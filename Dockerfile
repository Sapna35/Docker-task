# Use OpenJDK image as base
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the Spring Boot jar from target folder (after maven build)
COPY target/*.jar app.jar

# Expose port (change if your app runs on another port)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
