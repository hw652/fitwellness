import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.3],
            colors: [
              (appColors?.mint ?? const Color(0xFF30e89c))
                  .withValues(alpha: 0.15),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: colorScheme.onSurface),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        '커뮤니티',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: colorScheme.onSurface),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip(context, '전체', isActive: true),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '운동일지'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '식단공유'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '질문있어요'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '자유글'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '트레이너 피드백'),
                  ],
                ),
              ),

              // Feed List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildFeedItem(
                        context,
                        username: '운동매니아',
                        timeAgo: '5분 전',
                        profileImage:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCNAD1uHqmyTGJdLZKsLyLAYBPEzYe9R_yigBzwSfLjl1KV0s1ZUDYL2_Tim0ow06-fHsq1Nau-opYOrAsyd60hnMdFtEY3vbEh12vUIWZYq5fwa5MtE_4uDq5sQ7l35j_Mbg4hbaCF8JszMUG38x6p4vDYEMma7p5uQ_3r7z9hc7TOBt1Xv-nvG04MwlGeTJ_R2odoJ1zo4Dy6o6FBWG7baEjp4aGqgWNVK0Wnc_C1Gauv91OiwQzIr5MamxmfyKEOgNSyQP-mqZOU',
                        tag: '#운동일지',
                        content: '오늘 오운완! 하체 운동 루틴 공유합니다. 다들 득근하세요! 🔥',
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCnfloTdMgfwA8ZAWFT4bbolWEypWvRdLkbSY3wel1_XFVOmtL6e68wQNvbNsWtXAHp2HyqAa3u4jJvsPgs9IEO-F05DPi7tZIhKvKX0OhO1ZqV_hRuDYi51qLTHDfeCTYhWn9RLuC9eF1BcTvu_zE2LscMlQTTRApLuihX333myLQR2PEraUGn-eqPbgNwzWYYQWxXa4b0jyQLCIRmACcCgQAK6iYS67txoY1qDxufCsiwfQFla_XmgPI0jr3Q84sEJaLFaO9-FDOI',
                        likes: 15,
                        comments: 3,
                      ),
                      _buildFeedItem(
                        context,
                        username: '다이어터',
                        timeAgo: '1시간 전',
                        profileImage:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBUi4sQ2TwhkYrxlSEyZAdOeKLjQdgAr1YvgDuc1FkirmvwHgRkVfXEThv7UkQ0xkYg57q-9Lo3NYBMzCb2c-m5rxKRnfIA8k4fUprkLd8jMS38Ld18Z6guTdfJayMKamV8MUWEm2GNWmmFgckjTnVAffBDSFZE-7um7b6GL-sxo9181Vq_33gGziyQUyPfijnmIcgr8Ux6U1Xt1sfpx_9y3q0XDYMzyDGlzA1iWcERnK9QV8zXr8vAwpgwhVu0IAKlCVR_wOIme30W',
                        tag: '#식단공유',
                        content: '점심으로 먹은 닭가슴살 샐러드! 드레싱 추천 받아요. 🥗',
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDMYwUFKIJ1y7XnYzyR75M438Kfqu3bfsybbeuGV27-csXZSYMWvfEka_BGwbcoWoL9ga1s5yJOUT1h-60iE1Ww6P3RzLCvbbfkjxfLnpOHQ9ZrJgaK-iLTsEvbzyo_RrDS-_lP1WNvxbQy8PK98wk20coDWFy3u-_L9KtqXXqnOPr7Niv_Al2Xu1ZufhHvSuhqcTm7qvlrTFdaHOfSWrfJHNMMYW2Dto5ud0VQw5xJ3UhXwO4RW-Eo2FtDLBvEoSnKh5N2OC4fh5g3',
                        likes: 28,
                        comments: 5,
                      ),
                      _buildFeedItem(
                        context,
                        username: '헬린이',
                        timeAgo: '3시간 전',
                        profileImage:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB4kguom_vAI_3N3p-zVQifWeCkzqcjMIMZuRqckbUY7xMmZaoLHDuANaoszLPxWZM70IGlNR6Eh6FGrDnqsHwlHWaU4fU_vDABOoJ7pYPKSq3hIC1cJuBcPK5st56txV_1ajRwT83PeP1nmnfVbhF_y659-uxUERFAzXhTQPDYWAB8kXMGPTryo-4M8Dd84RxuZnhvvJxUTm2ueyNSYnSiq5gkc5oRxYJPrDfrZHVYgPNAroPbLpyIsxA3Zx40tfTBhnuYapJmYNMY',
                        tag: '#질문있어요',
                        content: '벤치프레스 할 때 어깨 통증이 있는데, 자세 문제일까요? 조언 부탁드립니다!',
                        image: null, // Assuming the third item in HTML didn't strictly show an image or I missed it, but based on typical feed. Wait, HTML had no image for 3rd item? Let me check. Ah, no image div in 3rd item in HTML.
                        likes: 9,
                        comments: 7,
                      ),
                      const SizedBox(height: 80), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: appColors?.mint ?? const Color(0xFF30e89c),
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      {bool isActive = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (appColors?.mint ?? const Color(0xFF30e89c))
            : (isDark ? Colors.grey[800] : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? null
            : Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: (appColors?.mint ?? const Color(0xFF30e89c))
                      .withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive
              ? Colors.white
              : colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFeedItem(
    BuildContext context, {
    required String username,
    required String timeAgo,
    required String profileImage,
    required String tag,
    required String content,
    String? image,
    required int likes,
    required int comments,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profileImage),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tag
          Text(
            tag,
            style: TextStyle(
              color: appColors?.freshGreen ?? Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),

          // Content
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Image
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              Icon(Icons.favorite_border,
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline,
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(
                '$comments',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}