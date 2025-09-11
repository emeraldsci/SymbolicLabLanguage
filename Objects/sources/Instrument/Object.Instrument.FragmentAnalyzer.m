(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* Object[Instrument,FragmentAnalyzer] *)


DefineObjectType[Object[Instrument, FragmentAnalyzer], {
	Description->"The array-based capillary electrophoresis instrument used for parallel qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size. A strong electric field (electrophoresis) is applied across an extremely thin, hollow tube (a capillary) containing a porous medium (gel solution) and facilitates the size-dependent migration of analytes in the sample. Depending on the attached CapillaryArray part, the analysis of either 12-, 48- or 96- samples in a single, parallel run can be performed and allows for high- to ultra-high throughput workflows.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		SupportedNumberOfCapillaries-> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],SupportedNumberOfCapillaries]],
			Pattern :> FragmentAnalyzerNumberOfCapillariesP,
			Description -> "The number of capillaries per capillary array that the instrument can support. Determines the maximum number of samples ran in parallel in a single injection, including a ladder sample which is recommended for every run.",
			Category -> "Instrument Specifications",
			Abstract-> True
		},
		SupportedCapillaryArrayLength-> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],SupportedCapillaryArrayLength]],
			Pattern :> FragmentAnalyzerCapillaryArrayLengthP,
			Description -> "The length (Short or Long) of CapillaryArray part that the instrument can support. For a Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 33 Centimeter, while the length from the sample inlet end until the outlet end to the reservoir (TotalLength) is 55 Centimeter. For a Long capillary array, the length from the sample inlet end up to the detector window (EffectiveLength) is 55 Centimeter, while the length from the sample inlet end up to the outlet end to the reservoir (TotalLength) is 80 Centimeter.",
			(*When Model[Instrument, FragmentAnalyzer, "FragmentAnalyzer 5200"] is made available, add: For an Ultra-Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 22 Centimeter, while the length from the sample inlet end until the outlet end (TotalLength) is 47 Centimeter.*)
			Category -> "Instrument Specifications",
			Abstract-> True
		},
		CapillaryArray-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, CapillaryArray][Instrument],
			Description -> "The attached ordered bundle of extremely thin, hollow tubes (capillary array) that is used by the instrument for analyte separation.",
			Category -> "Instrument Specifications"
		},
		ExcitationSource -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],ExcitationSource]],
			Pattern :> LampTypeP,
			Description -> "The light source available to excite and probe the dye-bound analytes as they pass across the capillary array detection window.",
			Category -> "Instrument Specifications"
		},
		MaxExcitationWavelength -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxExcitationWavelength]],
			Pattern :> GreaterP[0*NanoMeter],
			Description -> "The maximum wavelength the instrument uses to excite the dye-bound analytes.",
			Category -> "Instrument Specifications"
		},
		MinEmissionWavelength -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MinEmissionWavelength]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The minimum wavelength at which the fluorescence detector takes emission readings.",
			Category -> "Instrument Specifications"
		},
		MaxEmissionWavelength -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxEmissionWavelength]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The maximum wavelength at which the fluorescence detector takes emission readings.",
			Category -> "Instrument Specifications"
		},
		MinVoltage -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVoltage]],
			Pattern :> GreaterP[0*Kilovolt],
			Description -> "The minimum voltage that the instrument can generate and run across the capillaries in the course of the experiment.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVoltage]],
			Pattern :> GreaterP[0*Kilovolt],
			Description -> "The maximum voltage that the instrument can generate and run across the capillaries in the course of the experiment.",
			Category -> "Operating Limits"
		},
        MinDestinationPressure -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MinPressure]],
            Pattern :> LessEqualP[0 PSI],
            Description -> "The maximum negative pressure that can be applied at capillaries' destination by the high pressure syringe pump in the instrument. An applied negative pressure at the capillaries' destination causes a fluid movement forward from the Plates (Sample, RunningBuffer, RinseBuffer, Marker, Waste), through the capillary towards the end of the capillary connected to the syringe pump.",
            Category -> "Operating Limits"
        },
        MaxDestinationPressure -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxPressure]],
            Pattern :> GreaterP[0*PSI],
            Description -> "The maximum positive pressure that can be applied at the capillaries' destination by the high pressure syringe pump in the instrument. An applied positive pressure at the capillaries' destination causes a fluid movement backwards from the syringe pump through the capillary, and into the Plates (Sample, RunningBuffer, RinseBuffer, Marker, Waste).",
            Category -> "Operating Limits"
        },
		MinHumidity->{
			Format->Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MinHumidity]],
			Pattern:>GreaterP[0*Percent],
			Description->"The minimum relative humidity at which the instrument can perform operations.",
			Category->"Operating Limits"
		},
		MaxHumidity->{
			Format->Computable,
			Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxHumidity]],
			Pattern:>GreaterP[0*Percent],
			Description->"The maximum relative humidity at which the instrument can perform operations.",
			Category->"Operating Limits"
		},
		WasteLineCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap],
			Description -> "The cap that is attached to the waste line and placed on the WasteContainer placed inside the side compartment of the Instrument.",
			Category -> "Instrument Specifications"
		},
		ConditioningLineCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap],
			Description -> "The cap that is attached to the conditioning line and placed on the ConditioningSolutionContainer or PrimaryCapillaryFlushSolutionContainer placed inside the side compartment of the Instrument.",
			Category -> "Instrument Specifications"
		},
		PrimaryGelLineCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap],
			Description -> "The cap that is attached to the Gel 1 Line and placed on the GelDyeContainer or SecondaryCapillaryFlushSolutionContainer (if applicable) placed inside the side compartment of the Instrument.",
			Category -> "Instrument Specifications"
		},
		SecondaryGelLineCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap],
			Description -> "The cap that is attached to the Gel 2 Line and placed on the TertiaryCapillaryFlushSolutionContainer (if applicable) placed inside the side compartment of the Instrument.",
			Category -> "Instrument Specifications"
		},
		ConditioningLinePlaceholderContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Vessel],
			Description -> "The container vessel that holds the ConditioningLineCap when the instrument is not in use.",
			Category -> "Instrument Specifications"
		},
		PrimaryGelLinePlaceholderContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Vessel],
			Description -> "The container vessel that holds the PrimaryGelLineCap when the instrument is not in use.",
			Category -> "Instrument Specifications"
		},
		SecondaryGelLinePlaceholderContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Vessel],
			Description -> "The container vessel that holds the SecondaryGelLineCap when the instrument is not in use.",
			Category -> "Instrument Specifications"
		},
		CapillaryStorageSolutionPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
			Description -> "The plate that holds the CapillaryStorageSolution and is loaded into the instrument.",
			Category -> "Instrument Specifications"
		},
		RunningBufferPlatePlaceholder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Plate],
			Description -> "The container plate that is inside the RunningBufferPlate Slot when the instrument is not in use.",
			Category -> "Instrument Specifications"
		},
		InstrumentDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path on the instrument computer in which the data generated by the experiment is stored locally.",
			Category -> "Data Processing",
			Developer -> True
		},
		InstrumentBackupDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path on the instrument computer in which a back up copy of the data generated by the experiment is stored locally.",
			Category -> "Data Processing",
			Developer -> True
		},
		InstrumentMethodFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path on the instrument computer that contains the method files used by the software for flush and separation runs.",
			Category -> "Data Processing",
			Developer -> True
		}
	}
}];
