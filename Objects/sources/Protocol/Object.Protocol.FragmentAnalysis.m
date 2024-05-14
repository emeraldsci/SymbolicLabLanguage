(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,FragmentAnalysis],
	{
		Description->"A protocol for qualitative or quantitative analysis of nucleic acids in parallel (up to 96 samples at a time) via separation based on nucleic acid fragment size using capillary gel electrophoresis.",
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
			TargetSampleAnalyteType -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> FragmentAnalysisAnalyteTypeP,
				Description -> "The nucleic acid type (DNA or RNA) targeted by the selected AnalysisMethod.",
				Category -> "General"
			},
			SampleAnalyteType -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> FragmentAnalysisAnalyteTypeP,
				Description -> "For each member of SamplesIn, the nucleic acid type (DNA or RNA) of the analytes in the sample that are separated based on fragment size.",
				Category -> "General",
				IndexMatching->SamplesIn
			},
			MinReadLength -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0,1],
				Description -> "For each member of SamplesIn, the lowest number of base pairs or nucleotides of the shortest fragment analyte in the sample.",
				Category -> "General",
				IndexMatching->SamplesIn
			},
			MaxReadLength -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0,1],
				Description -> "For each member of SamplesIn, the highest number of base pairs or nucleotides of the shortest fragment analyte in the sample.",
				Category -> "General",
				IndexMatching->SamplesIn
			},
			AnalysisMethodName -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The name that is given to the Method Object that is generated from options specified in the experiment. Note that if no AnalysisMethodName is provided, no new method is saved.",
				Category -> "Method Saving"
			},
			CapillaryStorageSolutions -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "The buffer solutions contained in the CapillaryStorageSolutionPlate that the capillaries are immersed in when the Instrument is not in use. These solutions keep the capillary inlets from drying out and prolongs effective lifetime.",
				Category -> "General"
			},
			CapillaryStorageSolutionPlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the CapillaryStorageSolutionPlate in the dedicated position inside the Instrument.",
				Headers -> {"CapillaryStorageSolutionPlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			(*===Sample Preparation===*)
			SampleVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter],
				Units-> Microliter,
				Description -> "For each member of SamplesIn, the volume of sample that is contained in the plate prior to addition of SampleDiluent, LoadingBuffer (if applicable) and before loading into the instrument. If PreparedPlate is True, this defaults to Null for each member of SamplesIn.",
				Category -> "Sample Preparation",
				IndexMatching->SamplesIn
			},
			SampleDilutions -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if SampleDiluent is added to the sample (after aliquoting, if applicable) to reduce the sample concentration prior to addition of the LoadingBuffer and loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->SamplesIn
			},
			SampleDiluents -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SamplesIn, the buffer solution added to the sample to reduce the sample concentration prior to addition of the LoadingBuffer and loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->SamplesIn
			},
			SampleDiluentVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of buffer solution added to the sample to reduce the sample concentration prior to addition of the LoadingBuffer and loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->SamplesIn
			},
			SampleLoadingBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation->Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of SamplesIn, the solution added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->SamplesIn
			},
			SampleLoadingBufferVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter],
				Units -> Microliter,
				Description -> "For each member of SamplesIn, the volume of LoadingBuffer added to the sample (after aliquoting, if applicable) to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to mixing (if applicable) and loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->SamplesIn
			},
			Ladders -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "The solution(s) that contain nucleic acids of known lengths used for qualitative or quantitative data analysis. One ladder solution, which is dispensed to Position H12 (for a 96-capillary array), is recommended for each run of the capillary array. If multiple ladders are specified, each ladder is dispensed on the sample plate starting from Position H12 (for a 96-capillary array) enumerated backward. For example, with a 96-capillary array with 3 specified ladders, the first ladder will be dispensed to Position H12, the second ladder to Position H11 and the third ladder to position H10. If PreparedPlate is True, Ladders are the corresponding sample contained in the indicated WellPosition for the Ladder option.",
				Category -> "Sample Preparation"
			},
			LadderVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter],
				Units-> Microliter,
				Description -> "For each member of Ladders, the volume of Ladder that is contained in the plate prior to addition of the LoadingBuffer and before loading into the instrument. If PreparedPlate is True, this defaults to Null for each member of Ladders.",
				Category -> "Sample Preparation",
				IndexMatching->Ladders
			},
			LadderLoadingBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation->Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of Ladders, the solution added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the ladder prior to loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->Ladders
			},
			LadderLoadingBufferVolumes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter],
				Units -> Microliter,
				Description -> "For each member of Ladders, the volume of LoadingBuffer added to the sample (after aliquoting, if applicable) to either add markers to (Quantitative) or further dilute (Qualitative) the ladder prior to loading into the instrument.",
				Category -> "Sample Preparation",
				IndexMatching->Ladders
			},
			Blanks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "The solution that is dispensed in the well(s) of the sample plate required to be filled that are not filled by a sample or a ladder. For example, for a run using a 96-capillary array, if there are only 79 samples and 1 ladder, 16 wells are filled with Blanks.). Wells filled with Blanks each contain a volume equal to the total volume of TargetSampleVolume and LoadingBufferVolume of the AnalysisMethod.",
				Category -> "Sample Preparation"
			},
			SamplePlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Plate],
					Object[Container,Plate]
				],
				Description -> "The plate that holds the samples, ladders and blanks and is loaded into the instrument.",
				Category -> "Sample Preparation"
			},
			SamplePlateStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal),
				Description->"The storage condition under which SamplePlate is stored in the course of an experiment run when not on the bench or inside the instrument.",
				Category->"Storage & Handling"
			},
			SampleWells->{
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Relation -> Null,
				Description -> "The wells in the SamplePlate that contain samples.",
				Category-> "Sample Preparation"
			},
			LadderWells->{
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Relation -> Null,
				Description -> "The wells in the SamplePlate that contain ladder(s).",
				Category-> "Sample Preparation"
			},
			BlankWells->{
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Relation -> Null,
				Description -> "The wells in the SamplePlate that contain blank(s).",
				Category-> "Sample Preparation"
			},
			SamplePlateCover -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Item,Lid],
					Object[Item,Lid]
				],
				Description -> "The seal or lid that covers the SamplePlate after preparation and at any time it is not inside the Instrument.",
				Category -> "Sample Preparation"
			},
			SamplePlateUnitOperation -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[UnitOperation],
				Description -> "The UnitOperation objects used to prepare the SamplePlate.",
				Category -> "Sample Preparation"
			},
			WastePlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Plate],
					Object[Container,Plate]
				],
				Description -> "The plate that holds the waste from SamplePlate,RunningBufferPlate,MarkerPlate.",
				Category -> "General"
			},
			WastePlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the WastePlate in the dedicated position inside the Instrument.",
				Headers -> {"WastePlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			SamplePlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the SamplePlate in the dedicated position inside the Instrument.",
				Headers -> {"SamplePlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
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
			GelDyeContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that holds the Separation Gel and Dye Solution.",
				Category -> "Capillary Conditioning"
			},
			GelDyeContainerRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the GelDyeContainer throughout the experiment when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			GelDyeUnitOperation -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[UnitOperation],
				Description -> "The UnitOperation objects used to prepare the combined SeparationGel and Dye.",
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
			ConditioningSolutionContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that holds the ConditioningSolution.",
				Category -> "Capillary Conditioning"
			},
			ConditioningSolutionContainerRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the ConditioningSolutionContainer throughout the experiment when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			WasteContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that holds the ConditioningSolution and Flush Solutions waste after the experiment.",
				Category -> "General"
			},
			WasteContainerPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the WasteContainer in the dedicated position inside the Instrument.",
				Headers -> {"WasteContainer", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			ConditioningSolutionPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the ConditioningSolutionContainer in the dedicated position inside the Instrument.",
				Headers -> {"ConditioningSolution", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			GelDyePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the GelDyeContainer in the dedicated position inside the Instrument.",
				Headers -> {"GelDyeSolution", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},

			(*===Optional CapillaryFlush Step===*)
			CapillaryFlush -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if an optional CapillaryFlush procedure is performed prior to a sample run. A CapillaryFlush step involves running the conditioning solution  or specified alternative(s) through the capillaries and into a Waste Plate.",
				Category -> "Capillary Flush"
			},
			NumberOfCapillaryFlushes -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[1,1],
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
			PrimaryCapillaryFlushSolutionContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that holds the PrimaryCapillaryFlushSolution.",
				Category -> "Capillary Flush"
			},
			PrimaryCapillaryFlushSolutionContainerRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the PrimaryCapillaryFlushSolutionContainer throughout the experiment when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
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
			SecondaryCapillaryFlushSolutionContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that holds the SecondaryCapillaryFlushSolution.",
				Category -> "Capillary Flush"
			},
			SecondaryCapillaryFlushSolutionContainerRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the SecondaryCapillaryFlushSolutionContainer throughout the experiment when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			SecondaryCapillaryFlushPressure -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*PSI],
				Units -> PSI,
				Description -> "The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the SecondaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the second CapillaryFlush step.",
				Category -> "Capillary Flush"
			},
			SecondaryCapillaryFlushFlowRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The flow rate of the SecondaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
				Category -> "Capillary Flush"
			},
			SecondaryCapillaryFlushTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Second],
				Units -> Second,
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
			TertiaryCapillaryFlushSolutionContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that holds the TertiaryCapillaryFlushSolution.",
				Category -> "Capillary Flush"
			},
			TertiaryCapillaryFlushSolutionContainerRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the TertiaryCapillaryFlushSolutionContainer throughout the experiment when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			TertiaryCapillaryFlushPressure -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*PSI],
				Units -> PSI,
				Description -> "The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the TertiaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the third CapillaryFlush step.",
				Category -> "Capillary Flush"
			},
			TertiaryCapillaryFlushFlowRate -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The flow rate of the TertiaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
				Category -> "Capillary Flush"
			},
			TertiaryCapillaryFlushTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Second],
				Units -> Second,
				Description -> "The duration for which the TertiaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
				Category -> "Capillary Flush"
			},
			PrimaryCapillaryFlushSolutionPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the PrimaryCapillaryFlushSolutionContainer in the dedicated position inside the Instrument.",
				Headers -> {"PrimaryCapillaryFlushSolution", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			SecondaryCapillaryFlushSolutionPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the SecondaryCapillaryFlushSolutionContainer in the dedicated position inside the Instrument.",
				Headers -> {"SecondaryCapillaryFlushSolution", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			TertiaryCapillaryFlushSolutionPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the TertiaryCapillaryFlushSolutionContainer in the dedicated position inside the Instrument.",
				Headers -> {"TertiaryCapillaryFlushSolution", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			ConditioningLinePlaceholderPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the ConditioningLinePlaceholderContainer in the dedicated position inside the Instrument.",
				Headers -> {"ConditioningLinerPlaceholderContainer", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			ConditioningLinePlaceholderRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the ConditioningLinePlaceholderContainer temporarily when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			PrimaryGelLinePlaceholderPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the PrimaryGelLinePlaceholderContainer in the dedicated position inside the Instrument.",
				Headers -> {"PrimaryGelLinePlaceholderContainer", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			PrimaryGelLinePlaceholderRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the PrimaryGelLinePlaceholderContainer temporarily when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			SecondaryGelLinePlaceholderPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the SecondaryGelLinePlaceholderContainer in the dedicated position inside the Instrument.",
				Headers -> {"SecondaryGelLinePlaceholderContainer", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			SecondaryGelLinePlaceholderRack->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
				Description->"The rack that holds the SecondaryGelLinePlaceholderContainer temporarily when not inside the Instrument.",
				Category->"Storage & Handling",
				Developer->True
			},
			(*===Capillary Equilibration*)
			CapillaryEquilibration -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a step where an electric potential EquilibrationVoltage is applied across the capillaries for a duration of EquilibrationTime while the capillaries are immersed in the RunningBuffer solutions is performed. This serves to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times prior to a Pre-Marker Rinse or a Pre-Sample Rinse step.",
				Category -> "Capillary Equilibration"
			},
			SampleRunningBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description ->"For each member of SamplesIn, the buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The capillaries are immersed in the RunningBuffer during the Capillary Equilibration and Sample Separation steps.",
				Category -> "Capillary Equilibration",
				IndexMatching->SamplesIn
			},
			LadderRunningBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of Ladders, the buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The capillaries are immersed in the RunningBuffer during the Capillary Equilibration and Sample Separation steps.",
				Category -> "Capillary Equilibration",
				IndexMatching->Ladders
			},
			BlankRunningBuffers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of Blanks, the buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The capillaries are immersed in the RunningBuffer during the Capillary Equilibration and Sample Separation steps.",
				Category -> "Capillary Equilibration",
				IndexMatching->Blanks
			},
			RunningBufferPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Plate],
					Object[Container,Plate]
				],
				Description -> "The plate that holds the SampleRunningBuffer, LadderRunningBuffer and BlankRunningBuffer and is loaded into the instrument.",
				Category -> "Capillary Equilibration"
			},
			PreparedRunningBufferPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container,Plate],
				Description -> "The pre-prepared plate that holds the SampleRunningBuffer, LadderRunningBuffer and BlankRunningBuffer and is loaded into the instrument.",
				Category -> "Capillary Equilibration"
			},
			RunningBufferPlateCover -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Item,Lid],
					Object[Item,Lid]
				],
				Description -> "The seal or lid that covers the RunningBufferPlate after preparation and at any time it is not inside the Instrument.",
				Category -> "Capillary Equilibration"
			},
			RunningBufferPlateUnitOperation -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[UnitOperation],
				Description -> "The UnitOperation objects used to prepare the RunningBufferPlate.",
				Category -> "Capillary Equilibration"
			},
			RunningBufferPlateStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal),
				Description->"The storage condition under which RunningBufferPlate is stored after its usage in the experiment.",
				Category->"Storage & Handling"
			},
			EquilibrationVoltage -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Kilovolt],
				Units -> Kilovolt,
				Description -> "The electric potential applied across the capillaries as the capillaries are immersed in RunningBuffer to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times prior to a Pre-Marker Rinse or a Pre-Sample Rinse step.",
				Category -> "Capillary Equilibration"
			},
			EquilibrationTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Second],
				Units -> Second,
				Description -> "The duration for which the electric potential EquilibrationVoltage is applied across the capillaries as the capillaries are imersed in RunningBuffer to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times.",
				Category -> "Capillary Equilibration"
			},
			RunningBufferPlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the RunningBufferPlate in the dedicated position inside the Instrument.",
				Headers -> {"RunningBufferPlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			(*===Pre-Marker Rinse===*)
			PreMarkerRinse -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreMarkerRinseBuffer contained in the wells (rows A-D for 48-capillary injections OR rows A-H for 96-capillary injections) of the Pre-Marker Rinse Plate in order to wash off any previous reagents the capillaries may have come in contact with.",
				Category -> "Pre-Marker Rinse"
			},
			NumberOfPreMarkerRinses -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[1,1],
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
			PreMarkerRinseBufferPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Plate],
					Object[Container,Plate]
				],
				Description -> "The plate that holds the PreMarkerRinseBuffer and is loaded into the instrument.",
				Category -> "Pre-Marker Rinse"
			},
			PreMarkerRinseBufferPlateStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal),
				Description->"The storage condition under which PreMarkerRinseBufferPlate is stored after its usage in the experiment.",
				Category->"Storage & Handling"
			},
			PreMarkerRinseBufferPlateCover -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Item,Lid],
					Object[Item,Lid]
				],
				Description -> "The seal that covers the PreMarkerRinseBufferPlate after preparation and at any time it is not inside the Instrument.",
				Category -> "Pre-Marker Rinse"
			},
			PreMarkerRinseBufferPlateUnitOperation -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[UnitOperation],
				Description -> "The UnitOperation objects used to prepare the PreMarkerRinseBufferPlate.",
				Category -> "Pre-Marker Rinse"
			},
			PreMarkerRinseBufferPlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the PreMarkerRinseBufferPlate in the dedicated position inside the Instrument.",
				Headers -> {"PreMarkerRinseBufferPlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			(*===Marker Injection===*)
			MarkerInjection -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if injection of markers into the capillaries is performed prior to a sample run. This is only applicable if the LoadingBuffer does not contain markers.",
				Category -> "Marker Injection"
			},
			SampleMarkers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of SamplesIn, the solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
				Category -> "Marker Injection",
				IndexMatching->SamplesIn
			},
			LadderMarkers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of Ladders, the solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
				Category -> "Marker Injection",
				IndexMatching->Ladders
			},
			BlankMarkers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "For each member of Blanks, the solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. For a successful marker injection, a minimum of 50 Microliter is required in each well (rows A-H for 96-capillary injections) of the MarkerPlate.",
				Category -> "Marker Injection",
				IndexMatching->Blanks
			},
			MineralOil -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample],Object[Sample]],
				Description -> "The mineral oil that is added to each well of the marker plate on top of marker solutions that helps prevent evaporation of marker solution.",
				Category -> "Marker Injection"
			},
			MarkerPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Plate],
					Object[Container,Plate]
				],
				Description -> "The plate that holds the SampleMarker,LadderMarker,BlankMarker and is loaded into the instrument.",
				Category -> "Marker Injection"
			},
			MarkerPlateStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal),
				Description->"The storage condition under which MarkerPlate is stored after its usage in the experiment.",
				Category->"Storage & Handling"
			},
			PreparedMarkerPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container,Plate],
				Description -> "The pre-prepared plate that holds the SampleMarker,LadderMarker,BlankMarker and is loaded into the instrument.",
				Category -> "Marker Injection"
			},
			MarkerPlateCover -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Item,Lid],
					Object[Item,Lid]
				],
				Description -> "The seal that covers the MarkerPlate after preparation and at any time it is not inside the Instrument.",
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
			MarkerPlateUnitOperation -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[UnitOperation],
				Description -> "The UnitOperation objects used to prepare the MarkerPlate.",
				Category -> "Marker Injection"
			},
			MarkerPlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the MarkerPlate in the dedicated position inside the Instrument.",
				Headers -> {"MarkerPlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
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
				Pattern :> GreaterEqualP[1,1],
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
			PreSampleRinseBufferPlate -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Plate],
					Object[Container,Plate]
				],
				Description -> "The plate that holds the PreSampleRinseBuffer and is loaded into the instrument.",
				Category -> "Pre-Sample Rinse"
			},
			PreSampleRinseBufferPlateStorageCondition->{
				Format->Single,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal),
				Description->"The storage condition under which PreSampleRinseBufferPlate is stored after its usage in the experiment.",
				Category->"Storage & Handling"
			},
			PreSampleRinseBufferPlateCover -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Item,Lid],
					Object[Item,Lid]
				],
				Description -> "The seal that covers the PreSampleRinseBufferPlate after preparation and at any time it is not inside the Instrument.",
				Category -> "Pre-Sample Rinse"
			},
			PreSampleRinseBufferPlateUnitOperation -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[UnitOperation],
				Description -> "The UnitOperation objects used to prepare the PreSampleRinseBufferPlate.",
				Category -> "Pre-Sample Rinse"
			},
			PreSampleRinseBufferPlatePlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link,_Link, _String},
				Relation -> {Object[Container],Object[Instrument], Null},
				Description -> "The placement used to place the PreSampleRinseBufferPlate in the dedicated position inside the Instrument.",
				Headers -> {"PreSampleRinseBufferPlate", "Instrument", "Instrument Position"},
				Category -> "Placements",
				Developer -> True
			},
			(*===Sample Injection===*)
			SampleInjectionTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Second],
				Units -> Second,
				Description -> "The duration a electric potential (SampleInjectionVoltage) is applied across the capillaries to drive the contents of the SamplePlate (samples, ladder(s), blank(s)) into the capillaries.",
				Category -> "Sample Injection"
			},
			SampleInjectionVoltage -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Kilovolt],
				Units -> Kilovolt,
				Description -> "The electric potential applied across the capillaries to drive the contents of the SamplePlate (samples, ladder(s), blank(s)) forward into the capillaries, from the SamplePlate to the capillary inlet, during the SampleInjection step when the selected SampleInjectionTechnique is VoltageInjection.",
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
			},
			(*===Method Files===*)
			SeparationMethodFilePath->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The file path of the method file containing the different parameters used during the separation to generate the electropherogram that contains the details of separation of the different analyte fragments for all samples in protocol.",
				Category->"General",
				Developer->True
			},
			CapillaryFlushMethodFilePath->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The file path of the method file containing the parameters for running the conditioning solution or specified alternative(s) through the capillaries and into a Waste Plate performed prior to the separation.",
				Category->"General",
				Developer->True
			},
			SeparationBatFilePath->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The file path of the bat file that is executed in order to copy the Separation Method File from the Z drive to the appropriate folder of the instrument computer.",
				Category->"General",
				Developer->True
			},
			CapillaryFlushBatFilePath->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The file path of the bat file that is executed in order to copy the Capillary Flush Method File into the right folder.",
				Category->"General",
				Developer->True
			},
			SeparationFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The name of the method file containing the different parameters used during separation to generate the electropherogram that contains the details of separation of the different analyte fragments for all samples in protocol.",
				Category->"General",
				Developer->True
			},
			CapillaryFlushFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The name of the method file containing the parameters for running the conditioning solution or specified alternative(s) through the capillaries and into a Waste Plate performed prior to the separation.",
				Category->"General",
				Developer->True
			},
			(*===Data Processing===*)
			BackupRawDataFilePath->{
				Format -> Single,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The file path on the instrument computer in which a back up copy of the data generated by the experiment is stored locally.",
				Category -> "Data Processing",
				Developer -> True
			},
			RawDataBatFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the bat file that is executed in order to copy the Raw Data to the Z Drive.",
				Category->"Data Processing",
				Developer->True
			},
			RawDataBatFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The name of the the bat file that is executed in order to copy the Raw Data to the Z Drive.",
				Category->"Data Processing",
				Developer->True
			},
			RawDataFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the *.raw file that is generated after the separation run. This is also the file that is processed by the ProSize Software to generate the various processed data files.",
				Category->"Data Processing",
				Developer->True
			},
			RawDataDirectoryFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the folder in the Z drive that contains all the raw data files of the protocol.",
				Category->"Data Processing",
				Developer->True
			},
			RawDataFileName->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Description->"The name of the the *.raw file that is generated after the separation run. This is also the file that is processed by the ProSize Software to generate the various processed data files.",
				Category->"Data Processing",
				Developer->True
			},
			RawDataArchiveFile -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The *.zip data file containing all the raw unprocessed data files generated after the experiment.",
				Category -> "Data Processing"
			},
			RawDataArchiveFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the *.zip data file containing all the raw unprocessed data files generated after the experiment.",
				Category->"Data Processing",
				Developer->True
			},
			ProcessedDataDirectoryFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the folder in the Z drive that contains all the processed data files of the protocol.",
				Category->"Data Processing",
				Developer->True
			},
			ProcessedTimeDataDirectoryFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the folder in the Z drive that contains all the processed data files of the protocol that involve time units.",
				Category->"Data Processing",
				Developer->True
			},
			ProcessedSizeDataDirectoryFilePath->{
				Format->Single,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of the folder in the Z drive that contains all the processed data files of the protocol that involve size (bp or nt) units.",
				Category->"Data Processing",
				Developer->True
			}
		}
	}
];
