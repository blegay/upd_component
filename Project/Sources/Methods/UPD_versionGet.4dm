//%attributes = {"shared":true,"invisible":false}

//================================================================================
//@xdoc-start : en
//@name : UPD_versionGet
//@scope : public
//@deprecated : yes
//@description : This function returns the current version of the UPD_Component
//@parameter[0-OUT-componentVersion-TEXT] : component version (i.e. "4.00.00")
//@notes :
//@example : UPD_versionGet 
//@see : UPD_componentVersionGet
//@version : 4.00.00
//@author : Bruno LEGAY (BLE) - Copyrights A&C Consulting - 2015
//@history : 
//@xdoc-end
//================================================================================

#DECLARE()->$version : Text

$version:=UPD_componentVersionGet
