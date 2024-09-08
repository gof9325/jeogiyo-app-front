import 'dart:convert';
import 'package:http/http.dart' as http;

import 'location.dart';

const baseUrl = 'https://jeogiyo-backend.groon.workers.dev';
const endpoint = '/api/ask';

const headers = {
  "Content-Type": "application/x-www-form-urlencoded",
};

Future<Response> ask(String spokenText) async {
  double latitude = 0;
  double longitude = 0;
  await getLocation().then((value) {
    latitude = value!['latitude']!;
    longitude = value['longitude']!;
  });

  if (latitude == 0 || longitude == 0) {
    throw Exception('Failed to load data');
  }

  const url = '$baseUrl$endpoint';
  List<String> instructions = [];

  print('latitude: $latitude');

  final body = {
    'spokenText': spokenText,
    'coordinates': {
      'latitude': latitude,
      'longitude': longitude,
    },
  };

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
    final String confirmDirectionResult = responseType.data['result'];
    final result = responseType.data['instruction'];
    instructions.add(result);

    return Response(
      success: true,
      type: 'CONFIRM_DIRECTION',
      data: {confirmDirectionResult.toString(): instructions},
    );
  }

  throw Exception('Unexpected response type');
}

int count = 0;

Future<bool> checkWrongWay(String spokenText) async {
  // double latitude = 0;
  // double longitude = 0;
  // await getLocation().then((value) {
  //   latitude = value!['latitude']!;
  //   longitude = value['longitude']!;
  // });
  Map<double, double> coordinates = {
    37.554759: 127.010649,
    37.546797: 127.016310,
    37.558940: 127.004879,
  };

  if (count == 3) {
    count = 0;
  }

  double latitude = coordinates.keys.elementAt(count);
  double longitude = coordinates.values.elementAt(count);

  print('latitude: $latitude');
  print('longitude: $longitude');

  if (latitude == 0 || longitude == 0) {
    throw Exception('Failed to load data');
  }

  const url = '$baseUrl$endpoint';
  List<String> instructions = [];

  // print('latitude: $latitude');

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
  instructions = responseData['instructions'];
  final isWorongWay = result == 'RIGHT_DIRECTION' ? true : false;
  count++;

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
  unknown,
  rightDirection,
  wrongDirection,
}
