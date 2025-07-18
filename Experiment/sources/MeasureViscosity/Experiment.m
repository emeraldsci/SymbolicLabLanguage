(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMeasureViscosity*)


(* ::Subsubsection:: *)
(*ExperimentViscosity Options and Messages*)


DefineOptions[ExperimentMeasureViscosity,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Viscometer,"Rheosense VROC Initium"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument,Viscometer],Object[Instrument,Viscometer]}]
			],
			Description -> "The viscometer that is used to measure the viscosity of the sample. The available instrument measures pressure drops across a rectangular slit in a microlfuid chip as a sample is pumped though to calculate viscosity.",
			Category -> "General"
		},
		{
			OptionName -> AssayType,
			Default -> LowViscosity,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern:> ViscosityAssayTypeP
			],
			Description -> "The general experiment method that will be used to measure the viscosity of the sample. LowViscosity AssayType is intended for samples with viscosities between 0.3 and 150 m*Pa*s. HighViscositiy AssayType is intended for samples with viscositiies between 100 and 1000 m*Pa*s. HighShearRate AssayType will conduct measurements at high shear rates for samples with viscosities between 1 m*Pa*s and 150 m*Pa*s.",
			Category -> "General"
		},
		{
			OptionName -> ViscometerChip,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Part,ViscometerChip],Object[Part,ViscometerChip]}]
			],
			Description -> "The microfluidic device of known dimensionsthat is used to measure the viscosity of sample by flowing the sample through a measurement channel containing pressure sensors.",
			ResolutionDescription -> "LowViscosity AssayType defaults to the B05 chip, HighViscosity AssayType defaults to the C05 chip, HighShearRate defaults to the E02 chip.",
			Category -> "General"
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[2,1]
			],
			Description -> "The number of times each sample will be injected into the viscometer and meausred using the specified MeasurementMethodTable.",
			Category -> "General"
		},
		{
			OptionName -> SampleTemperature,
			Default -> Ambient,
			AllowNull -> False,
			Widget ->Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[4*Celsius, 40*Celsius],
					Units -> Alternatives[Celsius,Fahrenheit,Kelvin]
				]
			],
			Description -> "The temperature of the instrument's autosampler tray where samples are stored while awaiting measurement.",
			Category -> "Autosampler"
		},
		{
			OptionName -> AutosamplerPrePressurization,
			Default -> True,
			AllowNull -> False,
			Widget ->Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the autosampler syringe should inject air into the dead volume of the sample container to help reduce air bubble formation during sample pick-up. If set to True, the autosampler syringe will aspirate air before puncturing the sample container septum and then inject air into the dead volume of the container to increase pressure.",
			Category -> "Autosampler"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* -- Autosampler Options --*)
			{
				OptionName -> InjectionVolume,
				Default -> Automatic,
				AllowNull -> False,
				Widget ->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[EqualP[26*Microliter], EqualP[35*Microliter], EqualP[50*Microliter], EqualP[90*Microliter]]
				],
				Description -> "The volume of sample that is dispensed from the Autosampler syringe into the chip injection syringe for viscosity measurements.",
				ResolutionDescription -> "Defaults to the largest InjectionVolume possible based on the given sample's volume.",
				Category -> "Autosampler"
			},
			(* -- General Measurement Options --*)
			{
				OptionName -> Priming,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the measurement chip's channels will be initially wetted with the sample prior to measurements. Priming is recommended as the first step in a measurement method and prior to measurements at a new MeasurementTemperature. By default, a priming step is included for the Automatic MeasurementMethod, before each new MeasurementTemperature if TemperatureSweep is selected, and for the RelativePressureSweep MeasurementMethod.",
				ResolutionDescription -> "If set as True, this will add a Priming Step at the beginning of each measurement method, and before each new MeasurementTemperature.",
				Category -> "Measurement"
			},
			{
				OptionName -> MeasurementMethod,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ViscosityMeasurementMethodP
				],
				Category -> "Measurement",
				Description -> "Indicates the type of measurement and the subset of parameters that will be determined by the instrument during the measurement. For samples with unknown properties, 'Optimize' may be used. 'Optimize' will run a method that determines the FlowRate (shear rate) that results in a 50% pressure drop across the measurement channel relative to the maximum pressure rating of the selected ViscometerChip. The EquilibrationTime and MeasurementTime are then automatically calculated and the instrument will then make 10 measurements at the optimized FlowRate, equilibrationTime, and MeasurementTime.\nTo conduct a TemperatureSweep, Priming should be set as True, and multiple MeasurementTemperatures should be indicated. Since viscosity is temperature-dependent, the FlowRate should be left as Null to allow the instrument to determine an appropriate value (the FlowRate that results in a pressure drop that is 50% of the maximum pressure rating of the chip) at each MeasurementTemperature.\nShear rate sweeps may be conducted by specifying the flow rates to conduct measurements (FlowRateSweep) or by specifying the relative pressures (RelativePressureSeweep). To conduct a FlowRateSweep, multiple FlowRates should be indicated. Shear rate is calculated using the flow rate and geometry of the channel. To conduct a RelativePressureSweep, multiple RelativePressures (specified as percentages) should be specified. RelativePressures may be specified to ensure that a shear rate sweep is conducted within the dynamic range of the chip.\nSelecting a Custom MeasurementMethod enables any combination of measurement parameters to be selected. If this option is selected, please enter all measurement parameters into the MeasurementMethodTable Option."
			},
			{
				OptionName -> TemperatureStabilityMargin,
				Default -> 0.1 Celsius,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0.1*Celsius],
					Units -> Celsius
				],
				Description -> "Indicates the maximum allowable deviation from the MeasurementTemperature before initiating a measurement.",
				Category -> "Measurement"
			},
			{
				OptionName -> TemperatureStabilityTime,
				Default -> 2 Minute,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0*Second],
					Units -> Alternatives[{Second,{Second,Minute}}]
				],
				Description -> "Indicates the time that the instrument has to be held at the MeasurementTemperature +/- TemperatureStabilityMargin before a measurement step is started.",
				Category -> "Measurement"
			},
			{
				OptionName -> MeasurementTemperature,
				Default -> Ambient,
				AllowNull -> False,
				Widget -> Alternatives[
					Alternatives[
						Widget[
							Type->Enumeration,
							Pattern:>Alternatives[Ambient]
						],
						Widget[
							Type->Quantity,
							Pattern:>RangeP[4*Celsius, 70*Celsius],
							Units->Alternatives[Celsius,Fahrenheit,Kelvin]
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Ambient]
							],
							Widget[
								Type->Quantity,
								Pattern:>RangeP[4*Celsius, 70*Celsius],
								Units->Alternatives[Celsius,Fahrenheit,Kelvin]
							]
						],
					Orientation -> Vertical
					]
				],
				Description -> "Indicates the temperature at which viscosity measurements will be conducted.",
				Category -> "Measurement"
			},
			{
				OptionName -> FlowRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.5 Microliter/Minute, 1200 Microliter/Minute],
						Units -> CompoundUnit[
							{1,{Microliter,{Microliter,Milliliter}}},
							{-1,{Minute,{Minute,Second}}}
						]
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.5 Microliter/Minute, 1200 Microliter/Minute],
							Units -> CompoundUnit[
								{1,{Microliter,{Microliter,Milliliter}}},
								{-1,{Minute,{Minute,Second}}}
							]
						],
						Orientation -> Vertical
					]
				],
				Description -> "Indicates the volumetric rate at which the sample is pumped through the measurement channel of the chip.",
				ResolutionDescription -> "Defaults to Null if MeasurementMethod is 'Automatic' or 'TemperatureSweep'. Defaults to 20 Microliter/Minute if another MeasurementMethod is specified.",
				Category -> "Measurement"
			},
			{
				OptionName -> RelativePressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Percent, 90 Percent],
						Units -> Percent
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Percent, 90 Percent],
							Units -> Percent
						]
					]
				],
				Description -> "Indicates the pressure(s), as a percentage of the chip's maximum pressure, that the instrument should achieve when flowing sample through the measurement channel. The instrument will automatically adjust the flow rate (which directly affects the shear rate) to reach the indicated RelativePressure(s). Specifiying TargetPressures will allow the instrument to optimize FlowRate (ShearRate) settings for shear rate sweeps in a particular chip if the viscosity of the sample is unknown. To use this option, the Priming option must be set to True in order to allow the instrument to sufficiently wet the measurement channel.",
				ResolutionDescription -> "Resolves to Null if MeasurementMethod is 'Optimize', 'TemperatureSweep', or 'Custom'. Resolves to {10 Percent, 25 Percent, 50 Percent, 75 Percent, 90 Percent} if RelativePressureSweep is specified and no FlowRates are specified.",
				Category -> "Measurement"
			},
			{
				OptionName -> EquilibrationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0*Second,10*Minute],
						Units -> Alternatives[{Second, {Minute,Second}}]
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0*Second,60*Minute],
							Units -> Alternatives[{Second, {Minute,Second}}]
						],
						Orientation -> Vertical
					]
				],
				Description -> "Indicates the amount of time during which the instrument is flowing the sample through the measurement channel to develop a steady-state flow profile prior to collecting the data used to determine the average viscosity.",
				ResolutionDescription -> "Defaults to Null if MeasurementMethod is 'Exploratory' or 'TemperatureSweep'. For low-medium viscosity samples, 3 seconds is sufficient. For Flow rates < 10 MicroLiter/Minute, 5-10 seconds is sufficient. For samll volumes of samples with FlowRates > 50 Microliter/Minute, 2 seconds is sufficient. For flow rates > 300 Microliter/Minute, 1 second is sufficient ",
				Category -> "Measurement"
			},
			{
				OptionName -> MeasurementTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0*Second,10*Minute],
						Units -> Alternatives[{Second, {Minute,Second}}]
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0*Second,60*Minute],
							Units -> Alternatives[{Second, {Minute,Second}}]
						],
						Orientation -> Vertical
					]
				],
				Description -> "Indicates the amount of time the instrument flows sample through the measurement channel and collects data that is used to determine the average viscosity.",
				ResolutionDescription -> "Defaults to Null if MeasurementMethod is 'Exploratory' or 'TemperatureSweep'. For FlowRates < 1 MicroLiter/Minute, at least 20 seconds is recommended. For FlowRates > 100 MicroLiter/Minute, 1-2 seconds is sufficient.",
				Category -> "Measurement"
			},
			{
				OptionName -> PauseTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0*Second,10*Minute],
						Units -> Alternatives[{Second, {Minute,Second}}]
				],
				Description -> "Indicates the amount of time that the instrument waits between each measurement step to allow for sample relaxation. For samples with significant thixotropic behavior (requires finite time to obtain an equilibrium viscosity), a PauseTime between 10-20 seconds is recommended.",
				ResolutionDescription -> "Defaults to Null if MeasurementMethod is 'Exploratory' or 0 Second for all other type of MeasurementMethod. For samples with thixotropic (time-dependent shear thinning) behavior, 10-20 seconds is recommended to allow for samples to relax.",
				Category -> "Measurement"
			},
			{
				OptionName -> NumberOfReadings,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0,1]
				],
				Description -> "Indicates the number of times measurements are taken with each set of MeasurementTemperature, FlowRate, EquilibrationTime, and MeasurementTime. Unlike NumberOfReplicates, the instrument will not reinject sample into the measurement chip.",
				ResolutionDescription -> "Defaults to 10 if MeasurementMethod is 'Exploratory'. Otherwise will default to 3 Measurements for all unique sets of MeasurementTemperature, FlowRate, EqulibrationTime, and MeasurementTime, excluding any priming steps.",
				Category -> "Measurement"
			},
			{
				OptionName -> MeasurementMethodTable,
				Default -> Automatic,
				Description -> "The complete list of measurement parameters that will be used to characterize a sample's viscosity for each injection.",
				ResolutionDescription -> "Automatically set from the measurement method options listed above. Any priming steps do not count toward the NumberOfReadings.",
				AllowNull -> False,
				Category -> "Measurement",
				Widget ->
					Adder[
						{
							"Measurement Temperature" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[4 Celsius, 70 Celsius],
									Units -> Alternatives[Celsius,Kelvin,Fahrenheit]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Ambient]
								]
							],
							"Flow Rate" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0.5 Microliter/Minute, 1200 Microliter/Minute],
									Units -> CompoundUnit[
										{1,{Microliter,{Microliter,Milliliter}}},
										{-1,{Minute,{Minute,Second}}}
									]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Null]
								]
							],
							"Relative Pressure" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[2 Percent,90 Percent],
									Units -> Percent
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Null]
								]
							],
							"Equilibration Time" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Second,10*Minute],
									Units -> Alternatives[{Second, {Second,Minute}}]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic,Null]
								]
							],
							"Measurement Time" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Second,10*Minute],
									Units -> Alternatives[{Second, {Second,Minute}}]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic,Null]
								]
							],
							"Pause Time" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Second,10*Minute],
									Units -> Alternatives[{Second, {Minute,Second}}]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic,Null]
								]
							],
							"Priming" -> Widget[
								Type -> Enumeration,
								Pattern :> BooleanP
							],
							"Number of Readings" -> Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[0,1]
							]
						},
						Orientation->Vertical
					]
			},
			{
				OptionName -> RemeasurementAllowed,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sample will be directed to a holding reservoir after a measurement step and be recycled and sent back in the chip for additional measurements if the InjectionVolume is used up before all steps in the MeasurementMethod are completed.",
				Category -> "Measurement"
			},
			{
				OptionName -> RemeasurementReloadVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 88 Microliter],
					Units -> Alternatives[{Microliter,{Microliter, Milliliter}}]
				],
				Description -> "Indicates the volume of the sample that will be drawn from the holding reservoir and pumped back into the syringe for more additional measurements if RemeasurementAllowed is set as True and if the InjectionVolume is used up before the measurement method is completed. A RemeasurementReloadVolume of InjectionVolume-12 Microliter is recommended.",
				ResolutionDescription -> "Defaults InjectionVolume - 12 uL or the indicated ReservoirRetrievalVolume, whichever is lower.",
				Category -> "Measurement"
			},
			{
				OptionName -> RecoupSample,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sample injected into the instrument will be recovered, or alternatively, discarded, at the conclusion of the measurement.",
				Category -> "General"
			},
			{
				OptionName -> RecoupSampleContainerSame,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the recouped sample will be transferred back into the original container or well or a new container or well upon completion of the measurements.",
				ResolutionDescription -> "Defaults to the original sample container or well if RecoupSample is set to True but RecoupSampleContainer is not specified.",
				Category -> "General"
			}
		],
		{
			OptionName -> ResidualIncubation,
			Default -> True,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description->"Indicates if the autosampler tray containing the input samples should remain at the set SampleTemperature at the conclusion of measurements for all samples, until the samples are stored.",
			Category -> "Post Experiment"
		},

		(*-- Cleaning Solvents--*)
		{
			OptionName -> PrimaryBuffer,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
			],
			Description -> "The first solvent that is used to flush the instrument after a sample has been measured and before measuring the next sample. The PrimaryBuffer should be the principle solvent of all samples being measured and is used to dilute out any dissovled components in the samples. Samples should be miscible in the PrimaryBuffer. Standard methods will be used to flush the instrument with the PrimaryBuffer.",
			ResolutionDescription -> "Automatic will resolve to the Model[Sample] in the Sample's Solvent field. If no values are present in the Solvent field, this will default to PBS.",
			Category -> "Cleaning"
		},
		{
			OptionName -> PrimaryBufferStorageCondition,
			Default -> Null,
			AllowNull->True,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Description -> "The non-default conditions under which the PrimaryBuffer of this experiment should be stored after the protocol is completed. If left unset, the PrimaryBuffer will be stored according to their current StorageCondition.",
			Category -> "Post Experiment"
		},
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 200 Microliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum\"]."
			}
		],
		SimulationOption,
		NonBiologyFuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions
	}
];



(* ::Subsubsection:: *)
(*ExperimentMeasureViscosity Errors and Warnings*)
(* Messages thrown before options resolution *)


Error::TooManyViscosityInputs= "In ExperimentMeasureViscosity, the maximum number of input samples for one protocol is 20 if AssayType is LowVicosity OR ViscometerChip model is Model[Part, ViscometerChip, \"Rheosense VROC B05 Viscometer Chip\"]. Otherwise, the maximum number of input samples is 12. Please enter fewer input samples, or queue an additional experiment for the excess input samples.";
Error::ViscosityNoVolume="In ExperimentMeasureViscosity, the following samples `1` do not have their Volume field populated. The Volume of the sample must be known in order to determine if there is enough liquid to perform a viscosity measurement.";
Error::ViscositySolidSampleUnsupported="In ExperimentMeasureViscosity, the following samples `1` are in a solid state and are not compatible with this Experiment. Please use the AssayBuffer or AssayVolume options to add buffer to these samples so that they are compatible with the experiment.";
Error::ViscosityInsufficientVolume="In ExperimentMeasureViscosity, the following samples `1` has insufficient volume for measurement. These samples must have at least 26 uL in order to be measured by the available instrumentation. Please consider utilizing or generating samples with larger volumes to continue.";
Error::ViscosityIncompatibleSample="In ExperimentMeasureViscosity, one or more of the following samples, `1` , is not chemically compatible with the viscometer's wetted materials and would damage it. Please consider working with materials dissovled in different solvents when working with the instrument.";

(* Conflicting options errors *)
Error::ViscosityRemeasurementAllowedConflict="In ExperimentMeasureViscosity, the options RemeasurementAllowed and RemeasurementReloadVolume, `1`, conflict for the following samples `2`. If RemeasurementAllowed is False, the RemeasurementReloadVolume must be Null. If RemeasurementAllowed is True, the RemeasurementReloadVolume cannot be Null.";
Error::ViscosityInjectionVolumeHigh="In ExperimentMeasureViscosity, the InjectionVolume, `1`, with NumberOfReplicates, `2`, is greater the sample's `3` recorded volume. Please provide a sample with a larger volume (at least 26 uL per replicate), decrease the InjectionVolume, or decrease the NumberOfReplicates.";
Error::ViscosityRecoupSampleConflict="In ExperimentMeasureViscosity, the options RecoupSample and RecoupSampleContainerSame, `1`, conflict for the following samples `2`. If RecoupSample is False, the RecoupSampleContainerSame must be Null. If RecoupSamples is True, the RecouopSampleContainerSame cannot be Null.";

Error::ViscosityUnsupportedInjectionVolume="In ExperimentMeasureViscosity, the resolved InjectionVolume, `1` for sample `2`, is incompatible with the sample's container. The sample must be aliquoted into a container of type Model[Container,Vessel, 1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum], but there is not enough sample volume to perform the injection after the aliquot (which has a 10 uL dead volume). Please select a sample with higher sample volume.";
Warning::ViscosityPrimingFalse = "In ExperimentMeasureViscosity, Priming is False for sample(s) `1`. Priming is highly recommended to initially wet the measurement chip and before measuring at each new MeasurementTemperature.";
Error::ViscosityCustomMeasurementMethodConflicts = "In ExperimentMeasureViscosity, the following provided options: `1`, for sample `2` conflict. In order to specify the measurement parameters for a Custom MeasurementMethod, please input all parameters in the MeasurementMethodTable option only and leave the parameters for the other options (MeasurementTemperature, FlowRate,EquilibrationTime,MeasurementTime, PauseTime, and NumberOfReadings) as Automatic or Null.";
Warning::ViscosityCustomMeasurementTableNotProvided="In ExperimentMeasureViscosity,the MeasurementMethod is specified as Custom, but no custom measurement parameters are provided in the MeasurementMethodTable. Please input the desired measurement parameters or choose another MeasurementMethod.";
Error::ViscosityExploratoryTemperatureSweepParameterError ="In ExperimentMeasureViscosity, the specified MeasurementMethod, `1`, conflicts with one or more of the provided options: `2`, for sample `3`. In order to use this MeasurementMethod, FlowRate, EquilibrationTime, and MeasurementTime, should be left as Automatic or Null (these will be determined by the instrument during the measurement), Priming should be True, and MeasurementMethodTable should be left as Automatic. If you wish to specify any of these parameters, please set MeasurementMethod as ShearRateSweep or Custom.";
Error::ViscosityFlowRateEquilibrationTimeMeasurementTimeError="In ExperimentMeasureViscosity, one or more of the specified values `1`, conflict for sample(s), `2`. The length of the list of any values provided for FlowRate, EquilibrationTime, and MeasurementTime must be equal. These options also cannot be Null if any values are specified for FlowRate, EquilibrationTime, and MeasurementTime. Please make sure the same number of values are provided for each of these options, or leave the other options as Automatic";
Error::ViscosityFlowRateSweepParameterError="In ExperimentMeasureViscosity, one or more of the specified options:, `1`, for sample `2` conflict. In order to use MeasurementMethod FlowRateSweep, only one MeasurementTemperature should be specified and MeasurementMethodTable should be left as Automatic. If you wish to specify more than one MeasurementTemperature in addition to more than one FlowRate, please set MeasurementMethod as Custom.";
Error::ViscosityPressureSweepParameterError="In ExperimentMeasureViscosity, one or more of the specified options:, `1`, for sample `2` conflict. In order to use MeasurementMethod ShearRateSweep, only one MeasurementTemperature should be specified and MeasurementMethodTable, EquilibrationTime, and MeasurementTime should be left as Automatic. If you wish to specify more than one MeasurementTemperature or the EquilibrationTime and MeasurementTime, please set MeasurementMethod as Custom.";
Error::ViscosityTemperatureSweepInsufficientInput="In ExperimentMeasureViscosity, only one MeasurementTemperature, `1` is specified for sample `2`, but the MeasurementMethod was specified as TemperatureSweep. In order to conduct a TempeatureSweep, please provide at least 2 MeasurementTemperatures or set MeasurementTemperature to Automatic.";
Warning::ViscosityFlowRateSweepInsufficientInput="In ExperimentMeasureViscosity, only one FlowRate, `1`, is specified for sample `2`, but the MeasurementMethod was specified as FlowRateSweep. In order to conduct a FlowRateSweep, please provide at least 2 FlowRates or set FlowRate to Automatic.";
Error::ViscosityRemeasurementReloadVolumeHigh="In ExperimentMeasureViscosity, the specified RemeasurementReloadVolume, `1`, for sample `2`, exceeds the InjectionVolume, `3`. Please specify a RemeasurementReloadVolume that is less than the InjectionVolume or set RemeasurementReloadVolume to Automatic.";
Warning::ViscosityNotEnoughSampleInjected ="In ExperimentMeasureViscosity, the calculated total volume required for taking all measurements  for `1` exceeds the resolved InjectionVolume, `2`, and the instrument may not be able to complete all measurement steps. Please specify a larger InjectionVolume or set RemeasurementAllowed to True so that the sample may be recycled and pumped back into the meausrement chip for additional measurements.";
Error::ViscosityTooManyRecoupContainers="In ExperimentMeasureViscosity, the total number of samples and new containers requested for RecoupSample exceeds the number of samples allowed by the instrument rack. Please set RecoupSampleContainerSame as True to place the recouped sample back in the original container or well or specify fewer input samples.";
Error::ViscosityInvalidPrimeMeasurementTable= "In ExperimentMeasureViscosity, the provided MeasurementMethodTable `1` for sample `2` is invalid because of a missing or insufficient priming step. To conduct measurements at specified Relative Pressure, please insert a priming step at 90 Percent Relative Pressure and NumberOfReadings set to 6 (MeasurementTemperature,Null,90Percent,Null,Null,0 Second,True,6) before any RelativePressure. A priming step must be included for RelativePressure measurements at each new MeasurementTemperature.";
Error::ViscosityInvalidFlowRateMeasurementTable= "In ExpeirmentMeasureViscosity, the provided MeasurementMethodTable `1` for sample `2` is invalid because both FlowRate and RelativePressure have non-Null values specified in one or more rows. Since FlowRate and RelativePressure are interdependent, please specify either FlowRate or RelativePressure for each row in the MeasurementTable.";
Warning::ViscosityPressureMeasurementTimeConflict = "In ExperimentMeasureViscosity, the provided MeasurementMethodTable `1` for sample `2` contains one or more measurement steps where RelativePressure and EquilibrationTime and/or MeasurementTime are specified. EquilibrationTime and MeasurementTime are dependent on FlowRate, which will be determined by the instrument at experiment time. In order to allow the instrument determine the optimal EquilibrationTime and MeasurementTime for a given RelativePressure, please set these values to Automatic or Null.";



