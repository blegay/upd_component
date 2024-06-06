//%attributes = {"invisible":true,"shared":false}

//================================================================================
//@xdoc-start : en
//@name : UPD__restartPrepare
//@scope : public
//@deprecated : no
//@description : This function returns the command which will restart 4D, once update is done
//@parameter[0-OUT-cmd-TEXT] : command to restart 4D
//@notes :
//@example : UPD__restartPrepare 
//@see :
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : CREATION : Bruno LEGAY (BLE) - 12/04/2013, 18:08:19 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE()->$restartCmd : Text

var $tempDir : 4D:C1709.Folder
$tempDir:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)

var $restart4dLinkFile : 4D:C1709.File
$restart4dLinkFile:=$tempDir.file("restart.4DLink")

UPD__4DLinkBuild($restart4dLinkFile)

//open -a /Applications/dev/4D/4D\ v12/4D\ v12.5/4D.app  /Users/ble/Documents/Projets/BaseRef_v12/updater/source/test.4dlink

// On Windows, "Application file" is an .exe file
// On MacOS, "Application file" is an .app package (a folder)
var $appFile : Object
If (Is Windows:C1573)
	$appFile:=File:C1566(Application file:C491; fk platform path:K87:2)
Else 
	$appFile:=Folder:C1567(Application file:C491; fk platform path:K87:2)
End if 

UPD__moduleDebugDateTimeLine(4; Current method name:C684; "app path : \""+$appFile.path+"\"")

If (Is Windows:C1573)
	
	$restartCmd:="\""+$appFile.platformPath+"\" \""+$restart4dLinkFile.platformPath+"\""
	
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "restart cmd : \""+$restartCmd+"\"")
	
Else 
	
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "\""+$restart4dLinkFile.path+"\" file (posix) created")
	
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "app path (posix) : \""+$appFile.path+"\"")
	//  "/Applications/dev/4D/4D v12/4D v12.5/4D.app"
	
	var $cmd : Text
	$cmd:="open -a '"+$appFile.path+"' '"+$restart4dLinkFile.path+"'"
	
	If (False:C215)  //auto-cleanup
		$cmd:=$cmd+"\n"
		$cmd:=$cmd+"rm '"+$restart4dLinkFile.path+"'\n"
		
		TO_DO
		//$vt_cmd:=$vt_cmd+"rm '"+$restart4dLinkFile.path+"'\n"
	End if 
	
	var $tempScriptFile : 4D:C1709.File
	$tempScriptFile:=LPE_makeTempExec("restart.sh"; $cmd)
	
	$restartCmd:=$tempScriptFile.path
End if 
