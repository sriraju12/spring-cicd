FROM openjdk:17-jdk-slim

ARG artifact=target/*.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

EXPOSE 9090

ENTRYPOINT ["java","-jar","app.jar"]
