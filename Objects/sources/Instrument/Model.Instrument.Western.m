

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Western], {
	Description->"Model information for a capillary device that runs western-blot like assays.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WesternModeP,
			Description -> "Type of capillary western instrument.",
			Category -> "Instrument Specifications"
		},
		CapillaryCapacity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Maximum number of capillaries that can be loaded into the instrument.",
			Category -> "Operating Limits"
		},
		MaxLoading -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "Maximum mass of total protein lysate that can be loaded into a capillary.",
			Category -> "Operating Limits"
		},
		MinVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Minimum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MinMolecularWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilo*Dalton],
			Units -> Dalton Kilo,
			Description -> "Minimum molecular weight analyte the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMolecularWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilo*Dalton],
			Units -> Dalton Kilo,
			Description -> "Maximum molecular weight analyte the instrument can detect.",
			Category -> "Operating Limits"
		}
	}
}];
