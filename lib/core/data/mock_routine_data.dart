import 'package:team_wellness/core/models/exercise_model.dart';

class MockRoutineData {
  static final Routine dailyRoutine = Routine(
    id: 'routine_001',
    name: '전신 기초 근력 강화',
    exercises: [
      // 1. Jumping Jack (Warm-up)
      Exercise(
        id: 'ex_001',
        name: '점핑 잭',
        description: '전신 유산소 운동으로 심박수를 높이고 관절을 예열합니다.',
        imageUrl: 'https://media.istockphoto.com/id/1322355797/vector/jumping-jacks-exercise-guide-colorful-illustration.jpg?s=612x612&w=0&k=20&c=F6Nq-N1RjVlA_u-D_uB-O-y-G-F-i-g-h-t-s-c-o-m', // Placeholder
        type: ExerciseType.bodyweight,
        defaultRestSeconds: 30,
        sets: [
          ExerciseSet(setNumber: 1, targetReps: 20),
          ExerciseSet(setNumber: 2, targetReps: 20),
          ExerciseSet(setNumber: 3, targetReps: 30),
        ],
      ),
      // 2. Squat (Main Leg)
      Exercise(
        id: 'ex_002',
        name: '스쿼트',
        description: '하체 근력 강화의 핵심 운동입니다. 허리를 곧게 펴고 진행하세요.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDwVzmCHIYTYowahPS4_5FXfVrb94ev-HcBAihSsOy4pBIWmowtdxXiJQIDgcJ3d-aYiWXzaPy4rb4oPPI1yR-Hc6ReyvFOgDxY2ZgFYEdVEI6_rOIxYys-c--8BU3bqwdMNck55g2bMPx2iEnxKzLqYRFGGJytZFkF-ezFC69ffBHewvtalWQF7Dl2Ou5lscuhWQy1k6ZSyNBNzlXG88qZgftwJ3z4SHN0i9kVi9mkUr-x-LwC8RuWnF-JZbEpY1HIZ5r2TCyCUBG4',
        type: ExerciseType.bodyweight,
        defaultRestSeconds: 60,
        sets: [
          ExerciseSet(setNumber: 1, targetReps: 15), // Warm up
          ExerciseSet(setNumber: 2, targetReps: 12),
          ExerciseSet(setNumber: 3, targetReps: 10),
        ],
      ),
      // 3. Push Up (Upper Body)
      Exercise(
        id: 'ex_003',
        name: '푸시업',
        description: '가슴과 팔, 코어를 동시에 단련합니다.',
        imageUrl: 'https://t4.ftcdn.net/jpg/03/11/77/80/360_F_311778012_9O6d3Y9w6F6B3c6F3c6F3c6F3c6F3c6.jpg', // Placeholder
        type: ExerciseType.bodyweight,
        defaultRestSeconds: 45,
        sets: [
          ExerciseSet(setNumber: 1, targetReps: 15),
          ExerciseSet(setNumber: 2, targetReps: 12),
          ExerciseSet(setNumber: 3, targetReps: 10),
        ],
      ),
    ],
  );
}
