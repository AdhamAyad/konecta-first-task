# provider "aws" {
#      region = "eu-west-1"
#    }

provider "aws" {
  alias  = "cuenta_core"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "cuenta_local"
  region = "eu-west-1"
}