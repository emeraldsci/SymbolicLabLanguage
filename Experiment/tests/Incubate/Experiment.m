(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentIncubate : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentIncubate*)


(* ::Subsubsection::Closed:: *)
(*ExperimentIncubate*)


DefineTests[
	ExperimentIncubate,
	{
		(*-- BASIC TESTS --*)
		Example[
			{Basic,"Incubate the sample at 45 Celsius:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Temperature->45 Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Use the environmental stability chamber:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Temperature->25 Celsius, LightExposure->UVLight],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Mix the sample while also incubating at 80 Celsius:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],Mix->True,Temperature->80 Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Mix the specified samples. ExperimentIncubate will automatically resolve the best suited instrument to mix the samples on:"},
			ExperimentIncubate[{Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID]},Mix->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Vortex the specified samples using Model[Instrument,Vortex,\"id:dORYzZn0o45q\"] for 1 Hour, then continue mixing the samples up to 5 Hours until they are completely dissolved:"},
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixUntilDissolved->True,Time->1Hour,MaxTime->5Hour],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Thaw the given samples before mixing them at 50 Celsius. The samples will be thawed for a minimum of 30 Minutes, then will continue being thawed for up to 2 Hours, until they are completely thawed. Samples always go through the thaw stage (if Thaw->True) before they are mixed/incubated:"},
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawTime->30Minute,MaxThawTime->2Hour,ThawTemperature->60Celsius,Mix->True,Temperature->Ambient],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Samples that have TransportWarmed->True in their Model and are being incubated with heat will be left in their instrument to continue heating and mixing after Time/MaxTime until the operator returns to continue the protocol:"},
			ExperimentIncubate[Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubate"<>$SessionUUID],Mix->True,Temperature->50Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Specify {Position, Container} as the input."},
			ExperimentIncubate[{"A1",Object[Container, Plate,"Test container 6 for ExperimentIncubate"<>$SessionUUID]}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Specifiy a mixture of different types of the inputs."},
			ExperimentIncubate[{Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],{"A1", Object[Container, Plate, "Test container 6 for ExperimentIncubate"<>$SessionUUID]}}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,StirBar,"Use a StirBar to mix the sample:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],Mix->True,Temperature->80 Celsius,StirBar->Model[Part,StirBar,"2 Inch Stir Bar"]],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Use the plate sonicator with a specified duty cycle and amplitude:"},
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Sonicate, DutyCycle->{5 Second, 5 Second}, Amplitude->80 Percent],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,TemperatureProfile,"Specify a TemperatureProfile when shaking:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Shake, MixUntilDissolved->True, Time->10 Minute, MaxTime->20 Minute, TemperatureProfile->{{0 Second, 30 Celsius}, {5 Minute, 45 Celsius}}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixRateProfile,"Specify a MixRateProfile when shaking:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Shake, MixUntilDissolved->True, Time->10 Minute, MaxTime->20 Minute, MixRateProfile->{{0 Second, 200 RPM}, {5 Minute, 800 RPM}}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Mix via disruption:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 2mL tube for ExperimentIncubate"<>$SessionUUID], MixType->Disrupt, MixUntilDissolved->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Mix via swirling:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID], MixType->Swirl, NumberOfMixes->10, MaxNumberOfMixes->30, MixUntilDissolved->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Mix via nutation:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID], MixType->Nutate, MixUntilDissolved->True],
			ObjectP[Object[Protocol]]
		],
		(*-- OPTIONS --*)
		(*-- TYPE TESTS --*)
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since Instrument is set to be a Vortex, MixType is resolved to be Vortex:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],Output->Options],MixType],
			Vortex
		],
		Test[
			"MixType is resolved based on Instrument first:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,OverheadStirrer,"id:rea9jlRRmN05"],Output->Options],MixType],
			Stir
		],
		Test[
			"MixType is resolved based on Instrument first:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Sonicator,"id:Vrbp1jG80Jqx"],Output->Options],MixType],
			Sonicate
		],
		Test[
			"MixType is resolved based on Instrument first:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Null,MixVolume->10Milliliter,Output->Options],MixType],
			Pipette
		],
		Test[
			"If the volume of a sample is over 50 mL (the largest pipette tip we have) and we want to Mix with no instrument, we resolve to Invert:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubate"<>$SessionUUID],Mix->True,Instrument->Null,Output->Options],MixType],
			Invert
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since MixVolume is set, an appropriate MixType is chosen:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],MixVolume->50Milliliter,Output->Options],MixType],
			Pipette
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since NumberOfMixes is set and our sample is in an OpenContainer, an appropriate MixType is chosen:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubate"<>$SessionUUID], NumberOfMixes -> 5, Output -> Options],MixType],
			Pipette
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since NumberOfMixes is set and our sample is in an closed container, an appropriate MixType is chosen:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID], NumberOfMixes -> 5, Output -> Options],MixType],
			Invert
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since Temperature is set and Mix->True, MixType is resolved to a MixType that supports incubation while mixing:"},
			Lookup[ExperimentIncubate[Object[Sample, "Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],Mix->True,Temperature -> 40 Celsius, Output -> Options],MixType],
			Stir|Roll|Shake
		],
		Test[
			"If Time is set, MixType resolves to something reasonable:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubate"<>$SessionUUID],Time->2 Hour,Output->Options],MixType],
			_
		],
		Test[
			"Mixing with the MPH works fine if there are 96 samples:",
			ExperimentRoboticSamplePreparation[{
				LabelContainer[
					Label -> "my plate",
					Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> ({#, "my plate"} &) /@ Flatten[AllWells[]],
					Amount -> 500 Microliter
				],
				Mix[
					Sample -> "my plate",
					DeviceChannel -> MultiProbeHead
				]
			}],
			ObjectP[]
		],
		Test[
			"Mixing with the MPH throws an error if there are not 96 samples:",
			ExperimentRoboticSamplePreparation[{
				LabelContainer[
					Label -> "my plate",
					Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> ({#, "my plate"} &) /@ Flatten[AllWells[]][[1;;10]],
					Amount -> 500 Microliter
				],
				Mix[
					Sample -> "my plate",
					DeviceChannel -> MultiProbeHead
				]
			}],
			$Failed,
			Messages:>{
				Error::InvalidMultiProbeHeadMix,
				Error::InvalidInput
			}
		],
		Test[
			"If MixType is specified for any other sample in the same container, that MixType is used to mix the sample:",
			Lookup[
				ExperimentIncubate[
					{
						Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
						Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID]
					},
					Mix->True,
					MixType->{Shake,Automatic},
					Output->Options
				],
			MixType],
			{Shake,Shake},
			Messages:>{}
		],
		Test[
			"By default, plates are vortexed:",
			Lookup[
				ExperimentIncubate[
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
					Mix->True,
					Output->Options
				],
			MixType],
			Vortex
		],
		(*-- INVERT TESTS --*)
		(*-- PIPETTE TESTS -- *)
		Example[
			{Options,MixVolume,"When MixType->Pipette, volume resolves reasonably based on the volume of the given sample:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Pipette,Output->Options],MixVolume],
			RangeP[0Liter,50Milliliter]
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentIncubate[Link[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID], Now - 1 Second], MixType->Pipette, Output -> Options],
			{__Rule},
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[
			{Messages,"MixVolumeGreaterThanAvailable","If specifying a volume that is greater than the current volume of the same, a message will be thrown:"},
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixVolume->50Milliliter,Output->Options],
			_,
			Messages:>{
				Warning::MixVolumeGreaterThanAvailable
			}
		],
		(*-- VORTEX TESTS --*)
		Test[
			"When given a vortex but not a rate, the rate is resolved to the average RPM of that Instrument, rounded to the nearest RPM:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"],Output->Options],MixRate],
			Round[Mean[Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"][{MinRotationRate,MaxRotationRate}]],1RPM]
		],
		Test[
			"Mixing a DWP at 40 C defaults to vortexing:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Mix->True,Temperature->40 Celsius,Output->Options],MixType],
			Vortex
		],
		Example[
			{Messages,"VortexManualInstrumentContainers","When a vortex instrument is manually specified and the sample cannot fit onto that instrument, a message is thrown to warn the user:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],Output->Options],
			_,
			Messages:>{
				Error::VortexIncompatibleInstruments,
				Error::InvalidOption
			}
		],
		(*-- ROLL TESTS --*)
		Test[
			"When given a roller but not a rate, the rate is resolved to the average RPM of that Instrument, rounded to the nearest RPM:",
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,BottleRoller,"id:4pO6dMWvnJ9B"],Output->Options],MixRate],
			Round[Mean[Model[Instrument,BottleRoller,"id:4pO6dMWvnJ9B"][{MinRotationRate,MaxRotationRate}]],1RPM],
			Messages:>{
				Warning::AliquotRequired
			}
		],
		(*-- STIR TESTS --*)
		Test[
			"Specify a 50mL tube to be mixed via overhead stirring:",
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Stir,Output->Options],
			_
		],
		(*-- HOMOGENIZE TESTS --*)
		Test[
			"Specify a 50mL tube to be mixed via homogenization:",
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Homogenize],
			ObjectP[Object[Protocol]]
		],
		Test[
			"Specify a 50mL tube to be mixed via homogenization aiming to maintain a temperature of 50C with a maximum temperature of 80C (where the instrument will turn off if the sample reaches this temperature and wait for it to cool down):",
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Homogenize,Temperature->50 Celsius,MaxTemperature->80 Celsius],
			ObjectP[Object[Protocol]]
		],
		(* -- Option Tests -- *)
		Example[
			{Options,Preparation,"Specify that the preparation should be manual:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Preparation->Manual],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Preparation,"Specify that the preparation should be robotic:"},
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Preparation->Robotic],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Thaw,"Specify that the samples should be thawed first before they are incubated:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawTemperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Thaw,"Specify that the samples should be thawed first before they are mixed:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawTemperature->40Celsius,Mix->True,MixType->Vortex],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,ThawTime,"Specify that the samples should be thawed for at least 10 minutes:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawTime->10Minute,ThawTemperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxThawTime,"Specify that the samples should be thawed for at least 10 minutes. Then, if they are still not fully thawed after 10 minutes, thaw them for another 30 minutes:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawTime->10Minute,MaxThawTime->30Minute],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,ThawTemperature,"Specify the temperature at which the samples should be thawed:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawTime->10Minute,ThawTemperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,ThawInstrument,"Specify the model of incubator that should be used to thaw the samples:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Thaw->True,ThawInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Mix,"Specify that the samples should be mixed. ExperimentIncubate will figure out the optimal mixing instrument to use to mix the sample(s):"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixType,"Specify that the samples should be mixed by vortex. To see all of the valid mix types, evaluate MixTypeP:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[
			{Options,MixUntilDissolved,"Specify that the samples should be mix until they are fully dissolved. Mix the samples by vortex for 30 minutes and if they are not fully dissolved mix them again up to a maximum time of 3 hours:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Vortex,MixUntilDissolved->True,Time->30Minute,MaxTime->3Hour,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Time,"Specify that the samples should be mix until they are fully dissolved. Mix the samples by vortex for 30 minutes and if they are not fully dissolved mix them again up to a maximum time of 3 hours:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Vortex,MixUntilDissolved->True,Time->30Minute,MaxTime->3Hour,Output->Options];
			Lookup[options,Time],
			30 Minute,
			Variables:>{options}
		],
		Example[
			{Options,MaxTime,"Specify that the samples should be mix until they are fully dissolved. Mix the samples by vortex for 30 minutes and if they are not fully dissolved mix them again up to a maximum time of 3 hours:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Vortex,MixUntilDissolved->True,Time->30Minute,MaxTime->3Hour,Output->Options];
			Lookup[options,MaxTime],
			3 Hour,
			Variables:>{options}
		],
		Example[
			{Options,MixRate,"Specify that the samples should be rolled at a rate of 35 RPM:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Roll,MixRate->35RPM],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,NumberOfMixes,"Specify that the samples should be mixed via inversion for 20 times:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Invert,NumberOfMixes->20],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxNumberOfMixes,"Specify that the samples should be mixed via inversion for 20 times, then if they are not fully dissolved, mix them again up to 25 more times:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Invert,NumberOfMixes->20,MixUntilDissolved->True,MaxNumberOfMixes->25],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Temperature,"Specify that the samples should be both mixed and incubated at 40 Celsius:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,Temperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixVolume,"Specify that the samples should be both mixed via pipette with said pipette set to 10 mL:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Mix->True,MixType->Pipette,MixVolume->10Milliliter],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Instrument,"Specify that the samples should be mixed using a specific vortex model:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"]],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxTemperature,"Specify a 50mL tube to be mixed via homogenization aiming to maintain a temperature of 50C with a maximum temperature of 80C (where the instrument will turn off if the sample reaches this temperature and wait for it to cool down):"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Homogenize,Temperature->50 Celsius,MaxTemperature->80 Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Amplitude,"Specify an amplitude of 50 Percent when mixing the given sample by Homogenization:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Homogenize,Amplitude->50 Percent],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,DutyCycle,"Specify a duty cycle of 10 Milliseconds On, 20 Milliseconds Off when mixing the given sample by Homogenization:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Homogenize,DutyCycle->{10 Millisecond, 20 Millisecond}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,SampleLabel,"Specify a SampleLabel:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],SampleLabel->"My Test Sample Label",Output->Options],SampleLabel],
			"My Test Sample Label"
		],
		Example[
			{Options,SampleContainerLabel,"Specify a SampleContainerLabel:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],SampleContainerLabel->"My Test Sample Container Label",Output->Options],SampleContainerLabel],
			"My Test Sample Container Label"
		],
		Example[
			{Options,OscillationAngle,"Specify a OscillationAngle:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],OscillationAngle->5*AngularDegree,Output->Options],OscillationAngle],
			5 AngularDegree
		],
		Example[
			{Options,AnnealingTime,"Specify a AnnealingTime:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],AnnealingTime->5 Minute,Output->Options],AnnealingTime],
			5 Minute
		],
		Example[
			{Options,MixFlowRate,"Specify a MixFlowRate:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixFlowRate->5 Microliter/Second,Output->Options],MixFlowRate],
			5 Microliter/Second
		],
		Example[
			{Options,MixPosition,"Specify a MixPosition:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixPosition->Top,Output->Options],MixPosition],
			Top
		],
		Example[
			{Options,MixPositionOffset,"Specify a MixPositionOffset:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixPositionOffset->1 Millimeter,Output->Options],MixPositionOffset],
			1 Millimeter
		],
		Example[
			{Options,MixPositionOffset,"Specify a MixPositionOffset in 3 coordinates:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixPositionOffset->Coordinate[{1 Millimeter, 2 Millimeter, 3 Millimeter}],Output->Options],MixPositionOffset],
			Coordinate[{1 Millimeter, 2 Millimeter, 3 Millimeter}]
		],
		Example[
			{Options,CorrectionCurve,"Specify a CorrectionCurve:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],CorrectionCurve->{{0 Microliter, 0 Microliter}, {1 Microliter,2 Microliter}, {1000 Microliter, 1030 Microliter}},Preparation->Robotic,Output->Options],CorrectionCurve],
			{{0 Microliter, 0 Microliter}, {1 Microliter,2 Microliter}, {1000 Microliter, 1030 Microliter}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Tips,"Specify the Tips:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Tips->Model[Item, Tips, "id:J8AY5jDvl5lE"],Output->Options],Tips],
			ObjectP[Model[Item, Tips, "id:J8AY5jDvl5lE"]]
		],
		Example[
			{Options,TipType,"Specify the TipType:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],TipType->Normal,Output->Options],TipType],
			Normal
		],
		Example[
			{Options,Instrument,"Specify the Pipette used to mix the sample:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument, Pipette, "id:1ZA60vL547EM"],Output->Options],Instrument],
			ObjectP[Model[Instrument, Pipette, "id:1ZA60vL547EM"]]
		],
		Example[
			{Options,TipMaterial,"Specify the TipMaterial:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],TipMaterial->Polypropylene,Output->Options],TipMaterial],
			Polypropylene
		],
		Example[
			{Options,MultichannelMix,"Specify whether multiple device channels should be used to mix the sample:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MultichannelMix->True,Output->Options],MultichannelMix],
			True
		],
		Example[
			{Options,DeviceChannel,"Specify the channel of the work cell that should be used to perform the pipetting mixing:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],DeviceChannel->SingleProbe1,Output->Options],DeviceChannel],
			SingleProbe1
		],
		Example[
			{Options,ResidualIncubation,"Specify the residual incubation:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],ResidualIncubation->True,Output->Options],ResidualIncubation],
			True
		],
		Example[
			{Options,ResidualTemperature,"Specify the residual temperature:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],ResidualTemperature->36 Celsius,Output->Options],ResidualTemperature],
			36 Celsius
		],
		Example[
			{Options,ResidualMix,"Specify the residual mix:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixType->Shake,ResidualMix->True,Output->Options],ResidualMix],
			True
		],
		Example[
			{Options,ResidualMixRate,"Specify the residual mix rate:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],MixType->Shake,ResidualMixRate->50 RPM,Output->Options],ResidualMixRate],
			50 RPM
		],
		Example[
			{Options,Preheat,"Specify the Preheat:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Preheat->True,Output->Options],Preheat],
			True
		],
		Example[
			{Options,RelativeHumidity,"Specify a RelativeHumidity:"},
			Lookup[ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],RelativeHumidity->75 Percent,Output->Options],RelativeHumidity],
			75` Percent
		],

		Example[
			{Messages,"ConflictingUnitOperationMethodRequirements","If the Preparation is set and conflicts with an option given, an error will be thrown:"},
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Preparation->Robotic,MixUntilDissolved->True,MixType->Pipette],
			$Failed,
			Messages:>{
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Test[
			"If the Preparation is set to Manual and conflicts with an option given, an error will be thrown:",
			ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Preparation->Manual,ResidualMix->True],
			_,
			Messages:>{
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],

		(*-- INVALID INPUT TESTS --*)
		Example[
			{Messages,"DiscardedSamples","If the given samples are discarded, they cannot be mixed:"},
			ExperimentIncubate[Object[Sample,"Test discarded sample for ExperimentIncubate"<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		(*-- OPTION PRECISION TESTS --*)
		Example[
			{Messages,"InstrumentPrecision","If a Temperature with a greater precision that 1. Celsius is given, it is rounded:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Temperature->50.5Celsius],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a Time with a greater precision that 1. Second is given, it is rounded:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Time->1.342 Minute],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a MaxTime with a greater precision that 1. Second is given, it is rounded:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MaxTime->1.342 Minute],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a MixVolume with a greater precision that 1. Microliter is given, it is rounded:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixVolume->45.333333333333 Milliliter],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a MixRate with a greater precision that 1. RPM is given, it is rounded:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixRate->200.5RPM],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		(*-- CONFLICTING OPTION TESTS --*)
		Example[
			{Messages,"MixInstrumentTypeMismatch","If the Instrument and MixType options do not agree, an error is thrown:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixType->Pipette],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixTypeIncorrectOptions","If the resolved mix type does not agree with the other otpions set, an error will be thrown:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixType->Pipette],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixTypeRateMismatch","If the MixType and MixRate options do not agree, an error is thrown:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Invert,MixRate->100RPM],
			$Failed,
			Messages:>{
				Error::MixTypeRateMismatch,
				Error::MixTypeIncorrectOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixTypeNumberOfMixesMismatch","If the MixType and NumberOfMixes/MaxNumberOfMixes options do not agree, an error is thrown:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MixType->Vortex,NumberOfMixes->3],
			$Failed,
			Messages:>{
				Error::MixTypeNumberOfMixesMismatch,
				Error::MixTypeIncorrectOptions,
				Error::InvalidOption
			}
		],
		(*-- CONFLICTING OPTION TESTS --*)
		
		Example[{Messages,"InvalidTemperatureProfile","If TemperatureProfile is specified, the times are specified in the increasing order:"},
			ExperimentIncubate[
				Object[Sample,"Test water sample in PCR Plate for ExperimentIncubate"<>$SessionUUID],
				TemperatureProfile->{{0 Minute,0 Celsius},{1 Minute,10 Celsius},{2 Minute,20 Celsius},{1.5 Minute,15 Celsius}}
			],
			$Failed,
			Messages:>{Error::InvalidTemperatureProfile,Error::InvalidOption}
		],
		
		Example[{Messages,"InvalidTemperatureProfile","If TemperatureProfile is specified, the profile length does not exceed MaxTime:"},
			ExperimentIncubate[
				Object[Sample,"Test water sample in PCR Plate for ExperimentIncubate"<>$SessionUUID],
				TemperatureProfile->{{0 Minute,30 Celsius},{70 Minute,30 Celsius}},
				MaxTime->1 Hour
			],
			$Failed,
			Messages:>{Error::InvalidTemperatureProfile,Error::InvalidOption}
		],
		
		Example[{Messages,"InvalidTemperatureProfile","If TemperatureProfile is specified, it contains no more than 50 points:"},
			ExperimentIncubate[
				Object[Sample,"Test water sample in PCR Plate for ExperimentIncubate"<>$SessionUUID],
				TemperatureProfile->Table[{n*0.5*Minute,(25+n*1.5) Celsius},{n,0,51}]
			],
			$Failed,
			Messages:>{Error::InvalidTemperatureProfile,Error::InvalidOption}
		],
		Example[
			{Messages,"ResidualIncubationInvalid","If Shake is requested on the off-deck shaker robotically, residual incuabtion optpions cannot be specified:"},
			ExperimentRoboticCellPreparation[
				{
					Incubate[
						Sample -> Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
						MixType -> Shake,
						Instrument -> Model[Instrument, Shaker, "id:eGakldJkWVnz"],
						ResidualIncubation -> True,
						Preparation -> Robotic
					]
				}
			],
			$Failed,
			Messages:>{
				Error::ResidualIncubationInvalid,Error::InvalidInput
			}
		],

		(* CorrectionCurve Error Checking *)
		Example[
			{Messages,"CorrectionCurveNotMonotonic","A warning is thrown if the specified CorrectionCurve does not have monotonically increasing actual volume values:"},
			Lookup[
				ExperimentIncubate[
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
					CorrectionCurve -> {
						{0 Microliter, 0 Microliter},
						{60 Microliter, 55 Microliter},
						{50 Microliter, 60 Microliter},
						{150 Microliter, 180 Microliter},
						{300 Microliter, 345 Microliter},
						{500 Microliter, 560 Microliter},
						{1000 Microliter, 1050 Microliter}
					},
					Preparation->Robotic,
					Output->Options
				],
				CorrectionCurve
			],
			{
				{0 Microliter, 0 Microliter},
				{60 Microliter, 55 Microliter},
				{50 Microliter, 60 Microliter},
				{150 Microliter, 180 Microliter},
				{300 Microliter, 345 Microliter},
				{500 Microliter, 560 Microliter},
				{1000 Microliter, 1050 Microliter}
			},
			Messages:>{
				Warning::CorrectionCurveNotMonotonic
			},
			EquivalenceFunction->Equal
		],
		Example[
			{Messages,"CorrectionCurveIncomplete","A warning is thrown if the specified CorrectionCurve does not covers the transfer volume range of 0 uL - 1000 uL:"},
			Lookup[
				ExperimentIncubate[
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
					CorrectionCurve -> {
						{0 Microliter, 0 Microliter},
						{50 Microliter, 60 Microliter},
						{150 Microliter, 180 Microliter},
						{300 Microliter, 345 Microliter},
						{500 Microliter, 560 Microliter}
					},
					Preparation->Robotic,
					Output->Options
				],
				CorrectionCurve
			],
			{
				{0 Microliter, 0 Microliter},
				{50 Microliter, 60 Microliter},
				{150 Microliter, 180 Microliter},
				{300 Microliter, 345 Microliter},
				{500 Microliter, 560 Microliter}
			},
			Messages:>{
				Warning::CorrectionCurveIncomplete
			},
			EquivalenceFunction->Equal
		],
		Example[
			{Messages,"InvalidCorrectionCurveZeroValue","A CorrectionCurve with a 0 Microliter target volume entry must have a 0 Microliter actual volume value:"},
			ExperimentIncubate[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
				CorrectionCurve -> {
					{0 Microliter, 5 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				},
				Preparation->Robotic
			],
			$Failed,
			Messages :> {Error::InvalidCorrectionCurveZeroValue,Error::InvalidOption}
		],
		Example[
			{Messages,"LowPipetteMixVolume","If a sample is missing volume, resolve MixVolume to 1 uL for pipetting mixing and throw a warning:"},
			Lookup[
				ExperimentIncubate[
					Object[Sample,"Test no volume sample for ExperimentIncubate"<>$SessionUUID],
					Preparation->Robotic,
					MixType -> Pipette,
					Output->Options
				],
				MixVolume
			],
			EqualP[1Microliter],
			Messages:>{
				Warning::LowPipetteMixVolume
			}
		],
		
		Test[
			"Specifying Output->Tests returns a list of tests:",
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Output->Tests],
			{_EmeraldTest..}
		],
		Example[
			{Options,PreparatoryPrimitives,"Transfer 10mL of water into a 50mL tube and then incubate it at 80C for 2 hours:"},
			ExperimentIncubate[
				"My Container",
				PreparatoryPrimitives->{
					Define[Name->"My Container",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My Container"]
				},
				Time-> 2 Hour,
				Temperature->80 Celsius
			],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Transfer 10mL of water into a 50mL tube and then incubate it at 80C for 2 hours:"},
			ExperimentIncubate[
				"My Container",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"My Container",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My Container"]
				},
				Time-> 2 Hour,
				Temperature->80 Celsius
			],
			ObjectP[Object[Protocol]]
		],

		(* Tests for the robotic branching *)
		Test[
			"Test that the appropriate options are Null-ed out if Preparation is Robotic:",
			options=ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Preparation->Robotic,Output->Options];
			Lookup[options,{
				Thaw,
				ThawTime,
				MaxThawTime,
				ThawTemperature,
				ThawInstrument,
				MixUntilDissolved,
				StirBar,
				MaxTime,
				DutyCycle,
				MixRateProfile,
				MaxNumberOfMixes,
				TemperatureProfile,
				MaxTemperature,
				OscillationAngle,
				Amplitude,
				AnnealingTime}],
			{Null..},
			Variables:>{options}
		],
		Test[
			"Test that the appropriate options are Null-ed out if Preparation is Manual:",
			options=ExperimentIncubate[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],Preparation->Manual,Output->Options];
			Lookup[options,
				{MixFlowRate,MixPosition,MixPositionOffset,CorrectionCurve,Tips,TipType,
				TipMaterial,MultichannelMix,DeviceChannel,
				ResidualTemperature,ResidualMix,ResidualMixRate,Preheat}],
			{Null..},
			Variables:>{options}
		],

		(* Other additional unit tests *)
		(*post processing options*)
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],TargetConcentration->8*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			8*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],TargetConcentration->9*Micromolar,TargetConcentrationAnalyte->Model[Molecule,"Sodium n-Dodecyl Sulfate"],Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Sodium n-Dodecyl Sulfate"]],
			Variables:>{options}
		],
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeTemperature->30*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeAliquot->10*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquot],
			10 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeAliquot->10*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FiltrationType->Syringe,FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filter->Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterMaterial->PES,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],

		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterPoreSize->0.22*Micrometer,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],

		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],PrefilterPoreSize->1.*Micrometer,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane. This will resolve to Null for volumes we would use in this experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterHousing->Null,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTemperature->22*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterSterile->False,Output->Options];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->10*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		(*Aliquot options*)
		Example[{Options,Aliquot,"Perform a incubate experiment on a single liquid sample by first aliquotting the sample:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],AliquotAmount->10*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,AliquotAmount],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],AssayVolume->10*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->2,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->10*Microliter,AssayVolume->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,AliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],SamplesInStorageCondition->Refrigerator,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Name->"My Exploratory Incubate Test Protocol",Output->Options];
			Lookup[options,Name],
			"My Exploratory Incubate Test Protocol"
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],Template->Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubate testing"<>$SessionUUID],Output->Options];
			Lookup[options,MixType],
			Nutate,
			Variables:>{options}
		],
		Example[{Options, Output, "Simulation is returned when Output-> Simulation is specified:"},
			simulation = ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],
				Output -> Simulation];
			simulation,
			SimulationP,
			Variables:>{simulation}
		],
		Example[{Options, Output, "RunTime is correctly returned when Output-> RunTime is specified:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],
				Output -> RunTime],
			TimeP
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentIncubate[
				Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentIncubate[
				Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		]

	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>Module[
		{
			emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,
			discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10, noVolumeSample
		},
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 3 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 4 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 5 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Plate,"Test container 6 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 7 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 8 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 9 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 10 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Plate,"Test container 11 for ExperimentIncubate"<>$SessionUUID],
			Object[Container,Vessel,"Test container 12 for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test discarded sample for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test no volume sample for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ExperimentIncubate"<>$SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubate"<>$SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ExperimentIncubate"<>$SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubate testing"<>$SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Plate,"Test container 6 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 7 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 8 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 9 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 10 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Plate,"Test container 11 for ExperimentIncubate"<>$SessionUUID],
					Object[Container,Vessel,"Test container 12 for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test discarded sample for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test no volume sample for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ExperimentIncubate"<>$SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubate"<>$SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ExperimentIncubate"<>$SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubate testing"<>$SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];


		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ExperimentIncubate testing"<>$SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 12 for ExperimentIncubate"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ExperimentIncubate"<>$SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10, noVolumeSample}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubate"<>$SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11},
				{"A1",emptyContainer12}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter, Null},
			Name->{
				"Test discarded sample for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in 50mL tube for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in 1L Glass Bottle for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in 2L Glass Bottle for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in Open Test Tube for ExperimentIncubate"<>$SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in 5L Glass Bottle for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in 15mL tube for ExperimentIncubate"<>$SessionUUID,
				"Test TransportWarmed at 70C sample for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in 2mL tube for ExperimentIncubate"<>$SessionUUID,
				"Test water sample in PCR Plate for ExperimentIncubate"<>$SessionUUID,
				"Test no volume sample for ExperimentIncubate"<>$SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>,
			<|Object->noVolumeSample,DeveloperObject->True,Status->Available|>
		}];
	],
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMix*)


DefineTests[
	ExperimentMix,
	{
		(*-- BASIC TESTS --*)
		Example[
			{Basic,"Mix the sample at 45 Celsius:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Temperature->45 Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Mix the sample while also incubating at 80 Celsius:"},
			ExperimentMix[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],Mix->True,Temperature->80 Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Mix the specified samples. ExperimentMix will automatically resolve the best suited instrument to mix the samples on:"},
			ExperimentMix[{Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"]},Mix->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Vortex the specified samples using Model[Instrument,Vortex,\"id:dORYzZn0o45q\"] for 1 Hour, then continue mixing the samples up to 5 Hours until they are completely dissolved:"},
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixUntilDissolved->True,Time->1Hour,MaxTime->5Hour],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Thaw the given samples before mixing them at 50 Celsius. The samples will be thawed for a minimum of 30 Minutes, then will continue being thawed for up to 2 Hours, until they are completely thawed. Samples always go through the thaw stage (if Thaw->True) before they are mixed/incubated:"},
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Thaw->True,ThawTime->30Minute,MaxThawTime->2Hour,ThawTemperature->60Celsius,Mix->True,Temperature->Ambient],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Samples that have TransportWarmed->True in their Model and are being incubated with heat will be left in their instrument to continue heating and mixing after Time/MaxTime until the operator returns to continue the protocol:"},
			ExperimentMix[Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMix"],Mix->True,Temperature->50Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,StirBar,"Use a StirBar to mix the sample:"},
			ExperimentMix[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],Mix->True,Temperature->80 Celsius,StirBar->Model[Part,StirBar,"2 Inch Stir Bar"]],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Use the plate sonicator with a specified duty cycle and amplitude:"},
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Mix->True,MixType->Sonicate, DutyCycle->{5 Second, 5 Second}, Amplitude->80 Percent],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,TemperatureProfile,"Specify a TemperatureProfile when shaking:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Shake, MixUntilDissolved->True, Time->10 Minute, MaxTime->20 Minute, TemperatureProfile->{{0 Second, 30 Celsius}, {5 Minute, 45 Celsius}}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixRateProfile,"Specify a MixRateProfile when shaking:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Shake, MixUntilDissolved->True, Time->10 Minute, MaxTime->20 Minute, MixRateProfile->{{0 Second, 200 RPM}, {5 Minute, 800 RPM}}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Mix via disruption:"},
			ExperimentMix[Object[Sample,"Test water sample in 2mL tube for ExperimentMix"], MixType->Disrupt, MixUntilDissolved->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Mix via swirling:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"], MixType->Swirl, NumberOfMixes->10, MaxNumberOfMixes->30, MixUntilDissolved->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Additional,"Mix via nutation:"},
			ExperimentIncubate[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"], MixType->Nutate, MixUntilDissolved->True],
			ObjectP[Object[Protocol]]
		],
		(*-- OPTIONS --*)
		(*-- TYPE TESTS --*)
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since Instrument is set to be a Vortex, MixType is resolved to be Vortex:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],Output->Options],MixType],
			Vortex
		],
		Test[
			"Mix resolves to True by default:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],Output->Options],Mix],
			True
		],
		Test[
			"MixType is resolved based on Instrument first:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],Instrument->Model[Instrument,OverheadStirrer,"id:rea9jlRRmN05"],Output->Options],MixType],
			Stir
		],
		Test[
			"MixType is resolved based on Instrument first:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,Sonicator,"id:Vrbp1jG80Jqx"],Output->Options],MixType],
			Sonicate
		],
		Test[
			"MixType is resolved based on Instrument first:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Null,MixVolume->10Milliliter,Output->Options],MixType],
			Pipette
		],
		Test[
			"If the volume of a sample is over 50 mL (the largest pipette tip we have) and we want to Mix with no instrument, we resolve to Invert:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMix"],Mix->True,Instrument->Null,Output->Options],MixType],
			Invert
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since MixVolume is set, an appropriate MixType is chosen:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],MixVolume->50Milliliter,Output->Options],MixType],
			Pipette
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since NumberOfMixes is set and our sample is in an OpenContainer, an appropriate MixType is chosen:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in Open Test Tube for ExperimentMix"], NumberOfMixes -> 5, Output -> Options],MixType],
			Pipette
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since NumberOfMixes is set and our sample is in an closed container, an appropriate MixType is chosen:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"], NumberOfMixes -> 5, Output -> Options],MixType],
			Invert
		],
		Example[
			{Options,MixType,"When MixType->Automatic, it is automatically resolved. In the following example, since Temperature is set and Mix->True, MixType is resolved to a MixType that supports incubation while mixing:"},
			Lookup[ExperimentMix[Object[Sample, "Test water sample in 2L Glass Bottle for ExperimentMix"],Mix->True,Temperature -> 40 Celsius, Output -> Options],MixType],
			Stir|Roll|Shake
		],
		Test[
			"If Time is set, MixType resolves to something reasonable:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMix"],Time->2 Hour,Output->Options],MixType],
			_
		],
		Test[
			"If MixType is specified for any other sample in the same container, that MixType is used to mix the sample:",
			Lookup[
				ExperimentMix[
					{
						Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
						Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMix"]
					},
					Mix->True,
					MixType->{Shake,Automatic},
					Output->Options
				],
				MixType],
			{Shake,Shake},
			Messages:>{}
		],
		Test[
			"By default, plates are vortexed:",
			Lookup[
				ExperimentMix[
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
					Mix->True,
					Output->Options
				],
				MixType],
			Vortex
		],
		(*-- INVERT TESTS --*)
		(*-- PIPETTE TESTS -- *)
		Example[
			{Options,MixVolume,"When MixType->Pipette, volume resolves reasonably based on the volume of the given sample:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Pipette,Output->Options],MixVolume],
			RangeP[0Liter,50Milliliter]
		],
		Example[
			{Messages,"MixVolumeGreaterThanAvailable","If specifying a volume that is greater than the current volume of the same, a message will be thrown:"},
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixVolume->50Milliliter,Output->Options],
			_,
			Messages:>{
				Warning::MixVolumeGreaterThanAvailable
			}
		],
		(*-- VORTEX TESTS --*)
		Test[
			"When given a vortex but not a rate, the rate is resolved to the average RPM of that Instrument, rounded to the nearest RPM:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"],Output->Options],MixRate],
			Round[Mean[Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"][{MinRotationRate,MaxRotationRate}]],1RPM]
		],
		Test[
			"Mixing a DWP at 40 C defaults to vortexing:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Mix->True,Temperature->40 Celsius,Output->Options],MixType],
			Vortex
		],
		Example[
			{Messages,"VortexManualInstrumentContainers","When a vortex instrument is manually specified and the sample cannot fit onto that instrument, a message is thrown to warn the user:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],Output->Options],
			_,
			Messages:>{
				Error::VortexIncompatibleInstruments,
				Error::InvalidOption
			}
		],
		(*-- ROLL TESTS --*)
		Test[
			"When given a roller but not a rate, the rate is resolved to the average RPM of that Instrument, rounded to the nearest RPM:",
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,BottleRoller,"id:4pO6dMWvnJ9B"],Output->Options],MixRate],
			Round[Mean[Model[Instrument,BottleRoller,"id:4pO6dMWvnJ9B"][{MinRotationRate,MaxRotationRate}]],1RPM],
			Messages:>{
				Warning::AliquotRequired
			}
		],
		(*-- STIR TESTS --*)
		Test[
			"Specify a 50mL tube to be mixed via overhead stirring:",
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Stir,Output->Options],
			_
		],(*
		Example[
			{Messages,"StirAutomaticInstrumentContainers","Samples in incompatible containers (in this case, a 15mL tube) will have to be moved into a different container in order to be mixed by the overhead Instrument:"},
			ExperimentMix[Object[Sample,"Test water sample in 15mL tube for ExperimentMix"],MixType->Stir,Output->Options],
			_,
			Messages:>{
				Warning::StirAutomaticInstrumentContainers,
				Warning::IncubateIncompatibleContainers
			}
		],*)
		(*-- HOMOGENIZE TESTS --*)
		Test[
			"Specify a 50mL tube to be mixed via homogenization:",
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Homogenize],
			ObjectP[Object[Protocol]]
		],
		Test[
			"Specify a 50mL tube to be mixed via homogenization aiming to maintain a temperature of 50C with a maximum temperature of 80C (where the instrument will turn off if the sample reaches this temperature and wait for it to cool down):",
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Homogenize,Temperature->50 Celsius,MaxTemperature->80 Celsius],
			ObjectP[Object[Protocol]]
		],
		(* -- Option Tests -- *)
		Example[
			{Options,Preparation,"Specify that the preparation should be manual:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Preparation->Manual],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Preparation,"Specify that the preparation should be robotic:"},
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Preparation->Robotic],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Thaw,"Specify that the samples should be thawed first before they are incubated:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Thaw->True,ThawTemperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Thaw,"Specify that the samples should be thawed first before they are mixed:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Thaw->True,ThawTemperature->40Celsius,Mix->True,MixType->Vortex],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,ThawTime,"Specify that the samples should be thawed for at least 10 minutes:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Thaw->True,ThawTime->10Minute,ThawTemperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxThawTime,"Specify that the samples should be thawed for at least 10 minutes. Then, if they are still not fully thawed after 10 minutes, thaw them for another 30 minutes:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Thaw->True,ThawTime->10Minute,MaxThawTime->30Minute],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,ThawTemperature,"Specify the temperature at which the samples should be thawed:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Thaw->True,ThawTime->10Minute,ThawTemperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,ThawInstrument,"Specify the model of incubator that should be used to thaw the samples:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Thaw->True,ThawInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Mix,"Specify that the samples should be mixed. ExperimentMix will figure out the optimal mixing instrument to use to mix the sample(s):"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixType,"Specify that the samples should be mixed by vortex. To see all of the valid mix types, evaluate MixTypeP:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Vortex],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixUntilDissolved,"Specify that the samples should be mix until they are fully dissolved. Mix the samples by vortex for 30 minutes and if they are not fully dissolved mix them again up to a maximum time of 3 hours:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Vortex,MixUntilDissolved->True,Time->30Minute,MaxTime->3Hour],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Time,"Specify that the samples should be mix until they are fully dissolved. Mix the samples by vortex for 30 minutes and if they are not fully dissolved mix them again up to a maximum time of 3 hours:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Vortex,MixUntilDissolved->True,Time->30Minute,MaxTime->3Hour],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxTime,"Specify that the samples should be mix until they are fully dissolved. Mix the samples by vortex for 30 minutes and if they are not fully dissolved mix them again up to a maximum time of 3 hours:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Vortex,MixUntilDissolved->True,Time->30Minute,MaxTime->3Hour],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixRate,"Specify that the samples should be rolled at a rate of 35 RPM:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Roll,MixRate->35RPM],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,NumberOfMixes,"Specify that the samples should be mixed via inversion for 20 times:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Invert,NumberOfMixes->20],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxNumberOfMixes,"Specify that the samples should be mixed via inversion for 20 times, then if they are not fully dissolved, mix them again up to 25 more times:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Invert,NumberOfMixes->20,MixUntilDissolved->True,MaxNumberOfMixes->25],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Temperature,"Specify that the samples should be both mixed and incubated at 40 Celsius:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,Temperature->40Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MixVolume,"Specify that the samples should be both mixed via pipette with said pipette set to 10 mL:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Mix->True,MixType->Pipette,MixVolume->10Milliliter],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Instrument,"Specify that the samples should be mixed using a specific vortex model:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"]],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,MaxTemperature,"Specify a 50mL tube to be mixed via homogenization aiming to maintain a temperature of 50C with a maximum temperature of 80C (where the instrument will turn off if the sample reaches this temperature and wait for it to cool down):"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Homogenize,Temperature->50 Celsius,MaxTemperature->80 Celsius],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,Amplitude,"Specify an amplitude of 50 Percent when mixing the given sample by Homogenization:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Homogenize,Amplitude->50 Percent],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,DutyCycle,"Specify a duty cycle of 10 Milliseconds On, 20 Milliseconds Off when mixing the given sample by Homogenization:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Homogenize,DutyCycle->{10 Millisecond, 20 Millisecond}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Options,SampleLabel,"Specify a SampleLabel:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],SampleLabel->"My Test Sample Label",Output->Options],SampleLabel],
			"My Test Sample Label"
		],
		Example[
			{Options,SampleContainerLabel,"Specify a SampleContainerLabel:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],SampleContainerLabel->"My Test Sample Container Label",Output->Options],SampleContainerLabel],
			"My Test Sample Container Label"
		],
		Example[
			{Options,OscillationAngle,"Specify a OscillationAngle:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],OscillationAngle->5*AngularDegree,Output->Options],OscillationAngle],
			5 AngularDegree
		],
		Example[
			{Options,AnnealingTime,"Specify a AnnealingTime:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],AnnealingTime->5 Minute,Output->Options],AnnealingTime],
			5 Minute
		],
		Example[
			{Options,MixFlowRate,"Specify a MixFlowRate:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixFlowRate->5 Microliter/Second,Output->Options],MixFlowRate],
			5 Microliter/Second
		],
		Example[
			{Options,MixPosition,"Specify a MixPosition:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixPosition->Top,Output->Options],MixPosition],
			Top
		],
		Example[
			{Options,MixPositionOffset,"Specify a MixPositionOffset:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixPositionOffset->1 Millimeter,Output->Options],MixPositionOffset],
			1 Millimeter
		],
		Example[
			{Options,MixPositionOffset,"Specify a MixPositionOffset in 3 coordinates:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixPositionOffset->Coordinate[{1 Millimeter, 2 Millimeter, 3 Millimeter}],Output->Options],MixPositionOffset],
			Coordinate[{1 Millimeter, 2 Millimeter, 3 Millimeter}]
		],
		Example[
			{Options,CorrectionCurve,"Specify a CorrectionCurve:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],CorrectionCurve->{{0 Microliter, 0 Microliter}, {1 Microliter,2 Microliter}, {1000 Microliter, 1030 Microliter}},Preparation->Robotic,Output->Options],CorrectionCurve],
			{{0 Microliter, 0 Microliter}, {1 Microliter,2 Microliter}, {1000 Microliter, 1030 Microliter}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Tips,"Specify the Tips:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Tips->Model[Item, Tips, "id:J8AY5jDvl5lE"],Output->Options],Tips],
			ObjectP[Model[Item, Tips, "id:J8AY5jDvl5lE"]]
		],
		Example[
			{Options,TipType,"Specify the TipType:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],TipType->Normal,Output->Options],TipType],
			Normal
		],
		Example[
			{Options,TipMaterial,"Specify the TipMaterial:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],TipMaterial->Polypropylene,Output->Options],TipMaterial],
			Polypropylene
		],
		Example[
			{Options,MultichannelMix,"Specify whether multiple device channels should be used to mix the sample:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MultichannelMix->True,Output->Options],MultichannelMix],
			True
		],
		Example[
			{Options,DeviceChannel,"Specify the channel of the work cell that should be used to perform the pipetting mixing:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],DeviceChannel->SingleProbe1,Output->Options],DeviceChannel],
			SingleProbe1
		],
		Example[
			{Options,ResidualIncubation,"Specify the residual incubation:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],ResidualIncubation->True,Output->Options],ResidualIncubation],
			True
		],
		Example[
			{Options,ResidualTemperature,"Specify the residual temperature:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],ResidualTemperature->36 Celsius,Output->Options],ResidualTemperature],
			36 Celsius
		],
		Example[
			{Options,ResidualMix,"Specify the residual mix:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixType->Shake,ResidualMix->True,Output->Options],ResidualMix],
			True
		],
		Example[
			{Options,ResidualMixRate,"Specify the residual mix rate:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],MixType->Shake,ResidualMixRate->50 RPM,Output->Options],ResidualMixRate],
			50 RPM
		],
		Example[
			{Options,Preheat,"Specify the Preheat:"},
			Lookup[ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Preheat->True,Output->Options],Preheat],
			True
		],
		Example[
			{Messages,"ConflictingUnitOperationMethodRequirements","If the Preparation is set and conflicts with an option given, an error will be thrown:"},
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Preparation->Robotic,MixUntilDissolved->True],
			$Failed,
			Messages:>{
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Test[
			"If the Preparation is set to Manual and conflicts with an option given, an error will be thrown:",
			ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Preparation->Manual,ResidualMix->True],
			_,
			Messages:>{
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		(*-- INVALID INPUT TESTS --*)
		Example[
			{Messages,"DiscardedSamples","If the given samples are discarded, they cannot be mixed:"},
			ExperimentMix[Object[Sample,"Test discarded sample for ExperimentMix"]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		(*-- OPTION PRECISION TESTS --*)
		Example[
			{Messages,"InstrumentPrecision","If a Temperature with a greater precision that 1. Celsius is given, it is rounded:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Temperature->50.5Celsius],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a Time with a greater precision that 1. Second is given, it is rounded:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Time->1.342 Minute],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a MaxTime with a greater precision that 1. Second is given, it is rounded:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MaxTime->1.342 Minute],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a MixVolume with a greater precision that 1. Microliter is given, it is rounded:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixVolume->45.333333333333 Milliliter],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a MixRate with a greater precision that 1. RPM is given, it is rounded:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixRate->200.5RPM],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		(*-- CONFLICTING OPTION TESTS --*)
		Example[
			{Messages,"MixInstrumentTypeMismatch","If the Instrument and MixType options do not agree, an error is thrown:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixType->Pipette],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixTypeIncorrectOptions","If the resolved mix type does not agree with the other otpions set, an error will be thrown:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],MixType->Pipette],
			$Failed,
			Messages:>{
				Error::MixInstrumentTypeMismatch,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixTypeRateMismatch","If the MixType and MixRate options do not agree, an error is thrown:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Invert,MixRate->100RPM],
			$Failed,
			Messages:>{
				Error::MixTypeRateMismatch,
				Error::MixTypeIncorrectOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"MixTypeNumberOfMixesMismatch","If the MixType and NumberOfMixes/MaxNumberOfMixes options do not agree, an error is thrown:"},
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MixType->Vortex,NumberOfMixes->3],
			$Failed,
			Messages:>{
				Error::MixTypeNumberOfMixesMismatch,
				Error::MixTypeIncorrectOptions,
				Error::InvalidOption
			}
		],

		(* CorrectionCurve Error Checking *)
		Example[
			{Messages,"CorrectionCurveNotMonotonic","A warning is thrown if the specified CorrectionCurve does not have monotonically increasing actual volume values:"},
			Lookup[
				ExperimentMix[
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
					CorrectionCurve -> {
						{0 Microliter, 0 Microliter},
						{60 Microliter, 55 Microliter},
						{50 Microliter, 60 Microliter},
						{150 Microliter, 180 Microliter},
						{300 Microliter, 345 Microliter},
						{500 Microliter, 560 Microliter},
						{1000 Microliter, 1050 Microliter}
					},
					Preparation->Robotic,
					Output->Options
				],
				CorrectionCurve
			],
			{
				{0 Microliter, 0 Microliter},
				{60 Microliter, 55 Microliter},
				{50 Microliter, 60 Microliter},
				{150 Microliter, 180 Microliter},
				{300 Microliter, 345 Microliter},
				{500 Microliter, 560 Microliter},
				{1000 Microliter, 1050 Microliter}
			},
			Messages:>{
				Warning::CorrectionCurveNotMonotonic
			},
			EquivalenceFunction->Equal
		],
		Example[
			{Messages,"CorrectionCurveIncomplete","A warning is thrown if the specified CorrectionCurve does not covers the transfer volume range of 0 uL - 1000 uL:"},
			Lookup[
				ExperimentMix[
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
					CorrectionCurve -> {
						{0 Microliter, 0 Microliter},
						{50 Microliter, 60 Microliter},
						{150 Microliter, 180 Microliter},
						{300 Microliter, 345 Microliter},
						{500 Microliter, 560 Microliter}
					},
					Preparation->Robotic,
					Output->Options
				],
				CorrectionCurve
			],
			{
				{0 Microliter, 0 Microliter},
				{50 Microliter, 60 Microliter},
				{150 Microliter, 180 Microliter},
				{300 Microliter, 345 Microliter},
				{500 Microliter, 560 Microliter}
			},
			Messages:>{
				Warning::CorrectionCurveIncomplete
			},
			EquivalenceFunction->Equal
		],
		Example[
			{Messages,"InvalidCorrectionCurveZeroValue","A CorrectionCurve with a 0 Microliter target volume entry must have a 0 Microliter actual volume value:"},
			ExperimentMix[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
				CorrectionCurve -> {
					{0 Microliter, 5 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				},
				Preparation->Robotic
			],
			$Failed,
			Messages :> {Error::InvalidCorrectionCurveZeroValue,Error::InvalidOption}
		],

		Test[
			"Specifying Output->Tests returns a list of tests:",
			ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Output->Tests],
			{_EmeraldTest..}
		],
		Example[
			{Options,PreparatoryUnitOperations,"Transfer 10mL of water into a 50mL tube and then incubate it at 80C for 2 hours:"},
			ExperimentMix[
				"My Container",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"My Container",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My Container"]
				},
				Time-> 2 Hour,
				Temperature->80 Celsius
			],
			ObjectP[Object[Protocol]]
		],

		(* Tests for the robotic branching *)
		Test[
			"Test that the appropriate options are Null-ed out if Preparation is Robotic:",
			options=ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Preparation->Robotic,Output->Options];
			Lookup[options,{
				Thaw,
				ThawTime,
				MaxThawTime,
				ThawTemperature,
				ThawInstrument,
				MixUntilDissolved,
				StirBar,
				MaxTime,
				DutyCycle,
				MixRateProfile,
				MaxNumberOfMixes,
				TemperatureProfile,
				MaxTemperature,
				OscillationAngle,
				Amplitude,
				AnnealingTime}],
			{Null..},
			Variables:>{options}
		],
		Test[
			"Test that the appropriate options are Null-ed out if Preparation is Manual:",
			options=ExperimentMix[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],Preparation->Manual,Output->Options];
			Lookup[options,
				{MixFlowRate,MixPosition,MixPositionOffset,CorrectionCurve,Tips,TipType,
					TipMaterial,MultichannelMix,DeviceChannel,
					ResidualTemperature,ResidualMix,ResidualMixRate,Preheat}],
			{Null..},
			Variables:>{options}
		],

		(* Other additional unit tests *)
		(*post processing options*)
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],TargetConcentration->8*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			8*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],TargetConcentration->9*Micromolar,TargetConcentrationAnalyte->Model[Molecule,"Sodium n-Dodecyl Sulfate"],Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Sodium n-Dodecyl Sulfate"]],
			Variables:>{options}
		],
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeTemperature->30*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeAliquot->10*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquot],
			10 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeAliquot->10*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FiltrationType->Syringe,FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filter->Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterMaterial->PES,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],

		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterPoreSize->0.22*Micrometer,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],

		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],PrefilterPoreSize->1.*Micrometer,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane. This will resolve to Null for volumes we would use in this experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterHousing->Null,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTemperature->22*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterSterile->False,Output->Options];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->10*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		(*Aliquot options*)
		Example[{Options,Aliquot,"Perform a incubate experiment on a single liquid sample by first aliquotting the sample:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],AliquotAmount->10*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,AliquotAmount],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],AssayVolume->10*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->2,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->10*Microliter,AssayVolume->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,AliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],SamplesInStorageCondition->Refrigerator,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Name->"My Exploratory Incubate Test Protocol",Output->Options];
			Lookup[options,Name],
			"My Exploratory Incubate Test Protocol"
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],Template->Object[Protocol,Incubate,"Parent Protocol for ExperimentMix testing"],Output->Options];
			Lookup[options,MixType],
			Nutate
		],
		Example[{Options, Output, "Simulation is returned when Output-> Simulation is specified:"},
			simulation = ExperimentMix[Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],
				Output -> Simulation];
			simulation,
			SimulationP,
			Variables:>{simulation}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentMix[
				Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentMix[
				Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentMix"],
			Object[Container,Vessel,"Test container 2 for ExperimentMix"],
			Object[Container,Vessel,"Test container 3 for ExperimentMix"],
			Object[Container,Vessel,"Test container 4 for ExperimentMix"],
			Object[Container,Vessel,"Test container 5 for ExperimentMix"],
			Object[Container,Plate,"Test container 6 for ExperimentMix"],
			Object[Container,Vessel,"Test container 7 for ExperimentMix"],
			Object[Container,Vessel,"Test container 8 for ExperimentMix"],
			Object[Container,Vessel,"Test container 9 for ExperimentMix"],
			Object[Container,Vessel,"Test container 10 for ExperimentMix"],
			Object[Container,Plate,"Test container 11 for ExperimentMix"],
			Object[Sample,"Test discarded sample for ExperimentMix"],
			Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],
			Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMix"],
			Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],
			Object[Sample,"Test water sample in Open Test Tube for ExperimentMix"],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMix"],
			Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentMix"],
			Object[Sample,"Test water sample in 15mL tube for ExperimentMix"],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMix"],
			Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMix"],
			Object[Sample,"Test water sample in 2mL tube for ExperimentMix"],
			Object[Sample,"Test water sample in PCR Plate for ExperimentMix"],
			Object[Protocol,Incubate,"Parent Protocol for ExperimentMix testing"]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentMix"],
					Object[Container,Vessel,"Test container 2 for ExperimentMix"],
					Object[Container,Vessel,"Test container 3 for ExperimentMix"],
					Object[Container,Vessel,"Test container 4 for ExperimentMix"],
					Object[Container,Vessel,"Test container 5 for ExperimentMix"],
					Object[Container,Plate,"Test container 6 for ExperimentMix"],
					Object[Container,Vessel,"Test container 7 for ExperimentMix"],
					Object[Container,Vessel,"Test container 8 for ExperimentMix"],
					Object[Container,Vessel,"Test container 9 for ExperimentMix"],
					Object[Container,Vessel,"Test container 10 for ExperimentMix"],
					Object[Container,Plate,"Test container 11 for ExperimentMix"],
					Object[Sample,"Test discarded sample for ExperimentMix"],
					Object[Sample,"Test water sample in 50mL tube for ExperimentMix"],
					Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMix"],
					Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMix"],
					Object[Sample,"Test water sample in Open Test Tube for ExperimentMix"],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMix"],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMix"],
					Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentMix"],
					Object[Sample,"Test water sample in 15mL tube for ExperimentMix"],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMix"],
					Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMix"],
					Object[Sample,"Test water sample in 2mL tube for ExperimentMix"],
					Object[Sample,"Test water sample in PCR Plate for ExperimentMix"],
					Object[Protocol,Incubate,"Parent Protocol for ExperimentMix testing"]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ExperimentMix",
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];

		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ExperimentMix testing",
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ExperimentMix",
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample10,waterSample11}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMix"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}
			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter,1 Milliliter,.5 Milliliter},
			Name->{
				"Test discarded sample for ExperimentMix",
				"Test water sample in 50mL tube for ExperimentMix",
				"Test water sample in 1L Glass Bottle for ExperimentMix",
				"Test water sample in 2L Glass Bottle for ExperimentMix",
				"Test water sample in Open Test Tube for ExperimentMix",
				"Test water sample 1 in 96 deep-well plate for ExperimentMix",
				"Test water sample 2 in 96 deep-well plate for ExperimentMix",
				"Test water sample in 5L Glass Bottle for ExperimentMix",
				"Test water sample in 15mL tube for ExperimentMix",
				"Test TransportWarmed at 70C sample for ExperimentMix",
				"Test water sample in 2mL tube for ExperimentMix",
				"Test water sample in PCR Plate for ExperimentMix"
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample11,DeveloperObject->True,Status->Available|>
		}];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection:: *)
(*MixDevices*)


DefineTests[
	MixDevices,
	{
		Example[
			{Basic,"Returns the list of instruments that can be used to mix the given sample in a 50mL tube:"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"]],
			{ObjectP[Model[Instrument]]...}
		],
		Example[
			{Basic,"Return a list of instruments that can be used to mix at a specified GravitationalAcceleration:"},
			MixDevices[Model[Container, Vessel, "2mL Tube"], 1 Milliliter, Types -> Shake, Rate -> 50 GravitationalAcceleration],
			{ObjectP[Model[Instrument]]...}
		],
		Example[
			{Basic,"Returns the list of instruments that can be used to mix the given sample in a 96 deep-well plate:"},
			MixDevices[Object[Sample,"Test sample in deep-well plate for MixDevices"]],
			_?(Length@Complement[
				{
					Model[Instrument, Vortex, "id:dORYzZn0o45q"],
					Model[Instrument, Vortex, "id:o1k9jAGq7pNA"],
					Model[Instrument, Vortex, "id:E8zoYvNMxBq5"],
					Model[Instrument, Shaker, "id:N80DNj15vreD"],
					Model[Instrument, Nutator, "id:1ZA60vLBzwGq"],
					Model[Instrument, Sonicator, "id:6V0npvmZlEk6"]
				},
				#
			]==0&)
		],
		Example[
			{Basic,"Returns the list of instruments that can be used to mix the given sample, filtering out instruments that cannot match the required specifications (MixRate->500RPM):"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Rate->500RPM],
			_?(Length@Complement[
				{
					Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"],
					Model[Instrument, OverheadStirrer, "id:qdkmxzqNkVB1"],
					Model[Instrument, Shaker, "id:N80DNj15vreD"]
				},
				#
			]==0&)
		],
		Example[
			{Options,MixRate,"Returns the list of instruments that can be used to mix the given sample, filtering out instruments that cannot match the required specifications (MixRate->1000RPM):"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Rate->1000RPM],
			_?(Length@Complement[
				{
					Model[Instrument, Vortex, "id:8qZ1VWNmdKjP"],
					Model[Instrument, Vortex, "id:E8zoYvNMxo8m"],
					Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"],
					Model[Instrument, OverheadStirrer, "id:qdkmxzqNkVB1"],
					Model[Instrument, Shaker, "id:N80DNj15vreD"]
				},
				#
			]==0&)

		],
		Example[
			{Options,MixRate,"Returns the list of instruments that can be used to mix the given sample, filtering out instruments that cannot match the required specifications (MixRate->2000RPM):"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Rate->2000RPM],
			_?(Length@Complement[
				{Model[Instrument,Vortex,"id:8qZ1VWNmdKjP"], Model[Instrument, Vortex, "id:E8zoYvNMxo8m"]},
				#
			]==0&)
		],
		Example[
			{Options,Output,"Returns the containers that the sample can be transfered into to be mixed on certain instruments:"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Output->Containers],
			{Rule[ObjectP[Model[Instrument]],_List]..}
		],
		Example[
			{Options,Temperature,"Returns the list of instruments that can be used to mix the given sample, filtering out instruments that cannot match the required specifications (Temperature->50Celsius):"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"][Object],Temperature->50Celsius],
			_?(Length@Complement[
				{
					Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"],
					Model[Instrument, OverheadStirrer, "id:qdkmxzqNkVB1"],
					Model[Instrument, Shaker, "id:mnk9jORRwA7Z"],
					Model[Instrument, Shaker, "id:N80DNj15vreD"],
					Model[Instrument, Roller, "id:Vrbp1jKKZw6z"],
					Model[Instrument, Sonicator, "id:XnlV5jKNn3DM"],
					Model[Instrument, Sonicator, "id:L8kPEjnJOm54"],
					Model[Instrument, Homogenizer, "id:rea9jlRZqM7b"]
				},
				#
			]==0&)
		],
		Example[
			{Options,Types,"Returns the list of instruments that can be used to mix the given sample, filtering out instruments that cannot match the required specifications (Types->Sonicate):"},
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Types->Sonicate],
			{ObjectP[Model[Instrument, Sonicator]]..}
		],
		Example[
			{Options,InstrumentSearch,"Returns the list of instruments that can be used to mix the given sample, filtering out instruments that cannot match the required specifications when passed instrument search results (InstrumentSearch->search):"},
			MixDevices[Object[Sample,"Test sample in deep-well plate for MixDevices"],InstrumentSearch->search],
			_?(Length@Complement[
				{
					Model[Instrument, Vortex, "id:dORYzZn0o45q"],
					Model[Instrument, Vortex, "id:o1k9jAGq7pNA"],
					Model[Instrument, Vortex, "id:E8zoYvNMxBq5"],
					Model[Instrument, Shaker, "id:N80DNj15vreD"],
					Model[Instrument, Nutator, "id:1ZA60vLBzwGq"],
					Model[Instrument, Sonicator, "id:6V0npvmZlEk6"]
				},
				#
			]==0&),
			SetUp:>{
				search=Search[
				{
					Model[Instrument,Vortex],
					Model[Instrument,Shaker],
					Model[Instrument,BottleRoller],
					Model[Instrument,Roller],
					Model[Instrument,OverheadStirrer],
					Model[Instrument,Sonicator],
					Model[Instrument,Homogenizer],
					Model[Instrument, Disruptor],
					Model[Instrument, Nutator]
				},
				Deprecated==(False|Null) && DeveloperObject != True
			]},
			Variables:>{search}
		],
		Test[
			"Scintillation Vials can be shaken:",
			MixDevices[Object[Sample,"Test sample in Scintillation Vial for MixDevices"],Types->Shake],
			_?(Length@Complement[
				{
					Model[Instrument, Shaker, "id:Vrbp1jG80JAw"],
					Model[Instrument, Shaker, "id:mnk9jORRwA7Z"],
					Model[Instrument, Shaker, "id:6V0npvmNnOrw"],
					Model[Instrument, Shaker, "id:N80DNj15vreD"]
				},
				#
			]==0&)
		],
		Test[
			"50mL tubes can be sonicated:",
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Types->Sonicate],
			{ObjectP[Model[Instrument, Sonicator]]..}
		],
		Test[
			"50mL tubes can be vortexed:",
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Types->Vortex],
			_?(Length@Complement[
				{Model[Instrument, Vortex, "id:8qZ1VWNmdKjP"], Model[Instrument, Vortex, "id:E8zoYvNMxo8m"]},
				#
			]==0&)
		],
		Test[
			"50mL tubes can be rolled:",
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Types->Roll],
			_?(Length@Complement[
				{Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]},
				#
			]==0&)
		],
		Test[
			"50mL tubes can be stirred:",
			MixDevices[Object[Sample,"Test sample in 50mL tube for MixDevices"],Types->Stir],
			_?(Length@Complement[
				{Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"], Model[Instrument, OverheadStirrer, "id:qdkmxzqNkVB1"]},
				#
			]==0&)

		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Plate,"Test container 1 for MixDevices"],
			Object[Container,Vessel,"Test container 2 for MixDevices"],
			Object[Container,Vessel,"Test container 3 for MixDevices"],
			Object[Sample,"Test sample in deep-well plate for MixDevices"],
			Object[Sample,"Test sample in 50mL tube for MixDevices"],
			Object[Sample,"Test sample in Scintillation Vial for MixDevices"]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Plate,"Test container 1 for MixDevices"],
					Object[Container,Vessel,"Test container 2 for MixDevices"],
					Object[Container,Vessel,"Test container 3 for MixDevices"],
					Object[Sample,"Test sample in deep-well plate for MixDevices"],
					Object[Sample,"Test sample in 50mL tube for MixDevices"],
					Object[Sample,"Test sample in Scintillation Vial for MixDevices"]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3}=Upload[{
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 1 for MixDevices",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for MixDevices",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"20mL Glass Scintillation Vial"],Objects],
				Name->"Test container 3 for MixDevices",
				DeveloperObject->True
			|>
		}];

		(* Create some water samples *)
		{waterSample1,waterSample2,waterSample3}=ECL`InternalUpload`UploadSample[
			{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
			{{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3}},
			InitialAmount->{1 Milliliter,25 Milliliter,1 Milliliter},
			Name->{"Test sample in deep-well plate for MixDevices","Test sample in 50mL tube for MixDevices","Test sample in Scintillation Vial for MixDevices"}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample1,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>,
			<|Object->waterSample3,DeveloperObject->True|>
		}];
	),
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(*groupSamples*)

DefineTests[
	groupSamples,
	{
		Test[
			"Stress test with the roller, with duplicates:",
			groupSamples[
				{
					fiftySample1,
					fiftySample2,
					fiftySample3,
					fiftySample4,
					fiftySample5,
					fiftySample6,
					fiftySample7,
					fiftySample7,
					fifteenSample1,
					fifteenSample2,
					fifteenSample3,
					twoSample1
				},
				ConstantArray[Model[Instrument,Roller,"id:Vrbp1jKKZw6z"],12],
				ConstantArray[{MixRate->200RPM},12],
				Cache->Download[Flatten[{
					Function[obj,{obj,obj[Container],obj[Container][Model]}]/@
						{
							fiftySample1,
							fiftySample2,
							fiftySample3,
							fiftySample4,
							fiftySample5,
							fiftySample6,
							fiftySample7,
							fifteenSample1,
							fifteenSample2,
							fifteenSample3,
							twoSample1
						},
					{
						Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]
					}
				}]]
			],
			{{{ObjectP[Object[Sample]]...},{ObjectP[Object[Sample]]},{ObjectP[Object[Sample]]}},{ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]]},{{{_String,ObjectP[Model[Instrument]]}..},{{_String,ObjectP[Model[Instrument]]}..},{{_String,ObjectP[Model[Instrument]]}..}},{{MixRate->Quantity[200,("Revolutions")/("Minutes")]},{MixRate->Quantity[200,("Revolutions")/("Minutes")]},{MixRate->Quantity[200,("Revolutions")/("Minutes")]}}}
		],
		Test[
			"Stress test with the roller:",
			groupSamples[
				{
					fiftySample1,
					fiftySample2,
					fiftySample3,
					fiftySample4,
					fiftySample5,
					fiftySample6,
					fiftySample7,
					fifteenSample1,
					fifteenSample2,
					fifteenSample3,
					twoSample1
				},
				ConstantArray[Model[Instrument,Roller,"id:Vrbp1jKKZw6z"],11],
				ConstantArray[{MixRate->200RPM},11],
				Cache->Download[Flatten[{
					Function[obj,{obj,obj[Container],obj[Container][Model]}]/@
						{
							fiftySample1,
							fiftySample2,
							fiftySample3,
							fiftySample4,
							fiftySample5,
							fiftySample6,
							fiftySample7,
							fifteenSample1,
							fifteenSample2,
							fifteenSample3,
							twoSample1
						},
					{
						Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]
					}
				}]]
			],
			{{{ObjectP[Object[Sample]]...},{ObjectP[Object[Sample]]}},{ObjectP[Model[Instrument]],ObjectP[Model[Instrument]]},{{{_String,ObjectP[Model[Instrument]]}..},{{_String,ObjectP[Model[Instrument]]}}},{{MixRate->Quantity[200,("Revolutions")/("Minutes")]},{MixRate->Quantity[200,("Revolutions")/("Minutes")]}}}
		],
		Test[
			"Basic example with two instrument models with different rates:",
			groupSamples[
				{
					fiftySample1,
					fiftySample2,
					fiftySample3,
					fiftySample4,
					fiftySample5,
					fiftySample6,
					fifteenSample1,
					fifteenSample2
				},
				Flatten[{
					ConstantArray[Model[Instrument,Shaker,"id:L8kPEjNLDlBl"],7],
					Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]
				}],
				Flatten[{
					ConstantArray[{MixRate->200RPM},2],
					ConstantArray[{MixRate->100RPM},2],
					ConstantArray[{MixRate->300RPM},2],
					ConstantArray[{MixRate->200RPM},2]
				},1],
				Cache->Download[Flatten[{
					Function[obj,{obj,obj[Container],obj[Container][Model]}]/@
						{
							fiftySample1,
							fiftySample2,
							fiftySample3,
							fiftySample4,
							fiftySample5,
							fiftySample6,
							fifteenSample1,
							fifteenSample2
						},
					{
						Model[Instrument,Shaker,"id:L8kPEjNLDlBl"],
						Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]
					}
				}]]
			],
			(* List with three sample groupings. *)
			{{{ObjectP[Object[Sample]]...}...},{ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]]},{{{_String,ObjectP[Model[Instrument]]}...}...},{(_List)..}}
		],
		Test[
			"Basic example with two instrument models:",
			groupSamples[
				{
					fiftySample1,
					fiftySample2,
					fiftySample3,
					fiftySample4,
					fiftySample5,
					fiftySample6,
					fifteenSample1,
					fifteenSample2
				},
				Flatten[{
					ConstantArray[Model[Instrument,Shaker,"id:L8kPEjNLDlBl"],7],
					Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]
				}],
				ConstantArray[{MixRate->200RPM},8],
				Cache->Download[Flatten[{
					Function[obj,{obj,obj[Container],obj[Container][Model]}]/@
						{
							fiftySample1,
							fiftySample2,
							fiftySample3,
							fiftySample4,
							fiftySample5,
							fiftySample6,
							fifteenSample1,
							fifteenSample2
						},
					{
						Model[Instrument,Shaker,"id:L8kPEjNLDlBl"],
						Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]
					}
				}]]
			],
			{{{ObjectP[Object[Sample]]...}...},{ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]],ObjectP[Model[Instrument]]},{{{_String,ObjectP[Model[Instrument]]}...}...},{(_List)..}}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Plate,"Test container 1 for groupSamples"],
			Object[Container,Plate,"Test container 2 for groupSamples"],
			Object[Container,Vessel,"Test container 3 for groupSamples"],
			Object[Container,Vessel,"Test container 4 for groupSamples"],
			Object[Container,Vessel,"Test container 5 for groupSamples"],
			Object[Container,Vessel,"Test container 6 for groupSamples"],
			Object[Container,Vessel,"Test container 7 for groupSamples"],
			Object[Container,Vessel,"Test container 8 for groupSamples"],
			Object[Container,Vessel,"Test container 9 for groupSamples"],
			Object[Container,Vessel,"Test container 10 for groupSamples"],
			Object[Container,Vessel,"Test container 11 for groupSamples"],
			Object[Container,Vessel,"Test container 12 for groupSamples"],
			Object[Container,Vessel,"Test container 13 for groupSamples"],
			Object[Sample,"Test sample 1 in deep-well plate for groupSamples"],
			Object[Sample,"Test sample 2 in deep-well plate for groupSamples"],
			Object[Sample,"Test sample 1 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 2 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 3 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 4 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 5 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 6 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 7 in 50mL tube for groupSamples"],
			Object[Sample,"Test sample 1 in 15mL tube for groupSamples"],
			Object[Sample,"Test sample 2 in 15mL tube for groupSamples"],
			Object[Sample,"Test sample 3 in 15mL tube for groupSamples"],
			Object[Sample,"Test sample 1 in 2mL tube for groupSamples"]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Plate,"Test container 1 for groupSamples"],
					Object[Container,Plate,"Test container 2 for groupSamples"],
					Object[Container,Vessel,"Test container 3 for groupSamples"],
					Object[Container,Vessel,"Test container 4 for groupSamples"],
					Object[Container,Vessel,"Test container 5 for groupSamples"],
					Object[Container,Vessel,"Test container 6 for groupSamples"],
					Object[Container,Vessel,"Test container 7 for groupSamples"],
					Object[Container,Vessel,"Test container 8 for groupSamples"],
					Object[Container,Vessel,"Test container 9 for groupSamples"],
					Object[Container,Vessel,"Test container 10 for groupSamples"],
					Object[Container,Vessel,"Test container 11 for groupSamples"],
					Object[Container,Vessel,"Test container 12 for groupSamples"],
					Object[Container,Vessel,"Test container 13 for groupSamples"],
					Object[Sample,"Test sample 1 in deep-well plate for groupSamples"],
					Object[Sample,"Test sample 2 in deep-well plate for groupSamples"],
					Object[Sample,"Test sample 1 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 2 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 3 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 4 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 5 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 6 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 7 in 50mL tube for groupSamples"],
					Object[Sample,"Test sample 1 in 15mL tube for groupSamples"],
					Object[Sample,"Test sample 2 in 15mL tube for groupSamples"],
					Object[Sample,"Test sample 3 in 15mL tube for groupSamples"],
					Object[Sample,"Test sample 1 in 2mL tube for groupSamples"]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];

		(* Create some empty containers *)
		{
			emptyContainer1,
			emptyContainer2,
			emptyContainer3,
			emptyContainer4,
			emptyContainer5,
			emptyContainer6,
			emptyContainer7,
			emptyContainer8,
			emptyContainer9,
			emptyContainer10,
			emptyContainer11,
			emptyContainer12,
			emptyContainer13
		}=Upload[{
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 1 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 2 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 3 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 4 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 5 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 6 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 7 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 8 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 9 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"15mL Tube"],Objects],
				Name->"Test container 10 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"15mL Tube"],Objects],
				Name->"Test container 11 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"15mL Tube"],Objects],
				Name->"Test container 12 for groupSamples",
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
				Name->"Test container 13 for groupSamples",
				DeveloperObject->True
			|>
		}];

		(* Create some water samples *)
		{
			plateSample1,
			plateSample2,
			fiftySample1,
			fiftySample2,
			fiftySample3,
			fiftySample4,
			fiftySample5,
			fiftySample6,
			fiftySample7,
			fifteenSample1,
			fifteenSample2,
			fifteenSample3,
			twoSample1
		}=ECL`InternalUpload`UploadSample[
			(* All water samples. *)
			ConstantArray[Model[Sample,"Milli-Q water"],13],
			(* Place them in the containers. *)
			{"A1",#}&/@{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyContainer6,
				emptyContainer7,
				emptyContainer8,
				emptyContainer9,
				emptyContainer10,
				emptyContainer11,
				emptyContainer12,
				emptyContainer13
			},
			(* 1 mL in every container (doesn't matter) *)
			InitialAmount->ConstantArray[1 Milliliter,13],
			(* Names *)
			Name->{"Test sample 1 in deep-well plate for groupSamples","Test sample 2 in deep-well plate for groupSamples","Test sample 1 in 50mL tube for groupSamples","Test sample 2 in 50mL tube for groupSamples","Test sample 3 in 50mL tube for groupSamples","Test sample 4 in 50mL tube for groupSamples","Test sample 5 in 50mL tube for groupSamples","Test sample 6 in 50mL tube for groupSamples","Test sample 7 in 50mL tube for groupSamples","Test sample 1 in 15mL tube for groupSamples","Test sample 2 in 15mL tube for groupSamples","Test sample 3 in 15mL tube for groupSamples","Test sample 1 in 2mL tube for groupSamples"}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[<|Object->#,DeveloperObject->True|>&/@{
			plateSample1,
			plateSample2,
			fiftySample1,
			fiftySample2,
			fiftySample3,
			fiftySample4,
			fiftySample5,
			fiftySample6,
			fiftySample7,
			fifteenSample1,
			fifteenSample2,
			fifteenSample3,
			twoSample1
		}];
	),
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[ValidExperimentMixQ,
	{
		Example[
			{Basic,"Return a boolean indicating whether the call is valid:"},
			ValidExperimentMixQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
				Object[Container,Plate,"Test container 6 for ValidExperimentMixQ" <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic,"If an input is invalid, returns False:"},
			ValidExperimentMixQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
				Object[Sample,"Test discarded sample for ValidExperimentMixQ" <> $SessionUUID]
			}],
			False
		],
		Example[
			{Basic,"If an option is invalid, returns False:"},
			ValidExperimentMixQ[
				Object[Sample,"Test water sample in PCR Plate for ValidExperimentMixQ" <> $SessionUUID],
				TemperatureProfile -> 1000 Celsius],
			False
		],
		Example[{Options, OutputFormat,"Return a test summary of the tests run to validate the call:"},
			ValidExperimentMixQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
				Object[Container,Plate,"Test container 6 for ValidExperimentMixQ" <> $SessionUUID]
			},
				Name->"Existing ValidExperimentMixQ protocol",
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose,"Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentMixQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
				Object[Container,Plate,"Test container 6 for ValidExperimentMixQ" <> $SessionUUID]
			},
				Name->"Existing ValidExperimentMixQ protocol",
				Verbose->True
			],
			BooleanP
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>Module[
		{existsFilter,emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11, discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10},

		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 3 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 4 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 5 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Plate,"Test container 6 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 7 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 8 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 9 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 10 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Container,Plate,"Test container 11 for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test discarded sample for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ValidExperimentMixQ" <> $SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ValidExperimentMixQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ValidExperimentMixQ" <> $SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ValidExperimentMixQ testing" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 3 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 5 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Plate,"Test container 6 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 7 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 8 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 9 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 10 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Container,Plate,"Test container 11 for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test discarded sample for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ValidExperimentMixQ" <> $SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ValidExperimentMixQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ValidExperimentMixQ" <> $SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ValidExperimentMixQ testing" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];

		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ValidExperimentMixQ testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ValidExperimentMixQ" <> $SessionUUID,
				DeveloperObject->True,
				Site -> Link[$Site]
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ValidExperimentMixQ" <> $SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ValidExperimentMixQ" <> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter},
			Name->{
				"Test discarded sample for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in 50mL tube for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in 1L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in 2L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in Open Test Tube for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in 5L Glass Bottle for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in 15mL tube for ValidExperimentMixQ" <> $SessionUUID,
				"Test TransportWarmed at 70C sample for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in 2mL tube for ValidExperimentMixQ" <> $SessionUUID,
				"Test water sample in PCR Plate for ValidExperimentMixQ" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>
		}];
	],
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[ValidExperimentIncubateQ,
	{
		Example[
			{Basic,"Return a boolean indicating whether the call is valid:"},
			ValidExperimentIncubateQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
				Object[Container,Plate,"Test container 6 for ValidExperimentIncubateQ" <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic,"If an input is invalid, returns False:"},
			ValidExperimentIncubateQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
				Object[Sample,"Test discarded sample for ValidExperimentIncubateQ" <> $SessionUUID]
			}],
			False
		],
		Example[
			{Basic,"If an option is invalid, returns False:"},
			ValidExperimentIncubateQ[
				Object[Sample,"Test water sample in PCR Plate for ValidExperimentIncubateQ" <> $SessionUUID],
				TemperatureProfile -> 1000 Celsius],
			False
		],
		Example[{Options, OutputFormat,"Return a test summary of the tests run to validate the call:"},
			ValidExperimentIncubateQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
				Object[Container,Plate,"Test container 6 for ValidExperimentIncubateQ" <> $SessionUUID]
			},
				Name->"Existing ValidExperimentIncubateQ protocol",
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose,"Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentIncubateQ[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
				Object[Container,Plate,"Test container 6 for ValidExperimentIncubateQ" <> $SessionUUID]
			},
				Name->"Existing ValidExperimentIncubateQ protocol",
				Verbose->True
			],
			BooleanP
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 3 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 4 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 5 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Plate,"Test container 6 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 7 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 8 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 9 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Vessel,"Test container 10 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Container,Plate,"Test container 11 for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test discarded sample for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ValidExperimentIncubateQ" <> $SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ValidExperimentIncubateQ" <> $SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ValidExperimentIncubateQ testing" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 3 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 5 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Plate,"Test container 6 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 7 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 8 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 9 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Vessel,"Test container 10 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Container,Plate,"Test container 11 for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test discarded sample for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ValidExperimentIncubateQ" <> $SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ValidExperimentIncubateQ" <> $SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ValidExperimentIncubateQ testing" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];


		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ValidExperimentIncubateQ testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ValidExperimentIncubateQ" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ValidExperimentIncubateQ" <> $SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ValidExperimentIncubateQ" <> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter},
			Name->{
				"Test discarded sample for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in 50mL tube for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in 1L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in 2L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in Open Test Tube for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in 5L Glass Bottle for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in 15mL tube for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test TransportWarmed at 70C sample for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in 2mL tube for ValidExperimentIncubateQ" <> $SessionUUID,
				"Test water sample in PCR Plate for ValidExperimentIncubateQ" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>
		}];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[ExperimentMixPreview,
	{
		Example[
			{Basic,"Returns Null:"},
			ExperimentMixPreview[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentMixPreview" <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic,"Even if an input is invalid, returns Null:"},
			ExperimentMixPreview[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
				Object[Sample,"Test discarded sample for ExperimentMixPreview" <> $SessionUUID]
			}],
			Null,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Basic,"No preview is currently available for ExperimentIncubate:"},
			ExperimentMixPreview[
				Object[Sample,"Test water sample in 50mL tube for ExperimentMixPreview" <> $SessionUUID],
				Temperature->45 Celsius
			],
			Null
		],
		Example[{Basic,"If you wish to understand how the experiment will be performed, try using ExperimentIncubateOptions:"},
			ExperimentIncubateOptions[
				Object[Sample,"Test water sample in 50mL tube for ExperimentMixPreview" <> $SessionUUID],
				Temperature->45 Celsius,
				Mix->True
			],
			_Grid,
			TimeConstraint->10000
		],
		Example[
			{Basic,"Even if an option is invalid, returns Null:"},
			ExperimentMixPreview[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentMixPreview" <> $SessionUUID]
			},
				Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],
				MixType->Pipette,
				Name->"Existing IncubatePreview protocol"
			],
			Null,
			Messages:>{Error::MixInstrumentTypeMismatch,Error::InvalidOption}
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 3 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 4 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 5 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Plate,"Test container 6 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 7 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 8 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 9 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 10 for ExperimentMixPreview" <> $SessionUUID],
			Object[Container,Plate,"Test container 11 for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test discarded sample for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ExperimentMixPreview" <> $SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMixPreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ExperimentMixPreview" <> $SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ExperimentMixPreview testing" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Plate,"Test container 6 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 7 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 8 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 9 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 10 for ExperimentMixPreview" <> $SessionUUID],
					Object[Container,Plate,"Test container 11 for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test discarded sample for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ExperimentMixPreview" <> $SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMixPreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ExperimentMixPreview" <> $SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ExperimentMixPreview testing" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];


		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ExperimentMixPreview testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ExperimentMixPreview" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ExperimentMixPreview" <> $SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMixPreview" <> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter},
			Name->{
				"Test discarded sample for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in 50mL tube for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in 1L Glass Bottle for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in 2L Glass Bottle for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in Open Test Tube for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in 5L Glass Bottle for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in 15mL tube for ExperimentMixPreview" <> $SessionUUID,
				"Test TransportWarmed at 70C sample for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in 2mL tube for ExperimentMixPreview" <> $SessionUUID,
				"Test water sample in PCR Plate for ExperimentMixPreview" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>
		}];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[ExperimentIncubatePreview,
	{
		Example[
			{Basic,"Returns Null:"},
			ExperimentIncubatePreview[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentIncubatePreview" <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic,"Even if an input is invalid, returns Null:"},
			ExperimentIncubatePreview[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
				Object[Sample,"Test discarded sample for ExperimentIncubatePreview" <> $SessionUUID]
			}],
			Null,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Basic,"No preview is currently available for ExperimentIncubate:"},
			ExperimentIncubatePreview[
				Object[Sample,"Test water sample in 50mL tube for ExperimentIncubatePreview" <> $SessionUUID],
				Temperature->45 Celsius
			],
			Null
		],
		Example[{Basic,"If you wish to understand how the experiment will be performed, try using ExperimentIncubateOptions:"},
			ExperimentIncubateOptions[
				Object[Sample,"Test water sample in 50mL tube for ExperimentIncubatePreview" <> $SessionUUID],
				Temperature->45 Celsius,
				Mix->True
			],
			_Grid,
			TimeConstraint->10000
		],
		Example[
			{Basic,"Even if an option is invalid, returns Null:"},
			ExperimentIncubatePreview[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentIncubatePreview" <> $SessionUUID]
			},
				Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],
				MixType->Pipette,
				Name->"Existing IncubatePreview protocol"
			],
			Null,
			Messages:>{Error::MixInstrumentTypeMismatch,Error::InvalidOption}
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 3 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 4 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 5 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Plate,"Test container 6 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 7 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 8 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 9 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Vessel,"Test container 10 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Container,Plate,"Test container 11 for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test discarded sample for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ExperimentIncubatePreview" <> $SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ExperimentIncubatePreview" <> $SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubatePreview testing" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Plate,"Test container 6 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 7 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 8 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 9 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 10 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Container,Plate,"Test container 11 for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test discarded sample for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ExperimentIncubatePreview" <> $SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ExperimentIncubatePreview" <> $SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubatePreview testing" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];


		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ExperimentIncubatePreview testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ExperimentIncubatePreview" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ExperimentIncubatePreview" <> $SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubatePreview" <> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter},
			Name->{
				"Test discarded sample for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in 50mL tube for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in 1L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in 2L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in Open Test Tube for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in 5L Glass Bottle for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in 15mL tube for ExperimentIncubatePreview" <> $SessionUUID,
				"Test TransportWarmed at 70C sample for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in 2mL tube for ExperimentIncubatePreview" <> $SessionUUID,
				"Test water sample in PCR Plate for ExperimentIncubatePreview" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>
		}];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[ExperimentMixOptions,
	{
		Example[
			{Basic,"Return the resolved options:"},
			ExperimentMixOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentMixOptions" <> $SessionUUID]
			}],
			Graphics_
		],
		Example[
			{Basic,"Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentMixOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentMixOptions" <> $SessionUUID]
			}],
			Graphics_
		],
		Example[
			{Basic,"Even if an option is invalid, returns as many of the options as could be resolved:"},
			ExperimentMixOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentMixOptions" <> $SessionUUID]
			},
				Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],
				MixType->Pipette,
				Name->"Existing ExperimentIncubateCellsOptions protocol"
			],
			Graphics_,
			Messages:>{Error::MixInstrumentTypeMismatch,Error::InvalidOption}
		],
		Example[
			{Options,OutputFormat,"Return the resolved options as a list:"},
			ExperimentMixOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentMixOptions" <> $SessionUUID]
			},OutputFormat->List],
			Rule___
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 3 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 4 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 5 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Plate,"Test container 6 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 7 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 8 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 9 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 10 for ExperimentMixOptions" <> $SessionUUID],
			Object[Container,Plate,"Test container 11 for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test discarded sample for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ExperimentMixOptions" <> $SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMixOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ExperimentMixOptions" <> $SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ExperimentMixOptions testing" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Plate,"Test container 6 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 7 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 8 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 9 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 10 for ExperimentMixOptions" <> $SessionUUID],
					Object[Container,Plate,"Test container 11 for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test discarded sample for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ExperimentMixOptions" <> $SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ExperimentMixOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ExperimentMixOptions" <> $SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ExperimentMixOptions testing" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];


		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ExperimentMixOptions testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ExperimentMixOptions" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ExperimentMixOptions" <> $SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentMixOptions" <> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter},
			Name->{
				"Test discarded sample for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in 50mL tube for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in 1L Glass Bottle for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in 2L Glass Bottle for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in Open Test Tube for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in 5L Glass Bottle for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in 15mL tube for ExperimentMixOptions" <> $SessionUUID,
				"Test TransportWarmed at 70C sample for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in 2mL tube for ExperimentMixOptions" <> $SessionUUID,
				"Test water sample in PCR Plate for ExperimentMixOptions" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>
		}];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

DefineTests[ExperimentIncubateOptions,
	{
		Example[
			{Basic,"Return the resolved options:"},
			ExperimentIncubateOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID]
			}],
			Graphics_
		],
		Example[
			{Basic,"Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentIncubateOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID]
			}],
			Graphics_
		],
		Example[
			{Basic,"Even if an option is invalid, returns as many of the options as could be resolved:"},
			ExperimentIncubateOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID]
			},
				Instrument->Model[Instrument,Vortex,"id:dORYzZn0o45q"],
				MixType->Pipette,
				Name->"Existing ExperimentIncubateCellsOptions protocol"
			],
			Graphics_,
			Messages:>{Error::MixInstrumentTypeMismatch,Error::InvalidOption}
		],
		Example[
			{Options,OutputFormat,"Return the resolved options as a list:"},
			ExperimentIncubateOptions[{
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
				Object[Container,Plate,"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID]
			},OutputFormat->List],
			Rule___
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 3 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 4 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 5 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Plate,"Test container 6 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 7 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 8 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 9 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Vessel,"Test container 10 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Container,Plate,"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test discarded sample for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 50mL tube for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 15mL tube for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in PCR Plate for ExperimentIncubateOptions" <> $SessionUUID],
			Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Sample,"Test water sample in 2mL tube for ExperimentIncubateOptions" <> $SessionUUID],
			Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubateOptions testing" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Plate,"Test container 6 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 7 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 8 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 9 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test container 10 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Container,Plate,"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test discarded sample for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 50mL tube for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 2L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in Open Test Tube for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 5L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 15mL tube for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in PCR Plate for ExperimentIncubateOptions" <> $SessionUUID],
					Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test TransportWarmed at 70C sample for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Sample,"Test water sample in 2mL tube for ExperimentIncubateOptions" <> $SessionUUID],
					Object[Protocol,Incubate,"Parent Protocol for ExperimentIncubateOptions testing" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];


		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,Incubate],
				Name->"Parent Protocol for ExperimentIncubateOptions testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					MixType->Nutate
				}
			|>
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],
				Name->"Test container 4 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:4pO6dMWvnnzL"],Objects],
				Name->"Test container 5 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 6 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "5L Glass Bottle"],Objects],
				Name->"Test container 7 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 8 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
				Name->"Test container 9 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->"Test container 10 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"],Objects],
				Name->"Test container 11 for ExperimentIncubateOptions" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create a transport warmed model. *)
		Upload[<|
			Type->Model[Sample,StockSolution],
			Name->"Test TransportWarmed at 70C model for ExperimentIncubateOptions" <> $SessionUUID,
			TransportWarmed->70Celsius,
			DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]]
		|>];

		(* Create some water samples *)
		{discardedChemical,waterSample,waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,waterSample7,waterSample8,transportWarmedSample,waterSample9, waterSample10}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Test TransportWarmed at 70C model for ExperimentIncubateOptions" <> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},
				{"A1",emptyContainer5},
				{"A1",emptyContainer6},
				{"A1",emptyContainer6},
				{"A1",emptyContainer7},
				{"A1",emptyContainer8},
				{"A1",emptyContainer9},
				{"A1",emptyContainer10},
				{"A1",emptyContainer11}

			},
			InitialAmount->{50 Milliliter,47 Milliliter,1 Liter,2 Liter,10 Milliliter,1 Milliliter,1 Milliliter,4.5 Liter,19 Milliliter,1 Milliliter, 1 Milliliter, 0.1 Milliliter},
			Name->{
				"Test discarded sample for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in 50mL tube for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in 1L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in 2L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in Open Test Tube for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample 1 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample 2 in 96 deep-well plate for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in 5L Glass Bottle for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in 15mL tube for ExperimentIncubateOptions" <> $SessionUUID,
				"Test TransportWarmed at 70C sample for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in 2mL tube for ExperimentIncubateOptions" <> $SessionUUID,
				"Test water sample in PCR Plate for ExperimentIncubateOptions" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample,DeveloperObject->True,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]},{10 Micromolar,Link[Model[Molecule,"Sodium n-Dodecyl Sulfate"]]}},Status->Available|>,
			<|Object->waterSample2,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample3,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample4,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample5,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample6,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample7,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample8,DeveloperObject->True,Status->Available|>,
			<|Object->transportWarmedSample,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample9,DeveloperObject->True,Status->Available|>,
			<|Object->waterSample10,DeveloperObject->True,Status->Available|>
		}];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection::Closed:: *)
(* IncubateDevices *)
DefineTests[
	IncubateDevices,
	{
		(*-- BASIC TESTS --*)
		Example[
			{Basic,"Incubate the sample at 45 Celsius:"},
			IncubateDevices[Object[Sample,"Test water sample in 50mL tube for IncubateDevices" <> $SessionUUID],Temperature->45 Celsius],
			{ObjectP[Model[]]..}
		],
		Example[
			{Options,"Use the environmental stability chamber when LightExposure is defined:"},
			IncubateDevices[Object[Sample,"Test water sample in 50mL tube for IncubateDevices" <> $SessionUUID],Temperature->25 Celsius, LightExposure->UVLight],
			{ObjectP[Model[Instrument, EnvironmentalChamber]]..}
		],
		Example[
			{Options,"Use the environmental stability chamber when RelativeHumidity is defined:"},
			IncubateDevices[Object[Sample,"Test water sample in 50mL tube for IncubateDevices" <> $SessionUUID],RelativeHumidity -> 50 Percent],
			{ObjectP[Model[Instrument, EnvironmentalChamber]]..}
		],
		Example[
			{Options,"Use the programmable Thermocycler when ProgrammableTemperatureControl is defined:"},
			IncubateDevices[Object[Sample,"Test water sample in 50mL tube for IncubateDevices" <> $SessionUUID], ProgrammableTemperatureControl -> True],
			{ObjectP[Model[Instrument, Thermocycler]]..}
		],
		Example[
			{Options,"Use appropriate HeatBlock when Samples is in Plate and IntegratedLiquidHandler is set to True:"},
			IncubateDevices[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for IncubateDevices" <> $SessionUUID],
				IntegratedLiquidHandler -> True
			],
			{ObjectP[Model[Instrument, HeatBlock]]..}
		]
	},
	SetUp:>(ClearMemoization[];ClearDownload[];),
	SymbolSetUp:> (
		$CreatedObjects = {};
		Module[
			{testObjList, existsFilter, room, bench, sample1, sample2, sample3, container1, container2, container3},
			testObjList = {
				Object[Container,Room, "Test Room (IncubateDevices)" <> $SessionUUID],
				Object[Container,Bench, "Test Bench (IncubateDevices)" <> $SessionUUID],
				Object[Container, Vessel, "Test 50 mL Tube 1 (IncubateDevices)" <> $SessionUUID],
				Object[Container, Plate, "Test 96-well Plate 1 (IncubateDevices)" <> $SessionUUID],
				Object[Container, Vessel, "Test 2L Bottle  1 (IncubateDevices)" <> $SessionUUID],
				Object[Sample, "Test water sample in 50mL tube for IncubateDevices" <> $SessionUUID],
				Object[Sample, "Test water sample 1 in 96 deep-well plate for IncubateDevices" <> $SessionUUID],
				Object[Sample, "Test water sample in 2L Glass Bottle for IncubateDevices" <> $SessionUUID]
			};
			(* clean up any duplicated fake object in db that we will use *)
			existsFilter = DatabaseMemberQ[testObjList];
			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
			(* pre assign ID *)
			{
				room,
				bench,
				sample1,
				sample2,
				sample3,
				container1,
				container2,
				container3
			} = Map[CreateID[#[Type]]&, testObjList];

			(* upload room *)
			Upload[{
				<|
					DeveloperObject -> True,
					Object -> room,
					Name -> "Test Room (IncubateDevices)" <> $SessionUUID,
					Model -> Link[Model[Container, Room, "Chemistry Lab"], Objects]
				|>
			}];
			(* upload bench *)
			{
				bench
			} = UploadSample[
				{
					Model[Container, Bench, "The Bench of Testing"]
				},
				{
					{"Bench Slot 4", room}
				},
				Name -> {
					"Test Bench (IncubateDevices)" <> $SessionUUID
				},
				FastTrack->True
			];
			(* upload contianer *)
			{
				container1,
				container2,
				container3
			} = UploadSample[
				{
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "2L Glass Bottle"]
				},
				ConstantArray[{"Work Surface", bench}, 3],
				Name -> {
					"Test 50 mL Tube 1 (IncubateDevices)" <> $SessionUUID,
					"Test 96-well Plate 1 (IncubateDevices)" <> $SessionUUID,
					"Test 2L Bottle  1 (IncubateDevices)" <> $SessionUUID
				},
				StorageCondition -> AmbientStorage
			];
			(* upload samples *)
			{
				sample1,
				sample2,
				sample3
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", container1},
					{"A1", container2},
					{"A1", container3}
				},
				Name -> {
					"Test water sample in 50mL tube for IncubateDevices" <> $SessionUUID,
					"Test water sample 1 in 96 deep-well plate for IncubateDevices" <> $SessionUUID,
					"Test water sample in 2L Glass Bottle for IncubateDevices" <> $SessionUUID
				},
				InitialAmount -> {
					15 Milliliter,
					1 Milliliter,
					500 Milliliter
				},
				StorageCondition -> AmbientStorage
			];
		]
	),
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(*Engine Functions*)

DefineTests[uploadInvertFullyDissolved,
	{
		Example[{Basic,"Appends a True to the InvertFullyDissolved field:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], DeveloperObject->True|>];

				uploadInvertFullyDissolved[newProtocol];

				Download[newProtocol, InvertFullyDissolved]
			],
			{True}
		]
	}
];

DefineTests[uploadSwirlFullyDissolved,
	{
		Example[{Basic,"Appends a True to the SwirlFullyDissolved field:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], DeveloperObject->True|>];

				uploadSwirlFullyDissolved[newProtocol];

				Download[newProtocol, SwirlFullyDissolved]
			],
			{True}
		]
	}
];

DefineTests[uploadThawStartTime,
	{
		Example[{Basic,"Sets ThawStartTime to Now:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], DeveloperObject->True|>];

				uploadThawStartTime[newProtocol];

				Download[newProtocol, ThawStartTime]
			],
			_?DateObjectQ
		]
	}
];

DefineTests[uploadCurrentStartDate,
	{
		Example[{Basic,"Sets CurrentStartDate to Now:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], DeveloperObject->True|>];

				uploadCurrentStartDate[newProtocol];

				Download[newProtocol, CurrentStartDate]
			],
			_?DateObjectQ
		]
	}
];

DefineTests[uploadTemporaryMixUntilDissolvedFalse,
	{
		Example[{Basic,"Appends False to the TemporaryMixUntilDissolved field:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], DeveloperObject->True|>];

				uploadTemporaryMixUntilDissolvedFalse[newProtocol];

				Download[newProtocol, TemporaryMixUntilDissolved]
			],
			{False}
		]
	}
];

DefineTests[uploadCurrentMixUntilDissolved,
	{
		Example[{Basic,"Copies over the TemporaryMixUntilDissolved field into the CurrentMixUntilDissolved field:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], Replace[TemporaryMixUntilDissolved] -> {False, True, False}, DeveloperObject->True|>];

				uploadCurrentMixUntilDissolved[newProtocol];

				Download[newProtocol, CurrentMixUntilDissolved]
			],
			{False, True, False}
		],
		Example[{Basic,"Merges the TemporaryMixUntilDissolved field into the CurrentMixUntilDissolved field if CurrentMixUntilDissolved is not empty:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], Replace[TemporaryMixUntilDissolved] -> {False}, Replace[CurrentMixUntilDissolved] -> {False, True, False}, DeveloperObject->True|>];

				uploadCurrentMixUntilDissolved[newProtocol];

				Download[newProtocol, CurrentMixUntilDissolved]
			],
			{False, False, False}
		]
	}
];

DefineTests[uploadPipetteFullyDissolvedFalse,
	{
		Example[{Basic,"Appends False to the PipetteFullyDissolved field:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], DeveloperObject->True|>];

				uploadPipetteFullyDissolvedFalse[newProtocol];

				Download[newProtocol, PipetteFullyDissolved]
			],
			{False}
		]
	}
];

DefineTests[clearPipetteFullyDissolved,
	{
		Example[{Basic,"Clears out the PipetteFullyDissolved field:"},
			Module[{newProtocol},
				newProtocol=Upload[<|Type->Object[Protocol, Incubate], Replace[PipetteFullyDissolved] -> {True, False}, DeveloperObject->True|>];

				clearPipetteFullyDissolved[newProtocol];

				Download[newProtocol, PipetteFullyDissolved]
			],
			{}
		]
	}
];

(* ::Subsubsection:: *)
(*TransportDevices*)


DefineTests[
	TransportDevices,
	{
		Example[
			{Basic,"Returns the instrument that can be used to transport a Model Sample with a volume of 2mL with a default of Ambient TransportCondition:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Volume->2Milliliter],
			Null
		],
		Example[
			{Basic,"Returns the instrument that can be used with a Model Sample with a volume of 2mL and a specified TransportCondition of Minus80:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Model[TransportCondition,"Minus 80"],Volume->2Milliliter],
			ObjectP[Model[Instrument]]
		],
		Example[
			{Basic,"Returns the instrument that can be used with a Model Sample with a volume of 2mL and a specified TransportCondition of LightBox:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Model[TransportCondition,"LightBox"],Volume->2Milliliter],
			ObjectP[Model[Container]]
		],
		Example[
			{Basic,"Returns the instrument that can be used with an Object Sample with a volume of 2mL and a specified TransportCondition:"},
			TransportDevices[Object[Sample,"Test Object Sample" <> $SessionUUID],Model[TransportCondition,"LightBox"]],
			ObjectP[Model[Container]]
		],
		Example[
			{Basic,"Returns the instrument that can be used with a Model Sample with a specified Container and a specified TransportCondition:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Model[TransportCondition,"Minus 80"],Volume->2Milliliter,Container->Model[Container,Vessel,"2mL Tube"]],
			ObjectP[Model[Instrument]]
		],
		Example[
			{Basic,"Returns the instrument that can be used with a Model Sample a DefaultStorageCondition of Freezer:"},
			TransportDevices[Model[Sample,"Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID],Model[TransportCondition,"Minus 80"],Volume->2Milliliter,Container->Model[Container,Vessel,"2mL Tube"]],
			ObjectP[Model[Instrument]]
		],
		(*--- Message tests ---*)

		Example[
			{Messages,"NoVolumeSpecified","If specifying a Model Sample to be transported, a volume must be specified:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Model[TransportCondition,"LightBox"]],
			ObjectP[Model[Container]],
			Messages:>{
				Warning::NoVolumeSpecified
			}
		],
		Example[
			{Messages,"IncompatibleDimensions","The container with the sample must be able to fit in the transporter instrument:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Model[TransportCondition,"Minus 80"],Volume->20Liter],
			$Failed,
			Messages:>{
				Error::IncompatibleDimensions
			}
		],
		Example[
			{Messages,"IncompatibleTemperatures","The input Model Sample or Object Sample must be transported at a temperature safe for the container of the sample:"},
			TransportDevices[Model[Sample,"Test Model Sample" <> $SessionUUID],Model[TransportCondition,"LightBox"],Volume->2Milliliter,Container->Model[Container, Vessel, "id:1ZA60vL7XBAa"]],
			$Failed,
			Messages:>{
				Error::IncompatibleTemperatures
			}
		],
		Example[
			{Messages,"FlammableOrPyrophoric","If the input Model Sample or Object Sample is Flammable or Pyrophoric and is asked to be tranposrted OvenDried, throw an error:"},
			TransportDevices[Model[Sample,"Test Model Sample Flammable" <> $SessionUUID],Model[TransportCondition,"OvenDried"],Volume->2Milliliter,Container->Model[Container, Vessel, "id:1ZA60vL7XBAa"]],
			$Failed,
			Messages:>{
				Error::FlammableOrPyrophoric
			}
		],
		Example[
			{Messages,"FrozenSampleThawTemperature","If the input Model Sample or Object Sample is stored Frozen or Cryogenic, the given TransportCondition needs to "},
			TransportDevices[Model[Sample,"Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID],Model[TransportCondition,"OvenDried"],Volume->2Milliliter,Container->Model[Container, Vessel, "id:1ZA60vL7XBAa"]],
			$Failed,
			Messages:>{
				Warning::FrozenSampleThawTemperature
			}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Model[Sample,"Test Model Sample" <> $SessionUUID],
			Model[Sample,"Test Model Sample with Deep Freezer storage" <> $SessionUUID],
			Object[Sample,"Test Object Sample" <> $SessionUUID],
			Model[Sample,"Test Model Sample Flammable" <> $SessionUUID],
			Model[Sample,"Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Model[Sample,"Test Model Sample" <> $SessionUUID],
					Model[Sample,"Test Model Sample with Deep Freezer storage" <> $SessionUUID],
					Object[Sample,"Test Object Sample" <> $SessionUUID],
					Model[Sample,"Test Model Sample Flammable" <> $SessionUUID],
					Model[Sample,"Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];

		(* upload the model samples of just water with different DefaultStorageConditions *)
		UploadSampleModel["Test Model Sample" <> $SessionUUID,
			Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
			Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
			State->Liquid,BiosafetyLevel->"BSL-1",Flammable->False,MSDSRequired->False,IncompatibleMaterials->{None}];

		(* upload the model samples of just water with different DefaultStorageConditions *)
		UploadSampleModel["Test Model Sample with Deep Freezer storage" <> $SessionUUID,
			Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
			Expires->False,DefaultStorageCondition->Model[StorageCondition,"Deep Freezer"],
			State->Liquid,BiosafetyLevel->"BSL-1",Flammable->False,MSDSRequired->False,IncompatibleMaterials->{None}];

		(* upload the model samples of just water with different DefaultStorageConditions *)
		UploadSampleModel["Test Model Sample Flammable" <> $SessionUUID,
			Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
			Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage, Flammable"],
			State->Liquid,BiosafetyLevel->"BSL-1",Flammable->True,MSDSRequired->False,IncompatibleMaterials->{None}];

		(* upload the model samples of just water with different DefaultStorageCondition of Freezer *)
		UploadSampleModel["Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID,
			Composition->{{100 VolumePercent,Model[Molecule,"Water"]}},
			Expires->False,DefaultStorageCondition->Model[StorageCondition,"Freezer"],
			ThawTemperature->0Celsius,
			State->Liquid,BiosafetyLevel->"BSL-1",MSDSRequired->False,IncompatibleMaterials->{None}];

		(* upload the object sample of just water with Ambient StorageCondition *)
		UploadSample[
			Model[Sample, "Milli-Q water"],
			{"A1", Object[Container, Vessel, "Empty 50mL Tube"]},
			InitialAmount -> 20 Milliliter,
			StorageCondition->Model[StorageCondition,"Ambient Storage"],
			Name->"Test Object Sample" <> $SessionUUID
		];

	),
	SymbolTearDown:>(
		existsFilter=DatabaseMemberQ[{
			Model[Sample,"Test Model Sample" <> $SessionUUID],
			Model[Sample,"Test Model Sample with Deep Freezer storage" <> $SessionUUID],
			Object[Sample,"Test Object Sample" <> $SessionUUID],
			Model[Sample,"Test Model Sample Flammable" <> $SessionUUID],
			Model[Sample,"Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Model[Sample,"Test Model Sample" <> $SessionUUID],
					Model[Sample,"Test Model Sample with Deep Freezer storage" <> $SessionUUID],
					Object[Sample,"Test Object Sample" <> $SessionUUID],
					Model[Sample,"Test Model Sample Flammable" <> $SessionUUID],
					Model[Sample,"Test Model Sample DefaultStorageCondition Freezer" <> $SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Section:: *)
(*End Test Package*)
