(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, FluorescenceThermodynamics], {
	Description->"Measurements of fluorescence at specific wavelengths across varying temperatures, such as in melting and cooling curves.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "Excitation wavelength used in the experiment.",
			Category -> "General",
			Abstract -> True
		},
		ExcitationBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the excitation wavelength that the excitation filter will allow to pass through at 50% of the maximum transmission.",
			Category -> "General"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "Emission wavelength used in the experiment.",
			Category -> "General",
			Abstract -> True
		},
		EmissionBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the emission wavelength that the emission filter will allow to pass through at 50% of the maximum transmission.",
			Category -> "General"
		},
		Reporter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Reporter dye employed in the experiment and used to readout fluorescence levels.",
			Category -> "General"
		},
		Quencher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Quencher dye employed in the experiment and used to dampen fluorescence.",
			Category -> "General"
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The model of buffer used in the experiment.",
			Category -> "General"
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate],
			Description -> "The model of the plate containing the samples used in the experiment.",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "Well in the plate that the data is taken from.",
			Category -> "General",
			Abstract -> True
		},
		MeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,RFU}],
			Units -> {Celsius, RFU},
			Description -> "The recorded fluorescence signal as a function of rising temperature that has already been normalized by the PassiveReference (if one was used).",
			Category -> "Experimental Results"
		},
		CoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,RFU}],
			Units -> {Celsius, RFU},
			Description -> "The recorded fluorescence signal as a function of decreasing temperature that has already been normalized by the PassiveReference (if one was used).",
			Category -> "Experimental Results"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FluorescenceThermodynamicsDataP,
			Description -> "Indicates if this data represents an Analyte or a Passive Reference.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		RawMeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,RFU}],
			Units -> {Celsius, RFU},
			Description -> "The initial recorded fluorescence signal as a function of rising temperature before any normalization.",
			Category -> "Data Processing"
		},
		RawCoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,RFU}],
			Units -> {Celsius, RFU},
			Description -> "The initial recorded fluorescence signal as a function of decreasing temperature before any normalization.",
			Category -> "Data Processing"
		},
		PassiveReference -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, FluorescenceThermodynamics][Analytes],
			Description -> "Data from an inert dye that provides a constant fluorescent signal for normalization purposes.",
			Category -> "Experimental Results"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, FluorescenceThermodynamics][PassiveReference],
			Description -> "The analyte data objects which rely on this object's data for their passive reference.",
			Category -> "Experimental Results"
		},
		MeltingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Melting point analysis done on this data (and its replicates).",
			Category -> "Analysis & Reports"
		},
		Simulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Simulation, MeltingCurve][ExperimentalData],
			Description -> "Thermodynamic simulations for similar inputs and conditions as this data.",
			Category -> "Experiments & Simulations"
		}
	}
}];
