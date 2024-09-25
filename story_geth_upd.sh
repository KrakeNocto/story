#!/bin/bash

systemctl stop story-testnet-geth story-testnet

rm /usr/local/bin/geth
curl -sL https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.3-b224fdf.tar.gz | sudo tar -C /usr/local/bin -xzf- --strip-components=1 geth-linux-amd64-0.9.3-b224fdf/geth
chmod +x /usr/local/bin/geth

rm story_geth_upd.sh

sudo systemctl start story-testnet-geth
sudo systemctl start story-testnet
sudo journalctl -u story-testnet -f
