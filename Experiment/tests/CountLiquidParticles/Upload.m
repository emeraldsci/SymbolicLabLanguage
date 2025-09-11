(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadCountLiquidParticlesMethod*)


(* ::Subsubsection:: *)
(*UploadCountLiquidParticlesMethod*)


DefineTests[UploadCountLiquidParticlesMethod,
	{
		Example[{Basic,"Upload new method for ExperimentCountLiquidParticles:"},
			UploadCountLiquidParticlesMethod[
				{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				}
			],
			{
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]]
			}
		],
		Example[
			{Options,Name,"Specify for each member SamplesIn, the name of the method that will be uploaded:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				Name-> {
					"Test 1" <>$SessionUUID,
					"Test 2" <>$SessionUUID,
					"Test 3" <>$SessionUUID,
					"Test 4" <>$SessionUUID
				}
			];
			Download[methods,Name],
			{
				"Test 1" <>$SessionUUID,
				"Test 2" <>$SessionUUID,
				"Test 3" <>$SessionUUID,
				"Test 4" <>$SessionUUID
			},
			Variables:>{methods}
		],
		Example[
			{Options,Syringe,"Specify the syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and out of the system:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"]
			];
			Download[methods,Syringe],
			{
				LinkP[Model[Part,Syringe,"10 mL HIAC Injection Syringe"]],
				LinkP[Model[Part,Syringe,"10 mL HIAC Injection Syringe"]],
				LinkP[Model[Part,Syringe,"10 mL HIAC Injection Syringe"]],
				LinkP[Model[Part,Syringe,"10 mL HIAC Injection Syringe"]]
			},
			Variables:>{methods}
		],
		Example[
			{Options,SyringeSize,"Specify the size of the syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and flush it back out:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				SyringeSize->10Milliliter
			];
			Download[methods,SyringeSize],
			{
				10Milliliter,
				10Milliliter,
				10Milliliter,
				10Milliliter
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ParticleSizes,"Specify the collection of ranges (5 Micrometer to 100 Micromter) the different particle sizes that monitored:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				ParticleSizes->{
					{20Micrometer,25Micrometer},
					{20Micrometer,25Micrometer},
					{20Micrometer,25Micrometer},
					{20Micrometer,25Micrometer}
			}
			];
			Download[methods,ParticleSizes],
			{
				{20Micrometer,25Micrometer},
				{20Micrometer,25Micrometer},
				{20Micrometer,25Micrometer},
				{20Micrometer,25Micrometer}
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DilutionCurve,"Specify the collection of dilutions that will be performed on the samples before light obscuration measurements are taken. For Fixed Dilution Volume Dilution Curves, the Sample Amount is the volume of the sample that will be mixed with the Diluent Volume of the Diluent to create the desired concentration. For Fixed Dilution Factor Dilution Curves, the Sample Volume is the volume of the sample that will created after being diluted by the Dilution Factor. For example, a 1M sample with a dilution factor of 0.7 will be diluted to a concentration 0.7M. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DilutionCurve->{
					{2.0Milliliter,0.5Milliliter},
					{2.5Milliliter,0.5Milliliter},
					{2.5Milliliter,0.5Milliliter},
					{3.0Milliliter,0.5Milliliter}
				}
			];
			Download[methods,DilutionCurve],
			{{{Quantity[2, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[3, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}}, {{Quantity[2, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[3, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}}, {{Quantity[2, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[3, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}}, {{Quantity[2, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[2.5`, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}, {Quantity[3, "Milliliters"],
				Quantity[0.5`, "Milliliters"]}}},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SerialDilutionCurve,"Specify the collection of serial dilutions that will be performed on the samples before light obscuration measurements are taken. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 ug/ ml sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 25 ug/ ml, 6.25 ug/ ml, and 1.5625 ug/ ml with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				SerialDilutionCurve->{
				{5Milliliter,{0.7,0.8,0.6,0.1}},
				{5Milliliter,{0.7,0.8,0.6,0.1}},
				{5Milliliter,{0.7,0.8,0.6,0.1}},
				{5Milliliter,{0.7,0.8,0.6,0.1}}
			}
			];
			Download[methods,SerialDilutionCurve],
			{
				{5Milliliter,{0.7,0.8,0.6,0.1}},
				{5Milliliter,{0.7,0.8,0.6,0.1}},
				{5Milliliter,{0.7,0.8,0.6,0.1}},
				{5Milliliter,{0.7,0.8,0.6,0.1}}
			},
			Variables:>{methods}
		],
		Example[
			{Options,Diluent,"Specify the solution that is used to dilute the sample to generate a DilutionCurve or SerialDilutionCurve:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				Diluent->Model[Sample, "Methanol"]
			];
			Download[methods,Diluent],
			{
				LinkP[Model[Sample, "Methanol"]],
				LinkP[Model[Sample, "Methanol"]],
				LinkP[Model[Sample, "Methanol"]],
				LinkP[Model[Sample, "Methanol"]]
			},
			Variables:>{methods}
		],
		Example[
			{Options,DilutionContainer,"Specify the containers in which each sample is diluted with the Diluent to make the concentration series, with indices indicating specific grouping of samples if desired:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DilutionContainer-> {Model[Container, Vessel, "50mL Tube"]}
			];
			Download[methods,DilutionContainer],
			{
				{
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]]
				},
				{
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]]
				},
				{
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]]
				},
				{
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]],
					LinkP[Model[Container, Vessel, "50mL Tube"]]
				}
			},
			Variables:>{methods}
		],
		Example[
			{Options,DilutionStorageCondition,"Specify the conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DilutionStorageCondition->Disposal
			];
			Download[methods,DilutionStorageCondition],
			{
				Disposal,
				Disposal,
				Disposal,
				Disposal
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DilutionMixVolume,"Specify the volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DilutionMixVolume->{
				500Microliter,
				500Microliter,
				500Microliter,
				500Microliter
			}
			];
			Download[methods,DilutionMixVolume],
			{
				500Microliter,
				500Microliter,
				500Microliter,
				500Microliter
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DilutionNumberOfMixes,"Specify the number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DilutionNumberOfMixes->{
				3,
				3,
				3,
				3
			}
			];
			Download[methods,DilutionNumberOfMixes],
			{
				3,
				3,
				3,
				3
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DilutionMixRate,"Specify the speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DilutionMixRate->{
				400Microliter/Second,
				400Microliter/Second,
				400Microliter/Second,
				400Microliter/Second
			}
			];
			Download[methods,DilutionMixRate],
			{
				400Microliter/Second,
				400Microliter/Second,
				400Microliter/Second,
				400Microliter/Second
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ReadingVolume,"Specify the volume of sample that is loaded into the instrument and used to determine particle size and count. If the reading volume exceeds the volume of the syringe the instruments will perform multiple strokes to cover the full reading volume:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				ReadingVolume->{
				201Microliter,
				201Microliter,
				201Microliter,
				201Microliter
			}
			];
			Download[methods,ReadingVolume],
			{
				201Microliter,
				201Microliter,
				201Microliter,
				201Microliter
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SampleTemperature,"Specify the temperature of the instrument's sampler tray where samples are equilibrated just prior to the injection:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				SampleTemperature->30Celsius
			];
			Download[methods,SampleTemperature],
			{
				30Celsius,
				30Celsius,
				30Celsius,
				30Celsius
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,EquilibrationTime,"Specify the length of time for which each sample is incubated at the requested SampleTemperature just prior to being read:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				EquilibrationTime->4Minute
			];
			Download[methods,EquilibrationTime],
			{
				4Minute,
				4Minute,
				4Minute,
				4Minute
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,NumberOfReading,"Specify the number of times the liquid particle count is read by passing ReadingVolume through the light obscuration sensor:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				NumberOfReadings->3
			];
			Download[methods,NumberOfReadings],
			{3,3,3,3},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,PreRinseVolume,"Specify the volume of the sample flown into the syringe tubing to rinse out the lines with each new sample before beginning the reading:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				PreRinseVolume->{
				1Milliliter,
				1Milliliter,
				1Milliliter,
				1Milliliter
			}
			];
			Download[methods,PreRinseVolume],
			{
				1Milliliter,
				1Milliliter,
				1Milliliter,
				1Milliliter
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DiscardFirstRun,"Specify indicate during the data collection, the data collection starts from the 2nd reading, the first reading will be discarded. Setting this to true will increase the reproducibility of data collection:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				DiscardFirstRun->False
			];
			Download[methods,DiscardFirstRun],
			{
				False,
				False,
				False,
				False
			},
			Variables:>{methods}
		],
		Example[
			{Options,SamplingHeight,"Specify the height of the probe during data collection:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				SamplingHeight->20Millimeter
			];
			Download[methods,SamplingHeight],
			{
				20Millimeter,
				20Millimeter,
				20Millimeter,
				20Millimeter
			},
			Variables:>{methods},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,AcquisitionMix,"Specify indicates whether the samples should be mixed with a stir bar during data acquisition:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				AcquisitionMix->False
			];
			Download[methods,AcquisitionMix],
			{
				False,
				False,
				False,
				False
			},
			Variables:>{methods}
		],
		Example[
			{Options, AcquisitionMixType, "Specify the mix type:"},
			methods = UploadCountLiquidParticlesMethod[{
				Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
				Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
				Object[Sample, "Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
				Object[Sample, "Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
			},
				AcquisitionMixType -> Stir
			];
			Download[methods, AcquisitionMixType],
			{Stir, Stir, Stir, Stir},
			Variables :> {methods}
		],
		If[
			$CountLiquidParticlesAllowHandSwirl,
			Sequence@@{
				Example[
					{Options, AcquisitionMixType, "Specify the mix type:"},
					methods = UploadCountLiquidParticlesMethod[{
						Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
					},
						AcquisitionMixType -> {Swirl, Stir, Stir, Swirl}
					];
					Download[methods, AcquisitionMixType],
					{Swirl, Stir, Stir, Swirl},
					Variables :> {methods}
				],
				Example[
					{Options, NumberOfMixes, "Specify the number of mixes if the AcquisitionMixType is Swirl:"},
					methods = UploadCountLiquidParticlesMethod[{
						Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
					},
						AcquisitionMixType -> Swirl,
						NumberOfMixes -> {1, 2, 3, 4}
					];
					Download[methods, NumberOfMixes],
					{1, 2, 3, 4},
					Variables :> {methods}
				],
				Example[
					{Options, WaitTimeBeforeReading, "Specify how long the sample will be placed without any stirring before the data collection starts:"},
					methods = UploadCountLiquidParticlesMethod[{
						Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
						Object[Sample, "Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
					},
						AcquisitionMixType -> Swirl,
						WaitTimeBeforeReading -> {1Minute, 2Minute, 3Minute, 4Minute}
					];
					Download[methods, WaitTimeBeforeReading],
					{1Minute, 2Minute, 3Minute, 4Minute},
					Variables :> {methods},
					EquivalenceFunction -> Equal
				]
			},
			Nothing
		],
		Example[
			{Options,StirBar,"Specify indicates the stir bar used to agitate the sample during acquisition:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				StirBar->{
				Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"],
				Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"],
				Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"],
				Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]
			}
			];
			Download[methods,StirBar],
			{
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]],
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]],
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]],
				LinkP[Model[Part, StirBar, "0.625 Inch Egg-shaped Stir Bar"]]
			},
			Variables:>{methods}
		],
		Example[
			{Options,AcquisitionMixRate,"Specify indicates the rate at which the samples should be mixed with a stir bar during data acquisition:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				AcquisitionMixRate->{
				250RPM,
				250RPM,
				250RPM,
				250RPM
			}
			];
			Download[methods,AcquisitionMixRate],
			{
				250RPM,
				250RPM,
				250RPM,
				250RPM
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,AdjustMixRate,"Specify When using a stir bar, if specified AcquisitionMixRate does not provide a stable or consistent circular rotation of the magnetic bar, indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples. If stir bar is wiggling, decrease AcquisitionMixRate by AcquisitionMixRateIncrement and check if the stir bar is still wiggling. If it is, decrease by AcquisitionMixRateIncrement again. If still wiggling, repeat decrease until MaxStirAttempts. If the stir bar is not moving/stationary, increase the AcquisitionMixRate by AcquisitionMixRateIncrement and check if the stir bar is still stationary. If it is, increase by AcquisitionMixRateIncrement again. If still stationary, repeat increase until MaxStirAttempts. Mixing will occur during data acquisition. After MaxStirAttempts, if stable stirring was not achieved, StirringError will be set to True in the methods object:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				AdjustMixRate->True
			];
			Download[methods,AdjustMixRate],
			{
				True,
				True,
				True,
				True
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,MinAcquisitionMixRate,"Specify Sets the lower limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar if AdjustMixRate is True:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				MinAcquisitionMixRate->{
				100RPM,
				100RPM,
				100RPM,
				100RPM
			}
			];
			Download[methods,MinAcquisitionMixRate],
			{
				100RPM,
				100RPM,
				100RPM,
				100RPM
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,MaxAcquisitionMixRate,"Specify Sets the upper limit stirring rate to be increased to for sample mixing while attempting to mix the samples with a stir bar if AdjustMixRate is True:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				MaxAcquisitionMixRate->{
				300RPM,
				300RPM,
				300RPM,
				300RPM
			}
			];
			Download[methods,MaxAcquisitionMixRate],
			{
				300RPM,
				300RPM,
				300RPM,
				300RPM
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,AcquisitionMixRateIncrement,"Specify indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				AcquisitionMixRateIncrement->{
				10RPM,
				10RPM,
				10RPM,
				10RPM
			}
			];
			Download[methods,AcquisitionMixRateIncrement],
			{
				10RPM,
				10RPM,
				10RPM,
				10RPM
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,MaxStirAttempts,"Specify indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				MaxStirAttempts->{
				5,
				5,
				5,
				5
			}
			];
			Download[methods,MaxStirAttempt],
			{
				5,
				5,
				5,
				5
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,WashSolution,"Specify for each member of SamplesIn, the solution pumped through the instrument's flow path to clean it between the loading of each new sample:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				WashSolution->Model[Sample, "Milli-Q water"]
			];
			Download[methods,WashSolution],
			{
				LinkP[Model[Sample, "Milli-Q water"]],
				LinkP[Model[Sample, "Milli-Q water"]],
				LinkP[Model[Sample, "Milli-Q water"]],
				LinkP[Model[Sample, "Milli-Q water"]]
			},
			Variables:>{methods}
		],
		Example[
			{Options,WashSolutionTemperature,"Specify for each member of SamplesIn, the temperature to which the WashSolution is preheated before flowing it through the flow path:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				WashSolutionTemperature->40Celsius
			];
			Download[methods,WashSolutionTemperature],
			{
				40Celsius,
				40Celsius,
				40Celsius,
				40Celsius
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,WashEquilibrationTime,"Specify for each member of SamplesIn, the length of time for which the wash solution container equilibrate at the requested WashSolutionTemperature in the sample rack before being pumped through the instrument's flow path:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				WashEquilibrationTime->{
				7Minute,
				7Minute,
				7Minute,
				7Minute
			}
			];
			Download[methods,WashEquilibrationTime],
			{
				7Minute,
				7Minute,
				7Minute,
				7Minute
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,WashWaitTime,"Specify for each member of SamplesIn, the amount of time for which the syringe is allowed to soak with each wash solution before flushing it to the waste:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				WashWaitTime->{
					1Minute,
					1Minute,
					1Minute,
					1Minute
				}
			];
			Download[methods,WashWaitTime],
			{
				1Minute,
				1Minute,
				1Minute,
				1Minute
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,NumberOfWash,"Specify for each member SamplesIn, the number of times each wash solution is pumped through the instrument's flow path:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				NumberOfWash->1
			];
			Download[methods,NumberOfWash],
			{
				1,
				1,
				1,
				1
			},
			Variables:>{methods},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Output,"Specify indicate what the function should return:"},
			UploadCountLiquidParticlesMethod[{
				Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
				Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
				Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
				Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
			},
				Output->Options
			],
			{_Rule..}
		],
		Example[
			{Options,Simulation,"Specify the Simulation that contains any simulated objects that should be used:"},
			UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				Simulation->Null
			],
			{
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]]
			},
			Variables:>{methods}
		],
		Example[
			{Options,Upload,"Specify indicates if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
			methods=UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				Upload->False
			];
			ValidUploadQ[methods],
			True,
			Variables:>{methods}
		],
		Example[
			{Options,Cache,"Specify list of pre-downloaded packets to be used before checking for session cached object or downloading any object information from the server:"},
			UploadCountLiquidParticlesMethod[{
					Object[Sample,"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID],
					Object[Sample,"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod" <> $SessionUUID]
				},
				Cache->{Null}
			],
			{
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]],
				ObjectP[Object[Method, LiquidParticleCounting]]
			}
		]
		
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::AliquotRequired];
		CleanMemoization[];
		CleanDownload[];

		$CreatedObjects={};
		
		(* Clean up test objects *)
		uploadCountLiquidParticlesMethodCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,
				emptyContainer4,emptyContainer5,particleSample5Micro1,
				particleSample10Micro1,particleSample15Micro1,
				particleSample20Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for UploadCountLiquidParticlesMethod Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for UploadCountLiquidParticlesMethod"<>$SessionUUID,
					"Test container 2 for UploadCountLiquidParticlesMethod"<>$SessionUUID,
					"Test container 3 for UploadCountLiquidParticlesMethod"<>$SessionUUID,
					"Test container 4 for UploadCountLiquidParticlesMethod"<>$SessionUUID,
					"Test container 5 for UploadCountLiquidParticlesMethod"<>$SessionUUID
				},
				Status->Available
			];
			
			
			
			(* Create some samples *)
			
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1,
				particleSample15Micro1,
				particleSample20Micro1
				
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Milli-Q water"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
					Model[Sample, "Milli-Q water"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (15 microMeter, Duke Standards)"]*)
					Model[Sample, "Milli-Q water"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (20 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3},
					{"A1",emptyContainer4},
					{"A1",emptyContainer5}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				Name->{
					"Test water sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID,
					"Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID,
					"Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,DeveloperObject->True|>,
						<|Object->particleSample15Micro1,DeveloperObject->True|>,
						<|Object->particleSample20Micro1,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:> (
		On[Warning::AliquotRequired];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		uploadCountLiquidParticlesMethodCleanUp[];
	)
];

(* ::Subsubsection::Closed:: *)
(*uploadCountLiquidParticlesMethodCleanUp*)

uploadCountLiquidParticlesMethodCleanUp[]:=Module[
	{testObjList,existsFilter},
	
	testObjList = {
		Object[Container,Bench,"Test bench for UploadCountLiquidParticlesMethod Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for UploadCountLiquidParticlesMethod"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for UploadCountLiquidParticlesMethod"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for UploadCountLiquidParticlesMethod"<>$SessionUUID],
		Object[Container, Vessel, "Test container 4 for UploadCountLiquidParticlesMethod"<>$SessionUUID],
		Object[Container, Vessel, "Test container 5 for UploadCountLiquidParticlesMethod"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID],
		Object[Sample, "Test 15 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID],
		Object[Sample, "Test 20 micro meter particle sample 1 for UploadCountLiquidParticlesMethod"<> $SessionUUID],
		Object[Protocol, CountLiquidParticles, "Existed test methods for UploadCountLiquidParticlesMethod"<>$SessionUUID]
	};
	
	existsFilter = DatabaseMemberQ /@ testObjList;
	EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False]
];





(* ::Subsection:: *)
(*UploadCountLiquidParticlesMethodPreview*)


DefineTests[
	UploadCountLiquidParticlesMethodPreview,
	{
		Example[{Basic,"No preview is currently available for UploadCountLiquidParticlesMethod:"},
			UploadCountLiquidParticlesMethodPreview[
				{
					Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID]
				}
			],
			Null
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			UploadCountLiquidParticlesMethodOptions[
				{
					Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"],
				SyringeSize->1Milliliter
			],
			_Grid,
			Messages:>{
				Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles,
				Error::InvalidOption
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			UploadCountLiquidParticlesMethodOptions[
				{
					Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID]
				},
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::AliquotRequired];
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects={};
		
		(* Clean up test objects *)
		uploadCountLiquidParticlesMethodPreviewCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,particleSample5Micro1,
				particleSample10Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for UploadCountLiquidParticlesMethodPreview Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for UploadCountLiquidParticlesMethodPreview"<>$SessionUUID,
					"Test container 2 for UploadCountLiquidParticlesMethodPreview"<>$SessionUUID,
					"Test container 3 for UploadCountLiquidParticlesMethodPreview"<>$SessionUUID
				},
				Status->Available
			];
			
			(* Create some samples *)
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				Name->{
					"Test water sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::AliquotRequired];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		uploadCountLiquidParticlesMethodPreviewTestObjectsCleanup[];
		Unset[$CreatedObjects]
	]
];


(* ::Subsubsection:: *)
(*uploadCountLiquidParticlesMethodPreviewTestObjectsCleanup*)

uploadCountLiquidParticlesMethodPreviewTestObjectsCleanup[]:=Module[
	{allObjs, existingObjs},
	
	allObjs = {
		Object[Container,Bench,"Test bench for UploadCountLiquidParticlesMethodPreview Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for UploadCountLiquidParticlesMethodPreview"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for UploadCountLiquidParticlesMethodPreview"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for UploadCountLiquidParticlesMethodPreview"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodPreview"<> $SessionUUID]
	};
	
	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
];


(* ::Subsection:: *)
(*UploadCountLiquidParticlesMethodOptions*)

DefineTests[
	UploadCountLiquidParticlesMethodOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			UploadCountLiquidParticlesMethodOptions[
				{
					Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID]
				}
			],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			UploadCountLiquidParticlesMethodOptions[
				{
					Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"],
				SyringeSize->1Milliliter
			],
			_Grid,
			Messages:>{
				Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles,
				Error::InvalidOption
			}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			UploadCountLiquidParticlesMethodOptions[
				{
					Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID]
				},
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::AliquotRequired];
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects={};
		
		(* Clean up test objects *)
		uploadCountLiquidParticlesMethodOptionsCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,particleSample5Micro1,
				particleSample10Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for UploadCountLiquidParticlesMethodOptions Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for UploadCountLiquidParticlesMethodOptions"<>$SessionUUID,
					"Test container 2 for UploadCountLiquidParticlesMethodOptions"<>$SessionUUID,
					"Test container 3 for UploadCountLiquidParticlesMethodOptions"<>$SessionUUID
				},
				Status->Available
			];
			
			(* Create some samples *)
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				Name->{
					"Test water sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::AliquotRequired];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		uploadCountLiquidParticlesMethodOptionsCleanUp[];
		Unset[$CreatedObjects]
	]
];


