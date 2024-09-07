import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = 'https://jeogiyo-backend.groon.workers.dev';
const endpoint = '/api/ask';

Future<Map<String?, List<String>?>> ask(
    String spokenText, double latitude, double longitude) async {
  const url = '$baseUrl$endpoint';
  List<String> instructions = [];

  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode(
      {
        'spokenText': spokenText,
        'coordinates': {
          "latitude": latitude,
          "longitude": longitude,
        }
      },
    ),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load data');
  } else {
    final responseData = jsonDecode(response.body);
    final responseType = Response(
      success: responseData['success'],
      type: ResponseType.values.byName(responseData['type']),
      data: responseData['data'],
    );

    if (responseType.type == ResponseType.unknown) {
      throw Exception('Unknown response type');
    } else if (responseType.type == ResponseType.toDestination) {
      final String directionNextStation =
          responseType.data['directionNextStation'];
      instructions = responseType.data['instructions'];
      return {
        directionNextStation: instructions,
      };
    } else if (responseType.type == ResponseType.repeatLastResponse) {
      return {
        null: null,
      };
    } else if (responseType.type == ResponseType.confirmDirection) {
      final ConfirmDirectionResult confirmDirectionResult =
          responseType.data['confirmDirectionResult'];
      instructions = responseType.data['instructions'];

      return {
        confirmDirectionResult.toString(): instructions,
      };
    }
  }

  return {null: instructions};
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
