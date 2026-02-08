class CareTask {
  final String id;
  final String surgeryId;
  final String title;
  final String? description;
  final int intervalHours; // 通知間隔（時間）
  final int timesPerDay; // 1日の回数（0の場合はintervalHoursを使用）
  final bool enabled;
  final String? icon; // アイコン名

  CareTask({
    required this.id,
    required this.surgeryId,
    required this.title,
    this.description,
    this.intervalHours = 0,
    this.timesPerDay = 0,
    this.enabled = true,
    this.icon,
  });

  /// 頻度ラベルの表示
  String get frequencyLabel {
    if (timesPerDay > 0) {
      return '1日$timesPerDay回';
    }
    if (intervalHours > 0) {
      return '$intervalHours時間おき';
    }
    return '手動';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surgeryId': surgeryId,
        'title': title,
        'description': description,
        'intervalHours': intervalHours,
        'timesPerDay': timesPerDay,
        'enabled': enabled,
        'icon': icon,
      };

  factory CareTask.fromJson(Map<String, dynamic> json) => CareTask(
        id: json['id'] as String,
        surgeryId: json['surgeryId'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        intervalHours: json['intervalHours'] as int? ?? 0,
        timesPerDay: json['timesPerDay'] as int? ?? 0,
        enabled: json['enabled'] as bool? ?? true,
        icon: json['icon'] as String?,
      );

  CareTask copyWith({
    String? id,
    String? surgeryId,
    String? title,
    String? description,
    int? intervalHours,
    int? timesPerDay,
    bool? enabled,
    String? icon,
  }) {
    return CareTask(
      id: id ?? this.id,
      surgeryId: surgeryId ?? this.surgeryId,
      title: title ?? this.title,
      description: description ?? this.description,
      intervalHours: intervalHours ?? this.intervalHours,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      enabled: enabled ?? this.enabled,
      icon: icon ?? this.icon,
    );
  }
}
