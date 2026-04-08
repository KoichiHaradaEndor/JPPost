# JPPost.AddressZip クラス

## 説明

`AddressZip` クラスは[郵便番号・デジタルアドレス for Biz](https://lp-api.da.pf.japanpost.jp/)の `addresszip` APIを呼び出し、住所の一部から該当する住所を検索します。

`AddressZip` クラスはシングルトンクラスです。

**注**

本コンポーネントに含まれる関数はWebサーバーやサーバーアプリ上で使用します。郵便番号・デジタルアドレスAPIではアプリケーションごとにIDを発行し、API利用時にそのIDを使用して認証を行うためです。また認証後に発行される `token` は短時間で有効期限が切れるため頻繁に `token` の再発行をリクエストする必要がありますが、例えば各クライアントでこれを行うことで発生するかもしれない、クライアントAがリクエストした `token` が直後クライアントBによって差し替えられるという状態を防ぐ必要があるためです。

## コンストラクタ

### cs.JPPost.AddressZip.me

```4d
var $addresszip_o : cs.JPPost.AddressZip
$addresszip_o:=cs.JPPost.AddressZip.me
```

## 関数・プロパティ

<a id="fetch"></a>

### .fetch(queryParams: Object): Object

住所を検索します。

`queryParams` には検索キーとなる名前と検索条件のペアを渡します。以下の属性名と値を指定できます：

| 属性名 | 型 | 説明 |
|-------|----|------|
| pref_code | Text | 都道府県コード |
| pref_name | Text | 都道府県名 |
| pref_kana | Text | 都道府県名カナ |
| pref_roma | Text | 都道府県名ローマ字 |
| city_code | Text | 市区町村コード |
| city_name | Text | 市区町村名 |
| city_kana | Text | 市区町村名カナ |
| city_roma | Text | 市区町村名ローマ字 |
| town_name | Text | 町域 |
| town_kana | Text | 町域カナ |
| town_roma | Text | 町域ローマ字 |
| freeword | Text | フリーワード |
| flg_getcity | Integer | 市区町村一覧のみ取得フラグ<br>デフォルト値:0<br>0:すべての情報を取得<br>1:市区町村のみの情報を取得 |
| flg_getpref | Integer | 都道府県一覧のみ取得フラグ<br>デフォルト値:0<br>0:すべての情報を取得<br>1:都道府県のみの情報を取得 |
| page | Integer | ページ数 (デフォルト値:1) |
| limit | Integer | 取得最大レコード数 (デフォルト値:1000、最大値:1000) |

- pref_codeとpref_nameが両方リクエストされた場合は、pref_codeが優先される
- city_codeとcity_nameが両方リクエストされた場合は、city_codeが優先される

以下のオブジェクトが返されます: 

#### 成功時

| 属性名 | 型 | 説明 |
|-------|----|------|
| success | Boolean | True |
| page | Integer | ページ数 |
| limit | Integer | 取得最大レコード数 |
| count | Integer | 該当データ数 |
| level | Integer | マッチングレベル<br>1: 都道府県レベルで一致<br>2: 市区町村レベルで一致<br>3: 町域レベルで一致 |
| addresses | Collection | 住所リスト |

`addresses` は以下のオブジェクトのコレクションです（常にすべての属性が含まれるわけではありません）：

| 属性名 | 型 | 説明 |
|-------|----|------|
| zip_code | Text | 郵便番号 |
| pref_code | Text | 都道府県コード |
| pref_name | Text | 都道府県名 |
| pref_kana | Text | 都道府県名カナ |
| pref_roma | Text | 都道府県名ローマ字 |
| city_code | Text | 市区町村コード |
| city_name | Text | 市区町村名 |
| city_kana | Text | 市区町村名カナ |
| city_roma | Text | 市区町村名ローマ字 |
| town_name | Text | 町域 |
| town_kana | Text | 町域カナ |
| town_roma | Text | 町域ローマ字 |

#### APIサーバーからエラーが返された場合

| 属性名 | 型 | 説明 |
|-------|----|------|
| success | Boolean | False |
| errCode | Text | APIが返すエラーコード |
| message | Text | APIが返すエラーメッセージ |
| status | Integer | HTTPレスポンスステータスコード |
| requestId | Text | 問合せID (追跡コード) |

#### 実行時エラー

| 属性名 | 型 | 説明 |
|-------|----|------|
| success | Boolean | False |
| errors | Collection | エラースタックコレクション |

```4d
var $result_o: Object
$result_o:=cs.JPPost.AddressZip.me.fetch("0000000")
```

### .fetchForTest(queryParams: Object): Object

テスト環境で住所を検索します。

詳細は [fetch](#fetch) の説明を参照してください。
