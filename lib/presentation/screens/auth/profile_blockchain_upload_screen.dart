import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';

class ProfileBlockchainUploadScreen extends StatefulWidget {
  const ProfileBlockchainUploadScreen({super.key});

  @override
  State<ProfileBlockchainUploadScreen> createState() =>
      _ProfileBlockchainUploadScreenState();
}

class _ProfileBlockchainUploadScreenState
    extends State<ProfileBlockchainUploadScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startUploadSimulation();
  }

  void _startUploadSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.015;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          // Navigate to the next screen after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go('/profile-complete');
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon Circle
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (appColors?.mint ?? Colors.green).withValues(alpha: 0.2),
                      (appColors?.freshGreen ?? Colors.teal)
                          .withValues(alpha: 0.2),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.cloud_upload,
                  size: 64,
                  color: appColors?.freshGreen ?? colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '데이터 업로드 중...',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '고객님의 데이터를 안전하게 전송하고 있습니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 48),

              // Progress Bar Section
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '업로드 진행률',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: TextStyle(
                          color: appColors?.freshGreen ?? colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Container(
                              width: constraints.maxWidth * _progress,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    appColors?.mint ?? Colors.greenAccent,
                                    appColors?.freshGreen ?? Colors.green,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '잠시만 기다려주세요. 앱을 종료하지 마세요.',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
