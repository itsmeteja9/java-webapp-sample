FROM tomcat:9.0-jdk11-openjdk

# Set the working directory
WORKDIR /webapp

# Copy the WAR file to the Tomcat webapps directory
COPY target/java-hello-world.war /usr/local/tomcat/webapps/

# Expose the port Tomcat runs on
EXPOSE 8080

# The default command that runs Tomcat
CMD ["catalina.sh", "run"]
