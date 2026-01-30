# 安装指南

本指南将帮助你设置 App Factory 的开发环境。

## 系统要求

- macOS 10.15+ / Linux / Windows 10+
- 至少 8GB RAM
- 至少 20GB 可用磁盘空间

## 必需工具

### 1. Docker Desktop

#### macOS
```bash
# 使用 Homebrew
brew install --cask docker

# 或从官网下载
# https://www.docker.com/products/docker-desktop
```

#### Linux
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 添加当前用户到 docker 组
sudo usermod -aG docker $USER
```

验证安装：
```bash
docker --version
docker compose version
```

### 2. Java 21

#### macOS
```bash
# 使用 Homebrew
brew install openjdk@21

# 设置环境变量
echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-21-jdk

# 或使用 SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21-open
```

验证安装：
```bash
java -version
```

### 3. Maven

#### macOS
```bash
brew install maven
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt install maven

# 或使用 SDKMAN
sdk install maven
```

验证安装：
```bash
mvn -version
```

### 4. Flutter SDK

#### macOS
```bash
# 下载 Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# 添加到 PATH
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 运行 flutter doctor
flutter doctor
```

#### Linux
```bash
# 下载 Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# 添加到 PATH
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 运行 flutter doctor
flutter doctor
```

验证安装：
```bash
flutter --version
dart --version
```

### 5. IDE（可选但推荐）

#### VS Code
```bash
# macOS
brew install --cask visual-studio-code

# 安装扩展
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
```

#### IntelliJ IDEA / Android Studio
- 下载并安装 [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- 安装 Flutter 和 Dart 插件

## 克隆项目

```bash
git clone <repository-url> app-factory
cd app-factory
```

## 安装项目依赖

### Flutter 依赖
```bash
# 在项目根目录
dart pub get

# 或使用 melos
dart pub global activate melos
melos bootstrap
```

### 生成代码
```bash
# 生成所有包的代码
cd packages/shared_models
dart run build_runner build --delete-conflicting-outputs

cd ../api_client
dart run build_runner build --delete-conflicting-outputs

cd ../core
dart run build_runner build --delete-conflicting-outputs
```

### Java 依赖
```bash
cd server
mvn clean install
```

## 验证安装

运行以下命令确保所有工具正常工作：

```bash
# 检查 Docker
docker run hello-world

# 检查 Java
java -version

# 检查 Maven
mvn -version

# 检查 Flutter
flutter doctor -v

# 检查 Dart
dart --version
```

## 配置开发环境

### 1. 配置 Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. 配置 IDE

#### VS Code
创建 `.vscode/settings.json`：
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

#### IntelliJ IDEA
1. 打开 Preferences
2. 搜索 "Flutter"
3. 设置 Flutter SDK 路径
4. 启用 "Format on save"

## 下一步

安装完成后，继续阅读 [快速开始](quick-start.md) 启动项目。

## 常见问题

### Flutter doctor 显示错误

```bash
# 接受 Android licenses
flutter doctor --android-licenses

# 安装缺失的依赖
flutter doctor
```

### Maven 下载依赖慢

配置国内镜像（`~/.m2/settings.xml`）：
```xml
<mirrors>
  <mirror>
    <id>aliyun</id>
    <mirrorOf>central</mirrorOf>
    <url>https://maven.aliyun.com/repository/public</url>
  </mirror>
</mirrors>
```

### Docker 权限问题（Linux）

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## 获取帮助

- 查看 [快速开始](quick-start.md)
- 查看 [文档索引](../README.md)
- 查看项目 [CLAUDE.md](../../CLAUDE.md)
