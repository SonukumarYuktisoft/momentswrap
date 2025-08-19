import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static final Dio _dio = Dio();

  /// Share Product with fields
  static Future<void> shareProduct({
    required String name,
    String? price,
    String? currency,
    String? offer,
    required String imageUrl,
    String? shareUrl,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/product_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // download image
      await _dio.download(imageUrl, filePath);

      // build share text dynamically
      final buffer = StringBuffer();
      buffer.writeln("🛍️ $name");

      if (price != null && currency != null) {
        buffer.writeln("💰 Price: $currency $price");
      }
      if (offer != null) {
        buffer.writeln("🎁 Offer: $offer");
      }
      if (shareUrl != null) {
        buffer.writeln("🔗 Buy here: $shareUrl");
      }

      // open share sheet
      await Share.shareXFiles(
        [XFile(filePath)],
        text: buffer.toString(),
        subject: "Check out this product!",
      );
    } catch (e) {
      print("❌ Error while sharing product: $e");
    }
  }
}
