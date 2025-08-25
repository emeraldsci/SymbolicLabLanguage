(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* Object[Part,CapillaryArray] *)


DefineObjectType[Object[Part, CapillaryArray], {
	Description -> "The ordered bundle (array) of extremely thin, hollow tubes (capillaries) that is used by Object[Instrument,FragmentAnalyzer] for analyte separation in ExperimentFragmentAnalysis.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {

		Instrument-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Object[Instrument,FragmentAnalyzer][CapillaryArray],
			Description -> "The array-based capillary electrophoresis instrument(s) that the CapillaryArray is connected to for use in the parallel qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size.",
			Category -> "Part Specifications",
            Abstract-> True
		},
        NumberOfCapillaries -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfCapillaries]],
            Pattern :> FragmentAnalyzerNumberOfCapillariesP,
            Description -> "Indicates the number of ordered extremely thin, hollow tubes (capillaries) that make up the bundle in the CapillaryArray. This determines the maximum number of samples ran in parallel in a single injection, including a ladder sample which is recommended for every run.",
            Category -> "Part Specifications",
            Abstract -> True
        },
		CapillaryArrayLength-> {
			Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],CapillaryArrayLength]],
			Pattern :> FragmentAnalyzerCapillaryArrayLengthP,
			Description -> "The length (Short or Long) of each capillary in the CapillaryArray. For a Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 33 Centimeter, while the length from the sample inlet end until the outlet end to the reservoir (TotalLength) is 55 Centimeter. For a Long capillary array, the length from the sample inlet end up to the detector window (EffectiveLength) is 55 Centimeter, while the length from the sample inlet end up to the outlet end to the reservoir (TotalLength) is 80 Centimeter.",
            (*When Model[Instrument, FragmentAnalyzer, "FragmentAnalyzer 5200"] is made available, add: For an Ultra-Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 22 Centimeter, while the length from the sample inlet end until the outlet end (TotalLength) is 47 Centimeter.*)
			Category -> "Part Specifications",
			Abstract-> True
		},
        EffectiveLength -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],EffectiveLength]],
            Pattern :> GreaterP[0*Centimeter],
            Description -> "The length span of each capillary from the sample inlet end until the detector window. See Figure XXX.",
            Category -> "Part Specifications"
        },
        TotalLength -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],TotalLength]],
            Pattern :> GreaterP[0*Centimeter],
            Description -> "The length span of each capillary from the sample inlet end until the outlet end that connects to the reservoir.",
            Category -> "Part Specifications"
        },
        InnerDiameter -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],Diameter]],
            Pattern :> GreaterP[0*Micrometer],
            Description -> "The width of the bore through the center of the capillary through which samples travel through during separation.",
            Category -> "Part Specifications"
        },
        MinpH -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MinpH]],
            Pattern :> RangeP[0, 14],
            Description -> "The minimum pH (or highest acidity) of a medium or analyte that the inner coating of the capillary can contain without being damaged thereby ruining a separation.",
            Category -> "Operating Limits"
        },
        MaxpH -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxpH]],
            Pattern :> RangeP[0, 14],
            Description -> "The maximum pH (or highest alkalinity) of a medium or analyte that the inner coating of the capillary can contain without being damaged thereby ruining a separation.",
            Category -> "Operating Limits"
        },
        MinVoltage -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVoltage]],
            Pattern :> GreaterP[0*Kilovolt],
            Description -> "The minimum voltage that can be applied across the capillaries in the course of the experiment.",
            Category -> "Operating Limits"
        },
        MaxVoltage -> {
            Format -> Computable,
            Expression -> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVoltage]],
            Pattern :> GreaterP[0*Kilovolt],
            Description -> "The maximum voltage that can be applied across the capillaries in the course of the experiment.",
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
		CloggedChannels ->{
			Format->Multiple,
			Class->String,
			Pattern:>WellP,
			Description->"The list of channels that are clogged as identified by the most recent FlushCapillaryArray maintenance performed on the instrument.",
			Category->"General",
			Developer->True
		}
  }
}];
