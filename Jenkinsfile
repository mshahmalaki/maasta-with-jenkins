pipeline {
  agent any
  parameters{
    booleanParam(name: "FORCE_INIT", defaultValue: false)
    booleanParam(name: "FORCE_MIGRATE", defaultValue: false)
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
        sh "mv TFConfigs/backend.tfvars ."
        sh "mv TFConfigs/envs.groovy ./jkenvs"
        sh "rm -rf TFConfigs"
        load "jkenvs/envs.groovy"
      }
    }
    stage("Init"){
      when{
        anyOf{
          equals(actual: currentBuild.number,expected: 1)
          expression{
            return params.FORCE_INIT && !params.FORCE_MIGRATE
          }
        }
      }
      steps{
        sh "terraform init -backend-config=backend.tfvars"
      }
    }
    stage("Migrate"){
      when{
        expression{
          return !params.FORCE_INIT && params.FORCE_MIGRATE
        }
      }
      steps{
        sh "terraform init -migrate-state -backend-config=backend.tfvars"
      }
    }
    stage("Create Workspace & Switch to it"){
      when{
        equals(actual: currentBuild.number,expected: 1)
      }
      steps{
        sh "terraform workspace new `echo ${env.JOB_NAME} |  cut -d \"-\" -f 2` || true"
        sh "terraform workspace select `echo ${env.JOB_NAME} |  cut -d \"-\" -f 2`"
      }
    }
    stage("Deploy IaC"){
      when{
        expression{
          return !params.FORCE_DESTROY
        }
      }
      steps {
        sh "terraform apply -auto-approve"
      }
    }
    stage("Deploy CaC"){
      when{
        expression{
          return !params.FORCE_DESTROY
        }
      }
      steps {
        sh "terraform show -json | python3 -m maasta"
        ansiblePlaybook (
          become: true, 
          becomeUser: "ubuntu", 
          colorized: true, 
          credentialsId: "$ANSIBLE_SSH_KEY_CREDENTIAL", 
          disableHostKeyChecking: true, 
          inventory: "inventory.yaml", 
          playbook: "deploy.yaml" 
        )
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