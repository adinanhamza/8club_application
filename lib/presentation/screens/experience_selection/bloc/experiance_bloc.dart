// experience_bloc.dart
import 'package:flutter_application_1/data/models/experience_model.dart';
import 'package:flutter_application_1/data/repositories/experience_repository.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_event.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ExperienceRepository repository;

  ExperienceBloc({required this.repository}) : super(ExperienceInitial()) {
    on<LoadExperiences>(_onLoadExperiences);
    on<ToggleExperienceSelection>(_onToggleExperienceSelection);
    on<UpdateExperienceText>(_onUpdateExperienceText);
    on<ReorderExperiences>(_onReorderExperiences);
    on<ProceedToNextScreen>(_onProceedToNextScreen);
  }

  Future<void> _onLoadExperiences(
    LoadExperiences event,
    Emitter<ExperienceState> emit,
  ) async {
    emit(ExperienceLoading());
    try {
      final experiences = await repository.getExperiences();
      emit(ExperienceLoaded(experiences));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  void _onToggleExperienceSelection(
    ToggleExperienceSelection event,
    Emitter<ExperienceState> emit,
  ) {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      final updatedExperiences = currentState.experiences.map((exp) {
        if (exp.id == event.experienceId) {
          return exp.copyWith(isSelected: !exp.isSelected);
        }
        return exp;
      }).toList();

      // Move selected card to first position (animation)
      final selectedIndex = updatedExperiences
          .indexWhere((exp) => exp.id == event.experienceId);
      if (selectedIndex != -1 && updatedExperiences[selectedIndex].isSelected) {
        final selectedExperience = updatedExperiences.removeAt(selectedIndex);
        updatedExperiences.insert(0, selectedExperience);
      }

      emit(ExperienceLoaded(updatedExperiences));
    }
  }

  void _onUpdateExperienceText(
    UpdateExperienceText event,
    Emitter<ExperienceState> emit,
  ) {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      final updatedExperiences = currentState.experiences.map((exp) {
        if (exp.id == event.experienceId) {
          return exp.copyWith(customText: event.text);
        }
        return exp;
      }).toList();
      emit(ExperienceLoaded(updatedExperiences));
    }
  }

  void _onReorderExperiences(
    ReorderExperiences event,
    Emitter<ExperienceState> emit,
  ) {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      final updatedExperiences = List<Experience>.from(currentState.experiences);
      final item = updatedExperiences.removeAt(event.oldIndex);
      updatedExperiences.insert(event.newIndex, item);
      emit(ExperienceLoaded(updatedExperiences));
    }
  }

  void _onProceedToNextScreen(
    ProceedToNextScreen event,
    Emitter<ExperienceState> emit,
  ) {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      final selectedExperiences = currentState.experiences
          .where((exp) => exp.isSelected)
          .toList();
      
      // Log the state
      print('Selected Experiences:');
      for (var exp in selectedExperiences) {
        print('ID: \${exp.id}, Name: \${exp.name}, Text: \${exp.customText}');
      }
    }
  }
}