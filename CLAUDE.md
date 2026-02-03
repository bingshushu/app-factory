# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

App Factory - 一个用于流水线式生产移动应用的工厂架构。采用 Flutter + Java Spring MVC + PostgreSQL 技术栈，后端为微服务架构，从设计之初即面向 Kubernetes 环境。通过共享组件库实现多 App 快速开发。

---

## 🎯 核心原则：最佳实践优先

**本项目的所有技术决策都遵循"最佳实践优先"原则。** Claude 在本项目中工作时，必须理解并遵循这些原则。

### 原则一：约定优于配置 (Convention over Configuration)

遵循项目既定约定，不要发明新的做法：
- ✅ 使用 Melos 管理所有 Flutter 操作
- ✅ 使用 Flyway 管理数据库迁移
- ✅ 使用 Freezed 定义数据模型
- ❌ 不要手动运行 `dart pub get`
- ❌ 不要手写 JSON 序列化代码
- ❌ 不要直接执行 SQL 修改生产数据库

### 原则二：一致性优于个人偏好

团队一致性比个人习惯更重要：
- 所有代码使用相同的格式化规则 (`melos run format`)
- 所有 API 遵循相同的响应格式 (`{ code, message, data }`)
- 所有错误处理使用相同的模式 (Result 类型)
- 所有状态管理使用 Riverpod (不混用 Provider/Bloc)

### 原则三：显式优于隐式

代码意图必须清晰明确：
- 使用 `@riverpod` 注解而非手写 Provider
- 使用 `sealed class` 定义有限状态集
- 使用类型注解，避免 `dynamic` 和 `var`
- 错误信息必须包含上下文，不要只说 "操作失败"

### 原则四：安全优于便捷

安全性不可妥协：
- JWT Secret 必须从环境变量读取，禁止硬编码
- 所有用户输入必须验证和清理
- 数据库密码禁止提交到代码仓库
- 容器以非 root 用户运行

### 原则五：可测试性优于快速实现

代码必须易于测试：
- Repository 模式分离数据访问，便于 Mock
- 依赖注入通过 Riverpod，便于替换
- 业务逻辑不依赖 UI 框架
- 每个公共 API 必须有对应测试

---

## 📁 项目结构

```
app-factory/
├── docs/                    # 📚 项目文档
│   ├── README.md           # 文档索引
│   ├── getting-started/    # 快速开始指南
│   ├── architecture/       # 架构文档
│   ├── modules/            # 模块文档
│   ├── development/        # 开发指南
│   └── api/                # API 参考
├── scripts/                 # 🔧 开发和测试脚本
│   ├── start-auth-module.sh
│   └── test-auth-api.sh
├── apps/                    # 📱 各独立 Flutter App 项目
├── packages/                # 📦 Flutter 共享组件库
├── server/                  # ☕ 后端微服务
├── deploy/                  # 🚀 Kubernetes 部署配置
├── docker-compose.yaml      # 🐳 本地开发环境
└── CLAUDE.md               # 本文件
```

## 📖 文档组织

所有项目文档统一存放在 `docs/` 目录下，按功能分类：

