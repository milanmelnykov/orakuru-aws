#!/bin/bash
useradd --no-create-home --shell /usr/sbin/nologin prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.27.1/prometheus-2.27.1.linux-amd64.tar.gz
tar xvfz prometheus-2.27.1.linux-amd64.tar.gz
mv prometheus-2.27.1.linux-amd64 pm-dir

cp ./pm-dir/promtool /usr/local/bin/
cp ./pm-dir/prometheus /usr/local/bin/

cp -r ./pm-dir/consoles /etc/prometheus
cp -r ./pm-dir/console_libraries /etc/prometheus


chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

cat <<EOT >> /etc/prometheus/prometheus.yml
global:
    scrape_interval: 15s
    external_labels:
        monitor: 'orakuru-monitor'
scrape_configs:
    - job_name: 'orakuru'
      scrape_interval: 5s
      static_configs:
        - targets: ['${ EC2_ORK_PRIVATE_IP }:9000']
EOT

chown prometheus:prometheus /etc/prometheus/prometheus.yml

cat <<EOT >> /etc/systemd/system/prometheus.service
[Unit]
  Description=Prometheus Monitoring
  Wants=network-online.target
  After=network-online.target

[Service]
  User=prometheus
  Group=prometheus
  Type=simple
  ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
  WantedBy=multi-user.target
EOT

apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_7.5.7_amd64.deb
dpkg -i grafana_7.5.7_amd64.deb

systemctl daemon-reload

systemctl enable prometheus
systemctl start prometheus

systemctl enable grafana-server
systemctl start grafana-server