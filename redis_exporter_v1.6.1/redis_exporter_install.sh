# install redis_exporter
#

cd /usr/local/ && wget https://raw.githubusercontent.com/0eff/prometheus_grafana/master/redis_exporter_v1.6.1/redis_exporter-v1.6.1.linux-amd64.tar.gz
tar xf redis_exporter-v1.6.1.linux-amd64.tar.gz && mv redis_exporter-v1.6.1.linux-amd64 redis_exporter
cat <<EOF  > /lib/systemd/system/redis_exporter.service
[Unit]
Description=redis exporter server
After=network.target

[Service]
ExecStart=/usr/local/redis_exporter/redis_exporter
KillMode=process
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
Alias=redis_exporter.service
EOF

systemctl daemon-reload
systemctl enable redis_exporter
systemctl start redis_exporter
systemctl status redis_exporter
