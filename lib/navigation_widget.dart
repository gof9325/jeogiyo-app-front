import 'package:flutter/material.dart';

import 'api.dart';
import 'speaker_button.dart';
import 'sr_button_component.dart';

class NavigationWidget extends StatelessWidget {
  var helpButton = SRTextButton(
    text: 'Tap for help!',
    onPressed: () {
      ask(
        '서울역 어떻게 가요?',
        37.580067,
        127.045147,
      );
    },
  );
  var buttonColumn = Column(
    children: [
      SRTextButton(
        text: "Am I going the right way?",
        onPressed: () {},
      ),
      const SizedBox(height: 20),
      SRTextButton(
        text: "I'm confused!",
        onPressed: () {},
      ),
      const SizedBox(height: 20),
      SRTextButton(
        text: "Can you repeat?",
        onPressed: () {},
      ),
    ],
  );
  NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SpeakerButton(
          onPressed: () {
            // todo listener
          },
          width: 118,
          height: 118,
          iconSize: 85.0,
        ),
        const SizedBox(height: 20),
        buttonColumn,
        const SizedBox(height: 34),
      ],
    );
  }
}
