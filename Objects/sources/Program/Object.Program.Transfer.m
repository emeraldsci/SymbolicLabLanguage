(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Program, Transfer], {
	Description->"A program providing the information needed to individually transfer a specified amount of sample from one location to another.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SampleIn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample from which this transfer is being made.",
			Category -> "General",
			Abstract -> True
		},
		ContainerIn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container of the sample from which this transfer is being made.",
			Category -> "General"
		},
		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples on which this transfer, incubation, or filtering is operating.",
			Category -> "General",
			Abstract -> True
		},
		ContainersIn -> {(* this field is used to list all items to be moved to the bench during wait primitives, so it required to match containers, samples, and items *)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Sample],
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "The containers of the samples on which this transfer is operating. Note that in a Wait primitive, this can contain all the items that will be moved, if a processing stage is triggered (including tips, weighboats, needles), thus it needs to take samples.",
			Category -> "General"
		},
		SourceWell -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "The well in the source container from which the sample is being transferred.",
			Category -> "General"
		},
		SampleOut -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample created as a result of this transfer and any others with the same destination.",
			Category -> "General"
		},
		ContainerOut -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container into which the source sample is transferred.",
			Category -> "General",
			Abstract -> True
		},
		DestinationWell -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "The well in the destination container into which the source sample is transferred.",
			Category -> "General"
		},
		TransferType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TransferTypeP,
			Description -> "Indicates the type of transfer being performed.",
			Category -> "General",
			Abstract -> True
		},
		Amount -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassP|VolumeP|_Integer,
			Description -> "The amount of the source sample to transfer.",
			Category -> "General",
			Abstract -> True
		},
		ScaledAmount -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassP|VolumeP|_Integer,
			Description -> "The amount of the source sample to transfer, scaled to meet the resolution of the measuring device.",
			Category -> "General",
			Developer -> True
		},
		Tolerance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassP,
			Description -> "The acceptable tolerance range for a measurement of the Amount.",
			Category -> "General",
			Developer -> True
		},
		GraduatedCylinder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The graduated cylinder used to measure out the amount being transferred.",
			Category -> "General"
		},
		Syringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The syringe used to measure out the amount being transferred.",
			Category -> "General"
		},
		Pipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The pipette used to measure out the amount being transferred.",
			Category -> "General"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The balance used to measure out the amount being transferred.",
			Category -> "General"
		},
		WaterPurifier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The water purifier used to dispense the water being transferred.",
			Category -> "General"
		},
		PipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The tips used with the pipette performing the transfer.",
			Category -> "General"
		},
		HandPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part]
			],
			Description -> "The hand pump used to transfer liquid out of a solvent drum.",
			Category -> "General"
		},
		HandPumpWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect extra solvent from use of hand pumps to transfer liquid out of chemical drums.",
			Category -> "General",
			Developer -> True
		},
		Needle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe needle used to pierce a hermetically sealed source container.",
			Category -> "General"
		},
		BackfillNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe needle used to pierce a hermetically sealed source container.",
			Category -> "General",
			Description -> "The syringe needle used to pierce a hermetically sealed source container while attached to an inert gas line to backfill the source container during aspiration.",
			Category -> "General"
		},
		WeighBoat -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe needle used to pierce a hermetically sealed source container.",
			Category -> "General",
			Description -> "A disposable dish into which the source sample is measured in order to weigh out the required transfer amount.",
			Category -> "General"
		},
		Funnel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,Funnel],
				Object[Part,Funnel]
			],
			Description -> "A funnel used to guide liquid or solid chemicals into the container when transfering into a volumetric flask.",
			Category -> "General"
		},
		SelfStandingContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Rack],
				Object[Container,Rack]
			],
			Description -> "A rack for holding the destination container upright during a transfer.",
			Category -> "General"
		},
		TareWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The reading on the balance after it has been tared with any weigh boats on the pan.",
			Category -> "General"
		},
		TransferWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight of the weigh container when filled with the amount of sample needed to complete the transfer.",
			Category -> "General"
		},
		ResidueWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight of the weigh boat after weighing is complete and the sample has been transferred out of the weigh boat and into the destination.",
			Category -> "General"
		},
		MixProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation],Object[Protocol,RoboticSamplePreparation]],
			Description -> "Protocols used to mix the SamplesIn.",
			Category -> "Sample Preparation"
		},
		IntermediateTransfer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this is an intermediate transfer into a temporary container.",
			Category -> "General",
			Developer -> True
		},

		VolumeMeasurementDevice -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to measure the volume of a solution during a fill to volume transfer.",
			Category -> "General"
		},
		VolumeMeasurementRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The rack that needs to be used with VolumeMeasurementDevice.",
			Category -> "General"
		},

		FillToVolumeTransfer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this is an fill to volume transfer.",
			Category -> "General",
			Developer -> True
		},
		FillToVolumeTransferType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FillToVolumeTransferTypeP,
			Description -> "Indicated the type of this fill to volume transfer.",
			Category -> "General",
			Developer -> True
		},
		BulkVolumetricTransfer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this is a volumetric transfer where solvent is added to a volumetric flask until it reaches the neck.",
			Category -> "General",
			Developer -> True
		},
		FineVolumetricTransfer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this is a volumetric transfer where solvent is added to a volumetrick flask until it reaches the graduation mark.",
			Category -> "General",
			Developer -> True
		},

		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument],
				Object[Container]
			],
			Description -> "The location in which this transfer is performed.",
			Category -> "General",
			Developer -> True
		},
		(* Incubate Macro fields - all multiple *)
		MixBooleans -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the SamplesIn should be mixed (as opposed to incubation without mixing).",
			Category -> "Sample Preparation"
		},
		Times -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Duration for which the SamplesIn are incubated or centrifuged.",
			Category -> "Sample Preparation"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :>TemperatureP,
			Units -> Celsius,
			Description -> "Temperature at which the SamplesIn are incubated or centrifuged.",
			Category -> "Sample Preparation"
		},
		CounterbalanceWeights->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Gram],
			Units->Gram,
			Description-> "For each member of SamplesIn, the weight of the item used as a counterweight for the sample, its container and any associated collection container or adapter.",
			Category->"Filtration",
			Developer->True,
			IndexMatching->SamplesIn
		},
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the mixing, incubation, centrifugation, or filtration.",
			Category -> "Sample Preparation"
		},
		NumbersOfMixes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			Category -> "General"
		},
		MixesUntilDissolved -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute.",
			Category -> "Sample Preparation"
		},
		MixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Frequency of rotation the mixing instrument used to mix the SamplesIn.",
			Category -> "Sample Preparation"
		},
		MixTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MixTypeP,
			Description -> "The type of instrument used to mix or incubate the SamplesIn.",
			Category -> "Sample Preparation"
		},
		MixVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
			Category -> "Sample Preparation"
		},
		MaxNumbersOfMixes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1, 50, 1],
			Description -> "Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
			Category -> "Sample Preparation"
		},
		MaxTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
			Category -> "Sample Preparation"
		},
		NumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Tne number of times the sample should be pipetted up and down in order to mix it.",
			Category -> "General"
		},
		AnnealingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "Duration for which the SamplesIn remain in the incubator after IncubateTime has passed allowing the system to settle to room temperature.",
			Category -> "Sample Preparation"
		},
		ResidualIncubations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the incubation and/or mixing of SamplesIn should continue after Times/MaxTimes has finished while waiting to progress to the next step in the Incubate protocol.",
			Category -> "Sample Preparation"
		},
		IncubateProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation],Object[Protocol,RoboticSamplePreparation]],
			Description -> "Protocols used to incubate the SamplesIn.",
			Category -> "Sample Preparation"
		},
		CentrifugeProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Centrifuge],Object[Protocol,ManualSamplePreparation],Object[Protocol,RoboticSamplePreparation]],
			Description -> "Protocols used to centrifuge the SamplesIn.",
			Category -> "Sample Preparation"
		},
		PelletProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Pellet],Object[Protocol,ManualSamplePreparation],Object[Protocol,RoboticSamplePreparation]],
			Description -> "Protocols used to pellet the SamplesIn.",
			Category -> "Sample Preparation"
		},
		Duration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "Duration of the pause when executing a Wait primitive.",
			Category -> "Sample Preparation"
		},
		Manipulations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A list of manipulations which resulted in creation of the program transfer.",
			Category -> "General"
		},
		Subtransfers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program],
			Description -> "Set of distinct transfers needed to accomplish this transfer.",
			Category -> "General",
			Developer->True
		},
		DateStarted->{
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the first step of this program's execution was finished.",
			Category -> "Sample Preparation"
		},
		DateCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the last step of this program's execution was finished.",
			Category -> "Sample Preparation"
		},

		(* Pelleting Macro fields *)
		SupernatantDestinations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Link|Waste,
			Description -> "The destination that the supernatant should be dispensed into, after aspirated from the source sample.",
			Category -> "Sample Preparation"
		},
		SupernatantVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> VolumeP|All,
			Description -> "The volume of the supernatant that should be aspirated from the source sample.",
			Category -> "Sample Preparation"
		},
		SupernatantTransferInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "The pipette that will be used to transfer off the supernatant from the source sample.",
			Category -> "Sample Preparation"
		},
		ResuspensionSources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample that should be used to resuspend the pellet from the source sample.",
			Category -> "Sample Preparation"
		},
		ResuspensionVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> VolumeP|All,
			Description -> "The volume of ResuspensionSource that should be used to resuspend the pellet from the source sample.",
			Category -> "Sample Preparation"
		},
		ResuspensionInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "The pipette that will be used to resuspend the pellet from the source sample..",
			Category -> "Sample Preparation"
		},
		ResuspensionMix -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixType -> Expression,
				MixUntilDissolved -> Boolean,
				Instrument -> Link,
				Time -> Real,
				MaxTime -> Real,
				DutyCycle-> Expression,
				MixRate->Real,
				NumberOfMixes->Real,
				MaxNumberOfMixes->Real,
				MixVolume->Real,
				Temperature->Real,
				MaxTemperature->Real,
				Amplitude->Real
			},
			Pattern :> {
				Mix -> BooleanP,
				MixType -> MixTypeP,
				MixUntilDissolved -> BooleanP,
				Instrument -> ObjectP[{Object[Instrument], Model[Instrument]}],
				Time->TimeP,
				MaxTime->TimeP,
				DutyCycle->_List,
				MixRate->RPMP,
				NumberOfMixes->GreaterEqualP[0],
				MaxNumberOfMixes->GreaterEqualP[0],
				MixVolume->VolumeP,
				Temperature->TemperatureP,
				MaxTemperature->TemperatureP,
				Amplitude->PercentP
			},
			Units -> {
				Mix -> None,
				MixType -> None,
				MixUntilDissolved -> None,
				Instrument -> None,
				Time->Minute,
				MaxTime->Minute,
				DutyCycle->None,
				MixRate->RPM,
				NumberOfMixes->None,
				MaxNumberOfMixes->None,
				MixVolume->Milliliter,
				Temperature->Celsius,
				MaxTemperature->Celsius,
				Amplitude->Percent
			},
			Relation -> {
				Mix -> Null,
				MixType -> Null,
				MixUntilDissolved -> Null,
				Instrument -> Alternatives[Model[Instrument],Object[Instrument]],
				Time->Null,
				MaxTime->Null,
				DutyCycle->Null,
				MixRate->Null,
				NumberOfMixes->Null,
				MaxNumberOfMixes->Null,
				MixVolume->Null,
				Temperature->Null,
				MaxTemperature->Null,
				Amplitude->Null
			},
			Description -> "Parameters describing how the input samples should be mixed upon resuspension.",
			Category -> "Sample Preparation"
		},

	(* Filter Macro fields - all multiple *)

		FiltrationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FiltrationTypeP,
			Description -> "The filtration method used to filter the samples.",
			Category -> "Sample Preparation",
			Developer->True
		},
		Syringes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"The syringes used to force that sample through a filter.",
			Category->"Sample Preparation"
		},
		FilterHousings->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument, FilterHousing],
				Model[Instrument, FilterHousing],
				Object[Instrument, FilterBlock],
				Model[Instrument, FilterBlock]
			],
			Description->"The instruments used to hold a filter membrane when using a disc type filter.",
			Category->"Sample Preparation"
		},
		Speeds -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 RPM],GreaterP[0*GravitationalAcceleration]],
			Units -> None,
			Description -> "The relative centrifugal forces applied to centrifuged samples.",
			Category -> "Sample Preparation"
		},
		Filters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Alternatives[Object[Container],Model[Container],Object[Item],Model[Item]],
			Description -> "The filters used to pass through samples during this filtration.",
			Category -> "Sample Preparation"
		},
		FilterStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
			Description->"The conditions under which any filters used by this experiment should be stored after the protocol is completed.",
			Category -> "Sample Preparation"
		},
		MembraneMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The membrane materials that should be used to filter the samples.",
			Category -> "Sample Preparation"
		},
		PoreSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterSizeP,
			Description -> "The pore size of the filter; all particles larger than this should be removed during the filtration.",
			Category -> "Sample Preparation"
		},
		MolecularWeightCutoffs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterMolecularWeightCutoffP,
			Description -> "The molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
			Category -> "Sample Preparation"
		},
		PrefilterMembraneMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The membrane materials of the prefilter that should be used to filter the samples.",
			Category -> "Sample Preparation"
		},
		PrefilterPoreSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterSizeP,
			Description -> "The pore size of the prefilter; all particles larger than this should be removed during the filtration.",
			Category -> "Sample Preparation"
		},
		Sterile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "The pore size of the prefilter; all particles larger than this should be removed during the filtration.",
			Category -> "Sample Preparation"
		},
		CollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers into which the source samples are filtered.",
			Category -> "General"
		},
		ContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers into which the source samples are transferred after filtering.",
			Category -> "General"
		},
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples created as a result of this filtration.",
			Category -> "General"
		},
		FilterProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Filter],Object[Protocol,ManualSamplePreparation],Object[Protocol,RoboticSamplePreparation]],
			Description -> "Protocols used to filter the SamplesIn.",
			Category -> "Sample Preparation"
		}
	}
}];
