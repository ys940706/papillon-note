import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../app_theme.dart';
import '../models/surgery.dart';
import '../services/image_service.dart';

class ReportScreen extends StatefulWidget {
  final Surgery surgery;

  const ReportScreen({super.key, required this.surgery});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ImagePicker _picker = ImagePicker();
  final ImageService _imageService = ImageService();

  String? _startPath;
  String? _afterPath;
  String? _collagePath;
  bool _generating = false;

  Future<void> _pickImage(bool isStart) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isStart) {
          _startPath = image.path;
        } else {
          _afterPath = image.path;
        }
        _collagePath = null; // リセット
      });
    }
  }

  Future<void> _generateCollage() async {
    if (_startPath == null || _afterPath == null) return;

    setState(() => _generating = true);

    final path = await _imageService.createCollage(
      leftImagePath: _startPath!,
      rightImagePath: _afterPath!,
      surgeryName: widget.surgery.name,
      daysSince: widget.surgery.daysSinceSurgery,
      clinicName: widget.surgery.clinicName,
      doctorName: widget.surgery.doctorName,
      cost: widget.surgery.cost,
    );

    setState(() {
      _collagePath = path;
      _generating = false;
    });
  }

  Future<void> _shareToX() async {
    if (_collagePath == null) return;

    final text = '#${widget.surgery.name} '
        '術後${widget.surgery.daysSinceSurgery}日目 '
        '${widget.surgery.clinicName != null ? '\n📍${widget.surgery.clinicName}' : ''}'
        '\n#美容整形 #経過記録 #PapillonNote';

    await _imageService.shareToX(_collagePath!, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '経過レポート作成',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 施術情報カード
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.medical_services_outlined, color: AppTheme.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.surgery.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          widget.surgery.daysLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 写真選択エリア
            Text(
              '写真を選択',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _photoSelector('施術時', _startPath, () => _pickImage(true))),
                const SizedBox(width: 12),
                Expanded(child: _photoSelector('現在', _afterPath, () => _pickImage(false))),
              ],
            ),

            const SizedBox(height: 24),

            // 生成ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startPath != null && _afterPath != null && !_generating
                    ? _generateCollage
                    : null,
                icon: _generating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _generating ? '生成中...' : 'コラージュを生成',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            // コラージュプレビュー
            if (_collagePath != null) ...[
              const SizedBox(height: 24),
              Text(
                'プレビュー',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_collagePath!),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),

              // X投稿ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _shareToX,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DA1F2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: Text(
                    'Xに投稿する',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _photoSelector(String label, String? imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: imagePath != null ? AppTheme.accent : AppTheme.divider,
            width: imagePath != null ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(imagePath), fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 36,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    'タップして選択',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
