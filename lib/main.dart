import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingolearn/dictionary/app/cubits/dictionary_api/dictionary_api_cubit.dart';
import 'package:pingolearn/dictionary/app/cubits/speech_recognition/speech_recognition_cubit.dart';
import 'package:pingolearn/dictionary/presentation/landing_page.dart';

void main() {
  WidgetsBinding.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _speechRecognitionCubit = SpeechRecognitionCubit();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) =>
                    DictionaryApiCubit(_speechRecognitionCubit)),
            BlocProvider(
                lazy: false, create: (context) => _speechRecognitionCubit)
          ],
          child: const LandingPage(),
        ));
  }
}
