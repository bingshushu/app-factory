# 快速开始

本指南将帮助你在 5 分钟内启动并测试 App Factory 认证模块。

## 前置条件

确保已安装以下工具：
- Docker Desktop
- Java 21+
- Maven 3.x
- Flutter/Dart SDK 3.6+

详细安装步骤请参考 [安装指南](installation.md)。

## 配置 Java 环境

本项目使用指定的 Java 路径。首次使用前需要配置：

```bash
# 方式 1: 加载环境变量（推荐）
source .env.local

# 方式 2: 使用设置脚本
source scripts/setup-env.sh

# 验证 Java 配置
java -version
echo $JAVA_HOME
```

**注意**: 如果你的 Java 路径不是 `/Volumes/Sen/Documents/project/jdk`，请修改 `.env.local` 文件。

详细配置说明请参考 [Java 环境配置](../development/java-setup.md)。

## 一键启动

使用提供的启动脚本（已内置 Java 配置）：

```bash
cd /path/to/app-factory
./scripts/start-auth-module.sh
```

脚本会自动完成：
1. 配置 Java 环境
2. 安装 Flutter 依赖
3. 生成代码（Freezed、Riverpod）
4. 构建 Java 后端
5. 启动 Docker 服务（PostgreSQL、Redis、user-service）
6. 等待所有服务就绪

## 验证服务

### 1. 访问 API 文档

打开浏览器访问：http://localhost:8081/swagger-ui.html

### 2. 测试 API

使用测试脚本：

```bash
./scripts/test-auth-api.sh
```

或手动测试：

```bash
# 发送验证码
curl -X POST http://localhost:8081/api/v1/auth/send-code \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","type":"REGISTER"}'

# 查看验证码（在日志中）
docker compose logs user-service | grep "模拟短信"

# 注册用户
curl -X POST http://localhost:8081/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","verificationCode":"123456","nickname":"测试用户"}'
```

## 下一步

- 📖 阅读 [认证模块文档](../modules/auth/README.md)
- 🏗️ 了解 [架构设计](../architecture/overview.md)
- 💻 查看 [开发规范](../development/coding-standards.md)
- 🚀 开始 [创建第一个 App](#创建第一个-app)

## 创建第一个 App

```bash
# 创建新的 Flutter App
flutter create --org com.appfactory apps/demo_app

# 添加依赖
cd apps/demo_app
# 编辑 pubspec.yaml，添加 core、api_client、shared_models

# 运行 App
flutter run
```

## 停止服务

```bash
docker compose down
```

## 故障排查

### 端口被占用

```bash
# 检查端口占用
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis
lsof -i :8081  # user-service

# 停止占用端口的进程
kill -9 <PID>
```

### 服务启动失败

```bash
# 查看日志
docker compose logs user-service
docker compose logs postgres
docker compose logs redis

# 重启服务
docker compose restart user-service
```

### 代码生成失败

```bash
# 清理并重新生成
cd packages/shared_models
flutter clean
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## 获取帮助

- 查看 [完整文档](../README.md)
- 查看 [API 参考](../api/rest-api.md)
- 查看项目 [CLAUDE.md](../../CLAUDE.md)
