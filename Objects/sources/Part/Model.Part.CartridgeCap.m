(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,CartridgeCap],{
	Description->"Model information for an adjustable cap to attach solid load cartridges to a flash chromatography instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure under which the cartridge cap can operate when attached to a flash chromatography instrument and solid load cartridge.",
			Category -> "Operating Limits"
		},
		MinBedWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The minimum dry weight of the packing material that can be loaded into cartridges connected to this cartridge cap.",
			Category -> "Physical Properties"
		},
		MaxBedWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The maximum dry weight of the packing material that can be loaded into cartridges connected to this cartridge cap.",
			Category -> "Physical Properties"
		}
	}
}];
