echo "What is namenode ip address?"
read namenodeip
echo "What is secondary namenode ip address?"
read snamenodeip
echo "How many datanode ?"
read numOfDatanode
datanode=()
counter=0
while [ $counter -lt $numOfDatanode ]
do
    echo "What is datanode ip address?"
    read val
    datanode[$counter]=$val
    ((counter++))
done

sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y install openjdk-8-jdk-headless

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && tar xvzf hadoop-3.3.1.tar.gz && mv hadoop-3.3.1 hadoop

echo "
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HDFS_NAMENODE_USER=\"hadoop\"
export HDFS_DATANODE_USER=\"hadoop\"
export HDFS_SECONDARYNAMENODE_USER=\"hadoop\"
export YARN_RESOURCEMANAGER_USER=\"hadoop\"
export YARN_NODEMANAGER_USER=\"hadoop\"
export HADOOP_HOME=/home/hadoop/hadoop" > ./hadoop/etc/hadoop/hadoop-env.sh
source ./hadoop/etc/hadoop/hadoop-env.sh
sudo mkdir -p /usr/local/hadoop/hdfs/data
sudo chown -R hadoop:hadoop /usr/local/hadoop/hdfs/data

echo "$namenodeip" > ./hadoop/etc/hadoop/masters
rm ./hadoop/etc/hadoop/workers
mkdir ~/.ssh
for i in ${datanode[*]}
do
    echo "$i" >> ./hadoop/etc/hadoop/workers
    echo "Host $i
    HostName $i
    User hadoop
    IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
done

echo "<configuration><property><name>fs.default.name</name><value>hdfs://$namenodeip:9000/</value></property></configuration>" > ./hadoop/etc/hadoop/core-site.xml
echo "<configuration><property><name>dfs.replication</name><value>3</value></property><property><name>dfs.namenode.name.dir</name><value>file:///usr/local/hadoop/hdfs/data</value></property><property><name>dfs.secondary.http.address</name><value>$snamenodeip:50090</value></property></configuration>" > ./hadoop/etc/hadoop/hdfs-site.xml
echo "<configuration><property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property><property><name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name><value>org.apache.hadoop.mapred.ShuffleHandler</value></property></configuration>" > ./hadoop/etc/hadoop/yarn-site.xml
echo "<configuration><property><name>mapreduce.jobtracker.address</name><value>$namenodeip:54311</value></property><property><name>mapreduce.framework.name</name><value>yarn</value></property><property><name>yarn.nodemanager.vmem-check-enabled</name><value>false</value></property><property><name>yarn.app.mapreduce.am.env</name><value>HADOOP_MAPRED_HOME=\${HADOOP_HOME}</value></property><property><name>mapreduce.map.env</name><value>HADOOP_MAPRED_HOME=\${HADOOP_HOME}</value></property><property><name>mapreduce.reduce.env</name><value>HADOOP_MAPRED_HOME=\${HADOOP_HOME}</value></property></configuration>" > ./hadoop/etc/hadoop/mapred-site.xml

echo "source ~/hadoop/etc/hadoop/hadoop-env.sh" >> ~/.bashrc
source ~/.bashrc


echo "sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y install openjdk-8-jdk-headless
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && tar xvzf hadoop-3.3.1.tar.gz && mv hadoop-3.3.1 hadoop
echo \"export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HDFS_NAMENODE_USER=\"hadoop\"
export HDFS_DATANODE_USER=\"hadoop\"
export HDFS_SECONDARYNAMENODE_USER=\"hadoop\"
export YARN_RESOURCEMANAGER_USER=\"hadoop\"
export YARN_NODEMANAGER_USER=\"hadoop\"
export HADOOP_HOME=/home/hadoop/hadoop\" > ./hadoop/etc/hadoop/hadoop-env.sh
source ./hadoop/etc/hadoop/hadoop-env.sh
sudo mkdir -p /usr/local/hadoop/hdfs/data
sudo chown -R hadoop:hadoop /usr/local/hadoop/hdfs/data
echo \"<configuration><property><name>fs.default.name</name><value>hdfs://$namenodeip:9000/</value></property></configuration>\" > ./hadoop/etc/hadoop/core-site.xml
echo \"
<configuration>
<property><name>yarn.resourcemanager.hostname</name><value>$namenodeip</value></property>
<property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>
<property><name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name><value>org.apache.hadoop.mapred.ShuffleHandler</value></property></configuration>\" > ./hadoop/etc/hadoop/yarn-site.xml
echo \"source ~/hadoop/etc/hadoop/hadoop-env.sh\" >> ~/.bashrc
source ~/.bashrc
" >> ./hadoop-worker.sh
