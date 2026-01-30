package com.appfactory.user.service;

import com.appfactory.common.exception.AppException;
import com.appfactory.common.exception.AuthException;
import com.appfactory.user.dto.*;
import com.appfactory.user.entity.RefreshToken;
import com.appfactory.user.entity.User;
import com.appfactory.user.entity.VerificationCode;
import com.appfactory.user.repository.RefreshTokenRepository;
import com.appfactory.user.repository.UserRepository;
import com.appfactory.user.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final SmsService smsService;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // 检查手机号是否已注册
        if (userRepository.existsByPhone(request.getPhone())) {
            throw new AppException(400, "手机号已注册");
        }

        // 验证码和密码至少提供一个
        if ((request.getPassword() == null || request.getPassword().isEmpty()) &&
            (request.getVerificationCode() == null || request.getVerificationCode().isEmpty())) {
            throw new AppException(400, "密码和验证码至少提供一个");
        }

        // 如果提供了验证码，进行验证
        if (request.getVerificationCode() != null && !request.getVerificationCode().isEmpty()) {
            boolean verified = smsService.verifyCode(
                    request.getPhone(),
                    request.getVerificationCode(),
                    VerificationCode.CodeType.REGISTER
            );
            if (!verified) {
                throw new AppException(400, "验证码无效或已过期");
            }
        }

        // 创建用户
        User user = User.builder()
                .phone(request.getPhone())
                .passwordHash(request.getPassword() != null ?
                        passwordEncoder.encode(request.getPassword()) : null)
                .nickname(request.getNickname() != null ?
                        request.getNickname() : "用户" + request.getPhone().substring(7))
                .status(User.UserStatus.ACTIVE)
                .build();

        user = userRepository.save(user);

        // 生成 Token
        return generateAuthResponse(user);
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        // 查找用户
        User user = userRepository.findByPhone(request.getPhone())
                .orElseThrow(() -> new AuthException("手机号或密码错误"));

        // 检查用户状态
        if (user.getStatus() != User.UserStatus.ACTIVE) {
            throw new AuthException("账号已被禁用");
        }

        // 验证密码或验证码
        boolean authenticated = false;

        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            // 密码登录
            if (user.getPasswordHash() == null) {
                throw new AuthException("该账号未设置密码，请使用验证码登录");
            }
            authenticated = passwordEncoder.matches(request.getPassword(), user.getPasswordHash());
        } else if (request.getVerificationCode() != null && !request.getVerificationCode().isEmpty()) {
            // 验证码登录
            authenticated = smsService.verifyCode(
                    request.getPhone(),
                    request.getVerificationCode(),
                    VerificationCode.CodeType.LOGIN
            );
        }

        if (!authenticated) {
            throw new AuthException("手机号或密码/验证码错误");
        }

        // 生成 Token
        return generateAuthResponse(user);
    }

    @Transactional
    public AuthResponse refreshToken(String refreshTokenStr) {
        // 验证 refresh token
        if (!jwtUtil.validateToken(refreshTokenStr)) {
            throw new AuthException("刷新令牌无效");
        }

        // 从数据库查找
        RefreshToken refreshToken = refreshTokenRepository.findByToken(refreshTokenStr)
                .orElseThrow(() -> new AuthException("刷新令牌不存在"));

        if (refreshToken.isExpired()) {
            refreshTokenRepository.delete(refreshToken);
            throw new AuthException("刷新令牌已过期");
        }

        // 查找用户
        User user = userRepository.findById(refreshToken.getUserId())
                .orElseThrow(() -> new AuthException("用户不存在"));

        // 删除旧的 refresh token
        refreshTokenRepository.delete(refreshToken);

        // 生成新的 Token
        return generateAuthResponse(user);
    }

    @Transactional
    public void logout(Long userId) {
        refreshTokenRepository.deleteByUserId(userId);
    }

    public UserInfo getCurrentUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AuthException("用户不存在"));

        return mapToUserInfo(user);
    }

    private AuthResponse generateAuthResponse(User user) {
        String accessToken = jwtUtil.generateAccessToken(user.getId(), user.getPhone());
        String refreshTokenStr = jwtUtil.generateRefreshToken(user.getId());

        // 保存 refresh token
        RefreshToken refreshToken = RefreshToken.builder()
                .userId(user.getId())
                .token(refreshTokenStr)
                .expiresAt(LocalDateTime.now().plusSeconds(jwtUtil.getRefreshTokenExpiration() / 1000))
                .build();
        refreshTokenRepository.save(refreshToken);

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshTokenStr)
                .expiresIn(jwtUtil.getAccessTokenExpiration() / 1000)
                .user(mapToUserInfo(user))
                .build();
    }

    private UserInfo mapToUserInfo(User user) {
        return UserInfo.builder()
                .id(user.getId())
                .phone(user.getPhone())
                .nickname(user.getNickname())
                .avatarUrl(user.getAvatarUrl())
                .status(user.getStatus().name())
                .createdAt(user.getCreatedAt())
                .build();
    }

    @Transactional
    public void cleanupExpiredTokens() {
        refreshTokenRepository.deleteByExpiresAtBefore(LocalDateTime.now());
    }
}
