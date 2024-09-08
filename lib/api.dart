import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'location.dart';

const baseUrl = 'https://jeogiyo-backend.groon.workers.dev';
const endpoint = '/api/ask';
List<Map<String, double>> coordinates = [
  {'latitude': 37.554759, 'longitude': 127.010649},
  {'latitude': 37.546797, 'longitude': 127.016310},
  {'latitude': 37.558940, 'longitude': 127.004879},
];

const headers = {
  "Content-Type": "application/x-www-form-urlencoded",
};

int _coordinateIndex = 0;
Map<String, double> _getNextCoordinate() {
  final coordinate = coordinates[_coordinateIndex];
  _coordinateIndex = (_coordinateIndex + 1) % coordinates.length;
  return coordinate;
}

Future<Response> ask(String spokenText) async {
  final coordinate = _getNextCoordinate();
  double latitude = coordinate['latitude']!;
  double longitude = coordinate['longitude']!;

  if (latitude == 0 || longitude == 0) {
    throw Exception('Failed to load data');
  }

  const url = '$baseUrl$endpoint';
  List<String> instructions = [];

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'spokenText': spokenText,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
    }),
  );

  final responseData = jsonDecode(response.body);
  final responseType = Response(
    success: responseData['success'],
    type: responseData['questionType'],
    data: responseData['data'],
  );

  if (responseType.type.toString() == "UNKNOWN") {
    return Response(
      success: true,
      type: 'UNKNOWN',
      data: null,
    );
  } else if (responseType.type.toString() == "TO_DESTINATION") {
    final String directionNextStation =
        responseType.data['directionNextStation'];
    instructions = (responseType.data['instructions'] as List)
        .map((e) => e.toString())
        .toList();
    return Response(
      success: true,
      type: 'TO_DESTINATION',
      data: {directionNextStation: instructions},
    );
  } else if (responseType.type.toString() == "REPEAT_LAST_RESPONSE") {
    return Response(
      success: true,
      type: 'REPEAT_LAST_RESPONSE',
      data: null,
    );
  } else if (responseType.type.toString() == "CONFIRM_DIRECTION") {
    final String result = responseData['data']['result'];
    final String instruction = responseData['data']['instruction'];
    return Response(
      success: true,
      type: 'CONFIRM_DIRECTION',
      data: {
        'result': result,
        'instruction': instruction,
      },
    );
  }

  throw Exception('Unexpected response type');
}

Future<bool> checkWrongWay(String spokenText) async {
  int rendom = Random().nextInt(3);

  double latitude = coordinates[rendom]['latitude']!;
  double longitude = coordinates[rendom]['longitude']!;

  print('latitude: $latitude');
  print('longitude: $longitude');

  if (latitude == 0 || longitude == 0) {
    throw Exception('Failed to load data');
  }

  const url = '$baseUrl$endpoint';

  final body = jsonEncode({
    'spokenText': spokenText,
    'coordinates': {
      "latitude": latitude,
      "longitude": longitude,
    },
  });

  final response = await http.post(
    Uri.parse(url),
    body: body,
    headers: headers,
  );

  final responseData = jsonDecode(response.body);
  final responseType = responseData['questionType'];
  final result = responseData['result'];
  final isWorongWay = result == 'RIGHT_DIRECTION' ? true : false;

  return isWorongWay;
}

class Response {
  final bool success;
  final String type;
  final dynamic data;

  Response({
    required this.success,
    required this.type,
    required this.data,
  });
}

enum ConfirmDirectionResult {
  UNKNOWN,
  RIGHT_DIRECTION,
  WRONG_DIRECTION,
}
