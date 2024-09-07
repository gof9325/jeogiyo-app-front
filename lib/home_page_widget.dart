import 'package:flutter/material.dart';
import 'package:two/sr_button_component.dart';

import 'speaker_button.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Text('Ask for directions'),
              SpeakerButton(
                onPressed: () {
                  // todo listener
                },
                width: 150,
                height: 150,
                iconSize: 108.0,
              ),
              Text('Listening...'),
              Text('Results: '),
              SRTextButton(text: 'Guii Station', onPressed: () {}),
              SRTextButton(text: 'Guri Station', onPressed: () {}),
              SRTextButton(text: 'Gumi Station', onPressed: () {}),
              Text('None of these?'),
              Text('Ask again!'),
            ],
          ),
        ],
      ),
    );
  }
}
