//%attributes = {"shared":false,"invisible":true}

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

var $relaunch : Boolean
$relaunch:=True:C214

var $timeoutSecs : Integer
$timeoutSecs:=60  // 1 minute

UPD_onQuit($relaunch; $timeoutSecs)
