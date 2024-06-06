//%attributes = {"invisible":true}
//
//C_TEXTE($vt_appMakePath)
//$vt_appMakePath:=Dossier 4D(Dossier base)+"Preferences"+Séparateur dossier+"BuildApp"+Séparateur dossier+"BuildApp.xml"
//
//Si (Tester chemin acces($vt_appMakePath)=Est un document)
//GENERER APPLICATION($vt_appMakePath)
//
//C_TEXTE($vt_cmd;$vt_in;$vt_out;$vt_err)
//  //$vt_cmd:="/bin/cp -fR /Users/ble/Documents/Projets/BaseRef_v12/updater/build/Components/updater.4dbase /Users/ble/Documents/Projets/BaseRef_v12/updater/test_target_old/updater_test.4dbase/Components/"
//  //LANCER PROCESS EXTERNE($vt_cmd;$vt_in;$vt_out;$vt_err)
//  //
//$vt_cmd:="/bin/cp -fR /Users/ble/Documents/Projets/BaseRef_v12/updater/build/Components/updater.4dbase /Users/ble/Documents/Projets/BaseRef_v12/updater/test_update/updater_test.4dbase/Components/"
//LANCER PROCESS EXTERNE($vt_cmd;$vt_in;$vt_out;$vt_err)
//BEEP
//
//Sinon 
//ALERTE("\""+$vt_appMakePath+"\" n'est pas accessible")
//Fin de si 
