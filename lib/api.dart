import 'dart:convert';
import 'package:http/http.dart' as http;

import 'location.dart';

const baseUrl = 'https://jeogiyo-backend.groon.workers.dev';
const endpoint = '/api/ask';

const headers = {
  "Content-Type": "application/x-www-form-urlencoded",
  // "Content-Type": "application/json",
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
    // instructions = (responseType.data['instruction'] as List)
    //     .map((e) => e.toString())
    //     .toList();

    return Response(
      success: true,
      type: 'CONFIRM_DIRECTION',
      data: {confirmDirectionResult.toString(): instructions},
    );
  }

  // Add a default return statement to handle any unexpected cases
  throw Exception('Unexpected response type');
}

Future<bool> checkWrongWay(String spokenText) async {
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

  return isWorongWay;
}

// enum ResponseType {
//   toDestination,
//   repeatLastResponse,
//   confirmDirection,
//   unknown,
// }

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
