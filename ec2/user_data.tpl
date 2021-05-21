#!/bin/bash
wget https://github.com/binance-chain/bsc/releases/download/v1.1.0-beta/geth_linux
chmod +x geth_linux
sudo mv geth_linux /usr/local/bin/geth

sudo apt install unzip -y
wget https://github.com/binance-chain/bsc/releases/download/v1.1.0-beta/testnet.zip
unzip testnet.zip && rm testnet.zip

mkdir /home/${ DEFAULT_USER }/bsc-node
mv -t /home/${ DEFAULT_USER }/bsc-node config.toml genesis.json
geth --datadir /home/${ DEFAULT_USER }/bsc-node init /home/${ DEFAULT_USER }/bsc-node/genesis.json

mkdir /home/${ DEFAULT_USER }/script/
echo -e '#!/bin/bash' >> /home/${ DEFAULT_USER }/script/bsc.sh
echo -e 'geth --config /home/${ DEFAULT_USER }/bsc-node/config.toml --datadir /home/${ DEFAULT_USER }/bsc-node --cache 18000 --txlookuplimit 0 --ws --ws.api eth' >>  /home/${ DEFAULT_USER }/script/bsc.sh
chmod +x /home/${ DEFAULT_USER }/script/bsc.sh

sudo chown -R ${ DEFAULT_USER }:${ DEFAULT_USER } /home/${ DEFAULT_USER }/bsc-node/ /home/${ DEFAULT_USER }/script/

cat <<EOT >> /etc/systemd/system/bsc.service
[Unit]
Description=BSC daemon
After=network-online.target

[Service]
User=${ DEFAULT_USER }
ExecStart=/bin/bash /home/${ DEFAULT_USER }/script/bsc.sh
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable bsc.service
systemctl start bsc.service