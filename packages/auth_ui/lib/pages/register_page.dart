import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/utils/result.dart';
import '../providers/auth_providers.dart';
import 'dart:async';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codeController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _isPasswordMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _codeController.dispose();
    _nicknameController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _sendVerificationCode() async {
    if (_phoneController.text.isEmpty) {
      _showError('请输入手机号');
      return;
    }

    if (!_isValidPhone(_phoneController.text)) {
      _showError('请输入有效的手机号');
      return;
    }

    final result = await ref.read(sendVerificationCodeProvider.notifier).send(
          phone: _phoneController.text,
          type: 'REGISTER',
        );

    result.when(
      success: (_) {
        _startCountdown();
        _showSuccess('验证码已发送');
      },
      failure: (error) {
        _showError(error.message);
      },
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phone = _phoneController.text;
    final nickname = _nicknameController.text.isEmpty
        ? null
        : _nicknameController.text;
    Result<void> result;

    if (_isPasswordMode) {
      final password = _passwordController.text;
      result = await ref.read(registerProvider.notifier).registerWithPassword(
            phone: phone,
            password: password,
            nickname: nickname,
          );
    } else {
      final code = _codeController.text;
      result = await ref.read(registerProvider.notifier).registerWithCode(
            phone: phone,
            code: code,
            nickname: nickname,
          );
    }

    if (!mounted) return;

    result.when(
      success: (_) {
        // 路由会自动跳转到首页
      },
      failure: (error) {
        _showError(error.message);
      },
    );
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerProvider);
    final isLoading = registerState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isLoading
              ? null
              : () {
                  context.go('/login');
                },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo 或标题
                  Icon(
                    Icons.person_add,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '创建账号',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '加入 App Factory',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 注册方式切换
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                              value: true,
                              label: Text('密码注册'),
                              icon: Icon(Icons.lock),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text('验证码注册'),
                              icon: Icon(Icons.sms),
                            ),
                          ],
                          selected: {_isPasswordMode},
                          onSelectionChanged: (Set<bool> newSelection) {
                            setState(() {
                              _isPasswordMode = newSelection.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 手机号输入
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: '手机号',
                      hintText: '请输入手机号',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入手机号';
                      }
                      if (!_isValidPhone(value)) {
                        return '请输入有效的手机号';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 昵称输入（可选）
                  TextFormField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                      labelText: '昵称（可选）',
                      hintText: '请输入昵称',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 密码或验证码输入
                  if (_isPasswordMode) ...[
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: '密码',
                        hintText: '请输入密码（至少6位）',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入密码';
                        }
                        if (value.length < 6) {
                          return '密码至少6位';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: '确认密码',
                        hintText: '请再次输入密码',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请确认密码';
                        }
                        if (value != _passwordController.text) {
                          return '两次输入的密码不一致';
                        }
                        return null;
                      },
                    ),
                  ] else
                    TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '验证码',
                        hintText: '请输入验证码',
                        prefixIcon: const Icon(Icons.sms),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: _countdown > 0 ? null : _sendVerificationCode,
                            child: Text(
                              _countdown > 0 ? '${_countdown}s' : '获取验证码',
                            ),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入验证码';
                        }
                        if (value.length != 6) {
                          return '验证码为6位数字';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 32),

                  // 注册按钮
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleRegister,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('注册'),
                  ),
                  const SizedBox(height: 16),

                  // 登录链接
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('已有账号？'),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.go('/login');
                              },
                        child: const Text('立即登录'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
