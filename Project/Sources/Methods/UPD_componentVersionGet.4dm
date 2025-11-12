//%attributes = {"shared":true,"invisible":false}
//================================================================================
//@xdoc-start : en
//@name : UPD_componentVersionGet
//@scope : public
//@deprecated : no
//@description : This function returns the current version of the UPD_Component
//@parameter[0-OUT-componentVersion-TEXT] : component version (i.e. "4.00.01")
//@notes :
//@example : UPD_componentVersionGet 
//@see : 
//@version : 4.00.01
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2024
//@history : 
//  MODIFICATION : Bruno LEGAY (BLE) - 12/11/2025, 21:27:13 - 4.00.01
//   - UPD_onQuit : compress/archive old application
// MODIFICATION : Bruno LEGAY (BLE) - 10/04/2024, 10:14:31 - v4.00.00
//   - 4D v20, project mode
// MODIFICATION : Bruno LEGAY (BLE) - 07/09/2015, 12:01:00 - v1.02.01
//   - added optional parameter "timeout" to UPD_onQuit
// MODIFICATION : Bruno LEGAY (BLE) - 06/09/2015, 06:53:34 - v1.02.00
//   - made UPD_zip and UPD_unzip public
// MODIFICATION : Bruno LEGAY (BLE) - 24/04/2015, 13:51:56 - v1.01.00
//   - Windows (Windows 7+) version
//   - dependencies on PowerShell v2.x+ 
// MODIFICATION : Bruno LEGAY (BLE) - 24/04/2015 - v1.00.03
//  - amélioration gestion espace dans les chemins sur Mac OS X
// MODIFICATION : Bruno LEGAY (BLE) - 24/04/2015 - v1.01.00
//  - amélioration sur le script "update.sh"
// MODIFICATION : Bruno LEGAY (BLE) - 24/04/2015 - v1.01.00
//  - correction des scipts dans update.sh
//  - suppression des messages vocaux (say)
// CREATION : Bruno LEGAY (BLE) - 16/04/2013, 18:30:51 - v1.00.00
//@xdoc-end
//================================================================================

#DECLARE()->$version : Text

//<Modif> Bruno LEGAY (BLE) (12/11/2025)
//   - UPD_onQuit : compress/archive old application
$version:="4.00.01"
//<Modif>

If (False:C215)
	
	//<Modif> Bruno LEGAY (BLE) (10/04/2024)
	//  TODO
	//  DONE
	//   - commandes de chemins de fichiers à remplacer par des commandes File/Folder
	//   - LEP à remplacer par des system worker (code 4D v20+) lorsque possible
	//   - supprimer les variables interprocess et remplacer par du storage
	//   - supprimer le code retrocompatible (le code ne marchera pas avant les version 4D v20).
	//   - 4D v20, project mode
	//   - zip/unzip : remplacer les commandes php par des commandes natives 
	//$version:="4.00.00"
	//<Modif>
	
	//<Modif> Bruno LEGAY (BLE) (07/09/2015)
	//   - added optional parameter "timeout" to UPD_onQuit
	// $vt_version:="1.2.1"
	//<Modif>
	
	//<Modif> Bruno LEGAY (BLE) (06/09/2015)
	// made UPD_zip and UPD_unzip public
	// $vt_version:="1.2.0"
	//<Modif>
	
	//<Modif> Bruno LEGAY (BLE) (23/04/2015)
	// Windows (Windows 7+) version
	// dependencies on PowerShell v2.x+ 
	// $vt_version:="1.1.0"
	//<Modif>
	
	//Bruno LEGAY (BLE) (22/04/13)
	// amélioration gestion espace dans les chemins sur Mac OS X
	//$vt_version:="1.0.3"
	
	//Bruno LEGAY (BLE) (22/04/13)
	// amélioration sur le script "update.sh"
	//$vt_version:="1.0.2"
	
	//Bruno LEGAY (BLE) (19/04/13)
	// correction des scipts dans update.sh
	// suppression des messages vocaux (say)
	//$vt_version:="1.0.1"
	
	
	//Bruno LEGAY (BLE) (16/04/13)
	//$vt_version:="1.0.0"
End if 
