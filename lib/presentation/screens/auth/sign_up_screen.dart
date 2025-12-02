import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeAll = false;
  bool _agreeTerms = false;
  bool _agreePrivacy = false;

  void _toggleAll(bool? value) {
    setState(() {
      _agreeAll = value ?? false;
      _agreeTerms = _agreeAll;
      _agreePrivacy = _agreeAll;
    });
  }

  void _updateAgreement() {
    setState(() {
      _agreeAll = _agreeTerms && _agreePrivacy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '회원가입',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline
              Text(
                '핏웰니스에\n오신 것을 환영해요!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SNS 계정으로 간편하게 시작해보세요.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),

              // Social Login Buttons
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: Ink.image(
                  image: const AssetImage(
                      'assets/images/kakao_login_large_wide.png'),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 48,
                  child: InkWell(
                    onTap: () {},
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: const Color(0xFF03C75A),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/images/naver_icon_square.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              '네이버로 시작하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 11),
              Container(
                height: 48, // Match other social buttons
                width: double.infinity, // Match other social buttons
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    hoverColor: Colors.grey[100],
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SvgPicture.asset(
                              'assets/images/Google__G__logo.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              'Google로 시작하기',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는 이메일로 가입하기',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Fields
              _buildTextField(
                context,
                label: '이메일',
                hint: '이메일 주소를 입력해주세요',
                errorText: '사용 중인 이메일입니다.', // Example error state
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context,
                label: '비밀번호',
                hint: '비밀번호를 입력해주세요',
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                helperText: '영문, 숫자, 특수문자 포함 8자 이상',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context,
                label: '비밀번호 확인',
                hint: '비밀번호를 한번 더 입력해주세요',
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                onToggleObscure: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                errorText: '비밀번호가 일치하지 않습니다.', // Example error state
              ),
              const SizedBox(height: 16),
              _buildTextField(context, label: '닉네임', hint: '닉네임을 입력해주세요'),

              // Agreements
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreeAll,
                      onChanged: _toggleAll,
                      activeColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      '전체 동의',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildAgreementItem(
                context,
                label: '이용약관 동의 (필수)',
                value: _agreeTerms,
                onChanged: (v) {
                  setState(() {
                    _agreeTerms = v ?? false;
                    _updateAgreement();
                  });
                },
              ),
              _buildAgreementItem(
                context,
                label: '개인정보처리방침 동의 (필수)',
                value: _agreePrivacy,
                onChanged: (v) {
                  setState(() {
                    _agreePrivacy = v ?? false;
                    _updateAgreement();
                  });
                },
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/profile-setup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '가입하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '이미 계정이 있으신가요? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        '로그인',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    String? errorText,
    String? helperText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText,
              style: TextStyle(color: colorScheme.error, fontSize: 12),
            ),
          ),
        if (helperText != null && errorText == null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              helperText,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAgreementItem(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              '보기',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
