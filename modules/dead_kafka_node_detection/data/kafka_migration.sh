

#!/bin/bash



# Set variables

OLD_NODE=${HOSTNAME_OF_THE_FAILED_KAFKA_NODE}

NEW_NODE=${HOSTNAME_OF_THE_NEW_KAFKA_NODE}



# Stop Kafka service on the failed node

ssh $OLD_NODE sudo service kafka stop



# Remove the old Kafka node from the cluster

ssh $OLD_NODE sudo kafka-server-stop.sh

ssh $OLD_NODE sudo rm -rf /tmp/kafka-logs

ssh $OLD_NODE sudo rm -rf /var/lib/kafka



# Install Kafka on the new node

ssh $NEW_NODE sudo apt-get update

ssh $NEW_NODE sudo apt-get install kafka



# Configure the new Kafka node

ssh $NEW_NODE sudo sed -i 's/${OLD_NODE_HOSTNAME}/$OLD_NODE/' /etc/kafka/server.properties

ssh $NEW_NODE sudo chown -R kafka:kafka /var/log/kafka

ssh $NEW_NODE sudo chown -R kafka:kafka /var/lib/kafka



# Start Kafka service on the new node

ssh $NEW_NODE sudo service kafka start