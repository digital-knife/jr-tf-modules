module "network" {
  source      = "../../modules/vpc"
  environment = "test"
  vpc_cidr    = "10.1.0.0/16"
  az_count    = 2
}

module "test_assets" {
  #relative path to reach back into modules folder
  source      = "../modules/s3_bucket"
  bucket_name = "jr-test-assets-315735600075"
}
