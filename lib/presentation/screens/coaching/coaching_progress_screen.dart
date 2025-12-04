import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/data/mock_routine_data.dart';
import 'package:team_wellness/core/models/exercise_model.dart';

class CoachingProgressScreen extends StatefulWidget {
  final String programId;
  const CoachingProgressScreen({super.key, required this.programId});

  @override
  State<CoachingProgressScreen> createState() => _CoachingProgressScreenState();
}

class _CoachingProgressScreenState extends State<CoachingProgressScreen>
    with TickerProviderStateMixin {
  late Routine routine;
  int currentExerciseIndex = 0;

  // Timer State
  Timer? _timer;
  int _restSecondsRemaining = 0;
  bool isResting = false;

  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _progressAnimController;
  late Animation<double> _pulseAnimation;

  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    routine = MockRoutineData.dailyRoutine;
    for (var exercise in routine.exercises) {
      for (var set in exercise.sets) {
        set.isCompleted = false;
        set.actualReps = null;
        set.actualWeight = null;
      }
    }

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    _pulseController.dispose();
    _progressAnimController.dispose();
    super.dispose();
  }

  Exercise get currentExercise => routine.exercises[currentExerciseIndex];
  List<ExerciseSet> get currentSets => currentExercise.sets;

  int get currentSetIndex {
    int index = currentSets.indexWhere((set) => !set.isCompleted);
    return index == -1 ? currentSets.length - 1 : index;
  }

  ExerciseSet get currentSet => currentSets[currentSetIndex];
  bool get isLastSetOfExercise => currentSetIndex == currentSets.length - 1;
  bool get isLastExercise => currentExerciseIndex == routine.exercises.length - 1;

  int get completedSetsInCurrentExercise {
    return currentSets.where((s) => s.isCompleted).length;
  }

  int get _totalSetsInRoutine {
    return routine.exercises.fold(0, (sum, ex) => sum + ex.sets.length);
  }

  int get _completedSetsInRoutine {
    int completedTotal = 0;
    for (int i = 0; i < currentExerciseIndex; i++) {
      completedTotal += routine.exercises[i].sets.length;
    }
    completedTotal += completedSetsInCurrentExercise;
    return completedTotal;
  }

  double get _overallProgress {
    if (_totalSetsInRoutine == 0) return 0;
    return _completedSetsInRoutine / _totalSetsInRoutine;
  }

  void _startRestTimer() {
    HapticFeedback.mediumImpact();
    setState(() {
      isResting = true;
      _restSecondsRemaining = currentExercise.defaultRestSeconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_restSecondsRemaining > 0) {
            _restSecondsRemaining--;
          } else {
            _skipRest();
          }
        });
      }
    });
  }

  void _skipRest() {
    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() {
      isResting = false;
    });
  }

  void _completeSet() {
    HapticFeedback.heavyImpact();
    setState(() {
      currentSet.isCompleted = true;
      currentSet.actualReps ??= currentSet.targetReps;
      currentSet.actualWeight ??= currentSet.targetWeight;
    });

    if (isLastSetOfExercise) {
      if (isLastExercise) {
        _showWorkoutCompleteDialog();
      } else {
        setState(() {
          currentExerciseIndex++;
        });
        _startRestTimer();
      }
    } else {
      _startRestTimer();
    }
  }

  void _showWorkoutCompleteDialog() {
    HapticFeedback.heavyImpact();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return _WorkoutCompleteDialog(
          routineName: routine.name,
          totalSets: _totalSetsInRoutine,
          onGetNft: () {
            Navigator.of(context).pop();
            this.context.pop();
            this.context.push('/wallet/minting', extra: {
              'type': 'challenge',
              'name': routine.name,
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            this.context.pop();
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF050508) : colorScheme.surface,
      body: Stack(
        children: [
          // Background gradient
          _buildBackground(isDark, colorScheme),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, colorScheme),
                _buildProgressHeader(context, colorScheme),
                Expanded(
                  child: isResting
                      ? _buildRestView(context)
                      : _buildActiveView(context),
                ),
              ],
            ),
          ),

          // Bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark, ColorScheme colorScheme) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF4E80EE).withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showExitConfirmDialog(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  routine.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currentExercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showExitConfirmDialog(context),
            child: Text(
              '종료',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('운동 종료'),
        content: const Text('정말로 운동을 종료하시겠습니까?\n진행 상황이 저장되지 않습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              '계속하기',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            child: const Text('종료'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.fitness_center_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '전체 진행률',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_completedSetsInRoutine / $_totalSetsInRoutine 세트',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar with animation
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: 8,
                width: MediaQuery.of(context).size.width * 0.85 * _overallProgress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      const Color(0xFF4ECDC4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Exercise indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(routine.exercises.length, (index) {
              final isCompleted = index < currentExerciseIndex;
              final isCurrent = index == currentExerciseIndex;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isCurrent ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.primary
                            : isCurrent
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Image Card
          _buildExerciseImageCard(context, isDark, colorScheme),

          const SizedBox(height: 24),

          // Current Set Card
          _buildCurrentSetCard(context, colorScheme),

          const SizedBox(height: 20),

          // Set Progress Indicators
          _buildSetProgressIndicators(context, colorScheme),

          const SizedBox(height: 20),

          // Completed Sets
          if (currentSetIndex > 0) _buildCompletedSets(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildExerciseImageCard(
      BuildContext context, bool isDark, ColorScheme colorScheme) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              currentExercise.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: colorScheme.primary,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.fitness_center_rounded,
                    size: 64,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                );
              },
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Exercise info overlay
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentExercise.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentExercise.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${currentExercise.defaultRestSeconds}s',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Exercise number badge
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentExerciseIndex + 1} / ${routine.exercises.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSetCard(BuildContext context, ColorScheme colorScheme) {
    return _ActiveSetCard(
      exerciseType: currentExercise.type,
      setNumber: currentSet.setNumber,
      totalSets: currentSets.length,
      targetReps: currentSet.targetReps,
      targetWeight: currentSet.targetWeight,
      onRepsChanged: (val) => currentSet.actualReps = val,
      onWeightChanged: (val) => currentSet.actualWeight = val,
    );
  }

  Widget _buildSetProgressIndicators(
      BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(currentSets.length, (index) {
        final isCompleted = index < currentSetIndex ||
            (index == currentSetIndex && currentSet.isCompleted);
        final isCurrent = index == currentSetIndex && !currentSet.isCompleted;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isCurrent ? 48 : 40,
          height: isCurrent ? 48 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? colorScheme.primary
                : isCurrent
                    ? colorScheme.primary.withValues(alpha: 0.15)
                    : colorScheme.onSurface.withValues(alpha: 0.08),
            border: Border.all(
              color: isCurrent
                  ? colorScheme.primary
                  : isCompleted
                      ? colorScheme.primary
                      : Colors.transparent,
              width: 2,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.bold,
                      fontSize: isCurrent ? 18 : 16,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildCompletedSets(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              '완료된 세트',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...currentSets.take(currentSetIndex).map((set) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _CompletedSetItem(set: set, type: currentExercise.type),
            )),
      ],
    );
  }

  Widget _buildRestView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = _restSecondsRemaining / currentExercise.defaultRestSeconds;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        children: [
          // Rest Timer
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '휴식 시간',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),

                // Animated Timer
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Background circle
                            CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 12,
                              backgroundColor: Colors.transparent,
                              color: colorScheme.onSurface.withValues(alpha: 0.08),
                            ),
                            // Progress circle
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 1.0, end: progress),
                              duration: const Duration(milliseconds: 300),
                              builder: (context, value, child) {
                                return CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.transparent,
                                  color: colorScheme.primary,
                                  strokeCap: StrokeCap.round,
                                );
                              },
                            ),
                            // Timer text
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$_restSecondsRemaining',
                                    style: TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.primary,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    '초',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Next exercise preview
                if (currentSetIndex == 0 && currentExerciseIndex > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.1),
                          colorScheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(currentExercise.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '다음 운동',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentExercise.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Next set info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '다음 세트 준비',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${currentSet.setNumber} 세트',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getSetDescription(currentSet),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSetDescription(ExerciseSet set) {
    if (currentExercise.type == ExerciseType.weight) {
      return '${set.targetWeight}kg × ${set.targetReps}회';
    } else {
      return '${set.targetReps}회';
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isDark ? const Color(0xFF050508) : colorScheme.surface)
                .withValues(alpha: 0.0),
            isDark ? const Color(0xFF050508) : colorScheme.surface,
          ],
        ),
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isResting
                ? [
                    colorScheme.onSurface.withValues(alpha: 0.1),
                    colorScheme.onSurface.withValues(alpha: 0.05),
                  ]
                : [
                    colorScheme.primary,
                    const Color(0xFF4ECDC4),
                  ],
          ),
          boxShadow: isResting
              ? null
              : [
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
            onTap: isResting ? _skipRest : _completeSet,
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isResting
                        ? Icons.skip_next_rounded
                        : Icons.check_circle_rounded,
                    color: isResting ? colorScheme.onSurface : Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isResting ? '휴식 건너뛰기' : '세트 완료',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isResting ? colorScheme.onSurface : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Active Set Card Widget
class _ActiveSetCard extends StatefulWidget {
  final ExerciseType exerciseType;
  final int setNumber;
  final int totalSets;
  final int? targetReps;
  final double? targetWeight;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<double> onWeightChanged;

  const _ActiveSetCard({
    required this.exerciseType,
    required this.setNumber,
    required this.totalSets,
    this.targetReps,
    this.targetWeight,
    required this.onRepsChanged,
    required this.onWeightChanged,
  });

  @override
  State<_ActiveSetCard> createState() => _ActiveSetCardState();
}

class _ActiveSetCardState extends State<_ActiveSetCard> {
  late int reps;
  late double weight;

  @override
  void initState() {
    super.initState();
    reps = widget.targetReps ?? 0;
    weight = widget.targetWeight ?? 0;
  }

  @override
  void didUpdateWidget(covariant _ActiveSetCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.setNumber != widget.setNumber) {
      setState(() {
        reps = widget.targetReps ?? 0;
        weight = widget.targetWeight ?? 0;
      });
    }
  }

  void _updateReps(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      reps = (reps + delta).clamp(0, 999);
      widget.onRepsChanged(reps);
    });
  }

  void _updateWeight(double delta) {
    HapticFeedback.selectionClick();
    setState(() {
      weight = (weight + delta).clamp(0, 999);
      widget.onWeightChanged(weight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.15),
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_filled_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.setNumber} 세트',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  ' / ${widget.totalSets}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.exerciseType == ExerciseType.weight) ...[
                _buildControl(
                  context,
                  '무게',
                  'kg',
                  weight,
                  (val) => _updateWeight(val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '×',
                    style: TextStyle(
                      fontSize: 28,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
              _buildControl(
                context,
                '횟수',
                '회',
                reps.toDouble(),
                (val) => _updateReps(val.toInt()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControl(BuildContext context, String label, String unit,
      double value, ValueChanged<double> onChanged) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isInt = value % 1 == 0;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildControlButton(
              context,
              Icons.remove_rounded,
              () => onChanged(-1),
              isDark,
            ),
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isInt ? value.toInt().toString() : value.toString(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 2),
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildControlButton(
              context,
              Icons.add_rounded,
              () => onChanged(1),
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(
      BuildContext context, IconData icon, VoidCallback onPressed, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isDark
          ? colorScheme.onSurface.withValues(alpha: 0.08)
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

// Completed Set Item
class _CompletedSetItem extends StatelessWidget {
  final ExerciseSet set;
  final ExerciseType type;

  const _CompletedSetItem({required this.set, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.onSurface.withValues(alpha: 0.05)
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${set.setNumber}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${set.setNumber} 세트',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: [
              if (type == ExerciseType.weight) ...[
                Text(
                  '${set.actualWeight}kg',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '×',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
              Text(
                '${set.actualReps}회',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Workout Complete Dialog
class _WorkoutCompleteDialog extends StatefulWidget {
  final String routineName;
  final int totalSets;
  final VoidCallback onGetNft;
  final VoidCallback onSkip;

  const _WorkoutCompleteDialog({
    required this.routineName,
    required this.totalSets,
    required this.onGetNft,
    required this.onSkip,
  });

  @override
  State<_WorkoutCompleteDialog> createState() => _WorkoutCompleteDialogState();
}

class _WorkoutCompleteDialogState extends State<_WorkoutCompleteDialog>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Stack(
        children: [
          // Confetti
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _DialogConfettiPainter(
                  progress: _confettiController.value,
                ),
              );
            },
          ),

          // Dialog
          Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy icon with glow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        const Color(0xFF4ECDC4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '운동 완료!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.routineName,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                // Stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(
                        context,
                        Icons.fitness_center_rounded,
                        '${widget.totalSets}',
                        '세트 완료',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                      _buildStat(
                        context,
                        Icons.local_fire_department_rounded,
                        '100',
                        '칼로리',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '축하합니다! NFT 리워드를 받을 수 있어요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // NFT Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          const Color(0xFF4ECDC4),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onGetNft,
                        borderRadius: BorderRadius.circular(16),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'NFT 받기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(
                    '나중에 받기',
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
      BuildContext context, IconData icon, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// Confetti Painter for Dialog
class _DialogConfettiPainter extends CustomPainter {
  final double progress;

  _DialogConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final colors = [
      const Color(0xFF13ECA4),
      const Color(0xFFFFD700),
      const Color(0xFF4E80EE),
      const Color(0xFFA855F7),
      const Color(0xFF4ECDC4),
      const Color(0xFFFF6B6B),
    ];

    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final delay = random.nextDouble() * 0.3;
      final adjustedProgress = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);

      if (adjustedProgress <= 0) continue;

      final startY = size.height * 0.3;
      final endY = size.height + 50;
      final y = startY + (endY - startY) * adjustedProgress;

      final drift = math.sin(adjustedProgress * math.pi * 3 + i) * 20;

      final color = colors[i % colors.length];
      final opacity = (1.0 - adjustedProgress * 0.7).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final confettiSize = 4.0 + random.nextDouble() * 6;
      final rotation = adjustedProgress * math.pi * 4 * (random.nextBool() ? 1 : -1);

      canvas.save();
      canvas.translate(x + drift, y);
      canvas.rotate(rotation);

      if (i % 3 == 0) {
        canvas.drawCircle(Offset.zero, confettiSize / 2, paint);
      } else if (i % 3 == 1) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: confettiSize,
            height: confettiSize * 0.5,
          ),
          paint,
        );
      } else {
        final path = Path()
          ..moveTo(0, -confettiSize / 2)
          ..lineTo(confettiSize / 2, confettiSize / 2)
          ..lineTo(-confettiSize / 2, confettiSize / 2)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
