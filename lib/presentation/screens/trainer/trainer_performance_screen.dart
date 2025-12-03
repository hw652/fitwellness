import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainerPerformanceScreen extends StatelessWidget {
  const TrainerPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background gradient orbs
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4E80EE).withValues(alpha: 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '성과 대시보드',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Current Grade Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildCurrentGradeCard(context, isDark, colorScheme),
                  ),
                ),

                // Performance Metrics Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Text(
                      '성과 지표',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                // Performance Metrics Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildMetricsGrid(context, isDark, colorScheme),
                  ),
                ),

                // Grade Upgrade Progress
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Text(
                      '등급 갱신 조건',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                // Upgrade Requirements
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildUpgradeRequirements(context, isDark, colorScheme),
                  ),
                ),

                // Recent Reviews
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '최근 고객 리뷰',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '더보기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Review List
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: _buildReviewList(context, isDark, colorScheme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentGradeCard(
      BuildContext context, bool isDark, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.2),
            colorScheme.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                // Grade Badge
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Gold',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up_rounded,
                                  size: 12,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '+12%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '현재 등급',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                      Text(
                        '종합 점수 850점',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Next grade progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Platinum 등급까지',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '150점 남음',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 10,
                    backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGradeIndicator('Bronze', false),
                    _buildGradeIndicator('Silver', false),
                    _buildGradeIndicator('Gold', true),
                    _buildGradeIndicator('Platinum', false),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeIndicator(String grade, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFFFFD700) : Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          grade,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? const Color(0xFFFFD700) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(
      BuildContext context, bool isDark, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                isDark,
                colorScheme,
                '고객 만족도',
                '4.8',
                '/5.0',
                Icons.sentiment_very_satisfied_rounded,
                const Color(0xFF4ECDC4),
                0.96,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                context,
                isDark,
                colorScheme,
                '목표 달성률',
                '87',
                '%',
                Icons.track_changes_rounded,
                colorScheme.primary,
                0.87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                isDark,
                colorScheme,
                '총 코칭 세션',
                '156',
                '회',
                Icons.fitness_center_rounded,
                const Color(0xFF4E80EE),
                null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                context,
                isDark,
                colorScheme,
                '재등록률',
                '72',
                '%',
                Icons.refresh_rounded,
                const Color(0xFFA855F7),
                0.72,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    bool isDark,
    ColorScheme colorScheme,
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    double? progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              if (progress != null)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: progress,
                      color: color,
                      backgroundColor: isDark ? Colors.white10 : Colors.grey[200]!,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeRequirements(
      BuildContext context, bool isDark, ColorScheme colorScheme) {
    final requirements = [
      {
        'title': '고객 만족도 4.5 이상 유지',
        'current': 4.8,
        'target': 4.5,
        'unit': '',
        'completed': true,
      },
      {
        'title': '목표 달성률 80% 이상',
        'current': 87.0,
        'target': 80.0,
        'unit': '%',
        'completed': true,
      },
      {
        'title': '월간 코칭 세션 20회 이상',
        'current': 18.0,
        'target': 20.0,
        'unit': '회',
        'completed': false,
      },
      {
        'title': '추가 교육과정 1개 이수',
        'current': 0.0,
        'target': 1.0,
        'unit': '개',
        'completed': false,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: requirements.asMap().entries.map((entry) {
            final index = entry.key;
            final req = entry.value;
            final isCompleted = req['completed'] as bool;
            final progress = (req['current'] as double) / (req['target'] as double);

            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < requirements.length - 1 ? 16 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? colorScheme.primary
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCompleted
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.black,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          req['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted
                                ? colorScheme.onSurface.withValues(alpha: 0.5)
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        '${(req['current'] as double).toStringAsFixed(req['unit'] == '' ? 1 : 0)}/${(req['target'] as double).toStringAsFixed(req['unit'] == '' ? 1 : 0)}${req['unit']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? colorScheme.primary
                              : const Color(0xFFFFA500),
                        ),
                      ),
                    ],
                  ),
                  if (!isCompleted) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor:
                              const Color(0xFFFFA500).withValues(alpha: 0.15),
                          valueColor:
                              const AlwaysStoppedAnimation(Color(0xFFFFA500)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviewList(
      BuildContext context, bool isDark, ColorScheme colorScheme) {
    final reviews = [
      {
        'name': '김민준',
        'rating': 5,
        'comment': '정말 친절하고 전문적인 코칭이었습니다. 덕분에 목표 체중 달성!',
        'date': '2024.01.12',
        'avatar':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAg7r0CsvTHud-SJqQGco8xQWWdjtklkSED7ZQkhaA9Zvuqt2QPRHjLdQwaF-3JhcL-BgK6Am0L0TPMb9Yga8mREhnixgq1ZMqcVhdCnOdRHY02E8zPN5LRrFkacWCNIDqJIIOlOO4Ftd9YRMKmrl4aIZrGVr6nxz3KwurJqpHAGplN3cm9AWWvzV4P8Dh3j_WUJzxPSPIfzRAaE_SMTiBWV6VDLQ1DFQ9OpTG7oyJlpQBXpsoQP_SoQeqAOkYkR352PaKRjO6PiVsg',
      },
      {
        'name': '이지은',
        'rating': 5,
        'comment': '멘탈 코칭 프로그램이 정말 도움이 많이 됐어요. 스트레스 관리가 쉬워졌습니다.',
        'date': '2024.01.10',
        'avatar':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBT96tF0K47rMOjDgzYnnmSk3nVK-xEHdNdSJP1zNSlwEtjPdZHyW8uMvqqQsShqLfBUoxVsWEGjYt4iSR_RlgDSIoVqqaNT8cx73lbh6_OnpRzKQlvErAXxPWO5qoxOM2rtt2kaXUcZjx_jmaneWSVmzFKN6uffVvK1ZBnquMnKo2I50NeXkiIO0xqeQpqRQMwd_NMOgoAFB57b__jhxOXAkIOaT9gKR18BgPLuG_2aTpvy522mrkKZv9-sLAN8VOSCHrQSHf6KqPD',
      },
      {
        'name': '박준혁',
        'rating': 4,
        'comment': '체계적인 프로그램과 꼼꼼한 피드백이 좋았습니다.',
        'date': '2024.01.08',
        'avatar':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCANvsRYS6NeaHEFhV3y5QU_VANMX6q6pc6yDrHjtKWCnV8Zm1vWosLFMnuNqqOAtzq9Hh-PhNSlIMQv57bEXGkhcaGNIkp6weIalrkItKGkYKZ8yHKunnTyEsEqCC-G4tmvG62MoHYWKbSmQKkAWml6_aUJ1zaYs-kWMLx_UR7FaB5eapsrU5aRHJTBhm0-fEq_yGXW7k47d2ankvm3VEN837PX7xqFztUp0JE983kR3S7lfkOP0OrIBrI-33RRsJ_vEyxJzxPdS6_',
      },
    ];

    return Column(
      children: reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(review['avatar'] as String),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: index < (review['rating'] as int)
                                    ? const Color(0xFFFFD700)
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review['comment'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
