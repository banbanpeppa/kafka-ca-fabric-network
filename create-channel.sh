#!/bin/sh

export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/network-config
CHANNEL_NAME=$1
if [ ! -n "$1" ]; then
  echo "Please input a channel name..."
  exit 1
fi
# create folders
mkdir -p config
mkdir -p crypto-config

# generate channel configuration transaction
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./config/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./config/${CHANNEL_NAME}Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./config/${CHANNEL_NAME}Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org2MSP..."
  exit 1
fi
