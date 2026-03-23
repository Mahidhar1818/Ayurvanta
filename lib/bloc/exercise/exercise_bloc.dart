// lib/bloc/exercise/exercise_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/exercise_model.dart';
import '../../services/exercise_diet_service.dart';

// Events
abstract class ExerciseEvent {}

class LoadExercises extends ExerciseEvent {}
class LoadExercisesByCategory extends ExerciseEvent {
  final String category;
  LoadExercisesByCategory(this.category);
}
class LoadExercisesByBodyPart extends ExerciseEvent {
  final String bodyPart;
  LoadExercisesByBodyPart(this.bodyPart);
}
class LoadMyAssignedExercises extends ExerciseEvent {}
class AssignExercise extends ExerciseEvent {
  final String patientId;
  final String exerciseId;
  final int frequencyPerDay;
  final int durationDays;
  final String notes;
  AssignExercise({
    required this.patientId,
    required this.exerciseId,
    required this.frequencyPerDay,
    required this.durationDays,
    required this.notes,
  });
}
class LogExerciseProgress extends ExerciseEvent {
  final String assignedExerciseId;
  final bool completed;
  final int setsDone;
  final int repsDone;
  final String notes;
  final String painLevel;
  LogExerciseProgress({
    required this.assignedExerciseId,
    required this.completed,
    required this.setsDone,
    required this.repsDone,
    required this.notes,
    required this.painLevel,
  });
}
class SearchExercises extends ExerciseEvent {
  final String query;
  SearchExercises(this.query);
}

// States
abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}
class ExerciseLoading extends ExerciseState {}
class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final List<AssignedExercise> assignedExercises;
  ExerciseLoaded({required this.exercises, required this.assignedExercises});
}
class ExerciseError extends ExerciseState {
  final String message;
  ExerciseError(this.message);
}
class ExerciseAssigned extends ExerciseState {
  final AssignedExercise assignedExercise;
  ExerciseAssigned(this.assignedExercise);
}
class ProgressLogged extends ExerciseState {
  final ExerciseProgress progress;
  ProgressLogged(this.progress);
}

// BLoC
class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseDietService _service;

  ExerciseBloc(this._service) : super(ExerciseInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<LoadExercisesByCategory>(_onLoadExercisesByCategory);
    on<LoadExercisesByBodyPart>(_onLoadExercisesByBodyPart);
    on<LoadMyAssignedExercises>(_onLoadMyAssignedExercises);
    on<AssignExercise>(_onAssignExercise);
    on<LogExerciseProgress>(_onLogExerciseProgress);
    on<SearchExercises>(_onSearchExercises);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await _service.getAllExercises();
      final assignedExercises = await _service.getMyExercises();
      emit(ExerciseLoaded(
        exercises: exercises,
        assignedExercises: assignedExercises,
      ));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onLoadExercisesByCategory(
    LoadExercisesByCategory event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await _service.getExercisesByCategory(event.category);
      emit(ExerciseLoaded(
        exercises: exercises,
        assignedExercises: [],
      ));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onLoadExercisesByBodyPart(
    LoadExercisesByBodyPart event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await _service.getExercisesByBodyPart(event.bodyPart);
      emit(ExerciseLoaded(
        exercises: exercises,
        assignedExercises: [],
      ));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onLoadMyAssignedExercises(
    LoadMyAssignedExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final assignedExercises = await _service.getMyExercises();
      emit(ExerciseLoaded(
        exercises: [],
        assignedExercises: assignedExercises,
      ));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onAssignExercise(
    AssignExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final assigned = await _service.assignExerciseToPatient(
        patientId: event.patientId,
        exerciseId: event.exerciseId,
        frequencyPerDay: event.frequencyPerDay,
        durationDays: event.durationDays,
        notes: event.notes,
      );
      emit(ExerciseAssigned(assigned));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onLogExerciseProgress(
    LogExerciseProgress event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final progress = await _service.logExerciseProgress(
        assignedExerciseId: event.assignedExerciseId,
        completed: event.completed,
        setsDone: event.setsDone,
        repsDone: event.repsDone,
        notes: event.notes,
        painLevel: event.painLevel,
      );
      emit(ProgressLogged(progress));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onSearchExercises(
    SearchExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final allExercises = await _service.getAllExercises();
      final filtered = allExercises
          .where((e) =>
              e.name.toLowerCase().contains(event.query.toLowerCase()) ||
              e.description.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(ExerciseLoaded(
        exercises: filtered,
        assignedExercises: [],
      ));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }
}
