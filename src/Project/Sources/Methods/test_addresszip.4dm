//%attributes = {}
var $params_o; $result_o : Object

test_systemInfo

$params_o:={}
$params_o.pref_name:="埼玉県"
$params_o.city_name:="三郷市"
$result_o:=cs:C1710.AddressZip.me.fetch($params_o)

