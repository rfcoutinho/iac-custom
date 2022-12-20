pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                // Get some code from a GitHub repository
                git 'https://github.com/rfcoutinho/iac-custom.git'
                // Run Maven
                sh "cd ./jumia_phone_validator/validator-backend/ && mvn clean install"
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Build Image') {
            steps {
                echo 'Building Container Image....'
                sh "cd ./jumia_phone_validator/validator-backend/ && docker build -t validator-backend-image ."
            }
        }
        stage('Push Image to ECR') {
            steps {
                echo 'Push Image to ECR....'
                script {
                    docker.withRegistry("992122884453.dkr.ecr.eu-west-2.amazonaws.com", "ecr:eu-west-2:credential-id") {
                    docker.image("validator-backend-image").push()}
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }        
    }
}
