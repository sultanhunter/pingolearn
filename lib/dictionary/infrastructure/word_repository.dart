import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pingolearn/dictionary/domain/word.dart';
import 'package:pingolearn/dictionary/domain/word_failure.dart';

class WordRepository {
  final _client = Dio();

  final _headers = {
    'Authorization': 'Token 08a5e3222b8be11a8bdcbaa455cb0f7ab1e7f608',
    'Accept': 'application/json',
  };

  Future<Either<WordFailure, List<WordData>>> getWordData(String word) async {
    final Completer<Either<WordFailure, List<WordData>>> _completer =
        Completer();
    try {
      final response =
          await _client.get('https://owlbot.info/api/v4/dictionary/$word',
              options: Options(
                contentType: 'applicaton/json',
                receiveTimeout: 4000,
                headers: _headers,
              ));

      if (response.statusCode == 200) {
        final _data = response.data as Map<String, dynamic>;
        final List<dynamic> _listOfDefinitions = _data['definitions'];
        final List<WordData> _convertedData = _listOfDefinitions.map((e) {
          return WordData.fromMap({
            'definition': e['definition'],
            'example': e['example'],
            'image_url': e['image_url']
          });
        }).toList();

        _completer.complete(right(_convertedData));
      } else if (response.statusCode == 404) {
        print('404');
        _completer.complete(left(WordFailureNotFound()));
      } else if (response.statusCode == 503) {
        _completer.complete(left(WordFailureApi(errorCode: '503')));
      } else {
        _completer
            .complete(left(WordFailureApi(errorCode: 'something not right')));
      }
    } catch (e) {
      if (e is SocketException) {
        _completer.complete(left(WordFailureNoInternet()));
      } else {
        _completer.complete(left(WordFailureApi(errorCode: e.toString())));
      }
    }

    return _completer.future;
  }
}
