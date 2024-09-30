#!/bin/bash

rm story_upd*

systemctl stop story-testnet

wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.10.1-57567e5.tar.gz
chmod +x /usr/local/bin/story
rm /usr/local/bin/story
tar -xzf story-linux-amd64-0.10.1-57567e5.tar.gz
mv story-linux-amd64-0.10.1-57567e5/story /usr/local/bin/
chmod +x /usr/local/bin/story
rm -rf story-linux-amd64-0.10.1-57567e5*

rm story_upd*

systemctl restart story-testnet-geth story-testnet
journalctl -fu story-testnet
