import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fin_tech/Utils/utils.dart';

class ApiServices {
  /// POST
  static Future<String?> postMethod({required String url, Map<String, dynamic>? body}) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final request = http.Request('POST', Uri.parse(url));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await response.stream.bytesToString();
        return result;
      } else {
        final result = await response.stream.bytesToString();

        showSnack("Something Went Wrong", isError: true);
        logger.e("${response.statusCode} ${response.reasonPhrase} $result");
        return null;
      }
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  /// GET
  static Future<String?> getMethod(String url) async {
    try {
      final request = http.Request('GET', Uri.parse(url));

      http.StreamedResponse response = await request.send();

      final result = await response.stream.bytesToString();
      logger.i(result);
      if (response.statusCode == 200) {
        return result;
      }
      logger.e("$url>>>>>>>>.${response.reasonPhrase}");

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<String?> putMethod({
    required String url,
    Map<String, String>? body,
  }) async {
    final headers = {'Content-Type': 'application/json'};

    try {
      final request = http.Request('PUT', Uri.parse(url));
      request.headers.addAll(headers);

      logger.e(url);
      if (body != null) request.body = json.encode(body);

      http.StreamedResponse response = await request.send();
      final result = await response.stream.bytesToString();
      logger.f(result);
      if (json.decode(result)["status"] == false) {
        showToast(json.decode(result)["message"]);
      }
      if (response.statusCode == 200) {
        return result;
      } else {
        logger.e(response.reasonPhrase);
        return null;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
