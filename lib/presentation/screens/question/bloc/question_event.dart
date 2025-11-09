

import 'package:equatable/equatable.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object?> get props => [];
}

class StartAudioRecording extends QuestionEvent {}

class StopAudioRecording extends QuestionEvent {}

class CancelAudioRecording extends QuestionEvent {}

class DeleteAudio extends QuestionEvent {}

class StartVideoRecording extends QuestionEvent {}

class StopVideoRecording extends QuestionEvent {}

class CancelVideoRecording extends QuestionEvent {}

class DeleteVideo extends QuestionEvent {}

class UpdateTextAnswer extends QuestionEvent {
  final String text;
  
  const UpdateTextAnswer(this.text);
  
  @override
  List<Object?> get props => [text];
}

class SubmitAnswer extends QuestionEvent {}