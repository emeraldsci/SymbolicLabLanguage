(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,CapillaryIsoelectricFocusing],{
	Description->"Analytical data collected by a capillary IsoElectric Focusing (cIEF) experiment on samples for electrophoretic separation over a linear pH gradient.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* Method Information *)
		Cartridge->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,ProteinCapillaryElectrophoresisCartridge],
			Description->"The consumable inserted onto the instrument and sequentially loaded with samples for separation and analysis. The cartridge holds a capillary and the anode running buffer.",
			Category -> "General"
		},
		SampleTemperature->{
			Format->Single,
			Class->Expression,
			Pattern:>GreaterP[0*Kelvin],
			Description->"The sample tray temperature at which samples are maintained while awaiting injection.",
			Category -> "General"
		},
		InjectionIndex->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The numeric position indicating when this data was measured for the experiment with respect to the other column primes, sample injections, standard injections, blank injections, and column flushes (e.g. 1 is the first measurement run).",
			Category -> "General",
			Abstract->True
		},
		SampleType->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[Sample,Standard,Blank],
			Description->"Whether this data represents a blank, a standard, or an unknown sample measurement.",
			Category -> "General",
			Abstract->True
		},
		Well->{
			Format->Single,
			Class->Expression,
			Pattern:>WellP,
			Description->"The well in the plate from which the data were collected.",
			Category -> "General"
		},
		Standards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data],
			Description->"Standard data acquired under replicated experimental conditions to this data.",
			Category->"Organizational Information"
		},
		Blanks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data],
			Description->"Data acquired under replicated experimental conditions to this data.",
			Category->"Organizational Information"
		},
		TotalVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"Indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
			Category -> "General",
			Abstract->True
		},
		SampleVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"Indicates the sample volume in the assay tube prior to loading onto AssayContainer. Each tube contains a Sample, an InternalStandard, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
			Category -> "General",
			Abstract->True
		},
		PremadeMasterMixReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the reagent with all required components in sample preparation for capillary IsoelectricFocusing. Premade mastermix contains DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
			Category -> "General",
			Abstract->True
		},
		PremadeMasterMixVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of Premade MasterMix added in TotalVolume sample preparation.",
			Category -> "General",
			Abstract->True
		},
		Ampholytes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the makeup of amphoteric molecules in the mastermix that form the pH gradient.",
			Category -> "General",
			Abstract->True
		},
		AmpholyteVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volumes of amphoteric molecule stocks added to the mastermix.",
			Category -> "General",
			Abstract->True
		},
		IsoelectricPointMarkers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the makeup of IsoelectricPointMarkers in the mastermix that form the pH gradient.",
			Category -> "General",
			Abstract->True
		},
		IsoelectricPointMarkersVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volumes of amphoteric molecule stocks added to the mastermix.",
			Category -> "General",
			Abstract->True
		},
		DenaturationReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the denaturing agent, e.g., Urea or SimpleSol, added to the mastermix to prevent protein precipitation.",
			Category -> "General",
			Abstract->True
		},
		DenaturationReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of the denaturing agent, e.g., Urea or SimpleSol, added to the mastermix to prevent protein precipitation.",
			Category -> "General",
			Abstract->True
		},
		AnodicSpacer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the Acidic ampholyte included in the mastermix.",
			Category -> "General",
			Abstract->True
		},
		AnodicSpacerVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of the Acidic ampholyte included in the mastermix.",
			Category -> "General",
			Abstract->True
		},
		CathodicSpacer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the Basic ampholyte included in the mastermix.",
			Category -> "General",
			Abstract->True
		},
		CathodicSpacerVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of the Basic ampholyte included in the mastermix.",
			Category -> "General",
			Abstract->True
		},
		LoadTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Second,
			Description->"Indicates the time to load samples mixed with mastermix into the capillary by vacuum.",
			Category -> "General",
			Abstract->True
		},
		VoltageDurationProfile->{
			Format->Multiple,
			Class->{Integer,Real},
			Units->{Volt,Minute},
			Pattern:>{GreaterEqualP[0*Volt],GreaterP[0*Minute]},
			Headers->{"Voltage","Time"},
			Description->"Series of voltages and durations to apply onto the capillary for separation for each sample.",
			Category -> "General",
			Abstract->True
		},
		NativeFluorescenceExposureTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Second,
			Description->"Indicates the time to load samples mixed with mastermix into the capillary by vacuum.",
			Category -> "General",
			Abstract->True
		},
		(* Experimental Results *)
		SeparationData->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Pixel,AbsorbanceUnit}],
			Units->{Pixel,AbsorbanceUnit},
			Description->"The electropherogram time lapse of UV Absorbance (A280) vs. position in the capillary over 32 time points in fucosing.",
			Category->"Experimental Results"
		},
		UVAbsorbanceData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Pixel,AbsorbanceUnit}],
			Units->{Pixel,AbsorbanceUnit},
			Description->"The electropherogram of UV Absorbance (A280) vs. position in the capillary.",
			Category->"Experimental Results"
		},
		ProcessedUVAbsorbanceData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Pixel,AbsorbanceUnit}],
			Units->{Pixel,AbsorbanceUnit},
			Description->"The electropherogram of UV Absorbance (A280) vs. position in the capillary as processed by the Compass for iCE software.",
			Category->"Experimental Results"
		},
		UVAbsorbanceBackgroundData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Pixel,AbsorbanceUnit}],
			Units->{Pixel,AbsorbanceUnit},
			Description->"The electropherogram of UV Absorbance background vs. position in the capillary.",
			Category->"Experimental Results"
		},
		FluorescenceData->{
			Format->Multiple,
			Class->{Real,QuantityArray},
			Pattern:>{GreaterP[0Second],QuantityCoordinatesP[{Pixel,RFU}]},
			Units->{Second,{Pixel,RFU}},
			Headers->{"Exposure Time", "Native Fluorescence"},
			Description->"The electropherogram of native fluorescence vs. position in the capillary.",
			Category->"Experimental Results"
		},
		FluorescenceBackgroundData->{
			Format->Multiple,
			Class->{Real,QuantityArray},
			Pattern:>{GreaterP[0Second],QuantityCoordinatesP[{Pixel,RFU}]},
			Units->{Second,{Pixel,RFU}},
			Headers->{"Exposure Time", "Native Fluorescence"},
			Description->"The electropherogram of native fluorescence background vs. position in the capillary.",
			Category->"Experimental Results"
		},
		ProcessedFluorescenceData->{
			Format->Multiple,
			Class->{Real,QuantityArray},
			Pattern:>{GreaterP[0Second],QuantityCoordinatesP[{Pixel,RFU}]},
			Units->{Second,{Pixel,RFU}},
			Headers->{"Exposure Time", "Native Fluorescence"},
			Description->"The electropherogram of native fluorescence background vs. position in the capillary as processed by the Compass for iCE software.",
			Category->"Experimental Results"
		},
		CurrentData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,Milliampere}],
			Units->{Second,Milliampere},
			Description->"The Current vs. time curve of focusing.",
			Category->"Experimental Results"
		},
		VoltageData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,Volt}],
			Units->{Second,Volt},
			Description->"The Voltage vs. time curve of focusing.",
			Category->"Experimental Results",
			Abstract->False
		},
		(* Data Processing *)
		IsoelectricPointData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Pixel,None}],
			Units->{Pixel,None},
			Description->"The electropherogram of pH vs. distance based on internal standards.",
			Category->"Data Processing"
		},
		(* Analysis & Reports *)
		SmoothingAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Smoothing analysis performed on isoelectric focusing data.",
			Category->"Analysis & Reports"
		},
		PeaksAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Peak picking analyses performed on isoelectric focusing data.",
			Category->"Analysis & Reports"
		},
		FitAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Fit analyses performed on isoelectric focusing data.",
			Category->"Analysis & Reports"
		}
	}
}];





