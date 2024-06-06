//%attributes = {"invisible":true,"shared":false}

//================================================================================
//@xdoc-start : en
//@name : UPD__4DLinkBuild
//@scope : public
//@deprecated : no
//@description : This function creates a 4DLink file with structure path and data path
//@parameter[1-IN-paramName-TEXT] : 4DLink file path
//@parameter[2-IN-paramName-TEXT] : structure path (full path)
//@parameter[3-IN-paramName-TEXT] : data path (full path)
//@notes : (the file will be overwiten if it already exists)
//@example : UPD__4DLinkBuild 
//@see :
//@version : 1.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : CREATION : Bruno LEGAY (BLE) - 12/04/2013, 18:28:13 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE($4dLinkFile : 4D:C1709.File; $structurePathParam : 4D:C1709.File; $dataPathParam : 4D:C1709.File)

//open -a /Applications/dev/4D/4D\ v12/4D\ v12.5/4D.app  /Users/ble/Documents/Projets/BaseRef_v12/updater/source/test.4dlink

var $nbParam : Integer
$nbParam:=Count parameters:C259
If ($nbParam>0)
	
	var $structurePath; $dataPath : 4D:C1709.File
	
	Case of 
		: ($nbParam=1)
			$structurePath:=File:C1566(Structure file:C489(*); fk platform path:K87:2)  //base hôte
			$dataPath:=File:C1566(Data file:C490; fk platform path:K87:2)
			
		: ($nbParam=2)
			$structurePath:=$structurePathParam
			$dataPath:=File:C1566(Data file:C490; fk platform path:K87:2)
			
		Else 
			//: ($vl_nbParam=3)
			$structurePath:=$structurePathParam
			$dataPath:=$dataPathParam
	End case 
	
	If ($4dLinkFile.exists)
		$4dLinkFile.delete()
	End if 
	
	var $domRootRef : Text
	$domRootRef:=DOM Create XML Ref:C861("database_shortcut")
	If (ok=1)
		
		var $encoding : Text
		$encoding:="UTF-8"
		
		var $standalone; $indent : Boolean
		$standalone:=True:C214
		$indent:=False:C215
		
		DOM SET XML DECLARATION:C859($domRootRef; $encoding; $standalone; False:C215)
		
		//    is_remote             : tells if 4D connect to remote database or open local database
		//    user_name             : user name
		//    password              : password
		//    md5_password          : encrypted password
		//    structure_opening_mode: 0 -> normal
		//                            1 -> interpreted
		//                            2 -> compiled
		//
		//  - the following attributs are valid only if "is_remote" is true.
		//
		//    server_database_name  : server database name without extension
		//    server_path           : coulde be IP adresse or dns
		//         : if true open user login dialog
		//
		//  - the following attributs are valid only if "is_remote" is false.
		//
		//    open_in_custom_mode    : open database in custom mode
		//    open_tools             : open MSC dialog
		//    create_structure_file  : tells if 4D create or open structure file
		//    structure_file         : structure file path
		//    create_data_file       : tells if 4D create or open data file
		//    data_file              : data file path
		//    skip_onstartup_method  : skip OnStartup method
		//    definition_import_file : definition import file path
		//    resources_import_file  : resources import file path
		//    data_opening_mode      : 1 -> default data file
		//                             2 -> select other data file
		//                             3 -> create new data file
		//    data_conversion_mode   : 0 -> display data conversion dialog
		//                             1 -> not display data conversion dialog, no data conversion
		//                             2 -> convert data without displaying data conversion dialog
		//    structure_conversion_mode   : 0 -> display structure conversion dialog
		//                                  1 -> not display structure conversion dialog, no structure conversion
		//                                  2 -> convert structure without displaying structure conversion dialog
		
		var $structureFileUrl; $dataFileUrl : Text
		
		If (Is Windows:C1573)
			
			$structureFileUrl:="file:///"+$structurePath.path
			$dataFileUrl:="file:///"+$dataPath.path
			
			//  "file:///C:/4D/Test DB's/contacts/Contacts final/Contacts.4DD"
			
		Else 
			//les espaces ne doivent pas être échappés dans le fichier ".4dlink" - Bruno LEGAY le 22/04/2013
			
			//<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
			//<database_shortcut
			//  data_file="file:///Users/ble/Documents/Projets/myApp/data test/CBC.4DD"
			//  structure_file="file:///Users/ble/Documents/Projets/myApp/app test/myApp.4dbase/myApp.4DB"/>
			
			$structureFileUrl:="file://"+$structurePath.path
			$dataFileUrl:="file://"+$dataPath.path
		End if 
		
		DOM SET XML ATTRIBUTE:C866($domRootRef; "structure_file"; $structureFileUrl)
		DOM SET XML ATTRIBUTE:C866($domRootRef; "data_file"; $dataFileUrl)
		
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "set \"structure_file\" attribute : \""+$structureFileUrl+"\"")
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "set \"data_file\" attribute : \""+$dataFileUrl+"\"")
		
		//DOM ECRIRE ATTRIBUT XML($va_domRootRef;"structure_conversion_mode";"2")
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"data_conversion_mode";"2")
		
		//DOM ECRIRE ATTRIBUT XML($va_domRootRef;"user_name";"")
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"password";"")
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"md5_password";"")
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"structure_opening_mode";"2")   `interpreted
		
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"server_database_name";"")
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"server_path";"")
		
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"skip_onstartup_method";"true")
		
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"open_tools";"true")
		//DOM ECRIRE ATTRIBUT XML($va_domRootReft;"open_in_custom_mode";"true")
		
		DOM EXPORT TO FILE:C862($domRootRef; $4dLinkFile.platformPath)
		
		DOM CLOSE XML:C722($domRootRef)
		UPD__moduleDebugDateTimeLine(4; Current method name:C684; "\""+$4dLinkFile.path+"\" file created")
	End if 
	
End if 

