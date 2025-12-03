import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainerEducationScreen extends StatefulWidget {
  const TrainerEducationScreen({super.key});

  @override
  State<TrainerEducationScreen> createState() => _TrainerEducationScreenState();
}

class _TrainerEducationScreenState extends State<TrainerEducationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background gradient
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA855F7).withValues(alpha: 0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '피트니스 멘탈 코칭',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '교육과정',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Progress Overview Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProgressOverviewCard(context, isDark, colorScheme),
                  ),
                ),

                // Tab Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(4),
                        labelColor: Colors.black,
                        unselectedLabelColor:
                            colorScheme.onSurface.withValues(alpha: 0.6),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        dividerHeight: 0,
                        tabs: const [
                          Tab(text: '진행중'),
                          Tab(text: '완료'),
                          Tab(text: '전체'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildCourseList(context, isDark, colorScheme, 'in_progress'),
                  _buildCourseList(context, isDark, colorScheme, 'completed'),
                  _buildCourseList(context, isDark, colorScheme, 'all'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverviewCard(
      BuildContext context, bool isDark, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFA855F7).withValues(alpha: 0.15),
            const Color(0xFF6366F1).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFA855F7).withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA855F7), Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '전체 진행률',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '3개 과정 중 1개 완료',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 6,
                        color: isDark ? Colors.white10 : Colors.grey[200],
                      ),
                      CircularProgressIndicator(
                        value: 0.33,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.transparent,
                        color: const Color(0xFFA855F7),
                      ),
                      Center(
                        child: Text(
                          '33%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildMiniStat(context, '이수 시간', '24시간', Icons.access_time_rounded),
                const SizedBox(width: 16),
                _buildMiniStat(context, '획득 점수', '850점', Icons.stars_rounded),
                const SizedBox(width: 16),
                _buildMiniStat(context, '다음 갱신', 'D-45', Icons.event_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(
      BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: const Color(0xFFA855F7)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(
      BuildContext context, bool isDark, ColorScheme colorScheme, String filter) {
    final courses = _getCourses(filter);

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < courses.length - 1 ? 16 : 100),
          child: _buildCourseCard(context, isDark, colorScheme, course),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getCourses(String filter) {
    final allCourses = [
      {
        'title': '기초 피트니스 코칭',
        'description': '운동 지도의 기본 원리와 고객 상담 기법',
        'duration': '12시간',
        'lessons': 24,
        'completedLessons': 24,
        'status': 'completed',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFF4ECDC4),
        'blockchainRecorded': true,
      },
      {
        'title': '멘탈 웰니스 코칭',
        'description': '심리상담 기법과 스트레스 관리 프로그램 운영',
        'duration': '16시간',
        'lessons': 32,
        'completedLessons': 18,
        'status': 'in_progress',
        'icon': Icons.psychology_rounded,
        'color': const Color(0xFFA855F7),
        'blockchainRecorded': false,
      },
      {
        'title': '고급 퍼스널 트레이닝',
        'description': '개인 맞춤형 프로그램 설계 및 성과 분석',
        'duration': '20시간',
        'lessons': 40,
        'completedLessons': 0,
        'status': 'not_started',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF4E80EE),
        'blockchainRecorded': false,
      },
    ];

    if (filter == 'in_progress') {
      return allCourses
          .where((c) =>
              c['status'] == 'in_progress' || c['status'] == 'not_started')
          .toList();
    } else if (filter == 'completed') {
      return allCourses.where((c) => c['status'] == 'completed').toList();
    }
    return allCourses;
  }

  Widget _buildCourseCard(BuildContext context, bool isDark,
      ColorScheme colorScheme, Map<String, dynamic> course) {
    final progress = course['completedLessons'] / course['lessons'];
    final isCompleted = course['status'] == 'completed';
    final isRecorded = course['blockchainRecorded'] as bool;

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (course['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        course['icon'] as IconData,
                        color: course['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  course['title'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (isRecorded)
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
                                        Icons.link_rounded,
                                        size: 12,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '블록체인 기록',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course['description'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course['duration'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.menu_book_rounded,
                      size: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course['lessons']}개 레슨',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor:
                              (course['color'] as Color).withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation(
                              course['color'] as Color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${course['completedLessons']}/${course['lessons']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: course['color'] as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: isCompleted
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : course['color'] as Color,
                      foregroundColor:
                          isCompleted ? colorScheme.primary : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isCompleted ? '수료증 보기' : '이어서 학습하기',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
