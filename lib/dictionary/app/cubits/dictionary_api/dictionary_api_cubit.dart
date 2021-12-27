import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pingolearn/dictionary/app/cubits/speech_recognition/speech_recognition_cubit.dart';
import 'package:pingolearn/dictionary/domain/get_first_word_from_sentence.dart';
import 'package:pingolearn/dictionary/domain/word.dart';
import 'package:pingolearn/dictionary/domain/word_failure.dart';
import 'package:pingolearn/dictionary/infrastructure/word_repository.dart';

part 'dictionary_api_state.dart';

class DictionaryApiCubit extends Cubit<DictionaryApiState> {
  final SpeechRecognitionCubit _speechRecognitionCubit;
  late final StreamSubscription _speechStreamSubscription;
  final WordRepository _wordRepository = WordRepository();
  DictionaryApiCubit(this._speechRecognitionCubit)
      : super(DictionaryApiInitial()) {
    _speechStreamSubscription =
        _speechRecognitionCubit.stream.listen((state) async {
      if (state is SpeechRecognitionDone) {
        final String word = GetFirstWordFromSentence.getFirstWord(state.text);
        await fetchWordData(word);
      }
    });
  }

  Future<void> fetchWordData(String word) async {
    emit(DictionaryApiLoading());
    final _successOrFailure = await _wordRepository.getWordData(word);
    _successOrFailure.fold((l) {
      if (l is WordFailureNoInternet) {
        emit(DictionaryApiError(errorMessage: 'No Internet'));
      } else if (l is WordFailureNotAuthorized) {
        emit(DictionaryApiError(errorMessage: 'Not Authorized'));
      } else if (l is WordFailureNotFound) {
        emit(DictionaryApiNotFound());
      } else if (l is WordFailureApi) {
        emit(DictionaryApiError(errorMessage: l.errorCode ?? 'error'));
      }
    }, (r) {
      emit(DictionaryApiDone(r));
    });
  }
}
