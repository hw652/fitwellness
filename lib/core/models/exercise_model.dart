enum ExerciseType {
  weight, // Squat, PushUp (Weight + Reps)
  cardio, // Jumping Jack (Time or Reps only, no weight)
  bodyweight // PushUp can be this too if no added weight
}

class ExerciseSet {
  final int setNumber;
  int? targetReps;
  int? targetTimeSeconds;
  double? targetWeight;
  
  int? actualReps;
  int? actualTimeSeconds;
  double? actualWeight;
  
  bool isCompleted;

  ExerciseSet({
    required this.setNumber,
    this.targetReps,
    this.targetTimeSeconds,
    this.targetWeight,
    this.actualReps,
    this.actualTimeSeconds,
    this.actualWeight,
    this.isCompleted = false,
  });
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final ExerciseType type;
  final List<ExerciseSet> sets;
  final int defaultRestSeconds;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.sets,
    this.defaultRestSeconds = 60,
  });
}

class Routine {
  final String id;
  final String name;
  final List<Exercise> exercises;

  Routine({required this.id, required this.name, required this.exercises});
}
