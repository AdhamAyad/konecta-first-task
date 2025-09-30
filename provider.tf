provider "aws" {
  alias   = "cuenta_core"
  region  = "eu-west-1"
  profile = "default" # أو البروفايل اللي بتستعمله
}

provider "aws" {
  alias   = "cuenta_local"
  region  = "eu-west-1"
  profile = "default"
}
