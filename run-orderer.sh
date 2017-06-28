export ORDERER_GENERAL_LOGLEVEL=debug
export ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
export ORDERER_GENERAL_GENESISMETHOD=file
export ORDERER_GENERAL_GENESISFILE=/home/jingo/gowork/src/github.com/hyperledger/fabric/build/bin/network/genesis.block
export ORDERER_GENERAL_LOCALMSPID=OrdererMSP
export ORDERER_GENERAL_LOCALMSPDIR=/home/jingo/gowork/src/github.com/hyperledger/fabric/build/bin/network/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp
export ORDERER_FILELEDGER_LOCATION=/tmp/hyperledger/production/orderer

./orderer

