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
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA3cYjHCw_Xy1cZqYRJ8uEbP1sX-_7UoCcVd2CZzNpU9GQXnFFkCdfHFV88wijPpmijDNnlE5N-T3VXrjaU6v9YBccLiF3w5drmhMNmyOfYPgZgCOtQdnz81QO7ZBYN_RLy5MRIo8XLO_MeWgs-CmNvVSOMzGKn7lZJqd7o6PdUz7kdurz4sE6jCtzBXkd3kW4oI3Nl4pBl8kEPzcyxV3d6aE8-IacZiAkkP_dA4gai_KLEE8esyN38bQQ1a_z-l-ehHtAQ5jxKNq_b',
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
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQmX707uentpGAr4C8BjJhj4sz8hwOvMZggSaM9SqXuZPSv-JlZk2RP0b-31Jr_zNlGHUvfly5nKPk_qAnwZ7vIYbM_BvFzOoUKYNc62ZHkYxDW-xkTniBX5YTMWAW1kydxpW85aSdSC3FR5uCn3_EjM_gHBN_c-BrafSA6y4uLBBwDnGEkwwYpg4UpbNxpVrVuCDdj3Z3posPhEl5nfYFkTF3cS8jqv0b7n_NPAdrSZEOazx1yiSpU_OTz_Wt0T5oPfHYJeW0iKlE',
        type: ExerciseType.bodyweight,
        defaultRestSeconds: 60,
        sets: [
          ExerciseSet(setNumber: 1, targetReps: 15),
          ExerciseSet(setNumber: 2, targetReps: 12),
          ExerciseSet(setNumber: 3, targetReps: 10),
        ],
      ),
      // 3. Push Up (Upper Body)
      Exercise(
        id: 'ex_003',
        name: '푸시업',
        description: '가슴과 팔, 코어를 동시에 단련합니다.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeByvIEjhZ1mNGb1WARCSShZyku1-w9CRB2QVwXlRQy_aCKcH4g_VbwjxDKbmch2E3CxQ2VU-m3UajhcLZaj5oSwTYQ7S3kLverJEOMzvV4CIO6zAfjWNr_VVHHIvUl6UMPAtx9yWk2Turm1kwTPYniY6HiiWZ2Zr1QT5rL7KsRRymOwD8pl4wsZS9yyITSLRjZnM8oxRqlspbpIMkRMp_Uo_ihPc1cKheU05Agsyj27ThdV6B2ioK7Cfijx-Y_PyO9Yw-cTo5dg_B',
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
