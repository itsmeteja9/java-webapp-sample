
FROM openjdk:8-jre-alpine

RUN apk add --no-cache tomcat9 && \
    rm -rf /var/cache/apk/*

COPY index.jsp /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080

CMD ["catalina.sh", "run"]
