import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../network/api_client.dart';
import '../providers/core_providers.dart';
import '../logger/app_logger.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return UploadService(apiClient);
});

class UploadService {
  final ApiClient _apiClient;
  final ImagePicker _imagePicker = ImagePicker();

  UploadService(this._apiClient);

  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<File?> compressImage(File file) async {
    final filePath = file.absolute.path;
    final extensionIndex = filePath.lastIndexOf('.');
    if (extensionIndex == -1) return file;

    final extension = filePath.substring(extensionIndex);
    if (extension != '.jpg' &&
        extension != '.jpeg' &&
        extension != '.png' &&
        extension != '.webp') {
      return file;
    }

    final splitted = filePath.substring(0, extensionIndex);
    final outPath = "${splitted}_compressed$extension";

    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 70,
    );

    if (compressedFile != null) {
      return File(compressedFile.path);
    }
    return file;
  }

  Future<String?> uploadImage(
    File file, {
    String folder = 'forenshield/general',
    Function(int count, int total)? onSendProgress,
  }) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        'folder': folder,
        'image': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        '/upload_image.php',
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(responseType: ResponseType.plain),
      );

      final responseData = response.data;
      final payload = responseData is String
          ? jsonDecode(responseData) as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      if (response.statusCode == 200 && payload['success'] == true) {
        final url = payload['url'];
        return url is String && url.isNotEmpty ? url : null;
      } else {
        AppLogger.error('Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      AppLogger.error('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> deleteImage(String publicId) async {
    try {
      final response = await _apiClient.post(
        '/delete_image.php',
        data: {'public_id': publicId},
      );

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      AppLogger.error('Error deleting image: $e');
      return false;
    }
  }
}
