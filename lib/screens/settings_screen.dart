import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../main.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import 'dt_prep_list_screen.dart';
import 'privacy_policy_screen.dart';
import 'disclaimer_screen.dart';

/// 設定画面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back,
                color: AppTheme.textPrimary, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '設定',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // === 通知設定 ===
          _sectionHeader('🔔 通知'),
          _card([
            _switchTile(
              icon: Icons.notifications_active_outlined,
              title: 'ケアリマインダー通知',
              subtitle: '服薬・アイシング等の定期リマインド',
              value: _notificationsEnabled,
              onChanged: (v) async {
                setState(() => _notificationsEnabled = v);
                if (!v) {
                  await NotificationService().cancelAllNotifications();
                }
              },
            ),
          ]),
          const SizedBox(height: 20),

          // === コンテンツ ===
          _sectionHeader('📦 コンテンツ'),
          _card([
            _navTile(
              icon: Icons.shopping_bag_outlined,
              title: 'DT準備リスト',
              subtitle: 'ダウンタイムに必要なアイテム',
              iconColor: const Color(0xFFFF9900),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const DtPrepListScreen()),
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // === サポート ===
          _sectionHeader('💬 サポート'),
          _card([
            _navTile(
              icon: Icons.mail_outline,
              title: 'お問い合わせ',
              subtitle: 'ご意見・ご要望・不具合報告',
              onTap: () => _sendEmail(),
            ),
            _divider(),
            _navTile(
              icon: Icons.star_outline,
              title: 'アプリを評価する',
              subtitle: 'App Storeでレビューを書く',
              onTap: () {
                // TODO: App StoreのURLに変更
              },
            ),
          ]),
          const SizedBox(height: 20),

          // === 法的情報 ===
          _sectionHeader('📄 法的情報'),
          _card([
            _navTile(
              icon: Icons.privacy_tip_outlined,
              title: 'プライバシーポリシー',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen()),
              ),
            ),
            _divider(),
            _navTile(
              icon: Icons.health_and_safety_outlined,
              title: '利用規約・医療免責事項',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DisclaimerScreen(
                    onAccepted: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // === データ管理 ===
          _sectionHeader('🗂️ データ管理'),
          _card([
            _dangerTile(
              icon: Icons.delete_forever_outlined,
              title: 'すべてのデータを削除',
              subtitle: '施術記録・ケアスケジュールを完全に削除',
              onTap: () => _confirmDeleteAll(),
            ),
          ]),
          const SizedBox(height: 32),

          // === バージョン情報 ===
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/papillon_icon.jpg', width: 48, height: 48),
                ),
                const SizedBox(height: 4),
                Text(
                  'Papillon Note',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '© 2026 Studio Papillon',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // === Helper Widgets ===

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.accent).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.accent, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right,
          color: AppTheme.textSecondary, size: 20),
      onTap: onTap,
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.accent, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppTheme.accent,
        onChanged: onChanged,
      ),
    );
  }

  Widget _dangerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.danger.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.danger, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.danger,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: AppTheme.textSecondary,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 72,
      color: Colors.grey.withOpacity(0.15),
    );
  }

  // === Actions ===

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@studio-papillon.app',
      queryParameters: {
        'subject': '[Papillon Note] お問い合わせ',
        'body': '\n\n---\nアプリバージョン: 1.0.0\nプラットフォーム: iOS',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _confirmDeleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppTheme.danger, size: 24),
            const SizedBox(width: 8),
            Text(
              'データの全削除',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'すべての施術記録・ケアスケジュールが\n完全に削除されます。\n\nこの操作は取り消せません。\n本当に削除しますか？',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('キャンセル',
                style: TextStyle()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
            child: Text('すべて削除',
                style: TextStyle(
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await StorageService().deleteAllData();
      } catch (e) {
        debugPrint('Delete data error: $e');
      }
      try {
        await NotificationService().cancelAllNotifications();
      } catch (e) {
        debugPrint('Cancel notifications error: $e');
      }
      if (mounted) {
        // 全画面を破棄して初回起動フローから再開
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PapillonNoteApp()),
          (_) => false,
        );
      }
    }
  }
}
