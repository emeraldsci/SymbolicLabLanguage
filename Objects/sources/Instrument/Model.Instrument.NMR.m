

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, NMR], {
	Description->"A model for nuclear magentic resonance instruments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ResonanceFrequency -> {
			Format -> Multiple,
			Class -> {Nucleus -> String, Frequency -> Real},
			Pattern :> {Nucleus -> NucleusP, Frequency -> GreaterP[0*Megahertz]},
			Units -> {Nucleus -> None, Frequency -> Megahertz},
			Headers -> {Nucleus -> "Nucleus", Frequency -> "Resonance Frequency"},
			Description -> "The resonance frequency of each nucleus for this model of NMR instrument.",
			Category -> "Instrument Specifications"
		},
		MagnetStrength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Tesla],
			Units -> Tesla,
			Description -> "The strength of the magnet used in this model of NMR to obtain spectra.",
			Category  -> "Instrument Specifications"
		},
		BoreDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the opening into which the sample loaded in an NMR tube and spinner is inserted.",
			Category -> "Dimensions & Positions"
		}
	}
}];
