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

  // final body = jsonEncode({
  //   'spokenText': spokenText,
  //   'coordinates': {
  //     "latitude": latitude,
  //     "longitude": longitude,
  //   },
  // });

  final response = await http.post(
    Uri.parse(url),
    body: {
      'spokenText': spokenText,
      'coordinates': jsonEncode(
        {
          "latitude": latitude,
          "longitude": longitude,
        },
      ),
    },
    headers: headers,
  );

  // if (response.statusCode != 200) {
  //   throw Exception('Failed to load data');
  // } else {
  final responseData = jsonDecode(response.body);
  final responseType = Response(
    success: responseData['success'],
    type: responseData['questionType'],
    data: responseData['data'],
  );

  if (responseType.type.toString() == "UNKNOWN") {
    throw Exception('Unknown response type');
  } else if (responseType.type.toString() == "TO_DESTINATION") {
    final String directionNextStation =
        responseType.data['directionNextStation'];
    instructions = responseType.data['instructions'];
    return Response(
      success: true,
      type: ResponseType.toDestination,
      data: {directionNextStation: instructions},
    );
  } else if (responseType.type.toString() == "REPEAT_LAST_RESPONSE") {
    return Response(
      success: true,
      type: ResponseType.repeatLastResponse,
      data: null,
    );
  } else if (responseType.type.toString() == "CONFIRM_DIRECTION") {
    final ConfirmDirectionResult confirmDirectionResult =
        responseType.data['confirmDirectionResult'];
    instructions = responseType.data['instructions'];

    return Response(
      success: true,
      type: ResponseType.confirmDirection,
      data: {confirmDirectionResult.toString(): instructions},
    );
    // }
  }

  // Default return if no conditions are met
  return Response(
    success: false,
    type: ResponseType.unknown,
    data: null,
  );
}

enum ResponseType {
  toDestination,
  repeatLastResponse,
  confirmDirection,
  unknown,
}

class Response {
  final bool success;
  final ResponseType type;
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
