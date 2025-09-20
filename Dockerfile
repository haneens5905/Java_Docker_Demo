# Stage 1: Build the application with Maven + JDK
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory inside the container
WORKDIR /app

# Copy Maven config first to leverage dependency layer caching
COPY pom.xml .

# Copy source code
COPY src ./src

# Build the jar (skip tests for speed)
RUN mvn -q -DskipTests package



# Stage 2: Runtime image with only the JRE + our jar
FROM eclipse-temurin:17-jre

# Set working directory inside the container
WORKDIR /app

# Copy the jar from the builder stage
COPY --from=builder /app/target/hello-docker-1.0.0.jar app.jar

# Let the app know it's running inside a container
ENV RUNNING_IN_CONTAINER=true

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
