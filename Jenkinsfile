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
        stage('Run Docker Container') {
            steps {
                script {
                    bat 'docker run -d --name javawebapp $itsmeteja9/java-webapp-sample:$7'
                }
            }
        }

        stage('Cleaning up') { 

            steps { 

                bat "docker rmi $registry:$BUILD_NUMBER" 

            }

        } 

    }

}
