// lib/models/exercise_model.dart
class Exercise {
  final String id;
  final String name;
  final String description;
  final String instructions;
  final String category;
  final String difficultyLevel;
  final String bodyPart;
  final int durationMinutes;
  final int repetitions;
  final int sets;
  final String imageUrl;
  final String videoUrl;
  final List<String> precautions;
  final List<String> benefits;
  final bool isActive;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.category,
    required this.difficultyLevel,
    required this.bodyPart,
    required this.durationMinutes,
    required this.repetitions,
    required this.sets,
    required this.imageUrl,
    required this.videoUrl,
    required this.precautions,
    required this.benefits,
    required this.isActive,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
      category: json['category'] ?? '',
      difficultyLevel: json['difficulty_level'] ?? '',
      bodyPart: json['body_part'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      repetitions: json['repetitions'] ?? 0,
      sets: json['sets'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      precautions: List<String>.from(json['precautions'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'category': category,
      'difficulty_level': difficultyLevel,
      'body_part': bodyPart,
      'duration_minutes': durationMinutes,
      'repetitions': repetitions,
      'sets': sets,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'precautions': precautions,
      'benefits': benefits,
      'is_active': isActive,
    };
  }
}

class AssignedExercise {
  final String id;
  final String patientId;
  final String exerciseId;
  final Exercise exercise;
  final String doctorId;
  final String doctorName;
  final DateTime assignedDate;
  final int frequencyPerDay;
  final int durationDays;
  final String notes;
  final bool isCompleted;
  final List<ExerciseProgress> progress;

  AssignedExercise({
    required this.id,
    required this.patientId,
    required this.exerciseId,
    required this.exercise,
    required this.doctorId,
    required this.doctorName,
    required this.assignedDate,
    required this.frequencyPerDay,
    required this.durationDays,
    required this.notes,
    required this.isCompleted,
    required this.progress,
  });

  factory AssignedExercise.fromJson(Map<String, dynamic> json) {
    return AssignedExercise(
      id: json['id'] ?? '',
      patientId: json['patient_id'] ?? '',
      exerciseId: json['exercise_id'] ?? '',
      exercise: Exercise.fromJson(json['exercise'] ?? {}),
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      assignedDate: DateTime.parse(json['assigned_date'] ?? DateTime.now().toIso8601String()),
      frequencyPerDay: json['frequency_per_day'] ?? 1,
      durationDays: json['duration_days'] ?? 7,
      notes: json['notes'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      progress: (json['progress'] as List?)
          ?.map((p) => ExerciseProgress.fromJson(p))
          .toList() ?? [],
    );
  }
}

class ExerciseProgress {
  final String id;
  final DateTime date;
  final bool completed;
  final int setsDone;
  final int repsDone;
  final String notes;
  final String painLevel;

  ExerciseProgress({
    required this.id,
    required this.date,
    required this.completed,
    required this.setsDone,
    required this.repsDone,
    required this.notes,
    required this.painLevel,
  });

  factory ExerciseProgress.fromJson(Map<String, dynamic> json) {
    return ExerciseProgress(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      completed: json['completed'] ?? false,
      setsDone: json['sets_done'] ?? 0,
      repsDone: json['reps_done'] ?? 0,
      notes: json['notes'] ?? '',
      painLevel: json['pain_level'] ?? '',
    );
  }
}

class DietPlan {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String disease;
  final DateTime startDate;
  final DateTime endDate;
  final List<Meal> meals;
  final List<String> foodsToEat;
  final List<String> foodsToAvoid;
  final String instructions;
  final String hydrationGuidelines;
  final bool isActive;

  DietPlan({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.disease,
    required this.startDate,
    required this.endDate,
    required this.meals,
    required this.foodsToEat,
    required this.foodsToAvoid,
    required this.instructions,
    required this.hydrationGuidelines,
    required this.isActive,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      id: json['id'] ?? '',
      patientId: json['patient_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      disease: json['disease'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      meals: (json['meals'] as List?)
          ?.map((m) => Meal.fromJson(m))
          .toList() ?? [],
      foodsToEat: List<String>.from(json['foods_to_eat'] ?? []),
      foodsToAvoid: List<String>.from(json['foods_to_avoid'] ?? []),
      instructions: json['instructions'] ?? '',
      hydrationGuidelines: json['hydration_guidelines'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}

class Meal {
  final String type;
  final String time;
  final List<FoodItem> items;
  final String notes;

  Meal({
    required this.type,
    required this.time,
    required this.items,
    required this.notes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      type: json['type'] ?? '',
      time: json['time'] ?? '',
      items: (json['items'] as List?)
          ?.map((i) => FoodItem.fromJson(i))
          .toList() ?? [],
      notes: json['notes'] ?? '',
    );
  }
}

class FoodItem {
  final String name;
  final String quantity;
  final String calories;
  final String preparationMethod;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.preparationMethod,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
      calories: json['calories'] ?? '',
      preparationMethod: json['preparation_method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'calories': calories,
      'preparation_method': preparationMethod,
    };
  }
}
