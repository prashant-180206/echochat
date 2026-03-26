import 'package:echochat/core/singleton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileUtils {
  static Future<String> uploadProfileAvatarAndGetLink() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        logger.w("No image selected");
        return "";
      }

      final bytes = await image.readAsBytes();

      await supabase.storage
          .from('avatars')
          .uploadBinary(
            "${supabase.auth.currentUser!.id}.${image.name}",
            bytes,
            fileOptions: FileOptions(cacheControl: "3600", upsert: true),
          );
      logger.d("File uploaded: ${image.name}");
      final publicUrl = supabase.storage
          .from("avatars")
          .getPublicUrl("${supabase.auth.currentUser!.id}.${image.name}");

      logger.d("Public URL: $publicUrl");
      return publicUrl;
    } catch (e) {
      logger.e("File upload failed: $e");
      rethrow;
    }
  }

  static Future<String> uploadMessageImageAndGetLink() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        logger.w("No image selected");
        return "";
      }

      final bytes = await image.readAsBytes();

      // ✅ Clean filename (no folder duplication)
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      final bucket = supabase.storage.from('images');

      // ✅ Upload to SAME bucket
      await bucket.uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(cacheControl: "3600", upsert: true),
      );

      logger.d("File uploaded: $fileName");

      // ✅ Get URL from SAME bucket
      final publicUrl = bucket.getPublicUrl(fileName);

      logger.d("Public URL: $publicUrl");

      return publicUrl;
    } catch (e) {
      logger.e("File upload failed: $e");
      rethrow;
    }
  }
}
