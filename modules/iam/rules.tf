# // Leemos recursos que ya están creados en AWS
# data "aws_iam_policy" "AWSPolicy1" {
#   provider          = aws.cuenta_local
#   name              = "AmazonRDSEnhancedMonitoringRole"
# }
# data "aws_iam_policy" "AWSPolicy2" {
#   provider          = aws.cuenta_local
#   name              = "AWSElasticBeanstalkWebTier"
# }
# data "aws_iam_policy" "AWSPolicy3" {
#   provider          = aws.cuenta_local
#   name              = "AWSElasticBeanstalkMulticontainerDocker"
# }
# data "aws_iam_policy" "AWSPolicy4" {
#   provider          = aws.cuenta_local
#   name              = "AWSElasticBeanstalkRoleWorkerTier"
# }
# data "aws_iam_policy" "AWSPolicy5" {
#   provider          = aws.cuenta_local
#   name              = "AmazonSSMManagedInstanceCore"
# }
# data "aws_iam_policy" "AWSPolicy6" {
#   provider          = aws.cuenta_local
#   name              = "AmazonSSMPatchAssociation"
# }
# data "aws_iam_policy" "AWSPolicy-data-7" {
#   provider          = aws.cuenta_local
#   name              = "CloudWatchAgentServerPolicy"
# }
# // Creamos roles
# resource "aws_iam_role" "aws-elasticbeanstalk-ec2-role" {
#   provider          = aws.cuenta_local
#   name              = "ROLE-aws-elasticbeanstalk-ec2"
#   path              = "/"

# assume_role_policy  = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": "sts:AssumeRole",
#             "Principal": {
#                "Service": "ec2.amazonaws.com"
#             },
#             "Effect": "Allow",
#             "Sid": ""
#         }
#     ]
# }
# EOF
# 	tags              = merge({
#       "Name"        =  "ROLE-aws-elasticbeanstalk-ec2"
#     },
#     var.default_tags,	
#   )

# }
# // Atachamos politicas a los roles
# resource "aws_iam_role_policy_attachment" "AWSPolicy2-attach" {
#   provider          = aws.cuenta_local
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
#   policy_arn        = data.aws_iam_policy.AWSPolicy2.arn
# }

# resource "aws_iam_role_policy_attachment" "AWSPolicy3-attach" {
#   provider          = aws.cuenta_local
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
#   policy_arn        = data.aws_iam_policy.AWSPolicy3.arn
# }

# resource "aws_iam_role_policy_attachment" "AWSPolicy4-attach" {
#   provider          = aws.cuenta_local
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
#   policy_arn        = data.aws_iam_policy.AWSPolicy4.arn
# }

# resource "aws_iam_role_policy_attachment" "AWSPolicy5-attach" {
#   provider          = aws.cuenta_local
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
#   policy_arn        = data.aws_iam_policy.AWSPolicy5.arn
# }

# resource "aws_iam_role_policy_attachment" "AWSPolicy6-attach" {
#   provider          = aws.cuenta_local
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
#   policy_arn        = data.aws_iam_policy.AWSPolicy6.arn
# }

# resource "aws_iam_role_policy_attachment" "AWSPolicy7-attach" {
#   provider          = aws.cuenta_local
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
#   policy_arn        = data.aws_iam_policy.AWSPolicy-data-7.arn
# }
# // Creamos profiles
# resource "aws_iam_instance_profile" "profile-beanstalk-ec2" {
#   provider          = aws.cuenta_local
#   name              = "profile-beanstalk-ec2"
#   role              = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
# }
# //Programatico wolkvox
# resource "aws_iam_user" "usuario" {
#   provider = aws.cuenta_local
#   name = "wolkvox-aon.prog"
#   path = "/"
#   tags = {
#     "name" = "Programatico para acceso a S3 Wolkvox"
#   }
# }
# resource "aws_iam_access_key" "claves" {
#   provider = aws.cuenta_local
#   user = aws_iam_user.usuario.name
# }
# resource "aws_secretsmanager_secret" "secret" {
#   provider = aws.cuenta_local
#   name        = "wolkvox-aon.prog"
#   description = "Acceso a S3 de wolkvox"
#   tags = merge({
# 		"Name"		= "wolkvox-aon.prog"
# 		},
# 	  var.default_tags,	
# 	)
# }
# resource "aws_secretsmanager_secret_version" "secret_version" {
#   provider = aws.cuenta_local
#   secret_id = aws_secretsmanager_secret.secret.id
#   secret_string = <<EOF
#    {
#     "usuario": "${aws_iam_user.usuario.name}",
#     "access_key": "${aws_iam_access_key.claves.id}",
#     "secret_key": "${aws_iam_access_key.claves.secret}",
#    }
#   EOF
# }

# resource "aws_iam_policy" "politica" {
#   provider = aws.cuenta_local
#   name = "Policy-S3-konecta-aon-wolkvox"
#   description = "Policy-S3-konecta-aon-wolkvox"
#   tags = {
#     "name" = "konecta-aon-wolkvox"
#   }
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetEncryptionConfiguration",
#                 "s3:GetBucketLocation",
#                 "s3:PutObjectAcl"
#             ],
#             "Effect": "Allow",
#             "Resource": [
#               "${var.bucket_arn}",
#               "${var.bucket_arn}/*"
#             ]
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_user_policy_attachment" "attach" {
#   provider = aws.cuenta_local
#   user       = aws_iam_user.usuario.name
#   policy_arn = aws_iam_policy.politica.arn
# }

resource "aws_iam_role" "genesys" {
  provider = aws.cuenta_local
  name               = "Role-Genesys-S3"
  path               = "/"
  description        = "Da acceso al S3 de grabaciones a la cuenta AWS de Genesys"
  inline_policy {
    name = "Policy-Genesys-S3"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
          "s3:PutObject",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketLocation",
          "s3:PutObjectAcl"
          ]
          Effect   = "Allow"
          Resource = [
            "arn:aws:s3:::${var.bucket_genesys}",
            "arn:aws:s3:::${var.bucket_genesys}/*"
          ]
        }
      ]
    })
  }
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.cuenta_genesys}:root"
            },
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "${var.external_id}"
                }
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
  EOF
	tags = merge({
		"Name"		= "Role-Genesys-S3"
		},
	var.default_tags,	
	)
}
resource "aws_iam_role" "grabaciones" {
  provider = aws.cuenta_local
  name               = "Role-Grabaciones-S3"
  path               = "/"
  description        = "Da acceso al S3 de grabaciones a la cuenta AWS_GRABACIONES"
  inline_policy {
    name = "Policy-Grabaciones-S3"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "s3:ListBucket",
            "s3:GetEncryptionConfiguration",
            "s3:GetBucketLocation",
            "s3:GetObjectAcl",
            "s3:GetObject",
            "s3:GetObjectVersion"
          ]
          Effect   = "Allow"
          Resource = [
            "arn:aws:s3:::${var.bucket_genesys}",
            "arn:aws:s3:::${var.bucket_genesys}/*"
          ]
        }
      ]
    })
  }
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.arn_contenedor}"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.arn_lambda}"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
  EOF
	tags = merge({
		"Name"		= "Role-Grabaciones-S3"
		},
	var.default_tags,	
	)
}