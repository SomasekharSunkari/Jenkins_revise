FROM public.ecr.aws/docker/library/maven:3.9.8-eclipse-temurin-21 as builder

WORKDIR /app
COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests

FROM public.ecr.aws/docker/library/eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app/target/demo-*.jar app.jar
EXPOSE 8090
ENTRYPOINT [ "java","-jar","app.jar" ]