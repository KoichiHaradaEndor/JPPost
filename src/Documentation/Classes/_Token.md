# JPPost._Token クラス

## 説明

`_Token` クラスを使用して、[郵便番号・デジタルアドレス for Biz](https://lp-api.da.pf.japanpost.jp/) でAPIを使用するために必要な `token` を取得します。

`_Token` クラスは共有シングルトンクラスです。`token` はすべてのプロセスで共有して使用するためです。

## コンストラクタ

### cs.JPPost.Token.me

```4d
var $tokenClass_o : cs.JPPost._Token
$tokenClass_o:=cs.JPPost._Token.me
```

## 関数・プロパティ

<a id="claimToken"></a>

### .claimToken(): Object

本番環境で使用する `token` を取得します。

**注**

本関数は `shared` フラグが設定されているため `_Token` クラスの他の関数に対し排他的に実行されます。これは本関数が同時に呼び出されることで `token` 更新が同時に複数回行われることを防ぐためです。

以下のオブジェクトが返されます: 

#### 成功時

| 属性名 | 型 | 説明 |
|-------|----|------|
| success | Boolean | True |
| scope | Text | スコープ |
| tokenType | Text | トークンタイプ |
| expiresIn | Integer | 有効秒数 |
| token | Text | アクセストークン |

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

**Note:** 

- `token` がすでに取得済みで有効期限まで30秒以上ある場合は取得済みの `token` が返されます。そうでなければ、つまり `token` が未取得あるいは有効期限まで30秒未満の場合は `token` の再取得をリクエストします。

```4d
var $result_o: Object
var $token_t: Text
$result_o:=cs.JPPost._Token.me.claimToken()
If($result_o.success=True)
  $token_t:=$result_o.token
End if
```

### .claimTokenForTest({clientIp: Text}): Object

テスト環境で使用する `token` を取得します。

詳細は [claimToken](#claimToken) の説明を参照してください。
