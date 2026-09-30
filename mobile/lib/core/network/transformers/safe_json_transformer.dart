import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

/// A defensive JSON transformer for Dio that strips unexpected UTF-8 Byte Order Marks (BOM)
/// and accidental whitespace before decoding JSON.
class SafeJsonTransformer extends BackgroundTransformer {
  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    if (options.responseType == ResponseType.json) {
      final builder = BytesBuilder(copy: false);
      await for (final chunk in responseBody.stream) {
        builder.add(chunk);
      }
      final bytes = builder.takeBytes();
      var str = utf8.decode(bytes, allowMalformed: true);

      // Strip UTF-8 BOM if present
      if (str.startsWith('\uFEFF')) {
        str = str.substring(1);
      }
      str = str.trim();
      if (str.isEmpty) return null;
      return jsonDecode(str);
    }
    return super.transformResponse(options, responseBody);
  }
}
