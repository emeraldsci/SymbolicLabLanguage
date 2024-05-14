(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing, AspirationCap], {
	(* Note that this field has been deprecated and migrated to Model[Item,Cap] *)
	Description->"A multiport aspiration cap that can be used to interface instruments with source vessels.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		AspirationTubeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The length of the tubing used to aspirate liquid from a container to which this cap is attached, measured from the end of the tubing to the point where the tubing attaches to the cap.",
			Category -> "Dimensions & Positions"
		}
	}
}];
