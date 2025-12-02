import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/core/config/app_theme.dart';
import 'package:team_wellness/core/data/mock_routine_data.dart';
import 'package:team_wellness/core/models/exercise_model.dart';

class CoachingProgressScreen extends StatefulWidget {
  final String programId;
  const CoachingProgressScreen({super.key, required this.programId});

  @override
  State<CoachingProgressScreen> createState() => _CoachingProgressScreenState();
}

class _CoachingProgressScreenState extends State<CoachingProgressScreen> {
  late Routine routine;
  int currentExerciseIndex = 0;
  
  // Timer State
  Timer? _timer;
  int _restSecondsRemaining = 0;
  bool isResting = false;

  // Scroll Controller to auto-scroll to active set
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // In a real app, fetch by widget.programId
    // IMPORTANT: Reset the static data state when entering the screen
    routine = MockRoutineData.dailyRoutine;
    for (var exercise in routine.exercises) {
      for (var set in exercise.sets) {
        set.isCompleted = false;
        set.actualReps = null;
        set.actualWeight = null;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Exercise get currentExercise => routine.exercises[currentExerciseIndex];
  
  List<ExerciseSet> get currentSets => currentExercise.sets;

  int get currentSetIndex {
    // Find the first incomplete set
    int index = currentSets.indexWhere((set) => !set.isCompleted);
    // If all completed, return last index
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

    // 이전까지 끝낸 운동은 세트 전체를 완료한 것으로 계산
    for (int i = 0; i < currentExerciseIndex; i++) {
      completedTotal += routine.exercises[i].sets.length;
    }

    // 현재 운동은 완료한 세트만 반영
    completedTotal += completedSetsInCurrentExercise;

    return completedTotal;
  }

  double get _overallProgress {
    if (_totalSetsInRoutine == 0) return 0;
    return _completedSetsInRoutine / _totalSetsInRoutine;
  }

  void _startRestTimer() {
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
    _timer?.cancel();
    setState(() {
      isResting = false;
    });
    // Auto-scroll to the next set if needed
  }

  void _completeSet() {
    setState(() {
      // Mark current set as complete
      currentSet.isCompleted = true;
      // Save actual values
      currentSet.actualReps ??= currentSet.targetReps;
      currentSet.actualWeight ??= currentSet.targetWeight;
    });

    if (isLastSetOfExercise) {
      if (isLastExercise) {
        _showWorkoutCompleteDialog();
      } else {
        // Transition to next exercise immediately
        setState(() {
          currentExerciseIndex++;
        });
        // Start rest timer for the next exercise
        _startRestTimer();
      }
    } else {
      // Go to rest
      _startRestTimer();
    }
  }

  void _showWorkoutCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 운동 종료!'),
        content: const Text('모든 운동을 완료했습니다.\n수고하셨습니다!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              context.pop(); // Exit screen
            },
            child: const Text('완료'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: Text(
          currentExercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              '종료',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Progress Bar & Header Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '전체 루틴 진행률',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$_completedSetsInRoutine / $_totalSetsInRoutine 세트 완료',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _overallProgress,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: appColors?.freshGreen ?? colorScheme.primary,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),

          Expanded(
            child: isResting 
              ? _buildRestView(context)
              : _buildActiveView(context),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildActiveView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Guide Image
           Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surfaceContainerHighest,
              image: DecorationImage(
                image: NetworkImage(currentExercise.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '가이드',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Active Set Card
          _ActiveSetCard(
            exerciseType: currentExercise.type,
            setNumber: currentSet.setNumber,
            targetReps: currentSet.targetReps,
            targetWeight: currentSet.targetWeight,
            onRepsChanged: (val) => currentSet.actualReps = val,
            onWeightChanged: (val) => currentSet.actualWeight = val,
          ),
          
          const SizedBox(height: 24),

          // Previous Sets Summary
          if (currentSetIndex > 0)
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '완료된 세트',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...currentSets.take(currentSetIndex).map((set) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _CompletedSetItem(set: set, type: currentExercise.type),
                  )
                ),
              ],
             ),
        ],
      ),
    );
  }

  Widget _buildRestView(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '휴식 시간',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: _restSecondsRemaining / currentExercise.defaultRestSeconds,
                strokeWidth: 12,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: appColors?.freshGreen ?? colorScheme.primary,
              ),
              Center(
                child: Text(
                  '${_restSecondsRemaining}s',
                  style: TextStyle(
                    fontSize: 48, 
                    fontWeight: FontWeight.bold,
                    color: appColors?.freshGreen ?? colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        
        // Only show "Next Exercise" if we are at the start of a new exercise (Transition Rest)
        if (currentSetIndex == 0) ...[
          Text(
            '다음 운동: ${currentExercise.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        Text(
          '${currentSet.setNumber} 세트 준비',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        if (currentSetIndex < currentSets.length)
          Text(
            _getSetDescription(currentSet),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
      ],
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
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final colorScheme = Theme.of(context).colorScheme;
    final baseStart = appColors?.freshMint ?? colorScheme.primary;
    final baseEnd = appColors?.freshGreen ?? colorScheme.secondary;
    final restStart = baseStart.withValues(alpha: 0.7);
    final restEnd = baseEnd.withValues(alpha: 0.7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isResting ? _skipRest : _completeSet,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isResting 
                    ? [restStart, restEnd]
                    : [baseStart, baseEnd],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  isResting ? '휴식 건너뛰기' : '세트 완료',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Changed to white for better contrast on gradient
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveSetCard extends StatefulWidget {
  final ExerciseType exerciseType;
  final int setNumber;
  final int? targetReps;
  final double? targetWeight;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<double> onWeightChanged;

  const _ActiveSetCard({
    required this.exerciseType,
    required this.setNumber,
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
    setState(() {
      reps = (reps + delta).clamp(0, 999);
      widget.onRepsChanged(reps);
    });
  }

  void _updateWeight(double delta) {
    setState(() {
      weight = (weight + delta).clamp(0, 999);
      widget.onWeightChanged(weight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
           Text(
            '${widget.setNumber} 세트',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.exerciseType == ExerciseType.weight) ...[
                _buildControl(context, '무게 (kg)', weight, (val) => _updateWeight(val)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('X', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
              ],
              _buildControl(context, '횟수 (Rep)', reps.toDouble(), (val) => _updateReps(val.toInt())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControl(BuildContext context, String label, double value, ValueChanged<double> onChanged) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInt = value % 1 == 0;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _CircularButton(icon: Icons.remove, onPressed: () => onChanged(-1)),
            Container(
              width: 70,
              alignment: Alignment.center,
              child: Text(
                isInt ? value.toInt().toString() : value.toString(),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            _CircularButton(icon: Icons.add, onPressed: () => onChanged(1)),
          ],
        ),
      ],
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircularButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.dark 
            ? colorScheme.surfaceContainerHighest 
            : colorScheme.surfaceContainerHigh,
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}

class _CompletedSetItem extends StatelessWidget {
  final ExerciseSet set;
  final ExerciseType type;

  const _CompletedSetItem({required this.set, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${set.setNumber} 세트',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              if (type == ExerciseType.weight) ...[
                Text('${set.actualWeight}kg'),
                const SizedBox(width: 8),
                Text(
                  '|',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text('${set.actualReps}회'),
              const SizedBox(width: 12),
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
