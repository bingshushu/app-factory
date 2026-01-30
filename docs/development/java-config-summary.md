# Java 环境配置完成

## ✅ 已完成的配置

### 1. 环境变量文件
- ✅ `.env.local` - 本地环境变量配置
- ✅ `scripts/setup-env.sh` - 环境设置脚本

### 2. 启动脚本更新
- ✅ `scripts/start-auth-module.sh` - 已内置 Java 路径配置

### 3. Maven 配置
- ✅ `server/.mvn/maven.config` - Maven 配置文件
- ✅ `server/.mvn/wrapper/maven-wrapper.properties` - Maven Wrapper

### 4. 文档
- ✅ `docs/development/java-setup.md` - Java 环境配置详细说明

### 5. Git 配置
- ✅ `.gitignore` - 忽略本地配置文件

## 📖 使用方式

### 方式 1: 直接运行启动脚本（推荐）

启动脚本已内置 Java 配置，直接运行即可：

```bash
./scripts/start-auth-module.sh
```

脚本会自动：
1. 设置 `JAVA_HOME=/Volumes/Sen/Documents/project/jdk`
2. 显示使用的 Java 版本
3. 继续执行后续步骤

### 方式 2: 手动加载环境变量

如果需要在终端中手动执行命令：

```bash
# 加载环境变量
source .env.local

# 验证配置
java -version
echo $JAVA_HOME

# 然后执行其他命令
cd server
mvn clean package
```

### 方式 3: 使用 setup-env.sh

```bash
# 加载环境并显示信息
source scripts/setup-env.sh

# 然后执行其他命令
mvn -version
```

## 🔧 修改 Java 路径

如果需要使用其他 Java 版本，修改以下文件中的路径：

1. **`.env.local`**
```bash
export JAVA_HOME="/your/java/path"
```

2. **`scripts/setup-env.sh`**
```bash
export JAVA_HOME="/your/java/path"
```

3. **`scripts/start-auth-module.sh`**
```bash
export JAVA_HOME="/your/java/path"
```

## 📝 验证配置

```bash
# 加载环境变量
source .env.local

# 检查 Java 版本
java -version
# 应该显示: java version "21.x.x"

# 检查 JAVA_HOME
echo $JAVA_HOME
# 应该显示: /Volumes/Sen/Documents/project/jdk

# 检查 Maven 使用的 Java
mvn -version
# 应该显示使用 Java 21
```

## 🎯 配置文件说明

| 文件 | 用途 | 是否提交到 Git |
|------|------|----------------|
| `.env.local` | 本地环境变量 | ❌ 不提交（已在 .gitignore） |
| `scripts/setup-env.sh` | 环境设置脚本 | ✅ 提交 |
| `scripts/start-auth-module.sh` | 启动脚本 | ✅ 提交 |
| `server/.mvn/maven.config` | Maven 配置 | ✅ 提交 |

**注意**: `.env.local` 不会提交到 Git，每个开发者可以根据自己的环境配置。

## 📚 相关文档

- [Java 环境配置详细说明](../docs/development/java-setup.md)
- [快速开始](../docs/getting-started/quick-start.md)
- [安装指南](../docs/getting-started/installation.md)

---

**配置完成时间**: 2026-01-30
**Java 路径**: `/Volumes/Sen/Documents/project/jdk`
