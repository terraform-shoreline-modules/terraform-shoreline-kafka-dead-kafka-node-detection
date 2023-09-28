

#!/bin/bash



# Set the failed node hostname or IP address

FAILED_NODE=${NODE_HOSTNAME_OR_IP_ADDRESS}



# Set the path to the Kafka broker logs directory

LOGS_DIR=${PATH_TO_LOGS_DIRECTORY}



# Log in to the failed node using SSH

ssh ${USERNAME}@${FAILED_NODE} "cd ${LOGS_DIR} && tail -n 100 kafka.log"