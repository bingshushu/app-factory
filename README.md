# 📱 App Factory - 移动应用流水线工厂

> 一个高效的移动应用生产工厂框架，采用工厂模式和组件库复用，快速生产多个高质量 App

## 🎯 项目愿景

**App Factory** 是一个完整的**移动应用生产解决方案**，让团队能够像工厂一样高效地生产移动应用：

- 🏭 **工厂化生产** - 通过共享组件库和模板，快速生产多个 App
- 🔧 **模块化架构** - 前后端完全解耦，各自独立演进
- ☁️ **云原生设计** - 从设计之初就面向 Kubernetes 部署
- 📈 **易于扩展** - 微服务架构，新功能新服务
- 📚 **完善文档** - 详细的开发和部署指南

---

## 🌟 核心特性

| 特性 | 说明 |
|------|------|
| **🏭 工厂模式** | 快速复用组件库和设计模式，批量生产 App |
| **📦 Monorepo 管理** | Flutter Workspace 统一管理多个 App 和共享包 |
| **🔐 完整认证系统** | JWT + 手机号登录 + 验证码，开箱即用 |
| **⚙️ 微服务架构** | 后端服务独立部署，API Gateway 统一入口 |
| **🐳 容器化部署** | Docker Compose 本地开发，Kubernetes 生产部署 |
| **🧪 完整测试框架** | 单元测试、集成测试、API 测试 |
| **📖 齐全文档** | 快速开始、架构设计、API 参考、开发规范 |

---

## 🚀 快速开始

### 系统要求

```bash
# 前端开发
- Flutter SDK 3.6+
- Dart 3.6+
- VS Code / Android Studio

# 后端开发
- Java 21+
- Maven 3.x

# 本地测试
- Docker Desktop
- Docker Compose
```

### 一键启动（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/bingshushu/app-factory.git
cd app-factory

# 2. 启动后端服务（Docker）
docker compose up -d --build

# 3. 初始化前端依赖
dart pub get
melos bootstrap

# 4. 生成代码
melos run generate

# 5. 运行 App
cd apps/one
flutter run
```

### 访问服务

```
📖 API 文档 (Swagger UI): http://localhost:8081/swagger-ui.html
🔧 User Service:          http://localhost:8081
📊 Redis 管理:             redis-cli -p 6379
🗄️ PostgreSQL:            localhost:5432
```

### 验证环境

```bash
# 测试认证 API
./scripts/test-auth-api.sh

