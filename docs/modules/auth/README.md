# 认证模块使用指南

## 概述

已完成手机号+密码和手机号+验证码的注册登录功能，包括：

- ✅ 后端 user-service 微服务（Spring Boot + PostgreSQL + Redis）
- ✅ Flutter 共享数据模型（shared_models）
- ✅ Flutter API 客户端（api_client）
- ✅ Flutter 核心认证逻辑（core）
- ✅ Docker Compose 本地开发环境

## 快速开始

### 1. 安装依赖

```bash
# 在项目根目录
dart pub get

# 或使用 melos
melos bootstrap
```

### 2. 生成代码

```bash
# 生成 Freezed 和 JSON 序列化代码
cd packages/shared_models
dart run build_runner build --delete-conflicting-outputs

# 生成 Riverpod 代码
cd ../api_client
dart run build_runner build --delete-conflicting-outputs

cd ../core
dart run build_runner build --delete-conflicting-outputs
```

### 3. 启动后端服务

```bash
# 构建 Java 项目
cd server
mvn clean package -DskipTests

# 启动 Docker Compose（包含 PostgreSQL、Redis 和 user-service）
cd ..
docker compose up -d
```

等待服务启动完成，可以通过以下命令查看日志：

```bash
docker compose logs -f user-service
```

### 4. 验证服务

访问 Swagger UI 查看 API 文档：
- http://localhost:8081/swagger-ui.html

测试健康检查：
```bash
curl http://localhost:8081/actuator/health
```

## API 端点

### 发送验证码
```bash
POST http://localhost:8081/api/v1/auth/send-code
Content-Type: application/json

{
  "phone": "13800138000",
  "type": "REGISTER"  // 或 "LOGIN"
}
```

### 注册（密码方式）
```bash
POST http://localhost:8081/api/v1/auth/register
Content-Type: application/json

{
  "phone": "13800138000",
  "password": "password123",
  "nickname": "测试用户"
}
```

### 注册（验证码方式）
```bash
POST http://localhost:8081/api/v1/auth/register
Content-Type: application/json

{
  "phone": "13800138000",
  "verificationCode": "123456",
  "nickname": "测试用户"
}
```

### 登录（密码方式）
```bash
POST http://localhost:8081/api/v1/auth/login
Content-Type: application/json

{
  "phone": "13800138000",
  "password": "password123"
}
```

### 登录（验证码方式）
```bash
POST http://localhost:8081/api/v1/auth/login
Content-Type: application/json

{
  "phone": "13800138000",
  "verificationCode": "123456"
}
```

### 获取当前用户信息
```bash
GET http://localhost:8081/api/v1/auth/me
Authorization: Bearer {accessToken}
```

### 刷新令牌
```bash
POST http://localhost:8081/api/v1/auth/refresh
Content-Type: application/json

{
  "refreshToken": "{refreshToken}"
}
```

### 登出
```bash
POST http://localhost:8081/api/v1/auth/logout
Authorization: Bearer {accessToken}
```

## Flutter 使用示例

### 1. 在 App 中添加依赖

```yaml
# apps/your_app/pubspec.yaml
name: your_app
resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  core:
  api_client:
  shared_models:
  flutter_riverpod: ^2.5.0
```

### 2. 初始化 Riverpod

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 3. 使用认证功能

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.login(
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    switch (result) {
      case Success(:final data):
        // 更新认证状态
        ref.read(authStateProvider.notifier).setUser(data.user);
        // 导航到主页
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      case Failure(:final error):
        // 显示错误
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message)),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '手机号'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '密码'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. 验证码登录示例

```dart
Future<void> _sendCode() async {
  final authRepo = ref.read(authRepositoryProvider);
  final result = await authRepo.sendVerificationCode(
    phone: _phoneController.text,
    type: 'LOGIN',
  );

  switch (result) {
    case Success():
      // 显示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已发送')),
      );
    case Failure(:final error):
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
  }
}

Future<void> _loginWithCode() async {
  final authRepo = ref.read(authRepositoryProvider);
  final result = await authRepo.login(
    phone: _phoneController.text,
    verificationCode: _codeController.text,
  );

  // 处理结果...
}
```

## 开发模式说明

### 验证码模拟模式

默认情况下，验证码服务运行在模拟模式（`sms.mock=true`），验证码会打印在后端日志中：

```bash
# 查看验证码
docker compose logs -f user-service | grep "模拟短信"
```

输出示例：
```
【模拟短信】手机号: 13800138000, 验证码: 123456, 类型: REGISTER
```

### 数据库访问

PostgreSQL 连接信息：
- Host: localhost
- Port: 5432
- Database: user_db
- Username: appfactory
- Password: devpassword

```bash
# 使用 psql 连接
psql -h localhost -U appfactory -d user_db

# 查看用户表
SELECT * FROM users;

# 查看验证码表
SELECT * FROM verification_codes ORDER BY created_at DESC LIMIT 10;
```

### Redis 访问

```bash
# 连接 Redis
docker exec -it app-factory-redis redis-cli

# 查看验证码发送频率限制
KEYS sms:rate:*
GET sms:rate:13800138000
```

## 测试

### 后端单元测试

```bash
cd server
mvn test
```

### Flutter 单元测试

```bash
# 测试单个包
cd packages/core
flutter test

# 使用 melos 运行所有测试
melos run test
```

## 故障排查

### 1. 服务无法启动

检查端口占用：
```bash
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis
lsof -i :8081  # user-service
```

### 2. 数据库连接失败

检查 PostgreSQL 是否正常运行：
```bash
docker compose ps postgres
docker compose logs postgres
```

### 3. Flutter 代码生成失败

清理并重新生成：
```bash
cd packages/shared_models
flutter clean
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### 4. Token 认证失败

检查 JWT 密钥配置：
- 确保 `JWT_SECRET` 环境变量已设置
- 密钥长度至少 256 位

## 下一步

1. 创建第一个 Flutter App 并集成认证功能
2. 添加 API Gateway 服务
3. 实现 Token 自动刷新机制
4. 添加生物识别认证支持
5. 对接真实短信服务商

## 架构说明

### 后端架构

```
user-service (8081)
├── Controller: 处理 HTTP 请求
├── Service: 业务逻辑
│   ├── AuthService: 认证逻辑
│   └── SmsService: 验证码发送
├── Repository: 数据访问
├── Entity: JPA 实体
└── Security: JWT 认证过滤器
```

### Flutter 架构

```
packages/
├── shared_models: 数据模型（Freezed）
│   ├── User
│   ├── AuthResponse
│   └── ApiResponse
├── api_client: API 客户端（Dio）
│   ├── ApiClient: HTTP 客户端
│   ├── AuthApi: 认证 API
│   └── AuthInterceptor: Token 注入
└── core: 核心业务逻辑（Riverpod）
    ├── AuthRepository: 认证仓库
    ├── AuthState: 认证状态
    ├── TokenStorage: Token 存储
    └── Result: 结果类型
```

## 安全注意事项

1. **生产环境必须修改 JWT 密钥**：在 `application.properties` 或环境变量中设置强密钥
2. **启用 HTTPS**：生产环境必须使用 HTTPS
3. **对接真实短信服务**：设置 `sms.mock=false` 并实现 `SmsService.sendSmsViaProvider()`
4. **配置 CORS**：根据前端域名配置跨域策略
5. **限流保护**：已实现基于 Redis 的验证码发送频率限制（每小时 5 次）
6. **密码强度**：建议在前端添加密码强度校验

## 许可证

MIT
