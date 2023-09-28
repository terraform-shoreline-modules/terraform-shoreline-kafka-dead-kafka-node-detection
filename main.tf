terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "dead_kafka_node_detection" {
  source    = "./modules/dead_kafka_node_detection"

  providers = {
    shoreline = shoreline
  }
}