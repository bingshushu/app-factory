package com.appfactory.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterRequest {

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    @Size(min = 6, max = 20, message = "密码长度必须在6-20位之间")
    private String password;

    @Pattern(regexp = "^\\d{6}$", message = "验证码必须是6位数字")
    private String verificationCode;

    @Size(max = 50, message = "昵称长度不能超过50")
    private String nickname;
}
