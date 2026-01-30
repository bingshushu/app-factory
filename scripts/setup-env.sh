#!/bin/bash

# 设置项目环境变量
# 在运行其他脚本前先 source 此文件

# Java 配置
export JAVA_HOME="/Volumes/Sen/Documents/project/jdk/zulu21"
export PATH="$JAVA_HOME/bin:$PATH"

# Maven 配置（可选）
# export M2_HOME="/path/to/maven"
# export PATH="$M2_HOME/bin:$PATH"

# Flutter 配置（可选）
# export FLUTTER_HOME="/path/to/flutter"
# export PATH="$FLUTTER_HOME/bin:$PATH"

echo "✅ 环境变量已设置"
echo "   JAVA_HOME: $JAVA_HOME"
java -version
