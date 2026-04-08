/**
* 郵便番号・デジタルアドレス for Biz の token APIを処理するクラス
*/

// APIから返却されるデータ
property _scope : Text  // スコープ
property _tokenType : Text  // トークンタイプ
property _expiresIn : Integer  // 有効秒数
property _token : Text  // アクセストークン
property _expiresAt : Real  // 有効期限Unix Time

shared singleton Class constructor
	
shared Function claimToken() : Object
	
	return This:C1470._claimToken(JPPost Production Mode)
	
shared Function claimTokenForTest() : Object
	
	return This:C1470._claimToken(JPPost Test Mode)
	
Function _claimToken($mode_t : Text) : Object
	
/**
* 戻り値オブジェクトの構造
* 成功時
* {
*    success: True
*    scope: スコープ
*    tokenType: トークンタイプ
*    expiresIn: 有効秒数
*    token: アクセストークン
* }
* サーバーからエラーが返された場合
* {
*    success: False
*    errCode: APIが返すエラーコード
*    message: APIが返すエラーメッセージ
*    status: HTTPレスポンスステータスコード
*    requestId: APIが返す問合せID (追跡コード)
* }
* 実行時エラー
* {
*    success: False
*    errors: エラースタックコレクション
* }
*/
	
	var $result_o : Object
	var $currentUnixTime_r; $refreshRemaining_r : Real
	
	$refreshRemaining_r:=30  // 有効期限までこの秒数未満になったらtoken再取得
	
	Try
		
		$currentUnixTime_r:=cs:C1710._Utility.me.unixTime()
		Case of 
			: (This:C1470._token=Null:C1517) || (This:C1470._expiresAt=Null:C1517)
			: (This:C1470._expiresAt-$currentUnixTime_r<$refreshRemaining_r)
			Else 
				return {success: True:C214; scope: This:C1470._scope; tokenType: This:C1470._tokenType; expiresIn: This:C1470._expiresIn; token: This:C1470._token}
		End case 
		
		$result_o:=This:C1470._fetch($mode_t)
		If ($result_o.success=False:C215)
			return $result_o
		End if 
		
		return {success: True:C214; scope: This:C1470._scope; tokenType: This:C1470._tokenType; expiresIn: This:C1470._expiresIn; token: This:C1470._token}
		
	Catch
		return {success: False:C215; errors: Last errors:C1799}
	End try
	
Function _fetch($mode_t : Text) : Object
	
/**
* 戻り値オブジェクトの構造
* 成功時
* {
*    success: True
* }
* サーバーからエラーが返された場合
* {
*    success: False
*    errCode: APIが返すエラーコード
*    message: APIが返すエラーメッセージ
*    status: HTTPレスポンスステータスコード
*    requestId: APIが返す問合せID (追跡コード)
* }
*/
	
	var $payload_o; $options_o : Object
	var $response_o; $result_o : Object
	var $jwt_o : Object
	var $clientIp_t; $url_t; $grantType_t; $clientId_t; $secretKey_t : Text
	var $waitSec_l : Integer:=5
	var $path_t : Text:="/j/token"
	
	var $url_o : cs:C1710.WebAPI.URL
	var $headers_o : cs:C1710.WebAPI.Headers
	var $httpRequest_o : cs:C1710.WebAPI.HTTPRequest
	var $sysInfo_o : cs:C1710.SystemInfo:=cs:C1710.SystemInfo.me
	
	If ($sysInfo_o._apiVersion="v2")
		
		Case of 
			: ($mode_t=JPPost Production Mode)
				$url_t:="https://"+$sysInfo_o._hostName+"/api/"+$sysInfo_o._apiVersion+$path_t
				$grantType_t:="client_credentials"
				$clientId_t:=$sysInfo_o._clientId
				$secretKey_t:=$sysInfo_o._secretKey
			: ($mode_t=JPPost Test Mode)
				$url_t:="https://"+$sysInfo_o._hostNameForTest+"/api/"+$sysInfo_o._apiVersion+$path_t
				$grantType_t:="client_credentials"
				$clientId_t:=$sysInfo_o._clientIdForTest
				$secretKey_t:=$sysInfo_o._secretKeyForTest
			Else 
				throw:C1805({message: "mode 引数の値が無効です。"})
		End case 
		
		// URL
		$url_o:=cs:C1710.WebAPI.URL.new($url_t)
		
		// Headers
		$clientIp_t:=(Session:C1714.info#Null:C1517 && Session:C1714.info.IPAddress#Null:C1517) ? Session:C1714.info.IPAddress : "127.0.00.1"
		$headers_o:=cs:C1710.WebAPI.Headers.new()
		$headers_o.append("Content-Type"; "application/json")
		$headers_o.append("X-Forwarded-For"; $clientIp_t)
		
		// Payload
		$payload_o:={\
			grant_type: $grantType_t; \
			client_id: $clientId_t; \
			secret_key: $secretKey_t\
			}
		
		// Options
		$options_o:={\
			method: HTTP POST method:K71:2; \
			headers: $headers_o; \
			body: $payload_o\
			}
		
		$httpRequest_o:=cs:C1710.WebAPI.HTTPRequest.new()
		$response_o:=$httpRequest_o.fetch($url_o; $options_o; $waitSec_l)
		
		Case of 
			: ($response_o=Null:C1517) || ($response_o.status=Null:C1517)
				throw:C1805({message: "未知のエラーが発生しました。"})
			: ($response_o.status#200)
				$result_o:={success: False:C215; status: $response_o.status; errCode: $response_o.body.error_code; message: $response_o.body.message; requestId: $response_o.body.request_id}
			Else 
				
				$jwt_o:=cs:C1710.NetKit.JWT.new().decode($response_o.body.token)
				
				This:C1470._token:=$response_o.body.token
				This:C1470._tokenType:=$response_o.body.token_type
				This:C1470._expiresIn:=$response_o.body.expires_in
				This:C1470._scope:=$response_o.body.scope
				This:C1470._expiresAt:=$jwt_o.payload.exp
				
				$result_o:={success: True:C214}
				
		End case 
		
		return $result_o
		
	End if 
	