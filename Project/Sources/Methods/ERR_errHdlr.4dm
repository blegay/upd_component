//%attributes = {"shared":false,"invisible":true}
//================================================================================
//@xdoc-start : en
//@name : ERR_errHdlr
//@scope : private 
//@deprecated : no
//@description : This function pushes error to an error stack
//@notes : 
//@example : ERR_errHdlr
//@see : 
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting 2024
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 12/04/2024, 21:47:31 - 4.00.00
//@xdoc-end
//================================================================================

If (ERR_errorStack=Null:C1517)
	ERR_errorStack:=New collection:C1472
End if 
ERR_errorStack.push(ERR_onErrToObject)
