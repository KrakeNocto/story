# Апдейт + установка зависимостей
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y

# Ставим Go c удалением старой версии
GO_VERSION="1.22.3"
# Remove any existing Go installation
if [ -d "/usr/local/go" ]; then
    echo "Removing previous Go installation..."
    rm -rf /usr/local/go
fi
# Download the Go binary
echo "Downloading Go $GO_VERSION..."
wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
# Extract the archive
echo "Extracting Go $GO_VERSION..."
tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
# Clean up by removing the downloaded archive
echo "Cleaning up..."
rm go$GO_VERSION.linux-amd64.tar.gz
# Set up environment variables
echo "Setting up environment variables..."
if ! grep -q "/usr/local/go/bin" /etc/profile; then
    echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile
    echo "export PATH=\$PATH:\$HOME/go/bin" >> /etc/profile
fi
# Apply the changes to the current shell session
echo "Applying environment variables..."
source /etc/profile
# Verify the installation
echo "Verifying Go installation..."
go version

# Создаем переменную с моникером ноды
echo "Moniker:"
read -r MONIKER

min_am=10
max_am=64
PORT=$(shuf -i $min_am-$max_am -n 1)
echo $PORT

min=10
max=64
PORT_G=$(shuf -i $min-$max -n 1)
echo $PORT_G

# Нода очень похожа на Morph - космосовская нода, но состоит из двух частей - geth (go-ethereum) и story - сама нода.
# Geth обеспечивает связь с сетью ethereum, логов в ней особо нет. Все основные логи и прогресс по блокам идёт в Story.
# Скачиваем пакеты geth и story
cd && wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.11.0-aac4bfe.tar.gz
wget https://github.com/piplabs/story-geth/releases/download/v0.9.4/geth-linux-amd64

tar -xzf story-linux-amd64-0.11.0-aac4bfe.tar.gz
mv story-linux-amd64-0.11.0-aac4bfe/story /usr/local/bin/
mv geth-linux-amd64 version /usr/local/bin/geth

chmod +x /usr/local/bin/story
chmod +x /usr/local/bin/geth

# Инициализируем ноду
story init --moniker $MONIKER --network iliad --force=true

# Установка генезиса, адресбука и пиров
curl -Ls https://support.synergynodes.com/genesis/story_testnet/genesis.json > $HOME/.story/story/config/genesis.json
curl -Ls https://support.synergynodes.com/addrbook/story_testnet/addrbook.json > $HOME/.story/story/config/addrbook.json
# Add / Update Peers
PEERS=1708afbf73e2fbbb5a943aa2d97c976bf8e0d25c@52.9.183.131:26656,371ee318d105b0239b3997c287068ccbbcd46a91@3.248.113.42:26656,502768c5256728123626411bcd85a5633af5a1bc@95.217.193.182:46656,c82d2b5fe79e3159768a77f25eee4f22e3841f56@3.209.222.59:26656,8876a2351818d73c73d97dcf53333e6b7a58c114@3.225.157.207:26656,5e4f9ce2d20f2d3ef7f5c92796b1b954384cbfe1@34.234.176.168:26656,a2fe3dfd6396212e8b4210708e878de99307843c@54.209.160.71:26656,15c7e2b630c04ee11b2c3cfbfb1ede0379df9407@52.74.117.64:26656,f4d96bf0dc67a05a48287ca2c821bc8e1d2b2023@63.35.134.129:26656,2a77804d55ec9e05b411759c70bc29b5e9d0cce0@165.232.184.59:26656,6394a7913ffe2cf0e97cdaccc69760a420887ffe@150.136.92.197:26656,e0ef2e89930e3ff1a45660fa6cb21ceabeb18a1c@129.158.223.103:26656,b43b938fe2360c6364e230ac2aa46f5a8c1c03f7@129.153.150.8:26656,69d588eb98a6cefa51814ab218c8999222d4ca83@188.165.226.46:26766,e0b1bc6a5c9a24e2cf3d01f4957b54c0a819b2b1@148.71.209.79:26656,a15d9e52b1ac29daef23c62a33f3c3d26533d07b@213.239.207.162:26656,1cceccb08bae25a0f91fe85b0ca562fa791f47aa@184.169.154.204:26656,379606c5d249978f0d180a8b9e8350a680bf4e83@129.213.93.193:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.story/story/config/config.toml
sed -i.bak -e "s|^laddr = \"tcp://127.0.0.1:26657\"|laddr = \"tcp://127.0.0.1:2${PORT}57\"|" $HOME/.story/story/config/config.toml
sed -i.bak -e "s|^laddr = \"tcp://0.0.0.0:26656\"|laddr = \"tcp://0.0.0.0:2${PORT}56\"|" $HOME/.story/story/config/config.toml

#SNAPSHOT
cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup
rm -rf $HOME/.story/story/data
rm -rf $HOME/.story/geth/iliad/geth/chaindata
wget -O story_testnet_1517189.tar.lz4 https://support.synergynodes.com/snapshots/story_testnet_story/story_testnet_1539486.tar.lz4
wget -O story_testnet_geth_1539486.tar.lz4 https://support.synergynodes.com/snapshots/story_testnet_geth/story_testnet_geth_1539486.tar.lz4
lz4 -c -d story_testnet_1539486.tar.lz4 | tar -x -C $HOME/.story/story
lz4 -c -d story_testnet_geth_1539486.tar.lz4 | tar -x -C $HOME/.story/geth/iliad/geth
rm story_testnet_1539486.tar.lz4
mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

# Запуск сервиса geth
sudo tee /etc/systemd/system/story-testnet-geth.service > /dev/null << EOF
[Unit]
Description=Story Execution Client service
After=network-online.target

[Service]
User=root
WorkingDirectory=~
ExecStart=/usr/local/bin/geth --iliad --syncmode full --port ${PORT_G}303
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
# Запуск сервиса story
sudo tee /etc/systemd/system/story-testnet.service > /dev/null << EOF
[Unit]
Description=Story Consensus Client service
After=network-online.target

[Service]
User=root
WorkingDirectory=~
ExecStart=/usr/local/bin/story run
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable story-testnet-geth.service
sudo systemctl enable story-testnet.service
sudo systemctl start story-testnet-geth.service
sudo systemctl start story-testnet.service
