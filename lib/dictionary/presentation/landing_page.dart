import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingolearn/dictionary/app/cubits/dictionary_api/dictionary_api_cubit.dart';
import 'package:pingolearn/dictionary/app/cubits/speech_recognition/speech_recognition_cubit.dart';
import 'package:pingolearn/dictionary/domain/get_first_word_from_sentence.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          BlocBuilder<SpeechRecognitionCubit, SpeechRecognitionState>(
              builder: (context, state) {
        return AvatarGlow(
          endRadius: 75,
          animate: state is SpeechRecognitionListening ? true : false,
          child: FloatingActionButton(
              onPressed: () {
                context.read<SpeechRecognitionCubit>().startlistening();
              },
              child: const Icon(Icons.mic_none, color: Colors.white)),
        );
      }),
      appBar: AppBar(
        title: const Text('PingoLearn-Round 1'),
        centerTitle: true,
      ),
      body: SafeArea(child:
          BlocBuilder<SpeechRecognitionCubit, SpeechRecognitionState>(
              builder: (context, state) {
        if (state is SpeechRecognitionListening) {
          return Row(
            children: const [Text('Listening...'), CircularProgressIndicator()],
          );
        } else if (state is SpeechRecognitionDone) {
          return BlocBuilder<DictionaryApiCubit, DictionaryApiState>(
              builder: (context, dictionaryState) {
            if (dictionaryState is DictionaryApiDone) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Word: \n ${GetFirstWordFromSentence.getFirstWord(state.text)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Meaning',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            dictionaryState.wordDatas.elementAt(0).meaning,
                            style: const TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            'Example',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            dictionaryState.wordDatas.elementAt(0).example,
                            style: const TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  Image.network(
                      dictionaryState.wordDatas.elementAt(0).imageUrl!),
                ],
              );
            } else if (dictionaryState is DictionaryApiNotFound) {
              return Image.asset('assets/images/not_found.png');
            } else {
              return Text(
                  'fetching meaning... ${GetFirstWordFromSentence.getFirstWord(state.text)}');
            }
          });
        } else {
          return const Text('Press the button to start speaking');
        }
      })),
    );
  }
}
