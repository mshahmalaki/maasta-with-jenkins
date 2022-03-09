# Infra
Provisioning Infrastructure with Jenkins + [MAAS + Terraform + Ansible](https://github.com/ssbostan/maasta)

## Requirements
Jenkins (CI/CD Tools) <br>
Git server <br>
MinIO (Object Storage to store terraform.tfstate) <br>
Terraform CLI <br>
MAAS + Ready Machines <br>
> :information_source: for testing use [this stack](https://github.com/mshahmalaki/jenkins-stack.git) for Jenkins + Gitea + MinIO + Docker Registry

## How to
We need two `.tfvars` files: <br>
`terraform.tfvars` <br>
`backend.tfvars` <br>
> :white_check_mark: We can store this sensetive informations about our infrastructure credentials on private and separated git repository to restrict and disallow anonymous access. Please refer to [Jenkins environments directory](jenkins/env/) to set git repos URL for every environments and credential. So we need git repo to store `.tfvars` for every environments.

### `terraform.tfvars`
```
# Count of Machines to provision
MAAS_MACHINE_COUNT = 1
MAAS_API_URL       = "http://MAAS_IP:5240/MAAS"
MAAS_API_KEY       = "MAAS_API_KEY"
# Use tags to constraint provision (optional)
MAAS_MACHINE_TAGS  = ["MACHINE_TAGS_FOR_PROVISIONING"]
```

### `backend.tfvars`
```
endpoint             = "http://MINIO_IP:9000"
bucket               = "MINIO_BUCKET_NAME"
access_key           = "MINIO_ACCESS_KEY"
secret_key           = "MINIO_SECRET_KEY"
# terraform.tfstate path in S3 Object Storage (MinIO):  
# /BUCKET_NAME/KEY_PREFIX/WORKSPACE_NAME/terraform.tfstate
workspace_key_prefix = "tfstate"
```
### Define Jenkins job
According to `*.groovy` files in [Jenkins environments directory](jenkins/env/), we need define Jenkins job (Pipeline job) with name of the groovy file name. For example:<br>
`infra-testing.groovy` :arrow_right: **infra-testing** <br>
Please refer to **Load Configurations** stage in [Jenkinsfile](Jenkinsfile#L10-L27). **Run job and enjoy infrastructue automation.**