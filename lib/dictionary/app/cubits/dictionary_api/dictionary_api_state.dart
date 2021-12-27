part of 'dictionary_api_cubit.dart';

@immutable
abstract class DictionaryApiState {}

class DictionaryApiInitial extends DictionaryApiState {}

class DictionaryApiLoading extends DictionaryApiState {}

class DictionaryApiDone extends DictionaryApiState {
  final List<WordData> wordDatas;

  DictionaryApiDone(this.wordDatas);
}

class DictionaryApiNotFound extends DictionaryApiState {}

class DictionaryApiError extends DictionaryApiState {
  final String? errorMessage;

  DictionaryApiError({this.errorMessage});
}
