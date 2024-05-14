(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, BiosafetyCabinet], {
	Description->"The model of a Laminar flow cabinet to provide isolation of samples within from free circulating air in the room.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BiosafetyLevel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BiosafetyLevelP,
			Description -> "United States Centers for Disease Control and Prevention classification of containment level of the biosafety cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LaminarFlow -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Foot/Minute)],
			Units -> Foot/Minute,
			Description -> "Laminar flow velocity of the cabinet.",
			Category -> "Instrument Specifications"
		},
		Benchtop -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Metal | Epoxy,
			Description -> "Type of material the benchtop is made of.",
			Category -> "Instrument Specifications"
		},
		Plumbing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlumbingP,
			Description -> "List of items plumbed into the cabinet.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the Biosafety cabinet.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
