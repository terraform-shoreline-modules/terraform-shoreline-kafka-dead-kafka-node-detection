resource "shoreline_notebook" "dead_kafka_node_detection" {
  name       = "dead_kafka_node_detection"
  data       = file("${path.module}/data/dead_kafka_node_detection.json")
  depends_on = [shoreline_action.invoke_ping_nodes,shoreline_action.invoke_kafka_logs_tail]
}

resource "shoreline_file" "ping_nodes" {
  name             = "ping_nodes"
  input_file       = "${path.module}/data/ping_nodes.sh"
  md5              = filemd5("${path.module}/data/ping_nodes.sh")
  description      = "6. Check the network connectivity between Kafka and ZooKeeper nodes"
  destination_path = "/agent/scripts/ping_nodes.sh"
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

resource "shoreline_action" "invoke_ping_nodes" {
  name        = "invoke_ping_nodes"
  description = "6. Check the network connectivity between Kafka and ZooKeeper nodes"
  command     = "`chmod +x /agent/scripts/ping_nodes.sh && /agent/scripts/ping_nodes.sh`"
  params      = ["ZOOKEEPER_NODE","KAFKA_NODE"]
  file_deps   = ["ping_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.ping_nodes]
}

resource "shoreline_action" "invoke_kafka_logs_tail" {
  name        = "invoke_kafka_logs_tail"
  description = "Check the logs of the failed node to identify the root cause of the failure."
  command     = "`chmod +x /agent/scripts/kafka_logs_tail.sh && /agent/scripts/kafka_logs_tail.sh`"
  params      = ["NODE_HOSTNAME_OR_IP_ADDRESS","PATH_TO_LOGS_DIRECTORY","USERNAME"]
  file_deps   = ["kafka_logs_tail"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_logs_tail]
}

