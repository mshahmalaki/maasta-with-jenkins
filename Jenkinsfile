pipeline {
  agent any
  stages {
    stage("Deploy"){
      steps {
        sh "terraform init"
        sh "terraform apply -auto-approve"
      }
    }
  }
}