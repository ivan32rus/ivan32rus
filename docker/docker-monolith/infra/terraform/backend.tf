terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "otus"
    region     = "us-east-1"
    key        = "/terraform.tfstate"
    access_key = "asdaskdfvksjdkfjkldsjfsjdhf"
    secret_key = "asdasdgdfgdgdgdsfgdsfgdfkhgjhdsfj"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

