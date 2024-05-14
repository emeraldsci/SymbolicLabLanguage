(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* Model[Part,CapillaryArray] *)


DefineObjectType[Model[Part, CapillaryArray], {
	Description -> "Model information for an ordered bundle (array) of extremely thin, hollow tubes (capillaries) that is used by Object[Instrument,FragmentAnalyzer] for analyte separation in ExperimentFragmentAnalysis.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		CompatibleInstrument-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Instrument,FragmentAnalyzer]],
			Relation -> Model[Instrument,FragmentAnalyzer][SupportedCapillaryArray],
			Description -> "The array-based capillary electrophoresis instrument(s) that the CapillaryArray are compatible with for use in the parallel qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size.",
			Category -> "Part Specifications",
            Abstract -> True
		},
        NumberOfCapillaries -> {
            Format -> Single,
            Class -> Integer,
            Pattern :> FragmentAnalyzerNumberOfCapillariesP,
            Description -> "Indicates the number of ordered extremely thin, hollow tubes (capillaries) that make up the bundle in a CapillaryArray. This determines the maximum number of samples ran in parallel in a single injection, including a ladder sample.",
            Category -> "Part Specifications",
            Abstract -> True
        },
		CapillaryArrayLength-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalyzerCapillaryArrayLengthP,
			Description -> "The length (Short or Long) of each capillary in the CapillaryArray. For a Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 33 Centimeter, while the length from the sample inlet end until the outlet end to the reservoir (TotalLength) is 55 Centimeter. For a Long capillary array, the length from the sample inlet end up to the detector window (EffectiveLength) is 55 Centimeter, while the length from the sample inlet end up to the outlet end to the reservoir (TotalLength) is 80 Centimeter.",
            (*When Model[Instrument, FragmentAnalyzer, "FragmentAnalyzer 5200"] is made available, add: For an Ultra-Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 22 Centimeter, while the length from the sample inlet end until the outlet end (TotalLength) is 47 Centimeter.*)
			Category -> "Part Specifications",
			Abstract-> True
		},
        EffectiveLength -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0*Centimeter],
            Units -> Centimeter,
            Description -> "The length span of each capillary from the sample inlet end until the detector window.",
            Category -> "Part Specifications"
        },
        TotalLength -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0*Centimeter],
            Units -> Centimeter,
            Description -> "The length span of each capillary from the sample inlet end until the outlet end that connects to the reservoir.",
            Category -> "Part Specifications"
        },
        InternalDiameter -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0*Micrometer],
            Units -> Micrometer,
            Description -> "The width of the bore through the center of the capillary through which samples travel through during separation.",
            Category -> "Part Specifications"
        },
        MinpH -> {
            Format -> Single,
            Class -> Real,
            Pattern :> RangeP[0, 14],
            Units -> None,
            Description -> "The minimum pH (or highest acidity) of a medium or analyte that the inner coating of the capillary can contain without being damaged.",
            Category -> "Operating Limits"
        },
        MaxpH -> {
            Format -> Single,
            Class -> Real,
            Pattern :> RangeP[0, 14],
            Units -> None,
            Description -> "The maximum pH (or highest alkalinity) of a medium or analyte that the inner coating of the capillary can contain without being damaged.",
            Category -> "Operating Limits"
        },
        MinVoltage -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0*Kilovolt],
            Units -> Kilovolt,
            Description -> "The minimum electric potential that can be applied across the capillaries in the course of the experiment.",
            Category -> "Operating Limits"
        },
        MaxVoltage -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0*Kilovolt],
            Units -> Kilovolt,
            Description -> "The maximum electric potential that can be applied across the capillaries in the course of the experiment.",
            Category -> "Operating Limits"
        },
		MinDestinationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> LessEqualP[0 PSI],
			Units -> PSI,
			Description -> "The maximum negative pressure that can be applied at capillaries' destination by the high pressure syringe pump in the instrument. An applied negative pressure at the capillaries' destination causes a fluid movement forward from the Plates (Sample, RunningBuffer, RinseBuffer, Marker, Waste), through the capillary towards the end of the capillary connected to the syringe pump.",
			Category -> "Operating Limits"
		},
		MaxDestinationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum positive pressure that can be applied at the capillaries' destination by the high pressure syringe pump in the instrument. An applied positive pressure at the capillaries' destination causes a fluid movement backwards from the syringe pump through the capillary, and into the Plates (Sample, RunningBuffer, RinseBuffer, Marker, Waste).",
			Category -> "Operating Limits"
		},
            StorageBuffer -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Sample],
            Description -> "The solution that is used to keep the capillary wet while the capillary is attached to an instrument and in between experiments, or when not attached to an instrument and in storage.",
            Category -> "Storage Information"
        }
  }
}];
