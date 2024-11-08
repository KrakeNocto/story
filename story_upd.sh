#!/bin/bash

rm story_upd*

systemctl stop story-testnet story-testnet-geth

rm story-linux*
rm geth-linux*

wget https://github.com/piplabs/story/releases/download/v0.12.1/story-linux-amd64
wget https://github.com/piplabs/story-geth/releases/download/v0.10.0/geth-linux-amd64

mv story-linux-amd64 /usr/local/bin/story
mv geth-linux-amd64 /usr/local/bin/geth

chmod +x /usr/local/bin/story
chmod +x /usr/local/bin/geth

rm $HOME/.story/story/config/addrbook.json
cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup
PEERS="c2a6cc9b3fa468624b2683b54790eb339db45cbf@story-testnet-peer.itrocket.net:26656,02e9fac0fab468724db00e5e3328b2cbca258fdc@95.217.193.182:26656,5c001659b68370e7198e9c6c72bfc4c3c15dba41@211.218.55.32:50656,e1245ea24138ff16ca144962f72146d6afcbfe15@221.148.45.118:26656,34400e930af9ff63a0c2c2d1b036a8763e7c92e1@158.220.126.24:52656,959ef7ebaaacd08de053e738707d3a2940f846a4@148.72.138.5:26656,5531e438ecd2e0b0d2700e68b2ba8066eb02d2d7@185.133.251.245:656,29d7d1d203ccf8c9afe593eab7bee485f1e6bbfa@37.252.186.234:26656,bf975933a1169221e3bd04164a7ba9abc5d164c8@3.16.175.31:26656,f0e8398215663070d0d65ea6478f61688228d9d9@3.146.164.199:26656,04e5734295da362f09a61dd0a9999449448a0e5c@52.14.39.177:26656,046909534c2849ff8dccc15ee43ee63d2c60b21c@54.190.123.194:26656,9e2fabda41e3c3317c25f5ef6c604c1d78370aba@50.112.252.101:26656,176325c2f78f146fb09bebc6c287f430654b448c@84.247.174.15:656,bd58bf29180f476bd250af22d6026559d7eff289@146.59.118.198:26656,0ae60326fa7f01500a94dd7f0d2571fbba46cd10@167.235.39.5:17656,8b241f57d1375205aa4a17d038f9825a516ccbc5@88.99.252.213:36656,df7f1d465b992eb8ff06b382b791d9db15666cbe@100.42.183.29:656,e8d2732e64d3dcedb3960cbed9aeb325e6ffec51@37.60.234.34:656,75ac7b193e93e928d6c83c273397517cb60603c0@3.142.16.95:26656,39ef8bba040a71d6914359ba0f6f8490f7716c35@45.61.156.53:26656,73aafbaefe85e64a3eb0c6e23b3935bc308d77db@142.132.135.125:20656,2e65e5de93cb19ee35b1e82af7f874043a1f5d83@185.133.251.252:656,17334e0738463a9eac3466147283bf0637208cdb@37.60.234.243:656,8ff41ff3354241f608ba15ccd224ff6fb7393dd7@135.181.60.149:26656,acbb5e639d2985f09886fc7da6c247d024ee54fc@100.42.183.224:656,356847ca14f13b9b38d13bfaf7751ae74cc2919b@65.21.210.147:26656,443896c7ec4c695234467da5e503c78fcd75c18e@80.241.215.215:26656,c7226f11d8f0b4bbbd6e78af219fd39c0efd46ea@84.247.181.213:656,e8317a671abf0af33eb712045f368ac5f335d690@2.56.246.4:18656,ec9b94601137488dd8631a26db501d123f35ffba@158.220.127.86:656"
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
