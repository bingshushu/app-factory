package com.appfactory.common.exception;

public class AuthException extends AppException {
    public AuthException(String message) {
        super(401, message);
    }

    public AuthException(int code, String message) {
        super(code, message);
    }
}
