/**
* 郵便番号・デジタルアドレス for Biz の searchcode APIを処理するクラス
*/

singleton Class constructor
	
Function fetch($searchCode_t : Text; $searchOption_o : Object) : Object
	
	return This:C1470._fetch(JPPost Production Mode; $searchCode_t; $searchOption_o)
	
Function fetchForTest($searchCode_t : Text; $searchOption_o : Object) : Object
	
	return This:C1470._fetch(JPPost Test Mode; $searchCode_t; $searchOption_o)
	
Function _fetch($mode_t : Text; $searchCode_t : Text; $searchOption_o : Object) : Object
	
/**
* 戻り値オブジェクトの構造
* 成功時
* {
*    success: True
*    page: ページ数 (デフォルト値:1)
*    limit: 取得最大レコード数 (デフォルト値:1000、最大値:1000)
*    count: 該当データ数
*    searchType: 検索タイプ (dgacode/zipcode/bizzipcodeのいずれか)
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
	var $searchOptionAtts_c : Collection
	var $searchOptionAtt_t : Text
	
	var $url_o : cs:C1710.WebAPI.URL
	var $urlSearchParams_o : cs:C1710.WebAPI.URLSearchParams
	var $headers_o : cs:C1710.WebAPI.Headers
	var $httpRequest_o : cs:C1710.WebAPI.HTTPRequest
	
	var $path_t : Text:="/searchcode"
	var $waitSec_l : Integer:=5
	var $sysInfo_o : cs:C1710.SystemInfo:=cs:C1710.SystemInfo.me
	var $tokenClass_o : cs:C1710._Token:=cs:C1710._Token.me
	
	// 全角を半角に、小文字を大文字に変換
	$searchCode_t:=cs:C1710._Utility.me.JPtoEN($searchCode_t)
	$searchCode_t:=Replace string:C233($searchCode_t; "-"; "")
	$searchCode_t:=Uppercase:C13($searchCode_t)
	Case of 
		: (Match regex:C1019("^[0-9]{3,7}$"; $searchCode_t; 1))
			// 数字のみ3-7桁ならOK
		: (Match regex:C1019("^[0-9A-Z]{7}$"; $searchCode_t; 1))
			// 英数字7桁ならOK
		Else 
			throw:C1805({message: "searchCode 引数は数字のみ3-7桁、または英数字7桁でなければなりません。"})
	End case 
	
	If ($sysInfo_o._apiVersion="v2")
		
		Case of 
			: ($mode_t=JPPost Production Mode)
				$token_o:=$tokenClass_o.claimToken()
				$url_t:="https://"+$sysInfo_o._hostName+"/api/"+$sysInfo_o._apiVersion+$path_t+"/"+$searchCode_t
			: ($mode_t=JPPost Test Mode)
				$token_o:=$tokenClass_o.claimTokenForTest()
				$url_t:="https://"+$sysInfo_o._hostNameForTest+"/api/"+$sysInfo_o._apiVersion+$path_t+"/"+$searchCode_t
			Else 
				throw:C1805({message: "mode 引数の値が無効です。"})
		End case 
		
		If ($token_o.success=False:C215)
			return $token_o  // エラー情報が含まれている
		End if 
		
		// URL
		$url_o:=cs:C1710.WebAPI.URL.new($url_t)
		
		// 検索オプションが指定されていれば
		If ($searchOption_o#Null:C1517)
			
			$searchOptionAtts_c:=["page"; "limit"; "choikitype"; "searchtype"]
			$urlSearchParams_o:=cs:C1710.WebAPI.URLSearchParams.new()
			For each ($searchOptionAtt_t; $searchOptionAtts_c)
				If ($searchOption_o[$searchOptionAtt_t]#Null:C1517)
					$urlSearchParams_o.set($searchOptionAtt_t; $searchOption_o[$searchOptionAtt_t])
				End if 
			End for each 
			If ($urlSearchParams_o.size>0)
				$url_o.search:=$urlSearchParams_o.toString()
			End if 
			
		End if 
		
		// Headers
		$headers_o:=cs:C1710.WebAPI.Headers.new()
		$headers_o.append("Authorization"; "Bearer  "+$token_o.token)
		
		// Options
		$options_o:={\
			method: HTTP GET method:K71:1; \
			headers: $headers_o\
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
	