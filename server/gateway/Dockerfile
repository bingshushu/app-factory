# 多阶段构建 - Gateway Service
# 新增微服务时无需修改此文件

# 阶段 1: 构建
FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder
WORKDIR /app

# 复制整个 server 目录（通过 .dockerignore 排除不需要的文件）
COPY . .

# 构建 gateway 及其依赖
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -pl gateway -am -DskipTests -q

# 阶段 2: 运行
FROM eclipse-temurin:21.0.7_6-jre-alpine
WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring

ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8

USER spring:spring

COPY --from=builder /app/gateway/target/*.jar app.jar

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
