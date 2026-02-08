import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models/care_task.dart';

class CareTaskTile extends StatelessWidget {
  final CareTask task;
  final Function(bool) onToggle;
  final VoidCallback onDelete;

  const CareTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  IconData _getTaskIcon() {
    final title = task.title.toLowerCase();
    if (title.contains('薬') || title.contains('服用')) return Icons.medication_outlined;
    if (title.contains('アイシング') || title.contains('冷')) return Icons.ac_unit;
    if (title.contains('目薬')) return Icons.visibility_outlined;
    if (title.contains('消毒')) return Icons.local_hospital_outlined;
    if (title.contains('洗顔') || title.contains('洗い')) return Icons.water_drop_outlined;
    return Icons.task_alt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // アイコン
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: task.enabled
                    ? AppTheme.accentLight.withOpacity(0.5)
                    : AppTheme.primaryBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTaskIcon(),
                color: task.enabled ? AppTheme.accent : AppTheme.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // テキスト
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: GoogleFonts.zenMaruGothic(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: task.enabled ? AppTheme.textPrimary : AppTheme.textSecondary,
                      decoration: task.enabled ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 12,
                        color: task.enabled ? AppTheme.accent : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.frequencyLabel,
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 12,
                          color: task.enabled ? AppTheme.accent : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // トグル
            Switch(
              value: task.enabled,
              onChanged: onToggle,
              activeColor: AppTheme.accent,
              activeTrackColor: AppTheme.accentLight,
            ),

            // 削除ボタン
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text(
                      'タスクを削除',
                      style: GoogleFonts.zenMaruGothic(fontWeight: FontWeight.w700),
                    ),
                    content: Text(
                      '「${task.title}」を削除してもよろしいですか？',
                      style: GoogleFonts.zenMaruGothic(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('キャンセル', style: GoogleFonts.zenMaruGothic()),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onDelete();
                        },
                        style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
                        child: Text('削除', style: GoogleFonts.zenMaruGothic(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppTheme.textSecondary.withOpacity(0.5),
              tooltip: '削除',
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
