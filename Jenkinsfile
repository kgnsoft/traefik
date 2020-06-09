def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'danger', 'ABORTED': 'danger']

pipeline {

  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
  }

  environment {
    TF_LOG = "TRACE"
    TF_LOG_PATH = "terraform.log"
  }

  stages {
    stage('Clean'){
      steps {
        sh 'git clean -fdx'
      }
    }
    stage('Inboundproxy Packer Build') {
      when {
        changeset 'packer/**'
      }
      steps {
        sh 'cd packer && PACKER_LOG=1 PACKER_LOG_PATH="packer.log" packer build inbound_proxy.json'
      }
    }

    stage('Terraform Plan Changes') {
      steps {
        dir('terraform') {
            lock('inbound-deploy') {
              withCredentials([sshUserPrivateKey(credentialsId: "gitlab-ssh-jenkins", keyFileVariable: 'keyfile')]) {
                sh """
                export TARGET_KEY_ID=`aws kms list-aliases --region eu-west-2 | jq -r '.Aliases[] | select(.AliasName=="alias/s3") | .TargetKeyId'`
                GIT_SSH_COMMAND="ssh -i $keyfile" terraform12 init -backend-config "kms_key_id=\${TARGET_KEY_ID}"
                """
              withAWS(role: 'TerraformBuild', roleAccount: '260563756810', externalId: 'XhWVBr3y4LpxtM', roleSessionName: 'Jenkins') {
                sh """
                terraform12 plan -out terraform-plan
                """
              }
              
              }
            }
        }
      }
    }  
    stage('Terraform Plan Approval') {
      steps {
        script {
            env.APPLY_TERRAFORM = input message: 'User input required',
              parameters: [choice(name: 'Confirm you would like to APPLY the changes', choices: 'no\nyes', description: 'Choose "yes" if you want to continue')]
        }
      }   
    }

    stage('Terraform Apply Changes') {
      when {
          environment name: 'APPLY_TERRAFORM', value: 'yes'
      }  
      steps {
        dir('terraform') {
            lock('inbound-deploy') {
              withAWS(role: 'TerraformBuild', roleAccount: '260563756810', externalId: 'XhWVBr3y4LpxtM', roleSessionName: 'Jenkins') {
                sh """
                terraform12 apply terraform-plan
                """
            }
            }
        }
      }
    }

//    stage('AWS Deploy - terraform apply') {
//      steps { 
//          sh 'cd terraform && TF_LOG=TRACE TF_LOG_PATH=terraform.log terraform12 init'
//          sh 'cd terraform && TF_LOG=TRACE TF_LOG_PATH=terraform.log terraform12 plan -out terraform-plan'
//          sh 'cd terraform && TF_LOG=TRACE TF_LOG_PATH=terraform.log terraform12 apply terraform-plan'
//        
//      }
//    }

    stage('AMI Cleaner') {
      steps {            
        withPythonEnv('/usr/bin/python3') {
          // Creates the virtualenv before proceeding                                
          sh 'pip3 install --quiet --upgrade aws-amicleaner'
          sh 'export AWS_DEFAULT_REGION=eu-west-2 && amicleaner --mapping-key name --mapping-values InboundProxy --full-report --keep-previous 2 -f'
        }            
      }
    }
    
    stage('Test - inbound proxy is up'){
      steps {
        println 'Inbound Proxy  is up!'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/packer.log', fingerprint: true, allowEmptyArchive: true
      archiveArtifacts artifacts: 'terraform/terraform.log', fingerprint: true

      // slackSend color: COLOR_MAP[currentBuild.currentResult],
      //   message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}"
    }
  }
}

