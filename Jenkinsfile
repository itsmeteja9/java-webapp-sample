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
        stage('SonarQube analysis'){
            steps{
                withSonarQubeEnv('SonarQube'){
                    sh"./gradlew sonarqube"
                }
            }
        }
        stage("Quality gate"){
            steps{
                waitForQualityGate abortPipeline:true
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
        script {
            // Stop and remove the container first
            bat "docker stop javawebapp"
            bat "docker rm javawebapp"
        def lastSuccessfulBuildID = 0
        def build = currentBuild.previousBuild
        while (build != null) {
            if (build.result == "SUCCESS")
            {
                lastSuccessfulBuildID = build.id as Integer
                break
            }
            build = build.previousBuild
        }
        println lastSuccessfulBuildID
            // Now remove the image
            bat "docker rmi $registry:${lastSuccessfulBuildID}"
        }
    }
}
    }

}
