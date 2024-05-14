(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, CrimpingJig], {
	Description->"A model of a part that is used to position a covered container with the head of an Object[Instrument,Crimper] for optimum alignment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		VialHeight->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The height of vial for which this jig is intended. Used in conjunction with footprint to determine compatibility.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		VialFootprint->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "The footprint of vial for which this jig is intended. Used in conjunction with height to determine compatibility.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];
