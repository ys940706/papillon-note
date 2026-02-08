import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../models/surgery.dart';

class SurgeryCard extends StatelessWidget {
  final Surgery surgery;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SurgeryCard({
    super.key,
    required this.surgery,
    required this.onTap,
    required this.onDelete,
  });

  // カード背景のグラデーションをカテゴリに応じて変化
  LinearGradient _getGradient() {
    final days = surgery.daysSinceSurgery;
    if (days <= 7) {
      // 術後1週間: 温かみのあるピンク
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE8C4C4), Color(0xFFD4A5A5)],
      );
    } else if (days <= 30) {
      // 術後1ヶ月: ラベンダー
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD5C4E8), Color(0xFFBBA5D4)],
      );
    } else {
      // 術後1ヶ月以降: ミント
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC4E8D5), Color(0xFFA5D4B5)],
      );
    }
  }

  IconData _getStatusIcon() {
    final days = surgery.daysSinceSurgery;
    if (days < 0) return Icons.schedule;
    if (days <= 7) return Icons.healing;
    if (days <= 30) return Icons.favorite;
    return Icons.star;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _getGradient().colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 装飾的な円
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),

            // コンテンツ
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 上部：施術名 + メニュー
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getStatusIcon(),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          surgery.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.8)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline, color: AppTheme.danger, size: 20),
                                const SizedBox(width: 8),
                                Text('削除', style: TextStyle(color: AppTheme.danger)),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'delete') onDelete();
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 下部：術後日数を大きく表示
                  Text(
                    surgery.daysLabel,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy.MM.dd').format(surgery.date),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
