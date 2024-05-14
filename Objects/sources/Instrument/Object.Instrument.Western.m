

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Western], {
	Description->"A western blotting instrument or a western-blot-mimicking capillary device.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> WesternModeP,
			Description -> "Type of capillary western instrument.",
			Category -> "Instrument Specifications"
		},
		CapillaryCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CapillaryCapacity]],
			Pattern :> GreaterP[0, 1],
			Description -> "Maximum number of capillaries that can be loaded into the instrument.",
			Category -> "Operating Limits"
		},
		MaxLoading -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLoading]],
			Pattern :> GreaterP[0*Gram],
			Description -> "Maximum mass of total protein lysate that can be loaded into a capillary.",
			Category -> "Operating Limits"
		},
		MinVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVoltage]],
			Pattern :> GreaterEqualP[0*Volt],
			Description -> "Minimum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "Maximum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MinMolecularWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMolecularWeight]],
			Pattern :> GreaterP[0*Kilo*Dalton],
			Description -> "Minimum molecular weight analyte the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMolecularWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMolecularWeight]],
			Pattern :> GreaterP[0*Kilo*Dalton],
			Description -> "Maximum molecular weight analyte the instrument can detect.",
			Category -> "Operating Limits"
		}
	}
}];
