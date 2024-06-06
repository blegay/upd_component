//%attributes = {"shared":false,"invisible":true}
//================================================================================
//@xdoc-start : en
//@name : upd__xdocInit
//@scope : private 
//@deprecated : no
//@description : This function inits the xdoc component
//@notes : 
//@example : upd__xdocInit
//@see : 
//@version : 1.00.00
//@author : 
//@history : 
//  CREATION : Bruno LEGAY (BLE) - 10/04/2024, 06:14:15 - 1.00.02
//@xdoc-end
//================================================================================

var $prefixPattern; $version : Text
$prefixPattern:="upd"
$version:=UPD_componentVersionGet

If (Not:C34(Is compiled mode:C492))
	
	ARRAY TEXT:C222($tt_components; 0)
	COMPONENT LIST:C1001($tt_components)
	
	If (Find in array:C230($tt_components; "XDOC_component")>0)
		
		var $compte; $developer : Text
		$compte:=Current system user:C484
		Case of 
			: ($compte="@Bruno@")
				$developer:="Bruno LEGAY (BLE)"
				
			: ($compte="@Joel@")
				$developer:="Joël LACLAVERE (JLA)"
				
			: ($compte="@Jean@")
				$developer:="Jean GRAVELINE (JGR)"
				
			Else 
				$developer:="Bruno LEGAY (BLE)"
		End case 
		
		EXECUTE METHOD:C1007("XDOC_componentPrefixSet"; *; $prefixPattern)
		
		EXECUTE METHOD:C1007("XDOC_authorSet"; *; 1; $developer)
		
		EXECUTE METHOD:C1007("XDOC_authorSet"; *; 2; $developer+" - Copyrights A&C Consulting "+String:C10(Year of:C25(Current date:C33)))
		
		EXECUTE METHOD:C1007("XDOC_versionTagSet"; *; $version)
		
		var $userParamLong : Integer
		var $userParamText : Text
		$userParamLong:=Get database parameter:C643(User param value:K37:94; $userParamText)  // 108
		Case of 
			: ($userParamText="build")
				
				EXECUTE METHOD:C1007("XDOC_build"; *)
				
				QUIT 4D:C291
		End case 
		
	End if 
	
	ARRAY TEXT:C222($tt_components; 0)
End if 