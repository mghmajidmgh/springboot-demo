# Multi-stage Dockerfile for Spring Boot app (build then run)
# Uses Maven to build a fat jar, then OpenJDK 21 slim to run it

# Stage 1: build
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY pom.xml ./
COPY src ./src
RUN mvn -e -B -DskipTests package

# Stage 2: runtime
FROM eclipse-temurin:21-jre-jammy
ARG JAR_FILE=target/demo-0.0.1-SNAPSHOT.jar
WORKDIR /app
COPY --from=build /workspace/${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
