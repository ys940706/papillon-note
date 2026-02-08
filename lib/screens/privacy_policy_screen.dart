import 'package:flutter/material.dart';

import '../app_theme.dart';

/// プライバシーポリシー画面
/// Amazonアソシエイト参加表明を含む
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'プライバシーポリシー',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Container(
          padding: const EdgeInsets.all(24),
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
              _heading('プライバシーポリシー'),
              _date('最終更新日: 2026年2月8日'),
              const SizedBox(height: 20),

              _section('1. はじめに'),
              _body(
                'Papillon Note（以下「本アプリ」）は、ユーザーの'
                'プライバシーを最大限に尊重します。本ポリシーは、'
                '本アプリにおけるデータの取り扱いについて説明します。',
              ),

              _section('2. 収集するデータ'),
              _body(
                '本アプリは以下のデータを収集・保存します：\n\n'
                '• 施術記録（施術名、日付、クリニック名、医師名、費用）\n'
                '• ケアスケジュール（タスク名、頻度、有効/無効状態）\n'
                '• 経過写真（施術前後の記録画像）\n'
                '• アプリ設定（通知設定、初回起動フラグ）',
              ),

              _section('3. データの保存場所'),
              _body(
                '上記のデータはすべてお使いのデバイス内にのみ保存されます。'
                '外部サーバーやクラウドサービスへのデータ送信は'
                '一切行いません。',
              ),
              _highlight(
                '🔒 あなたのデータはあなたのデバイスの中だけにあります',
              ),

              _section('4. データの共有'),
              _body(
                '本アプリでは、ユーザーが明示的に「共有」機能を使用した場合'
                'にのみ、経過記録の画像をSNS等に投稿できます。'
                'ユーザーの操作なしにデータが共有されることはありません。',
              ),

              _section('5. 通知'),
              _body(
                'ケアスケジュールに基づくローカル通知を送信します。'
                'これらの通知はデバイス内で処理され、'
                '外部サーバーは使用しません。通知はいつでも'
                '設定画面からオフにできます。',
              ),

              _section('6. 外部リンクについて'),
              _body(
                '本アプリ内にAmazon.co.jpへのリンクが含まれる'
                '場合があります。リンク先の外部サイトにおけるデータの'
                '取り扱いは、当該サイトのプライバシーポリシーに'
                '従います。',
              ),

              _section('7. Amazonアソシエイトについて'),
              _amazonDisclosure(),

              _section('8. カメラ・写真へのアクセス'),
              _body(
                '本アプリは、経過写真の撮影・選択のためにカメラおよび'
                'フォトライブラリへのアクセスを要求する場合があります。'
                'これらの権限は経過記録の作成にのみ使用され、'
                '撮影・選択された写真はデバイス内にのみ保存されます。',
              ),

              _section('9. データの削除'),
              _body(
                'アプリの設定画面から、保存されたすべてのデータを'
                '削除できます。また、アプリをアンインストールすると '
                '保存データはすべて削除されます。',
              ),

              _section('10. 子どものプライバシー'),
              _body(
                '本アプリは13歳未満のお子様を対象としておりません。'
                '13歳未満のお子様から意図的に個人情報を収集することは'
                'ありません。',
              ),

              _section('11. ポリシーの変更'),
              _body(
                '本プライバシーポリシーは予告なく変更される'
                '場合があります。変更はアプリの更新を通じて'
                '通知されます。',
              ),

              _section('12. お問い合わせ'),
              _body(
                'プライバシーに関するご質問やご懸念がある場合は、'
                'アプリ内の「設定」>「お問い合わせ」よりご連絡ください。',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _date(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _body(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppTheme.textPrimary,
        height: 1.8,
      ),
    );
  }

  Widget _highlight(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amazonDisclosure() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront, size: 16, color: Color(0xFFFF9900)),
              const SizedBox(width: 6),
              Text(
                'Amazonアソシエイト・プログラム',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Papillon Noteは、Amazon.co.jpを宣伝しリンクすることに'
            'よってサイトが紹介料を獲得できる手段を提供することを'
            '目的に設定されたアフィリエイトプログラムである、'
            'Amazonアソシエイト・プログラムの参加者です。',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textPrimary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
