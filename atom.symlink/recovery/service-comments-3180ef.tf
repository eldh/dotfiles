module "service_comments" {
  source = "git::ssh://git@github.com/Dooer/terraform-tpc.git//service?ref=v6.3.3"

  name = "service-comments"
  tags = ["microservice"]
    memory = "${192 / var.memory_divider}"
  docker_image = "registry.tupac17.com:5000/dooer/service-comments:2.5.1"
  docker_registry_user = "${var.docker_registry_username}"
  docker_registry_password = "${var.docker_registry_password}"
  node_env = "development"
  consul_datacenter = "dc1"

  config {
    DOOER_SENTRY_ENDPOINT = "${var.sentry_dsn}"
    DOOER_STREAM_REGION = "${var.aws_region}"
    # DOOER_STREAM_NAME = "${aws_kinesis_stream.event_stream.name}"
    # DOOER_STREAM_LEASE_TABLE_NAME = "${aws_dynamodb_table.event_stream_lease.name}"
    # DOOER_STREAM_FAILED_TABLE_NAME = "${aws_dynamodb_table.event_stream_failed.name}"
  }
}

module "database_service_comments" {
  source = "git::ssh://git@github.com/Dooer/terraform-tpc.git//database-service-schema?ref=v6.3.3"

  pg_address = "${var.pg_ssh_tunnel_host}"
  pg_port = "${var.pg_ssh_tunnel_port}"
  pg_username = "${var.pg_username}"
  pg_password = "${var.pg_password}"
  pg_database = "${postgresql_database.dooer.name}"

  name = "service-comments"
}
