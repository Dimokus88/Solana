#!/bin/bash
# By Dimokus (https://t.me/Dimokus)
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${my_root_password}; echo ${my_root_password}) | passwd root && service ssh restart
sleep 5
runsvdir -P /etc/service &

sh -c "$(curl -sSfL https://release.solana.com/v1.14.4/install)"
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
sleep 5

solana --version
sleep 5
mkdir /root/solana
cd /root/solana/
solana-keygen new -o /root/solana/validator_keypair.json --no-bip39-passphrase

cat /root/solana/validator_keypair.json

sleep infinity
