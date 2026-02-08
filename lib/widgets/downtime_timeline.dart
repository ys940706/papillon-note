import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/medical_guide.dart';
import '../data/medical_data.dart';

/// 縦タイムラインでダウンタイム経過を表示するウィジェット
class DowntimeTimeline extends StatelessWidget {
  final SurgeryCategory category;
  final int currentDay;

  const DowntimeTimeline({
    super.key,
    required this.category,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context) {
    final guide = MedicalData.getGuide(category);

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
                  color: AppTheme.accentLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.timeline, color: AppTheme.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'ダウンタイム経過',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // タイムラインフェーズ
          ...guide.phases.asMap().entries.map((entry) {
            final index = entry.key;
            final phase = entry.value;
            final isActive = phase.isActive(currentDay);
            final isPast = phase.isPast(currentDay);
            final isLast = index == guide.phases.length - 1;

            return _PhaseItem(
              phase: phase,
              isActive: isActive,
              isPast: isPast,
              isLast: isLast,
              currentDay: currentDay,
            );
          }),
        ],
      ),
    );
  }
}

class _PhaseItem extends StatefulWidget {
  final DowntimePhase phase;
  final bool isActive;
  final bool isPast;
  final bool isLast;
  final int currentDay;

  const _PhaseItem({
    required this.phase,
    required this.isActive,
    required this.isPast,
    required this.isLast,
    required this.currentDay,
  });

  @override
  State<_PhaseItem> createState() => _PhaseItemState();
}

class _PhaseItemState extends State<_PhaseItem> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isActive; // 現在のフェーズはデフォルトで展開
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.isActive
        ? AppTheme.accent
        : widget.isPast
            ? const Color(0xFF8BC6A3) // 完了=緑
            : AppTheme.divider;
    final lineColor = widget.isPast
        ? const Color(0xFF8BC6A3)
        : AppTheme.divider;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // タイムラインドット＋ライン
        SizedBox(
          width: 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.isActive ? 18 : 12,
                height: widget.isActive ? 18 : 12,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: widget.isActive
                      ? Border.all(color: AppTheme.accent.withOpacity(0.3), width: 4)
                      : null,
                  boxShadow: widget.isActive
                      ? [BoxShadow(color: AppTheme.accent.withOpacity(0.3), blurRadius: 8)]
                      : null,
                ),
              ),
              if (!widget.isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: lineColor,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

          // コンテンツ
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: ClipRect(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppTheme.accent.withOpacity(0.06)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: widget.isActive
                      ? Border.all(color: AppTheme.accent.withOpacity(0.15))
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (widget.isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      margin: const EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'NOW',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  Flexible(
                                    child: Text(
                                      widget.phase.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                                        color: widget.isActive
                                            ? AppTheme.accent
                                            : widget.isPast
                                                ? AppTheme.textSecondary
                                                : AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.phase.startDay}日目〜${widget.phase.endDay}日目',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),

                    // 展開コンテンツ
                    if (_expanded) ...[
                      const SizedBox(height: 10),
                      Text(
                        widget.phase.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                          height: 1.6,
                        ),
                      ),
                      if (widget.phase.normalSymptoms.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          '🩺 この時期の正常な症状',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...widget.phase.normalSymptoms.map((s) => Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                              Expanded(
                                child: Text(
                                  s,
                                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                      if (widget.phase.tips.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          '💡 ケアのポイント',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4A90A4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...widget.phase.tips.map((t) => Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: TextStyle(fontSize: 11, color: const Color(0xFF4A90A4))),
                              Expanded(
                                child: Text(
                                  t,
                                  style: TextStyle(fontSize: 11, color: const Color(0xFF4A90A4)),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ],
                  ],
                ),
              ),
              ),
            ),
          ),
        ],
      );
    }
}
