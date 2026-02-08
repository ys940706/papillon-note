import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

/// オンボーディング画面
/// 蝶への変化（Papillon）コンセプトの3ページスワイプ式
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.auto_awesome,
      iconColor: Color(0xFFE1BEE7),
      bgGradient: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
      title: 'あなたの変化を見守る',
      subtitle: 'Papillon Note',
      body: 'ダウンタイムという「サナギの時間」を、\n'
          'もっと安心して過ごせるように。\n'
          '美しく羽ばたくその日まで、優しく記録します。',
      emoji: '',
      imagePath: 'assets/images/papillon_icon.jpg',
    ),
    _OnboardingPage(
      icon: Icons.timeline,
      iconColor: Color(0xFFB2DFDB),
      bgGradient: [Color(0xFFE0F2F1), Color(0xFFE8F5E9)],
      title: '安心のダウンタイム管理',
      subtitle: 'Recovery Guide',
      body: '術後の経過フェーズをタイムラインで表示。\n'
          '正常な症状とケアのポイントを確認でき、\n'
          '不安な時も安心して過ごせます。',
      emoji: '🩺',
    ),
    _OnboardingPage(
      icon: Icons.notifications_active,
      iconColor: Color(0xFFFFE0B2),
      bgGradient: [Color(0xFFFFF8E1), Color(0xFFFFF3E0)],
      title: 'スマートなケアリマインド',
      subtitle: 'Care Schedule',
      body: 'お薬の服用やアイシングの時間を\n'
          '通知でお知らせ。\n'
          '再施術のタイミングもリマインドします。',
      emoji: '⏰',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      body: SafeArea(
        child: Column(
          children: [
            // スキップボタン
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 20),
                child: TextButton(
                  onPressed: widget.onCompleted,
                  child: Text(
                    'スキップ',
                    style: GoogleFonts.zenMaruGothic(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // ページコンテンツ
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    _buildPage(_pages[index]),
              ),
            ),

            // インジケーター
            _buildIndicators(),
            const SizedBox(height: 24),

            // ボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppTheme.accent.withOpacity(0.3),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'はじめる'
                        : '次へ',
                    style: GoogleFonts.zenMaruGothic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // イラスト風アイコン
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: page.bgGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.iconColor.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: page.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(page.imagePath!, width: 80, height: 80),
                    )
                  : Text(page.emoji, style: const TextStyle(fontSize: 56)),
            ),
          ),
          const SizedBox(height: 40),

          // サブタイトル
          Text(
            page.subtitle,
            style: GoogleFonts.zenMaruGothic(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.accent,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          // タイトル
          Text(
            page.title,
            style: GoogleFonts.zenMaruGothic(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 説明文
          Text(
            page.body,
            style: GoogleFonts.zenMaruGothic(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == i ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == i
                ? AppTheme.accent
                : AppTheme.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final List<Color> bgGradient;
  final String title;
  final String subtitle;
  final String body;
  final String emoji;
  final String? imagePath;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.bgGradient,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.emoji,
    this.imagePath,
  });
}
