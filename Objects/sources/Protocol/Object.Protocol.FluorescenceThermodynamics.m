

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, FluorescenceThermodynamics], {
	Description->"A protocol to determine thermodynamic properties of samples by measuring fluorescence, often in the presence of external dyes, while varying temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		AssayFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the assay file to be used to run this plate of fluorescence thermodynamics reactions.",
			Category -> "General"
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path where the fluorescence thermodynamics data files are located.",
			Category -> "General"
		},
		Complements -> {
			Format -> Multiple,
			Class -> {Link, Real, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micromolar], GreaterEqualP[0*Micro*Liter]},
			Relation -> {Object[Sample], Null, Null},
			Units -> {None, Micromolar, Liter Micro},
			Description -> "For each member of SamplesIn, the complement sample that will be included in each reaction, target concentration for the complement sample, and the volume of the complement sample.",
			Headers -> {"Complement Sample", "Target Concentration", "Target Volume"},
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		ComplementConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "For each member of SamplesIn, the target concentration of the sample's complement to be used in each reaction.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		ComplementVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of the sample's complement to be used in each reaction.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Buffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SamplesIn, the buffer used in the sample's reaction.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		BufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of buffer used in each reaction.",
			Category -> "Sample Preparation"
		},
		PassiveReference -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The inert dye, whose fluorescence does not change during the reaction, added to each reaction to provide a point of normalization.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		PassiveReferenceVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the passive reference dye to use in each fluorescence thermodynamics reaction.",
			Category -> "Sample Preparation"
		},
		Dye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "A dye that exhibits a change in fluoresence indicative of a thermodynamic transition included in each reaction.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		DyeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of dye used in each fluorescence thermodynamics reaction to monitor the thermodynamic transition.",
			Category -> "Sample Preparation"
		},
		ReactionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume of each fluorescence thermodynamics reaction, including sample, complement sample, buffer, passive reference, and dye.",
			Category -> "Sample Preparation"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The liquid handler instrument used to prepare the thermodynamics reaction mixtures in a plate.",
			Category -> "Sample Preparation"
		},
		LiquidHandlerProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The set of instructions for the liquid handler that will prepare the master mixes and assay plate required for this qPCR experiment.",
			Category -> "Sample Preparation"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "Excitation wavelength of the light used to excite the reaction mixtures.",
			Category -> "Optical Information",
			Abstract -> True
		},
		ExcitationBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the excitation wavelength that the excitation filter will allow to pass through at 50% of the maximum transmission.",
			Category -> "Optical Information"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "Emission wavelength of the fluorescence recorded from the reaction mixtures.",
			Category -> "Optical Information",
			Abstract -> True
		},
		EmissionBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the emission wavelength that the emission filter will allow to pass through at 50% of the maximum transmission.",
			Category -> "Optical Information"
		},
		Thermocycler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The thermocycler instrument used to record fluorescence readings from the reaction plate at various temperatures.",
			Category -> "Thermocycling"
		},
		TemperatureRampOrder -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TemperatureCurveP,
			Description -> "The temperature curves to measure in each cycle.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The high temperature of the melting and cooling curves.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The high temperature of the melting and cooling curves.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		TemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Kelvin)/Second],
			Units -> Celsius/Second,
			Description -> "The rate at which the temperature changes during a melting or cooling curve.",
			Category -> "Thermocycling"
		},
		TemperatureStep -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The change in temperature from one melting or cooling curve step to the next during a step-wise (non-continuous) curve.",
			Category -> "Thermocycling"
		},
		TemperatureStepEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time to hold the temperature at each step in the melting or cooling curve before taking a reading.",
			Category -> "Thermocycling"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time to hold the temperature at the thermocycling endpoints (lowest or highest temperature).",
			Category -> "Thermocycling"
		}
	}
}];
