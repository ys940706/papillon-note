import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImageService {
  /// 2枚の画像を左右に並べたコラージュを生成
  Future<String?> createCollage({
    required String leftImagePath,
    required String rightImagePath,
    required String surgeryName,
    required int daysSince,
    String? clinicName,
    String? doctorName,
    String? cost,
  }) async {
    try {
      // 画像を読み込み
      final leftBytes = await File(leftImagePath).readAsBytes();
      final rightBytes = await File(rightImagePath).readAsBytes();

      final leftImg = img.decodeImage(leftBytes);
      final rightImg = img.decodeImage(rightBytes);

      if (leftImg == null || rightImg == null) return null;

      // 統一サイズにリサイズ
      const targetHeight = 800;
      const targetWidth = 600;

      final resizedLeft = img.copyResize(leftImg, width: targetWidth, height: targetHeight);
      final resizedRight = img.copyResize(rightImg, width: targetWidth, height: targetHeight);

      // コラージュキャンバス (左右 + 下部テキスト領域)
      const padding = 8;
      const bottomBar = 160;
      final canvasWidth = targetWidth * 2 + padding * 3;
      final canvasHeight = targetHeight + padding * 2 + bottomBar;

      final canvas = img.Image(width: canvasWidth, height: canvasHeight);
      // 白背景
      img.fill(canvas, color: img.ColorRgb8(255, 255, 255));

      // 左画像を配置
      img.compositeImage(canvas, resizedLeft, dstX: padding, dstY: padding);
      // 右画像を配置
      img.compositeImage(canvas, resizedRight, dstX: targetWidth + padding * 2, dstY: padding);

      // 施術時 / 現在 ラベル
      img.drawString(canvas, 'Start',
          font: img.arial24, x: padding + 20, y: padding + 10,
          color: img.ColorRgba8(255, 255, 255, 200));
      img.drawString(canvas, 'Now',
          font: img.arial24, x: targetWidth + padding * 2 + 20, y: padding + 10,
          color: img.ColorRgba8(255, 255, 255, 200));

      // 下部ピンクバー
      final pinkColor = img.ColorRgb8(212, 165, 165);
      img.fillRect(canvas,
          x1: 0, y1: targetHeight + padding * 2,
          x2: canvasWidth, y2: canvasHeight,
          color: pinkColor);

      // テキスト情報
      final textY = targetHeight + padding * 2 + 15;
      img.drawString(canvas, surgeryName,
          font: img.arial24, x: 20, y: textY,
          color: img.ColorRgb8(74, 59, 59));

      img.drawString(canvas, 'Day $daysSince',
          font: img.arial24, x: 20, y: textY + 35,
          color: img.ColorRgb8(74, 59, 59));

      int infoY = textY + 70;
      if (clinicName != null && clinicName.isNotEmpty) {
        img.drawString(canvas, 'Clinic: $clinicName',
            font: img.arial14, x: 20, y: infoY,
            color: img.ColorRgb8(100, 80, 80));
        infoY += 22;
      }
      if (doctorName != null && doctorName.isNotEmpty) {
        img.drawString(canvas, 'Dr. $doctorName',
            font: img.arial14, x: 20, y: infoY,
            color: img.ColorRgb8(100, 80, 80));
        infoY += 22;
      }
      if (cost != null && cost.isNotEmpty) {
        img.drawString(canvas, 'Cost: $cost',
            font: img.arial14, x: 20, y: infoY,
            color: img.ColorRgb8(100, 80, 80));
      }

      // 透かし
      img.drawString(canvas, 'Certified by Papillon Note / No Edit',
          font: img.arial14,
          x: canvasWidth - 320, y: canvasHeight - 25,
          color: img.ColorRgba8(74, 59, 59, 120));

      // ファイル保存
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${dir.path}/collage_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(img.encodePng(canvas));

      return filePath;
    } catch (e) {
      debugPrint('Collage generation error: $e');
      return null;
    }
  }

  /// 画像をXに共有
  Future<void> shareToX(String imagePath, String text) async {
    final xFile = XFile(imagePath);
    await Share.shareXFiles(
      [xFile],
      text: text,
    );
  }
}
