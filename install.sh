#!/bin/bash
BINARY_URL="https://github.com/mvc-labs/mvc-mining-instruction/releases/download"
NODE_FILE="mvc.tar.gz"
MINER_FILE="cpuminer.tar.gz"
# SHELL_NAME="install.sh"
WORKINGSPACE_DIR=""
NODE_DATA_DIR="node_data_dir"
NET_CHOOSE=
VERSION_CHOOSE=
VERSION_LATEST="v0.1.1.0"
TEMP_DIR=
RPC_USERNAME=""
RPC_PASSWORD=""
dependencies_array=("build-essential" "libtool" "autotools-dev" "automake" "pkg-config" "libssl-dev" "libevent-dev" "bsdmainutils" "libboost-system-dev" "libboost-filesystem-dev" "libboost-chrono-dev" "libboost-program-options-dev" "libboost-test-dev" "libboost-thread-dev" "libdb-dev" "libdb++-dev" "libczmq-dev")
version_history=("v0.1.1.0")

ensure() {
    if ! "$@"; then err "command $*" "failed" ; fi
}

say() {
    printf '[%s] %s: %s\n' "$1" "$2" "$3"
}

err() {
    say "ERROR" "$1" "$2" >&2
    exit 1
}

warn() {
    say "WARNING" "$1" "$2" >&2
}

check_dir() {
    WORKINGSPACE_DIR=$(cd $(dirname $0); pwd)
    echo -e "Are you sure you want to install the mvc node to : \033[1;40;34m$WORKINGSPACE_DIR \033[0m \\n[y / n]"
    read -r   dir_checked
    case $dir_checked in
        [yY][eE][sS]|[yY])
            echo -e "You choose \"yes\". \nThe mvc node will be installed to : $WORKINGSPACE_DIR"
            ;;
        [nN][oO]|[nN])
            # echo -e "You choose \"no\". Run \n\033[1;40;34mmv $WORKINGSPACE_DIR/$SHELL_NAME [your working directory]\033[0m \nand rerun this script!"
            echo -e "You choose \"no\"."
            echo Installation quit!
            exit 0
            ;;
        *)
        echo "Invalid input..."
        exit 1
        ;;
    esac
}

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}

install_curl(){
    echo "Installing curl..."
    sudo apt install curl 2>/dev/null > log/install_curl.log
    if ! check_cmd curl; then
        err "install failed: " "curl"
    fi
}

install_gum(){
    echo "Installing gum..."
    ensure sudo mkdir -p /etc/apt/keyrings
    if [ ! -f "/etc/apt/keyrings/charm.gpg" ]; then
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    fi
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
    sudo apt update 2>/dev/null > log/apt_update.log
    sudo apt install gum 2>/dev/null > log/install_gum.log

    if ! check_cmd gum; then
        err "install failed: " "gum"
    fi
}

install_wget(){
    echo "Installing wget..."
    sudo apt install wget 2>/dev/null > log/install_wget.log
    if ! check_cmd curl; then
        err "install failed: " "wget"
    fi
}

install_tools(){
    echo "Checking for missing tools..."

    # install curl
    if ! check_cmd curl; then
        install_curl
    fi

    # install gum
    if ! check_cmd gum; then
        install_gum
    fi

    # install wget
    if ! check_cmd wget gum; then
        install_wget
    fi

    echo "Tools checked!"
}

