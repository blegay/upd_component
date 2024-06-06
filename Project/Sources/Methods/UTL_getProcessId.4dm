//%attributes = {"invisible":true,"shared":false}
//================================================================================
//@xdoc-start : en
//@name : UTL_getProcessId
//@scope : public
//@deprecated : no
//@description : This function will return the current 4D application process id (pid) 
//@parameter[0-OUT-pid-LONGINT] : 4D application process id (pid)
//@notes : if it fails, the function will return 0
//@example : UTL_getProcessId 
//@see : 
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : CREATION : Bruno LEGAY (BLE) - 06/11/2009, 14:41:55 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE()->$4dAppPid : Integer

var $appInfos : Object
$appInfos:=Get application info:C1599

$4dAppPid:=$appInfos.pid
