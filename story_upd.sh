#!/bin/bash

rm story_upd*

systemctl stop story-testnet story-testnet-geth

wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.11.0-aac4bfe.tar.gz
wget https://github.com/piplabs/story-geth/releases/download/v0.9.4/geth-linux-amd64

tar -xzf story-linux-amd64-0.11.0-aac4bfe.tar.gz
mv story-linux-amd64-0.11.0-aac4bfe/story /usr/local/bin/
mv geth-linux-amd64 version /usr/local/bin/geth

chmod +x /usr/local/bin/story
chmod +x /usr/local/bin/geth

rm story-linux-amd64-0.11.0-aac4bfe.tar.gz
rm -rf story-linux-amd64-0.11.0-aac4bfe

wget -O $HOME/.story/story/config/addrbook.json https://server-3.itrocket.net/testnet/story/addrbook.json

cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup
rm -rf $HOME/.story/story/data
rm -rf $HOME/.story/geth/iliad/geth/chaindata
curl -L https://snapshots.kjnodes.com/story-testnet/snapshot_latest_geth.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.story/geth
curl -L https://snapshots.kjnodes.com/story-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.story/story
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

rm story_upd*

sudo systemctl enable story-testnet.service story-testnet-geth.service
sudo systemctl restart story-testnet.service story-testnet-geth.service
journalctl -fu story-testnet.service
