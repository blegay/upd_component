//%attributes = {"shared":false,"invisible":true}
//================================================================================
//@xdoc-start : en
//@name : UPD__initStorage
//@scope : private 
//@deprecated : no
//@description : This method inits the storage for the component
//@notes : 
//@example : UPD__initStorage
//@see : 
//@version : 1.00.00
//@author : 
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 10/04/2024, 10:19:20 - 1.00.00
//@xdoc-end
//================================================================================

var $debugMethodName : Text
$debugMethodName:=""

ARRAY TEXT:C222($tt_componentsList; 0)
COMPONENT LIST:C1001($tt_componentsList)
If (Find in array:C230($tt_componentsList; "dbg_component")>0)
	$debugMethodName:="DBG_module_Debug_DateTimeLine"
End if 
ARRAY TEXT:C222($tt_componentsList; 0)

var $isRemote : Boolean
$isRemote:=(Application type:C494=4D Remote mode:K5:5)

var $pid : Integer
If (Not:C34($isRemote))  //don't do this on 4D Client
	$pid:=UTL_getProcessId
End if 

Use (Storage:C1525)
	
	Storage:C1525.upd:=New shared object:C1526(\
		"debugMethodName"; $debugMethodName; \
		"init"; False:C215; \
		"pid"; Choose:C955($isRemote; Null:C1517; $pid); \
		"currentVersionDirOrFile"; Null:C1517; \
		"updateVersionDirOrFile"; Null:C1517; \
		"postUpdateAction"; Null:C1517; \
		"logFile"; Null:C1517)
	
End use 