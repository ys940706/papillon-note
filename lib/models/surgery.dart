
import 'medical_guide.dart';

class Surgery {
  final String id;
  final String name;
  final DateTime date;
  final String? clinicName;
  final String? doctorName;
  final String? cost;
  final String? imagePath;
  final SurgeryCategory category;

  Surgery({
    required this.id,
    required this.name,
    required this.date,
    this.clinicName,
    this.doctorName,
    this.cost,
    this.imagePath,
    this.category = SurgeryCategory.other,
  });

  /// 術後日数を計算
  int get daysSinceSurgery {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final surgeryDay = DateTime(date.year, date.month, date.day);
    return today.difference(surgeryDay).inDays;
  }

  /// 術後日数の表示ラベル
  String get daysLabel {
    final days = daysSinceSurgery;
    if (days == 0) return '手術当日';
    if (days < 0) return '手術まであと${-days}日';
    return '術後 $days日目';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
        'clinicName': clinicName,
        'doctorName': doctorName,
        'cost': cost,
        'imagePath': imagePath,
        'category': category.name,
      };

  factory Surgery.fromJson(Map<String, dynamic> json) => Surgery(
        id: json['id'] as String,
        name: json['name'] as String,
        date: DateTime.parse(json['date'] as String),
        clinicName: json['clinicName'] as String?,
        doctorName: json['doctorName'] as String?,
        cost: json['cost'] as String?,
        imagePath: json['imagePath'] as String?,
        category: _parseCategory(json['category'] as String?),
      );

  static SurgeryCategory _parseCategory(String? name) {
    if (name == null) return SurgeryCategory.other;
    return SurgeryCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => SurgeryCategory.other,
    );
  }

  Surgery copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? clinicName,
    String? doctorName,
    String? cost,
    String? imagePath,
    SurgeryCategory? category,
  }) {
    return Surgery(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      clinicName: clinicName ?? this.clinicName,
      doctorName: doctorName ?? this.doctorName,
      cost: cost ?? this.cost,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
    );
  }
}
