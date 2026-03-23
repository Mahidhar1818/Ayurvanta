// lib/services/exercise_diet_service.dart
import '../models/exercise_model.dart';
import '../core/services/api_service.dart';

class ExerciseDietService {
  final ApiService _apiService;

  ExerciseDietService(this._apiService);

  // Exercise Library Methods
  Future<List<Exercise>> getAllExercises() async {
    try {
      final response = await _apiService.get('/exercises/');
      if (response.data['success']) {
        final List<dynamic> exercisesJson = response.data['data'];
        return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load exercises');
    } catch (e) {
      throw Exception('Error loading exercises: \$e');
    }
  }

  Future<Exercise> getExerciseById(String id) async {
    try {
      final response = await _apiService.get('/exercises/\$id/');
      if (response.data['success']) {
        return Exercise.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Exercise not found');
    } catch (e) {
      throw Exception('Error loading exercise: \$e');
    }
  }

  Future<List<Exercise>> getExercisesByCategory(String category) async {
    try {
      final response = await _apiService.get('/exercises/?category=\$category');
      if (response.data['success']) {
        final List<dynamic> exercisesJson = response.data['data'];
        return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load exercises');
    } catch (e) {
      throw Exception('Error loading exercises by category: \$e');
    }
  }

  Future<List<Exercise>> getExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await _apiService.get('/exercises/?body_part=\$bodyPart');
      if (response.data['success']) {
        final List<dynamic> exercisesJson = response.data['data'];
        return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load exercises');
    } catch (e) {
      throw Exception('Error loading exercises by body part: \$e');
    }
  }

  // Doctor: Create Exercise (Admin/Doctor only)
  Future<Exercise> createExercise(Exercise exercise) async {
    try {
      final response = await _apiService.post(
        '/exercises/create/',
        data: exercise.toJson(),
      );
      if (response.data['success']) {
        return Exercise.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to create exercise');
    } catch (e) {
      throw Exception('Error creating exercise: \$e');
    }
  }

  // Doctor: Update Exercise
  Future<Exercise> updateExercise(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        '/exercises/\$id/',
        data: data,
      );
      if (response.data['success']) {
        return Exercise.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to update exercise');
    } catch (e) {
      throw Exception('Error updating exercise: \$e');
    }
  }

  // Doctor: Assign Exercise to Patient
  Future<AssignedExercise> assignExerciseToPatient({
    required String patientId,
    required String exerciseId,
    required int frequencyPerDay,
    required int durationDays,
    required String notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/exercises/assign/',
        data: {
          'patient_id': patientId,
          'exercise_id': exerciseId,
          'frequency_per_day': frequencyPerDay,
          'duration_days': durationDays,
          'notes': notes,
        },
      );
      if (response.data['success']) {
        return AssignedExercise.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to assign exercise');
    } catch (e) {
      throw Exception('Error assigning exercise: \$e');
    }
  }

  // Patient: Get My Assigned Exercises
  Future<List<AssignedExercise>> getMyExercises() async {
    try {
      final response = await _apiService.get('/exercises/my-exercises/');
      if (response.data['success']) {
        final List<dynamic> exercisesJson = response.data['data'];
        return exercisesJson.map((json) => AssignedExercise.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load assigned exercises');
    } catch (e) {
      throw Exception('Error loading assigned exercises: \$e');
    }
  }

  // Patient: Log Exercise Progress
  Future<ExerciseProgress> logExerciseProgress({
    required String assignedExerciseId,
    required bool completed,
    required int setsDone,
    required int repsDone,
    required String notes,
    required String painLevel,
  }) async {
    try {
      final response = await _apiService.post(
        '/exercises/log-progress/',
        data: {
          'assigned_exercise_id': assignedExerciseId,
          'completed': completed,
          'sets_done': setsDone,
          'reps_done': repsDone,
          'notes': notes,
          'pain_level': painLevel,
        },
      );
      if (response.data['success']) {
        return ExerciseProgress.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to log progress');
    } catch (e) {
      throw Exception('Error logging progress: \$e');
    }
  }

  // Diet Plan Methods
  
  // Doctor: Create Diet Plan
  Future<DietPlan> createDietPlan({
    required String patientId,
    required String disease,
    required DateTime startDate,
    required DateTime endDate,
    required List<Meal> meals,
    required List<String> foodsToEat,
    required List<String> foodsToAvoid,
    required String instructions,
    required String hydrationGuidelines,
  }) async {
    try {
      final response = await _apiService.post(
        '/diet-plans/create/',
        data: {
          'patient_id': patientId,
          'disease': disease,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'meals': meals.map((m) => {
            'type': m.type,
            'time': m.time,
            'items': m.items.map((i) => i.toJson()).toList(),
            'notes': m.notes,
          }).toList(),
          'foods_to_eat': foodsToEat,
          'foods_to_avoid': foodsToAvoid,
          'instructions': instructions,
          'hydration_guidelines': hydrationGuidelines,
        },
      );
      if (response.data['success']) {
        return DietPlan.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to create diet plan');
    } catch (e) {
      throw Exception('Error creating diet plan: \$e');
    }
  }

  // Patient: Get My Diet Plans
  Future<List<DietPlan>> getMyDietPlans() async {
    try {
      final response = await _apiService.get('/diet-plans/my-plans/');
      if (response.data['success']) {
        final List<dynamic> plansJson = response.data['data'];
        return plansJson.map((json) => DietPlan.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load diet plans');
    } catch (e) {
      throw Exception('Error loading diet plans: \$e');
    }
  }

  // Doctor: Get Diet Plans by Patient ID
  Future<List<DietPlan>> getDietPlansByPatient(String patientId) async {
    try {
      final response = await _apiService.get('/diet-plans/patient/\$patientId/');
      if (response.data['success']) {
        final List<dynamic> plansJson = response.data['data'];
        return plansJson.map((json) => DietPlan.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load diet plans');
    } catch (e) {
      throw Exception('Error loading diet plans: \$e');
    }
  }

  // Doctor: Update Diet Plan
  Future<DietPlan> updateDietPlan(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        '/diet-plans/\$id/',
        data: data,
      );
      if (response.data['success']) {
        return DietPlan.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to update diet plan');
    } catch (e) {
      throw Exception('Error updating diet plan: \$e');
    }
  }
}
