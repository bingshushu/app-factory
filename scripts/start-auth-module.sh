#!/bin/bash

# 认证模块快速启动脚本

set -e

echo "🚀 App Factory 认证模块启动脚本"
echo "================================"

# 配置 Java 路径
export JAVA_HOME="/Volumes/Sen/Documents/project/jdk/zulu21"
export PATH="$JAVA_HOME/bin:$PATH"

echo "📍 使用 Java: $JAVA_HOME"
java -version

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker"
    exit 1
fi

# 检查 Maven 是否安装
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven 未安装，请先安装 Maven"
    exit 1
fi

# 检查 Dart 是否安装
if ! command -v dart &> /dev/null; then
    echo "❌ Dart 未安装，请先安装 Flutter/Dart SDK"
    exit 1
fi

# 检查并激活 melos
if ! command -v melos &> /dev/null; then
    echo "📦 激活 Melos..."
    dart pub global activate melos
fi

echo ""
echo "📦 步骤 1/5: 安装 Flutter 依赖..."
melos bootstrap

echo ""
echo "🔨 步骤 2/5: 生成 Flutter 代码..."
melos run generate

echo ""
echo "🏗️  步骤 3/5: 构建 Java 后端..."
cd server
mvn clean package -DskipTests
cd ..

echo ""
echo "🐳 步骤 4/5: 启动 Docker 服务..."
docker compose up -d

echo ""
echo "⏳ 步骤 5/5: 等待服务启动..."
echo "等待 PostgreSQL..."
until docker compose exec -T postgres pg_isready -U appfactory > /dev/null 2>&1; do
    sleep 1
done
echo "✅ PostgreSQL 已就绪"

echo "等待 Redis..."
until docker compose exec -T redis redis-cli ping > /dev/null 2>&1; do
    sleep 1
done
echo "✅ Redis 已就绪"

echo "等待 user-service..."
for i in {1..30}; do
    if curl -s http://localhost:8081/api/v1/auth/send-code > /dev/null 2>&1; then
        echo "✅ user-service 已就绪"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠️  user-service 启动超时，请检查日志: docker compose logs user-service"
    fi
    sleep 2
done

echo ""
echo "✅ 所有服务已启动！"
echo ""
echo "📚 服务信息："
echo "  - API 文档: http://localhost:8081/swagger-ui.html"
echo "  - user-service: http://localhost:8081"
echo "  - PostgreSQL: localhost:5432 (user: appfactory, db: user_db)"
echo "  - Redis: localhost:6379"
echo ""
echo "📝 查看日志："
echo "  docker compose logs -f user-service"
echo ""
echo "🧪 测试 API："
echo '  curl -X POST http://localhost:8081/api/v1/auth/send-code \'
echo '    -H "Content-Type: application/json" \'
echo '    -d '"'"'{"phone":"13800138000","type":"REGISTER"}'"'"
echo ""
echo "🛑 停止服务："
echo "  docker compose down"
echo ""
