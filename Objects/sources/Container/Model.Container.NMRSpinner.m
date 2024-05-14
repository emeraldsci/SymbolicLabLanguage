(* ::Package:: *)

DefineObjectType[Model[Container, NMRSpinner], {
	Description -> "Model information for a container to hold an NMR tube so as to center the sample in the coil.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		TubeDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Millimeter],
			Units -> Millimeter,
			Description -> "The NMR tube diameters that this model of spinner can be used to hold.",
			Category -> "Dimensions & Positions"
		},
		(* Note: the following field only exists because these become the contents of NMR tubes for the sake of barcode scanning *)
		TransportWarmed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature that containers of this model should be incubated at while transported between instruments during experimentation.",
			Category -> "Storage Information"
		}
	}
}];
