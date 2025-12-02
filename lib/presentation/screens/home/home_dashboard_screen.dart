import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    // New Accent Color: Vibrant Blue
    const accentColor = Color(0xFF4E80EE);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // subtle background ambient light
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Area
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuAg7r0CsvTHud-SJqQGco8xQWWdjtklkSED7ZQkhaA9Zvuqt2QPRHjLdQwaF-3JhcL-BgK6Am0L0TPMb9Yga8mREhnixgq1ZMqcVhdCnOdRHY02E8zPN5LRrFkacWCNIDqJIIOlOO4Ftd9YRMKmrl4aIZrGVr6nxz3KwurJqpHAGplN3cm9AWWvzV4P8Dh3j_WUJzxPSPIfzRAaE_SMTiBWV6VDLQ1DFQ9OpTG7oyJlpQBXpsoQP_SoQeqAOkYkR352PaKRjO6PiVsg'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '안녕하세요,',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                              Text(
                                '김민준님',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(
                                color:
                                    colorScheme.outline.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            color: colorScheme.onSurface,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Headline
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '오늘의 웰니스',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '활기찬 하루를 위한 맞춤 코칭이 준비되어 있어요.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // Goal Progress Card (Featured)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF2C2C2E),
                                  const Color(0xFF1C1C1E)
                                ]
                              : [Colors.white, const Color(0xFFF5F7F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF000000).withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.fitness_center_rounded,
                                              size: 18,
                                              color: accentColor),
                                          const SizedBox(width: 8),
                                          Text(
                                            '주간 목표',
                                            style: TextStyle(
                                              color: accentColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '주 3회 운동하기',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '현재 2회 완료했어요!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CircularProgressIndicator(
                                        value: 1.0,
                                        strokeWidth: 8,
                                        color: isDark
                                            ? Colors.grey[800]
                                            : const Color(0xFFF0F0F0),
                                      ),
                                      CircularProgressIndicator(
                                        value: 0.66,
                                        strokeWidth: 8,
                                        strokeCap: StrokeCap.round,
                                        backgroundColor: Colors.transparent,
                                        color: accentColor,
                                      ),
                                      Center(
                                        child: Text(
                                          '66%',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Section Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '맞춤 코칭 프로그램',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Icon(Icons.arrow_forward,
                            size: 20,
                            color: colorScheme.onSurface.withValues(alpha: 0.4)),
                      ],
                    ),
                  ),

                  // Coaching List
                  SizedBox(
                    height: 260,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCoachingCard(
                          context,
                          '유연성 향상 요가',
                          '#유연성 #초급',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD5xVPM0r6fyde0SarrIdPa5D49EMkPIxLzG1xF9mKFftLW_VmLYqaIKLGnx8TOfpur44MB_Txig2pXgJ-EnKXSuNe7ego9YKfKVL-w3zPEB7W8FRNpaMXrMWWY4QFnoku13pWR58Rz7JEEHHYM2BwyfxHB0kI0-j8hoyo992Lhc6eqdW8_30SffMUShfEftd8hEQ9x7gOYN2Bcu_0PAOCha2-J-h4IBHt_6Swbxh4x1ykQWw-2bqyg7zdbME_hh5IugLGL8GIyk51x',
                        ),
                        const SizedBox(width: 16),
                        _buildCoachingCard(
                          context,
                          '스트레스 완화 명상',
                          '#멘탈케어 #초급',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDWJA-UcGiImtWP4uRvYY_awgOy95ENWUIZ1alccqHtYLpAoqn-8Un7NG_rMKBzalizYOtIByJlPkRsEvasMmQ7JG-D5bgs5w0h6y22gio1bml6uGOZUM0A1lbz3KaA67FY4uiYMjnUExmfl5-Pnk1Qc3xqwMTq8NZCiKgoWMKjJqFEDt0OpbMKYXyRAK7rkU2Vg3RfH2uYqBldFecChOGSWw0AyyWKqeToI1IhHuvWqklQDLxafjeobDU3oMqV-WNKGeSs2SDVtujk',
                        ),
                        const SizedBox(width: 16),
                        _buildCoachingCard(
                            context,
                            '고강도 인터벌',
                            '#체력증진 #중급',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDSRzkZpuU42ssVnjJPyGXAy01Ph9NTlue1fc2NcL7AsmlOl9ADRNcCLKRWv4w9wjjfqBx3Y2GlLG5SUu5bJ5W7LYL9jA6DzXKGgqbMZ2VZFSu-VKuAEdys9AKQu4u53HCg0tT9F-hVbG-zlveAUF_V-ZN4xF_Oi2-vU753vn108RJEoFZCOIiN381NgaWqf2vkJ7LJd9esoaLODdFLFrm0wnghtN6vLff0IIQpnvu03k-nUlkzsJ_q0Ckz4IUh-UBzGGoD5R6coP6-'),
                      ],
                    ),
                  ),

                  // NFT Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '나의 컬렉션',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '전체보기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildNftCard(
                            context,
                            '꾸준함 챌린지',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCzKJg5HpuKCyPimq5SSLgsSt9MGOiBObgnMZo1HBLEtrmyU3Ko6ia7iCXPb6Flf_d6dIHqsfYFH_OtvaTVqaCrFoejzQ29dezMKch74KZVXZWIeyzOgr8mmJmvgpzSMrqm3paWd2t11YSKilN7a6-K-7qDpfqKUZ025RUDM5XPbVnO84EPE5Kf7noDPsuqV6mM91EDiL_avr9aut3p1VbZFSkUItyixiS-zSUNRhs9hPWcTv6_DDTNAyhTpL6n67DiQoHZQi16ucvl',
                            isNew: true,
                            accentColor: accentColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNftCard(
                            context,
                            '첫 명상 성공',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuApcMhR8R2uyksbRFeoMLRTk77UsuEApVhp90R6zhiWFwGUHT53mH8XtOKbR72H9NBBZLWfMhWnETNSP0tBOtX_vHBZk8LyIBX19EBDcT8dgv_mNmcfj76TfRKh8T96wYapNmt04mWZ--fzbRPMZtarVTsrvk_BBi0dZ04dHEjG6CYjEPeEM-Zn6ZqmxZ2ho7vxeFVkKjNvJYESNM1c44uJcHlaVpSDvrlG-T0e3WKChU1X65OAlDw6-EAMI9YEyI60hdIQv9NqLZmk',
                            accentColor: accentColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNftCard(
                            context,
                            '목표 달성',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBeJVtxZkqc2-cJ9tUy1_xftNT8gj_EdJ6JdtVLVOBGcEwtAkCNkh9eYZ38vbOZiSKZRgJD8Ce6F9fLWnG6WWzpNHH6inG3JpJnIRJen4v8m22kuF4GwxKO2CpDwIM9Xg8w59iFqH6BPmWd3igxCMXOWl3DbCRVG5PJWkIN4otSBDMFsTV1tHVr2pAL9BtZ69-jEq4yqNH1dUFiXfzXu93-kessexpMY64qWVzpBr3dTO30nZdxaD4LAdShQRertIvHHSVpJDFVFeqP',
                            accentColor: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingCard(
      BuildContext context, String title, String tags, String imageUrl) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tags,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: FilledButton.tonal(
                    onPressed: () => context.push('/coaching/program/1'),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      foregroundColor: colorScheme.onSurface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('시작하기', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNftCard(BuildContext context, String title, String imageUrl,
      {bool isNew = false, required Color accentColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                if (isNew)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
