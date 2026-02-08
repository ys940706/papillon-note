import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models/surgery.dart';
import '../services/storage_service.dart';
import '../widgets/surgery_card.dart';
import 'add_surgery_modal.dart';
import 'settings_screen.dart';
import 'surgery_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final StorageService _storage = StorageService();
  List<Surgery> _surgeries = [];
  bool _loading = true;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadData();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final surgeries = await _storage.getSurgeries();
    setState(() {
      _surgeries = surgeries;
      _loading = false;
    });
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSurgeryModal(
        onSaved: (surgery) async {
          await _storage.addSurgery(surgery);
          await _loadData();
        },
      ),
    );
  }

  void _openDetail(Surgery surgery) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SurgeryDetailScreen(
          surgery: surgery,
          onUpdated: _loadData,
        ),
      ),
    );
  }

  Future<void> _deleteSurgery(Surgery surgery) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '削除確認',
          style: GoogleFonts.zenMaruGothic(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '「${surgery.name}」を削除しますか？\nこの施術に関連するケアタスクも削除されます。',
          style: GoogleFonts.zenMaruGothic(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.deleteSurgery(surgery.id);
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ヘッダー
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryBg,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                'Papillon Note',
                style: GoogleFonts.zenMaruGothic(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.heroGradient,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.more_horiz, size: 20, color: AppTheme.textPrimary),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  offset: const Offset(0, 48),
                  onSelected: (value) {
                    if (value == 'settings') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings_outlined, color: AppTheme.accent, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            '設定',
                            style: GoogleFonts.zenMaruGothic(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // コンテンツ
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_surgeries.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final surgery = _surgeries[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SurgeryCard(
                        surgery: surgery,
                        onTap: () => _openDetail(surgery),
                        onDelete: () => _deleteSurgery(surgery),
                      ),
                    );
                  },
                  childCount: _surgeries.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.accentLight.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.spa_outlined,
              size: 56,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '施術を追加しましょう',
            style: GoogleFonts.zenMaruGothic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '＋ ボタンをタップして\n最初の施術を記録してください',
            textAlign: TextAlign.center,
            style: GoogleFonts.zenMaruGothic(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showAddModal,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
