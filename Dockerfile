# Stage 1: Install Dependencies
FROM maven:3.8.8-eclipse-temurin-11 AS dependencies

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

# Stage 2: Build Application
FROM maven:3.8.8-eclipse-temurin-11 AS build

WORKDIR /app
COPY --from=dependencies /root/.m2 /root/.m2
COPY . .
RUN mvn clean package -DskipTests=true

# Stage 3: Run Application
FROM openjdk:11-jre-slim

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
