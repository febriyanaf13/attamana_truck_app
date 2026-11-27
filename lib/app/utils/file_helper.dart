import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static int _urut = 0;


  /// =========================
  /// COPY IMAGE TO APP STORAGE
  /// =========================
  static Future<String>
  saveImagePermanently(
      String filePath) async {

    /// folder aplikasi
    final directory =
    await getApplicationDocumentsDirectory();

    /// extension file
    final ext =
    extension(filePath);

    /// rename file
    // VERSI 50: tambah urutan supaya 2 foto yang disimpan pada milidetik yang sama tidak saling menimpa
    _urut++;
    final fileName =
        'do_${DateTime.now().millisecondsSinceEpoch}_$_urut$ext';

    /// lokasi baru
    final newPath =
    join(
      directory.path,
      fileName,
    );

    /// copy file
    final File imageFile =
    File(filePath);

    final File newImage =
    await imageFile.copy(
      newPath,
    );

    return newImage.path;
  }
}