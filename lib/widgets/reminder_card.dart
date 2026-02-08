import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../models/surgery.dart';
import '../data/reminder_data.dart';

/// 再施術リマインダーカード
class ReminderCard extends StatelessWidget {
  final Surgery surgery;

  const ReminderCard({super.key, required this.surgery});

  @override
  Widget build(BuildContext context) {
    final reminderInfo = ReminderData.getReminder(surgery.name);
    if (reminderInfo == null) return const SizedBox.shrink();

    final daysLeft = reminderInfo.daysUntilExpiry(surgery.date);
    final expiryDate = reminderInfo.getExpiryDate(surgery.date);
    final isExpired = daysLeft <= 0;
    final isUrgent = daysLeft <= 30 && daysLeft > 0;

    final Color cardColor;
    final Color borderColor;
    final IconData icon;
    final String statusText;

    if (isExpired) {
      cardColor = const Color(0xFFFDEDED);
      borderColor = const Color(0xFFE53935);
      icon = Icons.refresh;
      statusText = '効果期限が過ぎています（${-daysLeft}日超過）';
    } else if (isUrgent) {
      cardColor = const Color(0xFFFFF3E0);
      borderColor = const Color(0xFFFF9800);
      icon = Icons.schedule;
      statusText = '効果切れまであと$daysLeft日';
    } else {
      cardColor = const Color(0xFFE8F5E9);
      borderColor = const Color(0xFF66BB6A);
      icon = Icons.check_circle_outline;
      statusText = '効果切れまであと$daysLeft日';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.update, color: Color(0xFF5C6BC0), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                '再施術リマインド',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ステータスバー
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Icon(icon, color: borderColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: borderColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '効果期限：${DateFormat('yyyy年 M月 d日').format(expiryDate)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // プログレスバー
          _buildProgressBar(surgery.date, reminderInfo),
          const SizedBox(height: 12),

          // 詳細情報
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.science_outlined, size: 14, color: AppTheme.accent),
                    const SizedBox(width: 6),
                    Text(
                      '学術的根拠',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  reminderInfo.note,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _infoChip('効果持続', '約${reminderInfo.durationMonths}ヶ月'),
                    const SizedBox(width: 8),
                    _infoChip('推奨間隔', '${reminderInfo.reminderMonths}ヶ月〜'),
                  ],
                ),
              ],
            ),
          ),

          // 再施術が必要な場合のメッセージ
          if (isExpired || isUrgent) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isExpired
                    ? const Color(0xFFFDEDED)
                    : const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 16,
                    color: isExpired ? const Color(0xFFE53935) : const Color(0xFFFF9800),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isExpired
                          ? '再施術をご検討ください。クリニックへの予約をおすすめします。'
                          : 'そろそろ再施術の時期です。早めの予約をおすすめします。',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isExpired ? const Color(0xFFE53935) : const Color(0xFFFF9800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(DateTime surgeryDate, ReminderInfo info) {
    final totalDays = info.getExpiryDate(surgeryDate).difference(surgeryDate).inDays;
    final elapsed = DateTime.now().difference(surgeryDate).inDays;
    final progress = totalDays > 0 ? (elapsed / totalDays).clamp(0.0, 1.0) : 1.0;

    Color barColor;
    if (progress >= 1.0) {
      barColor = const Color(0xFFE53935);
    } else if (progress >= 0.8) {
      barColor = const Color(0xFFFF9800);
    } else {
      barColor = const Color(0xFF66BB6A);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '施術日',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
            Text(
              '${(progress * 100).round()}% 経過',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: barColor),
            ),
            Text(
              '効果期限',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.divider,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label：',
            style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
