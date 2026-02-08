/// 施術カテゴリ
enum SurgeryCategory {
  eyelid,       // 目元
  nose,         // 鼻
  faceContour,  // 輪郭
  liposuction,  // 脂肪吸引
  breast,       // 豊胸・バスト
  filler,       // 注入系
  skinLaser,    // レーザー・肌治療
  skinCare,     // スキンケア施術
  hair,         // 毛髪・脱毛
  dental,       // 歯科審美
  other,        // その他
}

extension SurgeryCategoryExtension on SurgeryCategory {
  String get label {
    switch (this) {
      case SurgeryCategory.eyelid: return '目元';
      case SurgeryCategory.nose: return '鼻';
      case SurgeryCategory.faceContour: return '輪郭・フェイスライン';
      case SurgeryCategory.liposuction: return '脂肪吸引・痩身';
      case SurgeryCategory.breast: return '豊胸・バスト';
      case SurgeryCategory.filler: return '注入・ボトックス';
      case SurgeryCategory.skinLaser: return 'レーザー・光治療';
      case SurgeryCategory.skinCare: return 'スキンケア・ピーリング';
      case SurgeryCategory.hair: return '毛髪・脱毛';
      case SurgeryCategory.dental: return '歯科審美';
      case SurgeryCategory.other: return 'その他';
    }
  }

  String get icon {
    switch (this) {
      case SurgeryCategory.eyelid: return '👁️';
      case SurgeryCategory.nose: return '👃';
      case SurgeryCategory.faceContour: return '💎';
      case SurgeryCategory.liposuction: return '✨';
      case SurgeryCategory.breast: return '🩱';
      case SurgeryCategory.filler: return '💉';
      case SurgeryCategory.skinLaser: return '🔬';
      case SurgeryCategory.skinCare: return '🧴';
      case SurgeryCategory.hair: return '💇';
      case SurgeryCategory.dental: return '🦷';
      case SurgeryCategory.other: return '🏥';
    }
  }
}

/// ダウンタイムの緊急度レベル
enum AlertLevel {
  warning,  // 注意：経過観察が必要
  danger,   // 危険：すぐに受診
}

/// ダウンタイムフェーズ
class DowntimePhase {
  final int startDay;
  final int endDay;
  final String title;
  final String description;
  final List<String> normalSymptoms;
  final List<String> tips;

  const DowntimePhase({
    required this.startDay,
    required this.endDay,
    required this.title,
    required this.description,
    this.normalSymptoms = const [],
    this.tips = const [],
  });

  bool isActive(int currentDay) => currentDay >= startDay && currentDay <= endDay;
  bool isPast(int currentDay) => currentDay > endDay;
}

/// 緊急アラート症状
class EmergencyAlert {
  final String symptom;
  final String description;
  final AlertLevel level;
  final int? relevantAfterDay; // この日数以降で特に注意

  const EmergencyAlert({
    required this.symptom,
    required this.description,
    required this.level,
    this.relevantAfterDay,
  });
}

/// 施術カテゴリ別ガイド情報
class SurgeryGuide {
  final SurgeryCategory category;
  final List<DowntimePhase> phases;
  final List<EmergencyAlert> alerts;
  final String disclaimer;

  const SurgeryGuide({
    required this.category,
    required this.phases,
    required this.alerts,
    this.disclaimer = '※ 本情報は一般的な医学知識に基づく参考情報です。個別の症状については必ず担当医にご相談ください。',
  });

  /// 現在のフェーズを取得
  DowntimePhase? getCurrentPhase(int day) {
    for (final phase in phases) {
      if (phase.isActive(day)) return phase;
    }
    // 全フェーズを過ぎた場合は最後のフェーズ
    if (phases.isNotEmpty && day > phases.last.endDay) return phases.last;
    return null;
  }

  /// 現在の日数に関連するアラート
  List<EmergencyAlert> getRelevantAlerts(int day) {
    return alerts.where((a) {
      if (a.relevantAfterDay == null) return true;
      return day >= a.relevantAfterDay!;
    }).toList();
  }
}
