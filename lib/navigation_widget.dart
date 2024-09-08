import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'speaker_button.dart';
import 'sr_button_component.dart';

class NavigationWidget extends StatefulWidget {
  final List<String> resultList;
  final Function() onSpeakerButtonPressed;
  final Function() onWrongWayNoti;
  final bool showRightWay;
  NavigationWidget({
    super.key,
    required this.resultList,
    required this.onSpeakerButtonPressed,
    required this.onWrongWayNoti,
    required this.showRightWay,
  });

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late FlutterTts flutterTts;

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setVoice({"name": "Yuna", "locale": "ko-KR"});
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setSharedInstance(true);
    flutterTts.setLanguage("ko-KR");
    flutterTts.setVoice({"name": "Yuna", "locale": "ko-KR"});
    if (mounted) {
      print('initState' + widget.resultList.join(' '));
      _speak(
        widget.resultList.join(' '),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tap',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                  ),
                  SpeakerButton(
                    onPressed: () {},
                    width: 50,
                    height: 50,
                    iconSize: 36,
                  ),
                  Text(
                    'to Speak',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                '"Am I going the right way?"',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const Text(
                '"Can you explain again?"',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
        resultBox(context, widget.showRightWay),
        const SizedBox(height: 40),
        SpeakerButton(
          onPressed: widget.onSpeakerButtonPressed,
          width: 118,
          height: 118,
          iconSize: 85.0,
        ),
        const SizedBox(height: 10),
        SRTextButton(
          text: 'Tap for help!',
          onPressed: () {},
          width: 150,
        ),
      ],
    );
  }

  Container resultBox(
    BuildContext context,
    bool isAnswer,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: isAnswer
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: isAnswer
            ? const Text(
                'Yes!',
                style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.resultList.length; i++)
                    Text(
                      widget.resultList[i],
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
