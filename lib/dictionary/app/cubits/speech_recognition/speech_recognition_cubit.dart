import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'speech_recognition_state.dart';

class SpeechRecognitionCubit extends Cubit<SpeechRecognitionState> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  SpeechRecognitionCubit() : super(SpeechRecognitionInitial());

  Future<void> startlistening() async {
    bool isReady = await _speech.initialize(onStatus: (status) {
      if (status == 'listening') {
        emit(SpeechRecognitionListening());
      } else if (status == 'notListening') {
        emit(SpeechRecognitionNotListening());
      } else {}
    }, onError: (e) {
      emit(SpeechRecognitionError());
    });

    if (isReady) {
      _speech.listen(
          onResult: (result) {
            emit(SpeechRecognitionDone(text: result.recognizedWords));
          },
          listenFor: const Duration(seconds: 4));
    } else {
      emit(SpeechRecognitionPermissionError());
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }
}
