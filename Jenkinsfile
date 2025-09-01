pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        AWS_CREDENTIALS = credentials('aws-credentials')
    }

    stages {
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t sapna350/springboot-hello:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh "echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin"
                    sh 'docker push sapna350/springboot-hello:latest'
                }
            }
        }

        stage('Configure AWS & kubectl') {
    steps {
        withEnv(["AWS_ACCESS_KEY_ID=${AWS_CREDENTIALS_USR}", "AWS_SECRET_ACCESS_KEY=${AWS_CREDENTIALS_PSW}"]) {
            sh '''
                aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                aws configure set default.region eu-west-3
                aws eks --region eu-west-3 update-kubeconfig --name batch4-team2-eks-cluster
            '''
        }
    }
}


        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml -n your-namespace'
                sh 'kubectl apply -f k8s/service.yaml -n your-namespace'
            }
        }
    }
}
