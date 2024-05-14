

(* ::Text:: *)
(*\[Copyright] 2018 Emerald Cloud Lab,Inc.*)

DefineObjectType[Object[Protocol, FlowCytometry],{
	Description->"A protocol to detect and measure physical and chemical characteristics of a population of cells or particles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		InjectionModes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :>  FlowCytometerInjectionModeP,
			Description -> "For each member of SamplesIn, the mode in which samples are loaded into the flow cell. In the Individual injection mode, only one sample is inside the line a given time. After data acquisition, the sample pump runs backward to clear the line, then a wash occurs before the probe moves to the next position. In Continuous mode, samples are aspirated continuously, resulting multiple samples in the sample line. Each sample is separated with a series of air and water boundaries.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,FlowCytometer]|Model[Instrument,FlowCytometer],
			Description->"The flow cytometer used for this experiment to count and quantify the cell populations by aligning them in a stream and measuring light scattered off the cells.",
			Category->"General",
			Abstract->True
		},
		PreparedPlate->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description-> "Indicates if the container containing the samples for the flow cytometry experiment will be loaded directly onto the instrument.",
			Category -> "Sample Preparation"
		},
		Temperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0 Celsius]|Ambient,
			Description -> "The temperature of the autosampler where the samples sit prior to being injected into the flow cytometer.",
			Category-> "General"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the amount of the input sample that is aliquoted from its original container.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Agitate->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description-> "For each member of SamplesIn, indicates if the autosampler is shaked to the resuspend sample prior to being injected into the flow cytometer.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		AgitationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[5 Second,1 Hour],
			Units -> Second,
			Description-> "For each member of SamplesIn, the amount of time the autosampler is shaked to the resuspend sample prior to being injected into the flow cytometer..",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		FlowRates->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RangeP[0.1Microliter/Second,3.5 Microliter/Second]|RangeP[0*Event/Second,100000*Event/Second],
			Description -> "For each member of SamplesIn, the volume or amount of trigger events per time which the sample is flowed through the flow cytometer.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		RecoupSamples->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->  "For each member of SamplesIn, indicates if the excess sample in the injection line returns to the into the container that they were in prior to the measurement.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		CellCount->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the number of cells per volume of the sample will be verified.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		FlushFrequency->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "Indicates the frequency at which the flushed after samples have been processed.",
			Category-> "General"
		},
		FlushSample->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "The liquid used to flush the instrument.",
			Category-> "General"
		},
		FlushSamplePlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A placement used to move the flush sample into position.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		FlushSpeed->{
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[0.5Microliter/Second,1Microliter/Second,1.5Microliter/Second],
			Description -> "The speed at which the FlushSample is run through the instrument during a Flush.",
			Category->"General"
		},
		Detectors->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The detectors which should be used to detect light scattered off the samples.",
			Category-> "General"
		},
		DetectionLabels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule]
			],
			Description -> "For each member of Detectors, the tag, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be analyzed by the Detectors.",
			Category-> "General",
			IndexMatching -> Detectors
		},
		NeutralDensityFilters->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Detectors, if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector.",
			Category-> "General",
			IndexMatching -> Detectors
		},
		ExcitationWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FlowCytometryExcitationWavelengthP,
			Description -> "The wavelength(s) which should be used to excite fluorescence and scatter off the samples.",
			Category-> "General"
		},
		ExcitationPowers->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>RangeP[0*Milli*Watt,100*Milli*Watt],
			Units -> Milli*Watt,
			Description -> "For each member of ExcitationWavelengths, the power which should be used to excite fluorescence and scatter off the samples.",
			Category-> "General",
			IndexMatching -> ExcitationWavelengths
		},
		Gains->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :>GreaterEqualP[0Volt]|Auto|QualityControl,
			Description -> "For each member of Detectors, the voltage the PMT should be set to to detect the scattered light off the sample.",
			Category-> "General",
			IndexMatching -> Detectors
		},
		OptimizeGain->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Detectors, if voltage the PMT should be adjusted for the adjustment sample.",
			Category-> "General",
			Developer->True,
			IndexMatching -> Detectors
		},
		AdjustmentSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "For each member of Detectors, the sample used for gain optimization. If CompensationSamplesIncluded is True, this sample will also be used when creating a compensation matrix.",
			Category-> "General",
			IndexMatching -> Detectors
		},
		TargetSaturationPercentages->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>RangeP[0Percent,100Percent],
			Units -> Percent,
			Description -> "For each member of Detectors, the percent of the PMTs dynamic range that the intensity of positive population is centered around.",
			Category-> "General",
			IndexMatching -> Detectors
		},
		TargetSaturationValues->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>RangeP[0,256],
			Description -> "For each member of Detectors, the value of the PMT that the intensity of positive population is centered around.",
			Category-> "General",
			IndexMatching -> Detectors,
			Developer->True
		},
		TriggerDetector->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The detector used to determine what signals count as an event.",
			Category-> "General"
		},
		TriggerThreshold->{
			Format -> Single,
			Class -> Real,
			Pattern :>RangeP[0.01Percent,100Percent],
			Units -> Percent,
			Description -> "The level of the intensity detected by TriggerDetector must fall above to be classified as an event.",
			Category-> "General"
		},
		SecondaryTriggerDetector->{
			Format -> Single,
			Class -> Expression,
			Pattern :> FlowCytometryDetectorP,
			Description -> "The additional detector used to determine what signals count as an event.",
			Category-> "General"
		},
		SecondaryTriggerThreshold->{
			Format -> Single,
			Class -> Real,
			Pattern :>RangeP[0.01Percent,100Percent],
			Units -> Percent,
			Description -> "The level of the intensity detected by SecondaryTriggerDetector must fall above to be classified as an event.",
			Category-> "General"
		},
		MaxVolume->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[10Microliter,5000Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the maximum volume of sample that will flow through the flow cytometer.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		MaxEvents->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "For each member of SamplesIn, the maximum number of trigger events that will flow through the flow cytometer.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		MaxGateEvents->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "For each member of SamplesIn, the maximum events falling into a specific Gate that will flow through the instrument.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		GateRegions->{
			Format->Multiple,
			Class->{Expression,Expression,Expression,Expression},
			Pattern:>{FlowCytometryDetectorP,_Span,FlowCytometryDetectorP,_Span},
			Description->"For each member of SamplesIn, the conditions given to categorize the gate for the MaxGateEvents.",
			Headers->{"X Channel","X Range","Y Channel","Y Range"},
			Category->"General",
			IndexMatching -> SamplesIn
		},
		GatePlotsX->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlowCytometryDetectorP,
			Description->"The X Channels of the plots needed to be set up for the gate for the MaxGateEvents.",
			Category->"General",
			Developer -> True
		},
		GatePlotsY->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlowCytometryDetectorP,
			Description->"The Y Channels of the plots needed to be set up for the gate for the MaxGateEvents.",
			Category->"General",
			Developer -> True
		},
		GatesX->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlowCytometryDetectorP,
			Description->"The X Channels of the plots for the gate.",
			Category->"General",
			Developer -> True
		},
		GatesY->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlowCytometryDetectorP,
			Description->"The X Channels of the plots for the gate.",
			Category->"General",
			Developer -> True
		},
		GatesXMin->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,256],
			Description->"The x minima of the ranges of the plots needed to be set up for the gate for the MaxGateEvents.",
			Category->"General",
			Developer -> True
		},
		GatesYMin->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,256],
			Description->"The y minima of the ranges of the plots needed to be set up for the gate for the MaxGateEvents.",
			Category->"General",
			Developer -> True
		},
		GatesXMax->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,256],
			Description->"The x maxima of the ranges of the plots needed to be set up for the gate for the MaxGateEvents.",
			Category->"General",
			Developer -> True
		},
		GatesYMax->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,256],
			Description->"The y maxima of the ranges of the plots needed to be set up for the gate for the MaxGateEvents.",
			Category->"General",
			Developer -> True
		},
		CompensationSamplesIncluded->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->  "If a compensation samples are included to create a matrix to compensate for spillover of DetectionLabel into other detectors.",
			Category-> "General"
		},
		UnstainedSample->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "A sample to be used as negative control when calculating the background of the compensation matrix for the experiment.",
			Category-> "General"
		},
		(*
		CompensationMatrix->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,CompensationMatrix]
			],
			Description ->  "The compensation matrix used to compensate for spillover of fluorophores into other detectors.",
			Category-> "General"
		},*)
		Reagents->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "For each member of SamplesIn, the reagent that will be added to the sample prior to measurement.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		ReagentVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0Microliter,5000Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the volume of Reagent that will be added to the sample prior to measurement.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		ReagentMix->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the Reagent and sample will be mixed by aspiration prior to measurement.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		NeedleInsideWashTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[0.5Second,1Second,2Second],
			Description -> "The amount of time the sheath fluid will be used to wash the inside of the injection needle after the sample measurement.",
			Category->"General"
		},
		BlankFrequency->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The frequency at which Blank samples will be inserted in the measurement sequence.",
			Category-> "General"
		},
		Blanks->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "The samples containing wash solution used an extra wash between samples.",
			Category-> "General"
		},
		BlankInjectionVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :>RangeP[0*Microliter,5*Milliliter],
			Units -> Microliter,
			Description -> "For each member of Blanks, the speed at which the wash sample is run through the instrument during a flush.",
			Category->"General",
			IndexMatching -> Blanks
		},
		InjectionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move the injection containers into position.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		InjectionVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container] | Object[Sample] | Model[Sample],
			Description -> "A list injection vessels that are moved into position inside the InjectionRack.",
			Category -> "Placements",
			Developer -> True
		},
		InjectionRackPositions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> LocationPositionP,
			Relation -> Null,
			Description -> "A list of positions inside the InjectionRack that the InjectionVessels are be moved to.",
			Category -> "Placements",
			Developer -> True
		},
		InjectionRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the injection containers during sample priming and injection.",
			Category -> "Placements",
			Developer -> True
		},
		InjectionRackPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A placement used to move the injection containers into position.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		InjectionContainers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container], Object[Container]}],
			Relation -> Model[Container] | Object[Container],
			Description -> "The container in which the samples, blanks, and reagents are moved to before injection.",
			Category -> "Placements"
		},
		InjectionContainerPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of samples into the injection plate or vessels.",
			Category -> "General",
			Developer -> True
		},
		InjectionContainerManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to transfer samples into the injection plate or vessels.",
			Category -> "General"
		},
		InjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				InjectionVolume->Real,
				AgitationTime->Real
			},
			Pattern:>{
				Type->Sample|AdjustmentSample|UnstainedSample|Blank,
				Sample->_Link,
				InjectionVolume->GreaterEqualP[0 * Micro * Liter],
				AgitationTime->GreaterEqualP[0 * Second]
			},
			Units->{
				Type->Null,
				Sample->None,
				InjectionVolume -> Micro*Liter,
				AgitationTime->Second
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[Object[Sample],Model[Sample]],
				InjectionVolume -> Null,
				AgitationTime->Null
			},
			Description->"The sequence of injections for a given experiment run for QualityControlBeads, Samples AdjustmentSamples UnstainedSample and Blanks.",
			Category -> "General"
		},
		MethodFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The methods filename containing the run parameters for all samples in protocol.",
			Category->"General",
			Developer->True
		},
		Bleach->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "The bleach used added to the waste container of the instrument.",
			Category-> "General"
		},
		SecondaryBleach->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],Object[Sample]
			],
			Description -> "The bleach used added to the secondary waste container of the instrument.",
			Category-> "General"
		},
		SampleWells->{
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Relation -> Null,
			Description -> "For each member of SamplesIn, the wells that contain the samples.",
			Category-> "General",
			IndexMatching -> SamplesIn
		},
		AdjustmentSampleWells->{
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Relation -> Null,
			Description -> "For each member of Detectors, the wells that contain the adjustment samples.",
			Category-> "General",
			IndexMatching -> Detectors
		},
		UnstainedSampleWells->{
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Relation -> Null,
			Description -> "The well that contains the unstained samples.",
			Category-> "General"
		},
		SampleData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of SamplesIn, the primary data for the samples generated by this protocol.",
			Category -> "Experimental Results"
		},
		AdjustmentSampleData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The primary data for the adjustment samples generated by this protocol.",
			Category -> "Experimental Results"
		},
		UnstainedSampleData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The primary data for the unstained samples generated by this protocol.",
			Category -> "Experimental Results"
		},
		FlowCytometryMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,FlowCytometry],
			Description -> "The flow cytometry method object which describes the optics settings of the instrument.",
			Category -> "Experimental Results"
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path where the flow cytometry data files are located.",
			Category -> "General",
			Developer->True
		},
		MethodFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the protocol file which contains the experiment parameters.",
			Category -> "General",
			Developer->True
		},
		CompensationMatrixAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Compensation matrix analysis objects calculated using the AdjustmentSampleData in this protocol.",
			Category -> "Analysis & Reports"
		}
}}];
