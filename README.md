# MVC MINING INSTRUCTION

 * Token Symbol : SPACE
 * Smallest Unit : SAT
 * Total Supply : 21,000,000 SPACEs
 * POW Proportion : 35% (aka 7,350,000 SPACEs)
 * Initial Reward : 25 SPACEs per block
 * Block Interval Time : 10 minites
 * Halving Period : 147,000 blocks(about 1000 days)
 * Mining Algorithm : SHA-256
 * Decimals : 8
 
# 1. Mining without running a node

You can use mvcpool.com to mine mvc directly without running a node.

## Steps
Register pool account

Mainnet: https://console.mvcpool.com/

Testnet: https://console-testnet.mvcpool.com/

Register and login your account first, keep your password safe.

Download cpuminer (ignore this step for asic)
Download CPU miner(ignore this if you already have asic miner) https://github.com/pooler/cpuminer/releases/tag/v2.5.1

Go to this page , you can see your stratum url and username. https://console.mvcpool.com/#/connect

Run CPU miner(or asic)
replace the following stratum url and userName, password is same as userName.

you can also change threads count according to your cpu cores.

```shell

./minerd -o stratum+tcp://mine.mvcpool.com:6666 -a sha256d -O userName:password -D -P --threads=4

```

Asic miner is also the same, configure your stratum url and userName, then start mining

password is the same as userName


# 2. Mining on your own node
## Operating System Environment
    Ubuntu 20.04 LTS
    Default ports: 9882  9883
It is highly recommended that you use the default ports and make sure that the ports is accessible!

## 2.1 Automatic deployment

This will automatically deploy the node and the mining program to your current path.

Run the following commands in your work path:

```
curl -fsSL https://github.com/mvc-labs/mvc-mining-instruction/raw/main/install.sh -o install.sh
```
```
sudo bash install.sh
```
if success， you will find 'cli' in your work path, in which you can run your node and start mining by run the corresponding script.
if it doesn't work, please try manual deployment.

## 2.2 Manual deployment
### STEP 1：Install dependencies 
```
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
```
```
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
```
```
sudo apt-get install libdb-dev
```
```
sudo apt-get install libdb++-dev
```
```
sudo apt-get install libczmq-dev
```


### STEP 2: Download the node binary, mining program, and node configuration file

---
### node

`latest version`: [v0.1.1.0](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.1.0/mvc.tar.gz)

`history version`: none

---
### mining program

[cpuminer](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.1.0/cpuminer.tar.gz)

---

### configuration file
[mvc.conf](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.1.0/mvc.conf)

### STEP3: Deploy the node and mining program
3.1 Unzip the node binary to user's directory
```
tar zxvf mvc.tar.gz -C /home/$USER/mvc
```
3.2 Unzip the mining program to user's directory
```
tar zxvf cpuminer.tar.gz -C /home/$USER/mine
```
3.3 Copy the configuration file to user's directory
```
cp mvc.conf /home/$USER/mvc
```
3.4 create the node data directory
```
mkdir -p  /home/$USER/node_data_dir
```
3.5 Modify the configuration file

find the following configuration items in mvc.conf and change them.
```
rpcuser=     (user name for the RPC accessing)
rpcpassword= (password for the RPC accessing)
```


### STEP 4: Start the node
```
/home/$USER/mvc/bin/mvcd -conf=/home/$USER/mvc/mvc.conf -data_dir=/home/$USER/node_data_dir
```
You shall see  "MVC SERVER STARTING".


![Banner](https://github.com/mvc-labs/mvc-mining-instruction/blob/main/start-image.jpeg)

### STEP 5: Start mining

5.1  alias cli command
```
alias mvc-cli="/home/$USER/mvc/bin/mvc-cli -conf=/home/$USER/mvc/mvc.conf"
```
5.2  Create a new address for mining
```
mvc-cli getnewaddress "mine"
```
5.3  Start mining
```
/home/$USER/mine/minerd -a sha256d -o 127.0.0.1:9882 -O user:password --coinbase-addr=addr
```

user:password is same as the configuration in mvc.conf

coinbase-addr:the new address in step5.2 or your own address