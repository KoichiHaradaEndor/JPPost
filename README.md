# JPPost

日本郵便株式会社が提供する郵便番号・デジタルアドレスAPIを利用するための4Dコンポーネントです。

本コンポーネントに含まれる関数はWebサーバーやサーバーアプリ上で使用します。郵便番号・デジタルアドレスAPIではアプリケーションごとにIDを発行し、API利用時にそのIDを使用して認証を行うためです。また認証後に発行される `token` は短時間で有効期限が切れるため頻繁に `token` の再発行をリクエストする必要がありますが、例えば各クライアントでこれを行うことで発生するかもしれない、クライアントAがリクエストした `token` が直後クライアントBによって差し替えられるという状態を防ぐ必要があるためです。

*現在テスト用APIは正しく動作しないようです。有効期限が切れたtokenが返されますし、検索APIをたたいても「tokenが不正です」エラーとなります。*

**初期設定**

```4d
var $systemInfo_o : cs.JPPost.SystemInfo
$systemInfo_o:=cs.JPPost.SystemInfo.me
$systemInfo_o.setParameter(JPPost Hostname; {APIホスト名})
$systemInfo_o.setParameter(JPPost Client ID; {あなたのクライアントID})
$systemInfo_o.setParameter(JPPost Secret Key; {あなたのクライアントシークレット})
```

**郵便番号から住所を検索**

```4d
var $result_o: Object
$result_o:=cs.JPPost.SearchCode.me.fetch("0000000")
```

**住所の一部から住所リストを検索**

```4d
var $result_o: Object
$result_o:=cs.JPPost.AddressZip.me.fetch({pref_name: "東京都"; city_name: "千代田区"})
```
