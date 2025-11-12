//%attributes = {"shared":true,"invisible":false}

//================================================================================
//@xdoc-start : en
//@name : UPD_onStartup
//@scope : public
//@deprecated : no
//@description : This method will prepare the update process. Typically called on application startup.
//@parameter[1-IN-updatePath-VARIANT] : path of the update application/structure (e.g. "Macintosh HD:Users:ble:Documents:myApp:temp:myApp.4dbase:") or 4D.File or 4D.Folder
//@parameter[2-IN-newPath-VARIANT] : path of the new stucture (optional, default value : current location "Macintosh HD:Users:ble:Documents:myApp:app:myApp.4dbase:") or 4D.File or 4D.Folder
//@notes : 
//  The user will need write access to the current structure dir
//  The function does nothing on 4D Remote
//@example : UPD_onStartup
//
// download new version from somewhere (S3, ftp/sftp, http, github) into a temp dir
// for instance, call a web service to get an object
//      - presignedUrl
//      - archiveFullname
//      - version
//      - sha256
//      - ...
//  
// var $archiveFullname : Text
// $archiveFullname:="newApp_v1_10_49.zip" 
//
// // timestamp compatible wih folder name
// var $timestamp : Text
// $timestamp:=Substring(Timestamp; 1; 19)
// $timestamp:=Replace string($timestamp; "-"; ""; *)
// $timestamp:=Replace string($timestamp; ":"; ""; *)
// // "20240427T164354"
//  
// // create a unique temp dir (e.g. "update_20240427T164354_be799d64dad040ff9444ebd0e05400ab") in temp dir
// // (e.g."/var/folders/61/sg995tqx3_n12n2s33kh7y200000gp/T/update_20240427T164354_be799d64dad040ff9444ebd0e05400ab/")
// var $updateTempDir : 4D.Folder
// $updateTempDir:=Folder(Temporary folder; fk platform path).folder("update_"+$timestamp+"_"+Lowercase(Generate UUID))
// $updateTempDir.create()
//  
// // let say that this is the archive file we want to install...
// var $zipFile : 4D.File
// $zipFile:=$updateTempDir.file($archiveFullname)
// 
// // download new version into that file
// // check the archive (md5, sha256 whatever)
//
// If (UPD_unzip($zipFile; $updateTempDir))
//
//       // delete the archive
//     $zipFile.delete()
//     
//     // Take the first folder of the unarchived files/folder (ignore invisible folders)
//     var $folders : Collection
//     $folders:=$updateTempDir.folders(Ignore invisible)
//     If ($folders.length>0)
//         var $newAppDir : 4D.File
//         $newAppDir:=$updateTempDir.folder($folders[0].fullname)
//         
//         // replace current app with that folder
//         UPD_onStartup($newAppDir)
//     Else   // There was no folder in that directory, try to take the first file
//         
//         // Take the first file of the unarchived files/folder (ignore invisible files)
//         var $files : Collection
//         $files:=$updateTempDir.files(Ignore invisible)
//         If ($files.length>0)
//             var $newAppFile : 4D.File
//             $newAppFile:=$updateTempDir.file($files[0].fullname)
//             
//             // replace current app with that file
//             UPD_onStartup($newAppFile)
//         End if 
//     End if 
//     
// End if 
//
//@see :
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : CREATION : Bruno LEGAY (BLE) - 12/04/2013, 17:50:21 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE($updateVersionParam : Variant; $basePathParam : Variant)

