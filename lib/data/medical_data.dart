import '../models/medical_guide.dart';

/// 各施術カテゴリ別の医学的ダウンタイム情報・緊急アラート
/// 一般的な医学文献・美容外科ガイドラインに基づく参考情報
class MedicalData {
  static final Map<SurgeryCategory, SurgeryGuide> guides = {

    // ===== 目元 =====
    SurgeryCategory.eyelid: SurgeryGuide(
      category: SurgeryCategory.eyelid,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 2,
          title: '急性腫脹期',
          description: '手術直後〜2日目。腫れ・内出血のピーク。目が開きにくい場合もあります。',
          normalSymptoms: ['強い腫れ', '内出血（紫〜赤色）', '目の違和感・ゴロゴロ感', '涙が出やすい', '軽い痛み'],
          tips: ['頭を高くして寝る', 'アイシング（20分冷やす→10分休む）', '目を擦らない', '処方薬は指示通りに服用'],
        ),
        DowntimePhase(
          startDay: 3, endDay: 7,
          title: '腫脹・改善初期',
          description: '腫れが徐々に引き始めます。内出血が黄色〜緑色に変化するのは正常です。',
          normalSymptoms: ['腫れの軽減（ただし左右差あり）', '内出血の色の変化（黄色〜緑）', '二重幅が広く見える', 'つっぱり感'],
          tips: ['洗顔は丁寧に（ゴシゴシ禁止）', 'コンタクト使用は医師に確認', '抜糸まで糸を触らない', 'メイクは抜糸後から'],
        ),
        DowntimePhase(
          startDay: 8, endDay: 30,
          title: '回復期',
          description: '大きな腫れは引き、二重のラインが安定してきます。ただし完成形ではありません。',
          normalSymptoms: ['軽いむくみ（朝に目立つ）', '二重幅の変動', '傷跡の赤み', '軽い引き攣れ感'],
          tips: ['目のマッサージ（医師の許可後）', '日焼け止めを塗る（色素沈着予防）', '飲酒・激しい運動は控えめに'],
        ),
        DowntimePhase(
          startDay: 31, endDay: 180,
          title: '完成に向かう安定期',
          description: '3〜6ヶ月で最終的な仕上がりに近づきます。傷跡も薄くなっていきます。',
          normalSymptoms: ['朝の軽いむくみ', '傷跡の薄い赤み→白色化'],
          tips: ['紫外線対策を継続', '心配な点は検診で相談'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '激しい痛みの増強',
          description: '術後の痛みは通常2-3日で軽減します。日に日に痛みが強くなる場合は感染の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '急激な片側の腫脹',
          description: '片目だけ急に腫れが強くなった場合、血腫（内部出血）の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '視力の低下・視野の欠損',
          description: '見え方に異常がある場合は、眼窩内血腫など重篤な合併症の可能性があり、緊急受診が必要です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '高熱（38.5℃以上）',
          description: '38.5℃以上の発熱は感染徴候の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '傷口からの膿・異臭',
          description: '黄色〜緑色の膿や異臭がある場合は感染症が疑われます。',
          level: AlertLevel.danger,
          relevantAfterDay: 2,
        ),
        EmergencyAlert(
          symptom: '1週間以上経っても改善しない強い腫れ',
          description: '通常1週間で大きな腫れは引きます。改善傾向がない場合は受診を。',
          level: AlertLevel.warning,
          relevantAfterDay: 7,
        ),
        EmergencyAlert(
          symptom: '糸が飛び出している・露出している',
          description: '埋没法の場合、糸が皮膚から露出することがあり、早めの処置が必要です。',
          level: AlertLevel.warning,
          relevantAfterDay: 3,
        ),
      ],
    ),

