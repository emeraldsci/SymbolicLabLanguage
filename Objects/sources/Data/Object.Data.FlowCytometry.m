

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Data, FlowCytometry], {
	Description->"Data collected from flow cytometry experiments, a laser-based technology used to count cells, sort cells, detect biomarkers and/or detect protein modifications.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FlowRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RangeP[0.1Microliter/Second,3.5 Microliter/Second]|RangeP[0*Event/Second,100000*Event/Second],
			Description -> "The flow rate at which sample was injected into the cytometer flow path for analysis.",
			Category -> "General"
		},
		TriggerDetector->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The detector used to determine what signals count as an event.",
			Category-> "Method Information"
		},
		TriggerThreshold->{
			Format -> Single,
			Class -> Real,
			Pattern :>RangeP[0.01Percent,100Percent],
			Units -> Percent,
			Description -> "The level of the intensity detected by TriggerDetector must fall above to be classified as an event.",
			Category-> "Method Information"
		},
		SecondaryTriggerDetector->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The additional detector used to determine what signals count as an event.",
			Category-> "Method Information"
		},
		SecondaryTriggerThreshold->{
			Format -> Single,
			Class -> Real,
			Pattern :>RangeP[0.01Percent,100Percent],
			Units -> Percent,
			Description -> "The level of the intensity detected by SecondaryTriggerDetector must fall above to be classified as an event.",
			Category-> "Method Information"
		},
		RunListFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The flow cytometry rlst file which stores the metadata about how the experiment was performed.",
			Category -> "Data Processing"
		},
		Well -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "The well in the source plate from which the sample was drawn to generate these data.",
			Category -> "General",
			Abstract -> True
		},
		Detectors->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The detectors used to detect light scattered off the samples.",
			Category-> "Method Information"
		},
		DetectionLabels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule]
			],
			Description -> "For each member of Detectors, the tag, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be analyzed by the Detectors.",
			Category-> "Method Information",
			IndexMatching -> Detectors
		},
		ExcitationWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FlowCytometryExcitationWavelengthP,
			Description -> "The wavelength(s) that were used to excite fluorescence and scatter off the samples.",
			Category-> "Method Information"
		},
		ExcitationPowers->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>RangeP[0*Milli*Watt,100*Milli*Watt],
			Units -> Milli*Watt,
			Description -> "For each member of ExcitationWavelengths, the power was used to excite fluorescence and scatter off the samples.",
			Category-> "Method Information",
			IndexMatching -> ExcitationWavelengths
		},
		Gains->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :>GreaterEqualP[0Volt],
			Description -> "For each member of Detectors, the voltage the PMT was set to to detect the scattered light off the sample.",
			Category-> "Method Information",
			IndexMatching -> Detectors
		},
		Volume->{
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0Milliliter],
			Units -> Milliliter,
			Description -> "The volume of sample analysed by the flow cytometer during the run.",
			Category-> "Experimental Results"
		},
		Events->{
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0],
			Description -> "The total number of events detected by the flow cytometer during the run.",
			Category-> "Experimental Results"
		},
		CellCount->{
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0Event/Milliliter],
			Units -> Event/Milliliter,
			Description -> "The number of events detected per volume.",
			Category-> "Experimental Results"
		},
		EventTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>GreaterEqualP[0Millisecond],
			Units -> Second,
			Description -> "The times in which each event occurred after data collection started.",
			Category-> "Experimental Results"
		},
		ForwardScatter488Excitation->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the forward scattering signal from a 488nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		ForwardScatter405Excitation->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the forward scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		SideScatter488Excitation->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the side scattering signal from a 488nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence488Excitation525Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 525/35nm fluorescent scattering signal from a 488nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence488Excitation593Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 593/52nm fluorescent scattering signal from a 488nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence488Excitation750Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 750nm long pass fluorescent scattering signal from a 488nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence488Excitation692Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 692/80nm fluorescent scattering signal from a 488nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation750Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 750nm long pass fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation670Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 670/30nm fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation720Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 720/60nm fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation589Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 589/15nm fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation577Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 577/15nm fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation640Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 640/20nm fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence561Excitation615Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 615/24nm fluorescent scattering signal from a 561nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation670Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 670/30nm fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation720Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 720/60nm fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation750Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 750nm long pass fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation460Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 460/22nm fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation420Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 420/10nm fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation615Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 615/24nm fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence405Excitation525Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 525/50nm fluorescent scattering signal from a 405nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence355Excitation525Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 525/50nm fluorescent scattering signal from a 355nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence355Excitation670Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 670/30nm fluorescent scattering signal from a 355nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence355Excitation700Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 700nm long pass fluorescent scattering signal from a 355nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence355Excitation447Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 447/60nm fluorescent scattering signal from a 355nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence355Excitation387Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 387/11nm fluorescent scattering signal from a 355nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence640Excitation720Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 720/60nm fluorescent scattering signal from a 640nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence640Excitation775Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 775/50nm fluorescent scattering signal from a 640nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence640Excitation800Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 800nm long pass fluorescent scattering signal from a 640nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		Fluorescence640Excitation670Emission->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{ArbitraryUnit, ArbitraryUnit Second, Second}..}],
			Units -> {ArbitraryUnit, ArbitraryUnit Second, Second},
			Description->"The height, area and width of the 670/30nm fluorescent scattering signal from a 640nm excitation laser given off by events passing through the laser beam path.",
			Category -> "General"
		},
		FlowCytometryAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of flow cytometry analyses performed on this data object.",
			Category -> "Analysis & Reports"
		}
	}
}];
