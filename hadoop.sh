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

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && tar xvzf hadoop-3.3.1.tar.gz && mv hadoop-3.3.1 hadoop && rm hadoop-3.3.1.tar.gz

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\nexport HDFS_NAMENODE_USER=\"hadoop\"\nexport HDFS_DATANODE_USER=\"hadoop\"\nexport HDFS_SECONDARYNAMENODE_USER=\"hadoop\"\nexport YARN_RESOURCEMANAGER_USER=\"hadoop\"\nexport YARN_NODEMANAGER_USER=\"hadoop\"\nexport HADOOP_HOME=/home/hadoop/hadoop" > ./hadoop/etc/hadoop/hadoop-env.sh
source ./hadoop/etc/hadoop/hadoop-env.sh
sudo mkdir -p /usr/local/hadoop/hdfs/data
sudo chown -R hadoop:hadoop /usr/local/hadoop/hdfs/data

echo "$namenodeip" > ./hadoop/etc/hadoop/conf/masters
for i in ${datanode[*]}
do
    echo "$i" >> ./hadoop/etc/hadoop/conf/workers
done

echo "<configuration><property><name>fs.default.name</name><value>hdfs://$namenodeip:9000/</value></property></configuration>" > ./hadoop/etc/hadoop/conf/core-site.xml
echo "<configuration><property><name>dfs.replication</name><value>3</value></property><property><name>dfs.namenode.name.dir</name><value>file:///usr/local/hadoop/hdfs/data</value></property><property><name>dfs.secondary.http.address</name><value>$snamenodeip:50090</value></property></configuration>" > ./hadoop/etc/hadoop/conf/hdfs-site.xml
echo "<configuration><property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property><property><name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name><value>org.apache.hadoop.mapred.ShuffleHandler</value></property></configuration>" > ./hadoop/etc/hadoop/conf/yarn-site.xml
echo "<configuration><property><name>mapreduce.jobtracker.address</name><value>$namenodeip:54311</value></property><property><name>mapreduce.framework.name</name><value>yarn</value></property><property><name>yarn.nodemanager.vmem-check-enabled</name><value>false</value></property><property><name>yarn.app.mapreduce.am.env</name><value>HADOOP_MAPRED_HOME=\${HADOOP_HOME}</value></property><property><name>mapreduce.map.env</name><value>HADOOP_MAPRED_HOME=\${HADOOP_HOME}</value></property><property><name>mapreduce.reduce.env</name><value>HADOOP_MAPRED_HOME=\${HADOOP_HOME}</value></property></configuration>" > ./hadoop/etc/hadoop/conf/mapred-site.xml

echo "alias hadoop=\"~/hadoop/hadoop-3.1.4/bin/hadoop\"\nsource ~/hadoop/etc/hadoop/hadoop-env.sh" >> ~/.bashrc
source ~/.bashrc


echo "sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y install openjdk-8-jdk-headless\nwget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && tar xvzf hadoop-3.3.1.tar.gz && mv hadoop-3.3.1 hadoop && rm hadoop-3.3.1.tar.gz\n
echo \"export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\nexport HDFS_NAMENODE_USER=\"hadoop\"\nexport HDFS_DATANODE_USER=\"hadoop\"\nexport HDFS_SECONDARYNAMENODE_USER=\"hadoop\"\nexport YARN_RESOURCEMANAGER_USER=\"hadoop\"\nexport YARN_NODEMANAGER_USER=\"hadoop\"\nexport HADOOP_HOME=/home/hadoop/hadoop\" > ./hadoop/etc/hadoop/hadoop-env.sh\n
source ./hadoop/etc/hadoop/hadoop-env.sh\n
sudo mkdir -p /usr/local/hadoop/hdfs/data\n
sudo chown -R hadoop:hadoop /usr/local/hadoop/hdfs/data\n

echo \"$namenodeip\" > ./hadoop/etc/hadoop/conf/masters\n" > ./hadoop-worker.sh

for i in ${datanode[*]}
do
    echo "echo $i >> ./hadoop/etc/hadoop/conf/workers" >> ./hadoop-worker.sh
done
echo "echo \"<configuration><property><name>fs.default.name</name><value>hdfs://$namenodeip:9000/</value></property></configuration>\" > ./hadoop/etc/hadoop/conf/core-site.xml\n
echo \"<configuration><property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property><property><name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name><value>org.apache.hadoop.mapred.ShuffleHandler</value></property></configuration>\" > ./hadoop/etc/hadoop/conf/yarn-site.xml\n

echo \"alias hadoop=\"~/hadoop/hadoop-3.1.4/bin/hadoop\"\nsource ~/hadoop/etc/hadoop/hadoop-env.sh\" >> ~/.bashrc\n
source ~/.bashrc\n
"