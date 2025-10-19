# Multi-stage Dockerfile for Spring Boot app with frontend build
# Stage A: build frontend with Node and Vite
FROM node:20-alpine AS node-build
WORKDIR /frontend
COPY frontend/package.json ./
COPY frontend/index.html ./
COPY frontend/src ./src
RUN npm ci && npm run build

# Stage B: build backend with Maven, and copy frontend build into resources/static
FROM maven:3.9.4-eclipse-temurin-21 AS build-with-frontend
WORKDIR /workspace
COPY pom.xml ./
COPY src ./src
# copy built frontend from node-build into resources so it ends up in the jar under static
COPY --from=node-build /frontend/dist ./src/main/resources/static
RUN mvn -e -B -DskipTests package

# Alternate build: assume frontend/dist already exists in the build context and copy it in
FROM maven:3.9.4-eclipse-temurin-21 AS build-local-frontend
WORKDIR /workspace
COPY pom.xml ./
COPY src ./src
# copy local frontend/dist (must exist in build context) into resources
COPY frontend/dist ./src/main/resources/static
RUN mvn -e -B -DskipTests package

# Default runtime (built-from-Docker frontend)
FROM eclipse-temurin:21-jre-jammy AS runtime
ARG JAR_FILE=target/demo-0.0.1-SNAPSHOT.jar
WORKDIR /app
COPY --from=build-with-frontend /workspace/${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]

# Alternate runtime when skipping frontend build (uses local frontend/dist)
FROM eclipse-temurin:21-jre-jammy AS runtime-local
ARG JAR_FILE=target/demo-0.0.1-SNAPSHOT.jar
WORKDIR /app
COPY --from=build-local-frontend /workspace/${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
