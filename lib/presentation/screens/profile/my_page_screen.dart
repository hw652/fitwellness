import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // 차분하고 고급스러운 웰니스 컬러 팔레트
    final calmGradientStart = isDark ? const Color(0xFF004D40) : const Color(0xFF26A69A); // Teal 800 / 400
    final calmGradientEnd = isDark ? const Color(0xFF00695C) : const Color(0xFF80CBC4);   // Teal 800 / 200
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text('마이 페이지', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [calmGradientStart, calmGradientEnd],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: calmGradientStart.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                    ),
                    child: const CircleAvatar(
                      radius: 34,
                      backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTP5hLKeEXRpP96lyuUOW6wgiMObwnLsc7lMoKNwFapSXLOaeARfVyh5Ncts5VXv6KkEfdNhqj3usXrWQI8g2u0X8uac9yaz_9KQHjDG2tSCZZ6WVX7kd3aXyrbdelbRoXMYZHMIHhQO9di11ZtCde4y5XOzE2sdWETvwFNP7Cn89WAuU-JX4H_ejq5s_omnvdfF3QS3FvC_axnsPFTgmUCSlk0TRpft2fUnlzxqc6XXe29mqqiRCi41mYXK4cd3GsCp1OsfCMRPDw'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '김웰니스',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'wellness.kim@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '프로필 수정',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white.withValues(alpha: 0.7)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section: Account Management
            _buildSectionHeader(context, '계정 관리'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: '개인 정보 수정',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.history,
              title: '내 활동 기록',
              onTap: () => context.push('/profile/activity/1'),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: '로그아웃',
              isDestructive: true,
              onTap: () => context.go('/login'),
            ),
            const SizedBox(height: 32),

            // Section: App Settings
            _buildSectionHeader(context, '앱 설정'),
            const SizedBox(height: 12),
            _buildSwitchItem(
              context,
              icon: Icons.notifications_outlined,
              title: '알림 설정',
              value: true,
              onChanged: (v) {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.language,
              title: '언어 설정',
              trailingText: '한국어',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.dark_mode_outlined,
              title: '화면 설정',
              trailingText: '다크 모드',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Section: Support
            _buildSectionHeader(context, '고객 지원'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.campaign_outlined,
              title: '공지사항',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: '자주 묻는 질문',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.support_agent,
              title: '1:1 문의하기',
              onTap: () {},
            ),

            const SizedBox(height: 40),
            Text(
              '버전 정보 1.0.0',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDestructive
        ? colorScheme.error
        : (isDark ? const Color(0xFF80CBC4) : const Color(0xFF00796B));
    
    final iconBgColor = isDestructive
        ? colorScheme.errorContainer.withValues(alpha: 0.5)
        : (isDark 
            ? const Color(0xFF004D40).withValues(alpha: 0.5) 
            : const Color(0xFFE0F2F1));

    return Material(
      color: isDark ? Colors.grey[900] : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.1 : 0.05),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? colorScheme.error : colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (!isDestructive) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark ? const Color(0xFF80CBC4) : const Color(0xFF00796B);
    final iconBgColor = isDark 
            ? const Color(0xFF004D40).withValues(alpha: 0.5) 
            : const Color(0xFFE0F2F1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.1 : 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF26A69A), // Calm Teal
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}