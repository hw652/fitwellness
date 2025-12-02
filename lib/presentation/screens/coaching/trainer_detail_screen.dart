import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class TrainerDetailScreen extends StatelessWidget {
  final String trainerId;
  const TrainerDetailScreen({super.key, required this.trainerId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F2C58), Color(0xFF0A1024)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark_border,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          Positioned.fill(
            top: 80, // Start below the AppBar area
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Image (Centered)
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.black : Colors.white,
                          width: 4,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuA8xJSd66cOF6PDpOTYMB0PjfTSBvo0bcSoOdmVVOX_1r6PZoXzMU-FvhA6d1owx47VgpSesMbEWSZUpLDzvqG-HAGAAw8zO5oEYxAUgWGVwBHS2pxAwM0FETaUAQrdLJ1d29s17vedVI-Bj7CwdozwsdtKl2VKincJFFw1_lJ_0FoqjCmWnFA1qVjYIL6O7kOOkliuJ4mrBJTSbCeKHtU_3qrOSDTBpFETBYgQ-M_Owe5hCAcQiqtlqNSixNzx_8lFzR7GhzVKFMTK',
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name & Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '김민준 트레이너',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SBT Pro',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '마음까지 케어하는 멘탈 코치',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // White Content Area
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Tabs
                        DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                labelPadding: EdgeInsets.zero, // Reduce padding to fit long text
                                labelColor: colorScheme.onSurface,
                                unselectedLabelColor: colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                indicatorColor:
                                    appColors?.freshMint ?? Colors.green,
                                indicatorWeight: 3,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                tabs: const [
                                  Tab(text: '프로필'),
                                  Tab(text: '코칭 성과'),
                                  Tab(text: '고객 리뷰 (125)'),
                                ],
                              ),
                              SizedBox(
                                height:
                                    650, // Increased height to prevent overflow
                                child: TabBarView(
                                  children: [
                                    // Profile Tab
                                    Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSectionTitle(context, '코칭 철학'),
                                          const SizedBox(height: 12),
                                          Text(
                                            '"단순히 몸을 만드는 것을 넘어, 운동을 통해 긍정적인 마음과 건강한 삶의 습관을 만들어 드립니다. 과학적인 지식과 따뜻한 공감으로 당신의 변화 여정에 함께하겠습니다."',
                                            style: TextStyle(
                                              height: 1.6,
                                              fontSize: 14,
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.7),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 32),

                                          _buildSectionTitle(context, '전문 분야'),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              _buildChip(
                                                context,
                                                '#멘탈 케어',
                                                isPrimary: true,
                                              ),
                                              _buildChip(
                                                context,
                                                '#다이어트',
                                                isPrimary: true,
                                              ),
                                              _buildChip(context, '#체형 교정'),
                                              _buildChip(context, '#바디프로필'),
                                            ],
                                          ),
                                          const SizedBox(height: 32),

                                          _buildSectionTitle(
                                            context,
                                            '자격증 및 경력',
                                          ),
                                          const SizedBox(height: 12),
                                          _buildCertItem(
                                            context,
                                            'SBT (Fitness Mental Coaching) Pro',
                                          ),
                                          _buildCertItem(
                                            context,
                                            '생활체육지도사 2급 (보디빌딩)',
                                          ),
                                          _buildCertItem(
                                            context,
                                            'XX 대학교 체육학과 졸업',
                                          ),
                                          _buildCertItem(
                                            context,
                                            '전) YM 피트니스 트레이너 (5년)',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Center(child: Text('코칭 성과 준비중')),
                                    const Center(child: Text('고객 리뷰 준비중')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30), // Space for bottom button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  16,
                ), // Added bottom padding
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Go to payment or apply flow
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: (appColors?.freshMint ?? Colors.teal)
                          .withValues(alpha: 0.4),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            appColors?.freshMint ?? const Color(0xFF84fab0),
                            appColors?.freshGreen ?? const Color(0xFF8fd3f4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '코칭 신청하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label, {
    bool isPrimary = false,
  }) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: [
                  appColors?.freshMint ?? const Color(0xFF84fab0),
                  appColors?.freshGreen ?? const Color(0xFF8fd3f4),
                ],
              )
            : null,
        color: isPrimary
            ? null
            : (isDark ? Colors.grey[800] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary
              ? Colors.white
              : (isDark ? Colors.grey[300] : Colors.grey[700]),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCertItem(BuildContext context, String text) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified,
            size: 20,
            color: appColors?.freshGreen ?? Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
