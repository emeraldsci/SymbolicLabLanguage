(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, PackColumn], {
	Description -> "The tools needed to pack a column.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SlurryConcentrationKit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Column], Model[Item, Column]],
			Description -> "The column that will be used to measure the SpecificVolume.",
			Category -> "General",
			Developer -> True
		},
		SpecificVolumeResins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description ->  "For each member of Columns, the resin that will have their SpecificVolume measured.",
			IndexMatching -> Columns,
			Category -> "General",
			Developer -> True
		},
		SpecificVolumeBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description ->  "For each member of Columns, the buffer that will be used to pack the resin during an FPLC run, and whose mixture with the resin will be the SpecificVolume that is measured.",
			IndexMatching -> Columns,
			Category -> "General",
			Developer -> True
		},
		SpecificVolumeSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Syringe], Model[Container, Syringe]],
			Description ->  "For each member of Columns, the disposable syringe used to insert buffer into the column during the subprotocol used to measure the SpecificVolume.",
			IndexMatching -> Columns,
			Category -> "General",
			Developer -> True
		},

		WorkingBench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Shelf],
			Description -> "The bench where the column packing will occur.",
			Category -> "General",
			Developer -> True
		},
		RetortStand -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			Description -> "The stand needed for column packing.",
			Category -> "General",
			Developer -> True
		},
		Clamps -> {
			Format -> Single,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {Alternatives[Object[Item, Consumable], Model[Item, Consumable]], Alternatives[Object[Item, Consumable], Model[Item, Consumable]]},
			Description -> "The clamps needed to attach the column to the stand to allow for packing.",
			Headers -> {"Top Clamp", "Bottom Clamp"},
			Category -> "General",
			Developer -> True
		},
		BubbleInclinometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			Description -> "The Inclinometer needed to ensure the slope of the empty column to be packed is straight. An inclinometer is an instrument used for measuring angles of slope (or tilt), elevation, or depression of an object with respect to gravity's direction.",
			Category -> "General",
			Developer -> True
		},
		FlashLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			Description -> "The FlashLight or Torch that provides the light source required to identify the bed height of the resin material.",
			Category -> "General",
			Developer -> True
		},
		MarkerPen -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			Description -> "The pen needed to mark the bed height of the resin material.",
			Category -> "General",
			Developer -> True
		},

		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Column], Model[Item, Column]],
			Description -> "The columns that are packed with Resin in the course of the experiment.",
			Category -> "General"
		},
		PackedColumnModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Column],
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the model the will represent the final packed object column.",
			Category -> "General"
		},
		PackingTubes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the separate packing column apparatus, that attaches to the chromatography column to aid with packing during the packing process.",
			Category -> "General",
			Developer -> True
		},
		PackingFunnels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, Funnel], Model[Part, Funnel]],
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the cone shaped tube that is used for guiding the resin into the column during packing.",
			Category -> "General",
			Developer -> True
		},
		Pipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the disposable transfer pipettes needed for filling the column to the brim with packing buffer to allow for consistent packing.",
			Category -> "General",
			Developer -> True
		},
		PackingBufferSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Syringe], Model[Container, Syringe]],
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the disposable syringes used to insert buffer into the column during particular stages of the packing process.",
			Category -> "General",
			Developer -> True
		},
		PackingBufferTubings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Plumbing, Tubing], Model[Plumbing, Tubing]],
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the disposable tubings used to insert buffer from the syringe to the column during particular stages of the packing process.",
			Category -> "General",
			Developer -> True
		},

		ResinLoadingAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milligram],
            Units -> Milligram,
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the amount of resin that will be used to fill up the empty column. When specifying the mass it is the amount of dry resin.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		ResinLoadingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
			Units -> Milliliter,
			IndexMatching -> Columns,
			Description -> "For each member of Columns, the volume of resin that will be used to fill up the empty column. When specifying the volume it is the volume of the resin in its storage state.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		BedVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
            Units -> Milliliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the total volume of material, both solid and liquid, in the compacted column; i.e. the volume of the support particles (compacted resin) plus the void volume.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		SpecificVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter / Gram],
			Units -> Milliliter / Gram,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the specific volume of the resin and storage buffer mixture.",
			Category -> "Sample Preparation"
		},
		SpecificVolumeFactor -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "The volume that the particular index in the experiment was measured to for the resin and storage buffer mixture.",
			Category -> "Sample Preparation",
			Developer -> True
		},

		SlurryBufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milliliter],
			Units -> Milliliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the amount of resin packing buffer that will be used to create the resin slurry to be packed into the column.",
			Category -> "General",
			Abstract -> True
		},
		ResinPackingBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the resin packing buffer that will be used to create the resin slurry to be packed into the column.",
			Category -> "General",
			Developer -> True
		},
		MiscellaneousBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the packing buffer that will be used to for miscellaneous tasks such as filling the syringe with buffer.",
			Category -> "General",
			Developer -> True
		},


		PackingBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of Columns, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General"
		},
		StorageBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of Columns, the buffer that will be used to store the resin wet in the column, this buffer will be passed through the column using the FPLC.",
			Category -> "General"
		},
		BufferASelection -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},
		BufferBSelection -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to store the resin wet in the column, this buffer will be passed through the column using the FPLC.",
			Category -> "General",
			Developer -> True
		},
		BufferAContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "For each member of BufferASelection, the list of deck placements used for placing buffers A needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			IndexMatching -> BufferASelection,
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		BufferBContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "For each member of BufferBSelection, the list of deck placements used for placing buffers B needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			IndexMatching -> BufferBSelection,
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		BufferACaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description -> "For each member of BufferASelection, the cap used to aspirate during this protocol.",
			IndexMatching -> BufferASelection,
			Category -> "General",
			Developer -> True
		},
		BufferBCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description -> "For each member of BufferBSelection, the cap used to aspirate during this protocol.",
			IndexMatching -> BufferBSelection,
			Category -> "General",
			Developer -> True
		},
		BufferALineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "For each member of BufferASelection, the instructions for attaching the inlet lines to the buffer A caps.",
			Headers -> {"Instrument Buffer A Inlet Line", "Inlet Line A Connection", "Buffer A Cap", "Buffer Cap A Connector"},
			IndexMatching -> BufferASelection,
			Category -> "General",
			Developer -> True
		},
		BufferBLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "For each member of BufferBSelection, the instructions for attaching the inlet lines to the buffer caps.",
			Headers -> {"Instrument Buffer B Inlet Line", "Inlet Line B Connection", "Buffer B Cap", "Buffer B Cap Connector"},
			IndexMatching -> BufferBSelection,
			Category -> "General",
			Developer -> True
		},
		BufferASensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "For each member of BufferACaps, the sensor attached to the corresponding cap.",
			IndexMatching -> BufferACaps,
			Category -> "General",
			Developer -> True
		},
		BufferBSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "For each member of BufferBCaps, the sensor attached to the corresponding cap.",
			IndexMatching -> BufferBCaps,
			Category -> "General",
			Developer -> True
		},

		InitialBufferAVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferASelection, the measured volume immediately before the experiment was started.",
			IndexMatching -> BufferASelection,
			Category -> "General",
			Developer -> True
		},
		InitialBufferBVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferBSelection, the measured volume immediately before the experiment was started.",
			IndexMatching -> BufferBSelection,
			Category -> "General",
			Developer -> True
		},
		InitialBufferAAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferASelection, an image taken immediately before the experiment was started.",
			IndexMatching -> BufferASelection,
			Category -> "General",
			Developer -> True
		},
		InitialBufferBAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferBSelection, an image taken immediately before the experiment was started.",
			IndexMatching -> BufferBSelection,
			Category -> "General",
			Developer -> True
		},

		FinalBufferAVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferASelection, the measured volume immediately after the experiment was finished.",
			IndexMatching -> BufferASelection,
			Category -> "General",
			Developer -> True
		},
		FinalBufferBVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferBSelection, the measured volume immediately after the experiment was finished.",
			IndexMatching -> BufferBSelection,
			Category -> "General",
			Developer -> True
		},
		FinalBufferAAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferASelection, an image of the corresponding BufferA taken immediately after the experiment was finished.",
			IndexMatching -> BufferASelection,
			Category -> "General",
			Developer -> True
		},
		FinalBufferBAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferBSelection, an image of the corresponding taken immediately after the experiment was finished.",
			IndexMatching -> BufferBSelection,
			Category -> "General",
			Developer -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},
		BufferE -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},
		BufferF -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},
		BufferG -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},
		BufferH -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "For each member of SamplesIn, the buffer that will be used to pack the resin during an FPLC run.",
			Category -> "General",
			Developer -> True
		},


		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the gradient used to pack the column.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		ResinSlurryPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SampleManipulationP | Null, SampleManipulationP | Null},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the set of instructions specifying the transfers of resin and packing buffer to an appropriately sized bottled used to mix the components into a slurry to be used in the column packing.",
			Category -> "General",
			Developer -> True
		},
		BufferSensorConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Sensor, Volume], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the sensors to the buffer caps.",
			Headers -> {"Sensor", "Sensor Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "General",
			Developer -> True
		},

		(* Plumbing Fields *)
		ColumnInletCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing],
			Description -> "For each member of Columns, the inlet cap for the threaded ports at the outlet to the column.",
			IndexMatching -> Columns,
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnOutletCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing],
			Description -> "For each member of Columns, the outlet cap for the threaded ports at the outlet to the column.",
			IndexMatching -> Columns,
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnInletPorts -> {
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for the threaded ports at the inlet to the column.",
			IndexMatching -> Columns,
			Headers -> {"Column", "Column Inlet Port"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnOutletPorts -> {
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for the threaded ports at the outlet to the column.",
			IndexMatching -> Columns,
			Headers -> {"Column", "Column Outlet Port"},
			Category -> "Column Installation",
			Developer -> True
		},
		InletStopPlugConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for the attachment of the inlet column join to its stop plug.",
			Headers -> {"Inlet Column Join Connector", "Inlet Column Join Connector Name", "Inlet Stop Plug", "Inlet Stop Plug End"},
			Category -> "Column Installation",
			Developer -> True
		},
		OutletStopPlugConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for the attachment of the outlet column join to its stop plug.",
			Headers -> {"Outlet Column Join Connector", "Outlet Column Join Connector Name", "Outlet Stop Plug", "Outlet Stop Plug End"},
			Category -> "Column Installation",
			Developer -> True
		},
		SyringeTubingConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Container], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for attaching the syringe to the tubing to create a contraption needed for column packing.",
			IndexMatching -> Columns,
			Headers -> {"Syringe Container", "Syringe Luer End", "Tubing", "Tubing Luer End"},
			Category -> "Column Installation",
			Developer -> True
		},
		SyringeColumnInletConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing, Tubing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for the attachment of the inlet column join to the packing buffer syringe tubing.",
			Headers -> {"Inlet Column Join Connector", "Inlet Column Join Connector Name", "Packing Buffer Syringe", "Packing Buffer Syringe End"},
			Category -> "Column Installation",
			Developer -> True
		},
		SyringeColumnOutletConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing, Tubing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for the attachment of the outlet column join to the packing buffer syringe tubing.",
			IndexMatching -> Columns,
			Headers -> {"Outlet Column Join Connector", "Outlet Column Join Connector Name", "Packing Buffer Syringe", "Packing Buffer Syringe End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnInletFPLCConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the column outlet connection information for attaching columns to the flow path coming from the sample manager.",
			IndexMatching -> Columns,
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column Inlet", "Column Inlet Port"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnOutletFPLCConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the column outlet connection information for attaching columns to the flow path coming from the sample manager.",
			IndexMatching -> Columns,
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column Outlet", "Column Outlet Port"},
			Category -> "Column Installation",
			Developer -> True
		},
		UpstreamColumnJoinConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for attaching columns joins to the upstream flow path tubing coming from the sample manager.",
			IndexMatching -> Columns,
			Headers -> {"Instrument Upstream Column Connector", "Column Connector Name", "Column Join", "Column Join Thin Port"},
			Category -> "Column Installation",
			Developer -> True
		},
		DownstreamColumnJoinConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Plumbing], Null},
			Description -> "For each member of Columns, the connection information for attaching columns joins to the upstream flow path tubing coming from the sample manager.",
			IndexMatching -> Columns,
			Headers -> {"Instrument Downstream Column Connector", "Column Connector Name", "Column Join", "Column Join Thick Port"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected column joins.",
			Headers -> {"Container", "Position"},
			Category -> "Column Installation",
			Developer -> True
		},
		DisconnectedDestination -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "The destination information on the operator cart for the disconnected plumbing.",
			Headers -> {"Container", "Position"},
			Category -> "Column Installation",
			Developer -> True
		},
		PlumbingDisconnectionSlot -> {
			Format -> Single,
			Class -> {String, Link},
			Pattern :> LocationContentsP,
			Relation -> {Null, Model[Instrument] | Object[Instrument]},
			Description -> "The destination information for the disconnected plumbing.",
			Headers -> {"Position", "Container"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnSlots -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> LocationContentsP,
			Relation -> {Null, Model[Instrument]|Object[Instrument]},
			Description -> "For each member of Columns, the destination information for attaching the columns to the FPLC.",
			IndexMatching -> Columns,
			Headers -> {"Position", "Container"},
			Category -> "Column Installation",
			Developer -> True
		},


		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument containing a pump, column oven, flow cell detector, and fraction collector used to compress the resin within the column.",
			Category -> "General"
		},
		SeparationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The estimated completion time for the protocol.",
			Category -> "General",
			Developer -> True
		},
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "Indicates the types of measurements performed for the experiment and available on the Instrument.",
			Category -> "General",
			Abstract -> True,
			Developer -> True
		},
		Wavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Meter Nano,
			Description -> "The wavelength(s) of light absorbed in the detector's flow cell.",
			Category -> "General",
			Developer -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation describing the mobile and stationary phase interplay.",
			Category -> "General",
			Abstract -> True,
			Developer -> True
		},


		MethodFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file containing the necessary parameters for the instrument to execute this protocol.",
			Category -> "General",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The directory to which data will be exported.",
			Category -> "General",
			Developer -> True
		},
		MethodName -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The method name for the protocol.",
			Category -> "General",
			Developer -> True
		},
		DataFile -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The root file name for files containing raw chromatography data.",
			Category -> "General",
			Developer -> True
		},
		MetaDataFile -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The root file name for files containing an FPLC run meta information.",
			Category -> "General",
			Developer -> True
		},


		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Parameters describing the length of each batch of columns.",
			Category -> "Batching",
			Developer -> True
		},
		BufferABatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Parameters describing the length of each batch of BufferA.",
			Category -> "Batching",
			Developer -> True
		},
		BufferBBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Parameters describing the length of each batch of BufferB.",
			Category -> "Batching",
			Developer -> True
		}
	}
}];

