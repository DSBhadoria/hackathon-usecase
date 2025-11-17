FROM maven:3.9-eclipse-temurin-17-alpine

WORKDIR /app

# Copy all source code and pom.xml
COPY . .

# Build Spring Boot JAR
RUN mvn clean package -DskipTests

# Expose port
EXPOSE 8080

# Set environment variables
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Run as non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Run the app directly
CMD ["java", "-jar", "target/order-service-0.0.1-SNAPSHOT.jar"]
