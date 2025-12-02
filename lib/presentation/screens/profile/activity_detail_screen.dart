import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityId;
  const ActivityDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '내 활동 기록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildNavChip(context, '전체', isActive: true),
                const SizedBox(width: 8),
                _buildNavChip(context, '코칭'),
                const SizedBox(width: 8),
                _buildNavChip(context, '목표 달성'),
                const SizedBox(width: 8),
                _buildNavChip(context, '커뮤니티'),
              ],
            ),
          ),

          // Activity List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildActivityItem(
                  context,
                  icon: Icons.fitness_center,
                  title: '오늘의 하체 집중 코칭 완료',
                  detail: '운동 시간: 50분',
                  date: '2023.10.27',
                  iconColor: appColors?.green ?? colorScheme.primary,
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  context,
                  icon: Icons.emoji_events,
                  title: '주간 챌린지: 5km 달리기 성공',
                  detail: '달성률: 100%',
                  date: '2023.10.26',
                  iconColor: const Color(0xFFFFD700), // Gold for achievement
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  context,
                  icon: Icons.groups,
                  title: '오운완 챌린지 게시글 작성',
                  detail: '좋아요: 25개',
                  date: '2023.10.25',
                  iconColor: Colors.blueAccent,
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  context,
                  icon: Icons.fitness_center,
                  title: '저녁 유산소 코칭 완료',
                  detail: '소모 칼로리: 320kcal',
                  date: '2023.10.24',
                  iconColor: appColors?.green ?? colorScheme.primary,
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  context,
                  icon: Icons.emoji_events,
                  title: '월간 목표: 체중 2kg 감량',
                  detail: '달성률: 85%',
                  date: '2023.10.22',
                  iconColor: const Color(0xFFFFD700),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavChip(BuildContext context, String label,
      {bool isActive = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? Colors.transparent
              : colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String detail,
    required String date,
    required Color iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
            size: 20,
          ),
        ],
      ),
    );
  }
}