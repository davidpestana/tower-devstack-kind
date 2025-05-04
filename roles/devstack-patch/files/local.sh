#!/bin/bash
function write_user_unit_file {
    local service=$1
    local command=$2
    local group=$3
    local user=$4
    local env_vars=$5
    local extra=$6
    local unitfile=/etc/systemd/system/$service

    sudo mkdir -p /etc/systemd/system
    sudo tee $unitfile > /dev/null <<EOF
[Unit]
Description=Devstack $service
After=network.target

[Service]
Type=simple
ExecStart=$command
User=$user
Environment="PATH=$PATH"
Restart=on-failure
KillMode=process
TimeoutStopSec=300
LimitNOFILE=65536
ExecReload=/usr/bin/kill -HUP \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
}
