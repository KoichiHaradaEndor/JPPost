/**
* 郵便番号・デジタルアドレス for Biz の addresszip APIを処理するクラス
*/

singleton Class constructor
	
Function fetch($queryParams_o : Object) : Object
	
	return This:C1470._fetch(JPPost Production Mode; $queryParams_o)
	
Function fetchForTest($queryParams_o : Object) : Object
	
	return This:C1470._fetch(JPPost Test Mode; $queryParams_o)
	
Function _fetch($mode_t : Text; $queryParams_o : Object) : Object
	
/**
* 戻り値オブジェクトの構造
* 成功時
* {
*    success: True
*    page: ページ数 (デフォルト値:1)
*    limit: 取得最大レコード数 (デフォルト値:1000、最大値:1000)
*    count: 該当データ数
*    level: マッチングレベル
*        1: 都道府県レベルで一致
*        2: 市区町村レベルで一致
*        3: 町域レベルで一致
*    addresses: Address クラスオブジェクトのコレクション
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
	
	var $url_t : Text
	var $token_o; $options_o : Object
	var $response_o; $result_o : Object
	
	var $url_o : cs:C1710.WebAPI.URL
	var $headers_o : cs:C1710.WebAPI.Headers
	var $httpRequest_o : cs:C1710.WebAPI.HTTPRequest
	
	var $path_t : Text:="/addresszip"
	var $waitSec_l : Integer:=5
	var $sysInfo_o : cs:C1710.SystemInfo:=cs:C1710.SystemInfo.me
	var $tokenClass_o : cs:C1710._Token:=cs:C1710._Token.me
	
	If ($sysInfo_o._apiVersion="v2")
		
		Case of 
			: ($mode_t=JPPost Production Mode)
				$token_o:=$tokenClass_o.claimToken()
				$url_t:="https://"+$sysInfo_o._hostName+"/api/"+$sysInfo_o._apiVersion+$path_t
			: ($mode_t=JPPost Test Mode)
				$token_o:=$tokenClass_o.claimTokenForTest()
				$url_t:="https://"+$sysInfo_o._hostNameForTest+"/api/"+$sysInfo_o._apiVersion+$path_t
			Else 
				throw:C1805({message: "mode 引数の値が無効です。"})
		End case 
		
		If ($token_o.success=False:C215)
			return $token_o  // エラー情報が含まれている
		End if 
		
		// URL
		$url_o:=cs:C1710.WebAPI.URL.new($url_t)
		
		// Headers
		$headers_o:=cs:C1710.WebAPI.Headers.new()
		$headers_o.append("Authorization"; "Bearer  "+$token_o.token)
		$headers_o.append("Content-Type"; "application/json")
		
		// Options
		$options_o:={\
			method: HTTP POST method:K71:2; \
			headers: $headers_o; \
			body: $queryParams_o\
			}
		
		$httpRequest_o:=cs:C1710.WebAPI.HTTPRequest.new()
		$response_o:=$httpRequest_o.fetch($url_o; $options_o; $waitSec_l)
		
		Case of 
			: ($response_o=Null:C1517) || ($response_o.status=Null:C1517)
				throw:C1805({message: "未知のエラーが発生しました。"})
			: ($response_o.status#200)
				$result_o:={success: False:C215; status: $response_o.status; errCode: $response_o.body.error_code; message: $response_o.body.message; requestId: $response_o.body.request_id}
			Else 
				$result_o:=$response_o.body
				$result_o.success:=True:C214
		End case 
		
		return $result_o
		
	End if 
	