# Stage 1: Build the Maven project for each service
FROM maven:3.8.7 AS build

# Set the working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Build the Gateway service
WORKDIR /app/gateway
RUN mvn clean package -DskipTests

# Build the Config Server service
WORKDIR /app/config-server
RUN mvn clean package -DskipTests

# Build the Discovery service
WORKDIR /app/discovery
RUN mvn clean package -DskipTests

# Build the School service
WORKDIR /app/school
RUN mvn clean package -DskipTests

# Build the Student service
WORKDIR /app/student
RUN mvn clean package -DskipTests

# Stage 2: Prepare the runtime environment using OpenJDK
FROM openjdk:17

# Set the working directory
WORKDIR /app

# Copy the built JARs from the build stage
COPY --from=build /app/gateway/target/*.jar gateway.jar
COPY --from=build /app/config-server/target/*.jar config-server.jar
COPY --from=build /app/discovery/target/*.jar discovery.jar
COPY --from=build /app/school/target/*.jar school.jar
COPY --from=build /app/student/target/*.jar student.jar

# Expose port 8080 (or other ports if necessary for each service)
EXPOSE 8080

# By default, run the Gateway service (adjust to whichever service you want to run)
ENTRYPOINT ["java", "-jar", "-Dserver.port=8080", "microservices.jar"]
