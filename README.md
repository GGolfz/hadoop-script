# Hadoop Script User Manual

## How to use ?

1) Download `hadoop.sh` into your master node.
2) Run `chmod +x hadoop.sh` to make it executable.
3) Run `./hadoop.sh` to start hadoop.
4) Enter namenode ip, secondary namenode ip, and datanode ip.
5) Wait for installation
6) It will generate `hadoop-worker.sh` in your current directory.
7) Copy `hadoop-worker.sh` to your worker nodes.
8) Run `chmod +x hadoop-worker.sh` to make it executable.
9) Run `./hadoop-worker.sh` to start installation.
10) Wait for installation
11) Configure SSH to connect to your worker nodes (generate and add to .ssh/authorized_keys).
12) Running Hadoop using `sudo ./hadoop/bin/hdfs namenode -format && ./hadoop/sbin/start-all.sh`

## Caution
1) Make sure that you have enough space on your node.
2) Make sure that current user is hadoop and has sudo permission.
3) You need to configure ssh by yourselve.