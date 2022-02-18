pipeline {
  agent any
  stages {
    stage("Load Configurations"){
      steps{
        load "jkenvs/${env.JOB_NAME}.groovy"
        dir("TFConfigs"){
          git(
            url: "$INFRA_CONFIG_GIT_URL",
            credentialsId: "$INFRA_CONFIG_GIT_CREDENTIAL_ID"
          )
        }
        sh "mv TFConfigs/terraform.tfvars ."
        sh "rm -rf TFConfigs"
      }
    }
    stage("Deploy"){
      steps {
        sh "terraform init"
        sh "terraform apply -auto-approve"
      }
    }
  }
}