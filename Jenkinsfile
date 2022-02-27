pipeline {
  agent any
  parameters{
    booleanParam(name: "FORCE_INIT", defaultValue: false)
    booleanParam(name: "FORCE_DESTROY", defaultValue: false)
  }
  stages {
    stage("Load Configurations"){
      steps{
        load "jkenvs/${env.JOB_NAME}.groovy"
        dir("TFConfigs"){
          git(
            url: "$INFRA_CONFIG_GIT_URL",
            branch: "main",
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
          equals(actual: currentBuild.number,expected: 1)
          expression{
            return params.FORCE_INIT
          }
        }
      }
      steps{
        sh "terraform init"
      }
    }
    stage("Create Workspace & Switch to it"){
      when{
        equals(actual: currentBuild.number,expected: 1)
      }
      steps{
        sh "export TFENV=`echo ${env.JOB_NAME} |  cut -d \"-\" -f 2` && terraform workspace new ${TFENV}"
      }
    }
    stage("Deploy"){
      when{
        expression{
          return !params.FORCE_DESTROY
        }
      }
      steps {
        sh "terraform apply -auto-approve"
      }
    }
    stage("Destroy"){
      when{
        expression{
          return params.FORCE_DESTROY
        }
      }
      steps{
        sh "terraform destroy -auto-approve"
      }
    }
  }
}