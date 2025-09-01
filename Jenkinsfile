pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sapna350/springboot-app"
        DOCKER_TAG = "latest"
        DOCKER_CREDENTIALS = credentials('dockerhub-creds')
        AWS_REGION = "eu-west-3"
        KUBE_NAMESPACE = "springboot-namespace"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Sapna35/Docker-task.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: 'https://index.docker.io/v1/']) {
                    sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withAWS(region: "$AWS_REGION", credentials: 'aws-creds') {
                    sh '''
                        aws eks update-kubeconfig --name my-eks-cluster --region $AWS_REGION
                        kubectl config set-context --current --namespace=$KUBE_NAMESPACE
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
