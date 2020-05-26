# install mysqld_exporter

# GRANT SELECT, PROCESS, SUPER, REPLICATION CLIENT, RELOAD ON *.* TO "pmm"@"%" IDENTIFIED BY "Pmm@_123_PSQA1";
# cat /usr/local/mysqld_exporter/t.cnf
# [client]
# user=pmm
# password=Pmm@_123
# host=172.19.0.30
# port=3306

cd /usr/local/ && wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz && tar xf mysqld_exporter-0.12.1.linux-amd64.tar.gz && mv mysqld_exporter-0.12.1.linux-amd64 mysqld_exporter
cat <<EOF  > /lib/systemd/system/mysqld_exporter.service
[Unit]
Description=mysqld exporter server
After=network.target

[Service]
ExecStart=/usr/local/mysqld_exporter/mysqld_exporter --config.my-cnf=/usr/local/mysqld_exporter/t.cnf --collect.auto_increment.columns --collect.binlog_size --collect.global_status --collect.global_variables --collect.info_schema.innodb_metrics --collect.info_schema.innodb_cmp --collect.info_schema.innodb_cmpmem --collect.info_schema.processlist --collect.info_schema.query_response_time --collect.info_schema.tables --collect.info_schema.tablestats --collect.info_schema.userstats --collect.perf_schema.eventswaits --collect.perf_schema.file_events --collect.perf_schema.indexiowaits --collect.perf_schema.tableiowaits --collect.perf_schema.tablelocks --collect.slave_status
KillMode=process
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
Alias=mysqld_exporter.service
EOF

systemctl daemon-reload
systemctl enable mysqld_exporter
systemctl start mysqld_exporter
systemctl status mysqld_exporter
