package com.appfactory.user.config;

import com.appfactory.user.service.AuthService;
import com.appfactory.user.service.SmsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class ScheduledTasks {

    private final AuthService authService;
    private final SmsService smsService;

    @Scheduled(cron = "0 0 * * * *") // 每小时执行一次
    public void cleanupExpiredTokens() {
        log.info("Cleaning up expired tokens");
        authService.cleanupExpiredTokens();
    }

    @Scheduled(cron = "0 0 * * * *") // 每小时执行一次
    public void cleanupExpiredCodes() {
        log.info("Cleaning up expired verification codes");
        smsService.cleanupExpiredCodes();
    }
}
