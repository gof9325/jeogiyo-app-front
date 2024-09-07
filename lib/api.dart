import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const baseUrl = 'https://jeogiyo-backend.groon.workers.dev';
const endpoint = '/api/ask';

Future<http.Response> ask(
    String question, double latitude, double longitude) async {
  const url = '$baseUrl$endpoint';

  // final _question = question;
  // final _latitude = latitude;
  // final _longitude = longitude;
  // final response = await http.post(
  //   Uri.parse(url),
  //   body: jsonEncode(
  //     {
  //       'spokenText': question,
  //       'coordinates': {
  //         "latitude": _latitude,
  //         "longitude": _longitude,
  //       }
  //     },
  //   ),
  //   headers: {'Content-Type': 'application/json'},
  // );
  final _testQuestion = '서울역 어떻게 가요?';
  final _testLatitude = 37.580067;
  final _testLongitude = 127.045147;
  Response response = await http.post(
    Uri.parse(url),
    body: jsonEncode(
      {
        'spokenText': _testQuestion,
        'coordinates': {
          "latitude": _testLatitude,
          "longitude": _testLongitude,
        }
      },
    ),
    headers: {'Content-Type': 'application/json'},
  );
  return response;
}
