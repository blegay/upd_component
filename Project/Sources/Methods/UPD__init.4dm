//%attributes = {"invisible":true,"shared":false}
//================================================================================
//@xdoc-start : en
//@name : UPD__init
//@scope : private 
//@deprecated : no
//@description : This method runs automatically on "after init".
//@notes : This way, we are sure that debug component is ready to logs messages for instance...
//@example : UPD__init
//@see : 
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting 2024
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 28/04/2024, 07:55:53 - 4.00.00
//@xdoc-end
//================================================================================

var $init : Boolean

$init:=Bool:C1537(Storage:C1525.upd.init)

If (Not:C34($init))
	
	Use (Storage:C1525.upd)
		Storage:C1525.upd.init:=True:C214
	End use 
	
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "upd_component v"+UPD_componentVersionGet+" inited.")
End if 

