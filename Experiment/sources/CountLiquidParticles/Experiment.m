(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ExperimentCountLiquidParticles Options*)

DefineOptions[ExperimentCountLiquidParticles,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the samples to be inspected, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->SampleContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the container of the samples to be inspected, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			}
		],
		{
			OptionName->Instrument,
			Default->Model[Instrument, LiquidParticleCounter, "HIAC 9703 Plus"],
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,LiquidParticleCounter], Object[Instrument,LiquidParticleCounter]}](*,
				OpenPaths ->
					{
						Object[Catalog, "Root"],
						"Instruments","Particle Counters"
					}*)
			],
			Description->"The instrument used to detect and count particles in a sample using light obscuration while flowing the sample through a flow cell.",
			Category->"General"
		},
		{
			OptionName->Sensor,
			Default->Model[Part,LightObscurationSensor,"2-400 um"],
			AllowNull->False,
			Widget -> Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Part,LightObscurationSensor],Model[Part,LightObscurationSensor]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Particle Analyzers",
						"Light Obscuration Particle Counters"
					}
				}
			],
			Description->"The light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count. The sensor sets the range of the particle sizes that can be detected.",
			Category->"General"
		},
		{
			OptionName->Syringe, 	(*FlowRate is it changes with the different syringe sizes? until Dec 28*)
			Default->Automatic,
			AllowNull->False,
			Widget -> Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Part,Syringe],Model[Part,Syringe]}](*,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Experiment Objects","HIAC Liquid Particle Counting", "Syringes"
					}
				}*)
			],
			Description->"The syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and out of the system.",
			ResolutionDescription->"Automatically set based on the SyringeSize",
			Category->"General"
		},
		{
			OptionName -> SyringeSize,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> HIACSyringeSizeP],
			Description -> "The size of the syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and flush it back out.",
			ResolutionDescription -> "Automatically set to the 1 mL syringe if the sample volume is less and equal than 5 mL, and the 10 mL syringe otherwise.",
			Category -> "General"
		},
		
		IndexMatching[
			IndexMatchingInput->"experiment samples",
	
			(* --- General --- *)
			{
				OptionName -> Method,
				Default -> Custom,
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, LiquidParticleCounting]](*,
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Experiment Objects","HIAC Liquid Particl Counting", "Methods"
							}
						}*)
	
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Custom]
					]
				],
				Description -> "The light obscuration standard procedure method object that describes the conditions for liquid particle counting. See figure x.x for examples of some standard methods."
			},
			{
				OptionName->SaveCustomMethod,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicate if Method is specified as Custom, or the specified method is modified, the new method will be saved.",
				Description->"Automatically set to True if Method is Custom, or if Method is specified, but any related option value is changed.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->ParticleSizes,
				Default -> Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					Adder[
						Widget[
							Type->Quantity,
							Pattern :> RangeP[1 Micrometer, 100 Micrometer],
							Units -> Micrometer
						]
					],
					Widget[
						Type->Quantity,
						Pattern :> RangeP[1 Micrometer, 100 Micrometer],
						Units -> Micrometer
					]
				],
				Description -> "The collection of ranges (5 Micrometer to 100 Micromter) the different particle sizes that monitored.",
				Category-> "General"
			}
		],

		(* --- Prime --- *)
		IndexMatching[
			IndexMatchingParent->PrimeSolutions,
			{
				OptionName->PrimeSolutions,
				Default->Model[Sample, "Milli-Q water"],
				AllowNull->False,
				Widget-> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
				(*,
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Experiment Objects","HIAC Liquid Particle Counting","Cleaning Solutions"
					}
				}*)
				Description->"The solution(s) pumped through the instrument's flow path prior to the loading and measuring samples.",
				Category->"Priming"
			},
			{
				OptionName -> PrimeSolutionTemperatures,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[0*Celsius, 80*Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Category -> "Priming",
				Description -> "For each member of PrimeSolutions, the temperature to which the PrimeSolutions is preheated before flowing it through the flow path.",
				ResolutionDescription->"Automatically set to the first value of SampleTemperatures.",
				ResolutionDescription -> "Automatically set to Ambient."
			},
			{
				OptionName->PrimeEquilibrationTime,
				Default->Automatic,
				Description->"For each member of PrimeSolutions, the length of time for which the prime solution container equilibrate at the requested PrimeSolutionTemperatures in the sample rack before being pumped through the instrument's flow path.",
				ResolutionDescription->"Automatically set to 5 minutes if the PrimeSolutionTemperatures is not Ambient.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second, $MaxExperimentTime],
					Units:>{1,{Minute,{Second,Minute,Hour}}}
				],
				Category->"Priming"
			},
			{
				OptionName -> PrimeWaitTime,
				Default -> 0 Minute,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units -> {Second, {Second, Minute, Hour}}]
				],
				Category -> "Priming",
				Description -> "For each member of PrimeSolutions, the amount of time for which the syringe is allowed to soak with each prime solutions before flushing it to the waste."
			},
			{
				OptionName ->NumberOfPrimes,
				Default -> 1,
				AllowNull -> False,
				Widget ->Widget[
					Type->Number,
					Pattern:>RangeP[1,10,1]
				],
				Category -> "Priming",
				Description -> "For each member of PrimeSolutions, the number of times each prime solution pumped through the instrument's flow path."
			}
		],


		(*--- Sample Preparation ---*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			{
				OptionName -> DilutionCurve,
				Default -> Automatic, (*TODO rewrite an example without using the concentration*)
				Description -> "The collection of dilutions that will be performed on the samples before light obscuration measurements are taken. For Fixed Dilution Volume Dilution Curves, the Sample Amount is the volume of the sample that will be mixed with the Diluent Volume of the Diluent to create the desired concentration. For Fixed Dilution Factor Dilution Curves, the Sample Volume is the volume of the sample that will created after being diluted by the Dilution Factor. For example, a 1M sample with a dilution factor of 0.7 will be diluted to a concentration 0.7M. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn.",
				ResolutionDescription->"This is automatically set Null if Diluent is set to Null or a SerialDilutionCurve is specified. Otherwise will default to a 0.5 factor dilution.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget->Alternatives[
					"Fixed Dilution Volume"->Adder[
						{
							"Sample Amount"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxTransferVolume],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
							"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxTransferVolume],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}]
						}
					],
					"Fixed Dilution Factor"->Adder[
						{
							"Sample Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxTransferVolume],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
							"Dilution Factors"->Widget[Type->Number,Pattern:>RangeP[0,1]]
						}
					]
				]
			},
			{
				OptionName -> SerialDilutionCurve,
				Default -> Automatic,
				Description -> "The collection of serial dilutions that will be performed on the samples before light obscuration measurements are taken. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 ug/ ml sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 25 ug/ ml, 6.25 ug/ ml, and 1.5625 ug/ ml with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn.",
				ResolutionDescription->"This is automatically set to Null if Diluent is set to Null or a non-serial Dilution Curve is specified. In all other cases it is automatically set to TransferVolume as one tenth of smallest of sample volume or container max volume, DiluentVolume as smallest of sample volume or container max volume, and Number of Dilutions as 3.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget->Alternatives[
					"Serial Dilution Volumes"-> {
						"Transfer Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxTransferVolume],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,$MaxTransferVolume],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Number Of Dilutions"->Widget[Type -> Number,Pattern :> RangeP[1,12,1]]
					},
					"Serial Dilution Factor"-> {
						"Sample Volume"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Microliter,$MaxTransferVolume],
							Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}
						],
						"Dilution Factors" ->Alternatives[
							"Constant" -> {
								"Constant Dilution Factor" ->
									Widget[Type -> Number, Pattern :> RangeP[0, 1]],
								"Number Of Dilutions" ->
									Widget[Type -> Number, Pattern :> RangeP[1,12,1]]
							},
							"Variable" ->
								Adder[Widget[Type -> Number, Pattern :> RangeP[0, 1]]]]
					}
				
				]
			},
			{
				OptionName -> Diluent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
					ObjectTypes->{Model[Sample],Object[Sample]}
				],
				Description -> "The solution that is used to dilute the sample to generate a DilutionCurve or SerialDilutionCurve.",
				ResolutionDescription->"Automatically set to the Solvent of the sample if DilutionCurve or SerialDilutionCurve are specified and if the Solvent field is not informed, Diluent is set to Model[Sample,\"Milli-Q water\"]. Otherwise set to Null.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget->Adder[
					Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							ObjectTypes -> {Model[Container]}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]
				],
				Description ->"The containers in which each sample is diluted with the Diluent to make the concentration series, with indices indicating specific grouping of samples if desired.",
				ResolutionDescription -> "Automatically set as Model[Container,Plate,\"96-well 2mL Deep Well Plate\"], grouping samples with the same container and DilutionStorageCondition.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionStorageCondition,
				Default ->Automatic,
				Description -> "The conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
				ResolutionDescription->"Automatically set Disposal if the sample is diluted and Null otherwise.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			},
			{
				OptionName -> DilutionMixVolume,
				Default ->Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter, 900 Microliter],
					Units->{1,{Liter,{Liter,Milliliter,Microliter}}}
				],
				Description -> "The volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
				ResolutionDescription->"Automatically set to the smallest dilution volume or half the largest dilution volume, whichever one is smaller.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionNumberOfMixes,
				Default ->Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0,20,1]
				],
				Description -> "The number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
				ResolutionDescription->"Automatically set 5 if the sample is diluted and Null otherwise.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionMixRate,
				Default ->Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
					Units->CompoundUnit[
						{1, {Microliter, {Microliter, Milliliter}}},
						{-1, {Second, {Second}}}
					]
				],
				Description -> "The speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
				ResolutionDescription->"Automatically set to 100 Microliter/Second if the sample is diluted and Null otherwise.",
				Category -> "Sample Preparation"
			},
			(* --- Measurement --- *)
			{
				OptionName->ReadingVolume,
				Default->Automatic,
				Description->"The volume of sample that is loaded into the instrument and used to determine particle size and count. If the reading volume exceeds the volume of the syringe the instruments will perform multiple strokes to cover the full reading volume.",
				ResolutionDescription -> "Automatically set based on speficied Method. If Method is Custom, automatically set to 20 Microliter if Syringe size is 1 mL, or 200 Microliter otherwise.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Microliter, $MaxTransferVolume],
					Units -> {1,{Microliter,{Microliter,Milliliter,Liter}}}
				],
				Category->"Measurement"
			},
			{
				OptionName -> SampleTemperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget ->Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0*Celsius, 80*Celsius],
						Units -> Alternatives[Celsius,Fahrenheit,Kelvin]
					]
				],
				Description -> "The temperature of the instrument's sampler tray where samples are equilibrated just prior to the injection.",
				Description -> "Automatically set based on speficied Method, else set to Ambient.",
				Category -> "Particle Size Measurements"
			},
			{
				OptionName->EquilibrationTime,
				Default->Automatic,
				Description->"The length of time for which each sample is incubated at the requested SampleTemperature just prior to being read.",
				ResolutionDescription->"Automatically set to 5 minutes when SampleTemperature is anything other than Ambient.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second, $MaxExperimentTime],
					Units:>{1,{Minute,{Second,Minute,Hour}}}
				],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->NumberOfReadings,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,10,1]
				],
				Description -> "The number of times the liquid particle count is read by passing ReadingVolume through the light obscuration sensor.",
				ResolutionDescription -> "Automatically set to 3 if Method is not specified.",
				Category->"Particle Size Measurements"
			},
			{
				OptionName->PreRinseVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[0 Microliter, 10 Milliliter],
					Units ->  {1 Microliter,{Microliter, Milliliter}}
				],
				Description->"The volume of the sample flown into the syringe tubing to rinse out the lines with each new sample before beginning the reading.",
				ResolutionDescription-> "Automatically set to 0 if DiscardFirstRun is True, otherwise set to the max volume for the syringe.",
				Category->"Particle Size Measurements"
			},
			{
				OptionName->DiscardFirstRun,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicate during the data collection, the data collection starts from the 2nd reading, the first reading will be discarded. Setting this to true will increase the reproducibility of data collection.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->SamplingHeight,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicate during the data collection, the distance between the tip of the probe and the bottom of the container.",
				ResolutionDescription -> "Automatically set based on the dimension of the container of the SamplesIn and StirBar (if AcquisitionMixType is Stir).",
				Widget-> Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Millimeter, 95Millimeter],
					Units ->  {1 Millimeter,{Millimeter, Centimeter}}
				],
				Category->"Particle Size Measurements"
			},
			
			
			(* --- Stirring --- *)
			{
				OptionName->AcquisitionMix,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicates whether the samples should be mixed during data acquisition.",
				ResolutionDescription->"Automatically set based on other AcquisitionMix options.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->AcquisitionMixType,
				Default->Automatic,
				AllowNull->True,
				Description->If[$CountLiquidParticlesAllowHandSwirl,
					"Indicates the method used to mix the sample. If this option is set to Stir, a StirBar will be transferred into the sample container and stir the sample during the entire data collection process. If this option is set to Swirl, the sample container will be swirled by hand. The sample container will stand still for WaitTime before the data collection starts, and the sample container will not be further mixed during the data collection.",
					"Indicates the method used to mix the sample. If this option is set to Stir, a StirBar will be transferred into the sample container and stir the sample during the entire data collection process."
				],
				ResolutionDescription->"Automatically set to Stir if AcquisitionMix is True.",
				Widget-> Widget[Type->Enumeration,Pattern:>If[$CountLiquidParticlesAllowHandSwirl, Alternatives[Stir, Swirl],Alternatives[Stir]]],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->NumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Description->"Indicate the number of times the sample container will be swirled if the AcquisitionMixType is swirl",
				ResolutionDescription->"Automatically sets to 10 if the AcquisitionMixType is Swirl.",
				Widget->Widget[Type->Number,Pattern:>RangeP[1,40,1]],
				Category->If[$CountLiquidParticlesAllowHandSwirl,"Particle Size Measurements","Hidden"]
			},
			{
				OptionName->WaitTimeBeforeReading,
				Default->Automatic,
				AllowNull->True,
				Description->"The length of time the container will be placed standstill before the reading its particle sizes",
				ResolutionDescription->"Automatically sets to 1 Minute if the AcquisitionMixType is swirl.",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Minute,10 Minute],Units-> {1 Minute, {Second,Minute}}],
				Category->If[$CountLiquidParticlesAllowHandSwirl,"Particle Size Measurements","Hidden"]
			},
			{
				OptionName->StirBar,
				Default->Automatic,
				AllowNull->True,
				Description->"Indicates the stir bar used to agitate the sample during acquisition.",
				ResolutionDescription -> "Automatically set based on the volume and the container of the sample if the AcquisitionMixType is Stir.",
				Widget-> Widget[Type->Object,
					Pattern:>ObjectP[{Model[Part, StirBar], Object[Part, StirBar]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments","Mixing Devices", "Stir Bars"
						}
					}
				],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->AcquisitionMixRate,
				Default->Automatic,
				AllowNull->True,
				Description->"Indicates the rate at which the samples should be mixed with a stir bar during data acquisition.",
				ResolutionDescription -> "Automatically set AcquisitionMixRate 400 RPM if the AcquisitionMixType is Stir.",
				Widget-> Widget[Type->Quantity,Pattern:>RangeP[50 RPM,350 RPM],Units->RPM],
				ResolutionDescription -> "Automatically set 500 RPM if if the AcquisitionMixType is Stir.",
				Category->"Particle Size Measurements"
			},
			{
				OptionName->AdjustMixRate,
				Default->Automatic,
				AllowNull->True,
				Description->"When using a stir bar for AcquisitionMixType is Stir, if specified AcquisitionMixRate does not provide a stable or consistent circular rotation of the magnetic bar, indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples. If stir bar is wiggling, decrease AcquisitionMixRate by AcquisitionMixRateIncrement and check if the stir bar is still wiggling. If it is, decrease by AcquisitionMixRateIncrement again. If still wiggling, repeat decrease until MaxStirAttempts. If the stir bar is not moving/stationary, increase the AcquisitionMixRate by AcquisitionMixRateIncrement and check if the stir bar is still stationary. If it is, increase by AcquisitionMixRateIncrement again. If still stationary, repeat increase until MaxStirAttempts. Mixing will occur during data acquisition. After MaxStirAttempts, if stable stirring was not achieved, StirringError will be set to True in the protocol object.",
				ResolutionDescription -> "Automatically set to True if if the AcquisitionMixType is Stir.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->MinAcquisitionMixRate,
				Default->Automatic,
				AllowNull->True,
				Description->"Sets the lower limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar if AdjustMixRate is True.",
				ResolutionDescription->"Automatically sets to 20% RPM lower than AcquisitionMixRate if AdjustMixRate is True.",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[50 RPM,350 RPM],Units->RPM],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->MaxAcquisitionMixRate,
				Default->Automatic,
				AllowNull->True,
				Description->"Sets the upper limit stirring rate to be increased to for sample mixing while attempting to mix the samples with a stir bar if AdjustMixRate is True.",
				ResolutionDescription -> "Automatically sets to 20% RPM greater than AcquisitionMixRate if AdjustMixRate is True.",
				Widget-> Widget[Type->Quantity,Pattern:>RangeP[50 RPM,350 RPM],Units->RPM],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->AcquisitionMixRateIncrement,
				Default->Automatic,
				AllowNull->True,
				Description->"Indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar.",
				ResolutionDescription->"Automatically sets to 50 RPM if AdjustMixRate is True.",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[10 RPM,350 RPM],Units->RPM],
				Category->"Particle Size Measurements"
			},
			{
				OptionName->MaxStirAttempts,
				Default->Automatic,
				AllowNull->True,
				Description->"Indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt.",
				ResolutionDescription->"If AdjustMixRate is True, automatically sets to 10.",
				Widget->Widget[Type->Number,Pattern:>RangeP[1,40]],
				Category->"Particle Size Measurements"
			},

		(* --- Wash --- *)
			{
				OptionName->WashSolution,
				Default->Automatic,
				AllowNull->False,
				Widget-> Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}
					](*,
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Experiment Objects","HIAC Liquid Particle Counting","Cleaning Solutions"
						}
					}*)
				],
				Description->"For each member of SamplesIn, the solution pumped through the instrument's flow path to clean it between the loading of each new sample.",
				Category->"Washing"
			},
			{
				OptionName -> WashSolutionTemperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					],
					Widget[Type -> Quantity, Pattern :> RangeP[4*Celsius, 40*Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}]
				],
				Category -> "Washing",
				Description -> "For each member of SamplesIn, the temperature to which the WashSolution is preheated before flowing it through the flow path.",
				ResolutionDescription -> "Automatically set to Ambient."
			},
			{
				OptionName->WashEquilibrationTime,
				Default->Automatic,
				Description->"For each member of SamplesIn, the length of time for which the wash solution container equilibrate at the requested WashSolutionTemperature in the sample rack before being pumped through the instrument's flow path.",
				ResolutionDescription->"Automatically set to 5 minutes if the WashSolutionTemperature is not Ambient.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second, $MaxExperimentTime],
					Units:>{1,{Minute,{Second,Minute,Hour}}}
				],
				Category->"Washing"
			},

			{
				OptionName -> WashWaitTime,
				Default -> Automatic,
				AllowNull -> False,
				Widget ->
					Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units -> {Second, {Second, Minute, Hour}}],
				Category -> "Washing",
				Description -> "For each member of SamplesIn, the amount of time for which the syringe is allowed to soak with each wash solution before flushing it to the waste.",
				ResolutionDescription-> "Automatically set 0 Minute."
			},
			{
				OptionName ->NumberOfWashes,
				Default -> Automatic,
				AllowNull -> False,
				Widget ->Widget[
					Type->Number,
					Pattern:>RangeP[1,10,1]
				],
				Category -> "Washing",
				Description -> "For each member SamplesIn, the number of times each wash solution is pumped through the instrument's flow path."
			}
		],
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterP[1, 1]
			],
			Category -> "General",
			Description -> "The number of times to repeat measurements on each provided sample(s). If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted."
		},
		(* Shared options *)
		ModifyOptions[
			PreparationOption,
			Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell. For now ExperimentCountLiquidParticles can be only done manually."
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 40 Milliliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption
	}
];

