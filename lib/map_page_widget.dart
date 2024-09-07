import 'package:flutter/material.dart';
import 'package:two/speaker_button.dart';

import 'navigation_widget.dart';

class MapPageWidget extends StatefulWidget {
  const MapPageWidget({super.key});

  @override
  State<MapPageWidget> createState() => _MapPageWidgetState();
}

class _MapPageWidgetState extends State<MapPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.yellow,
                  Colors.green,
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    minHeight: 200.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Go Straight',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0,
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    minHeight: 377.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Tap',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 50.0,
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
                              fontSize: 50.0,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '"Is this the right way?"',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            '"Can you explain again?"',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            '"Is it left here or right?"',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: NavigationWidget(),
                ),
                // Container(
                //   padding: EdgeInsets.all(16),
                //   child: Text(
                //     'Recognized words:',
                //     style: TextStyle(fontSize: 20.0),
                //   ),
                // ),
                // Expanded(
                //   child: Container(
                //     padding: EdgeInsets.all(16),
                //     child: Text(
                //       _speechToText.isListening
                //           ? '$_lastWords'
                //           : _speechEnabled
                //               ? 'Tap the microphone to start listening...'
                //               : 'Speech not available',
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