- **getting-started/**: 新手入门指南
  - `installation.md`: 开发环境安装
  - `quick-start.md`: 5 分钟快速开始

- **architecture/**: 架构设计文档
  - `overview.md`: 系统架构概览
  - `backend.md`: 后端微服务架构
  - `frontend.md`: Flutter Monorepo 架构

- **modules/**: 各功能模块文档
  - `auth/`: 认证模块（已完成）
    - `README.md`: 模块概览和使用指南
    - `implementation.md`: 实现细节和技术栈

- **development/**: 开发指南
  - `coding-standards.md`: 编码规范
  - `testing.md`: 测试指南
  - `deployment.md`: 部署指南

- **api/**: API 接口文档
  - `rest-api.md`: REST API 参考

## 🔧 脚本工具

所有脚本统一存放在 `scripts/` 目录下：

- `start-auth-module.sh`: 一键启动认证模块（包含依赖安装、代码生成、服务启动）
- `test-auth-api.sh`: 认证 API 自动化测试脚本

使用方式：
```bash
# 启动服务
./scripts/start-auth-module.sh

# 测试 API
./scripts/test-auth-api.sh
```

## 🚀 快速开始

### 新用户
1. 阅读 [安装指南](docs/getting-started/installation.md)
2. 运行 [快速开始](docs/getting-started/quick-start.md)
3. 查看 [认证模块文档](docs/modules/auth/README.md)

### 开发者
1. 查看 [架构文档](docs/architecture/)
2. 阅读 [编码规范](docs/development/coding-standards.md)
3. 参考 [API 文档](docs/api/rest-api.md)

## Architecture

```
app-factory/
├── docs/                    # 📚 项目文档（统一存放）
│   ├── README.md           # 文档索引
│   ├── getting-started/    # 快速开始
│   ├── architecture/       # 架构设计
│   ├── modules/            # 模块文档
│   │   └── auth/          # 认证模块（已完成）
│   ├── development/        # 开发指南
│   └── api/                # API 参考
├── scripts/                 # 🔧 开发和测试脚本（统一存放）
│   ├── start-auth-module.sh
│   └── test-auth-api.sh
├── apps/                    # 各独立 Flutter App 项目
│   ├── app_one/
│   ├── app_two/
│   └── ...
├── packages/                # Flutter 共享组件库 (本地 packages)
│   ├── core/               # 核心基础库
│   │   ├── lib/
│   │   │   ├── auth/       # 登录、注册、OAuth (JWT Token 管理) ✅
│   │   │   ├── storage/    # 本地存储、缓存 ✅
│   │   │   └── utils/      # 通用工具 ✅
│   │   └── pubspec.yaml
│   ├── ui_kit/             # UI 组件库
│   │   ├── lib/
│   │   │   ├── widgets/    # 通用 widgets
│   │   │   ├── theme/      # 主题系统
│   │   │   └── extensions/ # UI 扩展
│   │   └── pubspec.yaml
│   ├── api_client/         # 后端 API 客户端封装 ✅
│   │   ├── lib/
│   │   │   ├── client/     # 基础 HTTP 客户端 (dio)
│   │   │   ├── interceptors/ # Token 注入、刷新、错误拦截
│   │   │   └── auth/       # 认证服务 API
│   │   └── pubspec.yaml
│   └── shared_models/      # 共享数据模型 ✅
│       └── pubspec.yaml
├── server/                  # 后端微服务 (Java Spring Boot)
│   ├── common/             # 微服务共享模块 ✅
│   │   ├── src/
│   │   └── pom.xml
│   ├── user-service/       # 用户服务 ✅
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   ├── gateway/            # API 网关 (Spring Cloud Gateway) ✅
│   ├── ws-service/         # 长链接服务 (WebSocket / STOMP)
│   ├── file-service/       # 文件服务 (上传、下载、MinIO 对接)
│   ├── notification-service/ # 通知服务 (推送、站内信)
│   ├── pom.xml             # 父 POM (统一依赖版本管理) ✅
│   └── scripts/
│       └── init-db.sql     # 数据库初始化 ✅
├── deploy/                  # Kubernetes 部署配置
│   ├── base/               # Kustomize base
│   ├── overlays/           # 环境差异化配置
│   ├── helm/               # 可选 Helm charts
│   └── skaffold.yaml       # 本地开发用 Skaffold
└── docker-compose.yaml      # 本地开发环境 ✅
```

**注**: ✅ 表示已完成的模块

### 微服务职责划分

| 服务 | 职责 | 端口 | 数据库 | 状态 |
|------|------|------|--------|------|
| gateway | API 路由、限流、JWT 认证验证、CORS | 8080 | Redis (限流) | ✅ |
| user-service | 注册、登录、JWT 签发/刷新、OAuth、用户 CRUD | 8081 | user_db | ✅ |
| ws-service | WebSocket 长链接、实时消息推送、在线状态 | 8082 | 共享 Redis | 待开发 |
| file-service | 文件上传/下载、图片处理、MinIO 对接 | 8083 | file_db | 待开发 |
| notification-service | 推送通知 (FCM/APNs)、站内信、消息模板 | 8084 | notification_db | 待开发 |

### 微服务通信

- **同步**: 服务间通过 REST (OpenFeign) 或 gRPC 调用
- **异步**: 通过 Redis Pub/Sub 或 RabbitMQ/Kafka 解耦事件 (如用户注册后发送通知)
- **服务发现**: K8s Service DNS (无需 Eureka/Nacos)
- **配置管理**: K8s ConfigMap + Secret (无需 Spring Cloud Config)

### Gateway 服务详情 ✅

API Gateway 是所有客户端请求的统一入口，基于 Spring Cloud Gateway 实现。

**核心功能：**
- **路由转发**: 根据路径将请求转发到对应微服务
- **JWT 认证**: 全局过滤器验证 Token，提取用户信息到请求头
- **请求限流**: 基于 Redis 的分布式限流（IP/用户维度）
- **CORS 配置**: 统一跨域处理

**路由规则：**
```yaml
路径                      → 目标服务           认证要求
/api/v1/auth/**          → user-service      公开
/api/v1/users/**         → user-service      需认证
/api/v1/profile/**       → user-service      需认证
/api/v1/ws/**            → ws-service        需认证
/api/v1/files/**         → file-service      需认证
/api/v1/notifications/** → notification-service 需认证
```

**请求头传递：**
Gateway 验证 JWT 后，向下游服务传递以下请求头：
- `X-User-Id`: 用户 ID
- `X-User-Email`: 用户邮箱
- `X-App-Id`: 应用 ID
- `X-User-Roles`: 用户角色
- `X-Gateway`: 标识请求来自 Gateway

**启动 Gateway：**
```bash
# 开发模式（需要先启动 Redis）
cd server/gateway && mvn spring-boot:run -Dspring-boot.run.profiles=dev

# Docker Compose 启动全部服务
docker compose up -d

# 仅构建 Gateway
cd server && mvn clean package -pl gateway -am -DskipTests
```

**环境变量：**
| 变量 | 默认值 | 说明 |
|------|--------|------|
| `REDIS_HOST` | localhost | Redis 地址 |
| `REDIS_PORT` | 6379 | Redis 端口 |
| `JWT_SECRET` | - | JWT 签名密钥（生产环境必须配置） |
| `USER_SERVICE_URL` | http://localhost:8081 | User Service 地址 |

## Build Commands

### 快速开始

```bash
# 一键启动认证模块（推荐）
./scripts/start-auth-module.sh

# 测试认证 API
./scripts/test-auth-api.sh
```

### 初始化 Monorepo (首次)

```bash
# 1. 创建目录结构
mkdir -p apps packages server deploy

# 2. 创建根 pubspec.yaml (配置 Pub Workspace，见下方 Melos Configuration)

# 3. 安装 Melos
dart pub get  # 会安装 dev_dependencies 中的 melos

# 4. 创建核心 packages
flutter create --template=package packages/core
flutter create --template=package packages/ui_kit
flutter create --template=package packages/api_client
flutter create --template=package packages/shared_models

# 5. 为每个子包添加 resolution: workspace (见下方配置示例)

# 6. 链接所有依赖
dart pub get  # 或 melos bootstrap
```

### 后端初始化

```bash
# 创建 Spring Boot 父项目 (使用 Maven multi-module)
cd server
# 父 POM 已定义，各微服务作为子模块

# 构建所有微服务
cd server && mvn clean package -DskipTests

# 构建单个微服务
cd server && mvn clean package -pl gateway -am -DskipTests
cd server && mvn clean package -pl user-service -am -DskipTests

# 运行 Gateway (本地开发，需要先启动 Redis)
cd server/gateway && mvn spring-boot:run -Dspring-boot.run.profiles=dev

# 运行 User Service (本地开发)
cd server/user-service && mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### 创建新项目 (CLI)

```bash
# 创建新 Flutter App
flutter create --org com.yourcompany apps/my_new_app
# 编辑 apps/my_new_app/pubspec.yaml 添加 resolution: workspace 和本地包依赖

# 创建新 Flutter Package
flutter create --template=package packages/my_package
# 编辑 packages/my_package/pubspec.yaml 添加 resolution: workspace

# 重新链接依赖
dart pub get

# 创建新微服务
# 1. 在 server/ 下创建新 Spring Boot 模块
# 2. 在父 pom.xml 中添加 <module>
# 3. 添加 Dockerfile
# 4. 在 deploy/base/ 下添加 K8s 部署配置
```

### 日常开发

```bash
# === Flutter 前端 ===

# 链接所有依赖 (在 monorepo 根目录)
dart pub get  # 或 melos bootstrap

# 构建特定 App
cd apps/app_one && flutter build apk --release
cd apps/app_one && flutter build ios --release

# 运行特定 App
cd apps/app_one && flutter run

# 运行所有包的测试
melos run test

# 运行单个包的测试
cd packages/core && flutter test
cd packages/core && flutter test test/auth/login_test.dart  # 单个测试文件

# 代码分析
melos run analyze

# 代码格式化
melos run format

# === Java 后端 ===

# 启动本地基础设施 (PostgreSQL + Redis + MinIO)
docker compose up -d postgres redis minio

# 运行所有微服务测试
cd server && mvn test

# 运行单个服务测试
cd server/user-service && mvn test

# 本地一键启动所有服务 (开发模式)
docker compose up -d

# 使用 Skaffold 开发 (自动构建+部署到本地 K8s)
cd deploy && skaffold dev
```

## Server Commands

```bash
# === Docker Compose (本地开发，推荐) ===

# 🚀 一键启动所有服务（自动构建，无需本地 Java 环境）
docker compose up -d --build

# 仅启动基础设施（数据库和缓存）
docker compose up -d postgres redis

# 查看服务日志
docker compose logs -f gateway
docker compose logs -f user-service

# 停止所有服务
docker compose down

# === Docker 镜像构建 ===

# 构建所有微服务镜像（在 Docker 内完成 Maven 构建）
docker compose build

# 构建单个服务镜像
docker build -t app-factory/gateway:latest -f gateway/Dockerfile server/
docker build -t app-factory/user-service:latest -f user-service/Dockerfile server/

# === Kubernetes ===

# 部署到 dev 环境
kubectl apply -k deploy/overlays/dev

# 部署到 prod 环境
kubectl apply -k deploy/overlays/prod

# 查看服务状态
kubectl get pods -n app-factory
kubectl logs -f deployment/gateway -n app-factory
kubectl logs -f deployment/user-service -n app-factory

# 端口转发 (本地调试)
kubectl port-forward svc/gateway 8080:8080 -n app-factory

# === 数据库迁移 (Flyway, 集成在各微服务中) ===
# 迁移文件位于各服务的 src/main/resources/db/migration/
# 服务启动时自动执行 Flyway 迁移

# 手动执行迁移
cd server/user-service && mvn flyway:migrate -Dflyway.configFiles=src/main/resources/flyway.conf
```

## Key Conventions

### ⚠️ 重要：始终使用 Melos

**本项目是 Flutter Monorepo，必须使用 Melos 管理所有操作。**

#### 禁止的操作
❌ `dart pub get` - 不要直接使用
❌ `flutter pub get` - 不要直接使用
❌ `cd packages/xxx && dart run build_runner build` - 不要手动切换目录

#### 正确的操作

**基础命令：**
✅ `melos bootstrap` - 安装所有依赖（会自动运行代码生成）
✅ `melos run generate` - 生成所有代码
✅ `melos run generate:watch` - 监听模式生成代码
✅ `melos run test` - 运行所有测试
✅ `melos run test:coverage` - 运行测试并生成覆盖率报告
✅ `melos run analyze` - 分析所有代码
✅ `melos run format` - 格式化所有代码
✅ `melos run format:check` - 检查代码格式（CI 用）
✅ `melos run clean` - 清理所有包
✅ `melos run outdated` - 检查过期依赖

**CI 优化命令：**
✅ `melos run analyze:ci` - 仅分析变更的包
✅ `melos run test:ci` - 仅测试变更的包

#### 为什么必须使用 Melos？
1. **自动处理 workspace 依赖**：Melos 会正确链接本地包
2. **并行执行**：Melos 可以并行处理多个包，提高效率
3. **统一管理**：避免遗漏某些包的操作
4. **避免错误**：手动操作容易导致依赖不一致

### 依赖版本管理

**始终使用最新的稳定版本**

#### ✅ 解决 Riverpod 3.x 与 build_runner 冲突

**问题**：
- `flutter_riverpod ^3.2.0` 依赖 `test` 包
- `build_runner` 也依赖 `test` 包
- 两者对 `analyzer` 版本要求不同，导致冲突

**解决方案**：使用 `dependency_overrides` 固定 analyzer 版本

在**根目录** `pubspec.yaml` 中添加：
```yaml
dependency_overrides:
  analyzer: 8.4.1
```

**重要**：
- ✅ 只在根 pubspec.yaml 中设置 dependency_overrides
- ❌ 不要在子包中重复设置（会导致冲突）
- ✅ 这样可以同时使用 Riverpod 3.x 和 build_runner

#### 当前推荐的依赖版本（最新）

```yaml
environment:
  sdk: ^3.8.0  # 最新 Dart SDK（已更新）
  flutter: ">=3.24.0"

dependencies:
  # 状态管理（最新版本）
  flutter_riverpod: ^3.2.0          # ✅ 最新版
  riverpod_annotation: ^4.0.1       # ✅ 最新版

  # 路由
  go_router: ^17.0.1                # ✅ 最新版

  # 网络
  dio: ^5.9.1                       # ✅ 最新版

  # 数据模型
  freezed_annotation: ^3.1.0        # ✅ 最新版
  json_annotation: ^4.10.0          # ✅ 最新版

  # 存储
  shared_preferences: ^2.2.0        # 稳定版

  # 工具
  logger: ^2.6.2                    # ✅ 最新版

dev_dependencies:
  # 代码生成
  riverpod_generator: ^4.0.2        # ✅ 最新版
  freezed: ^3.2.4                   # ✅ 最新版
  json_serializable: ^6.12.0        # ✅ 最新版
  build_runner: ^2.10.5             # ✅ 最新版

  # Linting
  flutter_lints: ^6.0.0             # ✅ 最新版

  # 测试
  mocktail: ^1.0.0                  # Mock 工具
```

#### 根 pubspec.yaml 配置示例

```yaml
name: app_factory
publish_to: none

environment:
  sdk: ^3.8.0  # 已更新到最新版本

workspace:
  - apps/one
  - packages/core
  - packages/api_client
  - packages/shared_models
  - packages/ui_kit
  - packages/auth_ui

dev_dependencies:
  melos: ^7.4.0

# 关键：解决 Riverpod 3.x 与 build_runner 冲突
dependency_overrides:
  analyzer: 8.4.1

# Melos 配置
melos:
  # Bootstrap 生命周期 hooks
  command:
    bootstrap:
      hooks:
        post: melos run generate  # 自动生成代码

  scripts:
    # 代码分析
    analyze:
      exec: flutter analyze .
      description: Run static analysis
      packageFilters:
        flutter: true

    analyze:ci:
      exec: flutter analyze .
      description: Analyze changed packages only (CI optimized)
      packageFilters:
        diff: origin/main...HEAD
        flutter: true

    # 测试
    test:
      exec: flutter test
      description: Run tests
      packageFilters:
        flutter: true
        dirExists: test

    test:ci:
      exec: flutter test
      description: Test changed packages only (CI optimized)
      packageFilters:
        diff: origin/main...HEAD
        flutter: true
        dirExists: test

    test:coverage:
      exec: flutter test --coverage
      description: Run tests with coverage
      packageFilters:
        flutter: true
        dirExists: test

    # 代码格式化
    format:
      exec: dart format .
      description: Format code

    format:check:
      exec: dart format . --set-exit-if-changed
      description: Check code formatting (CI)

    # 代码生成
    generate:
      exec: dart run build_runner build --delete-conflicting-outputs
      description: Run code generation
      concurrency: 1  # 避免并发冲突
      packageFilters:
        dependsOn: build_runner

    generate:watch:
      exec: dart run build_runner watch --delete-conflicting-outputs
      description: Watch and generate code on changes
      packageFilters:
        dependsOn: build_runner

    # 依赖管理
    get:
      run: melos bootstrap
      description: Install dependencies for all packages

    outdated:
      exec: flutter pub outdated
      description: Check for outdated dependencies
      packageFilters:
        flutter: true

    # 清理
    clean:
      run: melos exec -- flutter clean
      description: Clean all packages

    clean:deep:
      run: |
        melos exec -- flutter clean
        melos exec -- rm -rf .dart_tool
        rm -rf .dart_tool
      description: Deep clean all packages and root
```

#### 检查依赖更新
```bash
# 检查过期的依赖（使用新的 Melos script）
melos run outdated

# 更新依赖到最新版本
# 1. 手动更新 pubspec.yaml 中的版本号
# 2. 运行 melos bootstrap
```

#### 添加新依赖的流程
1. 在对应包的 `pubspec.yaml` 中添加依赖（使用最新版本）
2. 运行 `melos bootstrap` 安装依赖（会自动运行代码生成）
3. 如果需要手动生成代码，运行 `melos run generate`

### Package 依赖规则
- 使用 Dart Pub Workspaces，本地包依赖无需指定 path，直接写包名即可
- packages 之间的依赖: `core` 是最底层，其他包可依赖 core，但 core 不依赖其他业务包
- `shared_models` 仅包含数据模型，不包含业务逻辑
- `api_client` 封装所有后端 API 调用，App 不直接使用 dio

### App 与 Server 的关系
- 所有 App 通过 API Gateway 统一入口访问后端微服务
- 客户端通过 JWT Token 认证，Token 由 user-service 签发
- 通过 `app_id` 请求头或 Token claims 区分不同 App 的数据和权限
- WebSocket 长链接通过 ws-service 建立，支持实时消息和在线状态
- 文件上传通过 file-service 对接 MinIO/OSS

### 微服务开发规范

**每个微服务统一结构 (Spring MVC):**
```
user-service/src/main/java/com/appfactory/user/
├── UserServiceApplication.java
├── config/            # 配置类 (Security, WebSocket, CORS...)
├── controller/        # REST Controller
├── service/           # 业务逻辑
├── repository/        # JPA Repository
├── entity/            # JPA Entity
├── dto/               # 请求/响应 DTO
├── mapper/            # Entity <-> DTO 映射 (MapStruct)
├── exception/         # 自定义异常 + 全局异常处理
└── security/          # JWT Filter, UserDetails 等
```

**数据库规范:**
- 每个微服务拥有独立的数据库 schema (database per service)
- 使用 Flyway 管理数据库迁移，脚本位于 `src/main/resources/db/migration/`
- 命名格式: `V1__init_user_tables.sql`, `V2__add_oauth_columns.sql`
- 禁止跨服务直接访问数据库，必须通过 API 调用

**API 规范:**
- RESTful 风格，统一前缀 `/api/v1/{resource}`
- 使用 Spring Validation 校验请求参数
- 统一响应格式: `{ "code": 0, "message": "success", "data": {...} }`
- 错误码统一定义在 common 模块

### 新建 App 检查清单
1. `flutter create --org com.yourcompany apps/{app_name}`
2. 编辑 `apps/{app_name}/pubspec.yaml`:
   - 添加 `resolution: workspace`
   - 添加本地包依赖: `core:`, `ui_kit:`, `api_client:`
3. 运行 `dart pub get` 链接依赖
4. 复制 `.env.example` 到 `apps/{app_name}/.env` 并配置 API Gateway 地址和 app_id
5. 按 Feature-First 结构组织 `lib/` 目录
6. 如需新的后端能力，在对应微服务中添加 API

### 新建 Package 检查清单
1. `flutter create --template=package packages/{package_name}`
2. 编辑 `packages/{package_name}/pubspec.yaml` 添加 `resolution: workspace`
3. 配置依赖 (如需依赖 core，直接写 `core:` 无需 path)
4. 导出公共 API 在 `lib/{package_name}.dart`
5. 运行 `dart pub get` 链接

### 新建微服务检查清单
1. 在 `server/` 下创建新 Spring Boot 模块 (从已有服务拷贝脚手架)
2. 在 `server/pom.xml` 父 POM 中添加 `<module>new-service</module>`
3. 依赖 `common` 模块获取公共工具类和异常定义
4. 创建数据库: `CREATE DATABASE new_service_db;`
5. 添加 Flyway 迁移脚本 `V1__init.sql`
6. 复制 Dockerfile 模板（只需改服务名和端口，见下方模板）
7. 在 `deploy/base/` 下添加 K8s Deployment + Service YAML
8. 在 Gateway 中添加路由规则
9. 在 `api_client` Flutter 包中添加对应的 API 封装
10. 更新 `docker-compose.yaml` 添加本地开发配置

**Dockerfile 模板（新增微服务时直接复制，改服务名和端口即可）：**
```dockerfile
# 多阶段构建 - {Service Name}
# 新增微服务时无需修改此文件结构

FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -pl {service-name} -am -DskipTests -q

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=builder /app/{service-name}/target/*.jar app.jar
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:{port}/actuator/health || exit 1
EXPOSE {port}
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

### 共享组件扩展规则
- 新增通用功能优先添加到 packages/ 而非单个 App
- UI 组件需支持主题定制 (通过 ThemeExtension)
- 网络请求统一使用 `packages/api_client/` 的封装
- 后端公共逻辑 (异常处理、JWT 工具、统一响应) 放在 `server/common/`

## Melos Configuration

本项目使用 [Melos 7.x](https://melos.invertase.dev/) + Dart Pub Workspaces 管理 Flutter monorepo。

**Melos 是什么?** Melos 是 Dart/Flutter monorepo 管理工具，提供：
- 本地包自动链接 (通过 Pub Workspaces)
- 跨包命令执行 (`melos exec`)
- 自定义脚本 (`melos run`)
- 基于 Conventional Commits 的自动版本管理和 Changelog 生成
- IDE 集成 (IntelliJ / VS Code)

### 根目录 pubspec.yaml (Pub Workspace)

```yaml
# pubspec.yaml (项目根目录)
name: app_factory
publish_to: none

environment:
  sdk: ^3.6.0

# Dart 3.6+ Pub Workspaces 配置
workspace:
  - apps/*
  - packages/*

dev_dependencies:
  melos: ^7.4.0
```

### Melos 配置 (melos 字段或 melos.yaml)

```yaml
# 可以放在根 pubspec.yaml 的 melos 字段，或单独 melos.yaml
melos:
  scripts:
    analyze:
      exec: flutter analyze .
      description: Run static analysis
    test:
      exec: flutter test
      description: Run tests
    format:
      exec: dart format .
      description: Format code
    generate:
      exec: dart run build_runner build --delete-conflicting-outputs
      description: Run code generation
      packageFilters:
        dependsOn: build_runner
```

### 子包 pubspec.yaml 配置

```yaml
# packages/core/pubspec.yaml
name: core
resolution: workspace  # 关键：声明属于 workspace

environment:
  sdk: ^3.6.0
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  # ... 其他依赖
```

Melos 会自动发现 workspace 下所有包，无需手动注册。运行 `dart pub get` 或 `melos bootstrap` 即可链接所有本地包。

---

## Development Standards

### 技术栈选型与理由

**Flutter 前端:**

| 类别 | 选型 | 为什么选择它 |
|------|------|-------------|
| 状态管理 | Riverpod | ✅ 编译时类型安全 ✅ 支持代码生成减少样板 ✅ 自动处理依赖和生命周期 ✅ 易于测试（可 override）|
| 路由 | go_router | ✅ 声明式路由，URL 与状态同步 ✅ 支持深度链接和 Web ✅ 类型安全的路径参数 |
| 网络请求 | dio | ✅ 拦截器机制便于统一处理 Token/错误 ✅ 支持请求取消 ✅ 丰富的配置选项 |
| 本地存储 | shared_preferences + hive | ✅ sp 简单轻量适合 KV ✅ hive 高性能适合复杂对象 ✅ 都支持加密存储 |
| 数据模型 | freezed + json_serializable | ✅ 不可变性保证状态安全 ✅ 自动生成 copyWith/==/hashCode ✅ JSON 序列化零样板 |
| 依赖注入 | Riverpod | ✅ 与状态管理统一 ✅ 编译时依赖检查 ✅ 支持作用域和覆盖 |
| 国际化 | slang | ✅ 类型安全的翻译键 ✅ 编译时检查缺失翻译 ✅ 支持复数和性别 |
| 日志 | logger | ✅ 格式化输出易读 ✅ 支持日志级别 ✅ 轻量无依赖 |
| WebSocket | web_socket_channel | ✅ 官方维护 ✅ 跨平台一致 ✅ 支持 Stream API |

**为什么不选其他方案：**
- ❌ **Provider**：Riverpod 是其作者的改进版，类型更安全，无 BuildContext 依赖
- ❌ **Bloc**：样板代码多，Event/State 分离对简单场景过度设计
- ❌ **GetX**：隐式依赖多，全局状态难以追踪和测试
- ❌ **http 包**：功能简单，缺少拦截器、取消请求等必要特性

**Java 后端:**

| 类别 | 选型 | 为什么选择它 |
|------|------|-------------|
| 框架 | Spring Boot 3.x + Spring MVC | ✅ 行业标准，生态完善 ✅ 自动配置减少样板 ✅ 原生支持 GraalVM |
| 数据库 | PostgreSQL | ✅ 功能强大（JSON、全文搜索）✅ 开源免费 ✅ 云厂商广泛支持 |
| ORM | Spring Data JPA | ✅ Repository 抽象简洁 ✅ 自动生成查询 ✅ 事务管理完善 |
| 数据库迁移 | Flyway | ✅ 版本化迁移脚本 ✅ 自动执行 ✅ 支持回滚 |
| 缓存 | Redis | ✅ 高性能 ✅ 数据结构丰富 ✅ 支持分布式锁和消息 |
| 认证 | Spring Security + JWT | ✅ 无状态可水平扩展 ✅ 标准化协议 ✅ 与 Spring 深度集成 |
| 对象映射 | MapStruct | ✅ 编译时生成代码 ✅ 零反射高性能 ✅ 类型安全 |
| API 文档 | SpringDoc OpenAPI | ✅ 自动生成 Swagger UI ✅ 与代码同步 ✅ 支持导出 |
| 文件存储 | MinIO | ✅ S3 兼容 API ✅ 自托管可控 ✅ 高性能 |
| 日志 | SLF4J + Logback | ✅ 行业标准 ✅ 支持 JSON 格式 ✅ 与 K8s 日志采集兼容 |

**为什么不选其他方案：**
- ❌ **MyBatis**：手写 SQL 维护成本高，JPA 对 CRUD 场景更高效
- ❌ **WebFlux**：响应式编程学习曲线陡峭，团队不熟悉
- ❌ **Session 认证**：有状态，难以水平扩展
- ❌ **ModelMapper/Dozer**：运行时反射，性能差且类型不安全

**部署与基础设施:**

| 类别 | 选型 | 为什么选择它 |
|------|------|-------------|
| 编排 | Kubernetes | ✅ 行业标准 ✅ 自动扩缩容 ✅ 自愈能力 ✅ 声明式配置 |
| 部署配置 | Kustomize | ✅ K8s 原生 ✅ 无模板语法 ✅ 易于理解和维护 |
| 本地开发 | Docker Compose + Skaffold | ✅ 快速启动完整环境 ✅ 热重载 ✅ 与生产环境一致 |
| 网关 | Spring Cloud Gateway | ✅ 与 Spring 生态集成 ✅ 响应式高性能 ✅ 丰富的过滤器 |
| 服务发现 | K8s Service DNS | ✅ 无额外组件 ✅ 零配置 ✅ 自动负载均衡 |
| 配置管理 | K8s ConfigMap + Secret | ✅ 原生支持 ✅ 支持热更新 ✅ 加密存储敏感信息 |
| 监控 | Prometheus + Grafana | ✅ 云原生标准 ✅ 强大的查询语言 ✅ 丰富的可视化 |

**为什么不选其他方案：**
- ❌ **Eureka/Nacos**：K8s 内建服务发现，无需额外组件
- ❌ **Spring Cloud Config**：K8s ConfigMap 更轻量，与部署环境一致
- ❌ **Helm**：对简单项目过于复杂，Kustomize 更直观

### 核心依赖版本

**Flutter (pubspec.yaml):**
```yaml
# packages/core/pubspec.yaml 统一管理版本
dependencies:
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  go_router: ^14.0.0
  dio: ^5.4.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0
  shared_preferences: ^2.2.0
  hive_flutter: ^1.1.0
  logger: ^2.2.0
  web_socket_channel: ^3.0.0

dev_dependencies:
  riverpod_generator: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  build_runner: ^2.4.0
  mocktail: ^1.0.0
```

**Java (server/pom.xml 父 POM 关键依赖):**
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.3.0</version>
</parent>

<properties>
    <java.version>21</java.version>
    <spring-cloud.version>2023.0.0</spring-cloud.version>
    <mapstruct.version>1.5.5.Final</mapstruct.version>
</properties>

<!-- 各微服务按需引入 -->
<!-- spring-boot-starter-web, spring-boot-starter-data-jpa,
     spring-boot-starter-security, spring-boot-starter-websocket,
     spring-boot-starter-data-redis, spring-cloud-starter-gateway,
     flyway-core, postgresql, io.jsonwebtoken:jjwt,
     springdoc-openapi-starter-webmvc-ui, minio, mapstruct -->
```

### App 内部结构 (Feature-First)

```
apps/app_one/lib/
├── main.dart                 # 入口
├── app.dart                  # MaterialApp 配置
├── bootstrap.dart            # 初始化逻辑
├── core/                     # App 级核心
│   ├── router/              # 路由配置
│   │   ├── app_router.dart
│   │   └── routes.dart
│   ├── providers/           # 全局 providers
│   └── constants/           # App 常量
├── features/                 # 功能模块 (按业务划分)
│   ├── home/
│   │   ├── data/            # 数据层
│   │   │   ├── repositories/
│   │   │   └── data_sources/
│   │   ├── domain/          # 领域层
│   │   │   ├── models/
│   │   │   └── usecases/
│   │   ├── presentation/    # 表现层
│   │   │   ├── pages/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   └── home.dart        # Feature barrel file
│   ├── profile/
│   └── settings/
└── shared/                   # App 内共享 (非通用，不适合放 packages)
    ├── widgets/
    └── extensions/
```

### 状态管理规范 (Riverpod)

```dart
// ✅ 使用代码生成 (推荐)
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}

// ✅ 异步数据使用 AsyncValue
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentUser();
}

// ✅ 在 Widget 中使用
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => ErrorWidget(e),
    );
  }
}
```

**Provider 命名规范:**
- 简单状态: `xxxProvider` (如 `counterProvider`)
- Repository: `xxxRepositoryProvider`
- UseCase: `xxxUseCaseProvider`
- 带参数: `xxxProvider(id)` 使用 family

### 数据模型规范 (Freezed)

```dart
// models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    @Default(false) bool isVerified,
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// 生成代码
// flutter pub run build_runner build --delete-conflicting-outputs
```

### Repository 模式

```dart
// 抽象定义 (domain 层)
abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<User> getCurrentUser();
  Future<TokenPair> refreshToken(String refreshToken);
}

// 实现 (data 层) - 通过 api_client 调用后端 user-service
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<User> signIn(String email, String password) async {
    final response = await _apiClient.post('/api/v1/auth/login', data: {
      'email': email,
      'password': password,
    });
    final tokenPair = TokenPair.fromJson(response.data['data']);
    await _apiClient.saveTokens(tokenPair);
    return User.fromJson(response.data['data']['user']);
  }
}

// Provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
}
```

### 错误处理规范

```dart
// 使用 Result 类型 (或 Either from fpdart)
import 'package:core/utils/result.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);
}

// 统一异常类型
sealed class AppException implements Exception {
  String get message;
}

class NetworkException extends AppException {
  @override
  final String message;
  final int? statusCode;
  NetworkException(this.message, {this.statusCode});
}

class AuthException extends AppException {
  @override
  final String message;
  AuthException(this.message);
}

// Repository 使用
Future<Result<User>> signIn(String email, String password) async {
  try {
    final response = await _apiClient.post('/api/v1/auth/login', data: {
      'email': email,
      'password': password,
    });
    return Success(User.fromJson(response.data['data']['user']));
  } on DioException catch (e) {
    final code = e.response?.statusCode;
    if (code == 401) return Failure(AuthException('Invalid credentials'));
    return Failure(NetworkException(e.message ?? 'Network error', statusCode: code));
  } catch (e) {
    return Failure(NetworkException('Unknown error'));
  }
}
```

### 路由规范 (go_router)

```dart
// core/router/app_router.dart
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authState,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'profile/:userId',
            builder: (context, state) => ProfilePage(
              userId: state.pathParameters['userId']!,
            ),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => AuthShell(child: child),
        routes: [
          GoRoute(path: '/auth/login', builder: ...),
          GoRoute(path: '/auth/register', builder: ...),
        ],
      ),
    ],
  );
}
```

### 命名规范

**Flutter:**

| 类型 | 规范 | 示例 |
|------|------|------|
| 文件名 | snake_case | `user_profile_page.dart` |
| 类名 | PascalCase | `UserProfilePage` |
| 变量/方法 | camelCase | `getUserProfile()` |
| 常量 | camelCase 或 SCREAMING_SNAKE | `defaultTimeout`, `API_BASE_URL` |
| Provider | camelCase + Provider | `userProfileProvider` |
| 私有成员 | _前缀 | `_internalState` |

**Java:**

| 类型 | 规范 | 示例 |
|------|------|------|
| 包名 | 全小写 | `com.appfactory.user.controller` |
| 类名 | PascalCase | `UserController`, `UserServiceImpl` |
| 方法/变量 | camelCase | `findByEmail()` |
| 常量 | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| Entity | 单数名词 | `User`, `Notification` |
| DTO | 后缀 Request/Response | `LoginRequest`, `UserResponse` |
| 数据库表 | snake_case 复数 | `users`, `user_tokens` |

**文件命名约定 (Flutter):**
- Page: `xxx_page.dart`
- Widget: `xxx_widget.dart` 或直接 `xxx.dart`
- Provider: `xxx_provider.dart`
- Repository: `xxx_repository.dart`
- Model: `xxx.dart` (在 models/ 目录下)

### 测试规范

**Flutter 测试:**
```dart
// 单元测试 - Repository
void main() {
  late AuthRepository authRepository;
  late MockApiClient mockClient;

  setUp(() {
    mockClient = MockApiClient();
    authRepository = AuthRepositoryImpl(mockClient);
  });

  group('signIn', () {
    test('should return User when credentials are valid', () async {
      // Arrange
      when(() => mockClient.post('/api/v1/auth/login', data: any(named: 'data')))
          .thenAnswer((_) async => mockSuccessResponse);

      // Act
      final result = await authRepository.signIn('test@test.com', 'password');

      // Assert
      expect(result, isA<Success<User>>());
    });
  });
}

// Widget 测试
void main() {
  testWidgets('LoginPage shows error on invalid credentials', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
```

**Flutter 测试目录结构:**
```
test/
├── unit/
│   ├── repositories/
│   └── usecases/
├── widget/
│   └── features/
└── integration/
```

**Java 测试:**
```java
// Controller 集成测试
@WebMvcTest(UserController.class)
class UserControllerTest {
    @Autowired MockMvc mockMvc;
    @MockBean UserService userService;

    @Test
    void login_withValidCredentials_returnsToken() throws Exception {
        when(userService.login(any())).thenReturn(new LoginResponse(...));

        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"email\":\"test@test.com\",\"password\":\"pass\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.accessToken").exists());
    }
}

// Service 单元测试
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock UserRepository userRepository;
    @InjectMocks UserServiceImpl userService;

    @Test
    void findByEmail_existingUser_returnsUser() {
        when(userRepository.findByEmail("test@test.com"))
                .thenReturn(Optional.of(new User(...)));

        var result = userService.findByEmail("test@test.com");

        assertThat(result).isPresent();
    }
}
```

### UI 开发规范

```dart
// ✅ 使用 const 构造函数
const MyWidget({super.key});

// ✅ 抽取子 Widget 而非方法
class UserCard extends StatelessWidget { ... }  // ✅
Widget _buildUserCard() { ... }  // ❌

// ✅ 使用 Theme 和 ThemeExtension
final colorScheme = Theme.of(context).colorScheme;
final appColors = Theme.of(context).extension<AppColors>()!;

// ✅ 响应式布局使用 LayoutBuilder 或 MediaQuery
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return WideLayout();
    }
    return NarrowLayout();
  },
)

// ✅ 间距使用统一常量
const kSpacingSmall = 8.0;
const kSpacingMedium = 16.0;
const kSpacingLarge = 24.0;
```

### 异步操作规范

```dart
// ✅ 页面初始化数据加载 - 使用 Provider
@riverpod
Future<HomeData> homeData(HomeDataRef ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.fetchHomeData();
}

// ✅ 用户触发的操作 - 使用 AsyncNotifier
@riverpod
class SubmitForm extends _$SubmitForm {
  @override
  FutureOr<void> build() {}

  Future<void> submit(FormData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(formRepositoryProvider).submit(data));
  }
}

// ❌ 避免在 Widget 中直接使用 FutureBuilder
// ❌ 避免在 initState 中发起网络请求
```

### Git Commit 规范

```
<type>(<scope>): <subject>

type: feat | fix | docs | style | refactor | test | chore
scope: core | ui_kit | api_client | app_one | gateway | user-service | ws-service | file-service | notification-service | deploy | ...

示例:
feat(user-service): add JWT refresh token rotation
feat(core): add biometric authentication support
fix(app_one): resolve login state persistence issue
refactor(ui_kit): extract button variants to separate files
chore(deploy): add staging overlay for k8s
feat(ws-service): implement heartbeat and reconnection logic
```

### 代码生成命令

```bash
# Flutter - 生成单个包的代码
cd packages/core && dart run build_runner build

# Flutter - 监听模式 (开发时使用)
dart run build_runner watch --delete-conflicting-outputs

# Flutter - 全量重新生成
melos run generate  # 需在 melos.yaml 中配置
```

## Docker 构建最佳实践

### Dockerfile 设计原则

本项目的 Dockerfile 采用以下设计：

1. **多阶段构建**: 构建阶段使用 Maven 镜像，运行阶段使用精简 JRE 镜像
2. **COPY . .**: 复制整个 server 目录，新增模块无需改 Dockerfile
3. **.dockerignore**: 排除 `target/`、`.idea/` 等，保持 context 精简
4. **BuildKit 缓存**: `--mount=type=cache` 缓存 Maven 依赖，加速增量构建
5. **非 root 用户**: 创建 spring 用户运行应用，提升安全性

### server/.dockerignore

```
**/target/
**/.idea/
**/*.iml
**/.git/
**/.gitignore
**/logs/
**/*.log
```

### 使用方式

```bash
# 一键启动（推荐，无需本地 Java 环境）
docker compose up -d --build

# 仅重建某个服务
docker compose up -d --build gateway

# 查看构建日志
docker compose build --progress=plain gateway
```

## Docker Compose (本地开发)

```yaml
# docker-compose.yaml (项目根目录)
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: appfactory
      POSTGRES_PASSWORD: devpassword
      POSTGRES_DB: user_db
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./server/scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appfactory"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  gateway:
    build:
      context: ./server
      dockerfile: gateway/Dockerfile
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - REDIS_HOST=redis
      - JWT_SECRET=dev-secret-key-for-testing-only-min-256-bits-long
      - USER_SERVICE_URL=http://user-service:8081
    depends_on:
      redis:
        condition: service_healthy
      user-service:
        condition: service_started

  user-service:
    build:
      context: ./server
      dockerfile: user-service/Dockerfile
    ports:
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - DATABASE_URL=jdbc:postgresql://postgres:5432/user_db
      - DATABASE_USERNAME=appfactory
      - DATABASE_PASSWORD=devpassword
      - REDIS_HOST=redis
      - JWT_SECRET=dev-secret-key-for-testing-only-min-256-bits-long
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

volumes:
  postgres_data:
```
