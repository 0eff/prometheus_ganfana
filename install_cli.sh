#! /bin/bash
#

# by jude

# install promethus client and the cpu and memory percent script for a single process

rm -f /usr/local/src/*_exporter*tar.gz
rm -rf /usr/local/*_exporter/

# install node_exporter

cd /usr/local/src/ && wget https://github.com/prometheus/node_exporter/releases/download/v1.0.0-rc.0/node_exporter-1.0.0-rc.0.linux-amd64.tar.gz
tar xf node_exporter-1.0.0-rc.0.linux-amd64.tar.gz -C /usr/local/ &&  cd  /usr/local/ && mv node_exporter-1.0.0-rc.0.linux-amd64 node_exporter
mkdir /usr/local/node_exporter/key/ -p
cd  /usr/local/node_exporter/key/ && wget https://raw.githubusercontent.com/0eff/prometheus_ganfana/master/ps.py
cat <<EOF  > /lib/systemd/system/node_exporter.service
[Unit]
Description=Prometheus client
After=network.target

[Service]
ExecStart=/usr/local/node_exporter/node_exporter --no-collector.softnet --collector.textfile.directory=/usr/local/node_exporter/key/
KillMode=process
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
Alias= node_exporter.service
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
systemctl status node_exporter

# install blackbox_exporter

cd /usr/local/src/ && wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.16.0/blackbox_exporter-0.16.0.linux-amd64.tar.gz
tar xf blackbox_exporter-0.16.0.linux-amd64.tar.gz -C /usr/local/ && mv blackbox_exporter-0.16.0.linux-amd64 blackbox_exporter
cat <<EOF  > /lib/systemd/system/blackbox_exporter.service
[Unit]
Description=blackbox_exporter
After=network.target

[Service]
User=root
Type=simple
ExecStart=/usr/local/blackbox_exporter/blackbox_exporter --config.file=/usr/local/blackbox_exporter/blackbox.yml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable blackbox_exporter
systemctl start blackbox_exporter
systemctl status blackbox_exporter


# crontab
yum install epel-release -y
yum install python-devel python2-pip.noarch -y
pip2 install psutil

if [[ ! `grep 'key.prom' /var/spool/cron/root`  ]] ; then
cat <<EOF  >> /var/spool/cron/root
* * * * * /usr/bin/python2 /usr/local/node_exporter/key/ps.py > /usr/local/node_exporter/key/txt && cat /usr/local/node_exporter/key/txt > /usr/local/node_exporter/key/key.prom
EOF
fi

systemctl restart crond
