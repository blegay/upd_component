```4d
// MARK:- initialisation de la mise à jour de l'application (à faire quand on veut)
// 
// on peut appeler ce code quand on veut (ça peut être lancé suite un dialogue affiché à l'utilisateur)
// en client serveur, le code ne fait rien sur le client, il faut le faire tourner sur le serveur.
// ici mettre le dossier de mon "app.4dbase" (ou application enginée) qui va remplacer 
// mon "app.4dbase" (ou application enginée) courante (celle qui execute de code actuel)
// en amont, on aura récupéré l'archive, fait des vérification, décompacté l'archive, etc...
// on peut utiliser les commandes UPD_unzip qui utilise désormais la compression native de 4D
// j'ai un exemle de code qui utilise le dossiert temporaire dans UPD_onStartup
// il faut que l'utilisateur qui fait tourner l'application ai les droits pour supprimer cette application (dossier ou fichier)
// l'opération est effectuée par un script qui est lancé quand on quitte (cf UPD_onQuit).
// le script attend que 4D quitte et effectue la substitution de l'application courante par la nouvelle application.
// ce code est délicat et il faut bien tester les différentes situation (interprété, compilé, enginé, client serveur, ... sur Mac et Windows)
// sinon, cela peut causer un déluge d'appels au support technique...
// il y a du log qui est généré (dans une dossier "LOGS/updater" et dans les logs si le composant DBG est installé)
// pour résumer, si on appelle UPD_onStartup, quand on va quitter, l'application (structure) courante sera mise à jour
// il faut appeler UPD_onQuit quand l'application quitte...
// testé par Bruno LEGAY le 27/04/2024 suite à la migration en 4D v20 (testé avec 4D v20.3 sur macOS avec structure interprétée)
// 
// TODO: il faut que l'application hote utilise l'option Utiliser la méthode "Sur événement base hôte" des composants
// c'est désormais comme ça que mes composants s'initialisent automatiquement...

If (True)  // ici pour le test, j'ai codé en dur, mais dans la vraie vie, bien sûr ce n'est pas comme ça qu'on doit faire
	var $newAppPath : Text
	$newAppPath:="Macintosh HD:Users:ble:Documents:Projets:BaseRef_v20:upd_component:test:upd_test_new.4dbase:"

	UPD_onStartup($newAppPath)

Else   // exemple de code qui pourrait être utilisé (à tester)

	// download new version from somewhere (S3, ftp/sftp, http, github) into a temp dir
	// for instance, call a web service to get an object
	//   - presignedUrl
	//   - archiveFullname
	//   - version
	//   - sha256
	//  - ...

	var $archiveFullname : Text
	$archiveFullname:="newApp_v1_10_49.zip"

	// timestamp compatible wih folder name
	var $timestamp : Text
	$timestamp:=Substring(Timestamp; 1; 19)
	$timestamp:=Replace string($timestamp; "-"; ""; *)
	$timestamp:=Replace string($timestamp; ":"; ""; *)
	// "20240427T164354"

	// create a unique temp dir (e.g. "update_20240427T164354_be799d64dad040ff9444ebd0e05400ab") in temp dir
	// "/var/folders/61/sg995tqx3_n12n2s33kh7y200000gp/T/update_20240427T164354_be799d64dad040ff9444ebd0e05400ab/"
	var $updateTempDir : 4D.Folder
	$updateTempDir:=Folder(Temporary folder; fk platform path).folder("update_"+$timestamp+"_"+Lowercase(Generate UUID))
	$updateTempDir.create()

	// let say that this is the archive file we want to install...
	var $zipFile : 4D.File
	$zipFile:=$updateTempDir.file($archiveFullname)

	// download new version into that file
	// check the archive (md5, sha256 whatever)

	// extract the archive
	If (UPD_unzip($zipFile; $updateTempDir))

		// delete the archive 
		$zipFile.delete()

		// Take the first folder of the unarchived files/folder (ignore invisible folders)
		var $folders : Collection
		$folders:=$updateTempDir.folders(Ignore invisible)
		If ($folders.length>0)
			var $newAppDir : 4D.File
			$newAppDir:=$updateTempDir.folder($folders[0].fullname)

			// replace current app with that folder
			UPD_onStartup($newAppDir)
		Else   // There was no folder in that directory, try to take the first file

			// Take the first file of the unarchived files/folder (ignore invisible files)
			var $files : Collection
			$files:=$updateTempDir.files(Ignore invisible)
			If ($files.length>0)
				var $newAppFile : 4D.File
				$newAppFile:=$updateTempDir.file($files[0].fullname)

				// replace current app with that file
				UPD_onStartup($newAppFile)
			End if 
		End if 

	End if 
End if 

// si on veut voir le fichier de logs :
// DBG_logFileShow
```





```4d
// MARK:- lancer le script de mise à jour de l'application (à faire à la fermeture de l'application)
//
// en client serveur, le code ne fait rien sur le client, il faut le faire tourner sur le serveur.
// si on a appelé UPD_onStartup et que le fichier/dossier de l'application est valide
// on doit appeler UPD_onQuit quand l'application quitte pour s'assurer que la mise à jour sera effectuée.
// il faut que l'utilisateur qui fait tourner l'application ai les droits pour supprimer cette application (dossier ou fichier)
// le script est lancé et attend que l'arret du process system dont PID correspond à l'application courante.
// (dans la limite du timeout) puis il effectuera la substitution de l'application courante par la nouvelle application.
// ce code est délicat et il faut bien tester les différentes situation (interprété, compilé, enginé, client serveur, ... sur Mac et Windows)
// sinon, cela peut causer un déluge d'appels au support technique...
// il y a du log qui est généré (dans une dossier "LOGS/updater" et dans les logs si le composant DBG est installé)
// testé par Bruno LEGAY le 27/04/2024 suite à la migration en 4D v20 (testé avec 4D v20.3 sur macOS avec structure interprétée)
// 

var $relaunch : Boolean
$relaunch:=True

var $timeoutSecs : Integer
$timeoutSecs:=60  // 1 minute

UPD_onQuit($relaunch; $timeoutSecs)
```