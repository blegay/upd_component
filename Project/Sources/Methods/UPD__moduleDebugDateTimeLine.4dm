//%attributes = {"shared":false,"invisible":true}
//================================================================================
//@xdoc-start : en
//@name : upd__moduleDebugDateTimeLine
//@scope : private 
//@deprecated : no
//@description : This method writes a log
//@parameter[1-IN-level-LONGINT] : level
//@parameter[2-IN-methodName-TEXT] : methodName
//@parameter[3-IN-debugMessage-TEXT] : debugMessage
//@parameter[4-IN-moduleCode-TEXT] : moduleCode (optional, default value : "upd")
//@notes : 
//@example : upd__moduleDebugDateTimeLine
//@see : 
//@version : 1.00.00
//@author : 
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 10/04/2024, 10:22:00 - 1.00.00
//@xdoc-end
//================================================================================

#DECLARE($level : Integer; $methodName : Text; $debugMessage : Text; $moduleCodeParam : Text)

ASSERT:C1129(Count parameters:C259>2; "requires 3 parameters")

var $moduleCode : Text
If (Count parameters:C259>3)
	$moduleCode:=$moduleCodeParam
End if 

If (Length:C16(Storage:C1525.upd.debugMethodName)>0)
	
	If (Length:C16($moduleCode)=0)
		$moduleCode:="upd"
	End if 
	
	EXECUTE METHOD:C1007(Storage:C1525.upd.debugMethodName; *; $moduleCode; $level; $methodName; $debugMessage)
	
End if 

UPD__log($methodName+" - "+String:C10($level)+" - "+$debugMessage)