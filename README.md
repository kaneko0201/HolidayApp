# 作品

サイトURL
https://holiday-app-1-94ec011ee64f.herokuapp.com/homes/ask

# アプリについて
ユーザーが旅行やおでかけプランについて質問し、AIや検索結果から回答を得ることができます。ユーザーの気持ちを入力できるので回答のミスマッチが起こりにくくなるかと思います。

# 技術

フロントエンド
| 使用技術  | 詳細 |
| ------------- | ------------- |
| Bootstrap5  | Webサイトの見た目を簡単に整えるためのフレームワーク  |
| Geolocation API  | GPS、IPアドレス、無線LAN、WiFiなどから位置情報を取得  |

バックエンド
| 使用技術  | 詳細 |
| ------------- | ------------- |
| Rails7 (7.1.3)  | Webアプリ開発のためのフルスタックなフレームワーク  |
| Rspec  | リクエストスペック・モデルスペックのテストを実行  |

外部API
| 使用技術  | 詳細 |
| ------------- | ------------- |
| OpenAI API  | gpt-4o-miniによる旅行プラン生成  |
| Google Geocoding API  | 位置情報から住所を取得  |
| Google Custom Search API  | 関連する公式サイトの検索  |

デプロイ
| 使用技術  | 詳細 |
| ------------- | ------------- |
| Heroku  | アプリの開発・運用を効率的に行うためのクラウドプラットフォーム  |



### 全体設計

<img width="781" alt="スクリーンショット 2025-04-14 15 24 04" src="https://github.com/user-attachments/assets/b0aaa564-f664-43b5-9b63-689f091d167b" />

### 現在地機能
ワンクリックで今いる場所からすぐに出発したいときに便利

![202504151317-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/887b4848-7a71-411b-9028-367c6c46cc0d)

### おでかけプラン生成
入力内容を元に、OpenAIが以下のような内容を自動で生成します：

・日ごとの訪問先（観光地・温泉・アクティビティなど）

・各スポットの簡単な紹介

![202504151354-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/227e80e8-bc3f-4b65-9d5a-2cc547cf8a86)

### 関連サイトの表示
AIが提案するスポットに対して、Google検索結果から公式サイトリンクを自動取得。そのまま予約や下調べもスムーズ。

![202504151357-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/ff0ef278-7d35-4284-86f6-a7c6ed481f76)

### 開発にあたって
大学の4年間田んぼだらけの土地で生活、社会人1年目は離島でした。
外出したくても何がどこにあるのか調べるのに苦労しました。
このアプリは、過去の自分のように転勤が多い方や新しい土地に馴染めない方に向けて、休日の選択肢にプラス1できるように考えました。

### 使用したアイコンのサイト様

<a target="_blank" href="https://icons8.com/icon/PndQWK6M1Hjo/bootstrap">ブートストラップ</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

<a target="_blank" href="https://icons8.com/icon/DcygmpZqBEd9/google-maps">グーグルマップ-新しい</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

<a target="_blank" href="https://icons8.com/icon/kqJCAdWaGpOx/ruby-on-rails">Ruby on Rails</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

<a target="_blank" href="https://icons8.com/icon/48167/google-web-search">Googleウェブ検索</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

<a target="_blank" href="https://icons8.com/icon/31085/heroku">Heroku</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

<a target="_blank" href="https://icons8.com/icon/12599/github">GitHub</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>
