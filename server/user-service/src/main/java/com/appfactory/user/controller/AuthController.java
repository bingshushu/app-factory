package com.appfactory.user.controller;

import com.appfactory.common.dto.ApiResponse;
import com.appfactory.user.dto.*;
import com.appfactory.user.entity.VerificationCode;
import com.appfactory.user.service.AuthService;
import com.appfactory.user.service.SmsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "认证接口", description = "用户注册、登录、登出等认证相关接口")
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final SmsService smsService;

    @Operation(summary = "发送验证码")
    @PostMapping("/send-code")
    public ApiResponse<Void> sendCode(@Valid @RequestBody SendCodeRequest request) {
        VerificationCode.CodeType type = VerificationCode.CodeType.valueOf(request.getType());
        smsService.sendVerificationCode(request.getPhone(), type);
        return ApiResponse.success("验证码已发送", null);
    }

    @Operation(summary = "用户注册")
    @PostMapping("/register")
    public ApiResponse<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ApiResponse.success(response);
    }

    @Operation(summary = "用户登录")
    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ApiResponse.success(response);
    }

    @Operation(summary = "刷新访问令牌")
    @PostMapping("/refresh")
    public ApiResponse<AuthResponse> refresh(@Valid @RequestBody RefreshTokenRequest request) {
        AuthResponse response = authService.refreshToken(request.getRefreshToken());
        return ApiResponse.success(response);
    }

    @Operation(summary = "用户登出")
    @PostMapping("/logout")
    public ApiResponse<Void> logout(@RequestAttribute("userId") Long userId) {
        authService.logout(userId);
        return ApiResponse.success("登出成功", null);
    }

    @Operation(summary = "获取当前用户信息")
    @GetMapping("/me")
    public ApiResponse<UserInfo> getCurrentUser(@RequestAttribute("userId") Long userId) {
        UserInfo userInfo = authService.getCurrentUser(userId);
        return ApiResponse.success(userInfo);
    }
}