(* ::Subsubsection:: *)
(*ExperimentCountLiquidParticles Errors and Warnings*)
Error::InvalidSyringeForCountLiquidParticles="The specified syringe `1` cannot be used for this experiment, please use a syringe with a model of either Model[Part, Syringe, \"10 mL HIAC Injection Syringe\"] or Model[Part, Syringe, \"1 mL HIAC Injection Syringe\"].";
Error::CountLiquidParticleNotEnoughSampleVolume="The following samples `1` does not have enough volume to finish the experiment. The experiment requires `2` to finish the experiment for each sample, respectively. The required total volume per sample is calculated by adding the PreRinseVolume to the ReadingVolume*NumberOfReadings. Please specify a ReadingVolume, NumberOfReadings and/or PreRinseVolume so that the required sample volume is less than the volume of the input samples.";
Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles="The specified syringe `1` does not consistent with specified syringe size `2`. Please change the syringe and the size to be consistent or leave one of these two options as Automatic."
Error::CountLiquidParticleDilutionContainerLengthMismatch="The following sample(s) `1` need to be diluted to `2` samples, respectively. However, only `3` DilutionContainer were specified.";
Error::CountLiquidParticleInvalidDilutionCurveVolumes="The following sample(s) `1` will be diluted, the diluted sample will have `2` in volume, respectively. However, the experiment requires `3` to finish the experiment. Consider preparing more diluted sample or reduce ReadingVolume or PreRinseVolume.";
Error::CountLiquidParticleUnneededAdjustMixOptions="The following sample(s) `1` have options `2` that requires to be set to Null since AdjustMixRate is False. Please leave them as Automatic.";
Error::CountLiquidParticleRequiredAdjustMixOptions="The following sample(s) `1` have options `2` that requires to be specified since AdjustMixRate is True. Please leave them as Automatic.";
Error::CountLiquidParticleRequiredAcquisitionMixOptions="The following samples `1` have options `3` that cannot be set to Null because AcquisitionMix is set to True and the AcquisitionMixType is `2`. please leave them as Automatic.";
Error::CountLiquidParticleUnneededAcquisitionMixOptions="The following samples `1` have options `2` that cannot be specified because AcquisitionMix is set to False, please leave them as Automatic.";
Error::CountLiquidParticleConflictingMixOptions="The following samples `1` have options `2` that need to be set to Null or Automatic for the corresponding AcquisitionMixType `3`. Note that if AcquisitionMixType is Swirl, only {AcquisitionMixType, NumberOfMixes, WaitTimeBeforeReading} need to be specified. If AcquisitionMixType is Stir, only {StirBar, AcquisitionMixRate, AdjustMixRate, MinAcquisitionMixRate, MaxAcquisitionMixRate, AcquisitionMixRateIncrement, MaxStirAttempts} need to be specified.";
Error::CountLiquidParticleInvalidStirBar = "The following samples `1` are set to be mixed by stirring, but have a StirBar, `2`, that is either set to Null or is not compatible with the sample container or the sample volume liquid level. If StirBar was set to Automatic, no compatible StirBar was found for the container and sample volume. If a StirBar was specified, it is not compatible with either the container or the sample volume. Please specify a StirBar that is compatible with the sample volume and the container that the sample will be stirred in.";
Error::CountLiquidParticleInvalidMinAcquisitionMixRate = "The following samples `1` have a MinAcquisitionMixRate, `2`, that is lower than the MinStirRate of the instrument model. Please set a MinAcquisitionMixRate that is higher than the MinStirRate of the instrument model.";
Error::CountLiquidParticleInvalidMaxAcquisitionMixRate = "The following samples `1` have a MaxAcquisitionMixRate, `2`, that is higher than the MaxStirRate of the instrument model. Please set a MaxAcquisitionMixRate that is lower than the MaxStirRate of the instrument model.";
Error::CountLiquidParticleInvalidAcquisitionMixRateIncrement = "The following samples `1` have an AcquisitinMixRateIncrement, `2`, that is larger than MaxAcquisitionMixRate. Please specify an AcquisitinMixRateIncrement that is lower than the MaxAcquisitionMixRate.";
Error::CountLiquidParticleLiquidLevelTooLow="The following samples `1` have will have a liquid level height of `2` after data collection. The container needs a minimum liquid level height of `3` for the sample to be drawn from the container. If a StirBar is specified, the height of the StirBar is included in the minimum liquid level. Please reduce the ReadingVolume, NumberOfReadings and/or PreRinseVolume, or consider not using a StirBar during data collection.";
Error::CountLiquidParticleInvalidSamplingHeight="The following samples `1` have will have a liquid with a height `4` after data collection. However the SamplingHeight is set to `2`. Please set a number between `3` and `4` or reduce the ReadingVolume, NumberOfReadings and/or PreRinseVolume.";
Warning::CountLiquidParticleDilutions="The following samples `1` will be diluted at the beginning of the experiments, and `2` of those samples will be used for dilution/serial dilutions. Also, the experiment will only count the particles sizes for diluted sample.";
Warning::CountLiquidParticlesDuplicateParticleSizes="The following samples `1` have the ParticleSizes with duplicate sizes `2`, respectively. Note that for each run, duplicate ParticleSize will not be measured. Thereby, only `3` will be measured for these samples.";

(* ::Subsubsection:: *)
(*ExperimentCountLiquidParticles*)

ExperimentCountLiquidParticles[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,safeOps,safeOpsTests,validLengths,validLengthTests,allDownloadPackets,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult, resolvedOptions,
		resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		optionsWithObjects, allObjects, objectSamplePacketFields, modelSamplePacketFields, modelContainerObjects,
		instrumentObjects, modelSampleObjects, sampleObjects, modelInstrumentObjects, samplePreparationSimulation,
		objectContainerFields,modelContainerFields,messages,listedSamples,objectContainerObjects,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed,upload, confirm,canaryBranch,
		parentProt, cache, methodObjects, modelInstrumentFields,simulatedProtocol,simulation,returnEarlyQ,
		performSimulationQ, updatedSimulation, allStirBarModels
	},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	
	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCountLiquidParticles,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];
	
	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a  messages above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	
	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentCountLiquidParticles,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCountLiquidParticles,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];
	
	(* get some information from the input options *)
	{upload, confirm, canaryBranch, parentProt, cache} = Lookup[safeOpsNamed, {Upload, Confirm, CanaryBranch, ParentProtocol, Cache},{}];
	
	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentCountLiquidParticles,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCountLiquidParticles,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentCountLiquidParticles,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCountLiquidParticles,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentCountLiquidParticles,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Any options whose values could be an object *)
	optionsWithObjects = {
		Diluent,
		DilutionContainer,
		Instrument,
		Method,
		Sensor,
		Syringe,
		PrimeSolutions,
		StirBar,
		WashSolution
	};

	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				(* Default objects *)
				(* All options that _could_ have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		],
		Object,
		Date->Now
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{Composition, IncompatibleMaterials, Well, Viscosity, BoilingPoint, SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,Products,Composition,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];
	modelInstrumentFields= {Object,Name,WettedMaterials,MinStirRate,MaxStirRate,Positions,ProbeLength,MaxSamplingHeight};

	modelContainerObjects= DeleteDuplicates[Join[Cases[allObjects,ObjectP[{Model[Container],Model[Part,Syringe]}]],{Model[Container, Vessel,"id:o1k9jAG00e3N"],Model[Container,Vessel,"id:eGakld01zzpq"],Model[Container,Vessel,"id:3em6Zv9NjjN8"],Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:jLq9jXvA8ewR"],Model[Container,Vessel,"id:01G6nvwPempK"],Model[Container,Vessel,"id:J8AY5jwzPPR7"],Model[Container,Vessel,"id:aXRlGnZmOONB"],Model[Container,Vessel,"id:zGj91aR3ddXJ"],Model[Container,Vessel,"id:3em6Zv9Njjbv"],Model[Container,Vessel,"id:Vrbp1jG800Zm"],Model[Container,Vessel,"id:dORYzZJpO79e"],Model[Container,Vessel,"id:aXRlGnZmOOB9"],Model[Container,Vessel,"id:3em6Zv9NjjkY"],Model[Container,Plate,"id:L8kPEjkmLbvW"],Model[Container,Plate,"id:E8zoYveRllM7"],Model[Part, Syringe, "id:bq9LA0JlRred"], Model[Part, Syringe, "id:zGj91a7zoBYj"]}]];
	objectContainerObjects= Cases[allObjects,ObjectP[{Object[Container],Object[Part,Syringe]}]];
	instrumentObjects = Cases[allObjects,ObjectP[Object[Instrument,LiquidParticleCounter]]];
	modelInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument,LiquidParticleCounter]]];
	modelSampleObjects=Cases[allObjects,ObjectP[Model[Sample]]];
	sampleObjects=Cases[allObjects,ObjectP[Object[Sample]]];
	methodObjects=Cases[allObjects,ObjectP[Object[Method]]];

	(* Search call *)
	allStirBarModels=Search[Model[Part,StirBar],(Expires!=True)&&(Deprecated!=True)];

	(* --- Download --- *)
	allDownloadPackets=Quiet[Download[
		{
			(*1*)sampleObjects,
			(*2*)ToList[instrumentObjects],
			(*3*)ToList[instrumentObjects],
			(*4*)modelInstrumentObjects,
			(*5*)modelContainerObjects,
			(*6*)objectContainerObjects,
			(*7*)objectContainerObjects,
			(*8*)methodObjects,
			(*9*)allStirBarModels
		},
		Evaluate[{
			(*1*){
				objectSamplePacketFields,
				modelSamplePacketFields,
				Packet[Container[objectContainerFields]],
				Packet[Container[Model][modelContainerFields]],
				Packet[Container[Model][VolumeCalibrations][{CalibrationFunction}]]
			},
			(*2*){
				Packet[Object,Name,Status,Model],
				Packet[Model[{Object,Name}]]
			},
			(*3*){
				Packet[Model[modelInstrumentFields]]
			},
			(*4*){
				Packet[Sequence@@modelInstrumentFields]
			},
			(*5*){
				Packet[Sequence@@modelContainerFields],
				Packet[VolumeCalibrations[{CalibrationFunction}]]
			},
			(*6*){
				Packet[Sequence@@objectContainerFields]
			},
			(*7*){
				Packet[Model[modelContainerFields]],
				Packet[Model[VolumeCalibrations][{CalibrationFunction}]]
			},
			(*8*){
				Packet[All]
			},
			(*9*){
				Packet[StirBarLength, StirBarWidth, StirBarShape]
			}
		}],
		Cache->cache,
		Simulation->samplePreparationSimulation,
		Date->Now
	],Download::FieldDoesntExist];

	(*Build the cache*)
	cacheBall=FlattenCachePackets[{cache,Flatten[allDownloadPackets]}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)

		{resolvedOptions,resolvedOptionsTests}=resolveExperimentCountLiquidParticlesOptions[ToList[listedSamples],expandedSafeOps,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentCountLiquidParticlesOptions[ToList[listedSamples],expandedSafeOps,Cache->cacheBall,Simulation->samplePreparationSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentCountLiquidParticles,
		resolvedOptions,
		Ignore->ToList[listedOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentCountLiquidParticles,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentFlowCytometry,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		countLiquidParticlesResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		{countLiquidParticlesResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->Result],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, updatedSimulation} = If[performSimulationQ,
		simulateExperimentCountLiquidParticles[
			First[resourcePackets],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->samplePreparationSimulation
		],
		{Lookup[First[resourcePackets],Object], Null}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentCountLiquidParticles,collapsedResolvedOptions],
			Preview -> Null,
			Simulation->updatedSimulation
		}]
	];
	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* If have other packet to upload, upload them as accessory packets *)
		Length[resourcePackets]>1,
		UploadProtocol[
			First[resourcePackets],
			Rest[resourcePackets],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			Cache -> cacheBall,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,CountLiquidParticles],
			Simulation->samplePreparationSimulation
		],

		(* If we want to upload an actual protocol object. *)
		True,
		UploadProtocol[
			First[resourcePackets],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			Cache -> cacheBall,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,CountLiquidParticles],
			Simulation->samplePreparationSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentCountLiquidParticles,collapsedResolvedOptions],
		Simulation->updatedSimulation,
		Preview -> Null
	}
];

(*Mixed inputs*)
ExperimentCountLiquidParticles[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,samplePreparationSimulation,containerToSampleResult,containerToSampleOutput,
		updatedCache,samples,sampleOptions,containerToSampleTests, containerToSampleSimulation, cache,listedContainers
	},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Get containers and options in list format. *)
	{listedContainers, listedOptions}= {ToList[myContainers], ToList[myOptions]};

	(* get some information from the input options *)
	cache = Lookup[listedOptions, Cache,{}];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentCountLiquidParticles,
			ToList[listedContainers],
			ToList[listedOptions],
			DefaultPreparedModelAmount -> 40 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a  messages above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];


	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentCountLiquidParticles,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Cache->cache,
			Simulation->samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentCountLiquidParticles,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Cache->cache,
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::EmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Update our cache with our new simulated values. *)
	(* It is important the the sample preparation cache appears first in the cache ball. *)
	updatedCache=Flatten[{
		cache,
		Lookup[listedOptions,Cache,{}]
	}];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentCountLiquidParticles[samples,ReplaceRule[sampleOptions,{Simulation->samplePreparationSimulation,Cache->updatedCache}]]
	]
];


(*resolveExperimentCountLiquidParticlesOptions*)

