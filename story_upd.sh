#!/bin/bash

rm story_upd*

systemctl stop story-testnet story-testnet-geth

wget https://github.com/piplabs/story/releases/download/v0.12.0/story-linux-amd64
wget https://github.com/piplabs/story-geth/releases/download/v0.10.0/geth-linux-amd64

mv story-linux-amd64 /usr/local/bin/story
mv geth-linux-amd64 /usr/local/bin/geth

chmod +x /usr/local/bin/story
chmod +x /usr/local/bin/geth

rm story_upd*

sudo systemctl enable story-testnet.service story-testnet-geth.service
sudo systemctl restart story-testnet.service story-testnet-geth.service
journalctl -fu story-testnet.service
