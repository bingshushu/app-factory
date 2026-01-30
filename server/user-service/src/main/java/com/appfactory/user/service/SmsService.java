package com.appfactory.user.service;

import com.appfactory.common.exception.AppException;
import com.appfactory.user.entity.VerificationCode;
import com.appfactory.user.repository.VerificationCodeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Random;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class SmsService {

    private final VerificationCodeRepository verificationCodeRepository;
    private final StringRedisTemplate redisTemplate;

    @Value("${sms.mock:true}")
    private boolean mockMode;

    private static final int CODE_LENGTH = 6;
    private static final int CODE_EXPIRATION_MINUTES = 5;
    private static final int MAX_SEND_PER_HOUR = 5;
    private static final String RATE_LIMIT_KEY_PREFIX = "sms:rate:";

    @Transactional
    public void sendVerificationCode(String phone, VerificationCode.CodeType type) {
        // 检查发送频率限制
        checkRateLimit(phone);

        // 生成验证码
        String code = generateCode();

        // 保存到数据库
        VerificationCode verificationCode = VerificationCode.builder()
                .phone(phone)
                .code(code)
                .type(type)
                .expiresAt(LocalDateTime.now().plusMinutes(CODE_EXPIRATION_MINUTES))
                .build();
        verificationCodeRepository.save(verificationCode);

        // 发送短信
        if (mockMode) {
            log.info("【模拟短信】手机号: {}, 验证码: {}, 类型: {}", phone, code, type);
        } else {
            // TODO: 对接真实短信服务商 (阿里云、腾讯云等)
            sendSmsViaProvider(phone, code, type);
        }

        // 记录发送次数
        incrementRateLimit(phone);
    }

    public boolean verifyCode(String phone, String code, VerificationCode.CodeType type) {
        var verificationCodeOpt = verificationCodeRepository
                .findTopByPhoneAndTypeAndVerifiedFalseOrderByCreatedAtDesc(phone, type);

        if (verificationCodeOpt.isEmpty()) {
            return false;
        }

        VerificationCode verificationCode = verificationCodeOpt.get();

        if (verificationCode.isExpired()) {
            return false;
        }

        if (!verificationCode.getCode().equals(code)) {
            return false;
        }

        // 标记为已验证
        verificationCode.setVerified(true);
        verificationCodeRepository.save(verificationCode);

        return true;
    }

    private void checkRateLimit(String phone) {
        String key = RATE_LIMIT_KEY_PREFIX + phone;
        String count = redisTemplate.opsForValue().get(key);

        if (count != null && Integer.parseInt(count) >= MAX_SEND_PER_HOUR) {
            throw new AppException(429, "发送验证码过于频繁，请稍后再试");
        }
    }

    private void incrementRateLimit(String phone) {
        String key = RATE_LIMIT_KEY_PREFIX + phone;
        Long count = redisTemplate.opsForValue().increment(key);

        if (count != null && count == 1) {
            redisTemplate.expire(key, 1, TimeUnit.HOURS);
        }
    }

    private String generateCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < CODE_LENGTH; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }

    private void sendSmsViaProvider(String phone, String code, VerificationCode.CodeType type) {
        // 实际对接短信服务商的逻辑
        log.info("Sending SMS to {} with code {} for type {}", phone, code, type);
    }

    @Transactional
    public void cleanupExpiredCodes() {
        verificationCodeRepository.deleteByExpiresAtBefore(LocalDateTime.now());
    }
}
