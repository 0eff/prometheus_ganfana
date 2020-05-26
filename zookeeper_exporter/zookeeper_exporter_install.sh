# install redis_exporter
#

##prometheus.yml
#scrape_configs:
# - job_name: 'kafka'
#   static_configs:
#    - targets:
#        - 'server1:9309'
#        - 'server1:9308'
#        - 'server2:7071'

##start
#kafka_exporter --kafka.server=server1:9309 \
# --kafka.server=server2:9308 \
# --kafka.server=server3:7071 \
# --sasl.enabled \
# --sasl.username=username \
# --sasl.password=”password“” \
# --web.listen-address=9309


#--sasl.handshake \
#--tls.insecure-skip-tls-verify \
#--tls.enabled


###kafka export grafana
#custom
#/usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server 172.19.0.30:9092,172.19.0.33:9092,172.19.0.43:9092 --topic test --consumer.config /usr/local/kafka/config/consumer.properties

cd /usr/local/ && wget https://github.com/danielqsj/kafka_exporter/releases/download/v1.2.0/kafka_exporter-1.2.0.linux-amd64.tar.gz
tar xf kafka_exporter-1.2.0.linux-amd64.tar.gz && mv kafka_exporter-1.2.0.linux-amd64 kafka_exporter
cat <<EOF  > /lib/systemd/system/kafka_exporter.service
[Unit]
Description=kafka exporter server
After=network.target

[Service]
ExecStart=/usr/local/kafka_exporter/kafka_exporter --kafka.server=192.168.99.238:9092 --kafka.server=192.168.99.239:9092 --kafka.server=192.168.99.240:9092
KillMode=process
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
Alias=kafka_exporter.service
EOF

systemctl daemon-reload
systemctl enable kafka_exporter
systemctl start kafka_exporter
systemctl status kafka_exporter
