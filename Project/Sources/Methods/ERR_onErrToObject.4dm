//%attributes = {"shared":false,"invisible":true}
//================================================================================
//@xdoc-start : en
//@name : ERR_onErrToObject
//@scope : private 
//@deprecated : no
//@description : Thisfunction gets information about the error context and returns an object
//@parameter[0-OUT-error-TEXT] : error object
//@notes : 
//@example : ERR_onErrToObject
//@see : 
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting 2023
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 12/01/2023, 05:57:41 - 1.00.00
//@xdoc-end
//================================================================================

#DECLARE()->$errorObject : Object

C_LONGINT:C283(error; Error line)  // cannot declare as "var" because space in variable name
C_TEXT:C284(Error method; Error formula)

If (error#0)
	
	var $error; $errorLine : Integer
	var $errorMethod; $errorFormula : Text
	
	$error:=error
	$errorLine:=Error line
	$errorMethod:=Error method
	$errorFormula:=Error formula  // 4D v15 R4+
	
	var $procName : Text
	var $procStatus; $procTime : Integer
	
	PROCESS PROPERTIES:C336(Current process:C322; $procName; $procStatus; $procTime)
	
	//var $errorObject : Object
	$errorObject:=New object:C1471
	$errorObject.error:=$error
	$errorObject.errorLine:=$errorLine
	$errorObject.errorMethod:=$errorMethod
	$errorObject.errorFormula:=$errorFormula
	$errorObject.timestampUtc:=Timestamp:C1445
	$errorObject.process:=Current process:C322
	$errorObject.processName:=Current process name:C1392
	$errorObject.processState:=$procStatus
	$errorObject.processTime:=$procTime
	$errorObject.errorStack:=New collection:C1472
	$errorObject.callChain:=Get call chain:C1662  // 4D v17 R6 +
	
	ARRAY LONGINT:C221($tl_errorCodes; 0)
	ARRAY TEXT:C222($tt_intCompArray; 0)
	ARRAY TEXT:C222($tt_errorText; 0)
	
	GET LAST ERROR STACK:C1015($tl_errorCodes; $tt_intCompArray; $tt_errorText)
	
	ARRAY TO COLLECTION:C1563($errorObject.errorStack; \
		$tl_errorCodes; "codes"; \
		$tt_intCompArray; "intComp"; \
		$tt_errorText; "text")
	
	ARRAY LONGINT:C221($tl_errorCodes; 0)
	ARRAY TEXT:C222($tt_intCompArray; 0)
	ARRAY TEXT:C222($tt_errorText; 0)
End if 
