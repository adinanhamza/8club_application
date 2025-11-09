// lib/presentation/screens/question/bloc/question_state.dart

import 'package:equatable/equatable.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();
  
  @override
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionRecordingAudio extends QuestionState {
  final String path;
  
  const QuestionRecordingAudio(this.path);
  
  @override
  List<Object?> get props => [path];
}

class QuestionAudioRecorded extends QuestionState {
  final String path;
  
  const QuestionAudioRecorded(this.path);
  
  @override
  List<Object?> get props => [path];
}

class QuestionRecordingVideo extends QuestionState {
  final String path;
  
  const QuestionRecordingVideo(this.path);
  
  @override
  List<Object?> get props => [path];
}

class QuestionVideoRecorded extends QuestionState {
  final String path;
  
  const QuestionVideoRecorded(this.path);
  
  @override
  List<Object?> get props => [path];
}

class QuestionTextUpdated extends QuestionState {
  final String text;
  
  const QuestionTextUpdated(this.text);
  
  @override
  List<Object?> get props => [text];
}

class QuestionError extends QuestionState {
  final String message;
  
  const QuestionError(this.message);
  
  @override
  List<Object?> get props => [message];
}