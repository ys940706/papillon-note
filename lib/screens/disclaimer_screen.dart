import 'package:flutter/material.dart';

import '../app_theme.dart';

/// 医療免責事項 & 利用規約画面
/// 初回起動時に表示、同意しないと進めない
class DisclaimerScreen extends StatefulWidget {
  final VoidCallback onAccepted;
  const DisclaimerScreen({super.key, required this.onAccepted});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // ヘッダー
              Icon(Icons.health_and_safety_outlined,
                  size: 56, color: AppTheme.accent),
              const SizedBox(height: 16),
              Text(
                '利用規約 & 医療免責事項',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ご利用の前に以下をお読みください',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // 規約本文
              Expanded(
                child: Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('🏥 医療免責事項'),
                        _bodyText(
                          'Papillon Note（以下「本アプリ」）は、美容施術の経過を'
                          '記録・管理するためのツールです。本アプリで提供される情報'
                          '（ダウンタイムの目安、ケアのポイント、緊急アラート等）は'
                          '一般的な医学知識に基づく参考情報であり、医療専門家による'
                          '診断・治療・助言に代わるものではありません。',
                        ),
                        const SizedBox(height: 8),
                        _bodyText(
                          '症状に関する個別の判断は、必ず担当医師にご相談ください。'
                          '本アプリの情報に基づいて行われた行動によって生じた'
                          'いかなる損害についても、開発者は一切の責任を負いません。',
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle('📋 利用規約'),
                        _bodyText(
                          '1. 本アプリは個人の記録管理を目的としたアプリです。\n'
                          '2. 入力されたデータはお使いのデバイス内にのみ保存され、'
                          '外部サーバーに送信されることはありません。\n'
                          '3. 本アプリのアンインストールやデータ削除により、'
                          '保存されたデータは失われます。重要なデータは'
                          'ご自身でバックアップをお取りください。\n'
                          '4. 本アプリ内のリンクから外部サイト（Amazon等）'
                          'に遷移する場合、遷移先のサービスの利用規約・'
                          'プライバシーポリシーが適用されます。\n'
                          '5. 本アプリは「Amazonアソシエイト・プログラム」'
                          'に参加しています。商品リンクはアフィリエイトリンクを'
                          '含む場合があります。',
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle('⚠️ 重要な注意事項'),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.danger.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.danger.withOpacity(0.2),
                            ),
                          ),
                          child: _bodyText(
                            '本アプリの緊急アラート機能は、受診を促すための'
                            '一般的な参考情報です。実際の緊急事態では、'
                            '直ちに医療機関を受診してください。'
                            'アラートが表示されない場合でも、異常を感じた場合は'
                            '速やかに担当医にご連絡ください。',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 同意チェックボックス
              GestureDetector(
                onTap: () => setState(() => _agreed = !_agreed),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _agreed
                        ? AppTheme.accent.withOpacity(0.06)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _agreed
                          ? AppTheme.accent
                          : AppTheme.textSecondary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _agreed ? AppTheme.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _agreed
                                ? AppTheme.accent
                                : AppTheme.textSecondary.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: _agreed
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '上記の利用規約および医療免責事項に同意します',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _agreed
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 同意ボタン
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _agreed ? widget.onAccepted : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppTheme.textSecondary.withOpacity(0.15),
                    disabledForegroundColor:
                        AppTheme.textSecondary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: _agreed ? 4 : 0,
                    shadowColor: AppTheme.accent.withOpacity(0.3),
                  ),
                  child: Text(
                    '同意してはじめる',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        color: AppTheme.textPrimary,
        height: 1.8,
      ),
    );
  }
}
