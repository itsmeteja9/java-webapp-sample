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

        stage('Compile and Build Jar') { 

            steps { 

                bat 'mvn clean install'

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

                    docker.withRegistry( '', registryCredential ) { 

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

                bat "docker rmi -f $registry:${BUILD_NUMBER}" 

            }

        } 

    }

}
