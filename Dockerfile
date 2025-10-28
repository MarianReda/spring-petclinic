# ---- Build stage ----
FROM eclipse-temurin:25-jdk AS build
WORKDIR /workspace
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN chmod +x mvnw && ./mvnw -B -ntp dependency:go-offline

COPY src src
RUN ./mvnw -B -ntp package -DskipTests

# ---- Package stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app
# copy the jar built in the build stage
COPY --from=build /workspace/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar","--spring.profiles.active=postgres"]