var $nbParam : Integer
$nbParam:=Count parameters:C259
If ($nbParam>0)
	
	var $appType : Integer
	$appType:=Application type:C494
	If ($appType#4D Remote mode:K5:5)  //don't do this on 4D Client
		
		UPD__init
		
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "4D Application type : "+String:C10($appType))
		
		var $updateVersionDirOrFile : Object  // 4D.Folder or 4D.File
		Case of 
			: (Value type:C1509($updateVersionParam)=Is text:K8:3)
				
				// "Macintosh HD:Users:ble:Desktop:"
				Case of 
					: (Test path name:C476($updateVersionParam)=Is a document:K24:1)
						$updateVersionDirOrFile:=File:C1566($updateVersionParam; fk platform path:K87:2)
						UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionParam (text) : \""+$updateVersionParam+"\", 4D.File : \""+$updateVersionDirOrFile.path+"\", exists : "+Choose:C955($updateVersionDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
						
					: (Test path name:C476($updateVersionParam)=Is a folder:K24:2)
						$updateVersionDirOrFile:=Folder:C1567($updateVersionParam; fk platform path:K87:2)
						UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionParam (text) : \""+$updateVersionParam+"\", 4D.Folder : \""+$updateVersionDirOrFile.path+"\", exists : "+Choose:C955($updateVersionDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
						
					Else 
						UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionParam (text) : \""+$updateVersionParam+"\" invalid path. [KO]")
				End case 
				
				
			: (Value type:C1509($updateVersionParam)=Is object:K8:27)
				Case of 
					: (OB Instance of:C1731($updateVersionParam; 4D:C1709.Folder))
						$updateVersionDirOrFile:=$updateVersionParam
						UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionParam (4D.Folder) : \""+$updateVersionDirOrFile.path+"\", exists : "+Choose:C955($updateVersionDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
						
					: (OB Instance of:C1731($updateVersionParam; 4D:C1709.File))
						$updateVersionDirOrFile:=$updateVersionParam
						UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionParam (4D.File) : \""+$updateVersionDirOrFile.path+"\", exists : "+Choose:C955($updateVersionDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
						
					Else 
						UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionParam (object) : \""+String:C10($updateVersionParam)+"\" not an instance of 4D.File or 4D.Folder. [KO]")
				End case 
		End case 
		
		var $basePathDirOrFile : Object  // 4D.Folder or 4D.File
		Case of 
			: ($nbParam=1)
				
				//$vt_basePath:=Get 4D folder(Database folder; *)  //dossier base de la base hôte
				//Macintosh HD:Users:ble:Documents:Projets:BaseRef_v12:updater:updater.4dbase:
				$basePathDirOrFile:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14; *); fk platform path:K87:2)
				
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "basePathParam (4D.Folder default) : \""+$basePathDirOrFile.path+"\", exists : "+Choose:C955($basePathDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
				
				
			Else 
				
				Case of 
					: (Value type:C1509($basePathParam)=Is text:K8:3)
						// "Macintosh HD:Users:ble:Desktop:"
						Case of 
							: (Test path name:C476($basePathParam)=Is a document:K24:1)
								$basePathDirOrFile:=File:C1566($basePathParam; fk platform path:K87:2)
								UPD__moduleDebugDateTimeLine(4; Current method name:C684; "basePathParam (4D.File) : \""+$basePathDirOrFile.path+"\", exists : "+Choose:C955($basePathDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
								
							: (Test path name:C476($basePathParam)=Is a folder:K24:2)
								$basePathDirOrFile:=Folder:C1567($basePathParam; fk platform path:K87:2)
								UPD__moduleDebugDateTimeLine(4; Current method name:C684; "basePathParam (4D.Folder) : \""+$basePathDirOrFile.path+"\", exists : "+Choose:C955($basePathDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
								
						End case 
						
					: (Value type:C1509($basePathParam)=Is object:K8:27)
						Case of 
							: (OB Instance of:C1731($basePathParam; 4D:C1709.Folder))
								$basePathDirOrFile:=$basePathParam
								UPD__moduleDebugDateTimeLine(4; Current method name:C684; "basePathDirOrFile (4D.Folder) : \""+$basePathDirOrFile.path+"\", exists : "+Choose:C955($basePathDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
								
							: (OB Instance of:C1731($basePathParam; 4D:C1709.File))
								$basePathDirOrFile:=$basePathParam
								UPD__moduleDebugDateTimeLine(4; Current method name:C684; "basePathDirOrFile (4D.File) : \""+$basePathDirOrFile.path+"\", exists : "+Choose:C955($basePathDirOrFile.exists; "yes. [OK]"; "no. [KO]"))
								
							Else 
								UPD__moduleDebugDateTimeLine(4; Current method name:C684; "basePathParam (object) : \""+String:C10($basePathParam)+"\" not an instance of 4D.File or 4D.Folder. [KO]")
						End case 
				End case 
				
		End case 
		
		var $pid : Integer
		If (Storage:C1525.upd.pid#Null:C1517)
			$pid:=Storage:C1525.upd.pid
		Else 
			$pid:=UTL_getProcessId
		End if 
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "pid : "+String:C10($pid))
		
		If ($pid#0)
			
			If ($basePathDirOrFile.exists)
				
				If ($updateVersionDirOrFile.exists)
					
					var $postUpdateAction : Text
					$postUpdateAction:=UPD__restartPrepare  //($vt_basePath)
					
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "udpater component v"+UPD_versionGet)
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "proc no : "+String:C10($pid))
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "oldVersionPath : \""+$basePathDirOrFile.path+"\"")
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "updateVersionPath : \""+$updateVersionDirOrFile.path+"\"")
					UPD__moduleDebugDateTimeLine(4; Current method name:C684; "postUpdateAction : \""+$postUpdateAction+"\"")
					
					Use (Storage:C1525.upd)
						Storage:C1525.upd.currentVersionDirOrFile:=$basePathDirOrFile
						Storage:C1525.upd.updateVersionDirOrFile:=$updateVersionDirOrFile
						Storage:C1525.upd.postUpdateAction:=$postUpdateAction
					End use 
					
				End if 
				
			End if 
			
		End if 
		
		If (Storage:C1525.upd#Null:C1517)
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd : "+JSON Stringify:C1217(Storage:C1525.upd))
		Else 
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "Storage.upd is null")
		End if 
		
	Else   // 4D Client
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "4D Remote")
	End if 
	
Else 
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "missing parameters")
End if 