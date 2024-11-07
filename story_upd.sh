#!/bin/bash

rm story_upd*

systemctl stop story-testnet story-testnet-geth

wget https://github.com/piplabs/story/releases/download/v0.12.1/story-linux-amd64
wget https://github.com/piplabs/story-geth/releases/download/v0.10.0/geth-linux-amd64

mv story-linux-amd64 /usr/local/bin/story
mv geth-linux-amd64 /usr/local/bin/geth

chmod +x /usr/local/bin/story
chmod +x /usr/local/bin/geth

rm $HOME/.story/story/config/addrbook.json
cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup
PEERS="2f372238bf86835e8ad68c0db12351833c40e8ad@story-testnet-rpc.itrocket.net:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@story-testnet.rpc.kjnodes.com:26656,25747524aca5e9c878bbde97a9854f24255fceb9@157.173.116.70:26656,960278d079a111b44c207dca7c2ffac640b477d1@44.223.234.211:26656,95937ce9971e81f61c3249f50404868bcedc77e7@148.251.8.22:27136,3f9ad4d8cab4cce46de2087e64d7be3252f391d1@65.108.6.41:15656,5e4f9ce2d20f2d3ef7f5c92796b1b954384cbfe1@34.234.176.168:26656,c82d2b5fe79e3159768a77f25eee4f22e3841f56@3.209.222.59:26656,359e4420e63db005d8e39c490ad1c1c329a68df3@3.222.216.118:26656,23dfb7ab0856a512e121c7f7fd815ec08e231ce1@152.53.102.226:26656,07ab4164e1d0ee17c565542856ac58981537156f@37.27.124.51:42656,aac5871efa351872789eef15c2da7a55a68abdad@88.218.226.79:26656,cbaa226e66502b6b032f5e648d4d754f26bf9ca6@65.109.84.22:47656,79711005feeea05488a6ab7ba91763e530e6e125@88.99.90.44:19656,db07ad11c18435aa91526637a66d0617a52b5ce2@65.108.10.58:17656,f4d96bf0dc67a05a48287ca2c821bc8e1d2b2023@63.35.134.129:26656,269caa385a94f551bd7550093c64d724680bcdeb@167.235.13.19:30656,88a48e1e46e4e30ff95defb91090137f97924748@176.9.149.220:36656,7a746cae8566c17dd4c6b45cff748a23e860a201@95.216.12.106:41656,be341c5258cdc88ab26d7483dcebee631ebbe961@202.61.250.9:26656,90dc15db5fd6280cce0cd56d76e829ba8a3e6ac5@138.201.8.241:23856,689cac47e79f4e0d735f07baadcb6c57b8bb93bc@176.9.102.253:21356,ebb34a499340b683829070c1a8f6c1d403842900@157.90.180.248:22956,d6262ed11a285ac6324ca26a431828ab6f453665@37.27.114.99:24556,8a1ed304ee0c040d4492bc905935031c1dcf7f21@168.119.66.119:25556,47a9f27aa83a45a0e77ed1c823c6dcafc4485e51@168.119.137.80:23856,e9c859b5905247eda272b11a11175b1052771ecf@116.202.169.185:23356,228f7343967e4b3903ec83e44fa2c4bbbafb3b02@162.55.92.79:24856,3fc516ce3f717dcba98ff5c284d4537764add8e4@162.55.98.31:23556,5f5ac7e85567515b7d0c0018a2631dcdc90fa8f5@176.9.48.61:25556,2f372238bf86835e8ad68c0db12351833c40e8ad@story-testnet-rpc.itrocket.net:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@story-testnet.rpc.kjnodes.com:26656,25747524aca5e9c878bbde97a9854f24255fceb9@157.173.116.70:26656,960278d079a111b44c207dca7c2ffac640b477d1@44.223.234.211:26656,95937ce9971e81f61c3249f50404868bcedc77e7@148.251.8.22:27136,3f9ad4d8cab4cce46de2087e64d7be3252f391d1@65.108.6.41:15656,5e4f9ce2d20f2d3ef7f5c92796b1b954384cbfe1@34.234.176.168:26656,c82d2b5fe79e3159768a77f25eee4f22e3841f56@3.209.222.59:26656,359e4420e63db005d8e39c490ad1c1c329a68df3@3.222.216.118:26656,23dfb7ab0856a512e121c7f7fd815ec08e231ce1@152.53.102.226:26656,07ab4164e1d0ee17c565542856ac58981537156f@37.27.124.51:42656,aac5871efa351872789eef15c2da7a55a68abdad@88.218.226.79:26656,cbaa226e66502b6b032f5e648d4d754f26bf9ca6@65.109.84.22:47656,79711005feeea05488a6ab7ba91763e530e6e125@88.99.90.44:19656,db07ad11c18435aa91526637a66d0617a52b5ce2@65.108.10.58:17656,f4d96bf0dc67a05a48287ca2c821bc8e1d2b2023@63.35.134.129:26656,269caa385a94f551bd7550093c64d724680bcdeb@167.235.13.19:30656,88a48e1e46e4e30ff95defb91090137f97924748@176.9.149.220:36656,7a746cae8566c17dd4c6b45cff748a23e860a201@95.216.12.106:41656,be341c5258cdc88ab26d7483dcebee631ebbe961@202.61.250.9:26656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.story/story/config/config.toml
wget -O $HOME/.story/story/config/addrbook.json https://server-3.itrocket.net/testnet/story/addrbook.json
rm -rf $HOME/.story/story/data
rm -rf $HOME/.story/geth/iliad/geth/chaindata
curl -L https://snapshots.kjnodes.com/story-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.story/story
curl -L https://snapshots.kjnodes.com/story-testnet/snapshot_latest_geth.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.story/geth
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

rm story_upd*

sudo systemctl enable story-testnet.service story-testnet-geth.service
sudo systemctl restart story-testnet.service story-testnet-geth.service
journalctl -fu story-testnet.service
