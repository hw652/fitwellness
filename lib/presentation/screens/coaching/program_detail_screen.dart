import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class ProgramDetailScreen extends StatelessWidget {
  final String programId;
  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      body: Stack(
        children: [
          DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: colorScheme.surface,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share, size: 20),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCHfrOsU-7-pogRUocmMNOupyc7QBKKB1kVJlUqDGdLifk9uwDa3rLfjhvTsgJ_RUFXtQ7c1E7voXtfjcBhdoRAs5wgnV4TRb4yO7EKzlLOujltMqAyIZMxPaPU3nkbzj2nTbTbvYWY6GOKbrqiWfSp2BAhPG5X11QAaTPHThEVWvEtJqF1DCPCzkDx0m1r1_8gY8FKc7TI89mC4c1783S08jXs8X-UOK03PTpSmuVlvhIW4_4qJFblh9AYr_mkRrAw4fIQcK8P9k-D',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chips
                          Row(
                            children: [
                              _buildChip(context, '#오운완'),
                              const SizedBox(width: 8),
                              _buildChip(context, '#초급자용'),
                              const SizedBox(width: 8),
                              _buildChip(context, '#15분'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Title
                          Text(
                            '전신 불태우기 챌린지',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          // Trainer Info
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDf0oGcFRJpeKngDGsfd4ceqcuCT3fA7CTEE5nFhHiOpBVET7Rb6wnsMfBqHCZZJupy4YHHdCokl9n1rhlNhTPDiLgYJ0PVI4-zmwfn1X3xEF0cBFmbRLGCd13rkjk3g422VZygziuFHziPVmlrLauyaye3i9dFZ1Cdst6W4RQeZdSO2rcLbf8ERkquds-vAGkuK1_QVdNnPLu-LSokB33zioOtrAetHmzPUfU8VZ8bgd-GxhtH20Sqa5F6okqr4gnhFtueTUiRJuMg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Jane Doe 트레이너',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.8 (215 리뷰)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        labelColor: appColors?.green ?? Colors.green,
                        unselectedLabelColor: colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                        indicatorColor: appColors?.green ?? Colors.green,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: '프로그램 소개'),
                          Tab(text: '상세 루틴'),
                          Tab(text: '준비물'),
                        ],
                      ),
                      colorScheme.surface,
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  // Tab 1: Intro
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Grid
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildStatRow(
                                context,
                                Icons.flag,
                                '목표',
                                '단기간 체지방 감량 및 근력 향상',
                              ),
                              const SizedBox(height: 16),
                              _buildStatRow(
                                context,
                                Icons.signal_cellular_alt,
                                '난이도',
                                '초급자 ~ 중급자',
                              ),
                              const SizedBox(height: 16),
                              _buildStatRow(
                                context,
                                Icons.timer,
                                '예상 소요 시간',
                                '하루 15분, 주 3회',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Description
                        Text(
                          '어떤 프로그램인가요?',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "바쁜 일상 속 짧은 시간 투자로 최대의 효과를! '전신 불태우기 챌린지'는 15분이라는 짧은 시간 안에 전신 근육을 자극하고 심박수를 높여 체지방 연소를 극대화하는 고강도 인터벌 트레이닝(HIIT) 프로그램입니다. 운동 초보자도 쉽게 따라할 수 있는 동작들로 구성되어 있습니다.",
                          style: TextStyle(
                            height: 1.6,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Routine Preview
                        Text(
                          '상세 루틴 미리보기',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildRoutineItem(
                          context,
                          '1. 점핑 잭',
                          '1분',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuA3cYjHCw_Xy1cZqYRJ8uEbP1sX-_7UoCcVd2CZzNpU9GQXnFFkCdfHFV88wijPpmijDNnlE5N-T3VXrjaU6v9YBccLiF3w5drmhMNmyOfYPgZgCOtQdnz81QO7ZBYN_RLy5MRIo8XLO_MeWgs-CmNvVSOMzGKn7lZJqd7o6PdUz7kdurz4sE6jCtzBXkd3kW4oI3Nl4pBl8kEPzcyxV3d6aE8-IacZiAkkP_dA4gai_KLEE8esyN38bQQ1a_z-l-ehHtAQ5jxKNq_b',
                        ),
                        const SizedBox(height: 12),
                        _buildRoutineItem(
                          context,
                          '2. 스쿼트',
                          '15회',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBQmX707uentpGAr4C8BjJhj4sz8hwOvMZggSaM9SqXuZPSv-JlZk2RP0b-31Jr_zNlGHUvfly5nKPk_qAnwZ7vIYbM_BvFzOoUKYNc62ZHkYxDW-xkTniBX5YTMWAW1kydxpW85aSdSC3FR5uCn3_EjM_gHBN_c-BrafSA6y4uLBBwDnGEkwwYpg4UpbNxpVrVuCDdj3Z3posPhEl5nfYFkTF3cS8jqv0b7n_NPAdrSZEOazx1yiSpU_OTz_Wt0T5oPfHYJeW0iKlE',
                        ),
                        const SizedBox(height: 12),
                        _buildRoutineItem(
                          context,
                          '3. 푸시업',
                          '10회',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDeByvIEjhZ1mNGb1WARCSShZyku1-w9CRB2QVwXlRQy_aCKcH4g_VbwjxDKbmch2E3CxQ2VU-m3UajhcLZaj5oSwTYQ7S3kLverJEOMzvV4CIO6zAfjWNr_VVHHIvUl6UMPAtx9yWk2Turm1kwTPYniY6HiiWZ2Zr1QT5rL7KsRRymOwD8pl4wsZS9yyITSLRjZnM8oxRqlspbpIMkRMp_Uo_ihPc1cKheU05Agsyj27ThdV6B2ioK7Cfijx-Y_PyO9Yw-cTo5dg_B',
                        ),

                        const SizedBox(height: 32),

                        // Trainer Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '트레이너 소개',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAtEggy1Rejp6k5uFy4rkrtec5cbajS7mXndbs3g5-GEp4VFo3Dk-2VIF3yMAcYCh9rJyvOKHwSmyxacC9dgYy_Dgk-IFo2rM-xAauWLXU9sDwrVX5WFozQho6xK7ibv8E7cdwMNZBeNFgiD3hJpY-xdBqp-uCUqy7o002KO-0dhVKskGy2zbouOljjICD7YNHdAoMLSECrbIcPNCwbO8U9e6dxn3PTWVSLP85ZV-4jYqLT_Gvop-wZv9Ew9Gj-l3LG20NWB7ZHv-Vb',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Jane Doe',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'NASM 인증 퍼스널 트레이너',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            '다른 프로그램 보기 >',
                                            style: TextStyle(
                                              color:
                                                  appColors?.green ??
                                                  Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120), // Space for bottom button
                      ],
                    ),
                  ),
                  // Tab 2 & 3 (Placeholders)
                  const Center(child: Text('상세 루틴 준비중')),
                  const Center(child: Text('준비물 리스트')),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: true,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20,
                ), // Reduced bottom padding as SafeArea handles it
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
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.push('/coaching/progress/$programId'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: (appColors?.mint ?? Colors.teal).withValues(
                        alpha: 0.4,
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            appColors?.mint ?? const Color(0xFF69F0AE),
                            appColors?.green ?? const Color(0xFF00E676),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '코칭 시작하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Contrast text
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

  Widget _buildChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineItem(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _backgroundColor;

  _SliverAppBarDelegate(this._tabBar, this._backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: _backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
