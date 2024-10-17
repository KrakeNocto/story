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

rm story_upd*

systemctl restart story-testnet-geth story-testnet
journalctl -fu story-testnet
