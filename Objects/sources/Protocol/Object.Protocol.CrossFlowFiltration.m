(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,CrossFlowFiltration],{
	Description->"An experiment used to purify samples with cross flow filtration.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		SampleInVolumes->{
			Format-> Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the amount of solution to be purified.",
			Category->"Sample Loading",
			IndexMatching -> SamplesIn
		},
		SampleReservoirs->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel,CrossFlowContainer],
				Object[Container,Vessel,CrossFlowContainer],
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"For each member of SamplesIn, container used to store the sample during the experiment.",
			Category->"Sample Loading",
			IndexMatching -> SamplesIn
		},
		CrossFlowFilters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,CrossFlowFilter],
				Model[Item,CrossFlowFilter],
				Object[Item, Filter, MicrofluidicChip],
				Model[Item, Filter, MicrofluidicChip]
			],
			Description->"For each member of SamplesIn, the filter unit used to separate the sample during the experiment.",
			Category->"Filtration",
			IndexMatching -> SamplesIn
		},
		
		DiafiltrationTargets->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[1],
			Description->"For each member of SamplesIn, the factor by which the sample will be transferred during buffer exchange.",
			Category->"Filtration",
			IndexMatching -> SamplesIn
		},
		
		PrimaryConcentrationTargets->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[1],
			Description->"For each member of SamplesIn, the factor by which the sample will be concentrated in the first concentration step.",
			Category->"Filtration",
			IndexMatching -> SamplesIn
		},
		
		SecondaryConcentrationTargets->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[1],
			Description->"For each member of SamplesIn, the factor by which the sample will be concentrated in the second concentration step.",
			Category->"Filtration",
			IndexMatching -> SamplesIn
		},
		
		DiafiltrationBufferWeights->{
			Format->Multiple,
			Class->Real,
			Units->Gram,
			Pattern:>GreaterEqualP[0Gram],
			Description->"For each member of SamplesIn, the mass of sample used for buffer exchange during a cross flow filtration using uPulse as the Instrument.",
			Category->"Filtration",
			Developer->True,
			IndexMatching -> SamplesIn
		},
		
		PrimaryConcentrationWeights->{
			Format->Multiple,
			Class->Real,
			Units->Gram,
			Pattern:>GreaterEqualP[0Gram],
			Description->"For each member of SamplesIn, the mass of sample will be concentrated in the first concentration step when using uPulse as the Instrument.",
			Category->"Filtration",
			Developer->True,
			IndexMatching -> SamplesIn
		},
		SecondaryConcentrationWeights->{
			Format->Multiple,
			Class->Real,
			Units->Gram,
			Pattern:>GreaterEqualP[0Gram],
			Description->"For each member of SamplesIn, the mass of sample will be concentrated in the second concentration step when using uPulse as the Instrument.",
			Category->"Filtration",
			Developer->True,
			IndexMatching -> SamplesIn
		},
		
		RetentateAliquotVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>GreaterP[0 Milliliter] | All,
			Description->"For each member of SamplesIn, amount of Retentate to be kept after the experiment.",
			Category->"Sample Recovery",
			IndexMatching -> SamplesIn
		},
		PermeateAliquotVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>GreaterP[0 Milliliter] | All,
			Description->"For each member of SamplesIn, the amount of permeate solution to be kept after the experiment.",
			Category->"Sample Recovery",
			IndexMatching -> SamplesIn
		},
		FiltrationModes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrossFlowFiltrationModeP,
			Description->"For each member of SamplesIn, the recipe used for concentration and/or diafiltration performed in the experiment.",
			Category->"Method Information",
			IndexMatching -> SamplesIn
		},
		TransmembranePressureTargets->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 PSI],
			Units->PSI,
			Description->"For each member of SamplesIn, the pressure value that is used to adjust the flow rate.",
			Category->"Method Information",
			IndexMatching -> SamplesIn
		},
		PrimaryPumpFlowRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Liter/Minute],
			Units->Milliliter/Minute,
			Description->"For each member of SamplesIn, the volume of feed pumped through the system per minute.",
			Category->"Method Information",
			IndexMatching -> SamplesIn
		},
		DiafiltrationModes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrossFlowFiltrationDiafiltrationModeP,
			Description->"For each member of SamplesIn, the mode of diafiltration performed in the experiment.",
			Category->"Method Information",
			IndexMatching -> SamplesIn
		},
		DiafiltrationExchangeCounts->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of SamplesIn, the number of steps during a Discrete diafiltration process.",
			Category->"Method Information",
			IndexMatching -> SamplesIn
		},
		
		DeadVolumeRecoveryModes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrossFlowFiltrationDeadVolumeRecoveryModeP,
			Description->"For each member of SamplesIn, the mode to recover the sample from the filter after the filtration and buffer exchange process is finished.",
			Category->"Method Information",
			IndexMatching -> SamplesIn
		},
		FilterHolder->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description->"Rack model that is used to hold the CrossFlowFilter during filtration.",
			Category->"Filtration"
		},
		
		Instrument->{
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

		AbsorbanceDetector->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,Spectrophotometer],
			Description->"The instruments that records the absorbance data during the experiment.",
			Category->"Instrument Setup"
		},

		ExperimentalFirstCheckInTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"Indicates how long the instrument is checked-in on for the first time after filtration has started.",
			Category -> "Instrument Processing"
		},

		ExperimentalRunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"Indicates how the experiment runtime with regular frequency check-ins.",
			Category -> "Instrument Processing"
		},
		
		FilterPrimeRunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"How long the filter prime takes to perform.",
			Category -> "Instrument Processing"
		},
		
		FilterFlushRunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"How long the filter prime takes to perform.",
			Category -> "Instrument Processing"
		},

		RetentateHoldupVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"Indicates the volume held in the Retentate tubing and filter prior to the filtration recipe.",
			Category->"Filtration",
			Developer->True
		},

		PermeateHoldupVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"Indicates the volume held in the permeate tubing and filter prior to the filtration recipe.",
			Category->"Filtration",
			Developer->True
		},


		AbsorbanceDataAcquisitionFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"How often absorbance values are measured during the experiment.",
			Category->"Absorbance Measurement"
		},
		
		OtherDataAcquisitionFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"How often pressure, weight, temperature and conductivity values are measured during the experiment.",
			Category->"Method Information"
		},
		
		AbsorbanceWavelength->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[RangeP[190 Nanometer,900 Nanometer],{RangeP[190 Nanometer,900 Nanometer],RangeP[190 Nanometer,900 Nanometer]}],
			Description->"Frequency of light that is measured in the absorbance module.",
			Category->"Absorbance Measurement"
		},
		
		AbsorbanceChannel->{
			Format->Single,
			Class->Expression,
			Pattern:>FilterFractionP,
			Description->"Which filter fraction is connected to the absorbance module.",
			Category->"Absorbance Measurement"
		},

		FilterPrime->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Whether the filter will be rinsed before the experiment.",
			Category->"Priming"
		},

		FilterPrimeVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"Amount of solution used to prime the system before the experiment.",
			Category->"Priming"
		},
		
		FilterPrimeFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Liter/Minute],
			Units->Milliliter/Minute,
			Description->"Volume of feed pumped through the system per minute.",
			Category->"Priming"
		},
		
		FilterPrimeTransmembranePressureTarget->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 PSI],
			Units->PSI,
			Description->"Amount of pressure maintained across the filter during the filter prime step.",
			Category->"Priming"
		},
		
		FilterPrimeRinse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Whether there will be a water wash step after the filter priming.",
			Category->"Priming"
		},
		
		FilterPrimeBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, solution used to wet the membrane and rinse the system.",
			IndexMatching -> SamplesIn,
			Category->"Priming"
		},
		FilterPrimeDiafiltrationBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, solution used to wet the membrane and rinse the system.",
			Category->"Priming",
			IndexMatching -> SamplesIn
		},
		
		FilterPrimeContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, container for the buffer used to prime and rinse the system.",
			Category->"Priming",
			IndexMatching -> SamplesIn
		},
		
		
		FilterPrimeRinseBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, buffer to rinse to system after the filter prime.",
			IndexMatching -> SamplesIn,
			Category->"Priming"
		},
		FilterPrimeRinseDiafiltrationBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, buffer to rinse to system after the filter prime.",
			IndexMatching -> SamplesIn,
			Category->"Priming"
		},
		
		FilterPrimeRinseContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, container for the buffer used to rinse to system after the filter prime.",
			IndexMatching -> SamplesIn,
			Category->"Priming"
		},

		RetentateOutVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"Amount of Retentate to be kept after the experiment.",
			Category->"Sample Recovery"
		},

		RetentateMeasureVolumeProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,MeasureVolume],
			Description->"The MeasureVolume protocol used to measure the Retentate volume after the recipe is done.",
			Category->"Sample Recovery"
		},

		RetentateEffectiveConcentrationFactors->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0],
			Description->"For each member of SamplesIn, the ratio between SampleInVolume and the volume measured at the end of the crossflow filtration recipe.",
			IndexMatching -> SamplesIn,
			Category->"Sample Recovery"
		},
		
		RetentateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of SamplesIn, how the Retentate will be kept after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Sample Storage"
		},
		PermeateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of SamplesIn, the conditions in which the permeate will be kept after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Sample Storage"
		},
		
		FilterStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of SamplesIn, how the filter will be kept after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Sample Storage"
		},
		PermeateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container used to store the permeate after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Sample Recovery"
		},
		TemporaryPermeateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Developer -> True,
			Description->"For each member of SamplesIn, the container used to store the permeate after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Sample Recovery"
		},
		
		DiafiltrationBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, indicates the solution added to the feed for buffer exchange.",
			IndexMatching -> SamplesIn,
			Category->"Filtration"
		},
		
		TemporaryDiafiltrationBufferContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Developer -> True,
			Description->"For each member of SamplesIn, the container for diafiltration buffer that will be temporally stored during the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Filtration"
		},
		RetentateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, container used to store the Retentate after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Sample Recovery"
		},
		TemporaryPermeateContainerOut->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container,Vessel],
				Model[Container,Vessel]
			],
			Description->"The container used to store the permeate during the experiment.",
			Category->"Sample Recovery",
			Developer->True
		},

		TemporaryPermeateContainerRack->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"The rack that holds the permeate container throughout the experiment.",
			Category->"Sample Recovery",
			Developer->True
		},
		
		DiafiltrationContainerRack->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"The rack that holds the permeate container throughout the experiment.",
			Category->"Sample Recovery",
			Developer->True
		},

		FilterFlush->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Whether the filter will be rinsed after the experiment.",
			Category->"Flushing"
		},
		
		FilterFlushVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"Amount of solution used to flush the membrane after the experiment.",
			Category->"Flushing"
		},
		
		FilterFlushFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Liter/Minute],
			Units->Milliliter/Minute,
			Description->"Volume of flushing buffer pumped through the system per minute.",
			Category->"Flushing"
		},
		
		FilterFlushTransmembranePressureTarget->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 PSI],
			Units->PSI,
			Description->"Amount of pressure maintained across the filter during the filter flush step.",
			Category->"Flushing"
		},
		
		FilterFlushRinse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Whether there will be a water wash step after the filter flush.",
			Category->"Flushing"
		},
		
		FilterFlushBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, solution used to flush the membrane after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Flushing"
		},
		FilterFlushDiafiltrationBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, solution used to flush the membrane after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Flushing"
		},
		FilterFlushContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, container for the buffer used to Flush the membrane after the experiment.",
			IndexMatching -> SamplesIn,
			Category->"Flushing"
		},
		
		FilterFlushRinseBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, solution used to rinse to system after the filter flush.",
			IndexMatching -> SamplesIn,
			Category->"Flushing"
		},
		FilterFlushRinseDiafiltrationBuffers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SamplesIn, solution used to rinse to system after the filter flush.",
			IndexMatching -> SamplesIn,
			Category->"Flushing"
		},
		FilterFlushRinseContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, container for the buffer used to rinse the system after filter flush.",
			IndexMatching -> SamplesIn,
			Category->"Flushing"
		},

		SystemPrimeBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"Solution that is used for cleaning the instrument before the filtration.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeDiafiltrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"Solution that is used for cleaning the instrument before the filtration.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"Solution that is used for cleaning the instrument after the filtration.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushDiafiltrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"Solution that is used for cleaning the instrument after the filtration.",
			Category->"Cleaning",
			Developer->True
		},

		SystemFlushRinseBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"Solution that is used for rinsing the instrument after the filtration.",
			Category->"Cleaning",
			Developer->True
		},
		
		WasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"Vessel used to collect the permeate during prime, rinse or flush steps.",
			Category->"Cleaning",
			Developer->True
		},
		
		TheoreticalPermeateVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Liter],
			Units->Milliliter,
			Description->"The total volume of sample and exchange buffer pumped into the feed.",
			Category -> "Method Information",
			Developer->True
		},

		ScaleAlarms->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Gram],
			Units->Gram,
			Description->"For each member of SamplesIn, the change in the permeate or Retentate weight, which is used to set alarms to avoid sample over-concentration and permeate overflow.",
			IndexMatching -> SamplesIn,
			Category -> "Method Information",
			Developer->True
		},
		
		SampleReservoirRack->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"The rack that holds the sample reservoir throughout the experiment.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		WashReservoirRacks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"The racks that hold the wash reservoirs during the experiment.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		RetentateTransferPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP|ManualSamplePreparationP,
			Description->"A set of instructions specifying the transfer of Retentate from SampleReservoir to the RetentateContainersOut.",
			Category->"Sample Recovery",
			Developer->True
		},
		
		PermeateTransferPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP|ManualSamplePreparationP,
			Description->"A set of instructions specifying the transfer of permeates from TemporaryPermeateContainerOut to the PermeateContainersOut.",
			Category->"Sample Recovery",
			Developer->True
		},
		
		SystemFlushFilterPlaceholder->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Plumbing,Fitting],
				Object[Plumbing,Fitting]
			],
			Description->"A fitting to replace the filter during the system flush, allowing the flow path to completed.",
			Category->"Cleaning",
			Developer->True
		},
		
		SystemFlushFilterPlaceholderConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Instrument,CrossFlowFiltration],Null},
			Description->"Instructions for attaching the SystemFlushFilterPlaceholder to the flow path.",
			Headers->{"Fitting","Fitting Connector","Pressure Sensor","Pressure Sensor Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		SystemFlushFilterPlaceholderFittings->{
			Format->Single,
			Class->{Link,Link,Link},
			Pattern:>{_Link,_Link,_Link},
			Relation->{Alternatives[Model[Plumbing,Fitting],Object[Plumbing,Fitting]],Alternatives[Model[Plumbing,Fitting],Object[Plumbing,Fitting]],Alternatives[Model[Plumbing,Fitting],Object[Plumbing,Fitting]]},
			Description->"Fitting to connect the filter placeholder to the rest of the flow path.",
			Headers->{"Fitting 1","Fitting 2","Fitting 3"},
			Category->"Cleaning",
			Developer->True
		},

		SystemFlushFilterPlaceholderFittingImages->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"For each member of SystemFlushFilterPlaceholderFittings, image files of the fitting to connect the filter placeholder to the rest of the flow path.",
			Category->"Cleaning",
			IndexMatching->SystemFlushFilterPlaceholderFittings,
			Developer->True
		},
		
		SystemFlushFilterPlaceholderFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Plumbing,Fitting],Null},
			Description->"Instructions for attaching the SystemFlushFilterPlaceholder to the SystemFlushFilterPlaceholderFittings.",
			Headers->{"Placeholder","Placeholder Connector","Fitting","Fitting Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FittingRack->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"Rack model that is used to hold the fitting during the protocol.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		AllFittings->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect the tubing to the filter and the sample reservoir. This is the helper fields for resource picking all fittings.",
			Category->"Instrument Setup",
			Developer->True
		},

		FittingImageFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"For each member of AllFittings, image files of the adaptors used to connect the tubing to the filter and the sample reservoir.",
			Category->"Instrument Setup",
			IndexMatching->AllFittings,
			Developer->True
		},
		
		FilterPrimeFittings->{
			Format->Single,
			Class->{Link,Link},
			Pattern:>{_Link,_Link},
			Relation->{
				Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
				Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]]
			},
			Description->"Adaptors used to connect the buffer reservoir to the flow path during the filter prime step.",
			Category->"Instrument Setup",
			Headers->{"Buffer Reservoir Feed","Buffer Reservoir Return"},
			Developer->True
		},
		
		FilterFlushFittings->{
			Format->Single,
			Class->{Link,Link},
			Pattern:>{_Link,_Link},
			Relation->{
				Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
				Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]]
			},
			Description->"Adaptors used to connect the buffer reservoir to the flow path during the filter flush step.",
			Category->"Instrument Setup",
			Headers->{"Buffer Reservoir Feed","Buffer Reservoir Return"},
			Developer->True
		},
		
		SystemFlushFittings->{
			Format->Single,
			Class->{Link,Link},
			Pattern:>{_Link,_Link},
			Relation->{
				Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
				Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]]
			},
			Description->"Adaptors used to connect the buffer reservoir to the flow path during the system flush step.",
			Category->"Instrument Setup",
			Headers->{"Buffer Reservoir Feed","Buffer Reservoir Return"},
			Developer->True
		},
		
		FilterPrimeFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach the fittings to the buffer reservoir for the filter prime step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FilterPrimeTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach tubes to the fittings on the buffer reservoir for the filter prime step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		FilterPrimeRinseFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach the fittings to the buffer reservoir for the filter prime rinse step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FilterPrimeRinseTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach tubes to the fittings on the buffer reservoir for the filter prime rinse step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		FilterFlushFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach the fittings to the buffer reservoir for the filter flush step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FilterFlushTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach tubes to the fittings on the buffer reservoir for the filter flush step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		FilterFlushRinseFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach the fittings to the buffer reservoir for the filter flush rinse step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FilterFlushRinseTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"The connections to attach tubes to the fittings on the buffer reservoir for the filter flush rinse step.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		SystemFlushFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container,Vessel,CrossFlowWashContainer]|Object[Plumbing,Fitting],Null},
			Description->"Instructions for attaching the fittings to the buffer reservoir.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		(*all new connections*)
		ConductivitySensorTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,PrecutTubing],Null,Object[Instrument,CrossFlowFiltration],Null},
			Description->"The connections to attach tubing to the conductivity sensors.",
			Headers->{"Tubing","Tubing Connector","Detector","Detector Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		ConductivitySensorFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Plumbing, PrecutTubing],Null},
			Description->"The connections to attach fittings to the tubes connected to the conductivity sensors.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		TubeToFittingConnections -> {
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Plumbing, PrecutTubing],Null},
			Description->"Instructions for attaching the fittings to DiafiltrationBufferContainerToFeedContainerTubing, RententateConductivitySensorToFeedContainerTubing, FeedContainerToFeedPressureSensorTubing, RetentatePressureSensorToConductivitySensorTubing, and PermeatePressureSensorToConductivitySensorTubing.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		FilterConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Alternatives[Object[Plumbing,Fitting], Object[Plumbing, PrecutTubing]],Null,Alternatives[Object[Item, CrossFlowFilter], Object[Plumbing, Fitting]],Null},
			Description->"The connections to attach fittings or tubing directly to the filter.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FilterTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Alternatives[Object[Plumbing,Fitting], Object[Plumbing, PrecutTubing]],Null,Alternatives[Object[Plumbing, PrecutTubing], Object[Plumbing, Fitting]],Null},
			Description->"Additional connections needed to connect fittings on the filter to additional fittings that can connect to the pressure sensors.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		PressureSensorConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Instrument,CrossFlowFiltration],Null},
			Description->"The connections to attach the fittings from the filter to the pressure sensors.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FeedContainerTubingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Alternatives[Object[Plumbing, PrecutTubing],Object[Plumbing, Fitting]],Null},
			Description->"The connections to attach tubings to the fittings on the tubes of the sample reservoir.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		FeedContainerFittingConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Object[Container, Vessel, CrossFlowContainer],Null},
			Description->"The connections to attach fittings to the tubes on the sample reservoir.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		FeedPressureSensorConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Alternatives[Object[Instrument,CrossFlowFiltration],Object[Plumbing, PrecutTubing]],Null},
			Description->"The connections to attach a fitting to the FeedPressureSensor.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		RetentateConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Alternatives[Object[Plumbing, PrecutTubing],Object[Instrument,CrossFlowFiltration]],Null},
			Description->"The connections to attach the tube from the RetentatePressureSensor to a tube on the RetentateConductivitySensor and a tube from the RententateConductivitySensor to the tube to the feed container.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},
		
		PermeateConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing,Fitting],Null,Alternatives[Object[Instrument,CrossFlowFiltration],Object[Plumbing, PrecutTubing]],Null},
			Description->"The connections to attach the PermeatePressureSensor to the inlet tube connected to the PermeateConductivitySensor.",
			Headers->{"Fitting","Fitting Connector","Buffer Reservoir","Buffer Reservoir Connector"},
			Category->"Plumbing Information",
			Developer->True
		},

		(* Coupling Rings for TCC fittings *)
		FilterConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterConnections,
			Developer -> True
		},
		FilterConnectionsTubeClamps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Clamp],Model[Item,Clamp]],
			Description -> "For each member of FilterConnections, the hose clamp required to seal the hose to the barb.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterConnections,
			Developer -> True
		},
		TubeClampPliers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "A tool to aid in affixing hose spring clamps over hose to barb fittings.",
			Category -> "General"
		},
		(* TODO: Remove this field *)
		FeedContainerTubingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FeedContainerTubingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FeedContainerTubingConnections,
			Developer -> True
		},
		FeedContainerFittingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FeedContainerFittingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FeedContainerFittingConnections,
			Developer -> True
		},
		(* TODO: Remove this *)
		FilterPrimeTubingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterPrimeTubingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterPrimeTubingConnections,
			Developer -> True
		},
		FilterPrimeFittingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterPrimeFittingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterPrimeFittingConnections,
			Developer -> True
		},

		(* TODO: Remove this *)
		FilterPrimeRinseTubingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterPrimeRinseTubingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterPrimeRinseTubingConnections,
			Developer -> True
		},

		(* TODO: Remove this *)
		FilterFlushTubingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterFlushTubingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterFlushTubingConnections,
			Developer -> True
		},
		FilterFlushFittingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterFlushFittingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterFlushFittingConnections,
			Developer -> True
		},

		(* TODO: Remove this *)
		FilterFlushRinseTubingConnectionsCouplingRings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Clamp],Model[Part,Clamp]],
			Description -> "For each member of FilterFlushRinseTubingConnections, the TriCloverClamp required to seal the connection.",
			Category -> "Instrument Setup",
			IndexMatching -> FilterFlushRinseTubingConnections,
			Developer -> True
		},
		
		(* All fittings *)
		(* TODO: Remove this *)
		FeedPressureSensorToFilterFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect the FeedPressureSensor to the CrossFlowFilter.",
			Category->"Instrument Setup",
			Developer->True
		},
		(* TODO: Remove this *)
		FilterToRetentatePressureSensorFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect from the RetentatePressureSensor to the CrossFlowFilter.",
			Category->"Instrument Setup"
		},
		(* TODO: Remove this *)
		FilterToPermeatePressureSensorFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect from the CrossFlowFilter to the PermeatePressureSensor.",
			Category->"Instrument Setup"
		},
		FilterToPermeatePressureSensorParentTubing  -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Tubing],Model[Plumbing,Tubing]],
			Description->"Tubing used to connect the filter to the permeate pressure sensor.",
			Category->"Instrument Setup",
			Developer->True
		},
		FeedPressureSensorToFilterInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FeedPressureSensor to the filter or to FeedPressureSensorToFilterTubing.",
			Category->"Instrument Setup",
			Developer->True
		},
		FeedPressureSensorToFilterOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect FeedPressureSensorToFilterTubing to the filter.",
			Category->"Instrument Setup",
			Developer->True
		},
		FilterToRetentatePressureSensorInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor to connect the filter to the RetentatePressureSensor or FilterToRetentatePressureSensorTubing.",
			Category->"Instrument Setup"
		},
		FilterToRetentatePressureSensorOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor to connect FilterToRetentatePressureSensorTubing to the RetentatePressureSensor.",
			Category->"Instrument Setup"
		},

		FilterToPermeatePressureSensorOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor to connect PermeatePressureSensor to the filter or to FilterToPermeatePressureSensorTubing.",
			Category->"Instrument Setup"
		},
		FeedContainerFilterOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the RetentateContainer to the FeedContainerToFeedPressureSensorTubingInletFitting for SamplesIn.",
			Category->"Instrument Setup",
			Developer->True
		},
		FeedContainerDetectorInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the RetentateContainer to the RententateConductivitySensorToFeedContainerTubingOutletFitting for SamplesIn.",
			Category->"Instrument Setup",
			Developer->True
		},
		FeedContainerDiafiltrationBufferInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect the RetentateContainer to the DiafiltrationBufferContainerToFeedContainerTubingOutletFitting for SamplesIn.",
			Category->"Instrument Setup",
			Developer->True
		},
		FeedContainerToFeedPressureSensorTubingOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FeedContainerToFeedPressureSensorTubing to the FeedPressureSensor.",
			Category->"Instrument Setup",
			Developer->True
		},
		RetentatePressureSensorToConductivitySensorTubingInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the RetentatePressureSensor to RetentatePressureSensorToConductivitySensorTubing.",
			Category->"Instrument Setup"
		},
		PermeatePressureSensorToConductivitySensorTubingInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect from the PermeatePressureSensor to the PermeatePressureSensorToConductivitySensorTubing.",
			Category->"Instrument Setup"
		},
		FeedContainerToFeedPressureSensorTubingInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FeedContainerFilterOutletFitting to the FeedContainerToFeedPressureSensorTubing.",
			Category->"Instrument Setup",
			Developer->True
		},
		RetentateConductivitySensorToFeedContainerTubingOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the RententateConductivitySensorToFeedContainerTubing to the FeedContainerDetectorInletFitting.",
			Category->"Instrument Setup",
			Developer->True
		},
		DiafiltrationBufferContainerToFeedContainerTubingOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the DiafiltrationBufferContainerToFeedContainerTubing to the FeedContainerDiafiltrationBufferInletFitting.",
			Category->"Instrument Setup",
			Developer->True
		},
		RetentatePressureSensorToConductivitySensorTubingOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the RetentatePressureSensorToConductivitySensorTubing to the RetentateConductivitySensorInletTubing.",
			Category->"Instrument Setup",
			Developer->True
		},
		RetentateConductivitySensorToFeedContainerTubingInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the RetentateConductivitySensorOutletTubing to the RententateConductivitySensorToFeedContainerTubing.",
			Category->"Instrument Setup",
			Developer->True
		},
		PermeatePressureSensorToConductivitySensorTubingOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the PermeatePressureSensorToConductivitySensorTubing to the PermeateConductivitySensorInletTubing.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		(* Prime and flush fittings for the same positions *)
		FilterPrimeFeedContainerFilterOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FilterPrimeContainer to the FeedContainerToFeedPressureSensorTubingInletFitting during the FilterPrime step.",
			Category->"Instrument Setup",
			Developer->True
		},
		FilterPrimeFeedContainerDetectorInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FilterPrimeContainer to the RententateConductivitySensorToFeedContainerTubingOutletFitting for the FilterPrime step.",
			Category->"Instrument Setup",
			Developer->True
		},
		FilterFlushFeedContainerFilterOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FilterFlushContainer to the FeedContainerToFeedPressureSensorTubingInletFitting during the FilterFlush step.",
			Category->"Instrument Setup",
			Developer->True
		},
		FilterFlushFeedContainerDetectorInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptor used to connect the FilterFlushContainer to the RententateConductivitySensorToFeedContainerTubingOutletFitting for the FilterFlush step.",
			Category->"Instrument Setup",
			Developer->True
		},
		SystemFlushFeedContainerFilterOutletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect the RetentateContainer to the RententateConductivitySensorToRetentateTubing for SystemFlush.",
			Category->"Instrument Setup",
			Developer->True
		},
		SystemFlushFeedContainerDetectorInletFitting->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Fitting],Model[Plumbing,Fitting]],
			Description->"Adaptors used to connect the RetentateContainer to the RententateConductivitySensorToRetentateTubing for SystemFlush.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		(*ParentTubing*)
		DiafiltrationParentTubing -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Tubing],Model[Plumbing,Tubing]],
			Description->"Parent tubing that the tubing used to transport diafiltration buffer into the Retentate container is cut from.",
			Category->"Instrument Setup",
			Developer->True
		},
		PermeateParentTubing -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Tubing],Model[Plumbing,Tubing]],
			Description->"Parent tubing that the tubing used to transport permeate from the filter to the permeate container is cut from.",
			Category->"Instrument Setup",
			Developer->True
		},
		RetentateParentTubing -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Tubing],Model[Plumbing,Tubing]],
			Description->"Parent tubing that the tubing used to transport retentate from the filter back to the retentate conductivity sensor is cut from.",
			Category->"Instrument Setup",
			Developer->True
		},
		ConductivitySensorsParentTubing -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Tubing],Model[Plumbing,Tubing]],
			Description->"Parent tubing that the tubing used to transport sample through the conductivity sensors is cut from.",
			Category->"Instrument Setup",
			Developer->True
		},
		FilterTubingParentTubing -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,Tubing],Model[Plumbing,Tubing]],
			Description->"Parent tubing that the tubing used to transport from the feed container to the filter through the main pump is cut from.",
			Category->"Instrument Setup",
			Developer->True
		},
		(* All tubings *)
		DiafiltrationBufferContainerToFeedContainerTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport diafiltration buffer into the Feed container.",
			Category->"Instrument Setup",
			Developer->True
		},

		FeedContainerToFeedPressureSensorTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport sample from the Feed Container through the main pump to the Feed Pressure Sensor.",
			Category->"Instrument Setup",
			Developer->True
		},

		RetentateConductivitySensorToFeedContainerTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport Retentate from the RetentateConductivitySensor back to the FeedContainer.",
			Category->"Instrument Setup",
			Developer->True
		},

		RetentateConductivitySensorInletTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"The tubing used to transport solution from the RetentatePressureSensorToConductivitySensorTubing to the Retentate conductivity sensor.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		RetentateConductivitySensorOutletTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"The tubing used to transport solution from the retentate conductivity sensor to the RententateConductivitySensorToFeedContainerTubing.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		PermeateConductivitySensorInletTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"The tubing used to transport solution from the PermeatePressureSensorToConductivitySensorTubingOutletFitting to the permeate conductivity sensor.",
			Category->"Instrument Setup",
			Developer->True
		},
		
		PermeateConductivitySensorOutletTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"The tubing used to transport solution from the Permeate conductivity sensor to the Permeate container.",
			Category->"Instrument Setup",
			Developer->True
		},

		RetentatePressureSensorToConductivitySensorTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport solution from the Retentate pressure sensor to the Retentate conductivity sensor.",
			Category->"Instrument Setup"
		},

		PermeatePressureSensorToConductivitySensorTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport solution from the retentate pressure sensor to the RetentateConductivitySensorInletTubing.",
			Category->"Instrument Setup"
		},
		FilterToPermeatePressureSensorTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport solution from the Filter to Permeate pressure sensor. Only used when using an Xampler filter.",
			Category->"Instrument Setup"
		},
		FilterToRetentatePressureSensorTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport solution from the Filter to Retentate pressure sensor. Only used when using an Xampler filter.",
			Category->"Instrument Setup"
		},
		FeedPressureSensorToFilterTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Plumbing,PrecutTubing],Model[Plumbing,PrecutTubing]],
			Description->"Tubing used to transport solution from the Feed Pressure sensor to the Filter. Only used when using an Xampler filter.",
			Category->"Instrument Setup"
		},
		CleaningFilter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item, Filter, MicrofluidicChip],
				Model[Item, Filter, MicrofluidicChip]
			],
			Description->"The filter unit used to clean the instrument during SystemPrim and SystemFlush process for uPulse.",
			Category->"Instrument Setup"
		},
		FilterTubingBlock ->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Part],Model[Part]],
			Description->"The block used to transport solutions from retentate and permeate to microfluidic fitler block.",
			Category->"Instrument Setup"
		},
		(* TODO: Remove this *)
		CableLabelSticker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Consumable] | Object[Item, Consumable],
			Description -> "The label sticker for labeling tubing and stickers in this protocol.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		PrimaryCableLabelSticker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Consumable] | Object[Item, Consumable],
			Description -> "The label sticker for labeling tubing in this protocol.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		SecondaryCableLabelSticker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Consumable] | Object[Item, Consumable],
			Description -> "The label sticker for labeling fittings in this protocol.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		TubeBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,TubeBlock] | Object[Part,TubeBlock],
			Description -> "The integrated tube block for connecting all sample and buffer containers and the filter for uPulse crossflow system.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		(* Placement *)
		SampleReservoirRackPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Instrument], Null},
			Description -> "The information that guide operator to put SampleReservoirRack to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		DiafiltrationContainerRackPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Instrument], Null},
			Description -> "The information that guide operator to put DiafiltrationContainerRack to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		WasteContainerPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Instrument], Null},
			Description -> "The information that guide operator to put WasteContainer to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SystemPrimeBufferPlacement->{
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "The information that guide operator to put the container of SystemPrimeBuffer to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SystemPrimeDiafiltrationBufferPlacement->{
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "The information that guide operator to put container of SystemPrimeDiafiltrationBuffer to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SystemFlushBufferPlacement->{
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "The information that guide operator to put container of SystemFlushBuffer to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SystemFlushDiafiltrationBufferPlacement->{
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "The information that guide operator to put container of SystemFlushDiafiltrationBuffer to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		TubeBlockPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part], Object[Instrument], Null},
			Description -> "The information that guide operator to put TubeBlock to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		CleaningFilterPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Item, Filter, MicrofluidicChip], Object[Instrument], Null},
			Description -> "The information that guide operator to put CleaningFilter to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		FeedContainerToFeedPressureSensorTubingPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Plumbing, PrecutTubing], Object[Instrument], Null},
			Description -> "The placement describing how to put the tubing through the o-ring at the PermeateSensorTubing Slot.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		RetentateConductivitySensorToFeedContainerTubingPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Plumbing, PrecutTubing], Object[Instrument], Null},
			Description -> "The placement describing how to put the tubing through the o-ring at the FilterFeedTubing Slot.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		DiafiltrationBufferContainerToFeedContainerTubingPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Plumbing, PrecutTubing], Object[Instrument], Null},
			Description -> "The placement describing how to put the tubing through the o-ring at the DiafiltrationTubing Slot.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},

		ExperimentalMethodFileNames->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"File names used for the method files for experimental steps.",
			Category->"Method Information",
			Developer->True
		},
		
		MethodFolderPath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Address of the folder used to store the method files during the experiment.",
			Category->"Method Information",
			Developer->True
		},
		
		DataFolderPath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Address of the folder used to store the data files during the experiment.",
			Category->"Method Information",
			Developer->True
		},
		
		DataFilePaths->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"Address of the each filter step data file generated during the experiment.",
			Category->"Experimental Results",
			Developer->True
		},
		
		NonFilterStepDataFilePaths->{
			Format->Single,
			Class->{String,String,String,String,String,String},
			Pattern:>{_String,_String,_String,_String,_String,_String},
			Description->"Address of the each non-filter step data file generated during the experiment.",
			Headers->{"Filter Prime","Filter Prime Rinse","Filter Flush","Filter Flush Rinse","System Flush","System Flush Rinse"},
			Category->"Experimental Results",
			Developer->True
		},
		
		MethodFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"Method files containing parameters for automated execution of the flush, rinse and prime steps, and for detectors.",
			Category->"Method Information"
		},
		
		DataFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"Data files containing the results of the cross-flow filtration experiment.",
			Category->"Method Information"
		},
		
		FilterPrimeData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Any data for all the FilterPrime Process generated by this protocol.",
			Category -> "Experimental Results",
			AdminWriteOnly->True
		},
		FilterPrimeRinseData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Any data for all the FilterPrimeRinse Process generated by this protocol.",
			Category -> "Experimental Results",
			AdminWriteOnly->True
		},
		FilterFlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Any data for all the FilterFlush Process generated by this protocol.",
			Category -> "Experimental Results",
			AdminWriteOnly->True
		},
		FilterFlushRinseData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Any data for all the FilterFlushRinse Process generated by this protocol.",
			Category -> "Experimental Results",
			AdminWriteOnly->True
		},
		AuxiliaryPermeateTubing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Plumbing, PrecutTubing], Model[Plumbing, PrecutTubing]],
			Description -> "For filters with a barbed Auxiliary Permeate connector, used in combination with AuxiliaryPermeateSiphonClamp to seal the system and prevent leaks.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		AuxiliaryPermeateSiphonClamp -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Clamp], Object[Item, Clamp]],
			Description -> "For filters with a barbed Auxiliary Permeate connector, used in combination with AuxiliaryPermeateTubing to seal the system and prevent leaks.",
			Category -> "Instrument Setup",
			Developer -> True
		}
	}
}];




