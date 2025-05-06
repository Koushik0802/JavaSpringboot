# Step 1: Build Stage
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /opt/app

COPY pom.xml .

COPY src ./src

RUN mvn clean package -DskipTests

# Step 2: Final Runtime Stage (Distroless)
FROM gcr.io/distroless/java21

# Copy the built jar from the builder image
COPY --from=builder /opt/app/target/*.jar /app/app.jar

# Set the entry point for the container to run the Java application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Optionally, set a default port for the application
EXPOSE 8081
