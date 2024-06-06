//%attributes = {"shared":true,"invisible":false}

//================================================================================
//@xdoc-start : en
//@name : UPD_onQuit
//@scope : public
//@deprecated : no
//@description : This method will trigger the update of the application
//@parameter[1-IN-relaunch-BOOLEAN] :  relaunch the current structure (optional, default TRUE)
//@parameter[2-IN-timeout-LONGINT] :  timeout in seconds (optional, default 0 i.e. no timeout)
//@notes :
//@example : 
// 
//  UPD_onQuit(True; 60) 
//
//@see : 
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : CREATION : Bruno LEGAY (BLE) - 12/04/2013, 17:33:21 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE($relaunchParam : Boolean; $timeoutSecondsParam : Integer)

var $nbParam : Integer
$nbParam:=Count parameters:C259

var $relaunch : Boolean
var $timeoutSeconds : Integer

Case of 
	: ($nbParam=0)
		$relaunch:=True:C214
		$timeoutSeconds:=0
		
	: ($nbParam=1)
		$relaunch:=$relaunchParam
		$timeoutSeconds:=0
		
	Else 
		//: ($vl_nbParam=2)
		$relaunch:=$relaunchParam
		$timeoutSeconds:=$timeoutSecondsParam
		
End case 

If (Application type:C494#4D Remote mode:K5:5)  //don't do this on 4D Client
	
	If (Storage:C1525.upd.pid#0)  //set to 0 if there was no update
		
		// get folder object for the component resources folder where the scripts are stored
		
		var $currentResourcesDir : 4D:C1709.Folder
		$currentResourcesDir:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2)
		
		ASSERT:C1129($currentResourcesDir.exists; "folder \""+$currentResourcesDir.path+"\" missing")
		
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "relaunch : "+Choose:C955($relaunch; "yes"; "no"))
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "timeout : "+Choose:C955($timeoutSeconds=0; "no timeout"; String:C10($timeoutSeconds)+"s"))
		
		If (Is Windows:C1573)  // windows 
			
			var $scriptFile : 4D:C1709.File
			$scriptFile:=$currentResourcesDir.file("update.ps1")
			
			If ($scriptFile.exists && \
				(Storage:C1525.upd.currentVersionDirOrFile#Null:C1517) && \
				(Storage:C1525.upd.updateVersionDirOrFile#Null:C1517) && \
				(Storage:C1525.upd.postUpdateAction#Null:C1517))
				
				var $params : Text
				$params:=String:C10(Storage:C1525.upd.pid)+" "+String:C10($timeoutSeconds)+\
					" \""+Storage:C1525.upd.currentVersionDirOrFile.platformPath+"\""+\
					" \""+Storage:C1525.upd.updateVersionDirOrFile.platformPath+"\""+\
					" "+Storage:C1525.upd.postUpdateAction
				
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "script : \""+$scriptFile.platformPath+"\", params : \""+$params+"\"...")
				
				UTL_winPowerShellExecuteScript($scriptFile; $params)
			Else 
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "script : \""+$scriptFile.path+"\" missing !!! [KO]")
			End if 
			
			//$vt_componentResourcePath:=Dossier 4D(Dossier Resources courant)
			//Si (Tester chemin acces($vt_componentResourcePath)=Est un répertoire)
			//
			//$vt_waitForPidToFinishScriptPath:=$vt_componentResourcePath+"waitforpidtofinish.vbs"
			//$vt_updateScriptPath:=$vt_componentResourcePath+"update.vbs"
			//
			//TO_DO 
			//  //to do (one day)
			//
			//Si (Faux)  //auto-cleanup
			//$vt_cmd:=$vt_cmd+"DEL \"%~dp0\""
			//Fin de si 
			//Fin de si 
			
			
		Else   // os x
			
			If (Storage:C1525.upd#Null:C1517)
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd : "+JSON Stringify:C1217(Storage:C1525.upd))
			Else 
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd is null")
			End if 
			
			var $waitForPidToFinishScriptFile; $updateScriptFile : 4D:C1709.File
			$waitForPidToFinishScriptFile:=$currentResourcesDir.file("waitforpidtofinish.sh")
			$updateScriptFile:=$currentResourcesDir.file("update.sh")
			
			SET ASSERT ENABLED:C1131(True:C214; *)
			
			ASSERT:C1129($waitForPidToFinishScriptFile.exists; "file \""+$waitForPidToFinishScriptFile.path+"\" missing")
			ASSERT:C1129($updateScriptFile.exists; "file \""+$updateScriptFile.path+"\" missing")
			
			If ($waitForPidToFinishScriptFile.exists && \
				$updateScriptFile.exists && \
				(Storage:C1525.upd.currentVersionDirOrFile#Null:C1517) && \
				(Storage:C1525.upd.updateVersionDirOrFile#Null:C1517) && \
				(Storage:C1525.upd.postUpdateAction#Null:C1517))
				
				If (Storage:C1525.upd#Null:C1517)
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd : "+JSON Stringify:C1217(Storage:C1525.upd))
				Else 
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd is null")
				End if 
				
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "$updateScriptFile.path : \""+$updateScriptFile.path+"\"")
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd.currentVersionDirOrFile : \""+Storage:C1525.upd.currentVersionDirOrFile.path+"\"")
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd.updateVersionDirOrFile : \""+Storage:C1525.upd.updateVersionDirOrFile.path+"\"")
				
				var $cmd : Text
				$cmd:=\
					"'"+$updateScriptFile.path+"'"+\
					" '"+Storage:C1525.upd.currentVersionDirOrFile.path+"'"+\
					" '"+Storage:C1525.upd.updateVersionDirOrFile.path+"'\n"
				
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "relaunch : "+Choose:C955($relaunch; "true"; "false")+", Storage.upd.postUpdateAction : \""+Storage:C1525.upd.postUpdateAction+"\"")
				
				If ($relaunch && (Storage:C1525.upd.postUpdateAction#Null:C1517) && (Length:C16(Storage:C1525.upd.postUpdateAction)>0))
					$cmd:=$cmd+"'"+Storage:C1525.upd.postUpdateAction+"'\n"
				End if 
				
				
				If (False:C215)  //auto-cleanup
					$cmd:=$cmd+"rm \"$0\"\n"
				End if 
				
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "$cmd : \""+$cmd+"\"")
				
				var $tempScriptFile : 4D:C1709.File
				$tempScriptFile:=LPE_makeTempExec("updater4d_"+Lowercase:C14(Generate UUID:C1066)+".sh"; $cmd)
				
				$cmd:="'"+$waitForPidToFinishScriptFile.path+"' "+\
					String:C10(Storage:C1525.upd.pid)+" "+\
					String:C10($timeoutSeconds)+" '"+\
					$tempScriptFile.path+"'"
				
				If (Application type:C494=4D Server:K5:6)
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Count users : "+String:C10(Count users:C342)+", Count user processes : "+String:C10(Count user processes:C343))
				End if 
				
				If (True:C214)  // use LEP because 4D.SystemWorker is not working for this context/use case
					
					If (Is Windows:C1573)
						SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
					End if 
					SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
					
					LAUNCH EXTERNAL PROCESS:C811($cmd)
					
				Else   // 4D.SystemWorker : les process 4D.SystemWorker semblent être détruit quand 4D quitte... On en peut pas les utiliser ici
					// Tested on 4D v20.3 LTS
					
					//var $sysWorker : 4D.SystemWorker
					//$sysWorker:=4D.SystemWorker.new($cmd)  // pas de wait car "non blocking" : fire and forget (don't wait for the script to execute...)
					
				End if 
				
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "cmd : \""+$cmd+"\" launched async (non blocking)")
				
			End if 
			
		End if 
		
	End if 
	
End if 