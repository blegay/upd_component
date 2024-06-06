//%attributes = {"invisible":true}
//TABLEAU TEXTE($tt_methodNameList;0)
//
//
//  //XDOC_methodListGet (->$tt_methodNameList)
//
//EXECUTER METHODE("XDOC_methodListGet";*;->$tt_methodNameList)
//
//C_TEXTE($vt_methodName)
//C_ENTIER LONG($i)
//Boucle ($i;1;Taille tableau($tt_methodNameList))
//$vt_methodName:=$tt_methodNameList{$i}
//
//Si ($vt_methodName="UPD_@")
//  //XDOC_generateCommentForMethod ($vt_methodName)
//EXECUTER METHODE("XDOC_generateCommentForMethod";*;$vt_methodName)
//Fin de si 
//
//Fin de boucle 
//
//TABLEAU TEXTE($tt_methodNameList;0)
//BEEP
//
