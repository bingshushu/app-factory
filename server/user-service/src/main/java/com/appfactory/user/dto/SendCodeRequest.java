package com.appfactory.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class SendCodeRequest {

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    @NotBlank(message = "验证码类型不能为空")
    @Pattern(regexp = "^(REGISTER|LOGIN|RESET_PASSWORD)$", message = "验证码类型不正确")
    private String type;
}