# 查看服务日志
docker compose logs -f user-service
```

---

## 📁 项目结构

```
app-factory/
│
├── 📱 apps/                       # Flutter 应用
│   └── one/                       # App One（示例应用）
│       ├── lib/
│       ├── test/
│       └── pubspec.yaml
│
├── 📦 packages/                   # 共享包库（Workspace）
│   ├── core/                      # 核心功能包
│   │   ├── auth/                  # 认证逻辑
│   │   ├── storage/               # 本地存储
│   │   └── logger/                # 日志工具
│   │
│   ├── api_client/                # API 客户端
│   │   ├── user_api.dart
│   │   ├── auth_api.dart
│   │   └── interceptors/
│   │
│   ├── shared_models/             # 数据模型（Freezed）
│   │   ├── user_model.dart
│   │   ├── auth_response.dart
│   │   └── api_response.dart
│   │
│   ├── ui_kit/                    # UI 组件库
│   │   ├── buttons/
│   │   ├── dialogs/
│   │   └── themes/
│   │
│   └── auth_ui/                   # 认证 UI 组件
│       ├── login_page.dart
│       └── register_page.dart
│
├── ☕ server/                      # 后端微服务
│   ├── pom.xml                    # 父 POM（统一依赖管理）
│   │
│   ├── common/                    # 共享模块
│   │   ├── exception/
│   │   ├── response/
│   │   └── config/
│   │
│   ├── gateway/                   # API 网关 ✅
│   │   ├── src/main/java/com/appfactory/gateway/
│   │   ├── application.yml
│   │   └── Dockerfile
│   │
│   ├── user-service/              # 用户服务 ✅
│   │   ├── src/main/java/com/appfactory/user/
│   │   │   ├── controller/        # API 端点
│   │   │   ├── service/           # 业务逻辑
│   │   │   ├── repository/        # 数据访问
│   │   │   ├── entity/            # JPA 实体
│   │   │   └── security/          # JWT 认证
│   │   ├── src/main/resources/db/migration/  # Flyway 脚本
│   │   ├── application.yml
│   │   └── Dockerfile
│   │
│   ├── ws-service/                # WebSocket 服务（待开发）
│   ├── file-service/              # 文件服务（待开发）
│   └── notification-service/      # 通知服务（待开发）
│
├── 🚀 deploy/                     # Kubernetes 部署配置
│   ├── base/                      # Kustomize base
│   ├── overlays/                  # 环境覆盖配置
│   └── helm/                      # Helm Charts（可选）
│
├── 📚 docs/                       # 完整文档
│   ├── getting-started/           # 快速开始指南
│   ├── architecture/              # 架构设计文档
│   ├── modules/                   # 模块文档
│   ├── development/               # 开发指南
│   └── api/                       # API 参考
│
├── 🔧 scripts/                    # 开发和测试脚本
│   ├── start-auth-module.sh
│   └── test-auth-api.sh
│
├── 🐳 docker-compose.yaml         # 本地开发环境配置
├── pubspec.yaml                   # Workspace 配置
└── README.md
```

---

## 🔄 技术架构

### 前端架构（Flutter）

```
Flutter Monorepo (Workspace)
│
├── 应用层
│   └── apps/one → 使用所有 packages
│
├── 功能层 (Packages)
│   ├── core/
│   │   ├── AuthRepository (Riverpod)
│   │   ├── TokenStorage (SharedPreferences)
│   │   └── Result<T> (函数式编程)
│   │
│   ├── api_client/
│   │   ├── ApiClient (Dio HTTP)
│   │   ├── AuthApi
│   │   └── AuthInterceptor (自动注入 Token)
│   │
│   └── shared_models/ (Freezed 数据类)
│       ├── User
│       ├── AuthResponse
│       └── ApiResponse
│
└── UI 组件库
    ├── ui_kit/ - 通用组件
    └── auth_ui/ - 认证专用 UI
```

### 后端架构（微服务）

```
请求流程：
客户端 → API Gateway (8080) → 微服务 → 数据库

┌─────────────────────────────────────┐
│  API Gateway (Spring Cloud Gateway) │  ✅
│  - JWT 认证验证                      │
│  - 请求路由转发                      │
│  - 限流降级                          │
│  - CORS 配置                         │
└─────────────────────────────────────┘
            ↓
┌──────────────────────────────────────┐
│      微服务集群                       │
├──────────────────────────────────────┤
│ User Service (8081) ✅              │
│ - 注册/登录                         │
│ - JWT 签发/刷新                     │
│ - 用户信息管理                      │
│ - 手机号验证码                      │
├──────────────────────────────────────┤
│ WebSocket Service (8082) 待开发     │
│ - 实时消息推送                      │
│ - 在线状态管理                      │
├──────────────────────────────────────┤
│ File Service (8083) 待开发          │
│ - 文件上传/下载                     │
│ - 图片处理 + MinIO                  │
├──────────────────────────────────────┤
│ Notification Service (8084) 待开发  │
│ - 推送通知 (FCM/APNs)               │
│ - 站内信                            │
└──────────────────────────────────────┘
            ↓
