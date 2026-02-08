import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../models/surgery.dart';
import '../models/medical_guide.dart';
import '../data/surgery_database.dart';

/// 施術情報の編集モーダル
class EditSurgeryModal extends StatefulWidget {
  final Surgery surgery;
  final Function(Surgery) onSaved;

  const EditSurgeryModal({
    super.key,
    required this.surgery,
    required this.onSaved,
  });

  @override
  State<EditSurgeryModal> createState() => _EditSurgeryModalState();
}

class _EditSurgeryModalState extends State<EditSurgeryModal> {
  late final TextEditingController _clinicController;
  late final TextEditingController _doctorController;
  late final TextEditingController _costController;
  late DateTime _selectedDate;
  late SurgeryCategory _selectedCategory;
  late String _selectedSurgeryName;

  @override
  void initState() {
    super.initState();
    _clinicController = TextEditingController(text: widget.surgery.clinicName ?? '');
    _doctorController = TextEditingController(text: widget.surgery.doctorName ?? '');
    _costController = TextEditingController(text: widget.surgery.cost ?? '');
    _selectedDate = widget.surgery.date;
    _selectedCategory = widget.surgery.category;
    _selectedSurgeryName = widget.surgery.name;
  }

  @override
  void dispose() {
    _clinicController.dispose();
    _doctorController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.accent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _save() {
    final updated = widget.surgery.copyWith(
      name: _selectedSurgeryName,
      date: _selectedDate,
      category: _selectedCategory,
      clinicName: _clinicController.text.trim().isEmpty ? null : _clinicController.text.trim(),
      doctorName: _doctorController.text.trim().isEmpty ? null : _doctorController.text.trim(),
      cost: _costController.text.trim().isEmpty ? null : _costController.text.trim(),
    );
    widget.onSaved(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final surgeryNames = SurgeryDatabase.surgeryTypes[_selectedCategory] ?? [];

    // 選択中の術式がリストに含まれていなければ追加（旧データ互換性）
    final displayNames = surgeryNames.contains(_selectedSurgeryName)
        ? surgeryNames
        : [_selectedSurgeryName, ...surgeryNames];

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ハンドルバー
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // タイトル
              Text(
                '施術情報を編集',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // カテゴリ選択
              _sectionLabel('施術カテゴリ'),
              const SizedBox(height: 8),
              _dropdownContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SurgeryCategory>(
                    isExpanded: true,
                    value: _selectedCategory,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accent),
                    borderRadius: BorderRadius.circular(14),
                    items: SurgeryCategory.values.map((cat) {
                      return DropdownMenuItem<SurgeryCategory>(
                        value: cat,
                        child: Row(
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Text(cat.label, style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (cat) {
                      if (cat != null) {
                        setState(() {
                          _selectedCategory = cat;
                          final names = SurgeryDatabase.surgeryTypes[cat] ?? [];
                          _selectedSurgeryName = names.isNotEmpty ? names.first : '';
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 術式選択
              _sectionLabel('術式'),
              const SizedBox(height: 8),
              _dropdownContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSurgeryName,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accent),
                    borderRadius: BorderRadius.circular(14),
                    menuMaxHeight: 300,
                    items: displayNames.map((name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (name) {
                      if (name != null) setState(() => _selectedSurgeryName = name);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 手術日
              _sectionLabel('手術日'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppTheme.accent, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('yyyy年 M月 d日').format(_selectedDate),
                        style: TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // クリニック
              _sectionLabel('クリニック名（任意）'),
              const SizedBox(height: 8),
              TextField(
                controller: _clinicController,
                decoration: const InputDecoration(
                  hintText: 'クリニック名',
                  prefixIcon: Icon(Icons.local_hospital_outlined, color: AppTheme.accent),
                ),
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),

              // 執刀医
              _sectionLabel('執刀医（任意）'),
              const SizedBox(height: 8),
              TextField(
                controller: _doctorController,
                decoration: const InputDecoration(
                  hintText: '執刀医',
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.accent),
                ),
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),

              // 費用
              _sectionLabel('費用（任意）'),
              const SizedBox(height: 8),
              TextField(
                controller: _costController,
                decoration: const InputDecoration(
                  hintText: '費用（例：50万円）',
                  prefixIcon: Icon(Icons.payments_outlined, color: AppTheme.accent),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 32),

              // 保存ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('変更を保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _dropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
