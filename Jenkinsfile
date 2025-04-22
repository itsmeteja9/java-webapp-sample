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

        stage('Compile and Build') { 
            steps { 
                bat 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('sonarserver') {
                        bat 'mvn sonar:sonar -Dsonar.java.binaries=target/classes'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
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
                    bat "docker stop javawebapp || exit 0"
                    bat "docker rm javawebapp || exit 0"

                    def lastSuccessfulBuildID = 0
                    def build = currentBuild.previousBuild
                    while (build != null) {
                        if (build.result == "SUCCESS") {
                            lastSuccessfulBuildID = build.id as Integer
                            break
                        }
                        build = build.previousBuild
                    }
                    println "Cleaning image from previous successful build: $lastSuccessfulBuildID"
                    bat "docker rmi $registry:${lastSuccessfulBuildID} || exit 0"
                }
            }
        }
    }
}
