(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,FlowCytometry],
	{
		Description -> "A detailed set of parameters for running a Flow Cytometry experiment on a set of samples.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
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
				Description -> "The sample that we analyze during this flow cytometry experiment.",
				Category -> "General",
				Migration -> SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that we analyze during this flow cytometry experiment.",
				Category -> "General",
				Migration -> SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The sample that we analyze during this flow cytometry experiment.",
				Category -> "General",
				Migration->SplitField
			},
			(*All Experiment options*)
			InjectionMode -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> FlowCytometerInjectionModeP,
				Description -> "For each member of SampleLink, the mode in which samples are loaded into the flow cell. In the Individual injection mode, only one sample is inside the line a given time. After data acquisition, the sample pump runs backward to clear the line, then a wash occurs before the probe moves to the next position. In Continuous mode, samples are aspirated continuously, resulting multiple samples in the sample line. Each sample is separated with a series of air and water boundaries.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			RecoupSample -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the excess sample in the injection line returns to the into the container that they were in prior to the measurement.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Microliter],
				Units -> Microliter,
				Description -> "For each member of SampleLink, the amount of the input sample that is aliquoted from its original container.",
				IndexMatching -> SampleLink,
				Category -> "General"
			},
			Instrument -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument, FlowCytometer] | Model[Instrument, FlowCytometer],
				Description -> "The flow cytometer used for this experiment to count and quantify the cell populations by aligning them in a stream and measuring light scattered off the cells.",
				Category -> "General"
			},
			FlowCytometryMethod -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Method, FlowCytometry],
				Description -> "The flow cytometry method object which describes the optics settings of the instrument.",
				Category -> "General"
			},
			PreparedPlate -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the container containing the samples for the flow cytometry experiment will be loaded directly onto the instrument.",
				Category -> "General"
			},
			TemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "The temperature of the autosampler where the samples sit prior to being injected into the flow cytometer.",
				Migration -> SplitField,
				Category -> "General"
			},
			TemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Ambient,
				Description -> "The temperature of the autosampler where the samples sit prior to being injected into the flow cytometer.",
				Category -> "General",
				Migration -> SplitField
			},
			Agitate -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the autosampler is shaked to the resuspend sample prior to being injected into the flow cytometer.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			AgitationFrequencyExpression -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> First,
				Description -> "The frequency at which the autosampler is shaked to resuspend samples between the injections.",
				Category -> "General",
				Migration -> SplitField
			},
			AgitationFrequencyInteger -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The frequency at which the autosampler is shaked to resuspend samples between the injections.",
				Category -> "General",
				Migration -> SplitField
			},
			AgitationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[5 Second, 1 Hour],
				Units -> Second,
				Description -> "For each member of SampleLink, the amount of time the autosampler is shaked to the resuspend sample prior to being injected into the flow cytometer..",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			FlowRate -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> RangeP[0.1Microliter / Second, 3.5 Microliter / Second] | RangeP[0 * Event / Second, 100000 * Event / Second],
				Description -> "For each member of SampleLink, the volume or amount of trigger events per time which the sample is flowed through the flow cytometer.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			CellCount -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the number of cells per volume of the sample will be verified.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			Flush -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a sample line flush is performed after the FlushFrequency number of samples have been processed.",
				Category -> "Flushing"
			},
			FlushFrequency -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Description -> "Indicates the frequency at which the flushed after samples have been processed.",
				Category -> "Flushing"
			},
			FlushSample -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample], Object[Sample]
				],
				Description -> "The liquid used to flush the instrument.",
				Category -> "Flushing"
			},
			FlushSpeed -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[0.5Microliter / Second, 1Microliter / Second, 1.5Microliter / Second],
				Description -> "The speed at which the FlushSample is run through the instrument during a Flush.",
				Category -> "Flushing"
			},
			Detector -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> FlowCytometryDetectorP,
				Description -> "The detectors which should be used to detect light scattered off the samples.",
				Category -> "Optics"
			},
			DetectionLabel -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Molecule]
				],
				Description -> "For each member of Detector, the tag, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be analyzed by the Detectors.",
				Category -> "Optics",
				IndexMatching -> Detector
			},
			NeutralDensityFilter -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of Detector, if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector.",
				Category -> "Optics",
				IndexMatching -> Detector
			},
			GainReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0Volt],
				Description -> "For each member of Detector, the voltage the PMT should be set to to detect the scattered light off the sample.",
				Category -> "Optics",
				Migration -> SplitField,
				IndexMatching -> Detector
			},
			GainExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Auto | QualityControl,
				Description -> "For each member of Detector, the voltage the PMT should be set to to detect the scattered light off the sample.",
				Category -> "Optics",
				Migration -> SplitField,
				IndexMatching -> Detector
			},
			AdjustmentSample -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample], Object[Sample]
				],
				Description -> "For each member of Detector, the sample used for gain optimization. If CompensationSamplecluded is True, this sample will also be used when creating a compensation matrix.",
				Category -> "Optics",
				IndexMatching -> Detector
			},
			TargetSaturationPercentage -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0Percent, 100Percent],
				Units -> Percent,
				Description -> "For each member of Detector, the percent of the PMTs dynamic range that the intensity of positive population is centered around.",
				Category -> "Optics",
				IndexMatching -> Detector
			},
			ExcitationWavelength -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> FlowCytometryExcitationWavelengthP,
				Description -> "The wavelength(s) which should be used to excite fluorescence and scatter off the samples.",
				Category -> "Optics"
			},
			ExcitationPower -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Milli * Watt, 100 * Milli * Watt],
				Units -> Milli * Watt,
				Description -> "For each member of ExcitationWavelength, the power which should be used to excite fluorescence and scatter off the samples.",
				Category -> "Optics",
				IndexMatching -> ExcitationWavelength
			},
			TriggerDetector -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> FlowCytometryDetectorP,
				Description -> "The detector used to determine what signals count as an event.",
				Category -> "Trigger"
			},
			TriggerThreshold -> {
				Format -> Single,
				Class -> Real,
				Pattern :> RangeP[0.01Percent, 100Percent],
				Units -> Percent,
				Description -> "The level of the intensity detected by TriggerDetector must fall above to be classified as an event.",
				Category -> "Trigger"
			},
			SecondaryTriggerDetector -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> FlowCytometryDetectorP | None,
				Description -> "The additional detector used to determine what signals count as an event.",
				Category -> "General"
			},
			SecondaryTriggerThreshold -> {
				Format -> Single,
				Class -> Real,
				Pattern :> RangeP[0.01Percent, 100Percent],
				Units -> Percent,
				Description -> "The level of the intensity detected by SecondaryTriggerDetector must fall above to be classified as an event.",
				Category -> "Trigger"
			},
			MaxVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[10Microliter, 5000Microliter],
				Units -> Microliter,
				Description -> "For each member of SampleLink, the maximum volume of sample that will flow through the flow cytometer.",
				Category -> "Stopping Conditions",
				IndexMatching -> SampleLink
			},
			MaxEventsInteger -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Description -> "For each member of SampleLink, the maximum number of trigger events that will flow through the flow cytometer.",
				Category -> "Stopping Conditions",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			MaxEventsExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[None],
				Description ->  "For each member of SampleLink, the maximum number of trigger events that will flow through the flow cytometer.",
				Category -> "Stopping Conditions",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			MaxGateEventsInteger -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Description -> "For each member of SampleLink, the maximum events falling into a specific Gate that will flow through the instrument.",
				Category -> "Stopping Conditions",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			MaxGateEventsExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[None],
				Description ->  "For each member of SampleLink, the maximum events falling into a specific Gate that will flow through the instrument.",
				Category -> "Stopping Conditions",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			GateRegion -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {FlowCytometryDetectorP, _Span, FlowCytometryDetectorP, _Span}|Null,
				Description -> "For each member of SampleLink, the conditions given to categorize the gate for the MaxGateEvents.",
				Category -> "Stopping Conditions",
				IndexMatching -> SampleLink
			},
			IncludeCompensationSamples -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a compensation matrix will be created to compensate for spillover of DetectionLabel into other detectors.",
				Category -> "Compensation"
			},
			UnstainedSampleLink -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample], Object[Sample]
				],
				Description -> "A sample to be used as negative control when calculating the background of the compensation matrix for the experiment.",
				Category -> "Compensation",
				Migration -> SplitField
			},
			UnstainedSampleExpression -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> None,
				Description -> "A sample to be used as negative control when calculating the background of the compensation matrix for the experiment.",
				Category -> "Compensation",
				Migration -> SplitField
			},
			AddReagent -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, Indicates if a Reagent will be added to the sample prior to measurement.",
				Category -> "Reagent Addition",
				IndexMatching -> SampleLink
			},
			Reagent -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample], Object[Sample]
				],
				Description -> "For each member of SampleLink, the reagent that will be added to the sample prior to measurement.",
				Category -> "Reagent Addition",
				IndexMatching -> SampleLink
			},
			ReagentVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0Microliter, 5000Microliter],
				Units -> Microliter,
				Description -> "For each member of SampleLink, the volume of Reagent that will be added to the sample prior to measurement.",
				Category -> "Reagent Addition",
				IndexMatching -> SampleLink
			},
			ReagentMix -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the Reagent and sample will be mixed by aspiration prior to measurement.",
				Category -> "Reagent Addition",
				IndexMatching -> SampleLink
			},
			NeedleWash -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, Indicates if sheath fluid will be used to wash the injection needle after the sample measurement.",
				Category -> "Washing",
				IndexMatching -> SampleLink
			},
			NeedleInsideWashTime -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[0.5Second, 1Second, 2Second],
				Description -> "The amount of time the sheath fluid will be used to wash the inside of the injection needle after the sample measurement.",
				Category -> "Washing"
			},
			BlankFrequency -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Description -> "The frequency at which Blank samples will be inserted in the measurement sequence.",
				Category -> "InjectionOrder"
			},
			Blank -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample], Object[Sample]
				],
				Description -> "The samples containing wash solution used an extra wash between samples.",
				Category -> "InjectionOrder"
			},
			BlankInjectionVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 * Microliter, 5 * Milliliter],
				Units -> Microliter,
				Description -> "For each member of Blank, the speed at which the wash sample is run through the instrument during a flush.",
				Category -> "InjectionOrder",
				IndexMatching -> Blank
			},
			InjectionTable->{
				Format->Multiple,
				Class->{
					Expression,
					Link,
					Real,
					Real
				},
				Pattern:>{
					Sample|AdjustmentSample|UnstainedSample|Blank,
					_Link,
					GreaterEqualP[0 * Micro * Liter],
					GreaterEqualP[0 * Second]
				},
				Units->{
					None,
					None,
					Micro*Liter,
					Second
				},
				Relation->{
					Null,
					Alternatives[Object[Sample],Model[Sample]],
					Null,
					Null
				},
				Headers->{
					"Type",
					"Sample",
					"InjectionVolume",
					"AgitationTime"
				},
				Description->"The sequence of injections for a given experiment run for QualityControlBeads, Samples AdjustmentSamples UnstainedSample and Blanks.",
				Category->"InjectionOrder"
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			(*Other resources*)
			InjectionContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> ObjectP[{Model[Container], Object[Container]}],
				Relation -> Model[Container] | Object[Container],
				Description -> "The container in which the samples, blanks, and reagents are moved to before injection.",
				Category -> "Placements"
			},
			InjectionRack -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Container] | Object[Container],
				Description -> "The instrument rack which holds the injection containers during sample priming and injection.",
				Category -> "Placements",
				Developer -> True
			},
			(*Data Fields*)
			SampleWells->{
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Relation -> Null,
				Description -> "For each member of SampleLink, the wells that contain the samples.",
				Category-> "General",
				IndexMatching -> SampleLink
			},
			AdjustmentSampleWells->{
				Format -> Multiple,
				Class -> String,
				Pattern :> WellP,
				Relation -> Null,
				Description -> "For each member of Detector, the wells that contain the adjustment samples.",
				Category-> "General",
				IndexMatching -> Detector
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
			}
		}
	}
];
