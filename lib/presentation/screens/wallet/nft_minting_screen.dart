import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NftMintingScreen extends StatefulWidget {
  final String achievementType;
  final String achievementName;

  const NftMintingScreen({
    super.key,
    required this.achievementType,
    required this.achievementName,
  });

  @override
  State<NftMintingScreen> createState() => _NftMintingScreenState();
}

class _NftMintingScreenState extends State<NftMintingScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _cardRevealController;
  late AnimationController _holographicController;
  late AnimationController _pulseController;
  late AnimationController _confettiController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _progressController;

  // Animations
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardRotateYAnimation;
  late Animation<double> _cardRotateXAnimation;

  // State
  int _currentStep = 0; // 0: connecting, 1: minting, 2: confirming, 3: complete
  bool _isMinting = true;
  bool _showDetails = false;

  final List<String> _stepLabels = [
    '블록체인 연결 중',
    'NFT 생성 중',
    '트랜잭션 확인 중',
    '발급 완료!',
  ];

  final List<IconData> _stepIcons = [
    Icons.link_rounded,
    Icons.auto_awesome_rounded,
    Icons.verified_rounded,
    Icons.check_circle_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startMintingSequence();
  }

  void _initAnimations() {
    // Card reveal animation
    _cardRevealController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardRevealController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _cardRotateYAnimation = Tween<double>(begin: math.pi, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardRevealController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _cardRotateXAnimation = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardRevealController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Holographic shine effect
    _holographicController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Pulse glow effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Confetti
    _confettiController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Floating animation for card
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    // Shimmer effect
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  Future<void> _startMintingSequence() async {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Step 1: Connecting
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();

    // Step 2: Minting
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _currentStep = 1);
    HapticFeedback.lightImpact();
    _progressController.reset();
    _progressController.forward();

    // Step 3: Confirming
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _currentStep = 2);
    HapticFeedback.lightImpact();
    _progressController.reset();
    _progressController.forward();

    // Step 4: Complete
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _currentStep = 3;
      _isMinting = false;
    });
    HapticFeedback.heavyImpact();

    // Play success animations
    _cardRevealController.forward();
    _confettiController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _showDetails = true);
  }

  @override
  void dispose() {
    _cardRevealController.dispose();
    _holographicController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nftData = _getNftData();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF050508) : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(isDark, nftData),

          // Floating particles
          _buildFloatingParticles(nftData),

          // Confetti (only after minting)
          if (!_isMinting) _buildConfetti(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, colorScheme),
                Expanded(
                  child: _isMinting
                      ? _buildMintingState(context, isDark, colorScheme, nftData)
                      : _buildSuccessState(context, isDark, colorScheme, nftData),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDark, Map<String, dynamic> nftData) {
    final primaryColor = nftData['color'] as Color;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: [
            // Primary orb
            Positioned(
              top: -200 + (_pulseController.value * 20),
              left: -150,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.3 + _pulseController.value * 0.1),
                      primaryColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Secondary orb
            Positioned(
              bottom: -150 - (_pulseController.value * 15),
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4E80EE).withValues(alpha: 0.2 + _pulseController.value * 0.1),
                      const Color(0xFF4E80EE).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Accent orb
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFA855F7).withValues(alpha: 0.15),
                      const Color(0xFFA855F7).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingParticles(Map<String, dynamic> nftData) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ParticlePainter(
            progress: _floatController.value,
            particleColor: (nftData['color'] as Color).withValues(alpha: 0.6),
            isMinting: _isMinting,
          ),
        );
      },
    );
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: EnhancedConfettiPainter(
            progress: _confettiController.value,
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          AnimatedOpacity(
            opacity: _showDetails ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '인증됨',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            icon: Icon(
              Icons.close_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMintingState(BuildContext context, bool isDark,
      ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minting card preview with holographic effect
        _buildMintingCardPreview(isDark, colorScheme, nftData),

        const SizedBox(height: 48),

        // Progress steps
        _buildProgressSteps(colorScheme, nftData),

        const SizedBox(height: 32),

        // Current status text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _stepLabels[_currentStep],
            key: ValueKey(_currentStep),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          _getStepSubtitle(),
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMintingCardPreview(
      bool isDark, ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _shimmerController]),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(math.sin(_shimmerController.value * math.pi * 2) * 0.05)
            ..rotateX(math.cos(_shimmerController.value * math.pi * 2) * 0.03),
          child: Container(
            width: 200,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (nftData['color'] as Color)
                      .withValues(alpha: 0.3 + _pulseController.value * 0.2),
                  blurRadius: 40 + _pulseController.value * 20,
                  spreadRadius: _pulseController.value * 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Base gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          nftData['color'] as Color,
                          (nftData['color'] as Color).withValues(alpha: 0.7),
                          isDark ? const Color(0xFF1a1a2e) : Colors.white,
                        ],
                      ),
                    ),
                  ),

                  // Scanning line effect
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                              stops: [
                                (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                                _shimmerController.value,
                                (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                              ],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Container(color: Colors.white),
                        );
                      },
                    ),
                  ),

                  // Center icon with pulse
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        nftData['icon'] as IconData,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),

                  // Loading shimmer overlay
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSteps(ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          final color = isCompleted
              ? colorScheme.primary
              : isActive
                  ? nftData['color'] as Color
                  : colorScheme.onSurface.withValues(alpha: 0.2);

          return Expanded(
            child: Row(
              children: [
                // Step indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 44 : 36,
                  height: isActive ? 44 : 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? colorScheme.primary
                        : isActive
                            ? (nftData['color'] as Color).withValues(alpha: 0.15)
                            : colorScheme.onSurface.withValues(alpha: 0.05),
                    border: Border.all(
                      color: color,
                      width: isActive ? 2.5 : 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: (nftData['color'] as Color).withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.black, size: 20)
                        : Icon(
                            _stepIcons[index],
                            color: isActive
                                ? nftData['color'] as Color
                                : colorScheme.onSurface.withValues(alpha: 0.3),
                            size: isActive ? 22 : 18,
                          ),
                  ),
                ),
                // Connector line
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isCompleted
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.1),
                            index < _currentStep - 1
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return '보안 연결을 설정하고 있습니다';
      case 1:
        return '고유한 NFT를 생성하고 있습니다';
      case 2:
        return '블록체인에 기록 중입니다';
      default:
        return 'NFT가 성공적으로 발급되었습니다';
    }
  }

  Widget _buildSuccessState(BuildContext context, bool isDark,
      ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Success header
          _buildSuccessHeader(colorScheme),

          const SizedBox(height: 36),

          // 3D Holographic NFT Card
          _buildHolographicNftCard(isDark, colorScheme, nftData),

          const SizedBox(height: 40),

          // NFT Details
          AnimatedOpacity(
            opacity: _showDetails ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: AnimatedSlide(
              offset: _showDetails ? Offset.zero : const Offset(0, 0.2),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              child: _buildNftDetails(context, isDark, colorScheme, nftData),
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          AnimatedOpacity(
            opacity: _showDetails ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: _buildActionButtons(context, colorScheme, nftData),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader(ColorScheme colorScheme) {
    return Column(
      children: [
        // Animated checkmark
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                  size: 36,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.onSurface,
                colorScheme.primary,
                colorScheme.onSurface,
              ],
            ).createShader(bounds);
          },
          child: Text(
            '축하합니다!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'NFT가 성공적으로 발급되었습니다',
          style: TextStyle(
            fontSize: 15,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildHolographicNftCard(
      bool isDark, ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _cardRevealController,
        _holographicController,
        _floatController,
      ]),
      builder: (context, child) {
        // Floating effect
        final floatOffset = math.sin(_floatController.value * math.pi) * 8;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_cardRotateYAnimation.value)
            ..rotateX(_cardRotateXAnimation.value)
            ..storage[13] = floatOffset,
          child: ScaleTransition(
            scale: _cardScaleAnimation,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: (nftData['color'] as Color).withValues(alpha: 0.5),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    // Base card
                    _buildCardBase(isDark, nftData),

                    // Holographic overlay
                    _buildHolographicOverlay(nftData),

                    // Card content
                    _buildCardContent(colorScheme, nftData),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBase(bool isDark, Map<String, dynamic> nftData) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            nftData['color'] as Color,
            (nftData['color'] as Color).withValues(alpha: 0.8),
            isDark ? const Color(0xFF1a1a2e) : Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildHolographicOverlay(Map<String, dynamic> nftData) {
    return AnimatedBuilder(
      animation: _holographicController,
      builder: (context, child) {
        return Positioned.fill(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1 + _holographicController.value * 3, -1),
                end: Alignment(1 + _holographicController.value * 3, 1),
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.1),
                  const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                  const Color(0xFF4ECDC4).withValues(alpha: 0.15),
                  const Color(0xFFA855F7).withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 0.8, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(ColorScheme colorScheme, Map<String, dynamic> nftData) {
    final grade = nftData['grade'] as String;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image area
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Grade-specific effects
              if (grade == 'Legend' || grade == 'Epic') _buildGradeEffect(grade),

              // Main icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    nftData['icon'] as IconData,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),

              // Grade badge
              Positioned(
                top: 16,
                right: 16,
                child: _buildGradeBadge(grade),
              ),

              // Serial number
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${_generateSerialNumber()}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Info area
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      nftData['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.share_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '팀웰니스 공식 NFT',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradeEffect(String grade) {
    if (grade == 'Legend') {
      return AnimatedBuilder(
        animation: _holographicController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(300, 220),
            painter: SparklesPainter(
              progress: _holographicController.value,
              color: const Color(0xFFFFD700),
            ),
          );
        },
      );
    } else if (grade == 'Epic') {
      return AnimatedBuilder(
        animation: _holographicController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(300, 220),
            painter: StardustPainter(
              progress: _holographicController.value,
              color: const Color(0xFFA855F7),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildGradeBadge(String grade) {
    final colors = _getGradeColors(grade);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors['bg']!.withValues(alpha: 0.9),
            colors['bg']!.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors['border']!.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors['glow']!.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getGradeIcon(grade),
            size: 14,
            color: colors['text'],
          ),
          const SizedBox(width: 5),
          Text(
            grade,
            style: TextStyle(
              color: colors['text'],
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getGradeColors(String grade) {
    switch (grade) {
      case 'Legend':
        return {
          'bg': const Color(0xFF1a1a2e),
          'border': const Color(0xFFFFD700),
          'text': const Color(0xFFFFD700),
          'glow': const Color(0xFFFFD700),
        };
      case 'Epic':
        return {
          'bg': const Color(0xFF1a1a2e),
          'border': const Color(0xFFA855F7),
          'text': const Color(0xFFA855F7),
          'glow': const Color(0xFFA855F7),
        };
      case 'Rare':
        return {
          'bg': const Color(0xFF1a1a2e),
          'border': const Color(0xFF4E80EE),
          'text': const Color(0xFF4E80EE),
          'glow': const Color(0xFF4E80EE),
        };
      default:
        return {
          'bg': const Color(0xFF2a2a3e),
          'border': Colors.white38,
          'text': Colors.white,
          'glow': Colors.white24,
        };
    }
  }

  IconData _getGradeIcon(String grade) {
    switch (grade) {
      case 'Legend':
        return Icons.diamond_rounded;
      case 'Epic':
        return Icons.auto_awesome_rounded;
      case 'Rare':
        return Icons.star_rounded;
      default:
        return Icons.circle;
    }
  }

  Widget _buildNftDetails(BuildContext context, bool isDark,
      ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem(
            context,
            '달성 내용',
            widget.achievementName,
            Icons.emoji_events_rounded,
            nftData['color'] as Color,
          ),
          _buildDivider(colorScheme),
          _buildDetailItem(
            context,
            '발급 일시',
            _getCurrentDateTime(),
            Icons.schedule_rounded,
            const Color(0xFF4E80EE),
          ),
          _buildDivider(colorScheme),
          _buildDetailItem(
            context,
            '트랜잭션 ID',
            _generateTxHash(),
            Icons.fingerprint_rounded,
            const Color(0xFF4ECDC4),
            isMonospace: true,
          ),
          _buildDivider(colorScheme),
          _buildDetailItem(
            context,
            '네트워크',
            'Polygon Mainnet',
            Icons.hub_rounded,
            const Color(0xFFA855F7),
          ),

          const SizedBox(height: 16),

          // Blockchain verified badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.1),
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '블록체인 검증 완료',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value,
      IconData icon, Color color, {bool isMonospace = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    fontFamily: isMonospace ? 'monospace' : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.content_copy_rounded,
            size: 18,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            colorScheme.outline.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ColorScheme colorScheme, Map<String, dynamic> nftData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Primary button - View in wallet
          Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.85),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.go('/wallet');
                },
                borderRadius: BorderRadius.circular(18),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '지갑에서 보기',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Secondary buttons row
          Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  '공유하기',
                  Icons.share_rounded,
                  colorScheme,
                  () {
                    HapticFeedback.lightImpact();
                    // Share functionality
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  '계속하기',
                  Icons.arrow_forward_rounded,
                  colorScheme,
                  () => context.pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, String label,
      IconData icon, ColorScheme colorScheme, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : colorScheme.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getNftData() {
    switch (widget.achievementType) {
      case 'challenge':
        return {
          'name': '챌린지 마스터',
          'icon': Icons.emoji_events_rounded,
          'color': const Color(0xFFFFD700),
          'grade': 'Rare',
        };
      case 'goal':
        return {
          'name': '목표 달성자',
          'icon': Icons.flag_rounded,
          'color': const Color(0xFF4E80EE),
          'grade': 'Common',
        };
      case 'streak':
        return {
          'name': '불꽃 연속기록',
          'icon': Icons.local_fire_department_rounded,
          'color': const Color(0xFFFF6B6B),
          'grade': 'Epic',
        };
      case 'first':
        return {
          'name': '첫 발걸음',
          'icon': Icons.celebration_rounded,
          'color': const Color(0xFFA855F7),
          'grade': 'Common',
        };
      case 'legend':
        return {
          'name': '전설의 운동왕',
          'icon': Icons.diamond_rounded,
          'color': const Color(0xFFFFD700),
          'grade': 'Legend',
        };
      default:
        return {
          'name': widget.achievementName,
          'icon': Icons.workspace_premium_rounded,
          'color': const Color(0xFF13ECA4),
          'grade': 'Common',
        };
    }
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _generateTxHash() {
    const chars = '0123456789abcdef';
    final random = math.Random();
    final hash = List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
    return '0x$hash...${hash.substring(0, 4)}';
  }

  String _generateSerialNumber() {
    final random = math.Random();
    return '${random.nextInt(9000) + 1000}';
  }
}

// Enhanced Confetti Painter with more variety
class EnhancedConfettiPainter extends CustomPainter {
  final double progress;

  EnhancedConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    final colors = [
      const Color(0xFFFFD700),
      const Color(0xFF4E80EE),
      const Color(0xFFA855F7),
      const Color(0xFF4ECDC4),
      const Color(0xFF13ECA4),
      const Color(0xFFFF6B6B),
      const Color(0xFFFF9F43),
    ];

    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final delay = random.nextDouble() * 0.3;
      final adjustedProgress = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);

      if (adjustedProgress <= 0) continue;

      final startY = -50.0 - random.nextDouble() * 100;
      final endY = size.height + 100;
      final y = startY + (endY - startY) * adjustedProgress;

      // Add horizontal drift
      final drift = math.sin(adjustedProgress * math.pi * 3 + i) * 30;

      final color = colors[i % colors.length];
      final opacity = (1.0 - adjustedProgress * 0.8).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final confettiSize = 5.0 + random.nextDouble() * 8;
      final rotation = adjustedProgress * math.pi * 6 * (random.nextBool() ? 1 : -1);

      canvas.save();
      canvas.translate(x + drift, y);
      canvas.rotate(rotation);

      // Different shapes
      if (i % 5 == 0) {
        // Star
        final path = _createStarPath(confettiSize);
        canvas.drawPath(path, paint);
      } else if (i % 5 == 1) {
        // Circle
        canvas.drawCircle(Offset.zero, confettiSize / 2, paint);
      } else if (i % 5 == 2) {
        // Rectangle
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: confettiSize, height: confettiSize * 0.5),
            const Radius.circular(2),
          ),
          paint,
        );
      } else if (i % 5 == 3) {
        // Triangle
        final path = Path()
          ..moveTo(0, -confettiSize / 2)
          ..lineTo(confettiSize / 2, confettiSize / 2)
          ..lineTo(-confettiSize / 2, confettiSize / 2)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        // Diamond
        final path = Path()
          ..moveTo(0, -confettiSize / 2)
          ..lineTo(confettiSize / 2, 0)
          ..lineTo(0, confettiSize / 2)
          ..lineTo(-confettiSize / 2, 0)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  Path _createStarPath(double size) {
    final path = Path();
    final outerRadius = size / 2;
    final innerRadius = size / 4;

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * math.pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * math.pi / 180;

      if (i == 0) {
        path.moveTo(outerRadius * math.cos(outerAngle), outerRadius * math.sin(outerAngle));
      } else {
        path.lineTo(outerRadius * math.cos(outerAngle), outerRadius * math.sin(outerAngle));
      }
      path.lineTo(innerRadius * math.cos(innerAngle), innerRadius * math.sin(innerAngle));
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Floating particles painter
class ParticlePainter extends CustomPainter {
  final double progress;
  final Color particleColor;
  final bool isMinting;

  ParticlePainter({
    required this.progress,
    required this.particleColor,
    required this.isMinting,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(123);
    final particleCount = isMinting ? 30 : 15;

    for (int i = 0; i < particleCount; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final phase = random.nextDouble() * math.pi * 2;
      final amplitude = 20 + random.nextDouble() * 30;

      final x = baseX + math.sin(progress * math.pi * 2 + phase) * amplitude * 0.5;
      final y = baseY + math.cos(progress * math.pi * 2 + phase) * amplitude;

      final particleSize = 2 + random.nextDouble() * 4;
      final opacity = 0.1 + random.nextDouble() * 0.3;

      final paint = Paint()
        ..color = particleColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Sparkles painter for Legend grade
class SparklesPainter extends CustomPainter {
  final double progress;
  final Color color;

  SparklesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(456);

    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final phase = random.nextDouble() * math.pi * 2;

      final twinkle = (math.sin(progress * math.pi * 4 + phase) + 1) / 2;
      final sparkleSize = 2 + twinkle * 4;

      final paint = Paint()
        ..color = color.withValues(alpha: twinkle * 0.8)
        ..style = PaintingStyle.fill;

      // Draw 4-point star
      final path = Path();
      path.moveTo(x, y - sparkleSize);
      path.lineTo(x + sparkleSize * 0.3, y);
      path.lineTo(x, y + sparkleSize);
      path.lineTo(x - sparkleSize * 0.3, y);
      path.close();

      path.moveTo(x - sparkleSize, y);
      path.lineTo(x, y + sparkleSize * 0.3);
      path.lineTo(x + sparkleSize, y);
      path.lineTo(x, y - sparkleSize * 0.3);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Stardust painter for Epic grade
class StardustPainter extends CustomPainter {
  final double progress;
  final Color color;

  StardustPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(789);

    for (int i = 0; i < 25; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final phase = random.nextDouble();

      final adjustedProgress = (progress + phase) % 1.0;
      final trail = adjustedProgress * 30;

      for (int j = 0; j < 5; j++) {
        final trailProgress = j / 5;
        final x = startX - trail * trailProgress * 0.5;
        final y = startY + trail * trailProgress;

        final opacity = (1 - trailProgress) * 0.6 * (1 - adjustedProgress * 0.5);
        final dotSize = (1 - trailProgress) * 3;

        final paint = Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
