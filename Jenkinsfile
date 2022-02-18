pipeline {
  agent any
  parameters{
    booleanParam(name: "FORCE_INIT", defaultValue: false)
  }
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
    stage("Init"){
      when{
        anyOf{
          equals(
            actual: currentBuild.number,
            expected: 1
          )
          expression{
            return params.FORCE_INIT
          }
        }
      }
      steps{
        sh "terraform init"
      }
    }
    stage("Deploy"){
      steps {
        sh "terraform apply -auto-approve"
      }
    }
  }
}