//%attributes = {"invisible":true,"shared":false}
#DECLARE($filename : Text; $cmd : Text)->$tempScriptFile : 4D:C1709.File

$tempScriptFile:=Null:C1517

ASSERT:C1129(Count parameters:C259>1; "requires 2 parameters")

If (Length:C16($filename)>0)
	$filename:=Replace string:C233($filename; " "; "_")
Else 
	$filename:="temp4d_"+Lowercase:C14(Generate UUID:C1066)  //String(Milliseconds; "&x")
	//DELAY PROCESS(Current process; 2)
End if 

var $encoding : Text  //; $lineSep
If (Is Windows:C1573)
	
	$encoding:="windows-1252"
	
	Case of 
		: (Substring:C12($filename; Length:C16($filename)-3)=".bat")
		: (Substring:C12($filename; Length:C16($filename)-3)=".vbs")
		Else 
			$filename:=$filename+".bat"
	End case 
	
Else 
	
	$encoding:="UTF-8-no-bom"
	
	Case of 
		: (Substring:C12($filename; Length:C16($filename)-2)=".sh")
		Else 
			$filename:=$filename+".sh"
	End case 
	
End if 

var $tempDir : 4D:C1709.Folder
$tempDir:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)

//var $tempScriptFile : 4D.File
$tempScriptFile:=$tempDir.file($filename)
If ($tempScriptFile.exists)
	$tempScriptFile.delete()
End if 

C_TEXT:C284($buffer)
$buffer:=""

If (Is Windows:C1573)
	//make sure end of line is \r\n (window)
	$cmd:=Replace string:C233($cmd; "\r\n"; "\n")
	$cmd:=Replace string:C233($cmd; "\r"; "\n")
	$cmd:=Replace string:C233($cmd; "\n"; "\r\n")
	
	$buffer:=$buffer+$cmd+"\r\n"
	
Else 
	
	If (Substring:C12($cmd; 1; 9)#"#!/bin/sh")
		$buffer:=$buffer+"#!/bin/sh\n\n"
	End if 
	
	//make sure end of line is \n (unix)
	$cmd:=Replace string:C233($cmd; "\r\n"; "\n")
	$cmd:=Replace string:C233($cmd; "\r"; "\n")
	
	$buffer:=$buffer+$cmd+"\n"
	
End if 

//create the script file
$tempScriptFile.setText($buffer; $encoding; Document unchanged:K24:18)
If ($tempScriptFile.exists)
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "\""+$tempScriptFile.path+"\" (with cmd : \""+$cmd+"\", encoding \""+$encoding+"\") file created")
End if 

If (Not:C34(Is Windows:C1573))
	//give the script the execution permissions
	
	$cmd:="/bin/chmod 755 '"+$tempScriptFile.path+"'"
	
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "cmd : \""+$cmd+"\"")
	var $sysWorker : 4D:C1709.SystemWorker
	$sysWorker:=4D:C1709.SystemWorker.new($cmd)
	$sysWorker:=$sysWorker.wait(1)
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "result : "+JSON Stringify:C1217($sysWorker))
	
End if 

