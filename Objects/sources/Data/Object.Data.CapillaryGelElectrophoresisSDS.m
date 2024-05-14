(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,CapillaryGelElectrophoresisSDS],{
	Description->"Analytical data collected by a Capillary gel Electrophoresis-Sodium Dodecyl Sulfate (CESDS) experiment. Raw data represents relative migration times (RMT) of analytes in samples, compared to an internal standard.",
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
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
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
			Pattern:>Alternatives[Sample,Ladder,Standard,Blank],
			Description->"Indicates whether these data represent a ladder, a blank, a standard, or an unknown sample measurement.",
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
		Ladders->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data],
			Description->"Ladder data acquired under the same experimental conditions to this data.",
			Category->"Organizational Information"
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
		SeparationMatrix->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"The sieving matrix loaded onto the capillary before each sample for separation. The mash-like matrix slows the migration of proteins based on their size so that larger proteins migrate slower than smaller ones.",
			Category -> "General"
		},
		TotalVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"Indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a Sample, an InternalStandard, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
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
			Description->"Indicates the reagent with all required components in sample preparation for capillary Gel Electrophoresis SDS. Premade mastermix contains an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
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
		PremadeMasterMixDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the solution used to dilute the premade mastermix in sample preparation for capillary Gel Electrophoresis SDS. Premade mastermix contains an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
			Category -> "General",
			Abstract->True
		},
		Diluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the solution used to dilute components in the mastermix to their working concentration.",
			Category -> "General",
			Abstract->True
		},
		InternalReference->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the internal standard stock solution added in sample preparation. The internal standard stock solution contains the analyte that serves as the reference by which Relative Migration Time is normalized. By default a 10 KDa marker is used.",
			Category -> "General",
			Abstract->True
		},
		InternalReferenceVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of the internal standard stock solution added in TotalVolume sample preparation.",
			Category -> "General",
			Abstract->True
		},
		ConcentratedSDSBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the SDS concentrated solution required for sample preparation. SDS denatures proteins and imparts an equal charge-to-mass ratio to all proteins, facilitating separation exclusively based on size.",
			Category -> "General",
			Abstract->True
		},
		ConcentratedSDSBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of the SDSBuffer concentrated solution added in TotalVolume sample preparation.",
			Category -> "General",
			Abstract->True
		},
		SDSBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the SDS solution required for sample preparation. SDS denatures proteins and imparts an equal charge-to-mass ratio to all proteins, facilitating separation exclusively based on size.",
			Category -> "General",
			Abstract->True
		},
		SDSBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"Indicates the volume of the SDSBuffer solution added in TotalVolume sample preparation.",
			Category -> "General",
			Abstract->True
		},
		ReducingAgent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the chemical stock solution added in sample preparation to break disulfide bridges in proteins.",
			Category -> "General",
			Abstract->True
		},
		ReducingAgentVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"Indicates the volume of the ReducingAgent stock solution added in TotalVolume sample preparation.",
			Category -> "General",
			Abstract->True
		},
		AlkylatingAgent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"Indicates the AlkylatingAgent stock solution added in sample preparation. Alkylation of free cysteines can reduce fragmentation and increase reproducibility in CESDS.",
			Category -> "General",
			Abstract->True
		},
		AlkylatingAgentVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"Indicates the volume of the AlkylatingAgent stock solution added in TotalVolume sample preparation.",
			Category -> "General",
			Abstract->True
		},
		DenaturingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Description->"Indicates the temperature at which proteins are denatured.",
			Category -> "General",
			Abstract->True
		},
		DenaturingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Description->"Indicates the duration of incubation at DenaturingTemperature.",
			Category -> "General",
			Abstract->True
		},
		CoolingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Description->"Indicates the temperature at which proteins are held after denaturation.",
			Category -> "General",
			Abstract->True
		},
		CoolingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Description->"Indicates the duration of incubation at CoolingTemperature.",
			Category -> "General",
			Abstract->True
		},
		InjectionVoltageDurationProfile->{
			Format->Single,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
			Description->"Indicates the series of voltages and durations applied onto the capillary while docked in the sample to electroinject proteins in the sample into the matrix in the capillary.",
			Category -> "General",
			Abstract->True
		},
		SeparationVoltageDurationProfile->{
			Format->Single,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0*Volt],GreaterP[0*Second]}..},
			Description->"Indicates the series of voltages and durations applied onto the capillary while docked in running buffer to seperate proteins by molecular weight as they migrate through the separation matrix in the capillary.",
			Category -> "General",
			Abstract->True
		},
		LadderMolecularWeights->{
			Format->Multiple,
			Class->{Expression,Expression},
			Headers->{"Marker","Molecular Weight / ID"},
			Pattern:>{_String|_Link,GreaterP[0*Kilodalton]|_String},
			Description->"Markers included in ladder and their molecular weight or identification.",
			Category -> "General"
		},
		(* Experimental Results *)
		UVAbsorbanceData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,AbsorbanceUnit}],
			Units->{Second,AbsorbanceUnit},
			Description->"The electropherogram of UV Absorbance (A280) vs. time.",
			Category->"Experimental Results"
		},
		ProcessedUVAbsorbanceData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,AbsorbanceUnit}],
			Units->{Second,AbsorbanceUnit},
			Description->"The electropherogram of UV Absorbance (A280) vs. time as processed by the Compass for iCE software.",
			Category->"Experimental Results"
		},
		UVAbsorbanceBackgroundData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,AbsorbanceUnit}],
			Units->{Second,AbsorbanceUnit},
			Description->"The electropherogram of UV Absorbance background vs. time.",
			Category->"Experimental Results"
		},
		CurrentData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,Milliampere}],
			Units->{Second,Milliampere},
			Description->"The Current vs. time curve of injection and separation.",
			Category->"Experimental Results"
		},
		VoltageData->{
			Format->Single,
			Class->QuantityArray,
			Pattern:>QuantityCoordinatesP[{Second,Volt}],
			Units->{Second,Volt},
			Description->"The Voltage vs. time curve of injection and separation.",
			Category->"Experimental Results"
		},
		(* Data Processing *)
		RelativeMigrationData->{
			Format->Single,
			Class->Compressed,
			Pattern:>CoordinatesP,
			Description->"The electropherogram of UV Absorbance (A280) vs. relative migration time to the InternalStandard. This field is generated by the most recent peak-picking in PeaksAnalyses.",
			Category->"Data Processing"
		},
		(* Analysis & Reports *)
		LadderAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"The molecular weight marker analyses performed on Relative Migration Time data.",
			Category->"Analysis & Reports"
		},
		SmoothingAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Smoothing analysis performed on Relative Migration Time data.",
			Category->"Analysis & Reports"
		},
		PeaksAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Peak picking analyses performed on ProcessedUVAbsorbanceData.",
			Category->"Analysis & Reports"
		},
		RelativeMigrationPeaksAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Peak picking analyses performed on RelativeMigrationData.",
			Category->"Analysis & Reports"
		},
		FitAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Fit analyses performed on Relative Migration Time data.",
			Category->"Analysis & Reports"
		}
	}
}];
