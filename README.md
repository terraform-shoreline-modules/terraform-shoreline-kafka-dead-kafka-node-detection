
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Dead Kafka Node Detection
---

Dead Kafka Node Detection is an incident type that occurs when the Kafka cluster detects the absence of a node that has stopped sending heartbeat signals. Kafka uses heartbeats to monitor the status of each node in a cluster and to detect if they are available or not. When a node is down, it can cause issues with data replication and data consistency. Therefore, this incident requires immediate attention to restore the failed node and ensure the smooth functioning of the Kafka cluster.

### Parameters
```shell
export KAFKA_BOOTSTRAP_SERVER="PLACEHOLDER"

export ZOOKEEPER_SERVER="PLACEHOLDER"

export ZOOKEEPER_NODE="PLACEHOLDER"

export KAFKA_NODE="PLACEHOLDER"

export BROKER_ID="PLACEHOLDER"

export ZOOKEEPER_PORT="PLACEHOLDER"

export CONSUMER_GROUP="PLACEHOLDER"

export PATH_TO_LOGS_DIRECTORY="PLACEHOLDER"

export NODE_HOSTNAME_OR_IP_ADDRESS="PLACEHOLDER"

export USERNAME="PLACEHOLDER"
```

## Debug

### 1. Check the status of the Kafka cluster
```shell
systemctl status kafka.service
```

### 2. Check the Kafka logs for any error messages
```shell
journalctl -u kafka.service | grep ERROR
```

### 3. Verify that all Kafka nodes are up and running
```shell
kafka-topics.sh --list --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER}
```

### 4. Check the ZooKeeper logs for any error messages
```shell
journalctl -u zookeeper.service | grep ERROR
```

### 5. Verify that all ZooKeeper nodes are up and running
```shell
zkCli.sh -server ${ZOOKEEPER_SERVER} ls /brokers/ids
```

### 6. Check the network connectivity between Kafka and ZooKeeper nodes
```shell
ping ${KAFKA_NODE} 

ping ${ZOOKEEPER_NODE}
```

### 7. Verify that Kafka is able to connect to ZooKeeper
```shell
kafka-configs.sh --describe --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} --entity-type brokers --entity-name ${BROKER_ID}
```

### 8. Check the disk space on all Kafka nodes
```shell
df -h
```

### 9. Verify that the ZooKeeper ensemble is in quorum
```shell
echo stat | nc ${ZOOKEEPER_NODE} ${ZOOKEEPER_PORT} | grep Mode
```

### 10. Monitor the Kafka cluster for any unusual activity
```shell
kafka-consumer-groups.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVER} --group ${CONSUMER_GROUP} --describe
```

## Repair

### Check the logs of the failed node to identify the root cause of the failure.
```shell


#!/bin/bash



# Set the failed node hostname or IP address

FAILED_NODE=${NODE_HOSTNAME_OR_IP_ADDRESS}



# Set the path to the Kafka broker logs directory

LOGS_DIR=${PATH_TO_LOGS_DIRECTORY}



# Log in to the failed node using SSH

ssh ${USERNAME}@${FAILED_NODE} "cd ${LOGS_DIR} && tail -n 100 kafka.log"


```