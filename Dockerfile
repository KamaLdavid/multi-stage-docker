############################################
# Stage 1: Install Dependencies
############################################
FROM maven:3.8.7-openjdk-11-slim AS dependencies

# Set working directory
WORKDIR /app

# Copy only the pom.xml and dependency files
COPY pom.xml ./

# Download project dependencies without building
RUN mvn dependency:go-offline

############################################
# Stage 2: Copy Application Files
############################################
FROM dependencies AS build

# Copy the source code into the container
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

############################################
# Stage 3: Run the Application
############################################
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
