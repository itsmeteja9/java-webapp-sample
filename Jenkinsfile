pipeline { 

    environment { 
        registry = "itsmeteja9/java-webapp-sample" 
        registryCredential = 'dockerjenkinsintegration' 
        dockerImage = '' 
    }

    agent any 

    tools { 
        maven 'Maven-3.9.9'
    }

    stages { 

        stage('Compile Project') { 
            steps { 
                bat 'mvn clean compile'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Ensure .class files are present during analysis
                    withSonarQubeEnv('sonarserver') {
                        bat 'mvn compile sonar:sonar -Dsonar.java.binaries=target/classes'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                // Wait for SonarQube Quality Gate to pass
                waitForQualityGate abortPipeline: true
            }
        }

        stage('Building our image') { 
            steps { 
                script { 
                    dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                }
            } 
        }

        stage('Deploy our image') { 
            steps { 
                script { 
                    docker.withRegistry('', registryCredential) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 

        stage('Deploy to Dev Docker Container') {
            steps {
                script {
                    bat "docker run -d --name javawebapp $registry:${BUILD_NUMBER}"
                }
            }
        }

        stage('Cleaning up') {
            steps {
                script {
                    // Stop and remove the container first
                    bat "docker stop javawebapp"
                    bat "docker rm javawebapp"

                    def lastSuccessfulBuildID = 0
                    def build = currentBuild.previousBuild
                    while (build != null) {
                        if (build.result == "SUCCESS") {
                            lastSuccessfulBuildID = build.id as Integer
                            break
                        }
                        build = build.previousBuild
                    }
                    println lastSuccessfulBuildID

                    // Remove the image
                    bat "docker rmi $registry:${lastSuccessfulBuildID}"
                }
            }
        }
    }
}
