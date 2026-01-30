#!/bin/bash

# 测试认证 API 的脚本

BASE_URL="http://localhost:8081/api/v1/auth"
PHONE="13800138000"

echo "🧪 认证模块 API 测试"
echo "===================="
echo ""

# 测试 1: 发送注册验证码
echo "📱 测试 1: 发送注册验证码"
RESPONSE=$(curl -s -X POST "$BASE_URL/send-code" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$PHONE\",\"type\":\"REGISTER\"}")
echo "响应: $RESPONSE"
echo ""

# 提示查看验证码
echo "💡 查看验证码（在另一个终端运行）："
echo "   docker compose logs user-service | grep '模拟短信'"
echo ""
read -p "请输入收到的验证码: " CODE
echo ""

# 测试 2: 使用验证码注册
echo "📝 测试 2: 使用验证码注册"
RESPONSE=$(curl -s -X POST "$BASE_URL/register" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$PHONE\",\"verificationCode\":\"$CODE\",\"nickname\":\"测试用户\"}")
echo "响应: $RESPONSE"
echo ""

# 提取 accessToken
ACCESS_TOKEN=$(echo $RESPONSE | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ 注册失败，无法获取 token"
    exit 1
fi

echo "✅ 注册成功！"
echo "Access Token: ${ACCESS_TOKEN:0:20}..."
echo ""

# 测试 3: 获取当前用户信息
echo "👤 测试 3: 获取当前用户信息"
RESPONSE=$(curl -s -X GET "$BASE_URL/me" \
  -H "Authorization: Bearer $ACCESS_TOKEN")
echo "响应: $RESPONSE"
echo ""

# 测试 4: 登出
echo "🚪 测试 4: 登出"
RESPONSE=$(curl -s -X POST "$BASE_URL/logout" \
  -H "Authorization: Bearer $ACCESS_TOKEN")
echo "响应: $RESPONSE"
echo ""

# 测试 5: 发送登录验证码
echo "📱 测试 5: 发送登录验证码"
RESPONSE=$(curl -s -X POST "$BASE_URL/send-code" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$PHONE\",\"type\":\"LOGIN\"}")
echo "响应: $RESPONSE"
echo ""

read -p "请输入新的验证码: " CODE
echo ""

# 测试 6: 使用验证码登录
echo "🔐 测试 6: 使用验证码登录"
RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$PHONE\",\"verificationCode\":\"$CODE\"}")
echo "响应: $RESPONSE"
echo ""

# 测试 7: 使用密码注册新用户
NEW_PHONE="13900139000"
PASSWORD="password123"

echo "📝 测试 7: 使用密码注册新用户"
RESPONSE=$(curl -s -X POST "$BASE_URL/register" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$NEW_PHONE\",\"password\":\"$PASSWORD\",\"nickname\":\"密码用户\"}")
echo "响应: $RESPONSE"
echo ""

# 测试 8: 使用密码登录
echo "🔐 测试 8: 使用密码登录"
RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$NEW_PHONE\",\"password\":\"$PASSWORD\"}")
echo "响应: $RESPONSE"
echo ""

echo "✅ 所有测试完成！"
