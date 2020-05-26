# install mongodb_exporter

#

mkdir /usr/local/mongodb_exporter/ -p
cd /usr/local/mongodb_exporter/ && wget https://raw.githubusercontent.com/0eff/prometheus_grafana/master/mongodb_exporter_v0.11.0/mongodb_exporter
chmod +x /usr/local/mongodb_exporter/mongodb_exporter
cat <<EOF  > /lib/systemd/system/mongodb_exporter.service
[Unit]
Description=mongodb exporter server
After=network.target

[Service]
ExecStart=/usr/local/mongodb_exporter/mongodb_exporter --mongodb.uri=mongodb://mongodb_exporter:password_xxx_monitor_X1909@127.0.0.1:29017
KillMode=process
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
Alias=mongodb_exporter.service
EOF

systemctl daemon-reload
systemctl enable mongodb_exporter
systemctl start mongodb_exporter
systemctl status mongodb_exporter
