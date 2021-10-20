mock "tfplan/v2" {
  module {
    source = "mock-tfplan-v2.sentinel"
  }
}
module "tfplan-functions" {
    source = "./tfplan-functions.sentinel"
}

policy "network_gcp_ssl_enforce" {
    source = "./network_gcp_ssl_enforce.sentinel"
    enforcement_level = "advisory"
}