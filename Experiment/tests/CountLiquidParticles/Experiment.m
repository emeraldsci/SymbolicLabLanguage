(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentCountLiquidParticles : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCountLiquidParticles*)


DefineTests[
	ExperimentCountLiquidParticles,
	{
		Example[{Basic, "Measure the liquid particle count of a single sample:"},
			ExperimentCountLiquidParticles[Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]],
			ObjectP[Object[Protocol, CountLiquidParticles]]
		],
		Example[{Additional, "Return simulation packet if specified the simulation:"},
			simulation = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Output -> Simulation
			];
			volumes = Download[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Volume,
				Simulation -> simulation
			];
			{simulation, volumes},
			{SimulationP, {EqualP[16.8 Milliliter], EqualP[16.8 Milliliter], EqualP[16.8 Milliliter]}},
			Variables :> {simulation, volumes}
		],
		Example[{Options, Instrument, "Specify the instrument used to detect and count particles in a sample using light obscuration while flowing the sample through a flow cell:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Instrument -> Object[Instrument, LiquidParticleCounter, "Test instrument for ExperimentCountLiquidParticles" <> $SessionUUID]
			];
			Download[protocol, Instrument],
			LinkP[Object[Instrument, LiquidParticleCounter, "Test instrument for ExperimentCountLiquidParticles" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options, Sensor, "Specify the light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count. The sensor sets the range of the particle sizes that can be detected:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Sensor -> Model[Part, LightObscurationSensor, "2-400 um"]
			];
			Download[protocol, Sensor],
			LinkP[Model[Part, LightObscurationSensor, "2-400 um"]],
			Variables :> {protocol}
		],
		Example[{Options, SyringeSize, "Measure the liquid particle count of a single sample:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				SyringeSize -> 10Milliliter,
				Output -> Options
			];
			Lookup[options, SyringeSize],
			10 Milliliter,
			Variables :> {options}
		],
		Example[{Options, Syringe, "Measure the liquid particle count of a single sample:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Syringe -> Model[Part, Syringe, "10 mL HIAC Injection Syringe"],
				Output -> Options
			];
			Lookup[options, Syringe],
			Download[Model[Part, Syringe, "10 mL HIAC Injection Syringe"], Object],
			Variables :> {options}
		],
		Example[{Options, Method, "Specify a pre-existing method:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Method -> Object[Method, LiquidParticleCounting, "Existed test method for ExperimentCountLiquidParticles" <> $SessionUUID]
			];
			Download[protocol, Methods],
			{
				LinkP[Object[Method, LiquidParticleCounting, "Existed test method for ExperimentCountLiquidParticles" <> $SessionUUID]],
				LinkP[Object[Method, LiquidParticleCounting, "Existed test method for ExperimentCountLiquidParticles" <> $SessionUUID]],
				LinkP[Object[Method, LiquidParticleCounting, "Existed test method for ExperimentCountLiquidParticles" <> $SessionUUID]]
			},
			Variables :> {protocol}
		],
		Example[{Options, Method, "Specify a the method to be Custom:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Method -> Custom
			];
			Download[protocol, Methods],
			{LinkP[Object[Method, LiquidParticleCounting]], LinkP[Object[Method, LiquidParticleCounting]], LinkP[Object[Method, LiquidParticleCounting]]},
			Variables :> {protocol}
		],
		Example[{Options, ParticleSizes, "Specify the collection of ranges the different particle sizes that monitored:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ParticleSizes -> {
					{10 Micrometer},
					{11 Micrometer, 12 Micrometer},
					{12 Micrometer},
					{11 Micrometer, 12 Micrometer, 13 Micrometer},
					{14 Micrometer}
				},
				Output -> Options
			];
			Lookup[options, ParticleSizes],
			{
				{10 Micrometer},
				{11 Micrometer, 12 Micrometer},
				{12 Micrometer},
				{11 Micrometer, 12 Micrometer, 13 Micrometer},
				{14 Micrometer}
			},
			Variables :> {options}
		],
		Example[{Options, PrimeSolutions, "Specify the solution(s) pumped through the instrument's flow path prior to the loading and measuring samples:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PrimeSolutions -> Model[Sample, "Milli-Q water"]
			];
			Download[protocol, PrimeSolutions],
			{LinkP[Model[Sample, "Milli-Q water"]]},
			Variables :> {protocol}
		],
		Example[{Options, PrimeSolutionTemperatures, "Specify for each member of PrimeSolutions, the temperature to which the PrimeSolutions is preheated before flowing it through the flow path:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PrimeSolutionTemperatures -> 40Celsius
			];
			Download[protocol, PrimeSolutionTemperatures],
			{Quantity[40.`, "DegreesCelsius"]},
			Variables :> {protocol}
		],
		Example[{Options, PrimeEquilibrationTime," Specify for each member of PrimeSolutions, the length of time for which the prime solution container equilibrate at the requested PrimeSolutionTemperatures in the sample rack before being pumped through the instrument's flow path:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PrimeEquilibrationTime -> 3Minute
			];
			Download[protocol, PrimeEquilibrationTimes],
			{Quantity[3.`, "Minutes"]},
			Variables :> {protocol}
		],
		Example[{Options, PrimeWaitTime, "Specify for each member of PrimeSolutions, the amount of time for which the syringe is allowed to soak with each prime solutions before flushing it to the waste:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PrimeWaitTime -> 1 Minute
			];
			Download[protocol, PrimeWaitTimes],
			{Quantity[1.`, "Minutes"]},
			Variables :> {protocol}
		],
		Example[{Options, NumberOfPrimes, "Specify for each member of PrimeSolutions, the number of times each prime solution pumped through the instrument's flow path:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				NumberOfPrimes -> 3
			];
			Download[protocol, NumberOfPrimes],
			{3},
			Variables :> {protocol}
		],
		Example[{Options, DilutionCurve, "Specify the collection of dilutions that will be performed on the samples before light obscuration measurements are taken. For Fixed Dilution Volume Dilution Curves, the Sample Amount is the volume of the sample that will be mixed with the Diluent Volume of the Diluent to create the desired concentration. For Fixed Dilution Factor Dilution Curves, the Sample Volume is the volume of the sample that will created after being diluted by the Dilution Factor. For example, a 1M sample with a dilution factor of 0.7 will be diluted to a concentration 0.7M. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				SyringeSize -> 1 Milliliter,
				DilutionCurve -> {{2Milliliter, 8Milliliter}, {2.5Milliliter, 7.50Milliliter}, {3Milliliter, 7Milliliter}}
			];
			Download[protocol, Dilutions],
			{
				{
					{Quantity[2, "Milliliters"], Quantity[8, "Milliliters"]},
					{Quantity[2.5`, "Milliliters"], Quantity[7.5`, "Milliliters"]},
					{Quantity[3, "Milliliters"], Quantity[7, "Milliliters"]}
				},
				{
					{Quantity[2, "Milliliters"], Quantity[8, "Milliliters"]},
					{Quantity[2.5`, "Milliliters"], Quantity[7.5`, "Milliliters"]},
					{Quantity[3, "Milliliters"], Quantity[7, "Milliliters"]}
				},
				{
					{Quantity[2, "Milliliters"], Quantity[8, "Milliliters"]},
					{Quantity[2.5`, "Milliliters"], Quantity[7.5`, "Milliliters"]},
					{Quantity[3, "Milliliters"], Quantity[7, "Milliliters"]}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, SerialDilutionCurve, "Specify the collection of serial dilutions that will be performed on the samples before light obscuration measurements are taken. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 ug/ ml sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 25 ug/ ml, 6.25 ug/ ml, and 1.5625 ug/ ml with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				SerialDilutionCurve -> {5 Milliliter, {0.7, 0.8, 0.6, 0.1}}
			];
			Download[protocol, SerialDilutions],
			{
				{
					{Quantity[8.148`, "Milliliters"], Quantity[3.492`, "Milliliters"]},
					{Quantity[6.64`, "Milliliters"], Quantity[1.66`, "Milliliters"]},
					{Quantity[3.3`, "Milliliters"], Quantity[2.2`, "Milliliters"]},
					{Quantity[0.5`, "Milliliters"], Quantity[4.5`, "Milliliters"]}
				},
				{
					{Quantity[8.148`, "Milliliters"], Quantity[3.492`, "Milliliters"]},
					{Quantity[6.64`, "Milliliters"], Quantity[1.66`, "Milliliters"]},
					{Quantity[3.3`, "Milliliters"], Quantity[2.2`, "Milliliters"]},
					{Quantity[0.5`, "Milliliters"], Quantity[4.5`, "Milliliters"]}
				},
				{
					{Quantity[8.148`, "Milliliters"], Quantity[3.492`, "Milliliters"]},
					{Quantity[6.64`, "Milliliters"], Quantity[1.66`, "Milliliters"]},
					{Quantity[3.3`, "Milliliters"], Quantity[2.2`, "Milliliters"]},
					{Quantity[0.5`, "Milliliters"], Quantity[4.5`, "Milliliters"]}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, Diluent, "Specify the solution that is used to dilute the sample to generate a DilutionCurve or SerialDilutionCurve:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Diluent -> Model[Sample, "Methanol"]
			];
			Download[protocol, Diluents],
			{LinkP[Model[Sample, "Methanol"]], LinkP[Model[Sample, "Methanol"]], LinkP[Model[Sample, "Methanol"]]},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, DilutionContainer, "Specify the containers in which each sample is diluted with the Diluent to make the concentration series, with indices indicating specific grouping of samples if desired:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DilutionCurve -> {{2.0 Milliliter, 5.0 Milliliter}, {2.5 Milliliter, 5.0 Milliliter}, {3.0 Milliliter, 5.0 Milliliter}},
				SyringeSize -> 1 Milliliter,
				DilutionContainer -> {
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"]
				}
			];
			Download[protocol, DilutionContainers],
			{
				{
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]],
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]],
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]
				},
				{
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]],
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]],
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]
				},
				{
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]],
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]],
					ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, DilutionStorageCondition, "Specify the conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DilutionStorageCondition -> Disposal
			];
			Download[protocol, DilutionStorageConditions],
			{Disposal, Disposal, Disposal},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, DilutionMixVolume, "Specify the volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DilutionCurve -> {{0.5Milliliter, 1.5Milliliter}, {1Milliliter, 1Milliliter}, {1.5Milliliter, 0.5Milliliter}},
				DilutionMixVolume -> 0.5Milliliter,
				SyringeSize -> 1 Milliliter
			];
			Download[protocol, DilutionMixVolumes],
			{Quantity[500.`, "Microliters"], Quantity[500.`, "Microliters"], Quantity[500.`, "Microliters"]},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, DilutionNumberOfMixes, "Specify the number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DilutionNumberOfMixes -> 3
			];
			Download[protocol, DilutionNumberOfMixes],
			{3, 3, 3},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions}
		],
		Example[{Options, DilutionMixRate, "Specify the speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DilutionMixRate -> 400 Microliter/Second
			];
			Download[protocol, DilutionMixRates],
			{
				400 Microliter/Second,
				400 Microliter/Second,
				400 Microliter/Second
			},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticleDilutions},
			EquivalenceFunction -> Equal
		],
		Example[{Options, ReadingVolume, "Specify the volume of sample that is loaded into the instrument and used to determine particle size and count. If the reading volume exceeds the volume of the syringe the instruments will perform multiple strokes to cover the full reading volume:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ReadingVolume -> 213Microliter
			];
			Download[protocol, ReadingVolumes],
			{Quantity[213.`, "Microliters"], Quantity[213.`, "Microliters"], Quantity[213.`, "Microliters"]},
			Variables :> {protocol}
		],
		Example[{Options, SampleTemperature, "Specify the temperature when the sample will be kept during the measurement:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				SampleTemperature -> 45Celsius
			];
			Download[protocol, SampleTemperatures],
			{Quantity[45.`, "DegreesCelsius"], Quantity[45.`, "DegreesCelsius"], Quantity[45.`, "DegreesCelsius"]},
			Variables :> {protocol}
		],
		Example[{Options, EquilibrationTime, "Specify the length of time for which each sample is incubated at the requested SampleTemperature just prior to being read:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				EquilibrationTime -> 3 Minute
			];
			Download[protocol, EquilibrationTimes],
			{Quantity[3.`, "Minutes"], Quantity[3.`, "Minutes"], Quantity[3.`, "Minutes"]},
			Variables :> {protocol}
		],
		Example[{Options, NumberOfReadings, "Specify the number of times the liquid particle count is read by passing ReadingVolume through the light obscuration sensor:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				NumberOfReadings -> 5
			];
			Download[protocol, NumberOfReadings],
			{5, 5, 5},
			Variables :> {protocol}
		],
		Example[{Options, PreRinseVolume, "Specify the volume of the sample flown into the syringe tubing to rinse out the lines with each new sample before beginning the reading:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PreRinseVolume -> 900 Microliter
			];
			Download[protocol, PreRinseVolumes],
			{Quantity[900.`, "Microliters"], Quantity[900.`, "Microliters"], Quantity[900.`, "Microliters"]},
			Variables :> {protocol}
		],
		Example[{Options, AcquisitionMix, "Indicates whether the samples should be mixed with a stir bar during data acquisition:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMix -> True,
				Output -> Options
			];
			Lookup[options, AcquisitionMix],
			True,
			Variables :> {options}
		],
		Example[{Options, AcquisitionMixType, "If AcquisitionMix is True, then the stir type is default to Stir."},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMix -> True,
				Output -> Options
			];
			Lookup[options,AcquisitionMixType],
			Stir,
			Variables :> {options}
		],
		Example[{Options, AcquisitionMixType, "Indicates the method used to mix the sample. If this option is set to Stir, a StirBar will be transferred into the sample container and stir the sample during the entire data collection process."},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMixType -> Stir,
				Output -> Options
			];
			Lookup[options, {AcquisitionMix, AcquisitionMixType}],
			{True, Stir},
			Variables :> {options}
		],
		If[$CountLiquidParticlesAllowHandSwirl,
			Sequence @@ {Example[{Options, NumberOfMixes, "Specify indicate the number of times the sample container will be swirled if the AcquisitionMixType is swirl."},
				options = ExperimentCountLiquidParticles[
					{
						Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
						Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
						Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
					},
					NumberOfMixes-> {13, 14, 15},
					Output -> Options
				];
				Lookup[options, NumberOfMixes],
				{13, 14, 15},
				Variables :> {options}
			], 
				Example[{Options, WaitTimeBeforeReading, "Specify the length of time the container will be placed standstill before the reading its particle sizes."},
					options = ExperimentCountLiquidParticles[
						{
							Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
						},
						WaitTimeBeforeReading -> {1 Minute, 2 Minute, 3 Minute},
						Output -> Options
					];
					Lookup[options, WaitTimeBeforeReading],
					{1 Minute, 2 Minute, 3 Minute},
					Variables :> {options}
				]
			},
			Nothing
		],
		Example[{Options, StirBar, "Indicates whether the stir bar should be used to agitate the sample during acquisition:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				StirBar -> Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]
			];
			Download[protocol, StirBars],
			{
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]],
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]],
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]]
			},
			Variables :> {protocol}
		],
		Example[{Options, AcquisitionMixRate, "Specify the rate at which the samples should be mixed with a stir bar during data acquisition:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMixRate -> 140 RPM
			];
			Download[protocol, AcquisitionMixRates],
			{
				Quantity[140.`, ("Revolutions")/("Minutes")],
				Quantity[140.`, ("Revolutions")/("Minutes")],
				Quantity[140.`, ("Revolutions")/("Minutes")]
			},
			Variables :> {protocol}
		],
		Example[{Options, AdjustMixRate, "Indicates whether mixing rate of stir bar is adjusted:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AdjustMixRate -> False,
				Output -> Options
			];
			Lookup[options, AdjustMixRate],
			False,
			Variables :> {protocol}
		],
		Example[{Options, MinAcquisitionMixRate, "Specify Sets the lower limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar if AdjustMixRate is True:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MinAcquisitionMixRate -> 50 RPM
			];
			Download[protocol, MinAcquisitionMixRates],
			{
				Quantity[50.`, ("Revolutions")/("Minutes")],
				Quantity[50.`, ("Revolutions")/("Minutes")],
				Quantity[50.`, ("Revolutions")/("Minutes")]
			},
			Variables :> {protocol}
		],
		Example[{Options, MaxAcquisitionMixRate, "Specify Sets the upper limit stirring rate to be increased to for sample mixing while attempting to mix the samples with a stir bar if AdjustMixRate is True:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MaxAcquisitionMixRate -> 200 RPM
			];
			Download[protocol, MaxAcquisitionMixRates],
			{
				Quantity[200.`, ("Revolutions")/("Minutes")],
				Quantity[200.`, ("Revolutions")/("Minutes")],
				Quantity[200.`, ("Revolutions")/("Minutes")]
			},
			Variables :> {protocol}
		],
		Example[{Options, AcquisitionMixRateIncrement, "Specify indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMixRateIncrement -> 20 RPM
			];
			Download[protocol, AcquisitionMixRateIncrements],
			{
				Quantity[20.`, ("Revolutions")/("Minutes")],
				Quantity[20.`, ("Revolutions")/("Minutes")],
				Quantity[20.`, ("Revolutions")/("Minutes")]
			},
			Variables :> {protocol}
		],
		Example[{Options, MaxStirAttempts, "Specify indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MaxStirAttempts -> 5
			];
			Download[protocol, MaxStirAttempts],
			{5, 5, 5},
			Variables :> {protocol}
		],
		Example[{Options, WashSolution, "Specify for each member of SamplesIn, the solution pumped through the instrument's flow path to clean it between the loading of each new sample:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				WashSolution -> Model[Sample, "Methanol"]
			];
			Download[protocol, WashSolutions],
			{
				LinkP[Model[Sample, "Methanol"]],
				LinkP[Model[Sample, "Methanol"]],
				LinkP[Model[Sample, "Methanol"]]
			},
			Variables :> {protocol}
		],
		Example[{Options, WashSolutionTemperature, "Specify for each member of SamplesIn, the temperature to which the WashSolution is preheated before flowing it through the flow path:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				WashSolutionTemperature -> 30 Celsius
			];
			Download[protocol, WashSolutionTemperatures],
			{
				Quantity[30.`, "DegreesCelsius"],
				Quantity[30.`, "DegreesCelsius"],
				Quantity[30.`, "DegreesCelsius"]
			},
			Variables :> {protocol}
		],
		Example[{Options, WashEquilibrationTime, "Specify for each member of SamplesIn, the length of time for which the wash solution container equilibrate at the requested WashSolutionTemperature in the sample rack before being pumped through the instrument's flow path:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				WashEquilibrationTime -> 5 Minute
			];
			Download[protocol, WashEquilibrationTimes],
			{Quantity[5.`, "Minutes"], Quantity[5.`, "Minutes"], Quantity[5.`, "Minutes"]},
			Variables :> {protocol}
		],
		Example[{Options, WashWaitTime, "Specify for each member of SamplesIn, the amount of time for which the syringe is allowed to soak with each wash solution before flushing it to the waste:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				WashWaitTime -> 1 Minute
			];
			Download[protocol, WashWaitTimes],
			{Quantity[1.`, "Minutes"], Quantity[1.`, "Minutes"], Quantity[1.`, "Minutes"]},
			Variables :> {protocol}
		],
		Example[{Options, NumberOfWashes, "Specify for each member SamplesIn, the number of times each wash solution is pumped through the instrument's flow path:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				NumberOfWashes -> 2
			];
			Download[protocol, NumberOfWashes],
			{2, 2, 2},
			Variables :> {protocol}
		],
		Example[{Options, SamplesInStorageCondition, "Specify the number of aliquots to generate from every sample as input to the flow cytometry experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				SamplesInStorageCondition->Freezer,
				Output -> Options
			];
			Lookup[options, SamplesInStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options, SampleLabel, "Specify the sample label for SamplePreparation primitives:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				SampleLabel -> "Test Label" <> $SessionUUID,
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"Test Label" <> $SessionUUID,
			Variables :> {options}
		],
		Example[{Options, SampleContainerLabel, "Specify the sample container label for SamplePreparation primitives:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				SampleContainerLabel -> "Test Container Label" <> $SessionUUID,
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"Test Container Label" <> $SessionUUID,
			Variables :> {options}
		],
		Example[{Options, AliquotSampleLabel, "Specify the aliquot label for SamplePreparation primitives:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				AliquotSampleLabel -> "Test Aliquot Label" <> $SessionUUID,
				Output -> Options
			];
			Lookup[options, AliquotSampleLabel],
			"Test Aliquot Label" <> $SessionUUID,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Specify the aliquot amount:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				AliquotAmount -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, AliquotAmount],
			15 Milliliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, DiscardFirstRun, "Specify if the first run of the experiment will be discarded during the data collection:"},
			protocol = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				DiscardFirstRun -> False
			];
			Download[protocol, DiscardFirstRuns],
			{False},
			Variables :> {protocol}
		],
		Example[{Options, SamplingHeight, "Sampling heights can catch if a stir bar is specified:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMixType -> Stir
			];
			Download[protocol, SamplingHeights],
			{31 Millimeter, 31 Millimeter, 31 Millimeter},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, SamplingHeight, "Specify the height of the probe when sampling:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				SamplingHeight -> {2 Millimeter, 3 Millimeter, 4 Millimeter}
			];
			Download[protocol, SamplingHeights],
			{2 Millimeter, 3 Millimeter, 4 Millimeter},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, SaveCustomMethod, "Specify the new custom method will be saved as a new Object[Method]:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				SaveCustomMethod -> False,
				Output -> Options
			];
			Lookup[options, SaveCustomMethod],
			False,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Specify the new custom method will be saved as a new Object[Method]:"},
			protocol = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				NumberOfReplicates -> 2
			];
			Download[protocol, SamplesIn],
			{
				ObjectP[Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]],
				ObjectP[Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]]
			},
			Variables :> {protocol}
		],
		Example[{Options, AliquotContainer, "Specify the new aliquot containers:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				AliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				AliquotPreparation -> Manual,
				Output -> Options
			];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				DestinationWell -> "A1",
				AliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, DestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, Preparation, "Specify indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell. For now ExperimentCountLiquidParticles can be only done manually:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Preparation -> Manual,
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, Template, "Specify A template protocol whose methodology should be reproduced in running this experiment. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Template -> Object[Protocol, CountLiquidParticles, "Existed test protocol for ExperimentCountLiquidParticles" <> $SessionUUID]
			];
			Download[protocol, Template],
			LinkP[Object[Protocol, CountLiquidParticles, "Existed test protocol for ExperimentCountLiquidParticles" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options, Name, "Specify A object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Name -> "Test name for ExpCountLiqParticles" <> $SessionUUID,
				Output -> Options
			];
			Lookup[options, Name],
			"Test name for ExpCountLiqParticles" <> $SessionUUID,
			Variables :> {protocol}
		],
		Example[{Options, PreparatoryUnitOperations, "Specify Specifies a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSampleManipulation:"},
			protocol = ExperimentCountLiquidParticles[
				{
					"CLP Sample 1",
					"CLP Sample 2"
				},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Sample Vessel 1",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 40 Milliliter,
						Destination -> "Sample Vessel 1",
						DestinationLabel -> "CLP Sample 1"
					],
					LabelContainer[
						Label -> "Sample Vessel 2",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 40 Milliliter,
						Destination -> "Sample Vessel 2",
						DestinationLabel -> "CLP Sample 2"
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP ..},
			Variables :> {protocol}
		],
		Example[{Options, PreparatoryPrimitives, "Specify Specifies a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSampleManipulation:"},
			protocol = ExperimentCountLiquidParticles[
				{
					"Sample Vessel 1"
				},
				PreparatoryPrimitives -> {
					Define[
						Name -> "Sample Vessel 1",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
						Amount -> 100 Microliter,
						Destination -> {"Sample Vessel 1", "A1"}
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Amount -> 20 Milliliter,
						Destination -> {"Sample Vessel 1", "A1"}
					]
				}
			];
			Download[protocol, PreparatoryPrimitives],
			{SampleManipulationP ..},
			Variables :> {protocol}
		],
		Example[{Options, Incubate, "Specify indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Incubate -> True,
				Output -> Options
			];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Specify Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				IncubationTemperature -> 50 Celsius,
				Output -> Options
			];
			Lookup[options, IncubationTemperature],
			50 Celsius,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Specify Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				IncubationTime -> 10 Minute,
				Output -> Options
			];
			Lookup[options, IncubationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, Mix, "Specify indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Mix -> True,
				Output -> Options
			];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Specify indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MixType -> Vortex,
				Output -> Options
			];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Specify indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MixUntilDissolved -> True,
				Output -> Options
			];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MaxIncubationTime -> 11 Minute,
				Output -> Options
			];
			Lookup[options, MaxIncubationTime],
			11 Minute,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"],
				Output -> Options
			];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Specify Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AnnealingTime -> 12 Minute,
				Output -> Options
			];
			Lookup[options, AnnealingTime],
			12 Minute,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Specify the desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, IncubateAliquotContainer],
			{
				{1, ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]},
				{2, ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]},
				{3, ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Specify the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				IncubateAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
				IncubateAliquotDestinationWell -> {"A1","B1","C1"},
				Output -> Options
			];
			Lookup[options, IncubateAliquotDestinationWell],
			{"A1", "B1", "C1"},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, IncubateAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				IncubateAliquot -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, IncubateAliquot],
			15 Milliliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Centrifuge -> True,
				Output -> Options
			];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"],
				CentrifugeAliquot -> 1200 Microliter,
				Output -> Options
			];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				CentrifugeIntensity -> 1000 RPM,
				Output -> Options
			];
			Lookup[options, CentrifugeIntensity],
			1000 RPM,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				CentrifugeTime -> 13 Minute,
				Output -> Options
			];
			Lookup[options, CentrifugeTime],
			13 Minute,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				CentrifugeTemperature -> 40 Celsius,
				Output -> Options
			];
			Lookup[options, CentrifugeTemperature],
			40 Celsius,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options
			];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				CentrifugeAliquotDestinationWell -> {"A1"},
				Output -> Options
			];
			Lookup[options, CentrifugeAliquotDestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				CentrifugeAliquot -> 1200 Microliter,
				Output -> Options
			];
			Lookup[options, CentrifugeAliquot],
			1200 Microliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Filtration -> True,
				Output -> Options
			];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Specify the type of filtration method that should be used to perform the filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FiltrationType -> Syringe,
				Output -> Options
			];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Specify the instrument that should be used to perform the filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterInstrument -> Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"],
				Output -> Options
			];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Filter, "Specify the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterAliquot -> 5 Milliliter,
				Filtration -> True,
				Filter -> Model[Container, Vessel, Filter, "id:6V0npvmeAX81"],
				Output -> Options
			];
			Lookup[options, Filter],
			ObjectP[Model[Container, Vessel, Filter, "id:6V0npvmeAX81"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterMaterial -> PES,
				Output -> Options
			];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PrefilterMaterial -> Null,
				Output -> Options
			];
			Lookup[options, PrefilterMaterial],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Filtration -> True, 
				FilterPoreSize -> 0.22 Micrometer,
				Output -> Options
			];
			Lookup[options, FilterPoreSize],
			0.22 Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				PrefilterPoreSize -> Null,
				Output -> Options
			];
			Lookup[options, PrefilterPoreSize],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Specify the syringe used to force that sample through a filter:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				AliquotAmount -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterHousing -> Null,
				Filtration -> True,
				AliquotAmount -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options,FilterIntensity, "Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterIntensity -> 1000 RPM,
				Output -> Options
			];
			Lookup[options, FilterIntensity],
			1000 RPM,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Specify the amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterTime -> 9 Minute,
				Output -> Options
			];
			Lookup[options, FilterTime],
			9 Minute,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterTemperature -> Null,
				Output -> Options
			];
			Lookup[options, FilterTemperature],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Specify the desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterContainerOut -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, FilterContainerOut],
			{
				{1, ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]},
				{2, ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]},
				{3, ObjectReferenceP[Model[Container, Vessel, "50mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCountLiquidParticles[
				{Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				FilterAliquotDestinationWell -> {"A1"},
				Output -> Options
			];
			Lookup[options, FilterAliquotDestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Specify the desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options
			];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterAliquot -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, FilterAliquot],
			15 Milliliter,
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Options, FilterSterile, "Specify indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				FilterSterile -> True,
				Output -> Options
			];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Aliquot, "Specify indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Aliquot -> True,
				Output -> Options
			];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				TargetConcentration -> Null,
				Output -> Options
			];
			Lookup[options, TargetConcentration],
			Null,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Specify the substance whose final concentration is attained with the TargetConcentration option:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				TargetConcentration -> Automatic, 
				TargetConcentrationAnalyte -> Null,
				Output -> Options
			];
			Lookup[options, TargetConcentrationAnalyte],
			Null,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AssayVolume -> 1250 Microliter,
				Output -> Options
			];
			Lookup[options, AssayVolume],
			1250 Microliter,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 100 Microliter,
				AssayVolume -> 1200 Microliter,
				Output -> Options
			];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Specify the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 100 Microliter,
				AssayVolume -> 1200 Microliter,
				Output -> Options
			];
			Lookup[options, BufferDilutionFactor],
			10,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Specify the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 100 Microliter,
				AssayVolume -> 1200 Microliter,
				Output -> Options
			];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], 
				AliquotAmount -> 100 Microliter, 
				AssayVolume -> 1200 Microliter,
				Output -> Options
			];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the options is completed:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AliquotSampleStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Disposal,
			Variables :> {options}
		],
			Example[{Options, ConsolidateAliquots, "Indicates whether identical aliquots should be prepared in the same container/position:"},
			options = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ConsolidateAliquots -> True,
				Output -> Options
			];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight ,"Specify indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MeasureWeight -> True
			];
			Download[protocol, MeasureWeight],
			True,
			Variables :> {protocol}
		],
		Example[{Options, MeasureVolume, "Specify indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				MeasureVolume -> True
			];
			Download[protocol, MeasureVolume],
			True,
			Variables :> {protocol}
		],
		Example[{Options, ImageSample, "Specify indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ImageSample -> False
			];
			Download[protocol, ImageSample],
			False,
			Variables :> {protocol}
		],
		(*--- Messages ---*)
		Example[{Messages, "DiscardedSamples", "Discarded samples cannot be used:"},
			ExperimentCountLiquidParticles[Download[Object[Sample, "Test discarded water sample for ExperimentCountLiquidParticles" <> $SessionUUID], Object]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput,
				Warning::AliquotRequired
			}
		],
		Example[{Messages, "NonLiquidSample", "Solid samples cannot be used:"},
			ExperimentCountLiquidParticles[Object[Sample, "Test solid sample for ExperimentCountLiquidParticles" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::SolidSamplesUnsupported,
				Error::InvalidInput,
				Warning::AliquotRequired
			}
		],
		Example[{Messages, "SyringeAndSyringeSizeMismatchedForCountLiquidParticles", "Syringe and SyringeSize need to be consistent:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Syringe -> Model[Part, Syringe, "10 mL HIAC Injection Syringe"],
				SyringeSize -> 1 Milliliter
			],
			$Failed,
			Messages :> {
				Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SyringeAndSyringeSizeMismatchedForCountLiquidParticles", "Syringe and SyringeSize need to be consistent:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Syringe -> Model[Part, Syringe, "BMG LABTECH Injector Syringe, 500 uL"]
			],
			$Failed,
			Messages :> {
				Error::InvalidSyringeForCountLiquidParticles,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCountLiduiqParticlesMethodRequirements", "Cannot specify Robotic as Preparation:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Preparation -> Robotic,
				Output -> Options
			],
			{_Rule..},
			Messages :> {Error::ConflictingUnitOperationMethodRequirements}
		],
		Example[{Messages, "CountLiquidParticleInvalidDilutionCurveVolumes", "Specified dilution cannot finished experiment:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DiscardFirstRun -> False,
				PreRinseVolume -> 10 Milliliter,
				SerialDilutionCurve -> {5 Milliliter, {0.7, 0.8, 0.6, 0.1}}
			],
			$Failed,
			Messages :> {Error::CountLiquidParticleInvalidDilutionCurveVolumes, Error::InvalidOption}
		],
		Example[{Messages, "CountLiquidParticleUnneededAdjustMixOptions", "If AdjustMixRate is False, related options need to be Null:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AdjustMixRate -> False,
				AcquisitionMixRateIncrement -> 20 RPM
			],
			$Failed,
			Messages :> {Error::CountLiquidParticleUnneededAdjustMixOptions, Error::InvalidOption}
		],
		Example[{Messages, "CountLiquidParticleRequiredAdjustMixOptions", "Specified dilution cannot finished experiment:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AdjustMixRate -> True,
				AcquisitionMixRateIncrement -> Null
			],
			$Failed,
			Messages :> {Error::CountLiquidParticleRequiredAdjustMixOptions, Error::InvalidOption}
		],
		Example[{Messages, "CountLiquidParticleUnneededAcquisitionMixOptions", "If AcquisitionMix is False, related options cannot be specified:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMix -> False,
				AcquisitionMixRate -> 250 RPM
			],
			$Failed,
			Messages :> {Error::CountLiquidParticleUnneededAcquisitionMixOptions, Error::InvalidOption}
		],
		Example[{Messages, "CountLiquidParticleRequiredAcquisitionMixOptions", "If AcquisitionMix is True and MixType is Stir, related options need to be specified:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMix -> True,
				AcquisitionMixType -> Stir,
				AcquisitionMixRate -> Null
			],
			$Failed,
			Messages :> {Error::CountLiquidParticleRequiredAcquisitionMixOptions, Error::InvalidOption}
		],
		If[
			$CountLiquidParticlesAllowHandSwirl,
			Sequence @@ {
				Example[
					{Messages, "CountLiquidParticleRequiredAcquisitionMixOptions", "If AcquisitionMix if True and MixType is Stir, related options need to be specified:"},
					ExperimentCountLiquidParticles[
						{
							Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
						},
						AcquisitionMix -> True,
						AcquisitionMixType -> Swirl,
						NumberOfMixes -> Null
					],
					$Failed,
					Messages :> {Error::CountLiquidParticleRequiredAcquisitionMixOptions, Error::InvalidOption}
				],
				Example[{Messages, "CountLiquidParticleConflictingMixOptions", "If the AcquisitionMixType is Swirl, options for Stir cannot be specified:"},
					ExperimentCountLiquidParticles[
						{
							Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
						},
						AcquisitionMixType -> Swirl,
						AcquisitionMixRate -> 250 RPM
					],
					$Failed,
					Messages :> {Error::CountLiquidParticleConflictingMixOptions, Error::InvalidOption}
				],
				Example[{Messages, "CountLiquidParticleConflictingMixOptions", "If the AcquisitionMixType is Stir, options for Swirl cannot be specified:"},
					ExperimentCountLiquidParticles[
						{
							Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
						},
						AcquisitionMixType -> Stir,
						NumberOfMixes -> 10
					],
					$Failed,
					Messages :> {Error::CountLiquidParticleConflictingMixOptions, Error::InvalidOption}
				]
			},
			Nothing
		],
		Example[{Messages, "CountLiquidParticleRequiredAcquisitionMixOptions", "If AcquisitionMix if True and MixType is Stir, related options need to be specified:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMix -> True,
				AcquisitionMixType -> Stir,
				AcquisitionMixRate -> Null
			],
			$Failed,
			Messages :> {Error::CountLiquidParticleRequiredAcquisitionMixOptions, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingCountLiquidParticlesMethodRequirements", "Dilution options need to be consistent in length:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				DilutionCurve -> {{1.0 Milliliter, 3.0 Milliliter}, {1.5 Milliliter, 2.5 Milliliter}},
				DilutionContainer -> {
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"]
				}
			],
			$Failed,
			Messages :> {
				Error::CountLiquidParticleDilutionContainerLengthMismatch,
				Warning::CountLiquidParticleDilutions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CountLiquidParticleInvalidSamplingHeight", "Sampling height is between stir bar and the min sample height:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				AcquisitionMixType -> Stir,
				SamplingHeight -> {2 Millimeter, 3 Millimeter, 2 Millimeter}
			],
			$Failed,
			Messages :> {
				Error::CountLiquidParticleInvalidSamplingHeight,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CountLiquidParticleLiquidLevelTooLow", "Liquid will not cover the stir bar after data collection is complete:"},
			ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ReadingVolume -> 1.5 Milliliter,
				NumberOfReadings -> 10,
				AcquisitionMixType -> Stir
			],
			$Failed,
			Messages :> {
				Error::CountLiquidParticleLiquidLevelTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CountLiquidParticlesDuplicateParticleSizes", "Throws out an warning when specifying duplicated particle sizes:"},
			protocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				ParticleSizes -> {10 Micrometer, {10 Micrometer, 10 Micrometer, 15 Micrometer, 15 Micrometer, 20 Micrometer}, Automatic}
			];
			Download[protocol, ParticleSizes],
			{
				{
					Quantity[10, "Micrometers"]
				},
				{
					Quantity[10, "Micrometers"],
					Quantity[15, "Micrometers"],
					Quantity[20, "Micrometers"]
				},
				{
					Quantity[20, "Micrometers"]
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::CountLiquidParticlesDuplicateParticleSizes}
		]
	},
	SetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolSetUp :> (
		CleanMemoization[];
		CleanDownload[];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {};
		
		(* Clean up test objects *)
		experimentCountLiquidParticlesCleanUp[];
		
		Module[
			{
				testBench, emptyContainer1, emptyContainer2, waterSample1, emptyPlate1, emptyContainer3, emptyContainer4, emptyContainer5,
				particleSample5Micro1, particleSample10Micro1, particleSample15Micro1, particleSample20Micro1, discardedSample,
				sampleStatusPackets, solidSample, existedMethod, testInstrument, existedProtocol
			},
			
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container,Bench,"The Bench of Testing"], Objects],
				Name -> "Test bench for ExperimentCountLiquidParticles Unit Tests" <> $SessionUUID,
				DeveloperObject -> True
			|>];
			
			(*Build Test Containers*)
			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyPlate1
			} = UploadSample[
				{
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test container 1 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test container 2 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test container 3 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test container 4 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test container 5 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test plate 1 for ExperimentCountLiquidParticles" <> $SessionUUID
				},
				Status -> Available
			];
			
			(* Create some samples *)
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1,
				particleSample15Micro1,
				particleSample20Micro1,
				discardedSample,
				solidSample
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (15 microMeter, Duke Standards)"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (20 microMeter, Duke Standards)"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Sodium Chloride"]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer5},
					{"A1", emptyPlate1},
					{"A1", emptyPlate1}
				},
				InitialAmount -> {
					18 Milliliter,
					18 Milliliter,
					18 Milliliter,
					18 Milliliter,
					18 Milliliter,
					1.5 Milliliter,
					1 Gram
				},
				Name -> {
					"Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test discarded water sample for ExperimentCountLiquidParticles" <> $SessionUUID,
					"Test solid sample for ExperimentCountLiquidParticles" <> $SessionUUID
				},
				Status -> Available,
				StorageCondition -> Model[StorageCondition, "Ambient Storage"]
			];
			
			sampleStatusPackets = UploadSampleStatus[
				Object[Sample, "Test discarded water sample for ExperimentCountLiquidParticles" <> $SessionUUID],
				Discarded,
				Upload -> False
			];

			testInstrument = Upload[<|
				Type -> Object[Instrument, LiquidParticleCounter],
				Name -> "Test instrument for ExperimentCountLiquidParticles" <> $SessionUUID,
				Model -> Link[Model[Instrument, LiquidParticleCounter, "id:eGakldJY3KNn"], Objects],
				ProbeTopPosition -> 26 Centimeter,
				ProbeLowPosition -> 5.625 Inch,
				Cost -> Quantity[22321.17, "USDollars"],
				DateInstalled -> DateObject[{2022, 3, 22, 0, 0, 0.}, "Instant", "Gregorian", -7.],
				DatePurchased -> DateObject[{2021, 10, 17, 0, 0, 0.}, "Instant", "Gregorian", -7.],
				ImageFile -> Link[Object[EmeraldCloudFile, "id:7X104vnVaVEp"]],
				NewStickerPrinted -> True,
				Position -> "Slot 1",
				ProbeStorageContainer -> Link[Object[Container, Vessel, "id:Vrbp1jKmxolb"]],
				RecirculatingPump -> Link[Object[Instrument, RecirculatingPump, "id:BYDOjv1VAajl"]],
				Site -> Link[$Site],
				Software -> "PharmSpec",
				Status -> Available,
				Syringe -> Link[Object[Part, Syringe, "id:Y0lXejMKL3zv"]],
				WasteContainer -> Link[Object[Container, Vessel, "id:KBL5DvwlEYxv"]],
				WasteScale -> Link[Object[Sensor, Weight, "id:N80DNj1YbEKW"], DevicesMonitored],
				Replace[Contents] -> {
					{
						"Sample Slot",
						Link[Object[Container, Vessel, "id:Vrbp1jKmxolb"], Container]
					}
				},
				DeveloperObject -> True
			|>];
			
			existedProtocol = ExperimentCountLiquidParticles[
				{
					Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
					Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]
				},
				Name -> "Existed test protocol for ExperimentCountLiquidParticles" <> $SessionUUID
			];
			
			existedMethod = First[UploadCountLiquidParticlesMethod[
				{Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID]},
				Name -> "Existed test method for ExperimentCountLiquidParticles" <> $SessionUUID
			]];

			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						sampleStatusPackets,
						<|Object -> waterSample1, DeveloperObject -> True|>,
						<|Object -> particleSample5Micro1, DeveloperObject -> True|>,
						<|Object -> particleSample10Micro1, DeveloperObject -> True|>,
						<|Object -> particleSample15Micro1, DeveloperObject -> True|>,
						<|Object -> particleSample20Micro1, DeveloperObject -> True|>,
						<|Object -> discardedSample, DeveloperObject -> True|>,
						<|Object -> solidSample, DeveloperObject -> True|>,
						<|Object -> existedProtocol, DeveloperObject -> True|>,
						<|Object -> existedMethod, DeveloperObject -> True|>
					}
				]
			];
		]
	),
	SymbolTearDown :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		experimentCountLiquidParticlesCleanUp[];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	},
	Parallel -> True
];


(* ::Subsubsection::Closed:: *)
(*experimentCountLiquidParticlesCleanUp*)

experimentCountLiquidParticlesCleanUp[] := Module[{testObjList, existsFilter},
	
	testObjList = {
		Object[Container, Bench, "Test bench for ExperimentCountLiquidParticles Unit Tests" <> $SessionUUID],
		Object[Container, Vessel, "Test container 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Container, Vessel, "Test container 2 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Container, Vessel, "Test container 3 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Container, Vessel, "Test container 4 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Container, Vessel, "Test container 5 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Container, Plate, "Test plate 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test water sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test discarded water sample for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test 15 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test 20 micro meter particle sample 1 for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test solid sample for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Instrument, LiquidParticleCounter, "Test instrument for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Protocol, CountLiquidParticles, "Existed test protocol for ExperimentCountLiquidParticles" <> $SessionUUID],
		Object[Method, LiquidParticleCounting, "Existed test method for ExperimentCountLiquidParticles" <> $SessionUUID]
	};
	
	existsFilter = DatabaseMemberQ /@ testObjList;
	EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False]
];

(* ::Subsubsection::Closed:: *)
(*CountLiquidParticles*)


DefineTests[
	CountLiquidParticles,
	{
		Example[{Basic, "Measure the liquid particle count of a single sample:"},
			Experiment[
				{
					CountLiquidParticles[
						Sample -> {
							Object[Sample, "Test water sample 1 for CountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 5 micro meter particle sample 1 for CountLiquidParticles" <> $SessionUUID],
							Object[Sample, "Test 10 micro meter particle sample 1 for CountLiquidParticles" <> $SessionUUID]
						}
					]
				}
			],
			ObjectP[Object[Protocol, ManualCellPreparation]],
			TimeConstraint -> 1000
		],
		Example[{Basic, "Enqueue a series of primitives:"},
			ExperimentManualSamplePreparation[
				{
					
					LabelContainer[
						Label -> "Sample Vessel 1",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 40 Milliliter,
						Destination -> "Sample Vessel 1",
						DestinationLabel -> "CLP Sample 1"
					],
					LabelContainer[
						Label -> "Sample Vessel 2",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 40 Milliliter,
						Destination -> "Sample Vessel 2",
						DestinationLabel -> "CLP Sample 2"
					],
					CountLiquidParticles[
						Sample -> {
							"CLP Sample 1",
							"CLP Sample 2"
						}
					]
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Example[{Basic, "Cannot run as Robotic Primitives:"},
			ExperimentRoboticSamplePreparation[
				{
					LabelContainer[
						Label -> "Sample Vessel 1",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 40 Milliliter,
						Destination -> "Sample Vessel 1",
						DestinationLabel -> "CLP Sample 1"
					],
					LabelContainer[
						Label -> "Sample Vessel 2",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 40 Milliliter,
						Destination -> "Sample Vessel 2",
						DestinationLabel -> "CLP Sample 2"
					],
					CountLiquidParticles[
						Sample -> {
							"CLP Sample 1",
							"CLP Sample 2"
						}
					]
				}
			],
			$Failed,
			Messages :> {
				Error::InvalidUnitOperationHeads,
				Error::InvalidInput
			},
			TimeConstraint -> 1000
		]
	},
	SymbolSetUp :> (
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects = {};
		
		(* Clean up test objects *)
		countLiquidParticlesCleanUp[];
		
		Module[
			{
				testBench, emptyContainer1, emptyContainer2, waterSample1, emptyContainer3, particleSample5Micro1,
				particleSample10Micro1
			},
			
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for CountLiquidParticles Unit Tests" <> $SessionUUID,
				DeveloperObject -> True
			|>];
			
			(*Build Test Containers*)
			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			} = UploadSample[
				{
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test container 1 for CountLiquidParticles" <> $SessionUUID,
					"Test container 2 for CountLiquidParticles" <> $SessionUUID,
					"Test container 3 for CountLiquidParticles" <> $SessionUUID
				},
				Status -> Available
			];
			
			(* Create some samples *)
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3}
				},
				InitialAmount -> {
					18 Milliliter,
					18 Milliliter,
					18 Milliliter
				},
				Name -> {
					"Test water sample 1 for CountLiquidParticles" <> $SessionUUID,
					"Test 5 micro meter particle sample 1 for CountLiquidParticles" <> $SessionUUID,
					"Test 10 micro meter particle sample 1 for CountLiquidParticles" <> $SessionUUID
				},
				Status -> Available,
				StorageCondition -> Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object -> waterSample1, DeveloperObject -> True|>,
						<|Object -> particleSample5Micro1, DeveloperObject -> True|>,
						<|Object -> particleSample10Micro1, DeveloperObject -> True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose ->False];
		countLiquidParticlesCleanUp[];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(*countLiquidParticlesCleanUp*)

countLiquidParticlesCleanUp[] := Module[{testObjList, existsFilter},
	
	testObjList = {
		Object[Container, Bench, "Test bench for CountLiquidParticles Unit Tests" <> $SessionUUID],
		Object[Container, Vessel, "Test container 1 for CountLiquidParticles" <> $SessionUUID],
		Object[Container, Vessel, "Test container 2 for CountLiquidParticles" <> $SessionUUID],
		Object[Container, Vessel, "Test container 3 for CountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test water sample 1 for CountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for CountLiquidParticles" <> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for CountLiquidParticles" <> $SessionUUID]
	};
	
	existsFilter = DatabaseMemberQ /@ testObjList;
	EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False]
];