(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Method,FragmentAnalysis], {
	Description->"A reusable set of parameters that describes an AnalysisMethod for the qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size. Each Object[Method,FragmentAnalysis] includes a set of option values either recommended by the Instrument Manufacturer or defined by the user such as recommended reagents (SeparationGel, LoadingBuffer, Ladder, Blank, Marker, PreMarkerRinseBuffer, PreSampleRinseBuffer), as well as specific parameters of the different experiment categories (eg. Sample Preparation, Instrument Preparation, Capillary Equilibration, Pre-Marker Rinse, Marker Injection, Pre-Sample Rinse, Sample Injection, Separation).",
	CreatePrivileges->None,
	Cache->Session,
	Fields ->{

		(*===General===*)
		ManufacturerMethodName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The reference name of the Manufacturer designed method.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TargetAnalyteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalysisAnalyteTypeP,
			Description -> "The desired nucleic acid type (DNA or RNA) of the analytes in the sample that are separated based on fragment size.",
			Category -> "General",
			Abstract -> True
		},
		MinTargetMassConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanogram/Microliter],
			Units -> Nanogram/Microliter,
			Description -> "The lowest desired mass concentration of analyte(s) in the sample (after SampleDilution, if applicable) contained in the sample plate prior to addition of LoadingBuffer.",
			Category -> "General",
			Abstract -> True
		},
		MaxTargetMassConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanogram/Microliter],
			Units -> Nanogram/Microliter,
			Description -> "The highest desired mass concentration of analyte(s) in the sample (after SampleDilution, if applicable) contained in the sample plate prior to addition of LoadingBuffer.",
			Category -> "General",
			Abstract -> True
		},
		MinTargetReadLength -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The desired lowest limit for the number of base pairs or nucleotides of the shortest fragment analyte in the sample.",
			Category -> "General",
			Abstract -> True
		},
		MaxTargetReadLength -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The desired highest limit for the number of base pairs or nucleotides of the longest fragment analyte in the sample.",
			Category -> "General",
			Abstract -> True
		},
		CapillaryArrayLength ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalyzerCapillaryArrayLengthP,
			Description -> "The length (Short or Long) of each capillary in the CapillaryArray that the method is compatible with.",
			Category -> "General",
			Abstract -> True
		},
		AnalysisStrategy ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FragmentAnalysisStrategyP,
			Description -> "The analysis strategy or strategies the method is compatible with.",
			Category -> "General",
			Abstract -> True
		},
		AnalysisMethodAuthor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalysisAuthorP, 
			Description -> "The type of author (Manufacturer or User) for the AnalysisMethod. Methods authored by the Manufacturer have option values that are based on instrument manufacturer recommendations, while methods authored by User have option values specified by ECL User(s).",
			Category -> "Method Saving",
			Abstract -> True
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name included in the method file used by the instrument software that allows data processing with appropriate configurations.",
			Category -> "General"
		},
		(*===Sample Preparation===*)
		TargetSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The desired total volume of sample and SampleDiluent (if applicable) that is contained in the plate prior to addition of the LoadingBuffer and before loading into the instrument.",
			Category -> "Sample Preparation"
		},
		SampleThaw -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample(s) are incubated at a specified SampleThawTemperature for the length of SampleThawTime until visibly liquid.",
			Category -> "Sample Preparation"
		},
		SampleThawTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "Temperature at which the sample(s) are incubated for the length of SampleThawTime until visibly liquid.",
			Category -> "Sample Preparation"
		},
		SampleThawTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Time at which the sample(s) are incubated at a specified SampleThawTemperature until visibly liquid.",
			Category -> "Sample Preparation"
		},
		SampleMaxThawTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Maximum time at which the sample(s) are incubated at a specified SampleThawTemperature until visibly liquid.",
			Category -> "Sample Preparation"
		},
		SampleIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample(s) are equilibrated at a specified SampleIncubationTemperature for the length of SampleIncubationTime before being transferred to the SamplePlate. This incubation step is necessary for RNA samples (eg denaturation) and is not necessary for DNA samples.", (* add description for DNA vs RNA*)
			Category -> "Sample Preparation"
		},
		SampleIncubationTemperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient,GreaterP[-20*Celsius]],
			Description -> "Temperature (Ambient or a specified temperature above -20 Celsius) at which the sample(s) are equilibrated for the length of SampleIncubationTime before being transferred to the SamplePlate. This incubation step is necessary for RNA samples (eg denaturation) and is not necessary for DNA samples.",
			Category -> "Sample Preparation"
		},
		SampleIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Time at which the sample(s) are equilibrated at SampleIncubationTemperature before being transferred to the SamplePlate. This incubation step is necessary for RNA samples (eg denaturation) and is not necessary for DNA samples.",
			Category -> "Sample Preparation"
		},
		SampleTransferSourceTemperature->{
			Format->Single,
			Description->"Temperature (Ambient, Cold (approximately 4 Celsius) or a temperature above -20 Celsius) at which the sample(s) are at during transfer to the SamplePlate.",
			Pattern:>Alternatives[Ambient,Cold,GreaterP[-20*Celsius]],
			Class->Expression,
			Category->"Sample Preparation"
		},
		SampleTransportTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "Temperature at which the sample(s) are kept during transport after incubation and before transfer to the SamplePlate.",
			Category -> "Sample Preparation"
		},
		SampleLoadingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Model[Sample],
			Description -> "The solution added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to loading into the instrument.",
			Category -> "Sample Preparation"
		},
		SampleLoadingBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of LoadingBuffer added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to loading into the instrument.",
			Category -> "Sample Preparation"
		},
		Ladder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution that contain nucleic acids of known lengths used for qualitative or quantitative data analysis. A ladder solution is recommended for each run of the capillary array.",
			Category -> "Sample Preparation"
		},
		LadderVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The desired volume of Ladder that is contained in the plate prior to addition of the LadderLoadingBuffer and before loading into the instrument.",
			Category -> "Sample Preparation"
		},
		LadderThaw -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the ladder(s) are incubated at a specified LadderThawTemperature for the length of LadderThawTime until visibly liquid.",
			Category -> "Sample Preparation"
		},
		LadderThawTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "Temperature at which the ladder(s) are incubated for the length of LadderThawTime until visibly liquid..",
			Category -> "Sample Preparation"
		},
		LadderThawTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Time at which the ladder(s) are incubated at a specified LadderThawTemperature until visibly liquid.",
			Category -> "Sample Preparation"
		},
		LadderMaxThawTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Maximum time at which the ladder(s) are incubated at a specified LadderThawTemperature until visibly liquid.",
			Category -> "Sample Preparation"
		},
		LadderIncubation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the ladder(s) are equilibrated at a specified LadderIncubationTemperature for the length of LadderIncubationTime before being transferred to the SamplePlate. This incubation step is necessary for RNA samples (eg denaturation) and is not necessary for DNA samples.",
			Category -> "Sample Preparation"
		},
		LadderIncubationTemperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient,GreaterP[-20*Celsius]],
			Description -> "Temperature (Ambient or a specified temperature above -20 Celsius) at which the ladder(s) are equilibrated for the length of LadderIncubationTime before being transferred to the SamplePlate. This incubation step is necessary for RNA samples (eg denaturation) and is not necessary for DNA samples.",
			Category -> "Sample Preparation"
		},
		LadderIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Time at which the ladder(s) are equilibrated at LadderIncubationTemperature before being transferred to the SamplePlate. This incubation step is necessary for RNA samples (eg denaturation) and is not necessary for DNA samples.",
			Category -> "Sample Preparation"
		},
		LadderLoading->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[Robotic, Manual],
			Description->"Indicates if the ladder(s) are loaded by a robotic liquid handler or manually into the sample plate.",
			Category -> "Sample Preparation"
		},
		LadderTransferSourceTemperature->{
			Format->Single,
			Description->"Temperature condition (Ambient, Cold (approximately 4 Celsius) or a temperature above -20 Celsius) at which the sample(s) are at during transfer to the SamplePlate.",
			Pattern:>Alternatives[Ambient,Cold,GreaterP[-20*Celsius]],
			Class->Expression,
			Category->"Sample Preparation"
		},
		LadderTransportTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "Temperature at which the ladder(s) are kept during transport after incubation and before transfer to the SamplePlate.",
			Category -> "Sample Preparation"
		},
		LadderLoadingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Model[Sample],
			Description -> "The solution added to the Ladder(s), to either add markers to (Quantitative) or further dilute (Qualitative) the ladder prior to loading into the instrument.",
			Category -> "Sample Preparation"
		},
		LadderLoadingBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of LoadingBuffer added to the ladder(s), to either add markers to (Quantitative) or further dilute (Qualitative) the ladder(s) prior to loading into the instrument.",
			Category -> "Sample Preparation"
		},
		Blank -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution that is dispensed in the wells required to be filled that is not filled by a sample or a ladder. For example, for a run using NumberOfCapillaries of 96, if there are only 79 samples and 1 ladder, 16 wells are filled with the Blank.",
			Category -> "Sample Preparation"
		},
		SamplePlateTransferDestinationTemperature -> {
			Format -> Single,
			Pattern:>Alternatives[Ambient,Cold,GreaterP[-20*Celsius]],
			Class->Expression,
			Description -> "Temperature condition (Ambient, Cold (approximately 4 Celsius) or a temperature above -20 Celsius) at which the SamplePlate is at during transfer of sample(s) and ladder(s) into the SamplePlate.",
			Category -> "Sample Preparation"
		},
		SamplePlateTransportTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "Temperature at which the SamplePlate is kept during transport after preparation and before loading into the instrument.",
			Category -> "Sample Preparation"
		},
		RNaseFreeTechnique -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if preparation of the SamplePlate uses RNaseFreeTechnique.",
			Category -> "Sample Preparation"
		},
		(*===Capillary Conditioning===*)
		SeparationGel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The gel reagent that serves as sieving matrix to facilitate the optimal separation of the analyte fragments in each sample by size.",
			Category -> "Capillary Conditioning"
		},
		Dye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution of a dye molecule that fluoresces when bound to DNA or RNA fragments in the sample and is used in the detection of the analyte fragments as it passes through the detection window of the capillary.",
			Category -> "Capillary Conditioning"
		},
		ConditioningSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution used in the priming of the capillaries prior to a sample run. The conditioning step helps maintain the low and reproducible electroosmotic flow for more precise analyte mobilities and migration times by stabilizing buffer pH and background electrolyte levels.",
			Category -> "Capillary Conditioning"
		},
		(*===Capillary Equilibration*)
		CapillaryEquilibration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an EquilibrationVoltage is ran through the capillaries over an EquilibrationTime period while the needles are immersed in the RunningBufferPlate prior to any injections. This serves to prepare the gel inside the capillaries for the separation condition and normalize the electroosmotic flow for more precise analyte mobilities and migration times.",
			Category -> "Capillary Equilibration"
		},
		SampleRunningBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments in a sample solution. The RunningBufferSolution is running through the capillaries during the Capillary Equilibration and Sample Separation steps.",
			Category -> "Capillary Equilibration"
		},
		LadderRunningBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer solution index matched to a ladder that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments in a ladder solution. The RunningBufferSolution is running through the capillaries during the Capillary Equilibration and Sample Separation steps.",
			Category -> "Capillary Equilibration"
		},
		BlankRunningBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments in a blank solution. The RunningBufferSolution is running through the capillaries during the Capillary Equilibration and Sample Separation steps.",
			Category -> "Capillary Equilibration"
		},
		EquilibrationVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The electric potential applied across the capillaries over an EquilibrationTime period while the needles are immersed in the RunningBufferPlate prior to any injections. This serves to prepare the gel inside the capillaries for the separation condition and normalize the electroosmotic flow for more precise analyte mobilities and migration times.",
			Category -> "Capillary Equilibration"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The duration for which the EquilibrationVoltage is applied across the capillaries while the needles are immersed in the RunningBufferPlate prior to any injections. This serves to prepare the gel inside the capillaries for the separation condition and normalize the electroosmotic flow for more precise analyte mobilities and migration times.",
			Category -> "Capillary Equilibration"
		},
		(*===Pre-Marker Rinse===*)
		PreMarkerRinse -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreMarkerRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Marker Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			Category -> "Pre-Marker Rinse"
		},
		NumberOfPreMarkerRinses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of dips of the capillary tips in and out of the PreMarkerRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Marker Rinse Plate prior to MarkerInjection in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			Category -> "Pre-Marker Rinse"
		},
		PreMarkerRinseBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer solution that is used to rinse the capillary tips by dipping them in and out of the PreMarkerRinseBuffer contained in the wells of the Pre-Marker Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			Category -> "Pre-Marker Rinse"
		},

		(*===Marker Injection===*)
		MarkerInjection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if injection of markers into the capillaries is performed prior to a sample run. This is only applicable if the LoadingBuffer does not contain markers.",
			Category -> "Marker Injection"
		},
		SampleMarker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution that runs with a sample solution and contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter of solution is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
			Category -> "Marker Injection"
		},
		LadderMarker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution that runs with a ladder solution and contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter of markers is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
			Category -> "Marker Injection"
		},
		BlankMarker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution that runs with a blank solution and contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter of markers is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
			Category -> "Marker Injection"
		},
		MarkerInjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The duration an electric potential (VoltageInjection) is applied across the capillaries to drive the markers into the capillaries. While a short InjectionTime is ideal since this in effect results in a small sample zone and reduces band broadening, a longer InjectionTime can serve to minimize voltage or pressure variability during injection.",
			Category -> "Marker Injection"
		},
		MarkerInjectionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The electric potential applied across the capillaries to drive the markers forward into the capillaries, from the MarkerPlate to the capillary inlet, during the MarkerInjection step.",
			Category -> "Marker Injection"
		},
		(*===Pre-Sample Rinse===*)
		PreSampleRinse -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreSampleRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Sample Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the SampleInjection step.",
			Category -> "Pre-Sample Rinse"
		},
		NumberOfPreSampleRinses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "The number of dips of the capillary tips in and out of the PreSampleRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Sample Rinse Plate prior to SampleInjection in order to wash off any previous reagents the capillaries may have come in contact with.",
			Category -> "Pre-Sample Rinse"
		},
		PreSampleRinseBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer solution that is used to rinse capillary tips by dipping them in and out of the PreSampleRinseBuffer contained in the wells of the Pre-Sample Rinse Plate.",
			Category -> "Pre-Sample Rinse"
		},
		(*===Sample Injection===*)
		SampleInjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The duration a electric potential (VoltageInjection) or pressure (PressureInjection) is applied across the capillaries to drive the samples and ladders into the capillaries. A short InjectionTime is results in a small sample zone and reduces band broadening but can also result in insufficient sample uptake. While a longer InjectionTime increases band broadening but has higher sample uptake and can serve to minimize voltage or pressure variability during injection.",
			Category -> "Sample Injection"
		},
		SampleInjectionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The electric potential applied across the capillaries to drive the samples or ladders forward into the capillaries, from the Sample Plate to the capillary inlet, during the SampleInjection step.",
			Category -> "Sample Injection"
		},
		(*===Separation===*)
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The duration for which the SeparationVoltage is applied across the capillaries in order for migration of analytes to occur. There should be sufficient SeparationTime for the analytes to migrate from the capillary inlet end to the capillary outlet end for a complete analysis.",
			Category -> "Separation"
		},
		SeparationVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The electric potential applied across the capillaries as the sample analytes migrate through the capillaries during the sample run.",
			Category -> "Separation"
		}


	}
}];
