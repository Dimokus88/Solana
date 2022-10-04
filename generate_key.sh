#!/bin/bash
# By Dimokus (https://t.me/Dimokus)
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${my_root_password}; echo ${my_root_password}) | passwd root && service ssh restart
sleep 5
runsvdir -P /etc/service &

sh -c "$(curl -sSfL https://release.solana.com/v1.14.3/install)"

sleep 5

solana --version
sleep 5

sleep infinity
