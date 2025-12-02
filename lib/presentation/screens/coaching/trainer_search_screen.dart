import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class TrainerSearchScreen extends StatelessWidget {
  const TrainerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('트레이너 찾기',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip(context, '필터',
                    icon: Icons.tune, isActive: false),
                const SizedBox(width: 8),
                _buildFilterChip(context, '인기순',
                    icon: Icons.expand_more, isActive: false),
                const SizedBox(width: 8),
                _buildFilterChip(context, '전문 분야',
                    icon: Icons.expand_more, isActive: true),
                const SizedBox(width: 8),
                _buildFilterChip(context, '거리순', isActive: false),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTrainerCard(
                  context,
                  name: '김민준 트레이너',
                  role: '마음까지 케어하는 멘탈 코치',
                  rating: '4.9',
                  reviews: '125 리뷰',
                  coachingCount: '코칭 80회+',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCANvsRYS6NeaHEFhV3y5QU_VANMX6q6pc6yDrHjtKWCnV8Zm1vWosLFMnuNqqOAtzq9Hh-PhNSlIMQv57bEXGkhcaGNIkp6weIalrkItKGkYKZ8yHKunnTyEsEqCC-G4tmvG62MoHYWKbSmQKkAWml6_aUJ1zaYs-kWMLx_UR7FaB5eapsrU5aRHJTBhm0-fEq_yGXW7k47d2ankvm3VEN837PX7xqFztUp0JE983kR3S7lfkOP0OrIBrI-33RRsJ_vEyxJzxPdS6_',
                  badge: 'SBT Pro',
                  id: '1',
                ),
                const SizedBox(height: 12),
                _buildTrainerCard(
                  context,
                  name: '박서연 트레이너',
                  role: '당신의 건강한 변화를 함께합니다',
                  rating: '4.8',
                  reviews: '98 리뷰',
                  coachingCount: '코칭 65회+',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDm5ab_YsBiRUMUd5LnReDQFeVlimnUI87RvpGcU1IL7lC2cT2cY8Zhp4o-Ipc1yv6Z1xxvX2ZkhcWqXKCsnVt933QyE-MBvME6XEmfNAZNCoYFmXHhE2HfBSoTRGQutbM4xD_IRwxSSqYDxZGc6C9HRMNE6F6pghyKadauAm2GX0JGDS4dPlHkSNIvkoZPcJZT5PQt59grD8nZh-YdpaBGOFO6ENLJ1wTd_M9Gak95-sz9yNqtaDzmYIHftiOfbU52Epp0zBCis-Yj',
                  badge: 'SBT Pro',
                  id: '2',
                ),
                const SizedBox(height: 12),
                _buildTrainerCard(
                  context,
                  name: '이하은 트레이너',
                  role: '과학적인 데이터 기반 코칭 전문가',
                  rating: '5.0',
                  reviews: '76 리뷰',
                  coachingCount: '코칭 120회+',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAP6wojB683_pmmLomzmRN3YsIL5j1aY1heZjkh7sBAyYv1p9lXI25mybui_ij0WlSGezWMnRcKub8YEUIMQAGpoXR9MJvcSopghsIp05_jPebxaCY5ZmixzvRsHna2YcPFjCYhhr6WE7P5IhG1QuTxiTOid9FkL5wmn1H2-In2Jvzi7flOmEVg4n4D4PjikkCRhlOkPOK9voBxCUU39o93YK3W691f9CKcajANC6QTTIkHseMNsPa_LisYryuLhw6Dvq_VMZf6acb2',
                  badge: 'SBT Master',
                  id: '3',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      {IconData? icon, required bool isActive}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isActive
        ? colorScheme.onSurface
        : (isDark ? Colors.grey[800] : Colors.grey[100]);
    final textColor = isActive
        ? colorScheme.surface
        : colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(
    BuildContext context, {
    required String name,
    required String role,
    required String rating,
    required String reviews,
    required String coachingCount,
    required String imageUrl,
    required String badge,
    required String id,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/coaching/trainer/$id'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          appColors?.freshMint ?? Colors.green,
                          appColors?.freshGreen ?? Colors.blue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isDark ? Colors.grey[900]! : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews)',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '|',
                          style: TextStyle(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.3)),
                        ),
                      ),
                      Text(
                        coachingCount,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
