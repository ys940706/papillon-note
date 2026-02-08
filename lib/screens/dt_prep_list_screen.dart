import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

/// DT（ダウンタイム）準備リスト画面
class DtPrepListScreen extends StatelessWidget {
  const DtPrepListScreen({super.key});

  static const List<_PrepItem> _items = [
    _PrepItem(
      name: '冷えピタ',
      icon: Icons.ac_unit,
      color: Color(0xFF42A5F5),
      description:
          '術後の腫れ・熱感を冷やすための必須アイテム。'
          '冷蔵庫で冷やしておくと効果的。'
          'おでこ・頬など広い範囲に使える大判タイプがおすすめ。',
      tips: ['前日に10枚以上ストック推奨', '冷蔵庫で冷やしておくと◎'],
      amazonUrl: 'https://www.amazon.co.jp/s?k=%E5%86%B7%E3%81%88%E3%83%94%E3%82%BF',
    ),
    _PrepItem(
      name: '高めの枕',
      icon: Icons.airline_seat_flat,
      color: Color(0xFF7E57C2),
      description:
          '術後は頭を高くして寝ることで、むくみ・腫れの軽減に効果的。'
          '傾斜がなだらかな三角クッションが人気。'
          '通常の枕を2〜3個重ねてもOK。',
      tips: ['15〜30度の角度が目安', '寝返り防止クッションも併用すると安心'],
      amazonUrl: 'https://www.amazon.co.jp/s?k=%E4%B8%89%E8%A7%92%E3%82%AF%E3%83%83%E3%82%B7%E3%83%A7%E3%83%B3+%E6%9E%95',
    ),
    _PrepItem(
      name: 'ドライシャンプー',
      icon: Icons.shower,
      color: Color(0xFF26A69A),
      description:
          '術後数日〜1週間はシャワーが制限される場合が多いため、'
          '水なしで使えるドライシャンプーがあると快適。'
          'スプレータイプ・パウダータイプ・シートタイプなど種類豊富。',
      tips: ['スプレータイプが手軽で人気', '敏感肌用を選ぶと安心'],
      amazonUrl: 'https://www.amazon.co.jp/s?k=%E3%83%89%E3%83%A9%E3%82%A4%E3%82%B7%E3%83%A3%E3%83%B3%E3%83%97%E3%83%BC',
    ),
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
            child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DT準備リスト',
          style: GoogleFonts.zenMaruGothic(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // ヘッダー説明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF8E1), Color(0xFFFFF3E0)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFE0B2)),
            ),
            child: Row(
              children: [
                const Text('🛒', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ダウンタイムに備えよう',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '施術前に準備しておくと安心なアイテムをまとめました',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // アイテムカード
          ..._items.map((item) => _buildItemCard(item)),
        ],
      ),
    );
  }

  Widget _buildItemCard(_PrepItem item) {
    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
              // ヘッダー（アイコン+名前）
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // 大きなアイコン
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(item.icon, color: item.color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.zenMaruGothic(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: GoogleFonts.zenMaruGothic(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ヒント
              if (item.tips.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, size: 14, color: AppTheme.accent),
                          const SizedBox(width: 4),
                          Text(
                            'ポイント',
                            style: GoogleFonts.zenMaruGothic(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...item.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(left: 4, top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: GoogleFonts.zenMaruGothic(fontSize: 11, color: AppTheme.textSecondary)),
                            Expanded(
                              child: Text(
                                tip,
                                style: GoogleFonts.zenMaruGothic(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

              // Amazonボタン
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openUrl(item.amazonUrl),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(
                      'Amazonで見る',
                      style: GoogleFonts.zenMaruGothic(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9900),
                      side: const BorderSide(color: Color(0xFFFF9900)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PrepItem {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> tips;
  final String amazonUrl;

  const _PrepItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.tips,
    required this.amazonUrl,
  });
}
