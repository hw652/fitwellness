import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class ProgramSearchScreen extends StatelessWidget {
  const ProgramSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text('코칭 프로그램', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '어떤 코칭을 찾고 계신가요?',
                      hintStyle: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      prefixIcon: Icon(Icons.search,
                          color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip(context, '전체', isActive: true),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '피트니스'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '멘탈케어'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '식단'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '초급'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '중급'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '고급'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '채민님을 위한 추천 프로그램',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              // Grid
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                  children: [
                    _buildProgramCard(
                      context,
                      title: '활기찬 아침을 위한 15분 요가',
                      description: '전신 스트레칭으로 하루를 상쾌하게 시작하세요.',
                      tags: '#15분 #초급 #인기',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuA7Fk0BWOzbqdSH9VdTqsq4LdVOgKYwqiAEScC8EzGGP2JHqO196Z8OS3TWOy--4WZMNQdk5Wtid5ek88_LXh6wwjIg7wWXdSJ_S2DtqQrUpLe1gfivm9f1ylEkgVAcegv9AAUcX-LGdtjsg_YG3SRybAmEXaBs7S76aAjTXeFjUZCOhmq-R_kBPx_anqGEaHESqwjTXxr7vxqB4YYD_IwS6LjC3FB7KF-5TpyLbwbfyj7vsjiK07bE4XFG647xpR-4L5svIngQshQP',
                    ),
                    _buildProgramCard(
                      context,
                      title: '업무 스트레스 해소를 위한 명상',
                      description: '지친 마음을 다독이는 10분 명상 가이드.',
                      tags: '#10분 #마음챙김',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAcmYKjSrApY_sGZjfooeIzMBfkM1MS8ZXrDpSJWPiHMDDqjCbP8ov0w7URGpDan6gymFrqeB7GIV0mKm1qsz3w3kWcYhWcJNlMCeGkQctG9K27ivLkEywCiurgIHw3wHMgYlAwKTxa7KsatQg6FwSivxd_BOkPX1Zo1RvPYb50IM217Zq1IKcjcnvnlvl8NeGmx3WQ96yWwAlIx5yXzs32fdVy6hBYYF2nYwHRdOE6PwYEpYquwDw_rpJz81hYwp8Fqt_y2C--v9xj',
                      isFavorite: true,
                    ),
                    _buildProgramCard(
                      context,
                      title: '코어 강화를 위한 20분 필라테스',
                      description: '매트 위에서 만드는 단단한 중심.',
                      tags: '#20분 #중급 #인기',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDm_BjE80CgooxJHcrfBUh5bqaVrJi-EHErBCmLAk-4IwvfRdgakelOsELMcaa-NKlPhaRlDjp3kuxr-qa37ROwkGyR1ZKb-o079MZ3POMMEr3412hC77v4Kf16YSdy7Y3hEKMfwmWSHvtkDCYr7tXOXed2Axcj5IhVMpfxUG8t30lhP1K-i2lqzn3FC4YXneZ4IR-e74avTWPU_Zm4gYOF-jDxSible1TxLDMD2lSzIdl7pLRgKFIE04MS-Fizou5PxqV1dCDJ3G5i',
                    ),
                    _buildProgramCard(
                      context,
                      title: '건강한 점심 식단 가이드',
                      description: '포만감 가득, 맛있는 샐러드 레시피.',
                      tags: '#식단 #건강',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXbd1MYR9_t000zOBq5sEct8sjhf_GZ9-8a1g-elclwqXiXM69K80WfZOTWMtRVgdOwo4_aGGspBEp96eqbJxFYwKqj9k4qjWqpl4bKvWI_f5XBcobXDnAc8LFj82qYwcBX7IV0hRP_D-L7VLnKg9nbhSHtvx8jVXysjA16pFGF9TuIJ6DV5nWmFCH9zjWtSS5Wc2v-s7aeatzM5b_YZP3MT0DbbHzwHsfs7l_j91gBYrT7833dLVV2H7HaAp7HDlD_C9oUIMz0vgB',
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: appColors?.mint ?? const Color(0xFF13ec80),
              foregroundColor: Colors.black,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('맞춤 추천', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      {bool isActive = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive
            ? (appColors?.mint ?? const Color(0xFF13ec80))
            : (isDark ? Colors.grey[800] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isActive
              ? Colors.black
              : colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProgramCard(
    BuildContext context, {
    required String title,
    required String description,
    required String tags,
    required String imageUrl,
    bool isFavorite = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return GestureDetector(
      onTap: () => context.push('/coaching/program/1'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? (appColors?.mint ?? Colors.green)
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            tags,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}