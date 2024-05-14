(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,FragmentAnalysis], {
	Description->"A detailed set of parameters that specifies a single fragment analysis step in a larger protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*===General===*)
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument,FragmentAnalyzer],Model[Instrument,FragmentAnalyzer]],
			Description->"The array-based capillary electrophoresis instrument used for parallel qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size of up to 96 samples in a single run.",
			Category->"General"
		},
		CapillaryArray -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Alternatives[Object[Part,CapillaryArray],Model[Part,CapillaryArray]],
			Description -> "The ordered bundle of extremely thin, hollow tubes (capillary array) that is used by the instrument for analyte separation.",
			Category -> "General"
		},
		CapillaryArrayLength ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalyzerCapillaryArrayLengthP,
			Description -> "The length (Short or Long) of each capillary in the CapillaryArray is used by the instrument for analyte separation.",
			Category -> "General"
		},
		NumberOfCapillaries -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> FragmentAnalyzerNumberOfCapillariesP,
			Description -> "The number of extremely thin, hollow tubes per bundle in the CapillaryArray used in the course of the experiment. Determines the maximum number of samples ran in parallel in a single injection, including a ladder sample which is recommended for every run.",
			Category -> "General"
		},
		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if SamplesIn are in an instrument-compatible plate that contain all other necessary components (LoadingBuffer, Ladder, and Blanks (if applicable)). Solution(s) contained in Position D12 (for 48-capillary array) and Position H12 (for 96-capillary array) are considered Ladders by default unless specified otherwise. All wells should contain a solution of least XX Microliter volume to avoid damage to the capillary array. Prepared plates are directly placed in the sample drawer of the instrument, ready for injection, and does not involve any sample preparation steps.",
			Category -> "General"
		},
		AnalysisMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Object[Method,FragmentAnalysis],
			Description -> "The template AnalysisMethod that indicates a pre-set of option values recommended by the Instrument Manufacturer. If not specified by User, this is initially set according to a selection criteria based on AnalyteType, MassConcentration and ReadLength option field values of the sample.",
			Category -> "General"
		},
		AnalysisStrategy ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FragmentAnalysisStrategyP,
			Description -> "The analysis strategy (Qualitative or Quantitative) the method is compatible with.",
			Category -> "General"
		},
		SampleAnalyteType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FragmentAnalysisAnalyteTypeP,
			Description -> "For each member of SampleLink, the nucleic acid type (DNA or RNA) of the analytes in the sample that are separated based on fragment size.",
			Category -> "General",
			IndexMatching->SampleLink
		},
		MinReadLength -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "For each member of SampleLink, the lowest number of base pairs or nucleotides of the shortest fragment analyte in the sample.",
			Category -> "General",
			IndexMatching->SampleLink
		},
		MaxReadLength -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "For each member of SampleLink, the highest number of base pairs or nucleotides of the shortest fragment analyte in the sample.",
			Category -> "General",
			IndexMatching->SampleLink
		},
		AnalysisMethodName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name that is given to the Method Object that is generated from options specified in the experiment. Note that if no AnalysisMethodName is provided, no new method is saved.",
			Category -> "Method Saving"
		},
		(*===Sample Preparation===*)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The samples that are being analyzed.",
			Category -> "Sample Preparation",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the samples that are being analyzed.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "For each member of SampleLink, the samples that are being analyzed.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "Sample Preparation",
			IndexMatching -> SampleLink
		},
		SampleVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units-> Microliter,
			Description -> "For each member of SampleLink, the total volume of sample and SampleDiluent (if applicable) that is contained in the plate prior to addition of the LoadingBuffer and before loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->SampleLink
		},
		SampleDilution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if SampleDiluent is added to the sample (after aliquoting, if applicable) to reduce the sample concentration prior to addition of the LoadingBuffer and loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->SampleLink
		},
		SampleDiluent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the buffer solution added to the sample to reduce the sample concentration prior to addition of the LoadingBuffer and loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->SampleLink
		},
		SampleDiluentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of buffer solution added to the sample to reduce the sample concentration prior to addition of the LoadingBuffer and loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->SampleLink
		},
		SampleLoadingBuffer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of SampleLink, the solution added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->SampleLink
		},
		SampleLoadingBufferVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of LoadingBuffer added to the sample (after aliquoting, if applicable) to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to mixing (if applicable) and loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->SampleLink
		},
		LadderLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution(s) that contain nucleic acids of known lengths used for qualitative or quantitative data analysis. One ladder solution, which is dispensed to Position H12 (for a 96-capillary array), is recommended for each run of the capillary array. If multiple ladders are specified, each ladder is dispensed on the sample plate starting from Position H12 (for a 96-capillary array) enumerated backward. For example, with a 96-capillary array with 3 specified ladders, the first ladder will be dispensed to Position H12, the second ladder to Position H11 and the third ladder to position H10. If PreparedPlate is True, Ladders are the corresponding sample contained in the indicated WellPosition for the Ladder option.",
			Category -> "Sample Preparation",
			Migration->SplitField
		},
		LadderString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The solution(s) that contain nucleic acids of known lengths used for qualitative or quantitative data analysis. One ladder solution, which is dispensed to Position H12 (for a 96-capillary array), is recommended for each run of the capillary array. If multiple ladders are specified, each ladder is dispensed on the sample plate starting from Position H12 (for a 96-capillary array) enumerated backward. For example, with a 96-capillary array with 3 specified ladders, the first ladder will be dispensed to Position H12, the second ladder to Position H11 and the third ladder to position H10. If PreparedPlate is True, Ladders are the corresponding sample contained in the indicated WellPosition for the Ladder option.",
			Category -> "Sample Preparation",
			Migration->SplitField
		},
		LadderVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units-> Microliter,
			Description -> "For each member of LadderLink, the volume of Ladder that is contained in the plate prior to addition of the LoadingBuffer and before loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->LadderLink
		},
		LadderLoadingBuffer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of LadderLink, the solution added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the ladder prior to loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->LadderLink
		},
		LadderLoadingBufferVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of LadderLink, the volume of LoadingBuffer added to the sample (after aliquoting, if applicable) to either add markers to (Quantitative) or further dilute (Qualitative) the ladder prior to loading into the instrument.",
			Category -> "Sample Preparation",
			IndexMatching->LadderLink
		},
		BlankLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution that is dispensed in the well(s) of the sample plate required to be filled that are not filled by a sample or a ladder. For example, for a run using a 96-capillary array, if there are only 79 samples and 1 ladder, 16 wells are filled with Blanks.). Wells filled with Blanks each contain a volume equal to the total volume of TargetSampleVolume and LoadingBufferVolume of the AnalysisMethod.",
			Category -> "Sample Preparation"
		},
		BlankString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The solution that is dispensed in the well(s) of the sample plate required to be filled that are not filled by a sample or a ladder. For example, for a run using a 96-capillary array, if there are only 79 samples and 1 ladder, 16 wells are filled with Blanks.). Wells filled with Blanks each contain a volume equal to the total volume of TargetSampleVolume and LoadingBufferVolume of the AnalysisMethod.",
			Category -> "Sample Preparation"
		},
 
		(*===Capillary Conditioning===*)
		SeparationGel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The gel reagent that serves as sieving matrix to facilitate the optimal separation of the analyte fragments in each sample by size.",
			Category -> "Capillary Conditioning"
		},
		Dye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution of a dye molecule that fluoresces when bound to DNA or RNA fragments in the sample and is used in the detection of the analyte fragments as it passes through the detection window of the capillary.",
			Category -> "Capillary Conditioning"
		},
		ConditioningSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution used in the priming of the capillaries prior to a sample run. The conditioning step helps maintain a low and reproducible electroosmotic flow for more precise analyte mobilities and migration times by stabilizing buffer pH and background electrolyte levels.",
			Category -> "Capillary Conditioning"
		},

		(*===Optional CapillaryFlush Step===*)
		CapillaryFlush -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an optional CapillaryFlush procedure is performed prior to a sample run. A CapillaryFlush step involves running the conditioning solution  or specified alternative(s) through the capillaries and into a Waste Plate.",
			Category -> "Capillary Flush"
		},
		NumberOfCapillaryFlushes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,3],
			Description -> "The number of CapillaryFlush steps that are performed prior to the sample run, where the specified CapillaryFlushSolution for each step runs through the capillaries and into the Waste Plate.",
			Category -> "Capillary Flush"
		},
		PrimaryCapillaryFlushSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution that runs through the capillaries and into the Waste Plate during the first CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		PrimaryCapillaryFlushPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the PrimaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the first CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		PrimaryCapillaryFlushFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The flow rate of the PrimaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the first CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		PrimaryCapillaryFlushTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The duration for which the PrimaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the first CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		SecondaryCapillaryFlushSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution that runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		SecondaryCapillaryFlushPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the SecondaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the second CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		SecondaryCapillaryFlushFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter/Second],
			Description -> "The flow rate of the SecondaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		SecondaryCapillaryFlushTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Description -> "The duration for which the SecondaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		TertiaryCapillaryFlushSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The solution that runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		TertiaryCapillaryFlushPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the TertiaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the third CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		TertiaryCapillaryFlushFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter/Second],
			Description -> "The flow rate of the TertiaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		TertiaryCapillaryFlushTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Description -> "The duration for which the TertiaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
			Category -> "Capillary Flush"
		},
		(*===Capillary Equilibration*)
		CapillaryEquilibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the RunningBufferSolution is run through the capillaries to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times prior to a Pre-Marker Rinse or a Pre-Sample Rinse step.",
			Category -> "Capillary Equilibration"
		},
		SampleRunningBuffer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of SampleLink, the buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The RunningBufferSolution is running through the capillaries during the Capillary Equilibration and Sample Separation steps.",
			Category -> "Capillary Equilibration",
			IndexMatching->SampleLink
		},
		LadderRunningBuffer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of LadderLink, the buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The RunningBufferSolution is running through the capillaries during the Capillary Equilibration and Sample Separation steps.",
			Category -> "Capillary Equilibration",
			IndexMatching->LadderLink
		},
		BlankRunningBuffer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of BlankLink, the buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The RunningBufferSolution is running through the capillaries during the Capillary Equilibration and Sample Separation steps.",
			Category -> "Capillary Equilibration",
			IndexMatching->BlankLink
		},
		PreparedRunningBufferPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Plate],
			Description -> "The pre-prepared plate that holds the SampleRunningBuffer, LadderRunningBuffer and BlankRunningBuffer and is loaded into the instrument.",
			Category -> "Capillary Equilibration"
		},
		EquilibrationVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Description -> "The electric potential applied across the capillaries as the RunningBufferSolution runs through the capillaries to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times prior to a Pre-Marker Rinse or a Pre-Sample Rinse step.",
			Category -> "Capillary Equilibration"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Description -> "The duration for which the RunningBufferSolution runs through the capillaries to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times.",
			Category -> "Capillary Equilibration"
		},
		(*===Pre-Marker Rinse===*)
		PreMarkerRinse -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreMarkerRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Marker Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with.",
			Category -> "Pre-Marker Rinse"
		},
		NumberOfPreMarkerRinses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,3],
			Description -> "The number of dips of the capillary tips in and out of the PreMarkerRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Marker Rinse Plate prior to MarkerInjection in order to wash off any previous reagents the capillaries may have come in contact with.",
			Category -> "Pre-Marker Rinse"
		},
		PreMarkerRinseBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The buffer solution that is used to rinse the capillary tips by dipping them in and out of the PreMarkerRinseBuffer contained in the wells of the Pre-Marker Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			Category -> "Pre-Marker Rinse"
		},
		(*===Marker Injection===*)
		MarkerInjection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if injection of markers into the capillaries is performed prior to a sample run. This is only applicable if the DiluentSolution does not contain markers.",
			Category -> "Marker Injection"
		},
		SampleMarker -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of SampleLink, the solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
			Category -> "Marker Injection",
			IndexMatching->SampleLink
		},
		LadderMarker -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of LadderLink, the solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
			Category -> "Marker Injection",
			IndexMatching->LadderLink
		},
		BlankMarker -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "For each member of BlankLink, the solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
			Category -> "Marker Injection",
			IndexMatching->BlankLink
		},
		PreparedMarkerPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Plate],
			Description -> "The pre-prepared plate that holds the SampleMarker,LadderMarker,BlankMarker and is loaded into the instrument.",
			Category -> "Marker Injection"
		},
		MarkerInjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Description -> "The duration an electric potential (VoltageInjection) is applied across the capillaries to drive the markers into the capillaries. While a short InjectionTime is ideal since this in effect results in a small sample zone and reduces band broadening, a longer InjectionTime can serve to minimize voltage or pressure variability during injection.",
			Category -> "Marker Injection"
		},
		MarkerInjectionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Description -> "The electric potential applied across the capillaries to drive the markers forward into the capillaries, from the MarkerPlate to the capillary inlet, during the MarkerInjection step.",
			Category -> "Marker Injection"
		},
		(*===Pre-Sample Rinse===*)
		PreSampleRinse -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreSampleRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Sample Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the SampleInjection step.",
			Category -> "Pre-Sample Rinse"
		},
		NumberOfPreSampleRinses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,3],
			Description -> "The number of dips of the capillary tips in and out of the PreSampleRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Sample Rinse Plate prior to SampleInjection in order to wash off any previous reagents the capillaries may have come in contact with.",
			Category -> "Pre-Sample Rinse"
		},
		PreSampleRinseBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The buffer solution that is used to rinse capillary tips by dipping them in and out of the PreSampleRinseBuffer contained in the wells of the Pre-Sample Rinse Plate.",
			Category -> "Pre-Sample Rinse"
		},
		(*===Sample Injection===*)
		SampleInjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The duration a electric potential (SampleInjectionVoltage) is applied across the capillaries to drive the samples into the capillaries.",
			Category -> "Sample Injection"
		},
		SampleInjectionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The electric potential applied across the capillaries to drive the samples or ladders forward into the capillaries, from the Sample Plate to the capillary inlet, during the SampleInjection step when the selected SampleInjectionTechnique is VoltageInjection.",
			Category -> "Sample Injection"
		},
		(*===Separation===*)
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The duration for which the SeparationVoltage is applied across the capillaries in order for migration of analytes to occur.",
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
