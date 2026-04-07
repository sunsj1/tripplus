import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

const maxPickBytes = 5 * 1024 * 1024;

/// Firestore ~1 MiB doc budget; base64 inflates ~4/3 — keep raw JPEG under this.
const maxStoredJpegBytes = 680000;

String encodeJpegBase64(Uint8List bytes) => base64Encode(bytes);

/// Returns compressed JPEG bytes, or `null` if compression fails.
Future<Uint8List?> compressReportPhotoFile(File file) async {
  final raw = await file.readAsBytes();
  if (raw.length > maxPickBytes) return null;

  var quality = 78;
  Uint8List? out = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minWidth: 1200,
    minHeight: 1200,
    quality: quality,
    format: CompressFormat.jpeg,
  );

  while (out != null && out.length > maxStoredJpegBytes && quality > 35) {
    quality -= 12;
    out = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 960,
      minHeight: 960,
      quality: quality,
      format: CompressFormat.jpeg,
    );
  }

  if (out == null || out.length > maxStoredJpegBytes) return null;
  return out;
}
