mock "tfplan/v2" {
  module {
    source = "mock-tfplan-v2.sentinel"
  }
}
module "tfplan-functions" {
    source = "./tfplan-functions.sentinel"
}

policy "gcp_dialogflow_region" {
    source = "./gcp_dialogflow_region.sentinel"
    enforcement_level = "advisory"
}