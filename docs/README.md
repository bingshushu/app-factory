# App Factory 文档索引

本目录包含 App Factory 项目的所有文档。

## 📚 文档结构

```
docs/
├── README.md                    # 本文件，文档索引
├── getting-started/             # 快速开始指南
│   ├── installation.md          # 安装指南
│   └── quick-start.md           # 快速开始
├── architecture/                # 架构文档
│   ├── overview.md              # 架构概览
│   ├── backend.md               # 后端架构
│   └── frontend.md              # 前端架构
├── modules/                     # 模块文档
│   └── auth/                    # 认证模块
│       ├── README.md            # 认证模块概览
│       ├── api.md               # API 文档
│       └── implementation.md    # 实现细节
├── development/                 # 开发指南
│   ├── coding-standards.md      # 编码规范
│   ├── testing.md               # 测试指南
│   ├── deployment.md            # 部署指南
│   ├── java-setup.md            # Java 环境配置
│   └── java-config-summary.md   # Java 配置总结
└── api/                         # API 参考
    └── rest-api.md              # REST API 文档
```

## 🚀 快速导航

### 新手入门
- [安装指南](getting-started/installation.md) - 如何设置开发环境
- [快速开始](getting-started/quick-start.md) - 5 分钟快速体验

### 架构文档
- [架构概览](architecture/overview.md) - 系统整体架构
- [后端架构](architecture/backend.md) - 微服务架构详解
- [前端架构](architecture/frontend.md) - Flutter Monorepo 架构

### 模块文档
- [认证模块](modules/auth/README.md) - 注册、登录、JWT 认证

### 开发指南
- [编码规范](development/coding-standards.md) - 代码风格和最佳实践
- [测试指南](development/testing.md) - 单元测试、集成测试
- [部署指南](development/deployment.md) - Docker、Kubernetes 部署

### API 参考
- [REST API](api/rest-api.md) - 完整的 API 接口文档

## 📖 推荐阅读顺序

### 第一次使用
1. [安装指南](getting-started/installation.md)
2. [快速开始](getting-started/quick-start.md)
3. [认证模块](modules/auth/README.md)

### 深入了解
1. [架构概览](architecture/overview.md)
2. [后端架构](architecture/backend.md)
3. [前端架构](architecture/frontend.md)

### 开始开发
1. [编码规范](development/coding-standards.md)
2. [测试指南](development/testing.md)
3. [API 参考](api/rest-api.md)

## 🔗 相关资源

- [项目根目录 README](../README.md)
- [CLAUDE.md](../CLAUDE.md) - Claude Code 项目指南
- [脚本工具](../scripts/) - 开发和测试脚本

## 📝 文档贡献

欢迎贡献文档！请遵循以下规范：

1. 使用 Markdown 格式
2. 文件名使用小写和连字符（kebab-case）
3. 添加清晰的标题和目录
4. 包含代码示例和截图
5. 更新本索引文件

## 📅 更新日志

- 2026-01-30: 创建文档结构，添加认证模块文档
