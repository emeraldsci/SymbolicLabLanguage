(* Mathematica package *)

PacletManager`Package`getPacletWithProgress["QuantityUnits"];

If[Internal`$DisableQuantityUnits=!=True,AbortProtect[Catch[Get[ "QuantityUnits`"],"NOGET"]]]