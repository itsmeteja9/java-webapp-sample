
FROM tomcat:9.0-jdk11-openjdk


COPY target/java-hello-world.war /usr/local/tomcat/webapps/


EXPOSE 8080


CMD ["java", "-jar","java-hello-world.war"]
