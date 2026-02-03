import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/auth/auth_state.dart';
import 'package:auth_ui/auth_ui.dart';
import '../logs/logs_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final logoutState = ref.watch(logoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogsPage(),
                ),
              );
            },
            tooltip: '日志管理',
          ),
          IconButton(
            icon: logoutState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.logout),
            onPressed: logoutState.isLoading
                ? null
                : () async {
                    final result = await ref.read(logoutProvider.notifier).logout();

                    if (!context.mounted) return;

                    result.when(
                      success: (_) {
                        // 路由会自动跳转到登录页
                      },
                      failure: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('登出失败: ${error.message}'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    );
                  },
            tooltip: '登出',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 用户头像
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: user?.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user!.avatarUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              const SizedBox(height: 24),

              // 用户信息卡片
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '用户信息',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.phone,
                        label: '手机号',
                        value: user?.phone ?? '未知',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        icon: Icons.person,
                        label: '昵称',
                        value: user?.nickname ?? '未设置',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        icon: Icons.badge,
                        label: '用户ID',
                        value: user?.id.toString() ?? '未知',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        icon: Icons.info,
                        label: '状态',
                        value: user?.status ?? '未知',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        icon: Icons.calendar_today,
                        label: '注册时间',
                        value: user?.createdAt != null
                            ? _formatDate(user!.createdAt)
                            : '未知',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 欢迎信息
              Text(
                '欢迎来到 App Factory!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '这是一个使用 Flutter + Spring Boot 构建的应用',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
