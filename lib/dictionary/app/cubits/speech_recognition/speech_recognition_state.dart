part of 'speech_recognition_cubit.dart';

@immutable
abstract class SpeechRecognitionState {}

class SpeechRecognitionInitial extends SpeechRecognitionState {}

class SpeechRecognitionListening extends SpeechRecognitionState {}

class SpeechRecognitionNotListening extends SpeechRecognitionState {}

class SpeechRecognitionDone extends SpeechRecognitionState {
  final String text;

  SpeechRecognitionDone({required this.text});
}

class SpeechRecognitionError extends SpeechRecognitionState {}

class SpeechRecognitionPermissionError extends SpeechRecognitionState {}
