# Use an official Maven image as a parent image for the build stage
FROM maven:3.8.5-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy only the pom.xml file to the working directory
COPY pom.xml .

# Resolve Maven dependencies and build the application
RUN mvn dependency:go-offline package

# Copy the rest of the application code to the working directory
COPY src ./src

# Build the application
RUN mvn package

# Start with a smaller base image for the final stage
FROM adoptopenjdk:11-jre-hotspot

# Set the working directory in the container
WORKDIR /app

# Copy the compiled application from the build stage
COPY --from=build /app/target/*.jar app.jar

# Specify the command to run on container start
CMD ["java", "-jar", "app.jar"]
