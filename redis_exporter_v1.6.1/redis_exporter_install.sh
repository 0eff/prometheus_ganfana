# install redis_exporter
#

##prometheus.yml
#- job_name: 'redis_cluster'
#  static_configs:
#    - targets:
#      - redis://192.168.111.11:7000
#      - redis://192.168.111.11:7001
#      - redis://192.168.111.11:7002
#      - redis://192.168.111.11:7003
#      - redis://192.168.111.11:7004
#      - redis://192.168.111.11:7005
#  metrics_path: /scrape
#  relabel_configs:
#    - source_labels: [__address__]
#      target_label: __param_target
#    - source_labels: [__param_target]
#      target_label: instance
#    - target_label: __address__
#      replacement: 192.168.111.11:9121

cd /usr/local/ && wget https://raw.githubusercontent.com/0eff/prometheus_grafana/master/redis_exporter_v1.6.1/redis_exporter-v1.6.1.linux-amd64.tar.gz
tar xf redis_exporter-v1.6.1.linux-amd64.tar.gz && mv redis_exporter-v1.6.1.linux-amd64 redis_exporter
cat <<EOF  > /lib/systemd/system/redis_exporter.service
[Unit]
Description=redis exporter server
After=network.target

[Service]
ExecStart=/usr/local/redis_exporter/redis_exporter -redis.addr 127.0.0.1:37693   -redis.password vb4mV$zeKw(dw4
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
