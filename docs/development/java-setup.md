# Java 环境配置说明

本项目使用指定的 Java 路径：`/Volumes/Sen/Documents/project/jdk`

## 配置方式

### 方式 1: 使用环境变量文件（推荐）

在项目根目录创建 `.env.local` 文件（已创建）：

```bash
export JAVA_HOME="/Volumes/Sen/Documents/project/jdk"
export PATH="$JAVA_HOME/bin:$PATH"
```

使用前先加载环境变量：
```bash
source .env.local
```

### 方式 2: 使用 setup-env.sh 脚本

```bash
source scripts/setup-env.sh
```

### 方式 3: 在启动脚本中自动配置

`scripts/start-auth-module.sh` 已经内置了 Java 路径配置，直接运行即可：

```bash
./scripts/start-auth-module.sh
```

## 验证 Java 配置

```bash
# 加载环境变量
source .env.local

# 验证 Java 版本
java -version
echo $JAVA_HOME

# 验证 Maven 使用的 Java
mvn -version
```

## 修改 Java 路径

如果需要使用其他 Java 版本，修改以下文件：

1. `.env.local` - 环境变量配置
2. `scripts/setup-env.sh` - 环境设置脚本
3. `scripts/start-auth-module.sh` - 启动脚本中的 JAVA_HOME

将 `/Volumes/Sen/Documents/project/jdk` 替换为你的 Java 路径。

## IDE 配置

### IntelliJ IDEA

1. 打开 `Preferences` > `Build, Execution, Deployment` > `Build Tools` > `Maven`
2. 设置 `Maven home directory`
3. 在 `Runner` 中设置环境变量：
   ```
   JAVA_HOME=/Volumes/Sen/Documents/project/jdk
   ```

### VS Code

在 `.vscode/settings.json` 中添加：

```json
{
  "java.configuration.runtimes": [
    {
      "name": "JavaSE-21",
      "path": "/Volumes/Sen/Documents/project/jdk",
      "default": true
    }
  ],
  "maven.terminal.customEnv": [
    {
      "environmentVariable": "JAVA_HOME",
      "value": "/Volumes/Sen/Documents/project/jdk"
    }
  ]
}
```

## Docker 构建

Docker 构建不受本地 Java 配置影响，因为它使用容器内的 Java 环境。

## 故障排查

### Maven 使用了错误的 Java 版本

```bash
# 检查 Maven 使用的 Java
mvn -version

# 如果不正确，确保已加载环境变量
source .env.local
mvn -version
```

### 编译错误：不支持的 Java 版本

确保 Java 版本为 21+：

```bash
java -version
# 应该显示 java version "21.x.x"
```

如果版本不对，检查 JAVA_HOME 是否正确设置。
