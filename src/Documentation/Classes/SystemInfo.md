# JPPost.SystemInfo クラス

## 説明

`SystemInfo` クラスを使用して、[郵便番号・デジタルアドレス for Biz](https://lp-api.da.pf.japanpost.jp/) APIを使用するために必要な設定を行います。このクラスを使用した設定は、他のクラスの使用よりも先に行わなければなりません。

`SystemInfo` クラスは共有シングルトンクラスです。

## コンストラクタ

### cs.JPPost.SystemInfo.me

```4d
var $systemInfoClass_o : cs.JPPost.SystemInfo
$systemInfoClass_o:=cs.JPPost.SystemInfo.me
```

## 関数・プロパティ

### .setParameter(name: Text; value: Variant)

本メソッドを使用して、APIの利用に必要なパラメターを設定します。

`name` には設定名を渡します。[JPPost](#constants) テーマの定数を渡すことができます。

`value` には `name` に対応する設定値を渡します。

以下は設定を行う設定名定数と値のリストです：

<a id="constants"></a>

#### 共通 (JPPost Common)

| 定数 | 設定必須 | パラメター値の型 | 値の説明 |
| :-------------------------------- | :-: | :-----: | :------------------- |
| JPPost Hostname                   |  o  | Text | APIの本番用ホスト名 |
| JPPost Hostname For Test          |  o<br>(テスト時)  | Text | APIのテスト用ホスト名 |
| JPPost API Version                |     | Text | APIのバージョン (例 : "v2")<br>初期値: "v2" |

<dl>
    <dt>ホスト名</dt>
    <dd>この設定は本コンポーネントの他のクラス関数利用前に行わなければなりません。本番用とテスト用それぞれ値が異なります。</dd>
    <dt>API Version について</dt>
    <dd>APIバージョンはエンドポイントURL中 "/api/" に続くバージョン部です。現在のデフォルトバージョン値は "v2" です。この値を変更することで、複数のAPIバージョンが公開されている場合に呼び出しAPIを切り替えることができます。</dd>
</dl>

#### Token 用パラメター (JPPost Token)

| 定数 | 設定必須 | パラメター値の型 | 値の説明 |
| :-------------------------------- | :-: | :-----: | :------------------- |
| JPPost Client ID                  |  o  | Text | APIの本番用クライアントID |
| JPPost Secret Key                 |  o  | Text | APIの本番用クライアントシークレット |
| JPPost Client ID For Test         |  o<br>(テスト時)  | Text | APIのテスト用クライアントID |
| JPPost Secret Key For Test        |  o<br>(テスト時)  | Text | APIのテスト用クライアントシークレット |

<dl>
    <dt>クライアントID・クライアントシークレット</dt>
    <dd>これらの設定は本コンポーネントの他のクラス関数利用前に行わなければなりません。本番用の値は郵便番号・デジタルアドレス for Biz APIのサイトへのアプリケーション登録時に発行されます。テスト用の値は郵便番号・デジタルアドレス for Biz APIサイトへのログイン後に見ることができるマニュアルに記載されています。本番用とテスト用それぞれ値が異なります。</dd>
</dl>

```4d
var $systemInfo_o : cs.JPPost.SystemInfo
$systemInfo_o:=cs.JPPost.SystemInfo.me

$systemInfo_o.setParameter(JPPost Hostname; "production.foo.bar.com")
$systemInfo_o.setParameter(JPPost Hostname For Test; "test.foo.bar.com")
$systemInfo_o.setParameter(JPPost API Version; "v2") // デフォルト値と異なるバージョンのAPIを使用する際に設定

$systemInfo_o.setParameter(JPPost Client ID; "abcdefg1234567890")
$systemInfo_o.setParameter(JPPost Secret Key; "abcdefg1234567890")
$systemInfo_o.setParameter(JPPost Client ID For Test; "1234567890abcdefg")
$systemInfo_o.setParameter(JPPost Secret Key For Test; "1234567890abcdefg")
```

### .getParameter(name: Text): Variant

APIの利用に必要なパラメターの現在値を取得できます。

`name` には設定名を渡します。[JPPost System Info](#k-systemInfo) テーマの定数を渡すことができます。

