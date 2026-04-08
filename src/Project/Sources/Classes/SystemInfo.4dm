/**
* 郵便番号・デジタルアドレス for Biz APIを使用するにあたり必要となるシステム情報を格納するクラス
*/

// 本番
property _hostName : Text  // ホスト名
property _clientId : Text  // クライアントID
property _secretKey : Text  // シークレットキー

// テスト用
property _hostNameForTest : Text  // ホスト名
property _clientIdForTest : Text  // クライアントID
property _secretKeyForTest : Text  // シークレットキー

// バージョン情報
property _apiVersion : Text  // API バージョン　(v2 など)

shared singleton Class constructor
	
	This:C1470._apiVersion:="v2"
	
shared Function setParameter($paramName_t : Text; $value_v : Variant)
	
	This:C1470[$paramName_t]:=$value_v
	
Function getParameter($paramName_t : Text) : Variant
	
	return This:C1470[$paramName_t]
	