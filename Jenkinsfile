pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="333482297166"
        AWS_DEFAULT_REGION="us-east-1" 
        IMAGE_REPO_NAME="spc-jenkins"
        IMAGE_TAG="latest"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/subhendusekhar111/spring-petclinic.git']]])            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        sh 'docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} .'
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
    }
    stage('Deploy on k8s') {
        steps {
            sh 'kubectl apply -f spc-k8s.yml'
        }
    }
    
}
}