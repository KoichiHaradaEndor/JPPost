singleton Class constructor
	
Function unixTime($date_d : Date; $time_h : Time) : Real
	
	var $start_d : Date:=!1970-01-01!
	var $numParams_l : Integer:=Count parameters:C259
	var $dateTime_t : Text
	var $days_l : Integer
	
	Case of 
		: ($numParams_l=2)  // ローカル日時をUTC日時に変換
			$dateTime_t:=String:C10($date_d; ISO date GMT:K1:10; $time_h)  // yyyy-MM-ddTHH:mm:ssZ
			$dateTime_t:=Substring:C12($dateTime_t; 1; Length:C16($dateTime_t)-1)  // UTC時刻のまま日付と時刻に分解
			$date_d:=Date:C102($dateTime_t)
			$time_h:=Time:C179($dateTime_t)
			
		Else   // タイムスタンプをUTC日時に変換
			$dateTime_t:=Timestamp:C1445  // yyyy-MM-ddTHH:mm:ss.SSSZ
			$dateTime_t:=Substring:C12($dateTime_t; 1; Length:C16($dateTime_t)-5)  // UTC時刻のまま日付と時刻に分解
			$date_d:=Date:C102($dateTime_t)
			$time_h:=Time:C179($dateTime_t)
			
	End case 
	
	$days_l:=$date_d-$start_d
	return ($days_l*86400)+($time_h+0)
	
Function unixTimeToIsoDateGmt($unixTime_r : Real) : Text
	
	var $start_d : Date:=!1970-01-01!
	var $secsPerDay_l : Integer:=60*60*24
	var $numDays_l : Integer
	var $remaining_r : Real
	var $date_d : Date
	var $time_h : Time
	
	$numDays_l:=$unixTime_r\$secsPerDay_l
	$date_d:=Add to date:C393($start_d; 0; 0; $numDays_l)
	
	$remaining_r:=$unixTime_r%$secsPerDay_l
	$time_h:=Time:C179($remaining_r)
	return String:C10($date_d; ISO date GMT:K1:10; $time_h)
	
Function decodeJWT($jwt_t : Text) : Object
	
	var $content_o : Object
	
	$content_o:=cs:C1710.NetKit.JWT.new().decode($jwt_t)
	$content_o.payload.iat2:=This:C1470.unixTimeToIsoDateGmt($content_o.payload.iat)
	$content_o.payload.exp2:=This:C1470.unixTimeToIsoDateGmt($content_o.payload.exp)
	return $content_o
	
Function JPtoEN($original_t : Text) : Text
	
	var $converted_t : Text:=$original_t
	var $jaStart_l; $enStart_l; $i : Integer
	
	// 大文字アルファベット
	$jaStart_l:=Character code:C91("Ａ")
	$enStart_l:=Character code:C91("A")
	For ($i; 0; 26)
		$converted_t:=Replace string:C233($converted_t; Char:C90($jaStart_l+$i); Char:C90($enStart_l+$i); *)
	End for 
	
	// 小文字アルファベット
	$jaStart_l:=Character code:C91("ａ")
	$enStart_l:=Character code:C91("a")
	For ($i; 0; 26)
		$converted_t:=Replace string:C233($converted_t; Char:C90($jaStart_l+$i); Char:C90($enStart_l+$i); *)
	End for 
	
	// 数字
	$jaStart_l:=Character code:C91("０")
	$enStart_l:=Character code:C91("0")
	For ($i; 0; 10)
		$converted_t:=Replace string:C233($converted_t; Char:C90($jaStart_l+$i); Char:C90($enStart_l+$i); *)
	End for 
	
	return $converted_t
	