# JPPost._Utility クラス

## 説明

`_Utility` クラスはシングルトンクラスです。

## コンストラクタ

### cs.JPPost._Utility.me

```4d
var $utilityClass_o : cs.JPPost._Utility
$utilityClass_o:=cs.JPPost._Utility.me
```

## 関数・プロパティ

### .unixTime({date: Date; time: Time}): Real

本メソッドを使用して、Unix時間を取得します。引数を渡さない場合は現在時刻をUnix時間に変換します。

`date` にはローカル日付を、`time` にはローカル時間を渡します。これらは `GMT` 時間に変換された後にUnix時間が計算されます。

```4d
var $unixTime_r : Real
$unixTime_r:=cs.JPPost._Utility.me.unixTime()
```

### .unixTimeToIsoDateGmt(unixTime: Real): Text

Unix時間を `yyyy-MM-ddTHH:mm:ssZ` 形式に変換します。

```4d
var $unixTime_r : Real
var $gmtDAteTime_t : Text
$gmtDAteTime_t:=cs.JPPost._Utility.me.unixTimeToIsoDateGmt($unixTime_r)
```

### .decodeJWT(jwt: Text): Object

JWT をデコードします。

`jwt` にはデコードする JWT 文字列を渡します。

戻り値は JWT がデコードされた内容を含むオブジェクトですが、以下の属性が追加されます：

| 属性名 | 説明 |
|:-----:|:-----|
|iat2|発行日時Unix時間をISO形式に変換した文字列|
|exp2|有効期限日時Unix時間をISO形式に変換した文字列|

```4d
var $content_o : Object
var $jwt_t : Text
$content_o:=cs.JPPost._Utility.me.decodeJWT($jwt_t)
```

### .JPtoEN(original: Text): Text

本メソッドは全角英数字（[0-9A-Za-z]）を半角に変換します。

```4d
var $zenkaku_t; $hankaku_t : Text
$hankaku_t:=cs.JPPost._Utility.me.JPtoEN($zenkaku_t)
```
