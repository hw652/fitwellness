import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class RewardWalletScreen extends StatelessWidget {
  const RewardWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    // Specific mint-green gradient for this screen as per design
    final gradientStart = appColors?.mint ?? const Color(0xFF6ef2a2);
    final gradientEnd = appColors?.freshGreen ?? const Color(0xFF32d6a5);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: isDark
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF112117),
                    const Color(0xFF1a382a),
                  ],
                ),
              )
            : null,
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
                        '나의 리워드 NFT',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Profile & Summary
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBT96tF0K47rMOjDgzYnnmSk3nVK-xEHdNdSJP1zNSlwEtjPdZHyW8uMvqqQsShqLfBUoxVsWEGjYt4iSR_RlgDSIoVqqaNT8cx73lbh6_OnpRzKQlvErAXxPWO5qoxOM2rtt2kaXUcZjx_jmaneWSVmzFKN6uffVvK1ZBnquMnKo2I50NeXkiIO0xqeQpqRQMwd_NMOgoAFB57b__jhxOXAkIOaT9gKR18BgPLuG_2aTpvy522mrkKZv9-sLAN8VOSCHrQSHf6KqPD'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '홍길동님',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          children: [
                            Text(
                              '총 ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6)),
                            ),
                            Text(
                              '15개',
                              style: TextStyle(
                                color: gradientStart,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '의 NFT를 획득했어요!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip(context, '최신순',
                        isActive: true,
                        gradient:
                            LinearGradient(colors: [gradientStart, gradientEnd])),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '획득 유형'),
                    const SizedBox(width: 8),
                    _buildFilterChip(context, '등급'),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  children: [
                    _buildNftItem(
                      context,
                      title: '새벽 조깅 챌린지',
                      date: '2023.10.26',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB3RRMLAm4VQjZ490ttQWQcJ76Eg-X8nV3NS6W9z0eIhHZdIyLJil1jDFeKw6R0Trbt0IAopdvQCbkecFFKlU1Qe7eWm5oDVEd2PvCqVisEmusWnkrW-IFVbBg5vURwHCB9W2QlNprkoYrsNmN64vqKeT9faSHNTsRknGm9iCkR6tnyPZxeZVKcjgkgUHsd_Oe6FGBkSSxRynZJraMaXrPrnl37v7ldZJRcDKJZaxDBr_Q2PQpsHTsMkK_STNTKm8OD4Nc8I_34uxBu',
                    ),
                    _buildNftItem(
                      context,
                      title: '주 3회 운동 성공',
                      date: '2023.10.22',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDYya6yfScMPooSqpoOd7jZ-uGd_HL7njR1JH14kwFwB223JFCy2Z_FhZQGAyQDsNiPQ-MozAW6aOgk8kUDinpWDGvU3nUPsS9ncL3_v91Bbm1Se-zFmxZOxPjzBOxqYzQIsUfZm2dDrSYpW7CdmOTD18ZnSkhxrJ41wsyelbhX1oY0L6amY7cpoElIFFC9x7ez0BbqQCPxfk6BgAptkxcyH9nzPih_qy68M-AF5dODJOq1lTeqCLPnpObFerGH8KBMSYXF8Kyb8uo_',
                    ),
                    _buildNftItem(
                      context,
                      title: '10,000 걸음 달성',
                      date: '2023.10.19',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHMWU6fJ3_mIBgW0LI-94gEaxv-WuPt1USxLCdI77nQYmL2P2abLYlsaj_BZzz5uIijWRUEKTTPwxbVTz0NIyefKmIWC6ZuHOWkJZv1Bu1wXCFYhoPL1vxPIvoBKD0beankhWQgWHyIzAKCiKMvSNxSBxsxawYRNR1HEeGII7tTu_y3IyTbJcTndVV8IK3Sx8XHIbAmeMm9XwRrRJ6NxtwaWz7h7K_jT9uaYKLow_9XpYBppojH51f3DQD_XuB-8L6ltWzVo_vzmYM',
                    ),
                    _buildNftItem(
                      context,
                      title: '월간 목표 클리어',
                      date: '2023.09.30',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCsJPyoAN0G5wTROYItM7JOpHljoN4USzJn6zDDmGQ8AWmuSJtAJBvfQst-gumS3eSAg5LPTc0LNN6mye42Q-OfN7zTXoql6dLb4UglmNtEUmQUNgJ4mZDqNVe5L8LH2jqqU-UC1zdokVD2urAM9FUQv3SyvDtaoPutQgpcKcHBzlO1Db3-0quD5I0GHWt4zTXtGA-oyYNPMOpeVkBDZu37rTWhRvHcfkyuJkukmIuiOorLniyRbp79NEo6hdBkEoyZfKSh-nRqLqUG',
                    ),
                    _buildNftItem(
                      context,
                      title: '첫 목표 달성!',
                      date: '2023.09.15',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDlfqRNw3YHa6v5PlJ_4ctRZ-w96dUfCtuybYn4OCt8g35jYBv2IXLrfIUSrrt4S_xIXWmWPk0L94AXIH3nKm0TQ80S4OrHD_lASlUC1PoIEQN5wRvl_JhbuieZpr_1SZGfYL_t3d5FzfNAHYTrsTGsc7eAJblhm9JusEfFFv2Fg7dp5qzBD5OO5XeYmgPYx6gbxjum8h4CexPmAe3a8hS-DgxdyXV_wMp8fJQMpOccSih03JJej7fqAjINaxv6-Gth779FtMDbPXPC',
                    ),
                    _buildNftItem(
                      context,
                      title: '친구와 함께 운동',
                      date: '2023.09.10',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7TL-POm5blhJ831nZaJDuJBYqct1t5CUKo9c0mVL0ZpAGj8YDTRicAonOAcXhNg80eIeNbkF7HfzqADgxkLrQnM-8IYMHEE961RcZzHnI4Krs0RdSTAusjjC7rKIA7hSP6Ijg3EmXgA3CT3UUYDGDzQ8yO4ZlA7z2ZXKLfkGz6XHG9qovY1BaGb1F5Rng-M2RXl4wyCU3hBESQ7qHOpaHBIvnZnMyzN7fq1J_FnpuJsPJk9T1Un5y1ge3zMAVv-EOVcmnjVc7bZ5m',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      {bool isActive = false, LinearGradient? gradient}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive ? gradient : null,
        color: isActive
            ? null
            : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Colors.black
                  : (isDark ? Colors.grey[300] : Colors.grey[700]),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (!isActive) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 20,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNftItem(
    BuildContext context, {
    required String title,
    required String date,
    required String imageUrl,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
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
        const SizedBox(height: 2),
        Text(
          date,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}