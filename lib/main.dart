import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'alert_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 11, 87, 198),
          secondary: Color.fromARGB(255, 0, 183, 7),
          tertiary: Color.fromARGB(255, 230, 55, 55),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool _showSplashScreen = true;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    Future.delayed(Duration(seconds: 2), _stopShowingSplashScreen);
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _stopShowingSplashScreen() {
    _showSplashScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    var werongWayNoti = Column(
      children: [
        NotificationWidget(
          text: 'You are in the wrong way!',
          assetImage: AssetImage(
            'assets/images/alert-triangle.png',
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(50),
          ),
        ),
      ],
    );
    var rightWayNoti = Column(
      children: [
        NotificationWidget(
          text: 'You reached the destination!',
          assetImage: AssetImage(
            'assets/images/check.png',
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
    return Scaffold(
      body: Stack(
        children: [
          if (_showSplashScreen)
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Expanded(
                child: Container(
                  width: 277,
                  height: 155,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo-main.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          werongWayNoti,
          rightWayNoti,
        ],
      ),
    );
  }
}
