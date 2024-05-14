(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Filter], {
	Description -> "A filtration experiment used to purify samples via a variety of different techniques.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {

		(* --- Filtration --- *)
		Filters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of SamplesIn, the filter used to remove impurities from the sample.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn
		},
		Target -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Filtrate | Retentate,
			Description -> "For each member of SamplesIn, indicates if the filtrate or retentate will populate SamplesOut.  Note that if set to Retentate, Filtrate will still be collected, just not put into SamplesOut.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn
		},
		FiltrateContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the containers the filtrate samples are either produced in or transferred into at the end of the experiment.",
			Category -> "Organizational Information",
			IndexMatching -> SamplesIn
		},
		FiltrateDestinationWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of FiltrateContainersOut, the positions of the containers in which the filtrate samples are either produced in or transferred into at the end of the experiment.",
			Category -> "Organizational Information",
			IndexMatching -> FiltrateContainersOut
		},
		RetentateContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the containers the retentate samples are transferred into at the end of the experiment.",
			Category -> "Organizational Information",
			IndexMatching -> SamplesIn
		},
		RetentateDestinationWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of RetentateContainersOut, the positions of the containers in which the retentate is transferred into at the end of the experiment.",
			Category -> "Organizational Information",
			IndexMatching -> RetentateContainersOut
		},
		FilterStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description -> "For each member of SamplesIn, the conditions under which any filters used by this experiment should be stored after the protocol is completed.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn
		},
		FiltrationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FiltrationTypeP,
			Description -> "The filtration method used to filter the samples.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		FiltrationInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument], Object[Container, Syringe]],
			Description -> "The instrument used to filter the samples specified in this protocol.",
			Category -> "Filtration"
		},
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SamplesIn, the instrument used to filter the samples specified in this protocol.",
			Category -> "Filtration",
			Developer -> True,
			IndexMatching -> SamplesIn
		},
		FilterHousing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, FilterHousing], Model[Instrument, FilterHousing]],
			Description -> "The instrument used to hold a filter membrane or plate when using a disc-type or plate-type filter.",
			Category -> "Filtration"
		},
		FilterHousings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, FilterHousing],
				Model[Instrument, FilterHousing],
				Object[Instrument, FilterBlock],
				Model[Instrument, FilterBlock]
			],
			Description -> "For each member of SamplesIn, the instruments used to hold a filter membrane or plate when using a disc-type or plate-type filter.",
			Category -> "Filtration",
			Developer -> True,
			IndexMatching -> SamplesIn
		},
		FiltrationPlatePreparation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "Sample manipulation protocol used to transfer samples into a filter plates.",
			Category -> "Filtration"
		},
		Syringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SamplesIn, the syringe used to force that sample through a filter.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn
		},
		Needles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item], Object[Item]],
			Description -> "For each member of SamplesIn, the needle used to aspirate that sample from its source container into a syringe.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn
		},
		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The location in which the filtrations are performed.",
			Category -> "Filtration",
			Developer -> True
		},
		RunTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Day],
			Units -> Hour,
			Description -> "For each member of SamplesIn, the estimated time for which the sample is filtered.",
			Category -> "Filtration",
			Developer -> True,
			IndexMatching -> SamplesIn
		},
		TransportContainer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "Container used to transport fragile filter membranes.",
			Category -> "Filtration",
			Developer -> True
		},
		TareWeighings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, MeasureWeight],
			Description -> "Protocols containing method information for tare weight measurements of the filtration destination containers.",
			Category -> "Filtration",
			Developer -> True
		},
		StoragePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|ManualSamplePreparationP,
			Description -> "A set of instructions specifying the transfers required to transfer the filtered samples into ContainersOut.",
			Category -> "Filtration",
			Developer -> True
		},
		(* --- Centrifugation --- *)
		CentrifugeSpeeds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0 * Revolution) / Minute],
			Units -> Revolution / Minute,
			Description -> "For each member of SamplesIn, the rates at which samples are spun in this centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		CentrifugeForces -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "For each member of SamplesIn, the relative centrifugal forces applied to samples in this centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		CentrifugeTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the amounts of time for which samples are spun in this centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		CentrifugeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperatures at which the centrifuge chamber is held during centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},

		Intensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 * GravitationalAcceleration] | GreaterP[0*RPM],
			Description -> "For each member of SamplesIn, the centrifugal forces or speeds applied to samples in this centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		Times -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the amounts of time for which samples are spun in this centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperatures at which the centrifuge chamber is held during centrifugal filtration.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the container collecting the filtrate after it has gone through the filter, if using a Buchner funnel or centrifugal filter.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		RetentateCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the container collecting the retentate via centrifugation.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		OccludingRetentateContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the container into which the retentate should be transferred if the filter becomes clogged.",
			Category -> "Filtration",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CounterbalanceWeights->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Gram],
			Units->Gram,
			Description->"For each member of SamplesIn, the weight of the item used as a counterweight for the sample, its container and any associated collection container or adapter.",
			Category->"Filtration",
			Developer->True,
			IndexMatching->SamplesIn
		},

		(* --- Cleaning --- *)
		CleaningSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SamplesIn, the solution used to clean the instrument tubing after the filtration has been completed.",
			Category -> "Cleaning",
			Developer -> True,
			IndexMatching -> SamplesIn
		},
		BlowGun -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, BlowGun], Model[Instrument, BlowGun]],
			Description -> "Indicates the blow gun used to flush remaining liquid out of filter lines after they've been cleaned.",
			Category -> "Cleaning",
			Developer -> True
		},

		(* --- Sensor Information --- *)
		WasteWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the filter waste container,measured at the start of the protocol.",
			Category -> "Sensor Information",
			Developer -> True
		},

		BatchInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "The instruments used to filter the samples specified in this protocol.",
			Category -> "Batching",
			Developer -> True
		},
		BatchingSingle -> {
			Format -> Multiple,
			Class -> {
				Instrument -> Link,
				Sterile -> Expression,
				RunTime -> Real,
				Filter -> Link,
				ContainerOut -> Link
			},
			Pattern :> {
				Instrument -> _Link,
				Sterile -> BooleanP,
				RunTime -> GreaterP[0 * Minute],
				Filter -> _Link,
				ContainerOut -> _Link
			},
			Relation -> {
				Instrument -> Alternatives[Object[Instrument], Model[Instrument]],
				Sterile -> Null,
				RunTime -> Null,
				Filter -> Alternatives[Object[Container], Model[Container], Object[Item], Model[Item]],
				ContainerOut -> Alternatives[Object[Container], Model[Container]]
			},
			Units -> {
				Instrument -> None,
				Sterile -> None,
				RunTime -> Minute,
				Filter -> None,
				ContainerOut -> None
			},
			Headers -> {
				Instrument -> "Instrument",
				Sterile -> "Sterile",
				RunTime -> "RunTime",
				Filter -> "Filter",
				ContainerOut -> "ContainerOut"
			},
			Description -> "Parameters describing how each batch will be filtered.",
			Category -> "Batching",
			Developer -> True
		},

		BatchingMultiple -> {
			Format -> Multiple,
			Class -> {
				SampleIn -> Link,
				ContainerIn -> Link,
				Position -> Expression,
				ContainerOut -> Link,
				Filter -> Link,
				FilterHousing -> Link,
				Syringe -> Link,
				Needle -> Link,
				CleaningSolution -> Link,
				Intensity -> Real,
				Time -> Real,
				Temperature -> Real,
				RunTime -> Real,
				PlatePrepPrimitives -> Expression,
				StoragePrimitives -> Expression,
				SampleIndex -> Expression,
				FilterStorageCondition -> Expression,
				CounterbalanceWeight -> Real,
				CollectionContainer -> Link
			},
			Pattern :> {
				SampleIn -> _Link,
				ContainerIn -> _Link,
				Position -> WellPositionP,
				ContainerOut -> _Link,
				Filter -> _Link,
				FilterHousing -> _Link,
				Syringe -> _Link,
				Needle -> _Link,
				CleaningSolution -> _Link,
				Intensity -> GreaterP[0 * GravitationalAcceleration],
				Time -> GreaterP[0 * Minute],
				Temperature -> GreaterP[0 * Kelvin],
				RunTime -> GreaterP[0 * Minute],
				PlatePrepPrimitives -> SampleManipulationP,
				StoragePrimitives -> SampleManipulationP,
				SampleIndex -> _Integer,
				FilterStorageCondition -> (SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
				CounterbalanceWeight -> GreaterP[0 Gram],
				CollectionContainer -> _Link
			},
			Relation -> {
				SampleIn -> Alternatives[Object[Sample], Model[Sample]],
				ContainerIn -> Alternatives[Object[Container], Model[Container]],
				Position -> Null,
				ContainerOut -> Alternatives[Object[Container], Model[Container]],
				Filter -> Alternatives[Object[Container], Model[Container], Object[Item], Model[Item]],
				FilterHousing -> Alternatives[Object[Instrument, FilterHousing], Model[Instrument, FilterHousing]],
				Syringe -> Alternatives[Object[Container], Model[Container]],
				Needle -> Alternatives[Object[Item], Model[Item]],
				CleaningSolution -> Alternatives[Model[Sample], Object[Sample]],
				Intensity -> Null,
				Time -> Null,
				Temperature -> Null,
				RunTime -> Null,
				PlatePrepPrimitives -> Null,
				StoragePrimitives -> Null,
				SampleIndex -> Null,
				FilterStorageCondition -> Null,
				CounterbalanceWeight -> Null,
				CollectionContainer -> Alternatives[Object[Container], Model[Container]]
			},
			Units -> {
				SampleIn -> None,
				ContainerIn -> None,
				Position -> None,
				ContainerOut -> None,
				Filter -> None,
				FilterHousing -> None,
				Syringe -> None,
				Needle -> None,
				CleaningSolution -> None,
				Intensity -> GravitationalAcceleration,
				Time -> Minute,
				Temperature -> Celsius,
				RunTime -> Minute,
				PlatePrepPrimitives -> None,
				StoragePrimitives -> None,
				SampleIndex -> None,
				FilterStorageCondition -> None,
				CounterbalanceWeight -> Gram,
				CollectionContainer -> None
			},
			Headers -> {
				SampleIn -> "SampleIn",
				ContainerIn -> "ContainerIn",
				Position -> "Position",
				ContainerOut -> "ContainerOut",
				Filter -> "Filter",
				FilterHousing -> "FilterHousing",
				Syringe -> "Syringe",
				Needle -> "Needle",
				CleaningSolution -> "CleaningSolution",
				Intensity -> "Intensity",
				Time -> "Time",
				Temperature -> "Temperature",
				RunTime -> "RunTime",
				PlatePrepPrimitives -> "PlatePrepPrimitives",
				StoragePrimitives -> "StoragePrimitives",
				SampleIndex -> "SampleIndex",
				FilterStorageCondition -> "FilterStorageCondition",
				CounterbalanceWeight -> "CounterbalanceWeight",
				CollectionContainer -> "CollectionContainer"
			},
			Description -> "Parameters describing how each each sample in a batch will be filtered.",
			Category -> "Batching",
			Developer -> True
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Parameters describing the length of each batch.",
			Category -> "Batching",
			Developer -> True
		},
		(* NOTE: These are all resource picked at once so that we can minimize trips to the VLM. *)
		RequiredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Sample],
				Model[Sample],
				Model[Item],
				Object[Item],
				Model[Part],
				Object[Part],
				Model[Plumbing],
				Object[Plumbing]
			],
			Description -> "Objects required for the protocol.",
			Category -> "General",
			Developer -> True
		},
		(* NOTE: These are resource picked on the fly, but we need this field so that ReadyCheck knows if we can start the protocol or not. *)
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Instruments required for the protocol.",
			Category -> "General",
			Developer -> True
		}
	}
}];
