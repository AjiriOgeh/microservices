#FROM maven:3.8.7 as build
#COPY . .
#RUN mvn -B clean package -DskipTests
#
#FROM openjdk:17
#COPY --from=build target/*.jar contactmanegment.jar
#EXPOSE 8080
#
## Removed the problematic backtick
#ENTRYPOINT ["java", "-jar", "-Dserver.port=8080", "microservices.jar"]
#
##17 is more stable

# Stage 1: Build the Maven project for each service
FROM maven:3.8.7 AS build

# Set the working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Build each service separately (replace 'gateway' with the correct service)
WORKDIR /app/gateway
RUN mvn clean package -DskipTests

# Stage 2: Prepare the runtime environment using OpenJDK
FROM openjdk:17

# Set the working directory
WORKDIR /app

# Copy the built JAR from the build stage (adjust to the correct service)
COPY --from=build /app/gateway/target/*.jar gateway.jar

# Expose port 8080 for the application
EXPOSE 8080

# Run the Gateway service (change to the correct service if needed)
ENTRYPOINT ["java", "-jar", "-Dserver.port=8080", "gateway.jar"]
