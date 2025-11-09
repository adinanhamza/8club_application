// lib/presentation/screens/question/bloc/question_bloc.dart

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'question_event.dart';
import 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final AudioRecorder _audioRecorder = AudioRecorder(); // FIXED: Use AudioRecorder
  String? _audioPath;
  String? _videoPath;
  String? _textAnswer;

  QuestionBloc() : super(QuestionInitial()) {
    on<StartAudioRecording>(_onStartAudioRecording);
    on<StopAudioRecording>(_onStopAudioRecording);
    on<CancelAudioRecording>(_onCancelAudioRecording);
    on<DeleteAudio>(_onDeleteAudio);
    on<StartVideoRecording>(_onStartVideoRecording);
    on<StopVideoRecording>(_onStopVideoRecording);
    on<CancelVideoRecording>(_onCancelVideoRecording);
    on<DeleteVideo>(_onDeleteVideo);
    on<UpdateTextAnswer>(_onUpdateTextAnswer);
    on<SubmitAnswer>(_onSubmitAnswer);
  }

  Future<void> _onStartAudioRecording(
    StartAudioRecording event,
    Emitter<QuestionState> emit,
  ) async {
    try {
      final hasPerm = await _audioRecorder.hasPermission();
      if (!hasPerm) {
        emit(const QuestionError('Audio permission not granted'));
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // FIXED: Use RecordConfig
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100, // FIXED: Changed from samplingRate to sampleRate
        ),
        path: path,
      );

      _audioPath = path; // Store the path
      emit(QuestionRecordingAudio(path));
    } catch (e, st) {
      print('start audio error: $e\n$st');
      emit(QuestionError(e.toString()));
    }
  }

  Future<void> _onStopAudioRecording(
    StopAudioRecording event,
    Emitter<QuestionState> emit,
  ) async {
    try {
      final path = await _audioRecorder.stop();
      
      // FIXED: Use async exists() instead of existsSync()
      final finalPath = path ?? _audioPath;
      if (finalPath != null && await File(finalPath).exists()) {
        _audioPath = finalPath;
        emit(QuestionAudioRecorded(finalPath));
      } else {
        emit(const QuestionError('Recording failed or file missing'));
      }
    } catch (e, st) {
      print('stop audio error: $e\n$st');
      emit(QuestionError(e.toString()));
    }
  }

  Future<void> _onCancelAudioRecording(
    CancelAudioRecording event,
    Emitter<QuestionState> emit,
  ) async {
    try {
      // Stop recording
      try {
        final path = await _audioRecorder.stop();
        if (path != null) {
          final f = File(path);
          if (await f.exists()) await f.delete();
        }
      } catch (_) {
        // Ignore stop errors
      }
      
      // Delete stored path if exists
      if (_audioPath != null) {
        final f = File(_audioPath!);
        if (await f.exists()) await f.delete();
      }
      
      _audioPath = null;
      emit(QuestionInitial());
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }

  Future<void> _onDeleteAudio(
    DeleteAudio event,
    Emitter<QuestionState> emit,
  ) async {
    if (_audioPath != null) {
      try {
        final f = File(_audioPath!);
        if (await f.exists()) await f.delete();
      } catch (e) {
        print('Delete audio error: $e');
      }
    }
    _audioPath = null;
    emit(QuestionInitial());
  }

  void _onStartVideoRecording(
    StartVideoRecording event,
    Emitter<QuestionState> emit,
  ) {
    // Video handled in widgets
    emit(QuestionRecordingVideo(''));
  }

  void _onStopVideoRecording(
    StopVideoRecording event,
    Emitter<QuestionState> emit,
  ) {
    if (_videoPath != null) {
      emit(QuestionVideoRecorded(_videoPath!));
    } else {
      emit(QuestionInitial());
    }
  }

  void _onCancelVideoRecording(
    CancelVideoRecording event,
    Emitter<QuestionState> emit,
  ) {
    _videoPath = null;
    emit(QuestionInitial());
  }

  Future<void> _onDeleteVideo(
    DeleteVideo event,
    Emitter<QuestionState> emit,
  ) async {
    if (_videoPath != null) {
      try {
        final f = File(_videoPath!);
        if (await f.exists()) await f.delete();
      } catch (e) {
        print('Delete video error: $e');
      }
    }
    _videoPath = null;
    emit(QuestionInitial());
  }

  void _onUpdateTextAnswer(
    UpdateTextAnswer event,
    Emitter<QuestionState> emit,
  ) {
    _textAnswer = event.text;
    emit(QuestionTextUpdated(event.text));
  }

  void _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<QuestionState> emit,
  ) {
    print('===== Question Answers =====');
    print('Text Answer: $_textAnswer');
    print('Audio Path: ${_audioPath ?? "No audio"}');
    print('Video Path: ${_videoPath ?? "No video"}');
    print('===========================');
  }

  void setVideoPath(String path) {
    _videoPath = path;
  }

  @override
  Future<void> close() {
    // FIXED: Dispose the recorder properly
    _audioRecorder.dispose();
    return super.close();
  }
}