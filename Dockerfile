# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml mvnw* ./
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21
WORKDIR /app

COPY --from=build /app/target/quarkus-app /app/quarkus-app

EXPOSE 8080
USER 185

ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"

WORKDIR /app/quarkus-app
CMD ["java", "-jar", "quarkus-run.jar"]



