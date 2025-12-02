import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  '핏웰니스',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '나를 위한 건강 여정의 시작',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
                const SizedBox(height: 40),
                _buildLabel('이메일 또는 아이디', context),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: '이메일 또는 아이디를 입력하세요',
                    filled: true,
                    fillColor: isDark
                        ? colorScheme.surfaceContainerHighest
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('비밀번호', context),
                const SizedBox(height: 8),
                TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력하세요',
                    filled: true,
                    fillColor: isDark
                        ? colorScheme.surfaceContainerHighest
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ).copyWith(
                    backgroundColor:
                        WidgetStateProperty.resolveWith((states) => null),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          appColors?.freshMint ?? colorScheme.primary,
                          appColors?.freshGreen ?? colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLink('비밀번호 찾기', context),
                    Container(
                      height: 12,
                      width: 1,
                      color: colorScheme.outline.withValues(alpha: 0.4),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color: colorScheme.outline.withValues(alpha: 0.2))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는',
                        style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                            color: colorScheme.outline.withValues(alpha: 0.2))),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'SNS 계정으로 간편 로그인',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7l4i8e5BAX7oOahDFnjQit8m05nhdeVlo3kOHZL9Ujuv50NemAbObXDcgiDa2GUncpr1wXB5OiGiUl9bCvWZT2dBUOKDwLfhy6ezDJ-Az47wZAE-iNiO8GpzZOzVvSvsKPi9EoOrtFl225DwOcG6uag_dBSkVMbwEZQELEp38X94PXz0HqhJ6MswTR0g1WPisVA3hZY2DdkR9yKfEyieSkEge44p_iwT6E76wl7zgy_tzkE6nontvb7NQ27DKvFcLLkx69oyppZTr'),
                    const SizedBox(width: 24),
                    _buildSocialButton(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCyRPXU92kTgPR3ZQjExp2kPTj_m5OGZmiigTtPIVVTe4FIaBr3Q-wqhkmprvQweU_sPIgchtIJmnBelyLhshIEwIIMoosDigEXRckkrpDqAQ8IDt_HEkmgc0X02q4HNCMsfZ7u1M9pX2IUsIlMo5PS93jgUIxCf5zOeSrvLB7ZwYHQuWO2-j2026M4B2XTrAICpHusQhpKUYV8XsxDZz39h4UfvjPZRc6KHXns5jMTqgmyF8vTBM7596luqJKEHnwW5JLJmNA9CtIV'),
                    const SizedBox(width: 24),
                    _buildSocialButton(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDSe0VhqAGUdVJMoUiLxP3NRmZNLBX-rOzrlK_RdQHM4KXpTLS0kqPNR1oOKfhlB-0wRqOolGHCcJvC61zik0aNBJxQ8f6a5trYUV9JpDRwMLN5qxdHJ26OrxLzSr3XQZ-pMwAAkxIn2ZtDJSNARgNbfL1kyTv5iT-_323Xfbqsoury4W3D6K3dInW-wQbHHqrLlTrbjSqWo86D3W3PsS2EQezcWMBLZjjMeNyI1Nj5P8zGwwoiuY-7MqKEVtzZWUKKlvt9oOpeOpLC'),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _buildLink(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildSocialButton(String iconUrl) {
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
          )
        ],
      ),
      child: Image.network(
        iconUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error_outline),
      ),
    );
  }
}
