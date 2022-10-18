#!/bin/bash
# By Dimokus (https://t.me/Dimokus)
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${my_root_password}; echo ${my_root_password}) | passwd root && service ssh restart
sleep 5
runsvdir -P /etc/service &

sh -c "$(curl -sSfL https://release.solana.com/v1.14.5/install)"
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
sleep 5
mkdir /root/solana
solana --version
sleep 5
wget -O /root/solana/sol.zip $LINK_KEYS_ZIP
cd /root/solana/
unzip sol.zip
ls

solana config set --url http://testnet.solana.com
sleep 5
solana config set --keypair /root/solana/validator-keypair.json
sleep 5
solana balance
sleep 5
echo =Run node...=
cd /
mkdir /root/sol
mkdir /root/sol/log

cat > /root/sol/run <<EOF 
#!/bin/bash
exec 2>&1
#!/bin/bash
export PATH="/root/.local/share/solana/install/active_release/bin:/root/.local/share/solana/install/active_release/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/root/go/bin"
export SOLANA_METRICS_CONFIG="host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"
exec solana-validator --expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY --entrypoint entrypoint.testnet.solana.com:8001 --entrypoint entrypoint2.testnet.solana.com:8001 --entrypoint entrypoint3.testnet.solana.com:8001 --rpc-port 8899 --dynamic-port-range 8000-8015 --identity /root/solana/validator-keypair.json --vote-account /root/solana/vote-account-keypair.json --ledger /root/sol/ledger --rocksdb-shred-compaction fifo --wal-recovery-mode skip_any_corrupted_record --no-os-network-limits-test --accounts-db-skip-shrink --no-port-check --log /root/solana/solana.log
EOF
chmod +x /root/sol/run
LOG=/var/log/sol

cat > /root/sol/log/run <<EOF 
#!/bin/bash
mkdir $LOG
exec svlogd -tt $LOG
EOF
chmod +x /root/sol/log/run
ln -s /root/sol /etc/service
sleep 5
tail -f /root/solana/solana.log
