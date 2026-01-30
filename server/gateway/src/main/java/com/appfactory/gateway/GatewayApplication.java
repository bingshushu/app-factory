package com.appfactory.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * API Gateway Application
 *
 * 职责：
 * - API 路由和转发
 * - JWT 认证验证
 * - 请求限流
 * - CORS 配置
 * - 统一错误处理
 */
@SpringBootApplication
public class GatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(GatewayApplication.class, args);
    }
}
