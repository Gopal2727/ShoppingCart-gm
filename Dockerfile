# Use an official Maven image as a parent image
FROM maven:3.8.5-jdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the working directory
COPY pom.xml .

# Copy the rest of the application code to the working directory
COPY src ./src

# Build the application
RUN mvn package

# Start with a base image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled application from the build stage
COPY --from=build /app/target/*.jar app.jar

# Specify the command to run on container start
CMD ["java", "-jar", "app.jar"]
