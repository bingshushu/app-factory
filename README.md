# App Factory

一个用于流水线式生产移动应用的工厂架构。采用 Flutter + Java Spring MVC + PostgreSQL 技术栈，后端为微服务架构，从设计之初即面向 Kubernetes 环境。通过共享组件库实现多 App 快速开发。

## ✨ 特性

- 🏭 **工厂模式**: 通过共享组件库快速生产多个 App
- 🔧 **微服务架构**: 后端服务独立部署，易于扩展
- 📱 **Flutter Monorepo**: 统一管理多个 App 和共享包
- 🔐 **完整认证系统**: JWT + 手机号登录 + 验证码
- 🐳 **容器化部署**: Docker Compose + Kubernetes
- 📚 **完善文档**: 详细的开发和部署指南

## 🚀 快速开始

### 前置要求

- Docker Desktop
- Java 21+
- Maven 3.x
- Flutter/Dart SDK 3.6+

详细安装步骤请参考 [安装指南](docs/getting-started/installation.md)。

### 一键启动

```bash
# 启动认证模块
./scripts/start-auth-module.sh

# 测试 API
./scripts/test-auth-api.sh
```

### 访问服务

- **API 文档**: http://localhost:8081/swagger-ui.html
- **user-service**: http://localhost:8081
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

## 📖 文档

- [快速开始](docs/getting-started/quick-start.md) - 5 分钟快速体验
- [安装指南](docs/getting-started/installation.md) - 开发环境设置
- [Java 环境配置](docs/development/java-setup.md) - 配置指定的 Java 路径
- [认证模块](docs/modules/auth/README.md) - 注册、登录功能
- [架构设计](docs/architecture/) - 系统架构文档
- [开发指南](docs/development/) - 编码规范和测试
- [API 参考](docs/api/) - REST API 文档

完整文档索引请查看 [docs/README.md](docs/README.md)。

## 🏗️ 项目结构

```
app-factory/
├── docs/                    # 📚 项目文档
├── scripts/                 # 🔧 开发和测试脚本
├── apps/                    # 📱 各独立 Flutter App
├── packages/                # 📦 Flutter 共享组件库
│   ├── core/               # 核心功能（认证、存储）
│   ├── api_client/         # API 客户端
│   ├── shared_models/      # 数据模型
│   └── ui_kit/             # UI 组件库
├── server/                  # ☕ 后端微服务
│   ├── common/             # 共享模块
│   ├── user-service/       # 用户服务（已完成）
│   ├── gateway/            # API 网关
│   └── ...                 # 其他服务
├── deploy/                  # 🚀 Kubernetes 配置
└── docker-compose.yaml      # 🐳 本地开发环境
```

## 🎯 已完成功能

### 认证模块 ✅
- 手机号+密码注册/登录
- 手机号+验证码注册/登录
- JWT Token 认证
- Token 刷新机制
- 用户信息管理

### 基础设施 ✅
- Docker Compose 本地环境
- PostgreSQL 数据库
- Redis 缓存
- Flyway 数据库迁移
- Swagger API 文档

## 🛠️ 技术栈

### 后端
- Java 21
- Spring Boot 3.3
- Spring Security + JWT
- PostgreSQL 16
- Redis 7
- Maven

### 前端
- Flutter 3.24+
- Dart 3.6+
- Riverpod (状态管理)
- Freezed (数据模型)
- Dio (HTTP 客户端)

### 基础设施
- Docker & Docker Compose
- Kubernetes (计划中)

## 📝 开发指南

### 创建新 App

```bash
flutter create --org com.appfactory apps/my_app
cd apps/my_app
# 编辑 pubspec.yaml 添加共享包依赖
dart pub get
```

### 创建新 Package

```bash
flutter create --template=package packages/my_package
cd packages/my_package
# 编辑 pubspec.yaml 添加 resolution: workspace
dart pub get
```

### 运行测试

```bash
# Flutter 测试
cd packages/core && flutter test

# Java 测试
cd server && mvn test
```

### 代码生成

```bash
# 生成 Freezed 和 Riverpod 代码
cd packages/shared_models
dart run build_runner build --delete-conflicting-outputs
```

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

提交信息请遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范。

## 📄 许可证

MIT License

## 🔗 相关链接

- [CLAUDE.md](CLAUDE.md) - Claude Code 项目指南
- [文档中心](docs/README.md) - 完整文档索引
- [认证模块文档](docs/modules/auth/README.md) - 认证功能详解

## 📮 联系方式

如有问题或建议，请提交 Issue。

---

**当前版本**: 1.0.0
**最后更新**: 2026-01-30

docker compose up -d --build
melos run generate