┌──────────────────────────────────────┐
│    共享基础设施                       │
├──────────────────────────────────────┤
│ PostgreSQL 16 (数据库)              │
│ Redis 7 (缓存 + 限流)               │
│ Flyway (数据库版本管理)             │
└──────────────────────────────────────┘
```

### 技术栈详情

**后端：**
- Java 21 + Spring Boot 3.3
- Spring Security + JWT
- Spring Cloud Gateway
- PostgreSQL 16 + JPA/Hibernate
- Redis 7 (缓存 + 会话)
- Maven + Docker

**前端：**
- Flutter 3.24+ / Dart 3.6+
- Riverpod (状态管理)
- Freezed (数据类生成)
- Dio (HTTP 客户端)
- Go Router (路由管理)
- SharedPreferences (本地存储)

**基础设施：**
- Docker & Docker Compose (本地开发)
- Kubernetes (生产部署)
- Flyway (数据库迁移)

---

## 🎯 已完成功能

### ✅ 认证模块（完全就绪）

**后端 - User Service:**
- [x] 手机号 + 密码注册/登录
- [x] 手机号 + 验证码注册/登录
- [x] JWT Token 签发（自定义声明）
- [x] Token 刷新机制（Refresh Token）
- [x] 用户信息 CRUD
- [x] 密码加密存储（bcrypt）
- [x] 验证码缓存管理（Redis）
- [x] 完整的异常处理

**前端 - Flutter:**
- [x] 认证状态管理（Riverpod）
- [x] Token 自动注入拦截器
- [x] 登录/注册 UI 界面
- [x] 本地 Token 存储
- [x] Token 失效自动刷新

### ✅ 基础设施

- [x] Docker Compose 一键启动
- [x] PostgreSQL + Flyway 数据库版本控制
- [x] Redis 缓存集成
- [x] Swagger API 文档
- [x] 健康检查配置
- [x] Melos 工作流管理

### 🔄 进行中

- 🚧 WebSocket 长链接服务
- 🚧 文件上传/下载服务
- 🚧 推送通知服务

---

## 📖 详细文档

| 文档 | 内容 |
|------|------|
| [快速开始](docs/getting-started/quick-start.md) | 5 分钟快速体验 |
| [安装指南](docs/getting-started/installation.md) | 开发环境设置 |
| [架构概览](docs/architecture/overview.md) | 系统整体架构设计 |
| [后端架构](docs/architecture/backend.md) | 微服务架构详解 |
| [前端架构](docs/architecture/frontend.md) | Flutter 架构设计 |
| [认证模块](docs/modules/auth/README.md) | 完整的认证实现 |
| [认证 API](docs/modules/auth/api.md) | 认证接口文档 |
| [编码规范](docs/development/coding-standards.md) | 代码风格和最佳实践 |
| [测试指南](docs/development/testing.md) | 单元测试和集成测试 |
| [REST API](docs/api/rest-api.md) | 完整的 API 参考 |

📚 [完整文档索引](docs/README.md)

---

## 💻 开发工作流

### 新建 Flutter App

```bash
# 1. 使用 Flutter 模板创建
flutter create --org com.appfactory apps/my_app

# 2. 配置 pubspec.yaml
cd apps/my_app
cat > pubspec.yaml << EOF
name: my_app
resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  core:
  api_client:
  shared_models:
  ui_kit:
EOF

# 3. 安装依赖
dart pub get

# 4. 运行应用
flutter run
```

### 新建共享包

```bash
# 1. 创建包
flutter create --template=package packages/my_package

# 2. 配置 Workspace
cd packages/my_package
# 在 pubspec.yaml 添加: resolution: workspace

# 3. 安装依赖
dart pub get
```

### 代码生成

```bash
# 生成所有代码（Freezed + Riverpod）
melos run generate

# 监听文件变化，自动生成
melos run generate:watch
```

### 运行测试

```bash
# Flutter 单元测试
melos run test

# Java 单元测试
cd server && mvn test

# 测试覆盖率
melos run test:coverage
```

### 代码规范检查

```bash
# 代码分析
melos run analyze

# 代码格式化
melos run format

# CI 模式检查
melos run format:check
```

---

## 🧪 API 测试

### 1. 发送验证码

```bash
curl -X POST http://localhost:8081/api/v1/auth/send-code \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","type":"REGISTER"}'
```

### 2. 注册（密码方式）

```bash
curl -X POST http://localhost:8081/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","password":"password123","nickname":"测试用户"}'
```

### 3. 登录

```bash
curl -X POST http://localhost:8081/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","password":"password123"}'

