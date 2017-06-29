export GOPATH=/data/wangji/gowork
export CORE_VM_ENDPOINT=unix:///var/run/docker.sock
export CORE_PEER_ID=peer0.org1.example.com
export CORE_LOGGING_PEER=debug
export CORE_CHAINCODE_LOGGING_LEVEL=DEBUG
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=/data/wangji/gowork/src/github.com/hyperledger/fabric/build/bin/network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
#export CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=network_default
export CORE_LEDGER_STATE_STATEDATABASE=goleveldb

./peer chaincode install -n ioheavy -v 1.0 -p github.com/ioheavy

