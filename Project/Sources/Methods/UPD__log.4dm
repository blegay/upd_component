//%attributes = {"invisible":true,"shared":false}

//================================================================================
//@xdoc-start : en
//@name : UPD__log
//@scope : public
//@deprecated : no
//@description : This method adds some log about the update process into a file
//@parameter[1-IN-message-TEXT] : log message
//@notes : the file is called "update_log_YYYYMMDD.txt"
//@example : UPD__log 
//@see : 
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 18/04/2024, 08:52:08 - v4.00.00
//@xdoc-end
//================================================================================

#DECLARE($message : Text)

ASSERT:C1129(Count parameters:C259>0; "requires 1 parameter")

var $linePrefix : Text
$linePrefix:=Timestamp:C1445+" - upd - "
// "2016-12-12T13:31:29.477Z"
//$vt_linePrefix:=String($vd_today; Internal date short)+" "+String($vh_now; HH MM SS)+" - 4d - "

var $buffer : Text
$buffer:=$linePrefix+$message

var $logFile : 4D:C1709.File

If (Storage:C1525.upd.logFile#Null:C1517)
	$logFile:=Storage:C1525.upd.logFile
Else 
	
	var $today : Date
	$today:=Current date:C33
	
	var $logDir : 4D:C1709.Folder
	$logDir:=Folder:C1567(fk logs folder:K87:17; *).folder("updater")
	If (Not:C34($logDir.exists))
		$logDir.create()
	End if 
	
	var $filename : Text
	$filename:="update_log_"+String:C10(Year of:C25($today); "0000")+String:C10(Month of:C24($today); "00")+String:C10(Day of:C23($today); "00")+".txt"
	
	$logFile:=$logDir.file($filename)
	
	If (Not:C34($logFile.exists))
		$logFile.create()
	End if 
	
	Use (Storage:C1525.upd)
		Storage:C1525.upd.logFile:=$logFile
	End use 
	
End if 

If (Not:C34($logFile.exists))
	$logFile.create()
End if 

var $logFileHandle : 4D:C1709.FileHandle
$logFileHandle:=$logFile.open("append")

$logFileHandle.writeLine($buffer)