pager_dependencies(){
    for((i=0;i<${#dependencies_array[@]};i++))
    do
        echo -e "${dependencies_array[$i]}\n"
    done
}

show_dependencies(){
    pager_dependencies | gum pager
}


install_dependency(){
    for((i=0;i<${#dependencies_array[@]};i++))
    do
        sudo gum spin --show-output --spinner globe --title "Installing ${dependencies_array[$i]}..." --title.foreground 99 -- sh -c "sudo apt-get install ${dependencies_array[$i]} > log/install_${dependencies_array[$i]}.log;sleep 1;echo '\033[32m✓\033[0m · ${dependencies_array[$i]}'"
    done

    echo -e "\033[32mAll dependencies installed!\033[0m"
}


install_dependencies() {
    echo "Install dependencies..."
    continue_install=$(gum choose "continue" "show dependencies" "quit")

    case $continue_install in
        "continue")
            install_dependency
            ;;
        "show dependencies")
            show_dependencies
            install_dependencies
            ;;
        "quit")
            echo "Installation quit!"
            exit 0
            ;;
        *)
    esac
}

pager_version(){
    echo "latest"
    for((i=0;i<${#version_history[@]};i++))
    do
        echo -e "${version_history[$i]}\n"
    done
}

node_version_choose(){
    VERSION_CHOOSE=$(pager_version | gum filter  --placeholder "Select version or innput to filter, default = latest")

    if [ -z $VERSION_CHOOSE ]; then
        gum confirm "Invalid version, choose again?" --affirmative "Okay" --negative "Quit"
            if [ $? == 1 ];then
                echo "Installation quit!"
                exit 0
            fi
            node_version_choose
    fi

    if [ "$VERSION_CHOOSE" == "latest" ]; then
        VERSION_CHOOSE=$VERSION_LATEST
    fi
}

node_net_choose() {
    echo "Please select the net you want to install!"
    NET_CHOOSE=$(gum choose Mainnet Testnet)

    case $NET_CHOOSE in
        "Mainnet")
            # gum confirm "Mainnet is coming soon! Do you want to try Testnet?" --affirmative "Okay" --negative "Cancel"
            # if [ $? == 1 ];then
            #     echo "Installation quit!"
            #     exit 0
            # fi
            NET_CHOOSE=""
            ;;
        "Testnet")
            NET_CHOOSE="testnet=1"
            ;;
        *)
    esac
}

confirm_install(){
    gum confirm --default=false  --affirmative "Think again"  --negative "Confirm" --timeout=5s  "Confirm to install!"
    if [ $? == 0 ]; then
        echo "Installation quit!"
        exit 0
    fi
}

create_dirs(){
    TEMP_DIR=temp-$(date +%s%N)
    echo "Creating node_data_dir..."
    ensure mkdir -p $WORKINGSPACE_DIR/$NODE_DATA_DIR
    echo "DOWN!"
    echo "Creating tmp_file_dir..."
    ensure mkdir -p $WORKINGSPACE_DIR/$TEMP_DIR
    echo "DOWN!"
}

download_files(){
    sudo gum spin --show-output --spinner globe --title "Downloading node file..." --title.foreground 99 -- sh -c "wget -O $WORKINGSPACE_DIR/$TEMP_DIR/$NODE_FILE -q ${BINARY_URL}/${VERSION_CHOOSE}/${NODE_FILE}"
    echo "Node file downloaded!"
    sudo gum spin --spinner globe --title "Extracting node file..." --title.foreground 99 -- sh -c "tar zxvf $WORKINGSPACE_DIR/$TEMP_DIR/$NODE_FILE -C $WORKINGSPACE_DIR"
    echo "Node file extracted!"
    sudo gum spin --show-output --spinner globe --title "Downloading miner file..." --title.foreground 99 -- sh -c "wget -O $WORKINGSPACE_DIR/$TEMP_DIR/$MINER_FILE  -q ${BINARY_URL}/${VERSION_CHOOSE}/${MINER_FILE}"
    echo "Miner file downloaded!"
    sudo gum spin --spinner globe --title "Extracting miner file..." --title.foreground 99 -- sh -c "tar zxvf $WORKINGSPACE_DIR/$TEMP_DIR/$MINER_FILE -C $WORKINGSPACE_DIR"
    echo "Miner file extracted!"
    echo hello
}

create_conf(){
    echo "Creating configuration file..."

    while [ "$RPC_USERNAME" == "" ]
    do
        RPC_USERNAME=$(gum input --prompt "Please input RPC user's name: " --placeholder "This cannot be left blank!" --prompt.foreground 99 --cursor.foreground 99 --width 50)
    done

    while [ "$RPC_PASSWORD" == "" ]
    do
        RPC_PASSWORD=$(gum input --password --prompt "Please input RPC user's password: " --placeholder "SHH~~~~!This cannot be left blank neither!" --prompt.foreground 99 --cursor.foreground 99 --width 50)

    done

cat > $WORKINGSPACE_DIR/mvc.conf << EOF
##
## mvcd.conf configuration file. Lines beginning with # are comments.
##

#start in background
daemon=1

$NET_CHOOSE

#Required Consensus Rules for Genesis
excessiveblocksize=10000000000 #10GB
maxstackmemoryusageconsensus=100000000 #100MB

#Mining
#biggest block size you want to mine
blockmaxsize=4000000000 
blockassembler=journaling

#preload mempool
preload=1

# Index all transactions, prune mode don&t support txindex
txindex=1
reindex=1
reindex-chainstate=1

#Other Sys, ws add
maxmempool=6000
dbcache=1000 

#Other Block, ws add
threadsperblock=6
#prune=196000

#Other Tx Conf:
maxscriptsizepolicy=0
blockmintxfee=0.00000250

# Connect via a SOCKS5 proxy
#proxy=127.0.0.1:9050

# Bind to given address and always listen on it. Use [host]:port notation for IPv6
#bind=<addr>

# Bind to given address and whitelist peers connecting to it. Use [host]:port notation for IPv6
#whitebind=<addr>

##############################################################
##            Quick Primer on addnode vs connect            ##
##  Let's say for instance you use addnode=4.2.2.4          ##
##  addnode will connect you to and tell you about the      ##
##    nodes connected to 4.2.2.4.  In addition it will tell ##
##    the other nodes connected to it that you exist so     ##
##    they can connect to you.                              ##
##  connect will not do the above when you 'connect' to it. ##
##    It will *only* connect you to 4.2.2.4 and no one else.##
##                                                          ##
##  So if you're behind a firewall, or have other problems  ##
##  finding nodes, add some using 'addnode'.                ##
##                                                          ##
##  If you want to stay private, use 'connect' to only      ##
##  connect to "trusted" nodes.                             ##
##                                                          ##
##  If you run multiple nodes on a LAN, there's no need for ##
##  all of them to open lots of connections.  Instead       ##
##  'connect' them all to one node that is port forwarded   ##
##  and has lots of connections.                            ##
##       Thanks goes to [Noodle] on Freenode.               ##
##############################################################

# Use as many addnode= settings as you like to connect to specific peers
# addnode=

# Alternatively use as many connect= settings as you like to connect ONLY to specific peers
#connect=

# Listening mode, enabled by default except when 'connect' is being used
#listen=1

# Maximum number of inbound+outbound connections.
maxconnections=12

#
# JSON-RPC options (for controlling a running Bitcoin/bitcoind process)
#

# server=1 tells bitcoind to accept JSON-RPC commands
server=1

# Bind to given address to listen for JSON-RPC connections. Use [host]:port notation for IPv6.
# This option can be specified multiple times (default: bind to all interfaces)
rpcbind=0.0.0.0

# If no rpcpassword is set, rpc cookie auth is sought. The default \`-rpccookiefile\` name
# is .cookie and found in the \`-datadir\` being used for bitcoind. This option is typically used
# when the server and client are run as the same user.
#
# If not, you must set rpcuser and rpcpassword to secure the JSON-RPC api. The first
# method(DEPRECATED) is to set this pair for the server and client:
rpcuser=$RPC_USERNAME

rpcpassword=$RPC_PASSWORD

# How many seconds mvc will wait for a complete RPC HTTP request.
# after the HTTP connection is established. 
#rpcclienttimeout=30

# By default, only RPC connections from localhost are allowed.
# Specify as many rpcallowip= settings as you like to allow connections from other hosts,
# either as a single IPv4/IPv6 or with a subnet specification.

# NOTE: opening up the RPC port to hosts outside your local trusted network is NOT RECOMMENDED,
# because the rpcpassword is transmitted over the network unencrypted.

# server=1 is read by mvcd to determine if RPC should be enabled 
rpcallowip=0.0.0.0/0

# Listen for RPC connections on this TCP port:
rpcport=9882

chaininitparam=MTM2NTAwMDAwMDAwMDAwMDoyNTAwMDAwMDAwOjE0NzAwMDpmYmI0Zjk3MTYyZTAyZDNiZTJjODYwYzdmNGRmNWQ4NjAwMzBiMDdmOjEw 

EOF
}

create_scripts(){
    echo "Creating cli scripts!"
    local script_help="Script                    ,Usage                                    \n"

    ensure mkdir -p $WORKINGSPACE_DIR/cli

    cat > $WORKINGSPACE_DIR/cli/run.sh << EOF
# start mvc node
#!/bin/bash
$WORKINGSPACE_DIR/bin/mvcd -conf=$WORKINGSPACE_DIR/mvc.conf -datadir=$WORKINGSPACE_DIR/$NODE_DATA_DIR
EOF
    sudo chmod +x $WORKINGSPACE_DIR/cli/run.sh

    script_help=$script_help"./cli/run.sh,start mvc node\n"

    cat > $WORKINGSPACE_DIR/cli/stop.sh << EOF
# stop mvc node
#!/bin/bash
$WORKINGSPACE_DIR/bin/mvc-cli -conf=$WORKINGSPACE_DIR/mvc.conf stop
EOF

    sudo chmod +x $WORKINGSPACE_DIR/cli/stop.sh

    script_help=$script_help"./cli/stop.sh,stop mvc node\n"


    cat > $WORKINGSPACE_DIR/cli/getinfo.sh << EOF
# get running info of node
#!/bin/bash
$WORKINGSPACE_DIR/bin/mvc-cli -conf=$WORKINGSPACE_DIR/mvc.conf getinfo
EOF

    sudo chmod +x $WORKINGSPACE_DIR/cli/getinfo.sh
    
    script_help=$script_help"./cli/getinfo.sh,get running info of node\n"


   cat > $WORKINGSPACE_DIR/cli/getnewaddress.sh << EOF
# create a new address from the wallet
#!/bin/bash
$WORKINGSPACE_DIR/bin/mvc-cli -conf=$WORKINGSPACE_DIR/mvc.conf getnewaddress
EOF

    sudo chmod +x $WORKINGSPACE_DIR/cli/getnewaddress.sh

    script_help=$script_help"./cli/getnewaddress.sh,create a new address from the wallet\n"


   cat > $WORKINGSPACE_DIR/cli/mine.sh << EOF
# start mining
#!/bin/bash

main(){
    if [ \$# -eq 0 ] || [ \$# -gt 1 ] ;
    then
        echo "miss coinbase address, try ./cli/mine.sh <your address>"
        exit 0
    fi

    $WORKINGSPACE_DIR/minerd  -a sha256d -o 127.0.0.1:9882 -O $RPC_USERNAME:$RPC_PASSWORD --coinbase-addr="\$1"
}


main "\$@" || exit 1
EOF

    sudo chmod +x $WORKINGSPACE_DIR/cli/mine.sh

    script_help=$script_help"./cli/mine.sh,start mining\n"

    echo -e "$script_help" | gum table > /dev/null
}


end_install(){
    sudo gum spin --show-output --spinner globe --title "Cleaning temp dir..." --title.foreground 99 -- sh -c "sleep 3; sudo rm -rf $WORKINGSPACE_DIR/$TEMP_DIR"
    
    gum style --foreground 99 --border double --border-foreground 99 --padding "1 2" --margin 1 "End of Installation, now enjoy!"
}

main(){
    check_dir
    echo "Creating log directory..."
    ensure mkdir -p $WORKINGSPACE_DIR/log
    echo "Log directory created!"
    
    install_tools

    install_dependencies

    # node_net_choose
    NET_CHOOSE=

    node_version_choose

    confirm_install

    create_dirs

    download_files

    create_conf

    create_scripts

    end_install
}

main "$@" || exit 1