import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'alert_widget.dart';
import 'home_page_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeogiyo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 11, 87, 198),
          secondary: const Color.fromARGB(255, 0, 183, 7),
          tertiary: const Color.fromARGB(255, 230, 55, 55),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _stopShowingSplashScreen);
  }

  void _stopShowingSplashScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePageWidget(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Container(
              width: 277,
              height: 155,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo-main.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          // werongWayNoti,
          // rightWayNoti,
        ],
      ),
    );
  }
}
