resource "shoreline_notebook" "dead_kafka_node_detection" {
  name       = "dead_kafka_node_detection"
  data       = file("${path.module}/data/dead_kafka_node_detection.json")
  depends_on = [shoreline_action.invoke_ping_kafka_zookeeper,shoreline_action.invoke_kafka_logs_tail]
}

resource "shoreline_file" "ping_kafka_zookeeper" {
  name             = "ping_kafka_zookeeper"
  input_file       = "${path.module}/data/ping_kafka_zookeeper.sh"
  md5              = filemd5("${path.module}/data/ping_kafka_zookeeper.sh")
  description      = "6. Check the network connectivity between Kafka and ZooKeeper nodes"
  destination_path = "/agent/scripts/ping_kafka_zookeeper.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_logs_tail" {
  name             = "kafka_logs_tail"
  input_file       = "${path.module}/data/kafka_logs_tail.sh"
  md5              = filemd5("${path.module}/data/kafka_logs_tail.sh")
  description      = "Check the logs of the failed node to identify the root cause of the failure."
  destination_path = "/agent/scripts/kafka_logs_tail.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ping_kafka_zookeeper" {
  name        = "invoke_ping_kafka_zookeeper"
  description = "6. Check the network connectivity between Kafka and ZooKeeper nodes"
  command     = "`chmod +x /agent/scripts/ping_kafka_zookeeper.sh && /agent/scripts/ping_kafka_zookeeper.sh`"
  params      = ["KAFKA_NODE","ZOOKEEPER_NODE"]
  file_deps   = ["ping_kafka_zookeeper"]
  enabled     = true
  depends_on  = [shoreline_file.ping_kafka_zookeeper]
}

resource "shoreline_action" "invoke_kafka_logs_tail" {
  name        = "invoke_kafka_logs_tail"
  description = "Check the logs of the failed node to identify the root cause of the failure."
  command     = "`chmod +x /agent/scripts/kafka_logs_tail.sh && /agent/scripts/kafka_logs_tail.sh`"
  params      = ["USERNAME","PATH_TO_LOGS_DIRECTORY","NODE_HOSTNAME_OR_IP_ADDRESS"]
  file_deps   = ["kafka_logs_tail"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_logs_tail]
}

