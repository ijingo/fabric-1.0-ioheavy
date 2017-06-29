# IOHeavy workload for Hyperledger Fabric v1.0-RC1

## Contents

`chaincode` folder contains the IOheavy chaincode using the latest version Chaincode StubAPI.

`network` folder contains keyfiles which are gotten directly from the Fabric example https://github.com/hyperledger/fabric-samples/tree/master/fabcar

`run-peer.sh` & `run-orderer.sh` set some system environment variables before start the `peer` and `orderer` executable binary

`create_channel.sh`, `join_channel.sh`, `install_chaincode.sh`, `instantiate_chaincode.sh` are scripts to instantiate the chaincode.

`invoke.js` is the chaincode driver which issues transactions using Fabric Node.js SDK, `invoke.sh` is a script to launch the driver and set some parameters such as how many key/value pairs are going to write/scan.

## Running steps

### Step 1: Compile Fabric v1.0-RC1

Download source code from https://github.com/hyperledger/fabric/releases and choose the v1.0.0-rc1 tag.
Or use source code with UStore support from https://github.com/ijingo/fabric/ under the `1.0-rc1-ustore` 
branch.

**Put the source code under `$GOPATH`, such as `$GOPATH/src/github.com/hyperledger/fabric/`**

Under the project root path (`$GOPATH/src/github.com/hyperledger/fabric`), use `make peer` and `make orderer`.
This will download base docker images and generate binaries into the `$GOPATH/src/github.com/hyperledger/fabric/build/bin/` directory.

### Step 2: Setup a test network

1. Copy all the things from this repository into the `$GOPATH/src/github.com/hyperledger/fabric/build/bin` directory.

2. Add 
```
127.0.0.1 orderer.example.com
127.0.0.1 peer0.example.com
127.0.0.1 peer1.example.com
```
into `/etc/hosts`

3. Edit the path prefix of the line `export CORE_PEER_MSPCONFIGPATH=/data/wangji/gowork/src/github.com/hyperledger/fabric/build/bin/network/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp` in `run-peer.sh` accordingly, and change the line `export CORE_PEER_FILESYSTEMPATH=/data/wangji/tmp/hyperledger/production` to make it point to the desired folder to hold the ledger data.

Use `export CORE_LEDGER_STATE_STATEDATABASE=goleveldb` in the `run-peer.sh` to enable goleveldb as the storage.

Also, edit the path prefix of the line `export ORDERER_GENERAL_GENESISFILE=/data/wangji/gowork/src/github.com/hyperledger/fabric/build/bin/network/genesis.block` and `export ORDERER_GENERAL_LOCALMSPDIR=/data/wangji/gowork/src/github.com/hyperledger/fabric/build/bin/network/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp` in `run-orderer.sh` accordingly, also make `export ORDERER_FILELEDGER_LOCATION=/data/wangji/tmp/hyperledger/production/orderer` point to the storage location.

This step is to set the `peer` and `orderer` using the private keys in the `network/crypto-config` folder, and also set the data storage path of the ledger data when using `goleveldb` as the storage.

4. Run `run-orderer.sh` to launch an `orderer` and run `run-peer.sh` to launch a `peer`.

5. Change the `CORE_PEER_MSPCONFIGPATH` environment variable in the `*_channel.sh` and `*_chaincode.sh` as well. Change the `mychannel.tx` file path in the `create_channel.sh` file  (last line in this file). Then run
`create_channel.sh`, `join_channel.sh` sequentially.

### Step 3: Install chaincode

Create a folder under `$GOPATH/src/github.com/` named `ioheavy`, copy `chaincode/ioheavy.go` file into `$GOPATH/src/github.com/ioheavy` folder. Run `install_chaincode.sh` and `instantiate_chaincode.sh` to instantiate a chaincode instance.

Note: in version 1.0, the chaincode is no need to be downloaded from Github.

### Step 4: Launch workload driver

Use `node invoke.js start_key value_num` to issue **one** write or scan transaction. Change the `fcn` field at line  https://github.com/ijingo/fabric-1.0-ioheavy/blob/master/invoke.js#L53 with `write` to issue write transaction or `scan` to issue scan transaction. The transaction will actually insert new key/value pairs or scan old key/value pairs. The parameter `start_key` is to set the starting key of write/scan, `value_num` is to set how many operations to be done. For example, with `start_key=100` and `value_num=10`, the driver will insert/scan key/value pairs with key `00000000000000000100`, `00000000000000000101`, ..., `00000000000000000109`.

The node.js driver will automatically registers an event to wait until the transaction finish.

`invoke.sh` is a simple helper script to launch `node invoke.js x y` multiple times.

## Run with UStore

1. Build ustore go library using pull request 128 https://github.com/nusdbsystem/USTORE/pull/128 . It will 
automatically install ustore under `$GOPATH/src/ustore`

2. Build Hyperledger Fabric with UStore version which can be gotten from https://github.com/ijingo/fabric/ under the `1.0-rc1-ustore` branch.

3. Copy a ustore `conf` folder into the fabric binary folder (or which the path the binary is run in).

4. Use `export CORE_LEDGER_STATE_STATEDATABASE=UStore` (`UStore` case sensitive) in the `run-peer.sh` to enable UStore as the storage (which is exact the same with the code in this repository but not default by Hyperledger Fabric).

5. Do the same Step 2-4 in the last section.

## Test Environment

* ciidaa-a19 machine
* node.js == v6.11.0
* go == 1.8.3
* cmake == 3.8.2
* Docker version 17.03.2-ce, build f5ec1e2
