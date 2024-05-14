(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,Degas],
	{
		Description->"A protocol for degassing samples.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{

			(*---Shared Fields---*)
			DegasType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>DegasTypeP,
				Description->"For each member of SamplesIn, the method (freeze-pump-thaw, sparging, or vacuum degassing) used to degas the sample.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			Instrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument],Model[Instrument]],
				Description->"The freeze-pump-thaw, vacuum degassing, or sparging instruments used to degas the provided samples.",
				Category->"Instrument Specifications"
			},
			FumeHood->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument],Object[Instrument]],
				Description->"The fume hood instrument in which degassing is performed.",
				Category->"Instrument Specifications"
			},
			SchlenkLine->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument],Object[Instrument]],
				Description->"The Schlenk line instrument in which degassing is performed.",
				Category->"Instrument Specifications"
			},
			Dewar->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument],Object[Instrument]],
				Description->"The dewar instrument in which freezing is performed for Freeze-Pump-Thaw.",
				Category->"Instrument Specifications"
			},
			WasteContainer ->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Vessel],
					Object[Container,Vessel]
				],
				Description -> "The vessel used to contain the waste bathwater from the vapor trap.",
				Category -> "Instrument Specifications"
			},
			DrainTube -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Plumbing,Tubing],
					Object[Plumbing,Tubing]
				],
				Description -> "The drain tube used to empty the vapor trap of the schlenk line instrument at the end of the experiment run.",
				Category -> "Instrument Specifications"
			},
			LiquidNitrogenDoser->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument],Model[Instrument]],
				Description->"The liquid nitrogen doser used to fill the dewar instrument with liquid nitrogen for use in freeze-pump-thaw.",
				Category->"Instrument Specifications"
			},
			HeatBlock->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument],Object[Instrument]],
				Description->"The heat block instrument in which thawing is performed for Freeze-Pump-Thaw.",
				Category->"Instrument Specifications"
			},
			Septum->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Item],Object[Item]],
				Description->"The septum used to cover the container for Freeze-Pump-Thaw.",
				Category->"Instrument Specifications"
			},
			Sonicator->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument],Object[Instrument]],
				Description->"The sonicator in which agitation is performed for Vacuum Degassing.",
				Category->"Instrument Specifications"
			},
			Mixer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Instrument, OverheadStirrer],Object[Instrument, OverheadStirrer]],
				Description -> "The mixer used to stir the solution as it is being degassed via the sparging method.",
				Category -> "Instrument Specifications"
			},
			Impeller -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
				Description -> "The impellers used in the mixer responsible for stirring the solution as it is being degassed via the sparging method.",
				Category -> "Instrument Specifications"
			},
			ImpellerGuide -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Part,AlignmentTool],Object[Part,AlignmentTool]],
				Description -> "The impeller guides used to stabilize the position of the impeller within the degas cap, as it is being degassed via the sparging method.",
				Category -> "Instrument Specifications"
			},
			DegasCap -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Item,Cap],Object[Item,Cap]],
				Description -> "The degas caps used to interface with the degas adapters, so that the sample containers can be plumbed into the degas instrument schlenk line.",
				Category -> "Instrument Specifications"
			},
			SchlenkAdapter -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Plumbing,Tubing],Object[Plumbing,Tubing]], (*TODO: FIX*)
				Description -> "The impellers used in the mixer responsible for stirring the solution as it is being degassed via the sparging method.",
				Category -> "Instrument Specifications"
			},
			MethodTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0*Hour],
				Units->Hour,
				Description->"The total estimated amount of time required for the entire degassing protocol to complete.",
				Category->"General",
				Developer->True
			},

			(*---Freeze Pump Thaw Specific---*)
			FreezePumpThawContainer->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
				Description->"For each member of SamplesIn, the container that will hold the sample during the freeze-pump-thaw procedure.",
				Category->"Container Specifications",
				IndexMatching->SamplesIn
			},
			FreezeTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time the sample will be flash frozen by submerging the container in a dewar filled with liquid nitrogen during the freeze-pump-thaw procedure. This is the first step in the freeze-pump-thaw cycle.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			PumpTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time the sample will be vacuumed during the pump step of the freeze-pump-thaw procedure. The pump step evacuates the headspace above the frozen sample in preparation for the thawing step.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			ThawTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time the sample will be thawed during the freeze-pump-thaw procedure. During the thaw step, the decreased headspace pressure from the pump step will decrease the solubility of dissolved gases in the thawed liquid, thereby causing dissolved gases to bubble out from the liquid as it thaws.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			ThawTemperature->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Celsius],
				Units->Celsius,
				Description->"For each member of SamplesIn, the temperature at which the sample will be thawed during the freeze-pump-thaw procedure.During the thaw step, the decreased headspace pressure from the pump step will decrease the solubility of dissolved gases in the thawed liquid, thereby causing dissolved gases to bubble out from the liquid as it thaws.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			NumberOfCycles->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[3,1],
				Description->"For each member of SamplesIn, the number of cycles of freezing the sample, evacuating the headspace above the sample, and then thawing the sample that will be performed as part of a single freeze-pump-thaw protocol.",
				Category->"General",
				IndexMatching->SamplesIn
			},

			(*---Vacuum Degassing Specific---*)
			VacuumTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time it takes to vacuum the sample during vacuum degassing method.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			VacuumUntilBubbleless->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"For each member of SamplesIn, indicates if the vacuum degassing should be continued until the sample is entirely bubbles, up to the MaxVacuumTime.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			MaxVacuumTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Hour],
				Units->Hour,
				Description->"For each member of SamplesIn, the maximum amount of time allowed for vacuuming the sample during vacuum degassing method.",
				Category->"General"
			},
			VacuumSonicate->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"For each member of SamplesIn, indicates whether or not the sample will be agitated by immersing the container in a sonicator during the vacuum degassing method.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			VacuumPressure->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Milli*Bar],
				Units->Milli*Bar,
				Description->"For each member of SamplesIn, the pressure at which to vacuum the sample during the vacuum degassing method.",
				Category->"General",
				IndexMatching->SamplesIn
			},

			(*---Sparging Specific---*)
			SpargingGas->{
				Format->Multiple,
				Class->Expression,
				Pattern:>DegasGasP,
				Description->"For each member of SamplesIn, the gas used to sparge the sample.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			SpargingTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time the sample will be sparged during the sparging procedure.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			SpargingMix->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"For each member of SamplesIn, indicates whether the sample will be mixed during the sparging procedure.",
				Category->"General",
				IndexMatching->SamplesIn
			},

			(*---Post processing---*)
			HeadspaceGasFlush->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[None,DegasGasP],
				Description->"For each member of SamplesIn, describes which inert gas will be used to replace the headspace after degassing. None indicates that no specific gas will be used and that the sample will be exposed to the atmosphere when capping.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			HeadspaceGasFlushTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time the sample will be sparged during the sparging procedure.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			DissolvedOxygen->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"For each member of SamplesIn, indicates if a dissolved oxygen reading should be taken before and after the degassing process, using a dissolved oxygen meter.",
				Category->"General",
				IndexMatching->SamplesIn
			},

			(* --- Parallelization and Batching Fields --- *)
			BatchLengths -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The list of batch sizes corresponding to number of containers per batch.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Units -> None,
				Description -> "The list of containers that will have their contents degassed simultaneously as part of the same 'batch'.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sample],
				Units -> None,
				Description -> "The list of samples that will be degassed simultaneously as part of the same 'batch'.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedSampleLengths -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The number of samples per 'batch' in a degas group.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedContainerIndexes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The index in WorkingContainers of each container in BatchLengths.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedSampleIndexes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The index of each sample in BatchedSampleLengths.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedDegasParameters ->{
				Format->Multiple,
				Class->{
					DegasType->Expression,
					Instrument->Link,

					(*Freeze pump thaw*)
					FreezePumpThawContainer->Link,
					FreezeTime->Real,
					PumpTime->Real,
					ThawTime->Real,
					ThawTemperature->Real,
					NumberOfCycles->Integer,

					(*vacuum degas*)
					VacuumTime->Real,
					VacuumUntilBubbleless->Boolean,
					MaxVacuumTime->Real,
					VacuumSonicate->Boolean,
					VacuumPressure->Real,

					(*sparging*)
					SpargingGas->Expression,
					SpargingTime->Real,
					SpargingMix->Boolean,

					(*post*)
					HeadspaceGasFlush->Expression,
					HeadspaceGasFlushTime->Real,

					(*organizational*)
					BatchNumber->Integer,
					NumberOfChannels->Integer,
					SchlenkAdapter->Link,
					DegasCap->Link,
					Impeller->Link,
					ImpellerGuide->Link
				},
				Pattern:>{
					DegasType->DegasTypeP,
					Instrument->_Link,

					(*Freeze pump thaw*)
					FreezePumpThawContainer->_Link,
					FreezeTime->GreaterEqualP[0*Minute],
					PumpTime->GreaterEqualP[0*Minute],
					ThawTime->GreaterEqualP[0*Minute],
					ThawTemperature->GreaterEqualP[0*Celsius],
					NumberOfCycles->GreaterEqualP[3,1],

					(*vacuum degas*)
					VacuumTime->GreaterEqualP[0*Minute],
					VacuumUntilBubbleless->BooleanP,
					MaxVacuumTime->GreaterEqualP[0*Hour],
					VacuumSonicate->BooleanP,
					VacuumPressure->GreaterEqualP[0*Milli*Bar],

					(*sparging*)
					SpargingGas->DegasGasP,
					SpargingTime->GreaterEqualP[0*Minute],
					SpargingMix->BooleanP,

					(*post*)
					HeadspaceGasFlush->Alternatives[None,DegasGasP],
					HeadspaceGasFlushTime->GreaterEqualP[0*Minute],

					(*organizational*)
					BatchNumber->GreaterP[0,1],
					NumberOfChannels->GreaterP[0,1],
					SchlenkAdapter->_Link,
					DegasCap->_Link,
					Impeller->_Link,
					ImpellerGuide->_Link
				},
				Relation->{
					DegasType->Null,
					Instrument->Alternatives[
						Model[Instrument,FreezePumpThawApparatus],
						Object[Instrument,FreezePumpThawApparatus],
						Model[Instrument,VacuumDegasser],
						Object[Instrument,VacuumDegasser],
						Model[Instrument,SpargingApparatus],
						Object[Instrument,SpargingApparatus]
					],

					(*Freeze pump thaw*)
					FreezePumpThawContainer->Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
					FreezeTime->Null,
					PumpTime->Null,
					ThawTime->Null,
					ThawTemperature->Null,
					NumberOfCycles->Null,

					(*vacuum degas*)
					VacuumTime->Null,
					VacuumUntilBubbleless->Null,
					MaxVacuumTime->Null,
					VacuumSonicate->Null,
					VacuumPressure->Null,

					(*sparging*)
					SpargingGas->Null,
					SpargingTime->Null,
					SpargingMix->Null,

					(*post*)
					HeadspaceGasFlush->Null,
					HeadspaceGasFlushTime->Null,

					(*organizational*)
					BatchNumber->Null,
					NumberOfChannels->Null,
					SchlenkAdapter->Alternatives[Model[Plumbing],Object[Plumbing]],
					DegasCap->Alternatives[Model[Item,Cap],Object[Item,Cap]],
					Impeller->Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
					ImpellerGuide->Alternatives[Model[Part,AlignmentTool],Object[Part,AlignmentTool]]
				},
				Units->{
					DegasType->None,
					Instrument->None,

					(*Freeze pump thaw*)
					FreezePumpThawContainer->None,
					FreezeTime->Second,
					PumpTime->Second,
					ThawTime->Second,
					ThawTemperature->Celsius,
					NumberOfCycles->None,

					(*vacuum degas*)
					VacuumTime->Second,
					VacuumUntilBubbleless->None,
					MaxVacuumTime->Hour,
					VacuumSonicate->None,
					VacuumPressure->Milli*Bar,

					(*sparging*)
					SpargingGas->None,
					SpargingTime->Second,
					SpargingMix->None,

					(*post*)
					HeadspaceGasFlush->None,
					HeadspaceGasFlushTime->Second,

					(*organizational*)
					BatchNumber->None,
					NumberOfChannels->None,
					SchlenkAdapter->None,
					DegasCap->None,
					Impeller->None,
					ImpellerGuide->None
				},
				Headers->{
					DegasType->"Type",
					Instrument->"Instrument",

					(*Freeze pump thaw*)
					FreezePumpThawContainer->"Freeze Pump Thaw Container",
					FreezeTime->"Freeze Time",
					PumpTime->"Pump Time",
					ThawTime->"Thaw Time",
					ThawTemperature->"Degas Thaw Temperature",
					NumberOfCycles->"Number Of Cycles",

					(*vacuum degas*)
					VacuumTime->"Vacuum Time",
					VacuumUntilBubbleless->"Vacuum Until Bubbleless",
					MaxVacuumTime->"Max Vacuum Time",
					VacuumSonicate->"Vacuum Sonicate",
					VacuumPressure->"Vacuum Pressure",

					(*sparging*)
					SpargingGas->"Sparging Gas",
					SpargingTime->"Sparging Time",
					SpargingMix->"Sparging Mix",

					(*post*)
					HeadspaceGasFlush->"Headspace Gas Flush",
					HeadspaceGasFlushTime->"Headspace Gas Flush Time",

					(*organizational*)
					BatchNumber->"BatchNumber",
					NumberOfChannels->"Number of Channels",
					SchlenkAdapter->"Schlenk Adapter",
					DegasCap->"Degas Cap",
					Impeller->"Impeller",
					ImpellerGuide->"Impeller Guide"
				},
				IndexMatching->BatchLengths,
				Description -> "For each member of BatchLengths, the measurement setup values shared by each container in the batch, no matter the degas type.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedConnectionLengths -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				IndexMatching->BatchLengths,
				Description -> "For each member of BatchLengths, the list of batch sizes corresponding to number of cap-to-adapter/adapter-to-instrument connections per batch.",
				Category -> "Batching",
				Developer -> True
			},
			BatchedConnections -> {
				Format -> Multiple,
				Class -> {Link,String,Link,String},
				Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
				Relation -> {
					Alternatives[Object[Instrument],Object[Plumbing],Object[Container],Object[Item],Model[Instrument],Model[Plumbing],Model[Container],Model[Item]],
					Null,
					Alternatives[Object[Instrument],Object[Plumbing],Object[Container],Object[Item],Model[Instrument],Model[Plumbing],Model[Container],Model[Item]],
					Null
				},
				Description -> "For each member of BatchLengths, the plumbing connections between the caps, adapters, and instruments that will be made during the experiment, as organized for degas batch.",
				Headers -> {"Plumbing A","Plumbing A Connector","Plumbing B","Plumbing B Connector"},
				Category -> "Batching",
				Developer -> True
			},
			NumberOfCyclesLoop->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Description->"Indicates the number of cycles of freezing the sample, evacuating the headspace above the sample, and then thawing the sample that will be performed as part of a single freeze-pump-thaw protocol, used for looping in the procedure. The length of this field will correspond to the number of cycles that must be performed.",
				Category->"General",
				Developer->True
			},

			(* --- Cleanup Fields --- *)
			FullyBubbleless -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indicates if the sample appears fully bubbleless upon visual inspection, during the vacuum degas process.",
				Category -> "Experimental Results"
			},
			InitialDissolvedOxygen->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link|Null,
				Relation->Object[Protocol,MeasureDissolvedOxygen],
				Description->"The MeasureDissolvedOxygen protocol generated as a result of the execution of MeasureDissolvedOxygen, which is used to determine the initial dissolved oxygen reading of the sample.",
				Category -> "General"
			},
			FinalDissolvedOxygen->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link|Null,
				Relation->Object[Protocol,MeasureDissolvedOxygen],
				Description->"The MeasureDissolvedOxygen protocol generated as a result of the execution of MeasureDissolvedOxygen, which is used to determine the final dissolved oxygen reading of the sample.",
				Category -> "General"
			},
			InitialDissolvedOxygenConcentration->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(DistributionP[Percent]|DistributionP[Milligram/Liter])|Null,
				Description->"For each member of SamplesIn, indicates what the dissolved oxygen level of the sample is prior to running the degassing procedure.",
				Category->"Experimental Results",
				IndexMatching->SamplesIn
			},
			FinalDissolvedOxygenConcentration->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(DistributionP[Percent]|DistributionP[Milligram/Liter])|Null,
				Description->"For each member of SamplesIn, indicates what the dissolved oxygen level of the sample is prior to running the degassing procedure.",
				Category->"Experimental Results",
				IndexMatching->SamplesIn
			},
			(*Nitrogen pressure log and argon pressure log are in the general object protocol*)
			HeliumPressureLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure log for the helium gas source for the relevant section of the facility.",
				Category -> "General"
			},
			ChannelAGasPressure -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure data of the gas out of channel A of the schlenk line during the run, if used in the experiment.",
				Category -> "Sensor Information"
			},
			ChannelBGasPressure -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure data of the gas out of channel B of the schlenk line during the run, if used in the experiment.",
				Category -> "Sensor Information"
			},
			(* Schlenk has only two lines at ECL2 and CMU (Channels A and B). So Channels C and D Gas Pressure are DeveloperObject here.  *)
			ChannelCGasPressure -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure data of the gas out of channel C of the schlenk line during the run, if used in the experiment.",
				Category -> "Sensor Information",
				Developer -> True
			},
			ChannelDGasPressure -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure data of the gas out of channel D of the schlenk line during the run, if used in the experiment.",
				Category -> "Sensor Information",
				Developer -> True
			},
			TemperatureData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The measured temperature for the heat bath used to thaw the sample during the course of the thawing.",
				Category -> "Sensor Information"
			},
			VacuumSensorPressure -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Protocol],
				Description -> "The pressure data of the vacuum sensor connected to the schlenk line during the run.",
				Category -> "Sensor Information"
			},
			SampleImages -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "Images of the container and sample after a freeze or thaw step.",
				Category -> "Imaging",
				Developer -> True
			},
			(* Develop field for saving time points when a gas or vacuum valve is opened or closed for RecordSensor purposes*)
			ValveStartTime -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> _?DateObjectQ,
				Description -> "The time-point when a valve is opened or a vacuum pump is on.",
				Category -> "Sensor Information",
				Developer -> True
			},
			(*______________*)
			TeflonTape ->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
				Description -> "Teflon tape used to seal the connection between the flask and the cap during degassing step.",
				Category -> "General",
				Developer -> True
			},
			RemainingThawTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> TimeP,
				Units -> Second,
				Description -> "Thaw time remaining for the current iteration, calculated when operator enters Instrument Processing Completion check.",
				Category -> "Batching",
				Developer -> True
			}
		}
	}
];
