FROM maven:3.8.5-openjdk-17 AS builder
COPY . .
RUN mvn install
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)


FROM eclipse-temurin:17-jdk AS runner
COPY --from=builder target/*.jar app.jar

RUN useradd demo
USER demo

ARG DEPENDENCY=target/dependency
COPY --from=builder ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=builder ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=builder ${DEPENDENCY}/BOOT-INF/classes /app

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app.jar"]
