

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Model[Container, Box], {
	Description->"A model of a box in which samples are shipped.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli,Meter Milli},
			Headers -> {"Width","Depth","Height"},
			Description -> "Interior size of the box.",
			Category -> "Dimensions & Positions"
		},
		PermanentStorage  -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the model box has sufficient storage density to be used as a compact long term storage solution. Items in PermanentStorage boxes can be stored in these boxes, while items in non-PermanentStorage boxes must be removed from the box during Storage, StoreAll, and ProcessingStorage tasks.",
			Category -> "Operating Limits"
		}
	}
}];
