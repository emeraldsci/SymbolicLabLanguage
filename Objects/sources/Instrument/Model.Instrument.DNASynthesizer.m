

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, DNASynthesizer], {
	Description->"Model of a Phosphoramidite Synthesizer that generates DNA/RNA or modified other oligomers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ColumnScale -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Mole],
			Units -> Mole Nano,
			Description -> "A list of synthesis scales for the different types of columns the instrument can work with.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		NominalArgonPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The normal working Argon pressure as indicated by the internal pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalChamberGaugePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The normal working chamber pressure as indicated by the chamber pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalPurgeGaugePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The normal working purge pressure as indicated by the purge pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalAmiditeAndACNGaugePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The normal working amidite/ACN pressure as indicated by the amidite/ACN pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalCapAndActivatorGaugePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The normal working cap/activator pressure as indicated by the cap/activator pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalDeblockAndOxidizerGaugePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The normal working deblock/activator pressure as indicated by the deblock/activator pressure gauge.",
			Category -> "Instrument Specifications"
		},
		MaxColumns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Number of columns the synthesizer can work with in a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		ReagentSets -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The max number of each reagent needed for synthesis on this instrument.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		PhosphoramiditePrimeVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume used to prime the phosphoramidite lines.",
			Category -> "Instrument Specifications"
		},
		ReagentPrimeVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume used to prime the reagent lines.",
			Category -> "Instrument Specifications"
		},
		PhosphoramiditeDeadVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume of phosphoramidite that is inaccessible by the instrument.",
			Category -> "Instrument Specifications"
		},
		ReagentDeadVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume of reagent that is inaccessible by the instrument.",
			Category -> "Instrument Specifications"
		},
		MaxModifications -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The maximum number of reagent positions for modifications that the instrument can hold.",
			Category -> "Operating Limits"
		},
		MinArgonPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The minimum allowable Argon pressure as indicated by the internal pressure gauge.",
			Category -> "Operating Limits"
		},
		MaxArgonPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum allowable Argon pressure as indicated by the internal pressure gauge.",
			Category -> "Operating Limits"
		},
		ValveMapping -> {
			Format -> Multiple,
			Class ->{Expression, String, String},
			Pattern :>{LocationPositionP, _String, _String},
			Headers -> {"Deck Position","Banks","Valve"},
			Description -> "A list of positions on the DNA synthesizer deck and their corresponding valves.",
			Category -> "Operating Limits"
		}
}
}];