DefineOptions[
	resolveExperimentCountLiquidParticlesOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentCountLiquidParticlesOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentCountLiquidParticlesOptions]]:=Module[
	{
		outputSpecification,output,gatherTests, messages,cache,simulation,samplePrepOptions,alphaScreenOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,
		simulatedCache,fastCacheBall,countLiquidParticlesAssociation,acquisitionMix,instrument,methods, numberOfPrimes, primeSolutions, primeWaitTimes,
		sampleTemperature, sensor, suppliedPrimeSolutionTemperatures, suppliedPrimeEquilibrationTimes, objectSamplePacketFields, modelSamplePacketFields,
		objectContainerPacketFields, modelContainerPacketFields, suppliedSyringeObjects,instrumentDownloadFields, samplePackets,instrumentPacket, requiredAliquotVolumes,
		syringeObjectPackets, unroundedDilutionCurve,separatedUnroundedDilutionCurve,roundedDilutionCurveOption,dilutionCurvePrecisionTests,roundedDilutionCurveOptions,
		unroundedSerialDilutionCurve,roundedSerialDilutionCurveOptions,doublyRoundedSerialDilutionCurveOptions,serialDilutionPrecisionTests,optionPrecisions,
		roundedOtherExperimentOptions,optionPrecisionTests,roundedExperimentOptions,roundedUnresolvedOptions,requiredAliquotContainers,resolvedAliquotOptions,aliquotTests,
		resolvedPostProcessingOptions,invalidInputs,invalidOptions,resolvedOptions,discardedSamplePackets,discardedInvalidInputs,discardedTests,name,suppliedInstrumentModel,
		compatibleMaterialsQ,compatibleMaterialsTests,compatibleMaterialsInvalidOption,validNameQ,nameInvalidOption,validNameTest, nonLiquidSamplePackets,	nonLiquidSampleInvalidInputs,
		nonLiquidSampleTests,allSamplePackets, resolvedParticleSizes,resolvedSyringeSize,resolvedSyringe,resolvedDilutionCurves,resolvedSerialDilutionCurves,resolvedDiluents,
		resolvedStirBars,resolvedMaxStirAttempts,resolvedPrimeSolutionTemperatures,resolvedPrimeEquilibrationTimes,	resolvedReadingVolumes,resolvedEquilibrationTimes,
		resolvedPreRinseVolumes, resolvedAcquisitionMixes,resolvedAcquisitionMixRates,resolvedAdjustMixRates, resolvedMinAcquisitionMixRates,resolvedMaxAcquisitionMixRates,
		resolvedAcquisitionMixRateIncrements,resolvedWashSolutionTemperatures,resolvedWashEquilibrationTimes,resolvedWashWaitTimes,firstMethod,methodPackets, methodObjects,
		allPrimeOptions, allPrimeValueLists,primeOptionLength,nonSampleLengthPrimeOptions,expandedPrimeSolutions, expandedPrimeSolutionTemperatures,instrumentModelPacket,
		expandedPrimeEquilibrationTimes, expandedPrimeWaitTimes, expandedNumberOfPrimes,expandedPrimeOptions,sampleModelPackets, resolvedSyringeModel, syringeAndSizeMisMatchedQ,
		invalidSyringeSizeOptions, invalidSyringeSizeTests, resolvedDilutionMixVolumes,resolvedDilutionMixRates,resolvedDilutionContainers,resolvedDilutionStorageConditions,resolvedDilutionNumberOfMixes,
		mapThreadFriendlyOptions,dilutionContainerLengthMisMatchedBools,syringeModelPacket,sampleContainerModelPackets, dilutionContainer, resolvedSampleTemperatures,
		resolvedNumberOfReadings, suppliedAliquotContainerModels, minStirRate,maxStirRate,resolvedWashSolutions,inConsistentOptionList,
		resolvedNumberOfWashes, sampleLoadingVolumes, numAspirations, unNeededDilutionOptionList, requiredDilutionOptionList, unNeededAcquisitionMixOptionList,
		requiredAcquisitionMixOptionList, unNeededAdjustMixRateOptionList, requiredAdjustMixRateOptionList, countLiquidPartcielDilutionBools,
		notEnoughVolumeBools, dilutionCurveVolumeBools, dilutionContainerBools, invalidStirBarBools, invalidMinAcquisitionMixRateBools, invalidMaxAcquisitionMixRateBools,
		requiredSampleVolumes, invalidAcquisitionMixRateIncrementBools, suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,
		suppliedAssayBuffers,suppliedAliquotContainers, suppliedConsolidateAliquots, impliedAliquotBools, inputContainerCompatibleBools,
		unNeededDilutionOptionTests,requiredDilutionOptionTests,unNeededAcquisitionMixOptionTests,requiredAcquisitionMixOptionTests,unNeededAdjustMixOptionTests,
		requiredAdjustMixRateOptionTests, outsideEngine, notEnoughVolumeOptions, notEnoughVolumeTests, invalidDilutionCurveVolumeOptions,
		notEnoughDilutionCurveVolumeTests, invalidDilutionContainerOptions, invalidDilutionContainerTests, invalidStirBarOptions, invalidStirBarTests, invalidMinAcquisitionMixRateOptions,
		invalidMinAcquisitionMixRateTests, invalidMaxAcquisitionMixRateOptions, invalidMaxAcquisitionMixRateTests, invalidAcquisitionMixRateIncrementOptions,
		invalidAcquisitionMixRateIncrementTests, preparationResult,	allowedPreparation,	preparationTest,resolvedPreparation,resolvedSaveCustomMethods,
		resolvedDiscardFirstRuns,dilutionLengthList,invalidDilutionContainerLengthsOptions,	invalidDilutionContainerLengthsTests,dilutedSampleVolumeList,
		invalidSyringeQ,invalidSyringeOptions,invalidSyringeTests,resolvedAcquisitionMixTypes,resolvedNumberOfMixesList,resolvedWaitTimeBeforeReadings,
		conflictingMixingOptionsList, conflictingMixOptionsTests, duplicateParticleSizesBools,resolvedSamplingHeights,
		liquidLevelCoverStirBarBools, sampleHeightBools, minSampleHeights, stirBarCoverHeights, invalidParticleLiquidLevelTooLowOptions,
		invalidParticleLiquidLevelTooLowTests,invalidSamplingHeightOptions, invalidSamplingHeightTests, resolvedSampleLabel, resolvedSampleContainerLabel,
		countLiquidPartcielDilutionWarnings,duplicateParticleSizesWarnings
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages=!gatherTests;

	(* Check if we are in Engine front end*)
	outsideEngine=!MatchQ[$ECLApplication,Engine];

	(* Fetch our cache and simulation from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Separate out our AlphaScreen options from our Sample Prep options. *)
	{samplePrepOptions,alphaScreenOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentCountLiquidParticles,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentCountLiquidParticles,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* Merge the simulation result into the simulatedCache *)
	simulatedCache = FlattenCachePackets[{cache, Lookup[updatedSimulation[[1]], Packets]}];

	fastCacheBall = makeFastAssocFromCache[simulatedCache];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	countLiquidParticlesAssociation = Association[alphaScreenOptions];

	(* Fetch supplied option values *)
	{
		instrument,
		methods,
		sensor,
		name,
		dilutionContainer
	}=Lookup[countLiquidParticlesAssociation,
		{
			Instrument,
			Method,
			Sensor,
			Name,
			DilutionContainer
		}
	];

	(* Determine which fields we need to download from the input Objects *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{Solvent,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerPacketFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerPacketFields=Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

	suppliedSyringeObjects=Cases[Lookup[countLiquidParticlesAssociation],ObjectP[Object[Container]]];

	(* Get the methods object *)
	methodObjects=Cases[ToList[methods],ObjectP[]];

	(* Instrument download fields*)
	instrumentDownloadFields=If[

		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument, ObjectP[Object[Instrument]]],
		Packet[Model[{Object,WettedMaterials,Name, MinStirRate, MaxStirRate}]],

		(* If instrument is a Model, download fields*)
		Packet[Object,WettedMaterials,Name, MinStirRate, MaxStirRate]
	];


	(* --- Assemble Download --- *)
	{
		allSamplePackets,
		instrumentPacket,
		syringeObjectPackets,
		methodPackets
	}=Quiet[
		Download[
			{
				simulatedSamples,
				ToList[instrument],
				DeleteDuplicates[ToList[suppliedSyringeObjects]],
				DeleteDuplicates[methodObjects]
			},
			Evaluate[{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerPacketFields]],
					Packet[Container[Model][modelContainerPacketFields]]
				},
				{instrumentDownloadFields},
				{objectContainerPacketFields},
				{Packet[All]}
			}],
			Cache->simulatedCache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Processing download information *)
	(*fetch the packet we want to use*)
	samplePackets=allSamplePackets[[All,1]];
	sampleModelPackets=allSamplePackets[[All,2]];
	sampleContainerModelPackets=allSamplePackets[[All,4]];


	(* Fetch the stir plate information *)
	{minStirRate,maxStirRate}=First[Lookup[FirstOrDefault[instrumentPacket],{MinStirRate,MaxStirRate}]];

	(* --- INPUT VALIDATION CHECKS --- *)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs= If[Length[discardedSamplePackets]==0,
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are discarded invalid inputs and we are throwing messages, throw an error  messages and keep track of the invalid inputs.*)
(*	If[Length[discardedInvalidInputs]>0&&messages,*)
(*		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Cache->simulatedCache]]*)
(*	];*)

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Get the samples from simulatedSamples that are discarded. *)
	(* Also we cannot take solid sample right now  *)

	(* Get the samples that are not liquids, we can't do mass spec on those *)
	nonLiquidSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[State->Solid]];

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=If[Length[nonLiquidSamplePackets]==0,{},Lookup[nonLiquidSamplePackets,Object]];


	(* Create a test for the valid samples and one for the invalid samples *)
	nonLiquidSampleTests=If[
		gatherTests,
		Test["The input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Cache->simulatedCache]<>" are not liquid:",True,Length[nonLiquidSamplePackets]==0],
		Nothing
	];

	(* --- Resolve the sample preparation method --- *)
	(* -- Always need to be false -- *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveCountLiquidParticlesMethod[simulatedSamples, ReplaceRule[myOptions, {Cache->simulatedCache,Simulation->simulation, Output->Result}]],
				{}
			},
			resolveCountLiquidParticlesMethod[simulatedSamples, ReplaceRule[myOptions, {Cache->simulatedCache,Simulation->simulation, Output->{Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* --- OPTION PRECISION CHECKS --- *)
	(* -- We will round the DilutionCurve and SerialDilutionCurve Options separately cause they're strange, this part is similar to ExpDLS --*)
	(* DilutionCurve *)
	(* First, get the unrounded DilutionCurves *)
	unroundedDilutionCurve=Lookup[countLiquidParticlesAssociation,DilutionCurve];

	(* Make a list of Associations *)
	separatedUnroundedDilutionCurve=Map[Association[DilutionCurve -> #] &, unroundedDilutionCurve];

	(* Round each Association *)
	{roundedDilutionCurveOption, dilutionCurvePrecisionTests} = Transpose[If[gatherTests,
		MapThread[
			RoundOptionPrecision[#1, DilutionCurve,
				If[MatchQ[#2, {{VolumeP, VolumeP} ..}],
					{10^-1*Microliter, 10^-1*Microliter},
					{10^-1*Microliter, 10^-3}
				],
				Output -> {Result, Tests}
			]&,
			{separatedUnroundedDilutionCurve,unroundedDilutionCurve}
		],
		MapThread[
			{
				RoundOptionPrecision[#1, DilutionCurve,
					If[MatchQ[#2, {{VolumeP, VolumeP} ..}],
						{10^-1*Microliter, 10^-1*Microliter},
						{10^-1*Microliter, 10^-3}]],
				{}
			}&,
			{separatedUnroundedDilutionCurve,unroundedDilutionCurve}]
	]];

	(* Put them back together *)
	roundedDilutionCurveOptions = Which[
		MatchQ[Flatten[Values[#], 1],{Null}],
		Null,
		MatchQ[Flatten[Values[#], 1],{Automatic}],
		Automatic,
		True,
		Flatten[Values[#], 1]
	]&/@roundedDilutionCurveOption;

	(* SerialDilutionCurve *)
	(* Get the unrounded SerialDilutionCurve values *)
	unroundedSerialDilutionCurve=If[
		MatchQ[Lookup[countLiquidParticlesAssociation,SerialDilutionCurve],{VolumeP,VolumeP,_Integer}|Automatic|{VolumeP,{_Real,_Integer}}|{VolumeP,{_Real..}}],
		{Lookup[countLiquidParticlesAssociation,SerialDilutionCurve]},
		Lookup[countLiquidParticlesAssociation,SerialDilutionCurve]
	];

	(* Round the Volume portion of each SerialDilutionCurve *)
	roundedSerialDilutionCurveOptions=Which[
		(* If the option is Automatic or Null, we don't need to round *)
		MatchQ[#,Automatic|Null],
		#,

		MatchQ[#,{VolumeP, VolumeP, _Integer}],
		RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1*Microliter];
		Join[{SafeRound[First[#],10^-1*Microliter]},{SafeRound[#[[2]],10^-1*Microliter]},{Last[#]}],

		True,
		RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1*Microliter];
		Join[{SafeRound[First[#],10^-1*Microliter]},Rest[#]]
	]&/@unroundedSerialDilutionCurve;

	(* Round the dilution factor portion of each SerialDilutionCurve *)
	doublyRoundedSerialDilutionCurveOptions=Which[
		(* If the option is Automatic or Null, we don't need to round *)
		MatchQ[#,Automatic|Null|{VolumeP, VolumeP, _Integer}],
		#,

		True,
		RoundOptionPrecision[<|SerialDilutionCurve->Last[#]|>, SerialDilutionCurve, 10^-3];
		Join[{First[#]},{SafeRound[Last[#],10^-3]}]
	]&/@roundedSerialDilutionCurveOptions;

	(* Gather the tests for the SerialDilutionCurve option precision *)
	serialDilutionPrecisionTests=Which[
		MatchQ[#,Automatic|Null],
		{},
		MatchQ[#,{VolumeP, VolumeP, _Integer}],
		If[gatherTests,
			Last[RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1*Microliter,Output->{Result,Tests}]],
			{}
		],
		True,
		If[gatherTests,
			Last[RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1*Microliter,Output->{Result,Tests}]],
			{}
		]
	]&/@unroundedSerialDilutionCurve;

	(* Round all of the other experiment options *)
	(* First, define the option precisions that need to be checked for  CountLiquidParticles *)
	optionPrecisions={
		{PrimeWaitTime,10^0*Second},
		{SampleTemperature,10^0Celsius},
		{SamplingHeight,1Millimeter},
		{PrimeSolutionTemperatures,10^0Celsius},
		{PrimeEquilibrationTime,10^0*Second},
		{ReadingVolume,1Microliter},
		{EquilibrationTime,10^0*Second},
		{PreRinseVolume,1Microliter},
		{AcquisitionMixRate,10RPM},
		{MinAcquisitionMixRate,10RPM},
		{MaxAcquisitionMixRate,10RPM},
		{AcquisitionMixRateIncrement,10RPM},
		{WashSolutionTemperature,10^0Celsius},
		{WashEquilibrationTime,10^0*Second},
		{DilutionMixVolume,10^-1Microliter},
		{DilutionMixRate,10^-1 Microliter/Second},
		{WashWaitTime,10^0*Second}
	};

	(* Verify that the experiment options are not overly precise *)
	{roundedOtherExperimentOptions,optionPrecisionTests}=If[gatherTests,

		(*If we are gathering tests *)
		RoundOptionPrecision[countLiquidParticlesAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

		(* Otherwise *)
		{RoundOptionPrecision[countLiquidParticlesAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];

	roundedExperimentOptions=Join[roundedOtherExperimentOptions,<|DilutionCurve->roundedDilutionCurveOptions|>,<|SerialDilutionCurve->doublyRoundedSerialDilutionCurveOptions|>];

	(* Replace the rounded options in myOptions *)
	roundedUnresolvedOptions=ReplaceRule[
		myOptions,
		Normal[roundedExperimentOptions],
		Append->False
	];


	(* Fetch the rounded option values *)
	{
		(*1*)primeWaitTimes,
		(*2*)sampleTemperature,
		(*3*)suppliedPrimeSolutionTemperatures,
		(*4*)suppliedPrimeEquilibrationTimes,
		(*5*)primeSolutions,
		(*6*)numberOfPrimes
	}=Lookup[roundedUnresolvedOptions,
		{
			(*1*)PrimeWaitTime,
			(*2*)SampleTemperature,
			(*3*)PrimeSolutionTemperatures,
			(*4*)PrimeEquilibrationTime,
			(*5*)PrimeSolutions,
			(*6*)NumberOfPrimes
		}
	];

	(* === CONFLICTING OPTIONS CHECKS === *)
	(* -- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument -- *)
	{compatibleMaterialsQ,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,simulatedSamples,Cache->simulatedCache,Simulation->updatedSimulation,Output->{Result,Tests}],
		{CompatibleMaterialsQ[instrument,simulatedSamples,Cache->simulatedCache,Simulation->updatedSimulation,Messages->messages],{}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption=If[Not[compatibleMaterialsQ]&&messages,
		{Instrument},
		{}
	];

	(* -- Check that the protocol name is unique -- *)
	validNameQ=If[MatchQ[ name,_String],

		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol, CountLiquidParticles, name]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"CountLiquidParticles protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already an CountLiquidParticles protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* -- Check that the Instrument is one of the accepted Models -- *)
	(* - Find the Model of the instrument, if it was specified - *)
	suppliedInstrumentModel=If[
		MatchQ[instrument,ObjectP[Model[Instrument]]],
		instrument,
		Download[Lookup[fetchPacketFromFastAssoc[instrument,fastCacheBall],Model],Object]
	];

	(* get the instrument model packet *)
	instrumentModelPacket = fetchPacketFromFastAssoc[suppliedInstrumentModel,fastCacheBall];

	(* DilutionContainer cannot be well handled by the mapThreadOptions *)
	(*Make the dilution container field of te from {{_,_},{_,_}..} to make mapThreadOptions run smoothly*)

	(* Build the mapthread safe options *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentCountLiquidParticles,roundedUnresolvedOptions];

	(*-- Resolved PreWashOptions --*)
	allPrimeOptions= {
		PrimeSolutions,
		PrimeSolutionTemperatures,
		PrimeEquilibrationTime,
		PrimeWaitTime,
		NumberOfPrimes
	};

	allPrimeValueLists={
		primeSolutions,
		suppliedPrimeSolutionTemperatures,
		suppliedPrimeEquilibrationTimes,
		primeWaitTimes,
		numberOfPrimes
	};


	(* Prime value max length *)
	primeOptionLength=Length[ToList[primeSolutions]];

	(* Initiate the invalid length options *)


	{
		expandedPrimeOptions,
		nonSampleLengthPrimeOptions
	} =Transpose[
		MapThread[
			Function[{optionName,value},
				(* if the value of the option is not a single value or not the same length *)
				Which[
					(* for single value, expand it*)
					MatchQ[value,Except[_List]],
					{ConstantArray[value, primeOptionLength],{}},

					(* Else check the length, if matched, return nothing*)
					Length[value]===primeOptionLength,
					{value,{}},

					(* Else collect that option *)
					True,
					{value,optionName}
				]
			],
			{allPrimeOptions,allPrimeValueLists}
		]
	];


	{
		expandedPrimeSolutions,
		expandedPrimeSolutionTemperatures,
		expandedPrimeEquilibrationTimes,
		expandedPrimeWaitTimes,
		expandedNumberOfPrimes
	}=expandedPrimeOptions;


	(*- We need the first methods user specified -*)
	firstMethod=FirstCase[methods,ObjectP[],{}];
	(*- The MapThread -*)
	{
		resolvedPrimeSolutionTemperatures,
		resolvedPrimeEquilibrationTimes
	}=Transpose[
		MapThread[
			Function[{primeSolutionTempeature,primeEquilibrationTime},
				Module[
					{
						resolvedPrimeSolutionTemperature,resolvedPrimeEquilibrationTime
					},

					(* resolved PrimeSolutionTemperature *)
					resolvedPrimeSolutionTemperature=If[
						(* User specified value *)
						MatchQ[primeSolutionTempeature,Except[Automatic]],
						primeSolutionTempeature,

						(* Otherwise set to ambient*)
						Ambient
					];

					(* resolved PrimeSolutionTemperature *)
					resolvedPrimeEquilibrationTime=Which[
						(* User specified value *)
						MatchQ[primeEquilibrationTime,Except[Automatic]],
						primeEquilibrationTime,

						(* Otherwise set based on PrimeSolutionTemperature*)
						MatchQ[resolvedPrimeSolutionTemperature,Except[Ambient|$AmbientTemperature]], 5Minute,

						(* Defult to Null*)
						True, Null

					];
					(* Return resolved values *)
					{resolvedPrimeSolutionTemperature,resolvedPrimeEquilibrationTime}
				]
			],
			{
				expandedPrimeSolutionTemperatures,
				expandedPrimeEquilibrationTimes
			}
		]
	];

	(* Resolved Syringe and Syringe Sizez *)
	resolvedSyringeSize=Which[

		(* Use user specified value *)
		MatchQ[Lookup[roundedUnresolvedOptions,SyringeSize],Except[Automatic]],Lookup[roundedUnresolvedOptions,SyringeSize],

		(* Else check the sample volume, is the max volume smaller than 5 mL, if so use <1 mL *)
		(Max[Lookup[samplePackets,Volume]/.{Null->0Milliliter}]>5Milliliter), 10 Milliliter,

		(* Else resolved to 1 Milliliter *)
		True, 1Milliliter
	];

 	(* resolved the syringe *)
	resolvedSyringe=Which[

		(* Use user specified value *)
		MatchQ[Lookup[roundedUnresolvedOptions,Syringe],Except[Automatic]],Lookup[roundedUnresolvedOptions,Syringe],

		(* Otherwise resolved based on syringe size *)
		MatchQ[resolvedSyringeSize,10Milliliter],Model[Part, Syringe, "10 mL HIAC Injection Syringe"],

		True, Model[Part, Syringe, "1 mL HIAC Injection Syringe"]
	];


	(* Get the resolved Syringe model *)
	resolvedSyringeModel=If[
		MatchQ[resolvedSyringe,ObjectP[Model[Part,Syringe]]],
		resolvedSyringe,
		Download[fetchPacketfromCache[resolvedSyringe,simulatedCache],Object]
	];

	(* Also fetch the packet from the syringe  *)
	syringeModelPacket=cacheLookup[simulatedCache,resolvedSyringeModel];

	(* Check if the syringe is valid *)
	invalidSyringeQ=If[
		MatchQ[suppliedInstrumentModel,ObjectP[Model[Instrument, LiquidParticleCounter, "HIAC 9703 Plus"]]],
		!MatchQ[resolvedSyringeModel,(ObjectP[Model[Part, Syringe, "10 mL HIAC Injection Syringe"]]|ObjectP[Model[Part, Syringe, "1 mL HIAC Injection Syringe"]])],
		False
	];

	(* Return the invalid zoptions *)
	invalidSyringeOptions=If[invalidSyringeQ&& messages && outsideEngine,
		Message[Error::InvalidSyringeForCountLiquidParticles,ObjectToString[suppliedSyringeObjects]];{Syringe},
		Nothing
	];

	(* Build the invalid tests *)
	invalidSyringeTests=If[gatherTests,
		Test["The Syringe can be used for this instrument:",
			!invalidSyringeQ,
			True
		],
		Nothing
	];


	(* Check if the syringe is matching the syringe size *)
	syringeAndSizeMisMatchedQ=Which[
		MatchQ[resolvedSyringeModel,ObjectReferenceP[Model[Part, Syringe, "10 mL HIAC Injection Syringe"]]], !MatchQ[resolvedSyringeSize,10 Milliliter],
		MatchQ[resolvedSyringeModel,ObjectReferenceP[Model[Part, Syringe, "1 mL HIAC Injection Syringe"]]], !MatchQ[resolvedSyringeSize,1 Milliliter],
		True,False
	];

	(* Return the invalid zoptions *)
	invalidSyringeSizeOptions=If[syringeAndSizeMisMatchedQ&& messages && outsideEngine,
		Message[Error::SyringeAndSyringeSizeMismatchedForCountLiquidParticles,ObjectToString[resolvedSyringe],resolvedSyringeSize];{Syringe,SyringeSize},
		Nothing
	];

	(* Build the invalid tests *)
	invalidSyringeSizeTests=If[gatherTests,
		Test["The Syringe matches the syringe size:",
			!syringeAndSizeMisMatchedQ,
			True
		],
		Nothing
	];
	
	(* pre-resolve the AcquisitionMixType since if Stir is needed, we need to make sure sample is in a self-standing container that stirbar can actually spin *)
	{
		resolvedSampleTemperatures,
		resolvedAcquisitionMixes,
		resolvedAcquisitionMixTypes
	} = Transpose[MapThread[
		Function[{optionList, method},
			Module[
				{
					methodPacketForProtocol, stirBar, maxStirAttempt, acquisitionMix, acquisitionMixRate, adjustMixRate, minAcquisitionMixRate, maxAcquisitionMixRate,
					acquisitionMixRateIncrement, acquisitionMixType, numberOfMixes, waitTimeBeforeReading, specifiedStirQ, specifiedSwirlQ, specifiedAcquisitionMixQ,
					resolvedSampleTemperature, resolvedAcquisitionMix, resolvedAcquisitionMixType
				},
				(* Preparation: get the user specified method packet*)
				methodPacketForProtocol = If[MatchQ[method, ObjectP[]], fetchPacketFromCache[Download[method, Object], Flatten[methodPackets]], {}];

				(* lookup options *)
				{
					stirBar,
					maxStirAttempt,
					acquisitionMix,
					acquisitionMixRate,
					adjustMixRate,
					minAcquisitionMixRate,
					maxAcquisitionMixRate,
					acquisitionMixRateIncrement,
					acquisitionMixType,
					numberOfMixes,
					waitTimeBeforeReading,
					sampleTemperature
				} = Lookup[optionList,
					{
						StirBar,
						MaxStirAttempts,
						AcquisitionMix,
						AcquisitionMixRate,
						AdjustMixRate,
						MinAcquisitionMixRate,
						MaxAcquisitionMixRate,
						AcquisitionMixRateIncrement,
						AcquisitionMixType,
						NumberOfMixes,
						WaitTimeBeforeReading,
						SampleTemperature
					}
				];

				(* check to see if user implied using stirring or swirling for mixing *)
				specifiedStirQ = Or[
					MatchQ[stirBar, Except[Null | Automatic]],
					MatchQ[maxStirAttempt, Except[Null | Automatic]],
					MatchQ[acquisitionMixRate, Except[Null | Automatic]],
					MatchQ[adjustMixRate, Except[Null | Automatic | False]],
					MatchQ[minAcquisitionMixRate, Except[Null | Automatic]],
					MatchQ[maxAcquisitionMixRate, Except[Null | Automatic]],
					MatchQ[acquisitionMixRateIncrement, Except[Null | Automatic]]
				];

				specifiedSwirlQ = Or[
					MatchQ[acquisitionMixType, Except[Null | Automatic]],
					MatchQ[numberOfMixes, Except[Null | Automatic]],
					MatchQ[waitTimeBeforeReading, Except[Null | Automatic]]
				];

				(* if any of these two are specified then we will determine that user has specified aquisition mix *)
				specifiedAcquisitionMixQ = Or[
					specifiedStirQ,
					specifiedSwirlQ
				];

				(* resolved SampleTemperature *)
				resolvedSampleTemperature = Which[

					(* Use what user specified *)
					MatchQ[sampleTemperature, Except[Automatic]], sampleTemperature,

					(* if user specified method, get the method *)
					MatchQ[methodPacketForProtocol, PacketP[]], Lookup[methodPacketForProtocol, SampleTemperature, Ambient],

					(* for 1mL syringe, set it to room temperature *)
					True, Ambient

				];

				(* Now resolve all AcquisitionMix Options *)
				resolvedAcquisitionMix = Which[

					(* Use user specified value *)
					MatchQ[acquisitionMix, Except[Automatic]], acquisitionMix,

					(* if user specified method, use the method value*)
					MatchQ[methodPacketForProtocol, PacketP[]], Lookup[methodPacketForProtocol, AcquisitionMix],

					(* If we specified a additional temperature we want to acqui mix *)
					!MatchQ[resolvedSampleTemperature, Ambient | EqualQ[$AmbientTemperature]], True,

					(* Otherwise just return the boolean about if we have specified acquisitionMix*)
					True, specifiedAcquisitionMixQ

				];

				(* resolve acquisition mix type *)
				resolvedAcquisitionMixType = Which[

					(* Use user specified value *)
					MatchQ[acquisitionMixType, Except[Automatic]],
					acquisitionMixType,

					(* if user specified method, use the method value*)
					MatchQ[methodPacketForProtocol, PacketP[]], Lookup[methodPacketForProtocol, AcquisitionMixType],

					(* if any stir options are filled resolved to Stir *)
					Or[specifiedStirQ, resolvedAcquisitionMix], Stir,

					(* Default to Null *)
					True, Null
				];

				(* return *)
				{
					resolvedSampleTemperature,
					resolvedAcquisitionMix,
					resolvedAcquisitionMixType
				}
			]
		],
		{mapThreadFriendlyOptions, methods}
	]];

	(* Before resolving the options, check if aliquot container has been specified *)
	suppliedAliquotContainerModels=Map[
		Which[

			(* Do nothing for automatic *)
			MatchQ[#,(Automatic|Null)],#,

			(* Do nothing if it's already a model *)
			MatchQ[#,ObjectP[Model[Container]]],#,

			(* If it's a {position, model}, take the model *)
			MatchQ[#[[-1]],ObjectP[Model[Container]]],Last[#],

			(* fetch the model from the packet*)
			MatchQ[#,ObjectP[Object[Container]]],Download[Lookup[fecthPacketFromCache[#,simulatedCache],Model],Object],

			(* If it's a {position, Object}, take the fetch the model of the object *)
			MatchQ[#[[-1]],ObjectP[Object[Container]]],Download[Lookup[fecthPacketFromCache[Last[#],simulatedCache],Model],Object],

			(* otherwise do nothing*)
			True, #

		]&,
		(Lookup[mapThreadFriendlyOptions,AliquotContainer])
	];

	(* Now check if all container models are compatible for the footprint for this *)
	inputContainerCompatibleBools= MapThread[
		Function[{compatibleFootprintQ, containerModelPacket, resolvedAcquisitionMixType},
			And[
				(* dimensions must match *)
				TrueQ[FirstOrDefault[compatibleFootprintQ, compatibleFootprintQ]],
				Or[
					(* if we are stirring, then the container must be self-standing *)
					MatchQ[resolvedAcquisitionMixType, Stir] && TrueQ[Lookup[containerModelPacket, SelfStanding]],
					(* if we are not stirring, we do not care if sample is in a self-standing container or not *)
					!MatchQ[resolvedAcquisitionMixType, Stir]
				]
			]
		],
		{
			(* we do not care about footprint match, just make sure the dimensions fit since we will try to find a rack anyway *)
			ToList @ CompatibleFootprintQ[
				ConstantArray[ToList[suppliedInstrumentModel], Length[Lookup[sampleContainerModelPackets, Object]]],
				Lookup[sampleContainerModelPackets, Object],
				ExactMatch -> False
			],
			sampleContainerModelPackets,
			resolvedAcquisitionMixTypes
		}
	];


	(* Define the RequiredAliquotContainers we have to aliquot if the samples are not in a compatible container *)
	requiredAliquotContainers = Flatten[MapThread[
		Function[{compatibleQ, simulatedSample, resolvedAcquisitionMixType},
			Which[
				(* If input sample is in a suitable container, not asking to aliquot*)
				compatibleQ,
				Null,
				(* if we are stirring, we will have to find a container that is selfstanding, and fits inside the instrument *)
				MatchQ[resolvedAcquisitionMixType, Stir],
				(First[Quiet[AliquotContainers[suppliedInstrumentModel, simulatedSample, ExactMatch -> False, SelfStanding -> True, Cache -> simulatedCache, Simulation -> updatedSimulation]]]),
				(* otherwise we do not really care what aliquot as long as it fits inside the instrument *)
				True,
				(First[Quiet[AliquotContainers[suppliedInstrumentModel, simulatedSample, ExactMatch -> False, Cache -> simulatedCache, Simulation -> updatedSimulation]]])
			]
		],
		{inputContainerCompatibleBools, simulatedSamples, resolvedAcquisitionMixTypes}
	]];


	(* MapThread to resolve the IndexMatched Options *)
	{
		(*1*)resolvedParticleSizes,
		(*2*)resolvedDilutionCurves,
		(*3*)resolvedSerialDilutionCurves,
		(*4*)resolvedDiluents,
		(*5*)resolvedStirBars,
		(*6*)resolvedMaxStirAttempts,
		(*7*)resolvedReadingVolumes,
		(*9*)resolvedNumberOfReadings,
		(*10*)resolvedEquilibrationTimes,
		(*11*)resolvedPreRinseVolumes,
		(*14*)resolvedAcquisitionMixRates,
		(*15*)resolvedAdjustMixRates,
		(*16*)resolvedMinAcquisitionMixRates,
		(*17*)resolvedMaxAcquisitionMixRates,
		(*18*)resolvedAcquisitionMixRateIncrements,
		(*19*)resolvedWashSolutionTemperatures,
		(*20*)resolvedWashEquilibrationTimes,
		(*21*)resolvedWashWaitTimes,
		(*22*)resolvedDilutionMixVolumes,
		(*23*)resolvedDilutionMixRates,
		(*24*)resolvedDilutionContainers,
		(*25*)resolvedDilutionStorageConditions,
		(*26*)resolvedDilutionNumberOfMixes,
		(*27*)resolvedWashSolutions,
		(*28*)resolvedNumberOfWashes,
		(*29*)resolvedSaveCustomMethods,
		(*30*)resolvedDiscardFirstRuns,
		(*32*)resolvedNumberOfMixesList,
		(*33*)resolvedWaitTimeBeforeReadings,
		(*34*)resolvedSamplingHeights,

		(* other returned values*)
		(*1*)sampleLoadingVolumes,
		(*2*)requiredSampleVolumes,
		(*3*)numAspirations,
		(*4*)unNeededDilutionOptionList,
		(*5*)requiredDilutionOptionList,
		(*6*)unNeededAcquisitionMixOptionList,
		(*7*)requiredAcquisitionMixOptionList,
		(*8*)unNeededAdjustMixRateOptionList,
		(*9*)requiredAdjustMixRateOptionList,
		(*10*)inConsistentOptionList,
		(*11*)dilutionLengthList,
		(*12*)dilutedSampleVolumeList,
		(*13*)conflictingMixingOptionsList,
		(*14*)minSampleHeights,
		(*15*)stirBarCoverHeights,

		(*Warnings*)
		(*1*)countLiquidPartcielDilutionBools,
		(*2*)duplicateParticleSizesBools,

		(* Errors *)
		(*1*)notEnoughVolumeBools,
		(*2*)dilutionCurveVolumeBools,
		(*3*)dilutionContainerBools,
		(*4*)invalidStirBarBools,
		(*5*)invalidMinAcquisitionMixRateBools,
		(*6*)invalidMaxAcquisitionMixRateBools,
		(*7*)invalidAcquisitionMixRateIncrementBools,
		(*8*)dilutionContainerLengthMisMatchedBools,
		(*9*)liquidLevelCoverStirBarBools,
		(*10*)sampleHeightBools

	}=Transpose[
		MapThread[
			Function[
				{
					optionList,
					samplePacket,
					sampleModelPacket,
					sampleContainerModelPacket,
					method,
					suppliedAliquotContainerModel,
					inputContainerCompatibleBool,
					requiredAliquotContainer,
					resolvedSampleTemperature,
					resolvedAcquisitionMix,
					resolvedAcquisitionMixType
				},
				Module[
					{
						particleSize, dilutionCurve, serialDilutionCurve, diluent, stirBar, maxStirAttempt, readingVolume,
						equilibrationTime, preRinseVolume, acquisitionMixRate, adjustMixRate,acquisitionMixType, numberOfMixes, waitTimeBeforeReading,
						minAcquisitionMixRate, maxAcquisitionMixRate, acquisitionMixRateIncrement, washSolutionTemperature,
						washEquilibrationTime, washWaitTime, resolvedParticleSize, resolvedDilutionCurve,
						resolvedSerialDilutionCurve, resolvedDiluent, resolvedStirBar, resolvedMaxStirAttempt, resolvedReadingVolume,
						resolvedEquilibrationTime, resolvedPreRinseVolume, sampleLoadingVolume,nominalParticleSizes,
						resolvedAcquisitionMixRate, resolvedAdjustMixRate, resolvedMinAcquisitionMixRate, resolvedMaxAcquisitionMixRate,
						resolvedAcquisitionMixRateIncrement,resolvedWashSolution, resolvedNumberOfWash, resolvedWashSolutionTemperature, resolvedWashEquilibrationTime,
						resolvedWashWaitTime, methodPacketForProtocol, specifiedDiluationQ, resolvedDilutionMixVolume, resolvedDilutionMixRate,
						resolvedUnExpandedDilutionContainer,resolvedDilutionContainer, resolvedDilutionStorageCondition, resolvedDilutionNumberOfMix,numAspiration,
						sampleSolvent, dilutionMixVolume, dilutionMixRate, dilutionContainer, dilutionStorageCondition, dilutionNumberOfMix,
						notEnoughVolumeError,dilutionCurveVolumeError,dilutionContainerLengthMisMatchedQ,serialDilutionVolume,
						countLiquidPartcielDilutionWarning,dilutionContainerError,dilutionSampleVolumes, requiredSampleVolume, maxVolume,
						numberOfDilutionWell, requiredWell, requiredRow, numberOfReading, resolvedNumberOfReading,
						unNeededDilutionOptions,requiredDilutionOptions, allCompatibleStirBars,invalidStirBarError, specifiedAdjustMixRateQ,unNeededAcquisitionMixOptions,
						requiredAcquisitionMixOptions,unNeededAdjustMixRateOptions,requiredAdjustMixRateOptions,
						invalidMinAcquisitionMixRateError, invalidMaxAcquisitionMixRateError, invalidAcquisitionMixRateIncrementError,
						washSolution,numberOfWash, inConsistentOptionNames,saveCustomMethod,discardFirstRun, samplingHeight,
						resolvedDiscardFirstRun,resolvedSamplingHeight,resolvedSaveCustomMethod, dilutionLength, dilutedSampleVolume,
						stirQ, swirlQ, resolvedNumberOfMixes, resolvedWaitTimeBeforeReading,
						conflictingMixingOptions,duplicateParticleSizesWarning,
						resolvedStirBarModelPacket, readingContainerModelPacket, calibrationFunction,minSampleVolume,
						minSampleHeight, stirBarCoverHeight, stirBarDeadHeight, liquidLevelCoverStirBarError, sampleHeightError,
						rawCalibrationFunction, inputUnit, outputUnit, inverseFunction, stirBarStirringHeight, latestVolumeCalibration
					},

					(*get the information from optionList *)
					{
						(*1*)particleSize,
						(*2*)dilutionCurve,
						(*3*)serialDilutionCurve,
						(*4*)diluent,
						(*5*)stirBar,
						(*6*)maxStirAttempt,
						(*7*)readingVolume,
						(*8*)sampleTemperature,
						(*9*)numberOfReading,
						(*10*)equilibrationTime,
						(*11*)preRinseVolume,
						(*13*)acquisitionMix,
						(*14*)acquisitionMixRate,
						(*15*)adjustMixRate,
						(*16*)minAcquisitionMixRate,
						(*17*)maxAcquisitionMixRate,
						(*18*)acquisitionMixRateIncrement,
						(*19*)washSolutionTemperature,
						(*20*)washEquilibrationTime,
						(*21*)washWaitTime,
						(*22*)dilutionMixVolume,
						(*23*)dilutionMixRate,
						(*24*)dilutionContainer,
						(*25*)dilutionStorageCondition,
						(*26*)dilutionNumberOfMix,
						(*27*)washSolution,
						(*28*)numberOfWash,
						(*29*)saveCustomMethod,
						(*30*)discardFirstRun,
						(*31*)acquisitionMixType,
						(*32*)numberOfMixes,
						(*33*)waitTimeBeforeReading,
						(*34*)samplingHeight
					}=Lookup[optionList,
						{
							(*1*)ParticleSizes,
							(*2*)DilutionCurve,
							(*3*)SerialDilutionCurve,
							(*4*)Diluent,
							(*5*)StirBar,
							(*6*)MaxStirAttempts,
							(*7*)ReadingVolume,
							(*8*)SampleTemperature,
							(*9*)NumberOfReadings,
							(*10*)EquilibrationTime,
							(*11*)PreRinseVolume,
							(*13*)AcquisitionMix,
							(*14*)AcquisitionMixRate,
							(*15*)AdjustMixRate,
							(*16*)MinAcquisitionMixRate,
							(*17*)MaxAcquisitionMixRate,
							(*18*)AcquisitionMixRateIncrement,
							(*19*)WashSolutionTemperature,
							(*20*)WashEquilibrationTime,
							(*21*)WashWaitTime,
							(*22*)DilutionMixVolume,
							(*23*)DilutionMixRate,
							(*24*)DilutionContainer,
							(*25*)DilutionStorageCondition,
							(*26*)DilutionNumberOfMixes,
							(*27*)WashSolution,
							(*28*)NumberOfWashes,
							(*29*)SaveCustomMethod,
							(*30*)DiscardFirstRun,
							(*31*)AcquisitionMixType,
							(*32*)NumberOfMixes,
							(*33*)WaitTimeBeforeReading,
							(*34*)SamplingHeight
						}
					];

					(* Preparation: get the user specified method packet*)
					methodPacketForProtocol=If[MatchQ[method, ObjectP[]],fetchPacketFromCache[Download[method,Object],Flatten[methodPackets]],{}];

					nominalParticleSizes=If[NullQ[sampleModelPacket],Null,Lookup[sampleModelPacket,NominalParticleSize]];

					(* Resolved Particle Size *)
					resolvedParticleSize=ToList@Which[

						(* Use user specified value *)
						MatchQ[particleSize,Except[Automatic]],
						DeleteDuplicates[particleSize],

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]],
						Lookup[methodPacketForProtocol,ParticleSize,20Micrometer],

						(* Else let's check the nomial particle size information in the model *)
						DistributionQ[nominalParticleSizes],
						Mean[nominalParticleSizes],

						(* Else check if the Paricle size field in sample object is fillec *)
						DistributionQ[Lookup[samplePacket,ParticleSize]],
						Mean[Lookup[samplePacket,ParticleSize]],

						(* Default to 20 Micrometer *)
						True,
						20Micrometer

					];

					(* Generate a warning for user specified duplicate particle sizes *)
					duplicateParticleSizesWarning=If[
						MatchQ[particleSize,Except[Automatic]],
						Not[SameQ[particleSize,DeleteDuplicates[particleSize]]],
						False
					];

					(* Resolved reading volumes *)
					resolvedReadingVolume=Which[

						(* Use what user specified *)
						MatchQ[readingVolume,Except[Automatic]],readingVolume,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,ReadingVolume,200Microliter],

						(* Else resolved based on syringe size *)
						MatchQ[resolvedSyringeSize,10Milliliter], 200Microliter,

						(* for 1mL syringe, set it to 50 microliter *)
						True, 50 Microliter

					];


					(* check if the user specified temperature are with in the min and max temperature of the instrument *)

					(* resolved SampleTemperature *)
					resolvedNumberOfReading=Which[

						(* Use what user specified *)
						MatchQ[numberOfReading,Except[Automatic]],numberOfReading,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,NumberOfReading,3],

						(* for 1mL syringe, set it to 200 microliter *)
						True, 3

					];

					(* Number of aspiration *)
					numAspiration=Ceiling[(resolvedReadingVolume/resolvedSyringeSize)];


					(* Required sample volume: the experiment need to aliquot ReadingVolume+SyringeMinVolume to proceed *)
					sampleLoadingVolume=(resolvedReadingVolume * resolvedNumberOfReading+resolvedPreRinseVolume+Lookup[syringeModelPacket,MinVolume,20Microliter]);

					(* Now resolved the equilibration time*)
					resolvedEquilibrationTime=Which[
						(* use user specified value *)
						MatchQ[equilibrationTime,Except[Automatic]], equilibrationTime,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,EquilibrationTime],

						(* else is the sampleTemperature not embient*)
						MatchQ[resolvedSampleTemperature,Except[Ambient|$AmbientTemperature]], 5Minute,

						(* Else default to 0 Minute *)
						True, 0 Minute

					];

					(* Now resolved DiscardFirstRun*)
					resolvedDiscardFirstRun=Which[
						(* use user specified value *)
						MatchQ[discardFirstRun,Except[Automatic]], discardFirstRun,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DiscardFirstRun],

						(* Else default to 0 Minute *)
						True, True

					];

					(* resolved PreRinseVolume *)
					resolvedPreRinseVolume=Which[

						(* Use user specified value*)
						MatchQ[preRinseVolume,Except[Automatic]], preRinseVolume,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,PreRinseVolume,0Milliliter],

						(* If we discard the first run, we don't need a prerinse *)
						resolvedDiscardFirstRun,0 Milliliter,

						(* otherwise use syringe size value *)
						True, Min[10 * resolvedReadingVolume, resolvedSyringeSize]
					];


					(* Resolved DilutionCurve *)
					specifiedDiluationQ=Or[
						MatchQ[dilutionCurve,Except[Null|Automatic]],
						MatchQ[serialDilutionCurve,Except[Null|Automatic]],
						MatchQ[dilutionMixVolume,Except[Null|Automatic]],
						MatchQ[dilutionMixRate,Except[Null|Automatic]],
						MatchQ[dilutionContainer,Except[Null|{Null..}|Automatic]],
						MatchQ[dilutionStorageCondition,Except[Null|Automatic]],
						MatchQ[dilutionNumberOfMix,Except[Null|Automatic]]
					];

					(* Check if solvent is specified *)
					sampleSolvent=Which[
						MatchQ[Lookup[samplePacket,Solvent],ObjectP[Model[Sample]]],
							Download[Lookup[samplePacket,Solvent],Object],
						NullQ[sampleModelPacket],
							Null,
						MatchQ[Lookup[sampleModelPacket,Solvent],ObjectP[Model[Sample]]],
							Download[Lookup[sampleModelPacket,Solvent],Object],
						True,
							Null
					];


					(* resolvedDiluent*)
					resolvedDiluent=Which[
						(*use user specified value*)
						MatchQ[diluent,Except[Automatic]], diluent,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,Diluent],

						(*will there be no diluting?*)
						specifiedDiluationQ&&MatchQ[sampleSolvent,ObjectP[{Model[Sample],Object[Sample]}]], sampleSolvent,

						specifiedDiluationQ,Model[Sample,"Milli-Q water"],

						(* Default to Null*)
						True, Null
					];


					(* Set more error tracking variables *)
					{dilutionCurveVolumeError,countLiquidPartcielDilutionWarning, dilutionContainerError}={False,False,False};

					(* Resolved SerialDilutionCurve *)
					resolvedSerialDilutionCurve=Which[

						(* Use what user specified value *)
						MatchQ[serialDilutionCurve,Except[Automatic]],serialDilutionCurve,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,SerialDilutionCurve]/.{{}->Null},

						(* if users have specified dilution curve, this goes to Null *)
						MatchQ[dilutionCurve,Except[Null|Automatic]],Null,

						(* No relevant options is set or DilutionCurve is already specified, set to Null*)
						Or[And[MatchQ[resolvedDiluent,Null],MatchQ[dilutionContainer,(Null | Automatic)]],MatchQ[dilutionCurve,Except[Null|Automatic]]],Null,

						(* Otherwise set to a default value *)
						True,{2 Milliliter,{0.1,4}}
					];

					(* Resolved SerialDilutionCurve *)
					resolvedDilutionCurve=Which[

						(* Use what user specified value *)
						MatchQ[dilutionCurve,Except[Automatic]],dilutionCurve,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DilutionCurve]/.{{}->Null},

						(* if we have resolved serial dilution curve, this goes to Null *)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]],Null,

						(* No relevant options is set or DilutionCurve is already specified, set to Null*)
						Or[And[MatchQ[resolvedDiluent,Null],MatchQ[dilutionContainer,(Null | Automatic)]],MatchQ[serialDilutionCurve,Except[Null|Automatic]]],Null,

						(* Otherwise set to a default value *)
						True, {{2Milliliter,0.5}}
					];

					(* Checking conflicts for DilutionCurve *)
					dilutionSampleVolumes=Which[
						MatchQ[resolvedDilutionCurve, {VolumeP, VolumeP} | {{VolumeP, VolumeP} ..}], Total[#] & /@ resolvedDilutionCurve,
						MatchQ[resolvedDilutionCurve, {VolumeP, RangeP[0,1]} | {{VolumeP, RangeP[0,1]} ..}], First[#] & /@ resolvedDilutionCurve,
						True, Null
					];

					(*serial dilution volume*)
					serialDilutionVolume=Which[
						MatchQ[resolvedSerialDilutionCurve, {VolumeP, VolumeP, _Integer}], resolvedSerialDilutionCurve[[2]],
						(!NullQ[resolvedSerialDilutionCurve]), FirstOrDefault[resolvedSerialDilutionCurve],
						True,Null
					];

					(* How much sample we will have after the dilution *)
					dilutedSampleVolume=If[
						(!NullQ[dilutionSampleVolumes]),
						dilutionSampleVolumes,
						serialDilutionVolume
					];

					(*Check volume conflicts*)
					{dilutionCurveVolumeError,countLiquidPartcielDilutionWarning}=Which[
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]],
						If[

							(*TransferVolume or samplevolume<loadingvolume?*)
							MatchQ[serialDilutionVolume,GreaterP[sampleLoadingVolume]], {False,True},
							(*not too little, not too much*)
							{True,False}
						],
						MatchQ[resolvedDilutionCurve,Except[Null|{}]],
						If[
							AnyTrue[dilutionSampleVolumes,MatchQ[#,GreaterP[sampleLoadingVolume]] &]&&MatchQ[dilutionStorageCondition,Automatic|Disposal],{False,True},
							(*Is not too little, not too much*)
							{True,False}
						],
						True,{False,False}
					];

					(* Resolving DilutionMixVolume Option *)
					resolvedDilutionMixVolume=Which[

						(* Use user specified value*)
						MatchQ[dilutionMixVolume,Except[Automatic]], dilutionMixVolume,

						(* If a method is specified, use method specified value *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DilutionMixVolume],

						(*Is the DilutionCurve set to No Dilution or Null by the user?*)
						MatchQ[resolvedSerialDilutionCurve,Null]&&MatchQ[resolvedDilutionCurve,Null], Null,

						(*Is it a serial dilution with a given transfer volume*)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]], Min[900Microliter,0.5*First[First[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]]],

						(* for fixed dilution, use the sample volume*)

						MatchQ[resolvedDilutionCurve,Except[Null|{}]],Min[900Microliter,0.5*Total[First/@resolvedDilutionCurve]],

						(* Catch all to default for 100 Microliter *)
						True,100 Microliter
					];


					(* Check how much sample do we need for this experiment *)
					requiredSampleVolume=Which[
						(*Is a serial Dilution specified?*)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]],First[First[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]],

						(*Is a custom Dilution specified?*)
						MatchQ[resolvedDilutionCurve,Except[Null|{}]],Total[First[calculatedDilutionCurveVolumes[resolvedDilutionCurve]]],

						(* Default to loading volume*)
						True,sampleLoadingVolume
					];


					(* check if we have enough volume  *)
					notEnoughVolumeError=requiredSampleVolume>(Lookup[samplePacket,Volume]/.Null->0Milliliter);

					(*Find the max volume to see if the dilution container is too small*)
					maxVolume=Which[
						(*Is a serial Dilution specified?*)
						(*the transfer volume plus the diluent volume*)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]], Max[First[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]+Last[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]],
						(*Is a custom Dilution specified?*)
						MatchQ[resolvedDilutionCurve,Except[Null|{}]],Max[First[calculatedDilutionCurveVolumes[resolvedDilutionCurve]]+Last[calculatedDilutionCurveVolumes[resolvedDilutionCurve]]],
						True,sampleLoadingVolume
					];

					(*resolve all the container object/model parts of the dilution curve by if there is diluting, the container indices will be resolved later*)
					resolvedUnExpandedDilutionContainer=Which[

						(*user specified*)
						MatchQ[dilutionContainer,Except[Automatic]], dilutionContainer,

						(* If a method is specified, use method specified value *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DilutionContainer],

						(*For Automatic case, check if there needs to be a container;If there is any diluting*)
						MatchQ[resolvedDilutionCurve, Null]&&MatchQ[resolvedSerialDilutionCurve, Null],Null,

						(*If other wise use the default value*)
						maxVolume<50Milliliter, Model[Container, Vessel, "50mL Tube"],
						maxVolume<150Milliliter, Model[Container, Vessel, "150 mL Glass Bottle"],

						(* True call preferred container to get a container*)
						True, FirstOrDefault[
							Quiet[
								AliquotContainers[
									suppliedInstrumentModel,
									Download[Lookup[samplePacket,Object],Object],
									ExactMatch->False,
									Cache->simulatedCache,
									Simulation->updatedSimulation
								],
								{Download::MissingCacheField}
							]
						]

					];

					(* get the dilution length *)
					dilutionLength=Which[

						(*Is a serial Dilution specified?*)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]],
						Which[
							MatchQ[resolvedSerialDilutionCurve, {VolumeP, VolumeP, _Integer}], resolvedSerialDilutionCurve[[3]],
							MatchQ[resolvedSerialDilutionCurve, {VolumeP, {GreaterP[0],_Integer}}],Last[Last[resolvedSerialDilutionCurve]],
							True,Length[Last[resolvedSerialDilutionCurve]]
						],

						(*Is a custom Dilution specified?*)
						MatchQ[resolvedDilutionCurve,Except[Null|{}]],Length[resolvedDilutionCurve],

						(* Default to loading volume*)
						True,0

					];

					(* Expand our resolved results *)
					{resolvedDilutionContainer,dilutionContainerLengthMisMatchedQ}=Which[


						NullQ[resolvedUnExpandedDilutionContainer],{Null,False},

						(* Expand the container *)
						Length[ToList[resolvedUnExpandedDilutionContainer]]==1, {ConstantArray[First[ToList[resolvedUnExpandedDilutionContainer]], dilutionLength],False},

						(* check if the specified length are the same *)
						Length[ToList[resolvedUnExpandedDilutionContainer]]==dilutionLength, {ToList[resolvedUnExpandedDilutionContainer],False},

						(*  Else return an error *)
						True,{ToList[resolvedUnExpandedDilutionContainer],True}

					];

					(*Check the error if user specifie a dilution container.*)
					dilutionContainerError=Which[
						(* We will mute this error if the length of containers and sample is not matched with each other*)
						Or[NullQ[resolvedDilutionContainer],MatchQ[dilutionContainer, Automatic]],False,
						MatchQ[resolvedDilutionContainer,Except[Null|{}]], Or[(maxVolume>Lookup[fetchPacketFromFastAssoc[#,fastCacheBall],MaxVolume])&/@resolvedDilutionContainer],
						True, False
					];

					(* Calculate how many dilution well we need for this *)
					numberOfDilutionWell=Which[

						(*Is a serial Dilution specified?*)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]],
						Length[First[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]],
						(*Is a custom Dilution specified?*)
						MatchQ[resolvedDilutionCurve,Except[Null|{}]],
						Length[First[calculatedDilutionCurveVolumes[resolvedDilutionCurve]]],
						True,0
					];

					(* How many well do we need for each dilution *)
					{requiredWell,requiredRow}=Which[
						(*For a serial dilution case*)
						MatchQ[resolvedSerialDilutionCurve,Except[Null|{}]],{
							(*wells taken up by the curve excluding the calibrant*)
							Length[Last[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]],
							(*rows taken up by the curve*)
							Ceiling[(Length[Last[calculatedDilutionCurveVolumes[resolvedSerialDilutionCurve]]])/11]
						},
						(*For a direct dilution case*)
						MatchQ[resolvedDilutionCurve,Except[Null|{}]],{
							(*length of the curve*)
							Length[resolvedDilutionCurve],
							(*rows taken up by the curve*)
							Ceiling[Length[resolvedDilutionCurve]/11]
						},
						(*Is the plate prepared plate or do diluting*)
						True,{1,1}
					];

					(* Resolve dilution mix rate *)
					resolvedDilutionMixRate=Which[

						(* Use user specified value *)
						MatchQ[dilutionMixRate,Except[Automatic]], dilutionMixRate,

						(* if user specified method, use the method value*)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DilutionMixRate],

						(* if we don't do any dilution, resolve to Null *)
						(MatchQ[resolvedDilutionCurve,Null]&&MatchQ[resolvedSerialDilutionCurve,Null]),Null,

						(* Otherwise resolved to 100 Microliter/Second *)
						True, 200 Microliter/Second
					];


					(*Resolve DilutionNumberofMixes*)
					resolvedDilutionNumberOfMix=Which[

						(* Use user specified value *)
						MatchQ[dilutionNumberOfMix,Except[Automatic]], dilutionNumberOfMix,

						(* if user specified method, use the method value*)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DilutionCurve]/.{{}->Null},

						(* If both dilutions are set to null, number of mixes should also be Null *)
						(MatchQ[resolvedDilutionCurve,Null]&&MatchQ[resolvedSerialDilutionCurve,Null]),Null,

						(* If specified dilution, default this value to 5 *)
						True,5
					];


					(* resolved DilutionStorageCondition *)
					resolvedDilutionStorageCondition= Which[

						(* Use user specified value *)
						MatchQ[dilutionStorageCondition,Except[Automatic]], dilutionStorageCondition,

						(* if user specified method, use the method value*)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,DilutionStorageCondition],

						(* If both dilutions are set to null, number of mixes should also be Null *)
						(MatchQ[resolvedDilutionCurve,Null]&&MatchQ[resolvedSerialDilutionCurve,Null]),Null,

						(* If specified dilution default this to disposal *)
						True,Disposal
					];


					(* Now check if any of the options are unneeded for dilution or serial dilution *)
					{unNeededDilutionOptions,requiredDilutionOptions}=If[(MatchQ[resolvedDilutionCurve,(Null|{})]&&MatchQ[resolvedSerialDilutionCurve,(Null|{})]),
						(* If both dilution curve are resolved to Null, all related options should be resolved to Null *)
						{
							PickList[
								{
									Diluent,
									DilutionMixVolumes,
									DilutionMixRates,
									DilutionContainers,
									DilutionStorageConditions,
									DilutionNumberOfMixes
								},
								{
									resolvedDiluent,
									resolvedDilutionMixVolume,
									resolvedDilutionMixRate,
									resolvedDilutionContainer,
									resolvedDilutionStorageCondition,
									resolvedDilutionNumberOfMix
								},
								Except[Null|{Null...}]
							],
							{}
						},
						{
							{},
							PickList[
								{
									Diluent,
									DilutionMixVolumes,
									DilutionMixRates,
									DilutionContainers,
									DilutionStorageConditions,
									DilutionNumberOfMixes
								},
								{
									resolvedDiluent,
									resolvedDilutionMixVolume,
									resolvedDilutionMixRate,
									resolvedDilutionContainer,
									resolvedDilutionStorageCondition,
									resolvedDilutionNumberOfMix
								},
								(Null|{Null...})
							]
						}
					];

					(* --- Now resolve acquisition mix options ---*)

					(* Build a shorthand for stirring with stir bar *)
					stirQ= resolvedAcquisitionMix&&MatchQ[resolvedAcquisitionMixType,Stir];
					swirlQ= resolvedAcquisitionMix&&MatchQ[resolvedAcquisitionMixType,Swirl];

					(* User cannot specify both type of mixing *)
					conflictingMixingOptions=Which[
						stirQ, PickList[
							{NumberOfMixes,WaitTimeBeforeReading},
							{numberOfMixes,waitTimeBeforeReading},
							Except[Null|Automatic]
						],
						swirlQ, PickList[
							{StirBar,MaxStirAttempt,AcquisitionMixRate,AdjustMixRate,MinAcquisitionMixRate,MaxAcquisitionMixRate,AcquisitionMixRateIncrement},
							{stirBar,maxStirAttempt,acquisitionMixRate,adjustMixRate,minAcquisitionMixRate,maxAcquisitionMixRate,acquisitionMixRateIncrement},
							Except[Null|Automatic]
						],
						True,{}
					];

					(* Resolved stir bar  *)
					(* For the container we have check all compatible stir bars *)
					(* First use compatibleStirBar to get all usable stir bars, only check this when resolvedAcquisitionMix is True *)
					allCompatibleStirBars=Which[

						(* if user specified aliquot container, get all possible stir bars for the model of specified aliquot containers *)
						stirQ&&MatchQ[suppliedAliquotContainerModel,ObjectP[Model[Container]]],
						Experiment`Private`compatibleStirBars[suppliedAliquotContainerModel,Cache->simulatedCache,Simulation->updatedSimulation],
						
						(* if we are going to aliquot into a new container, use the aliquot container *)
						stirQ&&(!NullQ[requiredAliquotContainer]),
						Experiment`Private`compatibleStirBars[requiredAliquotContainer,Cache->simulatedCache,Simulation->updatedSimulation],

						(* else the input sample is in a good container, so get all compatible stirbars for the input sample *)
						stirQ,
						Experiment`Private`compatibleStirBars[Lookup[samplePacket,Object],Cache->simulatedCache,Simulation->updatedSimulation],

						(* otherwise just return an empty list *)
						True,
						{}
					];

					(* now resolve the stir bar *)
					resolvedStirBar=Which[

						(* Use user specified value *)
						MatchQ[stirBar,Except[Automatic]],stirBar,

						(* If user spefied method, use the method value *)
						MatchQ[methodPacketForProtocol,PacketP[]], Download[Lookup[methodPacketForProtocol,StirBar],Object],

						(* Resolve the basedon if AcquisitionMix if True, use the first of stir bars value *)
						True, FirstOrDefault[allCompatibleStirBars]

					];

					(* now that we have resolved the stir bar check it's in consistency*)
					invalidStirBarError=If[stirQ && !MatchQ[resolvedStirBar, Null],
						!MemberQ[allCompatibleStirBars,resolvedStirBar],
						False
					];

					(* Now resolve the AcqisitionMixRate *)
					resolvedAcquisitionMixRate=Which[

						(* Use user specified value *)
						MatchQ[acquisitionMixRate,Except[Automatic]],acquisitionMixRate,

						(* Use what method specified *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,AcquisitionMixRate],

						(* If required Acquisition Mix set to 500 RPM *)
						stirQ, 200 RPM,

						(* Catch all with Null *)
						True, Null

					];

					(* Now resolved all AdjustMixRate  *)
					specifiedAdjustMixRateQ=Or[
						MatchQ[resolvedMinAcquisitionMixRate,Except[Null|Automatic]],
						MatchQ[resolvedMaxAcquisitionMixRate,Except[Null|Automatic]],
						MatchQ[resolvedMaxStirAttempt,Except[Null|Automatic]],
						MatchQ[resolvedAcquisitionMixRateIncrement,Except[Null|Automatic]]
					];

					(* resolvedAdjustMixRate *)
					resolvedAdjustMixRate=Which[
						(* Use user specified value *)
						MatchQ[adjustMixRate,Except[Automatic]],adjustMixRate,

						(* Use method specified value *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,AdjustMixRate],

						(* Otherwise set based on stirQ option *)
						True, stirQ

					];

					(* resolve MinAcquisitionMixRate *)
					resolvedMinAcquisitionMixRate=Which[
						(* Use user specified values *)
						MatchQ[minAcquisitionMixRate,Except[Automatic]],minAcquisitionMixRate,

						(* If user specified a method, use the value from the method object *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,MinAcquisitionMixRate],

						(* Otherwise resolved based on resolvedAdjustMixRate *)
						resolvedAdjustMixRate&&stirQ,Round[0.8*resolvedAcquisitionMixRate,10RPM],

						(* Default to Null then *)
						True, Null

					];

					(* resolve MaxAcquisitionMixRate *)
					resolvedMaxAcquisitionMixRate=Which[
						(* Use user specified values *)
						MatchQ[maxAcquisitionMixRate,Except[Automatic]],maxAcquisitionMixRate,

						(* If user specified a method, use the value from the method object *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,MaxAcquisitionMixRate],

						(* Otherwise resolved based on resolvedAdjustMixRate *)
						resolvedAdjustMixRate&&stirQ,Round[1.2*resolvedAcquisitionMixRate,10RPM],

						(* Default to Null then *)
						True, Null

					];

					(* resolve MaxStirAttempt *)
					resolvedMaxStirAttempt=Which[
						(* Use user specified values *)
						MatchQ[maxStirAttempt,Except[Automatic]],maxStirAttempt,

						(* If user specified a method, use the value from the method object *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,MaxStirAttempt],

						(* Otherwise resolved based on resolvedAdjustMixRate *)
						resolvedAdjustMixRate&&stirQ,5,

						(* Default to Null then *)
						True, Null

					];

					(* resolve AcquisitionMixRateIncrement *)
					resolvedAcquisitionMixRateIncrement=Which[
						(* Use user specified values *)
						MatchQ[acquisitionMixRateIncrement,Except[Automatic]],acquisitionMixRateIncrement,

						(* If user specified a method, use the value from the method object *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,AcquisitionMixRateIncrement],

						(* Otherwise resolved based on resolvedAdjustMixRate *)
						resolvedAdjustMixRate&&stirQ,20RPM,

						(* Default to Null then *)
						True, Null

					];

					(* Resolve the options for Swirl related options *)
					(* Resolve NumberOfMixes *)
					resolvedNumberOfMixes=Which[

						(* Use user specified value *)
						MatchQ[numberOfMixes,Except[Automatic]],numberOfMixes,

						(* If user specified a method, use the value from the method object *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,NumberOfMixes],

						(* If the AcquisitionMixType is set to Swirl, set to reasonable value *)
						swirlQ, 20,

						(* Else set to Null *)
						True, Null

					];

					(* Resolve WaitTimeBeforeReading *)
					resolvedWaitTimeBeforeReading=Which[

						(* Use user specified value *)
						MatchQ[waitTimeBeforeReading,Except[Automatic]],waitTimeBeforeReading,

						(* If user specified a method, use the value from the method object *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,WaitTimeBeforeReading],

						(* If the AcquisitionMixType is set to Swirl, set to reasonable value *)
						swirlQ, 1 Minute,

						(* Else set to Null *)
						True, Null

					];


					(* -- Now check all conflicts here -- *)
					(* Unneeded options for AcquisitionMix*)
					{unNeededAcquisitionMixOptions,requiredAcquisitionMixOptions}=Which[

						(* for AcquisitionMixType is stir*)
						stirQ,
						{
							{},
							PickList[
								{
									AcquisitionMixType,
									StirBar,
									AcquisitionMixRate,
									AdjustMixRate
								},
								{
									resolvedAcquisitionMixType,
									resolvedStirBar,
									resolvedAcquisitionMixRate,
									resolvedAdjustMixRate
								},
								(Null)
							]
						},

						(* for AcquisitionMixType is swirl*)
						swirlQ,
						{
							{},
							PickList[
								{
									AcquisitionMixType,
									NumberOfMixes,
									WaitTimeBeforeReading
								},
								{
									resolvedAcquisitionMixType,
									resolvedNumberOfMixes,
									resolvedWaitTimeBeforeReading
								},
								(Null)
							]
						},

						(* No mix specified*)
						True,
						{
							PickList[
								{
									StirBar,
									MaxStirAttempt,
									AcquisitionMixRate,
									AdjustMixRate,
									MinAcquisitionMixRate,
									MaxAcquisitionMixRate,
									AcquisitionMixRateIncrement
								},
								{
									resolvedStirBar,
									resolvedMaxStirAttempt,
									resolvedAcquisitionMixRate,
									resolvedAdjustMixRate,
									resolvedMinAcquisitionMixRate,
									resolvedMaxAcquisitionMixRate,
									resolvedAcquisitionMixRateIncrement
								},
								Except[(Null|{}|False)]
							],
							{}
						}

					];

					(* Unneeded and required options for AdjustMixRate *)
					{unNeededAdjustMixRateOptions,requiredAdjustMixRateOptions}=If[resolvedAdjustMixRate,
						{
							{},
							PickList[
								{
									MaxStirAttempt,
									MinAcquisitionMixRate,
									MaxAcquisitionMixRate,
									AcquisitionMixRateIncrement
								},
								{
									resolvedMaxStirAttempt,
									resolvedMinAcquisitionMixRate,
									resolvedMaxAcquisitionMixRate,
									resolvedAcquisitionMixRateIncrement
								},
								Null
							]
						},
						{
							PickList[
								{
									MaxStirAttempt,
									MinAcquisitionMixRate,
									MaxAcquisitionMixRate,
									AcquisitionMixRateIncrement
								},
								{
									resolvedMaxStirAttempt,
									resolvedMinAcquisitionMixRate,
									resolvedMaxAcquisitionMixRate,
									resolvedAcquisitionMixRateIncrement
								},
								Except[Null|{}]
							],
							{}
						}

					];

					(* invalid Min and Max AcquisitionMixRate *)
					invalidMinAcquisitionMixRateError=If[
						resolvedAdjustMixRate&&MatchQ[minStirRate,UnitsP[RPM]]&&MatchQ[MatchQ[minStirRate,UnitsP[RPM]],UnitsP[RPM]],
						!(minStirRate<=resolvedMinAcquisitionMixRate<=resolvedAcquisitionMixRate),
						False
					];
					invalidMaxAcquisitionMixRateError=If[
						resolvedAdjustMixRate&&MatchQ[maxStirRate,UnitsP[RPM]]&&MatchQ[MatchQ[maxStirRate,UnitsP[RPM]],UnitsP[RPM]],
						!(maxStirRate>=resolvedMaxAcquisitionMixRate>=resolvedAcquisitionMixRate),
						False
					];
					invalidAcquisitionMixRateIncrementError=If[
						resolvedAdjustMixRate&&MatchQ[resolvedAcquisitionMixRateIncrement,UnitsP[RPM]]&&MatchQ[resolvedMinAcquisitionMixRate,UnitsP[RPM]],
						(resolvedAcquisitionMixRateIncrement>resolvedMinAcquisitionMixRate),
						False
					];

					(* We need the stir bar model packet *)
					resolvedStirBarModelPacket=Which[
						(* stir bar is specified as model *)
						MatchQ[resolvedStirBar,ObjectP[Model[Part, StirBar]]],
						fetchPacketFromFastAssoc[resolvedStirBar,fastCacheBall],

						(* stir bar is specified as object *)
						MatchQ[resolvedStirBar,ObjectP[Object[Part, StirBar]]],
						fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, resolvedStirBar, Model], fastCacheBall],

						(* otherwise just use Null*)
						True, Null
					];

					(* Get the packet where the sample gonna be used when reading the volume *)
					readingContainerModelPacket=Which[

						(* If the sample is about to be diluted, then the dilution container will be used*)
						MatchQ[resolvedDilutionContainer,ObjectP[Model[Container]]],
						fetchPacketFromFastAssoc[resolvedDilutionContainer,fastCacheBall],

						(* if user specified aliquot container then we used the aliquot container*)
						MatchQ[suppliedAliquotContainerModel,ObjectP[Model[Container]]],
						fetchPacketFromFastAssoc[suppliedAliquotContainerModel,fastCacheBall],

						(* If the sample container is not gonna be compatible with the instrument use preferred container*)
						Not[FirstOrDefault[inputContainerCompatibleBool,inputContainerCompatibleBool]], fetchPacketFromFastAssoc[requiredAliquotContainer,fastCacheBall],

						(* else just get the sample container *)
						True, sampleContainerModelPacket
					];

					(* Get the object of the latest volume calibration *)
					latestVolumeCalibration=Download[
						LastOrDefault[
							Lookup[
								readingContainerModelPacket,
								VolumeCalibrations,
								{}
							]
						],
						Object
					];

					(* Get the latest volume calibration *)
					calibrationFunction = If[NullQ[latestVolumeCalibration],
						Null,
						fastAssocLookup[
							fastCacheBall,
							latestVolumeCalibration,
							CalibrationFunction
						]
					];

					(* Note this part was copied from tipsCanAspirateQ in ExpTransfer *)
					(* Our calibration function is a QuantityFunction[rawFunction, ListableP[inputUnits], outputUnit]. *)
					(* Pull out the raw function and invert it since we want to go from volume to distance. *)
					rawCalibrationFunction=If[
						NullQ[calibrationFunction],
						Null,
						calibrationFunction[[1]]
					];

					(* Now get the input units. It's listable so pull out the first distance. *)
					(* NOTE: The input and output unit will get swapped since we're inverting the function. *)
					inputUnit=If[NullQ[calibrationFunction],Null,FirstCase[calibrationFunction[[2]], DistanceP]];
					outputUnit=If[NullQ[calibrationFunction],Null,calibrationFunction[[3]]];

					(* Attempt to invert the function. If we didn't get another function out, then InverseFunction didn't work. *)
					inverseFunction=Quiet[InverseFunction[rawCalibrationFunction]];

					(* Min sample volume after we read all volumes*)
					minSampleVolume = (Lookup[samplePacket,Volume] - sampleLoadingVolume);

					(* Convert to the input unit, strip off the unit, then tack on the output unit. *)
					minSampleHeight=Which[
						(* Cover the edge case when we don't have a calibration function *)
						NullQ[calibrationFunction],
						10 Millimeter,

						MatchQ[inverseFunction, Verbatim[InverseFunction][___]],
						(* Solve analytically. *)
						Module[{uniqueVariable,containerHeight},
							uniqueVariable=Unique[t];
							(* What is the maximum height of the container? Look for InternalDepth first; if not available, use Z-dimension which is external height as estimate. *)
							containerHeight=Which[
								MatchQ[Lookup[readingContainerModelPacket, InternalDepth], DistanceP], Lookup[readingContainerModelPacket, InternalDepth],
								MatchQ[Lookup[readingContainerModelPacket, Dimensions], _List], Lookup[readingContainerModelPacket, Dimensions][[3]],
								True, 0 Meter
							];
							SafeRound[
								Lookup[
									FirstCase[
										Quiet@Solve[
											(* volume = calibrationFunction (with #1 subbed with t so we can solve for t). *)
											Unitless[UnitConvert[Max[{1 Microliter, minSampleVolume}], outputUnit]]==(rawCalibrationFunction[[1]]/.{#->uniqueVariable}),
											uniqueVariable,
											Reals
										],
										(* get the first solution that returns a non-negative value *)
										{uniqueVariable->GreaterEqualP[0]},
										(* If there is no analytical solution, assume the bottle is empty (so it's all the way at the bottom). Set the uniqueVariable as either containerHeight or 0 depending on the characteristic of volume calibration function. *)
										{uniqueVariable->If[rawCalibrationFunction[2]<rawCalibrationFunction[1],Unitless[containerHeight],0]},
										(* don't remove the levelspec or this function will error out *)
										{1}
									],
									uniqueVariable
								] * inputUnit,
								1 Millimeter,
								AvoidZero -> True
							]
						],
						(* Use our symbolic function. *)
						True,
						inverseFunction[
							Unitless[UnitConvert[Max[{1 Microliter, minSampleVolume}], outputUnit]]
						] * inputUnit

					];

					(* Build a variable for stirbar dead height *)
					stirBarDeadHeight = 1 Millimeter;

					(* Calculate how high the stir bar will be when stirring*)
					stirBarStirringHeight= If[NullQ[resolvedStirBarModelPacket],
						0 Millimeter,
						Switch[
							(* Switch based on stir bar shape *)
							Lookup[resolvedStirBarModelPacket,StirBarShape],

							(* If the stir bar is Circular, use a hard code value 9 mm to represent the height, this is because the StirBarWidth cannot represent the occupant width *)
							Circular, 13.5 Millimeter,

							(* Otherwise use the StirBarWidth *)
							_, Lookup[resolvedStirBarModelPacket,StirBarWidth]
						]
					];

					(* Calculate the height need to cover the stir bar when it's stirring *)
					stirBarCoverHeight = Which[

						(* No stir bar *)
						NullQ[resolvedStirBarModelPacket],
						stirBarDeadHeight,

						(* Self-standing, count only the width of the stir bar *)
						TrueQ[Lookup[readingContainerModelPacket,SelfStanding,True]],(stirBarDeadHeight + stirBarStirringHeight),

						(* For not self-standing container, since the stir bar cannot reach the bottom arbitrarily add 10 more millimeter *)
						True, (stirBarStirringHeight + 15Millimeter + stirBarDeadHeight)

					];

					(* After we resolve the stir bar now we resolve the samplingHeight *)
					resolvedSamplingHeight = Which[
						(* use user specified value *)
						MatchQ[samplingHeight, Except[Automatic]], samplingHeight,

						(* if user specified method, get the method *)
						MatchQ[methodPacketForProtocol, PacketP[]] && DistanceQ[Lookup[methodPacketForProtocol, SamplingHeight]], Lookup[methodPacketForProtocol, SamplingHeight],

						(* If not using stir bar default to 5 mm or minSampleHeight whichever is smaller *)
						NullQ[resolvedStirBarModelPacket], Min[5 Millimeter, minSampleHeight],
						(* If we have stir bar, we need to consider where the stir may bring in the height of the solution *)
						(* Here no extra check for stir bar height since we have already taken it into consideration *)
						True, Ceiling[Min[(stirBarCoverHeight + 1Millimeter), minSampleHeight], 1 Millimeter]

					];

					(* LiquidLevelTooLow errors *)
					liquidLevelCoverStirBarError = If[NullQ[resolvedStirBar],
						False,
						(minSampleHeight <= (1Millimeter + stirBarCoverHeight))
					];
					(* SampleHeight errors *)
					sampleHeightError = Which[
						MatchQ[liquidLevelCoverStirBarError, True],
						(* Note: for cases that liquid will not cover the stir bar after data collection is complete, we do not throw additional SampleHeight errors *)
							False,
						NullQ[resolvedStirBarModelPacket],
						(* If we do not have stir bar, we do have check stirBarCoverHeight *)
							(resolvedSamplingHeight > minSampleHeight),
						True,
							Or[
								(resolvedSamplingHeight > minSampleHeight),
								(resolvedSamplingHeight < stirBarCoverHeight)
							]
					];

					(* Resolve WashSolution *)
					resolvedWashSolution=Which[
						(* User user specified value *)
						MatchQ[washSolution,Except[Automatic]],washSolution,

						(* if user specified method use the value in the method  *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,WashSolution],

						(* Otherwise set to default value *)
						True, Model[Sample, "Milli-Q water"]

					];

					(* resolve WashSolutionTemperatures *)
					resolvedWashSolutionTemperature=Which[
						(* User user specified value *)
						MatchQ[washSolutionTemperature,Except[Automatic]],washSolutionTemperature,

						(* if user specified method use the value in the method  *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,WashSolutionTemperature],

						(* Otherwise set to default value *)
						True, Ambient

					];

					(* resolve WashEquilibrationTimes *)
					resolvedWashEquilibrationTime=Which[
						(* User user specified value *)
						MatchQ[washEquilibrationTime,Except[Automatic]],washEquilibrationTime,

						(* if user specified method use the value in the method  *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,WashEquilibrationTime],

						(* Otherwise set based on WashSolutionTemperature *)
						MatchQ[resolvedWashSolutionTemperature,Except[Ambient|$AmbientTemperature]], 5Minute,

						(* Defualt to 0 Minute*)
						True, 0Minute

					];

					(* resolve WashWaitTimes *)
					resolvedWashWaitTime=Which[
						(* User user specified value *)
						MatchQ[washWaitTime,Except[Automatic]],washWaitTime,

						(* if user specified method use the value in the method  *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,WashWaitTime],

						(* Otherwise set to default value *)
						True, 0 Minute

					];

					(* resolve NumberOfWashes *)
					resolvedNumberOfWash=Which[
						(* User user specified value *)
						MatchQ[numberOfWash,Except[Automatic]],numberOfWash,

						(* if user specified method use the value in the method  *)
						MatchQ[methodPacketForProtocol,PacketP[]], Lookup[methodPacketForProtocol,NumberOfWash],

						(* Otherwise set to default value *)
						True, 1

					];


					(* At the end check if any of the resolved values are inconsistent with value in the corresponding method *)
					(* Check if any values are not consistent *)
					inConsistentOptionNames=If[
						MatchQ[methodPacketForProtocol,PacketP[]],

						MapThread[
							Function[{optionName,resolvedValue},
								Which[

									(* Do not throw an error if the value in the method packet is Null *)
									NullQ[Lookup[methodPacketForProtocol,optionName]], Nothing,

									(* Else check if the value are consistent *)
									Which[
										MatchQ[Lookup[methodPacketForProtocol,optionName], {UnitsP[] ..}],!(Lookup[methodPacketForProtocol,optionName]==resolvedValue),
										MatchQ[Lookup[methodPacketForProtocol,optionName], ObjectP[]],!(MatchQ[Download[Lookup[methodPacketForProtocol,optionName],Object],Download[resolvedValue,Object]]),
										True,!MatchQ[Lookup[methodPacketForProtocol,optionName],resolvedValue]
									],optionName,

									(* Else return nothing*)
									True, Nothing

								]
							],
							{
								{
									ParticleSizes,
									ReadingVolume,
									SampleTemperature,
									DilutionContainer,
									DilutionMixVolume,
									DilutionNumberOfMixes,
									DilutionMixRate,
									DilutionStorageCondition,
									AcquisitionMix,
									StirBar,
									AcquisitionMixRate,
									AdjustMixRate,
									MinAcquisitionMixRate,
									MaxAcquisitionMixRate,
									AcquisitionMixRateIncrement,
									MaxStirAttempt,
									WashSolution,
									WashSolutionTemperature,
									WashEquilibrationTime,
									WashWaitTime,
									NumberOfWash,
									AcquisitionMixType,
									NumberOfMixes,
									WaitTimeBeforeReading
								},
								{
									resolvedParticleSize,
									resolvedReadingVolume,
									resolvedSampleTemperature,
									resolvedDilutionContainer,
									resolvedDilutionMixVolume,
									resolvedDilutionNumberOfMix,
									resolvedDilutionMixRate,
									resolvedDilutionStorageCondition,
									resolvedAcquisitionMix,
									resolvedStirBar,
									resolvedAcquisitionMixRate,
									resolvedAdjustMixRate,
									resolvedMinAcquisitionMixRate,
									resolvedMaxAcquisitionMixRate,
									resolvedAcquisitionMixRateIncrement,
									resolvedMaxStirAttempt,
									resolvedWashSolution,
									resolvedWashSolutionTemperature,
									resolvedWashEquilibrationTime,
									resolvedWashWaitTime,
									resolvedNumberOfWash,
									resolvedAcquisitionMixType,
									resolvedNumberOfMixes,
									resolvedWaitTimeBeforeReading
								}
							}
						],
						{}
					];

					(* resolve NumberOfWashes *)
					resolvedSaveCustomMethod=Which[
						(* User user specified value *)
						MatchQ[saveCustomMethod,Except[Automatic]],saveCustomMethod,

						(* if user specified method use the value in the method  *)
						And[MatchQ[methodPacketForProtocol,PacketP[]],Length[inConsistentOptionNames]==0],False,

						(* Otherwise set to default value *)
						True, True

					];

					(* Return resolved Options *)
					{
						(*1*)resolvedParticleSize,
						(*2*)resolvedDilutionCurve,
						(*3*)resolvedSerialDilutionCurve,
						(*4*)resolvedDiluent,
						(*5*)resolvedStirBar,
						(*6*)resolvedMaxStirAttempt,
						(*7*)resolvedReadingVolume,
						(*9*)resolvedNumberOfReading,
						(*10*)resolvedEquilibrationTime,
						(*11*)resolvedPreRinseVolume,
						(*14*)resolvedAcquisitionMixRate,
						(*15*)resolvedAdjustMixRate,
						(*16*)resolvedMinAcquisitionMixRate,
						(*17*)resolvedMaxAcquisitionMixRate,
						(*18*)resolvedAcquisitionMixRateIncrement,
						(*19*)resolvedWashSolutionTemperature,
						(*20*)resolvedWashEquilibrationTime,
						(*21*)resolvedWashWaitTime,
						(*22*)resolvedDilutionMixVolume,
						(*23*)resolvedDilutionMixRate,
						(*24*)resolvedDilutionContainer,
						(*25*)resolvedDilutionStorageCondition,
						(*26*)resolvedDilutionNumberOfMix,
						(*27*)resolvedWashSolution,
						(*28*)resolvedNumberOfWash,
						(*29*)resolvedSaveCustomMethod,
						(*30*)resolvedDiscardFirstRun,
						(*32*)resolvedNumberOfMixes,
						(*33*)resolvedWaitTimeBeforeReading,
						(*34*)resolvedSamplingHeight,

						(* Other returned value *)
						(*1*)sampleLoadingVolume,
						(*2*)requiredSampleVolume,
						(*3*)numAspiration,
						(*4*)unNeededDilutionOptions,
						(*5*)requiredDilutionOptions,
						(*6*)unNeededAcquisitionMixOptions,
						(*7*)requiredAcquisitionMixOptions,
						(*8*)unNeededAdjustMixRateOptions,
						(*9*)requiredAdjustMixRateOptions,
						(*10*)inConsistentOptionNames,
						(*11*)dilutionLength,
						(*12*)dilutedSampleVolume,
						(*13*)conflictingMixingOptions,
						(*14*)minSampleHeight,
						(*15*)stirBarCoverHeight,


						(* Warnings *)
						(*1*)countLiquidPartcielDilutionWarning,
						(*2*)duplicateParticleSizesWarning,

						(*Errors*)
						(*1*)notEnoughVolumeError,
						(*2*)dilutionCurveVolumeError,
						(*3*)dilutionContainerError,
						(*4*)invalidStirBarError,
						(*5*)invalidMinAcquisitionMixRateError,
						(*6*)invalidMaxAcquisitionMixRateError,
						(*7*)invalidAcquisitionMixRateIncrementError,
						(*8*)dilutionContainerLengthMisMatchedQ,
						(*9*)liquidLevelCoverStirBarError,
						(*10*)sampleHeightError
					}
				]
			],
			{
				mapThreadFriendlyOptions,
				samplePackets,
				sampleModelPackets,
				sampleContainerModelPackets,
				methods,
				suppliedAliquotContainerModels,
				inputContainerCompatibleBools,
				requiredAliquotContainers,
				resolvedSampleTemperatures,
				resolvedAcquisitionMixes,
				resolvedAcquisitionMixTypes
			}
		]
	];


	(* --- Resolved aliquot options --- *)
	(* -- First check if supplied to resolved to a container --*)
	(* Lookup relevant options *)
	{suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers, suppliedConsolidateAliquots}=Lookup[
		samplePrepOptions,
		{Aliquot,AliquotAmount,AssayVolume,TargetConcentration,AssayBuffer,AliquotContainer, ConsolidateAliquots}
	];

	(* Determine if all the core aliquot options are left automatic for a given sample (note that although we pulled out ConsolidateAliquots above, that does NOT count as a core aliquot option and isn't checked here) *)
	(* If no aliquot options are specified for a sample we want to be able to warn that it will be aliquoted if that comes up *)
	impliedAliquotBools=MapThread[
		Function[{aliquot,aliquotVolume,assayVolume,targetConcentration,assayBuffer,aliquotContainer},
			MatchQ[{aliquot,assayVolume,aliquotVolume,targetConcentration,assayBuffer,aliquotContainer},{Automatic|Null..}]
		],
		{suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers}
	];

	(* we will always aliquot all the sample into the new container b/c that is the assumption we followed when checking Error::CountLiquidParticleLiquidLevelTooLow *)
	requiredAliquotVolumes=If[Length[nonLiquidSamplePackets]>0,Null,Lookup[samplePackets,Volume]];

	(* -- Resolve Aliquot Options -= *)
	(* Call resolveAliquotOptions *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,

		(* Case where output includes tests *)
		resolveAliquotOptions[
			ExperimentCountLiquidParticles,
			mySamples,
			simulatedSamples,
			ReplaceRule[roundedUnresolvedOptions,resolvedSamplePrepOptions],
			Cache->simulatedCache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotVolumes,
			AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the "<>ObjectToString[Download[suppliedInstrumentModel,Object]],
			AllowSolids->False,
			Output->{Result,Tests}
		],

		(* Case where we are not gathering tests  *)
		{
			resolveAliquotOptions[
				ExperimentCountLiquidParticles,
				mySamples,
				simulatedSamples,
				ReplaceRule[roundedUnresolvedOptions,resolvedSamplePrepOptions],
				Cache->simulatedCache,
				Simulation->updatedSimulation,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotVolumes,
				AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the "<>ObjectToString[Download[suppliedInstrumentModel,Object]],
				AllowSolids->False,
				Output->Result
			],{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* --- Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["count liquid particles sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[roundedUnresolvedOptions, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["count liquid particles sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[roundedUnresolvedOptions, SampleContainerLabel]}
		]
	];


	(* All error messages *)

	(* Unneeded dilution options *)
	If[Length[Flatten[unNeededDilutionOptionList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleUnneededDilutionOptions,
			ObjectToString[PickList[mySamples,unNeededDilutionOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[unNeededDilutionOptionList,unNeededDilutionOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	unNeededDilutionOptionTests=If[
		gatherTests,
		Test["If DilutionSolution is not specified, all Dilution related options are not specieid:",Length[Flatten[unNeededDilutionOptionList]]==0,True],
		Nothing
	];

	(* required dilution options *)
	If[Length[Flatten[requiredDilutionOptionList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleRequiredDilutionOptions,
			ObjectToString[PickList[mySamples,requiredDilutionOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[requiredDilutionOptionList,requiredDilutionOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	requiredDilutionOptionTests=If[
		gatherTests,
		Test["If DilutionSolution is specified, all Dilution related options are not Null:",Length[Flatten[requiredDilutionOptionList]]==0,True],
		Nothing
	];

	(* Unneeded AcquisitionMix options *)
	If[Length[Flatten[unNeededAcquisitionMixOptionList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleUnneededAcquisitionMixOptions,
			ObjectToString[PickList[mySamples,unNeededAcquisitionMixOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[unNeededAcquisitionMixOptionList,unNeededAcquisitionMixOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	unNeededAcquisitionMixOptionTests=If[
		gatherTests,
		Test["If AcquisitionMix is True, all AcquisitionMix related options are not Null:",Length[Flatten[unNeededAcquisitionMixOptionList]]==0,True],
		Nothing
	];

	(* required AcquisitionMix options *)
	If[Length[Flatten[requiredAcquisitionMixOptionList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleRequiredAcquisitionMixOptions,
			ObjectToString[PickList[mySamples,requiredAcquisitionMixOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[resolvedAcquisitionMixTypes,requiredAcquisitionMixOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[requiredAcquisitionMixOptionList,requiredAcquisitionMixOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	requiredAcquisitionMixOptionTests=If[
		gatherTests,
		Test["If AcquisitionMix is False, all AcquisitionMix related options are Null:",Length[Flatten[requiredAcquisitionMixOptionList]]==0,True],
		Nothing
	];

	(* Unneeded AdjustMixOption options *)
	If[Length[Flatten[unNeededAdjustMixRateOptionList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleUnneededAdjustMixOptions,
			ObjectToString[PickList[mySamples,unNeededAdjustMixRateOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[unNeededAdjustMixRateOptionList,unNeededAdjustMixRateOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	unNeededAdjustMixOptionTests=If[
		gatherTests,
		Test["If AdjustMix is True, all AdjustMix related options are not Null:",Length[Flatten[unNeededAdjustMixRateOptionList]]==0,True],
		Nothing
	];

	(* required AdjustMixOption options *)
	If[Length[Flatten[requiredAdjustMixRateOptionList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleRequiredAdjustMixOptions,
			ObjectToString[PickList[mySamples,requiredAdjustMixRateOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[requiredAdjustMixRateOptionList,requiredAdjustMixRateOptionList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	requiredAdjustMixRateOptionTests=If[
		gatherTests,
		Test["If AdjustMix is False, all AdjustMix related options are Null:",Length[Flatten[requiredAdjustMixRateOptionList]]==0,True],
		Nothing
	];

	(* Not enough volumes *)
	notEnoughVolumeOptions=If[Or@@notEnoughVolumeBools && messages && outsideEngine && (Length[nonLiquidSamplePackets] == 0),
		Message[
			Error::CountLiquidParticleNotEnoughSampleVolume,
			ObjectToString[PickList[mySamples,notEnoughVolumeBools,True],Cache->simulatedCache],
			PickList[requiredSampleVolumes,notEnoughVolumeBools,True]
		];{ReadingVolume,PreRinseVolume}
	];

	(* Build the test for not enough sample volume *)
	notEnoughVolumeTests=If[
		gatherTests,
		Test["The sample have enough volume to finish all experiments:",Or@@notEnoughVolumeBools,False],
		Nothing
	];

	(* Not enough dilutionCurveVolumeBools *)
	invalidDilutionCurveVolumeOptions=If[Or@@dilutionCurveVolumeBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidDilutionCurveVolumes,
			ObjectToString[PickList[mySamples,dilutionCurveVolumeBools,True],Cache->simulatedCache],
			PickList[dilutedSampleVolumeList,dilutionCurveVolumeBools,True],
			PickList[sampleLoadingVolumes,dilutionCurveVolumeBools,True]
		];{ReadingVolume,PreRinseVolume}
	];

	(* Build the test for not enough sample volume *)
	notEnoughDilutionCurveVolumeTests=If[
		gatherTests,
		Test["The sample have enough volume to finish all dilution experiments:",Or@@dilutionCurveVolumeBools,False],
		Nothing
	];


	(* Unneeded AcquisitionMix options *)
	If[Length[Flatten[conflictingMixingOptionsList]]>0&& messages && outsideEngine,
		Message[
			Error::CountLiquidParticleConflictingMixOptions,
			ObjectToString[PickList[mySamples,conflictingMixingOptionsList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[conflictingMixingOptionsList,conflictingMixingOptionsList,_?(Length[#] > 0 &)],Cache->simulatedCache],
			ObjectToString[PickList[resolvedAcquisitionMixTypes,conflictingMixingOptionsList,_?(Length[#] > 0 &)],Cache->simulatedCache]
		]
	];

	(*Build a test for that *)
	conflictingMixOptionsTests=If[
		gatherTests,
		Test["AcquisitionMixType is consistent with all related options. If AcquisitionMixType is Swirl, only {AcquisitionMixType, NumberOfMixes, WaitTimeBeforeReading} need to be specified. If AcquisitionMixType is Stir, only {StirBar, AcquisitionMixRate, AdjustMixRate, MinAcquisitionMixRate, MaxAcquisitionMixRate, AcquisitionMixRateIncrement, MaxStirAttempts} need to be specified:",Length[Flatten[conflictingMixingOptionsList]]==0,True],
		Nothing
	];


	(* Invalid dilution container*)
	invalidDilutionContainerOptions=If[Or@@Flatten[dilutionContainerBools] && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidDilutionContainer,
			ObjectToString[PickList[mySamples,dilutionContainerBools,True],Cache->simulatedCache],
			PickList[resolvedDilutionContainers,dilutionContainerBools,True]
		];{DilutionCurve,SerialDilutionCurve}
	];

	(* Build the test for not enough sample volume *)
	invalidDilutionContainerTests=If[
		gatherTests,
		Test["The dilution containers are valid for all dilution processes:",Or@@dilutionContainerBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidStirBarOptions=If[Or@@invalidStirBarBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidStirBar,
			ObjectToString[PickList[mySamples,invalidStirBarBools,True],Cache->simulatedCache],
			PickList[resolvedStirBars,invalidStirBarBools,True]
		];{StirBar}
	];

	(* Build the test for not enough sample volume *)
	invalidStirBarTests=If[
		gatherTests,
		Test["The specified stir bars can be used in the measurements: ",Or@@invalidStirBarBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidMinAcquisitionMixRateOptions=If[Or@@invalidMinAcquisitionMixRateBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidMinAcquisitionMixRate,
			ObjectToString[PickList[mySamples,invalidMinAcquisitionMixRateBools,True],Cache->simulatedCache],
			PickList[resolvedStirBars,invalidMinAcquisitionMixRateBools,True]
		];{MinAcquisitionMixRate}
	];

	(* Build the test for not enough sample volume *)
	invalidMinAcquisitionMixRateTests=If[
		gatherTests,
		Test["The specified MinAcquisitionMixRate is higher than the MinStirRate of the instrument model: ",Or@@invalidMinAcquisitionMixRateBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidMaxAcquisitionMixRateOptions=If[Or@@invalidMaxAcquisitionMixRateBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidMaxAcquisitionMixRate,
			ObjectToString[PickList[mySamples,invalidMaxAcquisitionMixRateBools,True],Cache->simulatedCache],
			PickList[resolvedMaxAcquisitionMixRates,invalidMaxAcquisitionMixRateBools,True]
		];{MaxAcquisitionMixRate}
	];

	(* Build the test for not enough sample volume *)
	invalidMaxAcquisitionMixRateTests=If[
		gatherTests,
		Test["The specified MaxAcquisitionMixRate is higher than the MaxStirRate of the instrument model: ",Or@@invalidMaxAcquisitionMixRateBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidAcquisitionMixRateIncrementOptions=If[Or@@invalidAcquisitionMixRateIncrementBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidAcquisitionMixRateIncrement,
			ObjectToString[PickList[mySamples,invalidAcquisitionMixRateIncrementBools,True],Cache->simulatedCache],
			PickList[resolvedStirBars,invalidAcquisitionMixRateIncrementBools,True]
		];{AcquisitionMixRateIncrement}
	];

	(* Build the test for not enough sample volume *)
	invalidAcquisitionMixRateIncrementTests=If[
		gatherTests,
		Test["The specified AcquisitionMixRateIncrement are within the allowed range of the instrument model and are smaller than MaxAcquisitionMixRate: ",Or@@invalidAcquisitionMixRateIncrementBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidDilutionContainerLengthsOptions=If[Or@@dilutionContainerLengthMisMatchedBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleDilutionContainerLengthMismatch,
			ObjectToString[PickList[mySamples,dilutionContainerLengthMisMatchedBools,True],Cache->simulatedCache],
			PickList[dilutionLengthList,dilutionContainerLengthMisMatchedBools,True],
			PickList[resolvedDilutionContainers,dilutionContainerLengthMisMatchedBools,True]
		];{DilutionContainer}
	];

	(* Build the test for not enough sample volume *)
	invalidDilutionContainerLengthsTests=If[
		gatherTests,
		Test["The length of the DilutionCurve/SerialDilutionCurve should match the length of DilutionContainer:",Or@@dilutionContainerLengthMisMatchedBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidParticleLiquidLevelTooLowOptions=If[Or@@liquidLevelCoverStirBarBools && messages && outsideEngine && (Length[nonLiquidSamplePackets] == 0),
		Message[
			Error::CountLiquidParticleLiquidLevelTooLow,
			ObjectToString[PickList[mySamples,liquidLevelCoverStirBarBools,True],Cache->simulatedCache],
			PickList[minSampleHeights,liquidLevelCoverStirBarBools,True],
			PickList[stirBarCoverHeights,liquidLevelCoverStirBarBools,True]
		];{NumberOfReadings, ReadingVolume,StirBar}
	];

	(* Build the test for not enough sample volume *)
	invalidParticleLiquidLevelTooLowTests=If[
		gatherTests,
		Test["After data collection, the liquid level inside the container should still cover the stir bar.",Or@@liquidLevelCoverStirBarBools,False],
		Nothing
	];

	(* Invalid StirBarBools*)
	invalidSamplingHeightOptions=If[Or@@sampleHeightBools && messages && outsideEngine,
		Message[
			Error::CountLiquidParticleInvalidSamplingHeight,
			ObjectToString[PickList[mySamples,sampleHeightBools,True],Cache->simulatedCache],
			PickList[resolvedSamplingHeights,sampleHeightBools,True],
			PickList[stirBarCoverHeights,sampleHeightBools,True],
			PickList[minSampleHeights,sampleHeightBools,True]
		];{NumberOfReadings, ReadingVolume}
	];

	(* Build the test for not enough sample volume *)
	invalidSamplingHeightTests=If[
		gatherTests,
		Test["After data collection, the liquid should still cover the tip of the probe.",Or@@sampleHeightBools,False],
		Nothing
	];


	(* --- Warnings --- *)
	(* countLiquidPartcielDilutionBools *)
	If[Or@@countLiquidPartcielDilutionBools && messages && outsideEngine,
		Message[
			Warning::CountLiquidParticleDilutions,
			ObjectToString[PickList[mySamples,countLiquidPartcielDilutionBools,True],Cache->simulatedCache],
			PickList[requiredSampleVolumes,countLiquidPartcielDilutionBools,True]
		]
	];

	(* Build the dilution warnings *)
	countLiquidPartcielDilutionWarnings=If[
		gatherTests,
		Warning["If specified dilution, the experiment will only measure the diluted samples",Or@@countLiquidPartcielDilutionBools,False],
		Nothing
	];
	
	(* countLiquidPartcielDilutionBools *)
	If[Or@@duplicateParticleSizesBools && messages && outsideEngine,
		Message[
			Warning::CountLiquidParticlesDuplicateParticleSizes,
			ObjectToString[PickList[mySamples,duplicateParticleSizesBools,True],Cache->simulatedCache],
			PickList[resolvedParticleSizes,duplicateParticleSizesBools,True],
			DeleteDuplicates/@PickList[resolvedParticleSizes,duplicateParticleSizesBools,True]
		]
	];

	(* build the dilution warnings *)
	duplicateParticleSizesWarnings=If[
		gatherTests,
		Warning["No duplicate ParticleSizes are specified",Or@@duplicateParticleSizesBools,False],
		Nothing
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[
		{
			discardedInvalidInputs,
			nonLiquidSampleInvalidInputs
		}
	]];
	invalidOptions=DeleteDuplicates[
		Flatten[
			ReplaceAll[
				{
					compatibleMaterialsInvalidOption,
					nameInvalidOption,
					nonSampleLengthPrimeOptions,
					invalidSyringeSizeOptions,
					invalidSyringeOptions,
					unNeededDilutionOptionList,
					requiredDilutionOptionList,
					unNeededAcquisitionMixOptionList,
					requiredAcquisitionMixOptionList,
					unNeededAdjustMixRateOptionList,
					requiredAdjustMixRateOptionList,
					notEnoughVolumeOptions,
					invalidDilutionCurveVolumeOptions,
					conflictingMixingOptionsList,
					invalidDilutionContainerOptions,
					invalidStirBarOptions,
					invalidMinAcquisitionMixRateOptions,
					invalidMaxAcquisitionMixRateOptions,
					invalidAcquisitionMixRateIncrementOptions,
					invalidDilutionContainerLengthsOptions,
					invalidParticleLiquidLevelTooLowOptions,
					invalidSamplingHeightOptions
				},
				{Null->{}}
			]
		]
	];
	
	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];
	
	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];
	
	(* Define the Resolved Options *)
	resolvedOptions=ReplaceRule[
		roundedUnresolvedOptions,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				(* None Automatic Options *)
				Instrument->instrument,
				Method->methods,
				PrimeSolutions->expandedPrimeSolutions,
				PrimeWaitTime->expandedPrimeWaitTimes,
				NumberOfPrimes->expandedNumberOfPrimes,
				Sensor->sensor,

				(* Automatic Options *)
				NumberOfReadings->resolvedNumberOfReadings,
				SampleTemperature->resolvedSampleTemperatures,
				Preparation->resolvedPreparation,
				ParticleSizes->resolvedParticleSizes,
				SyringeSize->resolvedSyringeSize,
				Syringe->resolvedSyringe,
				DilutionCurve->resolvedDilutionCurves,
				SerialDilutionCurve->resolvedSerialDilutionCurves,
				Diluent->resolvedDiluents,
				DilutionMixVolume->resolvedDilutionMixVolumes,
				DilutionMixRate->resolvedDilutionMixRates,
				DilutionContainer->resolvedDilutionContainers,
				DilutionStorageCondition->resolvedDilutionStorageConditions,
				DilutionNumberOfMixes->resolvedDilutionNumberOfMixes,
				AcquisitionMix->resolvedAcquisitionMixes,
				AcquisitionMixType->resolvedAcquisitionMixTypes,
				NumberOfMixes->resolvedNumberOfMixesList,
				WaitTimeBeforeReading->resolvedWaitTimeBeforeReadings,
				StirBar->resolvedStirBars,
				MaxStirAttempts->resolvedMaxStirAttempts,
				PrimeSolutionTemperatures->resolvedPrimeSolutionTemperatures,
				PrimeEquilibrationTime->resolvedPrimeEquilibrationTimes,
				ReadingVolume->resolvedReadingVolumes,
				EquilibrationTime->resolvedEquilibrationTimes,
				PreRinseVolume->resolvedPreRinseVolumes,
				AcquisitionMixRate->resolvedAcquisitionMixRates,
				AdjustMixRate->resolvedAdjustMixRates,
				MinAcquisitionMixRate->resolvedMinAcquisitionMixRates,
				MaxAcquisitionMixRate->resolvedMaxAcquisitionMixRates,
				AcquisitionMixRateIncrement->resolvedAcquisitionMixRateIncrements,
				WashSolution->resolvedWashSolutions,
				WashSolutionTemperature->resolvedWashSolutionTemperatures,
				WashEquilibrationTime->resolvedWashEquilibrationTimes,
				WashWaitTime->resolvedWashWaitTimes,
				NumberOfWashes->resolvedNumberOfWashes,
				SaveCustomMethod->resolvedSaveCustomMethods,
				DiscardFirstRun->resolvedDiscardFirstRuns,
				SamplingHeight->resolvedSamplingHeights,
				SampleLabel->resolvedSampleLabel,
				SampleContainerLabel->resolvedSampleContainerLabel
			}
		]
	];
	
	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Cases[
			Flatten[
				{
					discardedTests,
					dilutionCurvePrecisionTests,
					serialDilutionPrecisionTests,
					optionPrecisionTests,
					compatibleMaterialsTests,
					validNameTest,
					aliquotTests,
					nonLiquidSampleTests,
					invalidSyringeSizeTests,
					invalidSyringeTests,
					unNeededDilutionOptionTests,
					requiredDilutionOptionTests,
					unNeededAcquisitionMixOptionTests,
					requiredAcquisitionMixOptionTests,
					unNeededAdjustMixOptionTests,
					requiredAdjustMixRateOptionTests,
					notEnoughVolumeTests,
					notEnoughDilutionCurveVolumeTests,
					conflictingMixOptionsTests,
					invalidDilutionContainerTests,
					invalidStirBarTests,
					invalidMinAcquisitionMixRateTests,
					invalidMaxAcquisitionMixRateTests,
					invalidAcquisitionMixRateIncrementTests,
					invalidDilutionContainerLengthsTests,
					invalidParticleLiquidLevelTooLowTests,
					invalidSamplingHeightTests,
					countLiquidPartcielDilutionWarnings,
					duplicateParticleSizesWarnings
				}
			],
			_EmeraldTest
		]
	}
	
];

(* ::Subsubsection:: *)
(* resolveCountLiquidParticlesMethod *)

(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveCountLiquidParticlesMethod,
	SharedOptions:>{
		ExperimentCountLiquidParticles,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveCountLiquidParticlesMethod[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}]|Automatic], myOptions : OptionsPattern[]] := Module[
	{outputSpecification,output,safeOps,gatherTests,resolvedPreparation,manualRequirementStrings,roboticRequirementStrings,result,tests},
	
	(* Generate the output specification*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	
	(* Check if we gather test *)
	gatherTests = MemberQ[output,Tests];
	
	(* get the safe options *)
	safeOps = SafeOptions[resolveCountLiquidParticlesMethod, ToList[myOptions]];
	
	(* Resolve the sample preparation methods *)
	resolvedPreparation=If[
		MatchQ[Lookup[safeOps,Preparation],Except[Automatic]],
		Lookup[safeOps,Preparation],
		{Manual}
	];
	
	
	(* make a boolean for if it is ManualSamplePreparation or not *)
	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		"ExperimentCountLiquidParticles can only be done manually."
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MemberQ[ToList[Lookup[safeOps, Preparation]], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};
	
	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];
	
	(* Return our result and tests. *)
	result=Which[
		MatchQ[Lookup[safeOps, Preparation], Except[Automatic]], Lookup[safeOps, Preparation],
		Length[manualRequirementStrings]>0,	Manual,
		Length[roboticRequirementStrings]>0, Robotic,
		True,{Manual, Robotic}
	];
	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the CountLiquidParticle primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];
	
	outputSpecification/.{Result->result, Tests->tests}

];


(* ::Subsubsection::Closed:: *)
(* ::Subsubsection:: *)
(*ExperimentCountLiquidParticlesResourcePackets*)
(* countLiquidParticlesResourcePackets *)


DefineOptions[
	countLiquidParticlesResourcePackets,
	Options:>{
		{
			Output -> Result,
			ListableP[Result|Tests],
			"Indicate what the helper function that does not need the Preview or Options output should return.",
			Category->Hidden
		},
		SimulationOption,
		CacheOption
	}
];

(* private function to generate the list of protocol packets containing resource blobs *)
countLiquidParticlesResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},myResourceOptions:OptionsPattern[countLiquidParticlesResourcePackets]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,outputSpecification,output,gatherTests,messages,cache,simulation,simulatedSamples,updatedSimulation,
		numReplicates,samplesInWithReplicates,optionsWithReplicates,acquisitionMix,acquisitionMixRate,acquisitionMixRateIncrement,adjustMixRate,
		diluent,dilutionContainer,dilutionCurve,dilutionMixRate,dilutionMixVolume,dilutionNumberOfMixes,dilutionStorageCondition,equilibrationTime,
		instrument,maxAcquisitionMixRate,maxStirAttempts,method,minAcquisitionMixRate,numberOfPrimes,numberOfReadings,numberOfWashes,
		particleSizes,preparation,preRinseVolume,primeEquilibrationTime,primeSolutions,primeSolutionTemperatures,primeWaitTimes,readingVolume,
		sampleTemperature,sensor,serialDilutionCurve,stirBar,syringe,syringeSize,washEquilibrationTime,washSolution,
		washSolutionTemperature,washWaitTime,resourcePacketDownload,samplePackets,syringePacket,numAspirations,sampleLoadingVolumes,
		sampleVolumes,syringeDownloadFields,pairedSamplesInAndVolumes,sampleVolumeRules,sampleResourceReplaceRules,samplesInResources,
		requiredDiluentVolumes,pairedDiluentsAndVolumes,diluentVolumeRules,uniqueDiluentResources,uniqueDiluentObjects,uniqueDiluentReplaceRules,
		diluentResources,resolvedOptionsNoHidden,containersInResources,checkpoints,dilutionContainerResource,protocolPacket,saveCustomMethod,
		requiredPrimeSolutionsVolumes,primeSolutionsResources,stirBarRetrieverResource,	stirBarResources,syringeResource,requiredWashSolutionsVolumes,washSolutionsResources,estimatedReadingTime,
		rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,
		resultRule,instrumentResource,sharedFieldPacket,finalizedPacket,simulationRule,allMethodPackets,methodPacketsToUpload, resolvedMethodsForProtocol,
		methodPacketForProtocolUpload,expandedSerialDilutions,expandedDilutions,dilutionContainerList,discardFirstRuns,flowRate,estimatedPrimeTime,
		estimatedRunTime,fillLiquidResource,expandedMethodPackets,rinseWaterVolume,rinseWaterResource,acquisitionMixType,numberOfMixes,
		waitTimeBeforeReading,samplingHeights,solidSamplePackets,solidInvalidInputs
	},
	
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentCountLiquidParticles, {mySamples}, myResolvedOptions];
	
	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentCountLiquidParticles,
		(* don't remove NumberOfMixes or WaitTimeBeforeReading because these guys are sometimes hidden and sometimes not, but we need them below regardless *)
		RemoveHiddenOptions[ExperimentCountLiquidParticles, myResolvedOptions, Exclude -> {NumberOfMixes, WaitTimeBeforeReading}],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];
	
	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[ToList[myResourceOptions], Output];
	output = ToList[outputSpecification];
	
	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];
	
	(* Get the cache *)
	cache = Lookup[ToList[myResourceOptions], Cache];
	simulation = Lookup[ToList[myResourceOptions], Simulation];
	
	(* Generate sample resources and update simulation *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentCountLiquidParticles, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* get the number of replicates, this should already to be a not Null number *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates, 1];
	
	(* Expand the function with a helper function *)
	{samplesInWithReplicates,optionsWithReplicates}=expandCountLiquidParticlesReplicates[mySamples,expandedResolvedOptions,numReplicates];

	(* Extract with all expanded options*)
	{
		(*1*)acquisitionMix,
		(*2*)acquisitionMixRate,
		(*3*)acquisitionMixRateIncrement,
		(*4*)adjustMixRate,
		(*5*)diluent,
		(*6*)dilutionContainer,
		(*7*)dilutionCurve,
		(*8*)dilutionMixRate,
		(*9*)dilutionMixVolume,
		(*10*)dilutionNumberOfMixes,
		(*11*)dilutionStorageCondition,
		(*12*)equilibrationTime,
		(*14*)instrument,
		(*15*)maxAcquisitionMixRate,
		(*16*)maxStirAttempts,
		(*17*)method,
		(*18*)minAcquisitionMixRate,
		(*19*)numberOfPrimes,
		(*20*)numberOfReadings,
		(*21*)numberOfWashes,
		(*22*)particleSizes,
		(*23*)preparation,
		(*24*)preRinseVolume,
		(*25*)primeEquilibrationTime,
		(*26*)primeSolutions,
		(*27*)primeSolutionTemperatures,
		(*28*)primeWaitTimes,
		(*29*)readingVolume,
		(*30*)sampleTemperature,
		(*31*)sensor,
		(*32*)serialDilutionCurve,
		(*33*)stirBar,
		(*34*)syringe,
		(*36*)syringeSize,
		(*37*)washEquilibrationTime,
		(*38*)washSolution,
		(*39*)washSolutionTemperature,
		(*40*)washWaitTime,
		(*41*)saveCustomMethod,
		(*42*)discardFirstRuns,
		(*43*)acquisitionMixType,
		(*44*)numberOfMixes,
		(*45*)waitTimeBeforeReading,
		(*46*)samplingHeights
	} = Lookup[optionsWithReplicates,
		{
			(*1*)AcquisitionMix,
			(*2*)AcquisitionMixRate,
			(*3*)AcquisitionMixRateIncrement,
			(*4*)AdjustMixRate,
			(*5*)Diluent,
			(*6*)DilutionContainer,
			(*7*)DilutionCurve,
			(*8*)DilutionMixRate,
			(*9*)DilutionMixVolume,
			(*10*)DilutionNumberOfMixes,
			(*11*)DilutionStorageCondition,
			(*12*)EquilibrationTime,
			(*14*)Instrument,
			(*15*)MaxAcquisitionMixRate,
			(*16*)MaxStirAttempts,
			(*17*)Method,
			(*18*)MinAcquisitionMixRate,
			(*19*)NumberOfPrimes,
			(*20*)NumberOfReadings,
			(*21*)NumberOfWashes,
			(*22*)ParticleSizes,
			(*23*)Preparation,
			(*24*)PreRinseVolume,
			(*25*)PrimeEquilibrationTime,
			(*26*)PrimeSolutions,
			(*27*)PrimeSolutionTemperatures,
			(*28*)PrimeWaitTime,
			(*29*)ReadingVolume,
			(*30*)SampleTemperature,
			(*31*)Sensor,
			(*32*)SerialDilutionCurve,
			(*33*)StirBar,
			(*34*)Syringe,
			(*36*)SyringeSize,
			(*37*)WashEquilibrationTime,
			(*38*)WashSolution,
			(*39*)WashSolutionTemperature,
			(*40*)WashWaitTime,
			(*41*)SaveCustomMethod,
			(*42*)DiscardFirstRun,
			(*43*)AcquisitionMixType,
			(*44*)NumberOfMixes,
			(*45*)WaitTimeBeforeReading,
			(*46*)SamplingHeight
		}
	];
	
	(* Get the model of the syringe *)
	syringeDownloadFields=If[
		
		(* If instrument is an object, download fields from the Model *)
		MatchQ[syringe, ObjectP[Object[Part]]],
		Packet[Model[{MinVolume}]],
		
		(* If instrument is a Model, download fields*)
		Packet[MinVolume]
	];
	
	(* make a Download call to get the sample, container, and instrument packets *)
	resourcePacketDownload= Quiet[
		Download[
			{
				mySamples,
				ToList[syringe]
			},
			Evaluate[{
				{Packet[Container,Volume,Object,Density,State,Viscosity,BoilingPoint]},
				{syringeDownloadFields}
			}],
			Cache -> cache,
			Simulation->updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}
	];
	
	(* Collect all inforations into different lists*)
	{samplePackets, syringePacket}=resourcePacketDownload;
	{samplePackets, syringePacket}=Flatten[#,1]&/@{samplePackets, syringePacket};

	(* --- Generate Resources for what we have --- *)
	(* -- Sample Resource--*)
	(* get the sample volumes we need to reserve with each sample, accounting for the number of replicates, whether we're aliquoting, and whether we're using the lunatic *)
	(* this part should be identifcal with the same part in the option resolver *)
	{
		numAspirations,
		sampleLoadingVolumes,
		sampleVolumes
	} = Transpose@MapThread[
		Function[
			{
				eachReadingVolume,
				eachPreRinseVolume,
				eachSerialDilutionCurve,
				eachDilutionCurve
			},
			
			Module[{numAspiration,sampleLoadingVolume,sampleVolume},(* Calculate the number of aspiration we need to do *)
				numAspiration=Ceiling[(eachReadingVolume/syringeSize)];
				
				(* Sample loading volume  *)
				sampleLoadingVolume=(eachReadingVolume+eachPreRinseVolume+(numAspiration-1)+Lookup[First[syringePacket],MinVolume,20Microliter]);
				

				(*calculate the total sample volume we need we need this for *)
				sampleVolume=Which[
					(*Is a serial Dilution specified?*)
					MatchQ[eachSerialDilutionCurve,Except[Null|{}]],First[First[calculatedDilutionCurveVolumes[eachSerialDilutionCurve]]],
					
					(*Is a custom Dilution specified?*)
					MatchQ[eachDilutionCurve,Except[Null|{}]],Total[First[calculatedDilutionCurveVolumes[eachDilutionCurve]]],
					
					(* Default to loading volume*)
					True,sampleLoadingVolume
				];
				
				(* Return those results *)
				{numAspiration,sampleLoadingVolume,sampleVolume}
			]
		],
		{
			readingVolume,
			preRinseVolume,
			serialDilutionCurve,
			dilutionCurve
		}
	];

	(* make rules correlating the volumes with each sample in *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {samplesInWithReplicates, sampleVolumes}];
	
	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];
	
	(* make replace rules for the samples and its resources *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[NullQ[volume],
				sample -> Resource[Sample -> sample, Name -> CreateUUID[]],
				sample -> Resource[Sample -> sample, Name -> CreateUUID[], Amount -> volume]
			]
		],
		sampleVolumeRules
	];
	
	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesInWithReplicates, sampleResourceReplaceRules, {1}];

	(* ContainersIn Resource *)
	(* ContainersIn *)
	containersInResources=(Link[Resource[Sample->#],Protocols]&)/@Download[Lookup[samplePackets,Container],Object];
	
	(*-- Diluent --*)
	(* Get the volume of diluent required *)
	(* resolveRequiredDiluentVolumeForDilution is a function in ExpCapillaryELISA *)
	requiredDiluentVolumes=MapThread[
		(* Call the helper function to calculate the volume of diluent required for each sample from its dilution curve or serial dilution curve *)
		resolveRequiredDiluentVolumeForDilution[#1,#2]&,
		{dilutionCurve,serialDilutionCurve}
	];
	
	(* Pair the diluents with volume *)
	pairedDiluentsAndVolumes=MapThread[
		(#1->#2)&,
		{Lookup[optionsWithReplicates,Diluent],requiredDiluentVolumes}
	];
	
	(* Merge the diluent volumes together to get the total volume of each diluent's resource *)
	(* Get a list of volume rules, getting rid of any rules with the pattern Null->__ or __->0Microliter *)
	diluentVolumeRules=DeleteCases[
		KeyDrop[
			Merge[pairedDiluentsAndVolumes,Total],
			Null
		],
		0Microliter
	];
	
	(* Use the volume rules association to make resources for each unique Object or Model. We always transfer the diluents to a liquid handler compatible container *)
	uniqueDiluentResources=KeyValueMap[
		Module[{amount,containers},
			amount=#2;
			containers=PreferredContainer[amount];
			Link[Resource[Sample->#1,Name->CreateUUID[],Amount->amount,Container->containers]]
		]&,
		diluentVolumeRules
	];
	
	(* Construct a list of replace rules to point from the diluent object to its resource *)
	uniqueDiluentObjects=Keys[diluentVolumeRules];
	uniqueDiluentReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueDiluentObjects,uniqueDiluentResources}
	];
	
	(* Now generate diluent resources *)
	diluentResources=(diluent/.uniqueDiluentReplaceRules);
	
	(*-- DilutionContainer --*)
	(* Before we working on the dilution container, we need to expand the DilutionCurve and SerialDilutionCurve first *)
	expandedSerialDilutions=(If[NullQ[#],Null,Transpose[calculatedDilutionCurveVolumes[#]]]&/@serialDilutionCurve);
	expandedDilutions=(If[NullQ[#],Null,Transpose[calculatedDilutionCurveVolumes[#]]]&/@dilutionCurve);
	
	
	(* Generate the nested container field in this *)
	dilutionContainerList=MapThread[
		Function[
			{
				dilutionContainerForEachSample,
				serialDilutionCurveForEachSample,
				dilutionCurveForEachSample
			},
			Which[
				NullQ[dilutionContainerForEachSample], Null,
				MatchQ[serialDilutionCurveForEachSample,Except[Null|{}]],
				If[
					MatchQ[dilutionContainerForEachSample,Except[Model[Container,Plate]]],
					dilutionContainerForEachSample,
					ConstantArray[dilutionContainerForEachSample,Length[serialDilutionCurveForEachSample]]
					
				],
				MatchQ[dilutionCurveForEachSample,Except[Null|{}]],
				If[
					MatchQ[dilutionContainerForEachSample,Except[Model[Container,Plate]]],
					dilutionContainerForEachSample,
					ConstantArray[dilutionContainerForEachSample,Length[dilutionCurveForEachSample]]
				]
			]
		],
		{
			dilutionContainer,
			expandedSerialDilutions,
			expandedDilutions
		}
	];
	
	(* Cannot populate resources for a nested list so flatten it and populated with the resources *)
	dilutionContainerResource=If[NullQ[#],Null,Link[Resource[Sample->#,Name->CreateUUID[]]]]&/@Flatten[dilutionContainerList];

	(*-- PrimeSolutions --*)
	requiredPrimeSolutionsVolumes=Map[
		Function[numPrime,
			1.05*(numPrime+1)*syringeSize
		],
		numberOfPrimes
	];
	
	(* Make the resource by helper function *)
	primeSolutionsResources=makeResourceWithLimit[Download[primeSolutions,Object],requiredPrimeSolutionsVolumes,250Milliliter];
	
	(*-- StirBar --*)
	(* Generate the resource, we need a stir bar for each container, we cannot only generate unique stir bar here *)
	stirBarResources=Map[
		If[NullQ[#],Null,Link[Resource[Sample->#,Name->CreateUUID[],Rent->True]]]&,
		stirBar
	];
	
	(*-- If we need stir bar we also need a stir bar retriever to retrieve the stir bar from the container --*)
	stirBarRetrieverResource=If[NullQ[stirBar],Null,Link[Resource[Sample->Model[Part, StirBarRetriever, "18 Inch Stir Bar Retriever"],Name->CreateUUID[],Rent->True]]];

	(*-- Syringe --*)
	(* SyringeResources, not sure if we need this one, but in case we still have multiple syringes, so I will just add one here *)
	syringeResource=Resource[Sample->syringe,Name->CreateUUID[],Rent->True];
	
	(*-- FillLiquid Resource --*)
	fillLiquidResource=Link[Resource[Sample->Model[Sample, "Milli-Q water"],Name->CreateUUID[],Amount->150Milliliter,Container->PreferredContainer[150Milliliter]]];
	
	(*-- WashSolution --*)
	requiredWashSolutionsVolumes=MapThread[
		Function[{numWash,serialDilutionList,dilutionList},
			
			
			Module[
				{numberOfDilutions},
				numberOfDilutions=If[NullQ[serialDilutionList]&&NullQ[dilutionList],
					(* No dilution, just our sample *)
					1,
					(Length[serialDilutionList/.{Null->Nothing}]+Length[dilutionList/.{Null->Nothing}])
				];
				
				1.05*((numWash+1)*numberOfDilutions)*syringeSize
			]
		],
		{numberOfWashes,expandedSerialDilutions,expandedDilutions}
	];
	
	
	(* Now generate washSolutions resources *)
	washSolutionsResources=makeResourceWithLimit[Download[washSolution,Object],requiredWashSolutionsVolumes,250Milliliter];
	
	(*-- Instrument --*)
	(* First we need to estimate all times *)
	{estimatedPrimeTime,estimatedRunTime,estimatedReadingTime}=Module[
		{installationTime,methodSetUpTime,fullSyringePullTime,primeTimes,washTimes,
			syringePullTime,runTimes},
		
		(* Time integrated between different sample *)
		installationTime= 10Minute;
		
		(* Method set up time*)
		methodSetUpTime=5Minute;
		
		(* Full Syringe Runtime *)
		fullSyringePullTime=1Minute;
		
		(* Length of time for prime *)
		primeTimes=Total@MapThread[
			Function[{equlibarationTime,waitTime,num},
				Ceiling[(installationTime+(fullSyringePullTime+waitTime+equlibarationTime+methodSetUpTime)*num)/.Null->0Minute,1Minute]
			],
			{
				primeEquilibrationTime,
				primeWaitTimes,
				numberOfPrimes
			}
		];
		
		(* check the flow rate, the flow rate is hardcoded by different syringe size*)
		flowRate=ConstantArray[50 Milliliter/Minute,Length[samplesInWithReplicates]];
		
		(* Length of run times*)
		syringePullTime=((ReplaceAll[readingVolume,{Null->0Milliliter}]+ReplaceAll[preRinseVolume,{Null->0Milliliter}])/flowRate);
		
		runTimes=Total@MapThread[
			Function[{eachEqulibarationTime,pulltime,num},
				Ceiling[(installationTime+(Ceiling[pulltime*num,1Minute]+eachEqulibarationTime+methodSetUpTime))/.Null->0Minute,1Minute]
			],
			{
				ReplaceAll[equilibrationTime,{Null->0Minute}],
				syringePullTime,
				numberOfReadings
			}
		];

		(* Length of wash times*)
		washTimes=Total@MapThread[
			Function[{equlibarationTime,waitTime,num},
				Ceiling[(installationTime+(fullSyringePullTime+waitTime+equlibarationTime+methodSetUpTime)*num)/.Null->0Minute,1Minute]
			],
			{
				washEquilibrationTime,
				washWaitTime,
				numberOfWashes
			}
		];
		
		{
			Total@Flatten[{primeTimes}],
			Total@Flatten[{runTimes, washTimes}],
			Total@Flatten[{primeTimes, runTimes, washTimes}]
		}
	];
	
	(* Now generating instrument resource *)
	instrumentResource=Resource[Instrument -> instrument, Time -> (estimatedReadingTime),Name->CreateUUID[]];
	
	(* water for rinse resources *)
	rinseWaterVolume=Total[MapThread[
		Function[{serialDilutionList,dilutionList},
			
			
			Module[
				{numberOfDilutions},
				numberOfDilutions=(Length[serialDilutionList/.{Null->Nothing}]+Length[dilutionList/.{Null->Nothing}]);
				
				1.05*(numberOfDilutions+1)*syringeSize
			]
		],
		{expandedSerialDilutions,expandedDilutions}
	]];
	
	rinseWaterResource=Link[Resource[Sample->Model[Sample, "Milli-Q water"],Name->CreateUUID[],Amount->rinseWaterVolume,Container->PreferredContainer[rinseWaterVolume]]];
	
	(*-- Check points --*)
	checkpoints={
		{"Preparing Samples", 1 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 1 Minute]]},
		{"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]},
		{"Priming The Instrument", estimatedPrimeTime, "Cleaning the Instrument with PrimeSolutions.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 15 * Minute]]},
		{"Measuring Particle Sizes", estimatedRunTime, "Measuring particle sizes of each sample/diluted sample one by one.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 15 * Minute]]},
		{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 5 * Minute]]},
		{"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 * Minute]]}
	};
		
	(* fill in the protocol packet with all the resources *)
	protocolPacket=<|
		Object -> CreateID[Object[Protocol,CountLiquidParticles]],
		Template -> If[MatchQ[Lookup[resolvedOptionsNoHidden, Template], FieldReferenceP[]],
			Link[Most[Lookup[resolvedOptionsNoHidden, Template]], ProtocolsTemplated],
			Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated]
		],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsNoHidden,
		Replace[Checkpoints] -> checkpoints,
		
		(*Resources to be upload*)
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ containersInResources),
		
		(* Single Field*)
		Instrument->instrumentResource,
		Sensor->Link[sensor],
		Syringe->syringeResource,
		SyringeSize->syringeSize,
		FillLiquid->fillLiquidResource,
		StirBarRetriever->stirBarRetrieverResource,
		RinsingSolution->rinseWaterResource,
		Replace[Dilutions]->expandedDilutions,
		Replace[SerialDilutions]->expandedSerialDilutions,
		
		Replace[DiscardFirstRuns]->discardFirstRuns,
		Replace[AcquisitionMixes]->acquisitionMix,
		Replace[AcquisitionMixTypes]->acquisitionMixType,
		Replace[NumberOfMixes]->numberOfMixes,
		Replace[WaitTimeBeforeReadings]->waitTimeBeforeReading,
		Replace[AcquisitionMixRateIncrements]->acquisitionMixRateIncrement,
		Replace[AcquisitionMixRates]->acquisitionMixRate,
		Replace[AdjustMixRates]->adjustMixRate,
		Replace[Diluents]->diluentResources,
		Replace[DilutionContainers]->dilutionContainerList,
		Replace[DilutionContainerResouces]->dilutionContainerResource,
		Replace[DilutionMixRates]->dilutionMixRate,
		Replace[DilutionMixVolumes]->dilutionMixVolume,
		Replace[DilutionNumberOfMixes]->dilutionNumberOfMixes,
		Replace[DilutionStorageConditions]->dilutionStorageCondition,
		Replace[SamplingHeights]->samplingHeights,
		Replace[EquilibrationTimes]->Replace[equilibrationTime, {Null -> 0Minute}],
		Replace[FlowRates]->flowRate,
		Replace[MaxAcquisitionMixRates]->maxAcquisitionMixRate,
		Replace[MaxStirAttempts]->maxStirAttempts,
		Replace[MinAcquisitionMixRates]->minAcquisitionMixRate,
		Replace[NumberOfPrimes]->numberOfPrimes,
		Replace[PrimeIndexes]->(Range/@numberOfPrimes),
		Replace[NumberOfWashes]->numberOfWashes,
		Replace[WashIndexes]->(Range/@numberOfWashes),
		Replace[NumberOfReadings]->numberOfReadings,
		Replace[ParticleSizes]->particleSizes,
		Replace[PreRinseVolumes]->preRinseVolume,
		Replace[PreRinseVolumeStrings]->(ToString[Round[Unitless[#,Milliliter],0.001]]&/@preRinseVolume),
		Replace[PrimeEquilibrationTimes]->primeEquilibrationTime,
		Replace[PrimeSolutions]->primeSolutionsResources,
		Replace[PrimeSolutionTemperatures]->(primeSolutionTemperatures/.{Ambient->$AmbientTemperature}),
		Replace[PrimeWaitTimes]->Replace[primeWaitTimes, {Null -> 0Minute}],
		Replace[ReadingVolumes]->readingVolume,
		Replace[SampleLoadingVolumes]->sampleLoadingVolumes,
		Replace[SampleTemperatures]->(sampleTemperature/.{Ambient->$AmbientTemperature}),
		Replace[StirBars]->stirBarResources,
		Replace[WashEquilibrationTimes]->Replace[washEquilibrationTime, {Null -> 0Minute}],
		Replace[WashSolutions]->washSolutionsResources,
		Replace[WashSolutionTemperatures]->(washSolutionTemperature/.{Ambient->$AmbientTemperature}),
		Replace[WashWaitTimes]->Replace[washWaitTime, {Null -> 0Minute}]
	|>;
	
	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache -> cache, Simulation -> updatedSimulation];
	
	
	(* --- Generate our unit operation protocol packet and method packet --- *)
	Block[{ExperimentCountLiquidParticles},
		
		ExperimentCountLiquidParticles[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
			(* Lookup the output specification the framework is asking for. *)
			frameworkOutputSpecification=Lookup[ToList[options], Output];
			
			frameworkOutputSpecification /. {
				Result -> protocolPacket,
				Options -> resolvedOptionsNoHidden,
				Preview -> Null,
				Simulation -> simulation
			}
		];
		
		allMethodPackets=If[MemberQ[output,Result],
			UploadCountLiquidParticlesMethod[
				ToList[mySamples],
				
				(*Experiment Options*)
				Syringe->Lookup[resolvedOptionsNoHidden,Syringe],
				SyringeSize->Lookup[resolvedOptionsNoHidden,SyringeSize],
				ParticleSizes->Lookup[resolvedOptionsNoHidden,ParticleSizes],
				DilutionCurve->Lookup[resolvedOptionsNoHidden,DilutionCurve],
				SerialDilutionCurve->Lookup[resolvedOptionsNoHidden,SerialDilutionCurve],
				Diluent->Lookup[resolvedOptionsNoHidden,Diluent],
				DilutionContainer->Lookup[resolvedOptionsNoHidden,DilutionContainer],
				DilutionStorageCondition->Lookup[resolvedOptionsNoHidden,DilutionStorageCondition],
				DilutionMixVolume->Lookup[resolvedOptionsNoHidden,DilutionMixVolume],
				DilutionNumberOfMixes->Lookup[resolvedOptionsNoHidden,DilutionNumberOfMixes],
				DilutionMixRate->Lookup[resolvedOptionsNoHidden,DilutionMixRate],
				ReadingVolume->Lookup[resolvedOptionsNoHidden,ReadingVolume],
				SampleTemperature->Lookup[resolvedOptionsNoHidden,SampleTemperature],
				EquilibrationTime->Lookup[resolvedOptionsNoHidden,EquilibrationTime],
				NumberOfReadings->Lookup[resolvedOptionsNoHidden,NumberOfReadings],
				PreRinseVolume->Lookup[resolvedOptionsNoHidden,PreRinseVolume],
				DiscardFirstRun->Lookup[resolvedOptionsNoHidden,DiscardFirstRun],
				AcquisitionMix->Lookup[resolvedOptionsNoHidden,AcquisitionMix],
				AcquisitionMixType->Lookup[resolvedOptionsNoHidden,AcquisitionMixType],
				NumberOfMixes->Lookup[resolvedOptionsNoHidden,NumberOfMixes],
				WaitTimeBeforeReading->Lookup[resolvedOptionsNoHidden,WaitTimeBeforeReading],
				StirBar->Lookup[resolvedOptionsNoHidden,StirBar],
				AcquisitionMixRate->Lookup[resolvedOptionsNoHidden,AcquisitionMixRate],
				AdjustMixRate->Lookup[resolvedOptionsNoHidden,AdjustMixRate],
				MinAcquisitionMixRate->Lookup[resolvedOptionsNoHidden,MinAcquisitionMixRate],
				MaxAcquisitionMixRate->Lookup[resolvedOptionsNoHidden,MaxAcquisitionMixRate],
				AcquisitionMixRateIncrement->Lookup[resolvedOptionsNoHidden,AcquisitionMixRateIncrement],
				MaxStirAttempts->Lookup[resolvedOptionsNoHidden,MaxStirAttempts],
				WashSolution->Lookup[resolvedOptionsNoHidden,WashSolution],
				WashSolutionTemperature->Lookup[resolvedOptionsNoHidden,WashSolutionTemperature],
				WashEquilibrationTime->Lookup[resolvedOptionsNoHidden,WashEquilibrationTime],
				WashWaitTime->Lookup[resolvedOptionsNoHidden,WashWaitTime],
				NumberOfWash->Lookup[resolvedOptionsNoHidden,NumberOfWashes],
				SamplingHeight->Lookup[resolvedOptionsNoHidden,SamplingHeight],
				
				(* Function informations *)
				Cache->cache,
				Simulation->simulation,
				Upload->False
			],
			{}
		];
	];
	
	(* Expand the method packet by number of replicates *)
	expandedMethodPackets=Flatten[Map[ConstantArray[#,(numReplicates/.Null->1)]&,ToList[allMethodPackets]],1];
	
	(* All method packet objects *)
	methodPacketsToUpload=If[
		Length[expandedMethodPackets]>0,
		DeleteDuplicates[PickList[expandedMethodPackets,saveCustomMethod]],
		{}
	];
	
	(* generate a uploadable method objects based on ou resolved SaveCustomMethod options*)
	resolvedMethodsForProtocol=If[
		Length[expandedMethodPackets]>0,
		MapThread[
			Function[{packet,bool,eachMethod},
				Which[
					bool, Lookup[packet,Object],
					MatchQ[eachMethod,ObjectP[]],eachMethod,
					True,Null
				]
			],
			{expandedMethodPackets,saveCustomMethod,method}
		],
		{}
	];
	
	(* generate method information packet to the protocol packet *)
	methodPacketForProtocolUpload=<|
		Replace[Methods]->Map[
			If[
				NullQ[#],
				Null,
				Link[#]
			]&,
			resolvedMethodsForProtocol
		]
	|>;
	
	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Flatten[{Join[sharedFieldPacket, methodPacketForProtocolUpload, protocolPacket], methodPacketsToUpload}];
	
	(* --- fulfillableResourceQ --- *)
	
	(* get all the resource blobs*)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	rawResourceBlobs = DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket]}],_Resource,Infinity]];
	
	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];
	
	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;
	
	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		(* If in engine, return True *)
		MatchQ[$ECLApplication, Engine], {True, {}},
		
		(* return test if gather test *)
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation->updatedSimulation, Cache->cache],
		
		(* catch all *)
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation->updatedSimulation, Messages -> messages,Cache->cache], Null}
	];
	
	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;
	
	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];
	
	
	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];
	
	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket/.resourceToNameReplaceRules,
		$Failed
	];
	
	(* generate the simulation output rule *)
	simulationRule = Simulation -> If[MemberQ[output, Simulation] && !MemberQ[output, Result],
		finalizedPacket,
		Null
	];
	
	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}

];


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentCountLiquidParticles,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentCountLiquidParticles[
	myProtocolPacket:(PacketP[Object[Protocol, CountLiquidParticles], {Object, ResolvedOptions}]|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCountLiquidParticles]
]:=Module[
	{listedSamples,cache,simulation,samplePackets,protocolObject,currentSimulation,simulationWithLabels,sampleLoadingVolumes,sampleVolumes,sampleStatusSimulation},
	
	listedSamples= ToList[mySamples];

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];
	
	(* Download containers from our sample packets. *)
	samplePackets=Download[
		listedSamples,
		Packet[Container,Volume],
		Cache->cache,
		Simulation->simulation
	];
	
	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[Object[Protocol,CountLiquidParticles]],
		True,
		Lookup[myProtocolPacket, Object]
	];
	
	
	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=If[
		
		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->(Resource[Sample->#]&)/@listedSamples,
				Instrument->Resource[Sample->Lookup[myResolvedOptions,Instrument],Time->10Minute],
				Syringe->Resource[Sample->Lookup[myResolvedOptions,Syringe],Time->10Minute],
				Diluents->(Resource[Sample->#]&)/@Cases[Lookup[myResolvedOptions,Diluent],Except[Null]],
				DilutionContainers->(Resource[Sample->#]&)/@Cases[Lookup[myResolvedOptions,DilutionContainer],Except[Null]],
				PrimeSolutions->(Resource[Sample->#]&)/@Cases[Lookup[myResolvedOptions,PrimeSolutions],Except[Null]],
				StirBars->(Resource[Sample->#]&)/@Cases[Lookup[myResolvedOptions,StirBar],Except[Null]],
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
		],
		
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Transfer]. *)
		
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, CountLiquidParticles]. *)
		SimulateResources[myProtocolPacket, Null, Cache->cache, Simulation->simulation]
	];
	
	(* Update the simulation *)
	currentSimulation=UpdateSimulation[simulation, currentSimulation];
	
	(* Update the sample transfer *)
	sampleLoadingVolumes= Lookup[myProtocolPacket,Replace[SampleLoadingVolumes]];
	sampleVolumes= Lookup[samplePackets,Volume];
	
	(* Update sample properties *)
	sampleStatusSimulation=Simulation[UploadSampleProperties[listedSamples, Volume ->Convert[(sampleVolumes-sampleLoadingVolumes),Milliliter],Simulation->currentSimulation, Upload->False]];
	
	(* Update the simulation *)
	currentSimulation=UpdateSimulation[currentSimulation, sampleStatusSimulation];
	
 	(* Uploaded Labels *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], listedSamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&)/@Range[Length[listedSamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[listedSamples]]}],
				{_String, _}
			]
		]
	];
	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];

(* ::Subsection:: *)
(*Helpers*)
(* ::Subsection:: *)
(* expand samples/options for replicates *)
expandCountLiquidParticlesReplicates[mySamples:{ObjectP[]...},options:{(_Rule|_RuleDelayed)..},numberOfReplicates:(_Integer|Null)]:=Module[
	{samplesWithReplicates,mapThreadOptions,optionsWithReplicates},
	
	(*Repeat the inputs if we have replicates*)
	samplesWithReplicates=duplicateCountLiquidParticlesReplicates[mySamples,numberOfReplicates];
	
	(* Determine options index-matched to the input *)
	mapThreadOptions=Lookup[Select[OptionDefinition[ExperimentCountLiquidParticles],MatchQ[Lookup[#,"IndexMatchingInput"],Except[Null]]&],"OptionSymbol"];
	
	(*Repeat MapThread options if we have replicates*)
	optionsWithReplicates=Map[
		If[MemberQ[mapThreadOptions,First[#]],
			First[#]->duplicateCountLiquidParticlesReplicates[Last[#],numberOfReplicates],
			First[#]->Last[#]
		]&,
		options
	];
	
	{samplesWithReplicates,optionsWithReplicates}
];

(* == duplicateCountLiquidParticlesReplicates HELPER == *)
(* Helper for expandCountLiquidParticlesReplicates. Given non-expanded sample input, and the numberOfReplicate, repeat the inputs if we have replicates *)
duplicateCountLiquidParticlesReplicates[value_,numberOfReplicates_]:=Module[{},
	If[MatchQ[numberOfReplicates,Null],
		value,
		Flatten[Map[ConstantArray[#,numberOfReplicates]&,value],1]
	]
];

makeResourceWithLimit[objectList_List, volumeList_List, limit_] := Module[
	{index, indexDict, totalVolDic, currVal, indexList, resources,objVolumeTuples},
	(* Init the association to store the information*)
	indexDict = <||>;
	totalVolDic = <||>;

	(* init the association with the default value *)
	(indexDict[#] = {0Milliliter, 0}) & /@ objectList;(*{volume, index}*)
	(totalVolDic[#] = <||>) & /@ objectList;

	objVolumeTuples=Transpose[{objectList,volumeList}];
	
	(* Generate the index to indicate which container we will use during the resource generation *)
	indexList = MapThread[
		Function[
			{obj, volume},

			(* Get the current index and volume*)
			{currVal, index} = Lookup[indexDict, obj];
			
			(* if the total volume will exceed the limit, iterate the index and reset the current volume for the next calculation *)
			If[volume + currVal > limit,
				(
					totalVolDic[obj][index] = currVal;
					currVal = volume; (* reset to current volume*)
					index = index + 1 (*iterate*)
				),
				((*otherwise we will just add the current volume*)
					currVal = currVal + volume
				)
			];
			
			(* in the association all the current information will be stored *)
			indexDict[obj] = {currVal, index};
			totalVolDic[obj][index] = currVal;
			index
		],
		{objectList, volumeList}
	];
	
	(* make the resource *)
	resources = MapThread[
		Function[{obj,currIndex},
			Module[{currTotalVolume, prefContainer, currName},
				
				(* Get all inforamtion *)
				currTotalVolume = Lookup[Lookup[totalVolDic, obj], currIndex];
				prefContainer = PreferredContainer[currTotalVolume];
				
				(* since resource system is using name to control if the resource is an unique one, here make unique names *)
				currName = (ToString[ObjectToFilePath[obj, FastTrack -> True]] <> "_" <> ToString[currTotalVolume] <> "_" <> ToString[currIndex]);
				
				(* Make the resource *)
				Resource[
					Sample -> obj,
					Amount -> currTotalVolume,
					Container -> prefContainer,
					Name -> currName
				]
			]
		],
		{objectList,indexList}
	];
	resources
]