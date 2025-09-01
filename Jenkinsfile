pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sapna350/springboot-hello:latest"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds"   
        KUBE_CONFIG = "$WORKSPACE/kubeconfig"     
        NAMESPACE = "sapna-namespace"              
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Sapna35/Docker-task'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
    steps {
        script {
            sh 'docker build -t sapna350/springboot-hello:latest -f springboot-app/Dockerfile springboot-app'
        }
    }
}

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Configure AWS & kubectl') {
            steps {
                withCredentials([aws(credentialsId: "${AWS_CREDENTIALS}", region: 'us-east-1')]) {
                    sh '''
                        # Update kubeconfig for EKS
                        aws eks update-kubeconfig --name my-eks-cluster --region us-east-1 --kubeconfig ${KUBE_CONFIG}
                        export KUBECONFIG=${KUBE_CONFIG}
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    export KUBECONFIG=${KUBE_CONFIG}
                    kubectl config use-context arn:aws:eks:us-east-1:123456789012:cluster/my-eks-cluster
                    kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                    
                    # Apply Kubernetes manifests (deployment + service)
                    kubectl apply -f k8s/deployment.yaml -n ${NAMESPACE}
                    kubectl apply -f k8s/service.yaml -n ${NAMESPACE}
                '''
            }
        }
    }
}
