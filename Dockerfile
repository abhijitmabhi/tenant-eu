FROM gradle:8.5-jdk21 AS build

WORKDIR /app

COPY gradlew .
COPY gradle gradle

COPY build.gradle .
COPY settings.gradle .

RUN ./gradlew --no-daemon build || return 0

COPY src src

RUN ./gradlew build -x test --no-daemon

FROM amazoncorretto:21-alpine

WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8082

CMD ["java", "-jar", "app.jar"]
