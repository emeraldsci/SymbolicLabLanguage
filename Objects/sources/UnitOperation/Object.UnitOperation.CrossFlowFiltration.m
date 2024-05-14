(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[
	Object[UnitOperation,CrossFlowFiltration],
	{
		Description->"A detailed set of parameters that specifies a single cross flow filtration step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			(* --- General --- *)
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
				Description -> "The sample to be analyzed during this light obscuration experiment.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample to be analyzed during this light obscuration experiment.",
				Category -> "General",
				Migration->SplitField
			},
			SampleOutLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "New samples (from RetentateContainersOut and PermeateContainersOut) that are generated in this filtration operation.",
				Category -> "General",
				Migration -> SplitField
			},
			SampleOutString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "New samples (from RetentateContainersOut and PermeateContainersOut) that are generated in this filtration operation.",
				Category -> "General",
				Migration -> SplitField
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the source container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			RetentateSampleOutLabel->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the retentate sample that are collected after the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			RetentateContainerOutLabel->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the container that will hold the retentate sample after the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			PermeateSampleOutLabel->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the permeated sample that are collected after the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			PermeateContainerOutLabel->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the container that will hold the permeate sample after the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			
			(*Experiment Options*)
			Instrument -> {
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Instrument,CrossFlowFiltration],
					Model[Instrument,CrossFlowFiltration]
				],
				Description->"The cross-flow filtration apparatus used to filter the sample.",
				Category->"Instrument Setup"
			},
			Sterile -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indicates if the protocol is performed in a sterile environment.",
				Category -> "General"
			},
			TubingType -> {
				Format->Multiple,
				Class->Expression,
				Pattern:> Alternatives[PharmaPure],
				Description->"Material of tubes used to transport solutions during the experiment.",
				Category->"Method Information"
			},
			SampleInVolume -> {
				Format-> Multiple,
				Class->Real,
				Pattern:>GreaterP[0 Milliliter],
				Units->Milliliter,
				Description->"The amount of solution to be purified.",
				Category->"Sample Loading"
			},
			FiltrationMode -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>CrossFlowFiltrationModeP,
				Description->"The recipe used for concentration and/or diafiltration performed in the experiment.",
				Category->"Method Information"
			},
			CrossFlowFilter -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Item,CrossFlowFilter],
					Model[Item,CrossFlowFilter],
					Object[Item, Filter, MicrofluidicChip],
					Model[Item, Filter, MicrofluidicChip]
				],
				Description->"The filter unit used to separate the sample during the experiment.",
				Category->"Filtration"
			},
			SizeCutoff -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>CrossFlowFilterCutoffP,
				Description->"The recipe used for concentration and/or diafiltration performed in the experiment.",
				Category->"Method Information"
			},
			DiafiltrationTarget -> {
				Format->Multiple,
				Class->Expression,
				Pattern:> (GreaterEqualP[0 Milliliter] | GreaterEqualP[0 Gram] | GreaterEqualP[1]),
				Description->"The number of sample volumes used for buffer exchange.",
				Category->"Filtration"
			},
			PrimaryConcentrationTarget -> {
				Format->Multiple,
				Class->Expression,
				Pattern:> (GreaterEqualP[0 Milliliter] | GreaterEqualP[0 Gram] | GreaterEqualP[1]),
				Description->"The factor by which the sample will be concentrated in the first concentration step.",
				Category->"Filtration"
			},
			SecondaryConcentrationTarget -> {
				Format->Multiple,
				Class->Expression,
				Pattern:> (GreaterEqualP[0 Milliliter] | GreaterEqualP[0 Gram] | GreaterEqualP[1]),
				Description->"The factor by which the sample will be concentrated in the second concentration step.",
				Category->"Filtration"
			},
			TransmembranePressureTarget -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 PSI],
				Units->PSI,
				Description->"The pressure value that is used to adjust the flow rate.",
				Category->"Method Information"
			},
			PermeateAliquotVolume -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>GreaterP[0 Milliliter] | All,
				Description->"The amount of permeate solution to be kept after the experiment.",
				Category->"Sample Recovery"
			},
			PermeateContainerOut -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Container],
					Model[Container]
				],
				Description->"The container used to store the permeate after the experiment.",
				Category->"Sample Recovery"
			},
			PermeateStorageCondition -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleStorageTypeP|Disposal,
				Description->"The conditions in which the permeate will be kept after the experiment.",
				Category->"Sample Storage"
			},
			PrimaryPumpFlowRate -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 Liter/Minute],
				Units->Milliliter/Minute,
				Description->"The volume of feed pumped through the system per minute.",
				Category->"Method Information"
			},
			DiafiltrationBuffer -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description->"Indicates the solution added to the feed for buffer exchange.",
				Category->"Filtration"
			},
			DiafiltrationMode -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>CrossFlowFiltrationDiafiltrationModeP,
				Description->"The mode of diafiltration performed in the experiment.",
				Category->"Method Information"
			},
			DiafiltrationExchangeCount -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The number of steps during a Discrete diafiltration process.",
				Category->"Method Information"
			},
			DeadVolumeRecoveryMode->{
				Format->Multiple,
				Class->Expression,
				Pattern:>CrossFlowFiltrationDeadVolumeRecoveryModeP,
				Description->"The mode to recover the sample from the filter after the filtration and buffer exchange process is finished.",
				Category->"Method Information"
			},
			SampleReservoir -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Container,Vessel,CrossFlowContainer],
					Object[Container,Vessel,CrossFlowContainer],
					Model[Container,Vessel],
					Object[Container,Vessel]
				],
				Description->"Container used to store the sample during the experiment.",
				Category->"Sample Loading"
			},
			RetentateContainerOut -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Container],
					Model[Container]
				],
				Description->"Container used to store the Retentate after the experiment.",
				Category->"Sample Recovery"
			},
			RetentateAliquotVolume -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>GreaterP[0 Milliliter] | All,
				Description->"Amount of Retentate to be kept after the experiment.",
				Category->"Sample Recovery"
			},
			RetentateStorageCondition -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleStorageTypeP|Disposal,
				Description->"How the Retentate will be kept after the experiment.",
				Category->"Sample Storage"
			},
			FilterStorageCondition -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleStorageTypeP|Disposal,
				Description->"How the filter will be kept after the experiment.",
				Category->"Sample Storage"
			},
			FilterPrime -> {
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Whether the filter will be rinsed before the experiment.",
				Category->"Priming"
			},
			FilterPrimeBuffer -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description->"Solution used to wet the membrane and rinse the system.",
				Category->"Priming"
			},
			FilterPrimeVolume -> {
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0 Milliliter],
				Units->Milliliter,
				Description->"Amount of solution used to prime the system before the experiment.",
				Category->"Priming"
			},
			FilterPrimeRinse -> {
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Whether there will be a water wash step after the filter priming.",
				Category->"Priming"
			},
			FilterPrimeRinseBuffer -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description->"Buffer to rinse to system after the filter prime.",
				Category->"Priming"
			},
			FilterPrimeFlowRate -> {
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0 Liter/Minute],
				Units->Milliliter/Minute,
				Description->"Volume of feed pumped through the system per minute.",
				Category->"Priming"
			},
			FilterPrimeTransmembranePressureTarget -> {
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0 PSI],
				Units->PSI,
				Description->"Amount of pressure maintained across the filter during the filter prime step.",
				Category->"Priming"
			},
			FilterFlush -> {
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Whether the filter will be rinsed after the experiment.",
				Category->"Flushing"
			},
			FilterFlushBuffer -> {
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description->"Solution used to flush the membrane after the experiment.",
				Category->"Flushing"
			},
			FilterFlushVolume -> {
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0 Milliliter],
				Units->Milliliter,
				Description->"Amount of solution used to flush the membrane after the experiment.",
				Category->"Flushing"
			},
			FilterFlushRinse -> {
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Whether there will be a water wash step after the filter flush.",
				Category->"Flushing"
			},
			FilterFlushFlowRate -> {
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0 Liter/Minute],
				Units->Milliliter/Minute,
				Description->"Volume of flushing buffer pumped through the system per minute.",
				Category->"Flushing"
			},
			FilterFlushTransmembranePressureTarget -> {
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0 PSI],
				Units->PSI,
				Description->"Amount of pressure maintained across the filter during the filter flush step.",
				Category->"Flushing"
			},
			SampleReservoirPlacements -> {
				Format -> Multiple,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {Object[Container], Object[Container] | Object[Instrument], Null},
				Description -> "The information that guide operator to put SampleReservoir to the desired rack.",
				Category -> "Placements",
				Developer -> True,
				Headers -> {"Object to Place", "Destination Object", "Destination Position"}
			},
			DiafiltrationContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {Object[Container], Object[Container] | Object[Instrument], Null},
				Description -> "The information that guide operator to put DiafiltrationContainer to the desired rack.",
				Category -> "Placements",
				Developer -> True,
				Headers -> {"Object to Place", "Destination Object", "Destination Position"}
			},
			PermeateContainerPlacements -> {
				Format -> Multiple,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {Object[Container], Object[Container] | Object[Instrument], Null},
				Description -> "The information that guide operator to put PermeateContainer to the instrument.",
				Category -> "Placements",
				Developer -> True,
				Headers -> {"Object to Place", "Destination Object", "Destination Position"}
			},
			FilterPlacement -> {
				Format -> Single,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {Object[Item, Filter, MicrofluidicChip], Object[Instrument], Null},
				Description -> "The information that guide operator to put Filter to the Instrument.",
				Category -> "Placements",
				Developer -> True,
				Headers -> {"Object to Place", "Destination Object", "Destination Position"}
			},
			MethodFilePaths -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The Batch file (with an extension of \"bat\") that auto populate experiment parameters into the instrument app.",
				Category -> "Method Information",
				Developer -> True
			},
			DataFilePaths -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The CSV files that contains the flow data .",
				Category -> "Method Information",
				Developer -> True
			},
			ImportScriptFilePaths -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The full file path of the export script file used to convert and export data gathered by the instrument to the network drive.",
				Category -> "General",
				Developer -> True
			},
			DiafiltrationBufferRefillIndices -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>{GreaterEqualP[0,1]...},
				Description->"A list of integers referring to the indices of number of time the diafiltration buffer need to be refilled during the experiment..",
				Category->"Method Information",
				Developer->True
			},
			ExperimentalRunTimes ->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Minute],
				Units->Minute,
				Description->"Indicates how the experiment runtime with regular frequency check-ins.",
				Category -> "Instrument Processing"
			},
			SampleTypes -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> (FilterPrime | Sample | FilterFlush | FilterFlushRinse | FilterPrimeRinse),
				Description -> "The type of sample run for this unit operation.",
				Category -> "General"
			},
			RetentateMeasureVolumeProtocols->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Protocol,MeasureVolume],
				Description->"The MeasureVolume protocol used to measure the Retentate volume after the recipe is done.",
				Category->"Sample Recovery"
			},
			TheoreticalPermeateVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 Liter],
				Units->Milliliter,
				Description->"The total volume of sample and exchange buffer pumped into the feed.",
				Category -> "Method Information",
				Developer->True
			},
			SamplePreparationPrimitives -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {SamplePreparationP...},
				Description -> "The sample preparation primitives used to transfer retentate and permeate sample into the corresponding RetentateContainerOut and PermeateContainerOut.",
				Category -> "Sample Preparation",
				Developer->True
			}
		}
	}
];