# 响应示例：
# {
#   "code": 200,
#   "message": "success",
#   "data": {
#     "accessToken": "eyJhbGc...",
#     "refreshToken": "eyJhbGc...",
#     "user": {
#       "id": 1,
#       "phone": "13800138000",
#       "nickname": "测试用户"
#     }
#   }
# }
```

### 4. 刷新 Token

```bash
curl -X POST http://localhost:8081/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refreshToken":"eyJhbGc..."}'
```

更多 API 详见 [REST API 文档](docs/api/rest-api.md) 或访问 http://localhost:8081/swagger-ui.html

---

## 🛠️ 常见命令

```bash
# Monorepo 管理
dart pub get                    # 安装所有依赖
melos bootstrap                 # 链接所有包

# 代码生成和检查
melos run generate              # 生成代码
melos run analyze               # 代码分析
melos run format                # 格式化代码

# 测试
melos run test                  # 运行所有测试
melos run test:coverage         # 生成覆盖率报告

# 后端开发
cd server
mvn clean package               # 构建所有服务
mvn test                        # 运行测试
mvn spring-boot:run             # 运行单个服务

# Docker 容器管理
docker compose up -d            # 启动所有服务
docker compose down             # 停止所有服务
docker compose logs -f          # 查看日志
docker compose ps               # 查看运行状态
```

---

## 🤝 贡献指南

欢迎贡献代码、报告 Bug 或改进文档！

1. **Fork** 本仓库
2. **创建** 特性分支：`git checkout -b feature/amazing-feature`
3. **提交** 更改：`git commit -m 'feat: add amazing feature'`
4. **推送** 到分支：`git push origin feature/amazing-feature`
5. **创建** Pull Request

### 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
feat:   新功能
fix:    bug 修复
docs:   文档更新
style:  代码风格（不影响功能）
refactor: 代码重构
test:   测试相关
chore:  构建脚本、依赖等
```

示例：
```bash
git commit -m "feat: add user profile API endpoint"
git commit -m "fix: correct JWT token expiration bug"
git commit -m "docs: update installation guide"
```

---

## 📊 项目统计

| 指标 | 数值 |
|------|------|
| 编程语言 | Dart (前端) + Java (后端) |
| 前端框架 | Flutter 3.24+ |
| 后端框架 | Spring Boot 3.3 |
| 微服务数量 | 1 完成 + 3 规划中 |
| 共享包数量 | 5 个 |
| 文档页数 | 10+ 页 |

---

## 🐛 故障排查

### 问题：Docker 容器无法启动

```bash
# 查看详细日志
docker compose logs user-service

# 重建容器
docker compose down
docker compose up -d --build

# 清理 Docker 系统
docker system prune -a
```

### 问题：前端依赖冲突

```bash
# 深度清理
melos clean:deep

# 重新安装
melos bootstrap

# 生成代码
melos run generate
```

### 问题：JWT Token 验证失败

1. 检查 Token 是否过期
2. 检查 Token 是否正确设置在 Authorization 请求头
3. 查看后端日志：`docker compose logs -f user-service | grep JWT`

更多解决方案详见 [故障排查文档](docs/development/troubleshooting.md)（待完善）

---

## 📞 获取帮助

- 📖 [完整文档](docs/README.md)
- 🐛 [提交 Issue](https://github.com/bingshushu/app-factory/issues)
- 💬 查看 [讨论区](https://github.com/bingshushu/app-factory/discussions)
- 📧 联系项目维护者

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## 🎉 致谢

感谢所有贡献者！本项目采用以下开源技术：

- [Flutter](https://flutter.dev/) - Google 跨平台框架
- [Spring Boot](https://spring.io/projects/spring-boot) - Java 微服务框架
- [Riverpod](https://riverpod.dev/) - Dart 状态管理
- [Dio](https://github.com/flutterchina/dio) - Dart HTTP 客户端
- [Docker](https://www.docker.com/) - 容器化技术

---

**🚀 现在就开始使用 App Factory，快速构建你的移动应用！**

```bash
git clone https://github.com/bingshushu/app-factory.git
cd app-factory
docker compose up -d --build && dart pub get && melos bootstrap
```

---

**版本：** 1.0.0  
**最后更新：** 2026-02-01 13:33:01  
**维护者：** [@bingshushu](https://github.com/bingshushu)