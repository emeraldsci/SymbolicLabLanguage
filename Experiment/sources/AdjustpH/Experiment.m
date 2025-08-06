(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* AdjustpHSharedOptions *)




DefineOptions[ExperimentAdjustpH,
	Options :> {
		IndexMatching[
			{
				OptionName -> SampleLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the sample that has its pH adjusted, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName->SampleContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the container of the sample that has its pH adjusted, for use in downstream unit operations.",
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
				OptionName->HistoricalData,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Object[Data, pHAdjustment]]
				],
				Description->"The pH adjustment data used to determine the fixed additions in this protocol. The fixed additions and the titrant reflected in the data will be added as fixed additions in this protocol.",
				ResolutionDescription->"Automatically set to use data for an aliquot of the sample whose pH is being adjusted. If no aliquot pHing data exists, data from a sample with the same model or composition will be used. Data for an adjustment that didn't overshoot will be used first. Otherwise, data from the adjustment which got closest to the target pH before overshooting will be used and the amount of titrant added before the overshoot event will be added in this protocol.",
				Category->"Pre-Titrated Additions"
			},

			(* Check if this agrees with Historical data, otherwise throw a warning *)
			{
				OptionName->FixedAdditions,
				Default->Automatic,
				Description->"A list of all samples and amounts to add in the form {amount, sample}.",
				ResolutionDescription->"Defaults to use the fixed additions and the titrant values from the historical data.",
				AllowNull->False,
				Category->"Pre-Titrated Additions",
				Widget->Alternatives[
					Adder[
						{
							"Amount"->Alternatives[
								"Mass"->Widget[
									Type->Quantity,
									Pattern :> RangeP[0 * Milligram, 1 Kilogram],
									Units->{Gram, {Milligram, Gram, Kilogram}}
								],
								"Volume"->Widget[
									Type->Quantity,
									Pattern :> RangeP[0 * Milliliter, 20 Liter],
									Units->{Milliliter, {Microliter, Milliliter, Liter}}
								],
								"Count"->Widget[
									Type->Number,
									Pattern :> RangeP[1, 100,1]
								]
							],
							"Sample"->Widget[
								Type->Object,
								Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials"
									}
								}
							]
						}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None]
					]
				]
			},

			{
				OptionName->TitrationMethod,
				Default->Automatic,
				Widget->Widget[Type->Enumeration,Pattern :> Manual|Robotic],
				Description->"For each member of the input samples, if the transfer of acid and base for pH adjustment is manual or robotic. For each input sample, if TitrationMethod is Robotic, the pH adjustment will be performed by pHTitrator and the pH measurement will be performed by SevenExcellence pH Meter with remote control.",
				ResolutionDescription->"For each input sample, TitrationMethod is Manual if Aliquot is True, or either of TitratingAcid and TitratingBase is not liquid, or pHMixType is not Stir, or pHMeter is not SevenExcellence. Otherwise, TitrationMethod is Robotic.",
				AllowNull->False,
				Category->"General"
			},
			{
				OptionName->TitrationInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, pHTitrator], Object[Instrument, pHTitrator]}]
				],
				Description->"For each member of the input samples, the instrument for making robotic transfer of acid and base in pH adjustment.",
				ResolutionDescription->"For each input sample, if TitrationMethod is Robotic, TitrationInstrument will be Model[Instrument, pHTitrator, \"Microlab 600 (ML600) pH Titrator\"]. Otherwise, TitrationInstrument will be Null.",
				Category->"General"
			},

			{
				OptionName->TitrationContainerCap,
				Default->Automatic,
				ResolutionDescription -> "Automatically set to the compatible cap of the AliquotContainer when TitrationMethod is Robotic",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Item, Cap]
					}]
				],
				Description->"The cap that is used to assemble pH probe, the overhead stirrer shaft and the acid and base addition tubings of pHTitrator when TitrationMethod is set to Robotic.",
				Category->"Hidden" (* It is hard to pre-determine if the given cap will be compatible for Robotic Titration before TitrationMethod and titration container (aliquot contaienr or sample container) is resolved. So we do not want user to specify this option. *)
			},
			(* -- pH Measurement -- *)

			(* Options from ExperimentMeasurepH *)
			{
				OptionName->pHMeter,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Instrument, pHMeter], Model[Instrument, pHMeter]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Measuring Devices",
							"pH Measurement",
							"pH Meters"
						}
					}
				],
				Description->"For each member of the input samples, the pH meter to be used for pH measurements.",
				ResolutionDescription->"For each input sample, the pH meter chosen is the first pH probe that fits into the container of the sample.",
				Category->"pH Measurement"
			},
			{
				OptionName->ProbeType,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>pHProbeTypeP
				],
				Description->"For each member of the input samples, the type of pH meter (Surface or Immersion) to be used for measurement.",
				ResolutionDescription->"For each input sample, the type of pH meter is choosen based on minimizing the aliquot volume.",
				Category->"pH Measurement"
			},
			{
				OptionName->Probe,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Part, pHProbe],Model[Part, pHProbe]}]
				],
				Description->"The pH probe which is immersed in each sample for conductivity measurement.",
				ResolutionDescription->"If the sample volume is small, a microprobe will be chosen. Otherwise, set to the large immersion probe.",
				Category->"pH Measurement"
			},
			{
				OptionName->AcquisitionTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern:>RangeP[0 Second,30 Minute],Units->{1,{Minute,{Minute,Second}}}],
				Description->"The amount of time that data from the pH sensor should be acquired. 0 Second indicates that the pH sensor should be pinged instantaneously, collecting only 1 data point. When set, SensorNet pings the instrument in 1 second intervals. This option cannot be set for the non-Sensor Array pH instruments since they only provide a single pH reading.",
				ResolutionDescription->"Resolves to 5 Second if the probe is connected to our SensorNet system; otherwise, set to Null.",
				Category->"pH Measurement"
			},
			{
				OptionName->TemperatureCorrection,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration, Pattern:>Alternatives[Linear,Off]],
				Description->"Defines the relationship between temperature and pH. Linear: Use for the temperature correction of medium and highly conductive solutions. Off: The pH value at the current temperature is displayed.",
				ResolutionDescription->"Set to Linear if the instrument is capable; otherwise, Null.",
				Category->"pH Measurement"
			},

			(* If the probe won't fit, we'll resolve Aliquot\[Rule]True, not pHAliquot\[Rule]True *)
			{
				OptionName->pHAliquot,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if an aliquot should be taken from the input sample and used to measure the pH, as opposed to directly immersing the probe in the input sample.",
				Category->"pH Measurement"
			},
			{
				OptionName->pHAliquotVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[1 Microliter, 20 Liter],Units :> {1,{Milliliter,{Microliter,Milliliter}}}],
				Description->"The volume to remove from the input sample and measure.",
				Category->"pH Measurement"
			},
			{
				OptionName->RecoupSample,
				Default->False,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if the aliquot used to measure the pH should be returned to source container after each reading.",
				Category->"pH Measurement"
			},

			(* -- pH Titration -- *)
			{
				OptionName->Titrate,
				Default->True,
				Description->"Indicates if titrating acid and/or base should be added until the pH is within the bounds specified by MinpH and MaxpH or until MaxNumberOfCycles or MaxAdditionVolume is reached. If Titrate is False, only FixedAdditions will be added to adjust pH.",
				AllowNull->False,
				Category->"pH Titration",
				Widget->Widget[Type->Enumeration,Pattern :> BooleanP]
			},
			{
				OptionName->TitratingAcid,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Acids"
						}
					}
				],
				Description->"The acid used to adjust the pH of the solution.",
				ResolutionDescription->"If Titrate is True, resolve to Model[Sample, StockSolution, \"2 M HCl\"].",
				Category->"pH Titration"
			},
			{
				OptionName->TitratingBase,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Bases"
						}
					}
				],
				Description->"The base used to adjust the pH of the solution.",
				ResolutionDescription->"If Titrate is True, resolve to Model[Sample,StockSolution,\"1.85 M NaOH\"].",
				Category->"pH Titration"
			},
			(* Figure something out such that we can be mixing while adding (actually simultaneously) - try using InSitu ExperimentTransfer *)
			{
				OptionName->MixWhileTitrating,
				Default->False,
				Description->"Indicates if the input sample should be mixed as titrating acid/base additions are made.",
				AllowNull->False,
				Category->"Hidden", (*TODO: hidden until we figure out how to do mix while titrating*)
				Widget->Widget[Type->Enumeration, Pattern :> BooleanP]
			},
			(* EXISTING MIX OPTIONS *)
			{
				OptionName->pHMixType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration, Pattern :> MixTypeP],
				Description->"Indicates the style of motion used to mix the sample.",
				ResolutionDescription->"Automatically sets based on the container of the sample and the Mix option. Specifically, if Mix is set to False, the option is set to Null. If pHMixInstrument is specified, the option is set based on the specified pHMixInstrument.  If pHMixRate and Time are Null, when pHMixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If SonicationAmplitude, MaxTemperature, or DutyCycle is not Null, the option is set to Homogenizer. If pHMixRate is set, the option is set base on any instrument that is capable of mixing the sample at the specified pHMixRate.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixUntilDissolved,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern :> (BooleanP)],
				Description->"Indicates if the mix should be continued up to the MaxTime or MaxNumberOfpHMixes (chosen according to the mix Type), in an attempt dissolve any solute.",
				ResolutionDescription->"Automatically resolves to True if MaxTime or MaxNumberOfpHMixes is set.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description->"The instrument used to perform the Mix and/or Incubation.",
				ResolutionDescription->"Automatically resolves based on the options Mix, Temperature, pHMixType and container of the sample.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixImpeller,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[Model[Part,StirrerShaft],Object[Part,StirrerShaft]]
				],
				Description->"The stirring shaft that is compatible with the pHMixInstrument.",
				ResolutionDescription->"Automatically resolves to the impeller compatible with the chosen pHMixInstrument.",
				Category->"Hidden"
			},
			{
				OptionName->pHMixTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description->"Duration of time for which the samples will be mixed.",
				ResolutionDescription->"Automatically resolves based on the mix Type and container of the sample.",
				Category->"Mixing"
			},
			{
				OptionName->MaxpHMixTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description->"Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the pHMixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
				ResolutionDescription->"Automatically resolves based on the mix Type and container of the sample.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixDutyCycle,
				Default->Automatic,
				AllowNull->True,
				Widget->{
					"Time On"->Widget[Type->Quantity,Pattern:>RangeP[0 Minute, 60 Hour],Units->{1,{Millisecond,{Millisecond,Second,Minute,Hour}}}],
					"Time Off"->Widget[Type->Quantity,Pattern:>RangeP[0 Minute, 60 Hour],Units->{1,{Millisecond,{Millisecond,Second,Minute,Hour}}}]
				},
				Description->"Specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
				ResolutionDescription->"Automatically resolves to {10 Millisecond, 10 Millisecond} if mixing by homogenization.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixRate,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
				Description->"Frequency of rotation the mixing instrument should use to mix the samples.",
				ResolutionDescription->"Automatically, resolves based on the sample container and instrument instrument model.",
				Category->"Mixing"
			},
			{
				OptionName->NumberOfpHMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description->"Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
				ResolutionDescription->"Automatically, resolves based on the mix Type.",
				Category->"Mixing"
			},
			{
				OptionName->MaxNumberOfpHMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description->"Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the pHMixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
				ResolutionDescription->"Automatically resolves based on the mix Type and container of the sample.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[1 Microliter, 50 Milliliter],Units :> {1,{Milliliter,{Microliter,Milliliter}}}],
				Description->"The volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
				Category->"Mixing"
			},
			{
				OptionName->pHMixTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units :> Celsius],
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
				],
				Description->"The temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
				Category->"Mixing"
			},
			{
				OptionName->MaxpHMixTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius],Units :> Celsius],
				Description->"The maximum temperature that the sample should reach during mixing via homogenization. If the measured temperature is above this MaxTemperature, the homogenizer will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume.",
				Category->"Mixing"
			},
			{
				OptionName->pHHomogenizingAmplitude,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity, Pattern :> RangeP[10 Percent, 100 Percent],Units :> Percent],
				Description->"The amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
				Category->"Mixing"
			},

			(* pHing Limits *)
			{
				OptionName->MinpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern :> RangeP[0,14]
				],
				Description->"The values used to set the lower end of the nominal pH range. If the measured pH is between this minimum and the MaxpH titrations will stop. If the MaxNumberOfCycles or the MaxAdditionVolume is reached first, than the final pH may not be above this minimum.",
				ResolutionDescription->"Automatically set to 0.1 below the nominal pH.",
				Category->"pHing Limits"
			},
			{
				OptionName->MaxpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern :> RangeP[0, 14]
				],
				Description->"The values used to set the upper end of the nominal pH range. If the measured pH is above the MinpH and below this maximum pH titrations will stop. If the MaxNumberOfCycles or the MaxAdditionVolume is reached first, than the final pH may not be below this maximum.",
				ResolutionDescription->"Automatically set to 0.1 below the nominal pH.",
				Category->"pHing Limits"
			},
			{
				OptionName->MaxAdditionVolume,
				Default->Automatic,
				Description->"Indicates the maximum volume of TitratingAcid and TitratingBase that can be added during the course of titration before the experiment will continue, even if the nominalpH is not reached (pHsAchieved->False).",
				ResolutionDescription->"Defaults to 6.8% of the TotalVolume, unless it exceeds the specified sample container or is specified by StockSolution sample model.",
				AllowNull->False,
				Category->"pHing Limits",
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Microliter,20 Liter],
					Units->{Milliliter, {Microliter, Milliliter, Liter}}
				]
			},
			{
				OptionName->MaxNumberOfCycles,
				Default->Automatic,
				Description->"Indicates the maximum number of additions to make before stopping titrations during the course of titration before the experiment will continue, even if the nominalpH is not reached (pHsAchieved->False).",
				ResolutionDescription->"Set to the MaxNumberOfpHingCycles value in ModelOut. Otherwise, defaults to 10 if TitrationMethod is Manual or 50 if TitrationMethod is Robotic.",
				AllowNull->False,
				Category->"pHing Limits",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,50]
				]
			},
			{
				OptionName->MaxAcidAmountPerCycle,
				Default->Automatic,
				Description->"Indicates the maximum amount of TitratingAcid that can be added in a single titration cycle.",
				ResolutionDescription->"Defaults to 0.5% of the initial sample volume if titration method is robotic, 2.5% of the initial sample volume if titrant is liquid and titration method is manual, 2 Grams/Liter if titrant is solid.",
				AllowNull->True,
				Category->"pHing Limits",
				Widget->Alternatives[
					"Mass"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milligram, 1 Kilogram],
						Units->{Gram, {Milligram, Gram, Kilogram}}
					],
					"Volume"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milliliter, 20 Liter],
						Units->{Milliliter, {Microliter, Milliliter, Liter}}
					]
				]
			},
			{
				OptionName->MaxBaseAmountPerCycle,
				Default->Automatic,
				Description->"Indicates the maximum amount of TitratingBase that can be added in a single titration cycle.",
				ResolutionDescription->"Defaults to 0.5% of the initial sample volume if titration method is robotic, 2.5% of the initial sample volume if titrant is liquid and titration method is manual, 2 Grams/Liter if titrant is solid.",
				AllowNull->True,
				Category->"pHing Limits",
				Widget->Alternatives[
					"Mass"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milligram, 1 Kilogram],
						Units->{Gram, {Milligram, Gram, Kilogram}}
					],
					"Volume"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milliliter, 20 Liter],
						Units->{Milliliter, {Microliter, Milliliter, Liter}}
					]
				]
			},
			{
				OptionName->ContainerOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description->"The container model in which the newly pH-adjusted sample should be stored after all adjustment steps have completed. If NumberOfReplicates is not Null, each replicate will be pooled back into the same ContainerOut. Null indicates the pH-adjusted sample remains in it's current container.",
				ResolutionDescription->"Automatically selected from ECL's stocked containers based on the volume of solution being prepared.",
				Category->"Storage Information"
			},
			{
				OptionName->ModelOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[Model[Sample]]
				],
				Description->"Indicates the desired Model the SamplesOut is set to after pH adjustment.",
				ResolutionDescription->"If SamplesIn Model is Model[Sample], set to Null. If SamplesIn's Model is Model[Sample,StockSolution], when NominalpH is within the Model's specified MinpH and MaxpH, or is the same as the Model's specified NominalpH, then preserve SamplesIn's Model. Otherwise, set to Null.",
				Category->"Hidden"
			},
			{
				OptionName->NonBuffered,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if the sample is not well buffered and therefore requires a less aggressive titrating method.",
				ResolutionDescription->"If ModelOut pHLog indicates pH change larger than one while overshooting, resolve to True, otherwise False.",
				Category->"Hidden"
			},
			IndexMatchingInput->"experiment samples"
		],
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"The number of times to repeat the adjustment on each provided 'sample'. Only available when Aliquot->True and ConsolidateAliquots->False.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[2,10,1]],
			Category->"General"
		},
		{
			OptionName -> MaxpHSlope,
			Default -> Automatic,
			Description -> "The maximum allowed pH slope, expressed as a percentage of the theoretical value. When the temperature is 25 °C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation (see derivation in Object[EmeraldCloudFile,\"id:xRO9n3EL1o8O\"]).",
			ResolutionDescription -> "Automatically set to 105% if using SevenExcellence instrument. Otherwise, set to Null.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[100 Percent], Units :> Percent],
			Category -> "Calibration"
		},
		{
			OptionName -> MinpHSlope,
			Default -> Automatic,
			Description -> "The minimum allowed pH slope, expressed as a percentage of the theoretical value. When the temperature is 25 °C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation (see derivation in Object[EmeraldCloudFile,\"id:xRO9n3EL1o8O\"]).",
			ResolutionDescription -> "Automatically set to 95% if using SevenExcellence instrument. Otherwise, set to Null.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> LessP[100 Percent], Units :> Percent],
			Category -> "Calibration"
		},
		{
			OptionName -> MinpHOffset,
			Default -> Automatic,
			Description -> "The minimum allowed y-intercept of the fitted slope when using SevenExcellence instrument.",
			ResolutionDescription ->  "Automatically set to -20 Milli * Volt if using SevenExcellence instrument. Otherwise, set to Null.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> LessP[0 Milli*Volt], Units :> Milli*Volt],
			Category -> "Calibration"
		},
		{
			OptionName -> MaxpHOffset,
			Default -> Automatic,
			Description -> "The maximum allowed y-intercept of the fitted slope when using SevenExcellence instrument.",
			ResolutionDescription ->  "Automatically set to 20 Milli * Volt if using SevenExcellence instrument. Otherwise, set to Null.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milli*Volt], Units :> Milli*Volt],
			Category -> "Calibration"
		},

		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SamplesOutStorageOptions,
		KeepInstrumentOption,
		SimulationOption
	}
];


(* ::Subsection::Closed:: *)
(* resolveExperimentAdjustpHOptions Helper Function*)

Error::FixedAdditionsConflict="If HistoricalData and FixedAdditions are specified the value from HistoricalData must match the fixed additions. Check `1` or specify only HistoricalData or FixedAdditions";
Error::NoAdditions="There are no fixed additions and titration is turned off so no pH adjustments can be made. Please turn one of these options on. Check `1`";
Error::InvalidTitrateCombo="If Titrate is True, TitratingAcid and TitratingBase must be set and if Titrate->False they cannot be set. Please check your Titrate value and consider allowing some of these options to resolve automatically for samples `1`";
Error::OverheadMixingRequired="When mixing during titration only overhead mixing is possible. Due to physical constraints all other mixing will happen immediately after titrant is added and stop before taking the next pH reading. Please consider setting MixWhileTitrating to False or changing the pHMixType. Check `1`";
Error::MaxVolumeExceeded="The MaxAdditionVolume must be less than or equal to volume needed to fill container";
Error::ConflictingpHRange="NominalpH must be larger than MinpH, and smaller than MaxpH. Check the specified MinpH and MaxpH for samples `1`";
Error::ConflictingTitratingAcidAndAmount="TitragingAcid and MaxAcidAmountPerCycle for samples `1` do not agree. If specified, they must be both Null or both not Null and solid TitragingAcid cannot be transferred by volume.";
Error::ConflictingTitratingBaseAndAmount="TitragingBase and MaxBaseAmountPerCycle for samples `1` do not agree.  If specified, they must be both Null or both not Null and solid TitragingBase cannot be transferred by volume.";
Error::AdjustpHContainerTooSmall="The specified aliquot container, or sample container if Aliquot is specified as False, is not enough to contain the FixedAdditions volume, which is either specified or resolved form a historical data.
This is likely to cause pHAdjustment to fail. Consider changing the specifications of Aliquot and AliquotContainer, or specify a smaller FixedAdditions volume with a more concentrated acid/base.";
Error::ConflictingTitrationMethod="TitrationMethod and titrating options for samples `1` do not agree. The TitrationMethod is specified to be Robotic but incompatible options are specified. When TitrationMethod is Robotic, pHMixType must be Stir, pHMeter model must be SevenExcellence pH meter, pHProbeType must be Immersion, pHAliquot must be False, RecoupSample must be False, Titrate must be True, TitratingAcid and TritratingBase must not be Solid, pHMixUntilDissolved must be False, TitrationInstrument must not be Null and pHMixInstrument must be OverheadStirrer. Please check the titrating options and make sure they are compatible with specified TitrationMethod.";
Error::ConflictingTitrationInstrument="TitrationInstrument and TitrationMethod for samples `1` do not agree. The TitrationInstrument Model[Instrument, pHTitrator, \"Microlab 600 (ML600) pH Titrator\"] can only be used when TitrationMethod is Robotic. Please check the specified TitrationInstrument and make sure it is not conflicting with TitrationMethod.";

$DefaultRoboticMixingImpeller = Model[Part, StirrerShaft, "id:9RdZXvNroMdJ"]; (*Model[Part, StirrerShaft, "SM-4500-06 PTFEE Impeller without Tape"]*)

(* Helper function that returns a list of roboticTitrationCaps packet *)
capCandidatesInRoboticTitration[memoization_String] := capCandidatesInRoboticTitration[memoization] =
		Module[{roboticTitrationCaps, roboticTitrationCapPackets},
			If[!MemberQ[$Memoization, Experiment`Private`capCandidatesInRoboticTitration],
				AppendTo[$Memoization, Experiment`Private`capCandidatesInRoboticTitration]];

			roboticTitrationCaps = Search[Model[Item, Cap], pHProbe != Null && Deprecated != True && DeveloperObject != True];
			roboticTitrationCapPackets = Quiet[Download[roboticTitrationCaps, {Packet[CoverFootprint, InternalDepth, InternalDiameter, pHProbe]}], {Download::FieldDoesntExist}];
			{roboticTitrationCaps, Flatten[roboticTitrationCapPackets]}
		];

(* Helper function that returns a list of roboticTitrationContainers packet *)
containerCandidatesInRoboticTitration[memoization_String] := containerCandidatesInRoboticTitration[memoization] =
		Module[{titrationContainerModels, titrationContainerModelPackets},
			If[!MemberQ[$Memoization, Experiment`Private`containerCandidatesInRoboticTitration],
				AppendTo[$Memoization, Experiment`Private`containerCandidatesInRoboticTitration]];

			titrationContainerModels = Intersection[Search[Model[Container, Vessel],
				CoverFootprints == Alternatives[CapGL45, Cap83B] && Deprecated != True && DeveloperObject != True], PreferredContainer[All]];
			titrationContainerModelPackets = Quiet[Download[titrationContainerModels,
				{
					Packet[Name, CoverTypes, CoverFootprints, VolumeCalibrations, MaxVolume, Aperture, InternalDiameter, Dimensions, Sterile, Deprecated, Footprint, OpenContainer, InternalDepth, InternalDimensions, Positions, RentByDefault],
					Packet[VolumeCalibrations[{LiquidLevelDetectorModel, CalibrationFunction, EmptyDistanceDistribution, DateCreated, Deprecated, Anomalous, DeveloperObject}]]
				}
			], {Download::FieldDoesntExist}];
			{titrationContainerModels, titrationContainerModelPackets}
		];

