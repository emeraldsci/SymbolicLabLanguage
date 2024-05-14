(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, FPLC], {
	Description -> "Fast protein liquid chromatography (FPLC) experiment that is used to separate and analyze mixtures of proteins.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* --- Instrument Information --- *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument containing a pump, column oven, flow cell detector, and fraction collector used to execute this experiment.",
			Category -> "General"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates whether the run is meant to preparatively purify the samples or meant to simply analyze the purity of the samples.",
			Category -> "General",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation describing the mobile and stationary phase interplay.",
			Category -> "General",
			Abstract -> True
		},
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "Indicates the types of measurements performed for the experiment and available on the Instrument.",
			Category -> "General",
			Abstract -> True
		},
		InjectionTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FPLCInjectionTypeP (*FlowInjection | Autosampler | Superloop*),
			Description -> "For each member of SamplesIn, whether the system introduces sample in to the flow path via the automated injection module (Autosampler), or a syringe (Superloop), or directly from an inlet line submerged into the samples (FlowInjection).",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		SamplePumpWash -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, whether the method includes a PumpWash step for Sample Pump after priming.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		SampleLoop -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Plumbing,SampleLoop],
				Object[Plumbing,SampleLoop]
			],
			Description -> "When InjectionType -> Superloop, the tubing used to hold the sample before introduction into the system.",
			Category -> "General"
		},
		Mixer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,Mixer],
				Object[Part,Mixer],
				Model[Plumbing,ColumnJoin],
				Object[Plumbing,ColumnJoin]
			],
			Description -> "The fluid chamber designed to agitate liquid. A joining column is used when no mixer is requested.",
			Category -> "General"
		},
		FlowCell -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,FlowCell],
				Object[Part,FlowCell]
			],
			Description -> "When a non-default fluid chamber for Absorbance measurement is requested, the part swapped in for the default one.",
			Category -> "General"
		},
		SampleLoopDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Instrument]|Object[Plumbing], Null},
			Description -> "The disconnection information for removing existing sample loop connections from the flow path.",
			Headers -> {"Instrument", "Inlet Port", "Sample Loop", "Sample Loop Connector"},
			Category -> "General",
			Developer -> True
		},
		SampleLoopConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Plumbing,SampleLoop], Null},
			Description -> "The connection information for the sample loop to the flow path.",
			Headers -> {"Instrument", "Inlet Port", "Sample Loop", "Sample Loop Connector"},
			Category -> "General",
			Developer -> True
		},
		SampleLoopSecondaryConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Plumbing,SampleLoop], Null},
			Description -> "The connection information for the other of the sample loop to the flow path.",
			Headers -> {"Instrument", "Inlet Port", "Sample Loop", "Sample Loop Connector"},
			Category -> "General",
			Developer -> True
		},
		MixerDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> 	{Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The disconnection information for removing existing flow cell connections from the flow path.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "General",
			Developer -> True
		},
		MixerConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> 	{Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The connection information for the flow cell to the flow path.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "General",
			Developer -> True
		},
		MixerDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected mixer.",
			Headers -> {"Container", "Position"},
			Category -> "General",
			Developer -> True
		},
		FlowCellDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part], Null},
			Description -> "The disconnection information for removing existing flow cell connections from the flow path.",
			Headers -> {"Instrument", "Connector", "Flow Cell", "Flow Cell Inlet"},
			Category -> "General",
			Developer -> True
		},
		FlowCellConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part], Null},
			Description -> "The connection information for the flow cell to the flow path.",
			Headers -> {"Instrument", "Connector", "Flow Cell", "Flow Cell Inlet"},
			Category -> "General",
			Developer -> True
		},
		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "The column(s) used to separate the input mixture.",
			Category -> "General",
			Abstract -> True
		},
		MaxColumnPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Megapascal],
			Units -> Megapascal,
			Description -> "The maximum allowable pressure across all of the Columns.",
			Category -> "General"
		},
		ColumnJoins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing, ColumnJoin],
				Model[Plumbing, ColumnJoin]
			],
			Description -> "The connections used to link multiple Columns.",
			Category -> "General"
		},
		ColumnAssemblyConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item, Column], Null},
			Description -> "The instructions for assembling all the components with ColumnSelection before placing into the Instrument.",
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description -> "The connection information for attaching columns to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description -> "The connection information for disconnecting column joins prior to attaching columns attaching columns to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnJoinConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item, Column], Null},
			Description -> "The connection information for attaching columns joins to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
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
		ColumnFittings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Plumbing, Fitting]|Object[Plumbing, Fitting],
			Description -> "A list of adapters required to connect the columns in the flow path.",
			Category -> "Column Installation",
			Developer -> True
		},

		(* --- Buffers --- *)
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The first available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The second available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The third available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient"
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The fourth available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient"
		},
		BufferE -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The fifth available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient",
			Abstract -> True
		},
		BufferF -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The sixth available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient",
			Abstract -> True
		},
		BufferG -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The seventh available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient",
			Abstract -> True
		},
		BufferH -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The eighth available solution for the run gradient.",
			Developer -> True,
			Category -> "Gradient",
			Abstract -> True
		},
		BufferASelection -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The unique list of all of the various mobile phase solutions used within BufferA/C/E/G.",
			Category -> "Gradient"
		},
		BufferBSelection -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The unique list of all of the various mobile phase solutions used within BufferB/D/F/H.",
			Category -> "Gradient",
			Abstract -> True
		},

		SampleContainerSelection -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"DeleteDuplicates of WorkingContainers; should be index-matched to SampleCaps.",
			Category -> "General",
			Developer -> True
		},
		SampleContainerA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"The very first sample container when doing InjectionType -> FlowInjection|Superloop.",
			Category -> "General",
			Developer -> True
		},
		SampleContainerB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"The second sample container when doing InjectionType -> FlowInjection|Superloop.",
			Category -> "General",
			Developer -> True
		},
		SampleContainerC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"The third sample container when doing InjectionType -> FlowInjection|Superloop.",
			Category -> "General",
			Developer -> True
		},
		SampleContainerD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"The fourth sample container when doing InjectionType -> FlowInjection|Superloop.",
			Category -> "General",
			Developer -> True
		},
		SampleContainerE -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"The fifth sample container when doing InjectionType -> FlowInjection|Superloop.",
			Category -> "General",
			Developer -> True
		},
		SampleRecoupContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"The containers used to empty the purge syringe when doing InjectionType -> FlowInjection. The contents are recovered or discarded based on FlowInjectionPurgeCycle.",
			Category -> "General",
			Developer -> True
		},
		BufferACaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description -> "For each member of BufferASelection, the cap used to aspirate during this protocol.",
			IndexMatching -> BufferASelection,
			Category -> "General"
		},
		BufferBCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description -> "For each member of BufferBSelection, the cap used to aspirate during this protocol.",
			IndexMatching -> BufferBSelection,
			Category -> "General"
		},
		SampleCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description -> "For each member of WorkingInjectionSamples, when InjectionMode -> FlowInjection, the caps that aspirate each sample container.",
			IndexMatching -> WorkingInjectionSamples,
			Category -> "General"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		BufferCapConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Item,Cap], Null, Object[Container], Null},
			Description -> "The instructions for attaching the caps to the buffer bottles.",
			Headers -> {"Buffer Cap", "Cap Threads", "Buffer Container", "Buffer Container Spout"},
			Category -> "General",
			Developer -> True
		},
		SampleCapConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Item,Cap], Null, Object[Container], Null},
			Description -> "The instructions for attaching the caps to the sample bottles.",
			Headers -> {"Buffer Cap", "Cap Threads", "Buffer Container", "Buffer Container Spout"},
			Category -> "General",
			Developer -> True
		},
		BufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the inlet lines to the buffer caps.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "General",
			Developer -> True
		},
		SampleLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Item,Cap], Null, Object[Plumbing], Null},
			Description -> "The instructions attaching the inlet lines to the sample caps.",
			Headers -> {"Sample Cap", "Sample Cap Connector","Instrument Sample Inlet Line", "Inlet Line Connection"},
			Category -> "General",
			Developer -> True
		},
		SystemPrimeSampleCapConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Item,Cap], Null, Object[Container], Null},
			Description -> "The instructions for attaching the caps to the system prime cleaning buffers for the sample lines.",
			Headers -> {"Buffer Cap", "Cap Threads", "Buffer Container", "Buffer Container Spout"},
			Category -> "General",
			Developer -> True
		},
		SystemPrimeBufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the inlet lines to the system prime buffer and sample caps.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "General",
			Developer -> True
		},
		SystemFlushSampleCapConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Item,Cap], Null, Object[Container], Null},
			Description -> "The instructions for attaching the caps to the system flush cleaning buffers for the sample lines.",
			Headers -> {"Buffer Cap", "Cap Threads", "Buffer Container", "Buffer Container Spout"},
			Category -> "General",
			Developer -> True
		},
		SystemFlushBufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the inlet lines to the system flush buffer and sample caps.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "General",
			Developer -> True
		},
		PurgeBufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the buffer inlet lines to the system flush buffer and sample cap during buffer purge prior to flush.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
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

		InitialBufferAVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferASelection, the measured volume immediately before the experiment was started.",
			IndexMatching -> BufferASelection,
			Category -> "General"
		},
		InitialBufferBVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferBSelection, the measured volume immediately before the experiment was started.",
			IndexMatching -> BufferBSelection,
			Category -> "General"
		},
		InitialBufferAAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferASelection, an image taken immediately before the experiment was started.",
			IndexMatching -> BufferASelection,
			Category -> "General"
		},
		InitialBufferBAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferBSelection, an image taken immediately before the experiment was started.",
			IndexMatching -> BufferBSelection,
			Category -> "General"
		},

		(*--Injection sequence--*)
		FlowInjectionPurgeCycle -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Determines whether to have the sample replaced back into the origin container from the purge syringing.",
			Category -> "General"
		},
		InjectionTable -> {
			Format -> Multiple,
			Class -> {
				Sample -> Link,
				Type -> Expression,
				Gradient -> Link,
				InjectionType -> Expression,
				InjectionVolume -> Real,
				DilutionFactor -> Real,
				ColumnTemperature -> Real,
				FractionCollectionMethod -> Link,
				Data -> Link
			},
			Pattern :> {
				Sample -> ObjectP[{Object[Sample], Model[Sample]}],
				Type -> InjectionTableP,
				Gradient -> ObjectP[Object[Method]],
				InjectionType -> FPLCInjectionTypeP,
				InjectionVolume -> GreaterEqualP[0 * Micro * Liter],
				DilutionFactor -> GreaterP[0],
				ColumnTemperature -> GreaterP[0 * Celsius],
				FractionCollectionMethod -> ObjectP[Object[Method]],
				Data -> _Link
			},
			Relation -> {
				Sample -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Type -> Null,
				Gradient -> Object[Method],
				InjectionType -> Null,
				InjectionVolume -> Null,
				DilutionFactor -> Null,
				ColumnTemperature -> Null,
				FractionCollectionMethod -> Object[Method],
				Data -> Object[Data]
			},
			Units -> {
				Sample -> None,
				Type -> Null,
				Gradient -> None,
				InjectionType -> Null,
				InjectionVolume -> Micro Liter,
				DilutionFactor -> None,
				ColumnTemperature -> Celsius,
				FractionCollectionMethod -> None,
				Data -> None
			},
			Description -> "The sequence of samples injected for a given experiment run including for ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category -> "General"
		},
		WorkingInjectionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of InjectionTable, the samples that are actually injected onto the instrument.  This list diverges from those in the InjectionTable when input samples are transferred to new containers.",
			Category -> "General"
		},
		SampleLoopDisconnects -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, if injecting by autosampler, specifies the volume of initial buffer that is flowed through the sample loop to displace the sample, before the sample loop is disconnected from the flow path and the user specified gradient begins. A Null value indicates that the sample loop remains connected for the duration of the run.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		GradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferA in the composition over time, in the form: {Time, % BufferA} or a single % BufferA for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferB in the composition over time, in the form: {Time, % BufferB} or a single % BufferB for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferC in the composition over time, in the form: {Time, % BufferC} or a single % BufferA for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferD in the composition over time, in the form: {Time, % BufferD} or a single % BufferD for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientE -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferE in the composition over time, in the form: {Time, % BufferE} or a single % BufferE for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientF -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferF in the composition over time, in the form: {Time, % BufferF} or a single % BufferF for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientG -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferG in the composition over time, in the form: {Time, % BufferG} or a single % BufferG for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientH -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferH in the composition over time, in the form: {Time, % BufferH} or a single % BufferH for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		PreInjectionEquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, specifies the amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			Category->"Gradient",
			IndexMatching->SamplesIn
		},
		FlowRate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0 * Minute], GreaterEqualP[0 * Milliliter / Minute]}] | GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of SamplesIn, the total rate of mobile phase pumped through the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient",
			Abstract -> True
		},
		FractionCollectionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, Fraction collection parameters used for any samples that require fraction collection.",
			IndexMatching -> SamplesIn,
			Category -> "Fraction Collection",
			Abstract -> True
		},
		FractionCollectionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FractionCollectionModeP,
			Description -> "For each member of SamplesIn, the mode by which fractions are collected, based either on always collecting peaks in a given time range, collecting peaks when ever absorbance crosses above a threshold value, or based on the steepness of a peak's slope.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		FractionCollectionStartTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the time before which no fractions will be collected.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		FractionCollectionEndTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the time after which no fractions will be collected.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		MaxFractionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "For each member of SamplesIn, the maximum volume to be collected in a single fraction after which a new fraction will be generated.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		MaxCollectionPeriods -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the maximum amount to collect in a single fraction after which a new fraction will be generated when FractionCollectionMode is Time.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		PeakMinimumDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the least of amounts of time that changes in slopes must be maintained before they are registered.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		AbsoluteThresholds -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli] | GreaterEqualP[0 Millisiemen/Centimeter] | UnitsP[0 Unit]),
			Units -> None,
			Description -> "For each member of SamplesIn, the absorbance or conductivity signal value above which fractions will always be collected when in Threshold mode.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		PeakEndThresholds -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli] | GreaterEqualP[0 Millisiemen/Centimeter] | UnitsP[0 Unit]),
			Units -> None,
			Description -> "For each member of SamplesIn, the  absorbance or conductivity signal value below which the end of a peak is marked and fraction collection stops.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		PeakSlopes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli/Second] | GreaterEqualP[0 Millisiemen/(Centimeter Second)] | UnitsP[0 Unit / Second]),
			Units -> None,
			Description -> "For each member of SamplesIn, the minimum slope rate (per second) that must be met before a peak is detected and fraction collection begins.  A new peak (and new fraction) can be registered once the slope drops below this again, and collection ends when the PeakEndThreshold value is reached.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		PeakSlopeEnds -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli/Second] | GreaterEqualP[0 Millisiemen/(Centimeter Second)] | UnitsP[0 Unit / Second]),
			Units -> None,
			Description -> "For each member of SamplesIn, the slope rate (per second) that indicates when to end Peak-based fraction collections.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		FractionCollectionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature of the fraction collection compartment during a run.",
			Category -> "Fraction Collection"
		},
		FractionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Fraction containers that collected samples during the protocol.",
			Category -> "Fraction Collection"
		},
		FractionContainerRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Racks holding the fraction containers that collected samples during the protocol.",
			Category -> "Fraction Collection"
		},
		FractionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container]|Object[Instrument], Null},
			Description -> "List of fraction container placements.",
			Category -> "Fraction Collection",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		Programs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "For each member of SamplesIn, a robotic program that contains fields describing the FPLC run.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Developer -> True
		},
		Wavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Meter Nano,
			Description -> "The wavelength(s) of light absorbed in the detector's flow cell.",
			Category -> "General"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume taken from the sample and injected onto the column.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		SampleFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Units -> (Milli * Liter) / Minute,
			Description -> "For each member of SamplesIn, the total rate of sample pumped onto the Column when InjectionType -> FlowInjection or Superloop.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		PlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The package of pierceable plate seals used to cover plates of injection samples in this experiment.",
			Category -> "Sample Preparation"
		},
		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, Gradient],
			Description -> "The gradients used during the course of the run, in the order they will be run.",
			Category -> "Gradient"
		},
		FlowDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ColumnOrientationP,
			Description -> "For each member of SamplesIn, the direction of the flow going through the column during the sample injection, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		AnalyteGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the buffer gradient used for purification.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient",
			Abstract -> True
		},
		FractionCollection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Determines if fraction collection was performed in the protocol.",
			Category -> "Fraction Collection"
		},
		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Samples with known profiles used to calibrate peak integrations and retention times for a given run.",
			Category -> "Standards"
		},
		StandardInjectionTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FPLCInjectionTypeP (*FlowInjection | Autosampler | Superloop*),
			Description -> "For each member of Standards, whether the system introduces the standard in to the flow path via the automated injection module (Autosampler), or a syringe (Superloop), or directly from an inlet line submerged into the samples (FlowInjection).",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of Standards, the volume taken from the standard and injected onto the column.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Standards, the method used to describe the gradient used for purification.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardSampleLoopDisconnects -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of Standards, if injecting by autosampler, specifies the volume of initial buffer that is flowed through the sample loop to displace the standard, before the sample loop is disconnected from the flow path and the user specified gradient begins. A Null value indicates that the sample loop remains connected for the duration of the run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientE -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferE in the composition over time, in the form: {Time, % Buffer E} or a single % Buffer E for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientF -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferF in the composition over time, in the form: {Time, % Buffer F} or a single % Buffer F for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientG -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferG in the composition over time, in the form: {Time, % Buffer G} or a single % Buffer G for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientH -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferH in the composition over time, in the form: {Time, % Buffer H} or a single % Buffer H for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardPreInjectionEquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of Standards, specifies the amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			Category->"Standards",
			IndexMatching->Standards
		},
		StandardsFlowDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ColumnOrientationP,
			Description -> "For each member of Standards, the direction of the flow going through the column during the standard injection, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation.",
			Category->"Standards",
			IndexMatching->Standards
		},
		StandardsStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "For each member of Standards, the storage conditions under which the standard samples should be stored after the protocol is completed.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Samples with known profiles used to calibrate background signal.",
			Category -> "Blanking"
		},
		BlankInjectionTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FPLCInjectionTypeP (*FlowInjection | Autosampler | Superloop*),
			Description -> "For each member of Blanks, whether the system introduces the blank into the flow path via the automated injection module (Autosampler), or a syringe (Superloop), or directly from an inlet line submerged into the samples (FlowInjection).",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of Blanks, the volume taken from the blank and injected onto the column.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Blanks, the method used to describe the gradient used for purification.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankSampleLoopDisconnects -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Units -> Milliliter,
			Description -> "For each member of Blanks, if injecting by autosampler, specifies the volume of initial buffer that is flowed through the sample loop to displace the blank, before the sample loop is disconnected from the flow path and the user specified gradient begins. A Null value indicates that the sample loop remains connected for the duration of the run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer A for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer B for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientE -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferE in the composition over time, in the form: {Time, % Buffer E} or a single % Buffer E for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientF -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferF in the composition over time, in the form: {Time, % Buffer F} or a single % Buffer F for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientG -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferG in the composition over time, in the form: {Time, % Buffer G} or a single % Buffer G for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientH -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferH in the composition over time, in the form: {Time, % Buffer H} or a single % Buffer H for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankPreInjectionEquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of Blanks, specifies the amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			Category->"Blanking",
			IndexMatching->Blanks
		},
		BlanksFlowDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ColumnOrientationP,
			Description -> "For each member of Blanks, the direction of the flow going through the column during the blank injection, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation.",
			Category->"Blanking",
			IndexMatching->Blanks
		},
		BlanksStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "For each member of Blanks, the storage conditions under which the blank samples should be stored after the protocol is completed.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		StandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each Standard, the chromatography trace generated.",
			Category -> "Experimental Results"
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of Blanks, the chromatography trace generated for the blank's injection.",
			IndexMatching -> Blanks,
			Category -> "Experimental Results"
		},

		ColumnPrimeGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each prime, the method used to describe the gradient used.",
			Category -> "Gradient"
		},
		ColumnPrimeGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer A for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer B for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientE -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferE in the composition over time, in the form: {Time, % Buffer E} or a single % Buffer E for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientF -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferF in the composition over time, in the form: {Time, % Buffer F} or a single % Buffer F for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientG -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferG in the composition over time, in the form: {Time, % Buffer G} or a single % Buffer G for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientH -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column prime, the percentage of BufferH in the composition over time, in the form: {Time, % Buffer H} or a single % Buffer H for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimePreInjectionEquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each column prime, specifies the amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			Category->"Column Prime"
		},
		ColumnPrimeFlowDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ColumnOrientationP,
			Description -> "For each column prime, the direction of the flow going through the column, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation.",
			Category -> "Column Prime"
		},
		ColumnFlushGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each flush, the method used to describe the gradient used.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer A for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer B for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientE -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferE in the composition over time, in the form: {Time, % Buffer E} or a single % Buffer E for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientF -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferF in the composition over time, in the form: {Time, % Buffer F} or a single % Buffer F for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientG -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferG in the composition over time, in the form: {Time, % Buffer G} or a single % Buffer G for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientH -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...} | RangeP[0 Percent, 100 Percent]),
			Description -> "For each column flush, the percentage of BufferH in the composition over time, in the form: {Time, % Buffer H} or a single % Buffer H for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushPreInjectionEquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each column flush, specifies the amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			Category->"Column Flush"
		},
		ColumnFlushFlowDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ColumnOrientationP,
			Description -> "For each column flush, the direction of the flow going through the column, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation.",
			Category -> "Column Flush"
		},

		FinalBufferAVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferASelection, the measured volume immediately after the experiment was finished.",
			IndexMatching -> BufferASelection,
			Category -> "General"
		},
		FinalBufferBVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of BufferBSelection, the measured volume immediately after the experiment was finished.",
			IndexMatching -> BufferBSelection,
			Category -> "General"
		},
		FinalBufferAAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferASelection, an image of the corresponding BufferA taken immediately after the experiment was finished.",
			IndexMatching -> BufferASelection,
			Category -> "General"
		},
		FinalBufferBAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BufferBSelection, an image of the corresponding taken immediately after the experiment was finished.",
			IndexMatching -> BufferBSelection,
			Category -> "General"
		},
		PrimeData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography data generated for any column prime runs.",
			Category -> "Experimental Results"
		},
		FlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography data generated for any column flush runs.",
			Category -> "Experimental Results"
		},
		SystemPrimeData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography traces generated for the system prime run whereby the system is flushed with solvent before the column is connected.",
			Category -> "Experimental Results",
			Developer->True
		},
		SystemFlushData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography traces generated for the system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category -> "Experimental Results",
			Developer->True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the folder containing the necessary parameters for the instrument to execute this protocol.",
			Category -> "General",
			Developer -> True
		},
		MethodQueueFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file containing the necessary parameters for the instrument to execute this protocol.",
			Category -> "General",
			Developer -> True
		},
		MethodFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The raw instrument files imported into the Instrument software to conduct the run.",
			Category -> "General"
		},
		FlowInjectionPurgeMethodFiles -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file names of the purge methods used when priming/purging the sample lines for Flow Injection.",
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
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The method name for the protocol.",
			Category -> "General",
			Developer -> True
		},
		MethodTemplateName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the instrument file containing a template with variables we will set at run time according to parameters stored in the protocol.",
			Category -> "General",
			Developer -> True
		},
		NumberOfInjections -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Description -> "The number of sample injections in the protocol.",
			Category -> "General",
			Developer -> True
		},
		ConfirmedNumberOfInjections -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "A field indicating whether the lab operator confirmed the number of injections in the software was correct.",
			Category -> "General",
			Developer -> True
		},
		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature of the autosampler compartment prior to and during a run.",
			Category -> "General"
		},
		Injections -> {
			Format -> Multiple,
			Class -> {
				AnalyteSample -> Link,
				SampleIn -> Link,
				Type -> Expression,
				Well -> String,
				Volume -> Real
			},
			Pattern :> {
				AnalyteSample -> _Link,
				SampleIn -> _Link,
				Type -> ChromatographySampleTypeP,
				Well -> WellP,
				Volume -> GreaterP[0 * Microliter]
			},
			Relation -> {
				AnalyteSample -> Alternatives[Model[Sample], Object[Sample]],
				SampleIn -> Alternatives[Model[Sample], Object[Sample]],
				Type -> Null,
				Well -> Null,
				Volume -> Null
			},
			Units -> {
				AnalyteSample -> None,
				SampleIn -> None,
				Type -> None,
				Well -> None,
				Volume -> Micro Liter
			},
			Headers -> {
				AnalyteSample -> "AnalyteSample",
				SampleIn -> "SampleIn",
				Type -> "Type",
				Well -> "Well",
				Volume -> "Volume"
			},
			Description -> "The group of injection information, comprising the object injected, the categorization of that sample (SampleIn, Standard and Blank), and the information regarding how much was injected.",
			Category -> "General",
			Developer -> False
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
		AutosamplerDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Model[Container], Null},
			Description -> "List of autosampler container deck placements.",
			Category -> "Placements",
			Headers -> {"Object to Place", "Placement Tree"},
			Developer -> True
		},
		AutosamplerRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, Expression},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {(Object[Container] | Object[Sample] | Model[Container] | Model[Sample]), (Object[Container] | Object[Sample] | Model[Container] | Model[Sample]), Null},
			Description -> "List of autosampler container rack placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		FlowInjectionDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Model[Container], Null},
			Description -> "List of container deck placements for samples to be injected via FlowInjection or Superloop.",
			Category -> "Placements",
			Headers -> {"Object to Place", "Placement Tree"},
			Developer -> True
		},
		FractionDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Model[Container], Null},
			Description -> "List of fraction container placements.",
			Category -> "Placements",
			Headers -> {"Object to Place", "Placement Tree"},
			Developer -> True
		},
		FractionRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, Expression},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {(Object[Container] | Object[Sample] | Model[Container] | Model[Sample]), (Object[Container] | Object[Sample] | Model[Container] | Model[Sample]), Null},
			Description -> "List of fraction collection container rack placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?TimeQ,
			Description -> "The estimated completion time for the protocol.",
			Category -> "General",
			Developer -> True
		},
		PurgeWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect purged buffer liquid.",
			Category -> "General",
			Developer -> True
		},
		PurgeSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Consumable],
				Model[Item, Consumable]
			],
			Description -> "The syringe used to pull air and buffer from the buffer lines to clear them of air bubbles.",
			Category -> "General",
			Developer -> True
		},
		PurgeTubing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Plumbing, Tubing],
				Object[Plumbing, Tubing]
			],
			Description -> "The optional short tubing used together with PurgeSyringe.",
			Category -> "General",
			Developer -> True
		},
		WasteWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight data of the waste carboy after the FPLC protocol is complete.",
			Category -> "General",
			Developer -> True
		},

		(* --- Cleaning --- *)
		TubingRinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse buffers lines.",
			Category -> "Cleaning"
		},
		CapWashAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing],
				Model[Plumbing]
			],
			Description -> "Buffer cap plumbing adapter used to clean the tubing interior of used buffer caps.",
			Category -> "Cleaning"
		},
		AutosamplerWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to wash the autosampler needle during automated injections.",
			Category -> "Cleaning",
			Developer -> True
		},
		AutosamplerWashPlacement -> {
			Format -> Single,
			Class -> {String, Link},
			Pattern :> LocationContentsP,
			Relation -> {Null, Object[Instrument]|Object[Container]},
			Description -> "A position where the solution for washing the autosampler injection syringe will be placed during protocol running.",
			Headers -> {"Position", "Container"},
			Category -> "Placements"
		},
		BufferPumpWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to replace wash solution for the pump seals for the buffer inlet.",
			Category -> "Cleaning",
			Developer -> True
		},
		SamplePumpWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to replace wash solution for the pump seals for the sample inlet.",
			Category -> "Cleaning",
			Developer -> True
		},
		PumpWashPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing pump wash buffers needed to run the prime protocol onto the instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		SystemPrimeBufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing system prime buffers needed to run the prime protocol onto the instrument buffer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		SystemPrimeWorklistFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file describing the system prime imported onto the system.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferA immediately before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferB immediately before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferA taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferB taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferA immediately after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferB immediately after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferA taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferB taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		SystemFlushBufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing system flush buffers needed to run the flush protocol onto the instrument buffer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		SystemFlushWorklistFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file describing the system prime imported onto the system.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of SystemFlushBufferA immediately before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of SystemFlushBufferB immediately before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemFlushBufferA taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemFlushBufferB taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferA immediately after the system Flush.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferB immediately after the system Flush.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemFlushBufferA taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemFlushBufferB taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		SystemPrimeProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "A robotic program that contains fields describing the priming of the FPLC instrument prior to the FPLC runs.",
			Category -> "General",
			Developer -> True
		},
		SystemFlushProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "A robotic program that contains fields describing the priming of the FPLC instrument following to the FPLC runs.",
			Category -> "General",
			Developer -> True
		},
		SystemPrimeBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The buffer sample used to generate the buffer gradient to purge buffer B line at the start of an FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemPrimeBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The buffer sample used to generate the buffer gradient to purge buffer B line at the start of an FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemPrimeCleaningBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "Cleaning solutions used to clear out the sample inlet lines before a FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The gradient used to purge the instrument lines at the start of an FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemFlushBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The buffer sample used to generate the buffer gradient to purge buffer A lines at the end of an FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemFlushBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The buffer sample used to generate the buffer gradient to purge buffer B  instrument lines at the end of an FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemFlushCleaningBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "Cleaning solutions used to clear out the sample inlet lines after a FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The gradient used to purge the instrument lines at the end of an FPLC protocol.",
			Category -> "Gradient",
			Developer -> True
		},

		ReplacementFractionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "Four additional fraction containers used to replace the original fraction containers after these have been filled.",
			Category -> "Fraction Collection",
			Developer -> True
		},

		InjectionPlateManipulations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of the Blanks, Standards, and SamplesIn into a single injection plate.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		InjectionPlatePrep -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "The sample manipulation used to prepare the injection plate.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		InjectionPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Plate], Object[Container, Plate]],
			Description -> "The plate to be loaded onto the FPLC's autosampler and into which the experiment's samples, standards, and blanks were manipulated into.",
			Category -> "Sample Preparation",
			Developer -> True
		},

		GradientPurge -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Determines if the pump is stopped and purged during the gradient.",
			Category -> "Gradient",
			Developer -> True
		},
		PurgeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "Determines the volume of the GradientPurge.",
			Category -> "Gradient",
			Developer -> True
		},
		CalibrationWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The sample that are used to wash the pH flow cell of the instrument during the calibration process.",
			Category -> "Detection",
			Developer -> True
		},
		CalibrationWashSolutionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
			Relation -> Model[Container, Syringe] | Object[Container, Syringe],
			Description -> "The syringe used to load CalibrationWashSolution into the instrument's pH detector's flow cell via syringe pump during the calibration process.",
			Category -> "Detection",
			Developer -> True
		},
		CalibrationWashSolutionSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item, Needle], Object[Item, Needle]}],
			Relation -> Model[Item, Needle] | Object[Item, Needle],
			Description -> "The needle used by the CalibrationWashSolutionSyringe to load CalibrationWashSolution into the instrument's pH detector's flow cell(s) via syringe pump during the calibration process.",
			Category -> "Detection",
			Developer -> True
		},
		LowpHCalibrationBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The low pH reference buffer used to calibrate the pH probe in the 2-point calibration.",
			Category -> "Detection"
		},
		LowpHCalibrationBufferSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
			Relation -> Model[Container, Syringe] | Object[Container, Syringe],
			Description -> "The syringe used to load LowpHCalibrationBuffer into the instrument's pH detector's flow cell via syringe pump during the calibration process.",
			Category -> "Detection",
			Developer -> True
		},
		LowpHCalibrationBufferSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item, Needle], Object[Item, Needle]}],
			Relation -> Model[Item, Needle] | Object[Item, Needle],
			Description -> "The needle used by the LowpHCalibrationBufferSyringe to load LowpHCalibrationBuffer into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Detection",
			Developer -> True
		},
		HighpHCalibrationBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The high pH reference buffer used to calibrate the pH probe in the 2-point calibration.",
			Category -> "Detection"
		},
		HighpHCalibrationBufferSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
			Relation -> Model[Container, Syringe] | Object[Container, Syringe],
			Description -> "The syringe used to load HighpHCalibrationBuffer into the instrument's pH detector's flow cell via syringe pump during the calibration process.",
			Category -> "Detection",
			Developer -> True
		},
		HighpHCalibrationBufferSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item, Needle], Object[Item, Needle]}],
			Relation -> Model[Item, Needle] | Object[Item, Needle],
			Description -> "The needle used by the HighpHCalibrationBufferSyringe to load HighpHCalibrationBuffer into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Detection",
			Developer -> True
		},
		LowpHCalibrationTarget -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Description -> "The pH of the LowpHCalibrationBuffer that used to calibrate the pH probe in the 2-point calibration.",
			Units -> None,
			Category -> "Detection"
		},
		HighpHCalibrationTarget -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Description -> "The pH of the HighpHCalibrationBuffer that used to calibrate the pH probe in the 2-point calibration.",
			Units -> None,
			Category -> "Detection"
		},
		pHCalibrationStorageBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The buffer stored in the pH detector flow cell after calibration is complete.",
			Category -> "Detection"
		},
		pHCalibrationStorageBufferSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
			Relation -> Model[Container, Syringe] | Object[Container, Syringe],
			Description -> "The syringe used to load pHCalibrationStorageBuffer into the instrument's pH detector's flow cell via syringe pump after the calibration process.",
			Category -> "Detection",
			Developer -> True
		},
		pHCalibrationStorageBufferSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item, Needle], Object[Item, Needle]}],
			Relation -> Model[Item, Needle] | Object[Item, Needle],
			Description -> "The needle used by the pHCalibrationStorageBufferSyringe to load pHCalibrationStorageBuffer into the instrument's pH detector's flow cell via syringe pump after pH calibration.",
			Category -> "Detection",
			Developer -> True
		},
		(*TOBE REMOVED OR RENAMED*)

		StandardBufferA -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Standards, the Buffer A sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Developer -> True
		},
		StandardBufferB -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Standards, the Buffer B sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Developer -> True
		},
		StandardBufferC -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Standards, the Buffer C sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Developer -> True
		},
		StandardBufferD -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Standards, the Buffer D sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Standards,
			Category -> "Standards",
			Developer -> True
		},

		BlankBufferA -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Blanks, the Buffer A sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Developer -> True
		},
		BlankBufferB -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Blanks, the Buffer B sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Developer -> True
		},
		BlankBufferC -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Blanks, the Buffer C sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Developer -> True
		},
		BlankBufferD -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of Blanks, the Buffer D sample used to generate the buffer gradient for the protocol.",
			IndexMatching -> Blanks,
			Category -> "Blanking",
			Developer -> True
		},

		ColumnPrimeBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer A sample used to generate the buffer gradient for the protocol for each column prime.",
			Category -> "Gradient",
			Developer -> True
		},
		ColumnPrimeBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer B sample used to generate the buffer gradient for the protocol for each column prime.",
			Category -> "Gradient",
			Developer -> True
		},
		ColumnPrimeBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer C sample used to generate the buffer gradient for the protocol for each column prime.",
			Category -> "Gradient",
			Developer -> True
		},
		ColumnPrimeBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer D sample used to generate the buffer gradient for the protocol for each column prime.",
			Category -> "Gradient",
			Developer -> True
		},

		ColumnFlushBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer A sample used to generate the buffer gradient for the protocol for each column flush.",
			Category -> "Gradient",
			Developer -> True
		},
		ColumnFlushBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer B sample used to generate the buffer gradient for the protocol for each column flush.",
			Category -> "Gradient",
			Developer -> True
		},
		ColumnFlushBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer C sample used to generate the buffer gradient for the protocol for each column flush.",
			Category -> "Gradient",
			Developer -> True
		},
		ColumnFlushBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer D sample used to generate the buffer gradient for the protocol for each column flush.",
			Category -> "Gradient",
			Developer -> True
		}
	}
}];
