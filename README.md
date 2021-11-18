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