import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class ProfileSbtCompleteScreen extends StatelessWidget {
  const ProfileSbtCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '프로필 SBT 발급 완료',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24), // Top spacing
                        // Verified Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (appColors?.mint ?? Colors.green)
                                .withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.verified_user,
                            size: 32,
                            color: appColors?.freshGreen ?? Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '프로필 SBT가 발급되었습니다',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '김민서 회원님, 반갑습니다!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // SBT Card
                        AspectRatio(
                          aspectRatio: 5 / 8,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  appColors?.mint ?? const Color(0xFFA8E6CF),
                                  appColors?.freshGreen ??
                                      const Color(0xFF30D5C8),
                                  const Color(0xFF34D399),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (appColors?.freshGreen ?? Colors.green)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Card Header
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle_notifications,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'SOULBOUND TOKEN',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // Card Content
                                Text(
                                  'MY PROFILE SBT',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.3),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: ClipOval(
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCcjXcbb4y-Npbe_jVPWkofYRzPrWE8M91Zd9aFbjvFzWFA7IGiA1B7toGhs6TzcykfMLbPmc0-NXr714eeFHHtToHtwaVc_3vUh8b-ho6RmvCyCaVbPg6NJfzprj73UqGaU--sjyVC710xvzpunI7MDxljw2XG6InN4kSa55HJS3EvrmPowRL3XPAGrF_AOICq-_12wrEvq9Gmr0_3_uwiF3mRgQv4O6tv4n1zC89eonTHvYaBPWbiUE5nWce9_G_APNDNg6QcOj3y',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.person,
                                                    color: Colors.white,
                                                    size: 40),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '김민서 회원',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'KIM MIN-SEO',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.0,
                                  ),
                                ),

                                const Spacer(),

                                // Card Footer
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '발급일',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.8),
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          '2024. 08. 15.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'SBT 등급',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.8),
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Bronze',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 32),

                        // Bottom Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => context.go('/home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[900],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '프로필 SBT 상세 정보',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
