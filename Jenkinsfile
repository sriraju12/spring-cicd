pipeline {
    agent any

tools {
    jdk 'Jdk17'
    maven 'Maven3'
}
 environment {
        DOCKER_IMAGE = "sriraju12/spring-app:${BUILD_NUMBER}"
    }   
stages {
    stage("checkout"){
        steps{
            git branch: 'main', credentialsId: 'github-tokens', url: 'https://github.com/sriraju12/spring-cicd.git'
        }
    }

    stage("build application"){
        steps{
            sh 'mvn clean package'
        }
    }

    stage("test application"){
        steps{
            sh 'mvn test'
        }
    }

    stage("sonarqube analysis"){
        steps {
            script {
                withSonarQubeEnv(credentialsId: 'jenkins-sonar-token'){
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }

    stage('Build and Push Docker Image') {
      environment {
        REGISTRY_CREDENTIALS = credentials('dockerhub-token')
      }
      steps {
        script {
            sh 'docker context use default'  
            sh "docker build -t ${DOCKER_IMAGE} ."
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "dockerhub-token") {
                dockerImage.push()
            }
        }
      }
    }

    stage('Docker Image Scan') {
       steps {
                sh "/opt/homebrew/bin/trivy image --format table -o trivy-image-report.html ${DOCKER_IMAGE}"
            }
        }

    

    stage('update deployement file') {
        environment {
            GIT_REPO_NAME = "spring-cicd"
            GIT_USER_NAME = "sriraju12"
        }
        steps {
            withCredentials([string(credentialsId: 'github-tokens', variable: 'GITHUB_TOKEN')]) {
                sh '''
                     git config user.email "rajukrishnamsetty9@gmail.com"
                     git config user.name "sriraju"
                     sed -i '' "s|image: sriraju12/spring-app:.*|image: sriraju12/spring-app:${BUILD_NUMBER}|g" srpingboot-manifests/deployment.yaml
                     git add srpingboot-manifests/deployment.yaml
                     git commit -m "update deployement image with latest build number" || echo "No changes to commit"
                     git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                   ''' 
            }

        }
    }
}
  post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'rajukrishnamsetty9@gmail.com',                                
            attachmentsPattern: 'trivy-image-report.html'
        }
    }   
}
