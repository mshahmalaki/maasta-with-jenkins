pipeline {
  agent any
  parameters{
    booleanParam(name: "FORCE_INIT", defaultValue: false)
    booleanParam(name: "FORCE_DESTROY", defaultValue: false)
  }
  triggers {
    pollSCM 'H/15 * * * *'
  }

  stages {
    stage("Load Configurations"){
      steps{
        load "jenkins/env/${env.JOB_NAME}.groovy"
        dir("jenkins/config"){
          git(
            url: "$INFRA_CONFIG_GIT_URL",
            branch: "main",
            credentialsId: "$INFRA_CONFIG_GIT_CREDENTIAL_ID"
          )
        }
        sh "mv jenkins/config/terraform.tfvars ."
        sh "mv jenkins/config/backend.tfvars ."
        sh "mv jenkins/config/envs.groovy ./jenkins/env"
        sh "rm -rf jenkins/config"
        load "jenkins/env/envs.groovy"
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
        sh "terraform init -backend-config=backend.tfvars"
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
          colorized: true, 
          credentialsId: "$ANSIBLE_SSH_KEY_CREDENTIAL", 
          disableHostKeyChecking: true, 
          inventory: "inventory.yaml", 
          playbook: "deploy.yaml" 
        )
        archiveArtifacts artifacts: 'inventory.yaml', followSymlinks: false
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