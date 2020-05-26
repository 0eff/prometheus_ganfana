# install zookeeper_exporter
#

##prometheus.yml
#scrape_configs:
# - job_name: 'zookeeper'
#   static_configs:
#    - targets:
#        - '192.168.99.240:9141'


#zoo.cfg
#4lw.commands.whitelist=*

cd /usr/local/ && wget https://github.com/dabealu/zookeeper-exporter/releases/download/v0.1.8/zookeeper-exporter-v0.1.8-linux.tar.gz
tar xf zookeeper-exporter-v0.1.8-linux.tar.gz && mv zookeeper-exporter-v0.1.8-linux zookeeper_exporter
cat <<EOF  > /lib/systemd/system/zookeeper_exporter.service
[Unit]
Description=zookeeper exporter server
After=network.target

[Service]
ExecStart=/usr/local/zookeeper_exporter/zookeeper-exporter -zk-host '192.168.99.239'
KillMode=process
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
Alias=kafka_exporter.service
EOF

systemctl daemon-reload
systemctl enable zookeeper_exporter
systemctl start zookeeper_exporter
systemctl status zookeeper_exporter
