(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, Filter], {
	Description -> "The information that specifies the information of how to perform a filter operation using the same instrument on one or multiple samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Sample-related fields *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "Sample to be filtered in this experiment.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "Sample to be filtered in this experiment.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
			Relation -> Null,
			Description -> "Sample to be filtered in this experiment.",
			Category -> "General",
			Migration -> SplitField
		},
		(* This is either Sample or the corresponding WorkingSamples after aliquoting etc. *)
		WorkingSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleLink, the samples to be filtered after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Developer -> True
		},
		WorkingContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of SampleLink, the containers holding the samples to be filtered after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Developer -> True
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample that goes into the filter.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample's container that goes into the filter.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		FiltrateSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleLink, the filtrate sample either produced in or transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		FiltrateContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SampleLink, the container the filtrate samples are either produced in or transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		FiltrateContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the containers the filtrate samples are either produced in or transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		FiltrateContainerOutExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Automatic, {_Integer | _String, _String | ObjectP[{Model[Container], Object[Container]}]}],
			Relation -> Null,
			Description -> "For each member of SampleLink, the containers the filtrate samples are either produced in or transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		FiltrateDestinationWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of SampleLink, the position of the container in which the filtrate samples should be either produced in or transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		FiltrateLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample that has gone through the filter.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		FiltrateContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample's container that has gone through the filter.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ResuspensionBufferLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample that is resuspending the retentate.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ResuspensionBufferContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the container of the sample that is resuspending the retentate.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		RetentateSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleLink, the retentate samples either created or transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		RetentateContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SampleLink, the containers the retentate samples are transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		RetentateContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the containers the retentate samples are transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		RetentateContainerOutExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Automatic, {_Integer | _String, _String | ObjectP[{Model[Container], Object[Container]}]}],
			Relation -> Null,
			Description -> "For each member of SampleLink, the containers the retentate samples are transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		RetentateDestinationWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of SampleLink, the positions of the containers in which the retentate should be transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		RetentateLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample that was retained on the filter and subsequently collected.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		RetentateContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample's container that was retained on the filter and subsequently collected.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CollectOccludingRetentate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates that if the filter becomes occluded or clogged during the course of filtration, all retentate that cannot be passed through the filter should be collected into the OccludingRetentateContainer.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		OccludingRetentateContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of CollectOccludingRetentate, indicates the container into which the retentate should be transferred if the filter becomes clogged.",
			Category -> "General",
			IndexMatching -> CollectOccludingRetentate,
			Migration -> SplitField
		},
		OccludingRetentateContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of CollectOccludingRetentate, indicates the container into which the retentate should be transferred if the filter becomes clogged.",
			Category -> "General",
			IndexMatching -> CollectOccludingRetentate,
			Migration -> SplitField
		},
		OccludingRetentateDestinationWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of CollectOccludingRetentate, the desired position in the corresponding OccludingRetentateContainer in which the occluding retentate samples will be placed.",
			Category -> "General",
			IndexMatching -> CollectOccludingRetentate
		},
		OccludingRetentateContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of CollectOccludingRetentate, the label of the container into which the retentate should be transferred if the filter becomes clogged.",
			Category -> "General",
			IndexMatching -> CollectOccludingRetentate
		},
		Target -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Filtrate, Retentate],
			Description -> "For each member of SampleLink, indicates if the filtrate samples or retentate samples should populate SamplesOut.  Note that if set to Retentate, Filtrate will still be collected as well, just not populated in SamplesOut.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of SampleLink, the SamplesOut (whether the Filtrate or Retentate) after all the filtration steps.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the sample that becomes the SamplesOut (whether the Filtrate or Retentate).",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the container that holds the sample that becomes the SamplesOut (whether the Filtrate or Retentate).",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, PeristalticPump],
				Object[Instrument, PeristalticPump],
				Model[Instrument, VacuumPump],
				Object[Instrument, VacuumPump],
				Model[Instrument, Centrifuge],
				Object[Instrument, Centrifuge],
				Model[Instrument, SyringePump],
				Object[Instrument, SyringePump],
				(* MPE2s *)
				Model[Instrument, PressureManifold],
				Object[Instrument, PressureManifold]
			],
			Description -> "For each member of SampleLink, the instrument used to perform the filtration.",
			Category -> "Filtration",
			Abstract -> True,
			IndexMatching -> SampleLink
		},
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, SchlenkLine],
				Object[Instrument, SchlenkLine]
			],
			Description -> "The instrument used to channel the vacuum from the pump to the filter flask when performing Buchner funnel filtration.",
			Category -> "Filtration"
		},
		SchlenkConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Instrument], Null},
			Description -> "The connection information for attaching the vacuum tubing to the schlenk line when performing Buchner unnel filtration.",
			Headers -> {"Vacuum Tubing", "Vacuum Tubing Connector Name", "Schlenk Line", "Shlenk Line Port Name"},
			Category -> "Filtration"
		},
		Spatula -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Spatula],
				Object[Item, Spatula]
			],
			Description -> "The item used to move the solid retentate from the filter into the RetentateContainerOut if RetentateCollectionMethod -> Transfer.",
			Category -> "General",
			Abstract -> True
		},
		Sterile -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the filtration of the samples should be done in a sterile environment.",
			Category -> "Filtration",
			Abstract -> True,
			IndexMatching -> SampleLink
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "Indicates the estimated duration of all filtrations grouped in this primitive.",
			Category -> "Filtration"
		},
		FilterLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of FilterLink, the label of the filter through which the sample is forced.",
			Category -> "General",
			IndexMatching -> FilterLink
		},
		FilterPosition -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of FilterLink, the positions of the filter in which the working samples should be transferred into prior to filtering.",
			Category -> "General",
			IndexMatching -> FilterLink
		},
		VolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the amount of sample to be transferred into the filter (if it is not already there) prior to its filtration.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		VolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the amount of sample to be transferred into the filter (if it is not already there) prior to its filtration.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		Pressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * PSI],
			Units -> PSI,
			Description -> "For each member of SampleLink, the target pressure applied to the filter.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		MembraneMaterial -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Relation -> Null,
			Description -> "For each member of SampleLink, the material from which the filtration membrane should be made of.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		PrefilterMembraneMaterial -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Relation -> Null,
			Description -> "For each member of SampleLink, the material from which the prefilter filtration membrane should be made of.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		PoreSize -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterSizeP,
			Relation -> Null,
			Description -> "For each member of SampleLink, the pore size of the filter; all particles larger than this should be removed during the filtration.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		MolecularWeightCutoff -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterMolecularWeightCutoffP,
			Relation -> Null,
			Description -> "For each member of SampleLink, the molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		(*PrefilterPoreSize -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FilterSizeP,
			Relation -> Null,
			Description -> "For each member of SampleLink, the pore size of the prefilter; all particles larger than this should be removed during the filtration.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},*)
		Syringe -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of SampleLink, the syringe used to force that sample through a filter.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		DestinationRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "For each member of FiltrateContainerOutLink, the rack that it used to hold the container into which sample is filtered.",
			Category -> "Filtration",
			IndexMatching -> FiltrateContainerOutLink
		},
		FlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0 * (Liter * Milli)) / Minute],
			Units -> (Liter Milli) / Minute,
			Description -> "For each member of SampleLink, the rate at which liquid is dispensed from the syringe through the filter.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		Needle -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SampleLink, the needle used to aspirate that sample from its source container into a syringe.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		CleaningSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleLink, the solution used to clean the instrument tubing after the filtration has been completed.",
			Category -> "Cleaning",
			IndexMatching -> SampleLink
		},
		Intensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> (GreaterP[0 GravitationalAcceleration] | GreaterP[0 RPM]),
			Description -> "For each member of SampleLink, the rotational speed or force at which the samples will be centrifuged during filtration.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		CollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SampleLink, the container collecting the filtrate after it has gone through the filter, if using a Buchner funnel or centrifugal filter.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		CollectionContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the container collecting the filtrate after it has gone through the filter, if using a Buchner funnel or centrifugal filter.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		CollectionContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of CollectionContainerLink, the label of the container that will be used to accumulate the filtrate when filtering by Centrifuge or Vacuum and Buchner funnel (if applicable).",
			Category -> "General",
			IndexMatching -> CollectionContainerLink
		},

		RetentateCollectionContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SampleLink, the container collecting the retentate via centrifugation.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		RetentateCollectionContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the container collecting the retentate via centrifugation.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		Time -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration for which the sample will be filtered.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		Temperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the samples will be filtered.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		FilterUntilDrained -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Time, indicates if the filtration should be continued until the source sample has all been filtered, or up to the correpsonding MaxTime, in an attempt to filter the entire source sample.",
			Category -> "Filtration",
			IndexMatching -> Time
		},
		MaxTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of Time, maximum duration of time for which the samples will be filtered, if the FilterUntilDrained option is chosen.",
			Category -> "Filtration",
			IndexMatching -> Time
		},
		StartDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "For each member of SampleLink, the timestamp at which filtering was begun.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},

		(* Retentate wash options *)
		CollectRetentate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the retentate captured by the filter should be retrieved and transferred to a new container.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		RetentateCollectionMethod -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Resuspend | Transfer | Centrifuge,
			Description -> "For each member of SampleLink, indicates how resuspended retentate should be transferred into RetentateContainerOut.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		WashRetentate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the retentate captured by the filter should be washed with a buffer prior to collection.",
			Category -> "Filtration"
		},
		RetentateWashBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "Batch length for each retentate washing step.",
			Category -> "Filtration"
		},
		RetentateWashBuffer -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[] | _String | Null)..} | ObjectP[] | _String,
			Description -> "The sample that is run through the retentate and filter after initial filtration prior to retentate collection.",
			Category -> "Filtration"
		},
		RetentateWashBufferResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "The sample that is run through the retentate and filter after initial filtration prior to retentate collection.",
			Category -> "Filtration"
		},
		RetentateWashBufferLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(_String | Null)..} | _String,
			Description -> "For each member of RetentateWashBuffer, the label of the sample that is washing the retentate.",
			Category -> "General",
			IndexMatching -> RetentateWashBuffer
		},
		RetentateWashBufferContainerLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(_String | Null)..},
			Description -> "For each member of RetentateWashBuffer, the label of the container of the sample that is washing the retentate.",
			Category -> "General",
			IndexMatching -> RetentateWashBuffer
		},
		WashFlowThroughLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(_String | Null)..},
			Description -> "For each member of RetentateWashBuffer, the label of the flow through sample that has come through the filter.",
			Category -> "General",
			IndexMatching -> RetentateWashBuffer
		},
		WashFlowThroughContainerLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(_String | Null)..},
			Description -> "For each member of RetentateWashBuffer, the label of the container of the flow through sample that has come through the filter.",
			Category -> "General",
			IndexMatching -> RetentateWashBuffer
		},
		WashFlowThroughSample -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[] | Null)..} | ObjectP[],
			Description -> "The sample that is collected through the filter during retentate wash.",
			Category -> "Filtration"
		},
		WashFlowThroughContainer -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[] | _String | Null)..},
			Description -> "For each member of RetentateWashBuffer, the containers the retentate samples are transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> RetentateWashBuffer
		},
		WashFlowThroughContainerResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The containers the retentate samples are transferred into at the end of the experiment.",
			Category -> "Filtration"
		},
		WashFlowThroughDestinationWell -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(WellP | Null)..},
			Description -> "For each member of RetentateWashBuffer, the position of the container in which the flow samples should be transferred into at the end of the experiment.",
			Category -> "General",
			IndexMatching -> RetentateWashBuffer
		},
		WashFlowThroughStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]] | Null)..},
			Description -> "For each member of RetentateWashBuffer, the conditions under which the flow through samples experiment should be stored after the protocol is completed.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		RetentateWashVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Milliliter] | Null)..} | GreaterP[0 Milliliter],
			Description -> "For each member of RetentateWashBuffer, the amount of that buffer that is run through the retentate and filter after initial filtration prior to retentate collection.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		NumberOfRetentateWashes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[0, 1] | Null)..} | GreaterEqualP[0, 1],
			Description -> "For each member of RetentateWashBuffer, the number of times to run RetentateWashBuffer through the retentate and filter after initial filtration prior to retentate collection.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		RetentateWashDrainTime -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Minute] | Null)..} | GreaterP[0 Minute],
			Description -> "For each member of RetentateWashBuffer, the amount of time for which the samples will be washed with RetentateWashBuffer after initial filtration and prior to retentate collection.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		RetentateWashCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 GravitationalAcceleration] | GreaterP[0 RPM] | Null)..} | GreaterP[0 GravitationalAcceleration] | GreaterP[0 RPM],
			Description -> "For each member of RetentateWashBuffer, the rotational speed or force at which the retentate that has been washed with RetentateWashBuffer after initial filtration and prior to retentate collection.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		RetentateWashMix -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(BooleanP | Null)..} | BooleanP,
			Description -> "For each member of RetentateWashBuffer, indicates if after RetentateWashBuffer is added to the retentate, the retentate should be mixed prior to filtering wash buffer out.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		NumberOfRetentateWashMixes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1] | Null)..} | GreaterP[0, 1],
			Description -> "For each member of RetentateWashBuffer, the number of times the retentate should be pipetted if WashRetentate -> True and RetentateWashMix -> True.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},
		RetentateWashPressure -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 * PSI] | Null)..},
			Description -> "For each member of RetentateWashBuffer, the target pressure applied to the retentate that has been washed with RetentateWashBuffer after initial filtration and prior to retentate collection.",
			Category -> "Filtration",
			IndexMatching -> RetentateWashBuffer
		},

		ResuspensionBufferLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of RetentateCollectionMethod, the desired sample in which the retentate is resuspended prior to being transferred to RetentateDestinationWell of RetentateContainerOut.",
			Category -> "Filtration",
			IndexMatching -> RetentateCollectionMethod,
			Migration -> SplitField
		},
		ResuspensionBufferString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of RetentateCollectionMethod, the desired sample in which the retentate is resuspended prior to being transferred to RetentateDestinationWell of RetentateContainerOut.",
			Category -> "Filtration",
			IndexMatching -> RetentateCollectionMethod,
			Migration -> SplitField
		},
		ResuspensionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of ResuspensionBufferLink, the volume of ResuspensionBuffer to be added to the retentate.",
			Category -> "Filtration",
			IndexMatching -> ResuspensionBufferLink
		},
		NumberOfResuspensionMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "For each member of ResuspensionBufferLink, the number of times the retentate should be pipetted if RetentateCollectionMethod -> Transfer.",
			Category -> "Filtration",
			IndexMatching -> ResuspensionBufferLink
		},
		ResuspensionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "A set of instructions specifying the transfer of buffers into the retentate for resuspension and subsequent transfer out.",
			Category -> "Filtration",
			Developer -> True
		},
		PrewetFilterLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "A set of instructions specifying the transfer of the PrewetFilterBuffer into the filters.",
			Category -> "Filtration",
			Developer -> True
		},
		FilterLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "A set of instructions specifying the transfer of samples into the filters.",
			Category -> "Filtration",
			Developer -> True
		},
		SamplesOutStoragePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "A set of instructions specifying the transfer of samples into the FiltrateContainersOut.",
			Category -> "Filtration",
			Developer -> True
		},
		WashFlowThroughStoragePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "A set of instructions specifying the transfer of samples into the WashFlowThroughContainer.",
			Category -> "Filtration",
			Developer -> True
		},
		RetentateWashCentrifugePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "For each member of RetentateWashBatchLengths, a set of instructions indicating the centrifugation of samples whose retentate has been washed by RetentateWashBuffer.",
			IndexMatching -> RetentateWashBatchLengths,
			Category -> "Filtration",
			Developer -> True
		},
		PrewetFilterCentrifugeUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation, Centrifuge],
			Description -> "A set of instructions specifying the centrifugation of filters with PrewetFilterBuffer in them.",
			Category -> "Filtration",
			Developer -> True
		},
		FilterCentrifugeUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation, Centrifuge],
			Description -> "A set of instructions specifying the centrifugation of filters with samples in them.",
			Category -> "Filtration",
			Developer -> True
		},
		RetentateWashCentrifugeUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation, Centrifuge],
			Description -> "For each member of RetentateWashBatchLengths, a set of instructions indicating the centrifugation of samples whose retentate has been washed by RetentateWashBuffer.",
			IndexMatching -> RetentateWashBatchLengths,
			Category -> "Filtration",
			Developer -> True
		},

		(* prewetting options *)
		PrewetFilter -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the filter should be pre-wet with PrewetFilterBuffer before the input sample is run through it.",
			IndexMatching -> SampleLink,
			Category -> "Filtration"
		},
		NumberOfFilterPrewettings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "For each member of PrewetFilter, indicates the number of times the filter should be pre-wet with PrewetFilterBuffer (or the initial StorageBuffer) before the input sample is run through it.",
			IndexMatching -> PrewetFilter,
			Category -> "Filtration"
		},
		PrewetFilterTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of PrewetFilter, indicates the length of time the PrewetFilterBuffer is run through the filter to pre-wet it.",
			IndexMatching -> PrewetFilter,
			Category -> "Filtration"
		},
		PrewetFilterBufferVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of PrewetFilter, indicates the amount of PrewetFilterBuffer to run through the filter prior to running the sample through.",
			IndexMatching -> PrewetFilter,
			Category -> "Filtration"
		},
		PrewetFilterCentrifugeIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> (GreaterP[0 GravitationalAcceleration] | GreaterP[0 RPM]),
			Description -> "For each member of PrewetFilterBufferLink, the rotational speed or force at which it will be centrifuged during filtration.",
			Category -> "Filtration",
			IndexMatching -> PrewetFilterBufferLink
		},
		PrewetFilterBufferLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of PrewetFilter, indicates the sample to run through the filter prior to running the input sample through the filter.",
			IndexMatching -> PrewetFilter,
			Migration -> SplitField,
			Category -> "Filtration"
		},
		PrewetFilterBufferString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of PrewetFilter, indicates the sample to run through the filter prior to running the input sample through the filter.",
			IndexMatching -> PrewetFilter,
			Migration -> SplitField,
			Category -> "Filtration"
		},
		PrewetFilterBufferLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of PrewetFilter, indicates the label of the sample run through the fitler prior to running the input sample through the filter.",
			IndexMatching -> PrewetFilter,
			Migration -> SplitField,
			Category -> "Filtration"
		},
		PrewetFilterContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of PrewetFilter, indicates the container that is be used to accumulate the filtrate during the prewetting step.",
			IndexMatching -> PrewetFilter,
			Migration -> SplitField,
			Category -> "Filtration"
		},
		PrewetFilterContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of PrewetFilter, indicates the container that is be used to accumulate the filtrate during the prewetting step.",
			IndexMatching -> PrewetFilter,
			Migration -> SplitField,
			Category -> "Filtration"
		},
		PrewetFilterContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of PrewetFilter, indicates the label of the container that is be used to accumulate the filtrate during the prewetting step.",
			IndexMatching -> PrewetFilter,
			Migration -> SplitField,
			Category -> "Filtration"
		},

		(* TODO might need some weird tip stuff for doing the retentate wash/transfer stuff but not going to worry about that until I get to the procedure *)
		BuchnerFunnel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "For each member of FilterLink, the funnel that is used to hold the filter paper and collect the source sample as it is pulled into the destination container.",
			Category -> "Filtration",
			IndexMatching -> FilterLink
		},
		FilterAdapter -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, FilterAdapter],
				Object[Part, FilterAdapter]
			],
			Description -> "For each member of BuchnerFunnel, the adapter that creates the seal between the collection container and the funnel when under vacuum.",
			Category -> "Filtration",
			IndexMatching -> BuchnerFunnel
		},
		VacuumTubing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Plumbing, Tubing],
				Object[Plumbing, Tubing]
			],
			Description -> "The tubing that connects the filter flask with the schlenk line in the case of Buchner funnel filtration.",
			Category -> "Filtration"
		},
		CounterbalanceWeight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Gram],
			Units -> Gram,
			Description -> "For each member of SampleLink, the weight of the item used as a counterweight for the sample, its container and any associated collection container or adapter.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},
		CounterweightLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Counterweight],
				Object[Item, Counterweight]
			],
			Description -> "For each member of SampleLink, the counterweight to the input container.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		CounterweightString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the counterweight to the input container.",
			Category -> "Filtration",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},

		FilterStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]),
			Description -> "For each member of SampleLink, the conditions under which any filters used by this experiment should be stored after the protocol is completed.",
			Category -> "Filtration",
			IndexMatching -> SampleLink
		},

		(* pipetting fields *)
		Tips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The pipette tips used to aspirate and dispense the requested volume.",
			Category -> "General"
		},
		TipType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of Tips, the type of pipette tips used to aspirate and dispense the requested volume during the transfer.",
			Category -> "General",
			IndexMatching -> Tips
		},
		TipMaterial -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "For each member of Tips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
			Category -> "General",
			IndexMatching -> Tips
		},
		ReversePipetting -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination position.",
			Category -> "General"
		},
		SlurryTransfer->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source sample should be mixed via pipette until it becomes homogenous, up to MaxNumberOfAspirationMixes times.",
			Category -> "General"
		},
		AspirationMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur during aspiration from the source sample.",
			Category -> "General"
		},
		NumberOfAspirationMixes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of AspirationMix, the number of times that the source sample should be mixed during aspiration.",
			Category -> "General",
			IndexMatching -> AspirationMix
		},
		MaxNumberOfAspirationMixes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of AspirationMix, the maximum number of times that the source sample was mixed during aspiration in order to achieve a homogeneous solution before the transfer.",
			Category -> "General",
			IndexMatching -> AspirationMix
		},
		AspirationMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
			Category -> "General"
		},
		DispenseMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should occur after the sample is dispensed into the destination container.",
			Category -> "General"
		},
		NumberOfDispenseMixes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of DispenseMix, the number of times that the source sample should be mixed after the sample is dispensed into the destination container.",
			Category -> "General",
			IndexMatching -> DispenseMix
		},
		DispenseMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			Category -> "General"
		},
		AspirationRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			Description -> "The speed at which liquid should be drawn up into the pipette tip.",
			Category -> "Pipetting Parameters"
		},
		OverAspirationVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
			Category -> "Pipetting Parameters"
		},
		AspirationWithdrawalRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter / Second],
			Units -> Millimeter / Second,
			Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
			Category -> "Pipetting Parameters"
		},
		AspirationEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
			Category -> "Pipetting Parameters"
		},
		AspirationMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
			Category -> "Pipetting Parameters"
		},
		AspirationPosition -> {
			Format -> Multiple,
			Class -> Expression,
			(* Top | Bottom | LiquidLevel *)
			Pattern :> PipettingPositionP,
			Description -> "The location from which liquid should be aspirated.",
			Category -> "Pipetting Parameters"
		},
		AspirationPositionOffset -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Millimeter]|{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]},
			Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
			Category -> "Pipetting Parameters"
		},
		AspirationAngle -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
			Units -> AngularDegree,
			Description -> "The angle that the source container will be tilted during the aspiration of liquid. The container is pivoted on its left edge when tilting occurs.",
			Category -> "Pipetting Parameters"
		},
		DispenseRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			Description -> "The speed at which liquid should be expelled from the pipette tip.",
			Category -> "Pipetting Parameters"
		},
		OverDispenseVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of air drawn blown out at the end of the dispensing of a liquid.",
			Category -> "Pipetting Parameters"
		},
		DispenseWithdrawalRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter / Second],
			Units -> Millimeter / Second,
			Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
			Category -> "Pipetting Parameters"
		},
		DispenseEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
			Category -> "Pipetting Parameters"
		},
		DispenseMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
			Category -> "Pipetting Parameters"
		},
		DispensePosition -> {
			Format -> Multiple,
			Class -> Expression,
			(* Top | Bottom | LiquidLevel *)
			Pattern :> PipettingPositionP,
			Description -> "The location from which liquid should be dispensed.",
			Category -> "Pipetting Parameters"
		},
		DispensePositionOffset -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Millimeter]|{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]},
			Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
			Category -> "Pipetting Parameters"
		},
		DispenseAngle -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
			Units -> AngularDegree,
			Description -> "The angle that the destination container will be tilted during the dispensing of liquid. The container is pivoted on its left edge when tilting occurs.",
			Category -> "Pipetting Parameters"
		},
		CorrectionCurve -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..} | Null,
			Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume in the form: {target volume, actual volume}.",
			Category -> "Pipetting Parameters"
		},
		PipettingMethod -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Method, Pipetting],
			Description -> "The pipetting parameters used to manipulate the sample in each transfer.",
			Category -> "Pipetting Parameters"
		},
		DynamicAspiration -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
			Category -> "Pipetting Parameters"
		},
		DeviceChannel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DeviceChannelP,
			Description -> "The channel of the work cell that should be used to perform the transfer.",
			Category -> "Pipetting Parameters"
		},
		WashAndResuspensionTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The pipette tips used to aspirate and dispense the requested volume of retentate wash and resuspension buffers.",
			Category -> "Pipetting Parameters"
		},
		FiltrateContainerOutTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The pipette tips used to aspirate and dispense the filtrate to the FiltrateContainerOut and WashFlowThroughContainer.",
			Category -> "Pipetting Parameters"
		},
		NumberOfLoadingTADMCurves -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "For each member of SampleLink, the number of TADM curves expected for the transfer of this sample to its filter, and any transfers of the filtrate into the FiltrateContainerOut.",
			Category -> "Pipetting Parameters"
		},
		LoadingAspirationDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which we aspirated our source solution.",
			Category -> "Pipetting Parameters"
		},
		LoadingAspirationPressure -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Pascal}..}],
			Description -> "The pressure data measured by the liquid handler during aspiration of the source samples.",
			Category -> "Pipetting Parameters"
		},
		LoadingAspirationLiquidLevelDetected -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the liquid level of the source sample was successfully detected before aspiration was performed. If the liquid level was not successfully detected, the aspiration occurred 2mm from the bottom of the source container.",
			Category->"Pipetting Parameters"
		},
		LoadingAspirationErrorMessage -> {
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The error message that the Hamilton firmware threw during aspiration from the source sample. If error messages are thrown during aspiration, the aspiration is retried from 2mm above the bottom of the source container.",
			Category->"Pipetting Parameters"
		},
		LoadingAspirationDetectedLiquidLevel -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Microliter,
			Description->"The estimated amount of liquid before the aspiration occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if AspirationPosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
			Category->"Pipetting Parameters"
		},
		LoadingDispenseDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which we dispensed our source solution.",
			Category -> "Pipetting Parameters"
		},
		LoadingDispensePressure -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Pascal}..}],
			Description -> "The pressure data measured by the liquid handler during dispensing of the source samples.",
			Category -> "Pipetting Parameters"
		},
		LoadingDispenseLiquidLevelDetected -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the liquid level of the destination sample was successfully detected before dispense was performed. If the liquid level was not successfully detected, the dispense occurred 2mm from the bottom of the destination container.",
			Category->"Pipetting Parameters"
		},
		LoadingDispenseErrorMessage -> {
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The error message that the Hamilton firmware threw during dispense from the destination sample. If error messages are thrown during dispense, the dispense is retried from 2mm above the bottom of the destination container.",
			Category->"Pipetting Parameters"
		},
		LoadingDispenseDetectedLiquidLevel -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Microliter,
			Description->"The estimated amount of liquid before the dispense occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if DispensePosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
			Category->"Pipetting Parameters"
		},
		NumberOfRetentateWashTADMCurves -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "For each member of SampleLink, the number of TADM curves expected for the retentate washing of this sample after filtration, and any transfers of the wash flow through into the WashFlowThroughContainers.",
			Category -> "Pipetting Parameters"
		},
		RetentateWashAspirationDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which we aspirated our retentate wash solution.",
			Category -> "Pipetting Parameters"
		},
		RetentateWashAspirationPressure -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Pascal}..}],
			Description -> "The pressure data measured by the liquid handler during aspiration of the retentate wash samples.",
			Category -> "Pipetting Parameters"
		},
		RetentateWashAspirationLiquidLevelDetected -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the liquid level of the source sample was successfully detected before aspiration of the retentate wash samples was performed. If the liquid level was not successfully detected, the aspiration occurred 2mm from the bottom of the source container.",
			Category->"Pipetting Parameters"
		},
		RetentateWashAspirationErrorMessage -> {
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The error message that the Hamilton firmware threw during aspiration from the retentate wash samples. If error messages are thrown during aspiration, the aspiration is retried from 2mm above the bottom of the source container.",
			Category->"Pipetting Parameters"
		},
		RetentateWashAspirationDetectedLiquidLevel -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Microliter,
			Description->"The estimated amount of liquid before the aspiration of the retentate wash samples occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if AspirationPosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
			Category->"Pipetting Parameters"
		},
		RetentateWashDispenseDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which we dispensed our retentate wash solution.",
			Category -> "Pipetting Parameters"
		},
		RetentateWashDispensePressure -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Pascal}..}],
			Description -> "The pressure data measured by the liquid handler during dispensing of the retentate wash samples.",
			Category -> "Pipetting Parameters"
		},
		RetentateWashDispenseLiquidLevelDetected -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the liquid level of the destination sample was successfully detected before dispense of the retentate wash samples was performed. If the liquid level was not successfully detected, the dispense occurred 2mm from the bottom of the destination container.",
			Category->"Pipetting Parameters"
		},
		RetentateWashDispenseErrorMessage -> {
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The error message that the Hamilton firmware threw during dispense from the retentate wash samples. If error messages are thrown during dispense, the dispense is retried from 2mm above the bottom of the destination container.",
			Category->"Pipetting Parameters"
		},
		RetentateWashDispenseDetectedLiquidLevel -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Microliter,
			Description->"The estimated amount of liquid before the dispense of the retentate wash samples occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if DispensePosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
			Category->"Pipetting Parameters"
		},
		NumberOfResuspensionTADMCurves -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "For each member of SampleLink, the number of TADM curves expected for the resuspension of the retentate after filtration.",
			Category -> "Pipetting Parameters"
		},
		ResuspensionAspirationDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which we aspirated our resuspension solution.",
			Category -> "Pipetting Parameters"
		},
		ResuspensionAspirationPressure -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Pascal}..}],
			Description -> "The pressure data measured by the liquid handler during aspiration of the resuspension samples.",
			Category -> "Pipetting Parameters"
		},
		ResuspensionAspirationLiquidLevelDetected -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the liquid level of the source sample was successfully detected before aspiration of the resuspension samples was performed. If the liquid level was not successfully detected, the aspiration occurred 2mm from the bottom of the source container.",
			Category->"Pipetting Parameters"
		},
		ResuspensionAspirationErrorMessage -> {
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The error message that the Hamilton firmware threw during aspiration from the resuspension samples. If error messages are thrown during aspiration, the aspiration is retried from 2mm above the bottom of the source container.",
			Category->"Pipetting Parameters"
		},
		ResuspensionAspirationDetectedLiquidLevel -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Microliter,
			Description->"The estimated amount of liquid before the aspiration of the resuspension samples occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if AspirationPosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
			Category->"Pipetting Parameters"
		},
		ResuspensionDispenseDate -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date at which we dispensed our resuspension solution.",
			Category -> "Pipetting Parameters"
		},
		ResuspensionDispensePressure -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Second, Pascal}..}],
			Description -> "The pressure data measured by the liquid handler during dispensing of the resuspension solution.",
			Category -> "Pipetting Parameters"
		},
		ResuspensionDispenseLiquidLevelDetected -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the liquid level of the destination sample was successfully detected before dispense of the resuspension solution was performed. If the liquid level was not successfully detected, the dispense occurred 2mm from the bottom of the destination container.",
			Category->"Pipetting Parameters"
		},
		ResuspensionDispenseErrorMessage -> {
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The error message that the Hamilton firmware threw during dispense from the resuspension solution. If error messages are thrown during dispense, the dispense is retried from 2mm above the bottom of the destination container.",
			Category->"Pipetting Parameters"
		},
		ResuspensionDispenseDetectedLiquidLevel -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Microliter],
			Units -> Microliter,
			Description->"The estimated amount of liquid before the dispense of the resuspension solution occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if DispensePosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
			Category->"Pipetting Parameters"
		}
	}
}];
