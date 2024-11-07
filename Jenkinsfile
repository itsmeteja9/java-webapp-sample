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
        

       stage('Cleaning up') {
    steps {
        script {
            // Stop and remove the container first
            bat "docker stop javawebapp"
            bat "docker rm javawebapp"

            // Now remove the image
            bat "docker rmi $registry:${BUILD_NUMBER}"
        }
    }
}

    }

}