    // ===== 鼻 =====
    SurgeryCategory.nose: SurgeryGuide(
      category: SurgeryCategory.nose,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 3,
          title: '急性腫脹期',
          description: '手術直後。ギプス・テーピング固定中。鼻周囲と目元に腫れ・内出血が出ます。',
          normalSymptoms: ['鼻全体の強い腫れ', '目元の内出血（パンダ目）', '鼻詰まり', '微量の出血（ガーゼに薄いピンク色）', '頭重感'],
          tips: ['口呼吸になるのでマスク＋加湿', '頭を高く保つ', 'くしゃみは口を開けて', '鼻をかまない', 'アイシングは目元に優しく'],
        ),
        DowntimePhase(
          startDay: 4, endDay: 7,
          title: 'ギプス除去期',
          description: '5-7日目にギプス除去。除去直後は鼻がまだ太く見えますが、これは残存腫脹です。',
          normalSymptoms: ['鼻筋のむくみ', '鼻先の硬さ・感覚鈍麻', '内出血の色の変化', '鼻通りの改善'],
          tips: ['ギプス除去後もテーピング推奨（医師指示に従う）', 'メガネは鼻に負荷がかからないよう注意', '軽いメイクはOK（医師確認後）'],
        ),
        DowntimePhase(
          startDay: 8, endDay: 30,
          title: '回復初期',
          description: '腫れが徐々に引き、鼻の輪郭が見えてきます。ただし鼻先の腫れは最も遅くまで残ります。',
          normalSymptoms: ['鼻先のむくみ（夕方に目立つ）', '感覚の回復途中', '皮膚のカサつき', '軽い左右差'],
          tips: ['サングラス・メガネは軽いもので短時間', '運動は軽いウォーキングから', 'うつ伏せ寝は避ける', '鼻を強く押さない'],
        ),
        DowntimePhase(
          startDay: 31, endDay: 90,
          title: '安定期',
          description: '多くの腫れが引き、形が安定してきます。鼻先の完成は3-6ヶ月かかります。',
          normalSymptoms: ['鼻先の微妙なむくみ', '硬さの残存', '朝晩のわずかな変動'],
          tips: ['鼻への衝撃に注意（スポーツ等）', '定期検診を忘れずに'],
        ),
        DowntimePhase(
          startDay: 91, endDay: 365,
          title: '完成期',
          description: '6ヶ月〜1年で最終的な仕上がりになります。傷跡もほとんど目立たなくなります。',
          normalSymptoms: ['ほぼ完成形', '鼻先の微細な変化は続く'],
          tips: ['最終評価は術後1年で', '不満がある場合は修正手術の相談（最低6ヶ月以降）'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '大量の鼻出血（止まらない）',
          description: '術後の微量出血は正常ですが、ガーゼを頻繁に交換するほどの出血は異常です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '鼻先の皮膚が白く変色',
          description: 'プロテーゼやフィラーによる血行障害の可能性。壊死につながるため緊急受診が必要です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '高熱（38.5℃以上）',
          description: '感染症の徴候です。抗生剤の変更や追加処置が必要な場合があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: 'プロテーゼの飛び出し・移動感',
          description: 'プロテーゼがずれている、またはスキンを突き破りそうな場合は緊急です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '傷口の赤み・膿・異臭の増強',
          description: '感染の徴候です。早めの対処が必要です。',
          level: AlertLevel.danger,
          relevantAfterDay: 3,
        ),
        EmergencyAlert(
          symptom: '2週間以上腫れが一向に引かない',
          description: '通常の経過から外れている可能性があります。',
          level: AlertLevel.warning,
          relevantAfterDay: 14,
        ),
      ],
    ),

    // ===== 脂肪吸引 =====
    SurgeryCategory.liposuction: SurgeryGuide(
      category: SurgeryCategory.liposuction,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 3,
          title: '急性期',
          description: '広範囲の腫れ・内出血。圧迫ガードルの着用が必須です。',
          normalSymptoms: ['広範囲の内出血', '強い腫れ', '施術部位の痛み', '浸出液の滲み出し', '発熱（37.5℃程度）'],
          tips: ['圧迫ガードルは24時間着用', '水分を十分に摂取', '無理に動かず安静に', '処方された痛み止めを使用'],
        ),
        DowntimePhase(
          startDay: 4, endDay: 14,
          title: '拘縮前期',
          description: '内出血が変色しながら吸収されます。硬縮（こうしゅく）が始まることがあります。',
          normalSymptoms: ['内出血の色変化（紫→黄色）', '皮膚のつっぱり感', '硬縮の始まり', 'でこぼこ感'],
          tips: ['インディバ等のアフターケア開始（医師指示後）', '軽いストレッチ', 'ガードル継続着用', 'マッサージ（医師許可後）'],
        ),
        DowntimePhase(
          startDay: 15, endDay: 90,
          title: '拘縮期',
          description: '皮膚が硬くなり、つっぱり感が強くなります。これは正常な治癒過程です。',
          normalSymptoms: ['皮膚の硬さ', 'つっぱり感', 'しびれ・感覚鈍麻', 'むくみ（特に夕方）'],
          tips: ['セルフマッサージを継続', '適度な運動を再開', '水分摂取を心がける'],
        ),
        DowntimePhase(
          startDay: 91, endDay: 180,
          title: '完成期',
          description: '3〜6ヶ月で拘縮が解消され、最終的なボディラインが現れます。',
          normalSymptoms: ['軽い感覚異常の残存', '形状の最終安定'],
          tips: ['体重管理を開始', '最終評価は6ヶ月後'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '息切れ・胸の痛み',
          description: '脂肪塞栓症や肺血栓塞栓症の可能性があり、命に関わります。すぐに救急へ。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '38.5℃以上の高熱が続く',
          description: '感染症の徴候です。広範囲の施術では特にリスクが高いです。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '施術部位の急激な発赤・熱感の拡大',
          description: '蜂窩織炎など重篤な感染の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '下肢の片側だけの腫れ・痛み',
          description: '深部静脈血栓症（DVT）の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '出血が止まらない',
          description: 'ドレーン孔や傷口からの持続出血は処置が必要です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '皮膚の壊死（黒色変化）',
          description: '皮膚の色が黒く変化している場合は壊死の可能性があります。',
          level: AlertLevel.danger,
          relevantAfterDay: 3,
        ),
      ],
    ),

    // ===== 輪郭 =====
    SurgeryCategory.faceContour: SurgeryGuide(
      category: SurgeryCategory.faceContour,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 3,
          title: '急性腫脹期',
          description: '顔全体が大きく腫れます。フェイスバンドで圧迫固定。食事はストローや流動食。',
          normalSymptoms: ['顔全体の著しい腫れ', '広範囲の内出血', '口が開きにくい', '強いしびれ（神経の一時的影響）', '軽い発熱'],
          tips: ['フェイスバンドの継続装着', '流動食〜柔らかい食事', '口腔内の清潔を保つ（うがい薬使用）', 'アイシングで腫れを軽減'],
        ),
        DowntimePhase(
          startDay: 4, endDay: 14,
          title: '腫脹軽減期',
          description: '腫れが徐々に引きます。まだ人前に出るのは厳しい時期です。',
          normalSymptoms: ['腫れの軽減', '内出血の色変化', '口の開き改善', '感覚の徐々な回復'],
          tips: ['柔らかい食事を継続', '歯磨きは優しく', '激しい運動は禁止', 'フェイスバンドは就寝時着用'],
        ),
        DowntimePhase(
          startDay: 15, endDay: 90,
          title: '回復期',
          description: '社会復帰可能。まだ軽い腫れやしびれが残りますが、輪郭の変化が分かってきます。',
          normalSymptoms: ['軽いむくみ', '噛み合わせの違和感', 'しびれの残存', '顔の左右差（腫れによる）'],
          tips: ['硬いものを噛むのは控える', '歯科検診を受ける', '定期検診を忘れずに'],
        ),
        DowntimePhase(
          startDay: 91, endDay: 365,
          title: '完成期',
          description: '6ヶ月〜1年で最終的な輪郭に落ち着きます。骨の剛性が安定します。',
          normalSymptoms: ['微細なむくみ', 'しびれの残存（部分的に永続する場合も）'],
          tips: ['顔面への強い衝撃を避ける', '最終評価は1年後'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '呼吸困難・気道閉塞感',
          description: '腫脹による気道圧迫の可能性があります。すぐに救急へ。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '大量出血（口腔内・傷口から）',
          description: '骨切り部位からの出血は処置が必要です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '急激な片側の腫脹増大',
          description: '血腫形成の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '高熱が続く',
          description: '骨髄炎や深部感染の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '噛み合わせの著しい異常',
          description: '骨片の移動や固定具のトラブルの可能性があります。',
          level: AlertLevel.warning,
          relevantAfterDay: 7,
        ),
        EmergencyAlert(
          symptom: '3ヶ月以上経ってもしびれが全く改善しない',
          description: '神経損傷の評価が必要な場合があります。',
          level: AlertLevel.warning,
          relevantAfterDay: 90,
        ),
      ],
    ),

    // ===== 豊胸 =====
    SurgeryCategory.breast: SurgeryGuide(
      category: SurgeryCategory.breast,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 7,
          title: '急性期',
          description: 'バストバンドで圧迫固定。腫れと痛みが強い時期です。',
          normalSymptoms: ['バストの腫れ・硬さ', '胸部の痛み', '腕が上げにくい', '内出血', '微熱'],
          tips: ['バストバンドを指示通り着用', '腕を高く上げない', '安静にする', '処方薬を服用'],
        ),
        DowntimePhase(
          startDay: 8, endDay: 30,
          title: '回復初期',
          description: '痛みが軽減し、日常生活に戻れます。バッグの位置が安定してきます。',
          normalSymptoms: ['バストの硬さ', '位置が高い（徐々に下がる）', '感覚の変化', 'つっぱり感'],
          tips: ['ワイヤー入りブラはまだ避ける', 'マッサージ（医師指示後から）', '軽い運動は可能'],
        ),
        DowntimePhase(
          startDay: 31, endDay: 180,
          title: '安定・完成期',
          description: '3〜6ヶ月でバッグが自然な位置に落ち着き、柔らかくなります。',
          normalSymptoms: ['徐々な柔軟性の回復', '位置の安定', '傷跡の薄れ'],
          tips: ['定期検診を忘れずに', 'マンモグラフィ時はインプラントの旨を伝える'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '片側だけの急激な腫大・痛み',
          description: '血腫や漿液腫の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '高熱と傷口周囲の発赤拡大',
          description: '感染症の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: 'バッグの破損感（急な変形）',
          description: 'インプラント破損の可能性。MRI検査が必要です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '被膜拘縮（バストが硬く丸くなる）',
          description: '被膜拘縮のグレードによっては再手術が必要です。',
          level: AlertLevel.warning,
          relevantAfterDay: 30,
        ),
      ],
    ),

    // ===== 注入系 =====
    SurgeryCategory.filler: SurgeryGuide(
      category: SurgeryCategory.filler,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 1,
          title: '注入直後',
          description: '注入部位の腫れ・赤み。ボトックスは効果発現まで3-7日かかります。',
          normalSymptoms: ['注入部位の軽い腫れ', '赤み・発赤', '針跡', '軽い痛み・圧痛'],
          tips: ['注入部位を強くマッサージしない', 'サウナ・激しい運動は避ける', 'メイクは翌日から', '飲酒は控える'],
        ),
        DowntimePhase(
          startDay: 2, endDay: 7,
          title: '安定期',
          description: 'ヒアルロン酸は馴染み、ボトックスは効果が出始めます。',
          normalSymptoms: ['軽い腫れの残存', 'ボトックス：効果の発現', '内出血があれば色の変化'],
          tips: ['フェイシャルエステは1週間後から', '歯科治療は2週間以降に'],
        ),
        DowntimePhase(
          startDay: 8, endDay: 30,
          title: '完成期',
          description: '最終的な仕上がりが確認できます。ボトックスのピークは2-4週間後。',
          normalSymptoms: ['完成形に近い状態'],
          tips: ['持続期間はヒアルロン酸6-18ヶ月、ボトックス3-6ヶ月が目安', '追加注入は医師と相談'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '注入部位の皮膚が白く変色',
          description: '血管閉塞（バスキュラー・コンプロマイズ）の可能性があり、壊死や失明に繋がります。超緊急です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '急激な視力低下・目の痛み',
          description: 'ヒアルロン酸による網膜血管閉塞の可能性。失明リスクがありすぐに受診。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '注入部位の強い痛み・広範囲の赤み',
          description: '感染や血管障害の初期症状の可能性。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '注入部位のしこり・不自然な硬さ',
          description: '遅延型アレルギーや肉芽腫の可能性があります。',
          level: AlertLevel.warning,
          relevantAfterDay: 14,
        ),
      ],
    ),

    // ===== レーザー =====
    SurgeryCategory.skinLaser: SurgeryGuide(
      category: SurgeryCategory.skinLaser,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 2,
          title: '施術直後',
          description: '赤み・ヒリヒリ感が出ます。治療の種類で程度が大きく異なります。',
          normalSymptoms: ['赤み・発赤', 'ヒリヒリ感（日焼けのような感覚）', '軽い腫れ', 'かさぶた形成（スポット照射の場合）'],
          tips: ['保湿を十分に', '日焼け止め必須（SPF50推奨）', 'スキンケアはマイルドなものに', '飲酒・サウナは控える'],
        ),
        DowntimePhase(
          startDay: 3, endDay: 7,
          title: '皮膚再生期',
          description: 'かさぶたが取れ、新しい皮膚が現れます。この時期が最も敏感です。',
          normalSymptoms: ['皮剥け・かさぶた脱落', '一時的な色素沈着（PIH）', '乾燥', '軽いかゆみ'],
          tips: ['かさぶたを無理に剥がさない', '保湿を継続', '紫外線を徹底的に避ける', '低刺激の化粧品を使用'],
        ),
        DowntimePhase(
          startDay: 8, endDay: 90,
          title: '回復期',
          description: '肌質の改善が徐々に現れます。戻りジミ（PIH）が出る場合があります。',
          normalSymptoms: ['肌のトーンアップ', '一時的な色素沈着（戻りジミ）', '肌質の改善'],
          tips: ['紫外線対策を3ヶ月は継続', '戻りジミは自然に消えることが多い', 'ハイドロキノン等は医師の指示で'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '水疱・やけどのような症状',
          description: 'レーザーの過剰照射による熱傷の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '傷口の感染徴候（膿・発赤の拡大）',
          description: 'ダーマペン等の施術後は感染リスクがあります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '急激な色素脱失（白抜け）',
          description: 'レーザーによるメラノサイト損傷の可能性があります。',
          level: AlertLevel.warning,
          relevantAfterDay: 7,
        ),
        EmergencyAlert(
          symptom: '瘢痕・ケロイドの形成',
          description: '治癒の異常です。早めの対処が必要です。',
          level: AlertLevel.warning,
          relevantAfterDay: 14,
        ),
      ],
    ),

    // ===== スキンケア =====
    SurgeryCategory.skinCare: SurgeryGuide(
      category: SurgeryCategory.skinCare,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 1,
          title: '施術当日',
          description: '施術の種類により赤み・ピリつきの程度が異なります。',
          normalSymptoms: ['赤み', '軽いピリピリ感', '一時的な乾燥'],
          tips: ['保湿を十分に', '日焼け止めを塗る', '刺激の強い化粧品は避ける'],
        ),
        DowntimePhase(
          startDay: 2, endDay: 7,
          title: '回復期',
          description: '肌のターンオーバーが促進され、皮剥けが起こる場合があります。',
          normalSymptoms: ['皮剥け', '軽い乾燥', '一時的な肌荒れ感'],
          tips: ['保湿を継続', '紫外線対策', '触りすぎない'],
        ),
        DowntimePhase(
          startDay: 8, endDay: 30,
          title: '効果実感期',
          description: '肌のハリ・透明感が出てきます。',
          normalSymptoms: ['肌質の改善'],
          tips: ['効果維持のため定期的な施術を検討'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: 'アレルギー反応（全身の蕁麻疹・呼吸困難）',
          description: '注入系や薬剤使用の施術でアレルギー反応が出る場合があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '施術部位の感染徴候',
          description: '水光注射等は針を使うため感染リスクがあります。',
          level: AlertLevel.danger,
        ),
      ],
    ),

    // ===== 毛髪・脱毛 =====
    SurgeryCategory.hair: SurgeryGuide(
      category: SurgeryCategory.hair,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 2,
          title: '施術直後',
          description: '脱毛は赤み程度。植毛は移植部の腫れ・かさぶたが出ます。',
          normalSymptoms: ['赤み・腫れ', 'かさぶた（植毛の場合）', '軽い痛み', '施術部の違和感'],
          tips: ['施術部位を触らない', '入浴は翌日から（医師指示に従う）', '激しい運動は避ける'],
        ),
        DowntimePhase(
          startDay: 3, endDay: 14,
          title: '初期回復',
          description: '脱毛の赤みは数日で消失。植毛はかさぶたが取れ始めます。',
          normalSymptoms: ['脱毛後の毛の脱落（ショックロス：植毛）', 'かさぶた脱落', '軽いかゆみ'],
          tips: ['シャンプーは優しく', '直射日光を避ける', 'かさぶたは無理に取らない'],
        ),
        DowntimePhase(
          startDay: 15, endDay: 180,
          title: '生着・効果確認期',
          description: '植毛は3-6ヶ月で新しい毛が生え始めます。脱毛は次回施術を待ちます。',
          normalSymptoms: ['植毛毛の一時的脱落後の再成長', '脱毛効果の安定'],
          tips: ['植毛の最終評価は12ヶ月後', '脱毛は定期施術を継続'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '移植部の感染徴候（膿・高熱）',
          description: '植毛部位の感染は毛根の生着に影響します。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: 'やけど・水疱（レーザー脱毛後）',
          description: '出力過多や日焼け肌への照射による熱傷の可能性。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '広範囲の色素変化',
          description: '脱毛後の異常な色素沈着や脱失は受診が必要です。',
          level: AlertLevel.warning,
          relevantAfterDay: 7,
        ),
      ],
    ),

    // ===== 歯科審美 =====
    SurgeryCategory.dental: SurgeryGuide(
      category: SurgeryCategory.dental,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 3,
          title: '施術直後',
          description: '知覚過敏や歯茎の腫れが出る場合があります。',
          normalSymptoms: ['歯の知覚過敏', '歯茎の腫れ・出血', '違和感', '軽い痛み（矯正の場合）'],
          tips: ['柔らかい食事', '冷たい/熱いものは控える', '処方された鎮痛剤を使用', '歯磨きは優しく'],
        ),
        DowntimePhase(
          startDay: 4, endDay: 14,
          title: '適応期',
          description: '新しい歯や矯正器具に口腔内が慣れていきます。',
          normalSymptoms: ['違和感の軽減', '噛み合わせの変化', '歯茎の回復'],
          tips: ['口腔清掃を丁寧に', '硬すぎる食べ物は避ける'],
        ),
        DowntimePhase(
          startDay: 15, endDay: 90,
          title: '安定期',
          description: '治療結果が安定します。矯正は長期治療のため毎月の調整が必要です。',
          normalSymptoms: ['完全な適応'],
          tips: ['定期メンテナンスを継続', '矯正は指示通りの装着時間を守る'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '激しい歯痛・歯茎の腫脹',
          description: '歯髄炎や歯根感染の可能性があります。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: 'セラミックの破損・脱落',
          description: '早めの修復が必要です。仮歯の破損も放置しないでください。',
          level: AlertLevel.warning,
        ),
        EmergencyAlert(
          symptom: '歯茎からの持続的な出血・膿',
          description: '感染の可能性があります。',
          level: AlertLevel.danger,
        ),
      ],
    ),

    // ===== その他 =====
    SurgeryCategory.other: SurgeryGuide(
      category: SurgeryCategory.other,
      phases: const [
        DowntimePhase(
          startDay: 0, endDay: 3,
          title: '急性期',
          description: '施術の種類により経過は大きく異なります。担当医の指示に従ってください。',
          normalSymptoms: ['腫れ', '痛み', '内出血'],
          tips: ['処方薬を指示通りに服用', '安静にする', '傷口を清潔に保つ'],
        ),
        DowntimePhase(
          startDay: 4, endDay: 14,
          title: '回復初期',
          description: '症状が軽減していきます。',
          normalSymptoms: ['腫れの軽減', '痛みの軽減'],
          tips: ['担当医の指示に従う', '無理をしない'],
        ),
        DowntimePhase(
          startDay: 15, endDay: 90,
          title: '回復〜完成期',
          description: '最終的な結果が見えてきます。',
          normalSymptoms: ['安定化'],
          tips: ['定期検診を受ける'],
        ),
      ],
      alerts: const [
        EmergencyAlert(
          symptom: '高熱・感染徴候',
          description: '38.5℃以上の発熱、傷口の膿・異臭がある場合は受診してください。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '大量出血',
          description: '止血できない出血は緊急受診が必要です。',
          level: AlertLevel.danger,
        ),
        EmergencyAlert(
          symptom: '予期しない激しい痛み',
          description: '日に日に痛みが増す場合は合併症の可能性があります。',
          level: AlertLevel.warning,
        ),
      ],
    ),
  };

  /// カテゴリからガイドを取得
  static SurgeryGuide getGuide(SurgeryCategory category) {
    return guides[category] ?? guides[SurgeryCategory.other]!;
  }
}
