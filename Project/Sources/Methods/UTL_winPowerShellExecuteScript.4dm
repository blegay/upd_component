//%attributes = {"shared":false,"invisible":true}
//================================================================================
//@xdoc-start : en
//@name : UTL_winPowerShellExecuteScript
//@scope : private
//@deprecated : no
//@description : This function will run a windows script file using powershell
//@parameter[1-IN-scriptFile-4D.File] : script file object
//@parameter[2-IN-args-TEXT] : args (optional)
//@notes :
//@example : UTL_winPowerShellExecuteScript
//@see :
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting 2024
//@history :
//  CREATION : Bruno LEGAY (BLE) - 26/04/2024, 04:29:03 - 4.00.00
//@xdoc-end
//================================================================================

#DECLARE($scriptFile : 4D:C1709.File; $argsParam : Text)

var $nbParam : Integer
$nbParam:=Count parameters:C259
If ($nbParam>0)
	
	var $args : Text
	Case of 
		: ($nbParam=1)
			$args:=""
			
		Else 
			//:($vl_nbParam=2)
			$args:=$argsParam
	End case 
	
	var $cmd : Text
	$cmd:="powershell.exe -nologo -NoProfile -ExecutionPolicy Bypass -file \""+$scriptFile.platformPath+"\" "+$args
	
	var $sysWorker : 4D:C1709.SystemWorker
	$sysWorker:=4D:C1709.SystemWorker.new($cmd)  // pas de wait car "non blocking" : fire and forget (don't wait for the script to execute...)
	
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "script \""+$scriptFile.platformPath+"\" launched async (non blocking, cmd : \""+$cmd+"\"). [OK]")
	
End if 
