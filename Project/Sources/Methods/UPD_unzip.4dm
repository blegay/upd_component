//%attributes = {"shared":true,"invisible":false}

//================================================================================
//@xdoc-start : en
//@name : UPD_unzip
//@scope : public
//@deprecated : no
//@description : native unzip
//@parameter[0-OUT-ok-BOOLEAN] : ok
//@parameter[1-IN-archive-OBJECT] : zip archive file (4D.File object)
//@parameter[2-IN-dest-OBJECT] : dest dir path (4D.Folder object)
//@parameter[3-IN-password-TEXT] : password to decrypt archive (optional)
//@example : 
//
//  var $zipFile : 4D.File
//  $zipFile:=File("Macintosh HD:Users:ble:Documents:Projets:BaseRef_v20:upd_component:test:upd_test_new.4dbase.zip"; fk platform path)
//
//  var $destDir : 4D.Folder
//  $destDir:=Folder("Macintosh HD:Users:ble:Documents:Projets:BaseRef_v20:upd_component:test:temp:"; fk platform path)
//
// If (UPD_unzip($zipFile; $destDir))
//   $zipFile.delete()
// End if 
//
//@see :
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//  CREATION : Bruno LEGAY (BLE) - 12/04/2024, 21:41:39 - 4.00.00
//@xdoc-end
//================================================================================

#DECLARE($archiveParam : Variant; $destParam : Variant; $password : Text)->$ok : Boolean

ASSERT:C1129(Count parameters:C259>1; "requires 2 parameters")

$ok:=False:C215

var $archiveFile : 4D:C1709.File
Case of 
	: (Value type:C1509($archiveParam)=Is text:K8:3)
		// "Macintosh HD:Users:ble:Desktop:aws_component_v4-00-05_(bfabed2)_v20_2-notarized.zip"
		$archiveFile:=File:C1566($archiveParam; fk platform path:K87:2)
		
	: (Value type:C1509($archiveParam)=Is object:K8:27)
		If (OB Instance of:C1731($archiveParam; 4D:C1709.File))
			$archiveFile:=$archiveParam
		End if 
End case 

var $destDir : 4D:C1709.Folder
Case of 
	: (Value type:C1509($destParam)=Is text:K8:3)
		// "Macintosh HD:Users:ble:Desktop:"
		$destDir:=Folder:C1567($destParam; fk platform path:K87:2)
		
	: (Value type:C1509($destParam)=Is object:K8:27)
		If (OB Instance of:C1731($destParam; 4D:C1709.Folder))
			$destDir:=$destParam
		End if 
End case 

If (($archiveFile#Null:C1517) & ($destDir#Null:C1517))
	
	If ($archiveFile.exists & $destDir.exists)
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip archive \""+$archiveFile.platformPath+"\" into dest \""+$destDir.platformPath+"\"...")
		
		// error handling
		var ERR_errorStack : Collection
		ERR_errorStack:=Null:C1517
		
		var $previousErrorHandler : Text
		$previousErrorHandler:=Method called on error:C704
		ON ERR CALL:C155("ERR_errHdlr")
		
		var $content : Object
		If ((Count parameters:C259>2) && ($password#""))
			$content:=ZIP Read archive:C1637($archiveFile; $password)
		Else 
			$content:=ZIP Read archive:C1637($archiveFile)
		End if 
		
		var $tempDir : 4D:C1709.Folder
		
		// extract archive to temp dir folder
		If ($content#Null:C1517)  // $archiveFile is a valid archive
			
			// create a temporary folder in $destDir (e.g. ".e768e646ba094d5492354fd12afafd67")
			$tempDir:=$destDir.folder("."+Lowercase:C14(Generate UUID:C1066))
			$tempDir.create()
			//$tempDir.hidden:=True
			
			// extract files in temporary folder (e.g. ".e768e646ba094d5492354fd12afafd67")
			var $file : 4D:C1709.File
			var $files : Collection
			$files:=$content.root.files()
			For each ($file; $files)
				$file.copyTo($tempDir)
			End for each 
			
			// extract folders (recursive) in temporary folder (e.g. ".e768e646ba094d5492354fd12afafd67")
			var $folder : 4D:C1709.Folder
			var $folders : Collection
			$folders:=$content.root.folders()
			For each ($folder; $folders)
				$folder.copyTo($tempDir)
			End for each 
			
		End if 
		
		ON ERR CALL:C155($previousErrorHandler)
		
		$ok:=(ERR_errorStack=Null:C1517)
		
		If ($ok)
			var $dirname : Text
			$dirname:=$content.root.name
			
			// make sure we have a unique name
			var $suffix : Text
			$suffix:=""
			var $suffixIndex : Integer
			$suffixIndex:=0
			While ($destDir.folder($dirname+$suffix).exists)
				$suffixIndex:=$suffixIndex+1
				$suffix:=" "+String:C10($suffixIndex)
			End while 
			
			// rename temp dir (e.g. ".e768e646ba094d5492354fd12afafd67") with root dir name (e.g. "aws_component_v4-00-05_(bfabed2)_v20_2-notarized")
			$tempDir:=$tempDir.rename($dirname+$suffix)
			$tempDir.hidden:=False:C215
			
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip archive \""+$archiveFile.platformPath+"\" into \""+$tempDir.platformPath+"\". [OK]")
			
		Else   // errors
			
			If ($tempDir.exists)
				$tempDir.delete(Delete with contents:K24:24)
			End if 
			
			If (ERR_errorStack#Null:C1517)
				UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip errors : "+JSON Stringify:C1217(ERR_errorStack))
				ERR_errorStack:=Null:C1517
			End if 
		End if 
		
	Else   // path do not exist
		
		If (Not:C34($archiveFile.exists))
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip archive \""+$archiveFile.platformPath+"\" does not exists. [KO]")
		End if 
		
		If (Not:C34($destDir.exists))
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip dest dir \""+$destDir.platformPath+"\" does not exists. [KO]")
		End if 
		
	End if 
	
Else   // invalid parameters
	
	If ($archiveFile=Null:C1517)
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip archive ($1) invalid parameter. [KO]")
	End if 
	
	If ($destDir=Null:C1517)
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "unzip dest dir ($2) invalid parameter. [KO]")
	End if 
	
End if 
