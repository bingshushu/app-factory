package com.appfactory.user.repository;

import com.appfactory.user.entity.VerificationCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface VerificationCodeRepository extends JpaRepository<VerificationCode, Long> {
    Optional<VerificationCode> findTopByPhoneAndTypeAndVerifiedFalseOrderByCreatedAtDesc(
            String phone, VerificationCode.CodeType type);

    long countByPhoneAndCreatedAtAfter(String phone, LocalDateTime after);

    void deleteByExpiresAtBefore(LocalDateTime dateTime);
}
