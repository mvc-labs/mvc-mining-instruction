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

Before you use mvcpool.com, make sure you have read how mvcpool works, the following link explain how mvcpool calculate rewards and distribution methods.

https://github.com/mvc-labs/mvcpool-manual



## Steps
Register pool account

Mainnet: https://mvcpool.com/

Mainnet: https://console.mvcpool.com/

Testnet: https://console-testnet.mvcpool.com/

Register and login your account first, keep your password safe.

Go to this page , you can see your stratum url and username. 

https://console.mvcpool.com/#/connect

Run asicminer(SHA256d)

replace the following stratum url and userName, password is same as userName.

Configure your stratum url and userName, then start mining

password is the same as userName

## NiceHash Example

![WX20230416-003036@2x](https://user-images.githubusercontent.com/41569443/232234599-56bddd7c-56c6-4e76-b826-1d83de5351d7.png)


In the nicehash marketplace, make sure you are selecting SHA256AsicBoost algorithm. Click add new pool if you haven't added your pool before. add following configs to your new pool(Replace USERNAME and PASSWORD by your own from https://console.mvcpool.com/#/connect):

![WX20230416-003327@2x](https://user-images.githubusercontent.com/41569443/232234653-92bbf2e9-00e4-4273-a532-1fb0016d52ba.png)

<img width="616" alt="image" src="https://user-images.githubusercontent.com/41569443/232234690-60421041-8f04-4995-9176-408599e9d0a9.png">

After the configuration, you can TEST Pool to make sure your config is correct.

then you can mine mvc from nicehash.

![image](https://user-images.githubusercontent.com/41569443/232234758-2b9251db-ee7e-4b52-ad83-3d0a41cfb620.png)

In the marketplace, select the mvcpool.com you just created, and config your order price, limit, amount then start mining.

![image](https://user-images.githubusercontent.com/41569443/232234789-241e70c1-dcc7-4691-9b83-da948b966834.png)

If nicehash is connected with correct credentials, you can see your hashrate in both nicehash and mvcpool.com.

<img width="528" alt="image" src="https://user-images.githubusercontent.com/41569443/232234819-0083bc55-166c-44d8-855a-0f74509a9a36.png">

Some times when your order price is lower than market price, your order will be paused due to lack of priority, you can rise your price or just wait for the price to go down.

The pool is using pplns, which means you only get rewarded when the pool actually found a block, this could take hours to days depending on the pool's total hash, but don't worry, the reward of your every share will always be calculated and sent, this can take some time.

If the block is found, you can see your reward in the payout page: https://mvcpool.com/#/payout, just wait it to be mature(takes 100 confirmation), and then you can withdraw your asset out of wallet. https://mvcpool.com/#/wallet

<img width="1266" alt="image" src="https://user-images.githubusercontent.com/41569443/232235029-8a06fc41-396d-41f6-9085-2d1d2ab12acb.png">



# 2. Mining on your own node
## Operating System Environment
    Ubuntu 20.04 LTS
    Default ports: 9882  9883
It is highly recommended that you use the default ports and make sure that the ports is accessible!

## 2.1 Node upgrade
If you have deployed an earlier version of the node, you can upgrade as follows.

* Stop the node :

```
mvc-cli stop
```
* Bakup old version of the binary file


* Remove  old version of the binary file
```
cd /home/$USER/mvc

rm -rf bin

```
* Get the latest version of the binary file

    [v0.1.4.0](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.4.0/mvc.tar.gz)

* Unzip the node binary to user's directory
```
tar zxvf mvc.tar.gz -C /home/$USER/mvc
```

* Restart the node
```
/home/$USER/mvc/bin/mvcd -conf=/home/$USER/mvc/mvc.conf -data_dir=/home/$USER/node_data_dir
```


## 2.2 Automatic deployment

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

## 2.3 Manual deployment
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

`latest version`:    
                        [v0.1.4.0](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.4.0/mvc.tar.gz)


`earlier version`:   

[v0.1.3.1](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.3.1/mvc.tar.gz)

[v0.1.3.0](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.3.0/mvc.tar.gz)


[v0.1.2.0](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.2.0/mvc.tar.gz)


---
### mining program

[cpuminer](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.3.0/cpuminer.tar.gz)

---

### configuration file

[mvc.conf](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.4.0/mvc.conf)(for v0.1.4.0)

[mvc.conf](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.3.0/mvc.conf)(for v0.1.3.0)

[mvc.conf](https://github.com/mvc-labs/mvc-mining-instruction/releases/download/v0.1.2.0/mvc.conf)(for v0.1.2.0)

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
