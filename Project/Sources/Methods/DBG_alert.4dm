//%attributes = {"invisible":true,"shared":false}

#DECLARE($alertMsg : Text)

ASSERT:C1129(Count parameters:C259>0; "requires 1 parameter")

If (Length:C16($alertMsg)>0)
	ALERT:C41($alertMsg)
End if 