(* Helper function that returns a list of robotic titration container-cap tuples *)
containerTuplesInRoboticTitration[memoization_String] := containerTuplesInRoboticTitration[memoization] =
		Module[{roboticTitrationCaps, roboticTitrationCapPackets, titrationContainerModels, titrationContainerModelPackets, titrationContainerVolumeCalibrations, titrationContainerVolumeCalibrationPackets,titrationContainerCalibrationFunctions, titratorCaps, sampleVolumes, sampleAdditionVolumes, probeModel, expandTitrationContainerModels, expandTitratorCaps, capParameters, containerParameters, rawTuples, expandCalibrationFunctions, minVolume, maxVolume},
			If[!MemberQ[$Memoization, Experiment`Private`containerTuplesInRoboticTitration],
				AppendTo[$Memoization, Experiment`Private`containerTuplesInRoboticTitration]];

			{titrationContainerModels, titrationContainerModelPackets} = containerCandidatesInRoboticTitration["Memoization"];
			{roboticTitrationCaps, roboticTitrationCapPackets} = capCandidatesInRoboticTitration["Memoization"];

			titrationContainerVolumeCalibrations = Lookup[titrationContainerModelPackets[[All, 1]], VolumeCalibrations, Null];
			(*If there are multiple calibration functions,pick the last*)
			titrationContainerVolumeCalibrationPackets = Map[
				Function[{volumeCalibration},
					If[Length[volumeCalibration]>0,
						Module[{allVolumeCalibrationPacket, filteredVolumeCalibrationPacket},
							allVolumeCalibrationPacket = Experiment`Private`fetchPacketFromCache[#, Flatten[titrationContainerModelPackets[[All, 2]]]]&/@ volumeCalibration;
							filteredVolumeCalibrationPacket=Cases[allVolumeCalibrationPacket,KeyValuePattern[{Anomalous->Except[True],Deprecated->Except[True],DeveloperObject->Except[True], EmptyDistanceDistribution->Except[Null], LiquidLevelDetectorModel -> ObjectP[]}]];
							If[Length[filteredVolumeCalibrationPacket]>0,
								Last[filteredVolumeCalibrationPacket],
								{}
							]
						],
						{}
					]
			],titrationContainerVolumeCalibrations];

			titrationContainerCalibrationFunctions = Lookup[titrationContainerVolumeCalibrationPackets, CalibrationFunction, Null];
			(* To pick all the possible caps, we set sampleVolumes to be the large enough so that caps won't be filtered because of liquid height limit *)
			sampleVolumes = ConstantArray[Max[Lookup[titrationContainerModelPackets[[All, 1]], MaxVolume]], Length[titrationContainerCalibrationFunctions]];
			(* To pick all the possible caps, we set probeModel to be Automatic so that caps won't be filtered because of different probe models *)
			probeModel = ConstantArray[Automatic, Length[titrationContainerCalibrationFunctions]];
			(* To pick all the possible caps, we set sampleAdditionVolume to be Null so that caps won't be filtered because of max volume exceed *)
			sampleAdditionVolumes = ConstantArray[Null, Length[titrationContainerCalibrationFunctions]];

			titratorCaps = MapThread[findpHTitratorCaps[#1, #2, #3, #4, #5] &,
				{titrationContainerModelPackets[[All, 1]], titrationContainerCalibrationFunctions, probeModel, sampleVolumes, sampleAdditionVolumes}];
			(*Expand other parameters to create tuples*)
			expandTitrationContainerModels = Flatten[MapThread[ConstantArray[#1, Length[#2]] &, {titrationContainerModels, titratorCaps}]];
			expandCalibrationFunctions = Flatten[MapThread[ConstantArray[#1, Length[#2]] &, {titrationContainerCalibrationFunctions, titratorCaps}]];
			expandTitratorCaps = Flatten[titratorCaps];
			capParameters = Lookup[Experiment`Private`fetchPacketFromCache[#, roboticTitrationCapPackets], {CoverFootprint, pHProbe, InternalDepth}] & /@ expandTitratorCaps;
			containerParameters = Lookup[Experiment`Private`fetchPacketFromCache[#, Flatten[titrationContainerModelPackets[[All, 1]]]], {InternalDepth, MaxVolume}] & /@ expandTitrationContainerModels;

			(*containerModel, capModel, CalibrationFunctions, containerInternalDepth, containerMaxVolume, CoverFootprint, probeModel, capInternalDepth*)
			rawTuples = Transpose@Join[{expandTitrationContainerModels, expandTitratorCaps, expandCalibrationFunctions}, Transpose[containerParameters], Transpose[capParameters]];
			(*the minDepths of Model[Instrument, pHMeter, "SevenExcellence (for pH) for Robotic Titration"] is 30 mm for fully immersion, we give 50 mm for safe *)
			minVolume = #[[3]][#[[4]] - #[[8]] + 50 Millimeter] & /@ rawTuples;
			(*Give it a tolerance of 15 Millimeter for volume occupied by probe and stir rod *)
			maxVolume =  #[[3]][#[[4]] - 15 Millimeter] & /@ rawTuples;
			(*containerModel, capModel, minSampleVolume, maxSampleVolume, containerInternalDepth, containerMaxVolume, CoverFootprint, probeModel, capInternalDepth*)
			Transpose@Join[{expandTitrationContainerModels, expandTitratorCaps, minVolume, maxVolume}, Transpose[containerParameters], Transpose[capParameters]]
		];


(* ::Subsection::Closed:: *)
(*ExperimentAdjustpH Main Function*)

(* ::Subsubsection::Closed:: *)
(*ExperimentAdjustpH Main Function Samples as Object[Sample]*)

ExperimentAdjustpH[mySamples:ListableP[ObjectP[Object[Sample]]],nominalpHs:ListableP[pHP],myOptions:OptionsPattern[ExperimentAdjustpH]]:=Module[
	{listedSamplesNamed,listedOptionsNamed,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,
		templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,
		collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests, pHInstrumentLookup, probeLookup,
		specifiedpHInstrumentObjects, specifiedpHInstrumentModels, specifiedProbeObjects, specifiedProbeModels,objectSamplePacketFields,
		pHInstrumentsModels, allInstrumentModels, potentialContainers, aliquotContainerLookup, potentialContainersWAliquot,specifiedHistoricalData,
		fixedAdditionSampleObjects,titratingAcidSampleObjects,titratingBaseSampleOjbects,sampleObjectsToDownload,fixedAdditionSampleModels,
		titratingAcidSampleModels,titratingBaseSampleModels,sampleModelsToDownload,specifiedAliquotContainerObjects,modelSamplePacketFields,
		potentialBeakers,possiblepHInstrumentModels,possibleMixingInstrumentModels,specifiedMixInstrumentObjects,possibleInstruments,modelOut,
		mixingpHInstrumentLookup,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed,returnEarlyQ,
		performSimulationQ,simulatedProtocol,simulation,thing,searchConditionsFailed,searchConditionsFailedDeNulled,pHAchievedQs,
		allDownloadValues,modelContainerFields, expandedInputs,expandedNominalpHs
	},

	(* Make sure we're working with a list of options *)
	{listedSamplesNamed, listedOptionsNamed} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];


	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentAdjustpH,
			listedSamplesNamed,
			listedOptionsNamed
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];


	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentAdjustpH,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentAdjustpH,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Sanitize named inputs *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];


	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentAdjustpH,{mySamplesWithPreparedSamples, nominalpHs},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentAdjustpH,{mySamplesWithPreparedSamples, nominalpHs},myOptionsWithPreparedSamples],{}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentAdjustpH,{ToList[mySamplesWithPreparedSamples],nominalpHs},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentAdjustpH,{ToList[mySamplesWithPreparedSamples],nominalpHs},myOptionsWithPreparedSamples],{}}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand inputs and index-matching options. This also includes the expansion of Standard and Blank related options with
	Standard and Blank as IndexMatchingParent *)
	{expandedInputs, expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentAdjustpH,{ToList[mySamplesWithPreparedSamples],nominalpHs},inheritedOptions];
	(* We allow multiple samples to be adjusted to a same pH; basically ExperimentAdjustpH[{a, a, a}, b] works as ExperimentAdjustpH[{a, a, a}, {b, b, b}] *)
	expandedNominalpHs =expandedInputs[[2]];

			(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(*All of the possible sample objects and models*)
	fixedAdditionSampleObjects=Cases[DeleteDuplicates[Flatten[Lookup[expandedSafeOps,FixedAdditions]]],ObjectP[Object[Sample]]];
	titratingAcidSampleObjects=Cases[DeleteDuplicates[Lookup[expandedSafeOps,TitratingAcid]],ObjectP[Object[Sample]]];
	titratingBaseSampleOjbects=Cases[DeleteDuplicates[Lookup[expandedSafeOps,TitratingBase]],ObjectP[Object[Sample]]];
	sampleObjectsToDownload={mySamplesWithPreparedSamples,fixedAdditionSampleObjects,titratingAcidSampleObjects,titratingBaseSampleOjbects}//Flatten//DeleteDuplicates;

	fixedAdditionSampleModels=Cases[DeleteDuplicates[Flatten[Lookup[expandedSafeOps,FixedAdditions]]],ObjectP[Types[Model[Sample]]]];
	titratingAcidSampleModels=Cases[DeleteDuplicates[Lookup[expandedSafeOps,TitratingAcid]],ObjectP[Types[Model[Sample]]]];
	titratingBaseSampleModels=Cases[DeleteDuplicates[Lookup[expandedSafeOps,TitratingBase]],ObjectP[Types[Model[Sample]]]];
	modelOut=Lookup[expandedSafeOps,ModelOut];
	(*titrats,fixedadditions, calibration buffers*)

	sampleModelsToDownload=Cases[{fixedAdditionSampleModels,titratingAcidSampleModels,titratingBaseSampleModels,modelOut,Model[Sample, "id:BYDOjvGjGxGr"],Model[Sample, "id:vXl9j57j7OVd"],Model[Sample, "id:n0k9mG8m8dMn"],Model[Sample, StockSolution, "id:jLq9jXY4k6ww"],Model[Sample, StockSolution, "id:BYDOjv1VA86X"],Model[Sample,"Milli-Q water"]}//Flatten//DeleteDuplicates,ObjectP[Model[Sample]]];

	(* Get the mix instruments in the lab that are not deprecated. *)
	possibleInstruments = Flatten[Search[
		{
			Model[Instrument, Vortex],
			Model[Instrument, Shaker],
			Model[Instrument, BottleRoller],
			Model[Instrument, Roller],
			Model[Instrument, OverheadStirrer],
			Model[Instrument, Sonicator],
			Model[Instrument, HeatBlock],
			Model[Instrument, Homogenizer],
			Model[Instrument, pHMeter],
			Model[Instrument, pHTitrator]
		},
		Deprecated == (False | Null) && DeveloperObject != True
	]];
	possiblepHInstrumentModels=Cases[possibleInstruments,ObjectP[{Model[Instrument,pHMeter]}]];
	possibleMixingInstrumentModels=Cases[possibleInstruments,Except[ObjectP[{Model[Instrument,pHMeter]}]]];

	(*check if the user supplied a instrument that's not in our list (e.g. a developer object)*)
	{pHInstrumentLookup,probeLookup,mixingpHInstrumentLookup}=Lookup[expandedSafeOps,{pHMeter,Probe,pHMixInstrument}];

	(* Get any objects that were specified in the instrument list. If models were specified, they will be in the possible instrument list*)
	specifiedpHInstrumentObjects=Cases[DeleteDuplicates[pHInstrumentLookup],ObjectP[Object[Instrument,pHMeter]]];
	specifiedMixInstrumentObjects=Cases[DeleteDuplicates[mixingpHInstrumentLookup],ObjectP[Object[Instrument]]];

	specifiedProbeObjects=Cases[DeleteDuplicates[probeLookup],ObjectP[Object[Part,pHProbe]]];
	specifiedProbeModels=Cases[DeleteDuplicates[probeLookup],ObjectP[Model[Part,pHProbe]]];

	specifiedHistoricalData=Cases[Lookup[expandedSafeOps,HistoricalData]//DeleteDuplicates,ObjectP[Object[Data,pHAdjustment]]];


	(* Get all the potential preferred containers*)
	potentialBeakers=Search[Model[Container,Vessel],InternalDiameter>3Centimeter&&Aperture > 3 Centimeter&&Sterile==False&&StringContainsQ[Name,"beaker",IgnoreCase->True]&&Deprecated!=True&&DeveloperObject != True];
	potentialContainers=Join[PreferredContainer[All],potentialBeakers];

	(*obtain other needed look ups*)
	aliquotContainerLookup=Lookup[expandedSafeOps,AliquotContainer];

	(*if it's a compatible type, then add to the download*)
	potentialContainersWAliquot=Cases[Union[potentialContainers,{aliquotContainerLookup}],ObjectP[Model[Container]]];

	specifiedAliquotContainerObjects=Cases[aliquotContainerLookup//DeleteDuplicates,ObjectP[Object[Container]]];

	objectSamplePacketFields=Packet@@Union[{pH,IncompatibleMaterials,RequestedResources},SamplePreparationCacheFields[Object[Sample]]];
	modelSamplePacketFields=Packet@@Union[{pH,TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State,IncompatibleMaterials,NominalpH,MinpH,MaxpH,pHingAcid,pHingBase,MaxNumberOfpHingCycles,MaxpHingAdditionVolume,MaxAcidAmountPerCycle,MaxBaseAmountPerCycle,TotalVolume},SamplePreparationCacheFields[Model[Sample]]];
	modelContainerFields=DeleteDuplicates[Join[SamplePreparationCacheFields[Model[Container]],{Immobile,CoverFootprints,AluminumFoil,Ampoule,BuiltInCover, CoverTypes,Counterweights,EngineDefault,Hermetic,Opaque, Parafilm,RequestedResources,Reusable,RNaseFree,Squeezable, StorageBuffer,StorageBufferVolume,TareWeight,Name, VolumeCalibrations, MaxVolume, Aperture, InternalDiameter, Dimensions, Sterile, Deprecated, Footprint, OpenContainer,InternalDepth,InternalDimensions,Positions,RentByDefault, MaxOverheadMixRate}]];

	(* Download our information. *)
	allDownloadValues = Quiet[Download[
		{
			(*1*)sampleObjectsToDownload,
			(*2*)sampleModelsToDownload,
			(*3*)possiblepHInstrumentModels,
			(*4*)specifiedpHInstrumentObjects,
			(*3-1*)possibleMixingInstrumentModels,
			(*4-1*)specifiedMixInstrumentObjects,
			(*5*)specifiedProbeObjects,
			(*6*)specifiedProbeModels,
			(*7*)potentialContainersWAliquot,
			(*8*)specifiedAliquotContainerObjects,
			(*9*)specifiedHistoricalData
		},
		{
			(*1.sampleObjectsToDownload*)
			{
				objectSamplePacketFields,
				Packet[Model[Evaluate[Union[{pH,TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State,NominalpH,MinpH,MaxpH,IncompatibleMaterials},Evaluate[SamplePreparationCacheFields[Model[Sample]]]]]]],
				Packet[Container[Evaluate[SamplePreparationCacheFields[Object[Container]]]]],
				Packet[Container[Model][modelContainerFields]],
				Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,CalibrationFunction,EmptyDistanceDistribution,DateCreated}]],
				Packet[Composition[[All,2]][MolecularWeight]]
			},
			(*2.sampleModelsToDownload*)
			{
				modelSamplePacketFields
			},
			(*3:possiblepHInstrumentModels*)
			{
				Packet[Name,Object,Objects,TemperatureCorrection,WettedMaterials,Dimensions,ProbeLengths,ProbeDiameters,MinpHs,MaxpHs,MinDepths,MinSampleVolumes,ProbeTypes,AssociatedAccessories, TemperatureCorrection, AcquisitionTimeControl,MaxForce,MinForce],
				(*get all of the pH probe information*)
				Packet[AssociatedAccessories[[All, 1]][{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]
			},
			(*4:specifiedpHInstrumentObjects*)
			{
				Packet[Name,Model]
			},
			(*3-1:possibleMixingInstrumentModels*)
			{
				Packet[Name, Objects, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, Model, MinTemperature, MaxTemperature,
					RollerSpacing, CompatibleImpellers, InternalDimensions, CompatibleSonicationHorns, ProgrammableTemperatureControl,
					ProgrammableMixControl, MaxOscillationAngle, MinOscillationAngle, GripperDiameter, CompatibleAdapters, MaxStirBarRotationRate,
					MinStirBarRotationRate, MaxForce, MinForce, IntegratedLiquidHandlers, MinDispenseVolume, StirBarControl, MaxWeight, CompatibleRacks, CompatibleAdapters, CompatibleSonicationAdapters],
				Packet[CompatibleImpellers[{Name,StirrerLength,MaxDiameter,ImpellerDiameter}]]
			},
			(*4-1:specifiedMixInstrumentObjects*)
			{
				Packet[Name,Model]
			},
			(*5.specifiedProbeObjects*)
			{
				Packet[Name,Model],
				Packet[Model[{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]
			},
			(*6.specifiedProbeModels*)
			{
				Packet[Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments]
			},
			(*7.potentialContainersWAliquot*)
			{
				Evaluate[Packet @@ modelContainerFields],
				Packet[VolumeCalibrations[{LiquidLevelDetectorModel,CalibrationFunction,DateCreated,EmptyDistanceDistribution}]]
			},
			(*8.specifiedAliquotContainerObjects*)
			{
				Packet[Name,Model],
				Packet[Model[modelContainerFields]],
				Packet[Model[VolumeCalibrations[{LiquidLevelDetectorModel,CalibrationFunction,DateCreated,EmptyDistanceDistribution}]]]
			},
			(*9.specifiedHistoricalData*)
			{
				Packet[FixedAdditions, pHLog, SamplesIn, Overshot, SampleModel, SampleVolume],
				Packet[pHLog[[All,2]][State]],(*Object*)
				Packet[pHLog[[All,1]][State]](*Model*)
			}
		},
		Cache->Lookup[expandedSafeOps,Cache,{}],
		Simulation->updatedSimulation,
		Date->Now
		(*some containers don't have a link to VolumeCalibrations. Need to silence those.*)
	], {Download::FieldDoesntExist,Download::NotLinkField}];


	cacheBall=FlattenCachePackets[{
		allDownloadValues
	}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentAdjustpHOptions[ToList[mySamplesWithPreparedSamples],ToList[expandedNominalpHs],ToList[expandedSafeOps],Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}=Append[{resolveExperimentAdjustpHOptions[ToList[mySamplesWithPreparedSamples],ToList[expandedNominalpHs],ToList[expandedSafeOps],Cache->cacheBall,Simulation->updatedSimulation]},{}],
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentAdjustpH,
		resolvedOptions,
		Ignore->myOptionsWithPreparedSamples,
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentAdjustpH,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>, Verbose->False, OutputFormat->SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentAdjustpH, collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];



	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[returnEarlyQ,
		{$Failed, {}},
		If[gatherTests,
			adjustpHResourcePackets[ToList[mySamplesWithPreparedSamples],ToList[expandedNominalpHs],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
			{adjustpHResourcePackets[ToList[mySamplesWithPreparedSamples],ToList[expandedNominalpHs],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
		]
	];



	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, updatedSimulation} = If[performSimulationQ,
		simulateExperimentAdjustpH[resourcePackets,ToList[mySamplesWithPreparedSamples],resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],
		{Null, updatedSimulation}
	];


	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentAdjustpH,collapsedResolvedOptions],
			Preview->Null,
			Simulation->updatedSimulation
		}]
	];


	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
		$Failed,


		(*TODO: in template but not relevant yet*)
		(*
		(* Were we asked to simulate the procedure? *)
		MatchQ[Lookup[safeOps, SimulateProcedure, Null], True],
		AdjustpHSimulationPackets[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Cache->cacheBall,
			Simulation->simulation
		],
		*)
		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[resolvedOptions,Upload],
			Confirm->Lookup[resolvedOptions,Confirm],
			CanaryBranch->Lookup[resolvedOptions,CanaryBranch],
			ParentProtocol->Lookup[resolvedOptions,ParentProtocol],
			Priority->Lookup[resolvedOptions,Priority],
			StartDate->Lookup[resolvedOptions,StartDate],
			HoldOrder->Lookup[resolvedOptions,HoldOrder],
			QueuePosition->Lookup[resolvedOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,AdjustpH],
			Cache->cacheBall,
			Simulation->updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentAdjustpH,collapsedResolvedOptions],
		Preview->Null
	}
];


(* ::Subsubsection::Closed:: *)
(*Experiment function overload that takes container as input-- we don't accept plate.*)
(* Note: The container overload should come after the sample overload. *)
ExperimentAdjustpH[myContainers:ListableP[ObjectP[{Object[Container,Vessel],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],nominalpHs:ListableP[pHP],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,objectsExistQs,objectsExistTests,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests,listedContainers},

	(* Make sure we're working with a list of options *)
	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentAdjustpH,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentAdjustpH,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentAdjustpH,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];



	(* If we were given an empty container, return early. *)
	If[MemberQ[ToList[containerToSampleResult],$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentAdjustpH[samples,nominalpHs,ReplaceRule[sampleOptions,Simulation->updatedSimulation]]
	]
];


(* ::Subsection:: *)
(* resolveAdjustpHMethod *)

DefineOptions[resolveAdjustpHMethod,
	SharedOptions:>{
		ExperimentAdjustpH,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: mySamples can be Automatic when the user has not yet specified a value for autofill. *)
resolveAdjustpHMethod[
	mySamples:ListableP[Automatic|(ObjectP[{Object[Sample], Object[Container]}])],
	myNominalpHs : ListableP[pHP],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, result, tests},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveAdjustpHMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[safeOptions, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* for AdjustpH, result is always ManualSamplePreparation and there are no tests *)
	result = Manual;
	tests = {};

	outputSpecification /. {Result -> result, Tests -> tests}
];


DefineOptions[
	resolveExperimentAdjustpHOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentAdjustpHOptions[mySamples:{ObjectP[Object[Sample]]...},nominalpHs:{pHP..},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentAdjustpHOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,cache,samplePrepOptions,adjustpHOptions,simulatedSamplesMain,resolvedSamplePrepOptionsMain,updatedSimulationMain,samplePrepTests,simulatedSamplePackets,simulatedSampleContainers,samplePackets,specifiedHistoricalData,specifiedFixedAdditions, specifiedTitratingAcid,specifiedTitratingBase,specifiedAliquotContainers,dataFields,sampleFields,downloadData,aliquotContainerPackets, pHProbes,overheadStirrers,fixedAdditionSamples,fixedAdditionsConflicts,fixedAdditionsConflictSamples,fixedAdditionsConflictOptions, fixedAdditionsConflictTest,specifiedTitrate,noAdditions,noAdditionSamples,noAdditionOptions,noAdditionsTest,badTitrations,badTitrationSamples,invalidTitrateOptions,specifiedMixWhileTitrating, specifiedpHMixType,validMixWhiles,invalidMixSamples,overheadMixingRequiredOptions,overheadMixingRequiredTest,specifiedMaxAdditionVolumes,validMaxVolumes,invalidMaxVolumeSamples,badMaxVolumeOptions, maxVolumeTest,specifiedMinpHs,specifiedMaxpHs,resolvedMinpHs,resolvedMaxpHs,resolvedMaxAdditionVolumes,preresolvedProbe,resolvedAliquots, resolvedAliquotContainers,resolvedOutputContainers,resolvedpHOptions,resolvedMixOptions,allOptions,allTests,probePackets,simulatedSampleContainerModelPackets,resolvedAliquotOptions, aliquotTests,optionsWithResolvedAliquots,resolvedPostProcessingOptions,experimentMeasurepHPassedOptions,replacedMeasurepHOptions,experimentMixPassedOptions,replacedMixOptions, resolvedHistoricalData,resolvedFixedAdditions,replacedpHNamesOptions,replacedMixNamesOptions,resolvedProbe,resolvedProbeType, specifiedNumberOfReplicates,fixedAdditionModels,fixedAdditionModelsNullReplaced,additionModelLookup,numberOfReplicatesNullToOne,specifiedAliquotAmount,candidateBeakerPackets, candidateBeakers,calculatedAliquotAmounts,aliquotAmountRequired,preferredBeaker,minpHProbeDiamter,clearances,possibleImpellers,replicateAliquotRequired,measurepHTests,mixTests,aliquoteReplicateConflictQ,aliquoteReplicateConflictTest,invalidTitrateComboTest,resolverSafeOps, specifiedAliquot,specifiedConsolidateAliquote,resolverResolvedOptions,otherExperimentOptions,searchQs,noHistoricalDataQs,searchConditionsStringent,searchConditionsLoose,searchConditionsStringentDeNulled, searchConditionsLooseDeNulled,searchConditions,numberOfSearches,searchResults,searchResolvedHistoricalData,searchPositions,searchReplaceRules,noHistoricalDataPositions, noHistoricalDataRules,combinedReplaceRules,searchResultsPackets,pastLogsWithResolvedNullModelReplaced,fullCache,fullCacheWithSearchResults,historicalDataSamplesInVolume,protocolSamplesInVolume,sampleVolumeConvertingFactors, calculatedAliquotContainerVolume,mixAliquotRequiredWithResolvedMix,aliquotRequiredWithConsiderations,aliquotTargetContainers,specifiedpHMixUntilDissolved, specifiedpHMixInstrument,specifiedpHMixTime,specifiedMaxpHMixTime,specifiedpHMixDutyCycle,specifiedpHMixRate,specifiedNumberOfpHMixes,specifiedMaxNumberOfpHMixes,specifiedpHMixVolume,specifiedpHMixTemperature, specifiedMaxpHMixTemperature,specifiedSonicationAmplitude,specifiedMixOptionsTransposed,preResolvedpHMixType,preResolvedpHMixUntilDissolved,preResolvedpHMixInstrument,preResolvedpHMixTime,preResolvedMaxpHMixTime, preResolvedpHMixDutyCycle,preResolvedpHMixRate,preResolvedNumberOfpHMixes,preResolvedMaxNumberOfpHMixes,preResolvedpHMixVolume,preResolvedpHMixTemperature,preResolvedMaxpHMixTemperature,preResolvedSonicationAmplitude, preResolvedMixOptions,updatedSimulatedSamplesMain,updatedresolvedSamplePrepOptionsMain,updatedSamplePrepTests,resolvedFixedAdditionSampleStates,resolvedFixedAdditionSamples,mixingInstrumentModels,impellers,preResolvedMixOptionsMaxTempNull,preResolvedMixOptionsMaxTempTimeNull,aliquotContainerCondensed,simulatedSampleContainerPackets, specifiedKeepInstruments,invalidOptions,sampleContainers,sampleContainerModels,calculatedFixedAdditions,sampleVolumes,pHRangeConflictingTests, pHRangeConflictingSamples,aliquoteReplicateConflictOptions,pHRangeConflictingOptions,resolvedTitratingAcids,resolvedTitratingBases,specifiedAsssayVolume,specifiedDestinationWell,specifiedAliquotContainer, specifiedAliquotSampleStorageCondition,specifiedTargetConcentration,aliquotAmountRequiredDeList,specifiedContainerOut,historicalDataOvershotQs,resolvedTitratingAcidsInModel, resolvedTitratingBasesInModel,simulatedSampleModels,simulatedSampleModelPackets,specifiedModelsOut,modelMinpHs,modelMaxpHs,modelNominalpHs,resolvedModelOut,titrantsModelToObjectReplacementRulesAll, titrantsModelToObjectReplacementRulesSearched,searchResolvedHistoricalDataObjectified,numberSimulatedSamples,expandedMixOptions,expandedMeasurepHOptions,simulatedSampleModelPacketsToAssoc, maxAdditionVolumeAliquotRequired,simulation,secondUpdatedSimulationMain,updatedCacheWithSecondSamplePrepSimulation,skipSecondPrepQ,specifiedSimulation, specifiedPreparatoryPrimitives,prePreResolvedMixType,AliquotRequiredWithVolumetricFlasks,aliquotQ,resolvedAliquotAmountWithNumberOfReplicates,updatedSimulatedSamplePackets, updatedSimulatedSampleContainers,updatesSimulatedSampleVolumes,maxBeakerVolume,specifiedMaxAcidAmountPerCycle,specifiedMaxBaseAmountPerCycle,resolvedTitratingAcidsStates,resolvedTitratingBasesStates, simulatedSampleVolumes,resolvedMaxAcidAmountPerCycle,resolvedMaxBaseAmountPerCycle,modelsOutpHingAcid,modelsOutpHingBase,modelsOutMaxNumberOfpHingCycles,modelsOutMaxAdditionVolume,modelsOutMaxAcidAmountPerCycle, modelsOutMaxBaseAmountPerCycle,modelsOutTotalVolume,resolvedMaxNumberOfCycles,modelsOutPackets,fetchModelOutValue,specifiedMaxNumberOfCycles,modelsOutMaxpHs,modelsOutMinpHs,acidStatusAmountConformQs, acidStatusAmountConflictingSamples,acidAmountTest,baseStatusAmountConformQs,baseStatusAmountConflictingSamples,baseAmountTest,titratingBaseAmountConflictingOptions,titratingAcidAmountConflictingOptions, samplesWithContainerTooSmall,containerTooSmallTest,samplePacketsForMaxAdditionVolumes,sampleContainerModelPacketsForMaxAdditionVolumes,resolvedMaxAdditionVolumeAliquotErrorTuple,aliquotContainerTooSmallQs, sampleContainerModelPackets,searchConditionsFailedDeNulled,pHAchievedQs,containerTooSmallOptions,preResolveMixOptions,solidTitrantQs,spikedAmountsConverted, searchConditionsFailed,resolvedHistoricalDataPackets,resolvedHistoricalLogs,sampleContainerMaxVolumes,resolvedMaxAdditionVolumesWithNumberOfReplicates,totalPossibleVolumes, modelContainerFields,resolvedSampleLabel,resolvedSampleContainerLabel, searchConditionsStringentNoFixedAdditions, searchConditionsLooseNoFixedAdditions,searchConditionsFailedNoFixedAdditions, searchConditionsStringentNoFixedAdditionsDeNulled, searchConditionsLooseNoFixedAdditionsDeNulled,searchConditionsFailedNoFixedAdditionsDeNulled,searchResultsStringentFixedAdditions, searchResultsStringentNoFixedAdditions,searchResultsLooseFixedAdditions,searchResultsLooseNoFixedAdditions, searchResultsFailedFixedAdditions,searchResultsFailedNoFixedAdditions, resolvedTitrationMethod, preresolvedpHMeter, preresolvedpHAliquot, specifiedTitrationMethod, specifiedTitrationInstrument, specifiedpHMeterModel, specifiedProbeType, specifiedProbeModel, specifiedpHAliquot, specifiedpHMeter, rawpHMeterModel, specifiedProbe, rawProbeModel, specifiedpHAliquotVolume, titrationMethodConflictingSamples, titrationMethodConflictQs, titrationMethodConflictingOptions,specifiedRecoupSample, titrationMethodTest, resolvedTitrationInstrument, possibleTitratorCaps,sampleContainerCalibrationFunctions, sampleContainerVolumeCalibrationPackets, sampleContainerVolumeCalibrations, titrationContainerModels,titrationContainerModelPackets, roboticTitrationCaps, roboticTitrationCapPackets, roboticTitrationContainer, roboticTitrationContainerCap, roboticTitrationProbe, preresolvedProbeRobotic, preresolvedCapRobotic, roboticTitrationAliquotCaps, 	titrationInstrumentTest,titrationInstrumentConflictingOptions, titrationInstrumentConflictingSamples, titrationInstrumentCompatibleQs, possiblepHTitrators, rawpHTitratorsAssociate, pHTitratorspHMeters, pHTitratorsMixInstruments, validSampleContainerVolumeCalibrationPackets, updatedMaxBaseAmountPerCycle, updatedMaxAcidAmountPerCycle, updatedMaxNumberOfCycles,specifiedSite, resolvedSite, specifiedAssayVolume, specifiedTargetConcentrationAnalyte, preResolvedAnalyte, potentialAnalytesToUse, sampleCompositionPackets, potentialAnalytePackets, resolvedAssayVolumeAliquotQ, resolvedAssayVolume, workingSampleVolumes, maxSafeMixRates, safeMixRateMismatches, safeMixRateMismatchOptions, safeMixRateMismatchInputs, safeMixRateInvalidOptions, safeMixRateTest, maxSafeMixRatesMissingInvalidInputs, maxSafeMixRatesMissingTest, invalidInputs
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];


	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	resolverSafeOps=SafeOptions[ExperimentAdjustpH,myOptions];

	(* Fetch our cache from the parent function. *)
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(* Separate out our adjustpH options from our Sample Prep options. *)
	{samplePrepOptions,adjustpHOptions}=splitPrepOptions[resolverSafeOps];

	(* Resolve our sample prep options *)
	{{simulatedSamplesMain,resolvedSamplePrepOptionsMain,updatedSimulationMain},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentAdjustpH,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentAdjustpH,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];


	(* -- Download -- *)
	(*Get specified option values to avoid headaches later on*)

	{
		specifiedHistoricalData,specifiedFixedAdditions,specifiedTitratingAcid,specifiedTitratingBase,specifiedAliquotContainers,
		specifiedAliquotAmount,specifiedNumberOfReplicates,specifiedAliquot,specifiedConsolidateAliquote,specifiedMixWhileTitrating,
		specifiedpHMixType,specifiedpHMixUntilDissolved,specifiedpHMixInstrument,specifiedpHMixTime,
		specifiedMaxpHMixTime,specifiedpHMixDutyCycle,specifiedpHMixRate,specifiedNumberOfpHMixes,specifiedMaxNumberOfpHMixes,
		specifiedpHMixVolume,specifiedpHMixTemperature,specifiedMaxpHMixTemperature,specifiedSonicationAmplitude,specifiedMinpHs,
		specifiedMaxpHs,specifiedTitrate,specifiedMaxAdditionVolumes,specifiedKeepInstruments,specifiedAsssayVolume,specifiedDestinationWell,
		specifiedAliquotContainer,specifiedAliquotSampleStorageCondition,specifiedTargetConcentration,specifiedAssayVolume, specifiedTargetConcentrationAnalyte, specifiedContainerOut,specifiedSimulation,specifiedPreparatoryPrimitives,
		specifiedMaxAcidAmountPerCycle,specifiedMaxBaseAmountPerCycle,specifiedModelsOut,specifiedMaxNumberOfCycles, specifiedTitrationMethod, specifiedTitrationInstrument, specifiedpHMeter, specifiedProbe, specifiedProbeType, specifiedpHAliquot, specifiedpHAliquotVolume, specifiedRecoupSample, specifiedSite
	}=Lookup[
		resolverSafeOps,
		{
			HistoricalData,FixedAdditions,TitratingAcid,TitratingBase,AliquotContainer,AliquotAmount,NumberOfReplicates,
			Aliquot,ConsilidateAliquote,MixWhileTitrating,pHMixType,pHMixUntilDissolved, pHMixInstrument, pHMixTime,
			MaxpHMixTime, pHMixDutyCycle, pHMixRate,NumberOfpHMixes, MaxNumberOfpHMixes,pHMixVolume, pHMixTemperature,
			MaxpHMixTemperature, pHHomogenizingAmplitude,MinpH,MaxpH,Titrate,MaxAdditionVolume,KeepInstruments,AssayVolume,
			DestinationWell,AliquotContainer,AliquotSampleStorageCondition,TargetConcentration,AssayVolume,TargetConcentrationAnalyte, ContainerOut,Simulation,PreparatoryUnitOperations,
			MaxAcidAmountPerCycle,MaxBaseAmountPerCycle,ModelOut,MaxNumberOfCycles, TitrationMethod, TitrationInstrument, pHMeter, Probe, ProbeType, pHAliquot, pHAliquotVolume, RecoupSample, Site
		}
	];
	(*Replace Null to 1 for NumberOfReplicates*)
	numberOfReplicatesNullToOne=specifiedNumberOfReplicates/.Null->1;


	dataFields={
		Packet[pHLog, SamplesIn, Overshot, SampleModel, SampleVolume, pHAchieved]
	};
	sampleFields=Packet@@Union[{pH,IncompatibleMaterials,RequestedResources},SamplePreparationCacheFields[Object[Sample]]];
	modelContainerFields=DeleteDuplicates[Join[SamplePreparationCacheFields[Model[Container]],{Immobile,CoverFootprints,AluminumFoil,Ampoule,BuiltInCover, CoverTypes,Counterweights,EngineDefault,Hermetic,Opaque, Parafilm,RequestedResources,Reusable,RNaseFree,Squeezable, StorageBuffer,StorageBufferVolume,TareWeight,Name, VolumeCalibrations, MaxVolume, Aperture, InternalDiameter, Dimensions, Sterile, Deprecated, Footprint, OpenContainer,InternalDepth,InternalDimensions,Positions,RentByDefault,SelfStanding, MaxOverheadMixRate}]];
	{pHProbes,overheadStirrers,candidateBeakers}=Search[
		{
			Model[Part,pHProbe],
			Model[Instrument, OverheadStirrer],
			Model[Container, Vessel]
		},
		{
			Deprecated!=True && DeveloperObject != True,
			Deprecated!=True && DeveloperObject != True,
			InternalDiameter>3Centimeter&&Sterile==False&&StringContainsQ[Name,"beaker",IgnoreCase->True]&&Deprecated!=True && DeveloperObject != True
		}
	];

	possiblepHTitrators = Search[Object[Instrument, pHTitrator], Status != Retired];

	(*get the fixed addition information to download*)
	fixedAdditionSamples=Cases[Flatten[specifiedFixedAdditions,1],{UnitsP[],ObjectP[]}][[All,2]];

	downloadData = Quiet[
		Download[
			{
				(*1*)simulatedSamplesMain,
				(*2*)Cases[Join[specifiedTitratingAcid, specifiedTitratingBase], ObjectP[]],
				(*3*)fixedAdditionSamples,
				(*4*)Cases[specifiedHistoricalData, ObjectP[]],
				(*5*)Join[Cases[specifiedAliquotContainers, ObjectP[]], PreferredContainer[All]],
				(*6*)pHProbes,
				(*7*)candidateBeakers,
				(*8*)specifiedModelsOut /. Automatic -> Null,
				(*9*)specifiedpHMeter /. Automatic -> Null,
				(*10*)specifiedProbe /. Automatic -> Null,
				(*11*)possiblepHTitrators
			},
			{
				(*1*)
				{
					sampleFields,
					Packet[Model[Evaluate[Union[{pH, TransportTemperature, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, SolidUnitWeight, State, NominalpH, MinpH, MaxpH, IncompatibleMaterials}, Evaluate[SamplePreparationCacheFields[Model[Sample]]]]]]],
					Packet[Container[Evaluate[SamplePreparationCacheFields[Object[Container]]]]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel, CalibrationFunction, DateCreated}]]
				},
				(*2*){Object},
				(*3*){Model[Object]},
				(*4*)dataFields,
				(*5*){Evaluate[Packet @@ modelContainerFields]},
				(*6*){Packet[ShaftLength, ShaftDiameter, ProbeType]},
				(*7*){Packet[MaxVolume, Aperture, InternalDiameter, MaxOverheadMixRate]},
				(*8*){Packet[MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle, TotalVolume]},
				(*9*){Model[Object]},
				(*10*){Model[Object]},
				(*11*){
								Packet[MixInstrument, pHMeter],
								Packet[Model[MinDispenseVolume]]
							}
			},
			Cache -> cache,
			Simulation -> updatedSimulationMain
		],
		{Download::FieldDoesntExist}
	];

	(* == Raw variables dump for usage in multiple places == *)
	(*samplePackets=downloadData[[1,All,1]];*)
	simulatedSampleContainerModelPackets=downloadData[[1,All,4]];

	(* We only downloaded objects above so now we have to restore index matching *)
	(* Take the user specified value, find the positions we would have downloaded and update them with download values leaving Automatics/Nulls *)
	fixedAdditionModels=downloadData[[3,All,1]];

	(* If Model is Null, use the Object instead *)
	fixedAdditionModelsNullReplaced=MapThread[If[MatchQ[#1,ObjectP[Model[Sample]]],#1,#2]&,{fixedAdditionModels,fixedAdditionSamples}];

	additionModelLookup=AssociationThread[fixedAdditionSamples,fixedAdditionModelsNullReplaced];

	aliquotContainerPackets=Flatten[downloadData[[5]]];
	probePackets=downloadData[[6,All,1]];
	candidateBeakerPackets=Flatten[downloadData[[7]]];

	(* Get ModelOut information on pHing *)
	modelsOutPackets=Flatten[downloadData[[8]]];

	(* Get pHMeter Model *)
	rawpHMeterModel = Flatten[downloadData[[9]]];
	specifiedpHMeterModel =MapThread[If[MatchQ[#1, ObjectP[Model[Instrument, pHMeter]]], #1, #2]&,{rawpHMeterModel, specifiedpHMeter}];

	(* Get Probe Model *)
	rawProbeModel = Flatten[downloadData[[10]]];
	specifiedProbeModel = MapThread[If[MatchQ[#1, ObjectP[Model[Part, pHProbe]]], #1, #2]&,{rawProbeModel, specifiedProbe}];

	(* Get pHMeter and MixInstrument for pHTitrator *)
	rawpHTitratorsAssociate = Flatten[downloadData[[11]]];

	(* Get all caps for robotic titration *)
	{roboticTitrationCaps, roboticTitrationCapPackets} = capCandidatesInRoboticTitration["Memoization"];
	{titrationContainerModels, titrationContainerModelPackets} = containerCandidatesInRoboticTitration["Memoization"];

	(* Helper function to safely get fields out of modelsOutPackets which are index-matched to specifiedModelsOut*)
	fetchModelOutValue[model_,field_]:=If[MatchQ[model,ObjectP[Model[Sample]]],
		Lookup[fetchPacketFromCache[model,modelsOutPackets],field,Null],
		Null
	];
	modelsOutMinpHs=fetchModelOutValue[#,MinpH]&/@specifiedModelsOut;
	modelsOutMaxpHs=fetchModelOutValue[#,MaxpH]&/@specifiedModelsOut;
	modelsOutpHingAcid=fetchModelOutValue[#,pHingAcid]&/@specifiedModelsOut;
	modelsOutpHingBase=fetchModelOutValue[#,pHingBase]&/@specifiedModelsOut;
	modelsOutMaxNumberOfpHingCycles=fetchModelOutValue[#,MaxNumberOfpHingCycles]&/@specifiedModelsOut;
	modelsOutMaxAdditionVolume=fetchModelOutValue[#,MaxpHingAdditionVolume]&/@specifiedModelsOut;
	modelsOutMaxAcidAmountPerCycle=fetchModelOutValue[#,MaxAcidAmountPerCycle]&/@specifiedModelsOut;
	modelsOutMaxBaseAmountPerCycle=fetchModelOutValue[#,MaxBaseAmountPerCycle]&/@specifiedModelsOut;
	modelsOutTotalVolume=fetchModelOutValue[#,TotalVolume]&/@specifiedModelsOut;


	(*Update cache to include simulated data*)
	fullCache=FlattenCachePackets[{cache,downloadData}];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamplesMain, using our updatedSimulationMain *)
	(* Quiet[Download[...],Download::FieldDoesntExist]. An alternative method to Download from Cache - fetchPacketFromCache function - in shared Experiment Framework - to get information from cache *)
	(* Fetch simulated samples *)
	simulatedSamplePackets=Experiment`Private`fetchPacketFromCache[#,fullCache]&/@simulatedSamplesMain;
	simulatedSampleVolumes=simulatedSamplePackets[Volume];

	(* Get information about the containers of the simulated samples *)
	simulatedSampleContainers=Lookup[simulatedSamplePackets,Container];
	simulatedSampleContainerPackets=Experiment`Private`fetchPacketFromCache[#,fullCache]&/@simulatedSampleContainers;

	(* Extract downloaded mySamples packets and container models *)
	(* Important to note that when Aliquot is explicitely specified, simulatedSamples will be already in the aliquot containers. *)
	samplePackets=Experiment`Private`fetchPacketFromCache[#,fullCache]&/@mySamples;
	sampleVolumes=Lookup[samplePackets,Volume];
	sampleContainers=Lookup[samplePackets,Container][Object];
	sampleContainerModels=Experiment`Private`fetchPacketFromCache[#,fullCache][Model][Object]&/@sampleContainers;
	sampleContainerModelPackets=Experiment`Private`fetchPacketFromCache[#,fullCache]&/@sampleContainerModels;
	sampleContainerMaxVolumes=Lookup[sampleContainerModelPackets,MaxVolume];

	sampleContainerVolumeCalibrations = Lookup[sampleContainerModelPackets, VolumeCalibrations];
	validSampleContainerVolumeCalibrationPackets = Map[
		Function[{eachSampleContainerCalibrations},
			Module[{eachSampleContainerCalibrationPackets},
				eachSampleContainerCalibrationPackets = Experiment`Private`fetchPacketFromCache[#,
					Flatten[downloadData[[1]]]] & /@ eachSampleContainerCalibrations;
				Select[eachSampleContainerCalibrationPackets,
					And[
						! NullQ[Lookup[#, LiquidLevelDetectorModel]],
						! TrueQ[Lookup[#, Anomalous]],
						! TrueQ[Lookup[#, Deprecated]],
						! TrueQ[Lookup[#, DeveloperObject]]]&]
			]
		],
		sampleContainerVolumeCalibrations
	];
	(*If there are multiple calibration functions, pick the first*)
	sampleContainerVolumeCalibrationPackets = If[Length[#]>0,
		Last[#],
		<||>
	]& /@ validSampleContainerVolumeCalibrationPackets;
	sampleContainerCalibrationFunctions = Lookup[sampleContainerVolumeCalibrationPackets, CalibrationFunction, Null];

	(*-- INPUT VALIDATION CHECKS --*)
	(* NOTE: we are leaving it to MeasurepH to check Invalid samples*)

	(*-------- Validate Options -------------*)


	(* -- FixedAdditions are set or Titrate->True -- *)


	noAdditions=MapThread[
		MatchQ[#1,{}|None]&&MatchQ[#2,False]&,
		{specifiedFixedAdditions,specifiedTitrate}
	];

	noAdditionSamples=PickList[mySamples,noAdditions,True];

	If[!MatchQ[noAdditionSamples,{}]&&!gatherTests,
		Message[Error::NoAdditions,ObjectToString[noAdditionSamples,Cache->fullCache]]
	];

	noAdditionOptions=If[!MatchQ[noAdditionSamples,{}],
		{FixedAdditions, Titrate}
	];

	noAdditionsTest=If[gatherTests,Test["FixedAdditions are supplied or Titrate is set set to True for all samples:",noAdditionSamples,{}],Nothing];

	(*-- Titrate, TitratingAcid, TitratingBase combo is valid -- *)

	(* If we aren't titrating then acid and base can't be specified *)
	(* If we are titrating, then acid and base must be specified *)
	badTitrations=MapThread[
		Or[
			!#1&&MemberQ[{#2,#3,#4,#5,#6},Except[Automatic|Null]],
			#1&&MemberQ[{#2,#3,#4,#5,#6},Null]
		]&,
		{specifiedTitrate,specifiedTitratingBase,specifiedTitratingAcid,specifiedMaxNumberOfCycles,specifiedMaxAcidAmountPerCycle,specifiedMaxBaseAmountPerCycle}
	];

	badTitrationSamples=PickList[mySamples,badTitrations,True];

	If[!MatchQ[badTitrationSamples,{}]&&!gatherTests,
		Message[Error::InvalidTitrateCombo,ObjectToString[badTitrationSamples,Cache->fullCache]]
	];

	invalidTitrateOptions=If[!MatchQ[badTitrationSamples,{}],
		{TitratingAcid,TitratingBase,Titrate,MaxNumberOfCycles,MaxAcidAmountPerCycle,MaxBaseAmountPerCycle},
		{}
	];

	invalidTitrateComboTest=If[gatherTests,Test["For all sample if Titrate is True, TitratingAcid and TitratingBase are MaxNumberOfCycles, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle set and if Titrate isFalse, TitratingAcid, TitratingBase, MaxNumberOfCycles, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle are not set:",badTitrationSamples,{}],Nothing];

	(*--  MixWhileTitrating==True &&pHMixType==Overhead -- *)

	(* See if we can find an impeller that will fit in current container and give us enough clearances between it and pH meter - arbitrarily set to 3 cm, double usual. We need these variables later in the function *)
	(*TODO: DeleteCases--this is not a perfect solution for cases where pH probe is not meant for adjustpH (HPLC probes for example)*)
	minpHProbeDiamter = Min[DeleteCases[Lookup[probePackets, ShaftDiameter],Except[_Quantity]]];
	clearances=If[#,minpHProbeDiamter+3 Centimeter,minpHProbeDiamter+1.5 Centimeter]&/@specifiedMixWhileTitrating;

	possibleImpellers=MapThread[
		If[(NullQ[#3])||(LessQ[FirstCase[{#3/Lookup[#1, MaxVolume, Null], 0.39}, NumericP], 0.4]),
			(* if the sample volume is less than 40% of the max volume, return Null to trigger aliquot for impeller *)
			Null,
			(* check if there is compatible impeller based on container size *)
			compatibleImpeller[Lookup[#1, Object],First[overheadStirrers],Clearance->#2,Cache->fullCache]
		]&,
		{simulatedSampleContainerModelPackets,clearances, sampleVolumes}
	];
	(* Aliquot is required if NumberOfReplicates is larger than 1 *)
	replicateAliquotRequired=numberOfReplicatesNullToOne>1;


	(* We can only mix as titrant is being added if doing overhead mixing *)
	validMixWhiles=MapThread[
		If[#1,
			MatchQ[#2,Stir],
			True
		]&,
		{specifiedMixWhileTitrating,specifiedpHMixType}
	];

	invalidMixSamples=PickList[mySamples,validMixWhiles,False];

	If[!MatchQ[invalidMixSamples,{}]&&!gatherTests,
		Message[Error::OverheadMixingRequired,ObjectToString[invalidMixSamples,Cache->fullCache]]
	];

	overheadMixingRequiredOptions=If[!MatchQ[invalidMixSamples,{}],
		{MixWhileTitrating,pHMixType}
	];

	overheadMixingRequiredTest=If[gatherTests,Test["If MixWhileTitrating is on pHMixType is set to Stir:",invalidMixSamples,{}],Nothing];


	(*-- MaxAdditionVolume is less than or equal to volume needed to fill container --*)


	validMaxVolumes=MapThread[
		Function[{max,samplePacket,containerModelPacket},
			If[VolumeQ[max],
				max<=Lookup[containerModelPacket,MaxVolume]-Lookup[samplePacket,Volume],
				True
			]
		],
		{specifiedMaxAdditionVolumes,simulatedSamplePackets,simulatedSampleContainerModelPackets} (*These are all simulated samples*)
	];

	invalidMaxVolumeSamples=PickList[mySamples,validMaxVolumes,False];

	If[!MatchQ[invalidMaxVolumeSamples,{}]&&!gatherTests,
		Message[Error::MaxVolumeExceeded,invalidMaxVolumeSamples]
	];

	badMaxVolumeOptions=If[!MatchQ[invalidMaxVolumeSamples,{}],
		{MaxAdditionVolume}
	];

	maxVolumeTest=If[gatherTests,Test["The MaxAdditionVolume is less than or equal to volume needed to fill container for all the samples:",invalidMaxVolumeSamples,{}],Nothing];

	(*-- NumberOfReplicate cannot be Unull when Aliquot->True and ConsolidateAliquots->False --*)
	aliquoteReplicateConflictQ=MatchQ[
		{specifiedNumberOfReplicates,specifiedAliquot,specifiedConsolidateAliquote},
		{GreaterP[1],{True|Automatic..},False|Automatic}|{Null,_,False|Automatic}
	];

	If[aliquoteReplicateConflictQ&&!gatherTests,
		Message[Error::NumberOfReplicatesConflictsWithAliquotOptions]
	];

	aliquoteReplicateConflictOptions=If[aliquoteReplicateConflictQ,{Aliquot,ConsolidateAliquots,NumberOfReplicates}];

	aliquoteReplicateConflictTest=If[gatherTests,Test["NumberOfReplicates must only be greater than 1 when Aliquot->True and ConsolidateAliquots->False.",aliquoteReplicateConflictQ,False],Nothing];

	(* --MinpH<NominalpH<MaxpH -- *)
	(*we want an error only if the Min>Nominal, Max<Nominal, or Min=Max or any combination of these *)
	pHRangeConflictingSamples=MapThread[
		If[
			Or[
				MatchQ[#1/.(Automatic->0), GreaterP[#2]],
				MatchQ[#3/.(Automatic->14), LessP[#2]],
				MatchQ[(#1/.Automatic->0), (#3/.Automatic->14)]
			],
			#4,
			Nothing
		]&,
		{specifiedMinpHs,nominalpHs,specifiedMaxpHs,mySamples}
	];


	If[!MatchQ[pHRangeConflictingSamples,{}]&&!gatherTests,
		Message[Error::ConflictingpHRange,pHRangeConflictingSamples]
	];

	pHRangeConflictingOptions=If[!MatchQ[pHRangeConflictingSamples,{}],{MinpH,MaxpH},{}];

	pHRangeConflictingTests=If[gatherTests,
		Test["NominalpH must be larger than MinpH, and smaller than MaxpH",
			MatchQ[pHRangeConflictingSamples,{}],
			True
		],
		{}
	];



	(* -- Titrant state and measurement should not conflict -- *)
	acidStatusAmountConformQs=MapThread[
		Which[
			(*If TitratingAcid is not specified, then all is good*)
			MatchQ[#1,Automatic],
			True,
			(*If TitratingAcid is specified as Null, then Amount must be Null too*)
			MatchQ[#1,Null],
			MatchQ[#2,Automatic|Null],
			(*Otherwise, if TitratingAcid is solid and amount is volume, then error out*)
			True,
			Module[{state},
				state=Lookup[fetchPacketFromCache[#1,fullCache],State,Null];
				!MatchQ[{state,#2},{Solid,VolumeP|Null}|{Liquid,Null}]
			]]&,
		{specifiedTitratingAcid,specifiedMaxAcidAmountPerCycle}
	];

	acidStatusAmountConflictingSamples=PickList[mySamples,acidStatusAmountConformQs,False];

	titratingAcidAmountConflictingOptions=If[!(And@@acidStatusAmountConformQs),{TitratingAcid,MaxAcidAmountPerCycle},{}];

	If[!(And@@acidStatusAmountConformQs)&&!gatherTests,
		Message[Error::ConflictingTitratingAcidAndAmount,acidStatusAmountConflictingSamples]
	];

	acidAmountTest=If[gatherTests,
		Test["Specified TitratingAcid and MaxAcidAmountPerCycle should not conflict",
			And@@acidStatusAmountConformQs,
			True
		],
		{}
	];

	baseStatusAmountConformQs=MapThread[
		Which[
			MatchQ[#1,Automatic],
			True,

			MatchQ[#1,Null],
			MatchQ[#2,Automatic|Null],

			True,
			Module[{state},
				state=Lookup[fetchPacketFromCache[#1,fullCache],State,Null];
				!MatchQ[{state,#2},{Solid,VolumeP|Null}|{Liquid,Null}]
			]]&,
		{specifiedTitratingBase,specifiedMaxBaseAmountPerCycle}
	];

	baseStatusAmountConflictingSamples=PickList[mySamples,baseStatusAmountConformQs,False];

	titratingBaseAmountConflictingOptions=If[!(And@@baseStatusAmountConformQs),{TitratingBase,MaxBaseAmountPerCycle},{}];


	If[!(And@@baseStatusAmountConformQs)&&!gatherTests,
		Message[Error::ConflictingTitratingBaseAndAmount,baseStatusAmountConflictingSamples]
	];

	baseAmountTest=If[gatherTests,
		Test["Specified TitratingBase and MaxBaseAmountPerCycle should not conflict",
			And@@baseStatusAmountConformQs,
			True
		],
		{}
	];

	(*  == Resolve Automatic options ==  *)
	(* -- Resolve Titrants -- *)
	{resolvedTitratingAcids,resolvedTitratingBases}=MapThread[
		Module[{resolvedAcid,resolvedBase},
			If[#1,
				resolvedAcid=Which[
					MatchQ[{#2,#4},{Automatic,ObjectP[]}],#4,
					MatchQ[#2,Automatic],Model[Sample, StockSolution, "id:jLq9jXY4k6ww"],(*Model[Sample, StockSolution, "2 M HCl"]*)
					True,#2
				];
				resolvedBase=Which[
					MatchQ[{#3,#5},{Automatic,ObjectP[]}],#5,
					MatchQ[#3,Automatic],Model[Sample,StockSolution,"id:BYDOjv1VA86X"],(*Model[Sample, StockSolution, "1.85 M NaOH"]*)
					True,#3
				];

				{resolvedAcid,resolvedBase},

				(*ELSE*)
				{
					#2/.Automatic->Null,
					#3/.Automatic->Null
				}
			]
		]&,
		{
			(*1*)specifiedTitrate,
			(*2*)specifiedTitratingAcid,
			(*3*)specifiedTitratingBase,
			(*4*)modelsOutpHingAcid,
			(*5*)modelsOutpHingBase
		}
	]//Transpose;

	(*Need their states later on in multiple places*)
	resolvedTitratingAcidsStates=fetchPacketFromCache[#,fullCache][State]&/@resolvedTitratingAcids;
	resolvedTitratingBasesStates=fetchPacketFromCache[#,fullCache][State]&/@resolvedTitratingBases;

	(* -- Resolve pH Limits -- *)

	(* Arbitrarily try to get with 0.1 of the desired pH*)
	resolvedMinpHs=MapThread[
		Which[
			MatchQ[#2,pHP],#2,
			MatchQ[#3,pHP],#3,
			True,#1-0.1
		]&,
		{nominalpHs,specifiedMinpHs,modelsOutMinpHs}
	];

	resolvedMaxpHs=MapThread[
		Which[
			MatchQ[#2,pHP],#2,
			MatchQ[#3,pHP],#3,
			True,#1+0.1
		]&,
		{nominalpHs,specifiedMaxpHs,modelsOutMaxpHs}
	];




	(* --- Resolve ModelOut: this must happen before resolving HistoricalData --- *)
	simulatedSampleModels=simulatedSamplePackets[Model];
	simulatedSampleModelPackets=fetchPacketFromCache[#,fullCache]&/@simulatedSampleModels;
	simulatedSampleModelPacketsToAssoc=If[AssociationQ[#],#,<||>]&/@simulatedSampleModelPackets;

	modelMinpHs=Lookup[simulatedSampleModelPacketsToAssoc,MinpH,Null];
	modelMaxpHs=Lookup[simulatedSampleModelPacketsToAssoc,MaxpH,Null];
	modelNominalpHs=Lookup[simulatedSampleModelPacketsToAssoc,NominalpH,Null];



	(*
	If ModelOut is specified, take it.
	Elif SimulatedSample Model is stocksolution, then:
		If MinpH is specified in the SimulatedSample's Model, it must be smaller or equal to MinpH in option;
		If MaxpH is specified in the SimulatedSample's Model, it must be larger or equal to MaxpH in option;
		If NominalpH is specified in the SimulatedSample's Model, our target pH must be within +-0.2 of this specified NominalpH;
		When all three satisfies, take this  SimulatedSample's Model
	ELSE: resolve to Null
	*)
	resolvedModelOut=MapThread[
		Which[
			(*A*)
			MatchQ[#1,Except[Automatic]],
			#1,
			(*B*)
			MatchQ[#2,ObjectP[Model[Sample,StockSolution]]],
			Module[{minInRangeQ,maxInRangeQ,nomInRangeQ},
				minInRangeQ=If[MatchQ[#3,pHP],#3<=#4,True];
				maxInRangeQ=If[MatchQ[#5,pHP],#5>=#6,True];
				nomInRangeQ=If[MatchQ[#7,pHP],MatchQ[#7,RangeP[#8-0.02,#8+0.02]],True];
				If[minInRangeQ&&maxInRangeQ&&nomInRangeQ, #2, Null]
			],
			(*C*)
			True,
			Null

		]&,
		{
			(*1*)specifiedModelsOut,
			(*2*)simulatedSampleModels,
			(*3*)modelMinpHs,
			(*4*)resolvedMinpHs,
			(*5*)modelMaxpHs,
			(*6*)resolvedMaxpHs,
			(*7*)modelNominalpHs,
			(*8*)nominalpHs
		}
	];




	(* -- Resolve HistoricalData -- *)

	(* Use data for an aliquot of the sample whose pH is being adjusted.
	If no such data exists data for a sample with the same model will be used. Data which didn't overshoot will be used
	first. If no such data exists the data for an event which got closest to the pH before overshooting will be used and only the titrant added before the overshoot event will be added in this protocol.*)

	(*	Use data for an aliquot of the sample whose pH is being adjusted.
		If no such data exists data for a sample with the same model or composition will be used. Data which didn't overshoot will be used
		first. If no such data exists the data for an event which got closest to the pH before overshooting will be used and only the titrant added before the overshoot event will be added in this protocol.
	*)
	resolvedTitratingAcidsInModel=If[MatchQ[#,ObjectP[Object[Sample]]],fetchPacketFromCache[#,fullCache][Model],#]&/@resolvedTitratingAcids;
	resolvedTitratingBasesInModel=If[MatchQ[#,ObjectP[Object[Sample]]],fetchPacketFromCache[#,fullCache][Model],#]&/@resolvedTitratingBases;


	{searchQs,noHistoricalDataQs,searchConditionsStringent,searchConditionsLoose,searchConditionsFailed,searchConditionsStringentNoFixedAdditions,
		searchConditionsLooseNoFixedAdditions,searchConditionsFailedNoFixedAdditions}=Transpose[MapThread[
		Module[{searchQ,noHistoricalDataQ,baseConditions,condition0,condition1,condition2,condition3,condition4,condition5},
			(*We search when HistoricalData is Automatic, when there ModelOut is known and when we're inside a stock solution *)
			(* Stock Solution restriction is pretty cautious but we want to make sure we're comparing apples to apples with this data *)
			searchQ=MatchQ[{#2,#7,Lookup[myOptions,ParentProtocol]},{Automatic,ObjectP[],ObjectP[Object[Protocol,StockSolution]]}];

			(* Resolve HistoricalData to Null: *)
			(* We don't need historical data when FixedAddition is specified. *)
			(* We cannot find a historical data properly if model is Null. *)
			(* When we're not inside a stock solution we don't want to use historical data *)
			noHistoricalDataQ=MatchQ[
				{#2,#3,#7,Lookup[myOptions,ParentProtocol]},
				{Automatic,Except[Automatic],_,_}|{Automatic,Automatic,Null}|{_,_,_,Except[ObjectP[Object[Protocol,StockSolution]]]}
			];

			(*We want to get data that is actually comparable - sample model, same requested pH, uses our TitratingAcid and Titrating base (for titration and used in fixed additions) *)
			(* Additionally we've decided to do this only when we're pHing within a stock solution - if a sample has been adjusted a bunch of times it's not really the same as the first pH adjustment *)
			(* Note - we are doing a seemingly silly thing with the FixedAdditions in order to split up the Searches and make them take less time *)
			baseConditions=And[
				SampleModel==#7,
				NominalpH==#4,
				TitratingAcidModel==#5,
				TitratingBaseModel==#6,
				Protocol[ParentProtocol][Type] == Object[Protocol,StockSolution]
			];

			(*We preferably pick the data objects that has no overshot. *)
			condition0=If[searchQ,
				And[baseConditions,pH>=#8,pH<=#9,pHAchieved==True,Overshot!=True,Field[FixedAdditions[[2]]]==({#5}|{#6})],
				Null
			];

			(* Overshoot just in case *)
			condition1=If[searchQ,
				And[baseConditions,pH>=#8,pH<=#9,pHAchieved==True,Overshot==True,Field[FixedAdditions[[2]]]==({#5}|{#6})],
				Null
			];

			(* Case where we didn't reach the pH*)
			condition2=If[searchQ,
				And[baseConditions,pHAchieved!=True,Field[FixedAdditions[[2]]]==({#5}|{#6})],
				Null
			];

			(* Now we do the above conditions again, but this time with FixedAdditions==Null *)
			(*We preferably pick the data objects that has no overshot. *)
			condition3=If[searchQ,
				And[baseConditions,pH>=#8,pH<=#9,pHAchieved==True,Overshot!=True,FixedAdditions==Null],
				Null
			];

			(* Overshoot just in case *)
			condition4=If[searchQ,
				And[baseConditions,pH>=#8,pH<=#9,pHAchieved==True,Overshot==True,FixedAdditions==Null],
				Null
			];

			(* Case where we didn't reach the pH*)
			condition5=If[searchQ,
				And[baseConditions,pHAchieved!=True,FixedAdditions==Null],
				Null
			];

			{searchQ,noHistoricalDataQ,condition0,condition1,condition2,condition3,condition4,condition5}
		]&,
		{
			(*1*)simulatedSamplePackets,
			(*2*)specifiedHistoricalData,
			(*3*)specifiedFixedAdditions,
			(*4*)nominalpHs,
			(*5*)resolvedTitratingAcidsInModel,
			(*6*)resolvedTitratingBasesInModel,
			(*7*)resolvedModelOut,
			(*8*)resolvedMinpHs,
			(*9*)resolvedMaxpHs
		}
	]];

	(*Get rid of Nulls representing samples that do not require searching*)
	searchConditionsStringentDeNulled=DeleteCases[searchConditionsStringent,Null];
	searchConditionsStringentNoFixedAdditionsDeNulled=DeleteCases[searchConditionsStringentNoFixedAdditions,Null];
	searchConditionsLooseDeNulled=DeleteCases[searchConditionsLoose,Null];
	searchConditionsLooseNoFixedAdditionsDeNulled=DeleteCases[searchConditionsLooseNoFixedAdditions,Null];
	searchConditionsFailedDeNulled=DeleteCases[searchConditionsFailed,Null];
	searchConditionsFailedNoFixedAdditionsDeNulled=DeleteCases[searchConditionsFailedNoFixedAdditions,Null];
	searchConditions=Join[
		searchConditionsStringentDeNulled,searchConditionsStringentNoFixedAdditionsDeNulled,searchConditionsLooseDeNulled,
		searchConditionsLooseNoFixedAdditionsDeNulled,searchConditionsFailedDeNulled,searchConditionsFailedNoFixedAdditionsDeNulled
	];

	(*Number of samples that requires searching times 6*)
	numberOfSearches=Length[searchConditions];

	(*Do the search*)
	searchResults=If[
		numberOfSearches===0,
		{},
		Search[ConstantArray[Object[Data,pHAdjustment],numberOfSearches],Evaluate[searchConditions],MaxResults->1]
	];

	(* Split the search results by the searches that generated them *)
	{
		searchResultsStringentFixedAdditions,searchResultsStringentNoFixedAdditions,searchResultsLooseFixedAdditions,searchResultsLooseNoFixedAdditions,
		searchResultsFailedFixedAdditions,searchResultsFailedNoFixedAdditions
	}=If[MatchQ[searchResults,{}],{{},{},{},{},{},{}},Partition[searchResults,numberOfSearches/6]];

	(*Go through each sample's search results. combine the results into {StringentResult1,LooseResults1} and take the safe first one.*)
	searchResolvedHistoricalData=MapThread[
		FirstOrDefault[Join[#1,#2,#3,#4],Null]&,
		{searchResultsStringentFixedAdditions,searchResultsStringentNoFixedAdditions,searchResultsLooseFixedAdditions,searchResultsLooseNoFixedAdditions,
			searchResultsFailedFixedAdditions,searchResultsFailedNoFixedAdditions}];

	(*If TitratingAcid and TitratingBases were specified as Objects we want to revert the resolved models back to objects. This is Particularly important for StockSolution as it picks the acid and bases upfront.*)
	(*All Model->specified Object/Model replacement rule indexed to each sample*)
	titrantsModelToObjectReplacementRulesAll={
		MapThread[#1->#2&,{resolvedTitratingAcidsInModel,resolvedTitratingAcids}],
		MapThread[#1->#2&,{resolvedTitratingBasesInModel,resolvedTitratingBases}]
	}//Transpose;
	(*Only take positions of samples that needed searching*)
	titrantsModelToObjectReplacementRulesSearched=PickList[titrantsModelToObjectReplacementRulesAll,searchQs,True];
	searchResolvedHistoricalDataObjectified=MapThread[#1/.#2&,{searchResolvedHistoricalData,titrantsModelToObjectReplacementRulesSearched}];

	(*Find out sample positions which needed searching*)
	searchPositions=Position[searchQs,True]//Flatten;
	searchReplaceRules=MapThread[#1->#2&,{searchPositions,searchResolvedHistoricalDataObjectified}];

	(*Find out sample positions which should be resolved to Null*)
	noHistoricalDataPositions=Position[noHistoricalDataQs,True]//Flatten;
	noHistoricalDataRules=#->Null&/@noHistoricalDataPositions;

	combinedReplaceRules=Join[searchReplaceRules,noHistoricalDataRules];

	(*Replace Automatics to resolved data*)
	resolvedHistoricalData=ReplacePart[specifiedHistoricalData,combinedReplaceRules];

	(*Download packets for each searchResolvedHistoricalData object*)
	searchResultsPackets=Download[
		Cases[searchResolvedHistoricalData,ObjectP[]]//DeleteDuplicates,
		dataFields,
		Date->Now
	];

	(* Update cache asap *)
	fullCacheWithSearchResults=FlattenCachePackets[{fullCache,searchResultsPackets}];

	(* Get historical data packets. if HistoricalData is Null, then packet is Null *)
	resolvedHistoricalDataPackets=Experiment`Private`fetchPacketFromCache[#,fullCacheWithSearchResults]&/@resolvedHistoricalData;
	(* Get pHLog from packets *)
	resolvedHistoricalLogs=If[NullQ[#],Null,Lookup[#,pHLog]]&/@resolvedHistoricalDataPackets;
	(* TODO: Should check if specified historical data's Nominal pH MinpH MaxpH agrees with our new sample's *)

	(*When model is Null, replace the Null with the Object[Sample]*)
	pastLogsWithResolvedNullModelReplaced=Map[
		Function[{oneLog},
			If[
				MatchQ[oneLog,{NullP,ObjectP[],_,_,_}],
				Map[ReplacePart[#,1->#[[2]]]&,oneLog],
				oneLog
			]
		],
		resolvedHistoricalLogs,{2}];




	(* ---- Resolve fixed additions: use specified FixedAdditions, else use resolved HistoricalData, else resolve to None ---- *)
	(*Samples in HistoricalData may not be of the same volume. We need to correct the volume by fetching the protocol SamplesIn volumes and the data SamplesIn volumes*)
	historicalDataSamplesInVolume=If[NullQ[#],Null,Lookup[#,SampleVolume]]&/@resolvedHistoricalDataPackets;
	(*Per number of replicates, the volume of samples needed*)
	protocolSamplesInVolume=fetchPacketFromCache[#,fullCacheWithSearchResults][Volume]/numberOfReplicatesNullToOne&/@simulatedSamplesMain;
	sampleVolumeConvertingFactors=MapThread[If[MatchQ[#1,Null],Null,#2/#1]&,{historicalDataSamplesInVolume,protocolSamplesInVolume}];

	(*We also want to know if historical data has overshot. if so we want to be more conservative next time around*)
	(*Similarly we want to find out if the historical data achieved its pH or not*)
	{historicalDataOvershotQs,pHAchievedQs}=Transpose[
		Map[
			If[MatchQ[#,ObjectP[Object[Data,pHAdjustment]]],Lookup[fetchPacketFromCache[#,fullCacheWithSearchResults],{Overshot,pHAchieved}],{Null,Null}]&,
			resolvedHistoricalData
		]
	]/.Null->False;



	(* While we are at it, we also want to figure out if historical data shows the solution is not well buffered and use it to help resolve MaxBlahAmountPerCycle and MaxNumberOfCycles *)
	{calculatedFixedAdditions,spikedAmountsConverted}=Transpose[MapThread[
		Function[
			{eachHistoricalData,historicalDatapHLog,overshotQ,achievedQ,volumeConverter},

			(*If historical data is specified, deduct fixed additions from historical data*)
			(*pHLog in historical data is in such form {"Addition Model", "Addition Sample", "Amount", "pH", "pH Data"}.
			At this point, Models that are Null have been replace with Object[Sample]*)
			If[
				!MatchQ[eachHistoricalData,ObjectP[]],
				{None,Null},
				Module[{cleanLog,trimmedLog,sample,amount,volumeList,volumeSansOvershot,calculatedFD,spikedQ,spikedAmountConverted},

					(*When there's no fixed additions, the first one or few entries are {Null,Null,Null,_,_}, we don't want to pick that part of the log*)
					cleanLog=DeleteCases[historicalDatapHLog,{Null,Null,Null,_,_},1];

					(* There is also no fixed additions when pH just arrived at the correct range without adding acid/base last time *)
					trimmedLog=If[MatchQ[cleanLog,{}],
						Null,
						First[SplitBy[cleanLog, Download[First[#], Object] &]]
					];

					If[
						NullQ[trimmedLog],
						{None,Null},
						Module[{},
							(*Sample models are the same here. We just take the first one*)
							sample=trimmedLog[[1,1]];
							volumeList=trimmedLog[[All,3]];

							volumeSansOvershot=Switch[{overshotQ,achievedQ,Length[volumeList]},

								(* If no overshot, take all the entries *)
								{False,_,_},Total[volumeList],

								(* Elif overshot and multiple volume additions, take all the additions except for the last *)
								{True,_,GreaterP[1]},Total[volumeList[[;;-2]]],

								(* Elif overshot, pHing failed, and only one entry, take off 60% *)
								{True,False,EqualP[1]},Total[volumeList]*0.4,

								(* Elif overshot but only one entry, take off 30% from the total volume *)
								_,Total[volumeList]*0.7
							];

							(*Total the amount. Because samples are the same we don't need to worry about adding a mass to a volume*)
							amount=volumeSansOvershot*volumeConverter;
							calculatedFD={{amount,sample}};

							(*spiked: in the overshot addition, pH changed 1 or more*)
							(*NOTE: we are assuming here that the acid and base strengths are the same. If not, then lumping up acid and base is problematic.
							but as of now we don't have reliable way to figure out the H+/OH- molarity in the titrant so we'll just make our peace with this assumption.
							If there's only one entry in the log then we cant know if it spiked*)
							spikedQ=If[
								MatchQ[Length[trimmedLog[[All,4]]],GreaterP[1]],
								Abs[trimmedLog[[All,4]][[-1]]-trimmedLog[[All,4]][[-2]]]>1,
								False
							];

							(* This spiked addition amount is converted so that it is relative to our actual volume *)
							spikedAmountConverted=If[spikedQ,(trimmedLog[[All,3]][[-1]])*volumeConverter,Null];

							{calculatedFD,spikedAmountConverted}
						]
					]
				]
			]
		],
		{
			resolvedHistoricalData,
			pastLogsWithResolvedNullModelReplaced,
			historicalDataOvershotQs,
			pHAchievedQs,
			sampleVolumeConvertingFactors,
			nominalpHs (*we can use our NominalpH here because it has to be the same with our nominal ph*)
		}
	]];

	resolvedFixedAdditions=MapThread[If[MatchQ[#1,Automatic],#2,#1]&,{specifiedFixedAdditions,calculatedFixedAdditions}];

	(* -- Error check: If HistoricalData and FixedAdditions are both specified then they must agree -- *)
	fixedAdditionsConflicts=MapThread[
		Function[{calculatedFA,specifiedFA,specifiedHD},
			If[(*Only check conflict when both FixedAdditions and HistoricalData are specified*)
				MatchQ[{specifiedHD, specifiedFA},{Except[Automatic],Except[Automatic]}],
				If[(*IF both are specified as Null or None, then there's no conflict*)
					MatchQ[{specifiedHD,specifiedFA},{Null|None,Null|None}],
					False,
					Module[{calculatedFAToPatternSorted,specifiedFASorted,specifiedFAReshaped,calculatedFAReshaped},
						(*CalculatedFA won't be None so feel free to map*)
						calculatedFAReshaped=calculatedFA/.Alternatives[Automatic,None]->{{Null,Null}};
						calculatedFAToPatternSorted=SortBy[{
							Which[
								(* Liquid *)
								VolumeQ[#[[1]]],RangeP[#[[1]]-10Microliter,#[[1]]+10Microliter],
								(* Solid *)
								MassQ[#[[1]]],RangeP[#[[1]]-10Milligram,#[[1]]+10Milligram],
								(* Tablet *)
								True, #[[1]]
							],
							#[[2]][Object]
						}&/@calculatedFAReshaped,#[[2]]&];
						specifiedFAReshaped=specifiedFA/.Alternatives[Automatic,None]->{{Null,Null}};
						specifiedFASorted=SortBy[specifiedFAReshaped,#[[2]]&];

						!MatchQ[specifiedFASorted,calculatedFAToPatternSorted]&&!MatchQ[specifiedFA,Automatic]
					]
				],

				(*ELSE*)
				False
			]
		],
		{calculatedFixedAdditions,specifiedFixedAdditions,specifiedHistoricalData}
	];


	fixedAdditionsConflictSamples=PickList[mySamples,fixedAdditionsConflicts,True];

	If[Length[fixedAdditionsConflictSamples]>0&&!gatherTests,
		Message[Error::FixedAdditionsConflict,ObjectToString[fixedAdditionsConflictSamples,Cache->fullCache]]
	];

	fixedAdditionsConflictOptions=If[Length[fixedAdditionsConflictSamples]>0,
		{HistoricalData, FixedAdditions},
		{}
	];

	fixedAdditionsConflictTest=If[gatherTests,Test["If HistoricalData and FixedAdditions are specified the value from HistoricalData matches the fixed additions for all samples:",fixedAdditionsConflictSamples,{}],Nothing];


	(* --- Resolve MaxAcidAmountPerCycle & MaxBaseAmountPerCycle --- *)

	resolvedMaxAcidAmountPerCycle=MapThread[
		Which[
			(*If specified, take it*)
			MatchQ[#1,Except[Automatic]],#1,
			(*If Titration is specified to be False, resolve to Null*)
			!#6,Null,
			(*If model specified, scale to our volume*)
			MatchQ[{#4,#5},{Alternatives[VolumeP,MassP],VolumeP}],#4*(#3/#5),
			(*If historical data spiked, take the minimum between our arbituarily-detemined amount and half of the converted spiking volume*)
			MatchQ[#2,Liquid]&&VolumeQ[#7],Min[0.025*#3,#7/2],
			MatchQ[#2,Solid]&&MassQ[#7],Min[2Gram/Liter*#3,#7/2],
			(*Otherwise, if no historical spike is found,, just take this arbituarily-detemined amount*)
			MatchQ[#2,Liquid],0.025*#3,
			MatchQ[#2,Solid],2Gram/Liter*#3
		]&,
		{
			(*1*)specifiedMaxAcidAmountPerCycle,
			(*2*)resolvedTitratingAcidsStates,
			(*3*)simulatedSampleVolumes,
			(*4*)modelsOutMaxAcidAmountPerCycle,
			(*5*)modelsOutTotalVolume,
			(*6*)specifiedTitrate,
			(*7*)spikedAmountsConverted
		}
	];

	resolvedMaxBaseAmountPerCycle=MapThread[
		Which[
			(*If specified, take it*)
			MatchQ[#1,Except[Automatic]],#1,
			(*If Titration is specified to be False, resolve to Null*)
			!#6,Null,
			(*If model specified, scale to our volume*)
			MatchQ[{#4,#5},{Alternatives[VolumeP,MassP],VolumeP}],#4*(#3/#5),
			(*If historical data spiked, take the minimum between our arbituarily-detemined amount and half of the converted spiking volume*)
			MatchQ[#2,Liquid]&&VolumeQ[#7],Min[0.025*#3,#7/2],
			MatchQ[#2,Solid]&&MassQ[#7],Min[2Gram/Liter*#3,#7/2],
			(*Otherwise, if no historical spike is found,, just take this arbituarily-detemined amount*)
			MatchQ[#2,Liquid],0.025*#3,
			MatchQ[#2,Solid],2Gram/Liter*#3
		]&,
		{
			(*1*)specifiedMaxBaseAmountPerCycle,
			(*2*)resolvedTitratingBasesStates,
			(*3*)simulatedSampleVolumes,
			(*4*)modelsOutMaxBaseAmountPerCycle,
			(*5*)modelsOutTotalVolume,
			(*6*)specifiedTitrate,
			(*7*)spikedAmountsConverted
		}
	];


	(* -- Resolve MaxNumberOfpHingCycles -- *)
	(* -- Resolve Titrants -- *)
	resolvedMaxNumberOfCycles=MapThread[
		If[#1, (*with titration*)
			Which[
				MatchQ[{#2,#3},{Automatic,NumericP}],#3,
				(*if historical data spiked, titrate 20 times. otherwise titrate 10 times*)
				MatchQ[#2,Automatic]&&QuantityQ[#4],20,
				MatchQ[#2,Automatic]&&!QuantityQ[#4],10,
				True,#2
			],

			(*ELSE,no titration*)
			#2/.Automatic->Null
		]&,
		{
			(*1*)specifiedTitrate,
			(*2*)specifiedMaxNumberOfCycles,
			(*3*)modelsOutMaxNumberOfpHingCycles,
			(*4*)spikedAmountsConverted
		}
	];

	(* -- Resolve AssayVolume for Target concentration -- *)
	(* This section is doing a simplified assay volume resolution in the same as that in resolveExperimentAliquotOptions (line 2816 in  where resolvedAssayVolume is resolved), except that we only consider liquid state (we consider solid and count as well in aliquot) *)
	(* We do not include conflict checks and tests, just to figure out the assay volume if aliquot for target concentration is expected. Those checks and tests will be performed when we call aliquot resolver *)
	preResolvedAnalyte = MapThread[
		If[MatchQ[#1, Null|Automatic] && MatchQ[#2, Automatic],
			Null,
			#2]&,
		{specifiedTargetConcentration, specifiedTargetConcentrationAnalyte}];

	(*decide the potential analyte using selectAnalyteFromSample (this is defined in AbsorbanceSpectroscopy/Experiment.m)*)
	potentialAnalytesToUse = selectAnalyteFromSample[samplePackets, Analyte -> preResolvedAnalyte, Cache -> fullCache, DetectionMethod -> Absorbance, Output -> Result];
	(* pull out the sample composition identity model packets *)
	sampleCompositionPackets = Map[
		Function[{samplePacket},
			fetchPacketFromCache[#, fullCacheWithSearchResults]& /@ Lookup[samplePacket, Composition][[All, 2]]
		],
		samplePackets
	];
	(*get the packet for each of the potential analytes*)
	potentialAnalytePackets = Map[
		Function[{potentialAnalyte},
			SelectFirst[Flatten[sampleCompositionPackets], Not[NullQ[#]] && MatchQ[potentialAnalyte, ObjectReferenceP[Lookup[#, Object]]] &, Null]],
		potentialAnalytesToUse];

	(* Do a simplified aliquot resolution for assayVolume, just to get the correct volume. We do not need those tests/checks since they would be called again later in aliquot *)
	(* Unlike ExperimentAliquot, AdjustpH does not allow pooled samples, so we only need to mapthread once to figure out the assay volume *)
	{
		resolvedAssayVolumeAliquotQ,
		resolvedAssayVolume
	} = Transpose[MapThread[
		Function[{samplePacket, assayVolume, targetConc, potentialAnalytes},
			Module[
				{eitherConcP, targetConcentration, molecularWeight, sampleConc, sampleMassConc, sampleVolume, resolvedSampleConc, dilutionFactor, sampleComposition, roundedAssayVolume, assayVolumeAliquotQ, resolveAssayVolume},

				(* pull out the Composition of the sample packet *)
				sampleComposition = Lookup[samplePacket, Composition, {}];
				(* get the volume field from the sample directly *)
				sampleVolume = Lookup[samplePacket, Volume];
				(* just pull out MolecularWeight directly.  Note that this could be $Failed because the field doesn't exist for everything *)
				molecularWeight = If[NullQ[potentialAnalytes],
					Null,
					Lookup[potentialAnalytes, MolecularWeight, Null]
				];

				(* make a pattern that is just the combination of ConcentrationP and MassConcentrationP (since I'll be using it a lot below) *)
				eitherConcP = ConcentrationP|MassConcentrationP;
				(* get the TargetConcentration option; if it is Automatic, resolve to Null *)
				targetConcentration = targetConc/. {Automatic -> Null};
				(* pull out the concentration and mass concentration of the chosen component from the composition field *)
				sampleConc = If[MatchQ[potentialAnalytes, PacketP[]],
					FirstCase[sampleComposition, {conc:ConcentrationP, ObjectP[Lookup[potentialAnalytes, Object]], _?DateObjectQ | Null} :> conc, Null],
					Null
				];
				sampleMassConc = If[MatchQ[potentialAnalytes, PacketP[]],
					FirstCase[sampleComposition, {massConc:MassConcentrationP, ObjectP[Lookup[potentialAnalytes, Object]], _?DateObjectQ | Null} :> massConc, Null],
					Null
				];
				(* pick the real concentration we are going to use; should mirror the units of TargetConcentration *)
				resolvedSampleConc = Which[
					(* If we have the same units for our target and the composition, use that unit *)
					ConcentrationQ[targetConcentration]&&ConcentrationQ[sampleConc],sampleConc,
					MassConcentrationQ[targetConcentration]&&MassConcentrationQ[sampleMassConc], sampleMassConc,
					(* If we have concentration target and mass concentration composition, and the molecular weight is known, divide by the molecular weight *)
					ConcentrationQ[targetConcentration]&&MassConcentrationQ[sampleMassConc]&&MolecularWeightQ[molecularWeight],UnitConvert[sampleMassConc/molecularWeight,Molar],
					(* If we have mass concentration target and concentration composition, and the molecular weight is known, multiple by the molecular weight *)
					MassConcentrationQ[targetConcentration]&&ConcentrationQ[sampleConc]&&MolecularWeightQ[molecularWeight],UnitConvert[sampleConc*molecularWeight,Gram/Liter],
					(* Otherwise, return Null *)
					True, Null
				];

				(* get the dilution factor, which is the ratio of the sample's target concentration to the current concentration; if target conc is Null or noConcentrationError is True, then set it as 1 *)
				dilutionFactor = If[NullQ[resolvedSampleConc],
					1,
					(resolvedSampleConc / targetConcentration)
				];

				(* resolve the AssayVolume options *)
				{
					assayVolumeAliquotQ,
					resolveAssayVolume
				} = Switch[{assayVolume, targetConc},
					(*AssayVolume is given, we will call aliquot resolver to handle the dilution *)
					{VolumeP, _},
					{True, assayVolume},
					(* if we do not have a target concentration, no dilution is necessary *)
					{_, Null},
					{False, sampleVolume},
					(* if we have a specified target concentration and no Volume information specified, calculate based on dilution factor*)
					{_, eitherConcP},
					{True, sampleVolume * dilutionFactor},
					(* otherwise, we do not need to dilute*)
					{_, _},
					{False, sampleVolume}
				];
				roundedAssayVolume = If[NullQ[resolveAssayVolume],
					Null,
					Quiet[AchievableResolution[resolveAssayVolume],{Error::MinimumAmount,Warning::AmountRounded}]
				];
				{
					assayVolumeAliquotQ,
					roundedAssayVolume
				}
			]
		],
		{samplePackets, specifiedAssayVolume, specifiedTargetConcentration, potentialAnalytePackets}
	]];

	(* update the working sample volume to be the larger of assay volume and sample volume *)
	(* Theoretically, assay volume should be equal or larger than sample volume. If an assay volume is specified and it's smaller than sample volume, aliquot resolver will deal with that conflict *)
	workingSampleVolumes = MapThread[If[#1 > #2, #1, #2]&, {resolvedAssayVolume, sampleVolumes}];

	(* -- Resolve MaxAdditionVolume -- *)

	(* make sure we are in the right container:
	if NoR==1 we want our sample to be in the aliquot container if specified. So we use simulated packets ;
	if NoR>1 we want to be in the original container as we are concerned with whether the final volume is too large to pool samples back
	*)
	samplePacketsForMaxAdditionVolumes=If[numberOfReplicatesNullToOne>1,samplePackets,simulatedSamplePackets];
	sampleContainerModelPacketsForMaxAdditionVolumes=If[numberOfReplicatesNullToOne>1,sampleContainerModelPackets,simulatedSampleContainerModelPackets];

	(* If MaxAdditionVolume was not set, resolve it to the volume needed to fill the container *)
	(* In a typical laboratory setting, one should never change more than 5% of the total volume for pHing samples. This is in line with StockSolution's criteria.
	StockSolution requests 7.5% of the final volume of the StockSolution. We can then request 6.8% of the prepH value to leave a 10% margin.
	This, compared with resolving to the empty volume in the container, also prevents calling too much titration resources when sample only takes up a small portion of the container volume capacity. *)


	resolvedMaxAdditionVolumeAliquotErrorTuple=MapThread[
		Function[{
			(*1*)max,
			(*2*)samplePacket,
			(*3*)containerModelPacket,
			(*4*)modelMaxVol,
			(*5*)modelTotalVol,
			(*6*)aliquotContainer,
			(*7*)aliquot,
			(*8*)fixedAddition
		},
			Module[{emptyVolume,percent,modelPercent,resolvedMaxVolume,fixedAdditionVolume,calculatedMaxAdditionVolume,
				totalMaxVolume
			},
				(* prepare numbers *)
				emptyVolume=(Lookup[containerModelPacket,MaxVolume]-(Lookup[samplePacket,Volume]));
				percent=0.068*Lookup[samplePacket,Volume];
				modelPercent=If[MatchQ[{modelMaxVol,modelTotalVol},{VolumeP,VolumeP}],(modelMaxVol/modelTotalVol)*(Lookup[samplePacket,Volume]),Null];
				fixedAdditionVolume=If[MatchQ[fixedAddition,{{VolumeP,_}..}],Total[fixedAddition[[All,1]]],0Milliliter];

				(* resolve MaxAdditionVolume *)
				resolvedMaxVolume=If[MatchQ[max,Automatic],

					calculatedMaxAdditionVolume=Which[
						(*Take Model specified if possible*)
						VolumeQ[modelPercent],modelPercent,

						(*If empty space 0, then take the larger one between 6.8% and fixed addition (we will request aliquot later)*)
						(*TODO: we can change this to a percent of percent, but not sure how much it would affect StockSolution*)
						EqualQ[emptyVolume,0 Milliliter],Max[percent,fixedAdditionVolume],

						(*If empty space is not 0, take the smaller of the two, and larger between it and fixed addition*)
						(*If empty space is negative, set addition volume to upper limit of 20 Milliliter*)
						(* Avoid getting too large resource volume. Based on the history, we rarely need over 20 mL acid/base. Setting a hard limit here but we can always revisit this value later *)
						True,If[EqualQ[Max[Min[emptyVolume,percent],fixedAdditionVolume],0 Milliliter],20 Milliliter,
						Min[Max[Min[emptyVolume,percent],fixedAdditionVolume], 20 Milliliter]]
					];

					(*If NumberOfReplicates>1, this number should be further divided*)
					calculatedMaxAdditionVolume/numberOfReplicatesNullToOne,

					(*Else: just take the specified MaxAdditionVolume-- this volume is per NoR*)
					max
				];

				(* Calculated pooled max addition volume so we can see if the original container is enough to hold the volume pooled back if NoR>1 *)
				totalMaxVolume=resolvedMaxVolume*numberOfReplicatesNullToOne;

				Which[
					(* if user already specified aliquot container, in which case we should be in simulatedContainer already, but empty volume is still not enough for FixedAddition, we should throw an error. *)
					(* we also throw an error if Aliquot is False but volume is not enough *)
					emptyVolume<fixedAdditionVolume && Or[MatchQ[aliquotContainer,ObjectP[Object[Container]]],MatchQ[aliquot,False]],
					{emptyVolume,False,True},

					(* if empty volume is NOT smaller than fixed addition volume but smaller than our calculated max volume, and we don't have the freedom to further request aliquot, then take the empty volume *)
					emptyVolume<totalMaxVolume && Or[MatchQ[aliquotContainer,ObjectP[Object[Container]]],MatchQ[aliquot,False]],
					{emptyVolume,False,False},

					(* if aliquot container is automatic depending on whether the empty volume is enough for what we need we require aliquot or not*)
					emptyVolume<totalMaxVolume&&MatchQ[aliquotContainer,Automatic],
					{resolvedMaxVolume,True,False},


					(* if we have enough empty volume we are all good *)
					emptyVolume>=totalMaxVolume,
					{resolvedMaxVolume,False,False}
				]
			]
		],
		{
			(*1*)specifiedMaxAdditionVolumes,
			(*2*)samplePacketsForMaxAdditionVolumes,
			(*3*)sampleContainerModelPacketsForMaxAdditionVolumes,
			(*4*)modelsOutMaxAdditionVolume,
			(*5*)modelsOutTotalVolume,
			(*6*)specifiedAliquotContainer,
			(*7*)specifiedAliquot,
			(*8*)resolvedFixedAdditions
		}
	];

	{resolvedMaxAdditionVolumes,maxAdditionVolumeAliquotRequired,aliquotContainerTooSmallQs}=resolvedMaxAdditionVolumeAliquotErrorTuple//Transpose;

	(* -- Error check: container too small  -- *)

	samplesWithContainerTooSmall=PickList[mySamples,aliquotContainerTooSmallQs];

	If[Length[samplesWithContainerTooSmall]>0&&!gatherTests,
		Message[Error::AdjustpHContainerTooSmall,ObjectToString[samplesWithContainerTooSmall]]
	];

	containerTooSmallOptions=If[Length[samplesWithContainerTooSmall]>0,{FixedAdditions,MaxAdditionVolume,Aliquot,AliquotContainer},{}];

	containerTooSmallTest=If[gatherTests,
		Test["The specified aliquot container, or sample container if Aliquot->False, is too small to contain sample volume with MaxAdditionVolume.",Length[samplesWithContainerTooSmall],0],
		{}
	];

	(* If titrationMethod is Robotic, we have to use the pHMeter and MixInstrument that is assigned to the pH titrator *)
	pHTitratorspHMeters = Cases[Download[Lookup[rawpHTitratorsAssociate, pHMeter, Null], Object], ObjectP[]];
	pHTitratorsMixInstruments = Cases[Download[Lookup[rawpHTitratorsAssociate, MixInstrument, Null], Object], ObjectP[]];

	(* TitrationMethod conflict check *)
	titrationMethodConflictQs=MapThread[
		Which[
			(*If TitrationMethod is not resolved or is resolved to Manual, no conflicts*)
			MatchQ[#1,Except[Robotic]],
			True,
			(*If TitrationMethod is resolved Robotic but associated option is not compatible, give conflicts*)
			MatchQ[#1,Robotic]&&
					Or@@{
						MatchQ[#2,Except[Automatic|Stir]],
						MatchQ[#3,Except[Alternatives[Automatic, Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"], Sequence @@ pHTitratorspHMeters]]],
						MatchQ[#4,Surface],
						MatchQ[#5,Except[Automatic|Null|Model[Part, pHProbe, "id:jLq9jXvP7jLx"]|Model[Part, pHProbe, "id:J8AY5jDmW5BZ"]]], (*Model[Part, pHProbe, "InLab Reach Pro-225"]|Model[Part, pHProbe, "InLab Micro Pro-ISM"]*)
						MatchQ[#6,True],
						MatchQ[#7,False],
						MatchQ[#8,True],
						MatchQ[#9,Except[Alternatives[Automatic, Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"], Sequence @@ pHTitratorsMixInstruments]]],
						MatchQ[#10,Except[Automatic|Null]],
						MatchQ[#11,Except[Null]]&&MatchQ[Lookup[fetchPacketFromCache[#11,fullCache],State,Null],Solid],
						MatchQ[#12,Except[Null]]&&MatchQ[Lookup[fetchPacketFromCache[#12,fullCache],State,Null],Solid],
						MatchQ[#13,True],
						MatchQ[#14, Except[Automatic]]||MatchQ[#15, Except[Automatic]],
						MatchQ[#16,Null]
					},
			False,

			True,
			True
		]&,
		{
			(*1*)specifiedTitrationMethod,
			(*2*)specifiedpHMixType,
			(*3*)specifiedpHMeterModel,
			(*4*)specifiedProbeType,
			(*5*)specifiedProbeModel,
			(*6*)specifiedpHAliquot,
			(*7*)specifiedTitrate,
			(*8*)specifiedpHMixUntilDissolved,
			(*9*)specifiedpHMixInstrument,
			(*10*)specifiedpHAliquotVolume,
			(*11*)resolvedTitratingBases,
			(*12*)resolvedTitratingAcids,
			(*13*)specifiedRecoupSample,
			(*14*)specifiedAliquotContainer,
			(*15*)specifiedDestinationWell,
			(*16*)specifiedTitrationInstrument
		}
	];

	titrationMethodConflictingSamples=PickList[mySamples,titrationMethodConflictQs,False];

	titrationMethodConflictingOptions=If[!(And@@titrationMethodConflictQs),{TitrationMethod, pHMixType, pHMeter, ProbeType, Probe, pHAliquot, Titrate, pHMixUntilDissolved, pHMixInstrument, pHAliquotVolume, TitratingBase, TitratingAcid, RecoupSample},{}];


	If[!(And@@titrationMethodConflictQs)&&!gatherTests,
		Message[Error::ConflictingTitrationMethod,titrationMethodConflictingSamples]
	];

	titrationMethodTest=If[gatherTests,
		Test["Specified TitrationMethod and associated options should not conflict",
			And@@titrationMethodConflictQs,
			True
		],
		{}
	];

	(* -- Resolve TitrationMethod -- *)

	(* findpHTitrationCaps returns all the possible caps that can be used for the sample container in robotic titration*)
	possibleTitratorCaps = If[replicateAliquotRequired,
		(*If we will need to do Aliquot because numberOfReplicates >1, we won't be using the current sample container anyway, resolve to {} to trigger the consideration of preferredRoboticTitrationContainers *)
		{{}},
		(*Using findpHTitratorCaps to check if we can use the current sample container for robotic titration.*)
		MapThread[findpHTitratorCaps[#1, #2, #3, #4, #5] &, {simulatedSampleContainerModelPackets, sampleContainerCalibrationFunctions, specifiedProbeModel, workingSampleVolumes, resolvedMaxAdditionVolumes}]
	];

	(*In case we need to change the container, find out the minimum volume the target container must satisfy considering the replicates*)
	calculatedAliquotContainerVolume=MapThread[(#1/numberOfReplicatesNullToOne)+#2&,{workingSampleVolumes,resolvedMaxAdditionVolumes}];
	(*preferredRoboticTitrationContainers returns the smallest container that can be used to Aliquot the sample into for robotic titration as well as its corresponding cap and pH probe *)
	{roboticTitrationContainer, roboticTitrationContainerCap, roboticTitrationProbe} = Transpose[MapThread[preferredRoboticTitrationContainers[#1/.(Automatic|Null) -> #3, #2]&, {specifiedAliquotAmount, specifiedProbeModel, calculatedAliquotContainerVolume}]];

	(* Todo: need site for titration method determination before CMU pHTitrator set up*)
	resolvedSite = Which[
		(* Use the option if already provided *)
		!MatchQ[specifiedSite,Automatic],Download[specifiedSite,Object],
		True, $Site
	];
	resolvedTitrationMethod=MapThread[
		Which[
			(*If specified, take it*)
			MatchQ[#1,Except[Automatic]],#1,
			(*If site is Object[Container, Site, "ECL-CMU"], resolve to Manual*)
			MatchQ[resolvedSite,ObjectP[Object[Container, Site, "id:P5ZnEjZpRlK4"]]],Manual,
			(*If pHMixType is specified but is not Stir, resolve to Manual*)
			MatchQ[#2,Except[Automatic|Stir]],Manual,
			(*If Titrate is specified to False, resolve to Manual*)
			MatchQ[#3,False],Manual,
			(*If pHMeter is specified but its Model is not SevenExcellence or the connected pHMeter of pH Titrator, resolve to Manual*)
			MatchQ[#4,Except[Alternatives[Automatic, Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"], Sequence @@ pHTitratorspHMeters]]], Manual,
			(*If RecoupSample is specified to True, resolve to Manual*)
			MatchQ[#5,True],Manual,
			(*If pHAliquot is specified to True, resolve to Manual*)
			MatchQ[#6,True],Manual,
			(*If pHAliquotVolume is specified, resolve to Manual*)
			MatchQ[#7,Except[Automatic|Null]],Manual,
			(*If pHMixUntilDissolved is True, resolve to Manual*)
			MatchQ[#8,True],Manual,
			(*If pHMixInstrument is specified but it is not Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"] or the connected OverheadStirrer of pH Titrator, resolve to Manual*)
			MatchQ[#9,Except[Alternatives[Automatic, Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"], Sequence @@ pHTitratorsMixInstruments]]],Manual,
			(*If TitratingAcid is specified to Solid, resolve to Manual*)
			MatchQ[#10,Except[Null]]&&MatchQ[Lookup[fetchPacketFromCache[#10,fullCache],State,Null],Solid],Manual,
			(*If TitratingBase is specified to Solid, resolve to Manual*)
			MatchQ[#11,Except[Null]]&&MatchQ[Lookup[fetchPacketFromCache[#11,fullCache],State,Null],Solid],Manual,
			(*If AliquotContainer or DestinationWell is specified, resolve to Manual because we might need to aliquot to the desired containers for robotic titration. *)
			MatchQ[#15, Except[Automatic]]||MatchQ[#16, Except[Automatic]], Manual,
			(*If we could not find a compatible cap for sample container and (Aliquot is specified False or we could not find a container to aliquot into), resolve to Manual*)
			MatchQ[#12, {}]&&(MatchQ[#13, False]||NullQ[#14]), Manual,
			(*If TitrationInstrument is Null, resolve to Manual*)
			MatchQ[#17,Null],Manual,
			(*If ProbeType is specified to be Surface, resolve to Manual*)
			MatchQ[#18,Surface], Manual,
			(*If SonicationAmplitude is specified, resolve to Manual*)
			MatchQ[#19,PercentP], Manual,
			(*If MaxpHMixTemperature is specified, we cannot use Stir, so resolve to Manual*)
			MatchQ[#20,TemperatureP], Manual,
			(*Otherwise, resolve to Robotic*)
			True, Robotic
		]&,
		{
			(*1*)specifiedTitrationMethod,
			(*2*)specifiedpHMixType,
			(*3*)specifiedTitrate,
			(*4*)specifiedpHMeterModel,
			(*5*)specifiedRecoupSample,
			(*6*)specifiedpHAliquot,
			(*7*)specifiedpHAliquotVolume,
			(*8*)specifiedpHMixUntilDissolved,
			(*9*)specifiedpHMixInstrument,
			(*10*)resolvedTitratingAcids,
			(*11*)resolvedTitratingBases,
			(*12*)possibleTitratorCaps,
			(*13*)specifiedAliquot,
			(*14*)roboticTitrationContainer,
			(*15*)specifiedAliquotContainer,
			(*16*)specifiedDestinationWell,
			(*17*)specifiedTitrationInstrument,
			(*18*)specifiedProbeType,
			(*19*)specifiedSonicationAmplitude,
			(*20*)specifiedMaxpHMixTemperature
		}
	];

	(* Update MaxNumberOfCycles and MaxAcidAmountPerCycle/MaxBaseAmountPerCycle if titrationMethod is Robotic and these options were not specified*)
	(* Originally, MaxNumberOfCycles is default to 10, MaxAcidAmountPerCycle/MaxBaseAmountPerCycle is 2.5% of initial volume. *)
	(* After update, MaxNumberOfCycles is default to 50, MaxAcidAmountPerCycle/MaxBaseAmountPerCycle is 0.5% of initial volume. *)
	(* So the max addition volume in total is not changed--the resolved max volume after pH adjustment is the same -- aliquot resolution and container resolution unchanged *)
	{updatedMaxBaseAmountPerCycle, updatedMaxAcidAmountPerCycle, updatedMaxNumberOfCycles} = Transpose@MapThread[
		Which[
			(* If either of MaxNumberOfCycles/MaxAcidAmountPerCycle/MaxBaseAmountPerCycle is specified,	keep the original resolution *)
			MemberQ[{#5, #6, #7}, Except[Automatic]],
			{#1, #2, #3},
			(* If TitrationMethod is Robotic, decrease max acid/base addition per cycle by 5 times and increase the max number of cycles by 5 times *)
			MatchQ[#4, Robotic],
			Module[{minVolume},
				(* Extract the min amount that can be transferred when titration method is robotic*)
				minVolume = First@Cases[Lookup[rawpHTitratorsAssociate, MinDispenseVolume, 0.02 Milliliter], VolumeP];
				{Max[0.2*#1, minVolume], Max[0.2*#2, minVolume], #3 * 5}
			],
			(* Otherwise, do not change *)
			True,
			{#1, #2, #3}
		]&,
		{
			(*1*)resolvedMaxBaseAmountPerCycle,
			(*2*)resolvedMaxAcidAmountPerCycle,
			(*3*)resolvedMaxNumberOfCycles,
			(*4*)resolvedTitrationMethod,
			(*5*)specifiedMaxBaseAmountPerCycle,
			(*6*)specifiedMaxAcidAmountPerCycle,
			(*7*)specifiedMaxNumberOfCycles
		}
	];

	preresolvedCapRobotic = MapThread[
		Which[
			(* If TitrationMethod is Manual, resolve cap to Null*)
			MatchQ[#1, Manual],
			Null,
			(* If TitrationMethod is Robotic, and we can find compatible caps, resolve the first of the list of caps*)
			Length[#2]>0,
			First[#2],
			(* If TitrationMethod is Robotic but the sample container does not have compatible caps, resolve to the cap from preferredRoboticTitrationContainers*)
			True,
			#3
		]&,
		{
			(*1*)resolvedTitrationMethod,
			(*2*)possibleTitratorCaps,
			(*3*)roboticTitrationContainerCap
		}
	];

	preresolvedProbeRobotic = MapThread[
		Which[
			(*If Probe is specified, keep it*)
			MatchQ[#2, Except[Automatic]],
			#2,
			(* If TitrationMethod is Manual, we do not resolve probe here*)
			MatchQ[#1, Manual],
			#2,
			(* If TitrationMethod is Robotic, the probe is solved with the cap*)
			MatchQ[#3, Except[Null]],
			Lookup[fetchPacketFromCache[#3,roboticTitrationCapPackets],pHProbe],
			(* If we cannot resolve a cap, resolve to Null*)
			True,
			Automatic
		]&,
		{
			(*1*)resolvedTitrationMethod,
			(*2*)specifiedProbe,
			(*3*)preresolvedCapRobotic
		}
	];

	titrationInstrumentCompatibleQs=MapThread[
		Which[
			(*If TitrationInstrument is not specified, no conflicts*)
			MatchQ[#1,Automatic],
			True,
			(*If TitrationInstrument is not compatible with titration method, give conflicts*)
			MatchQ[#1,ObjectP[{Object[Instrument, pHTitrator], Model[Instrument, pHTitrator]}]]&& MatchQ[#2, Manual],
			False,
			True,
			True
		]&,
		{
			(*1*)specifiedTitrationInstrument,
			(*2*)resolvedTitrationMethod
		}
	];

	titrationInstrumentConflictingSamples=PickList[mySamples,titrationInstrumentCompatibleQs,False];

	titrationInstrumentConflictingOptions=If[!(And@@titrationInstrumentCompatibleQs),{TitrationInstrument, TitrationMethod},{}];


	If[!(And@@titrationInstrumentCompatibleQs)&&!gatherTests,
		Message[Error::ConflictingTitrationInstrument,titrationInstrumentConflictingSamples]
	];

	titrationInstrumentTest=If[gatherTests,
		Test["Specified TitrationInstrument and TitrationMethod options should not conflict",
			And@@titrationInstrumentCompatibleQs,
			True
		],
		{}];

	resolvedTitrationInstrument = MapThread[
		Which[
			(*If specified, take it*)
			MatchQ[#1,Except[Automatic]],
			#1,
			(*If TitrationMethod is Manual, resolve to Null*)
			MatchQ[#2,Manual],
			Null,
			(*Otherwise, resolve to pHTitrator*)
			True,
			Model[Instrument, pHTitrator, "id:WNa4Zjap6PRE"] (*Model[Instrument, pHTitrator, "Microlab 600 (ML600) pH Titrator"]*)
		]&,
		{
			(*1*)specifiedTitrationInstrument,
			(*2*)resolvedTitrationMethod
		}
	];


	(* -- Pre-Pre-resolve pHMixType so that we can figure out if we must aliquot for mixing -- *)

	(* Helper function to pre-resolve pHMix options *)
	preResolveMixOptions[
		(*1*)specifiedMixingOpts_,
		(*2*)containers_,
		(*3*)solidQ_,
		(*4*)mixWhileTitrating_,
		(*5*)sampleVol_,
		(*6*)titrationMethod_,
		cache_
	]:=MapThread[
		Module[{
			containerModel,containerModelPacket,titratingContainerOpenQ,titratingContainerLargeVolumeQ,
			titratingContainerVeryLargeVolumeQ,solidMixTimeReplaced,
			maxVol,noRoomQ
		},
			containerModel=fetchPacketFromCache[#2,cache][Model];
			(*Note here we don't have to consider mixAliquotRequired because it will only be True when pHMixType has been specified to True. We are only dealing with all Automatics here.*)
			containerModelPacket=fetchPacketFromCache[containerModel,cache];
			maxVol=containerModelPacket[MaxVolume];
			titratingContainerOpenQ=TrueQ[containerModelPacket[OpenContainer]];(*True or Null*)
			titratingContainerLargeVolumeQ=(maxVol>50Milliliter)&&(maxVol<1Liter);
			titratingContainerVeryLargeVolumeQ = maxVol>=1 Liter;
			noRoomQ=1-(#5/maxVol)<0.05; (*There's always extra room since we supposedly never pass MaxVolume so this should leave about 10% of total volume room*)
			Switch[#6, (* TitrationMethod Manual, pH adjustment will be preformed manually *)
				Manual,
				Switch[#1,
					{Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic},
					Switch[{#3,titratingContainerOpenQ,titratingContainerLargeVolumeQ,titratingContainerVeryLargeVolumeQ,#4,noRoomQ},

						{True,_,_,_,True,_}, (*Solid Titrant and mix while titrating-- stir till dissolve*)
						{Stir,True,Automatic,5Minute,14Minute,Automatic,90RPM,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{_,_,_,True,_,_}, (*Very large container, Stir for 14 Minutes*)
						{Stir,Automatic,Automatic,14Minute,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{True,False,True,_,_,_}, (*Solid titrant in closed large container, stir till dissolved*)
						{Stir,True,Automatic,5Minute,14Minute,Automatic,90RPM,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{_,_,True,_,_,_}, (*large container, stir for 5min*)
						{Stir,Automatic,Automatic,5Minute,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{False,_,_,_,True,_},(*Liquid Titrant and mix while titrating-- stir for 2 minuts (it's constantly stirring so going to be actually way longer than 2min)*)
						{Stir,Automatic,Automatic,2Minute,Automatic,Automatic,90RPM,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{True,True,_,_,_,_}, (*Solid Titrant in open container-- stir till dissolve*)
						{Stir,True,Automatic,5Minute,14Minute,Automatic,90RPM,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{False,True,_,_,_,_},(*Liquid Titrant in open container-- stir for 5 minuts*)
						{Stir,Automatic,Automatic,5Minute,Automatic,Automatic,90RPM,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{True,False,False,False,_,_}, (*Solid Titrant in closed small container-- roll till dissolved*)
						{Roll,True,Automatic,5Minute,14Minute,Automatic,30RPM,Automatic,Automatic,Automatic,Automatic,Null,Automatic},

						{_,_,_,_,_,True}, (*If mixing room is limited but otherwise not requiring stir, Invert 20 times*)
						{Invert,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,20,Automatic,Automatic,Automatic,Null,Automatic},

						{False,False,False,False,_,_}, (*Liquid titrant in closed small container, invert 15 times*)
						{Invert,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,15,Automatic,Automatic,Automatic,Null,Automatic},

						_, (*Any other odd incidences, invert 15 times*)
						{Invert,Automatic,Automatic,Automatic,Automatic,Automatic,Automatic,15,Automatic,Automatic,Automatic,Null,Automatic}

					],

					{Except[Invert|Pipette],_,_,Automatic,Automatic,_,_,_,_,_,_,_,_},
					If[#3,
						solidMixTimeReplaced=ReplacePart[#1,{4->5Minute,5->14Minute}];
						If[MatchQ[#1[[2]],Automatic],ReplacePart[#1,2->True],solidMixTimeReplaced],
						ReplacePart[#1,4->2Minute]
					],

					{(Invert|Pipette),_,_,_,_,_,_,Automatic,_,_,_,_,_},
					ReplacePart[#1,8->10],

					_,
					#1
				],
				Robotic, (* preResolveMixOptions with pHbot will be performed with stir*)
				ReplacePart[#1, {1-> Stir, 2-> False, 3 -> Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"], 4-> 2Minute}] (*Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]*)
			]

		]&,
		{
			(*1*)specifiedMixingOpts,
			(*2*)containers,
			(*3*)solidQ,
			(*4*)mixWhileTitrating,
			(*5*)sampleVol,
			(*6*)titrationMethod
		}
	];

	specifiedMixOptionsTransposed={
		specifiedpHMixType,
		specifiedpHMixUntilDissolved,
		specifiedpHMixInstrument,
		specifiedpHMixTime,
		specifiedMaxpHMixTime,
		specifiedpHMixDutyCycle,
		specifiedpHMixRate,
		specifiedNumberOfpHMixes,
		specifiedMaxNumberOfpHMixes,
		specifiedpHMixVolume,
		specifiedpHMixTemperature,
		specifiedMaxpHMixTemperature,
		specifiedSonicationAmplitude
	}//Transpose;



	(*If there are multiple fixed addition samples to the same input sample, they will be under the same sublist*)
	resolvedFixedAdditionSamples=ReplaceAll[resolvedFixedAdditions,None->{{Null,Null}}][[All,All,2]];
	resolvedFixedAdditionSampleStates=Map[If[MatchQ[#,ObjectP[]],fetchPacketFromCache[#,fullCacheWithSearchResults][State],Null]&,resolvedFixedAdditionSamples,{2}];
	solidTitrantQs=MapThread[MemberQ[Flatten[{#1,#2,#3}],Solid]&,{resolvedFixedAdditionSampleStates,resolvedTitratingAcidsStates,resolvedTitratingBasesStates}];

	prePreResolvedMixType=preResolveMixOptions[
		(*1*)specifiedMixOptionsTransposed,
		(*2*)simulatedSampleContainers,
		(*3*)solidTitrantQs,
		(*4*)specifiedMixWhileTitrating,
		(*5*)protocolSamplesInVolume,
		(*6*)resolvedTitrationMethod,
		fullCacheWithSearchResults
	][[All,1]];



	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(* Find out if mix requires us to aliquot *)
	mixAliquotRequiredWithResolvedMix=MapThread[
		Or[
			MatchQ[{#1,#2,#3},{Null,Stir,Manual}],
			MatchQ[{#2, #4}, {Stir, Null}]
		]&,
		{possibleImpellers,prePreResolvedMixType,resolvedTitrationMethod, Lookup[sampleContainerModelPackets, MaxOverheadMixRate, Null]}
	];

	(* Volumetric flasks tend to give us -- they can be too narrow and tall for pH probes. So we always aliquot when the original container is a volumetric flask *)
	AliquotRequiredWithVolumetricFlasks=MapThread[MatchQ[{#1, #2},{ObjectP[{Object[Container,Vessel,VolumetricFlask],Model[Container,Vessel,VolumetricFlask]}], Manual}]&,{sampleContainers, resolvedTitrationMethod}];

	(* When resolvedTitrationMethod is Robotic, we need to do aliquot when possibleTitratorCaps is {}*)
	roboticTitrationAliquotCaps = MapThread[MatchQ[{#1, #2}, {{},Robotic}]&, {possibleTitratorCaps, resolvedTitrationMethod}];

	(* If aliquot is required for each sample *)
	aliquotRequiredWithConsiderations=MapThread[Or[#1,#2,#3,#4,#5,replicateAliquotRequired]&,{mixAliquotRequiredWithResolvedMix,maxAdditionVolumeAliquotRequired,AliquotRequiredWithVolumetricFlasks, roboticTitrationAliquotCaps, resolvedAssayVolumeAliquotQ}];

	(* Considering user specified aliquot, is aliquot required or not? *)
	aliquotQ=Or@@#&/@Transpose[{aliquotRequiredWithConsiderations,(specifiedAliquot/.Alternatives[Automatic,Null]->False)}];

	(*If the titration is Manual, round down from sensible units to avoid issues if we try to take every last dreg and subsequent experiments get confused (e.g. ExperimentAliquot has had issues here) *)
	(*If the titration is Robotic, then aliquot is to change to use a compatible container, so will take the total amount of sample *)
	(* This is the amount to be fed into aliquot resolver, so we should use sampleVolumes instead of workingSampleVolumes --assay volume. *)
	calculatedAliquotAmounts= MapThread[
		Function[{sampleVolume, titrationMethod},
			If[MatchQ[titrationMethod, Robotic],
				sampleVolume/numberOfReplicatesNullToOne,
				Floor[UnitScale[sampleVolume/numberOfReplicatesNullToOne]]
			]
		],
		{sampleVolumes, resolvedTitrationMethod}
	];

	(*
		Take into consideration user specified Aliquot/AliquotAmount and check if aliquoting is considered required by the resolver
		If aliquot is implicitly specified by other aliquot options, we'll keep Aliquot amount to be resolved by resolveAliquotOptions, as the aliquot amount depends on bunch of other things.
	*)
	aliquotAmountRequired=MapThread[
		Function[{specifiedAmount,calculatedAmount,aliquotBool,specifiedTotalVolume,specifiedWell,specifiedContainer,specifiedStorage,specifiedConcentration},
			Which[
				(* We determined above we need to aliquot. Use user value or switch Automatic to resolved vvalue  *)
				aliquotBool, specifiedAmount/.Automatic->calculatedAmount,
				(* If user set another aliquot option we should aliquot *)
				MemberQ[{specifiedTotalVolume,specifiedWell,specifiedContainer,specifiedStorage,specifiedConcentration},Except[Automatic|Null|{}|{Null..}|None|{None..}]], specifiedAmount,
				(* Otherwise no aliquots *)
				True, specifiedAmount/.Automatic->Null
			]
		],
		{specifiedAliquotAmount,calculatedAliquotAmounts,aliquotQ,specifiedAsssayVolume,specifiedDestinationWell,specifiedAliquotContainer,specifiedAliquotSampleStorageCondition,specifiedTargetConcentration}
	];

	(*Helper function to find the smallest beaker that can take the specified volume with enough clearances*)
	preferredBeaker[volume:_Quantity,clearance_Quantity]:=Module[{candidates,minMaxVolume},
		(*Find a beaker that has enough clearances and enough volume*)
		candidates=Select[candidateBeakerPackets,#[InternalDiameter]>=clearance&&#[Aperture]>=clearance&&#[MaxVolume]>=volume&];
		(*Find the smallest MaxVolume in there*)
		minMaxVolume=Min[Lookup[candidates,MaxVolume]];
		(*Find the packet that has that smallest MaxVolume, and get the object from the beaker*)
		SelectFirst[candidates,#[MaxVolume]===minMaxVolume&][Object]
	];

	maxBeakerVolume=Max[Cases[candidateBeakerPackets[MaxVolume],VolumeP]];

	aliquotTargetContainers=MapThread[
		Which[
			(*When TitrationMethod is Manual, Aliquot is required because we need an overhead stirrer and the original container is not compatible,
			OR user specified aliquoting with Stirring pHMixType-- we can do beaker under a max volume (unrrently it's 2L)*)
			MatchQ[{#1,#2,#3, #6},{True,Stir,LessEqualP[maxBeakerVolume], Manual}],
			#4/.Automatic->preferredBeaker[#3,#5],

			(*When TitrationMethod is Manual, Aliquot is required because of NumberOfReplicates, MaxAdditionVolumes, or VolumetricFlasks,
			OR user specified aliquoting with pHMixType that is not Stirring*)
			MatchQ[{#1, #6},{True, Manual}],
			#4/.Automatic->PreferredContainer[#3],

			(*When TitrationMethod is Robotic, Aliquot is required because of no compatible caps found for the sample container*)
			MatchQ[{#1, #6}, {True, Robotic}],
			#7, (* we do not allow user to specify AliquotContainer if titration is robotic and aliquot is required *)

			True,(*Aliquot is not required and is not requested by the user*)
			#4/.Automatic->Null
		]&,
		{
			(*1*)aliquotQ,
			(*2*)prePreResolvedMixType,
			(*3*)calculatedAliquotContainerVolume,
			(*4*)specifiedAliquotContainers,
			(*5*)clearances,
			(*6*)resolvedTitrationMethod,
			(*7*)roboticTitrationContainer
		}
	];

	(* Check if MixRate is safe -- These two errors won't be thrown twice in ExperimentIncubate because we do not specify StirBar option when we call incubate resolver *)
	maxSafeMixRates = Module[{workingSampleContainerModels},
		workingSampleContainerModels = MapThread[
			If[!NullQ[#1],
				(* if we need to aliquot, check if resolved aliquot container is object or model *)
				If[MatchQ[#1, ObjectP[Object[Container]]],
					(* get the model container if it is object*)
					Lookup[Experiment`Private`fetchPacketFromCache[#1, fullCache], Model],
					#1
				],
				#2
			]&,
			{aliquotTargetContainers, sampleContainerModels}];
		(* get the safe mix rate of target container model*)
		Lookup[Experiment`Private`fetchPacketFromCache[#, fullCache], MaxOverheadMixRate, Null]&/@ workingSampleContainerModels
	];

	(* check if the working sample container have MaxOverheadMixRate populated for Stir*)
	maxSafeMixRatesMissingInvalidInputs = MapThread[
		Function[{maxSafeMixRate,sample,mixType},
			(* If mix type is specified to be Stir, but we do not have MaxOverheadMixRate field populated for the target sample container, error out as the sample is invalid input *)
			If[MatchQ[maxSafeMixRate, Null]&&MatchQ[mixType, Stir],
				sample,
				Nothing
			]
		],
		{
			maxSafeMixRates,
			simulatedSamplesMain,
			prePreResolvedMixType
		}
	];
	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[maxSafeMixRatesMissingInvalidInputs]>0&&!gatherTests,
		Message[Error::SafeMixRateNotFound,ObjectToString[maxSafeMixRatesMissingInvalidInputs,Cache->fullCache]];
	];
	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	maxSafeMixRatesMissingTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[maxSafeMixRatesMissingInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[maxSafeMixRatesMissingInvalidInputs,Cache->fullCache]<>" do not have MaxOverheadMixRate field populated for the container:",True,False]
			];

			passingTest=If[Length[maxSafeMixRatesMissingInvalidInputs]==Length[simulatedSamplesMain],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamplesMain,maxSafeMixRatesMissingInvalidInputs],Cache->fullCache]<>" have MaxOverheadMixRate field populated for the container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* check if the given MixRate can be reached with the sample container. *)
	safeMixRateMismatches=MapThread[
		Function[{maxSafeMixRate,mixRate,sample,mixType},
			(* If the provided mixRate is larger than the max safeMixRate we can reach *)
			If[MatchQ[mixRate, Except[Automatic|Null]]&&MatchQ[maxSafeMixRate, Except[Null]]&&MatchQ[mixType, Stir],
				If[!NullQ[maxSafeMixRate]&&maxSafeMixRate < mixRate,
					{{mixRate, maxSafeMixRate},sample},
					Nothing
				],
				Nothing
			]
		],
		{
			maxSafeMixRates,
			specifiedpHMixRate,
			simulatedSamplesMain,
			prePreResolvedMixType
		}
	];
	(* Transpose our result if there were mismatches. *)
	{safeMixRateMismatchOptions,safeMixRateMismatchInputs}=If[MatchQ[safeMixRateMismatches,{}],
		{{},{}},
		Transpose[safeMixRateMismatches]
	];
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	safeMixRateInvalidOptions=If[Length[safeMixRateMismatchOptions]>0&&!gatherTests,
		Message[Error::SafeMixRateMismatch,ObjectToString[safeMixRateMismatchInputs,Cache->fullCache],safeMixRateMismatchOptions[[All, 1]], safeMixRateMismatchOptions[[All, 2]]];
		{pHMixRate},
		{}
	];
	(* If we are gathering tests, create a test with the appropriate result. *)
	safeMixRateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamplesMain,safeMixRateMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting mix rate and the maximumn safe mix rate they can reach "<>ObjectToString[passingInputs,Cache->fullCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[safeMixRateMismatchInputs]>0,
				Test["The following object(s) do not have conflicting mix rate and the maximumn safe mix rate they can reach "<>ObjectToString[safeMixRateMismatchInputs,Cache->fullCache]<>":",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*resolveAliquotOptions does not like it when RequiredAliquotAmount is {Automatic} so we'll change it to Automatic*)
	aliquotAmountRequiredDeList=If[MatchQ[aliquotAmountRequired,{Automatic}],Automatic,aliquotAmountRequired];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids->True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		(*We are forcing the aliquotAmountRequired into the resolverSafeOps because if we only put it into the options and if aliquotTargetContainer is of the same model as the original container, specifying RequiredAliquotAmounts will not turn on aliquoting. But we will need to aliquot in this experiment, due to number of replicates*)
		If[MemberQ[aliquotAmountRequired,Automatic],
			resolveAliquotOptions[ExperimentAdjustpH,mySamples,simulatedSamplesMain,ReplaceRule[resolverSafeOps,resolvedSamplePrepOptionsMain],Cache->fullCacheWithSearchResults,Simulation->simulation, RequiredAliquotAmounts->Null,Output->{Result,Tests}],

			resolveAliquotOptions[ExperimentAdjustpH,mySamples,simulatedSamplesMain,ReplaceRule[resolverSafeOps,Flatten[{AliquotAmount->aliquotAmountRequiredDeList,resolvedSamplePrepOptionsMain}]],Cache->fullCacheWithSearchResults,RequiredAliquotContainers->aliquotTargetContainers,Simulation->simulation, RequiredAliquotAmounts->aliquotAmountRequiredDeList,Output->{Result,Tests}]
		],

		(*ELSE: not gathering tests*)
		If[MemberQ[aliquotAmountRequired,Automatic],
			{resolveAliquotOptions[ExperimentAdjustpH,mySamples,simulatedSamplesMain,ReplaceRule[resolverSafeOps,resolvedSamplePrepOptionsMain],Cache->fullCacheWithSearchResults,Simulation->simulation, RequiredAliquotAmounts->Null,Output->Result],{}},

			{resolveAliquotOptions[ExperimentAdjustpH,mySamples,simulatedSamplesMain,ReplaceRule[resolverSafeOps,Flatten[{AliquotAmount->aliquotAmountRequiredDeList,resolvedSamplePrepOptionsMain}]],Cache->fullCacheWithSearchResults,RequiredAliquotContainers->aliquotTargetContainers,Simulation->simulation, RequiredAliquotAmounts->aliquotAmountRequiredDeList,Output->Result],{}}
		]
	];

	optionsWithResolvedAliquots=ReplaceRule[resolverSafeOps,resolvedAliquotOptions];



	(* ---- Resolved ContainerOut ---- *)


	resolvedAliquotAmountWithNumberOfReplicates=Lookup[optionsWithResolvedAliquots,AliquotAmount]*numberOfReplicatesNullToOne;
	resolvedMaxAdditionVolumesWithNumberOfReplicates=resolvedMaxAdditionVolumes*numberOfReplicatesNullToOne;
	(*With MaxAdditionVolume and NumberOfReplicates, how much total volume can we generate after pHing?*)

	totalPossibleVolumes=MapThread[
		If[MatchQ[#1,VolumeP],#1+#3,#2+#3]&,
		{resolvedAliquotAmountWithNumberOfReplicates,sampleVolumes,resolvedMaxAdditionVolumesWithNumberOfReplicates}
	];
	resolvedAliquots=Lookup[resolvedAliquotOptions,Aliquot];


	(*
	If it's specified, take specified
	Otherwise, if not aliquoted, original container,
	Otherwise, take the preferred container of the maximum possible final total volume
	*)
	(*find out of the current container is open container*)

	resolvedOutputContainers=MapThread[
		Which[
			MatchQ[#1,Except[Automatic]],#1,
			!TrueQ[#2],#3,
			True,PreferredContainer[#4]
		]&,
		{specifiedContainerOut,resolvedAliquots,sampleContainers,totalPossibleVolumes}
	];

	(* After we've resolved the aliquot options *)
	(* Call resolveSamplePrepOptions again to put SamplesIn into resolved aliquoting containers *)
	(* Only pass aliquot options and NumberOfReplicates which the resolver needs *)

	(* SPEED: skip the second resolveSamplePrepOptionsNew entirely if Aliquot container was specified by the user, or resolved to Null *)
	(*AliquotContainer looks like this: {{1,Model[Container,Vessel,"blah"]},{2,Model[Container,Vessel,"blah"]}...}. We need to combine the aliquot containers of the same sample.*)
	resolvedAliquotContainers=Lookup[optionsWithResolvedAliquots,AliquotContainer]/.Null->{1,Null};
	aliquotContainerCondensed=Partition[resolvedAliquotContainers,numberOfReplicatesNullToOne][[All,1,2]];
	skipSecondPrepQ=MatchQ[{ToList[specifiedAliquotContainers],ToList[aliquotContainerCondensed]},
		Alternatives[
			{
				{ObjectP[{Object[Container,Vessel]|Model[Container,Vessel]}]..},_
			},
			{
				{(Automatic|Null)..},{Null..}
			}
		]
	];

	(*Simulate the resolved aliquot*)
	{{updatedSimulatedSamplesMain,updatedresolvedSamplePrepOptionsMain,secondUpdatedSimulationMain},updatedSamplePrepTests}=If[skipSecondPrepQ,
		{{simulatedSamplesMain,resolvedSamplePrepOptionsMain,updatedSimulationMain},{}},
		If[gatherTests,
			resolveSamplePrepOptionsNew[ExperimentAdjustpH,mySamples,Append[resolvedAliquotOptions,NumberOfReplicates->specifiedNumberOfReplicates],Cache->fullCacheWithSearchResults,Simulation->simulation,Output->{Result,Tests}],
			{resolveSamplePrepOptionsNew[ExperimentAdjustpH,mySamples,Append[resolvedAliquotOptions,NumberOfReplicates->specifiedNumberOfReplicates],Cache->fullCacheWithSearchResults,Simulation->simulation,Output->Result],{}}
		]
	];

	updatedCacheWithSecondSamplePrepSimulation=If[skipSecondPrepQ,
		fullCacheWithSearchResults,
		FlattenCachePackets[
			{
				fullCacheWithSearchResults,
				Quiet[
					Download[updatedSimulatedSamplesMain,
						{
							sampleFields,
							Packet[Model[Evaluate[Union[{pH,TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State,NominalpH,MinpH,MaxpH,IncompatibleMaterials},Evaluate[SamplePreparationCacheFields[Model[Sample]]]]]]],
							Packet[Container[Evaluate[SamplePreparationCacheFields[Object[Container]]]]],
							Packet[Container[Model][{Name, VolumeCalibrations, MaxVolume, Aperture, InternalDiameter, Dimensions, Sterile, Deprecated, Footprint, OpenContainer,InternalDepth,InternalDimensions,SelfStanding}]],
							Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
						},
						Cache->fullCacheWithSearchResults,
						Simulation->secondUpdatedSimulationMain
					],
					{Download::FieldDoesntExist}
				]
			}
		]
	];




	(* ---- Resolve Mix Options (for real) ---- *)

	(* We don't want Mix and MeasurepH to get our aliquot options, sample prep options, or template option *)
	otherExperimentOptions=Normal[KeyDrop[resolverSafeOps,Flatten[{ToExpression[Keys[Options[SamplePrepOptions]]],ToExpression[Keys[Options[AliquotOptions]]],Template}]]];


	updatedSimulatedSamplePackets=fetchPacketFromCache[#,updatedCacheWithSecondSamplePrepSimulation]&/@updatedSimulatedSamplesMain;
	updatedSimulatedSampleContainers=Lookup[updatedSimulatedSamplePackets,Container];
	updatesSimulatedSampleVolumes=Lookup[updatedSimulatedSamplePackets,Volume];


	preResolvedMixOptions=preResolveMixOptions[
		(*1*)specifiedMixOptionsTransposed,
		(*2*)updatedSimulatedSampleContainers,
		(*3*)solidTitrantQs,
		(*4*)specifiedMixWhileTitrating,
		(*5*)updatesSimulatedSampleVolumes,
		(*6*)resolvedTitrationMethod,
		updatedCacheWithSecondSamplePrepSimulation
	];



	(*ExperimentMix does not take Automatic for MaxMixTime and MaxMixTemperature.*)

	preResolvedMixOptionsMaxTempNull=If[#[[-2]]===Automatic,ReplacePart[#,-2->Null],#]&/@preResolvedMixOptions;
	preResolvedMixOptionsMaxTempTimeNull=If[#[[5]]===Automatic,ReplacePart[#,5->Null],#]&/@preResolvedMixOptionsMaxTempNull;

	{
		preResolvedpHMixType,
		preResolvedpHMixUntilDissolved,
		preResolvedpHMixInstrument,
		preResolvedpHMixTime,
		preResolvedMaxpHMixTime,
		preResolvedpHMixDutyCycle,
		preResolvedpHMixRate,
		preResolvedNumberOfpHMixes,
		preResolvedMaxNumberOfpHMixes,
		preResolvedpHMixVolume,
		preResolvedpHMixTemperature,
		preResolvedMaxpHMixTemperature,
		preResolvedSonicationAmplitude
	}=Transpose[preResolvedMixOptionsMaxTempTimeNull];

	(* Generate the options for the ExperimentMix call. Make all of the options symbols (PassOptions converts to strings) *)
	experimentMixPassedOptions=MapAt[ToExpression,
		List[Quiet[PassOptions[ExperimentAdjustpH, ExperimentMix, otherExperimentOptions],Warning::OptionPattern]],
		{All, 1}
	];

	(* We want to pass on any mix options provide, but we must change their names *)
	(* NumberOfReplicates means we'll be making aliquots and adjusting the pH of each of these and is not meant to apply to mixes *)

	numberSimulatedSamples=Length[simulatedSamplesMain];
	replacedMixOptions=ReplaceRule[
		experimentMixPassedOptions,
		{
			Aliquot->ConstantArray[False,numberSimulatedSamples],
			Mix->ConstantArray[True,numberSimulatedSamples],
			MixType->preResolvedpHMixType,
			MixUntilDissolved->preResolvedpHMixUntilDissolved,
			Instrument->preResolvedpHMixInstrument,
			Time->preResolvedpHMixTime,
			MaxTime->preResolvedMaxpHMixTime,
			DutyCycle->preResolvedpHMixDutyCycle,
			MixRate->preResolvedpHMixRate,
			NumberOfMixes->preResolvedNumberOfpHMixes,
			MaxNumberOfMixes->preResolvedMaxNumberOfpHMixes,
			MixVolume->preResolvedpHMixVolume,
			Temperature->preResolvedpHMixTemperature,
			MaxTemperature->preResolvedMaxpHMixTemperature,
			Amplitude->preResolvedSonicationAmplitude,

			Output-> If[gatherTests,
				{Options,Tests},
				Options
			],
			Cache->fullCacheWithSearchResults
		}
	];

	expandedMixOptions=Last[ExpandIndexMatchedInputs[ExperimentMix,{ToList[simulatedSamplesMain]},replacedMixOptions]];
	(*resolve everything mix related*)
	(*We are calling the option resolver directly instead of the whole experiment because Incubate's resource packets takes half of the time of the function. Also we are gathering all resources Mix will need upfront excepts for instruments that are not overhead stirrer.*)
	{resolvedMixOptions,mixTests}=If[gatherTests,
		Quiet[resolveExperimentIncubateNewOptions[simulatedSamplesMain,expandedMixOptions,Cache->fullCacheWithSearchResults,Simulation->updatedSimulationMain,Output->{Result,Tests}],{Error::DiscardedSamples,Error::InvalidInput,Error::AliquotOptionConflict,Error::StirIncompatibleInstruments,Error::StirNoStirBarOrImpeller,Error::VolumetricFlaskMixMismatch,Error::InvalidOption}],
		{Quiet[resolveExperimentIncubateNewOptions[simulatedSamplesMain,expandedMixOptions,Cache->fullCacheWithSearchResults,Simulation->updatedSimulationMain],{Error::DiscardedSamples,Error::InvalidInput,Error::AliquotOptionConflict,Error::StirIncompatibleInstruments,Error::StirNoStirBarOrImpeller,Error::VolumetricFlaskMixMismatch,Error::InvalidOption}],{}}
	];

	(*now we want to convert back to the names that we use in this experiemnt function*)
	replacedMixNamesOptions=ReplaceAll[
		resolvedMixOptions,
		{
			Rule[Instrument,x_]:>Rule[pHMixInstrument,x],
			Rule[Temperature,x_]:>Rule[pHMixTemperature,x],
			Rule[MaxTime,x_]:>Rule[MaxpHMixTime,x],
			Rule[Time,x_]:>Rule[pHMixTime,x],
			Rule[DutyCycle,x_]:>Rule[pHMixDutyCycle,x],
			Rule[MixType,x_]:>Rule[pHMixType,x],
			Rule[MixUntilDissolved,x_]:>Rule[pHMixUntilDissolved,x],
			Rule[MixRate,x_]:>Rule[pHMixRate,x],
			Rule[NumberOfMixes,x_]:>Rule[NumberOfpHMixes,x],
			Rule[MaxNumberOfMixes,x_]:>Rule[MaxNumberOfpHMixes,x],
			Rule[MixVolume,x_]:>Rule[pHMixVolume,x],
			Rule[Temperature,x_]:>Rule[pHMixTemperature,x],
			Rule[MaxTemperature,x_]:>Rule[MaxpHMixTemperature,x],
			Rule[Amplitude,x_]:>Rule[pHHomogenizingAmplitude,x]
		}
	];






	(* ---- Resolve MeasurepH Options ---- *)
	(*before passing to ExperimentpH, we want to try to resolve the probe by the probe type if need be (currently not supported measure pH)*)
	preresolvedProbe=MapThread[
		Function[{eachProbe,eachProbeType, eachTitrationMethod, eachProbeRobotic},
			Switch[eachTitrationMethod,
				Manual,
				Switch[
					{eachProbe,eachProbeType},
					{Except[Automatic],_},eachProbe,
					{_,Except[Automatic|Null]},Lookup[FirstCase[probePackets,KeyValuePattern[ProbeType->eachProbeType]],Object],
					_,eachProbe
				],
				Robotic,
				eachProbeRobotic
			]
		],
		Join[Lookup[resolverSafeOps,{Probe,ProbeType}],{resolvedTitrationMethod, preresolvedProbeRobotic}]
	];

	preresolvedpHMeter = MapThread[
		Function[{eachpHMeter,eachTitrationMethod},
			Switch[eachTitrationMethod,
				Manual,
				eachpHMeter,
				Robotic,
				If[MatchQ[eachpHMeter, Automatic],
					Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"],
					eachpHMeter
				]
			]
		],
		{Lookup[resolverSafeOps,pHMeter],resolvedTitrationMethod}
	];

	preresolvedpHAliquot = MapThread[
		Function[{eachpHAliquot,eachAutoTransfer},
			Switch[eachAutoTransfer,
				Manual,
				eachpHAliquot,
				Robotic,
				False
			]
		],
		{Lookup[resolverSafeOps,pHAliquot],resolvedTitrationMethod}
	];

	(* Generate the options for the ExperimentMeasurepH call. Make all of the options symbols (PassOptions converts to strings) *)
	experimentMeasurepHPassedOptions=MapAt[ToExpression,
		{PassOptions[ExperimentAdjustpH, ExperimentMeasurepH, otherExperimentOptions]},
		{All, 1}
	];


	(* We want to replace the Instrument with the pHMeter option*)
	(* NumberOfReplicates means we'll be making aliquots and adjusting the pH of each of these and is not meant to apply to pH measurements *)

	replacedMeasurepHOptions=ReplaceRule[
		Normal[experimentMeasurepHPassedOptions],
		{
			NumberOfReplicates->Null,
			Instrument->preresolvedpHMeter,
			Aliquot->preresolvedpHAliquot,
			AliquotAmount->Lookup[resolverSafeOps,pHAliquotVolume],
			Probe->preresolvedProbe,
			Output->If[gatherTests,
				{Options,Tests},
				Options
			],
			Cache->updatedCacheWithSecondSamplePrepSimulation(*,
			Simulation->secondUpdatedSimulationMain*)
		}
	];

	expandedMeasurepHOptions=Last[ExpandIndexMatchedInputs[ExperimentMeasurepH,{ToList[updatedSimulatedSamplesMain]},replacedMeasurepHOptions]];

	(*We are calling the option resolver directly instead of the whole experiment because MeasurepH's resource packets takes half of the time of the function. Also we are gathering all resources Mix will need upfront excepts for instruments.*)
	{resolvedpHOptions,measurepHTests}=If[gatherTests,
		resolveExperimentMeasurepHOptions[updatedSimulatedSamplesMain,expandedMeasurepHOptions,InternalUsage -> True, Cache->updatedCacheWithSecondSamplePrepSimulation,Simulation->secondUpdatedSimulationMain,Output->{Result,Tests}],
		{resolveExperimentMeasurepHOptions[updatedSimulatedSamplesMain,expandedMeasurepHOptions,InternalUsage -> True, Cache->updatedCacheWithSecondSamplePrepSimulation,Simulation->secondUpdatedSimulationMain],{}}
	];

	(*now we want to convert back to the names that we use in this experiment function*)
	replacedpHNamesOptions=ReplaceAll[
		resolvedpHOptions,
		{
			Rule[Instrument,x_]:>Rule[pHMeter,x],
			Rule[Aliquot,x_]:>Rule[pHAliquot,x],
			Rule[AliquotAmount,x_]:>Rule[pHAliquotVolume,x]
		}
	];
	(*resolve the probe type*)
	resolvedProbe=Lookup[resolvedpHOptions,Probe];
	resolvedProbeType=MapThread[
		Function[{resolvedProbe,specifiedProbeType},
			Switch[{resolvedProbe,specifiedProbeType},
				{_,Except[Automatic]},specifiedProbeType,
				{ObjectP[],_},Lookup[fetchPacketFromCache[resolvedProbe,probePackets],ProbeType],
				_,Null
			]
		],
		{
			resolvedProbe,
			Lookup[resolverSafeOps,ProbeType]
		}
	];

	(* ---- Resolve Impeller: takes into consideration of aliquoting containers ---- *)
	(*If instrument is specified as object, get its model*)
	mixingInstrumentModels=If[MatchQ[#,ObjectP[Object[Instrument]]],fetchPacketFromCache[#,updatedCacheWithSecondSamplePrepSimulation][Model],#]&/@Lookup[replacedMixNamesOptions,pHMixInstrument];


	(* Get the impellers for each overhead stirrer.*)
	impellers=MapThread[
		If[MatchQ[#3, Robotic],
			$DefaultRoboticMixingImpeller,
			If[
				MatchQ[#2,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
				compatibleImpeller[#1,#2,Cache->updatedCacheWithSecondSamplePrepSimulation],
				Null
			]
		]&,
		{
			updatedSimulatedSamplesMain,
			mixingInstrumentModels,
			resolvedTitrationMethod
		}
	];

	(* --- Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[updatedSimulatedSamplesMain, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["adjust ph sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[secondUpdatedSimulationMain, SimulationP] && MatchQ[LookupObjectLabel[secondUpdatedSimulationMain, Download[object, Object]], _String],
					LookupObjectLabel[secondUpdatedSimulationMain, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[resolverSafeOps, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[updatedSimulatedSamplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["adjust ph sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[secondUpdatedSimulationMain, SimulationP] && MatchQ[LookupObjectLabel[secondUpdatedSimulationMain, Download[object, Object]], _String],
					LookupObjectLabel[secondUpdatedSimulationMain, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[resolverSafeOps, SampleContainerLabel]}
		]
	];

	(* --- Resolve Post Processing Options --- *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[resolverSafeOps];




	(* Sneaky: Arrange options so that duplicates are overridden by whatever appears last *)
	(* Calling ExperimentMeasurepH/Incubate will return full sets of resolved options *)
	(* We only want a subset of their options - e.g. pHMixTime, but not Aliquot, put them first *)
	(* Then must list all other function options *)
	resolverResolvedOptions=Association[
		replacedpHNamesOptions,
		replacedMixNamesOptions,
		resolvedSamplePrepOptionsMain,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		{
			HistoricalData->resolvedHistoricalData,
			FixedAdditions->(resolvedFixedAdditions/.x:LinkP[]:>x[Object]),
			MinpH->resolvedMinpHs,
			MaxpH->resolvedMaxpHs,
			MaxAdditionVolume->resolvedMaxAdditionVolumes,
			ContainerOut->resolvedOutputContainers,
			TitrationMethod -> resolvedTitrationMethod,
			TitrationInstrument -> resolvedTitrationInstrument,
			TitrationContainerCap -> preresolvedCapRobotic,
			ProbeType->resolvedProbeType,
			pHMixImpeller->impellers,
			NumberOfReplicates->specifiedNumberOfReplicates,
			KeepInstruments->specifiedKeepInstruments,
			TitratingAcid->resolvedTitratingAcids,
			TitratingBase->resolvedTitratingBases,
			MaxAcidAmountPerCycle->updatedMaxAcidAmountPerCycle,
			MaxBaseAmountPerCycle->updatedMaxBaseAmountPerCycle,
			ModelOut->resolvedModelOut,
			NonBuffered->QuantityQ/@spikedAmountsConverted,
			MaxNumberOfCycles->updatedMaxNumberOfCycles,
			PreparatoryUnitOperations->specifiedPreparatoryPrimitives,
			SampleLabel->resolvedSampleLabel,
			SampleContainerLabel->resolvedSampleContainerLabel,
			Simulation->specifiedSimulation (*Simulation should be returned as is*)

		}

	];

	invalidOptions=DeleteCases[DeleteDuplicates[Flatten[{
		noAdditionOptions,fixedAdditionsConflictOptions,fixedAdditionsConflictOptions,invalidTitrateOptions,
		invalidTitrateOptions,overheadMixingRequiredOptions,badMaxVolumeOptions,overheadMixingRequiredOptions,badMaxVolumeOptions,pHRangeConflictingOptions,
		titratingBaseAmountConflictingOptions,titratingAcidAmountConflictingOptions,containerTooSmallOptions, titrationMethodConflictingOptions, titrationInstrumentConflictingOptions, safeMixRateInvalidOptions
	}]],Null];
	invalidInputs=DeleteDuplicates[Flatten[{maxSafeMixRatesMissingInvalidInputs}]];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];
	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0 && MatchQ[gatherTests, False],
		Message[Error::InvalidInput,invalidInputs]
	];


	(* Get any other options where we're just using the defaults *)
	(* Using Append->False will also remove any options we picked up from MeasurepH or Incubate *)
	allOptions=ReplaceRule[resolverSafeOps,Normal[resolverResolvedOptions],Append->False];

	allTests = DeleteCases[Flatten[{measurepHTests,mixTests,maxVolumeTest,aliquoteReplicateConflictTest,invalidTitrateComboTest,
		fixedAdditionsConflictTest,noAdditionsTest,aliquotTests,pHRangeConflictingTests,samplePrepTests,updatedSamplePrepTests,
		acidAmountTest,baseAmountTest,containerTooSmallTest, titrationMethodTest, maxSafeMixRatesMissingTest, safeMixRateTest}], Null | {}];

	outputSpecification /. {Result->allOptions, Tests->allTests}
];


(* ::Subsubsection:: *)
(*Resource Packets*)


DefineOptions[adjustpHResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

adjustpHResourcePackets[mySamples:{ObjectP[Object[Sample]]..},nominalpHs:{pHP..},templatedOptions:{(_Rule|_RuleDelayed)...},resolvedOptions:{(_Rule|_RuleDelayed)..},myOps:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTestsQ,protocolID,cache,numberOfReplicates,replicatedSamples,replicatedOptions,download,
		samplePackets,requiredVolumes,sampleVolumeTuples,uniqueSampleVolumeTuples,uniqueSampleResources,sampleResourceLookup,
		sampleResources,uniqueSampleContainers,containerResources,titrantVolumeTuples,reagentSums,
		uniqueReagentResources,titratingBaseResources,
		titratingAcidResources,fixedAdditionRequests,fixedAdditionSamples,titratingAcid,titratingBase,resourceTime,prepTime,
		additionsTime,adjustmentTime,postProcessTime,storageTime,protocolPacket,prepPacket,finalizedPacket,resources,resourcesOk,
		resourceTests,fixedAdditionRequestsFlattened,fixedAdditionRequestsObjectsDeDup,replicatedOptionsNoneToNull,maxAdditionVolumeWithMargin,
		allMixInstruments,mixInstrumentsResources,impellers,impellersResources,
		resolvedContainersOut,containersOutResources,containersOutResourcesExpanded,washSolution,washSolutionResource,
		sampleContainers,aliquotContainers,transferContainers,transferContainersClean,transferContainersModel,transferContainerModelDeDup,
		transferRackDeDup,transferRackResourcesDeDup,rackReplacementRules,racks,lowCalibrationBufferResource,mediumCalibrationBufferResource,
		highCalibrationBufferResource,allMixInstrumentsNoStir,allMixInstrumentsNoStirResources,mixInstrumentReplacementRules,phMeters,
		phMetersDeDup,phMetersResourcesDeDup,phMetersReplacementRules,phInstrumentsResources,mixInstrumentsResourcified,simulation, titrationInstruments, titrationInstrumentsResourcified, manualTitrationSamples, roboticTitrationSamples, manualTitrationPositions,
		roboticTitrationPositions, batchedTitrationMethods, batchedFixedAdditions, batchedProbeTypes, batchedAcquisitionTimes,
		batchedTemperatureCorrections, batchedpHAliquots,
		batchedpHAliquotVolumes, batchedTitrates, batchedMixWhileTitrating,
		batchedpHMixTypes, batchedpHMixUntilDissolved, batchedpHMixTimes,
		batchedMaxpHMixTimes, batchedpHMixDutyCycles, batchedpHMixRates,
		batchedNumbersOfpHMixes, batchedMaxNumbersOfpHMixes,
		batchedpHMixVolumes, batchedpHMixTemperatures,
		batchedMaxpHMixTemperatures, batchedpHHomogenizingAmplitudes,
		batchedMinpHs, batchedMaxpHs, batchedMaxAdditionVolumes,
		batchedMaxNumbersOfCycles, batchedpHMeters, batchedProbes,
		batchedNominalpHs, batchedTransferDestinationRacks,
		batchedTitratingAcids, batchedTitratingBases,
		batchedpHMixInstruments, batchedpHMixImpellers, batchLengths, replicatedNominalpHs,  batchedMaxAcidAmountsPerCycle,batchedMaxBaseAmountsPerCycle,batchedTitrationInstrument, titrationContainerCaps,titrationContainerCapsResources ,batchedTitrationContainerCaps, pHMixTimesRoboticNull, resolvedBatchingParameters, mixInstrumentResourceLookup, impellerResourceLookup,
		titrationContainerCapLookup, titrationInstrumentsUpdated,titrationInstrumentAssociation,
		uniqueTitrationInstruments, titrationInstrumentResourceLookup, pHMetersResourcified, allpHMeters, pHMeterResourceLookup, roboticUniqueTitrant,titrationMethods, titrationInstrumentCounts, titrationInstrumentPackets, uniqueTitrationContainerCaps
	},

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];
	gatherTestsQ=MemberQ[output,Tests];

	(* Generate an ID for the new protocol *)
	protocolID=CreateID[Object[Protocol,AdjustpH]];

	(* Get cache for Download *)
	cache=OptionDefault[OptionValue[Cache]];
	simulation=OptionDefault[OptionValue[Simulation]];

	(* Determine if we need to make replicate spots *)
	numberOfReplicates=Lookup[resolvedOptions,NumberOfReplicates]/.Null->1;


	(* If user has asked for replicates, repeat the sample and the option that number of times *)
	{replicatedSamples,replicatedOptions}=expandFluorescenceReplicates[ExperimentAdjustpH,mySamples,resolvedOptions,numberOfReplicates];
	titrationInstruments = Lookup[replicatedOptions, TitrationInstrument];

	download=Quiet[
		Download[
			{
				replicatedSamples,
				titrationInstruments
			},
			{
				{Packet[Volume,Container,Model]},
				{Packet[Object, Model]}
			},
			Cache->cache,
			Simulation->simulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];
	samplePackets=download[[1,All,1]];
	titrationInstrumentPackets =Flatten[download[[2]]];

	(*If no need to aliquot, take the volume of the sample. If aliquot, take aliquot amount*)
	requiredVolumes=MapThread[
		If[!#1,#2[Volume],#3]&,
		{Lookup[replicatedOptions,Aliquot],samplePackets,Lookup[replicatedOptions,AliquotAmount]}
	];

	(* Generate a list of pairs in the form {sample,volume needed} *)
	sampleVolumeTuples=Transpose[{replicatedSamples,requiredVolumes}];

	(* Gather up samples that appear multiple times and get the total volume needed from each *)
	uniqueSampleVolumeTuples=Map[
		{#[[1,1]],Total[#[[All,2]]]}&,
		GatherBy[sampleVolumeTuples,First]
	];

	(* Make a list of unique sample resources - requesting volume if *)
	uniqueSampleResources=Resource[Sample->First[#],Amount->Last[#],Name->ToString[First[#]]]&/@uniqueSampleVolumeTuples;

	(* Create a little lookup between unique samples and resources and then get the right resource for each sample so we can preserve index-matching *)
	sampleResourceLookup=AssociationThread[uniqueSampleVolumeTuples[[All,1]]->uniqueSampleResources];
	sampleResources=Lookup[sampleResourceLookup,#]&/@replicatedSamples;

	sampleContainers=Download[Lookup[samplePackets,Container],Object];
	uniqueSampleContainers=DeleteDuplicates[sampleContainers];
	containerResources=Link[Resource[Sample->#],Protocols]&/@uniqueSampleContainers;


	(* -- Make resources for destination racks -- *)
	(* If AliquotContainer is specified, take aliquotContainer, otherwise take containerIn *)
	aliquotContainers=Lookup[replicatedOptions,AliquotContainer];
	transferContainers=MapThread[If[!MatchQ[#1,Null],#1,#2]&,{aliquotContainers,sampleContainers}];
	(*Get rid of any nested lists and none objects*)
	transferContainersClean=FirstCase[Flatten[ToList[#]],ObjectP[]]&/@transferContainers;
	(*Get model if object*)
	transferContainersModel=If[MatchQ[#,ObjectP[Object[Container]]],fetchPacketFromCache[#,cache][Model][Object],#]&/@transferContainersClean;
	(*we don't need a one unque desitnation rack per container as the container only sits with the rack during transfer*)
	transferContainerModelDeDup=DeleteDuplicates[transferContainersModel]/.x:LinkP[]:>x[Object];
	transferRackDeDup=ToList[RackFinder[transferContainerModelDeDup]];

	transferRackResourcesDeDup=If[MatchQ[#,ObjectP[Model[Container,Rack]]],Link[Resource[Sample->#,Name->ToString[Unique[]]]],Null]&/@transferRackDeDup;

	(*Replace each ContainerModel with resources*)
	rackReplacementRules=If[
		!MatchQ[transferRackResourcesDeDup,{}],
			AssociationThread[transferContainerModelDeDup,transferRackResourcesDeDup]//Normal,
			AssociationThread[transferContainerModelDeDup,ConstantArray[Null,Length[transferContainerModelDeDup]]]//Normal
	];

	racks=transferContainersModel/.rackReplacementRules;

	(* -- Make resources for robotic titration instrument -- *)
	titrationMethods = Lookup[replicatedOptions, TitrationMethod];
	(*Find the index positions of each titration method *)
	manualTitrationPositions = Flatten@Position[titrationMethods, Manual];
	roboticTitrationPositions = Flatten@Position[titrationMethods, Robotic];

	(* resource pick pH titrator if needed *)
	(* If TitrationInstrument object is specified, use that object for all the same model. *)
	titrationInstrumentAssociation = If[MemberQ[titrationInstruments, ObjectP[Object[Instrument, pHTitrator]]],
		Module[{titrationInstrumentObject, titrationInstrumentPacket},
			(*We currently only have one pHTitrator model *)
			titrationInstrumentObject=FirstCase[titrationInstruments, ObjectP[Object[Instrument, pHTitrator]]];
			titrationInstrumentPacket = fetchPacketFromCache[titrationInstrumentObject, titrationInstrumentPackets];
			<|Download[Lookup[titrationInstrumentPacket, Model], Object] -> titrationInstrumentObject|>
		],
		<||>
	];
	titrationInstrumentsUpdated = Download[titrationInstruments,Object]/.titrationInstrumentAssociation;

	(* Create a little lookup for titrationInstruments *)
	titrationInstrumentCounts = Tally[DeleteCases[titrationInstrumentsUpdated, Null]];
	uniqueTitrationInstruments = titrationInstrumentCounts[[All, 1]];
	titrationInstrumentResourceLookup = If[Length[uniqueTitrationInstruments]>0,
		Association@@MapThread[
			#1->Link[Resource[Instrument -> #1 , Time -> #2 * 90 Minute, Name->ToString[Unique[]]]]&,
			Transpose[titrationInstrumentCounts]],
		<||>
	];
	titrationInstrumentsResourcified=Lookup[titrationInstrumentResourceLookup,#, Null]&/@titrationInstrumentsUpdated;

	(* -- Figure out how much of each acid, base to request -- *)
	(* Combine requests because we want to use the same sample for fixed additions and titration when possible *)

	(* Lookup specified options *)
	{fixedAdditionRequests,titratingAcid,titratingBase}=Lookup[replicatedOptions,{FixedAdditions,TitratingAcid,TitratingBase}];

	(* - Calculate the amount of volume that we should ask for for each of the pHing acids/bases - *)
	(* the maximum amount needed for any acid or base for one replicate is the MaxAdditionVolume. If TitrationMethod is Manual, add 10% margin; if Robotic, add 5 Milliliter more as prime volume for titrating acid and base*)
	maxAdditionVolumeWithMargin= MapThread[
		If[MatchQ[#1, Robotic],
			#2 + 5 Milliliter,
			#2 * 1.1
		]&,
		Lookup[replicatedOptions,{TitrationMethod, MaxAdditionVolume}]
	];

	(* For any titration requests set-up to indicate we need the MaxAdditionVolume of the volume of the sample *)
	titrantVolumeTuples=MapThread[
		Which[
			MatchQ[{#2,#3},{Null,Null}],
			Nothing,
			True,
			{{#1,#2},{#1,#3}}
		]&,
		{maxAdditionVolumeWithMargin,titratingAcid,titratingBase}
	];

	(* Turn the requests for each sample into an association, the merge the associations totaling up the values for any repeat keys *)
	(* This tells us how much of each model we need *)
	reagentSums=Merge[
		Map[
			Function[request,
				Association[(Download[request[[2]],Object]->request[[1]])]
			],
			Cases[Join[Flatten[fixedAdditionRequests,1],Flatten[titrantVolumeTuples,1]],Except[Null|None]]
		],
		Total
	];

	roboticUniqueTitrant = DeleteDuplicates[Join[titratingAcid[[roboticTitrationPositions]], titratingBase[[roboticTitrationPositions]]]];
	(* Make a lookup so we can link each sample to a resource for it *)

	uniqueReagentResources=KeyValueMap[
		(* If this reagent will be used for robotic titration using pHTitrator, we pick the stocked inventory in 1 L Glass Bottle *)
		(* In pHTitrator, we need 100 Milliliter dead volume *)
		If[MemberQ[roboticUniqueTitrant, #1],
			#1->Link[Resource[Sample->#1,Amount->(#2 + 100 Milliliter),Container->Model[Container, Vessel, "id:zGj91aR3ddXJ"],Name->ToString[Unique[]]]], (*Model[Container, Vessel, "1L Glass Bottle"]*)
			#1->Link[Resource[Sample->#1,Amount->#2,Container->PreferredContainer[#2],Name->ToString[Unique[]]]]
		]&,
		reagentSums
	];

	(* Replace model/sample requests for acid/base with resources for those requests *)
	titratingBaseResources=Download[titratingBase,Object]/.uniqueReagentResources;
	titratingAcidResources=Download[titratingAcid,Object]/.uniqueReagentResources;

	(* Replace model/sample requests for fixed additions with resources for those requests *)
	(* We are filling up FixedAdditionSamples here, which are only the resources needed for FixedAdditions. We don't need to preserve the shape of FixedAdditions. FixedAdditions is a multiple-multiple so we cannot do links. Models will be converted to Objects "manually" in compiler *)
	(* We want to get all of the ObjectPs in the resolved FixedAdditions and replace them with resources*)
	fixedAdditionRequestsFlattened=fixedAdditionRequests//Flatten;
	(* Extract objects, make sure the id form is used with Download, and DeleteDuplicates *)
	fixedAdditionRequestsObjectsDeDup=Map[#[Object]&,Cases[fixedAdditionRequestsFlattened,ObjectP[]]]//DeleteDuplicates;
	fixedAdditionSamples=fixedAdditionRequestsObjectsDeDup/.uniqueReagentResources;

	(*Make resources for calibration buffers*)
	lowCalibrationBufferResource=Resource[Sample->Model[Sample, "id:BYDOjvGjGxGr"],Amount->20 Milliliter,Name->"Low Calibration Buffer"];
	mediumCalibrationBufferResource=Resource[Sample->Model[Sample, "id:vXl9j57j7OVd"],Amount->20 Milliliter,Name->"Medium Calibration Buffer"];
	highCalibrationBufferResource=Resource[Sample->Model[Sample, "id:n0k9mG8m8dMn"],Amount->20 Milliliter,Name->"High Calibration Buffer"];

	(* ContainersOut resources resolution *)
	(* Pre-expand ContainerOut *)
	resolvedContainersOut=Lookup[resolvedOptions,ContainerOut];
	containersOutResources=Switch[#,
		ObjectP[Object[Container,Vessel]],Link[Resource[Sample->#,Name->ToString[Unique[]]],Protocols],
		ObjectP[Model[Container,Vessel]],Link[Resource[Sample->#,Name->ToString[Unique[]]]],
		_,Null
	]&/@resolvedContainersOut;
	(* expand the same container NoR times to make sure they are NoR working samples are combined into the same container*)
	containersOutResourcesExpanded=ConstantArray[containersOutResources,numberOfReplicates]//Transpose//Flatten;

	(* WashSolutionResource *)
	(* We only allow Model[Sample,"Milli-Q water"] as WashSolution at the moment. *)
	washSolution=Model[Sample,"Milli-Q water"];
	washSolutionResource=Link[Resource[Sample->washSolution,Amount->400 Milliliter,Container->Model[Container, Vessel, "id:R8e1PjRDbbOv"],RentContainer->True]
	];

	(*Go through the rest instruments.*)
	(*If Mixer is overhead stirrer, convert to resource because we need to set it up. If not, keep as Model as Incubate will pick resource.*)
	allMixInstruments=Lookup[replicatedOptions,pHMixInstrument];
	mixInstrumentResourceLookup=Association@@MapThread[
		If[MatchQ[#2,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
			#1-> Link[Resource[Instrument->#2, Time->15Minute, Name->ToString[Unique[]]]],
			#1-> Link[#2]]&,
		{replicatedSamples, allMixInstruments}];
	mixInstrumentsResourcified=Lookup[mixInstrumentResourceLookup,#]&/@replicatedSamples;

	impellers=Lookup[replicatedOptions,pHMixImpeller];
	impellerResourceLookup=Association@@MapThread[
		If[MatchQ[#2,ObjectP[]],
			#1 -> Link[Resource[Sample->#2, Name->ToString[Unique[]]]],
			#1-> Link[#2]]&,
		{replicatedSamples,impellers}];
	impellersResources = Lookup[impellerResourceLookup,#]&/@replicatedSamples;

	allpHMeters=Lookup[replicatedOptions,pHMeter];
	pHMeterResourceLookup=Association@@MapThread[
		(* We need to resource pick if titration method is robotic. If titration method is manual, pH meter will be resource picked in MeasurepH *)
		If[MatchQ[#3, Robotic],
			#1-> Link[Resource[Instrument->#2, Time->15Minute, Name->ToString[Unique[]]]],
			#1-> Link[#2]]&,
		{replicatedSamples, allpHMeters, titrationMethods}];
	pHMetersResourcified=Lookup[pHMeterResourceLookup,#]&/@replicatedSamples;

	titrationContainerCaps=Lookup[replicatedOptions,TitrationContainerCap];
	(* TitrationContainerCap is a hidden option and should be resolved to be model *)
	(* We will not batch or reorder sample for re-use same model of titrationContainerCap, we will clean the cap everytime after used*)
	uniqueTitrationContainerCaps = DeleteCases[DeleteDuplicates[titrationContainerCaps], Null];
	titrationContainerCapLookup=If[Length[uniqueTitrationContainerCaps]>0,
		Association@@Map[
			#1->Link[Resource[Sample->#1, Name->ToString[Unique[]]]]&,
			uniqueTitrationContainerCaps],
		<||>
	];
	titrationContainerCapsResources=Lookup[titrationContainerCapLookup,#,Null]&/@titrationContainerCaps;

	(* Batching Parameters *)
	(* Split up our samples into manual titration, robotic titration default and robotic titration customized. *)
	manualTitrationSamples = sampleResources[[manualTitrationPositions]];
	roboticTitrationSamples = sampleResources[[roboticTitrationPositions]];

	replicatedOptionsNoneToNull=replicatedOptions/.None->Null;
	replicatedNominalpHs = Flatten[ConstantArray[#, numberOfReplicates] & /@ nominalpHs];

	{
		batchedTitrationMethods, batchedFixedAdditions, batchedProbeTypes,  batchedAcquisitionTimes, batchedTemperatureCorrections, batchedpHAliquots, batchedpHAliquotVolumes, batchedTitrates, batchedMixWhileTitrating, batchedpHMixTypes, batchedpHMixUntilDissolved, batchedpHMixTimes, batchedMaxpHMixTimes, batchedpHMixDutyCycles, batchedpHMixRates, batchedNumbersOfpHMixes, batchedMaxNumbersOfpHMixes, batchedpHMixVolumes, batchedpHMixTemperatures, batchedMaxpHMixTemperatures, batchedpHHomogenizingAmplitudes, batchedMinpHs, batchedMaxpHs, batchedMaxAdditionVolumes, batchedMaxAcidAmountsPerCycle,batchedMaxBaseAmountsPerCycle, batchedMaxNumbersOfCycles,
		batchedTitrationContainerCaps, batchedpHMeters, batchedProbes, batchedTitrationInstrument,
		batchedNominalpHs, batchedTransferDestinationRacks, batchedTitratingAcids, batchedTitratingBases, batchedpHMixInstruments, batchedpHMixImpellers
	} = Map[Join[#[[manualTitrationPositions]], #[[roboticTitrationPositions]]]&,
		Join[Lookup[replicatedOptionsNoneToNull, {TitrationMethod, FixedAdditions, ProbeType, AcquisitionTime, TemperatureCorrection, pHAliquot, pHAliquotVolume, Titrate, MixWhileTitrating, pHMixType, pHMixUntilDissolved, pHMixTime, MaxpHMixTime, pHMixDutyCycle, pHMixRate, NumberOfpHMixes, MaxNumberOfpHMixes, pHMixVolume, pHMixTemperature, MaxpHMixTemperature, pHHomogenizingAmplitude, MinpH, MaxpH, MaxAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle, MaxNumberOfCycles}],
			{titrationContainerCapsResources, pHMetersResourcified, Link[Lookup[replicatedOptionsNoneToNull, Probe]], titrationInstrumentsResourcified,
				replicatedNominalpHs, racks, titratingAcidResources, titratingBaseResources, mixInstrumentsResourcified, impellersResources}]];

	(*get batchLengths for the batching based on the number of samples for each titration method *)
	batchLengths = Cases[{Length[manualTitrationSamples], Length[roboticTitrationSamples]}, GreaterP[0]];

	resolvedBatchingParameters = MapThread[
		Function[{titrationMethod, fixedAddition, probeType, acquisitionTime, temperatureCorrection, aliquotpH, aliquotVolumepH, titrate, mixWhileTitratingpH, mixType, mixUntilDissolvedpH, mixTime, maxpHMixTime, mixDutyCycle, mixRate, numbersOfpHMix, maxNumbersOfpHMix, mixVolume, mixTemperature, maxpHMixTemperature, homogenizingAmplitude, minpH, maxpH, maxAdditionVolume,maxAcidAmountPerCycle, maxBaseAmountPerCycle, maxNumbersOfCycle, pHMeterInstrument, probe, nominalpH, transferDestinationRack, titratingAcid, titratingBase, mixInstrument, mixImpeller, titrationInstrument, titrationContainerCap},
			<|
				TitrationMethod -> titrationMethod,
				FixedAddition -> fixedAddition,
				ProbeType -> probeType,
				AcquisitionTime->acquisitionTime,
				TemperatureCorrection->temperatureCorrection,
				pHAliquot->aliquotpH,
				pHAliquotVolume->aliquotVolumepH,
				Titrate->titrate,
				MixWhileTitrating->mixWhileTitratingpH,
				pHMixType->mixType,
				MixUntilDissolved->mixUntilDissolvedpH,
				pHMixTime->mixTime,
				MaxpHMixTime->maxpHMixTime,
				pHMixDutyCycle->mixDutyCycle,
				pHMixRate->mixRate,
				NumberOfpHMixes->numbersOfpHMix,
				MaxNumberOfpHMixes->maxNumbersOfpHMix,
				pHMixVolume->mixVolume,
				pHMixTemperature->mixTemperature,
				MaxpHMixTemperature->maxpHMixTemperature,
				pHHomogenizingAmplitude->homogenizingAmplitude,
				MinpH->minpH,
				MaxpH->maxpH,
				MaxAdditionVolume->maxAdditionVolume,
				MaxAcidAmountPerCycle -> maxAcidAmountPerCycle,
				MaxBaseAmountPerCycle -> maxBaseAmountPerCycle,
				MaxNumberOfCycles->maxNumbersOfCycle,
				pHMeter->pHMeterInstrument,
				Probe->probe,
				NominalpH->nominalpH,
				TransferDestinationRack->transferDestinationRack,
				TitratingAcid->titratingAcid,
				TitratingBase->titratingBase,
				pHMixInstrument->mixInstrument,
				pHMixImpeller->mixImpeller,
				TitrationInstrument -> titrationInstrument,
				TitrationContainerCap -> titrationContainerCap
			|>
		],
		{
			batchedTitrationMethods, batchedFixedAdditions, batchedProbeTypes, batchedAcquisitionTimes, batchedTemperatureCorrections, batchedpHAliquots, batchedpHAliquotVolumes, batchedTitrates, batchedMixWhileTitrating, batchedpHMixTypes, batchedpHMixUntilDissolved, batchedpHMixTimes, batchedMaxpHMixTimes, batchedpHMixDutyCycles, batchedpHMixRates, batchedNumbersOfpHMixes, batchedMaxNumbersOfpHMixes, batchedpHMixVolumes, batchedpHMixTemperatures, batchedMaxpHMixTemperatures, batchedpHHomogenizingAmplitudes, batchedMinpHs, batchedMaxpHs, batchedMaxAdditionVolumes,batchedMaxAcidAmountsPerCycle,batchedMaxBaseAmountsPerCycle, batchedMaxNumbersOfCycles, batchedpHMeters, batchedProbes, batchedNominalpHs, batchedTransferDestinationRacks, batchedTitratingAcids, batchedTitratingBases, batchedpHMixInstruments, batchedpHMixImpellers, batchedTitrationInstrument, batchedTitrationContainerCaps
		}
	];

	(* - Calculate timings for checkpoints - *)
	resourceTime=Length[containerResources]*Length[uniqueReagentResources];

	(* Actual prep time will come when subprotocols are created *)
	prepTime=1 Minute;

	additionsTime=If[!NullQ[fixedAdditionRequests],Length[Flatten[fixedAdditionRequests,1]]*3 Minute, 0 Minute];
	adjustmentTime=Length[mySamples]*15 Minute;
	postProcessTime=1 Minute;
	storageTime=Length[uniqueReagentResources]*3 Minute;


	protocolPacket=<|
		Type->Object[Protocol,AdjustpH],
		Object->protocolID,
		Replace[ContainersIn]->containerResources,
		Replace[SamplesIn]->sampleResources,
		NumberOfReplicates->If[numberOfReplicates===1,Null,numberOfReplicates],

		UnresolvedOptions->templatedOptions,
		ResolvedOptions->resolvedOptions,

		Name->Lookup[replicatedOptionsNoneToNull,Name],

		Replace[Checkpoints]->{
			{"Preparing Samples", prepTime,"Preprocessing, such as mixing, centrifuging, thermal incubation, and aliquoting, is performed.",
				Link[Resource[Operator->$BaselineOperator,Time->45 Minute]]
			},
			{"Fixed Additions", additionsTime,"Set amounts of samples are added before titration.",
				Link[Resource[Operator->$BaselineOperator,Time->additionsTime]]
			},
			{"Adjusting pH", adjustmentTime,"Acid or base is added incrementally, mixing as specified until the desired pHs are reached.",
				Link[Resource[Operator->$BaselineOperator,Time->adjustmentTime]]
			},
			{"Sample Post-Processing", postProcessTime,"Any measuring of volume, weight, or sample imaging post experiment is performed.",
				Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]
			},
			{"Returning Materials", storageTime,"Samples are returned to storage.",
				Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]
			}
		},


		Replace[FixedAdditionSamples]->fixedAdditionSamples,

		Replace[ContainersOut]->containersOutResourcesExpanded,

		Replace[Titrates]->Lookup[replicatedOptionsNoneToNull,Titrate],

		Replace[TitratingBases]->titratingBaseResources,

		Replace[TitratingAcids]->titratingAcidResources,

		Replace[MaxAdditionVolumes]->Lookup[replicatedOptionsNoneToNull,MaxAdditionVolume],

		Replace[AcquisitionTimes]->Lookup[replicatedOptionsNoneToNull,AcquisitionTime],

		(* No links since this would need multiple multiples to link properly *)
		(* In Protocol object we use Nulls instead of Nones *)
		Replace[FixedAdditions]->Lookup[replicatedOptionsNoneToNull,FixedAdditions],

		Replace[HistoricalData]->Link[Lookup[replicatedOptionsNoneToNull,HistoricalData]],

		Replace[MaxpHs]->Lookup[replicatedOptionsNoneToNull,MaxpH],

		Replace[MinpHs]->Lookup[replicatedOptionsNoneToNull,MinpH],

		Replace[MaxpHMixTemperatures]->Lookup[replicatedOptionsNoneToNull,MaxpHMixTemperature],

		Replace[MaxpHMixTimes]->Lookup[replicatedOptionsNoneToNull,MaxpHMixTime],

		Replace[MaxNumbersOfCycles]->Lookup[replicatedOptionsNoneToNull,MaxNumberOfCycles],

		Replace[MaxNumbersOfpHMixes]->Lookup[replicatedOptionsNoneToNull,MaxNumberOfpHMixes],

		Replace[pHHomogenizingAmplitudes]->Lookup[replicatedOptionsNoneToNull,pHHomogenizingAmplitude],

		Replace[pHMixDutyCycles]->Lookup[replicatedOptionsNoneToNull,pHMixDutyCycle],

		(* Make resources only for overhead stirrers as we need to set them up in the main function *)
		Replace[pHMixInstruments]->mixInstrumentsResourcified,

		Replace[pHMixImpellers]->impellersResources,

		Replace[pHMixRates]->Lookup[replicatedOptionsNoneToNull,pHMixRate],

		Replace[pHMixTemperatures]->Lookup[replicatedOptionsNoneToNull,pHMixTemperature],

		Replace[pHMixTimes]->Lookup[replicatedOptionsNoneToNull,pHMixTime],

		Replace[pHMixTypes]->Lookup[replicatedOptionsNoneToNull,pHMixType],

		Replace[pHMixUntilDissolved]->Lookup[replicatedOptionsNoneToNull,pHMixUntilDissolved],

		Replace[pHMixVolumes]->Lookup[replicatedOptionsNoneToNull,pHMixVolume],

		Replace[MixWhileTitrating]->Lookup[replicatedOptionsNoneToNull,MixWhileTitrating],

		Replace[pHHomogenizingAmplitudes]->Lookup[replicatedOptionsNoneToNull,pHHomogenizingAmplitude],

		Replace[NominalpHs]->nominalpHs,

		Replace[NumbersOfpHMixes]->Lookup[replicatedOptionsNoneToNull,NumberOfpHMixes],

		Replace[pHAliquots]->Lookup[replicatedOptionsNoneToNull,pHAliquot],

		Replace[pHAliquotVolumes]->Lookup[replicatedOptionsNoneToNull,pHAliquotVolume],

		Replace[pHMeters]-> pHMetersResourcified,

		LowCalibrationBuffer->Link[lowCalibrationBufferResource],

		MediumCalibrationBuffer->Link[mediumCalibrationBufferResource],

		HighCalibrationBuffer->Link[highCalibrationBufferResource],

		(* fill waste beaker with some water to dilute base/acid *)
		WasteBeaker -> Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 200 Milliliter, Container -> Model[Container, Vessel, "id:O81aEB4kJJJo"], RentContainer -> True],

		AcidPrimeVolume -> 10 Milliliter,

		BasePrimeVolume -> 10 Milliliter,

		MaxpHSlope -> Lookup[replicatedOptionsNoneToNull,MaxpHSlope],

		MinpHSlope -> Lookup[replicatedOptionsNoneToNull,MinpHSlope],

		MinpHOffset -> Lookup[replicatedOptionsNoneToNull,MinpHOffset],

		MaxpHOffset -> Lookup[replicatedOptionsNoneToNull,MaxpHOffset],

		Replace[Probes]->Link[Lookup[replicatedOptionsNoneToNull,Probe]],

		Replace[ProbeTypes]->Lookup[replicatedOptionsNoneToNull,ProbeType],

		Replace[RecoupSample]->Lookup[replicatedOptionsNoneToNull,RecoupSample],

		Replace[TemperatureCorrections]->Lookup[replicatedOptionsNoneToNull,TemperatureCorrection],

		Replace[pHsAchieved]->ConstantArray[Null,Length[sampleResources]],

		WashSolution->Link[washSolutionResource],

		KeepInstruments->Lookup[replicatedOptionsNoneToNull, KeepInstruments],

		Replace[ModelsOut]->Link[Lookup[replicatedOptionsNoneToNull, ModelOut]],

		Replace[NonBuffered]->Lookup[replicatedOptionsNoneToNull, NonBuffered],

		Replace[TransferDestinationRacks]->racks,

		Replace[MaxAcidAmountsPerCycle]-> Lookup[replicatedOptionsNoneToNull,MaxAcidAmountPerCycle],

		Replace[MaxBaseAmountsPerCycle]-> Lookup[replicatedOptionsNoneToNull,MaxBaseAmountPerCycle],

		Replace[TitrationMethods] -> Lookup[replicatedOptionsNoneToNull,TitrationMethod],

		Replace[TitrationInstruments] -> titrationInstrumentsResourcified,

		Replace[TitrationContainerCaps] -> titrationContainerCapsResources,

		Replace[BatchLengths] -> batchLengths,
		Replace[BatchingParameters] -> resolvedBatchingParameters,

		Replace[ManualTitrationIndices] -> manualTitrationPositions,
		Replace[RoboticTitrationIndices] -> roboticTitrationPositions
	|>;

	(* Populate prep fields - send in initial samples and options since this handles NumberOfReplicates on its own *)
	prepPacket=populateSamplePrepFields[mySamples,resolvedOptions,Cache->cache,Simulation->simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[protocolPacket,prepPacket];

	(* -- Validate Resources -- *)

	(* get all the resource "symbolic representations" *)

	(*Mix Instruments*)
	(*We only actually pick overhead stirrers in the main function. other resources are for FRQ only*)
	allMixInstruments=Lookup[replicatedOptions,pHMixInstrument];
	allMixInstrumentsNoStir=DeleteCases[Lookup[replicatedOptions,pHMixInstrument]//DeleteDuplicates,Alternatives[ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}],Null]];
	allMixInstrumentsNoStirResources=Map[Link[Resource[Instrument->#, Time->15Minute]]&,allMixInstrumentsNoStir];
	mixInstrumentReplacementRules=Normal[AssociationThread[allMixInstrumentsNoStir->allMixInstrumentsNoStirResources]];
	mixInstrumentsResources=allMixInstruments/.mixInstrumentReplacementRules;


	(*pHing Instruments*)
	(*We don't pick pHMeters in the main function. The resources is for FRQ only*)
	phMeters=Lookup[replicatedOptions,pHMeter];
	phMetersDeDup=phMeters//DeleteDuplicates;
	phMetersResourcesDeDup=Map[If[MatchQ[#,ObjectP[{Model[Instrument,pHMeter],Object[Instrument,pHMeter]}]],Link[Resource[Instrument->#, Time->30Minute]],Null]&,phMetersDeDup];
	phMetersReplacementRules=Normal[AssociationThread[phMetersDeDup->phMetersResourcesDeDup]];
	phInstrumentsResources=phMeters/.phMetersReplacementRules;

	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	resources=DeleteDuplicates[Cases[Flatten[{Values[finalizedPacket],mixInstrumentsResources,phInstrumentsResources}],_Resource,Infinity]];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTestsQ,
		Resources`Private`fulfillableResourceQ[resources,Output->{Result,Tests},Site->Lookup[resolvedOptions,Site],Cache->cache,Simulation->simulation],
		True,
		{Resources`Private`fulfillableResourceQ[resources,Cache->cache,Site->Lookup[resolvedOptions,Site],Simulation->simulation],{}}
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->If[resourcesOk,
			finalizedPacket,
			$Failed
		],
		Tests->resourceTests
	}
];


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentAdjustpH,
	Options:>{CacheOption,SimulationOption}
];

simulateExperimentAdjustpH[
	myResourcePacket:(PacketP[Object[Protocol, AdjustpH], {Object, ResolvedOptions}]|$Failed),
	mySamples:{(ObjectP[{Object[Sample], Model[Sample], Object[Container]}]|{_Integer,ObjectP[Model[Container]]}|{Alternatives@@Flatten[AllWells[]],ObjectP[Object[Container]]})..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentAdjustpH]
]:=Module[
	{
		cache,simulation,protocolObject,mapThreadFriendlyOptions,currentSimulation,samplePackets,protocolPacket,
		simulatedFixedAdditionSamplePakcets,fixedAdditions,titratingAcidVolumes,titratingBsesVolumes,modelsOut,titratingAcids,
		titratingBases,maxAdditionVolumes,calibrants,nominalpHs,fixedAdditionModelToSampleReplacementTable,fixedAdditionsObjectified,
		fixedAdditionTransferPackets,titrantToMaxAdditionVolumeRules,titrantToMaxAdditionVolumeMergedAssoc,titrantToInitialVolumeRules,
		titrantToInitialVolumeMergedAssoc,allTitrantsDeDup,allTitrantsDeDupUpdatedVolumes,numberOfTitrants,titrantsVolumeUpdatePackets,
		samplespHUpdatePackets,currentSamplePackets,samplesModelUpdatePackets,discardReagentUpdatePacktes,simulationWithLabels,
		fixedAdditionsObjectifiedNoLink,protocolPacketFixedAdditionObjectified,sampleContainers,fixedAdditionSamples
	},

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=If[MatchQ[myResourcePacket, $Failed],
		SimulateCreateID[Object[Protocol,AdjustpH]],
		Lookup[myResourcePacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentAdjustpH,
		myResolvedOptions
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=If[MatchQ[myResourcePacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],
		SimulateResources[
			myResourcePacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	(* Download information from our simulated resources. *)


	{
		protocolPacket,
		simulatedFixedAdditionSamplePakcets,
		fixedAdditions,
		titratingAcidVolumes,
		titratingBsesVolumes,
		sampleContainers
	}=Quiet[
		Download[
			protocolObject,
			{
				Packet[TitratingAcids,TitratingBases,FixedAdditions,FixedAdditionSamples,LowCalibrationBuffer,MediumCalibrationBuffer,HighCalibrationBuffer,MaxAdditionVolumes,NominalpHs,ModelsOut],
				Packet[FixedAdditionSamples[Model]],
				FixedAdditions,
				TitratingAcids[Volume],
				TitratingBases[Volume],
				SamplesIn[Containers]
			},
			Cache->cache,
			Simulation->currentSimulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	]/.x:LinkP[]:>x[Object];

	(*get our desired values from protocolPacket upfront*)
	titratingAcids=Lookup[protocolPacket,TitratingAcids];
	titratingBases=Lookup[protocolPacket,TitratingBases];
	fixedAdditions=Lookup[protocolPacket,FixedAdditions];
	fixedAdditionSamples=Lookup[protocolPacket,FixedAdditionSamples];
	maxAdditionVolumes=Lookup[protocolPacket,MaxAdditionVolumes];
	calibrants=Lookup[protocolPacket,{LowCalibrationBuffer,MediumCalibrationBuffer,HighCalibrationBuffer,WashSolution}];
	nominalpHs=Lookup[protocolPacket,NominalpHs];
	modelsOut=Lookup[protocolPacket,ModelsOut];


	(* Update FixedAdditions with objects from FixedAdditionSamples *)
	fixedAdditionModelToSampleReplacementTable=#[Model]->#[Object]&/@simulatedFixedAdditionSamplePakcets;
	fixedAdditionsObjectified=fixedAdditions/.fixedAdditionModelToSampleReplacementTable;
	(* FixedAdditions is not a Link field so make sure there isn't any link in there *)
	fixedAdditionsObjectifiedNoLink=fixedAdditionsObjectified/.x:LinkP[]:>x[Object];
	protocolPacketFixedAdditionObjectified=<|Object->protocolObject,Replace[FixedAdditions]->fixedAdditionsObjectifiedNoLink|>;

	(* Transfer FixedAdditionSamples into SamplesIn *)
	fixedAdditionTransferPackets=If[MatchQ[fixedAdditions,Null|{}|{Null..}],{},
		Module[{samplesWithFixedAdditions,fixedAdditionsObjectifiedDeNulled,numberOfFixedAdditionsPerSample,fixedAdditionsExpandedSamples},
			samplesWithFixedAdditions=PickList[mySamples,fixedAdditions,Except[Null]];
			fixedAdditionsObjectifiedDeNulled=DeleteCases[fixedAdditionsObjectified,Null];
			numberOfFixedAdditionsPerSample=Length/@fixedAdditionsObjectifiedDeNulled;
			(* Expand SamplesIn for number of fixedaddition number of times as transfer desitinaitons *)
			fixedAdditionsExpandedSamples=MapThread[ConstantArray[#1,#2]&,{samplesWithFixedAdditions,numberOfFixedAdditionsPerSample}];
			(* make the transfers: MapThread on level 2 as FixedAdditions and fixedAdditionsExpanded are nested under each SampleIn *)
			If[MatchQ[samplesWithFixedAdditions,{}],
				{},
				MapThread[
					UploadSampleTransfer[
						#1[[2]],
						#2,
						#1[[1]],
						Upload->False,
						FastTrack->True,
						Simulation->currentSimulation
					]&,
					{fixedAdditionsObjectifiedDeNulled,fixedAdditionsExpandedSamples},
					2
				]
			]
		]
	];

	currentSimulation = UpdateSimulation[currentSimulation, Simulation[Flatten[{protocolPacketFixedAdditionObjectified,fixedAdditionTransferPackets}]]];



	(* Update volumes for titrants-- this might include fixedadditionsamples but ok since we are updating with the lowest possible final volume *)
	titrantToMaxAdditionVolumeRules=MapThread[#1->#2&,{Flatten[{titratingAcids,titratingBases}],Flatten[{maxAdditionVolumes,maxAdditionVolumes}]}];
	titrantToMaxAdditionVolumeMergedAssoc=Merge[titrantToMaxAdditionVolumeRules,Total];

	titrantToInitialVolumeRules=MapThread[#1->#2&,{Flatten[{titratingAcids,titratingBases}],Flatten[{titratingAcidVolumes,titratingBsesVolumes}]}];
	titrantToInitialVolumeMergedAssoc=Merge[titrantToInitialVolumeRules,Total];

	allTitrantsDeDup=Keys[titrantToInitialVolumeMergedAssoc];
	allTitrantsDeDupUpdatedVolumes=(titrantToInitialVolumeMergedAssoc[#]-titrantToMaxAdditionVolumeMergedAssoc[#])&/@allTitrantsDeDup;

	(*Update the volume and status*)
	numberOfTitrants=Length[allTitrantsDeDup];

	titrantsVolumeUpdatePackets=UploadSampleProperties[allTitrantsDeDup,Volume->allTitrantsDeDupUpdatedVolumes,Upload->False,Simulation->currentSimulation];
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[titrantsVolumeUpdatePackets]];


	(* Update pH for SamplesIn *)
	samplespHUpdatePackets=UploadSampleProperties[mySamples,pH->nominalpHs,Upload->False,Simulation->currentSimulation];
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[samplespHUpdatePackets]];


	(* Update model for SamplesIn *)

	samplesModelUpdatePackets=MapThread[<|Object->#1,Model->Link[#2,Objects]|>&,{mySamples,modelsOut}];
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[samplesModelUpdatePackets]];


	(* Discard calibration buffers and possibly titrants *)
	discardReagentUpdatePacktes=If[MatchQ[modelsOut,ObjectP[Model[Sample,StockSolution]]],
		UploadSampleProperties[DeleteDuplicates[Flatten[{titratingAcids,titratingBases,fixedAdditionSamples,calibrants}]],Discarded,Upload->False,Simulation->currentSimulation];
		UploadSampleProperties[calibrants,Discarded,Upload->False,Simulation->currentSimulation]
	];

	currentSimulation = UpdateSimulation[currentSimulation, Simulation[discardReagentUpdatePacktes]];

	(* We don't do aliquots for premitivies FOR NOW so there won't be aliquots, so there won't be ContainerOut *)

	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], sampleContainers}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
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

(*  == Resolve TitrationMethod options ==  *)
(* ::Subsection::Closed:: *)
DefineOptions[
	findpHTitratorCaps,
	Options:>{
		{Messages->True,BooleanP,"Indicates if messages should be thrown."},
		CacheOption
	}
];
(* helper function to find suitable caps for robotic titration with sample container *)
findpHTitratorCaps[modelContainerPacket : PacketP[], calibrationFunction : (_QuantityFunction|Null), probeModel : (ObjectP[Model[Part, pHProbe]] | Automatic), sampleVolume : VolumeP,  additionVolume : (VolumeP|Null)] := Module[{roboticTitrationCaps, roboticTitrationCapPackets, internalDiameter, internalDepth, coverFootprints, maxVolume, probe, capsCandidates, possibleCaps, additionVolumeTooLargeQ},

	{roboticTitrationCaps, roboticTitrationCapPackets} = capCandidatesInRoboticTitration["Memoization"];

	{internalDiameter, internalDepth, coverFootprints} = Lookup[modelContainerPacket, {InternalDiameter, InternalDepth, CoverFootprints}, Null];

	maxVolume = If[NullQ[calibrationFunction], Lookup[modelContainerPacket, MaxVolume], calibrationFunction[internalDepth]];

	(*If we need to aliquot because of the current sample container is too small, we will return {} as possibleCaps since we won't use the current container anyway *)
	additionVolumeTooLargeQ=(!NullQ[additionVolume]) && MatchQ[additionVolume + sampleVolume, GreaterEqualP[maxVolume]];

	probe = If[MatchQ[probeModel, Automatic],
		Model[Part, pHProbe, "id:jLq9jXvP7jLx"]|Model[Part, pHProbe, "id:J8AY5jDmW5BZ"],
		Download[probeModel, Object]
	];
	capsCandidates = If[MatchQ[internalDiameter, Except[Null]] && MatchQ[internalDepth, Except[Null]] && Length[coverFootprints] > 0,
		Select[roboticTitrationCapPackets,
			Lookup[#, InternalDiameter] <= internalDiameter && Lookup[#, InternalDepth] <= internalDepth &&
       MatchQ[Download[Lookup[#, pHProbe], Object], probe] &&
			 MatchQ[Lookup[#, CoverFootprint], Alternatives[Sequence @@ coverFootprints]] &],
		{}
	];

	possibleCaps = If[Length[capsCandidates] > 0 && (!additionVolumeTooLargeQ)&& (!NullQ[calibrationFunction]),
		Module[{minHeight,minVolume},
			(* Calculate the required min liquid height/volume to reach the probe *)
			minHeight = internalDepth - Lookup[capsCandidates, InternalDepth];
			minVolume = calibrationFunction[#]&/@minHeight;
			PickList[capsCandidates[Object], minVolume, LessP[sampleVolume]]
		],
		{}
	]
];


(* ::Subsection::Closed:: *)
(*preferredRoboticTitrationContainers*)
DefineOptions[
	preferredRoboticTitrationContainers,
	Options:>{
		{Messages->True,BooleanP,"Indicates if messages should be thrown."},
		CacheOption
	}
];


preferredRoboticTitrationContainers[myVolume:GreaterEqualP[0 Milliliter], myProbe:(ObjectP[Model[Part, pHProbe]]|Automatic), myOptions:OptionsPattern[]]:=Module[
	{
		safeOptions,containerCapTuples, probeModel, possibleContainerCapTuples, sortedContainerCapTuples, roboticTitrationContainer, roboticTitrationContainerCap, roboticTitrationProbe
	},

	(* Validate input options *)
	safeOptions=SafeOptions[preferredRoboticTitrationContainers, ToList[myOptions]];
	(*containerModel,capModel,minVolume, maxVolume, containerInternalDepth,containerMaxVolume,CoverFootprint,probeModel,capInternalDepth*)
	containerCapTuples = Experiment`Private`containerTuplesInRoboticTitration["Memoization"];
	probeModel = Which[
		MatchQ[myProbe, Automatic],
		ObjectP[Model[Part, pHProbe, "id:jLq9jXvP7jLx"]]|ObjectP[Model[Part, pHProbe, "id:J8AY5jDmW5BZ"]], (*Model[Part, pHProbe, "InLab Reach Pro-225"]|Model[Part, pHProbe, "InLab Micro Pro-ISM"]*)
		True,
		ObjectP[myProbe]
	];
	(*containerModel, capModel, minSampleVolume, maxSampleVolume, containerInternalDepth, containerMaxVolume, CoverFootprint, probeModel, capInternalDepth*)
  possibleContainerCapTuples = Cases[containerCapTuples, {_, _, LessP[myVolume], GreaterP[myVolume], _, GreaterP[myVolume], _, probeModel, _}];

	sortedContainerCapTuples = SortBy[possibleContainerCapTuples, (#[[6]] &)];

	{roboticTitrationContainer, roboticTitrationContainerCap, roboticTitrationProbe} = If[Length[sortedContainerCapTuples]>0,
		{
			First[sortedContainerCapTuples][[1]],
			First[sortedContainerCapTuples][[2]],
			If[MatchQ[myProbe, ObjectP[Object[Part, pHProbe]]], myProbe, First[sortedContainerCapTuples][[8]]]
		},
		{Null, Null, Null}
	]
];