(* ::Subsubsection:: *)
(*uploadCountLiquidParticlesMethodOptionsCleanUp*)

uploadCountLiquidParticlesMethodOptionsCleanUp[]:=Module[
	{allObjs, existingObjs},
	
	allObjs = {
		Object[Container,Bench,"Test bench for UploadCountLiquidParticlesMethodOptions Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for UploadCountLiquidParticlesMethodOptions"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for UploadCountLiquidParticlesMethodOptions"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for UploadCountLiquidParticlesMethodOptions"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for UploadCountLiquidParticlesMethodOptions"<> $SessionUUID]
	};
	
	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
];



(* ::Subsection:: *)
(*ValidUploadCountLiquidParticlesMethodQ*)

DefineTests[
	ValidUploadCountLiquidParticlesMethodQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidUploadCountLiquidParticlesMethodQ[
				{
					Object[Sample, "Test water sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID]
				}
			],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidUploadCountLiquidParticlesMethodQ[
				{
					Object[Sample, "Test water sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID]
				},
				Syringe->Model[Part,Syringe,"10 mL HIAC Injection Syringe"],
				SyringeSize->1Milliliter
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidUploadCountLiquidParticlesMethodQ[
				{
					Object[Sample, "Test water sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID]
				},
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidUploadCountLiquidParticlesMethodQ[
				{
					Object[Sample, "Test water sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 5 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
					Object[Sample, "Test 10 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID]
				},
				Verbose->True
			],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		
		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::AliquotRequired];
		CleanMemoization[];
		CleanDownload[];
		
		$CreatedObjects={};
		
		(* Clean up test objects *)
		validUploadCountLiquidParticlesMethodQCleanUp[];
		
		Module[
			{
				fakeBench,emptyContainer1,emptyContainer2,
				waterSample1,emptyContainer3,particleSample5Micro1,
				particleSample10Micro1
			},
			
			fakeBench=Upload[
				<|Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for ValidUploadCountLiquidParticlesMethodQ Unit Tests"<>$SessionUUID,
					DeveloperObject->True|>
			];
			
			(*Build Test Containers*)
			{
				
				emptyContainer1,
				emptyContainer2,
				emptyContainer3
			}=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Name->{
					"Test container 1 for ValidUploadCountLiquidParticlesMethodQ"<>$SessionUUID,
					"Test container 2 for ValidUploadCountLiquidParticlesMethodQ"<>$SessionUUID,
					"Test container 3 for ValidUploadCountLiquidParticlesMethodQ"<>$SessionUUID
				},
				Status->Available
			];
			
			(* Create some samples *)
			
			{
				waterSample1,
				particleSample5Micro1,
				particleSample10Micro1
			}=UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"],(*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (5 microMeter, Duke Standards)"]*)
					Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"](*Model[Sample, "Poly(Styrene-co-DivinylBenzene) Uniform Particles (10 microMeter, Duke Standards)"]*)
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				Name->{
					"Test water sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID,
					"Test 5 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID,
					"Test 10 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID
				},
				Status->Available,
				StorageCondition->Model[StorageCondition, "Ambient Storage"]
			];
			
			
			(* Make some changes to the samples *)
			Upload[
				Flatten[
					{
						<|Object->waterSample1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample5Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>,
						<|Object->particleSample10Micro1,ExpirationDate -> Now + 1 Year,DeveloperObject->True|>
					}
				]
			];
		
		]
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::AliquotRequired];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		validUploadCountLiquidParticlesMethodQCleanUp[];
		Unset[$CreatedObjects]
	]
];

(* ::Subsubsection:: *)
(*validUploadCountLiquidParticlesMethodQCleanUp*)

validUploadCountLiquidParticlesMethodQCleanUp[]:=Module[
	{allObjs, existingObjs},
	
	allObjs = {
		Object[Container,Bench,"Test bench for ValidUploadCountLiquidParticlesMethodQ Unit Tests"<>$SessionUUID],
		
		Object[Container, Vessel, "Test container 1 for ValidUploadCountLiquidParticlesMethodQ"<>$SessionUUID],
		Object[Container, Vessel, "Test container 2 for ValidUploadCountLiquidParticlesMethodQ"<>$SessionUUID],
		Object[Container, Vessel, "Test container 3 for ValidUploadCountLiquidParticlesMethodQ"<>$SessionUUID],
		
		Object[Sample, "Test water sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
		Object[Sample, "Test 5 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID],
		Object[Sample, "Test 10 micro meter particle sample 1 for ValidUploadCountLiquidParticlesMethodQ"<> $SessionUUID]
	};
	
	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
]
