import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../app_theme.dart';
import '../models/surgery.dart';
import '../models/medical_guide.dart';
import '../models/care_task.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../widgets/care_task_tile.dart';
import '../widgets/downtime_timeline.dart';
import '../widgets/emergency_alert_card.dart';
import '../widgets/reminder_card.dart';
import 'edit_surgery_modal.dart';
import 'report_screen.dart';

class SurgeryDetailScreen extends StatefulWidget {
  final Surgery surgery;
  final VoidCallback onUpdated;

  const SurgeryDetailScreen({
    super.key,
    required this.surgery,
    required this.onUpdated,
  });

  @override
  State<SurgeryDetailScreen> createState() => _SurgeryDetailScreenState();
}

class _SurgeryDetailScreenState extends State<SurgeryDetailScreen> {
  final StorageService _storage = StorageService();
  final NotificationService _notification = NotificationService();
  List<CareTask> _tasks = [];
  bool _loading = true;
  late Surgery _surgery;

  @override
  void initState() {
    super.initState();
    _surgery = widget.surgery;
    _notification.initialize();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storage.getCareTasksForSurgery(_surgery.id);
    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  void _showEditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditSurgeryModal(
        surgery: _surgery,
        onSaved: (updated) async {
          await _storage.updateSurgery(updated);
          setState(() => _surgery = updated);
          widget.onUpdated();
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    final nameController = TextEditingController();
    String frequencyType = 'timesPerDay';
    int frequencyValue = 3;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'ケアタスクを追加',
              style: GoogleFonts.zenMaruGothic(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: '例：薬の服用、アイシング',
                      prefixIcon: const Icon(Icons.task_alt, color: AppTheme.accent),
                      filled: true,
                      fillColor: AppTheme.primaryBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.zenMaruGothic(fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '通知頻度',
                    style: GoogleFonts.zenMaruGothic(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 頻度タイプ選択
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(() {
                              frequencyType = 'timesPerDay';
                              frequencyValue = 3;
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: frequencyType == 'timesPerDay'
                                    ? AppTheme.accent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '1日◯回',
                                  style: GoogleFonts.zenMaruGothic(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: frequencyType == 'timesPerDay'
                                        ? Colors.white
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(() {
                              frequencyType = 'interval';
                              frequencyValue = 6;
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: frequencyType == 'interval'
                                    ? AppTheme.accent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '◯時間おき',
                                  style: GoogleFonts.zenMaruGothic(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: frequencyType == 'interval'
                                        ? Colors.white
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 数値選択
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (frequencyValue > 1) {
                            setDialogState(() => frequencyValue--);
                          }
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.accentLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.remove, color: AppTheme.accent, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$frequencyValue',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          if (frequencyValue < 24) {
                            setDialogState(() => frequencyValue++);
                          }
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.accentLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: AppTheme.accent, size: 20),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      frequencyType == 'timesPerDay'
                          ? '1日 $frequencyValue 回'
                          : '$frequencyValue 時間おき',
                      style: GoogleFonts.zenMaruGothic(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),

                  // プリセット
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _presetChip('💊 薬の服用', nameController, '1日3回', setDialogState, () {
                        frequencyType = 'timesPerDay';
                        frequencyValue = 3;
                      }),
                      _presetChip('🧊 アイシング', nameController, '2時間おき', setDialogState, () {
                        frequencyType = 'interval';
                        frequencyValue = 2;
                      }),
                      _presetChip('💧 目薬', nameController, '6時間おき', setDialogState, () {
                        frequencyType = 'interval';
                        frequencyValue = 6;
                      }),
                      _presetChip('🩹 消毒', nameController, '1日2回', setDialogState, () {
                        frequencyType = 'timesPerDay';
                        frequencyValue = 2;
                      }),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('キャンセル', style: GoogleFonts.zenMaruGothic()),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) return;

                  final task = CareTask(
                    id: const Uuid().v4(),
                    surgeryId: _surgery.id,
                    title: nameController.text.trim(),
                    timesPerDay: frequencyType == 'timesPerDay' ? frequencyValue : 0,
                    intervalHours: frequencyType == 'interval' ? frequencyValue : 0,
                    enabled: true,
                  );

                  await _storage.addCareTask(task);
                  await _notification.scheduleTaskNotification(task, _surgery.name);
                  await _loadTasks();
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text('追加', style: GoogleFonts.zenMaruGothic()),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _presetChip(
    String label,
    TextEditingController controller,
    String desc,
    StateSetter setDialogState,
    VoidCallback onSelect,
  ) {
    return GestureDetector(
      onTap: () {
        controller.text = label.replaceAll(RegExp(r'[^\w\s\u3000-\u9FFF]'), '').trim();
        setDialogState(() {
          onSelect();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Text(
          label,
          style: GoogleFonts.zenMaruGothic(fontSize: 12, color: AppTheme.textPrimary),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ヒーローヘッダー
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppTheme.accent,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // 編集ボタン
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
                onPressed: _showEditModal,
                tooltip: '編集',
              ),
              // カメラボタン
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportScreen(surgery: _surgery),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.accentGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // カテゴリバッジ
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_surgery.category.icon} ${_surgery.category.label}',
                          style: GoogleFonts.zenMaruGothic(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _surgery.daysLabel,
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _surgery.name,
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('yyyy年 M月 d日 施術').format(_surgery.date),
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 施術情報セクション
          SliverToBoxAdapter(
            child: Container(
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
                children: [
                  // クリニック・医師・費用を常に表示（空なら「未入力」）
                  _infoRow(Icons.local_hospital_outlined, 'クリニック',
                      _surgery.clinicName ?? '未入力'),
                  const SizedBox(height: 12),
                  _infoRow(Icons.person_outline, '執刀医',
                      _surgery.doctorName ?? '未入力'),
                  const SizedBox(height: 12),
                  _infoRow(Icons.payments_outlined, '費用',
                      _surgery.cost ?? '未入力'),
                  const SizedBox(height: 14),
                  // 編集リンク
                  GestureDetector(
                    onTap: _showEditModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit, size: 14, color: AppTheme.accent),
                        const SizedBox(width: 4),
                        Text(
                          '施術情報を編集',
                          style: GoogleFonts.zenMaruGothic(
                            fontSize: 12,
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== 再施術リマインド =====
          SliverToBoxAdapter(
            child: ReminderCard(surgery: _surgery),
          ),

          // ===== ダウンタイム経過タイムライン =====
          SliverToBoxAdapter(
            child: DowntimeTimeline(
              category: _surgery.category,
              currentDay: _surgery.daysSinceSurgery,
            ),
          ),

          // ===== 緊急アラート =====
          SliverToBoxAdapter(
            child: EmergencyAlertCard(
              category: _surgery.category,
              currentDay: _surgery.daysSinceSurgery,
            ),
          ),

          // ケアスケジュールヘッダー
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  Text(
                    'ケアスケジュール',
                    style: GoogleFonts.zenMaruGothic(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _showAddTaskDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('追加', style: GoogleFonts.zenMaruGothic(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),

          // ケアタスク一覧
          if (_loading)
            const SliverToBoxAdapter(
              child: Center(child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              )),
            )
          else if (_tasks.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.notifications_none, size: 40, color: AppTheme.textSecondary.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Text(
                      'ケアタスクがありません',
                      style: GoogleFonts.zenMaruGothic(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '「＋追加」ボタンからタスクを作成しましょう',
                      style: GoogleFonts.zenMaruGothic(
                        fontSize: 12,
                        color: AppTheme.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = _tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CareTaskTile(
                        task: task,
                        onToggle: (enabled) async {
                          final updated = task.copyWith(enabled: enabled);
                          await _storage.updateCareTask(updated);
                          if (enabled) {
                            await _notification.scheduleTaskNotification(updated, _surgery.name);
                          } else {
                            await _notification.cancelTaskNotifications(task.id);
                          }
                          await _loadTasks();
                        },
                        onDelete: () async {
                          await _notification.cancelTaskNotifications(task.id);
                          await _storage.deleteCareTask(task.id);
                          await _loadTasks();
                        },
                      ),
                    );
                  },
                  childCount: _tasks.length,
                ),
              ),
            ),

          // 余白
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    final isEmpty = value == '未入力';
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.zenMaruGothic(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.zenMaruGothic(
            fontSize: 14,
            fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
            color: isEmpty ? AppTheme.textSecondary.withOpacity(0.5) : AppTheme.textPrimary,
            fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}
