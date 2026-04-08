# JPPost.SearchCode クラス

## 説明

`SearchCode` クラスは[郵便番号・デジタルアドレス for Biz](https://lp-api.da.pf.japanpost.jp/)の `searchcode` APIを呼び出し、郵便番号やデジタルアドレスから住所情報を検索します。

`SearchCode` クラスはシングルトンクラスです。

**注**

本コンポーネントに含まれる関数はWebサーバーやサーバーアプリ上で使用します。郵便番号・デジタルアドレスAPIではアプリケーションごとにIDを発行し、API利用時にそのIDを使用して認証を行うためです。また認証後に発行される `token` は短時間で有効期限が切れるため頻繁に `token` の再発行をリクエストする必要がありますが、例えば各クライアントでこれを行うことで発生するかもしれない、クライアントAがリクエストした `token` が直後クライアントBによって差し替えられるという状態を防ぐ必要があるためです。

## コンストラクタ

### cs.JPPost.SearchCode.me

```4d
var $searchCode_o : cs.JPPost.SearchCode
$searchCode_o:=cs.JPPost.SearchCode.me
```

## 関数・プロパティ

<a id="fetch"></a>

### .fetch(searchCode: Text{; searchOption: Object}): Object

住所を検索します。

`searchCode` には検索キーとなる英数字を渡します。郵便番号は数字のみ3桁以上7桁まで、デジタルアドレスは英数字7桁です。それ以外の場合はエラーとなります。

オプションの引数 `searchOption` には以下の属性と値を渡すことができます：

| 属性名 | 型 | 説明 |
|-------|----|------|
| page | Integer | ページ番号 (デフォルト値:1) |
| limit | Integer | 取得する最大レコード数 (デフォルト値:1000、最大値:1000) |
| choikitype | Integer | 返却する町域フィールド (指定がない場合はchoikitype=1とみなす)<br>1:括弧なし<br>2:括弧あり |
| searchtype | Integer | 検索対象 (指定がない場合はsearchtype=1とみなす)<br>1:郵便番号、事業所個別郵便番号、デジタルアドレスを検索<br>2:郵便番号、デジタルアドレスを検索 |

以下のオブジェクトが返されます: 

#### 成功時

| 属性名 | 型 | 説明 |
|-------|----|------|
| success | Boolean | True |
| page | Integer | ページ数 |
| limit | Integer | 取得最大レコード数 |
| count | Integer | 該当データ数 |
| searchtype | Text | 検索タイプ (dgacode/zipcode/bizzipcodeのいずれか) |
| addresses | Collection | 住所リスト |

`addresses` は以下のオブジェクトのコレクションです（常にすべての属性が含まれるわけではありません）：

| 属性名 | 型 | 説明 |
|-------|----|------|
| dgacode | Text | デジタルアドレスコード |
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
| biz_name | Text | 事業所名 |
| biz_kana | Text | 事業所名カナ |
| biz_roma | Text | 事業所名ローマ字 |
| block_name | Text | 番地等文字列 |
| other_name | Text | その他住所文字列 |
| corporate_number | Text | 法人番号 |
| business_name | Text | 企業名 |
| business_name_kana | Text | 企業名カナ |
| tel_number | Text | 電話番号 |
| url | Text | 企業HPのURL |
| address | Text | 登録住所 |
| longitude | Real | 経度 |
| latitude | Real | 緯度 |

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
$result_o:=cs.JPPost.SearchCode.me.fetch("0000000")
```

### .fetchForTest(searchCode: Text{; searchOption: Object}): Object

テスト環境で住所を検索します。

詳細は [fetch](#fetch) の説明を参照してください。
