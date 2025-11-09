
import 'package:equatable/equatable.dart';

abstract class ExperienceEvent extends Equatable {
  const ExperienceEvent();

  @override
  List<Object?> get props => [];
}

class LoadExperiences extends ExperienceEvent {}

class ToggleExperienceSelection extends ExperienceEvent {
  final int experienceId;
  
  const ToggleExperienceSelection(this.experienceId);
  
  @override
  List<Object?> get props => [experienceId];
}

class UpdateExperienceText extends ExperienceEvent {
  final int experienceId;
  final String text;
  
  const UpdateExperienceText(this.experienceId, this.text);
  
  @override
  List<Object?> get props => [experienceId, text];
}

class ReorderExperiences extends ExperienceEvent {
  final int oldIndex;
  final int newIndex;
  
  const ReorderExperiences(this.oldIndex, this.newIndex);
  
  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class ProceedToNextScreen extends ExperienceEvent {}
