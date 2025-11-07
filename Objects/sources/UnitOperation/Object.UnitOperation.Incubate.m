(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,Incubate],
	{
		Description->"A detailed set of parameters that specifies a single incubate step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
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
				Description -> "The samples that we are incubating.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The samples that we are incubating.",
				Category -> "General",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The samples that we are incubating.",
				Category -> "General",
				Migration->SplitField
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the Sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the Sample container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},

			(* This is either Sample or this is IntermediateContainer. *)
			WorkingSample -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],

					(* NOTE: This is only going to be a Model[Sample] if we're going to use a water purifier. *)
					Model[Sample]
				],
				Description -> "The current container in which our Sample sample is in, after any intermediate transfers.",
				Category -> "General",
				Developer -> True
			},

			(*-- OPTION FIELDS --*)
			ThawTime->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the length of time that samples should be thawed.",
				Category->"Incubation"
			},
			MaxThawTime->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->" the length of time that samples should be thawed.",
				Description->"For each member of SampleLink, the minimum interval at which the samples will be checked to see if they are thawed.",
				Category->"Incubation"
			},
			ThawTemperature->{
				Format->Multiple,
				Class->Real,
				Units->Celsius,
				Pattern:>GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature at which the samples should be thawed.",
				Category->"Incubation"
			},
			ThawInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Instrument,HeatBlock],
					Object[Instrument,HeatBlock]
				],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the instrument that will be used to thaw the sample.",
				Category->"Incubation"
			},
			Instrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Sequence@@Join[MixInstrumentModels,MixInstrumentObjects]
				],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the instrument used to perform the Mix and/or Incubation.",
				Category->"Incubation"
			},
			StirBar->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Part,StirBar],
					Object[Part,StirBar]
				],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the stir bar that should be used to stir the sample.",
				Category->"Incubation"
			},
			Time->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the duration of time for which the samples will be mixed.",
				Category->"Incubation"
			},
			MaxTime->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
				Category->"Incubation"
			},
			PreSonicationTime->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the duration of time for which the sonicator water bath degases prior to loading sample.",
				Category->"Incubation"
			},
			AlternateInstruments -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern:> _List,
				Description -> "For each member of SampleLink, the alternative instruments can be used to perform the Mix and/or Incubation. Currently, this field is only used when mixing with Sonicator.",
				Category -> "Incubation",
				IndexMatching -> SampleLink,
				Developer -> True
			},
			DutyCycle->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Null|{GreaterP[0 Minute], GreaterP[0 Minute]},
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
				Category->"Incubation"
			},
			DutyCycleOnTime->{
				Format->Multiple,
				Class->Real,
				Units->Second,
				Pattern:>TimeP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the On Time that specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed.",
				Category->"Incubation"
			},
			DutyCycleOffTime->{
				Format->Multiple,
				Class->Real,
				Units->Second,
				Pattern:>TimeP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the On Time that specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed.",
				Category->"Incubation"
			},
			MixRate->{
				Format->Multiple,
				Class->VariableUnit,
				Units->None,
				Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GraviationalAcceleration],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the frequency of rotation the mixing instrument should use to mix the samples.",
				Category->"Incubation"
			},
			MixRateProfile->{
				Format->Multiple,
				Class->Expression,
				Pattern:>_List,
				Description->"For each member of SampleLink, the frequency of rotation the mixing instrument should use to mix the samples, over the course of time.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},
			NumberOfMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Description->"For each member of SampleLink, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},
			MaxNumberOfMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Description->"For each member of SampleLink, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},
			MixVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Milliliter,
				Description->"For each member of SampleLink, the volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},
			TemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
				Category->"Incubation",
				Migration -> SplitField
			},
			TemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Ambient,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
				Category->"Incubation",
				Migration -> SplitField
			},
			TemperatureProfile->{
				Format->Multiple,
				Class->Expression,
				Pattern:>_List,
				Description->"For each member of SampleLink, the temperature of the device, over the course of time, that should be used to mix/incubate the sample.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},
			MaxTemperature->{
				Format->Multiple,
				Class->Real,
				Units->Celsius,
				Pattern:>GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the maximum temperature that the sample should reach during mixing via homogenization or sonication. If the measured temperature is above this MaxTemperature, the homogenizer/sonicator will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume.",
				Category->"Incubation"
			},
			RelativeHumidity->{
				Format->Multiple,
				Class->Real,
				Units->Percent,
				Pattern:>GreaterEqualP[0 Percent],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the amount of water vapor present in air that the samples will be exposed to during incubation, relative to the amount needed for saturation.",
				Category->"Incubation"
			},
			LightExposure->{
				Format->Multiple,
				Class->Expression,
				Pattern:>EnvironmentalChamberLightTypeP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the range of wavelengths of light that the incubated samples will be exposed to. Only available when incubating the samples in an environmental chamber with UVLight and VisibleLight control.",
				Category->"Incubation"
			},
			LightExposureIntensity->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern :> GreaterEqualP[0 (Watt/(Meter^2))] | GreaterEqualP[0 (Lumen/(Meter^2))],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the intensity of light that the incubated samples will be exposed to during the course of the incubation. UVLight exposure is measured in Watt/Meter^2 and Visible Light Intensity is measured in Lumen/Meter^2.",
				Category->"Incubation"
			},
			TotalLightExposure->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern :> GreaterEqualP[0 (Watt*Hour/(Meter^2))] | GreaterEqualP[0 (Lumen*Hour/(Meter^2))],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the total light exposure that the incubated samples will be experience during the course of the incubation. UVLight exposure is measured in Watt*Hour/Meter^2 and Visible Light exposure is measured in Lumen*Hour/Meter^2.",
				Category->"Incubation"
			},
			LightExposureStandard->{
				Format->Multiple,
				Class->Link,
				Pattern :> _Link,
				Relation -> Object[Sample]|Object[Container],
				Description->"During light exposure experiments, a set of samples that are placed in an opaque box to receive identical incubation conditions without exposure to light. This option can only be set if incubating other samples in an environmental stability chamber with light exposure.",
				Category->"Incubation"
			},
			OscillationAngle->{
				Format->Multiple,
				Class->Real,
				Units->AngularDegree,
				Pattern:>GreaterEqualP[0 AngularDegree],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the angle of oscillation of the mixing motion when a wrist action shaker is used.",
				Category->"Incubation"
			},
			Amplitude->{
				Format->Multiple,
				Class->Real,
				Units->Percent,
				Pattern:>PercentP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
				Category->"Incubation"
			},
			MixFlowRate->{
				Format->Multiple,
				Class->Real,
				Units->Microliter/Second,
				Pattern:>GreaterEqualP[0 Microliter/Second],
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, indicates the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},
			MixPosition->{
				Format->Multiple,
				Class->Expression,
				Pattern:>PipettingPositionP,
				Description -> "For each member of SampleLink, the location from which liquid should be mixed by pipetting. This option can only be set if Preparation->Robotic.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},
			MixPositionOffset->{
				Format->Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, the distance from the center of the well that the sample will be mixed via pipette. When specifying a Z Offset, the Z Offset is calculated either as the height below the top of the well, the height above the bottom of the well, or the height below the detected liquid level, depending on value of the DispensePosition option (Top|Bottom|LiquidLevel). When an DispenseAngle is specified, the DispensePositionOffset is measured in the frame of reference of the tilted labware (so that wells that are further away from the pivot point of the tilt are in the same frame of reference as wells that are close to the pivot point of the tilt).",
				Category->"Incubation"
			},
			MixTiltAngle->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the container will be tilted during the mixing of the sample via pipette. The container is pivoted on its left edge when tilting occurs.",
				Category->"Incubation"
			},
			PlateTilter -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, PlateTilter],
					Object[Instrument, PlateTilter]
				],
				Description -> "The robotically integrated plate tilter that will tilt the plates during the course of the mixing, if plate tilting is requested.",
				Category -> "General",
				Developer -> True
			},
			CorrectionCurve->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|Null,
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},
			Tips->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Tips],
					Object[Item, Tips]
				],
				Description -> "The pipette tips used to aspirate and dispense the requested volume.",
				Category->"Incubation"
			},
			TipType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> TipTypeP,
				Description -> "For each member of Tips, the tip type to use to mix liquid in the manipulation. This option can only be set if Preparation->Robotic.",
				Category->"Incubation",
				IndexMatching -> Tips
			},
			TipMaterial->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MaterialP,
				Description->"For each member of Tips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer. This option can only be set if Preparation->Robotic.",
				Category->"Incubation",
				IndexMatching -> Tips
			},
			MultichannelMix->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, indicates if multiple device channels should be used when performing pipette mixing. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},
			MultichannelMixName -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the unique identitifer for the multichannel mix. This option can only be set if Preparation->Robotic.",
				Category->"Incubation",
				IndexMatching->SampleLink
			},
			DeviceChannel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>DeviceChannelP,
				Description -> "For each member of SampleLink, the channel of the work cell that should be used to perform the pipetting mixing. This option can only be set if Preparation->Robotic.",
				IndexMatching->SampleLink,
				Category->"Incubation"
			},

			ResidualIncubation->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates if the incubation and/or mixing should continue after Time/MaxTime has finished while waiting to progress to the next step in the protocol.",
				Category->"Incubation"
			},
			ResidualTemperature->{
				Format->Multiple,
				Class->Real,
				Units->Celsius,
				Pattern:>GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature at which the sample(s) should remain incubating after Time has elapsed. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},
			ResidualMix->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates that the sample(s) should remain shaking at the ResidualMixRate after Time has elapsed. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},
			ResidualMixRate->{
				Format->Multiple,
				Class->Real,
				Units->RPM,
				Pattern:>GreaterEqualP[0 RPM],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates the rate at which the sample(s) should remain shaking after Time has elapsed, when mixing by shaking. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},
			Preheat->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates if the incubation position should be brought to Temperature before exposing the Sample to it. This option can only be set if Preparation->Robotic.",
				Category->"Incubation"
			},

			(* from current incubate parameters*)
			Impeller->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Part,StirrerShaft]|Object[Part,StirrerShaft],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the impeller that will be used to mix the sample.",
				Category->"Incubation"
			},
			Horn->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Part,SonicationHorn]|Object[Part,SonicationHorn],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the horn that will be used to sonicate the sample.",
				Category->"Incubation"
			},
			PlateSeal->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Item],Object[Item]],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the plate seal that will be used to seal the sample container if it is a plate.",
				Category->"Incubation"
			},
			ShakerAdapter->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part],Object[Part]],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the shaker adapter that will be used to contain the sample if it is used in a shaker.",
				Category->"Incubation"
			},
			StirBarRetriever->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part],Object[Part]],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the stir bar retriever that will be used to retrieve the stir bar after mixing.",
				Category->"Incubation"
			},
			FullyDissolved->{
				Format->Multiple,
				Class->{Expression,Integer,Expression},
				Pattern:>{_Symbol,_Integer,_List|BooleanP},
				Description->"Stores information about the completed batches of incubation and whether they were fully dissolved.",
				Category->"Incubation",
				Headers->{"Mix Type","Batch","Fully Dissolved List"},
				Developer->True
			},

			(* Transform fields *)
			Transform->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates if SampleLink are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				Category->"Incubation"
			},
			TransformHeatShockTemperature->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which the cells are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				Category->"Incubation"
			},
			TransformHeatShockTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"For each member of SampleLink, the length of time for which the cells are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				Category->"Incubation"
			},
			TransformPreHeatCoolingTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the length of time for which the cells are cooled prior to heat shocking.",
				Category->"Incubation"
			},
			TransformPostHeatCoolingTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Second,
				Description->"For each member of SampleLink, the length of time for which the cells are cooled after heat shocking.",
				Category->"Incubation"
			},
			TransformRecoveryMedia -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sample],
				IndexMatching -> SampleLink,
				Description -> "For each member of SampleLink, the nutrient-rich growth medium used to support the recovery of heat shocked cells. The sample object is used in full in its current container and should be prepared prior to the experiment.",
				Category -> "Incubation"
			},
			TransformRecoveryTransferVolumes -> {
				Format -> Multiple,
				Class -> {Real, Real},
				Pattern :> {GreaterP[0 Microliter], GreaterP[0 Microliter]},
				Units -> {Microliter, Microliter},
				Headers -> {"Initial transfer volume", "Secondary transfer volume"},
				IndexMatching -> SampleLink,
				Description -> "For each member of SampleLink, the volume of TransformRecoveryMedia added to the heat shocked cells, and the volume of the resulting mixture which is immediately transferred back into the container of TransformRecoveryMedia for incubation.",
				Category -> "Incubation",
				Developer -> True
			},
			TransformIncubator -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Instrument, Incubator],
					Model[Instrument, Incubator]
				],
				Description -> "For each member of SampleLink, the incubator used to house the mixture of heat shocked cells and TransformRecoveryMedia for recovery.",
				Category -> "Incubation",
				Developer -> True
			},
			TransformIncubatorTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "For each member of SampleLink, the temperature at which the mixture of heat shocked cells and TransformRecoveryMedia are housed in for recovery. Currently limited to 37 Degrees Celsius for incubation of bacterial cells.",
				Category -> "Incubation",
				Developer -> True
			},
			TransformIncubatorShakingRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "For each member of SampleLink, the frequency at which the mixture of heat shocked cells and TransformRecoveryMedia is agitated by movement in a circular motion for recovery. Currently limited to 200 RPM for incubation of bacterial cells.",
				Category -> "Incubation",
				Developer -> True
			},
			TransformRecoveryIncubationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "For each member of SampleLink, the duration for which the mixture of heat shocked cells and TransformRecoveryMedia is housed in TransformIncubator for recovery.",
				Category -> "Incubation",
				Developer -> True
			}
		}
	}
];
