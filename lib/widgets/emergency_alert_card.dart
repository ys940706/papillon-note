import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/medical_guide.dart';
import '../data/medical_data.dart';

/// 緊急アラート一覧カード
class EmergencyAlertCard extends StatelessWidget {
  final SurgeryCategory category;
  final int currentDay;

  const EmergencyAlertCard({
    super.key,
    required this.category,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context) {
    final guide = MedicalData.getGuide(category);
    final alerts = guide.getRelevantAlerts(currentDay);

    if (alerts.isEmpty) return const SizedBox.shrink();

    // dangerを先に、warningを後に
    final dangerAlerts = alerts.where((a) => a.level == AlertLevel.danger).toList();
    final warningAlerts = alerts.where((a) => a.level == AlertLevel.warning).toList();
    final sortedAlerts = [...dangerAlerts, ...warningAlerts];

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
                  color: const Color(0xFFFDEDED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE53935), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'こんな症状が出たら病院へ連絡',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...sortedAlerts.map((alert) => _AlertItem(alert: alert)),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 14, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '※ 本情報は一般的な医学知識に基づく参考情報です。個別の症状については必ず担当医にご相談ください。',
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color(0xFF9E9E9E),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final EmergencyAlert alert;

  const _AlertItem({required this.alert});

  @override
  Widget build(BuildContext context) {
    final isDanger = alert.level == AlertLevel.danger;
    final color = isDanger ? const Color(0xFFE53935) : const Color(0xFFFF9800);
    final bgColor = isDanger ? const Color(0xFFFDEDED) : const Color(0xFFFFF3E0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDanger ? Icons.error : Icons.warning,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isDanger ? '緊急' : '注意',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.symptom,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            alert.description,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
