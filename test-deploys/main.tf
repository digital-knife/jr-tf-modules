module "test_assets" {
  # We use a relative path to reach back into your modules folder
  source = "../modules/s3_bucket"

  bucket_name = "jr-test-assets-315735600075"
}