(* ::Subsubsection:: *)
(*ExperimentMeasureViscosity*)


ExperimentMeasureViscosity[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{listedSamples, listedOptions, cacheOption, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		safeOps, safeOpsTests, validLengths, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, protocolObject, resourcePackets, resourcePacketTests, measureViscosityOptionsAssociation, optionsWithObjects,
		instrumentObjects, modelInstrumentObjects, viscInstrumentModels, allInstrumentModels, potentialContainers, objectSamplePacketFields, modelSamplePacketFields, objectContainerPacketFields,
		modelContainerPacketFields, allSamplePackets, intstrumentModelPacket, instrumentObjectPacket, potentialContainerPacket, potentialContainerFields,
		mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, safeOpsNamed, updatedSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption = ToList[Lookup[listedOptions, Cache, {}]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasureViscosity,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentMeasureViscosity, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentMeasureViscosity, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureViscosity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentMeasureViscosity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureViscosity, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentMeasureViscosity, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentMeasureViscosity, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];
	measureViscosityOptionsAssociation = Association[expandedSafeOps];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Any options whose values could be an object *)
	optionsWithObjects = {
		Instrument,
		ViscometerChip,
		PrimaryBuffer
	};

	instrumentObjects = Cases[Lookup[expandedSafeOps, optionsWithObjects], ObjectP[Object[Instrument, Viscometer]]];
	modelInstrumentObjects = Cases[Lookup[expandedSafeOps, optionsWithObjects], ObjectP[Model[Instrument, Viscometer]]];
	viscInstrumentModels = Search[Model[Instrument, Viscometer]];
	allInstrumentModels = Join[modelInstrumentObjects, viscInstrumentModels];

	(*Note: the Rheosense Initium viscometer can only be calibrated for one Model of autosample vial and 96-well plate at any one time.
		Currently, the autosampler is calibrated for the following containers. If you want to use a different container, the autosampler MUST be
 		re-calibrated to account for differences in the distance to the bottom of the container. *)
	potentialContainers = {Model[Container, Plate, "96-well PCR Plate"], Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]};


	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields = Packet[
		(*For sample prep*)
		Sequence @@ SamplePreparationCacheFields[Object[Sample]],
		(* For Experiment *)
		Density, RequestedResources, Notebook, Status, Model, Container, State, Density, Volume, Composition, Solvent, IncompatibleMaterials, Status, Model, Container, State, Density, Volume, Composition, Solvent, IncompatibleMaterials,
		(*Safety and transport, previously from model*)
		Ventilated, TransportTemperature, BoilingPoint
	];

	modelSamplePacketFields = Packet[Model[{
		(*For sample prep*)
		Sequence @@ SamplePreparationCacheFields[Model[Sample]],
		(* For Experiment *)
		Density, Notebook
	}]];

	objectContainerPacketFields = SamplePreparationCacheFields[Object[Container]];

	modelContainerPacketFields = Packet[Container[Model][{
		(*For sample prep*)
		Sequence @@ SamplePreparationCacheFields[Model[Container]],
		(* Experiment required *)
		NumberOfWells, WellDimensions, WellDiameter, WellDepth, MaxVolume, Name, DefaultStorageCondition
	}]];

	potentialContainerFields = Packet @@ SamplePreparationCacheFields[Model[Container]];

	{
		allSamplePackets,
		intstrumentModelPacket,
		instrumentObjectPacket,
		potentialContainerPacket
	} = Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				instrumentObjects,
				allInstrumentModels,
				potentialContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerPacketFields]],
					modelContainerPacketFields,

					Packet[Model, Status, Container, Well, Volume, Composition, IncompatibleMaterials, Solvent, Density],
					Packet[Container[Model][{MaxVolume, NumberOfWells, Name}]],

					(*Mode*)
					Packet[Container[{Object, Model, Contents, Name, Status, Sterile}]],
					(* Model Composition *)
					Packet[Composition[[All, 2]][{State, Density, Concentration, MolecularWeight}]],
					Packet[Model[{IncompatibleMaterials, Composition, Name, Solvent, Density, State, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, SolidUnitWeight, Products, Dimensions, TransportTemperature, MolecularWeight}]]
				},
				{    (*Model[Instrument]*)
					Packet[Model[{Object, Name, WettedMaterials, InjectionVolumes, MinSampleVolume}]]
				},
				{    (*Object[Instrument]*)
					Packet[Object, Name, Status, Model, WettedMaterials, MinSampleVolume, InjectionVolumes],
					(*Get the model information*)
					Packet[Model[{Object, Name, WettedMaterials, InjectionVolumes, MinSampleVolume}]]
				},

				{ (*Potential Containers*)
					potentialContainerFields
				}
			},
			Cache -> cacheOption,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	cacheBall = FlattenCachePackets[{
		cacheOption, allSamplePackets, intstrumentModelPacket, instrumentObjectPacket, potentialContainerPacket
	}];
	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentMeasureViscosityOptions[ToList[mySamples], expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentMeasureViscosityOptions[ToList[mySamples], expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureViscosity,
		resolvedOptions,
		Ignore -> ToList[myOptions],
		Messages -> False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentMeasureViscosity, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = If[gatherTests,
		experimentMeasureViscosityResourcePackets[mySamplesWithPreparedSamples, expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{experimentMeasureViscosityResourcePackets[mySamplesWithPreparedSamples, expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureViscosity, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets, $Failed] && !MatchQ[resolvedOptionsResult, $Failed],
		UploadProtocol[
			resourcePackets,
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> Object[Protocol, MeasureViscosity],
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentMeasureViscosity, collapsedResolvedOptions],
		Preview -> Null
	}
];


(* Note: The container overload should come after the sample overload. *)
ExperimentMeasureViscosity[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,listedContainers,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests, containerToSampleSimulation,
		updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureViscosity,
			ToList[listedContainers],
			ToList[listedOptions],
			DefaultPreparedModelAmount -> 200 Microliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=containerToSampleOptions[
			ExperimentMeasureViscosity,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation}=containerToSampleOptions[
				ExperimentMeasureViscosity,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasureViscosity[samples,ReplaceRule[sampleOptions,Simulation -> containerToSampleSimulation]]
	]
];


(* ::Subsubsection:: *)
(*resolveExperimentMeasureViscosityOptions *)


DefineOptions[
	resolveExperimentMeasureViscosityOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentMeasureViscosityOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureViscosityOptions]]:=Module[
	{outputSpecification,output,gatherTests,cache,samplePrepOptions,measureViscosityOptions,simulatedSamples,resolvedSamplePrepOptions,samplePrepTests,
	measureViscosityOptionsAssociation,invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests,targetVolumes,

	(* Sample, container, and instrument packets to download*)
		viscometerInstrumentsModels, potentialContainers,instrumentModel,
		instrumentDownloadOption,instrumentDownloadFields,viscometerChipPacket,viscometerChipDownloadFields,objectSamplePacketFields,modelSamplePacketFields,modelContainerPacketFields,
		listedSampleContainerPackets,instrumentPacket,allViscometerInstrumentsModelPackets,samplePackets,sampleModelPackets,sampleComponentPackets,sampleContainerPackets,containerPackets,
		simulatedSampleContainerModels,simulatedSampleContainerObjects,sampleSolvents,nonLiquidStatePackets,

	(* options that do not need to be rounded *)
		instrument,assayType,viscometerChip,viscometerChipModel, numberOfReplicates,residualIncubation,primaryBuffer,name,
		suppliedViscometerChip, suppliedViscometerChipObject,suppliedPrimaryBuffer,primaryBufferStorage,prePressurization,

	(*for rounding options *)
		viscosityOptionsChecks,viscosityOptionsPrecisions,roundedExperimentOptions,optionsPrecisionTests,roundedExperimentOptionsList,allOptionsRounded,
		listedMeasurementOptions, listedMeasurementOptionPrecision, unroundedListedMeasurementOptions, unroundedListedMeasurementOptionsFlat, unroundedListedMeasurementAssoc,
		measurementTemperatureFlat,flowRateFlat,equilibrationTimeFlat,measurementTimeFlat,pauseTimeFlat,targetPressureFlat,roundedRelistedOptions,roundedRelistedOptionsAssociation,
		combinedRoundedAssociation,reformattedUnroundedListedOptions,allOptionsPrecisionTests,roundedListedOptions,roundedListedOptionsPrecisionTest,
		unroundedMeasTable,measTableTempPositions,measTableFlowRatePositions,measTableTimePositions,measTableEquilTimePositions,measTableMeasTimePositions,measTablePauseTimePositions,measTablePressurePositions,
		measTableTempAssociation,measTableFlowRateAssociation,measTableEquilTimeAssociation,measTableMeasTimeAssociation,measTablePauseTimeAssociation,measTablePressureAssociation,measTableTempRoundedAssociation,measTablePressureRoundedAssociation,measTablePressureRoundedTests,
		measTableTempRoundedTests,measTableFlowRateRoundedAssociation,measTableFlowRateRoundedTests,measTableEquilTimeRoundedAssociation,measTableEquilTimeRoundedTests,
		measTableMeasTimeRoundedAssociation,measTableMeasTimeRoundedTests,measTablePauseTimeRoundedAssociation,measTablePauseTimeRoundedTests,roundedMeasurementTable,

	(* Options that should  be rounded *)
		suppliedSampleTemperature,suppliedTemperatureStabilityMargin,suppliedTemperatureStabilityTime,suppliedMeasurementTemperature,
		suppliedFlowRate,suppliedEquilibrationTime,suppliedMeasurementTime,suppliedPauseTime,suppliedRemeasurementReloadVolume,suppliedTargetPressure,

	(* input Validation *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,containerlessSamples,containerlessSampleTest,maxNumberOfSamples,
		tooManyInvalidInputs,tooManyInputsTests,noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTest,
		minMeasurementVolume,insufficientVolSamplePackets,insufficientVolInvalidInputs,insufficientVolumeTest,
		compatibleInputBools,incompatibleInputBools,incompatibleInputs,incompatibleInputTests,solidInvalidInputs,solidStateTest,

	(* conflicting options*)
		validNameQ,nameInvalidOption,validNameTest,
		remeasurementConflicts,remeasurementConflictOptions,remeasurementConflictInputs,remeasurementInvalidOptions,remeasurementInvalidTest,
		recoupSampleConflicts,recoupSampleConflictOptions,recoupSampleConflictInputs,recoupSampleInvalidOptions,recoupSampleInvalidTest,
		measurementTableOptions,measurementTableOptionsBoolsmeasurementTableConflicts,recoupSampleContainerlist,recoupSampleContainerModels,
	(* Map thread*)
		mapThreadFriendlyOptions,injectionVolumesList,
		resolvedViscometerChip,resolvedPrimaryBuffer,resolvedPrimaryBufferStorage,resolvedSampleTemperature,resolvedMeasurementMethod,resolvedPriming,resolvedTemperatureStabilityMargin,resolvedTemperatureStabilityTime,
		resolvedMeasurementTemperature,resolvedRemeasurementAllowed,resolvedRecoupSample,resolvedRecoupSampleContainerSame,resolvedInjectionVolume,
		resolvedFlowRate,resolvedEquilibrationTime,resolvedMeasurementTime,resolvedPauseTime,resolvedNumberOfReadings,resolvedMeasurementMethodTable,resolvedRemeasurementReloadVolume,resolvedTargetPressure,
		resolvedRecoupSampleContainer,
	(*Errors and testing *)
		sampleVolumeTooLowForInjectionErrors,sampleVolumeTooLowForInjectionTests,sampleVolumeTooLowForInjectionOptions,
		minInjectionAliquotErrors,minInjectionAliquotErrorTests,minInjectionAliquoErrorOptions,
		primingWarnings,primingWarningTests,primingWarningOptions,
		customMeasTableParameterErrors,customMeasTableParameterErrorTests,customMeasTableParameterOptions,failingCustomMeasInputs,failingCustomMeasOptions,
		customMeasTableParameterWarnings,customMeasTableParameterWarningTests,customMeasTableParameterWarningOptions,
		exploratoryTempSweepParameterErrors,exploratoryTempSweepParameterErrorTests,exploratoryTempSweepParameterErrorOptions,failingExploratoryTempSweepInputs,failingExploratoryTempSweepOptions,
		measurementParameterErrors,measurementParameterErrorTests,measurementParameterErrorOptions,failingMeasurementParameterInputs,failingMeasurementParameterOptions,
		shearSweepParameterErrors,shearSweepParameterErrorTests,shearSweepParameterErrorOptions,failingShearSweepInputs,failingShearSweepOptions,
		pressureSweepParameterErrors,pressureSweepParameterErrorTests,pressureSweepParameterErrorOptions,pressureShearSweepInputs,failingPressureSweepOptions,failingPressureSweepInputs,
		tempSweepInsufficientErrors,tempSweepInsufficientErrorTests,tempSweepInsufficientErrorOptions,
		shearRateSweepInsuffcientErrors,shearRateSweepInsufficientErrorTests,shearRateSweepInsufficientErrorOptions,
		remeasurementReloadVolumeTooHighErrors,remeasurementReloadVolumeTooHighErrorTests,remeasurementReloadVolumeTooHighErrorOptions,
		notEnoughInjectionWarnings,notEnoughInjectionWarningTests,notEnoughInjectionWarningOptions,
		incompatibleContainerBools,
		minInjectionAliquotBools,minInjectionRequired,minInjectionAliquotErrorOptions,
		recoupSampleContainerSameBools,preResolvedRecoupSampleContainerModels,firstRecoupContainerModel,recoupContainerModelComparisonBools,
		recoupContainerAllSame,simContainerModelComparisonBools,simContainersAllSame,
		recoupContainerConflictBools,measurementContainerModel,additionalContainersNeeded,totalContainerCount,tooManyRecoupContainers,
		recoupSampleContainerErrors,recoupSampleContainerErrorTests,recoupSampleContainerErrorOptions,
		recoupContainerAliquotConflictTests,recoupContainerAliquotConflictOptions,tooManyRecoupContainerOptions,tooManyRecoupContainerTests,

		customPressurePrimeErrors,customPressurePrimeErrorTests,customPressurePrimeErrorOptions,
		customPressureTimeWarnings,customPressureTimeWarningTests,customPressureTimeWarningOptions,
		customPressureFlowRateErrors,customPressureFlowRateErrorTests,customPressureFlowRateErrorOptions,

		validSampleStorageConditionQ,invalidStorageConditionOptions,validSampleStorageTests,
		allTests,
		aliquotMessage,resolvedOptions, emailOption, uploadOption, nameOption, confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,samplesOutStorageOption,operator,resolvedEmail,

		resolvedPostProcessingOptions, simulation, updatedSimulation
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our MeasureViscosity options from our Sample Prep options. *)
	{samplePrepOptions,measureViscosityOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMeasureViscosity,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMeasureViscosity,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureViscosityOptionsAssociation = Association[measureViscosityOptions];

	(* Get all the potential preferred containers*)
	(*Note: the Rheosense Initium viscometer can only be calibrated for one Model of autosample vial and 96-well plate at any one time.
		Currently, the autosampler is calibrated for the following containers. If you want to use a different container, the autosampler must be
 		re-calibrated to account for differences in the distance to the bottom of the container. *)
	potentialContainers={
		Model[Container, Plate, "id:01G6nvkKrrYm"], (*Model[Container, Plate, "96-well PCR Plate"]*)
		Model[Container, Vessel, "id:BYDOjvGj6q39"] (*Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]*)
	};

	(* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
	(* Get the instrument *)
	instrument=Lookup[measureViscosityOptionsAssociation,Instrument];
	suppliedViscometerChip=Lookup[measureViscosityOptionsAssociation,ViscometerChip];
	suppliedViscometerChipObject=If[MatchQ[suppliedViscometerChip,ObjectP[]],
		suppliedViscometerChip,
		Null
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

	instrumentDownloadFields=Which[
		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument,ObjectP[Object[Instrument]]],
		Packet[Model[{Object,WettedMaterials,MinSampleVolume,InjectionVolumes}]],

		(* If instrument is a Model, download fields*)
		MatchQ[instrument,ObjectP[Model[Instrument]]],
		Packet[Object,WettedMaterials,MinSampleVolume,InjectionVolumes],

		True,
		Nothing
	];
	
	viscometerChipDownloadFields=Which[
		(* If ViscometerChip is an object, download fields from the Model *)
		MatchQ[suppliedViscometerChip,ObjectP[Object[Part,ViscometerChip]]],
		Packet[Model[Object]],
		
		(* If instrument is a Model, download fields*)
		MatchQ[suppliedViscometerChip,ObjectP[Model[Part,ViscometerChip]]],
		Packet[Object],
		
		True,
		Nothing
	];
	
	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our updatedSimulation *)
	{listedSampleContainerPackets, instrumentPacket, containerPackets, {viscometerChipPacket}} = Quiet[Download[
		{
			simulatedSamples,
			{instrument},
			potentialContainers,
			ToList[suppliedViscometerChipObject]
		},
		{
			{
				Packet[Model, Status, Container, Well, Volume, Composition, IncompatibleMaterials, Solvent, Density, State],
				Packet[Model[{IncompatibleMaterials, Composition, Name, Solvent, Density, MolecularWeight, State}]],
				Packet[Container[{Model, Contents}]],
				(*Packet[Container[Model[{MaxVolume,NumberOfWells,Name}]]],*)
				Packet[Composition[[All, 2]][{State, Density, Concentration}]]
			},
			{instrumentDownloadFields},
			{Packet[MaxVolume, NumberOfWells, Name]},
			{viscometerChipDownloadFields}
		},
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets = listedSampleContainerPackets[[All, 1]];
	sampleModelPackets = listedSampleContainerPackets[[All, 2]];
	sampleComponentPackets = listedSampleContainerPackets[[All, 4]];
	sampleContainerPackets = listedSampleContainerPackets[[All, 3]];
	simulatedSampleContainerModels = If[NullQ[#], Null, Download[Lookup[#, Model], Object]]& /@ sampleContainerPackets;
	simulatedSampleContainerObjects = Download[Lookup[samplePackets, Container], Object];
	sampleSolvents = Lookup[Flatten[samplePackets], Solvent, Null];

	(* -- Instrument packet --*)
	(* - Find the Model of the instrument, if it was specified - *)
	instrumentModel = If[
		MatchQ[instrumentPacket, {}],
		Null,
		FirstOrDefault[Lookup[Flatten[instrumentPacket], Object]]
	];

	(* Pull out the list of all possible injection Volumes from the Model Packet *)
	injectionVolumesList = Lookup[Flatten[instrumentPacket], InjectionVolumes];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1. Check if samples are discarded *)

	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets = Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs, Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs], Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 1.5 Check if samples are in a container *)

	(* Get the sample containers that are not in a container *)
	containerlessSamples = PickList[simulatedSamples,simulatedSampleContainerObjects,Null];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[containerlessSamples]>0&&!gatherTests,
		Message[Error::ContainerlessSamples, ObjectToString[containerlessSamples, Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerlessSampleTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[containerlessSamples]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[containerlessSamples, Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[containerlessSamples]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,containerlessSamples], Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 2. Check to see if the number of samples is more than the limit depending on the ViscometerChip - B05 (72 samples), C05,E02 (48 samples). *)
	(* Each chip has a specific amount of TertiaryCleaningSolvent that it uses per sample. The maximum amount of TertiaryCleaningSolvent that is prepared for one experiment is 1 L. B05 uses 12 mL per sample, while C05 and E02 uses 20 mL per sample. *)
	viscometerChipModel=Which[
		MatchQ[suppliedViscometerChip,ObjectP[]],
		Lookup[viscometerChipPacket[[1]],Object],
		
		True,
		Null
	];
	(* The maxNumberOfSamples is dependent on the limiting TertiaryCleaningSolvent used per Chip*)
	maxNumberOfSamples =  Which[
		(* Chip B05 *)
		MatchQ[viscometerChipModel,ObjectP[Model[Part, ViscometerChip, "id:6V0npvmZXEAa"]]],
		72,
		
		(* Chip C05 or E02*)
		MatchQ[viscometerChipModel,ObjectP[Model[Part, ViscometerChip, "id:pZx9jo8LKz04"]]|ObjectP[Model[Part, ViscometerChip, "id:4pO6dM504kjL"]]],
		48,
		
		(* If the ViscometerChip has not been supplied, maxNumberOfSamples depends on AssayType which has a default of LowViscosity. LowViscosity uses the B05 chip*)
		MatchQ[Lookup[measureViscosityOptionsAssociation,AssayType],LowViscosity],
		72,
		
		(* If AssayType is not LowViscosity, the experiment is set to use either a C05 or E02 and can only accommodate 48 samples *)
		True,
		48
	];
	
	(* If there are more than maxNumberOfSamples input samples, set all of the samples to tooManyInvalidInputs *)
	tooManyInvalidInputs=If[MatchQ[Length[simulatedSamples],GreaterP[maxNumberOfSamples]],
			Lookup[Flatten[samplePackets],Object,Null],
			{}
	];

	(* If there are too many input samples and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[tooManyInvalidInputs]>0&&!gatherTests,
		Message[Error::TooManyViscosityInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooManyInvalidInputs]==0,
				Nothing,
				Test["There are 96 or fewer input samples in "<>ObjectToString[tooManyInvalidInputs,Simulation->updatedSimulation],True,False]
			];

			passingTest=If[Length[tooManyInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["There are 96 or fewer input samples.",True,True]
			];

				{failingTest,passingTest}
			],
			Nothing
		];

	(*3.0 Check if samples are NOT in a Liquid state *)
	(* Get the samples from simulatedSamples that are not in a liquid state. *)
	nonLiquidStatePackets = Cases[Flatten[samplePackets],KeyValuePattern[State->Solid]];
	solidInvalidInputs = Lookup[nonLiquidStatePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[solidInvalidInputs]>0&&!gatherTests,
		Message[Error::ViscositySolidSampleUnsupported, ObjectToString[solidInvalidInputs, Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	solidStateTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[solidInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[solidInvalidInputs, Simulation->updatedSimulation]<>" are in a liquid state:",True,False]
			];

			passingTest=If[Length[solidInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,solidInvalidInputs], Simulation->updatedSimulation]<>" are in a liquid state:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 3. Check if samples have volume populated *)

	(* Get the samples from simulatedSamples that do not have volume populated. *)
	noVolumeSamplePackets = Cases[Flatten[samplePackets],KeyValuePattern[Volume->NullP]];
	noVolumeInvalidInputs = Lookup[noVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[noVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::ViscosityNoVolume, ObjectToString[noVolumeInvalidInputs, Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs, Simulation->updatedSimulation]<>" have volume populated:",True,False]
			];

			passingTest=If[Length[noVolumeInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,noVolumeInvalidInputs], Simulation->updatedSimulation]<>" have volume populated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 4.  Check if samples have a volume of at least 26 uL *)

	(* Get the samples from simulatedSamples that do not have volume populated. *)
	minMeasurementVolume = Min[injectionVolumesList];
	insufficientVolSamplePackets = Cases[Flatten[samplePackets],KeyValuePattern[Volume->LessP[minMeasurementVolume]]];
	insufficientVolInvalidInputs = Lookup[insufficientVolSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[insufficientVolInvalidInputs]>0&&!gatherTests,
		Message[Error::ViscosityInsufficientVolume, ObjectToString[insufficientVolInvalidInputs, Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	insufficientVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[insufficientVolInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[insufficientVolInvalidInputs, Simulation->updatedSimulation]<>" have a volume of at least 26 uL:",True,False]
			];

			passingTest=If[Length[insufficientVolInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,insufficientVolInvalidInputs], Simulation->updatedSimulation]<>" have a volume of at least 26 uL:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 5.  Check if samples are chemically compatible with the instrument *)
	{compatibleInputBools,incompatibleInputTests} = If[gatherTests,
		CompatibleMaterialsQ[Lookup[Flatten[instrumentPacket],Object,{}][[1]],simulatedSamples,Simulation -> updatedSimulation,Output -> {Result, Tests}],
		{CompatibleMaterialsQ[Lookup[Flatten[instrumentPacket],Object,{}][[1]],simulatedSamples,Simulation -> updatedSimulation,Messages->!gatherTests],{}}
	];

	(*Get all the incompatible samples*)
	incompatibleInputs = If[Not[compatibleInputBools] && !gatherTests,
		mySamples,
		{}
	];

	(* If there are incompatible inputs and we are throwing messages, throw an error message .*)
	If[Length[incompatibleInputs]>0&&!gatherTests,
		Message[Error::ViscosityIncompatibleSample, ObjectToString[incompatibleInputs, Simulation->updatedSimulation]]
	];

	(*-- OPTION PRECISION CHECKS --*)

	(*List the options that we need to check the precisions of. These options are single values. *)
	viscosityOptionsChecks = {
		(*1*)SampleTemperature,
		(*2*)TemperatureStabilityMargin,
		(*3*)TemperatureStabilityTime,
		(*4*)RemeasurementReloadVolume,
		(*5*)PauseTime
	};

	viscosityOptionsPrecisions = {
		(*1*)10^-1 Celsius,
		(*2*)10^-1 Celsius,
		(*3*)2*10^-1 Second,
		(*4*)10^0 Microliter,
		(*5*)2*10^-1 Second
	};

	(* Round the options *)
	{roundedExperimentOptions,optionsPrecisionTests} = If[gatherTests,
		RoundOptionPrecision[
			measureViscosityOptionsAssociation,
			viscosityOptionsChecks,
			viscosityOptionsPrecisions,
			Output -> {Result,Tests}
		],

		{
			RoundOptionPrecision[
				measureViscosityOptionsAssociation,
				viscosityOptionsChecks,
				viscosityOptionsPrecisions
			],
			{}
		}
	];

	(*List the options that we need to check the precisions of. These options are potentially lists of values, so we need to handle them accordingly to round. *)
	listedMeasurementOptions =	{
		(*7*)MeasurementTemperature,
		(*8*)FlowRate,
		(*9*)EquilibrationTime,
		(*10*)MeasurementTime,
		(*11*)RelativePressure
	};

	listedMeasurementOptionPrecision ={
		(*7*)10^-1 Celsius,
		(*8*)10^-1 (Micro*Liter)/Minute,
		(*9*)2*10^-1 Second,
		(*10*)2*10^-1 Second,
		(*11*)10^-1 Percent
	};

	(* Get all the unrounded, listed option values*)
	unroundedListedMeasurementOptions = Lookup[measureViscosityOptionsAssociation,#]& /@listedMeasurementOptions;

	(* Flatten the nested lists so we get a single list of MeasurementTemps etc. that we can pass into RoundOptionPrecision*)
	unroundedListedMeasurementOptionsFlat = Map[Flatten[#,1]&,unroundedListedMeasurementOptions];

	(* Build an association of the flattened list of unrounded options to pass into RoundOptionPrecision *)
	unroundedListedMeasurementAssoc = MapThread[Association[#1 -> #2]&,{listedMeasurementOptions,unroundedListedMeasurementOptionsFlat}];

	{roundedListedOptions,roundedListedOptionsPrecisionTest} = If[gatherTests,
		RoundOptionPrecision[
			Association[unroundedListedMeasurementAssoc],
			listedMeasurementOptions,
			listedMeasurementOptionPrecision,
			Output -> {Result,Tests}
		],

		{
			RoundOptionPrecision[
				Association[unroundedListedMeasurementAssoc],
				listedMeasurementOptions,
				listedMeasurementOptionPrecision
			],
			{}
		}
	];

	{measurementTemperatureFlat,flowRateFlat,equilibrationTimeFlat,measurementTimeFlat,targetPressureFlat} = Lookup[roundedListedOptions,
		{MeasurementTemperature,FlowRate,EquilibrationTime,MeasurementTime,RelativePressure}
	];

	(* Re-list the flattened listable options so that they are in the same form as the original input *)

	(* If any of the measurement options are Automatic or Null, or a single value, we need to wrap {} around it *)
	reformattedUnroundedListedOptions = Map[ToList[#]&,unroundedListedMeasurementOptions,2];(*Map[If[MatchQ[#,Alternatives[Automatic,Null,Ambient]],{#},#]&,unroundedListedMeasurementOptions,2];*)

	suppliedMeasurementTemperature = TakeList[measurementTemperatureFlat,Length/@reformattedUnroundedListedOptions[[1]]];
	suppliedFlowRate = TakeList[flowRateFlat,Length/@reformattedUnroundedListedOptions[[2]]];
	suppliedEquilibrationTime = TakeList[equilibrationTimeFlat,Length/@reformattedUnroundedListedOptions[[3]]];
	suppliedMeasurementTime = TakeList[measurementTimeFlat,Length/@reformattedUnroundedListedOptions[[4]]];
	suppliedTargetPressure = TakeList[targetPressureFlat,Length/@reformattedUnroundedListedOptions[[5]]];

	(* Put the re-listed options back into an association *)
		(* First, merge them into a list *)
		roundedRelistedOptions = {suppliedMeasurementTemperature,suppliedFlowRate,suppliedEquilibrationTime,suppliedMeasurementTime,suppliedTargetPressure};

		(* Then, make an association *)
		roundedRelistedOptionsAssociation = Association[MapThread[Association[#1->#2]&,{listedMeasurementOptions,roundedRelistedOptions}]];

	(* Round the options provided in the Measurement table *)
		(* We need to pull out the Measurement Temperature, Flow Rate, Equilibration Time, Measurement Time, Pause time, and TargetPressure, round them and then put everything back together *)

		unroundedMeasTable = Lookup[measureViscosityOptionsAssociation,MeasurementMethodTable];

		(* Find all positions where a Temperature exists*)
		measTableTempPositions = Position[unroundedMeasTable,_Quantity?TemperatureQ,Infinity,Heads->False];

		(* Find all positions where a Flow Rate exists*)
		measTableFlowRatePositions = Position[unroundedMeasTable,_Quantity?FlowRateQ,Infinity,Heads->False];

		(* Find all positions where a Time exists*)
		measTableTimePositions = Position[unroundedMeasTable,_Quantity?TimeQ,Infinity,Heads->False];
		(*Separate this out into Equilibration Time (Column 3), MeasurementTime (col 4), and Pause Time (col 5)*)
		measTableEquilTimePositions = Select[measTableTimePositions, #[[3]] == 3 &];
		measTableMeasTimePositions = Select[measTableTimePositions, #[[3]] == 4 &];
		measTablePauseTimePositions = Select[measTableTimePositions, #[[3]] == 5 &];

		(* Find all positions where a Pressure percent exists*)
		measTablePressurePositions = Position[unroundedMeasTable,_Quantity?PercentQ,Infinity,Heads->False];

		(*build an association with flattened Temperature values *)
		measTableTempAssociation = Association[MeasurementMethodTable -> (Extract[unroundedMeasTable,#]&/@measTableTempPositions)];

		(*build an association with flattened FlowRate values *)
		measTableFlowRateAssociation = Association[MeasurementMethodTable -> (Extract[unroundedMeasTable,#]&/@measTableFlowRatePositions)];

		(*build an association with flattened Time values *)
		measTableEquilTimeAssociation = Association[MeasurementMethodTable -> (Extract[unroundedMeasTable,#]&/@measTableEquilTimePositions)];
		measTableMeasTimeAssociation = Association[MeasurementMethodTable -> (Extract[unroundedMeasTable,#]&/@measTableMeasTimePositions)];
		measTablePauseTimeAssociation = Association[MeasurementMethodTable -> (Extract[unroundedMeasTable,#]&/@measTablePauseTimePositions)];

		(*build an association with flattened TargetPressure percent values *)
		measTablePressureAssociation = Association[MeasurementMethodTable-> (Extract[unroundedMeasTable,#]&/@measTablePressurePositions)];

		(* Pass the build Temperature association to get rounded values *)
		{measTableTempRoundedAssociation,measTableTempRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				measTableTempAssociation,
				MeasurementMethodTable,
				10^-1 Celsius,
				Output->{Result,Tests}
			],
			{
				RoundOptionPrecision[
					measTableTempAssociation,
					MeasurementMethodTable,
					10^-1 Celsius
				],
				{}
			}
		];

		(* Pass the build FlowRate association to get rounded values *)
		{measTableFlowRateRoundedAssociation,measTableFlowRateRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				measTableFlowRateAssociation,
				MeasurementMethodTable,
				10^0 Microliter/Minute,
				Output->{Result,Tests}
			],
			{
				RoundOptionPrecision[
					measTableFlowRateAssociation,
					MeasurementMethodTable,
					10^0 Microliter/Minute
				],
				{}
			}
		];

		(* Pass the build EquilibrationTime association to get rounded values *)
		{measTableEquilTimeRoundedAssociation,measTableEquilTimeRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				measTableEquilTimeAssociation,
				MeasurementMethodTable,
				0.2*10^-1 Second,
				Output->{Result,Tests}
			],
			{
				RoundOptionPrecision[
					measTableEquilTimeAssociation,
					MeasurementMethodTable,
					0.2*10^-1 Second
				],
				{}
			}
		];

		(* Pass the build MeasurementTime association to get rounded values *)
		{measTableMeasTimeRoundedAssociation,measTableMeasTimeRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				measTableMeasTimeAssociation,
				MeasurementMethodTable,
				0.2*10^-1 Second,
				Output->{Result,Tests}
			],
			{
				RoundOptionPrecision[
					measTableMeasTimeAssociation,
					MeasurementMethodTable,
					0.2*10^-1 Second
				],
				{}
			}
		];

		(* Pass the build Time association to get rounded values *)
		{measTablePauseTimeRoundedAssociation,measTablePauseTimeRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				measTablePauseTimeAssociation,
				MeasurementMethodTable,
				0.2*10^-1 Second,
				Output->{Result,Tests}
			],
			{
				RoundOptionPrecision[
					measTablePauseTimeAssociation,
					MeasurementMethodTable,
					0.2*10^-1 Second
				],
				{}
			}
		];

		(* Pass the build FlowRate association to get rounded values *)
		{measTablePressureRoundedAssociation,measTablePressureRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				measTablePressureAssociation,
				MeasurementMethodTable,
				10^-1 Percent,
				Output->{Result,Tests}
			],
			{
				RoundOptionPrecision[
					measTablePressureAssociation,
					MeasurementMethodTable,
					10^-1 Percent
				],
				{}
			}
		];

		(* Rebuild the MeasurementTable option association by replacing the flat rounded values at the
		positions they were originally found in *)
		roundedMeasurementTable = Association[MeasurementMethodTable ->
			ReplacePart[
				Lookup[measureViscosityOptionsAssociation,MeasurementMethodTable],
				Join[
					MapThread[
						Rule,
						{measTableTempPositions,Lookup[measTableTempRoundedAssociation,MeasurementMethodTable]}
					],
					MapThread[
						Rule,
						{measTableFlowRatePositions,Lookup[measTableFlowRateRoundedAssociation,MeasurementMethodTable]}
					],
					MapThread[
						Rule,
						{measTablePressurePositions,Lookup[measTablePressureRoundedAssociation,MeasurementMethodTable]}
					],
					MapThread[
						Rule,
						{measTableEquilTimePositions,Lookup[measTableEquilTimeRoundedAssociation,MeasurementMethodTable]}
					],
					MapThread[
						Rule,
						{measTableMeasTimePositions,Lookup[measTableMeasTimeRoundedAssociation,MeasurementMethodTable]}
					],
					MapThread[
						Rule,
						{measTablePauseTimePositions,Lookup[measTablePauseTimeRoundedAssociation,MeasurementMethodTable]}
					]
				]
			]
		];

	(* Combine the rounded associations *)
	combinedRoundedAssociation = Join[roundedExperimentOptions,roundedRelistedOptionsAssociation,roundedMeasurementTable];

	(* Turn the output of RoundOptionPrecision[experimentOptionsAssociation] into a list *)
	roundedExperimentOptionsList=Normal[combinedRoundedAssociation];

	(* Replace the rounded options in myOptions *)
	allOptionsRounded=ReplaceRule[
		myOptions,
		roundedExperimentOptionsList,
		Append->False
	];

	allOptionsPrecisionTests = Join[optionsPrecisionTests,roundedListedOptionsPrecisionTest,{measTableTempRoundedTests,measTableFlowRateRoundedTests,measTableEquilTimeRoundedTests,measTableMeasTimeRoundedTests,measTablePauseTimeRoundedTests,measTablePressureRoundedTests}];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* - Check that the protocol name is unique - *)
	validNameQ=If[MatchQ[name,_String],

		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,MeasureViscosity,name]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"MeasureViscosity protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already an MeasureViscosity protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* - Check that the RemeasurementReloadVolume is Null if RemeasurementAllowed is set as False - *)
	remeasurementConflicts = MapThread[
		Function[
			{remeasurementAllowed,reloadVolume,sampleObject},
			If[
				Or[
						(* If RemeasurementAllowed -> False but a RemeasurementReloadVolume was specified *)
						MatchQ[remeasurementAllowed,Alternatives[False,Null]] && !MatchQ[reloadVolume,Alternatives[Automatic,Null]],

						(* OR If RemeasurementAllowed -> True but a RemeasurementReloadVolume was set as Null *)
						MatchQ[remeasurementAllowed,True] && MatchQ[reloadVolume,Null]
				],
				{{remeasurementAllowed,reloadVolume},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,RemeasurementAllowed],Lookup[allOptionsRounded,RemeasurementReloadVolume],ToList[simulatedSamples]}
	];

	(* Transpose our result if there were mismatches. *)
	{remeasurementConflictOptions,remeasurementConflictInputs} = If[MatchQ[remeasurementConflicts,{}],
		{{},{}},
		Transpose[remeasurementConflicts]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	remeasurementInvalidOptions = If[Length[remeasurementConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{RemeasurementAllowed, RemeasurementReloadVolume},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If we are throwing messages, put the call here *)
	If[Length[remeasurementConflictOptions]>0 &&!gatherTests,
		Message[Error::ViscosityRemeasurementAllowedConflict,remeasurementConflictOptions,ObjectToString[remeasurementConflictInputs,Simulation->updatedSimulation]]
	];

	(* Build a test for whether a values was specified for RemeasurementReloadVolume even though RemeasurementAllowed -> False *)
	remeasurementInvalidTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest = If[Length[remeasurementConflictOptions]==0,
				Nothing,
				Test["The provided values for RemeasurementAllowed and RemeasurementReloadVolume are in conflict with each other:", True, False]
			];

			passingTest = If[Length[remeasurementConflictOptions]!=0,
				Nothing,
				Test["The provided values for RemeasurementAllowed and RemeasurementReloadVolume are in conflict with each other:", True, True]
			];
		{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check that if RecoupSample is True, the RecoupSampleContainerSame is not Null - *)
	recoupSampleConflicts = MapThread[
		Function[
			{recoupSample,recoupSampleContainer,sampleObject},
			If[
				Or[
						(* If RecoupSample -> False but a RecoupSampleContainer was specified *)
						MatchQ[recoupSample,False] && !MatchQ[recoupSampleContainer,Alternatives[Automatic,Null]],

						(* OR If RecoupSample -> True but a RecoupSampleContainer was specified as Null *)
						MatchQ[recoupSample,True] && MatchQ[recoupSampleContainer,Null]
				],
				{{recoupSample,recoupSampleContainer},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,RecoupSample],Lookup[allOptionsRounded,RecoupSampleContainerSame],ToList[simulatedSamples]}
	];

	(* Transpose our result if there were mismatches. *)
	{recoupSampleConflictOptions,recoupSampleConflictInputs} = If[MatchQ[recoupSampleConflicts,{}],
		{{},{}},
		Transpose[recoupSampleConflicts]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	recoupSampleInvalidOptions = If[Length[recoupSampleConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{RecoupSample, RecoupSampleContainerSame},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	If[Length[recoupSampleConflictOptions]>0 && !gatherTests,
		Message[Error::ViscosityRecoupSampleConflict,recoupSampleConflictOptions,ObjectToString[recoupSampleConflictInputs,Simulation->updatedSimulation]]
	];

	(* Build a test for whether values were specified for RecoupSampleContainerSame even though RecoupSample -> False *)
	recoupSampleInvalidTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest = If[Length[recoupSampleConflictOptions]==0,
				Nothing,
				Test["The provided values for RecoupSample and RecoupSampleContainerSame are in conflict with each other:", True, False]
			];

			passingTest = If[Length[recoupSampleConflictOptions]!=0,
				Nothing,
				Test["The provided values for RecoupSample and RecoupSampleContainerSame are in conflict with each other:", True, True]
			];
		{failingTest,passingTest}
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Pull out all the options *)
	(* these options are defaulted and are outside of the main map thread*)
	{
		instrument,assayType,numberOfReplicates,residualIncubation,name,prePressurization
	} =
		Lookup[allOptionsRounded,
			 {
				 Instrument,AssayType,NumberOfReplicates,ResidualIncubation,Name,AutosamplerPrePressurization
			 },
			 Null
	];

	(* these options need to be resolved outside of the main map thread *)
	{suppliedPrimaryBuffer,suppliedSampleTemperature,primaryBufferStorage}
 		= Lookup[allOptionsRounded,
			{
				PrimaryBuffer,SampleTemperature,PrimaryBufferStorageCondition
			},
			Null
	];

	(* Resolve the viscometer chip *)
	resolvedViscometerChip = If[
		(* If the ViscometerChip is left as Automatic, resolve based on what AssayType was given *)
		MatchQ[suppliedViscometerChip, Automatic],
		Which[
			MatchQ[assayType,LowViscosity],Model[Part, ViscometerChip, "id:6V0npvmZXEAa"], (*B05 Chip*)
			MatchQ[assayType,HighViscosity],Model[Part,ViscometerChip,"id:pZx9jo8LKz04"], (*C05 Chip*)
			MatchQ[assayType,HighShearRate],Model[Part,ViscometerChip,"id:pZx9jo8LKz04"] (*E02 Chip*)
		],
		(* Otherwise, the user supplied a value, so just use that *)
		suppliedViscometerChip
	];

	(* Resolve the Primary Buffer  *)
	resolvedPrimaryBuffer = If[
		(* If the PrimaryCleaningSolution is left as Automatic, try to resolve based on what the solvent is *)
		MatchQ[suppliedPrimaryBuffer, Automatic],
				Which[
					(* No Solvent information *)
					MatchQ[sampleSolvents,{Null..}],
						Model[Sample, StockSolution, "Filtered PBS, Sterile"],	(*If the solvent field is not filled out, we default to PBS*)

					(* If the first sample has a solvent specified, use it *)
					MatchQ[First[sampleSolvents],ObjectP[Model[Sample]]],
						First[sampleSolvents],

					(* Otherwise default to PBS *)
					True,
						Model[Sample, StockSolution, "Filtered PBS, Sterile"]
				],
		(* Otherwise, the user supplied a value, so just use that *)
		suppliedPrimaryBuffer
	];

	(* Resolve the Buffer Storage Conditions *)
	resolvedPrimaryBufferStorage = primaryBufferStorage;

	(* Resolve the Sample Temperature *)
	resolvedSampleTemperature = If[
		(* If the SampleTempearture is Ambient, change this to 25 C *)
		MatchQ[suppliedSampleTemperature, Alternatives[Ambient|Automatic]],
		25 Celsius,
		(* Otherwise, the user supplied a value, so just use that *)
		suppliedSampleTemperature
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureViscosity,allOptionsRounded];

	(*-----MAP THREAD-------*)
	{
		resolvedMeasurementMethod,
		resolvedPriming,
		resolvedTemperatureStabilityMargin,
		resolvedTemperatureStabilityTime,
		resolvedMeasurementTemperature,
		resolvedRemeasurementAllowed,
		resolvedRecoupSample,
		resolvedRecoupSampleContainerSame,
		resolvedInjectionVolume,
		resolvedFlowRate,
		resolvedEquilibrationTime,
		resolvedMeasurementTime,
		resolvedPauseTime,
		resolvedNumberOfReadings,
		resolvedMeasurementMethodTable,
		resolvedRemeasurementReloadVolume,
		resolvedTargetPressure,

		(* Bools to track whether we need to aliquot *)
		incompatibleContainerBools,
		minInjectionAliquotBools,
		(* Setup our error tracking variables *)
		sampleVolumeTooLowForInjectionErrors,
		minInjectionAliquotErrors,
		primingWarnings,
		customMeasTableParameterErrors,
		customMeasTableParameterWarnings,
		exploratoryTempSweepParameterErrors,
		measurementParameterErrors,
		shearSweepParameterErrors,
		pressureSweepParameterErrors,
		tempSweepInsufficientErrors,
		shearRateSweepInsuffcientErrors,
		remeasurementReloadVolumeTooHighErrors,
		notEnoughInjectionWarnings,
		recoupSampleContainerErrors,
		customPressurePrimeErrors,
		customPressureTimeWarnings,
		customPressureFlowRateErrors,

		(* Options related to error tracking*)
		failingCustomMeasInputs,
		failingCustomMeasOptions,
		failingExploratoryTempSweepInputs,
		failingExploratoryTempSweepOptions,
		failingMeasurementParameterInputs,
		failingMeasurementParameterOptions,
		failingShearSweepInputs,
		failingShearSweepOptions,
		failingPressureSweepInputs,
		failingPressureSweepOptions
	} = Transpose@MapThread[
		Function[{myMapThreadFriendlyOptions,mySample,mySampleContainerModel,mySampleContainerObject},
			Module[{
				measurementMethod,
				priming,
				temperatureStabilityMargin,
				temperatureStabilityTime,
				measurementTemperature,
				remeasurementAllowed,
				recoupSample,
				recoupSampleContainerSame,
				injectionVolume,
				flowRate,
				equilibrationTime,
				measurementTime,
				pauseTime,
				numberOfReadings,
				measurementMethodTable,
				remeasurementReloadVolume,
				targetPressure,
				(* Error checking booleans *)
				sampleVolumeTooLowForInjectionError,
				minInjectionAliquotError,
				primingWarning,
				customMeasTableParameterError,
				customMeasTableParameterWarning,
				exploratoryTempSweepParameterError,
				measurementParameterError,
				shearSweepParameterError,
				pressureSweepParameterError,
				tempSweepInsufficientError,
				shearRateSweepInsuffcientError,
				remeasurementReloadVolumeTooHighError,
				notEnoughInjectionWarning,
				recoupSampleContainerError,
				customPressurePrimeError,
				customPressureTimeWarning,
				customPressureFlowRateError,
				(* Misc error variables*)
				failingCustomMeasInput,failingCustomMeasOption,failingCustomMeasInputPos,
				failingExploratoryTempSweepInput,failingExploratoryTempSweepOption,
				failingMeasurementParameterInput,failingMeasurementParameterOption,
				failingShearSweepInput,failingShearSweepOption,
				failingPressureSweepInput,failingPressureSweepOption,

				(* supplied option values*)
				supMeasurementMethod,
				supPriming,
				supTemperatureStabilityMargin,
				supTemperatureStabilityTime,
				supMeasurementTemperature,
				supRemeasurementAllowed,
				supRecoupSample,
				supRecoupSampleContainerSame,
				supInjectionVolume,
				supFlowRate,
				supEquilibrationTime,
				supMeasurementTime,
				supPauseTime,
				supNumberOfReadings,
				supMeasurementMethodTable,
				supRemeasurementReloadVolume,
				supTargetPressure,

				(*other varables*)
				sampleVolume,
				mySampVol,
				aliquotDeadVolume,
				incompatibleContainerBool,
				minInjectionAliquotBool
			},

			(* Initialize our error tracking variables *)
			{
				sampleVolumeTooLowForInjectionError,
				minInjectionAliquotError,
				primingWarning,
				customMeasTableParameterError,
				customMeasTableParameterWarning,
				exploratoryTempSweepParameterError,
				measurementParameterError,
				shearSweepParameterError,
				pressureSweepParameterError,
				tempSweepInsufficientError,
				shearRateSweepInsuffcientError,
				remeasurementReloadVolumeTooHighError,
				notEnoughInjectionWarning,
				recoupSampleContainerError,
				customPressurePrimeError,
				customPressureTimeWarning,
				customPressureFlowRateError
			} = ConstantArray[False,17];

			(* Store our Options in their variables *)
			{
				supMeasurementMethod,
				supPriming,
				supTemperatureStabilityMargin,
				supTemperatureStabilityTime,
				supMeasurementTemperature,
				supRemeasurementAllowed,
				supRecoupSample,
				supRecoupSampleContainerSame,
				supInjectionVolume,
				supFlowRate,
				supEquilibrationTime,
				supMeasurementTime,
				supPauseTime,
				supNumberOfReadings,
				supMeasurementMethodTable,
				supRemeasurementReloadVolume,
				supTargetPressure
			} = Lookup[
				myMapThreadFriendlyOptions,
				{
					MeasurementMethod,
					Priming,
					TemperatureStabilityMargin,
					TemperatureStabilityTime,
					MeasurementTemperature,
					RemeasurementAllowed,
					RecoupSample,
					RecoupSampleContainerSame,
					InjectionVolume,
					FlowRate,
					EquilibrationTime,
					MeasurementTime,
					PauseTime,
					NumberOfReadings,
					MeasurementMethodTable,
					RemeasurementReloadVolume,
					RelativePressure
				}
			];

			(* Get the  volume of the sample. If the volume is missing, default to 0. We will have thrown an error above *)
			sampleVolume = Lookup[mySample,Volume];
			mySampVol = Max[Replace[sampleVolume,Null -> 0*Milli*Liter]];

			(* Resolve the injection volume *)
			(* First, check if the sample is in a compatible container *)
			{incompatibleContainerBool,aliquotDeadVolume} = If[MatchQ[mySampleContainerModel,Alternatives[ObjectP[potentialContainers]]],
				(*The sample is in a compatible container and we don't need to aliquot or pad with a dead volume *)
				{False, 0 Microliter},
				(*Else, we need to aliquot and will pad with a dead volume *)
				{True, 10 Microliter}
			];

			(* Second, we will resolve the InjectionVolume based on the sample's volume - aliquotDeadVolume  *)
			injectionVolume = If[
				(*The value is Automatic*)
				MatchQ[supInjectionVolume, Automatic],
				(*default based on the sample volume and number of replicates. *)
				Module[{potentialInjectionVolumes,resInjectionVolume},
					potentialInjectionVolumes=Select[First[injectionVolumesList], # <= (mySampVol - aliquotDeadVolume)/(numberOfReplicates/.Null->1) &];
					resInjectionVolume=If[MatchQ[Length[potentialInjectionVolumes],0],
						(* mySampVol-aliquotDeadVolume is < 26 uL, so return Null*)
						Null,
						(*Otherwise, take the max injection volume*)
						Max[potentialInjectionVolumes]
					]
				],
				(*Else, the user supplied a value*)
				supInjectionVolume
			];

			(* Third, we need to check that the sample volume is greater than the injection volume*NumberOfReplicates, and that injectionVolume is not Null *)
			sampleVolumeTooLowForInjectionError = If[
				(*If a user supplued a value, we need to make sure that the injectionVolume*NumberOfReplicates is less than the sample volume*)
				And[!MatchQ[sampleVolume,Null], !MatchQ[injectionVolume,Null], !GreaterEqual[mySampVol, (injectionVolume*numberOfReplicates/.Null-> 1) + aliquotDeadVolume]],
				True,
				(*Otherwise, we do have enough sample volme to make the injection *)
				False
			];

			(* Fourth, we need to check that if the injection volume is 26 uL, we need to make sure that the container is the autosampler vial *)
			{minInjectionAliquotBool,minInjectionAliquotError} = If[
				And[
					(*The injectionVolume is 26 uL *)
					MatchQ[injectionVolume, 26 Microliter],
					(*The sample is not already in autosampler vial, do nothing*)
					!MatchQ[mySampleContainerModel,ObjectP[potentialContainers[[2]]]]
				],
				Module[{minInjectBool,suffVol,deadVol},
					(*Set minInjectBool to True*)
					minInjectBool = True;
					deadVol = 10 Microliter;
					(*Check to make sure that the sampleVolume - deadVolume is at least 26 uL*)
					suffVol = If[GreaterEqual[(mySampVol-deadVol),injectionVolume],
						False,
						True
					];
					(*Return the bools*)
					{minInjectBool,suffVol}
				],
				(* Otherwise, injectionvolume is not 26 uL and/or the sample is not in an autosampler vial so we don't need to do these checks *)
				{False,False}
			];

		(* Get the values for the TempStabilityMargin and the Temperature StabilityTime*)
		temperatureStabilityMargin = supTemperatureStabilityMargin;
		temperatureStabilityTime = supTemperatureStabilityTime;
		priming = supPriming;

		(* If the user specifies priming as false, throw a warning*)
		primingWarning = If[MatchQ[priming,False],
			True,
			False
		];

		(* - Conflicting options check: if the user wants a custom measurement method, the measurementMethodTable MUST NOT BE NULL; all other options will be ignored - *)
		customMeasTableParameterError = Switch[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supFlowRate,supEquilibrationTime,supMeasurementTime,supPauseTime,supNumberOfReadings,supTargetPressure},
			(* If the MeasurementMethod is specified as Custom, supplied MeasurementTemperature,FlowRate,EquilibrationTime,MeasurementTime, PauseTime, TargetPressure are Null -*)
			{Custom,Except[Null],Except[{Automatic}|{Ambient}|Null],_,_,_,_,_,_},True,
			{Custom,Except[Null],_,Except[{Automatic}|Null],_,_,_,_,_},True,
			{Custom,Except[Null],_,Except[{Automatic}|Null],_,_,_,_,_},True,
			{Custom,Except[Null],_,_,_,Except[{Automatic}|Null],_,_,_},True,
			{Custom,Except[Null],_,_,_,_,Except[Automatic|Null],_,_},True,
			{Custom,Except[Null],_,_,_,_,_,Except[Automatic|Null],_},True,
			{Custom,Except[Null],_,_,_,_,_,_,Except[{Automatic}|Null]},True,
			(* If the MeasurementMethod is left as Automatic, but the user specifies the MeasurementMethodTable,  MeasurementTemperature,FlowRate,EquilibrationTime,MeasurementTime, PauseTime, TargePressure are Null -*)
			{Automatic,Except[Null|Automatic],Except[{Automatic}|{Ambient}|Null],_,_,_,_,_,_},True,
			{Automatic,Except[Null|Automatic],_,Except[{Automatic}|Null],_,_,_,_,_},True,
			{Automatic,Except[Null|Automatic],_,_,Except[{Automatic}|Null],_,_,_,_},True,
			{Automatic,Except[Null|Automatic],_,_,_,Except[{Automatic}|Null],_,_,_},True,
			{Automatic,Except[Null|Automatic],_,_,_,_,Except[Automatic|Null],_,_},True,
			{Automatic,Except[Null|Automatic],_,_,_,_,_,Except[Automatic|Null],_},True,
			{Automatic,Except[Null|Automatic],_,_,_,_,_,_,Except[{Automatic}|Null]},True,
			(*Otherwise this is false*)
			{_,_,_,_,_,_,_,_,_}, False
		];

		(* Pull out what inputs are failing *)
		{failingCustomMeasInput,failingCustomMeasOption} = If[customMeasTableParameterError,
			Module[{valuesToCheck,optionsToCheck,failingCustomMeasInputIntermediate,failingInputs,failingInputPos,failingOptions},

				(* List of option values that should be checked if customMeasTableParameterError is True*)
				valuesToCheck = {supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supFlowRate,supEquilibrationTime,supMeasurementTime,supPauseTime,supNumberOfReadings,supTargetPressure};

				(* List of options that should be checked if customMeasTableParameterError is True *)
				optionsToCheck = {MeasurementMethod,MeasurementMethodTable,MeasurementTemperature,FlowRate,EquilibrationTime,MeasurementTime,PauseTime,NumberOfReadings,RelativePressure};

				(* get the options that are not Null or Automatic *)
				failingCustomMeasInputIntermediate = Cases[valuesToCheck,Except[Null|Automatic|{Ambient}|{Automatic}]];

				(* Pull out what options are failing *)
				(* Get the positions of the failing inputs *)
				failingInputPos = Position[valuesToCheck,Except[Null|Automatic|{Ambient}|{Automatic}],1, Heads->False];
				failingOptions = Part[optionsToCheck,Flatten[failingInputPos]];

				(*Map the option to its failing value *)
				failingInputs = AssociationThread[failingOptions,failingCustomMeasInputIntermediate];

				(* return the failing options *)
				{failingInputs,failingOptions}
			],

			(*Else these are just Null*)
			{Null,Null}
		];

		(* If the MeasurementMethod is specified as Custom, give them a Warning if they didn't fill out the measurement table -*)
		customMeasTableParameterWarning = If[
			And[
				MatchQ[supMeasurementMethod,Custom],
				MatchQ[supMeasurementMethodTable,Automatic]
			],
			True,
			False
		];

		(* - Conflicting options check: if the user wants a Optimize or TemperatureSweep measurement method, the measurementMethodTable, flow rate, equilibrationtime, MeasurementTime, TargetPressure cannot be specified and Priming must be true- *)
		exploratoryTempSweepParameterError = Switch[{supMeasurementMethod,supMeasurementMethodTable,supFlowRate,supEquilibrationTime,supMeasurementTime,priming,supTargetPressure},
			(* If the MeasurementMethod is specified as Optimize or TemperatureSweep then FlowRate, MeasurementTime,EquilibrationTime, and MeasurementMethodTable cannot be specified and Priming MUST Be True*)
			{Alternatives[Optimize,TemperatureSweep],Except[Automatic|Null],_,_,_,False,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,Except[{Automatic}|Null],_,_,False,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,Except[{Automatic}|Null],_,False,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,_,Except[{Automatic}|Null],False,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,_,_,False,Except[{Automatic}|Null]}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,_,_,False,_}, True,
			{Alternatives[Optimize,TemperatureSweep],Except[Automatic|Null],_,_,_,True,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,Except[{Automatic}|Null],_,_,True,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,Except[{Automatic}|Null],_,True,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,_,Except[{Automatic}|Null],True,_}, True,
			{Alternatives[Optimize,TemperatureSweep],_,_,_,_,True,Except[{Automatic}|Null]}, True,
			(*Otherwise, this is false*)
			{Alternatives[Optimize,TemperatureSweep],Automatic|Null,{Automatic}|Null,{Automatic}|Null,{Automatic}|Null,True,{Automatic}|Null}, False,
			{Except[Optimize,TemperatureSweep],_,_,_,_,_,_}, False,
			{_,_,_,_,_,_,_}, False
		];

		(* Pull out what inputs are failing *)
		{failingExploratoryTempSweepInput,failingExploratoryTempSweepOption} = If[exploratoryTempSweepParameterError,
			Module[{failingIntInput,failingInputs,failingInputPos,failingOptions},
				failingIntInput = Cases[{supMeasurementMethodTable,supFlowRate,supEquilibrationTime,supMeasurementTime,priming},Except[Null|Automatic|{Ambient}|{Automatic}|True]];

				(* Pull out what options are failing *)
				(* Get the positions of the failing inputs *)
				failingInputPos = Position[{supMeasurementMethodTable,supFlowRate,supEquilibrationTime,supMeasurementTime,priming},Except[Null|Automatic|{Ambient}|{Automatic}|True],1, Heads->False];
				failingOptions = Part[{MeasurementMethodTable,FlowRate,EquilibrationTime,MeasurementTime,Priming},Flatten[failingInputPos]];

				(*Map the option to its failing value *)
				failingInputs = AssociationThread[failingOptions,failingIntInput];

				(* return the failing options *)
				{failingInputs,failingOptions}
			],

			(*Else these are just Null*)
			{Null,Null}
		];

		(* Conflicting options check: make sure that any provided values for MeasurementTime, EquilibrationTime, and FlowRate are in agreement there should be a 1:1:1 mapping of them if they are not automatic *)
		measurementParameterError = Switch[{supFlowRate,supEquilibrationTime,supMeasurementTime},
			(* If either FlowRate, EquilibrationTime, or MeasuremetTime is specified, the other values cannot be null *)
			{Except[{Automatic}],Null|{Null},_},True,
			{Except[{Automatic}],_,Null|{Null}},True,
			{Null|{Null},Except[{Automatic}],_},True,
			{Null|{Null},_,Except[{Automatic}]},True,
			{_,Null|{Null},Except[{Automatic}]},True,
			{Except[{Automatic}],Null|{Null},_},True,

			(*If Flow Rate is specified, and equilibration time is specified, the length of the entries in flow rate should equal that of the equilibration time *)
			{Except[{Automatic}],Except[{Automatic}],_}, !MatchQ[Length[supFlowRate],Length[supEquilibrationTime]],
			(*If Flow Rate is specified, and measurement time is specified, the length of the entries in flow rate should equal that of the measurement time *)
			{Except[{Automatic}],_,Except[{Automatic}]}, !MatchQ[Length[supFlowRate],Length[supMeasurementTime]],
			(*If all three are specified, they should all be equal *)
			{Except[{Automatic}],Except[{Automatic}],Except[{Automatic}]}, !And[MatchQ[Length[supFlowRate],Length[supMeasurementTime]],MatchQ[Length[supFlowRate],Length[supEquilibrationTime]]],

			(*If FlowRate is automatic, equilibration time and measurement time should be equal if provided *)
			{{Automatic},Except[{Automatic}],Except[{Automatic}]},!MatchQ[Length[supEquilibrationTime],Length[supMeasurementTime]],

			(*Default to false if all else fails*)
			{_,_,_},False
		];

		(* Pull out what inputs are failing *)
		{failingMeasurementParameterInput,failingMeasurementParameterOption} = If[measurementParameterError,
			Module[{assoc,notAutomatic,nulls,failingIntInput,failingInputs,failingInputPos,failingOptions},

				(*Make an association of the parameters*)
				assoc = AssociationThread[{FlowRate,EquilibrationTime,MeasurementTime},{supFlowRate,supEquilibrationTime,supMeasurementTime}];

				(*Get the options that are not automatic and not null *)
				notAutomatic = Select[assoc, MatchQ[Except[Automatic|Null]]];

				(*Get the options that are Null*)
				nulls =	Select[notAutomatic, MatchQ[Null|{Null}]];

				{failingInputs,failingOptions} = Which[
					(*If all three options are nulls OR if 2 options are null, the third does not need to be error checked so save the Null options*)
					MatchQ[Length[nulls],2|3],
					{nulls,Keys[nulls]},

					(* If only one option is Null, we need to check the length of the other two options to see if they conflict also *)
					MatchQ[Length[nulls],1],
					Module[{vals,sameLen,failingAssoc},
						(*Extract the values of the non-automatic Keys*)
						vals = Values[notAutomatic];
						failingAssoc = assoc;
						{failingAssoc,Keys[failingAssoc]}
					],

					(*Otherwise, all three options are not null and not automatic and at least one has a different length *)
					True,
					{assoc,Keys[assoc]}
					]
				],

			(*Else these are just Null*)
			{Null,Null}
		];

		(* Check that if the MeasurementMethod is specified as FlowRateSweep then there is only one measurementTemperature specified and MeasurementMethodTable is Automatic/Null - *)
		shearSweepParameterError = Switch[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supTargetPressure},
			{FlowRateSweep,_,{TemperatureP|Ambient|Automatic,TemperatureP|Ambient..},_},True,
			{FlowRateSweep,Except[Automatic|Null],_,_},True,
			{FlowRateSweep,_,_,{PercentP..}},True,
			(*ONE measurementTemp is specified so it is okay*)
			{FlowRateSweep,_,{Ambient|TemperatureP},_},False,
			{Except[FlowRateSweep],_,_,_}, False
		];

		(* Pull out what inputs are failing *)
		{failingShearSweepInput,failingShearSweepOption} = If[shearSweepParameterError,
			Module[{failingIntInput,failingInputs,failingInputPos,failingOptions},
				failingIntInput = Cases[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supTargetPressure},Except[Null|Automatic|{Ambient}|{Automatic}]];

				(* Pull out what options are failing *)
				(* Get the positions of the failing inputs *)
				failingInputPos = Position[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supTargetPressure},Except[Null|Automatic|{Ambient}|{Automatic}],1, Heads->False];
				failingOptions = Part[{MeasurementMethod,MeasurementMethodTable,MeasurementTemperature,RelativePressure},Flatten[failingInputPos]];

				(*Map the option to its failing value *)
				failingInputs = AssociationThread[failingOptions,failingIntInput];

				(* return the failing options *)
				{failingInputs,failingOptions}
			],

			(*Else these are just Null*)
			{Null,Null}
		];

		(* Check that if the MeasurementMethod is specified as RelativePressureSweep then there is only one measurementTemperature specified, Priming is true,the Measurement and Equilibration Times are Automatic or Null and MeasurementMethodTable and FlowRate are Automatic/Null - *)
		pressureSweepParameterError = Switch[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supFlowRate,supEquilibrationTime,supMeasurementTime,priming},
			{RelativePressureSweep,_,{TemperatureP|Ambient|Automatic,TemperatureP|Ambient..},_,_,_,_},True,
			{RelativePressureSweep,Except[Automatic|Null],_,_,_,_,_},True,
			{RelativePressureSweep,_,_,Except[{Automatic}|Null],_,_,_},True,
			{RelativePressureSweep,_,_,_,Except[{Automatic}|Null],_,_},True,
			{RelativePressureSweep,_,_,_,_,Except[{Automatic}|Null],_},True,
			(*Priming has to be true*)
			{RelativePressureSweep,_,_,_,_,_,False},True,
			(*ONE measurementTemp is specified so it is okay*)
			{RelativePressureSweep,_,{Ambient|TemperatureP},_,_,_,True},False,
			{Except[RelativePressureSweep],_,_,_,_,_,_}, False
		];

		(* Pull out what inputs are failing *)
		{failingPressureSweepInput,failingPressureSweepOption} = If[pressureSweepParameterError,
			Module[{failingIntInput,failingInputs,failingInputPos,failingOptions},
				failingIntInput = Cases[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supFlowRate,priming},Except[Null|Automatic|{Ambient}|{Automatic}|True]];

				(* Pull out what options are failing *)
				(* Get the positions of the failing inputs *)
				failingInputPos = Position[{supMeasurementMethod,supMeasurementMethodTable,supMeasurementTemperature,supFlowRate,priming},Except[Null|Automatic|{Ambient}|{Automatic}|True],1, Heads->False];
				failingOptions = Part[{MeasurementMethod,MeasurementMethodTable,MeasurementTemperature,FlowRate,Priming},Flatten[failingInputPos]];

				(*Map the option to its failing value *)
				failingInputs = AssociationThread[failingOptions,failingIntInput];

				(* return the failing options *)
				{failingInputs,failingOptions}
			],

			(*Else these are just Null*)
			{Null,Null}
		];

		(* Resolve the MeasurementMethod *)
		measurementMethod = If[MatchQ[supMeasurementMethod, Automatic],
			Switch[{supMeasurementTemperature,supFlowRate,supEquilibrationTime,supMeasurementTime,priming,supMeasurementMethodTable,supTargetPressure},
				(*One MeasurementTemperature is specified and everything else is automatic/true *)
				{{TemperatureP|Ambient|Automatic|Null},{Automatic|Null},{Automatic|Null},{Automatic|Null},Except[False],Automatic|Null,{Automatic|Null}},Optimize,

				(*More than one MeasurementTemperature is specified, but everthing else is automatic/True*)
				{{Alternatives[TemperatureP,Ambient]..},{Automatic|Null},{Automatic|Null},{Automatic|Null},Except[False],Automatic|Null,{Automatic|Null}},TemperatureSweep,

				(*More than one FlowRate is specified, and one measurement temp is specified. The other values can be specified or not*)
				{{TemperatureP|Automatic|Ambient|Null},{FlowRateP..},_,_,_,Automatic|Null,_},FlowRateSweep,

				(*More than one TargetPressure is specified, and one measurement temp is specified. The other values can be specified or not*)
				{{TemperatureP|Automatic|Ambient|Null},{Automatic|Null},_,_,_,Automatic|Null,{PercentP..}},RelativePressureSweep,

				(*One TargetPressure and one FloeRate are specified, and one measurement temp is specified. The other values can be specified or not*)
				{{TemperatureP|Automatic|Ambient|Null},{FlowRateP}|FlowRateP,_,_,_,Automatic|Null,PercentP|{PercentP}},Custom,

				(* Otherwise, the user wants a completely custom protocol*)
				{_,_,_,_,_,_,_},Custom
			],
			(*Otherwise, the user supplied a value, so use that*)
			supMeasurementMethod
		];

		(* Resolve master switches *)
		{
			measurementTemperature,
			flowRate,
			targetPressure,
			equilibrationTime,
			measurementTime,
			pauseTime,
			numberOfReadings,
			measurementMethodTable,
			tempSweepInsufficientError,
			shearRateSweepInsuffcientError,
			customPressurePrimeError,
			customPressureTimeWarning,
			customPressureFlowRateError
		} = Switch[measurementMethod,
			(*Case 1: Optimize. Instrument determines appropriate parameters *)
			Optimize, Module[{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,
						primingStep,measSteps,tempSweepError,shearRateSweepError
				},

				(*resolve the measurement temperature*)
				resMeasurementTemperature = If[MatchQ[supMeasurementTemperature, Alternatives[{Automatic},{Ambient},Automatic,Ambient]],
					25 Celsius,
					supMeasurementTemperature[[1]]
				];

				(*resolve the number of readings *)
				resNumberOfReadings = If[MatchQ[supNumberOfReadings, Automatic],
					(* Default to 10 readings if the user did not supply anything *)
					10,
					supNumberOfReadings
				];

				(*Resolve the pauseTime*)
				resPauseTime = If[MatchQ[supPauseTime,{Automatic}|Null|Automatic],
					0 Second,
					supPauseTime
				];

				(* The following options should be Null and will be determined by the instrument during the experiment run. If the user specified a value, we will have thrown an error above*)
				resFlowRate = If[MatchQ[supFlowRate,{Automatic}|Automatic|Null],
					Null,
					supFlowRate
				];

				resTargetPressure =  If[MatchQ[supTargetPressure,{Automatic}|Automatic|Null],
					Null,
					supTargetPressure
				];

				resEquilibrationTime = If[MatchQ[supEquilibrationTime,{Automatic}|Automatic|Null],
					Null,
					supEquilibrationTime
				];

				resMeasurementTime = If[MatchQ[supMeasurementTime,{Automatic}|Automatic|Null],
					Null,
					supMeasurementTime
				];

			(* Put together the measurement table *)
			(*The measurement table columns are as follows: (1) MeasurementTemperature (2)Flow Rate (3)TargetPressure (4) Equilibration Time (5) measurement times (6)Pause Time (7) priming, (8)Number of readings*)
				(* The priming step is the first step *)
				primingStep = {resMeasurementTemperature,Null,Null,Null,Null,resPauseTime,True,1};

				(* The measurement steps are the subseuqent steps *)
				measSteps = {resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,resPauseTime,False,resNumberOfReadings};

				(*The measurement table is just the priming step + measurement steps *)
				resMeasurementMethodTable = {primingStep,measSteps};

			(* The error checking booleans are all irrelevant here and should be False*)
				tempSweepError = tempSweepInsufficientError;
 				shearRateSweepError=shearRateSweepInsuffcientError;


			(*Return all the resolved values*)
				{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
					resPauseTime,resNumberOfReadings,resMeasurementMethodTable,tempSweepError,shearRateSweepError,
					customPressurePrimeError,customPressureTimeWarning,customPressureFlowRateError}
			],

			(*Case 2: TemperatureSweep*)
			TemperatureSweep, Module[{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,
						prime,measSteps,tempSweepError,shearRateSweepError},

				(* Resolve the measurement temperature *)
				{resMeasurementTemperature,tempSweepError} = If[MatchQ[supMeasurementTemperature, {Automatic}|{Ambient}|Automatic|Ambient],
						(* No values are supplied so, we list a generic set of temperatures and we set the tempSweep error to False *)
						{{20 Celsius, 25 Celsius, 30 Celsius, 35 Celsius, 40 Celsius},False},

						(* Else, the user supplied values, so we use theirs and we need to do some error checking to make sure they have at least 1 temperature to make it a TemperatureSweep*)
						Module[{moreThanOneTemp},
							moreThanOneTemp = If[Greater[Length[supMeasurementTemperature],1],
								(*The user gave more than one measurement Temperature so this is False*)
								False,
								(*The user gave more than one measurement Temperature so this is False*)
								True
							];
							{supMeasurementTemperature,moreThanOneTemp}
						]
					];

				(* Resolve the number of readings *)
				resNumberOfReadings = If[MatchQ[supNumberOfReadings, Automatic],
					(* Default to 5 readings if the user did not supply anything *)
					5,
					supNumberOfReadings
				];

				(* Resolve the pause time*)
				resPauseTime = If[MatchQ[supPauseTime,{Automatic}|Null|Automatic|{Null}],
					0 Second,
					supPauseTime
				];

				(* The following options should be Null and will be determined by the instrument during the experiment run. If the user specified a value, we will have thrown an error above*)
				resFlowRate = If[MatchQ[supFlowRate,{Automatic}|Null|Automatic],
					Null,
					supFlowRate
				];

				resEquilibrationTime = If[MatchQ[supEquilibrationTime,{Automatic}|Null|Automatic],
					Null,
					supEquilibrationTime
				];

				resTargetPressure = If[MatchQ[supTargetPressure,{Automatic}|Null|Automatic],
					Null,
					supTargetPressure
				];

				resMeasurementTime = If[MatchQ[supMeasurementTime,{Automatic}|Null|Automatic],
					Null,
					resMeasurementTime
				];

				(* The error checking booleans for the shearRateSweep are irrelevant here and should be False*)
			 	shearRateSweepError=shearRateSweepInsuffcientError;

				(* Put together the measurementTable *)
					(* First, generate the priming steps for each temperature *)
					prime = {#,Null,Null,Null,Null,resPauseTime,True,1}&/@resMeasurementTemperature;

					(* Second, generate the measurement steps for each reading *)
					measSteps = {#,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,resPauseTime,False,resNumberOfReadings}&/@resMeasurementTemperature;

					(* Finally, riffle the priming steps and measurement steps so that the table has the following row orders 1. Priming at Temp 1 2. Measurement at Temp 1, 3. Priming at temp 2...*)
					resMeasurementMethodTable = Riffle[prime,measSteps];

				(*Return all the resolved values*)
				{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
					resPauseTime,resNumberOfReadings,resMeasurementMethodTable,tempSweepError,shearRateSweepError,
					customPressurePrimeError,customPressureTimeWarning,customPressureFlowRateError
				}
			],

			(*Case 3: FlowRateSweep*)
			FlowRateSweep, Module[{resMeasurementTemperature,resFlowRate,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,resTargetPressure,
						primingStepFlow,measStepsFlow,measSteps,tempSweepError,shearRateSweepError},

						(* Resolve the measurement temperature *)
						resMeasurementTemperature = If[MatchQ[supMeasurementTemperature, Automatic|Ambient|{Ambient}|{Automatic}],
							(* No values are supplied so, we set this to 25 C *)
							25 Celsius,
							(* Else, the user supplied a value, so we use theirs *)
							supMeasurementTemperature[[1]]
						];

						(* Resolve the number of readings *)
						resNumberOfReadings = If[MatchQ[supNumberOfReadings, Automatic],
							(* Default to 3 readings if the user did not supply anything *)
							3,
							supNumberOfReadings
						];

						(* Resolve the Target Pressures. Note: users may specify FlowRates and TargetPressures, just not for the same measurement step. However if we resolve to FlowRateSweep, only FLowRates will be specified (we will have resolved to custom otherwise) *)
						resTargetPressure = If[MatchQ[supTargetPressure, {Automatic}|Automatic],
							(* Case 1: No Target Pressure is specified so we default this to Null*)
							Null,
							(*Otherwise, the user provided a value and we will have thrown an error above*)
							supTargetPressure
						];

						(* Resolve the flow rates  *)
							(*No Flow Rate is specified, so we need to come up with some FlowRates *)
							(*Try to resolve based on any supplied Measurement Times or EquilibrationTimes*)
							resFlowRate = If[MatchQ[supFlowRate,Automatic|{Automatic}],
								Which[
									(*If they provided a MeasurementTime, try to resolve a flow rate around that *)
									MatchQ[supMeasurementTime, Except[{Automatic}|Null]],
										Switch[#,
											GreaterEqualP[2 Second], 100 Microliter/Minute,
											_,SafeRound[Convert[1.6667 Microliter/#, Microliter/Minute],1 Microliter/Minute]
										]&/@supMeasurementTime,

										(*If they provided an EquilibrationTime, try to resolve a flow rate around that *)
										MatchQ[supEquilibrationTime, Except[{Automatic}|Null]],
											Switch[#,
												GreaterEqualP[1.6 Second], 100 Microliter/Minute,
												RangeP[1 Second, 1.6 Second], 75 Microliter/Minute,
												_,25 Microliter/Minute
											]&/@supEquilibrationTime,

										(*Otherwise, no values are supplied so, we set this to an fixed set of flow rates. We will be conservative here *)
										True, {250 Microliter/Minute, 100 Microliter/Minute, 50 Microliter/Minute, 25 Microliter/Minute, 10 Microliter/Minute}
								],

							(* Otherwise, the user provided values for the flow rate so we just use their values*)
						 	supFlowRate
						];

						(* We need to make sure that they supplied more than 1 flow rate to make it a true sweep *)
						shearRateSweepInsuffcientError = !Greater[Length[resFlowRate],1]; (* this is now a Warning*)

					(* Resolve the PauseTime *)
					resPauseTime = If[MatchQ[supPauseTime,{Automatic}|Null|Automatic],
						0 Second,
						supPauseTime
					];

					(* Resolve the Equilibration Time for each flow rate. The Equilibration time is depenent on each flow rate *)
					resEquilibrationTime = If[MatchQ[supEquilibrationTime,{Automatic}|Null|Automatic],
						(* We need to resolve the equilibration times *)
						Which[
							(* For flow rates > 100 ul/Minute, we need a 1.6 second equilibration time *)
							GreaterEqual[#,100 Microliter/Minute], 1.6 Second,

							(* For flow rates between 50 and 100 ul/Minute, the equilibration time should be equal to 1.666 divided by the flow rate. We also should round*)
							Between[#,{50 Microliter/Minute,100 Microliter/Minute}], SafeRound[Convert[1.66667 Microliter/#,Second], 0.2 Second],

							(*Otherwise, we divide 3.333 by the Flow rate and round *)
							True, SafeRound[Convert[3.3333 Microliter/#,Second], 0.2 Second]
						]&/@resFlowRate,

						(*Otherwise, the user provided values, so we use those*)
						supEquilibrationTime
					];

					(* Resolve the Measurement Time for each flow rate. The MeasurementTime is dependent on each flow rate *)
					resMeasurementTime = If[MatchQ[supMeasurementTime,{Automatic}|Null|Automatic],
						(* We need to resolve the measurement times based on the flow rate*)
						If[
							(* For flow rates > 100 ul/Minute, we need a 2 second measurement time *)
							GreaterEqual[#,100 Microliter/Minute],2 Second,

							(*Otherwise, calculate based on flow rate. This is based on the manufacturer's recommendations*)
							SafeRound[Convert[1.6667 Microliter/#, Second],0.2 Second]
						]&/@resFlowRate,

						(*Otherwise, the user provided values, so we use those*)
						supMeasurementTime
					];

					(* Put together the measurementTable *)
						(* First, generate a priming step before a measurement at a particular FlowRate if the user indicated they wanted it *)
						primingStepFlow = If[MatchQ[priming,True],
							(* Priming is true so we need to generate a priming step *)
							{resMeasurementTemperature,Null,Null,Null,Null,resPauseTime,True,1},
							(*Otherwise, they did not want to prime, so do nothing*)
							{}
						];

						(* Second, generate the measurement steps for each reading at each FlowRate. If we have thrown errors above, set this to Null *)
						measStepsFlow = If[!measurementParameterError,
							MapThread[
								Function[{flow,equil,meas},
									{resMeasurementTemperature,flow,Null,equil,meas,resPauseTime,False,resNumberOfReadings}
								],
								{resFlowRate,resEquilibrationTime,resMeasurementTime}
							],
							{}
						];

						(* Finally,combine any priming steps and measurement steps so that the table has the following row orders 1. Priming  2. Measurement at FlowRate1 ...*)
						resMeasurementMethodTable = DeleteCases[Join[{primingStepFlow},measStepsFlow],{}];

					(* The error checking booleans related to the temperature sweep is irrelevant here and should be False*)
					tempSweepError = tempSweepInsufficientError;

				(*Return all the resolved values*)
					{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,tempSweepError,shearRateSweepInsuffcientError,
						customPressurePrimeError,customPressureTimeWarning,customPressureFlowRateError
					}
				],

			(* Case 4: RelativePressureSweep *)
			RelativePressureSweep, Module[{resMeasurementTemperature,resFlowRate,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,resTargetPressure,
						primingStepFlow,primingStepPressure,measSteps,tempSweepError,shearRateSweepError,measStepsPressure},

						(* Resolve the measurement temperature *)
						resMeasurementTemperature = If[MatchQ[supMeasurementTemperature, Automatic|Ambient|{Ambient}|{Automatic}],
							(* No values are supplied so, we set this to 25 C *)
							25 Celsius,
							(* Else, the user supplied a value, so we use theirs *)
							supMeasurementTemperature[[1]]
						];

						(* Resolve the number of readings *)
						resNumberOfReadings = If[MatchQ[supNumberOfReadings, Automatic],
							(* Default to 3 readings if the user did not supply anything *)
							3,
							supNumberOfReadings
						];

						(* Resolve the Target Pressures. Note: users may specify FlowRates and TargetPressures, just not for the same measurement step *)
						resTargetPressure = If[
							(* No Target Pressure is specified and no flow rates are specified so we default to a preset range of TargetPressures*)
							MatchQ[supTargetPressure, {Automatic}|Automatic] && MatchQ[supFlowRate,Null|Automatic|{Automatic}],
							{10 Percent, 20 Percent, 30 Percent, 40 Percent, 50 Percent, 60 Percent, 70 Percent, 80 Percent, 90 Percent},

							(* Otherwise, the user provided values for RelativePressure so we just use their values*)
							supTargetPressure
						];

						(* Resolve the flow rates  *)
						resFlowRate = If[MatchQ[supFlowRate, {Automatic}|Automatic],
							(* No Flow Rate is specified so we default this to Null *)
							Null,

							(* Otherwise, the user provided values for both the flow rate and RelativePressure, so we just use their values and will have thrown an error above*)
							supFlowRate
						];

						(* We need to make sure that they supplied more than 1 flow rate to make it a true sweep *)
						shearRateSweepInsuffcientError = Null; (*TODO remove this error check?*)

					(* Resolve the PauseTime *)
					resPauseTime = If[MatchQ[supPauseTime,{Automatic}|Null|Automatic],
						0 Second,
						supPauseTime
					];

					(* Resolve the Equilibration Time for each flow rate. The Equilibration time is depenent on each flow rate, but will default to Null (to allow the instrument to determine the appropriate values in the case of the RelativePressureSweep) *)
					resEquilibrationTime = If[MatchQ[supEquilibrationTime,{Automatic}|Null|Automatic],
						Null,

						(*Otherwise, the user provided values, so we use those*)
						supEquilibrationTime
					];

					(* Resolve the Measurement Time for each flow rate. The MeasurementTime is dependent on each flow rate *)
					resMeasurementTime = If[MatchQ[supMeasurementTime,{Automatic}|Null|Automatic],
						Null,

						(*Otherwise, the user provided values, so we use those*)
						supMeasurementTime
					];

					(* Put together the measurementTable *)
						(* First, generate a priming step before a measurement at a specified RelativePressure if the user indicated they wanted it *)

						(* If TargetPressure is not Null, we MUST add a Priming step at 90 Percent TargetPressure, repeated 6 times, as required by the instrument *)
						primingStepPressure = If[MatchQ[priming,True] && !NullQ[resTargetPressure],
							(* Priming is true so we need to generate a priming step *)
							{resMeasurementTemperature,Null,90 Percent,Null,Null,resPauseTime,True,6},
							(*Otherwise, they did not want to prime, so do nothing*)
							{}
						];

						measStepsPressure = If[!measurementParameterError,
							{resMeasurementTemperature,Null,#,resEquilibrationTime,resMeasurementTime,resPauseTime,False,resNumberOfReadings}&/@resTargetPressure,
							{}
						];

						(* Finally,combine any priming steps and measurement steps so that the table has the following row orders 1. Priming  2. Measurement at FlowRate1 ...*)
						resMeasurementMethodTable = DeleteCases[Join[{primingStepPressure},measStepsPressure],{}];

					(* The error checking booleans related to the temperature sweep is irrelevant here and should be False*)
					tempSweepError = tempSweepInsufficientError;

				(*Return all the resolved values*)
					{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,tempSweepError,shearRateSweepInsuffcientError,
						customPressurePrimeError,customPressureTimeWarning,customPressureFlowRateError
					}
				],

			(* Case 5: Custom *)
			Custom, Module[{resMeasurementTemperature,resFlowRate,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,specifiedTableBool,
						tempSweepError,shearRateSweepError,customNumReadings,flowRateWithTimes,joinedTable,
						flowPressureBothSpecifiedError,timePressureBothSpecified,pressureNoPriming,pressuresWithTimes,
						measStepsFlow,measStepsPressure,resTargetPressure},

				(* If they selected custom, but did not fill out the MeasurementTable, we will populate it with a few measurement steps as a default.
 						Or if they did not specifically set MeasurementMethod as Custom, but we resolved to it, we will try to make a measurement table out of what they gave us *)
				{
					resMeasurementMethodTable,
					specifiedTableBool,
					flowPressureBothSpecifiedError,
					timePressureBothSpecified,
					pressureNoPriming
				} = If[MatchQ[supMeasurementMethodTable,Automatic],
					Module[{customMeasTemps,customFlowRate,customEquilTime,customMeasTime,customPauseTime,primingStepFlow,primingStepPressure,measSteps,tempFlowTuple,customTargetPressure},
						customMeasTemps = If[MatchQ[supMeasurementTemperature,{Automatic}|Null|Ambient|{Ambient}],
							{25 Celsius},
							supMeasurementTemperature
						];

						customFlowRate = Which[
						(*case 1 : No flow rate is specified and Target Pressure is set to Null*)
						MatchQ[supFlowRate,{Automatic}|Null],
							Which[
								(*If they provided a MeasurementTime, try to resolve a flow rate around that *)
								MatchQ[supMeasurementTime, Except[{Automatic}|Null]],
									Switch[#,
										GreaterEqualP[2 Second], 100 Microliter/Minute,
										_,SafeRound[Convert[1.6667 Microliter/#, Microliter/Minute],1 Microliter/Minute]
									]&/@supMeasurementTime,

									(*If they provided an EquilibrationTime, try to resolve a flow rate around that *)
									MatchQ[supEquilibrationTime, Except[{Automatic}|Null]],
										Switch[#,
											GreaterEqualP[1.6 Second], 100 Microliter/Minute,
											RangeP[1 Second, 1.6 Second], 75 Microliter/Minute,
											_,25 Microliter/Minute
										]&/@supEquilibrationTime,

								(*Otherwise, we pick a couple of flow rates *)
								True, {100 Microliter/Minute,50 Microliter/Minute}
							],
							(*case 2 : Values are provided in TargetPressure so we will set FlowRate to Null *)
							!MatchQ[supTargetPressure,Null|{Automatic}],
							Null,

							(*Case 3/Default the user provided some values for flow rate so we just use theirs*)
							True, supFlowRate
						];

						customTargetPressure = Which[
							(*case 1 : No Target Pressure is specified and customFlowRate is resolved to Null so we pick a set of percentages*)
							MatchQ[supTargetPressure,{Automatic}] && MatchQ[customFlowRate,Null],
							{10 Percent, 20 Percent, 30 Percent, 40 Percent, 50 Percent, 60 Percent, 70 Percent, 80 Percent, 90 Percent},

							(*case 2 : Values are provided in FlowRate so we will set TargetPressure to Null *)
							!MatchQ[customFlowRate,Null],
							Null,

							(*Case 3/Default the user provided some values for TargetPressure so we just use theirs*)
							True, supTargetPressure
						];

						(* Calculate a couple of Equilibration Times if they are not already provided and if flow rates are provided*)
						customEquilTime = Which[
							(*case 1: customFlowRate is not Noull and the equilbration time is not specified, so we resolve values based on flow rate *)
							MatchQ[supEquilibrationTime,{Automatic}|Null] && !NullQ[customFlowRate],
							Which[
								(* For flow rates > 100 ul/Minute, we need a 1.6 second equilibration time *)
								GreaterEqual[#,100 Microliter/Minute], 1.6 Second,

								(* For flow rates between 50 and 100 ul/Minute, the equilibration time should be equal to 1.666 divided by the flow rate. We also should round*)
								Between[#,{50 Microliter/Minute,100 Microliter/Minute}], SafeRound[Convert[1.66667 Microliter/#,Second], 0.2 Second],

								(*Otherwise, we divide 3.333 by the Flow rate and round *)
								True, SafeRound[Convert[3.3333 Microliter/#,Second], 0.2 Second]
							]&/@customFlowRate,

							(*case 2: customFlowRate is Null but values are provided in customTargetPressure so we set this to null since it will be determined by the instrument *)
							MatchQ[supEquilibrationTime,{Automatic}|Null] && !NullQ[customTargetPressure] && NullQ[customFlowRate],
							Null,

							(* case 3 Otherwise, the user provided a value, so use that. *)
							True,
							supEquilibrationTime
						];

						(* Calculate a couple of measurement Times if they are not already provided*)
						customMeasTime = Which[
							(*case 1: customFlowRate is not Null and the measurement time is not specified, so we resolve values based on flow rate *)
							MatchQ[supMeasurementTime,{Automatic}|Null] && !NullQ[customFlowRate],
							If[
								(* For flow rates > 100 ul/Minute, we need a 2 second measurement time *)
								GreaterEqual[#,100 Microliter/Minute],2 Second,

								(*Otherwise, calculate based on flow rate. This is based on the manufacturer's recommendations*)
								SafeRound[Convert[1.6667 Microliter/#, Second],0.2 Second]
							]&/@customFlowRate,

							(* Case 2: customFlowRate is Null but values are provided in customTargetPressure so we set this to null since it will be determined by the instrument *)
							MatchQ[supEquilibrationTime,{Automatic}|Null] && !NullQ[customTargetPressure] && NullQ[customFlowRate],
							Null,

							(* Case 3: Otherwise, the user provided a value, so use that. *)
							True,
							supMeasurementTime
						];

						(* Set the pauseTime*)
						customPauseTime = If[MatchQ[supPauseTime,Automatic|Null],
							0 Second,
							supPauseTime
						];

						customNumReadings = If[MatchQ[supNumberOfReadings,Automatic|Null],
							3,
							supNumberOfReadings
						];

						(* Put together the measurement steps*)
						(* First, Add in a priming step if they indicated one. we need to make a priming step separately for TargetPressures*)
						primingStepFlow = If[MatchQ[priming,True],
							(* Priming is true so we need to generate a priming step *)
							{#,Null,Null,Null,Null,customPauseTime,True,1}&/@customMeasTemps,
							(*Otherwise, they did not want to prime, so do nothing*)
							{}
						];

						(*add a priming step repeated 6 times if TargetPressures is not Null *)
						primingStepPressure = If[MatchQ[priming,True] && !NullQ[customTargetPressure],
							(* Priming is true so we need to generate a priming step *)
							{#,Null,Null,Null,Null,customPauseTime,True,6}&/@customMeasTemps,
							(*Otherwise, they did not want to prime, so do nothing. we will have thrown an error above*)
							{}
						];

						(* Second, generate the measurement steps for each reading. *)
							(* Put together the FlowRates, EquilibrationTime, MeasurementTIme, Pause, Time and number of readings *)
							flowRateWithTimes = If[!measurementParameterError,
								MapThread[Function[{flow,equil,meas},
										{flow,Null,equil,meas,customPauseTime,False,customNumReadings}
									],
									{customFlowRate,customEquilTime,customMeasTime}
								],
								{}
							];

							(* Put together the TargetPressure and the number of readings. The times are Null *)
							pressuresWithTimes = {Null,#,Null,Null,customPauseTime,False,customNumReadings}&/@customTargetPressure;

							(* Append the Tempeartures. We need to do a nested Map if cutsomFlowRates is not Null *)
							measStepsFlow = If[!NullQ[customFlowRate],
								Map[
									Map[Function[flows,
										Join[{#},flows]
										],
									flowRateWithTimes
									]&,
								customMeasTemps
								],
							(* If customFlowRate is Null, just make this an empty list*)
							{}
							];

							(* Append the Tempeartures to each Target Pressure. We need to do a nested Map if customTargetPressure is not null *)
							measStepsPressure = If[!NullQ[customTargetPressure],
 								Map[
										Map[Function[pressures,
											Join[{#},pressures]
										],
									pressuresWithTimes
									]&,
								customMeasTemps
								],
								{}
							];

							(* Finally,combine any priming steps and measurement steps so that the table has the following row orders 1. Priming  2. Measurement at FlowRate1 ...*)
							joinedTable = Flatten[DeleteCases[Join[{primingStepFlow},measStepsFlow,{primingStepPressure},measStepsPressure],{}],1];
							(*Order everything by measurementTemperature. the Booleans are all false*)
							{SortBy[joinedTable,First],False,False,False,False}
					],
					(*Else, they specified something so use their inputs *)
					(* We need to check to make sure everything is set to an appropriate value or Null *)
					Module[{checkedMeasTempTable,automatedMeasurementStepQ,primeInPreviousStep,pressurePrimecCheck,pressureRows,pressureQ,invalidMeasurementTableBool,flowPressureError,
							timePressureError,flowPressureErrorCollapsed,timePressureErrorCollapsed},
						(* Check whether each step is an automated measurement priming step (Priming is true, and FlowRate, EquilibrationTime,EquilibrationTime,and MeasurementTime are Null or 0). We need this for error checking and resolving *)
						automatedMeasurementStepQ = And[
							(* We are priming *)
							#[[6]],
							(*FlowRate is Null (it cannot be 0 here) *)
							NullQ[#[[2]]],
							(*RelativePressure is Null*)
							NullQ[#[[3]]],
							(* Equilibration Time is 0 or Null *)
							MatchQ[#[[4]],Alternatives[Null,0 Second]],
							(*MeasurementTime is Null or 0 *)
							MatchQ[#[[5]],Alternatives[Null,0 Second]]
						]&/@supMeasurementMethodTable;

						(* Go through each memebr of automatedMeasurementStepQ and reutrn a new T/F list that states whether the previous step was an automated priming step. We need this for error checking and resolving *)
						(* The first entry will always be false and we can take Most[automatedMeasurementStepQ] since we don't need to assess the last element of automatedMeasurementStepQ *)
						primeInPreviousStep = Join[{False},Most[automatedMeasurementStepQ]];

						(* Go through each row in the measurement method table and change any Automatics to a value*)
						{
							checkedMeasTempTable,
							flowPressureError,
							timePressureError
						} = Transpose@MapThread[
							Function[{measTable,prevPrime},
								Module[{measTemp,prime,flowRates,pressure,equilTime,measTime,pause,flowPressure,timePressure,pressureNoPrime},

									(*Automatic or Ambient MeasurementTemperatures should be changed to 25 Celsius*)
									measTemp = measTable[[1]]/.Alternatives[Automatic,Ambient]->25 Celsius;

									(* check if we are priming in this step *)
									prime = MatchQ[measTable[[7]],True];

									(* FlowRate is either Null or specified. *)
									flowRates = measTable[[2]];

									(* RelativePressure is either Null or specified. *)
									pressure = measTable[[3]];

									(* If we are Priming, EquilibrationTime can be set to Null if it is not specified *)
									equilTime = If[
										MatchQ[measTable[[4]],Automatic],
										(* If EquilibrationTime is utomatic, we need to resolve based on FlowRate, whether this is a priming step, and whether the previous step was a priming step *)
										Which[
											(* If FlowRate is not Null, resolve based on the FlowRate*)
											FlowRateQ[flowRates],
											Switch[flowRates,
												(* For flow rates > 100 ul/Minute, we need a 1.6 second equilibration time *)
												GreaterEqualP[100 Microliter/Minute], 1.6 Second,

												(* For flow rates between 50 and 100 ul/Minute, the equilibration time should be equal to 1.666 divided by the flow rate. We also should round*)
												RangeP[{50 Microliter/Minute,100 Microliter/Minute}], SafeRound[Convert[1.66667 Microliter/flowRates,Second], 0.2 Second],

												(*Otherwise, we divide 3.333 by the Flow rate and round *)
												_, SafeRound[Convert[3.3333 Microliter/flowRates,Second], 0.2 Second]
											],

											(* If this is a priming step, set this to Null *)
											prime, Null,

											(* If EqulibrationTime is Automatic, FlowRate is Null and the previous step was a primeStep, set this to Null *)
											NullQ[flowRates] && prevPrime, Null,

											(*If pressure is specified, set this to Null since it will be determined by the instrument*)
											MatchQ[pressure,PercentP],Null,

											(* If all else fails, set this to a set value *)
											True, 1.6 Second
										],

										(* Else, EquilibrationTime is sepcified as Null or a value, so use their value *)
										measTable[[4]]
									];

									(* If we are Priming, MeasurementTime can be set to Null if it is not specified *)
									measTime = If[
										MatchQ[measTable[[5]],Automatic],
										(* If MeasurementTime is automatic, we need to resolve based on FlowRate, whether this is a priming step, and whether the previous step was a priming step *)
										Which[
											(* If FlowRate is not Null, resolve based on the FlowRate*)
											FlowRateQ[flowRates],
											Switch[flowRates,
												(* For flow rates > 100 ul/Minute, we need a 2 second measurement time *)
												GreaterEqualP[100 Microliter/Minute],2 Second,

												(*Otherwise, calculate based on flow rate. This is based on the manufacturer's recommendations*)
												_,SafeRound[Convert[1.6667 Microliter/flowRates, Second],0.2 Second]
											],

											(* If this is a priming step, set this to Null *)
											prime, Null,

											(* If FlowRate is Null and the previous step was a primeStep, set this to Null *)
											NullQ[flowRates] && prevPrime, Null,

											(*If pressure is specified, set this to Null since it will be determined by the instrument*)
											MatchQ[pressure,PercentP],Null,

											(* If all else fails, set this to a set value *)
											True, 2 Second
										],

										(* Else, MeasurementTime is sepcified as Null or a value, so use their value *)
										measTable[[5]]
									];

								(* Set PuaseTime to 0 Second if it is left as automatic*)
								pause = If[
									MatchQ[measTable[[6]],Automatic],
									0 Second,
									measTable[[6]]
								];

								(* If the FlowRate and Pressure are both specified in the same row, we need to throw an error since they are dependent on each other *)
								flowPressure = And[
									MatchQ[flowRates,FlowRateP],
									MatchQ[pressure,PercentP]
								];

								(* If the Pressure and Equilibration time and/or MeasurementTime are specified, throw a warning that these times may not be optimized and should really be determined by the instrument *)
								timePressure = And[
									MatchQ[pressure,PercentP],
									Or[
										MatchQ[measTime,TimeP],
										MatchQ[equilTime,TimeP]
									]
								];

								(* Return the reformatted row*)
								(* Pause Time (5) and NumberOfReadings (7) should be unchanged, so just pull them directly from the measurement table *)
								{{measTemp,flowRates,pressure,equilTime,measTime,pause,prime,measTable[[8]]},flowPressure,timePressure}
								]
							],
							{supMeasurementMethodTable,primeInPreviousStep}
						];

						(* We need to do Error checking for the measurement method table if it contains relative pressures. the following must be true
						(1) A PrimingStep consisting of a Measurement made at 90 Percent Relative Pressure repeated six times at a measurement temperature must precede all subsequent measurements at relativePressures at that temperature
						(2)RelativePressureMeasurements at a particular temperature must be conducted in sequence, after the priming step for that particular temperature
						*)
					(* Pull out all the rows that have a percent specified *)
					pressureRows = Cases[checkedMeasTempTable, {_, _, PercentP, _, _, _, _, _}];

					(*Determine if pressurePos is {}, if so, we can skip the error checks below *)
					pressureQ = !MatchQ[pressureRows, {}];

					invalidMeasurementTableBool = If[pressureQ,
						(* do all the error checking *)
						Module[{splitByTemp,correctFormatBool},
							(*First, SplitBy all the pressure rows into groups with the same MeasurementTemp. We need to make sure that there is one priming step per new measurementtemperature*)
							splitByTemp = SplitBy[pressureRows,First];

							(* For each group split by MeasurementTemps, we need to make sure that the first measurement is  apriming step at 90 Percent RelaivePressure repeated 6 times*)
							correctFormatBool = And[
								(* Pressure is equal to 90 Percent*)
								MatchQ[#[[1,3]],90 Percent],
								(*We are priming in this step*)
								MatchQ[#[[1,7]], True],
								(*We repeat this step 6 times*)
								MatchQ[#[[1,8]],6]
							]&/@splitByTemp;

							(* If we have any False values in correctFormatBool, we have an invalid table and need to throw an error *)
							ContainsAny[correctFormatBool,{False}]
						],
						(*Otherwise we can skip the error checks since there are no RelativePresures specified and Default this to False *)
						False
					];

						(*Figure out if there were any Trues in the flowPressureError list *)
						flowPressureErrorCollapsed=ContainsAny[flowPressureError,{True}];

						(*Figure out if there were any Trues in the timePressureError list *)
						timePressureErrorCollapsed=ContainsAny[timePressureError,{True}];

						{checkedMeasTempTable,True,flowPressureErrorCollapsed,timePressureErrorCollapsed,invalidMeasurementTableBool}
					]
				];

				(* If specifiedTableBool is true (values were entered in the table, then null out MeasurementTenoeratures,FlwoRates,EquilibrationTimes, and MeasurementTimes based on the MeasurementMethodTable),
 						Otherwise, back fill the MeasurementTenoeratures,FlwoRates,EquilibrationTimes, and MeasurementTimes based on the MeasurementMethodTable resovled above*)
				{	resMeasurementTemperature,
					resFlowRate,
					resEquilibrationTime,
					resMeasurementTime,
					resPauseTime,
					resNumberOfReadings,
					resTargetPressure
				} = If[specifiedTableBool,
					{DeleteDuplicates[resMeasurementMethodTable[[All,1]]],Null,Null,Null,Null,Null,Null},

					(* Otherwise, we resolved to Custom based on the values they entered in the other options, so we backfill any unspecified values based on the resolved measurementMethodTable*)
					Module[{backMeasTemp,backFlow,backEquiltime,backMeasTime,backPauseTime,backNumMeas,backPressure},
					backMeasTemp = If[MatchQ[supMeasurementTemperature,{Automatic}|Null|Ambient|{Ambient}],
						DeleteDuplicates[resMeasurementMethodTable[[All,1]]],
						supMeasurementTemperature
					];

					backFlow = If[MatchQ[supFlowRate,{Automatic}|Null],
						DeleteCases[DeleteDuplicates[resMeasurementMethodTable[[All,2]]],Null], (*Remove Nulls and Duplicates*)
						supFlowRate
					];

					backEquiltime = If[MatchQ[supEquilibrationTime,{Automatic}|Null],
						(* get the list of equilibration times for each unique flow rate *)
						Module[{flowRatePosition,rowNum},
							(*get the first positions of each unique flow rate*)
							flowRatePosition = FirstPosition[resMeasurementMethodTable, #]& /@ backFlow;
							(*get the first positions of each unique flow rate*)
							rowNum = flowRatePosition[[All,1]];
							(* get the corresponding EquilibrationTime in that row*)
							resMeasurementMethodTable[[#,4]]&/@rowNum
						],
						supEquilibrationTime
					];

					backMeasTime = If[MatchQ[supMeasurementTime,{Automatic}|Null],
						(* get the list of measurement times for each unique flow rate *)
						Module[{flowRatePosition,rowNum},
							(*get the first positions of each unique flow rate*)
							flowRatePosition = FirstPosition[resMeasurementMethodTable, #]& /@ backFlow;
							(*get the first positions of each unique flow rate*)
							rowNum = flowRatePosition[[All,1]];
							(* get the corresponding EquilibrationTime in that row*)
							resMeasurementMethodTable[[#,5]]&/@rowNum
						],
						supMeasurementTime
					];

					backPauseTime = If[MatchQ[supPauseTime,Automatic|Null],
						0 Second,
						supPauseTime
					];

					backNumMeas = If[MatchQ[supNumberOfReadings,Automatic|Null],
						3,
						supNumberOfReadings
					];

					backPressure = If[MatchQ[supTargetPressure,{Automatic}|Null],
							DeleteDuplicates[resMeasurementMethodTable[[All,3]]],
							supTargetPressure
					];
					(* Return the values *)
					{backMeasTemp,backFlow,backEquiltime,backMeasTime,backPauseTime,backNumMeas,backPressure}
					]
				];

				(* The error checking booleans are all irrelevant here and should left as False*)
					tempSweepError = tempSweepInsufficientError;
					shearRateSweepError=shearRateSweepInsuffcientError;

				(*Return all the resolved values*)
					{resMeasurementTemperature,resFlowRate,resTargetPressure,resEquilibrationTime,resMeasurementTime,
						resPauseTime,resNumberOfReadings,resMeasurementMethodTable,tempSweepError,shearRateSweepError,
						pressureNoPriming,timePressureBothSpecified,flowPressureBothSpecifiedError
					}
			]
		];

		(*Resolve the other options*)
		remeasurementAllowed = supRemeasurementAllowed;

		(* Resolve the remeasurementReloadVolume*) (*Resolve based on the Injection Volume *)
		{remeasurementReloadVolume,remeasurementReloadVolumeTooHighError} = If[MatchQ[remeasurementAllowed,False],
			(* If we are not remeasuring, set this to Null*)
			{Null,False},
			(* otherwise, we resolve *)
			Module[{reloadVol,reloadVolumeBool},
				reloadVol = If[MatchQ[supRemeasurementReloadVolume,Automatic],
					(*Resolve based on the injected volume. These are based on the manufacturer's recommendaitons *)
					Switch[injectionVolume,
						LessEqualP[35 Microliter], 18 Microliter,
						RangeP[36 Microliter, 50 Microliter], 35 Microliter,
						GreaterP[50 Microliter], 70 Microliter,
						True, 18 Microliter
					],
				(* Otherwise, we default to the user's value  *)
				supRemeasurementReloadVolume
				];

				(*Make sure the Relaod volume is less than the resolved injection volume *)
				reloadVolumeBool = If[GreaterEqual[injectionVolume,reloadVol],
					False, (* The injection volume is greater than the reloadVol, so everything is okay*)
					True	(*Else, turn on this error boolean*)
				];

				(* Return the reload vol and boolean*)
				{reloadVol,reloadVolumeBool}
			]
		];

		(* If we are not reloading anything, we need to check to make sure that the volume consumed by the measurmenents does not exceed the injection volume *)
		notEnoughInjectionWarning = If[MatchQ[remeasurementAllowed,False],
			(* If we don't allow remeasurement, we must do this check *)
			Module[{notEnoughVolBool,allEquilTimes,allMeasTimes,allTimesSummed,allFlowRates,flowRatesReplaced,allNumReadings,volConsumed,totalVolumeConsumed},
				(* Pull out the relevant values from the MeasurementTable*)
				allFlowRates = measurementMethodTable[[All,2]];
				allEquilTimes = measurementMethodTable[[All,4]];
				allMeasTimes = measurementMethodTable[[All,5]];
				allNumReadings = measurementMethodTable[[All,8]];

				(* Sum all the times and replace any Null values with an arbitrary time *)
				allTimesSummed = MapThread[#1+#2 &,{allEquilTimes,allMeasTimes}]/.Null->2 Second;

				(* Replace any Nulls (from priming steps or with relative pressures etc.) in the flow rates with an arbitrary flow rate *)
				flowRatesReplaced = allFlowRates/.Null -> 200 Microliter/Minute;

				(* Calculate the volume consumed for each measurement. This will be FlowRate*allTimesSummed*allNumReadings *)
				volConsumed = MapThread[Function[{time,flowRate,numReadings},
						time*flowRate*numReadings
					],
					{allTimesSummed,flowRatesReplaced,allNumReadings}
				];

				(* Sum up all the volume consumed*)
				totalVolumeConsumed = Total[volConsumed];

				notEnoughVolBool = If[GreaterEqual[totalVolumeConsumed,injectionVolume],
					True, (*if the total volume consumed exceeds the injection volme, we need to throw a warning*)
					False
				];

				(* Return the boolean*)
				notEnoughVolBool
			],
			(* Otherwise, the instrment will continuously reload sample as needed *)
			False
		];

		(* Resolved recoupsample option *)
		recoupSample = supRecoupSample;

		(*Resolve whether we want the recoup sample container to be the same container as the original *)
		recoupSampleContainerSame = Which[
			(*If Automatic, resolve based on whether RecoupSample is True*)
			MatchQ[supRecoupSampleContainerSame,Automatic] && MatchQ[recoupSample, True], True,
			MatchQ[supRecoupSampleContainerSame,Automatic] && MatchQ[recoupSample, False], Null,
			(*Otherwise the user provided a value, so take that*)
			True,	supRecoupSampleContainerSame
		];

		(* Gather MapThread results *)
		{
			measurementMethod,
			priming,
			temperatureStabilityMargin,
			temperatureStabilityTime,
			measurementTemperature,
			remeasurementAllowed,
			recoupSample,
			recoupSampleContainerSame,
			injectionVolume,
			flowRate,
			equilibrationTime,
			measurementTime,
			pauseTime,
			numberOfReadings,
			measurementMethodTable,
			remeasurementReloadVolume,
			targetPressure/.{{Null}->Null},

			incompatibleContainerBool,
			minInjectionAliquotBool,
			(* Error checking Booleans *)
			sampleVolumeTooLowForInjectionError,
			minInjectionAliquotError,
			primingWarning,
			customMeasTableParameterError,
			customMeasTableParameterWarning,
			exploratoryTempSweepParameterError,
			measurementParameterError,
			shearSweepParameterError,
			pressureSweepParameterError,
			tempSweepInsufficientError,
			shearRateSweepInsuffcientError,
			remeasurementReloadVolumeTooHighError,
			notEnoughInjectionWarning,
			recoupSampleContainerError,
			customPressurePrimeError,
			customPressureTimeWarning,
			customPressureFlowRateError,

			failingCustomMeasInput,
			failingCustomMeasOption,
			failingExploratoryTempSweepInput,
			failingExploratoryTempSweepOption,
			failingMeasurementParameterInput,
			failingMeasurementParameterOption,
			failingShearSweepInput,
			failingShearSweepOption,
			failingPressureSweepInput,
			failingPressureSweepOption
		}
		]
	],
	(* MapThread over our index-matched lists *)
	{mapThreadFriendlyOptions,samplePackets,simulatedSampleContainerModels,simulatedSampleContainerObjects}
	];

		(* Go through the entire list and check to see if all the models in the List match each other *)
		simContainerModelComparisonBools = MatchQ[#,simulatedSampleContainerModels[[1]]]&/@simulatedSampleContainerModels;

		(* Go through the entire list and check to see if it is All True *)
		simContainersAllSame = If[AllTrue[simContainerModelComparisonBools,TrueQ],True,False];

		(* Check to see if any InjectionVolumes are 26 uL. If there is at least one, we need to set all containers to the autosampler vials*)
		minInjectionRequired = ContainsAny[resolvedInjectionVolume, {26 Microliter}];

		(* Do some checking to determine the targetContainer, targetValume. *)
		{
			targetContainers,
			targetVolumes,
			measurementContainerModel
		} = Transpose@MapThread[
			Function[{myContainerModel,recoupSample,injectionVol},
				Module[{recoupContainer,targetContain,targetVol,recoupContainerConflict,finalContainerModel},
					Which[
						(*Everything MUST be in the autosampler vial if one of the InjectionVolumes is 26 uL*)
						minInjectionRequired,
							(*If the sample is not in the autosampler vial, we need to aliquot*)
							{targetContain,targetVol} = If[!MatchQ[myContainerModel,ObjectP[potentialContainers[[2]]]], (*Samples are NOT in an Autosampler vial*)
								{potentialContainers[[2]], (injectionVol + 10 Microliter)},
								(* Else, samples are already in Autosampler vials, so we do not need to aliquot *)
								{Null,Null}
							];
							finalContainerModel=potentialContainers[[2]],

						(* We do not need to aliquot any of the samples and all samples are in the same container type*)
						!AllTrue[incompatibleContainerBools,TrueQ] && simContainersAllSame,
							targetContain = Null;
							targetVol = Null;
							finalContainerModel=myContainerModel,

						(*Otherwise, we need to aliquot at least one sample, so we need to intelligently figure out what container to put it in *)
						True,
							(* We are just going to default to the autosampler vials *)
							{targetContain,targetVol} = If[!MatchQ[myContainerModel,potentialContainers[[2]]],
								(* If sample is not in an autosampler vial, then we are going to put it in one *)
								{potentialContainers[[2]],injectionVol + 10 Microliter},
								{Null,Null}
							];

							finalContainerModel=potentialContainers[[2]]
					];
				(*Return the values*)
				{targetContain,targetVol,finalContainerModel}
			]
		],
		{simulatedSampleContainerModels,resolvedRecoupSample,resolvedInjectionVolume}
	];

	(*Now, we check to see if the number of simulatedSample Containers + recoupSampleContainers is less than 40 for the autosampler vials or 96 for the PCR plate*)
	(*If we are aliquoting into a new container, count this as an additional container that we need to put on the autosampler deck *)
	additionalContainersNeeded = Length[Cases[resolvedRecoupSampleContainerSame,False]];

	totalContainerCount = Length[simulatedSamples] + additionalContainersNeeded;

	tooManyRecoupContainers = If[
		Or[
			(* We are in a 96 well plate and the total container count is greater than 96 *)
			And[MatchQ[measurementContainerModel[[1]],ObjectP[Model[Container,Plate]]], Greater[totalContainerCount,96], MemberQ[resolvedRecoupSample,True]],
			(* We are in a 96 well plate and the total container count is greater than 40 *)
			And[MatchQ[measurementContainerModel[[1]],ObjectP[Model[Container,Vessel]]], Greater[totalContainerCount,40],MemberQ[resolvedRecoupSample,True]]
		],
		True,
		False
	];

	(* Geerate the error messages and warnings from the MapThread *)

	(* (1) Throw an error message if the we don't have enough sample volume for the indicated injectionVolume --*)
	If[MemberQ[sampleVolumeTooLowForInjectionErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityInjectionVolumeHigh, PickList[resolvedInjectionVolume, sampleVolumeTooLowForInjectionErrors],numberOfReplicates,ObjectToString[PickList[simulatedSamples, sampleVolumeTooLowForInjectionErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	sampleVolumeTooLowForInjectionTests = If[gatherTests,
		Module[{failingSamples,failingInjectionVolumes,passingSamples,passingInjectionVolumes,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, sampleVolumeTooLowForInjectionErrors];
			failingInjectionVolumes = PickList[resolvedInjectionVolume, sampleVolumeTooLowForInjectionErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, sampleVolumeTooLowForInjectionErrors, False];
			passingInjectionVolumes = PickList[resolvedInjectionVolume, sampleVolumeTooLowForInjectionErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the specified InjectionVolume" <> ObjectToString[failingInjectionVolumes, Simulation->updatedSimulation] <> "is greater than the sample's recorded volume:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the specified InjectionVolume" <> ObjectToString[passingInjectionVolumes, Simulation->updatedSimulation] <> "is less than the sample's recorded volume:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	sampleVolumeTooLowForInjectionOptions = If[MemberQ[sampleVolumeTooLowForInjectionErrors, True],
		{InjectionVolume},
		Nothing
	];

	(* (2) Throw a Warning message if the user wanted an InjectionVolume of 26 uL but the sample needs to be aliquoted into an autosampler vial since this is the only container that supports this Injection volume --*)
	If[MemberQ[minInjectionAliquotErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityUnsupportedInjectionVolume, PickList[resolvedInjectionVolume, minInjectionAliquotErrors],ObjectToString[PickList[simulatedSamples, minInjectionAliquotErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	minInjectionAliquotErrorTests = If[gatherTests,
		Module[{failingSamples,failingInjectionVolumes,passingSamples,passingInjectionVolumes,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, minInjectionAliquotErrors];
			failingInjectionVolumes = PickList[resolvedInjectionVolume, minInjectionAliquotErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, minInjectionAliquotErrors, False];
			passingInjectionVolumes = PickList[resolvedInjectionVolume, minInjectionAliquotErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the instrument does not support the specified InjectionVolume " <> ObjectToString[failingInjectionVolumes, Simulation->updatedSimulation] <> " for the sample's container. The sample must be aliquoted into a compatible container but there is not enough sample volume to aliquot:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the instrument does support the specified InjectionVolume " <> ObjectToString[passingInjectionVolumes, Simulation->updatedSimulation] <> " for the sample's container:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	minInjectionAliquotErrorOptions = If[MemberQ[minInjectionAliquotErrors, True],
		{InjectionVolume},
		Nothing
	];


	(* (4) Throw a Warning message if the user set Priming to False  *)
	If[MemberQ[primingWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ViscosityPrimingFalse, ObjectToString[PickList[simulatedSamples, primingWarnings], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	primingWarningTests = If[gatherTests,
		Module[{failingSamples,failingPrimings,passingSamples,passingPrimings,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, primingWarnings];
			failingPrimings = PickList[resolvedPriming, primingWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, primingWarnings, False];
			passingPrimings = PickList[resolvedPriming, primingWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the provided value for Priming, " <> ObjectToString[failingPrimings, Simulation->updatedSimulation] <> " is set to False:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the provided value for Priming, " <> ObjectToString[passingPrimings, Simulation->updatedSimulation] <> "  is set to True:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	primingWarningOptions = If[MemberQ[primingWarnings, True],
		{Priming},
		Nothing
	];

	(* (5) Throw an Error message if the user set selected a Custom MeasurementMethod and also specified options outside of the MeasurementMethodTable *)
	If[MemberQ[customMeasTableParameterErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityCustomMeasurementMethodConflicts, Normal[failingCustomMeasInputs], ObjectToString[PickList[simulatedSamples, customMeasTableParameterErrors], Simulation->updatedSimulation]]

		(*PickList[resolvedMeasurementMethodTable, customMeasTableParameterErrors],PickList[resolvedMeasurementTemperature, customMeasTableParameterErrors],PickList[resolvedFlowRate, customMeasTableParameterErrors],
			PickList[resolvedEquilibrationTime, customMeasTableParameterErrors],PickList[resolvedMeasurementTime, customMeasTableParameterErrors],PickList[resolvedPauseTime, customMeasTableParameterErrors],PickList[resolvedNumberOfReadings, customMeasTableParameterErrors],
			ObjectToString[PickList[simulatedSamples, customMeasTableParameterErrors], Simulation->updatedSimulation]]*)
	];

	(* generate the tests *)
	customMeasTableParameterErrorTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, customMeasTableParameterErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, customMeasTableParameterErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the provided values for MeasurementTemperature,FlowRate,EquilibrationTime,MeasurementTime, PauseTime, NumberOfReadings, and MeasurementMethodTable are in conflict with one another:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the provided values for MeasurementTemperature,FlowRate,EquilibrationTime,MeasurementTime, PauseTime, NumberOfReadings, and MeasurementMethodTable are not in conflict with one another:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	customMeasTableParameterOptions = If[MemberQ[customMeasTableParameterErrors, True],
		failingCustomMeasOptions,
		Nothing
	];

	(* (6) Throw a Warning message if the user  selected a Custom MeasurementMethod but left MeasurementMethodTable as Automatic *)
	If[MemberQ[customMeasTableParameterWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ViscosityCustomMeasurementTableNotProvided,ObjectToString[PickList[simulatedSamples, customMeasTableParameterWarnings], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	customMeasTableParameterWarningTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, customMeasTableParameterWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, customMeasTableParameterWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", no Custom values are entered in the MeasurementMethodTable:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", Custom values are specified in the MeasurementMethodTable:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	customMeasTableParameterWarningOptions = If[MemberQ[customMeasTableParameterWarnings, True],
		{MeasurementMethod,MeasurementMethodTable},
		Nothing
	];

	(* (7) Throw an Error message if the user selected an Exploratory or TemperatureSweep MeasurementMethod and also specified values for FlowRate,EquilibrationTime,MeasurementTime and/or set Priming to False *)
	If[MemberQ[exploratoryTempSweepParameterErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityExploratoryTemperatureSweepParameterError,PickList[resolvedMeasurementMethod, exploratoryTempSweepParameterErrors],Normal[failingExploratoryTempSweepInputs],ObjectToString[PickList[simulatedSamples, exploratoryTempSweepParameterErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	exploratoryTempSweepParameterErrorTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, exploratoryTempSweepParameterErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, exploratoryTempSweepParameterErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the values specified for MeasurementMethod, MeasurementMethodTable, FlowRate, EquilibrationTime, MeasurementTime, and Priming are in conflict with each other:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the values specified for MeasurementMethod, MeasurementMethodTable, FlowRate, EquilibrationTime, MeasurementTime, and Priming are not in conflict with each other:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	exploratoryTempSweepParameterErrorOptions = If[MemberQ[exploratoryTempSweepParameterErrors, True],
		failingExploratoryTempSweepOptions,
		Nothing
	];

	(* (7.5) Throw an Error message if there are mismathches in the number of values provided for FlowRate, EquilibrationTime, and MeasurementTime *)
	If[MemberQ[measurementParameterErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityFlowRateEquilibrationTimeMeasurementTimeError,failingMeasurementParameterInputs,ObjectToString[PickList[simulatedSamples, measurementParameterErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	measurementParameterErrorTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, measurementParameterErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, measurementParameterErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the values specified for FlowRate, EquilibrationTime, and MeasurementTime are in conflict with each other:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the values specified for FlowRate, EquilibrationTime, and MeasurementTime are not in conflict with each other:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	measurementParameterErrorOptions = If[MemberQ[measurementParameterErrors, True],
		failingMeasurementParameterOptions,
		Nothing
	];


	(* (8) Throw an Error message if the user selected a ShearRateSweep MeasurementMethod and also specified values for MeasurementMethodTable or provided more than one MeasurementTemperature *)
	If[MemberQ[shearSweepParameterErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityFlowRateSweepParameterError,Normal[failingShearSweepInputs],ObjectToString[PickList[simulatedSamples, shearSweepParameterErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	shearSweepParameterErrorTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, shearSweepParameterErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, shearSweepParameterErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the values specified for MeasurementMethod, MeasurementMethodTable, and MeasurementTempearature are in conflict with each other:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the values specified for MeasurementMethod, MeasurementMethodTable, and MeasurementTemperature are not in conflict with each other:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	shearSweepParameterErrorOptions = If[MemberQ[shearSweepParameterErrors, True],
		failingShearSweepOptions,
		Nothing
	];

	(* (8.5) Throw an Error message if the user selected a RelativePressreSweep MeasurementMethod and also specified values for MeasurementMethodTable, EquilibrationTime, Measurementtime, or provided more than one MeasurementTemperature *)
	If[MemberQ[pressureSweepParameterErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityPressureSweepParameterError,Normal[failingPressureSweepInputs],ObjectToString[PickList[simulatedSamples, pressureSweepParameterErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	pressureSweepParameterErrorTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, pressureSweepParameterErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, pressureSweepParameterErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the values specified for MeasurementMethod, MeasurementMethodTable, MeasurementTemperature, EquilibrationTime, and MeasurementTime are in conflict with each other:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the values specified for MeasurementMethod, MeasurementMethodTable, MeasurementTemperature,EquilibrationTime, and MeasurementTime are not in conflict with each other:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	failingPressureSweepOptions = If[MemberQ[pressureSweepParameterErrors, True],
		failingPressureSweepOptions,
		Nothing
	];

	(* (9) Throw an Error message if the user selected a TemperatureSweep MeasurementMethod but only specified one MeasurementTemperature*)
	If[MemberQ[tempSweepInsufficientErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityTemperatureSweepInsufficientInput,PickList[resolvedMeasurementTemperature, tempSweepInsufficientErrors],ObjectToString[PickList[simulatedSamples, tempSweepInsufficientErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	tempSweepInsufficientErrorTests = If[gatherTests,
		Module[{failingSamples,failingMeasurementTemperatures,passingSamples,passingMeasurementTemperatures,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, tempSweepInsufficientErrors];
			failingMeasurementTemperatures = PickList[resolvedMeasurementTemperature, tempSweepInsufficientErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, tempSweepInsufficientErrors, False];
			passingMeasurementTemperatures = PickList[resolvedMeasurementTemperature, tempSweepInsufficientErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", only one MeasurementTemperature, " <> ObjectToString[failingMeasurementTemperatures, Simulation->updatedSimulation] <> " is specified for a TemperatureSweep MeasurementMethod:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", more than one MeasurementTemperature, " <> ObjectToString[passingMeasurementTemperatures, Simulation->updatedSimulation] <> " is specified for a TemperatureSweep MeasurementMethod:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	tempSweepInsufficientErrorOptions = If[MemberQ[tempSweepInsufficientErrors, True],
		{MeasurementMethod,MeasurementTemperature},
		Nothing
	];

	(* (10) Throw a Warning message if the user selected a ShearRateSweep MeasurementMethod but only specified one FlowRate*)
	If[MemberQ[shearRateSweepInsuffcientErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ViscosityFlowRateSweepInsufficientInput,PickList[resolvedFlowRate, shearRateSweepInsuffcientErrors],ObjectToString[PickList[simulatedSamples, shearRateSweepInsuffcientErrors], Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	shearRateSweepInsufficientErrorTests = If[gatherTests,
		Module[{failingSamples,failingFlowRates,passingSamples,passingFlowRates,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, shearSweepParameterErrors];
			failingFlowRates = PickList[resolvedFlowRate, shearSweepParameterErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, shearSweepParameterErrors, False];
			passingFlowRates = PickList[resolvedFlowRate, shearSweepParameterErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", only one FlowRate, " <> ObjectToString[failingFlowRates, Simulation->updatedSimulation] <> " is specified for a FlowRateSweep MeasurementMethod:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", more than one FlowRate, " <> ObjectToString[passingFlowRates, Simulation->updatedSimulation] <> " is specified for a ShearRateSweep MeasurementMethod:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	shearRateSweepInsufficientErrorOptions = If[MemberQ[shearRateSweepInsuffcientErrors, True],
		{MeasurementMethod,FlowRate},
		Nothing
	];

	(* (11) Throw an Error message if the RemeasurementReloadVolume exceeds the InjectionVolume*)
	If[MemberQ[remeasurementReloadVolumeTooHighErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityRemeasurementReloadVolumeHigh,PickList[resolvedRemeasurementReloadVolume, remeasurementReloadVolumeTooHighErrors],ObjectToString[PickList[simulatedSamples, remeasurementReloadVolumeTooHighErrors], Simulation->updatedSimulation],PickList[resolvedInjectionVolume, remeasurementReloadVolumeTooHighErrors]]
	];

	(* generate the tests *)
	remeasurementReloadVolumeTooHighErrorTests = If[gatherTests,
		Module[{failingSamples,failingReloadVols,failingInjectionVols, passingSamples,passingReloadVols,passingInjectionVols,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, remeasurementReloadVolumeTooHighErrors];
			failingReloadVols = PickList[resolvedRemeasurementReloadVolume, remeasurementReloadVolumeTooHighErrors];
			failingInjectionVols = PickList[resolvedInjectionVolume, remeasurementReloadVolumeTooHighErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, remeasurementReloadVolumeTooHighErrors, False];
			passingReloadVols = PickList[resolvedRemeasurementReloadVolume, remeasurementReloadVolumeTooHighErrors,False];
			passingInjectionVols = PickList[resolvedInjectionVolume, remeasurementReloadVolumeTooHighErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the RemeasurementReloadVolume, " <> ObjectToString[failingReloadVols, Simulation->updatedSimulation] <> ", is greater than the InjectionVolume, "  <> ObjectToString[failingInjectionVols, Simulation->updatedSimulation] <> ":",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the RemeasurementReloadVolume, " <> ObjectToString[passingReloadVols, Simulation->updatedSimulation] <> ", is less than or equal to the InjectionVolume, "  <> ObjectToString[passingInjectionVols, Simulation->updatedSimulation] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	remeasurementReloadVolumeTooHighErrorOptions = If[MemberQ[remeasurementReloadVolumeTooHighErrors, True],
		{RemeasurementReloadVolume,InjectionVolume},
		Nothing
	];

	(* (12) Throw a Warning message if the calculated total volume consumed for all measurement steps exceeds the InjectionVolume*)
	If[MemberQ[notEnoughInjectionWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ViscosityNotEnoughSampleInjected,ObjectToString[PickList[simulatedSamples, notEnoughInjectionWarnings],Simulation->updatedSimulation], PickList[resolvedInjectionVolume, notEnoughInjectionWarnings]]
	];

	(* generate the tests *)
	notEnoughInjectionWarningTests = If[gatherTests,
		Module[{failingSamples,failingInjectionVols, passingSamples,passingInjectionVols,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, notEnoughInjectionWarnings];
			failingInjectionVols = PickList[resolvedInjectionVolume, notEnoughInjectionWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, notEnoughInjectionWarnings, False];
			passingInjectionVols = PickList[resolvedInjectionVolume, notEnoughInjectionWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the calculated Sample Volume consumed, is greater than the InjectionVolume, " <> ObjectToString[failingInjectionVols, Simulation->updatedSimulation] <> " and there may not be enough sample to complete all measurement steps:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the calculated Sample Volume consumed, is less than the InjectionVolume, " <> ObjectToString[passingInjectionVols, Simulation->updatedSimulation] <> " and there is enough sample to complete all measurement steps:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	notEnoughInjectionWarningOptions = If[MemberQ[notEnoughInjectionWarnings, True],
		{InjectionVolume},
		Nothing
	];


	(* (15) Throw an Error if the user specified too many RecoupContainers such that the total number of sample+recoup containers exceed what is allowed*)
	If[tooManyRecoupContainers && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityTooManyRecoupContainers]
	];

	(* generate the tests *)
	tooManyRecoupContainerTests = If[gatherTests,
			Module[{failingTest,passingTest},
				failingTest=If[tooManyRecoupContainers,
					Nothing,
					Test["The number of sample containers and unique recoup sample containers is less than or equal to 40 if samples are in Autosampler vials or 96, if samples are in a 96-well Plate:",True,False]
				];

				passingTest=If[!tooManyRecoupContainers,
					Nothing,
					Test["The number of sample containers and unique recoup sample containers is less than or equal to 40 if samples are in Autosampler vials or 96, if samples are in a 96-well Plate:",True,True]
				];

					{failingTest,passingTest}
				],
				Nothing
			];

	(* Stash the failing options related to this error *)
	tooManyRecoupContainerOptions = If[tooManyRecoupContainers,
		{RecoupSample,RecoupSampleContainerSame},
		Nothing
	];

	(* (16) Throw an Error if the user (1) specified values in the MeasurementMethodTable, (2) Specified Measurements at a Relative Pressure, and (3) Did NOT provide a sufficient priming step  *)
	If[MemberQ[customPressurePrimeErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityInvalidPrimeMeasurementTable,PickList[resolvedMeasurementMethodTable, customPressurePrimeErrors],ObjectToString[PickList[simulatedSamples, customPressurePrimeErrors],Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	customPressurePrimeErrorTests = If[gatherTests,
		Module[{failingSamples,failingTables, passingSamples,passingTables,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, customPressurePrimeErrors];
			failingTables = PickList[resolvedMeasurementMethodTable, customPressurePrimeErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, customPressurePrimeErrors, False];
			passingTables = PickList[resolvedMeasurementMethodTable, customPressurePrimeErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the provided MeasurementMethodTable, " <> ObjectToString[failingTables, Simulation->updatedSimulation] <> " contains a valid priming step before measurements at a RelativePressure:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the provided MeasurementMethodTable, " <> ObjectToString[passingTables, Simulation->updatedSimulation] <> "contains a valid priming step before measurements at a RelativePressure:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	customPressurePrimeErrorOptions = If[MemberQ[customPressurePrimeErrors, True],
		{MeasurementMethodTable},
		Nothing
	];

	(* (17) Throw a Warning if the user (1) specified values in the MeasurementMethodTable, (2) Specified a RelativePressure and EquilibrationTime and/or MeasurementTime *)
	If[MemberQ[customPressureTimeWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ViscosityPressureMeasurementTimeConflict,PickList[resolvedMeasurementMethodTable, customPressureTimeWarnings],ObjectToString[PickList[simulatedSamples, customPressureTimeWarnings],Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	customPressureTimeWarningTests = If[gatherTests,
		Module[{failingSamples,failingTables, passingSamples,passingTables,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, customPressureTimeWarnings];
			failingTables = PickList[resolvedMeasurementMethodTable, customPressureTimeWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, customPressureTimeWarnings, False];
			passingTables = PickList[resolvedMeasurementMethodTable, customPressureTimeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the provided MeasurementMethodTable, " <> ObjectToString[failingTables, Simulation->updatedSimulation] <> " does not contain any steps where the RelativePressure is specified and the EquilibrationTime or MeasurementTIme are specified:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the provided MeasurementMethodTable, " <> ObjectToString[passingTables, Simulation->updatedSimulation] <> " does not contain any steps where the RelativePressure is specified and the EquilibrationTime or MeasurementTIme are specified:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	customPressureTimeWarningOptions = If[MemberQ[customPressureTimeWarnings, True],
		{MeasurementMethodTable},
		Nothing
	];

	(* (18) Throw a Warning if the user (1) specified values in the MeasurementMethodTable, (2) Specified a RelativePressure and FlowRate in the same measurement step *)
	If[MemberQ[customPressureFlowRateErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::ViscosityInvalidFlowRateMeasurementTable,PickList[resolvedMeasurementMethodTable, customPressureFlowRateErrors],ObjectToString[PickList[simulatedSamples, customPressureFlowRateErrors],Simulation->updatedSimulation]]
	];

	(* generate the tests *)
	customPressureFlowRateErrorTests = If[gatherTests,
		Module[{failingSamples,failingTables, passingSamples,passingTables,failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, customPressureFlowRateErrors];
			failingTables = PickList[resolvedMeasurementMethodTable, customPressureFlowRateErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, customPressureFlowRateErrors, False];
			passingTables = PickList[resolvedMeasurementMethodTable, customPressureFlowRateErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation->updatedSimulation] <> ", the provided MeasurementMethodTable, " <> ObjectToString[failingTables, Simulation->updatedSimulation] <> " does not contain any steps where the RelativePressure is specified and the EquilibrationTime or MeasurementTIme are specified:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation->updatedSimulation] <> ", the provided MeasurementMethodTable, " <> ObjectToString[passingTables, Simulation->updatedSimulation] <> " does not contain any steps where the RelativePressure is specified and the EquilibrationTime or MeasurementTIme are specified:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	customPressureFlowRateErrorOptions = If[MemberQ[customPressureFlowRateErrors, True],
		{MeasurementMethodTable},
		Nothing
	];

	(* Pull out Miscellaneous options *)
	{emailOption, uploadOption, nameOption, confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,samplesOutStorageOption,operator} =
		Lookup[allOptionsRounded,
			{Email, Upload, Name,Confirm,CanaryBranch,ParentProtocol,FastTrack,Template,SamplesInStorageCondition,SamplesOutStorageCondition,Operator}];

	(* check if the provided sampleStorageCondtion is valid*)
	{validSampleStorageConditionQ,validSampleStorageTests}=If[gatherTests,
			ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageOption,Simulation->updatedSimulation,Output->{Result,Tests}],
			{ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageOption,Simulation->updatedSimulation,Output->Result],{}}
	];

	(* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
		{SamplesInStorageCondition},
		{}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,containerlessSamples,tooManyInvalidInputs,solidInvalidInputs,noVolumeInvalidInputs,insufficientVolInvalidInputs,incompatibleInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{nameInvalidOption,recoupSampleConflictOptions,remeasurementConflictOptions,
		sampleVolumeTooLowForInjectionOptions,minInjectionAliquotErrorOptions,customMeasTableParameterOptions,exploratoryTempSweepParameterErrorOptions,measurementParameterErrorOptions,shearSweepParameterErrorOptions,
		tempSweepInsufficientErrorOptions,remeasurementReloadVolumeTooHighErrorOptions,
		tooManyRecoupContainerOptions,invalidStorageConditionOptions,failingPressureSweepOptions,
		customPressurePrimeErrorOptions,customPressureFlowRateErrorOptions}]];

	allTests = Flatten[{
		(* Invalid Inputs tests *)
		samplePrepTests,discardedTest,containerlessSampleTest,tooManyInputsTests,solidStateTest,noVolumeTest,insufficientVolumeTest,incompatibleInputTests,

		(* options precision tests *)
		allOptionsPrecisionTests,

		(* Conflicting options tests *)
		validNameTest,remeasurementInvalidTest,recoupSampleInvalidTest,validSampleStorageTests,

		(*Tests from the MapThread*)
		sampleVolumeTooLowForInjectionTests,minInjectionAliquotErrorTests,primingWarningTests,
		customMeasTableParameterErrorTests,customMeasTableParameterWarningTests,exploratoryTempSweepParameterErrorTests,measurementParameterErrorTests,shearSweepParameterErrorTests,
		tempSweepInsufficientErrorTests,shearRateSweepInsufficientErrorTests,remeasurementReloadVolumeTooHighErrorTests,notEnoughInjectionWarningTests,pressureSweepParameterErrorTests,customPressurePrimeErrorTests,customPressureTimeWarningTests,customPressureFlowRateErrorTests
	}];


	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation->updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
		(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
		(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
		(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	aliquotMessage = "because the given sample is not in a container that is comaptible with the instrument, the container is not compatibled with the specified InjectionVolume, or is not of the same container Model as the other samples.";
	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[
			ExperimentMeasureViscosity,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> cache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->targetVolumes,
			AliquotWarningMessage->aliquotMessage,
			Output->{Result,Tests}],
		{resolveAliquotOptions[
			ExperimentMeasureViscosity,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> cache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->targetVolumes,
			AliquotWarningMessage->aliquotMessage,
			Output->Result],{}
		}
	];


	(* Resolve Email option *)
	resolvedEmail = If[!MatchQ[emailOption, Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption, MemberQ[output, Result]],
			True,
			False
		]
	];


	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* all resolved options*)
	resolvedOptions = ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				Instrument->instrument,
				AssayType->assayType,
				AutosamplerPrePressurization->prePressurization,
				NumberOfReplicates->numberOfReplicates,
				ViscometerChip->resolvedViscometerChip,
				SampleTemperature->resolvedSampleTemperature,
				InjectionVolume->resolvedInjectionVolume,
				MeasurementMethod->resolvedMeasurementMethod,
				Priming->resolvedPriming,
				TemperatureStabilityMargin->resolvedTemperatureStabilityMargin,
				TemperatureStabilityTime->resolvedTemperatureStabilityTime,
				MeasurementTemperature->resolvedMeasurementTemperature,
				FlowRate->resolvedFlowRate,
				RelativePressure->resolvedTargetPressure,
				EquilibrationTime->resolvedEquilibrationTime,
				MeasurementTime->resolvedMeasurementTime,
				PauseTime->resolvedPauseTime,
				NumberOfReadings->resolvedNumberOfReadings,
				MeasurementMethodTable->resolvedMeasurementMethodTable,
				RemeasurementAllowed->resolvedRemeasurementAllowed,
				RemeasurementReloadVolume->resolvedRemeasurementReloadVolume,
				RecoupSample->resolvedRecoupSample,
				RecoupSampleContainerSame->resolvedRecoupSampleContainerSame,
				ResidualIncubation->residualIncubation,
				PrimaryBuffer->resolvedPrimaryBuffer,
				PrimaryBufferStorageCondition->resolvedPrimaryBufferStorage,
				Confirm -> confirmOption,
				CanaryBranch -> canaryBranchOption,
				Name -> name,
				Email -> resolvedEmail,
				ParentProtocol -> parentProtocolOption,
				Upload -> uploadOption,
				FastTrack -> fastTrackOption,
				Operator -> operator,
				SamplesInStorageCondition -> samplesInStorageOption,
				SamplesOutStorageCondition -> samplesOutStorageOption,
				Template -> templateOption,
				Cache -> cache
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> allTests
	}
];


(* ::Subsubsection:: *)
(*measureViscosityResourcePackets*)


DefineOptions[
	experimentMeasureViscosityResourcePackets,
	Options:>{OutputOption,CacheOption,SimulationOption}
];


experimentMeasureViscosityResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,numReplicates,intNumberOfReplicates,
		samplePackets,expandedSamplesWithNumReplicates,expandedAliquotVolume,pairedSamplesInAndVolumes,
		sampleResourceReplaceRules,samplesInResources,instrument,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,potentialContainers,

		sampleDownloads,numberOfSamples,orderedSamples,aliquotVolumes,listOfExpandedSamples, numberOfExpandedSamples,injectionVolume,reExpandedInjectionVolumes,
		expandedForNumberOfReplicatesInjectionVolumes,sampleVolumesNeeded,sampleResources,samplesInLinks,optionsWithReplicates,autosamplerContainerBool,
		resourceSamplesIn,expandedSamplePacketsWithNumReplicates,workingContainers,measurementTable,recoupSampleCount,
		plateSealResource,rackResource,coolingInsertResource,viscometerChip,viscometerChipResource,viscometerChipWrenchResource,viscometerChipTweezersResource,viscometerPliersResource,viscometerChipFerruleResource,recoupSampleContainerSame,recoupContainerCount,recoupContainerResource,
		measurementTableFlat,measurementTableReformat,allTimes,allTimesSummed,allNumReadings,totalMeasurementTimes,recoupSample,containersInResources,
		sampleTemperature,nitroValveBool,needleResource,residualIncubation,instrumentSetupTearDown,processingTime,recoupSamples, simulation,

		(*Cleaning buffers*)
		primaryBuffer,primaryBufferResource,secondaryCleaningSolutionResource,tertiaryCleaningSolutionResource,primaryBufferAmount,secondaryCleaningAmount,tertiaryCleaningAmount,
		numSamples,assayType,primaryVolumePerSampleB05, secondaryVolumePerSampleB05, tertiaryVolumePerSampleB05, primaryVolumePerSampleC05, secondaryVolumePerSampleC05, tertiaryVolumePerSampleC05, primaryVolumePerSampleE02, secondaryVolumePerSampleE02, tertiaryVolumePerSampleE02,volCleaning,bufferedVol,allWasteWeight,optionsRule,previewRule
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMeasureViscosity, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentMeasureViscosity,
		RemoveHiddenOptions[ExperimentMeasureViscosity,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[myResolvedOptions,Cache];
	simulation = Lookup[ToList[ops], Simulation];

	(* --- Make our one big Download call --- *)
	{sampleDownloads} = Quiet[
		Download[
			{mySamples},
			{Packet[Container, Volume, Object]},
			Cache -> inheritedCache,
			Simulation -> simulation,
			Date -> Now
		],
		Download::FieldDoesntExist
	];

	samplePackets = Flatten[sampleDownloads];

	(* --- Make all the resources needed in the experiment --- *)

	(*Note: the Rheosense Initium viscometer can only be calibrated for one Model of autosample vial and 96-well plate at any one time.
		Currently, the autosampler is calibrated for the following containers. If you want to use a different container, the autosampler MUST be
 		re-calibrated to account for differences in the distance to the bottom of the container. *)
	potentialContainers = {
		Model[Container, Plate, "id:01G6nvkKrrYm"], (*Model[Container, Plate, "96-well PCR Plate"]*)
		Model[Container, Vessel, "id:BYDOjvGj6q39"] (*Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]*)
	};

	(* -- Generate resources for the SamplesIn -- *)

	(* Get the number of replicates *)
	{instrument,numReplicates,aliquotVolumes,residualIncubation} = Lookup[myResolvedOptions,{Instrument,NumberOfReplicates,AliquotAmount,ResidualIncubation}];

	(* convert NumberOfReplicates such that Null->1*)
	intNumberOfReplicates = numReplicates/.{Null->1};

	(* make a variable that is the number of input samples *)
	numberOfSamples = Length[mySamples];

	(* Make a list of all of the samples that will be run, in order, taking into account the NumberOfReplicates options *)
	listOfExpandedSamples=Flatten[Table[#,intNumberOfReplicates]&/@mySamples];

	(* Make a variable for the number of total sample lanes that will be run *)
	numberOfExpandedSamples=Length[listOfExpandedSamples];

	(* Pull out the resolved injection volume from*)
	injectionVolume = Lookup[myResolvedOptions,InjectionVolume];

	(* Figure out the needed sample volumes *)
	(* First, expand the indexed matched injectionVolume if it has been collapsed in the main function *)
	reExpandedInjectionVolumes=If[MatchQ[Head[injectionVolume],Quantity],
		Table[injectionVolume,numberOfSamples],
		injectionVolume
	];

	(* Then, we need to expand this list of injection volumes to take into account the number of replicates *)
	expandedForNumberOfReplicatesInjectionVolumes=Flatten[Table[#,intNumberOfReplicates]&/@reExpandedInjectionVolumes];

	(* pull out the AliquotAmount option *)
	expandedAliquotVolume = Flatten[Table[#,intNumberOfReplicates]&/@aliquotVolumes];

	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)
	(* The volume of the samples we need is either the sampleLoadingVolume times the NumberOfReplicates or, if we are aliquoting, the aliquot volume*)
		sampleVolumesNeeded=MapThread[
			Function[{injectionVolume,aliquotVolume},
				If[VolumeQ[aliquotVolume],
					aliquotVolume,
					injectionVolume
				]
			],
			{expandedForNumberOfReplicatesInjectionVolumes,expandedAliquotVolume}
		];

	(* Pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes = MapThread[
		{#1, #2}&,
		{listOfExpandedSamples, sampleVolumesNeeded}
	];

	(* Make a list of the sampleResources, combining any of the samplesIn that are duplicates *)
	sampleResources=Map[
		Resource[
			Sample->#[[1,1]],
			Amount->Total[#[[All,2]]],
			Name->ToString[Unique[]]
		]&,
		GatherBy[pairedSamplesInAndVolumes,First]
	];

	orderedSamples=Lookup[sampleResources[[All,1]],Sample];

	(* Make the sample resource replace rules *)
	sampleResourceReplaceRules=AssociationThread[
		orderedSamples->sampleResources
	];

	(* Make the SamplesIn links *)
	samplesInLinks=Link[listOfExpandedSamples,Protocols];

	(* make resourceSamplesIn *)
	resourceSamplesIn=samplesInLinks/.sampleResourceReplaceRules;

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* Expand the samples according to the number of replicates *)
	{expandedSamplesWithNumReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentMeasureViscosity,mySamples,expandedResolvedOptions];
	
	(*  *)
	expandedSamplePacketsWithNumReplicates=expandedSamplesWithNumReplicates/.Thread[Lookup[samplePackets,Object]->samplePackets];
	
	(* Get the working container of the sample after SamplePrep. We need this info for figuring out what rack we need *)
	workingContainers = MapThread[
		If[MatchQ[#1,Except[Null]],
			(* If we are aliquoting, take the Aliquot Container, otherwise, take the SamplesIn container*)
			If[MatchQ[#,{_,ObjectP[]}],
				(* Get rid of the container index *)
				#1[[2]],
				#1
			],
			#2
		]&,
		{Lookup[optionsWithReplicates,AliquotContainer], Lookup[expandedSamplePacketsWithNumReplicates,Container][Object]}
	];

	(* Generate a boolean for whether the sample is in the autosampler vials or a 96-well PCR plate *)
	autosamplerContainerBool = If[MatchQ[workingContainers[[1]],ObjectP[{Object[Container,Plate],Model[Container,Plate]}]],
		False,
		True
	];

	(* If autosamplerContainerBool is False, the samples are in a 96 well plate and we need a plate seal and the 96-well rack insert *)
	plateSealResource = If[autosamplerContainerBool,
		Null,
		Resource[Sample->Model[Item, PlateSeal, "id:9RdZXv17jeqZ"], Name->ToString[Unique[]]]
	];

	(* If autosamplerContainerBool is True, we need to make a resource for a needle to remove bubbles since we cannot centrifuge the containers *)
	needleResource = If[autosamplerContainerBool,
		Resource[Sample->Model[Item, Needle, "id:XnlV5jmbZZpn"], Rent->True, Name->ToString[Unique[]]],
		Null
	];

	(* Generate the rack resource*)
	rackResource = If[autosamplerContainerBool,
		Resource[Sample -> Model[Container, Rack, "Rheosense VROC Initium Autosampler Rack"],Rent->True],
		Resource[Sample -> Model[Container, Rack, "Rheosense VROC Initium 96-Well Plate Rack"], Rent->True]
	];

	(* If the sample tray temperature is held below 20 C or any measurements are made below 20 C, we need to place the cooling insert on the sample and we need to turn on the nitrogen valve to start gas flow to prevent condensation buildup*)
	sampleTemperature = Min[Flatten[ToList[Lookup[myResolvedOptions,SampleTemperature],Lookup[myResolvedOptions,MeasurementTemperature]]]];

	(* The cooling insert is only compatible with the autosampler vials*)
	coolingInsertResource = If[LessEqual[sampleTemperature, 20 Celsius] && autosamplerContainerBool,
		Resource[Sample->Model[Part,"id:O81aEBZ9Nlee"], Rent->True],
		Null
	];

	(* If we are keeping the samples below 20 C, we need to turn on the nitrogen valve to prevent condensation buildup in the instrument *)
	nitroValveBool = If[LessEqual[sampleTemperature, 20 Celsius],
		True,
		False
	];

	(* Generate the resource for the viscometer chip *)
	viscometerChip = Lookup[myResolvedOptions,ViscometerChip];
	viscometerChipResource = Resource[Sample->viscometerChip,Name->ToString[Unique[]], Rent->True];
	viscometerChipFerruleResource = Resource[
		Sample->Model[Item, Consumable, "6-32 1/16'' Tube Fitting for Viscometer Chip"],
		Amount->2,
		Name->ToString[Unique[]]
	];

	(*Generate the resource for the wrench needed to install the ferrules on the viscometer chip*)
	viscometerChipWrenchResource= Resource[Sample->Model[Item,Wrench,"1/8 Inch Open End Wrench for Viscometer"], Rent->True];

	(*Generate the resource for the tweezers needed to install the viscometer chip*)
	viscometerChipTweezersResource= Resource[Sample->Model[Item, Tweezer, "Straight flat tip tweezer"],Rent->True];

	(*Generate the resource for the pliers needed to tighten the screws of the solvent bottle lines on the instrument*)
	viscometerPliersResource= Resource[Sample->Model[Item, Plier, "1.5 Inch NeedNose Plier"],Rent->True];

	(* Generate the resource for the recoup sample container *)
	(* If RecoupSampleContainerSame is False AND we are in the autosampler vials, we need to generate a new container resource for each sample *)
	recoupSampleContainerSame = Lookup[optionsWithReplicates,RecoupSampleContainerSame];
	recoupSamples = Lookup[optionsWithReplicates,RecoupSample];

	(* Get the number of new containers that we need for the recouped sample*)
	recoupContainerCount = Count[recoupSampleContainerSame, False];

	(* If we are using autosampler vials, and recoupContainerCount is not 0, create resources for new autosampler containers *)
	recoupContainerResource = Which[
		(* We are in autosampler containers *)
		autosamplerContainerBool,
			MapThread[
				Function[{recoup,sameContainerBool,originalContainerObj},
					Which[
						(*Create a resource for a new container if we are not recouping into the same container. New container for each sample, even for replicates. *)
						recoup && MatchQ[sameContainerBool,False],
						Link[Resource[Sample->potentialContainers[[2]],Name->CreateUUID[]]],

						(* If we are recouping into the same container, the resource is just the original container *)
						recoup && MatchQ[sameContainerBool,False],
						Link[Resource[Sample->originalContainerObj]],

						(* Else we are not recouping, so make no resources *)
						True,
						Null
					]
				],
				{recoupSamples,recoupSampleContainerSame,workingContainers}
			],

		(* If we are in a plate, and we are recouping at least one sample, we just need to create one resource, the ContainersIn*)
		And[!autosamplerContainerBool, Or@@recoupSamples],
			Link[Resource[Sample->#]]&/@DeleteDuplicates[workingContainers],

		(*Otherwise, we are in a plate and are not recouping so we don't need to create any resources *)
		True,
			Null
	];

	(*-- Generate the resources for the cleaning buffers --*)
	(* Get the number of samples to estimate the amount of cleaning solutions that we need.  *)
	numSamples = Length[pairedSamplesInAndVolumes];
	
	(* The assayType determines the chip model used and also determines the amount of cleaning solutions required *)
	assayType = Lookup[myResolvedOptions,AssayType];

	(* These are the approximate amounts of buffer used per sample when using a corresponding chip according to Software update as of January 2024 *)

	primaryVolumePerSampleB05 = 8.1 Milliliter;
	secondaryVolumePerSampleB05 = 6.9 Milliliter;
	tertiaryVolumePerSampleB05 = 11.9 Milliliter;
	primaryVolumePerSampleC05 = 12.1 Milliliter;
	secondaryVolumePerSampleC05 = 11.3 Milliliter;
	tertiaryVolumePerSampleC05 = 19.3 Milliliter;
	primaryVolumePerSampleE02 = 11.8 Milliliter;
	secondaryVolumePerSampleE02 = 11.1 Milliliter;
	tertiaryVolumePerSampleE02 = 19.2 Milliliter;

	(* In order to ensure effective pick-up of solvent, an extra 100 Milliliter is always added *)
	bufferedVol = 100 Milliliter;

	(* PrimaryBuffer : user specified *)
	primaryBuffer = Lookup[myResolvedOptions,PrimaryBuffer];

	primaryBufferAmount = Which[
		MatchQ[assayType,LowViscosity],
		Min[(primaryVolumePerSampleB05*numberOfSamples)+100 Milliliter,1 Liter],
		
		MatchQ[assayType,HighViscosity],
		Min[(primaryVolumePerSampleC05*numberOfSamples)+100 Milliliter,1 Liter],
		
		MatchQ[assayType,HighShearRate],
		Min[(primaryVolumePerSampleE02*numberOfSamples)+100 Milliliter,1 Liter],
		
		True,
		Min[(primaryVolumePerSampleB05*numberOfSamples)+100 Milliliter,1 Liter]
	];
	
	primaryBufferResource = Resource[Sample->primaryBuffer,Amount-> primaryBufferAmount,Container->Model[Container, Vessel, "1L Glass Bottle"]];
	(* Note: the instrument buffer deck only allows Model[Container, Vessel, "1L Glass Bottle"] *)

	(*Note: we make resources for the secondary and tertiary cleaning solvents here since we want to ensure that there are enough cleaning solvents for the run (vs. having it refilled as a maintenance). We also want to leave open the possibility of custom cleaning solvents in the future, pending method development from Rheosense and customer requests*)

	(* Secondary Cleaning Solvent 1% Aquet in RO Water *)
	secondaryCleaningAmount = Which[
		MatchQ[assayType,LowViscosity],
		Min[(secondaryVolumePerSampleB05*numberOfSamples)+100 Milliliter,1 Liter],
		
		MatchQ[assayType,HighViscosity],
		Min[(secondaryVolumePerSampleC05*numberOfSamples)+100 Milliliter,1 Liter],
		
		MatchQ[assayType,HighShearRate],
		Min[(secondaryVolumePerSampleE02*numberOfSamples)+100 Milliliter,1 Liter],
		
		True,
		Min[(secondaryVolumePerSampleB05*numberOfSamples)+100 Milliliter,1 Liter]
	];
	
	secondaryCleaningSolutionResource = Resource[Sample->Model[Sample, StockSolution, "id:R8e1Pjeapqjj"],Amount->secondaryCleaningAmount,Container->Model[Container, Vessel, "1L Glass Bottle"]];

	(* TertiaryCleaning Solvent: Acetone *)
	tertiaryCleaningAmount = Which[
		MatchQ[assayType,LowViscosity],
		Min[(tertiaryVolumePerSampleB05*numberOfSamples)+100 Milliliter,1 Liter],
		
		MatchQ[assayType,HighViscosity],
		Min[(tertiaryVolumePerSampleC05*numberOfSamples)+100 Milliliter,1 Liter],
		
		MatchQ[assayType,HighShearRate],
		Min[(tertiaryVolumePerSampleE02*numberOfSamples)+100 Milliliter,1 Liter],
		
		True,
		Min[(tertiaryVolumePerSampleB05*numberOfSamples)+100 Milliliter,1 Liter]
	];
	
	tertiaryCleaningSolutionResource = Resource[Sample->Model[Sample,"Acetone, Reagent Grade"],Amount->tertiaryCleaningAmount,Container->Model[Container, Vessel, "1L Glass Bottle"]];

	(* -- Generate instrument resources -- *)

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)

	measurementTable = Lookup[optionsWithReplicates,MeasurementMethodTable];
	measurementTableFlat = Flatten[measurementTable,1];

	(*Extract all the relevant values from the MesurementMethodTable*)
	(*Reformat the measurementMethodTable so that it has a depth of 5 *)
	measurementTableReformat = If[MatchQ[Depth[measurementTable],4],
		{measurementTable},
		measurementTable
	];

	(* For each row in the measurementmethodTable, sum the EquilTime, MeasurementTime, and PauseTime, and multiply by the number of readings *)
	allTimes = measurementTableFlat[[All,4;;6]];

	(*For each row, sum together the Equilibraiton Time, MeasurementTime, and PauseTime*)
	allTimesSummed = (Total/@allTimes) /. Null->7 Second; (* for the Null entries, which indicate priming steps, set to  7 seconds*)

	(* Get the numberofReadings for each row*)
	allNumReadings = measurementTableFlat[[All,8]];

	(*Get the total measurement times by multiplying the number of readings by allTimes summed*)
	totalMeasurementTimes = Total[MapThread[#1*#2 &, {allTimesSummed, allNumReadings}]];

	(* Get the RecoupSample value *)
	recoupSample = Lookup[optionsWithReplicates,RecoupSample];

	(* Count the number of samples that we are recouping. This is used to estimate instrument time, as this adds extra cleaning time*)
	recoupSampleCount = Count[recoupSample,True];

	(*  30 Minutes for setting up the instrument, including loading the buffers and the viscometerchip; 15 Minute for starting up the instrument and running the diagnostic tests, and 10 minutes for cleanup*)
	instrumentSetupTearDown = (30 Minute + 15 Minute + 10 Minute);

	(* Estimate the time needed to run an experiment on the viscometer *)
	instrumentTime = First@Plus[

		(* Time spent actually measuring the sample is equal to the Equilibration Time  + Measurement Time+ pause time * number of reads *)
		totalMeasurementTimes,

		(* Add in more time to account for the TemperatureStabilityTime for each step *)
		Total[allNumReadings]*Lookup[myResolvedOptions,TemperatureStabilityTime],

		(* transferring sample from the container to the autosampler to the injection syringe is approximately 5 minutes *)
		5 Minute*(numberOfSamples*intNumberOfReplicates),

		(* Cleaning the autosampler after is approximately 5 minutes. This occurs after injection *)
		5 Minute*(numberOfSamples*intNumberOfReplicates),

		(* Add more time for recouping the sample. We need to add 5 minutes for the sample recovery + 5 minutes for the autosample cleaning if we are recouping the sample *)
		10 Minute*recoupSampleCount,

		(* Cleaning the autosampler + chip + any other wetted components after each run is 30 minutes per sample *)
		30 Minute*(numberOfSamples*intNumberOfReplicates),

		instrumentSetupTearDown
	];

	(*get the processing time estimate, which is the instrumentTime - instrumentSetupTearDown*)
	processingTime = instrumentTime-instrumentSetupTearDown;

	(* Generate resource for the waste generated *)
		(* Assume all buffer and sample ends up in the waste *)
		(*Primary Buffer: 500 mL, Secondary Cleaning: 250 mL, Tertiary Cleaning -> 250 mL, sample: 100 uL each *)

		(*Samples are mostly aqueous so estimate their density as 1g/L *)
		allWasteWeight = N[(numSamples*100 Microliter + primaryBufferAmount + secondaryCleaningAmount + tertiaryCleaningAmount)*(1 Gram/Milliliter)];
		(*wasteResource = Resource[Waste->Model[Sample,"Chemical Waste"], Amount -> allWasteWeight];*)

	instrumentResource = Resource[Instrument -> instrument, Time -> instrumentTime];

	(* ContainersIn *)
	containersInResources=(Link[Resource[Sample->#],Protocols]&)/@Lookup[samplePackets,Container][Object];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Type -> Object[Protocol,MeasureViscosity],
		Object -> CreateID[Object[Protocol,MeasureViscosity]],
		Replace[SamplesIn] -> resourceSamplesIn,
		Replace[ContainersIn] -> containersInResources,
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> myResolvedOptions,
		NumberOfReplicates -> numReplicates,

		(* General Instrument Set up*)
		Instrument -> Link[instrumentResource],
		ViscometerChip -> Link[viscometerChipResource],
		ViscometerChipWrench -> Link[viscometerChipWrenchResource],
		ViscometerChipTweezers -> Link[viscometerChipTweezersResource],
		ViscometerPliers->Link[viscometerPliersResource],
		AssayType -> Lookup[myResolvedOptions,AssayType],
		NitrogenValve -> nitroValveBool,
		SampleTrayRack -> Link[rackResource],
		SampleTrayInsert -> Link[coolingInsertResource],
		ViscometerChipFerrules -> Link[viscometerChipFerruleResource],

		(* Sample prep resources specific to viscometer *)
		PlateSeal -> Link[plateSealResource],
		Needle -> Link[needleResource],

		(* Method Information *)
		SampleTemperature -> Lookup[myResolvedOptions,SampleTemperature],
		AutosamplerPrePressurization -> Lookup[myResolvedOptions,AutosamplerPrePressurization],
		Replace[InjectionVolumes] -> Lookup[optionsWithReplicates,InjectionVolume],
		Replace[MeasurementMethods] -> Lookup[optionsWithReplicates,MeasurementMethod],
		Replace[TemperatureStabilityMargins] -> Lookup[optionsWithReplicates,TemperatureStabilityMargin],
		Replace[TemperatureStabilityTimes] -> Lookup[optionsWithReplicates,TemperatureStabilityTime],
		Replace[MeasurementTemperatures] -> Lookup[optionsWithReplicates,MeasurementTemperature],
		Replace[FlowRates] -> Lookup[optionsWithReplicates,FlowRate],
		Replace[RelativePressures] -> Lookup[optionsWithReplicates,RelativePressure],
		Replace[EquilibrationTimes] -> Lookup[optionsWithReplicates,EquilibrationTime],
		Replace[MeasurementTimes] -> Lookup[optionsWithReplicates,MeasurementTime],
		Replace[PauseTimes] -> Lookup[optionsWithReplicates,PauseTime],
		Replace[NumberOfReadings] -> Lookup[optionsWithReplicates,NumberOfReadings],
		Replace[Priming] -> Lookup[optionsWithReplicates,Priming],
		Replace[MeasurementMethodTables] -> Lookup[optionsWithReplicates,MeasurementMethodTable],
		Replace[RemeasurementAlloweds] -> Lookup[optionsWithReplicates, RemeasurementAllowed],
		Replace[RemeasurementReloadVolumes] -> Lookup[optionsWithReplicates, RemeasurementReloadVolume],

		(* Post Experiment *)
		ResidualIncubation -> residualIncubation,
		Replace[RecoupSamples] -> Lookup[optionsWithReplicates,RecoupSample],
		Replace[RecoupSampleContainerSame] -> Lookup[optionsWithReplicates,RecoupSampleContainerSame],
		Replace[RecoupSampleContainers] -> recoupContainerResource,
		(* Cleaning *)
		PrimaryBuffer -> Link[primaryBufferResource],
		SecondaryCleaningSolvent-> Link[secondaryCleaningSolutionResource],
		TertiaryCleaningSolvent -> Link[tertiaryCleaningSolutionResource],
		PrimaryBufferStorageCondition -> Lookup[expandedResolvedOptions,PrimaryBufferStorageCondition],

		Replace[SamplesInStorage] -> Lookup[optionsWithReplicates,SamplesInStorageCondition],
		Replace[SamplesOutStorage] -> Lookup[optionsWithReplicates,SamplesOutStorageCondition],
		EstimatedProcessingTime->processingTime,

		Replace[Checkpoints] -> {
			{"Picking Resources",30 Minute,"Samples required to execute this protocol are gathered from storage.", Resource[Operator -> $BaselineOperator, Time -> 10 Minute]},
			{"Preparing Samples",45 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Resource[Operator -> $BaselineOperator, Time -> 45 Minute]},
			{"Measuring Viscosity", instrumentTime,"The viscometer is prepared, the samples are injected into the measurement chip, the viscosity of samples are measured, and the viscometer is cleaned between each sample.", Resource[Operator -> $BaselineOperator, Time -> instrumentTime]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Resource[Operator -> $BaselineOperator, Time -> 1*Hour]},
			{"Returning Materials",20 Minute,"Samples are returned to storage.", Resource[Operator -> $BaselineOperator, Time -> 20*Minute]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->inheritedCache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->inheritedCache, Simulation -> simulation], Null}
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
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule,optionsRule,resultRule, testsRule}
];


(* ::Subsection:: *)
(*Helpers*)
