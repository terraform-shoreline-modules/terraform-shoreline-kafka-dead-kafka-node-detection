resource "shoreline_notebook" "dead_kafka_node_detection" {
  name       = "dead_kafka_node_detection"
  data       = file("${path.module}/data/dead_kafka_node_detection.json")
  depends_on = [shoreline_action.invoke_kafka_migration]
}

resource "shoreline_file" "kafka_migration" {
  name             = "kafka_migration"
  input_file       = "${path.module}/data/kafka_migration.sh"
  md5              = filemd5("${path.module}/data/kafka_migration.sh")
  description      = "Replace the failed node: If the node is found to be defective, it should be replaced with a new one."
  destination_path = "/tmp/kafka_migration.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_migration" {
  name        = "invoke_kafka_migration"
  description = "Replace the failed node: If the node is found to be defective, it should be replaced with a new one."
  command     = "`chmod +x /tmp/kafka_migration.sh && /tmp/kafka_migration.sh`"
  params      = ["HOSTNAME_OF_THE_FAILED_KAFKA_NODE","OLD_NODE_HOSTNAME","HOSTNAME_OF_THE_NEW_KAFKA_NODE"]
  file_deps   = ["kafka_migration"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_migration]
}

