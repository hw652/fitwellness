import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    // Use theme colors for gradient or fallback to scaffold background
    final gradientStart = isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : appColors?.mint?.withValues(alpha: 0.2) ?? Colors.green.shade50;
    final gradientEnd =
        Theme.of(context).scaffoldBackgroundColor; // Blend into background

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradientStart,
              gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCuoKahCPvj4PVduRA1M2_jOKD9K2Ywcdc38UMsSWST0Msg3jcyzTAExVNfzSXKGnx3F7riPDOu9gcQpux4B25RLJjVIV-8zdvpfIZl1JQ4TP7Qcth56H8rQN1_723dlmwpmyikOngQWtcQ2cr5B7pvc8AsNyssgfYZqc-IAYb0XKs-q6SKGRv0U6lDUP03lNPL9nzciYzSQk1WQr8h9pBmlo4QCIxQfBIeaDcPigJehTRlikIe-4d-xBqeR6oBnwCB0vieOegzGa15',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '핏웰니스에 오신 것을\n환영합니다!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.2,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'My Data를 기반으로 당신만을 위한\n초개인 맞춤 웰니스 코칭을 시작해보세요.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDot(context, true),
                        const SizedBox(width: 8),
                        _buildDot(context, false),
                        const SizedBox(width: 8),
                        _buildDot(context, false),
                        const SizedBox(width: 8),
                        _buildDot(context, false),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => context.go('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('시작하기'),
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
    );
  }

  Widget _buildDot(BuildContext context, bool isActive) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? primaryColor : primaryColor.withValues(alpha: 0.3),
      ),
    );
  }
}
