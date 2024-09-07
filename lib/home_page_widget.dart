import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:two/alert_widget.dart';
import 'package:two/api.dart';
import 'navigation_widget.dart';
import 'speaker_button.dart';

enum ListeningState {
  notListening,
  listening,
  done,
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  final spinkit = const SpinKitThreeBounce(
    color: Colors.black,
    size: 20.0,
  );
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  double latitude = 0;
  double longitude = 0;
  bool _showWarning = false;
  bool _isProcessing = false;

  ListeningState listeningState = ListeningState.notListening;

  List<String> resultList = [];

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) async {
        print('onStatus: $status');
        if (status == 'done') {
          if (!_isProcessing) {
            if (listeningState == ListeningState.listening) {
              print("Done");
              _isProcessing = true;
              await getAnswer();
              listeningState = ListeningState.done;
            }
          } else {
            _isProcessing = false;
          }
        }
      },
    );

    // setState(() {});
  }

  Future getAnswer() async {
    print('get answer');

    if (_lastWords.isNotEmpty || _lastWords != '') {
      final response = await ask(_lastWords);

      final data = response.data;

      if (response.type == "TO_DESTINATION" ||
          response.type == "CONFIRM_DIRECTION") {
        resultList = (data.values.first as List).cast<String>();
      } else if (response.type == "REPEAT_LAST_RESPONSE") {}

      _lastWords = '';
      _isProcessing = false;
      setState(() {});
    } else {
      listeningState = ListeningState.notListening;
      setState(() {});
    }
  }

  void startListening() async {
    listeningState = ListeningState.listening;
    print('start listening');
    await _speechToText.listen(
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(milliseconds: 2500),
      onResult: _onSpeechResult,
      localeId: 'ko-KR',
    );

    setState(() {});
  }

  void stopListening() async {
    print('stop listening');
    await _speechToText.stop();
    listeningState = ListeningState.notListening;
    _lastWords = '';
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    print('on speech result' + _lastWords);
  }

  Future _checkWrongWay() async {
    _showWarning = await checkWrongWay(_lastWords);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    var wrongWayNoti = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NotificationWidget(
          text: 'You are going the wrong way!',
          assetImage: const AssetImage(
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (listeningState == ListeningState.notListening)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Ask for directions',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SpeakerButton(
                      onPressed: () {
                        startListening();
                      },
                      width: 150,
                      height: 150,
                      iconSize: 108.0,
                    ),
                  ],
                ),
              if (listeningState == ListeningState.listening)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Listening',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                        spinkit,
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Image(
                      image: AssetImage('assets/images/listening.png'),
                      width: 182,
                      height: 160,
                    ),
                    TextButton(
                      onPressed: () {
                        stopListening();
                      },
                      child: const Text('Stop'),
                    ),
                  ],
                ),
              if (listeningState == ListeningState.done)
                NavigationWidget(
                  onSpeakerButtonPressed: () {
                    startListening();
                  },
                  resultList: resultList,
                  onWrongWayNoti: _checkWrongWay,
                ),
            ],
          ),
          if (_showWarning) wrongWayNoti,
          if (_showWarning)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
        ],
      ),
    );
  }
}
