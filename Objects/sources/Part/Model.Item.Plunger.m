(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item,Plunger],{
	Description->"Model information for a cylindrical object used to pack a cartridge with material.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The external diameter of the plunger body.",
			Category -> "Dimensions & Positions"
		}
	}
}];
