import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('웰니스 프로필 생성',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '프로필 생성 (1/4)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.25,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              appColors?.mint ?? const Color(0xFFA8E6CF),
                              appColors?.freshGreen ?? const Color(0xFF30D5C8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text(
                    '나의 웰니스\n프로필 만들기',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '정확한 맞춤 코칭을 위해 아래 정보를 입력해주세요.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Psychology Profile
                  _buildSectionHeader(
                    context,
                    icon: Icons.psychology,
                    title: '심리 프로필',
                  ),
                  const SizedBox(height: 16),
                  _buildInputGroup(
                    context,
                    label: 'TCI 검사 결과',
                    hint: '결과를 입력해주세요',
                    showHelp: true,
                  ),
                  const SizedBox(height: 16),
                  _buildInputGroup(
                    context,
                    label: 'SRI 검사 결과',
                    hint: '결과를 입력해주세요',
                    showHelp: true,
                  ),

                  const SizedBox(height: 24),

                  // Physical Profile
                  _buildSectionHeader(
                    context,
                    icon: Icons.fitness_center,
                    title: '신체 프로필',
                  ),
                  const SizedBox(height: 16),
                  _buildInputGroup(
                    context,
                    label: '키',
                    hint: '예: 165',
                    suffix: 'cm',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildInputGroup(
                    context,
                    label: '현재 체중',
                    hint: '예: 55',
                    suffix: 'kg',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildInputGroup(
                    context,
                    label: '목표 체중',
                    hint: '예: 50',
                    suffix: 'kg',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.lock_outline,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text(
                        '입력된 정보는 코칭 목적으로만 안전하게 사용됩니다.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Bottom padding for scroll
                ],
              ),
            ),
          ), // This is the end of Expanded. Add a comma here.
          Container(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0),
                ],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/profile-upload'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: (appColors?.freshGreen ?? Colors.cyan)
                      .withValues(alpha: 0.3),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appColors?.mint ?? const Color(0xFFA8E6CF),
                        appColors?.freshGreen ?? const Color(0xFF30D5C8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '나의 SBT 발급 시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon, required String title}) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (appColors?.mint ?? Colors.green).withValues(alpha: 0.2),
                (appColors?.freshGreen ?? Colors.teal).withValues(alpha: 0.2),
              ],
            ),
          ),
          child: Icon(
            icon,
            color: appColors?.freshGreen ?? colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildInputGroup(
    BuildContext context,
    {
    required String label,
    required String hint,
    String? suffix,
    bool showHelp = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (showHelp) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.help_outline,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appColors?.freshGreen ?? colorScheme.primary,
                  width: 1.5,
                ),
              ),
              suffixIcon: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        suffix,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}