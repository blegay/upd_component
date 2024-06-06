//%attributes = {"shared":true,"invisible":false}

//================================================================================
//@xdoc-start : en
//@name : UPD_zip
//@scope : public
//@deprecated : no
//@description : simple native zip
//@parameter[0-OUT-ok-BOOLEAN] : ok
//@parameter[1-IN-source-OBJECT] : source path (4D.File object or 4D.Folder object)
//@parameter[2-IN-archive-OBJECT] : zip archive file (4D.File object)
//@parameter[3-IN-options-OBJECT] : options (optional)
//@example : 
//
//  var $zipFile : 4D.File
//  $zipFile:=File("Macintosh HD:Users:ble:Documents:Projets:BaseRef_v20:upd_component:test:upd_test_new.4dbase.zip"; fk platform path)
//
//  var $srcDir : 4D.Folder
//  $srcDir:=Folder("Macintosh HD:Users:ble:Documents:Projets:BaseRef_v20:upd_component:test:upd_test.4dbase"; fk platform path)
//
//  If (UPD_zip($srcDir; $zipFile))
//
//  End if 
//
//  $zipFile:=File("Macintosh HD:Users:ble:Documents:Projets:BaseRef_v20:upd_component:test:upd_test_new.4dbase.xz"; fk platform path)
//
//  var $options : Object
//  $options:=New object
//  $options.compression:=ZIP Compression XZ
//  $options.level:=8
//  $options.encryption:=ZIP Encryption AES256
//  $options.password:="password"
//  $options.folderOption:=0  // ZIP Ignore invisible files
//
//  If (UPD_zip($srcDir; $zipFile; $options))
//
//  End if 
//
//@see :
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : CREATION : Bruno LEGAY (BLE) - 12/04/2013, 18:50:25 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE($sourceParam : Variant; $archiveParam : Variant; $optionsParam : Object)->$ok : Boolean

ASSERT:C1129(Count parameters:C259>1; "requires 2 parameters")

$ok:=False:C215
var $sourceDir : 4D:C1709.Folder
var $sourceFile : 4D:C1709.File
Case of 
	: (Value type:C1509($sourceParam)=Is text:K8:3)
		// "Macintosh HD:Users:ble:Desktop:"
		Case of 
			: (Test path name:C476($sourceParam)=Is a folder:K24:2)
				$sourceDir:=Folder:C1567($sourceParam; fk platform path:K87:2)
				
			: (Test path name:C476($sourceParam)=Is a document:K24:1)
				$sourceFile:=File:C1566($sourceParam; fk platform path:K87:2)
				
		End case 
		
	: (Value type:C1509($sourceParam)=Is object:K8:27)
		Case of 
			: (OB Instance of:C1731($sourceParam; 4D:C1709.Folder) && ($sourceParam.exists))
				$sourceDir:=$sourceParam
				
			: (OB Instance of:C1731($sourceParam; 4D:C1709.File) && ($sourceParam.exists))
				$sourceFile:=$sourceParam
		End case 
End case 


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

If (($archiveFile#Null:C1517) && (($sourceFile#Null:C1517) || ($sourceDir#Null:C1517)))
	
	var $folderOption : Integer
	$folderOption:=ZIP Ignore invisible files:K91:8
	
	var $zipStructure : Object
	$zipStructure:=New object:C1471
	$zipStructure.compression:=ZIP Compression standard:K91:1
	$zipStructure.level:=6
	$zipStructure.encryption:=ZIP Encryption none:K91:3
	//$zipStructure.password:=""
	//$zipStructure.callback:= // 4D.Function
	
	
	If (Count parameters:C259>2)
		If ($optionsParam#Null:C1517)
			If ($optionsParam.compression#Null:C1517)
				$zipStructure.compression:=$optionsParam.compression
			End if 
			If ($optionsParam.level#Null:C1517)
				$zipStructure.level:=$optionsParam.level
			End if 
			If ($optionsParam.encryption#Null:C1517)
				$zipStructure.encryption:=$optionsParam.encryption
			End if 
			If ($optionsParam.password#Null:C1517)
				$zipStructure.password:=$optionsParam.password
			End if 
			If ($optionsParam.callback#Null:C1517)
				$zipStructure.callback:=$optionsParam.callback
			End if 
			If ($optionsParam.folderOption#Null:C1517)
				$folderOption:=$optionsParam.folderOption
			End if 
		End if 
	End if 
	
	var $zipStructureFileColl : Collection
	$zipStructureFileColl:=New collection:C1472
	
	Case of 
		: (OB Instance of:C1731($sourceDir; 4D:C1709.Folder))
			$zipStructureFileColl.push(New object:C1471("source"; $sourceDir; "option"; $folderOption))
			
		: (OB Instance of:C1731($sourceFile; 4D:C1709.File))
			$zipStructureFileColl.push(New object:C1471("source"; $sourceFile))
			
	End case 
	
	$zipStructure.files:=$zipStructureFileColl
	
	// error handling
	var ERR_errorStack : Collection
	ERR_errorStack:=Null:C1517
	
	var $previousErrorHandler : Text
	$previousErrorHandler:=Method called on error:C704
	ON ERR CALL:C155("ERR_errHdlr")
	
	var $result : Object
	Case of 
		: (($sourceFile#Null:C1517) && ($sourceFile.exists))
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "zip file \""+$sourceFile.platformPath+"\" into archive \""+$archiveFile.platformPath+"\"...")
			$result:=ZIP Create archive:C1640($zipStructure; $archiveFile)  //; $options)
			$ok:=($result.success)
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "zip file \""+$sourceFile.platformPath+"\" into archive \""+$archiveFile.platformPath+"\". ("+JSON Stringify:C1217($result)+")."+Choose:C955($ok; "[OK]"; "[OK]"))
			
		: (($sourceDir#Null:C1517) && ($sourceDir.exists))
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "zip folder \""+$sourceDir.platformPath+"\" into archive \""+$archiveFile.platformPath+"\"...")
			$result:=ZIP Create archive:C1640($zipStructure; $archiveFile)  //; $options)
			$ok:=($result.success)
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "zip folder \""+$sourceDir.platformPath+"\" into archive \""+$archiveFile.platformPath+"\" ("+JSON Stringify:C1217($result)+")."+Choose:C955($ok; "[OK]"; "[OK]"))
			
		Else 
			UPD__moduleDebugDateTimeLine(4; Current method name:C684; "invalid source ($1) "+String:C10($sourceParam))
	End case 
	
	ON ERR CALL:C155($previousErrorHandler)
	
	If ($ok)
		$ok:=(ERR_errorStack=Null:C1517)
	End if 
	
	If (ERR_errorStack#Null:C1517)
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "zip errors : "+JSON Stringify:C1217(ERR_errorStack))
		ERR_errorStack:=Null:C1517
	End if 
	
Else 
	UPD__moduleDebugDateTimeLine(4; Current method name:C684; "invalid archive ($2)")
End if 

