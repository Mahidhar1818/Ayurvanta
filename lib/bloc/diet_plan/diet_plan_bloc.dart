// lib/bloc/diet_plan/diet_plan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/exercise_model.dart';
import '../../services/exercise_diet_service.dart';

// Events
abstract class DietPlanEvent {}

class LoadMyDietPlans extends DietPlanEvent {}
class LoadDietPlansByPatient extends DietPlanEvent {
  final String patientId;
  LoadDietPlansByPatient(this.patientId);
}
class CreateDietPlan extends DietPlanEvent {
  final String patientId;
  final String disease;
  final DateTime startDate;
  final DateTime endDate;
  final List<Meal> meals;
  final List<String> foodsToEat;
  final List<String> foodsToAvoid;
  final String instructions;
  final String hydrationGuidelines;
  CreateDietPlan({
    required this.patientId,
    required this.disease,
    required this.startDate,
    required this.endDate,
    required this.meals,
    required this.foodsToEat,
    required this.foodsToAvoid,
    required this.instructions,
    required this.hydrationGuidelines,
  });
}
class UpdateDietPlan extends DietPlanEvent {
  final String id;
  final Map<String, dynamic> data;
  UpdateDietPlan(this.id, this.data);
}

// States
abstract class DietPlanState {}

class DietPlanInitial extends DietPlanState {}
class DietPlanLoading extends DietPlanState {}
class DietPlanLoaded extends DietPlanState {
  final List<DietPlan> dietPlans;
  DietPlanLoaded(this.dietPlans);
}
class DietPlanCreated extends DietPlanState {
  final DietPlan dietPlan;
  DietPlanCreated(this.dietPlan);
}
class DietPlanError extends DietPlanState {
  final String message;
  DietPlanError(this.message);
}

// BLoC
class DietPlanBloc extends Bloc<DietPlanEvent, DietPlanState> {
  final ExerciseDietService _service;

  DietPlanBloc(this._service) : super(DietPlanInitial()) {
    on<LoadMyDietPlans>(_onLoadMyDietPlans);
    on<LoadDietPlansByPatient>(_onLoadDietPlansByPatient);
    on<CreateDietPlan>(_onCreateDietPlan);
    on<UpdateDietPlan>(_onUpdateDietPlan);
  }

  Future<void> _onLoadMyDietPlans(
    LoadMyDietPlans event,
    Emitter<DietPlanState> emit,
  ) async {
    emit(DietPlanLoading());
    try {
      final plans = await _service.getMyDietPlans();
      emit(DietPlanLoaded(plans));
    } catch (e) {
      emit(DietPlanError(e.toString()));
    }
  }

  Future<void> _onLoadDietPlansByPatient(
    LoadDietPlansByPatient event,
    Emitter<DietPlanState> emit,
  ) async {
    emit(DietPlanLoading());
    try {
      final plans = await _service.getDietPlansByPatient(event.patientId);
      emit(DietPlanLoaded(plans));
    } catch (e) {
      emit(DietPlanError(e.toString()));
    }
  }

  Future<void> _onCreateDietPlan(
    CreateDietPlan event,
    Emitter<DietPlanState> emit,
  ) async {
    emit(DietPlanLoading());
    try {
      final plan = await _service.createDietPlan(
        patientId: event.patientId,
        disease: event.disease,
        startDate: event.startDate,
        endDate: event.endDate,
        meals: event.meals,
        foodsToEat: event.foodsToEat,
        foodsToAvoid: event.foodsToAvoid,
        instructions: event.instructions,
        hydrationGuidelines: event.hydrationGuidelines,
      );
      emit(DietPlanCreated(plan));
    } catch (e) {
      emit(DietPlanError(e.toString()));
    }
  }

  Future<void> _onUpdateDietPlan(
    UpdateDietPlan event,
    Emitter<DietPlanState> emit,
  ) async {
    emit(DietPlanLoading());
    try {
      final plan = await _service.updateDietPlan(event.id, event.data);
      emit(DietPlanCreated(plan));
    } catch (e) {
      emit(DietPlanError(e.toString()));
    }
  }
}
