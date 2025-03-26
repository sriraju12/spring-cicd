FROM openjdk:17-jdk-slim

WORKDIR /opt/app

COPY target/demo-*.jar app.jar

EXPOSE 9090

ENTRYPOINT ["java","-jar","app.jar"]

