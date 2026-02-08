/// 定期施術のリマインドデータ
/// 学術的根拠に基づく効果持続期間と再施術推奨タイミング
class ReminderData {
  /// 術式名 → リマインド情報のマッピング
  /// durationMonths: 効果持続期間（月）
  /// reminderMonths: リマインド通知（効果切れ前に通知、月）
  /// note: 備考
  static const Map<String, ReminderInfo> _data = {
    // ===== ヒアルロン酸注入 =====
    'ヒアルロン酸注入（額）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '持続期間は製剤により6-18ヶ月。ボリューマ等の硬い製剤は長持ち。'),
    'ヒアルロン酸注入（こめかみ）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '動きの少ない部位のため比較的長持ち（12-18ヶ月）。'),
    'ヒアルロン酸注入（涙袋）': ReminderInfo(durationMonths: 9, reminderMonths: 7, note: '涙袋は動きが多く吸収が早め（6-12ヶ月）。'),
    'ヒアルロン酸注入（鼻）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '鼻筋は比較的持続（12-18ヶ月）。繰り返し注入で長持ちする傾向。'),
    'ヒアルロン酸注入（ほうれい線）': ReminderInfo(durationMonths: 10, reminderMonths: 8, note: '表情筋の動きにより吸収が早い部位（8-14ヶ月）。'),
    'ヒアルロン酸注入（唇）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '唇は血流が多く吸収が最も早い部位（4-8ヶ月）。'),
    'ヒアルロン酸注入（顎）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '硬い製剤を使用するため長持ち（12-18ヶ月）。'),
    'ヒアルロン酸注入（頬）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '持続期間は注入量と製剤による（10-18ヶ月）。'),
    'ヒアルロン酸注入（マリオネットライン）': ReminderInfo(durationMonths: 10, reminderMonths: 8, note: '表情筋の影響で吸収が比較的早い（8-14ヶ月）。'),
    'ヒアルロン酸注入（手の甲）': ReminderInfo(durationMonths: 9, reminderMonths: 7, note: '手は動きが多いため持続期間は短め（6-12ヶ月）。'),

    // ===== ボトックス =====
    'ボトックス注射（額）': ReminderInfo(durationMonths: 4, reminderMonths: 3, note: '効果は通常3-6ヶ月。定期的な施術で持続期間が延びる傾向。'),
    'ボトックス注射（眉間）': ReminderInfo(durationMonths: 4, reminderMonths: 3, note: '眉間のシワ予防に最も効果的。3-6ヶ月持続。'),
    'ボトックス注射（目尻）': ReminderInfo(durationMonths: 4, reminderMonths: 3, note: '笑いジワに対して3-5ヶ月持続。'),
    'ボトックス注射（エラ）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '咬筋への注入は4-8ヶ月持続。筋肉が萎縮するため回を重ねると長持ち。'),
    'ボトックス注射（ガミースマイル）': ReminderInfo(durationMonths: 4, reminderMonths: 3, note: '3-6ヶ月持続。'),
    'ボトックス注射（ふくらはぎ）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '筋肉量により持続期間が異なる（4-8ヶ月）。'),
    'ボトックス注射（脇・多汗症）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '多汗症治療では4-9ヶ月持続。夏前の施術が推奨。'),
    'ボトックス注射（肩）': ReminderInfo(durationMonths: 5, reminderMonths: 4, note: '肩ボトックス（肩こり/肩痩せ）は4-6ヶ月持続。'),

    // ===== その他の注入系 =====
    'ベビーコラーゲン注入': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: 'Ⅰ型・Ⅲ型コラーゲン注入。効果は3-6ヶ月。'),
    'エランセ注入': ReminderInfo(durationMonths: 18, reminderMonths: 15, note: 'PCL素材。製剤により1-4年持続。コラーゲン生成促進効果あり。'),
    'レディエッセ注入': ReminderInfo(durationMonths: 14, reminderMonths: 12, note: 'ハイドロキシアパタイト製剤。12-18ヶ月持続。溶解剤がないため注意。'),
    'スネコス注射': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '初回は3-4回コース推奨。効果持続は約6ヶ月。'),
    'リジュラン注射': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: 'PN/PDRN製剤。初回3-4回コース後、6ヶ月間隔でメンテナンス。'),
    'プロファイロ注射': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '高濃度ヒアルロン酸注入。2回1コース後、6ヶ月間隔でメンテナンス。'),
    'ジュビダームビスタ': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: 'アラガン社製ヒアルロン酸。ボリューマ/ボルベラ等で持続期間が異なる。'),
    'PRP療法（多血小板血漿）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '自己血由来。効果発現に1-3ヶ月。持続は6-18ヶ月。'),

    // ===== 糸リフト =====
    'ほうれい線治療（ヒアルロン酸）': ReminderInfo(durationMonths: 10, reminderMonths: 8, note: 'ヒアルロン酸充填。8-14ヶ月持続。'),
    'マリオネットライン治療': ReminderInfo(durationMonths: 10, reminderMonths: 8, note: '通常ヒアルロン酸注入。8-14ヶ月持続。'),
    'ゴルゴライン治療': ReminderInfo(durationMonths: 10, reminderMonths: 8, note: 'ヒアルロン酸/脂肪注入。8-14ヶ月持続。'),
    '糸リフト（スレッドリフト）': ReminderInfo(durationMonths: 18, reminderMonths: 15, note: 'PDO/PCL/PLAにより持続期間が異なる。物理的リフト効果は6-12ヶ月、コラーゲン生成効果は12-24ヶ月。'),

    // ===== HIFU・RF系 =====
    'HIFU（ハイフ）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '超音波によるリフトアップ。効果ピークは施術後1-3ヶ月。持続は3-6ヶ月。年2-3回推奨。'),
    'サーマクール': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: 'RF（高周波）による引き締め。効果は2-6ヶ月持続。年1-2回推奨。'),
    'ウルトラフォーマーⅢ': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: 'HIFU機器。効果は3-6ヶ月。3-6ヶ月間隔でメンテナンス。'),
    'ソノクイーン': ReminderInfo(durationMonths: 5, reminderMonths: 4, note: 'HIFU機器（目周り特化も）。効果は3-6ヶ月。'),
    'タイタン': ReminderInfo(durationMonths: 4, reminderMonths: 3, note: '近赤外線による引き締め。月1回×3-5回コース推奨。'),
    'ポテンツァ': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: 'ニードルRF。肌質改善は3-5回コース後、3-6ヶ月間隔でメンテナンス。'),
    'シルファームX': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: 'パルス高周波マイクロニードル。3-5回コース推奨。効果持続3-6ヶ月。'),

    // ===== レーザー・光治療 =====
    'ピコレーザー（ピコトーニング）': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: '肝斑・美白に月1回×5-10回コース推奨。その後2-3ヶ月間隔でメンテナンス。'),
    'IPL（フォトフェイシャル）': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: '月1回×3-5回コース後、2-3ヶ月間隔でメンテナンス。'),
    'フォトRF（オーロラ）': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: 'IPL+RF併用。月1回×5回コース後、メンテナンス。'),
    'ジェネシス': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: 'ロングパルスYAGレーザー。2-4週間隔で5回程度推奨。'),
    'ライムライト': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: 'IPLの一種。3-4週間隔で3-5回コース推奨。'),

    // ===== スキンケア =====
    'ケミカルピーリング（グリコール酸）': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: '月1回を4-6回コース推奨。維持は1-2ヶ月間隔。'),
    'ケミカルピーリング（サリチル酸マクロゴール）': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: '月1回を4-6回コース推奨。刺激が少ないのが特徴。'),
    'マッサージピール（PRX-T33/コラーゲンピール）': ReminderInfo(durationMonths: 2, reminderMonths: 1, note: '2-3週間隔で3-5回コース推奨。コラーゲン生成促進。'),
    'ハイドラフェイシャル': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: '月1回のメンテナンスが理想。毛穴洗浄+保湿。'),
    '水光注射': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: '2-4週間隔で3回コース後、2-3ヶ月間隔でメンテナンス。'),
    'ダーマペン4': ReminderInfo(durationMonths: 2, reminderMonths: 1, note: '3-4週間隔で3-5回コース推奨。コラーゲン生成促進。'),
    'ヴェルベットスキン（ダーマペン+マッサージピール）': ReminderInfo(durationMonths: 2, reminderMonths: 1, note: 'ダーマペン+マッサージピールの併用。3-4週間隔で3-5回推奨。'),
    'エクソソーム療法': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: '幹細胞由来エクソソーム。2-4週間隔で3-5回後、3ヶ月間隔でメンテナンス。'),
    'フラクショナルCO2レーザー': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '1-3ヶ月間隔で3-5回コース推奨。ニキビ跡・毛穴改善に。'),

    // ===== ホワイトニング =====
    'ホワイトニング（オフィス）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '効果持続は3-6ヶ月。食事・喫煙習慣により異なる。半年に1回のメンテナンス推奨。'),
    'ホワイトニング（ホーム）': ReminderInfo(durationMonths: 6, reminderMonths: 5, note: '効果持続は3-6ヶ月。メンテナンスとして月数回の使用推奨。'),
    'デュアルホワイトニング': ReminderInfo(durationMonths: 9, reminderMonths: 7, note: 'オフィス+ホームの併用で効果が長持ち（6-12ヶ月）。'),

    // ===== 脱毛 =====
    '医療レーザー脱毛（顔）': ReminderInfo(durationMonths: 2, reminderMonths: 1, note: '1-2ヶ月間隔で5-8回コース。毛周期に合わせた施術が重要。'),
    '医療レーザー脱毛（ワキ）': ReminderInfo(durationMonths: 2, reminderMonths: 2, note: '2ヶ月間隔で5-6回コース。完了後は基本的に永久脱毛。'),
    '医療レーザー脱毛（VIO）': ReminderInfo(durationMonths: 2, reminderMonths: 2, note: '1.5-2ヶ月間隔で5-8回コース。'),
    '医療レーザー脱毛（全身）': ReminderInfo(durationMonths: 2, reminderMonths: 2, note: '2ヶ月間隔で5-8回コース。部位により必要回数が異なる。'),
    '医療レーザー脱毛（腕・脚）': ReminderInfo(durationMonths: 2, reminderMonths: 2, note: '2ヶ月間隔で5-6回コース。'),

    // ===== AGA =====
    'AGA治療（内服薬）': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: 'フィナステリド/デュタステリドは継続服用が必要。中止すると3-6ヶ月で効果が消失。'),
    'AGA治療（外用薬）': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: 'ミノキシジル外用は毎日継続が必要。中止で効果消失。'),
    'AGA治療（メソセラピー）': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: '月1回×6-12回コース後、2-3ヶ月間隔でメンテナンス。'),
    'HARG療法': ReminderInfo(durationMonths: 3, reminderMonths: 2, note: '月1回×6回コース後、3-6ヶ月間隔でメンテナンス。'),

    // ===== 点滴 =====
    '白玉注射（グルタチオン点滴）': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: '週1-2回を推奨。効果維持には継続が必要。'),
    '高濃度ビタミンC点滴': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: '月1-2回推奨。疲労回復・美白効果。'),
    'プラセンタ注射': ReminderInfo(durationMonths: 1, reminderMonths: 1, note: '週1-2回推奨。効果維持には継続が必要。'),

    // ===== プチ隆鼻 =====
    'プチ隆鼻（ヒアルロン酸注入）': ReminderInfo(durationMonths: 12, reminderMonths: 10, note: '製剤により6-18ヶ月持続。クレヴィエルコントアは長持ち。'),
    '鼻先ボトックス': ReminderInfo(durationMonths: 4, reminderMonths: 3, note: '鼻を動かす筋肉を抑制。3-6ヶ月持続。'),

    // ===== 目元 =====
    '涙袋形成（ヒアルロン酸注入）': ReminderInfo(durationMonths: 9, reminderMonths: 7, note: '涙袋は動きが多く吸収されやすい。6-12ヶ月持続。'),

    // ===== アートメイク =====
    'アートメイク（眉）': ReminderInfo(durationMonths: 18, reminderMonths: 15, note: '1-3年で徐々に薄くなる。リタッチは1-2年間隔推奨。'),
    'アートメイク（アイライン）': ReminderInfo(durationMonths: 24, reminderMonths: 20, note: '眉より持続が長い（2-3年）。リタッチ推奨。'),
    'アートメイク（リップ）': ReminderInfo(durationMonths: 18, reminderMonths: 15, note: '1-2年で薄くなる。唇は代謝が早いため比較的短い。'),
    'アートメイク（ヘアライン）': ReminderInfo(durationMonths: 18, reminderMonths: 15, note: '1-3年持続。汗をかく部位のため退色しやすい。'),
  };

  /// 術式名からリマインド情報を取得
  static ReminderInfo? getReminder(String surgeryName) {
    return _data[surgeryName];
  }

  /// リマインドが必要な術式かどうか
  static bool hasReminder(String surgeryName) {
    return _data.containsKey(surgeryName);
  }
}

/// リマインド情報
class ReminderInfo {
  final int durationMonths;   // 効果持続期間（月）
  final int reminderMonths;   // リマインド通知タイミング（月）
  final String note;          // 学術的根拠に基づくメモ

  const ReminderInfo({
    required this.durationMonths,
    required this.reminderMonths,
    required this.note,
  });

  /// 効果切れ予定日を計算
  DateTime getExpiryDate(DateTime surgeryDate) {
    return DateTime(
      surgeryDate.year,
      surgeryDate.month + durationMonths,
      surgeryDate.day,
    );
  }

  /// リマインド日を計算
  DateTime getReminderDate(DateTime surgeryDate) {
    return DateTime(
      surgeryDate.year,
      surgeryDate.month + reminderMonths,
      surgeryDate.day,
    );
  }

  /// 効果切れまでの残日数
  int daysUntilExpiry(DateTime surgeryDate) {
    final expiry = getExpiryDate(surgeryDate);
    final now = DateTime.now();
    return expiry.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  /// リマインド表示すべきかどうか
  bool shouldShowReminder(DateTime surgeryDate) {
    return daysUntilExpiry(surgeryDate) <= 30; // 残り30日以下で表示
  }
}
