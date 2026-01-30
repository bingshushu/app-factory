package com.appfactory.user.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserInfo {
    private Long id;
    private String phone;
    private String nickname;
    private String avatarUrl;
    private String status;
    private LocalDateTime createdAt;
}
