# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

App Factory - 一个用于流水线式生产移动应用的工厂架构。采用 Flutter + Java Spring MVC + PostgreSQL 技术栈，后端为微服务架构，从设计之初即面向 Kubernetes 环境。通过共享组件库实现多 App 快速开发。

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
│   ├── gateway/            # API 网关 (Spring Cloud Gateway)
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

| 服务 | 职责 | 端口 | 数据库 |
|------|------|------|--------|
| gateway | API 路由、限流、认证转发 | 8080 | 无 |
| user-service | 注册、登录、JWT 签发/刷新、OAuth、用户 CRUD | 8081 | user_db |
| ws-service | WebSocket 长链接、实时消息推送、在线状态 | 8082 | 共享 Redis |
| file-service | 文件上传/下载、图片处理、MinIO 对接 | 8083 | file_db |
| notification-service | 推送通知 (FCM/APNs)、站内信、消息模板 | 8084 | notification_db |

### 微服务通信

- **同步**: 服务间通过 REST (OpenFeign) 或 gRPC 调用
- **异步**: 通过 Redis Pub/Sub 或 RabbitMQ/Kafka 解耦事件 (如用户注册后发送通知)
- **服务发现**: K8s Service DNS (无需 Eureka/Nacos)
- **配置管理**: K8s ConfigMap + Secret (无需 Spring Cloud Config)

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
cd server && mvn clean package -pl user-service -am

# 运行单个微服务 (本地开发)
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
# === Docker ===

# 构建所有微服务镜像
docker compose build

# 构建单个服务镜像
docker build -t app-factory/user-service:latest server/user-service

# === Kubernetes ===

# 部署到 dev 环境
kubectl apply -k deploy/overlays/dev

# 部署到 prod 环境
kubectl apply -k deploy/overlays/prod

# 查看服务状态
kubectl get pods -n app-factory
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
✅ `melos bootstrap` - 安装所有依赖
✅ `melos run generate` - 生成所有代码
✅ `melos run test` - 运行所有测试
✅ `melos run analyze` - 分析所有代码
✅ `melos run format` - 格式化所有代码

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
  sdk: ^3.8.0  # 最新 Dart SDK
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
  sdk: ^3.6.0

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
```

#### 检查依赖更新
```bash
# 检查过期的依赖
melos exec -- flutter pub outdated

# 更新依赖到最新版本
# 1. 手动更新 pubspec.yaml 中的版本号
# 2. 运行 melos bootstrap
```

#### 添加新依赖的流程
1. 在对应包的 `pubspec.yaml` 中添加依赖（使用最新版本）
2. 运行 `melos bootstrap` 安装依赖
3. 如果需要代码生成，运行 `melos run generate`

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
6. 编写 Dockerfile (可复用已有模板)
7. 在 `deploy/base/` 下添加 K8s Deployment + Service YAML
8. 在 Gateway 中添加路由规则
9. 在 `api_client` Flutter 包中添加对应的 API 封装
10. 更新 `docker-compose.yaml` 添加本地开发配置

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

### 技术栈选型

**Flutter 前端:**

| 类别 | 选型 | 说明 |
|------|------|------|
| 状态管理 | Riverpod | 类型安全、可测试、支持代码生成 |
| 路由 | go_router | 声明式路由、深度链接支持 |
| 网络请求 | dio | 拦截器、取消请求、错误处理 |
| 本地存储 | shared_preferences + hive | 简单 KV 用 sp，复杂对象用 hive |
| 数据模型 | freezed + json_serializable | 不可变模型、自动序列化 |
| 依赖注入 | Riverpod | 统一使用 Riverpod 管理依赖 |
| 国际化 | slang | 类型安全的 i18n |
| 日志 | logger | 格式化日志输出 |
| WebSocket | web_socket_channel | 长链接通信 |

**Java 后端:**

| 类别 | 选型 | 说明 |
|------|------|------|
| 框架 | Spring Boot 3.x + Spring MVC | REST API 开发 |
| 数据库 | PostgreSQL | 主数据库 |
| ORM | Spring Data JPA (Hibernate) | 数据访问层 |
| 数据库迁移 | Flyway | 版本化 schema 管理 |
| 缓存 | Redis (Spring Data Redis) | 会话、缓存、消息队列 |
| 认证 | Spring Security + JWT | 无状态认证 |
| 对象映射 | MapStruct | Entity/DTO 转换 |
| API 文档 | SpringDoc OpenAPI (Swagger) | 自动生成 API 文档 |
| WebSocket | Spring WebSocket + STOMP | 长链接服务 |
| 文件存储 | MinIO (S3 兼容) | 对象存储 |
| 消息队列 | Redis Pub/Sub (轻量) / RabbitMQ (重度) | 服务间异步通信 |
| 日志 | SLF4J + Logback | 结构化日志，输出 JSON 格式便于 K8s 采集 |
| 构建工具 | Maven | 多模块项目管理 |
| 容器化 | Docker + Jib (可选) | 镜像构建 |

**部署与基础设施:**

| 类别 | 选型 | 说明 |
|------|------|------|
| 编排 | Kubernetes | 容器编排和服务管理 |
| 部署配置 | Kustomize | 多环境差异化部署 |
| 本地开发 | Docker Compose + Skaffold | 本地快速启动 |
| 网关 | Spring Cloud Gateway | API 路由、限流、鉴权 |
| 服务发现 | K8s Service DNS | 内建服务发现，无需额外组件 |
| 配置管理 | K8s ConfigMap + Secret | 环境配置注入 |
| 监控 | Prometheus + Grafana (可选) | 指标采集和可视化 |

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

## Docker Compose (本地开发)

```yaml
# docker-compose.yaml (项目根目录)
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: appfactory
      POSTGRES_PASSWORD: devpassword
      POSTGRES_DB: appfactory
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./server/scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data

  gateway:
    build: server/gateway
    ports:
      - "8080:8080"
    depends_on:
      - user-service
      - ws-service
    environment:
      - SPRING_PROFILES_ACTIVE=dev

  user-service:
    build: server/user-service
    ports:
      - "8081:8081"
    depends_on:
      - postgres
      - redis
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/user_db

  ws-service:
    build: server/ws-service
    ports:
      - "8082:8082"
    depends_on:
      - redis
    environment:
      - SPRING_PROFILES_ACTIVE=dev

  file-service:
    build: server/file-service
    ports:
      - "8083:8083"
    depends_on:
      - postgres
      - minio
    environment:
      - SPRING_PROFILES_ACTIVE=dev

  notification-service:
    build: server/notification-service
    ports:
      - "8084:8084"
    depends_on:
      - postgres
      - redis
    environment:
      - SPRING_PROFILES_ACTIVE=dev

volumes:
  postgres_data:
  minio_data:
```
