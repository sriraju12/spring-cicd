pipeline {
    agent any

tools {
    jdk 'jdk17'
    maven 'Maven3'
}
stages {
    stage("checkout"){
        steps{
            git branch: 'main', credentialsId: 'github', url: 'https://github.com/sriraju12/spring-demo.git'
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
                    sh 'mvn sonar: sonar'
                }
            }
        }
    }

    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "sriraju12/spring-app:${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('dockerhub-token')
      }
      steps {
        script {
            sh "docker build -t ${DOCKER_IMAGE} ."
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "dockerhub-token") {
                dockerImage.push()
            }
        }
      }
    }
}
}
