#!/bin/bash

systemctl stop story-testnet

wget http://116.202.116.35:33150/story
rm /usr/local/bin/story
mv story /usr/local/bin/

chmod +x /usr/local/bin/story

systemctl restart story-testnet-geth story-testnet
journalctl -fu story-testnet
