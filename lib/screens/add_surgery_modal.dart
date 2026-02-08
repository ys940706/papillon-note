import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../app_theme.dart';
import '../models/surgery.dart';
import '../models/medical_guide.dart';
import '../data/surgery_database.dart';

class AddSurgeryModal extends StatefulWidget {
  final Function(Surgery) onSaved;

  const AddSurgeryModal({super.key, required this.onSaved});

  @override
  State<AddSurgeryModal> createState() => _AddSurgeryModalState();
}

class _AddSurgeryModalState extends State<AddSurgeryModal> {
  final _clinicController = TextEditingController();
  final _doctorController = TextEditingController();
  final _costController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _showAdvanced = false;

  SurgeryCategory? _selectedCategory;
  String? _selectedSurgeryName;

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
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _save() {
    if (_selectedSurgeryName == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '施術を選択してください',
            style: TextStyle(),
          ),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final surgery = Surgery(
      id: const Uuid().v4(),
      name: _selectedSurgeryName!,
      date: _selectedDate,
      category: _selectedCategory!,
      clinicName: _clinicController.text.trim().isEmpty ? null : _clinicController.text.trim(),
      doctorName: _doctorController.text.trim().isEmpty ? null : _doctorController.text.trim(),
      cost: _costController.text.trim().isEmpty ? null : _costController.text.trim(),
    );

    widget.onSaved(surgery);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final surgeryNames = _selectedCategory != null
        ? SurgeryDatabase.surgeryTypes[_selectedCategory] ?? []
        : <String>[];

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
                '新しい施術を追加',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // ===== カテゴリ選択 =====
              Text(
                '施術カテゴリ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SurgeryCategory>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: Text(
                      'カテゴリを選択',
                      style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accent),
                    borderRadius: BorderRadius.circular(14),
                    items: SurgeryCategory.values.map((cat) {
                      return DropdownMenuItem<SurgeryCategory>(
                        value: cat,
                        child: Row(
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Text(
                              cat.label,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                        _selectedSurgeryName = null; // リセット
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== 術式選択 =====
              Text(
                '術式',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSurgeryName,
                    hint: Text(
                      _selectedCategory == null ? 'まずカテゴリを選択' : '術式を選択',
                      style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accent),
                    borderRadius: BorderRadius.circular(14),
                    menuMaxHeight: 300,
                    items: surgeryNames.map((name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: _selectedCategory == null
                        ? null
                        : (name) {
                            setState(() {
                              _selectedSurgeryName = name;
                            });
                          },
                  ),
                ),
              ),

              // 選択された術式の確認表示
              if (_selectedSurgeryName != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(_selectedCategory?.icon ?? '', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedSurgeryName!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accent,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedSurgeryName = null),
                        child: const Icon(Icons.close, size: 16, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // 手術日
              Text(
                '手術日',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
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

              // 詳細情報トグル
              GestureDetector(
                onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                child: Row(
                  children: [
                    Icon(
                      _showAdvanced ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '詳細情報（任意）',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // 詳細入力欄
              if (_showAdvanced) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _clinicController,
                  decoration: const InputDecoration(
                    hintText: 'クリニック名',
                    prefixIcon: Icon(Icons.local_hospital_outlined, color: AppTheme.accent),
                  ),
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _doctorController,
                  decoration: const InputDecoration(
                    hintText: '執刀医',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.accent),
                  ),
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _costController,
                  decoration: const InputDecoration(
                    hintText: '費用（例：50万円）',
                    prefixIcon: Icon(Icons.payments_outlined, color: AppTheme.accent),
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 15),
                ),
              ],

              const SizedBox(height: 32),

              // 保存ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('追加する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
