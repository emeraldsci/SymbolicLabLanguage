(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ThermalShift*)


(* ::Subsubsection:: *)
(*ExperimentThermalShift patterns and hardcoded values*)


(* ::Subsubsection:: *)
(*ExperimentThermalShift Options*)


DefineOptions[ExperimentThermalShift,
	Options :> {
		{
			OptionName->Instrument,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to Model[Instrument, Thermocycler, \"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] for nucleic acid samples and Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] for protein samples",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,Thermocycler],
				Object[Instrument,Thermocycler],
				Model[Instrument, MultimodeSpectrophotometer],
				Object[Instrument, MultimodeSpectrophotometer]}],
				ObjectTypes-> {Model[Instrument,Thermocycler],
					Object[Instrument,Thermocycler],
					Model[Instrument, MultimodeSpectrophotometer],
					Object[Instrument, MultimodeSpectrophotometer]}
			],
			Description->"The instrument used to perform the thermal shift experiment."
		},
		(* if loading is manual then prep plate volume is found InternalExperiment\sources\ThermalShift\Engine.m line 592 *)
		{
			OptionName -> ReactionVolume,
			Default -> Automatic,
			Description -> "The total volume of the reaction including the sample, Buffer, DetectionReagent, and PassiveReference. For protocols using Model[Instrument,MultimodeSpectrophotometer], a minimum of 20 Microliter for the ReactionVolume is required.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[5 Microliter, 40 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
			Category->"Sample Preparation"
		},
		(* === Non-index matched Sample Preparation === *)
		PreparatoryUnitOperationsOption,

		(* === Additional nucleic acid analyte specific sample preparation options === *)
		{
			OptionName->PassiveReference,
			Default -> Null,
			Description -> "A temperature insensitive fluorophore used to normalize melting curves.",
			AllowNull -> True,
			Widget -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
			Category -> "Sample Preparation"
		},
		{
			OptionName->PassiveReferenceVolume,
			Default->Automatic,
			Description -> "The volume of PassiveReference to add to the final reaction.",
			ResolutionDescription->"Automatically set to the manufacturer recommended working concentration of the selected passive reference dye or Null if PassiveReference is not specified.",
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity,Pattern :> GreaterP[0 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
			Category->"Sample Preparation"
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Automatic,
			AllowNull -> True,
			Widget-> Widget[Type->Number,Pattern:>GreaterEqualP[2,1]],
			Description -> "The number of different analysis wells in which each nested index matching sample is measured.",
			ResolutionDescription -> "Automatically set to 2 if Instrument is set to a Model[Instrument, MultimodeSpectrophotometer] or Object[Instrument, MultimodeSpectrophotometer].",
			Category -> "General"
		},

		(* === Index matched options === *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* DILUTION CURVE OPTIONS - these are index matched to each SAMPLE*)
			(* This is because dilution will occur prior to pooling*)
			(* The options should mirror the pool format such that if we have  samples {s1,{s2,s3}} the dilution options would be {{VolumeP,VolumeP,_Integer},{{VolumeP,VolumeP,_Integer},{VolumeP,VolumeP,_Integer}}}*)
			{
				OptionName -> DilutionCurve,
				NestedIndexMatching -> True,
				Default -> Null,
				Description -> "The collection of dilutions that are performed on sample prior to sample pooling (if desired) and thermal ramping.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget-> Alternatives[
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
						"Fixed Dilution Volume"->Adder[
							{
								"Sample Amount"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
								"Diluent Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}]
							}
						],
						"Fixed Dilution Factor"->Adder[
							{
								"Sample Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
								"Dilution Factors"->Widget[Type->Number,Pattern:>RangeP[0,1]]
							}
						]
				]
			},
			{
				OptionName -> SerialDilutionCurve,
				NestedIndexMatching->True,
				Default -> Null,
				Description -> "The collection of dilutions that are performed on sample prior to sample pooling (if desired) and thermal ramping. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed and then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, 100mM sample with a TransferVolume of 20 Microliters, a DiluentVolume of 60 Microliters and a NumberofDilutions of 3 is used, it will create a DilutionCurve of 100mM, 25mM, and 6.25mM with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample is diluted by the dilution factor at each transfer step.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget-> Alternatives[
							Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
						"Serial Dilution Volumes"->
								{
									"Transfer Volume"->Widget[Type->Quantity,Pattern:>GreaterP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
									"Diluent Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
									"Number Of Dilutions"->Widget[Type -> Number,Pattern :> GreaterP[1,1]]
								},
						"Serial Dilution Factor"->
								{
									"Sample Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
									"Dilution Factors" ->
											Alternatives[
												"Constant" -> {
													"Constant Dilution Factor" ->
															Widget[Type -> Number, Pattern :> RangeP[0, 1]],
													"Number Of Dilutions" ->
															Widget[Type -> Number, Pattern :> GreaterP[1, 1]]
												},
												"Variable" ->
														Adder[Widget[Type -> Number, Pattern :> RangeP[0, 1]]]]
								}
						]
			},
			{
				OptionName -> Diluent,
				NestedIndexMatching->True,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
							ObjectTypes->{Model[Sample],Object[Sample]}
						]
					],
				Description -> "The sample that is used to dilute the sample to make a DilutionCurve or SerialDilutionCurve.",
				ResolutionDescription->"Automatically set to Model[Sample,\"Nuclease-free Water\"] for nucleic acid analytes and Model[Sample,StockSolution,\"1x PBS from 10X stock, pH 7\"] for protein analytes when SerialDilutionCurve or DilutionCurve are specified and Null when neither SerialDilutionCurve or DilutionCurve are specified.",
				Category -> "Sample Preparation"
			},

			{
				OptionName -> DilutionContainer,
				NestedIndexMatching->True,
				Default -> Automatic,
				AllowNull -> True,
				Widget-> Alternatives[
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
						{
							"Index" -> Widget[
									Type -> Number,
									Pattern :> GreaterEqualP[1, 1]
								],
							"Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container], Object[Container]}],
									ObjectTypes -> {Model[Container], Object[Container]}
								]
						}
					],
				Description ->"The containers in which each sample is diluted with the Diluent to make the concentration series, with indices indicating specific grouping of samples if desired.",
				ResolutionDescription ->"Automatically set as {1,Model[Container,Plate,\"96-well 2mL Deep Well Plate\"]}.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionStorageCondition,
				NestedIndexMatching->True,
				Default -> Automatic,
				Description -> "The conditions under which any leftover samples from the DilutionCurve or SerialDilutionCurve should be stored after the samples are transferred to the measurement plate.",
				ResolutionDescription->"Automatically set to Disposal.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
				]
			},
			{
				OptionName -> DilutionMixVolume,
				NestedIndexMatching->True,
				Default ->Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
					Widget[
							Type->Quantity,
							Pattern:>GreaterEqualP[0 Microliter],
							Units->{1,{Liter,{Liter,Milliliter,Microliter}}}
						]
					],
				Description -> "The volume that is pipetted out of and in to the dilution to mix the sample with the Diluent to make the DilutionCurve or SerialDilutionCurve.",
				ResolutionDescription->"Automatically set to the smallest dilution volume or half the largest dilution volume, whichever one is smaller.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionNumberOfMixes,
				NestedIndexMatching->True,
				Default ->Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
						Widget[
							Type -> Number,
							Pattern :> RangeP[0,20,1]
						]
					],
				Description -> "The number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve or SerialDilutionCurve.",
				ResolutionDescription->"Automatically set to 5 when DilutionCurve or SerialDilutionCurve is specified.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DilutionMixRate,
				NestedIndexMatching->True,
				Default ->Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
							Units->{1,{Microliter/Second,{Microliter/Second}}}
						]
					],
				Description -> "The speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve or SerialDilutionCurve.",
				ResolutionDescription->"Automatically set to 100 Microliter/Second when DilutionCurve or SerialDilutionCurve is specified.",
				Category -> "Sample Preparation"
			},

			(* POOLED OPTIONS - these are index matched to each POOL as opposed to each SAMPLE *)
			{
				OptionName -> AnalyteType,
				Default -> Automatic,
				AllowNull -> False,
				Widget-> Widget[Type->Enumeration,Pattern:>Alternatives[Oligomer,Protein]],
				Description -> "The type of molecule present in the nested index matching sample that is detected during instrument measurement.",
				ResolutionDescription -> "Automatically set to the type of specified analytes in the sample definition.",
				Category -> "General"
			},
			(* mixing of the pool *)
			{
				OptionName -> NestedIndexMatchingMix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
				Description -> "Indicates if mixing of the nested index matching samples occur inside the destination plate.",
				ResolutionDescription -> "Automatically set based on whether pooling of the source samples is performed.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingMixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (Pipette|Invert)],
				Description -> "Indicates the style of motion used to mix the nested index matching samples inside the AliquotContainer.",
				ResolutionDescription -> "Automatically set to Pipette when NestedIndexMatchingMix is True.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingNumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description ->  "The number of times each nested index matching sample is mixed by pipetting or inversion.",
				ResolutionDescription->"Automatically set to 5.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingMixVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Microliter, 50 Milliliter],Units :> {1,{Milliliter,{Microliter,Milliliter}}}],
				Description -> "The volume of each nested index matching sample is pipetted up and down to mix.",
				ResolutionDescription->"Automatically set to half the total nested index matching volume.",
				Category->"Sample Preparation"
			},
			(* incubation of the pools (annealing) *)
			{
				OptionName -> NestedIndexMatchingIncubate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if thermal incubation of the nested index matching samples occur prior to measurement.",
				ResolutionDescription->"Automatically set to False if NestedIndexMatchingIncubationTime, NestedIndexMatchingIncubationTemperature, and NestedIndexMatchingAnnealingTime are not specified. Automatically set to True if either NestedIndexMatchingIncubationTime, NestedIndexMatchingIncubationTemperature, or NestedIndexMatchingAnnealingTime are specified.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> PooledIncubationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Minute,$MaxExperimentTime], Units :> {1,{Hour,{Second,Minute,Hour}}}],
				Description -> "Duration for which the nested index matching samples are thermally incubated prior to measurement.",
				ResolutionDescription-> "Automatically set to Null if NestedIndexMatchingIncubate is False and 5 minutes if NestedIndexMatchingIncubate is True.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingIncubationTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[22 Celsius, 90 Celsius],Units :> Celsius],
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
				],
				Description -> "Temperature at which the nested index matching samples are thermally incubated prior to measurement.",
				ResolutionDescription->"Automatically set to Null if NestedIndexMatchingIncubate is False and 85 Celsius if NestedIndexMatchingIncubate is True.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingAnnealingTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units :> Alternatives[Second,Minute,Hour]],
				Description -> "Duration for which the nested index matching samples remain in the thermal incubation instrument before being removed, allowing the system to settle to room temperature after the NestedIndexMatchingIncubationTime has passed.",
				ResolutionDescription-> "Automatically set to Null if NestedIndexMatchingIncubate is False and 3 Hour if NestedIndexMatchingIncubate is True.",
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleVolume,
				Default->Automatic,
				Description -> "The volume of the sample containing the main analyte used in the experiment.",
				ResolutionDescription->"Automatically set to 20uL if the instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models and 10uL if the instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or an object with this model.",
				AllowNull -> False,
				Widget->Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 40 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Sample Preparation"
			},
			{
				OptionName->Buffer,
				Default->Automatic,
				Description -> "A sample used to bring each reaction to its reaction volume once all other components have been added.",
				ResolutionDescription->"Automatically set to Model[Sample,\"Nuclease-free Water\"] for nucleic acid analytes and Model[Sample,StockSolution,\"1x PBS from 10X stock, pH 7\"] for protein analytes.",
				AllowNull -> True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}]],
				Category->"Sample Preparation"
			},
			{
				OptionName -> BufferVolume,
				Default -> Automatic,
				Description -> "The volume, of Buffer added to bring the reaction volume up to ReactionVolume.",
				ResolutionDescription-> "Automatically set to the volume difference between the sum of the reaction components and the reaction volume.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 40 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category->"Sample Preparation"
			},
			{
				OptionName -> DetectionReagent,
				Default -> Automatic,
				Description -> "The fluorophore or fluorescent dye used to detect melting of the analyte.",
				ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"10X SYBR Gold in filtered 1X TBE Alternative Preparation\"] for nucleic acid analytes. Automatically set to Model[Sample,StockSolution,\"10X SYPRO Orange\"] for protein analytes if the instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models and Null if the instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or an object with this model.",
				AllowNull -> True,
				Widget -> Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category -> "Sample Preparation"
			},
			{
				OptionName -> DetectionReagentVolume,
				Default -> Automatic,
				Description -> "The volume of the DetectionReagent to add to the reaction.",
				ResolutionDescription -> "Automatically set to the manufacturer's recommendation for the working concentration of the selected detection reagent. In the case of Model[Sample,StockSolution,\"10X SYPRO Orange\"], the default working concentration is set to 5X.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Microliter, 40 Microliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
				Category -> "Sample Preparation"
			}
		],
		(* === Melting curve options === *)
		{
			OptionName->MinTemperature,
			Default->15 Celsius,
			Description -> "The low temperature of the heating or cooling cycle.",
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Melting Curve",
			AllowNull-> False
		},
		{
			OptionName->MaxTemperature,
			Default->95 Celsius,
			Description -> "The high temperature of the heating or cooling cycle.",
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 100 Celsius],Units -> {1,{Celsius,{Celsius,Kelvin,Fahrenheit}}}],
			Category->"Melting Curve",
			AllowNull-> False
		},
		{
			OptionName -> TemperatureRampOrder,
			Default -> {Heating, Cooling},
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration,Pattern :> ThermodynamicCycleP],
			Description -> "The order of temperature ramping to be performed in each cycle.",
			Category -> "Melting Curve"
		},
		{
			OptionName->NumberOfCycles,
			Default->Automatic,
			AllowNull->False,
			Description->"The number of repeated melting and cooling cycles to be performed.",
			ResolutionDescription->"Automatically set to 0.5 cycles. Half cycles represent a monotonically ascending or descending temperature ramp and is determined by the first entry in TemperatureRampOrder. More than 0.5 cycles can only be measured on Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"].",
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[0.5,1,1.5,2,2.5,3]],
			Category->"Melting Curve"
		},
		{
			OptionName->EquilibrationTime,
			Default->1 Minute,
			Description-> "The time between each melting and cooling cycle during which the samples are held at the starting temperature of the next thermal ramp.",
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0 Second, 99 Minute + 59 Second], Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Melting Curve",
			AllowNull-> False
		},
		{
			OptionName->TemperatureRamping,
			Default->Automatic,
			Description-> "The type of temperature ramp. Linear temperature ramps increase temperature at a constant rate given by TemperatureRampRate. Step temperature ramps increase the temperature by TemperatureRampStep/TemperatureRampStepTime and holds the temperature constant for TemperatureRampStepHold before measurement.",
			ResolutionDescription->"Automatically set to Linear if no stepped temperature ramp options are specified. Automatically set to Step if any stepped temperature ramp options are specified.",
			Widget-> Widget[Type->Enumeration, Pattern:>Alternatives[Linear, Step]],
			AllowNull->False,
			Category->"Melting Curve"
		},
		{
			OptionName->TemperatureRampRate,
			Default->Automatic,
			Description -> "The rate at which the temperature is changed in the course of one heating and/or cooling cycle.",
			ResolutionDescription->"If TemperatureRamping is Linear, automatically set to 1 Celsius/Minute. If TemperatureRamping is Step, automatically set to the max ramp rate available on the instrument.",
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[.0015 (Celsius/Second), 3.4 (Celsius/Second)],Units -> CompoundUnit[{1,{Celsius,{Celsius,Kelvin,Fahrenheit}}},{-1,{Second,{Second,Minute}}}]],
			Category->"Melting Curve",
			AllowNull-> False
		},
		(* === Linear Ramp Options === *)
		{
			OptionName -> TemperatureResolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0*Celsius,100*Celsius], Units:>Celsius],
			Description -> "The amount by which the temperature is changed between each data point and the subsequent data point for a given sample during the melting and/or cooling curves.",
			ResolutionDescription -> "Automatically set to highest possible resolution if the instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or an object with this model. Automatically set to Null if the instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models because temperature resolution is not tunable on this instrument type.",
			Category -> "Melting Curve"
		},
		(* === Step Ramp Options === *)
		{
			OptionName->NumberOfTemperatureRampSteps,
			Default->Automatic,
			Description->"The number of step changes in temperature for a heating or cooling cycle.",
			ResolutionDescription-> "If TemperatureRamping is Step, automatically set to the absolute value of the difference in MinTemperature and MaxTemperature rounded to the nearest integer. If TemperatureRamping is Linear, automatically set to Null.",
			Widget -> Widget[Type->Number,Pattern:>RangeP[1, 100]],
			Category->"Melting Curve",
			AllowNull-> True
		},
		{
			OptionName->StepHoldTime,
			Default->Automatic,
			Description->"The length of time samples are held at each temperature during a stepped temperature ramp prior to fluorescence or static light scattering measurement.",
			ResolutionDescription-> "Automatically set to 30 Second when TemperatureRamping is \"Step\" and Null when TemperatureRamping is \"Linear\".",
			Widget -> Widget[Type -> Quantity,Pattern :> RangeP[1 Second, 13500 Second], Units -> {1,{Second,{Second,Minute,Hour}}}],
			Category->"Melting Curve",
			AllowNull-> True
		},

		(*Index matched Detection Options*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* === MultimodeSpectrophotometer specific detection options === *)
			{
				OptionName->FluorescenceLaserPower,
				Default->Automatic,
				Description -> "The fluorescence laser power filter used in the experiment. If OptimizeFluorescenceLaserPower is True, this is the laser power at which the optimization starts.",
				ResolutionDescription -> "Automatically set to 50 Percent if the instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or an object with this model and Null if the instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models.",
				AllowNull -> True,
				Widget->Widget[Type -> Enumeration, Pattern :> LaserPowerFilterP],
				Category->"Detection"
			},
			{
				OptionName->StaticLightScatteringLaserPower,
				Default->Automatic,
				Description -> "The static light scattering laser power filter used in the experiment. A laser power of 25% is recommended for most proteins. Higher laser powers may be necessary for smaller particles that do not scatter as much light. If OptimizeStaticLightScatteringLaserPower is True, the laser power used in the experiment will match the optimized fluorescence laser power setting.",
				ResolutionDescription -> "Automatically set to 25 Percent if the instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or an object with this model and Null if the instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models.",
				AllowNull -> True,
				Widget->Widget[Type -> Enumeration, Pattern :> LaserPowerFilterP],
				Category->"Detection"
			},
			{
				OptionName->OptimizeFluorescenceLaserPower,
				Default->False,
				Description -> "Indicates if prior to thermal ramping, the fluorescence laser power filter should be adjusted such that the sample's spectra at or between LaserOptimizationEmissionWavelengthRange has a peak intensity that falls within the LaserOptimizationTargetEmissionIntensityRange.",
				AllowNull -> False,
				Widget->Widget[Type -> Enumeration, Pattern :> BooleanP],
				Category->"Detection"
			},
			{
				OptionName->OptimizeStaticLightScatteringLaserPower,
				Default->False,
				Description -> "Indicates if prior to thermal ramping, the static light scattering laser power filter should be adjusted to match the optimized fluorescence laser power filter.",
				AllowNull -> False,
				Widget->Widget[Type -> Enumeration, Pattern :> BooleanP],
				Category->"Detection"
			},
			{
				OptionName->LaserOptimizationEmissionWavelengthRange,
				Default->Automatic,
				Description -> "Indicates the wavelength range of the sample's spectra used to evaluate optimal laser setting when OptimizeFluorescenceLaserPower is True.",
				ResolutionDescription->"Automatically set to Null if OptimizeFluorescenceLaserPower is False. If OptimizeFluorescenceLaserPower is True, automatically set to {300*Nanometer,450*Nanometer}.",
				AllowNull -> True,
				Widget-> Span[
					Widget[Type -> Quantity, Pattern :> RangeP[250 Nanometer, 719 Nanometer,1 Nanometer],Units :> Nanometer],
					Widget[Type->Quantity, Pattern :> RangeP[251 Nanometer, 750 Nanometer,1 Nanometer],Units :> Nanometer]
				],
				Category->"Detection"
			},
			{
				OptionName->LaserOptimizationTargetEmissionIntensityRange,
				Default->Automatic,
				Description -> "Indicates the optimal signal intensity range, expressed as a percentage of the detector saturation intensity, used to evaluate optimal laser setting when OptimizeFluorescenceLaserPower is True.",
				ResolutionDescription->"Automatically set to Null if OptimizeFluorescenceLaserPower is False. If OptimizeFluorescenceLaserPower is True, set to {5 Percent, 20 Percent}.",
				AllowNull -> True,
				Widget-> Span[
					Widget[Type -> Quantity, Pattern :> RangeP[0.1 Percent, 99.9 Percent,0.1 Percent] ,Units :> Percent],
					Widget[Type->Quantity, Pattern :> RangeP[0.2 Percent, 100 Percent,0.1 Percent],Units :> Percent]
				],
				Category->"Detection"
			},
			(* === Fluorescence detection options === *)
			{
				OptionName -> ExcitationWavelength,
				Default->Automatic,
				Description -> "The wavelength of light used to excite the reporter component of the detection reagent.",
				ResolutionDescription -> "Automatically set to the available excitation wavelength closest to the excitation maximum of the corresponding detection reagent if the instrument is Model[Instrument, Thermocycler, \"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models. Automatically set to 266 nm if the instrument is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] or an object with this model" ,
				AllowNull -> False,
				Widget->Widget[Type -> Quantity,Pattern :> RangeP[266 Nanometer, 670 Nanometer],Units -> Nanometer],
				Category->"Detection"
			},
			{
				OptionName -> EmissionWavelength,
				Default->Automatic,
				Description -> "The wavelength of emitted light recorded.",
				ResolutionDescription -> "Automatically set to the available emission wavelength closest to the emission maximum of the corresponding detection reagent if the instrument is Model[Instrument, Thermocycler, \"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models. Automatically set to Null if the instrument is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] or an object with this model",
				AllowNull -> True,
				Widget->Widget[Type -> Quantity,Pattern :> RangeP[250 Nanometer, 720 Nanometer],Units -> Nanometer],
				Category->"Detection"
			},
			{
				OptionName->MinEmissionWavelength,
				Default->Automatic,
				Description -> "The minimum wavelength of emitted light recorded for the sample fluorescence spectra.",
				ResolutionDescription -> "Automatically set to 250nm if the instrument is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] or an object with this model and Null if the instrument is Model[Instrument, Thermocycler, \"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models.",
				AllowNull -> True,
				Widget->Widget[Type -> Quantity,Pattern :> RangeP[250 Nanometer, 720 Nanometer],Units -> Nanometer],
				Category->"Detection"
			},
			{
				OptionName->MaxEmissionWavelength,
				Default->Automatic,
				Description -> "The maximum wavelength of emitted light recorded for the sample fluorescence spectra.",
				ResolutionDescription -> "Automatically set to 720nm if the instrument is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] or an object with this model and Null if the instrument is Model[Instrument, Thermocycler, \"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models.",
				AllowNull -> True,
				Widget->Widget[Type -> Quantity,Pattern :> RangeP[250 Nanometer, 720 Nanometer],Units -> Nanometer],
				Category->"Detection"
			},
			(* === Static Light Scattering specific detection options === *)
			{
				OptionName-> StaticLightScatteringExcitationWavelength,
				Default -> Automatic,
				Description -> "The wavelength(s) of light used to illuminate static light scattering measurements.",
				ResolutionDescription-> "Automatically set to {266 Nanometer, 473 Nanometer} if the instrument is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] or an object with this model and Null if the instrument is Model[Instrument, Thermocycler, \"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"] or an object with these models.",
				AllowNull-> True,
				Widget->Widget[Type->MultiSelect, Pattern:>DuplicateFreeListableP[EqualP[266*Nanometer]|EqualP[473*Nanometer]]],
				Category->"Detection"
			}
		],

		(* === Dynamic Light Scattering options === *)
		{
			OptionName->DynamicLightScattering,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description->"Indicates if at least one DLS measurement of each sample is made during the experiment.",
			Category->"Detection"
		},
		{
			OptionName->DynamicLightScatteringMeasurements,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[
					{Before},
					{After},
					{Before,After}
				]
			],
			Description->"Describes if a DLS measurement of each sample will be made before thermal ramping, after thermal ramping, or both before and after thermal ramping.",
			ResolutionDescription->"Automatically set to Null if DynamicLightScattering is False and to {Before,After} otherwise.",
			Category->"Detection"
		},
		{
			OptionName->DynamicLightScatteringMeasurementTemperatures,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[15*Celsius,95*Celsius], Units:>Celsius],
				{
					"Before" -> Widget[Type -> Quantity, Pattern :> RangeP[15*Celsius,95*Celsius], Units:>Celsius],
					"After" -> Widget[Type -> Quantity, Pattern :> RangeP[15*Celsius,95*Celsius], Units:>Celsius]
				}
			],
			Description->"Indicates the temperatures at which DLS measurements will be acquired. If only a single measurement is required, provide only one temperature. If DynamicLightScatteringMeasurements->{Before,After}, provide a matched list of temperatures.",
			ResolutionDescription->"Automatically set to Null if DynamicLightScattering is False and to the temperature of the adjacent thermal ramp otherwise.",
			Category->"Detection"
		},
		{
			OptionName->NumberOfDynamicLightScatteringAcquisitions,
			Default->Automatic,
			Description->"For each DLS measurement, the number of series of speckle patterns that are each collected over the AcquisitionTime to create the measurement's autocorrelation curve.",
			ResolutionDescription->"Automatically set to Null if DynamicLightScattering is False and to 4 if DynamicLightScattering is True.",
			AllowNull->True,
			Category->"Detection",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,20,1]
			]
		},
		{
			OptionName->DynamicLightScatteringAcquisitionTime,
			Default->Automatic,
			Description->"For each DLS measurement, the length of time that each acquisition generates speckle patterns to create the measurement's autocorrelation curve.",
			ResolutionDescription->"Automatically set to Null if DynamicLightScattering is False and to 5 seconds if DynamicLightScattering is True.",
			AllowNull->True,
			Category->"Detection",
			Widget-> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1*Second,30*Second],
				Units -> Second
			]
		},
		{
			OptionName->AutomaticDynamicLightScatteringLaserSettings,
			Default->Automatic,
			Description->"Indicates if the DynamicLightScatteringLaserPower and DynamicLightScatteringDiodeAttenuation are automatically set at the beginning of the assay by the Instrument to levels ideal for the samples.",
			ResolutionDescription->"Automatically set to Null if DynamicLightScattering is False. If DynamicLightScattering is True and either the DynamicLightScatteringLaserPower or DynamicLightScatteringDiodeAttenuation is specified, the option is set to False. Otherwise, AutomaticDynamicLightScatteringLaserSettings is set to True.",
			AllowNull->True,
			Category->"Detection",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName->DynamicLightScatteringLaserPower,
			Default->Automatic,
			Description->"The percent of the max dynamic light scattering laser power that is used to make DLS measurements. The laser level is optimized at run time by the instrument software when AutomaticDynamicLightScatteringLaserSettings is True and LaserLevel is Null.",
			ResolutionDescription->"Automatically set to 100% if AutomaticDynamicLightScatteringLaserSettings is False and to Null otherwise.",
			AllowNull->True,
			Category->"Detection",
			Widget-> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1*Percent,100*Percent],
				Units -> Percent
			]
		},
		{
			OptionName->DynamicLightScatteringDiodeAttenuation,
			Default->Automatic,
			Description->"The percent of scattered light signal that is allowed to reach the avalanche photodiode for DLS measurements. The attenuator level is optimized at run time by the instrument software when AutomaticDynamicLightScatteringLaserSettings is True and DiodeAttenuation is Null.",
			ResolutionDescription->"Automatically set to 100% if AutomaticDynamicLightScatteringLaserSettings is False and to Null otherwise.",
			AllowNull->True,
			Category->"Detection",
			Widget-> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1*Percent,100*Percent],
				Units -> Percent
			]
		},
		{
			OptionName->DynamicLightScatteringCapillaryLoading,
			Default->Automatic,
			Description->"The loading method for capillaries when the instrument used is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] . When set to Robotic, capillaries are loaded by liquid handler. when set to Manual, capillaries are loaded by a multichannel pipette.",
			ResolutionDescription->"If Automatic, set to Manual if the instrument is Model[Instrument, MultimodeSpectrophotometer, \"Uncle\"] and to Null otherwise.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Automatic, Robotic, Manual]
			]
		},

		(*Sample recovery and storage options*)
		{
			OptionName ->ContainerOut,
			Default -> Null,
			AllowNull -> True,
			Widget->Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Container]],
				ObjectTypes -> {Model[Container]}
			],
			Description -> "The container which the assay samples are transferred into after the experiment.",
			Category -> "Sample Storage"
		},
		{
			OptionName -> SamplesOutStorageCondition,
			Default -> Null,
			Description -> "The condition under which the assay samples in ContainerOut should be stored after the protocol is completed.",
			AllowNull -> True,
			Category -> "Sample Storage",
			Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
		},

		(*===Shared Options===*)
		SimulationOption,
		ProtocolOptions,
		NonBiologyPostProcessingOptions,
		NonBiologyFuntopiaSharedOptionsPooled,
		SubprotocolDescriptionOption,
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True
				}
			}
		]
	}
];


(*Error Definitions*)
(*Conflicting options*)
Error::TooManyTemperatureRampOptions = "Both Linear temperature ramp option `1` and Step temperature ramp options `2` cannot be specified.";
Error::IncompatibleTemperatureRamp = "If `1` temperature ramping is specified, cannot specify `2` options.";
Error::TooFewTemperatureRampOptions ="Both Linear temperature ramp option `1` and Step temperature ramp options `2` cannot be Null if TemperatureRamping is Automatic.";
Error::InvalidNullTemperatureRampOptions ="If `1` temperature ramping is specified, `2` option(s) cannot be Null.";
Error::InvalidNestedIndexMatchingMixOptions = "For the following sample pool(s), NestedIndexMatchingMix conflicts with nested index matching mix options: `1`. Please set pool mix to `2` respectively or do not specify nested index matching mix options.";
Error::InvalidNestedIndexMatchingIncubateOptions = "For the following sample pool(s) `1`, NestedIndexMatchingIncubation options are conflicting `2`. Please resolve conflicts or do not specify nested index matching incubate options.";
Error::IncompatibleMixOptions = " Sample pool(s) with conflicting NestedIndexMatchingMixType and NestedIndexMatchingMixVolume options. Please resolve the following conflicts: `1`.";
Error::IncompatibleSampleStorageOptions ="Conflicting ContainerOut and SamplesOutStorageCondition options. Please resolve the following conflicts: `1`.";
Error::InvalidEmissionOptions = "Sample pool(s) with conflicting EmissionWavelength and emission wavelength range options. Please resolve the following conflicts by specifying either an emission wavelength or an emission wavelength range: `1`.";
Error::IncompatibleEmissionRangeOptions = "Sample pool(s) with incompatible MinEmissionWavelength and MaxEmissionWavelength options. Please resolving the following conflicts by providing a range where MinEmissionWavelength is less than MaxEmissionWavelength or use EmissionWavelength if only a single wavelength is desired:`1`.";
Error::InvalidPassiveReferenceOptions = "If PassiveReference is `1`, PassiveReferenceVolume cannot be `2`.";
Error::IncompatibleDetectionReagentOptions = "Sample pool(s), with conflicting DetectionReagent and DetectionReagentVolume options. One option cannot be Null if the other option is specified, please update the following options or use Automatic: `1`.";
Error::TooManyDilutionCurveOptions = "For the following sample pool(s), `1`, both serial dilution and dilution curve options are specified. Please choose only one dilution option per input sample. If both are desired, duplicate the input sample.";
Error::IncompatibleDilutionCurveOptions = "For the following sample pool(s) `1`, serial dilution or dilution curve options conflict with dilution parameters. Please resolve the following conflicts: `2`.";
Error::InvalidTemperatureRamp = "The specified MinTemperature `1` is greater than the specified MaxTemperature `2`. Please specify a MinTemperature that is less than the MaxTemperature.";
Error::InvalidPassiveReferenceVolume = "Could not resolve the appropriate volume for the passive reference dye `1`. Please specify the desired volume using the PassiveReferenceVolume option.";
Error::InvalidThermocycler = "The specified instrument `1` is not a qPCR thermocycler and cannot be used for this experiment. Please change the Instrument option to a compatible instrument model, object, or use Automatic.";
Error::ConflictingThermalShiftDLSOptions="The following options, `1`, with values of `2` are in conflict. If DynamicLightScattering is False, none of the dynamic light scattering-related options can be specified. Please consider setting DynamicLightScattering to True or to let these options resolve automatically.";
Error::ConflictingThermalShiftNullDLSOptions="The following options, `1`, with values of `2` are in conflict. If DynamicLightScattering is True, none of the DynamicLightScatteringMeasurements, NumberOfDynamicLightScatteringAcquisitions, or DynamicLightScatteringAcquisitionTime options can be Null. Please ensure that these options are not in conflict, or consider letting these options resolve automatically.";

(*Mapthread and resolved option Errors*)
Error::InvalidPoolMixVolumes = "For the following sample pool(s), the corresponding mix volume is greater than the available nested index matching volume `1`. Please decrease the mix volume or use Automatic.";
Error::InvalidDetectionReagentVolumes = "For the following sample(s), the corresponding detection reagent volume could not be resolved: `1` . Please specify the desired volume using DetectionReagentVolume option.";
Error::InvalidSampleVolumes = "For the following sample pool(s), the sample volumes are less than zero `1`. Please specify desired sample volume or increase the reaction volume.";
Error::InvalidBufferVolumes = "For the following sample pool(s), the buffer volumes are less than zero `1`. Please specify desired buffer volume or increase the reaction volume.";
Error::InsufficientDilutionVolume = "For the following sample pool(s), the required sample aliquot volume exceeds one or more available dilution volumes `1`. Please increase dilution curve volumes or decrease the aliquot volume.";
Error::InvalidDilutionMixVolumes = "For the following sample pool(s), the dilution mix volume exceeds the smallest dilution volume `1`. Please lower the dilution mix volume or use Automatic.";
Error::InvalidThermocyclerOptions = "For the following sample pool(s): `2`, FluorescenceLaserPower, StaticLightScatteringLaserPower, or StaticLightScatteringExcitationWavelength detection parameters are specified but are incompatible with the instrument `1`. If fluorescence or static light scattering is desired, please use instrument `3`.";
Error::InvalidEmissionRange = "For the following sample pool(s), an emission range cannot be specified if the instrument is `1`: `2`. Please specify an emission wavelength or use Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"].";
Error::InvalidMultiModeSpectrometerOptions = "For the following sample pool(s), the corresponding detection parameters {FluorescenceLaserPower,StaticLightScatteringLaserPower,StaticLightScatteringExcitationWavelength}, cannot be Null when the resolved instrument is `1`: `2`. Please specify the parameters or if static light scattering is not desired set StaticLightScatteringLaserPower to 0%.";
Error::InvalidExcitationWavelengths = "For the following sample pool(s), the excitation wavelength could not be resolved `1`. Please specify an appropriate excitation wavelength.";
Error::InvalidEmissionWavelengths = "For the following sample pool(s), the emission wavelength could not be resolved `1`. Please specify an appropriate emission wavelength.";
Error::IncompatibleExcitationWavelength = "For the following samples pool(s), the corresponding excitation wavelength is not compatible with the instrument `1`: `2`.";
Error::IncompatibleEmissionOptions = "For the following sample pool(s), the corresponding emission detection wavelengths are not compatible with the instrument `1`: `2`.";
Error::InvalidTemperatureResolution = "Invalid TemperatureResolution `1`. Temperature resolution must be Null for instrument `2`.";
Error::IncompatibleTemperatureResolution = "The temperature resolution `1` exceeds the maximum achievable resolution. With `2` samples and a linear ramp rate of `3`, the maximum achievable temperature resolution is `4`.";
Error::InvalidRampRate = "The temperature ramp rate `1` is greater than the operating limits of the instrument `2`. Please specify a rate less than `3` for this instrument.";
Error::InvalidMinTemperature = "The MinTemperature `1` is outside the operating limits of the instrument `2`. Please specify a MinTemperature between `3` for this instrument.";
Error::InvalidMaxTemperature = "The MaxTemperature `1` is outside the operating limits of the instrument `2`. Please specify a MaxTemperature between `3` for this instrument.";
Error::TooManySamples = "The experiment requires `1` assay wells which exceeds the instrument `2` max capacity of `3`. Please decrease the sample number or change the dilution options.";
Error::InvalidReactionVolume = "The resolved reaction volume is incompatible with `1` instrument assay containers which have a capacity of `2`. Please adjust the reaction volume or use automatic.";
Error::InvalidContainerOut = "Samples cannot be recouped from `2` instrument assay containers. Please change the ContainerOut option from `1` to Null.";
Error::InvalidNumberOfCycles = "The number of cycles `1` exceeds the `2` instrument capacity of 0.5 cycles. To acquire data for more cycles consider using Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"].";
Error::InvalidDilutionContainers = "For the following samples, the max dilution volume exceeds the capacity of the dilution container: `1`. Please specify a container with a higher max volume.";
Error::InvalidTotalReactionVolume = "For the following samples, the total volume of the reaction components does not equal the ReactionVolume: `1`. Please adjust one or more of the following options: `2`.";
Error::InvalidNestedIndexMatchingDilutions = "For the following sample pools, the number of dilutions for each pooling partner are not equal:`1`. Please adjust one or more of the following options `2`.";
Error::TooManySamplesOut = "The number of samples exceeds the ContainerOut max capacity of `1`. Please use a container that can accommodate all samples.";
Error::TooManyDilutionStorageConditions = "Samples diluted in the containers `1` have conflicting storage conditions `2`. Please fix the storage conditions for samples diluted in the same container or dilute samples in different containers.";
Error::ConflictingThermalShiftDynamicLightScatteringInstrument="The Instrument, `1`, and DynamicLightScattering option, `2`, are in conflict. DynamicLightScattering can only be True if the Instrument is a MultimodeSpectrophotometer. Please ensure that these options are not in conflict";
Error::ConflictingThermalShiftAutomaticDLSLaserOptions="The following options, `1`, with values of `2` are in conflict. If AutomaticDynamicLightScatteringLaserSettings is True, both the DynamicLightScatteringLaserPower and DynamicLightScatteringDiodeAttenuation options must be Null. If AutomaticDynamicLightScatteringLaserSettings is True, neither of the other two options can be Null. Please ensure that these options are not in conflict, or consider letting these options resolve automatically.";
Error::ConflictingDLSMeasurementRequestedTemperatures = "When DynamicLightScatteringMeasurements is `1`, DynamicLightScatteringMeasurementTemperatures may not be `2`. Please provide the correct number of temperatures or Null if DLS measurements are not required.";

(*warnings*)
Warning::IncompatibleAnalytes = "`1` type analytes are not recommended for this assay. Automatic options will default to oligomer settings if no other compatible analytes are present.";
Warning::MoreThanOneTypeOfAnalyte = "The input samples contain `1` analytes. More than one type of analyte is not recommended for this assay. Automatic options will default to oligomer settings.";
Warning::UnknownAnalytes = "Unable to identify protein or nucleotide analytes. Other types of analytes are not recommended for this assay. Automatic options will default to oligomer analyte settings.";
Warning::RecommendedInstrument = "The specified instrument `1` is not recommended for the input sample analytes. Consider using `2` instead.";
Warning::InvalidLaserOptimization = "`1` option(s) will be ignored. Laser power cannot be adjusted on `2` instrument.";
Warning::UnusedOptimizationParameters = "For the following samples, `1` option(s) will be ignored because OptimizeFluorescenceLaserPower is False:`2`. Please set OptimizeFluorescenceLaserPower to True if laser power optimization is desired.";


(* ::Subsubsection::Closed:: *)
(*ExperimentThermalShift Experiment function*)


(* Overload for mixed input like {s1,{s2,s3}} -> We assume the first sample is going to be inside a pool and turn this into {{s1},{s2,s3}} *)
(*This overload also converts container inputs into sample inputs and expands options such that index matching is preserved.*)
ExperimentThermalShift[mySemiPooledInputsNamed:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample],Object[Container],Model[Sample]}],_String,{LocationPositionP,_String|ObjectP[Object[Container]]}]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,listedInputs,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,
		containerToSampleTests,samples,sampleOptions,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		listedInputsNoTemporalLinks,prepPrim,contentsPerDefinedContainerObject,totalSampleCountsPerDefinedContainerRules,
		defineAssociations,prepUnitOperations,labelContainerPrimitives,definedContainerRules,uniqueSampleTransfersPerDefinedContainer,
		totalSampleCountsPerDefinedContainer,mySemiPooledInputs,listedOptionsNamed, updatedSimulation,containerToSampleSimulation},

	(* Make sure we're working with a list of options *)
	listedOptionsNamed=ToList[myOptions];

	(* remove named objects *)
	{mySemiPooledInputs,listedOptions}=sanitizeInputs[ToList@mySemiPooledInputsNamed,listedOptionsNamed, Simulation->Lookup[listedOptionsNamed,Simulation,Null]];

	(* If this failed because of ODNE, fail gracefully here *)
	If[MatchQ[listedOptions,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* in the next step we will be wrapping a list around any single sample inputs except plates. in order to not pool all the samples in a Defined container that has more than one sample, we need to get the containers for the defined inputs and wrap a list only around ones that do not have more than one sample in them.*)
	prepPrim = Lookup[listedOptions,PreparatoryUnitOperations];
	defineAssociations = Cases[prepPrim, DefineP]/. Define -> Sequence;

	prepUnitOperations = Lookup[ToList[myOptions],PreparatoryUnitOperations];
	labelContainerPrimitives = If[MatchQ[prepUnitOperations, _List],
		Cases[prepUnitOperations, _LabelContainer],
		{}
	];

	definedContainerRules = Join[
		If[MatchQ[defineAssociations,{}|Null],
			{},
			MapThread[#1->#2&,{Lookup[defineAssociations,Name],Lookup[defineAssociations,Container]}]
		],
		If[MatchQ[labelContainerPrimitives,{}|Null],
			{},
			MapThread[#1->#2&,{Lookup[labelContainerPrimitives[[All,1]],Label],Lookup[labelContainerPrimitives[[All,1]],Container]}]
		]
	];

	contentsPerDefinedContainerObject = Association@Thread[
		PickList[Keys[definedContainerRules],Values[definedContainerRules],ObjectP[Object[Container]]] -> Length/@Download[Cases[Values[definedContainerRules],ObjectP[Object[Container]]],Contents]
		];

	uniqueSampleTransfersPerDefinedContainer = Counts@DeleteDuplicates[Cases[Flatten[Lookup[Cases[prepPrim, _?Patterns`Private`transferQ] /. Transfer -> Sequence, Destination], 1], {_String, WellP}]][[All, 1]];

	totalSampleCountsPerDefinedContainerRules = Normal@Merge[{contentsPerDefinedContainerObject,uniqueSampleTransfersPerDefinedContainer},Total];

	totalSampleCountsPerDefinedContainer = mySemiPooledInputs/.totalSampleCountsPerDefinedContainerRules;

	(* Wrap a list around any single sample inputs except single plate objects to convert flat input into a nested list *)
	(* Leave any non-list plate objects as single inputs because wrapping list around a single plate object signals pooling of all samples in plate.
	In the case that a user wants to run every sample in a plate independently, the plate object is supplied as a single input.*)
	listedInputs=MapThread[
		If[
			MatchQ[#1, ObjectP[Object[Container,Plate]]] || MatchQ[#2, GreaterP[1]],
			#1, ToList[#1]
		]&,
		{mySemiPooledInputs,totalSampleCountsPerDefinedContainer}
	];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	{listedInputsNoTemporalLinks, listedOptions}=removeLinks[listedInputs, listedOptions];

	(* First, simulate our sample preparation and check if MissingDefineNames, InvalidInput, InvalidOption error messages are thrown.
	If none of these messages are thrown, returns mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation*)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentThermalShift,
			listedInputsNoTemporalLinks,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given MissingDefineNames, InvalidInput, InvalidOption error messages, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* For each group, map containerToSampleOptions over each sample or simulated sample group to get the object samples from the contents of the container *)
	(* ignoring the options, since we will use the ones from from ExpandIndexMatchedInputs *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=pooledContainerToSampleOptions[
			ExperimentThermalShift,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::EmptyContainers. *)
		{
			Check[
				{containerToSampleOutput,containerToSampleSimulation}=pooledContainerToSampleOptions[
					ExperimentThermalShift,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output-> {Result,Simulation},
					Simulation -> updatedSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			],
			{}
		}
	];

	(* If we were given an empty container,return early. *)
	If[ContainsAny[containerToSampleResult,{$Failed}],

		(* if containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* take the samples from the mapped containerToSampleOptions, and the options from expandedOptions *)
		(* this way we'll end up index matching each grouping to an option *)
		ExperimentThermalShiftCore[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* This is the core function taking only clean pooled lists of samples in the form -> {{s1},{s2},{s3,s4},{s5,s6,s7}} *)
ExperimentThermalShiftCore[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:OptionsPattern[ExperimentThermalShift]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,
		upload,confirm,canaryBranch,fastTrack,parentProtocol,cache,preferredContainers,containerOutModels,specifiedAliquotContainerObjects,specifiedAliquotContainerModels,instrumentModels,userInstrumentOption,
		specifiedInstrumentModels,specifiedInstrumentObjects,sampleList,passiveReferenceObject,passiveReferenceModel,possibleDetectionReagentModels,detectionReagentObjects,detectionReagentModels,sampleObjectPacketFields,containerObjectFields,
		sampleIdentityModelPacketFields,sampleContainerPacketFields,containerObjectPacketFields,containerModelPacketFields,instrumentObjectPacketFields,instrumentModelPacketFields,fluorescentDyeIdentityModelPacketFields,
		fluorescentDyeObjectPacketFields,fluorescentDyeModelPacketFields,resourcePacketTests,resourcePackets,specifiedContainerOutObj,
		specifiedContainerOutModel,instrumentModelFields,instrumentObjectFields,updatedSimulation,
		listedPooledSamples,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	{listedPooledSamples, listedOptions}=removeLinks[ToList[myPooledSamples], ToList[myOptions]];
	(* Simulate our sample preparation and check if any prepared samples are not defined using the PreparatoryUnitOperations option. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentThermalShift,
			listedPooledSamples,
			listedOptions
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentThermalShift,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentThermalShift,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed, Simulation->updatedSimulation];
 
	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentThermalShift,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentThermalShift,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
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

	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentThermalShift,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentThermalShift,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],{}}
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
	(* get assorted hidden options *)
	{upload,confirm,canaryBranch,fastTrack,parentProtocol,cache} = Lookup[inheritedOptions,{Upload,Confirm,CanaryBranch,FastTrack,ParentProtocol,Cache}];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentThermalShift,{mySamplesWithPreparedSamples},inheritedOptions]];

	(*== DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION ==*)

	(* all possible containers that the resolver might use; these are qPCR plates, Uncle capillary strips, aliquot plates, and also ContainerOut options *)
	preferredContainers=DeleteDuplicates[
		Flatten[{
			PreferredContainer[All,Type->All],
			PreferredContainer[All,Sterile->True,Type->All],
			PreferredContainer[All,LightSensitive->True,Type->All],
			Search[Model[Container, Plate], NumberOfWells >= 48 && Treatment === NonTreated && Type != Model[Container, Plate, Filter] && (ContainerMaterials === Polypropylene || ContainerMaterials === Polystyrene) && Footprint != Null && Deprecated != True],
			Search[Model[Container,Plate,CapillaryStrip], Deprecated != True]
		}]
	];
	(* any container out the user provided (in case it's not ont he PreferredContainer list) *)
	containerOutModels=Cases[Flatten[ToList[Lookup[safeOps, ContainerOut]]],ObjectP[Model[Container]];

	(* any aliquot container the user provided (in case it's not on the PreferredContainer list) *)
	specifiedAliquotContainerObjects=Cases[ToList[Lookup[safeOps, AliquotContainer]],ObjectP[Object[Container]]]];
	specifiedAliquotContainerModels=Cases[Flatten[ToList[Lookup[safeOps, AliquotContainer]]],ObjectP[Model[Container]]];

	(* all instrument models capable of doing ThermalShift *)
	instrumentModels= {
		Model[Instrument, Thermocycler, "ViiA 7"],
		Model[Instrument, Thermocycler, "QuantStudio 7 Flex"],
		Model[Instrument, MultimodeSpectrophotometer,"Uncle"]
	};

	(* handle any instrument or model instrument provide by the user *)
	userInstrumentOption=Lookup[safeOps,Instrument];

	{specifiedInstrumentModels,specifiedInstrumentObjects}= Switch[userInstrumentOption,
		Automatic,{{},{}},
		ObjectP[Model[Instrument]],{{userInstrumentOption},{}},
		ObjectP[Object[Instrument]],{{},{userInstrumentOption}}
	];

	(* to make the download easier, flatten all the samples *)
	sampleList=Flatten[mySamplesWithPreparedSamples];

	(*Passive reference objects*)
	{passiveReferenceObject,passiveReferenceModel} = Switch[{Lookup[safeOps,PassiveReference]},
		{ObjectP[Object[Sample]]},{{Lookup[safeOps,PassiveReference]},{}},
		{ObjectP[Model[Sample]]},{{},{Lookup[safeOps,PassiveReference]}},
		{Null}, {{},{}}
	];

	(*all detection reagent objects*)
	possibleDetectionReagentModels =Search[Model[Sample], Composition[[2]][Fluorescent] == {___, True, ___} && Length[Composition] == 2 && Deprecated != True];
	{detectionReagentObjects,detectionReagentModels} = {
		Cases[Lookup[safeOps,DetectionReagent],ObjectP[Object[Sample]]],
		Cases[Lookup[safeOps,DetectionReagent],ObjectP[Model[Sample]]]
	};

	(*Container Out objects*)
	{specifiedContainerOutObj,specifiedContainerOutModel} = Switch[Lookup[safeOps,ContainerOut],
		Null,{{},{}},
		ObjectP[Object[Container]], {{Lookup[safeOps,ContainerOut]},{}},
		ObjectP[Model[Container]], {{},{Lookup[safeOps,ContainerOut]}}
	];

	(* Create the Packet Download syntax for our sample Objects and Identity Models. *)
	sampleObjectPacketFields=Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence]];
	sampleIdentityModelPacketFields=Packet[Field[Composition[[All,2]]][{Type, MolecularWeight, IncompatibleMaterials}]];

	(*Create the Packet Download syntax for all relevant container objects and models*)
	sampleContainerPacketFields = Packet[Container[Sequence @@ containerObjectFields]];
	containerObjectPacketFields=Packet @@ containerObjectFields;
	containerModelPacketFields=Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];

	containerObjectFields = SamplePreparationCacheFields[Object[Container]];

	(*Create the Packet Download syntax for all relevant instruments*)
	instrumentModelFields={Name,Mode,Objects,EmissionFilters,ExcitationFilters,FluorescenceWavelengths,StaticLightScatteringWavelengths,
		MaxTemperatureRamp,MinTemperatureRamp,MinTemperature,MaxTemperature,CCDArraySaturationIntensityData,WettedMaterials,
		Positions,EnvironmentalControls,MaxRotationRate,MinRotationRate,InternalDimensions,Model};
	instrumentObjectFields={Name,Model,Mode,MaxTemperatureRamp,MinTemperatureRamp,WettedMaterials,Positions,
		EnvironmentalControls,MaxRotationRate,MinRotationRate,MinTemperature,MaxTemperature,InternalDimensions};
	instrumentObjectPacketFields=Packet@@instrumentObjectFields;
	instrumentModelPacketFields=Packet@@instrumentModelFields;

	(*Create the Packet Download syntax for all relevant passive reference dyes and detection reagents*)
	fluorescentDyeIdentityModelPacketFields=Packet[Field[Composition[[All,2]]][{Name,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums,FluorescenceLabelingTarget}]];
	fluorescentDyeObjectPacketFields={Packet[Composition],Packet[Model[{ConcentratedBufferDilutionFactor}]]};
	fluorescentDyeModelPacketFields=Packet[ConcentratedBufferDilutionFactor,Composition];

	cacheBall = FlattenCachePackets[
		Quiet[
			Download[
				{
					preferredContainers,
					containerOutModels,
					specifiedAliquotContainerObjects,
					specifiedAliquotContainerModels,
					instrumentModels,
					(*instrumentModels,*)
					specifiedInstrumentObjects,
					specifiedInstrumentObjects,
					specifiedInstrumentModels,
					sampleList,
					sampleList,
					(*sampleList,*)
					passiveReferenceObject,
					passiveReferenceObject,
					passiveReferenceModel,
					passiveReferenceModel,
					detectionReagentObjects,
					detectionReagentObjects,
					detectionReagentModels,
					detectionReagentModels,
					possibleDetectionReagentModels,
					possibleDetectionReagentModels,
					specifiedContainerOutObj,
					specifiedContainerOutModel
				},
				{
					(*preferred container model packets*)
					{containerModelPacketFields},

					(*container out model packets*)
					{containerModelPacketFields},

					(*specified aliquot container object packets*)
					{containerObjectPacketFields},

					(*specified aliquot container model packets*)
					{sampleContainerPacketFields},

					(*instrument model packets*)
					{instrumentModelPacketFields},

					(*instrument object packets*)
					(*{Packet[Objects[instrumentObjectFields]]},*)

					(*user specified instrument object packets*)
					{instrumentObjectPacketFields},

					(*user specified instrument object model packets*)
					{Packet[Model[instrumentModelFields]]},

					(*user specified instrument model packets*)
					{instrumentModelPacketFields},

					(*sample object packets*)
					{sampleObjectPacketFields},

					(*sample identity model packets*)
					{sampleIdentityModelPacketFields},

					(*sample container packets*)
					(*	{sampleContainerPacketFields},*)

					(*passive reference object packet*)
					fluorescentDyeObjectPacketFields,

					(*passive reference object identity model packet*)
					{fluorescentDyeIdentityModelPacketFields},

					(*passive reference model packet*)
					{fluorescentDyeModelPacketFields},

					(*passive reference model identity model packet*)
					{fluorescentDyeIdentityModelPacketFields},

					(*detection reagent objects packet*)
					fluorescentDyeObjectPacketFields,

					(*detection reagent objects identity model packet*)
					{fluorescentDyeIdentityModelPacketFields},

					(*detection reagent models packet*)
					{fluorescentDyeModelPacketFields},

					(*detection reagent models identity model packet*)
					{fluorescentDyeIdentityModelPacketFields},

					(*possible detection reagent models packet*)
					{fluorescentDyeModelPacketFields},

					(*possible detection reagent models identity model packet*)
					{fluorescentDyeIdentityModelPacketFields},

					(*Container out object packet*)
					{containerObjectPacketFields},

					(*Container out model packet*)
					{containerModelPacketFields}
				},
				Cache->cache,
				Simulation -> updatedSimulation,
				Date->Now
			],
			{Download::FieldDoesntExist,Download::NotLinkField}
		]
	];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(*If we are gathering tests silence any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentThermalShiftOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Because messages are silenced, we have to run the tests to see if we encountered a failure. If no failures were encountered return the result from above*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* If we are not gathering tests simply check for Error::InvalidInput and Error::InvalidOption. If any of these messages were generated return failed.*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentThermalShiftOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];
	
	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentThermalShift,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentThermalShift,collapsedResolvedOptions],
			Preview->Null
		}]
	];
	
	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		experimentThermalShiftResourcePackets[ToList[mySamplesWithPreparedSamples],listedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{experimentThermalShiftResourcePackets[ToList[mySamplesWithPreparedSamples],listedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentThermalShift,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->upload,
			Confirm->confirm,
			CanaryBranch->canaryBranch,
			ParentProtocol->parentProtocol,
			Priority->Lookup[inheritedOptions,Priority],
			StartDate->Lookup[inheritedOptions,StartDate],
			HoldOrder->Lookup[inheritedOptions,HoldOrder],
			QueuePosition->Lookup[inheritedOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,ThermalShift],
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentThermalShift,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ========== resolveExperimentThermalShiftOptions Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)

DefineOptions[
	resolveExperimentThermalShiftOptions,
	Options:>{SimulationOption,HelperOutputOption,CacheOption}
];

resolveExperimentThermalShiftOptions[myPooledSamples:ListableP[{ObjectP[Object[Sample]]...}],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentThermalShiftOptions]]:=Module[
	{outputSpecification,output,gatherTests,cache,samplePrepOptions,thermalShiftOptions,simulatedSamples,resolvedSamplePrepOptions,samplePrepTests,
		(*Download Variables*)
		messages,flatSimulatedSamples,poolingLengths,assayContainers,dilutionContainerObjects,dilutionContainerModels,preferredDilutionContainerModel,
		allDilutionContainerModels,instrumentModels,passiveReferenceObject,passiveReferenceModel,possibleDetectionReagentModels,
		detectionReagentObjects,detectionReagentModels,instrumentOption,specifiedInstrumentModels,specifiedInstrumentObjects,
		sampleObjectPacketFields,sampleAnalytePacketFields,sampleIdentityModelPacketFields,sampleContainerPacketFields,
		containerModelPacketFields,containerObjectPacketFields,containerObjectFields,instrumentObjectPacketFields,instrumentModelPacketFields,
		fluorescentDyeIdentityModelPacketFields,fluorescentDyeObjectPacketFields,fluorescentDyeModelPacketFields,
		samplePackets,sampleAnalytePackets,sampleIdentityModelPackets,sampleContainerModelPackets,assayContainerPackets,dilutionContainerObjectPackets,
		dilutionContainerModelPackets,specifiedInstrumentObjectPackets,specifiedInstrumentModelPackets,thermalShiftInstrumentModelPackets,
		passiveRefObjCompositionPackets,passiveRefObjPackets,passiveRefObjIdentityModelPackets,passiveRefModelPackets,
		passiveRefIdentityModelPackets,detectionReagentObjCompositionPackets,detectionReagentObjPackets,detectionReagentObjIdentityModelPackets,
		detectionReagentModelPackets,detectionReagentIdentityModelPackets,possibleDetectionReagentModelPackets,possibleDetectionReagentIdentityModelPackets,
		downloadedPackets,specifiedInstrumentObjModelPackets,aliquotBools,aliquotContainers,pooledSamplePackets,resolvedInstrumentModel,
		specifiedContainerOutObj, specifiedContainerOutModel, containerOutObjectPackets, containerOutModelPackets,
		(*Input Validation Checks*)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,nucleotideTypesP,proteinTypesP,analyteTypesP,resolvedAnalytePackets,
		analyteTypeResolver,resolvedAnalyteType,tooManyTypesTest, nonLiquidSamplePackets, nonLiquidSampleInvalidInputs, nonLiquidSampleTest,
		(*Option Prescision Check*)
		roundedThermalShiftOptions,precisionTests,
		(*Conflicting Options Check*)
		engineQ,preferredInstrumentModel,specifiedInstrumentModel,preferredInstrumentCheck,preferredInstrumentTest,rampingOption,
		linearOptions,stepOptions,suppliedStepOptions,suppliedNullLinearOptions,suppliedLinearOptions,suppliedNullStepOptions,
		invalidTemperatureRampOptions,invalidRampOptions,invalidRampOptionsKeys,invalidNullRampOptionsKeys,invalidNullRampOptions,invalidTemperatureRampTest,mapThreadFriendlyOptions,
		invalidMixOptionsMapThread,filteredInvalidMixList,invalidPooledMixSamples,invalidPoolMix,invalidPooledMixOptions,inversePoolMix,
		invalidPooledMixTest,invalidIncubateOptionsMapThread,filteredInvalidIncubateList,invalidPooledIncubateSamples,invalidPoolIncubate,
		invalidPooledIncubateOptions,inversePoolIncubate,invalidPooledIncubateTest,incompatibleMixOptionsMapThread,filteredIncompatibleMixList,
		incompatibleMixSamples,incompatiblePooledMixOptionsTest,validNameTest,nameInvalidOption,validNameQ,suppliedName,
		dynamicLightScatteringOption,dynamicLightScatteringMeasurementsOption,
		numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringAcquisitionTimeOption,
		automaticDynamicLightScatteringLaserSettingsOption,dynamicLightScatteringLaserPowerOption,dynamicLightScatteringCapillaryLoadingOption,
		dynamicLightScatteringDiodeAttenuationOption,invalidConflictingDLSOptionNames,invalidConflictingDLSOptionValues,
		conflictingDLSOptionTests,invalidConflictingNullDLSOptionNames,invalidConflictingNullDLSOptionValues,
		conflictingNullDLSOptionTests,

		incompatibleStorageOptions,incompatibleStorageOptionsTest,invalidEmissionsOptionsMapThread,filteredInvalidEmissionOptions,
		invalidEmissionSamples,invalidEmissionOptions,invalidEmissionTest,incompatibleEmissionOptionsMapThread,
		filteredIncompatibleEmissionList,incompatibleEmissionSamples,invalidEmissionRangeTest,passiveReferenceOption,
		passiveReferenceVolumeOption,invalidPassiveReferenceOptions,invalidPassiveReferenceOptionsKeys,invalidPassiveRefTest,incompatibleDetectionReagentOptionsMapThread,
		filteredIncompatibleReagentList,incompatibleReagentSamples,invalidReagentTest,tooManyDilutionCurveOptionsMapThread,
		filteredDilutionsList,tooManyDilutionSamples,tooManyDilutionsTest,incompatibleDilutionCurveOptionsMapThread,
		filteredIncompatibleDilutionsList,incompatibleDilutionOptions,invalidDilutionTest,minTemp,maxTemp,
		invalidTempRange,invalidRampTest,resolvedInstrument,resolvedInstrumentPacket,reactionVolumeOption,reactionVolume,passiveReferenceVolume,incompatibleMixOptionKeys,
		incompatibleStorageOptionKeys,incompatibleEmissionRangeKeys,incompatibleReagentOptionKeys,invalidPassiveRefVolTest,tooManyDilutionOptionKeys,invalidTempRangeOptions,
		containerOption,storageOption,flatDilutionsList,singularOptionPatterns,expandedDilutionOptions,filteredOptions,poolExpandedDilutionOptions,mapThreadFriendlyOptionsWithoutDilutions,
		flatIncompatibleDilutionsList,optimizeSLSTest, invalidSLSOptimization, invalidSLSOptimizationMapThread,invalidThermocyclerModeOption, specifiedThermocyclerMode,thermocyclerModeTest,qPCRThermocyclerInstrumentCheck,

		(*Resolve MapThread Options*)
		targetContainers,sampleVolumes,buffers,bufferVolumes,detectionReagents,detectionReagentVolumes,invalidDetectionReagentVolume,aliquotVol,
		diluents,dilutionContainers,dilutionMixVolumes,dilutionMixNumbers,dilutionCurves,serialDilutionCurves,invalidDilutionVolSamples,invalidDilutionMixSamples,
		pooledMixes,pooledMixTypes,pooledMixNumberOfMixes,pooledMixVolumes,pooledIncubations,pooledIncubationTimes,pooledIncubationTemperatures,pooledAnnealingTimes,
		fluorescenceFilters,slsFilters,emissionParameters,excitationWavelengths,slsExcitationWavelengths,requiredWells,
		invalidPoolMixVolumes,invalidDetectionReagentVolumes,invalidSampleVolumes,invalidBufferVolumes,invalidDilutionMixVols,invalidDilutionContainers,invalidThermocyclerOptions,invalidMMSpecOptions,invalidEmissionRanges,invalidExcitationWavelengths,invalidEmissionWavelengths,incompatibleExcitationWavelengths,
		incompatibleEmissionDetectors,requiredVolumes,dilutionMixRates,minEmWavelengths,maxEmWavelengths,emWavelengths,analytes,composition,invalidDilutionVolumes,
		resolvedLaserOptiWavelengths,resolvedLaserOptiIntensities,invalidLaserOptiOptions,unusedOptimizationOptions,resolvedDilutionStorageConditions,
		(*Resolve Experiment Options*)
		rampOrder,totalReadTime,equilibrationTime,unresolvedCycleNum,unresolvedRampType,unresolvedRampRate,unresolvedRampResolution,unresolvedStepNum,unresolvedStepHold,
		defaultCycleNum,instrumentMaxRate,stepNum,defaultRampType, defaultRampRate, defaultStepNum, defaultStepHold,resolvedCycleNum,resolvedRampType,resolvedRampRate,resolvedStepNum,resolvedStepHold,
		maxRes,resolvedTempResolution,resolvedDynamicLightScatteringMeasurements,startTemp,endTemp,resolvedDynamicLightScatteringMeasurementTemperatures,
		resolvedNumberOfDynamicLightScatteringAcquisitions,resolvedDynamicLightScatteringAcquisitionTime,
		resolvedAutomaticDynamicLightScatteringLaserSettings,resolvedDynamicLightScatteringLaserPower,resolvedDynamicLightScatteringDiodeAttenuation,
		resolvedDynamicLightScatteringCapillaryLoading,conflictingDLSInstrumentTests,invalidAutomaticDLSLaserOptionNames,
		invalidAutomaticDLSLaserOptionValues,conflictingAutomaticDLSLaserTests,dynamicLightScatteringTemperatureOption,


		invalidInstrumentOption,invalidResolution,instrumentRateRange,instrumentTempRange,invalidSampleNumber,maxSampleNum,resolveSamplePrepOptionsWithoutAliquot,
		(*Error Checking*)
		sampleOptionList,invalidDetectionReagentOption,invalidEmissionDetectionOptions,invalidSampleOptionList,invalidPoolMixVolumeTest,invalidDetectionReagentVolumesTest,invalidSampleVolumesTest,invalidBufferVolumesTest,invalidRequiredSamplesVolumesTest,invalidDilutionMixVolumesTest,invalidDilutionContainersTest,invalidThermocyclerOptionsTest,
		invalidResolvedEmissionRangeTest,invalidMMSpecOptionsTest,invalidExWavelengthsTest,invalidEmWavelengthsTest,incompatibleExWavelengthsTest,incompatibleEmOptionsTest,invalidTempResTest,incompatibleTempResTest,invalidRampRateTest,invalidMinTempTest,
		invalidMaxTempTest,invalidSampleNumberTest,invalidReactionVolume,compatibleVolume,invalidReactionVolumeTest,invalidInputs,invalidOptions,resolvedAliquotOptions,resolvedAliquotOptionsTests,resolvedPostProcessingOptions,resolvedOptions,
		invalidPoolMixVolOptions,invalidSampleVolOption,invalidBufferVolOption,invalidDilutionVolOption,invalidDilutionMixVolOption,
		invalidDilutionContainerOption,invalidThermocyclerOption,invalidThermocyclerEmissionsOption,invalidMultiModeSpecOption,invalidCycleNumBoolean,invalidCycleNumOption,invalidCycleNumTest,
		invalidExcitationOption,incompatibleExcitationOption,incompatibleEmissionOption,incompatibleResolutionOption, invalidRecoupSampleTest,invalidContainerOutBoolean,invalidContainerOutOption,
		invalidRampRateOption,invalidMinTempOption,invalidMaxTempOption,invalidSampleNumberOption,invalidReactionVolOption,invalidInstrumentBoolean,allTests,
		bufferVolumesWithNulls, detectionReagentVolumesWithNulls, passiveReferenceVolumeWithNulls,invalidLaserOptiBoolean, invalidLaserOptiBooleanTest,
		invalidLaserOptiOptionsTest, unsuedOptimizationOptionSamples, unusedLaserOptiOptionsTest,invalidPassRefVol,invalidPassRefOption,invalidSampleReactionVolumes,
		invalidSampleReactionVolOption,invalidSampleReactionVolumesTest,invalidPooledDilutions,invalidPooledDilutionOptions, invalidPooledDilutionsTest,containerOutCapacity,invalidContainerOutCapacity,invalidContainerOutCapacityTest,invalidContainerOutCapacityOption,
		dilutionStorageRules, mergedStorageRules,invalidDilutionStorageCondition,invalidinvalidDilutionStorageConditionTest,simulation,updatedSimulation,
		invalidConflictingDLSInstrumentOptions,invalidDLSTemperature,invalidDLSTemperatureOptions,invalidDLSTempTest,resultRule,testsRule,


		invalidDilutionStorageConditionOption, specifiedNumberOfReplicates, resolvedNumberOfReplicates
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our thermal shift options from our Sample Prep options. *)
	{samplePrepOptions,thermalShiftOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentThermalShift,myPooledSamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentThermalShift,myPooledSamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(*Since pooled samples are designated by wrapping in a list, flatten list so all samples can be easily used.*)
	flatSimulatedSamples=Flatten[simulatedSamples];

	(*Get the number of samples combined in each pooledSample*)
	poolingLengths=Length/@simulatedSamples;

	(*-- DOWNLOAD CALL --*)
	(* all possible assay containers*)
	assayContainers= DeleteDuplicates[
		Join[
			PreferredContainer[All, Type -> Plate],
			Search[Model[Container,Plate,CapillaryStrip], Deprecated != True],
			Search[Model[Container, Plate], NumberOfWells === 384 && Deprecated != True]
		]
	];

	(* dilution container objects*)
	dilutionContainerModels = Cases[Flatten[Lookup[thermalShiftOptions,{DilutionContainer}]],ObjectP[Model[Container]]];
	dilutionContainerObjects = Cases[Flatten[Lookup[thermalShiftOptions,{DilutionContainer}]],ObjectP[Object[Container]]];

	preferredDilutionContainerModel =PreferredContainer[2*Milliliter, Type -> Plate];
	allDilutionContainerModels = Union[dilutionContainerModels,{preferredDilutionContainerModel}];

	(* all instrument models capable of doing ThermalShift *)
	instrumentModels= {
		Model[Instrument, Thermocycler, "ViiA 7"],
		Model[Instrument, Thermocycler, "QuantStudio 7 Flex"],
		Model[Instrument, MultimodeSpectrophotometer,"Uncle"]
	};

	(*Passive reference objects*)
	{passiveReferenceObject,passiveReferenceModel} = Switch[{Lookup[thermalShiftOptions,PassiveReference]},
		{ObjectP[Object[Sample]]},{{Lookup[thermalShiftOptions,PassiveReference]},{}},
		{ObjectP[Model[Sample]]},{{},{Lookup[thermalShiftOptions,PassiveReference]}},
		{Null}, {{},{}}
	];

	(*all detection reagent objects*)
	possibleDetectionReagentModels =Search[Model[Sample,StockSolution], Composition[[2]][Fluorescent] == {___, True, ___} && Deprecated != True];
	{detectionReagentObjects,detectionReagentModels} = {
		Cases[Lookup[thermalShiftOptions,DetectionReagent],ObjectP[Object[Sample]]],
		Cases[Lookup[thermalShiftOptions,DetectionReagent],ObjectP[Model[Sample]]]
	};

	(* Find instrument option value *)
	instrumentOption=Lookup[thermalShiftOptions,Instrument];

	{specifiedInstrumentModels,specifiedInstrumentObjects}= Switch[instrumentOption,
		Automatic,{{},{}},
		ObjectP[Model[Instrument]],{{instrumentOption},{}},
		ObjectP[Object[Instrument]],{{},{instrumentOption}}
	];

	(*Container Out objects*)
	{specifiedContainerOutObj,specifiedContainerOutModel} = Switch[Lookup[thermalShiftOptions,ContainerOut],
		Null,{{},{}},
		ObjectP[Object[Container]], {{Lookup[thermalShiftOptions,ContainerOut]},{}},
		ObjectP[Model[Container]], {{},{Lookup[thermalShiftOptions,ContainerOut]}}
	];

	(* Create the Packet Download syntax for our sample Objects, Identity Models, and sample containers. *)
	sampleObjectPacketFields=Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence]];
	sampleAnalytePacketFields=Packet[Analytes[{Type, MolecularWeight, IncompatibleMaterials}]];
	sampleIdentityModelPacketFields=Packet[Field[Composition[[All,2]]][{Type, MolecularWeight, IncompatibleMaterials}]];
	sampleContainerPacketFields = Packet[Container[Sequence @@ containerObjectFields]];

	(*Create the Packet Download syntax for all relevant assay container models*)
	containerObjectPacketFields=Packet @@ containerObjectFields;
	containerModelPacketFields=Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];

	containerObjectFields = SamplePreparationCacheFields[Object[Container]];

	(*Create the Packet Download syntax for all relevant instruments*)
	instrumentObjectPacketFields=Packet[Name,Model,Mode];
	instrumentModelPacketFields=Packet[Name,Mode,Objects,EmissionFilters,ExcitationFilters,FluorescenceWavelengths,StaticLightScatteringWavelengths,MaxTemperatureRamp,MinTemperatureRamp,MinTemperature,MaxTemperature];

	(*Create the Packet Download syntax for all relevant passive reference dyes and detection reagents*)
	fluorescentDyeIdentityModelPacketFields=Packet[Field[Composition[[All,2]]][{Name,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums,FluorescenceLabelingTarget}]];
	fluorescentDyeObjectPacketFields={Packet[Composition],Packet[Model[ConcentratedBufferDilutionFactor]]};
	fluorescentDyeModelPacketFields=Packet[ConcentratedBufferDilutionFactor,Composition];

	downloadedPackets = Quiet[
		Download[
			{
				flatSimulatedSamples,
				flatSimulatedSamples,
				flatSimulatedSamples,
				(*flatSimulatedSamples,*)
				assayContainers,
				dilutionContainerObjects,
				allDilutionContainerModels,
				specifiedInstrumentObjects,
				specifiedInstrumentObjects,
				specifiedInstrumentModels,
				instrumentModels,
				passiveReferenceObject,
				passiveReferenceObject,
				passiveReferenceObject,
				passiveReferenceModel,
				passiveReferenceModel,
				detectionReagentObjects,
				detectionReagentObjects,
				detectionReagentObjects,
				detectionReagentModels,
				detectionReagentModels,
				possibleDetectionReagentModels,
				possibleDetectionReagentModels,
				specifiedContainerOutObj,
				specifiedContainerOutModel
			},
			{
				(*sample object packets*)
				{sampleObjectPacketFields},

				(*sample analyte packets*)
				{sampleAnalytePacketFields},

				(*sample identity model packets*)
				{sampleIdentityModelPacketFields},

				(*(*sample container packets*)
				{sampleContainerPacketFields},*)

				(*assay container packets*)
				{containerModelPacketFields},

				(*dilution container object packets*)
				{containerObjectPacketFields},

				(*dilution container model packets*)
				{containerModelPacketFields},

				(*user specified instrument object packets*)
				{instrumentObjectPacketFields},

				(*user specified instrument object model packets*)
				{instrumentObjectPacketFields},

				(*user specified instrument model packets*)
				{instrumentModelPacketFields},

				(*thermal shift allowed instrument packets*)
				{instrumentModelPacketFields},

				(*passive reference object composition packet*)
				{First@fluorescentDyeObjectPacketFields},

				(*passive reference object packet*)
				{Last@fluorescentDyeObjectPacketFields},

				(*passive reference object identity model packet*)
				{fluorescentDyeIdentityModelPacketFields},

				(*passive reference model packet*)
				{fluorescentDyeModelPacketFields},

				(*passive reference model identity model packet*)
				{fluorescentDyeIdentityModelPacketFields},

				(*detection reagent objects composition packet*)
				{First@fluorescentDyeObjectPacketFields},

				(*detection reagent objects packet*)
				{Last@fluorescentDyeObjectPacketFields},

				(*detection reagent objects identity model packet*)
				{fluorescentDyeIdentityModelPacketFields},

				(*detection reagent models packet*)
				{fluorescentDyeModelPacketFields},

				(*detection reagent models identity model packet*)
				{fluorescentDyeIdentityModelPacketFields},

				(*possible detection reagent models packet*)
				{fluorescentDyeModelPacketFields},

				(*possible detection reagent models identity model packet*)
				{fluorescentDyeIdentityModelPacketFields},

				(*Container out object packet*)
				{containerObjectPacketFields},

				(*Container out model packet*)
				{containerModelPacketFields}
			},
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Deconstruct the downloaded packets *)
	{samplePackets,
		sampleAnalytePackets,
		sampleIdentityModelPackets,(*
		sampleContainerModelPackets,*)
		assayContainerPackets,
		dilutionContainerObjectPackets,
		dilutionContainerModelPackets,
		specifiedInstrumentObjectPackets,
		specifiedInstrumentObjModelPackets,
		specifiedInstrumentModelPackets,
		thermalShiftInstrumentModelPackets,
		passiveRefObjCompositionPackets,
		passiveRefObjPackets,
		passiveRefObjIdentityModelPackets,
		passiveRefModelPackets,
		passiveRefIdentityModelPackets,
		detectionReagentObjCompositionPackets,
		detectionReagentObjPackets,
		detectionReagentObjIdentityModelPackets,
		detectionReagentModelPackets,
		detectionReagentIdentityModelPackets,
		possibleDetectionReagentModelPackets,
		possibleDetectionReagentIdentityModelPackets,
		containerOutObjectPackets,
		containerOutModelPackets
	} = downloadedPackets;

	pooledSamplePackets = TakeList[Flatten@samplePackets,poolingLengths];

	(*-- INPUT VALIDATION CHECKS --*)
	(*Check if we are executing in Engine, if so we don't want to throw warnings*)
	engineQ = MatchQ[$ECLApplication,Engine];

	(*1. DISCARDED SAMPLES ARE NOT OKAY*)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]>0,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]<>" are not discarded:",True,False],
				Nothing
			];

			passingTest=If[Length[discardedInvalidInputs]==0,
				Test["Our input samples "<>ObjectToString[Complement[myPooledSamples,discardedInvalidInputs],Simulation->updatedSimulation]<>" are not discarded:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		{}
	];

	(*2. MORE THAN ONE TYPE OF ANALYTE IS NOT RECOMMENDED*)

	(*Resolve Analytes*)

	(*Define acceptable analyte patterns*) (*TODO this may need to be updated when/if any additional identity model types are added*)
	nucleotideTypesP = Alternatives[Model[Molecule, Oligomer], Model[Molecule, cDNA], Model[Molecule, Transcript]];
	proteinTypesP = Alternatives[Model[Molecule, Protein, Antibody], Model[Molecule, Protein]];
	analyteTypesP = Join[nucleotideTypesP,proteinTypesP];

	(*Resolve analytes by first determining if analytes are user defined*)
	resolvedAnalytePackets = If[
		!MatchQ[Flatten@sampleAnalytePackets,{}],

		(*If analytes are user defined, return user defined anayltes*)
		Flatten@sampleAnalytePackets,

		(*If no analytes are defined resolve compatible analytes from identity model packets.*)
		Select[Cases[Flatten@sampleIdentityModelPackets,Except[NullP]], MatchQ[Lookup[#,Type],analyteTypesP]&]
	];

	(*Resolve the major analyte type for use later in the resolver*)

	(*Helper function to resolve major analyte type*)
	analyteTypeResolver[resolvedPackets:Alternatives[{PacketP[]..},{}]]:= If[
		MemberQ[Lookup[thermalShiftOptions,AnalyteType],Automatic],

		(*If analytes were resolved or user provided, resolve the analyte type*)
		If[!MatchQ[resolvedPackets,{}],
			Module[{analyteUniqueTypes,incompatibleAnalyteTypes,filteredAnalyteTypes,majorAnalyteType},
			(*Find the unique analyte types*)
			analyteUniqueTypes = Union[Lookup[resolvedPackets,Type]];

			(*If any of the unique analyte types are not recommended for this assay, filter them out and give the user a warning.*)
			incompatibleAnalyteTypes = Select[analyteUniqueTypes, MatchQ[#, Except[analyteTypesP]]&];
			filteredAnalyteTypes = Complement[analyteUniqueTypes,incompatibleAnalyteTypes];
			If[Length[incompatibleAnalyteTypes]>0&&!engineQ, Message[Warning::IncompatibleAnalytes,incompatibleAnalyteTypes],Nothing];

			(*Select the most abundant type of compatible analyte*)
			majorAnalyteType = Commonest[filteredAnalyteTypes];

			Which[

					(*If majorAnalyteType list contains both a nucleotide type and protein type, default to Oligomer and give the user a warning*)
					MemberQ[majorAnalyteType,nucleotideTypesP]&&MemberQ[majorAnalyteType,proteinTypesP]&&!engineQ,
					Message[Warning::MoreThanOneTypeOfAnalyte,majorAnalyteType]; Oligomer,

					(*otherwise if majorAnalyteType list exclusively contains one or more nucleotideTypeP resolve to Oligomer*)
					MemberQ[majorAnalyteType,nucleotideTypesP]&&!MemberQ[majorAnalyteType,proteinTypesP],
					Oligomer,

					(*otherwise if majorAnalyteType list exclusively contains one or more proteinTypeP resolve to Protein*)
					MemberQ[majorAnalyteType,proteinTypesP]&&!MemberQ[majorAnalyteType,nucleotideTypesP],
					Protein,

					(*set resolvedType to Oligomer as a catch all. For example, if filteredAnalyteTypes = {} need to choose a default.*)
					True,
					Oligomer
				]
			],

			(*Otherwise if analytes could not be resolved, default to nucleotide analytes and give the user a warning*)
			If[!engineQ,Message[Warning::UnknownAnalytes]; Oligomer, Oligomer]
		],
	(*If the user specified the AnalyteType option, find the most common.*)
	(*If there is a tie default to Oligomer*)
		Module[{majorAnalyteType},
		majorAnalyteType=Commonest[Lookup[thermalShiftOptions,AnalyteType]];
		If[Length[majorAnalyteType]>1,Oligomer,First@majorAnalyteType]
		]
	];

	(*Call helper function to resolve analyte type*)
	resolvedAnalyteType = analyteTypeResolver[resolvedAnalytePackets];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	tooManyTypesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[Union[Lookup[resolvedAnalytePackets, Type]]] > 1,
								Test["Our resolved analytes are all of the same type:", True, False],
								Nothing
							];

					passingTest =
							If[Length[Union[Lookup[resolvedAnalytePackets, Type]]] == 1,
								Test["Our resolved analytes are all of the same type:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*-- OPTION PRECISION CHECKS --*)

	(*Verify that the options are not overly precise*)
	{roundedThermalShiftOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[Association[thermalShiftOptions],
			{NestedIndexMatchingIncubationTemperature, MinTemperature, MaxTemperature, TemperatureResolution,DynamicLightScatteringMeasurementTemperatures,
				ReactionVolume,PassiveReferenceVolume,NestedIndexMatchingMixVolume,SampleVolume,BufferVolume,DetectionReagentVolume,DilutionMixVolume,
				PooledIncubationTime,NestedIndexMatchingAnnealingTime,EquilibrationTime,StepHoldTime,
				TemperatureRampRate,
				ExcitationWavelength,EmissionWavelength,MinEmissionWavelength,MaxEmissionWavelength,StaticLightScatteringExcitationWavelength,
				DynamicLightScatteringAcquisitionTime,DynamicLightScatteringLaserPower,DynamicLightScatteringDiodeAttenuation
			},
			{0.1 Celsius,0.1 Celsius,0.1 Celsius,0.001 Celsius,0.1Celsius,
				0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,
				0.1 Millisecond,0.1 Millisecond,0.1 Millisecond,0.1 Millisecond,
				0.001 Celsius/Second,
				1 Nanometer,1 Nanometer,1 Nanometer,1 Nanometer,1 Nanometer,
				1*Second,1*Percent,1*Percent
			},
			Output->{Result,Tests}],
		{RoundOptionPrecision[Association[thermalShiftOptions],
			{NestedIndexMatchingIncubationTemperature, MinTemperature, MaxTemperature, TemperatureResolution,DynamicLightScatteringMeasurementTemperatures,
				ReactionVolume,PassiveReferenceVolume,NestedIndexMatchingMixVolume,SampleVolume,BufferVolume,DetectionReagentVolume,DilutionMixVolume,
				PooledIncubationTime,NestedIndexMatchingAnnealingTime,EquilibrationTime,StepHoldTime,
				TemperatureRampRate,
				ExcitationWavelength,EmissionWavelength,MinEmissionWavelength,MaxEmissionWavelength,StaticLightScatteringExcitationWavelength,
				DynamicLightScatteringAcquisitionTime,DynamicLightScatteringLaserPower,DynamicLightScatteringDiodeAttenuation
			},
			{0.1 Celsius,0.1 Celsius,0.1 Celsius,0.001 Celsius,0.1Celsius,
				0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,0.1 Microliter,
				0.1 Millisecond,0.1 Millisecond,0.1 Millisecond,0.1 Millisecond,
				0.001 Celsius/Second,
				1 Nanometer,1 Nanometer,1 Nanometer,1 Nanometer,1 Nanometer,
				1*Second,1*Percent,1*Percent
			}],Null}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*Get the mapthreadfriendly options excluding the dilution options*)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentThermalShift,roundedThermalShiftOptions];

	(*--1. Check to see if the user specified instrument is recommended for the resolvedAnalyteType--*)

	(*Find the preferred instrument model for the analyte type*)
	preferredInstrumentModel = If[MatchQ[resolvedAnalyteType,Protein],
		Cases[Lookup[Flatten@thermalShiftInstrumentModelPackets,Object],ObjectP[Model[Instrument, MultimodeSpectrophotometer]]],
		Cases[Lookup[Flatten@thermalShiftInstrumentModelPackets,Object],ObjectP[Model[Instrument, Thermocycler]]]
	];

	(*Find the instrument model of the user specified instrument.*)
	specifiedInstrumentModel=Which[
		MatchQ[Lookup[roundedThermalShiftOptions,Instrument],ObjectP[Object[Instrument]]],
		Download[Lookup[Flatten@specifiedInstrumentObjectPackets,Model],Object],

		MatchQ[Lookup[roundedThermalShiftOptions,Instrument],ObjectP[Model[Instrument]]],
		Lookup[Flatten@specifiedInstrumentModelPackets,Object],

		True,
		Automatic
	];

	(*Check if the preferred instrument model matches the user specified instrument model*)
	preferredInstrumentCheck = If[MatchQ[specifiedInstrumentModel,Automatic] || MemberQ[ToList[preferredInstrumentModel],Alternatives @@ specifiedInstrumentModel],
		True,
		False
	];

	(*Throw a warning if the preferredInstrumentCheck is False*)
	If[MatchQ[preferredInstrumentCheck,False]&&!engineQ&&!gatherTests,
		Message[Warning::RecommendedInstrument, Lookup[roundedThermalShiftOptions,Instrument], preferredInstrumentModel],
		Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	preferredInstrumentTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[preferredInstrumentCheck,False],
								Warning["Our specified instrument is the preferred instrument for the resolved analyte type "<>ToString[resolvedAnalyteType]<>" :", True, False],
								Nothing
							];
					passingTest =
							If[MatchQ[preferredInstrumentCheck,True],
								Warning["Our specified instrument is the preferred instrument for the resolved analyte type "<>ToString[resolvedAnalyteType]<>" :", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--2. Check if temperature ramping is specified. If it is, check what temperature ramp options are specified and if they are compatible with the given ramp type--*)
	(*For example, if Linear ramping is specified, check that no Step ramp options are specified (StepHoldTime, NumberOfTemperatureRampSteps)*)

	(*Find ramping option*)
	rampingOption = Lookup[roundedThermalShiftOptions,TemperatureRamping];

	(*Find linear ramp options*)
	linearOptions = FilterRules[Normal@roundedThermalShiftOptions,{TemperatureResolution}];
	stepOptions = FilterRules[Normal@roundedThermalShiftOptions,{NumberOfTemperatureRampSteps,StepHoldTime}];

	(*find any step ramp options that are user specified*)
	suppliedStepOptions = Select[stepOptions,!MatchQ[Values[#],Alternatives[Automatic,Null]]&];
	suppliedNullLinearOptions = Select[linearOptions,MatchQ[Values[#],Null]&];

	(*find any linear ramp options that are user specified*)
	suppliedLinearOptions = Select[linearOptions,!MatchQ[Values[#],Alternatives[Automatic,Null]]&];
	suppliedNullStepOptions = Select[stepOptions,MatchQ[Values[#],Null]&];

	invalidTemperatureRampOptions=Which[
		(*If ramping is Linear return supplied step options*)
		MatchQ[rampingOption,Linear], {suppliedStepOptions,suppliedNullLinearOptions},
		(*If ramping is Step return supplied linear options*)
		MatchQ[rampingOption,Step], {suppliedLinearOptions,suppliedNullStepOptions},
		(*If ramping is Automatic and both linear and step options are supplied return list of all parameters*)
		MatchQ[rampingOption,Automatic]&&Length[suppliedLinearOptions]>0&&Length[suppliedStepOptions]>0, {{suppliedLinearOptions,suppliedStepOptions},{}},
		(*If ramping is Automatic and both linear and step options are Null return list of all Null parameters*)
		MatchQ[rampingOption,Automatic]&&Length[suppliedNullLinearOptions]>0&&Length[suppliedNullStepOptions]>0, {{},{suppliedNullLinearOptions,suppliedNullStepOptions}},
		(*Catch all for all other combinations*)
		True, {{},{}}
	];

	(*Separate out invalidTemperatureRampOptions*)
	invalidRampOptions=invalidTemperatureRampOptions[[1]];
	invalidNullRampOptions=invalidTemperatureRampOptions[[2]];

	(*Get just the invalid options keys for later*)
	(*Separate out invalidTemperatureRampOptions*)
	invalidRampOptionsKeys=If[Length[invalidRampOptions]>0,Keys[invalidRampOptions],{}];
	invalidNullRampOptionsKeys=If[Length[invalidNullRampOptions]>0,Keys[invalidNullRampOptions],{}];

	(*Throw an error if invalidRampOptions is not {}*)
	Which[
		Length[invalidRampOptions]>0&&MatchQ[rampingOption,Automatic]&&messages, Message[Error::TooManyTemperatureRampOptions,Keys[First[invalidRampOptions]],Keys[Last[invalidRampOptions]]],
		Length[invalidRampOptions]>0&&messages, Message[Error::IncompatibleTemperatureRamp,rampingOption,Keys[invalidRampOptions]],
		True, Nothing
	];

	(*Throw an error if invalidNullRampOptions is not {}*)
	Which[
		Length[invalidNullRampOptions]>0&&MatchQ[rampingOption,Automatic]&&messages, Message[Error::TooFewTemperatureRampOptions,Keys[First[invalidNullRampOptions]],Keys[Last[invalidNullRampOptions]]],
		Length[invalidNullRampOptions]>0&&messages, Message[Error::InvalidNullTemperatureRampOptions,rampingOption,Keys[invalidNullRampOptions]],
		True, Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidTemperatureRampTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[Flatten@invalidTemperatureRampOptions] > 0,
								Test["Our temperature ramp options are compatible:", True, False],
								Nothing
							];
					passingTest =
							If[Length[Flatten@invalidTemperatureRampOptions] == 0,
								Test["Our temperature ramp options are compatible:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--3. Check that NestedIndexMatchingMix option and NestedIndexMatchingMixType, NestedIndexMatchingNumberOfMixes, and NestedIndexMatchingMixVolume options are compatible--*)

	(*Map over all input pools to check if pooled mix options are compatible*)
	invalidMixOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{mixOption,suppliedPoolMixOptions,suppliedNullPoolMixOptions},

				(*Find mix boolean value*)
				mixOption = Lookup[sampleOptions,NestedIndexMatchingMix];

				(*Find any pooled mix options that are user specified*)
				suppliedNullPoolMixOptions = Select[FilterRules[Normal@sampleOptions,{NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixType}], MatchQ[Values[#],Null]&];
				suppliedPoolMixOptions = Select[FilterRules[Normal@sampleOptions,{NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixType}], !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

				(*Return the appropriate invalid options given the NestedIndexMatchingMix option*)
				Which[
					(*If NestedIndexMatchingMix is True return Null pooled mix options and input sample*) (*Dont check NestedIndexMatchingMixVolume, we will check that later depending on NestedIndexMatchingMixType*)
					MatchQ[mixOption,True], {pooledSample,{NestedIndexMatchingMix->mixOption},suppliedNullPoolMixOptions},
					(*If NestedIndexMatchingMix is False or Null return non-Null pooled mix options and input sample*)
					MatchQ[mixOption,Alternatives[False,Null]],{pooledSample,{NestedIndexMatchingMix->mixOption},suppliedPoolMixOptions},
					(*Catch all for if mixOption is Automatic. We will resolve this later*)
					True, {pooledSample,mixOption,{}}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out samples with {} invalid options*)
	filteredInvalidMixList = Select[invalidMixOptionsMapThread,!MatchQ[#[[3]],{}]&];

	(*Separate out invalid mix option map thread output*)
	If[Length[filteredInvalidMixList]>0,
		{
			invalidPooledMixSamples = filteredInvalidMixList[[All, 1]];
			invalidPoolMix = filteredInvalidMixList[[All, 2]];
			invalidPooledMixOptions = filteredInvalidMixList[[All, 3]];
			inversePoolMix = Not/@invalidPoolMix
		},
		{
			invalidPooledMixSamples = {};
			invalidPoolMix = {};
			invalidPooledMixOptions = {};
			inversePoolMix ={}
		}
	];

	(*Throw an error if invalidPooledMixOptions is not {}*)
	If[
		Length[filteredInvalidMixList]>0&&messages,
		Message[Error::InvalidNestedIndexMatchingMixOptions,filteredInvalidMixList,inversePoolMix],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidPooledMixTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidPooledMixSamples] > 0,
								Test["Our user specified nested index matching mix options are compatible for the inputs "<>ObjectToString[invalidPooledMixSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing];

					passingTest =
							If[Length[invalidPooledMixSamples] == 0,
								Test["Our user specified nested index matching mix options are compatible for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}];

	(*--4. Check that NestedIndexMatchingIncubate option and PooledIncubationTime, NestedIndexMatchingIncubationTemperature, and NestedIndexMatchingAnnealingTime options are compatible--*)

	(*Map over all input pools to check if pooled incubate options are compatible*)
	invalidIncubateOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{incubateOption,incubationParameters,suppliedPoolIncubateOptions,suppliedNullPoolIncubateOptions},

				(*Find incubate boolean value*)
				incubateOption = Lookup[sampleOptions,NestedIndexMatchingIncubate];

				(*Gather other incubate options*)
				incubationParameters=FilterRules[Normal@sampleOptions,{PooledIncubationTime,NestedIndexMatchingIncubationTemperature,NestedIndexMatchingAnnealingTime}];

				(*Find any pooled incubate options that are user specified*)
				suppliedNullPoolIncubateOptions = Select[incubationParameters, MatchQ[Values[#],Null]&];
				suppliedPoolIncubateOptions = Select[incubationParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

				(*Return the appropriate invalid options given the NestedIndexMatchingIncubate option*)
				Which[
					(*If NestedIndexMatchingIncubate is True return Null pooled incubate options and input sample*)
					MatchQ[incubateOption,True], {pooledSample,NestedIndexMatchingIncubate->incubateOption,suppliedNullPoolIncubateOptions},
					(*If NestedIndexMatchingIncubate is False or Null return non-Null pooled incubate options and input sample*)
					MatchQ[incubateOption,Alternatives[False,Null]],{pooledSample,NestedIndexMatchingIncubate->incubateOption,suppliedPoolIncubateOptions},
					(*If both Null and specified options are provided return the conflicting options*)
					Length[Flatten@suppliedNullPoolIncubateOptions]>0&&Length[Flatten@suppliedPoolIncubateOptions]>0, {pooledSample,NestedIndexMatchingIncubate->incubateOption,Join[suppliedNullPoolIncubateOptions,suppliedPoolIncubateOptions]},
					(*Catch all for if incubateOption is Automatic. We will resolve this later.*)
					True, {pooledSample,NestedIndexMatchingIncubate->incubateOption,{}}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out samples with {} invalid options*)
	filteredInvalidIncubateList = Select[invalidIncubateOptionsMapThread,!MatchQ[#[[3]],{}]&];

	(*Separate out invalid incubate options map thread output*)
	If[Length[filteredInvalidIncubateList]>0,
		{
			invalidPooledIncubateSamples = filteredInvalidIncubateList[[All, 1]];
			invalidPoolIncubate = filteredInvalidIncubateList[[All, 2]];
			invalidPooledIncubateOptions = filteredInvalidIncubateList[[All, 3]];
			inversePoolIncubate = Not/@invalidPoolIncubate
		},
		{
			invalidPooledIncubateSamples = {};
			invalidPoolIncubate = {};
			invalidPooledIncubateOptions = {};
			inversePoolIncubate = {}
		}
	];

	(*Throw an error if invalidPooledIncubate Options is not {}*)
	If[
		Length[invalidPooledIncubateOptions]>0&&messages,
		Message[Error::InvalidNestedIndexMatchingIncubateOptions,invalidPooledIncubateSamples,Join[invalidPoolIncubate,Flatten@invalidPooledIncubateOptions]],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidPooledIncubateTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidPooledIncubateSamples] > 0,
								Test["Our nested index matching incubate options are compatible for the inputs "<>ObjectToString[invalidPooledIncubateSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing
							];
					passingTest =
							If[Length[invalidPooledIncubateSamples] == 0,
								Test["Our nested index matching incubate options are compatible for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--5. Check that NestedIndexMatchingMixType option and NestedIndexMatchingMixVolume option are compatible--*)

	(*Map over all input pools to check if pooled mix options are compatible*)
	incompatibleMixOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{mixType,mixVolume},

				(*Find option values*)
				{mixType,mixVolume} = Lookup[sampleOptions,{NestedIndexMatchingMixType,NestedIndexMatchingMixVolume}];

				(*Check whether these options are conflicting*)
				Switch[{mixType,mixVolume},
					(*If NestedIndexMatchingMixType is Pipette and PooledVolume is Null return options*)
					{Pipette,Null}, {pooledSample,{NestedIndexMatchingMixType->mixType,NestedIndexMatchingMixVolume->mixVolume}},
					(*If NestedIndexMatchingMixType is Invert and PooledVolume is a volume return options*)
					{Invert,VolumeP}, {pooledSample,{NestedIndexMatchingMixType->mixType,NestedIndexMatchingMixVolume->mixVolume}},
					(*Catch all for any other combination of these two options. We will resolve this later.*)
					_, {pooledSample,{},{}}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out samples with {} invalid options*)
	filteredIncompatibleMixList = Select[incompatibleMixOptionsMapThread,!MatchQ[#[[2]],{}]&];

	(*Get the incompatible option keys for later*)
	incompatibleMixOptionKeys = If[Length[filteredIncompatibleMixList]>0,{NestedIndexMatchingMixType,NestedIndexMatchingMixVolume},{}];

	(*Throw an error if filteredIncompatibleMixList is not {}*)
	If[
		Length[filteredIncompatibleMixList]>0&&messages,
		Message[Error::IncompatibleMixOptions,filteredIncompatibleMixList],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	incompatiblePooledMixOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[filteredIncompatibleMixList] > 0,
								Test["Our nested index matching mix type is compatible with our nested index matching mix volume for the inputs "<>ObjectToString[incompatibleMixSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing
							];
					passingTest =
							If[Length[filteredIncompatibleMixList] == 0,
								Test["Our nested index matching mix type is compatible with our nested index matching mix volume for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--6. Check that ContainerOut option and SamplesOutStorageCondition option are compatible--*)

	(*Find option values*)
	{containerOption,storageOption} = Lookup[roundedThermalShiftOptions,{ContainerOut,SamplesOutStorageCondition}];

	(*Check whether these options are conflicting*)
	{incompatibleStorageOptions,incompatibleStorageOptionKeys} = Switch[{containerOption,storageOption},
		(*If ContainerOut is an object and SamplesOutStorageCondition is Disposal return object reference and storage option*)
		{ObjectP[],Null}, {{containerOption,storageOption},{ContainerOut,SamplesOutStorageCondition}},
		(*If ContainerOut is Null and SamplesOutStorageCondition is SampleStorageTypeP return options*)
		{Null,SampleStorageTypeP|Disposal}, {{containerOption,storageOption},{ContainerOut,SamplesOutStorageCondition}},
		(*Catch all for any other combination of these two options. We will resolve this later.*)
		{_,_}, {{},{}}
	];

	(*Throw an error if incompatibleStorageOptions is not {}*)
	If[
		Length[incompatibleStorageOptions]>0&&messages,
		Message[Error::IncompatibleSampleStorageOptions,incompatibleStorageOptions],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	incompatibleStorageOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[incompatibleStorageOptions] > 0,
								Test["Our sample ContainerOut is compatible with our SamplesOutStorageCondition:", True, False],
								Nothing
							];
					passingTest =
							If[Length[incompatibleStorageOptions] == 0,
								Test["Our sample ContainerOut is compatible with our SamplesOutStorageCondition:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--7. Check if either EmissionWavelength or Min/Max Emission wavelengths are specified. Both are not allowed. --*)

	(*Map over all input pools to check if emissions options are compatible*)
	invalidEmissionsOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{emissionOption,emissionParameters,suppliedEmissionOptions,suppliedNullEmissionOptions},

				(*Find emission wavelength value*)
				emissionOption = Lookup[sampleOptions,EmissionWavelength];

				(*Gather other emission options*)
				emissionParameters=FilterRules[Normal@sampleOptions,{MinEmissionWavelength,MaxEmissionWavelength}];

				(*Find any emission options that are user specified*)
				suppliedNullEmissionOptions = Select[emissionParameters, MatchQ[Values[#],Null]&];
				suppliedEmissionOptions = Select[emissionParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

				(*Return the appropriate invalid options given the emission option*)
				Which[
					(*If EmissionWavelength is specified return non-Null min/max emission options and input sample*)
					!MatchQ[emissionOption,Alternatives[Automatic,Null]], {pooledSample,{EmissionWavelength->emissionOption},suppliedEmissionOptions},
					(*If EmissionWavelength is Null return Null min/max emission options and input sample*)
					MatchQ[emissionOption,Null],{pooledSample,{EmissionWavelength->emissionOption},suppliedNullEmissionOptions},
					(*Catch all for if EmissionWavelength is Automatic. We will resolve this later.*)
					True, {pooledSample,emissionOption,{}}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out samples with {} invalid options*)
	filteredInvalidEmissionOptions = Select[invalidEmissionsOptionsMapThread,!MatchQ[#[[3]],{}]&];

	(*Get just the option keys for later*)
	invalidEmissionOptions = If[Length[filteredInvalidEmissionOptions]>0, DeleteDuplicates@Keys[#[[3]]&/@filteredInvalidEmissionOptions], {}];

	(*Throw an error if invalidEmissionOptions is not {}*)
	If[
		Length[filteredInvalidEmissionOptions]>0&&messages,
		Message[Error::InvalidEmissionOptions,filteredInvalidEmissionOptions],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidEmissionTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[filteredInvalidEmissionOptions] > 0,
								Test["Our user specified emission wavelength options are compatible for the inputs "<>ObjectToString[invalidEmissionSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing
							];
					passingTest =
							If[Length[filteredInvalidEmissionOptions] == 0,
								Test["Our user specified emission wavelength options are compatible for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}];

	(*--8. Check if MinEmission wavelength is less than MaxEmission wavelength.--*)

	(*Map over all input pools to check if min/max emissions options are compatible*)
	incompatibleEmissionOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{minEmission,maxEmission},

				(*Find option values*)
				{minEmission,maxEmission} = Lookup[sampleOptions,{MinEmissionWavelength,MaxEmissionWavelength}];

				(*Find if Min and Max are compatible.*)
				Which[
					(*If both are Null return the sample and {}. This assumes that EmissionWavelength is specified. We check for this above.*)
					MatchQ[minEmission,Null]&&MatchQ[maxEmission,Null], {pooledSample,{},{}},
					(*If both are Automatic return the sample and {}. We will resolve this later.*)
					MatchQ[minEmission,Automatic]&&MatchQ[maxEmission,Automatic], {pooledSample,{},{}},
					(*If one parameter is Null while the other is specified return the sample and options.*)
					MatchQ[minEmission,Null]&&!MatchQ[maxEmission,Alternatives[Automatic,Null]]||!MatchQ[minEmission,Alternatives[Automatic,Null]]&&MatchQ[maxEmission,Null], {pooledSample,{MinEmissionWavelength->minEmission,MaxEmissionWavelength->maxEmission}},
					(*If min is less than max return the sample and {}*)
					minEmission<maxEmission, {pooledSample,{},{}},
					(*If min is greater than max return the sample and options*)
					minEmission>maxEmission, {pooledSample,{MinEmissionWavelength->minEmission,MaxEmissionWavelength->maxEmission}},
					(*Catch all *)
					True,{pooledSample,{},{}}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out the samples with compatible min/max options*)
	filteredIncompatibleEmissionList = Select[incompatibleEmissionOptionsMapThread,!MatchQ[#[[2]],{}]&];

	(*Get incompatible option keys for later*)
	incompatibleEmissionRangeKeys = If[Length[filteredIncompatibleEmissionList]>0,{MinEmissionWavelength,MaxEmissionWavelength},{}];

	(*Throw an error if incompatibleEmissionOptions is not {}*)
	If[
		Length[filteredIncompatibleEmissionList]>0&&messages,
		Message[Error::IncompatibleEmissionRangeOptions,filteredIncompatibleEmissionList],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidEmissionRangeTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[filteredIncompatibleEmissionList] > 0,
								Test["Our emission wavelength range options are compatible for the inputs "<>ObjectToString[incompatibleEmissionSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[filteredIncompatibleEmissionList] == 0,
								Test["Our emission wavelength range options are compatible for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*--9. Check if PassiveReference is Null but PassiveReferenceVolume is specified and vice versa.--*)
	(*Get option values*)
	{passiveReferenceOption, passiveReferenceVolumeOption}=Lookup[roundedThermalShiftOptions,{PassiveReference,PassiveReferenceVolume}];

	(*Check if the options are compatible, if they are not return the incompatible options*)
	invalidPassiveReferenceOptions = Which[

		(*If the passive reference is Null but passive reference volume is specified return the incompatible options*)
		MatchQ[passiveReferenceOption,Null]&&MatchQ[passiveReferenceVolumeOption,VolumeP], {passiveReferenceOption,passiveReferenceVolumeOption},

		(*If the passive reference is a model or object reference and passive reference volume is Null return the incompatible options*)
		MatchQ[passiveReferenceOption,ObjectP[]]&&MatchQ[passiveReferenceVolumeOption,Null], {passiveReferenceOption,passiveReferenceVolumeOption},

		(*Otherwise return an empty list*)
		True, {}
	];

	(*Throw an error if invalidPassiveReferenceOptions is not {}*)
	If[Length[invalidPassiveReferenceOptions]>0&&messages,
		Message[Error::InvalidPassiveReferenceOptions, invalidPassiveReferenceOptions[[1]], invalidPassiveReferenceOptions[[2]]],
		Nothing
	];

	(*Get the invalid keys for later*)
	invalidPassiveReferenceOptionsKeys =If[Length[invalidPassiveReferenceOptions]>0, {PassiveReference,PassiveReferenceVolume}, {}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidPassiveRefTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidPassiveReferenceOptions] > 0,
								Test["Our passive reference options are compatible:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidPassiveReferenceOptions] == 0,
								Test["Our passive reference options are compatible:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*--10. Check if DetectionReagent is Null but DetectionReagentVolume is specified.--*)
	(*Map over all input pools to check if detection reagent options are compatible*)
	incompatibleDetectionReagentOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{reagent,reagentVolume},

				(*Find option values*)
				{reagent,reagentVolume} = Lookup[sampleOptions,{DetectionReagent,DetectionReagentVolume}];

				(*Find if reagent and volume are compatible.*)
				Which[
					(*If both are Null return the sample and {}.*)
					MatchQ[reagent,Null]&&MatchQ[reagentVolume,Null], {pooledSample,{},{}},
					(*If reagent is Null while reagent volume is specified return the sample and the options.*)
					MatchQ[reagent,Null]&&!MatchQ[reagentVolume,Alternatives[Automatic,Null]], {pooledSample,{DetectionReagent->reagent,DetectionReagentVolume->reagentVolume}},
					(*If the reagent is specified while the reagent volume is Null, return the sample and options*)
					!MatchQ[reagent,Alternatives[Automatic,Null]]&&MatchQ[reagentVolume,Null], {pooledSample,{DetectionReagent->reagent,DetectionReagentVolume->reagentVolume}},
					(*Catch all if both are automatic.*)
					True,{pooledSample,{},{}}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out the samples with compatible reagent options*)
	filteredIncompatibleReagentList = Select[incompatibleDetectionReagentOptionsMapThread,!MatchQ[#[[2]],{}]&];

	(*Get the incompatible option keys for later*)
	incompatibleReagentOptionKeys = If[Length[filteredIncompatibleReagentList]>0, {DetectionReagent,DetectionReagentVolume},{}];

	(*Throw an error if incompatibleReagentOptions is not {}*)
	If[
		Length[filteredIncompatibleReagentList]>0&&messages,
		Message[Error::IncompatibleDetectionReagentOptions,filteredIncompatibleReagentList],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidReagentTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[filteredIncompatibleReagentList] > 0,
								Test["Our detection reagent options are compatible for the inputs "<>ObjectToString[incompatibleReagentSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[filteredIncompatibleReagentList] == 0,
								Test["Our detection reagent options are compatible for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*--11. Check that only one dilution option is specified.--*)
	(*Map over all input pools to check if serial dilution curve and dilution curve are specified*)
	tooManyDilutionCurveOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{serialDilution,dilution},

				(*Find option values*)
				{serialDilution,dilution} = Lookup[sampleOptions,{SerialDilutionCurve,DilutionCurve}];

				(*Mapthread over each sample in the pool*)
				(*Find if both options are not Null.*)
				MapThread[
				Which[
					(*If serildilution is not Null and dilution is not Null return the pooled sample and conflicting options.*)
					!MatchQ[#1,Null]&&!MatchQ[#2,Null], {pooledSample,{#1,#2},{SerialDilutionCurve,DilutionCurve}},
					(*In all other cases, return sample and {}.*)
					True,{#3,{},{}}
				]&,
					{serialDilution,dilution,pooledSample}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out the samples with compatible dilution options*)
	flatDilutionsList = Flatten[tooManyDilutionCurveOptionsMapThread,1];
	filteredDilutionsList = Select[flatDilutionsList,!MatchQ[#[[2]],{}]&];

	(*Get the invalid keys for later*)
	tooManyDilutionOptionKeys = If[Length[filteredDilutionsList]>0,{SerialDilutionCurve,DilutionCurve},{}];

	(*Throw an error if tooManyDilutionOptions is not {}*)
	If[
		Length[filteredDilutionsList]>0&&messages,
		Message[Error::TooManyDilutionCurveOptions,filteredDilutionsList[[All,1]]],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	tooManyDilutionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[filteredDilutionsList] > 0,
								Test["Only one type of dilution curve for each of the inputs "<>ObjectToString[tooManyDilutionSamples,Simulation->updatedSimulation]<>" is specified:", True, False],
								Nothing];
					passingTest =
							If[Length[filteredDilutionsList] == 0,
								Test["Only one type of dilution curve for each of the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" is specified:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*--12. Check that the dilution curve options are compatible.--*)
	(*Map over all input pools to check if dilution curve options are specified*)
	incompatibleDilutionCurveOptionsMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{serialDilution,dilution,diluentObj,dilMixRate,dilMixNum,dilMixVol,dilStorageCond},

				(*Find serial dilution and dilution curve value*)
				{serialDilution,dilution} = Lookup[sampleOptions,{SerialDilutionCurve,DilutionCurve}];

				(*Gather other dilution curve options*)
				{diluentObj,dilMixRate,dilMixNum,dilMixVol,dilStorageCond}=Lookup[sampleOptions,{Diluent,DilutionMixRate,DilutionNumberOfMixes,DilutionMixVolume,DilutionStorageCondition}];

				(*MapThread over each pool to look for compatible options for each sample*)
				MapThread[
					Function[{serialDilutionOption,dilutionOption,diluent,mixRate,mixNum,mixVol,storageCond},
						Module[{suppliedNullDilutionOptions,suppliedDilutionOptions,dilutionPars},
							dilutionPars = {Diluent->diluent,DilutionMixRate->mixRate,DilutionNumberOfMixes->mixNum,DilutionMixVolume->mixVol,DilutionStorageCondition->storageCond};
							(*Find any dilution options that are user specified*)
							suppliedNullDilutionOptions = Select[dilutionPars, MatchQ[Values[#],Null]&];
							suppliedDilutionOptions = Select[dilutionPars, MatchQ[Values[#],Except[Alternatives[Automatic,Null]]]&];

							(*Return the appropriate invalid options given the dilution options*)
							Which[
								(*If SerialDilutionCurve or DilutionCurve is not Null return Null dilution options and input sample*)
								!MatchQ[serialDilutionOption,Null]||!MatchQ[dilutionOption,Null], {pooledSample,suppliedNullDilutionOptions},
								(*If both SerialDilutionCurve and DilutionCurve are Null return non-Null dilution options and input sample*)
								MatchQ[serialDilutionOption,Null]&&MatchQ[dilutionOption,Null],{pooledSample,suppliedDilutionOptions}
							]
						]
					],
					{serialDilution,dilution,diluentObj,dilMixRate,dilMixNum,dilMixVol,dilStorageCond}
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Filter out the samples with compatible dilution options*)
	flatIncompatibleDilutionsList = Flatten[incompatibleDilutionCurveOptionsMapThread,1];
	filteredIncompatibleDilutionsList = Select[flatIncompatibleDilutionsList,!MatchQ[#[[2]],{}]&];

	(*Get the incompatible keys for later*)
	incompatibleDilutionOptions = If[Length[filteredIncompatibleDilutionsList]>0,Keys[filteredIncompatibleDilutionsList[[All,2]]],{}];

	(*Throw an error if filteredIncompatibleDilutionsList is not {}*)
	If[
		Length[filteredIncompatibleDilutionsList]>0&&messages,
		Message[Error::IncompatibleDilutionCurveOptions,filteredIncompatibleDilutionsList[[All,1]],filteredIncompatibleDilutionsList[[All,2]]],
		Nothing
	];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidDilutionTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[filteredIncompatibleDilutionsList] > 0,
								Test["Our sample dilution curve options for inputs "<>ObjectToString[filteredIncompatibleDilutionsList[[All,1]],Simulation->updatedSimulation]<>" are compatible:", True, False],
								Nothing
							];
					passingTest =
							If[Length[filteredIncompatibleDilutionsList] == 0,
								Test["Our sample dilution curve options for inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--13. Check that MinTemperature is less than MaxTemperature--*)

	(*Find the min and max temp option values*)
	{minTemp,maxTemp} = Lookup[roundedThermalShiftOptions,{MinTemperature,MaxTemperature}];

	(*Check if the min temp is less than the max temp*)
	invalidTempRange = minTemp>maxTemp;

	(*Throw an error if invalidTempRange is True*)
	invalidTempRangeOptions = If[MatchQ[invalidTempRange,True]&&messages,
		(Message[Error::InvalidTemperatureRamp, minTemp, maxTemp];
		{MinTemperature,MaxTemperature}),
		{}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidRampTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidTempRange,True],
								Test["Our specified MinTemperature is less than the MaxTemperature:", True, False],
								Nothing
							];
					passingTest =
							If[MatchQ[invalidTempRange,False],
								Test["Our specified MinTemperature is less than the MaxTemperature:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(*--14. Check that OptimizeStaticLightScatteringLaserPower is only True when OptimizeFluorescenceLaserPower is True--*)

	(*MapThread over expanded options*)
	invalidSLSOptimizationMapThread=MapThread[
		Function[ {sampleOptions,pooledSample},
			Module[{optimizeSLS,optimizeFluorescence,result},

				(*Find the option values*)
				{optimizeSLS,optimizeFluorescence} = Lookup[sampleOptions,{OptimizeStaticLightScatteringLaserPower,OptimizeFluorescenceLaserPower}];

				(*For each sample, determine if the SLS optimization is True when the fluorescence optimization is False *)
				result = If[
					MatchQ[optimizeSLS,True]&&MatchQ[optimizeFluorescence,False],
					{pooledSample,True},
					Null
				]
			]
		],
		{mapThreadFriendlyOptions,myPooledSamples}
	];

	(*Get just the invalid samples*)
	invalidSLSOptimization= Cases[invalidSLSOptimizationMapThread, Except[NullP]];

	(*Throw a warning if the invalidSLSOptimization is not an empty list*)
	If[Length[invalidSLSOptimization]>0&&!engineQ,
		Message[Warning::UnusedOptimizationParameters, OptimizeStaticLightScatteringLaserPower, invalidSLSOptimization[[All,1]]],
		Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	optimizeSLSTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSLSOptimization]>0,
								Test["Optimize SLS laser power is only True when optimize fluorescence laser power is True:", True, False],
								Nothing
							];
					passingTest =
							If[Length[invalidSLSOptimization]===0,
								Test["Optimize SLS laser power is only True when optimize fluorescence laser power is True:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(* 15. SOLID SAMPLES ARE NOT OK *)

	(* Get the samples that are not liquids,cannot filter those *)
	nonLiquidSamplePackets=If[Not[MatchQ[Lookup[#, State], Alternatives[Liquid, Null]]],
		#,
		Nothing
	] & /@ (Flatten@samplePackets);

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=If[MatchQ[nonLiquidSamplePackets,{}],{},Lookup[nonLiquidSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::SolidSamplesUnsupported,ObjectToString[nonLiquidSampleInvalidInputs,Simulation->updatedSimulation],ExperimentThermalShift];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonLiquidSampleInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Simulation->updatedSimulation]<>" have a Liquid State:",True,False]
			];

			passingTest=If[Length[nonLiquidSampleInvalidInputs]==Length[flatSampleList],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[flatSampleList,nonLiquidSampleInvalidInputs],Simulation->updatedSimulation]<>" have a Liquid State:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-16. Check to see if the user specified thermocycler is a qPCR thermocycler--*)

	(*Find the instrument model of the user specified instrument.*)
	specifiedThermocyclerMode=Which[
		MatchQ[Lookup[roundedThermalShiftOptions,Instrument],ObjectP[Object[Instrument,Thermocycler]]],
		Lookup[Flatten@specifiedInstrumentObjectPackets,Mode],

		MatchQ[Lookup[roundedThermalShiftOptions,Instrument],ObjectP[Model[Instrument,Thermocycler]]],
		Lookup[Flatten@specifiedInstrumentModelPackets,Mode],

		True,
		Automatic
	];

	(*Check if the thermocycler instrument model is a qPCR instrument*)
	{qPCRThermocyclerInstrumentCheck, invalidThermocyclerModeOption} = If[MatchQ[specifiedThermocyclerMode,qPCR|{qPCR}]||MatchQ[specifiedThermocyclerMode,Automatic],
		{True,{}},
		{False,Instrument}
	];

	(*Throw an error if the qPCRThermocyclerInstrumentCheck is False*)
	If[MatchQ[qPCRThermocyclerInstrumentCheck,False]&&!engineQ,
		Message[Error::InvalidThermocycler, Lookup[roundedThermalShiftOptions,Instrument]],
		Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	thermocyclerModeTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[qPCRThermocyclerInstrumentCheck,False],
								Test["Our specified thermocycler is a qPCR thermocycler:", True, False],
								Nothing
							];
					passingTest =
							If[MatchQ[qPCRThermocyclerInstrumentCheck,True],
								Test["Our specified thermocycler is a qPCR thermocycler:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(* -17. Check that the protocol name is unique - *)
	suppliedName = Lookup[roundedThermalShiftOptions,Name];

	validNameQ=If[MatchQ[suppliedName,_String],

		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,ThermalShift,suppliedName]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"ThermalShift protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[suppliedName,_String],
		Test["If specified, Name is not already an ThermalShift protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* - Lookup the DLS-related options - *)
	{
		dynamicLightScatteringOption,dynamicLightScatteringMeasurementsOption,numberOfDynamicLightScatteringAcquisitionsOption,
		dynamicLightScatteringAcquisitionTimeOption,automaticDynamicLightScatteringLaserSettingsOption,dynamicLightScatteringLaserPowerOption,
		dynamicLightScatteringDiodeAttenuationOption, dynamicLightScatteringTemperatureOption,dynamicLightScatteringCapillaryLoadingOption
	}=Lookup[roundedThermalShiftOptions,
		{
			DynamicLightScattering,DynamicLightScatteringMeasurements,NumberOfDynamicLightScatteringAcquisitions,
			DynamicLightScatteringAcquisitionTime,AutomaticDynamicLightScatteringLaserSettings,DynamicLightScatteringLaserPower,
			DynamicLightScatteringDiodeAttenuation,DynamicLightScatteringMeasurementTemperatures,DynamicLightScatteringCapillaryLoading
		}
	];

	(* -- Throw Errors related to conflicting DLS options -- *)
	(* - Throw an Error if DynamicLightScattering is False, but any of the DLS-related options are not Null - *)
	{invalidConflictingDLSOptionNames,invalidConflictingDLSOptionValues}=Module[
		{
			nonNullOptionValues,nonNullOptionNames,invalidOptionValues,invalidOptionNames
		},

		(* Find the values of any DLS-related options which are not Null *)
		nonNullOptionValues=Cases[
			{
				dynamicLightScatteringMeasurementsOption,numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringAcquisitionTimeOption,
				automaticDynamicLightScatteringLaserSettingsOption,dynamicLightScatteringLaserPowerOption,dynamicLightScatteringDiodeAttenuationOption,
				dynamicLightScatteringTemperatureOption
			},
			Except[Alternatives[Null,Automatic]]
		];

		(* Find the Names of any DLS-related options which are not Null *)
		nonNullOptionNames=PickList[
			{
				DynamicLightScatteringMeasurements,NumberOfDynamicLightScatteringAcquisitions,DynamicLightScatteringAcquisitionTime,
				AutomaticDynamicLightScatteringLaserSettings,DynamicLightScatteringLaserPower,DynamicLightScatteringDiodeAttenuation,
				DynamicLightScatteringMeasurementTemperatures
			},
			{
				dynamicLightScatteringMeasurementsOption,numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringAcquisitionTimeOption,
				automaticDynamicLightScatteringLaserSettingsOption,dynamicLightScatteringLaserPowerOption,dynamicLightScatteringDiodeAttenuationOption,
				dynamicLightScatteringTemperatureOption
			},
			Except[Alternatives[Null,Automatic]]
		];

		{invalidOptionValues,invalidOptionNames}=If[

			(* IF DynamicLightScattering is False AND there are some non-Null option values *)
			And[
				Not[dynamicLightScatteringOption],
				Length[nonNullOptionValues]>0
			],

			(* THEN any of the DLS-related option which are not Null or Automatic are invalid *)
			{
				Join[{dynamicLightScatteringOption},nonNullOptionValues],
				Join[{DynamicLightScattering},nonNullOptionNames]
			},

			(* ELSE the options are not invalid *)
			{{},{}}
		];

		(* Return the invalidOptionValues and invalidOptionNames *)
		{invalidOptionNames,invalidOptionValues}
	];

	(* If there are any invalidConflictingDLSInstrumentOptions has any Contents and we are throwing Messages, throw an Error *)
	If[Length[invalidConflictingDLSOptionNames]>0&&messages,
		Message[Error::ConflictingThermalShiftDLSOptions,invalidConflictingDLSOptionNames,invalidConflictingDLSOptionValues]
	];

	(* Define the tests the user will see for the above message *)
	conflictingDLSOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingDLSOptionNames]==0,
				Nothing,
				Test["The following options, "<>ToString[invalidConflictingDLSOptionNames]<>", with values of  "<>ToString[invalidConflictingDLSOptionValues]<>" are in conflict. If DynamicLightScattering is False, none of the dynamic light scattering-related options can be specified:",True,False]
			];
			passingTest=If[Length[invalidConflictingDLSOptionNames]>0,
				Nothing,
				Test["The DynamicLightScattering option and related DLS options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];



	(* - Throw an Error if DynamicLightScattering is True but any of the DynamicLightScatteringMeasurements, the NumberOfAcquisitions
	or AcquisitionTime is Null - *)
	(* Define the invalid options and their values *)
	{invalidConflictingNullDLSOptionNames,invalidConflictingNullDLSOptionValues}=Switch[
		{
			dynamicLightScatteringOption,numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringAcquisitionTimeOption,
			dynamicLightScatteringMeasurementsOption,dynamicLightScatteringTemperatureOption
		},

		(* Case where DLS is False - don't throw this error *)
		{False,_,_,_,_},
			{{},{}},

		(* Case where DLS is True, and neither the NumberOfAcquisitions nor the AcquisitionTime is Null - no Error *)
		{True,Except[Null],Except[Null],Except[Null],Except[Null]},
			{{},{}},

		(* In all other cases (DLS True and one of the options is Null, we need to throw Error) *)
		{_,_,_,_,_},
			{
				Join[
					{DynamicLightScattering},
					PickList[
						{
							NumberOfDynamicLightScatteringAcquisitions,DynamicLightScatteringAcquisitionTime,DynamicLightScatteringMeasurements,DynamicLightScatteringMeasurementSTemperature
						},
						{
							numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringAcquisitionTimeOption,
							dynamicLightScatteringMeasurementsOption,dynamicLightScatteringTemperatureOption
						},
						Null
					]
				],
				Join[
					{dynamicLightScatteringOption},
					Cases[
						{
							numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringAcquisitionTimeOption,
							dynamicLightScatteringMeasurementsOption,dynamicLightScatteringTemperatureOption
						},
						Null
					]
				]
			}
	];

	(* If there are any invalidConflictingDLSInstrumentOptions has any Contents and we are throwing Messages, throw an Error *)
	If[Length[invalidConflictingNullDLSOptionNames]>0&&messages,
		Message[Error::ConflictingThermalShiftNullDLSOptions,invalidConflictingNullDLSOptionNames,invalidConflictingNullDLSOptionValues]
	];

	(* Define the tests the user will see for the above message *)
	conflictingNullDLSOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingNullDLSOptionNames]==0,
				Nothing,
				Test["The following options, "<>ToString[invalidConflictingNullDLSOptionNames]<>", with values of  "<>ToString[invalidConflictingNullDLSOptionValues]<>" are in conflict. If DynamicLightScattering is True, neither the NumberOfDynamicLightScatteringAcquisitions nor the DynamicLightScatteringAcquisitionTime options can be Null:",True,False]
			];
			passingTest=If[Length[invalidConflictingNullDLSOptionNames]>0,
				Nothing,
				Test["The DynamicLightScattering option and related DLS acquisition options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(*Resolve instrument based on resolvedAnalyteType*)
	(* note that we are using $Site here to resolve whether we're using the QuantStudio 7 Flex *)
	(* this is not exactly right but the resources will treat the Viia 7 and the QuantStudio 7 Flex as equivalent in the resource packets anyway *)
	resolvedInstrument = Switch[{$Site, instrumentOption,resolvedAnalyteType},
		(*If the resolved anaylte type is Oligomer set instrument to thermocycler*)
		(* this site here is Object[Container, Site, "ECL-2"] *)
		{Object[Container, Site, "id:kEJ9mqJxOl63"], Automatic,Oligomer}, Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], (* Model[Instrument,Thermocycler,"ViiA 7"] *)
		(* this would be for CMU or any other theoretical future instance*)
		{_, Automatic,Oligomer}, Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"], (* Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)

		(*If the resolved analyte type is Protein set instrument to multimode spectrophotometer*)
		{_, Automatic,Protein}, Model[Instrument,MultimodeSpectrophotometer,"Uncle"],

		(*Otherwise keep the user specification*)
		{_, ObjectP[],_}, instrumentOption
	];


	(* resolve the NumberOfReplicates option; default to 2 if we're using the Uncle *)
	specifiedNumberOfReplicates = Lookup[roundedThermalShiftOptions, NumberOfReplicates];
	resolvedNumberOfReplicates = Which[
		Not[MatchQ[specifiedNumberOfReplicates, Automatic]], specifiedNumberOfReplicates,
		MatchQ[resolvedInstrument, ObjectP[{Model[Instrument, MultimodeSpectrophotometer], Object[Instrument, MultimodeSpectrophotometer]}]], 2,
		True, Null
	];

	(*Get the resolved instrument packet from the downloaded instrument packets*)
	resolvedInstrumentModel = If[MatchQ[resolvedInstrument,ObjectP[Model[Instrument]]],resolvedInstrument,Sequence@@Lookup[Flatten@specifiedInstrumentObjectPackets,Model]];
	resolvedInstrumentPacket = Cases[
		Flatten@Union[specifiedInstrumentModelPackets,specifiedInstrumentObjectPackets,thermalShiftInstrumentModelPackets],
		KeyValuePattern[Object->Download[resolvedInstrumentModel,Object]]
	];

	(*Resolve ReactionVolume based on resolvedInstrument*)
	(*First get the ReactionVolume option*)
	reactionVolumeOption = Lookup[roundedThermalShiftOptions,ReactionVolume];

	(*Resolve the reaction volume given the reactionVolumeOption and resolvedInstrument*)
	reactionVolume = Switch[reactionVolumeOption,
		(*If the reactionVolumeOption is Automatic, set reactionVolume to 20uL*)
		Automatic, 20*Microliter,
		(*Otherwise keep the user specification. We will error check this later.*)
		_, reactionVolumeOption
	];


	(*Resolve PassiveReferenceVolume based on PassiveReference*)
	(*First get the passive reference options*)
	{passiveReferenceOption, passiveReferenceVolumeOption} = Lookup[roundedThermalShiftOptions,{PassiveReference,PassiveReferenceVolume}];

	(*Resolve the passive reference volume given the passiveReferenceOption*)
	passiveReferenceVolume = Switch[{passiveReferenceOption,passiveReferenceVolumeOption},

		(*If the passiveReferenceOption is a model sample and passiveReferenceVolumeOption is Automatic lookup the passive reference volume*)
		{ObjectP[Model[Sample]],Automatic}, Sequence@@SafeRound[reactionVolume/Lookup[Flatten@passiveRefModelPackets,ConcentratedBufferDilutionFactor],0.01*Microliter],

		(*If the passiveReferenceOption is a object sample and passiveReferenceVolumeOption is Automatic lookup the passive reference volume*)
		{ObjectP[Object[Sample]],Automatic}, Sequence@@SafeRound[reactionVolume/Lookup[Flatten@passiveRefObjPackets,ConcentratedBufferDilutionFactor],0.01*Microliter],


		(*If the passiveReferenceOption is Null and passiveReferenceVolumeOption is Automatic, set to 0*)
		{Null,Automatic}, SafeRound[0*Microliter,0.01*Microliter],

		(*Otherwise keep the user specification.*)
		{_,_}, passiveReferenceVolumeOption
	];

	(*If the resolved volume is not a number, give an error*)
	(*This can happen in the case where the specified object does not have an associated model and therefore we cannot look up the concentration factor.*)
	{invalidPassRefVol,invalidPassRefOption}=If[!passiveReferenceVolume>=0Microliter&&messages, {True,PassiveReferenceVolume},{False,{}}];

	If[invalidPassRefVol==True,Message[Error::InvalidPassiveReferenceVolume,passiveReferenceOption],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidPassiveRefVolTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidPassRefVol,True],
								Test["Our passive reference volume can be resolved:", True, False],
								Nothing
							];
					passingTest =
							If[MatchQ[invalidPassRefVol,False],
								Test["Our passive reference volume can be resolved:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];

	(* MapThread over each of our samples. *)
	{aliquotBools,aliquotContainers,aliquotVol} = Lookup[resolvedSamplePrepOptions,{Aliquot,AliquotContainer,AliquotAmount}];

	{targetContainers,sampleVolumes,buffers,bufferVolumes,detectionReagents,detectionReagentVolumes,invalidDetectionReagentVolume,
		dilutionCurves,serialDilutionCurves,diluents,dilutionMixRates,dilutionContainers,dilutionMixVolumes,dilutionMixNumbers,
		pooledMixes,pooledMixTypes,pooledMixNumberOfMixes,pooledMixVolumes,pooledIncubations,pooledIncubationTimes,pooledIncubationTemperatures,pooledAnnealingTimes,
		fluorescenceFilters,slsFilters,emissionParameters,minEmWavelengths,maxEmWavelengths,emWavelengths,excitationWavelengths,slsExcitationWavelengths,
		invalidPoolMixVolumes,invalidDetectionReagentVolumes,invalidSampleVolumes,invalidBufferVolumes,invalidDilutionMixVols,invalidDilutionContainers,invalidThermocyclerOptions,invalidMMSpecOptions,invalidEmissionRanges,invalidExcitationWavelengths,invalidEmissionWavelengths,incompatibleExcitationWavelengths,
		incompatibleEmissionDetectors,requiredWells,invalidDilutionVolumes,resolvedLaserOptiWavelengths,resolvedLaserOptiIntensities,invalidLaserOptiOptions,unusedOptimizationOptions,invalidSampleReactionVolumes,invalidPooledDilutions,resolvedDilutionStorageConditions
	}= Transpose[
		MapThread[
			Function[{mySamples,myMapThreadOptions,aliquotBool,aliquotContainer,aliquotVolume,poolPackets},
				Module[{targetContainer,unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume,poolVolume,poolLength,
					resolvedPoolMix,resolvedPooledMixType,sampleVolume,resolvedMixNumber,resolvedMixVolume,invalidPoolMixVolume,unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime,
					resolvedPoolIncubate,resolvedIncubationTemperature,resolvedIncubationTime,resolvedAnnealingTime,unresolvedDetectionReagent, unresolvedDetectionReagentVol,
					analytePackets,analyteType,specifiedAnalyte,specifiedDetectionReagentPacket,defaultDetectionReagent,defaultDetectionReagentVolume,resolvedDetectionReagent,resolvedDetectionReagentVolume,
					invalidDetectionReagentVolume,unresolvedSampleVolume, unresolvedBufferVolume,resolvedSampleVolume,resolvedBufferVolume,invalidSampleVolume,invalidBufferVolume,
					unresolvedBuffer,resolvedBuffer,serialDilution,dilution,dilutionCurveList,serialDilutionList,dilutionList,requiredWellNum,
					unresolvedDiluent,unresolvedDilutionMixRate,unresolvedMixVol,minDilVolume,unresolvedDilutionContainer,resolvedDiluent,resolvedDilutionMixRate,resolvedDilutionMixNumber,
					resolvedDilutionMixVol,resolvedDilutionContainer,invalidDilutionMixVol,dilutionContainer,invalidDilutionContainer,unresolvedFluorFilter,unresolvedSLSFilter,unresolvedExWavelength,
					unresolvedEmWavelength,unresolvedMinEm,unresolvedMaxEm,unresolvedSLSEx,requiredPureSampleVol,dilutionQ,maxDilVol,
					fluorescenceFilter, slsFilter,allCompositionPackets,allIMPackets,resolvedDetectionReagentCompLinks,resolvedDetectionReagentComp,resolvedDetectionReagentPacket,
					reagentExMax,instrumentExWavelengths,defaultEx,reagentEmMax,instrumentEmWavelengths,defaultEm,defaultMinEm,defaultMaxEm,defaultSLSEx,resolvedFluorFilter,resolvedSLSFilter,resolvedExWavelength,resolvedSLSEx,
					resolvedEmissionDetection,invalidThermocyclerOption,invalidMMSpecOption,invalidEmissionRange,invalidExcitationWavelength,invalidEmissionWavelength,incompatibleExcitationWavelength,
					incompatibleEmissionOption,resolvedMinEm,resolvedMaxEm,resolvedEmWavelength,storageCondRules,detectionReagentObjectRef,resolvedDilutionOptions,invalidSampleReactionVolume,
					invalidDilutionOptions,invalidDilutionVolume,resolvedLaserOptiWavelength,resolvedLaserOptiIntensity,invalidLaserOptiOption,unusedOptimizationOption,unresolvedOptiWavelengthRange, unresolvedOptiIntensityRange,optiFluorescenceLaser,
					dilutionCurveListNoNulls, dilutionLengths, invalidPooledDilution,resolvedDilutionStorageCondition},

					(* Setup our error tracking variables *)
					{invalidPoolMixVolume,invalidDetectionReagentVolume,invalidSampleVolume,invalidBufferVolume,invalidDilutionMixVol,invalidDilutionContainer,invalidThermocyclerOption,invalidMMSpecOption,invalidEmissionRange,invalidExcitationWavelength,invalidEmissionWavelength,incompatibleExcitationWavelength,
						incompatibleEmissionOption}=ConstantArray[False,13];

					(* Helper to return the user-specified value if provided or resolve the Automatic to a given value *)
					resolveAutomaticOptions[option_, valueToResolveTo_] :=
							Module[{listOps, listVals},
								listOps = option;
								listVals = valueToResolveTo;
								MapThread[
									If[MatchQ[#1, Automatic|{Automatic..}], #2, #1] &, {listOps, listVals}]];

					(*-- 1. POOLED MIX OPTIONS RESOLUTION --*)

					(*First, get all the pooled mix related options*)
					{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume} =
							Lookup[myMapThreadOptions, {NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixVolume}];

					(*Get the sample volume, pool sample total volume, and length*)
					poolVolume = Total[aliquotVolume];
					poolLength = Length[mySamples];
					sampleVolume = Total[Lookup[poolPackets,Volume]];

					(*Option resolution switch depending on option values and sample pool length*)
					(*Note that we have already checked that the mix options are compatible*)

					{resolvedPoolMix,resolvedPooledMixType,resolvedMixNumber,resolvedMixVolume} = Switch[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume,poolLength},

						(*If the pool contains more than one sample and all other options are Automatic, NestedIndexMatchingMix->True, NestedIndexMatchingMixType->Pipette, NestedIndexMatchingNumberOfMixes->5, NestedIndexMatchingMixVolume->pooledVolume/2*)
						{Automatic,Automatic,Automatic,Automatic,GreaterP[1]},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{True,Pipette,5,poolVolume/2}],

						(*If the pool contains only one sample and all other options are Automatic, NestedIndexMatchingMix->False and all other options are Null*)
						{Automatic,Automatic,Automatic,Automatic,EqualP[1]},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{False, Null, Null, Null}],

						(*If the pool contains only one sample and NestedIndexMatchingMix->True, NestedIndexMatchingMixType->Pipette, NestedIndexMatchingMixVolume->sampleVolume,PooledNumberOfMixed->5*)
						{True,_,_,_,EqualP[1]},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{True, Pipette, 5, sampleVolume}],

						(*If the pool contains only one sample and NestedIndexMatchingMixType->Pipette, NestedIndexMatchingMix->True, NestedIndexMatchingMixVolume->sampleVolume,PooledNumberOfMixed->5*)
						{_,Pipette,_,_,EqualP[1]},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{True, Pipette, 5, sampleVolume}],

						(*If PoolMix is false or Null, and all other options are anything, *)
						{False|Null,_,_,_,_},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{False,Null,Null,Null}],

						(*If PoolMixType is Invert, and all other options are anything, *)
						{_,Invert,_,_,_},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{True,Invert,5,Null}],

						(*If PoolMixType is Null and all other options are Automatic *)
						{Automatic,Null,Automatic,Automatic,_},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{False,Null,Null,Null}],

						(*If NestedIndexMatchingNumberOfMixes is Null and all other options are Automatic *)
						{Automatic,Automatic,Null,Automatic,_},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{False,Null,Null,Null}],

						(*If NestedIndexMatchingMixVolume is Null and all other options are Automatic *)
						{Automatic,Automatic,Automatic,Null,_},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{False,Null,Null,Null}],

						(*For any other combination of options, take the user specified options and resolve any automatics to the defaults*)
						{_,_,_,_,_},
						resolveAutomaticOptions[{unresolvedPooledMix,unresolvedPooledMixType,unresolvedMixNumber,unresolvedMixVolume},{True,Pipette,5,poolVolume/2}]
					];

					(*Check that the pool mix volume is less than or equal to the available pooled volume*)
					invalidPoolMixVolume = If[!MatchQ[resolvedMixVolume,Null]&&resolvedMixVolume>poolVolume, True, False];

					(*-- 2. TARGET CONTAINER RESOLUTION --*)

					(*Target container is the target aliquot container*)
					(*If aliquotting is false, the target container will be Null otherwise it will be a 2-mL deep well plate if pooledmixtype is pipette and a 2ml tube if pooled mix type is invert*)

					targetContainer = Switch[{aliquotBool, aliquotContainer,resolvedPooledMixType},

						(*If aliquot is true and aliquot container is an object, return the specified object*)
						{True|Automatic,ObjectP[],_}, aliquotContainer,

						(*If aliquot is true, pooled mix typ eis pipette, and aliquot container is not an object reference, return 2-mL deep well plate*)
						{True,Except[ObjectP[]],Pipette}, Model[Container, Plate, "id:L8kPEjkmLbvW"](* 96-well 2mL Deep Well Plate *),

						(*If aliquot is true, pooled mix type is invert and aliquot container is not an object reference, return 2-mL tube*)
						{True,Except[ObjectP[]],Invert}, Model[Container, Vessel, "id:3em6Zv9NjjN8"](* 2mL Tube *),

						(*If aliquot is false, return Null*)
						{False,_,_}, Null,

						(*In all other cases return a 2mL deep well plate (catch-all)*)
						{Except[False],_,_}, Model[Container, Plate, "id:L8kPEjkmLbvW"](* 96-well 2mL Deep Well Plate *)
					];
					(*-- 3. POOLED INCUBATE OPTIONS RESOLUTION --*)

					(*First, get all the pooled mix related options*)
					{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime} =
							Lookup[myMapThreadOptions, {NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}];

					(*Option resolution switch depending on option values*)
					(*Note that we have already checked that the incubate options are compatible*)

					{resolvedPoolIncubate,resolvedIncubationTemperature,resolvedIncubationTime,resolvedAnnealingTime} = Switch[{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime},

						(*If pooled incubate is automatic or false and all other options are Automatic, no incubation*)
						{Automatic|False,Automatic,Automatic,Automatic},
						resolveAutomaticOptions[{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime},{False,Null,Null,Null}],

						(*If any of the incubation options are Null, resolve as if NestedIndexMatchingIncubate is False*)
						{_,Null,_,_},
						resolveAutomaticOptions[{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime},{False,Null,Null,Null}],

						{_,_,Null,_},
						resolveAutomaticOptions[{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime},{False,Null,Null,Null}],

						{_,_,_,Null},
						resolveAutomaticOptions[{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime},{False,Null,Null,Null}],

						(*For any other combination of options take the user specified values and resolve any automatic values to the default incubation*)
						{_,_,_,_},
						resolveAutomaticOptions[{unresolvedPooledIncubate,unresolvedIncubationTemperature,unresolvedIncubationTime,unresolvedAnnealingTime},{True,85*Celsius,5*Minute,3*Hour}]
					];

					(*-- 4. DETECTION REAGENT OPTIONS RESOLUTION --*)

					(*First, get all the detection reagent related options*)
					{unresolvedDetectionReagent, unresolvedDetectionReagentVol} = Lookup[myMapThreadOptions,{DetectionReagent, DetectionReagentVolume}];

					(*Then find the analyte type for each pool sample using our analyteTypeResolver helper function or user specified type*)
					analytes = Flatten@Lookup[poolPackets,Analytes];
					composition = Lookup[poolPackets,Composition][[All,All,2]];
					specifiedAnalyte = Lookup[myMapThreadOptions,AnalyteType];

					analytePackets = If[
						!MatchQ[analytes,{}|Null],
						Cases[DeleteDuplicates@Flatten@sampleAnalytePackets,KeyValuePattern[Object->Alternatives[Sequence@@Flatten@Download[analytes,Object]]]],
						Cases[DeleteDuplicates@Flatten@sampleIdentityModelPackets,KeyValuePattern[Object->Alternatives[Sequence@@Flatten@Download[composition,Object]]]]
					];

					analyteType = If[MatchQ[specifiedAnalyte,Automatic], Quiet[analyteTypeResolver[analytePackets]],specifiedAnalyte];

					(*If the detection reagent is specified, get the appropriate packet from the list of specified detection reagent packets for each pool sample.*)
					specifiedDetectionReagentPacket = Which[
						MatchQ[unresolvedDetectionReagent,ObjectP[Object[Sample]]], DeleteDuplicates[Cases[detectionReagentObjPackets,Object->unresolvedDetectionReagent]],
						MatchQ[unresolvedDetectionReagent,ObjectP[Model[Sample]]], DeleteDuplicates[Cases[detectionReagentModelPackets,Object->unresolvedDetectionReagent]],
						True, {}];

					(*Set the default detection reagent objects and concentration factors*)
					{defaultDetectionReagent,defaultDetectionReagentVolume }= Switch[{unresolvedDetectionReagent,analyteType,resolvedInstrument},

						(*If the detection reagent is Null, the default detection reagent volume will be Null regardless of analyte or instrument*)
						{Null,_,_},
						{Null,N[0*Microliter]},

						(*If the analyte type is Oligomer, the default reagent will be SYBR Gold*)
						{Except[Null],Oligomer,_},
						{Model[Sample, StockSolution, "id:3em6ZvLn86AB"](* 10X SYBR Gold in filtered 1X TBE Alternative Preparation *),reactionVolume/10},

						(*If the analyte type is Protein and the instrument is a thermocycler, the default reagent will be SYPRO Orange*)
						{Except[Null],Protein,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]},
						{Model[Sample, StockSolution, "id:zGj91a7ZK9An"](* 10X SYPRO Orange *),reactionVolume/2},

						(*If the analyte type is Protein and the instrument is a Uncle, there should be no detection reagent*)
						{Except[Null],Protein, ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]},
						{Null,N[0*Microliter]}
					];

					(*Option resolution where the default values are determined above using the resolved analyte type and instrument*)
					(*Note that we have already checked the detection reagent options are compatible*)

					{resolvedDetectionReagent,resolvedDetectionReagentVolume} = Switch[{unresolvedDetectionReagent,unresolvedDetectionReagentVol},
						(*If the detection reagent is specified but the volume is automatic, look up the concentration factor from the user specified reagent model packet.*)
						{ObjectP[{Model[Sample],Object[Sample],Model[Sample,StockSolution]}],_},
						resolveAutomaticOptions[{unresolvedDetectionReagent,unresolvedDetectionReagentVol}, {defaultDetectionReagent,reactionVolume/Lookup[specifiedDetectionReagentPacket,ConcentratedBufferDilutionFactor]}],

						(*In all other cases, take the user options and set any automatic options to defaults*)
						{Automatic|Null,_},
						resolveAutomaticOptions[{unresolvedDetectionReagent,unresolvedDetectionReagentVol}, {defaultDetectionReagent,defaultDetectionReagentVolume}]

					];

					(*If the resolved volume is not a number, set invalidDetectionReagentVolume = 1 *)
					(*This can happen in the case where the specified object does not have an associated model and therefore we cannot look up the concentration factor.*)
					invalidDetectionReagentVolume = If[!NumberQ[Unitless[resolvedDetectionReagentVolume]]&&MatchQ[resolvedDetectionReagent,ObjectP[]], True, False];

					(*-- 5. SAMPLE VOLUME AND BUFFER VOLUME RESOLUTION --*)

					(*First get the sample volume and buffer volume options.*)
					{unresolvedSampleVolume, unresolvedBufferVolume} = Lookup[myMapThreadOptions,{SampleVolume,BufferVolume}];

					(*Resolve the sample and buffer volumes according*)
					{resolvedSampleVolume,resolvedBufferVolume} = Switch[{unresolvedSampleVolume,unresolvedBufferVolume},

						(*If all options are automatic, default to zero buffer volume and sample volume is the difference between reaction volume and passive reference and detection reagent volumes.*)
						{Automatic,Automatic},
						{reactionVolume-(passiveReferenceVolume+resolvedDetectionReagentVolume), 0*Microliter},

						(*If sample volume is specified and buffer volume is automatic, buffer volume is the leftover reaction volume.*)
						{Except[Automatic],Automatic},
						{unresolvedSampleVolume, reactionVolume-(passiveReferenceVolume+resolvedDetectionReagentVolume+unresolvedSampleVolume)},

						(*If the buffer volume is specified but sample volume is automatic, sample volume is the leftover reaction volume.*)
						{Automatic,Except[Automatic]},
						{reactionVolume-(passiveReferenceVolume+resolvedDetectionReagentVolume+unresolvedBufferVolume),unresolvedBufferVolume},

						(*If both are specified return the specified values.*)
						{Except[Automatic],Except[Automatic]},
						{unresolvedSampleVolume,unresolvedBufferVolume}
					];

					(*Check that the resolved sample volume and buffer volume are greater than or equal to 0*)
					invalidSampleVolume = If[resolvedSampleVolume<0*Microliter,True,False];
					invalidBufferVolume = If[resolvedBufferVolume<0*Microliter,True,False];

					(*Check that all reaction components add up to the reaction volume*)
					invalidSampleReactionVolume = If[reactionVolume!=passiveReferenceVolume+resolvedSampleVolume+resolvedBufferVolume+resolvedDetectionReagentVolume,True,False];

					(*-- 6. BUFFER SAMPLE RESOLUTION --*)

					(*First get the buffer sample option*)
					unresolvedBuffer=Lookup[myMapThreadOptions,Buffer];

					(*Resolve the buffer sample according to the analyte type*)
					{resolvedBuffer}=Switch[{unresolvedBuffer,analyteType,resolvedBufferVolume},
						(*If the resolved buffer volume is 0, return Null*)
						{_,_,LessEqualP[0*Microliter]},
						{Null},

						(*If the analyte is a protein use 1X PBS*)
						{Automatic,Protein,GreaterP[0*Microliter]},
						{Model[Sample, StockSolution, "id:L8kPEjnmM03N"](* 1x PBS from 10x stock, pH 7 *)},

						(*For any other combination of options default to nuclease free water*)
						{_,_,GreaterP[0*Microliter]},
						resolveAutomaticOptions[{unresolvedBuffer},{Model[Sample, "id:O81aEBZnWMRO"](* Nuclease-free Water *)}]
					];

					(*-- 7. DILUTION CURVE VOLUME CALCULATIONS --*)
					(*First get the serial dilution and dilution options*)
					{serialDilution,dilution} = Lookup[myMapThreadOptions,{SerialDilutionCurve,DilutionCurve}];
					dilutionQ = MapThread[
						Xor[
						MatchQ[#1,Except[Null]],MatchQ[#2,Except[Null]]
						]&,
						{serialDilution,dilution}
					];

					(*Find how much of the pure sample we need. Either the sample volume or the aliquot volume*)
					requiredPureSampleVol = MapThread[If[aliquotBool&&#1, Max[resolvedSampleVolume,#2],resolvedSampleVolume]&,{dilutionQ,aliquotVolume}];

					(*Because the dilution options are index match to each sample instead of each pool we will need to mapthread over a flat list of the options and the pooled samples*)
					dilutionCurveList =	Flatten[MapThread[
						Function[{serialDilutionOption,dilutionOption,requiredPureSample},
							(*Use the helper function to calculate the dilution curve volumes*)
							 Switch[{serialDilutionOption,dilutionOption},
								{Null,Except[Null]}, {calculatedDilutionCurveVolumes[dilutionOption]},
								 (*the original serial dilution helper function adds the undiluted sample and a blank to the dilution curve after the resolver.
								 In this experiment, most use cases will not need a blank. If a blank is necessary it can be added as a separate sample or custom dilution.
								 Further, rather than adding an additional well for the undiluted sample such that total dilutions = NumberOfDilutions + 1,
								 we want total dilutions = NumberOfDilutions so we will take all except the last dilution output by the original helper function.*)
								{Except[Null],Null}, {
								 {
									 Most[Prepend[calculatedDilutionCurveVolumes[serialDilutionOption][[1]],SafeRound[Total[{First@calculatedDilutionCurveVolumes[serialDilutionOption][[1]],requiredPureSample}],0.1*Microliter]]],
									 Most[Prepend[calculatedDilutionCurveVolumes[serialDilutionOption][[2]],0*Microliter]]
								 }
							 },
								{Null,Null},{Null}
								]
					],
						{serialDilution,dilution,requiredPureSampleVol}
					],1];

					(*make output variable that splits it into dilution curve or serial dilution curve*)
					serialDilutionList =	Flatten[MapThread[
						Function[{serialDilutionOption,dilutionOption,dilutionCurve},
								Switch[{serialDilutionOption,dilutionOption},
									{Except[Null],Null}, {dilutionCurve},
									{Null,_}, {Null}
								]
						],
						{serialDilution,dilution,dilutionCurveList}
					],1];

					dilutionList =	Flatten[MapThread[
						Function[{serialDilutionOption,dilutionOption,dilutionCurve},
								Switch[{serialDilutionOption,dilutionOption},
									{Null,Except[Null]}, {dilutionCurve},
									{_,Null}, {Null}
								]
						],
						{serialDilution,dilution,dilutionCurveList}
					],1];

					(*Calculate the total number of wells needed for each sample*)
					requiredWellNum = Flatten[Map[
						Function[{dilutionCurve},
							If[MatchQ[dilutionCurve, Null],
								ReplaceAll[resolvedNumberOfReplicates, Null -> 1],
								ReplaceAll[resolvedNumberOfReplicates, Null -> 1] * Length[First@dilutionCurve]
							]
						],
						dilutionCurveList
					], 1];

					(*Calculate the smallest total dilution volume for error checking later*)
					minDilVolume =	Flatten[
						MapThread[
						Function[{serialDilCurve,dilutionCurve,aliquot,requiredPureSample},
							If[MatchQ[dilutionCurve,Null]&&MatchQ[serialDilCurve,Null],
								aliquot,
								If[MatchQ[dilutionCurve,Null],
									Min[Join[{requiredPureSample},Rest[Last[serialDilCurve]]]],
									Min[Total[dilutionCurve]]
								]
							]
						],
							{serialDilutionList,dilutionList,aliquotVolume,requiredPureSampleVol}
						], 1];

					(*-- 8. DILUTION OPTIONS RESOLUTION--*)

					(*First get the serial dilution or dilution curve options and the diluent options.*)
					{unresolvedDiluent,unresolvedDilutionMixRate,unresolvedMixNumber,unresolvedMixVol,unresolvedDilutionContainer} = Lookup[myMapThreadOptions,{Diluent,DilutionMixRate,DilutionNumberOfMixes,DilutionMixVolume,DilutionContainer}];

					(*MapThread over the options to resolve the dilution options for each sample within our pooled samples*)
					resolvedDilutionOptions = MapThread[
						Function[{diluent,dilMixRate,mixNum,mixVol,dilContainer,serialDilutionOption,dilutionOption,dilStorageCond,dilutionCurve,minDilVol,dilQ},
							Module[{defaultDiluent,defaultMixRate,defaultMixNumber,defaultMixVol,storageCondRules,defaultDilutionContainer,defaultDilutionStorageCondition},
								(*Set the dilution parameter defaults*)
								defaultDiluent = Switch[{analyteType},
									(*If the nested index matching sample analyteType is Oligomer use Nuclease-free Water*)
									{Oligomer}, Model[Sample, "id:O81aEBZnWMRO"](* Nuclease-free Water *),
									(*If the nested index matching sample analyteType is Protein use 1X PBS*)
									{Protein}, Model[Sample, StockSolution, "id:L8kPEjnmM03N"](* 1x PBS from 10x stock, pH 7 *)
								];

								defaultMixRate = 100 Microliter/Second;

								defaultMixNumber = 5;

								(*Set the default mix volume to half the max dilution volume or the min dilution volume, whichever is smaller.*)
								(*If there is not a dilution curve just give 0.*)
								maxDilVol = If[dilQ,Max[Total[Transpose@dilutionCurve]],0*Microliter];

								defaultMixVol =  If[dilQ,Min[0.5*maxDilVol,minDilVol],0*Microliter];

								(*Set the default container to the preferred container that can accommodate the max volume and is grouped by the storage condition*)
								(*Create grouping index rules*)
								storageCondRules = MapThread[#2 ->#1 &, {Range[1, 1+Length[List@@SampleStorageTypeP]], Join[{Disposal},List@@SampleStorageTypeP]}];

								(*set default*)
								defaultDilutionContainer = {1,Model[Container, Plate, "id:L8kPEjkmLbvW"](* 96-well 2mL Deep Well Plate *)};

								(*set default storage condition*)

								defaultDilutionStorageCondition = Disposal;

								(*Resolve the dilution options*)

								(*Note that we have already error checked for too many dilutions, dilution parameter, and dilution mix volume compatibility*)
								Switch[{serialDilutionOption,dilutionOption},

									(*If dilution curves are not specified default to Null for dilution parameters*)
									{Null,Null},
									resolveAutomaticOptions[{diluent,dilMixRate,mixNum,mixVol,dilContainer,dilStorageCond},{Null,Null,Null,Null,Null,Null}],

									(*If any dilution curve is specified default to the values set above or take user specified values*)
									{_,_},
									resolveAutomaticOptions[{diluent,dilMixRate,mixNum,mixVol,dilContainer,dilStorageCond},{defaultDiluent,defaultMixRate,defaultMixNumber,defaultMixVol,defaultDilutionContainer,defaultDilutionStorageCondition}]
								]
							]
						]
						,{unresolvedDiluent,unresolvedDilutionMixRate,unresolvedMixNumber,unresolvedMixVol,unresolvedDilutionContainer,serialDilution,dilution,Lookup[myMapThreadOptions,DilutionStorageCondition],dilutionCurveList,minDilVolume,dilutionQ}
					];

					(*Gather the resolved dilution options*)
					resolvedDiluent = resolvedDilutionOptions[[All,1]];
					resolvedDilutionMixRate = resolvedDilutionOptions[[All,2]];
					resolvedDilutionMixNumber = resolvedDilutionOptions[[All,3]];
					resolvedDilutionMixVol = resolvedDilutionOptions[[All,4]];
					resolvedDilutionContainer = resolvedDilutionOptions[[All,5]];
					resolvedDilutionStorageCondition = resolvedDilutionOptions[[All,6]];

					(*MapThread to error check the resolved dilution options for each sample*)
					invalidDilutionOptions = MapThread[
						Function[{serialDilutionOption,dilutionOption,dilutionCurve,dilMixVol,dilContainer,minDilVol,aliquotAmount},
							Module[{invalidDilMixVol,invalidDilContainer,maxDilutionContainerVol,invalidDilVolume},
						(*Check that the dilution mix volume is less than the smallest dilution volume*)
					invalidDilMixVol = If[!MatchQ[serialDilutionOption,Null]||!MatchQ[dilutionOption,Null],
						If[!MatchQ[dilMixVol,Null]&&(dilMixVol>minDilVol), True, False],
						False
					];

					(*Check that the max dilution volume does not exceed the recommended dilution container volume*)
					(*Get the recommended volume for the resolved dilution container*)
					dilutionContainer = If[MatchQ[dilContainer,ObjectP[]]||MatchQ[dilContainer,Null],dilContainer,dilContainer[[2]]];
					maxDilutionContainerVol = Sequence@@Lookup[Cases[Flatten@Union[dilutionContainerObjectPackets,dilutionContainerModelPackets],KeyValuePattern[Object->Download[dilutionContainer,Object]]],RecommendedFillVolume];
					invalidDilContainer = If[!MemberQ[dilContainer,Null]&&maxDilutionContainerVol<Max[Total[dilutionCurve]],True,False];

					(*Check that the min dilution volume is large enough to fulfill the pooling aliquot volume. No sample should be below the absolute minimum required by either instrument 10*uL*)
					invalidDilVolume = If[MatchQ[aliquotAmount,VolumeP]&&MatchQ[minDilVol,VolumeP],aliquotAmount>minDilVol,False];

					{invalidDilMixVol,invalidDilContainer,invalidDilVolume}
								]
						],
						{serialDilution,dilution,dilutionCurveList,resolvedDilutionMixVol,resolvedDilutionContainer,minDilVolume,aliquotVolume}
					];

					(*Check that if the sample is pooled with another sample, the dilution curve lengths match or the pooling partner is not diluted*)

					(*generate a list of dilution lengths - replace Nulls with {{}}*)
					dilutionCurveListNoNulls = dilutionCurveList/.Null->{{}};
					dilutionLengths = Length/@dilutionCurveListNoNulls[[All,1]];

					(*Check that all the dilution lengths are equal or 0*)
					invalidPooledDilution = !AllTrue[dilutionLengths,EqualQ[#,FirstCase[dilutionLengths,GreaterP[0]]]||EqualQ[#,0]&];

					(*Gather invalid dilution options*)
					invalidDilutionMixVol = invalidDilutionOptions[[All,1]];
					invalidDilutionContainer = invalidDilutionOptions[[All,2]];
					invalidDilutionVolume = invalidDilutionOptions[[All,3]];

					(*-- 9. DETECTION OPTIONS RESOLUTION --*)
					(*First get all detection related parameters*)
					{unresolvedFluorFilter,unresolvedSLSFilter,unresolvedExWavelength,
						unresolvedEmWavelength,unresolvedMinEm,unresolvedMaxEm,unresolvedSLSEx}=
							Lookup[myMapThreadOptions, {FluorescenceLaserPower,StaticLightScatteringLaserPower,ExcitationWavelength,
								EmissionWavelength,MinEmissionWavelength,MaxEmissionWavelength,StaticLightScatteringExcitationWavelength}];

					(*Set default values depending on resolved instrument, analyte, and resolved detection reagent*)

					(*Assign default laser power filters*)
					{fluorescenceFilter, slsFilter} = Switch[{resolvedInstrument},

						(*If the instrument is a thermocycler, set to null*)
						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]}, {Null,Null},

						(*If the instrument is a multimodespectrophotometer, set fluorescence laser power to 50% and SLS laser power to 25%*)
						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, {50*Percent,25*Percent}
					];

					(*Assign default excitation wavelength *)
					(*First get the resolved detection reagent composition*)

					(*combine all packets*)
					allCompositionPackets = Union[detectionReagentModelPackets,detectionReagentObjCompositionPackets,possibleDetectionReagentModelPackets];
					allIMPackets = Union[detectionReagentObjIdentityModelPackets,detectionReagentIdentityModelPackets,possibleDetectionReagentIdentityModelPackets];

					(*Look up the resolved reagent composition packet and format it into a list of object references (not links)*)
					detectionReagentObjectRef = Download[resolvedDetectionReagent,Object];

					resolvedDetectionReagentCompLinks = If[MatchQ[resolvedDetectionReagent,Null|{}],
						{Null},
						Lookup[Cases[Flatten@allCompositionPackets,KeyValuePattern[Object->detectionReagentObjectRef]],Composition][[All,All,2]]
					];

					resolvedDetectionReagentComp = Flatten@Download[resolvedDetectionReagentCompLinks,Object];

					(*Look up all the identity models for the resolved detection reagent*)
					resolvedDetectionReagentPacket = Cases[Flatten@allIMPackets,KeyValuePattern[Object->Alternatives@@Download[resolvedDetectionReagentComp,Object]]];

					(*Find the smallest excitation maximum in the case that the dye is made up of more than one fluorophore*)
					reagentExMax =If[MatchQ[resolvedDetectionReagent,ObjectP[]], Min[Flatten@Lookup[resolvedDetectionReagentPacket,FluorescenceExcitationMaximums]], Null];

					(*Get the resolved instrument excitation wavelengths*)
					instrumentExWavelengths = Switch[{resolvedInstrument},

						(*If the instrument is a thermocycler, lookup excitationfilters field*)
						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]},  Lookup[resolvedInstrumentPacket,ExcitationFilters][[All,All,1]],

						(*If the instrument is a multimodespectrophotometer, lookup the fluorescenceexcittationwavelengths field*)
						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, Lookup[resolvedInstrumentPacket,FluorescenceWavelengths]
					];

					(*Find the instrument excitation that is closest to and less than the detection reagent excitation max. Use this as the default Excitation Wavelength*)
					defaultEx = If[MatchQ[reagentExMax,Null|{}|Infinity],N[266*Nanometer],Max[Sort[Select[Flatten@instrumentExWavelengths,#<=reagentExMax&]]]];

					(*Assign default emission wavelength *)

					(*Find the largest emission maximum in the case that the dye is made up of more than one fluorophore*)
					reagentEmMax = If[MatchQ[resolvedDetectionReagent,ObjectP[]],Max[Flatten@Lookup[resolvedDetectionReagentPacket,FluorescenceEmissionMaximums]],Null];

					(*Get the resolved instrument emission wavelengths*)
					instrumentEmWavelengths = Switch[{resolvedInstrument,resolvedDetectionReagent},

						(*If the instrument is a thermocycler, lookup excitationfilters field*)
						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}],ObjectP[]},  Lookup[resolvedInstrumentPacket,EmissionFilters][[All,All,1]],

						(*If the instrument is a multimodespectrophotometer, give the reagent max since the uncle can resolve any em wavelength between 250nm and 720nm*)
						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}],ObjectP[]}, {If[MatchQ[reagentExMax,Null],720*Nanometer,Min[reagentEmMax,720*Nanometer]]},

						(*If the instrument is a multimodespectrophotometer and the detection reagent is null, give the instrument max 720*)
						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}],Null}, {Null}
					];

					(*Find the instrument emission filter that is closest to and greater than the detection reagent emission max. Use this as the default Emission Wavelength*)
					defaultEm =If[MatchQ[reagentEmMax,Null|{}|-Infinity],Null, Min[Sort[Select[Flatten@instrumentEmWavelengths,#>=reagentEmMax&]]]];

					(*Assign default MinEm and MaxEm depending on instrument*)
					{defaultMinEm,defaultMaxEm} = Switch[{resolvedInstrument},

						(*If the instrument is a thermocycler, set both to Null*)
						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]},  {Null,Null},

						(*If the instrument is a multimodespectrophotometer, set to {250nm,720nm}*)
						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, {N[250*Nanometer],N[720*Nanometer]}
					];

					(*Assign default SLS excitation wavelength depending on instrument*)
					defaultSLSEx = Switch[{resolvedInstrument},

						(*If the instrument is a thermocycler, set to Null*)
						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]},  Null,

						(*If the instrument is a multimodespectrophotometer, set to {266nm,473nm}*)
						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, {N[266*Nanometer],N[473*Nanometer]}
					];

					(*Resolve detection parameters*)
					{resolvedFluorFilter,resolvedSLSFilter,resolvedExWavelength,resolvedSLSEx} = resolveAutomaticOptions[{unresolvedFluorFilter,unresolvedSLSFilter,unresolvedExWavelength,unresolvedSLSEx},{fluorescenceFilter,slsFilter,defaultEx,defaultSLSEx}];

					(*Resolve Emission parameters*)
					resolvedEmissionDetection = Switch[{unresolvedEmWavelength,unresolvedMinEm,unresolvedMaxEm,resolvedInstrument},

						(*If all emission options are automatic and the instrument is Uncle, set emission dafaults to default emission range*)
						{Automatic,Automatic,Automatic,ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]},
						resolveAutomaticOptions[{unresolvedMinEm,unresolvedMaxEm},{defaultMinEm,defaultMaxEm}],

						(*If all emission options are automatic and instrument is ViiA 7, set emission defaults to default emission wavelength*)
						{Automatic,Automatic,Automatic,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]},
						resolveAutomaticOptions[{unresolvedEmWavelength},{defaultEm}],

						(*If min emission wavelength is null, resolve EmissionWavelength*)
						{_,Null,_,_},
						resolveAutomaticOptions[{unresolvedEmWavelength},{defaultEm}],

						(*If max emission wavelength is null, resolve EmissionWavelength*)
						{_,_,Null,_},
						resolveAutomaticOptions[{unresolvedEmWavelength},{defaultEm}],

						(*If EmissionWavelength is Null, resolve emission wavelength range*)
						{Null,_,_,_},
						resolveAutomaticOptions[{unresolvedMinEm,unresolvedMaxEm},{defaultMinEm,defaultMaxEm}],

						(*If min emission is specified, resolve the emission range*)
						{_,Except[Automatic|Null],_,_},
						resolveAutomaticOptions[{unresolvedMinEm,unresolvedMaxEm},{defaultMinEm,defaultMaxEm}],

						(*If max emission is specified, resolve the emission range*)
						{_,_,Except[Automatic|Null],_},
						resolveAutomaticOptions[{unresolvedMinEm,unresolvedMaxEm},{defaultMinEm,defaultMaxEm}],


						(*Catch all*)
						{_,_,_,_},
						resolveAutomaticOptions[{unresolvedEmWavelength},{defaultEm}]
					];

					(*Get outputs*)
					{resolvedMinEm,resolvedMaxEm,resolvedEmWavelength}=Switch[Length[resolvedEmissionDetection],
						GreaterP[1], {Min[resolvedEmissionDetection],Max[resolvedEmissionDetection],Null},
						EqualP[1], {Null,Null,Sequence@@resolvedEmissionDetection}
					];

					(*Detection parameter error checking variables*)

					(*Check that if the instrument is ViiA 7, resolvedFluorFilter,resolvedSLSFilter,resolvedSLSEx are Null.*)
					invalidThermocyclerOption = If[MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]]&&MemberQ[{resolvedFluorFilter,resolvedSLSFilter,resolvedSLSEx},Except[Null]],True,False];

					(*Check that if the instrument is ViiA 7, resolvedEmissionDetection is a single number not a range.*)
					invalidEmissionRange = If[MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]]&&Length[resolvedEmissionDetection]>1,True,False];

					(*Check that if the instrument is Uncle, resolvedFluorFilter,resolvedSLSFilter,resolvedSLSEx are not Null.*)
					invalidMMSpecOption = If[MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]]&&MemberQ[{resolvedFluorFilter,resolvedSLSFilter,resolvedSLSEx},Null],True,False];

					(*Check that resolvedExWavelength and resolvedEmissionDetection are all numbers.*)
					invalidExcitationWavelength = If[!MatchQ[QuantityMagnitude[resolvedExWavelength],_Real|_Integer],True,False];

					invalidEmissionWavelength =If[!MatchQ[QuantityMagnitude[resolvedEmissionDetection],Alternatives[_Real|_Integer,{_Real|_Integer},{(_Real|_Integer)..}]],True,False];

					(*Check that the excitation wavelength is within the instrument operating capabilities*)
					incompatibleExcitationWavelength = If[!MemberQ[Round@Flatten@instrumentExWavelengths,Round@resolvedExWavelength],True,False];

					(*Check that the emission wavelength or emission range is within the instrument operating limits*)
					incompatibleEmissionOption = Switch[{resolvedInstrument,Length[resolvedEmissionDetection]},

						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}],GreaterP[1]},  False,

						{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}],LessEqualP[1]}, !MemberQ[Round@Flatten@instrumentEmWavelengths,Round@First@resolvedEmissionDetection],

						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}],GreaterP[1]}, !IntervalMemberQ[Interval[{250*Nanometer,720*Nanometer}],Interval[Round@resolvedEmissionDetection]],

						{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}],LessEqualP[1]}, !Between[{250*Nanometer,720*Nanometer},Round@First@resolvedEmissionDetection]

					];

					(*Resolve LaserOptimizationEmissionWavelengthRange and LaserOptimizationTargetEmissionIntensityRange*)

					(*Look up the options*)
					{unresolvedOptiWavelengthRange, unresolvedOptiIntensityRange,optiFluorescenceLaser} = Lookup[myMapThreadOptions,{LaserOptimizationEmissionWavelengthRange,LaserOptimizationTargetEmissionIntensityRange,OptimizeFluorescenceLaserPower}];
					{resolvedLaserOptiWavelength,resolvedLaserOptiIntensity} = Switch[
						{resolvedInstrument,optiFluorescenceLaser},
						{ObjectP[{Object[Instrument,Thermocycler],Model[Instrument,Thermocycler]}],_},
							resolveAutomaticOptions[{unresolvedOptiWavelengthRange, unresolvedOptiIntensityRange},{Null,Null}],

						{ObjectP[{Object[Instrument,MultimodeSpectrophotometer],Model[Instrument,MultimodeSpectrophotometer]}], True},
							resolveAutomaticOptions[{unresolvedOptiWavelengthRange, unresolvedOptiIntensityRange},{300*Nanometer;;450*Nanometer,5 Percent;;20 Percent}],

						{ObjectP[{Object[Instrument,MultimodeSpectrophotometer],Model[Instrument,MultimodeSpectrophotometer]}], False},
						resolveAutomaticOptions[{unresolvedOptiWavelengthRange, unresolvedOptiIntensityRange},{Null,Null}]
					];

					(*If the resolved instrument is a thermocycler and the resolved options are not Null, invalidLaserOptiOption is True*)
					invalidLaserOptiOption = Switch[
						{resolvedInstrument,resolvedLaserOptiWavelength,resolvedLaserOptiIntensity},
						{ObjectP[{Object[Instrument,Thermocycler],Model[Instrument,Thermocycler]}],_,Except[Null]},
							True,
						{ObjectP[{Object[Instrument,Thermocycler],Model[Instrument,Thermocycler]}],Except[Null],_},
						True,
							_,False];

					(*If the OptimizeFluorescenceLaserPower is False and the resolved options are not Null, unused options is True*)
					unusedOptimizationOption = Switch[
						{optiFluorescenceLaser,resolvedLaserOptiWavelength,resolvedLaserOptiIntensity},
						{False,_,Except[Null]},
						True,
						{False,Except[Null],_},
						True,
						_,False];

					(*Gather Map thread resolved options*)
					{targetContainer,resolvedSampleVolume,resolvedBuffer,resolvedBufferVolume,resolvedDetectionReagent,resolvedDetectionReagentVolume,invalidDetectionReagentVolume,
						dilutionList,serialDilutionList,resolvedDiluent,resolvedDilutionMixRate,resolvedDilutionContainer,resolvedDilutionMixVol,resolvedDilutionMixNumber,
						resolvedPoolMix,resolvedPooledMixType,resolvedMixNumber,resolvedMixVolume,
						resolvedPoolIncubate,resolvedIncubationTime,resolvedIncubationTemperature,resolvedAnnealingTime,
						resolvedFluorFilter,resolvedSLSFilter,resolvedEmissionDetection,resolvedMinEm,resolvedMaxEm,resolvedEmWavelength,resolvedExWavelength,resolvedSLSEx,
						invalidPoolMixVolume,invalidDetectionReagentVolume,invalidSampleVolume,invalidBufferVolume,invalidDilutionMixVol,
						invalidDilutionContainer,invalidThermocyclerOption,invalidMMSpecOption,invalidEmissionRange,invalidExcitationWavelength,invalidEmissionWavelength,incompatibleExcitationWavelength,incompatibleEmissionOption,
						requiredWellNum,invalidDilutionVolume,resolvedLaserOptiWavelength,resolvedLaserOptiIntensity,invalidLaserOptiOption,unusedOptimizationOption,invalidSampleReactionVolume,invalidPooledDilution,resolvedDilutionStorageCondition}
				]
			],
			{myPooledSamples,mapThreadFriendlyOptions,aliquotBools,aliquotContainers,aliquotVol,pooledSamplePackets}
		]
	];

	(*Resolve melting curve options*)
	(*First get all melting curve related parameters*)
	{minTemp,maxTemp,rampOrder,equilibrationTime,unresolvedCycleNum,unresolvedRampType,
		unresolvedRampRate,unresolvedRampResolution,unresolvedStepNum,unresolvedStepHold} = Lookup[roundedThermalShiftOptions,{MinTemperature,MaxTemperature,TemperatureRampOrder,EquilibrationTime,NumberOfCycles,TemperatureRamping,TemperatureRampRate,TemperatureResolution,NumberOfTemperatureRampSteps,StepHoldTime}];

	(*Set default parameter values depending on option values. These are the values that the options will take if the user has left them Automatic. Otherwise we will take the user specification.*)
	defaultCycleNum = Switch[{Length[rampOrder]},

		(*If the TemperatureRampOrder is specified to be more than the default {Heating,Cooling}, set to the length of TemperatureRampOrder/2*)
		{GreaterP[2]}, Length[rampOrder]/2,

		(*In all other cases, set to 0.5 such that only a heating cycle or only a cooling cycle is executed.*)
		{_}, 0.5
	];

	(*Lookup the resolved instrument's max ramp rate. This is the default rate for Step ramps.*)
	instrumentMaxRate = Sequence@@Lookup[resolvedInstrumentPacket,MaxTemperatureRamp];

	(*Calculate the default number of steps given the temperature range. We will default to measuring at every 1 degree increment.*)
	stepNum = Unitless@(maxTemp-minTemp);

	(*Set the linear and step defaults at the same time since they are dependent on each other*)
	{defaultRampType, defaultRampRate, defaultStepNum, defaultStepHold} = Switch[{unresolvedRampType,unresolvedRampResolution,unresolvedStepNum,unresolvedStepHold},

		(*If a step ramp is specified, set default to Step and max resolved instrument rate*)
		{Step,_,_,_}, {Step,instrumentMaxRate,stepNum,30*Second},

		(*If a step ramp option is specified, set default to Step and max resolved instrument rate*)
		{Except[Linear],_,Except[Automatic|Null],_}, {Step,instrumentMaxRate,stepNum,30*Second},

		(*If a step ramp option is specified, set default to Step and max resolved instrument rate*)
		{Except[Linear],_,_,Except[Automatic|Null]}, {Step,instrumentMaxRate,stepNum,30*Second},

		(*If the linear option TemperatureResolution is Automatic or specified, set the default to Linear and the rate to 1C/Minute.*)
		{Except[Step],Except[Null],_,_}, {Linear,1*Celsius/Minute,Null,Null},

		(*If the linear option TemperatureResolution is Automatic or specified, set the default to Linear and the rate to 1C/Minute.*)
		{Except[Step],_,_,_}, {Linear,1*Celsius/Minute,Null,Null}
	];

	(*Resolve melting curve parameters*)
	{resolvedCycleNum,resolvedRampType,resolvedRampRate,resolvedStepNum,resolvedStepHold} = resolveAutomaticOptions[{unresolvedCycleNum,unresolvedRampType,unresolvedRampRate,unresolvedStepNum,unresolvedStepHold}, {defaultCycleNum,defaultRampType,defaultRampRate,defaultStepNum,defaultStepHold}];

	(*Resolve temperature resolution option*)
	(*First calculate the maximum resolution achievable given the number of samples and ramp rate *)
	totalReadTime = Total[Flatten@requiredWells]*(3.4*Second);
	maxRes = Round[Convert[resolvedRampRate,Celsius/Second]*Convert[totalReadTime,Second],0.001];

	{resolvedTempResolution} = Switch[{Download[resolvedInstrument,Object]},

		(*If the instrument is Uncle, resolve to the maxRes or take user specification*)
		{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, resolveAutomaticOptions[{unresolvedRampResolution},{maxRes}],

		(*If the instrument is ViiA 7, resolve to Null*)
		{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]}, resolveAutomaticOptions[{unresolvedRampResolution},{Null}]
	];

	(* -- Resolve the DLS-related options  -- *)
	(* - DynamicLightScatteringMeasurements - *)
	resolvedDynamicLightScatteringMeasurements=Switch[{dynamicLightScatteringMeasurementsOption,dynamicLightScatteringOption},

		(* If the user has specified the DynamicLightScatteringMeasurements, we accept it *)
		{Except[Automatic],_},
			dynamicLightScatteringMeasurementsOption,

		(* Otherwise, we resolve based on the DynamicLightScattering Option *)
		{Automatic,False},
			Null,
		{Automatic,True},
			{Before,After}
	];

	(* - DynamicLightScatteringMeasurementTemperatures - *)
	(*First find the start temperature and end temperature for use later*)
	startTemp = Switch[First[rampOrder],
		(*If start on a heating cycle the temperature will be the minTemp*)
		Heating, minTemp,
		(*If we start on a cooling cycle the temperature will be the maxTemp*)
		Cooling, maxTemp
	];

	(* We are taking Mod of 1 to essentially determine if we are using a whole number or a fraction. Fraction means
	 that the end temperature is different from the initial while a whole cycle cycles back to the initial temperature. *)
	endTemp = Switch[If[Mod[resolvedCycleNum,1]==0.5, First[rampOrder], Last[rampOrder]],
		(*If we end on a Heating cycle the temperature will be the maxTemp*)
		Heating, maxTemp,
		(*If we end on a Coooling cycle the temperature will be the minTemp*)
		Cooling, minTemp
	];

	resolvedDynamicLightScatteringMeasurementTemperatures=Switch[{dynamicLightScatteringTemperatureOption,resolvedDynamicLightScatteringMeasurements},

		(* If the user has specified the DynamicLightScatteringMeasurementTemperatures, we accept it *)
		{Except[Automatic],_},
		Flatten@{dynamicLightScatteringTemperatureOption},

		(* Otherwise, we resolve based on the DynamicLightScatteringMeasurements Option *)
		{Automatic,{Before}}, {startTemp},

		{Automatic,{After}}, {endTemp},

		{Automatic,{Before,After}}, {startTemp, endTemp},

		{_,_}, Null

	];

	(* - NumberOfDynamicLightScatteringAcquisitions - *)
	resolvedNumberOfDynamicLightScatteringAcquisitions=Switch[{numberOfDynamicLightScatteringAcquisitionsOption,dynamicLightScatteringOption},

		(* If the user has specified the NumberOfDynamicLightScatteringAcquisitions, we accept it *)
		{Except[Automatic],_},
			numberOfDynamicLightScatteringAcquisitionsOption,

		(* Otherwise, we resolve based on the DynamicLightScattering Option *)
		{Automatic,False},
			Null,
		{Automatic,True},
			4
	];

	(* - DynamicLightScatteringAcquisitionTime - *)
	resolvedDynamicLightScatteringAcquisitionTime=Switch[{dynamicLightScatteringAcquisitionTimeOption,dynamicLightScatteringOption},

		(* If the user has specified the DynamicLightScatteringAcquisitionTime, we accept it *)
		{Except[Automatic],_},
			dynamicLightScatteringAcquisitionTimeOption,

		(* Otherwise, we resolve based on the DynamicLightScattering Option *)
		{Automatic,False},
			Null,
		{Automatic,True},
			5*Second
	];

	(* - AutomaticDynamicLightScatteringLaserSettings - *)
	resolvedAutomaticDynamicLightScatteringLaserSettings=Switch[
		{
			automaticDynamicLightScatteringLaserSettingsOption,dynamicLightScatteringOption,dynamicLightScatteringLaserPowerOption,
			dynamicLightScatteringDiodeAttenuationOption
		},

		(* If the user has specified the AutomaticDynamicLightScatteringLaserSettings, we accept it *)
		{Except[Automatic],_,_,_},
			automaticDynamicLightScatteringLaserSettingsOption,

		(* If the DynamicLightScattering option is False, we resolve to Null *)
		{Automatic,False,_,_},
			Null,

		(* If DynamicLightScattering option is True, and neither of the LaserPower/DiodeAttenuation options has been specified, resolve to True *)
		{Automatic,True,Alternatives[Automatic,Null],Alternatives[Automatic,Null]},
			True,

		(* Otherwise (DLS is True and user has specified LaserPower or DiodeAttenuation), resolve to False *)
		{Automatic,True,_,_},
			False
	];

	(* - DynamicLightScatteringLaserPower - *)
	resolvedDynamicLightScatteringLaserPower=Switch[{dynamicLightScatteringLaserPowerOption,resolvedAutomaticDynamicLightScatteringLaserSettings},

		(* If the user has specified the DynamicLightScatteringLaserPower, we accept it *)
		{Except[Automatic],_},
			dynamicLightScatteringLaserPowerOption,

		(* Otherwise, we resolve based on the resolvedAutomaticDynamicLightScatteringLaserSettings *)
		{Automatic,Alternatives[True,Null]},
			Null,
		{Automatic,False},
			100*Percent
	];

	(* - DynamicLightScatteringDiodeAttenuation - *)
	resolvedDynamicLightScatteringDiodeAttenuation=Switch[{dynamicLightScatteringDiodeAttenuationOption,resolvedAutomaticDynamicLightScatteringLaserSettings},

		(* If the user has specified the DynamicLightScatteringDiodeAttenuation, we accept it *)
		{Except[Automatic],_},
			dynamicLightScatteringDiodeAttenuationOption,

		(* Otherwise, we resolve based on the resolvedAutomaticDynamicLightScatteringLaserSettings *)
		{Automatic,Alternatives[True,Null]},
			Null,
		{Automatic,False},
			100*Percent
	];

	(* - DynamicLightScatteringDiodeAttenuation - *)

	(* - DynamicLightScatteringCapillaryLoading - *)
	resolvedDynamicLightScatteringCapillaryLoading=Switch[{Download[resolvedInstrumentModel,Object], dynamicLightScatteringCapillaryLoadingOption},
		(* If the instrument Model[Instrument, Thermocycler, "ViiA 7"] or Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] is used then DynamicLightScatteringCapillaryLoading is not used *)
		{Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"]|Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"], _},
		Null,
		(* If the user has specified the DynamicLightScatteringCapillaryLoading, we accept it *)
		{Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"], Except[Automatic]},
		dynamicLightScatteringCapillaryLoadingOption,

		(* Otherwise, we resolve based on the resolvedInstrumentModel *)
		{Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"], Automatic},
		Manual
	];
	(* - DynamicLightScatteringCapillaryLoading - *)

	(*-- RESOLVED OPTIONS ERROR CHECKING --*)

	(*MapThread Options*)

	(*1. Throw an error for any sample pools where the mix volume is greater than the available pool volume*)

	(*Retrieve the sample pool and group in a list with the resolved pooledmixvolumes*)
	sampleOptionList = Transpose[{myPooledSamples,pooledMixVolumes}];

	(*Find the invalid volumes using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidPoolMixVolumes];
	invalidPoolMixVolOptions=If[Length@invalidSampleOptionList>0,{NestedIndexMatchingMixVolume},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidPoolMixVolumes,ObjectToString[invalidSampleOptionList]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidPoolMixVolumeTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved pool mix volumes are less than the available nested index matching sample volume for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" :", True, False],
								Nothing
							];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved pool mix volumes are less than the available nested index matching sample volume for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*2. Throw an error for any sample pools where the detection reagent volume could not be resolved*)

	(*Retrieve the sample pool and group in a list with the resolved detection reagent*)
	sampleOptionList = Transpose[{myPooledSamples,detectionReagents}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidDetectionReagentVolumes];
	invalidDetectionReagentOption = If[Length@invalidSampleOptionList>=1,{DetectionReagent,DetectionReagentVolume},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidDetectionReagentVolumes,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidDetectionReagentVolumesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our detection reagent volumes could be resolved for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our detection reagent volumes could be resolved for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*3. Throw an error for any sample pools where the resolved sample volume is negative*)

	(*Retrieve the sample pool and group in a list with the resolved sample volume*)
	sampleOptionList = Transpose[{myPooledSamples,sampleVolumes}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidSampleVolumes];
	invalidSampleVolOption = If[Length@invalidSampleOptionList>0,{SampleVolume},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidSampleVolumes,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidSampleVolumesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our sample volumes could be resolved for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our sample volumes could be resolved for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*4. Throw an error for any sample pools where the resolved buffer volume is negative*)

	(*Retrieve the sample pool and group in a list with the resolved buffer volume*)
	sampleOptionList = Transpose[{myPooledSamples,bufferVolumes}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidBufferVolumes];
	invalidBufferVolOption = If[Length@invalidSampleOptionList>0,{BufferVolume},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidBufferVolumes,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidBufferVolumesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our buffer volumes could be resolved for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our buffer volumes could be resolved for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*5. Throw an error for any sample where the smallest dilution volume is less than the aliquot pooling volume*)

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidDilutionVolSamples = PickList[Flatten@myPooledSamples,Flatten@invalidDilutionVolumes];
	invalidDilutionVolOption = If[Length@invalidDilutionVolSamples>0,{AliquotAmount},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidDilutionVolSamples]>0&&messages,Message[Error::InsufficientDilutionVolume,ObjectToString[invalidDilutionVolSamples,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidRequiredSamplesVolumesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidDilutionVolSamples]>0,
								Test["Our required sample volume is less than or equal to the available nested index matching volume for the inputs "<>ObjectToString[invalidDilutionVolSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidDilutionVolSamples]==0,
								Test["Our required sample volume is less than or equal to the available nested index matching volume for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*6. Throw an error for any samples where the dilution mix volume exceeds the smallest dilution volume*)

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidDilutionMixSamples = PickList[Flatten@myPooledSamples,Flatten@invalidDilutionMixVols];
	invalidDilutionMixVolOption = If[Length@invalidDilutionMixSamples>0,{DilutionMixVolume},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidDilutionMixSamples]>0&&messages,Message[Error::InvalidDilutionMixVolumes,ObjectToString[invalidDilutionMixSamples,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidDilutionMixVolumesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidDilutionMixSamples]>0,
								Test["Our required dilution mix volume is less than or equal to the smallest dilution volume for the inputs "<>ObjectToString[invalidDilutionMixSamples,Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidDilutionMixSamples]==0,
								Test["Our required dilution mix volume is less than or equal to the smallest dilution volume for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*7. Throw an error for any sample pools where the largest dilution volume exceeds the dilution container max volume*)

		(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[Flatten@myPooledSamples,Flatten@invalidDilutionContainers];
	invalidDilutionContainerOption = If[Length@invalidSampleOptionList>0,{DilutionContainer},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidDilutionContainers,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidDilutionContainersTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved dilution container can accomodate the largest dilution volume for the inputs "<>ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved dilution container can accomodate the largest dilution volume for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*8. Throw an error for any sample pools where the resolved detection options are not valid for the resolved instrument*)

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[myPooledSamples,invalidThermocyclerOptions];
	invalidThermocyclerOption = If[Length@invalidSampleOptionList>0,{FluorescenceLaserPower,StaticLightScatteringLaserPower,StaticLightScatteringExcitationWavelength},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidThermocyclerOptions,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation],"Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"]"],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidThermocyclerOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved detection parameters for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved detection parameters for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*9. Throw an error for any sample pools where the emission range is specified when the instrument is a thermocycler*)

	(*Retrieve the sample pool and group in a list with the emission range*)
	sampleOptionList = Transpose[{myPooledSamples,emissionParameters}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidEmissionRanges];
	invalidThermocyclerEmissionsOption = If[Length@invalidSampleOptionList>0,{MinEmissionWavelength,MaxEmissionWavelength},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidEmissionRange,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidResolvedEmissionRangeTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved emission range for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved emission range for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*10. Throw an error for any sample pools where the laser powers and SLS options are Null but the instrument is a multimode spectrophotometer*)

	(*Retrieve the sample pool and group in a list with the detection parameters*)
	sampleOptionList = Transpose[{myPooledSamples,fluorescenceFilters,slsFilters,slsExcitationWavelengths}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidMMSpecOptions];
	invalidMultiModeSpecOption = If[Length@invalidSampleOptionList>0,{FluorescenceLaserPower,StaticLightScatteringLaserPower,StaticLightScatteringExcitationWavelength},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidMultiModeSpectrometerOptions,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidMMSpecOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved laser power settings and SLS excitation for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved laser power settings and SLS excitaiton for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*11. Throw an error for any sample pools where the excitation wavelength could not be resolved*)
	(*Retrieve the sample pool and group in a list with the excitation wavelength*)
	sampleOptionList = Transpose[{myPooledSamples,excitationWavelengths}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidExcitationWavelengths];
	invalidExcitationOption = If[Length@invalidSampleOptionList>0,{ExcitationWavelength},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidExcitationWavelengths,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidExWavelengthsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our excitation wavelengths can be resolved for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our excitation wavelengths can be resolved for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*12. Throw an error for any sample pools where the emission parameters could not be resolved*)
	(*Retrieve the sample pool and group in a list with the emissions parameters*)
	sampleOptionList = Transpose[{myPooledSamples,emissionParameters}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,invalidEmissionWavelengths];
	invalidEmissionDetectionOptions=If[Length@invalidSampleOptionList>0,{EmissionWavelength,MinEmissionWavelength,MaxEmissionWavelength},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidEmissionWavelengths,ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidEmWavelengthsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our emission wavelengths can be resolved for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our emission wavelengths can be resolved for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*13. Throw an error for any sample pools where the excitation wavelength is not compatible with the resolved instrument*)

	(*Retrieve the sample pool and group in a list with the excitation wavelength*)
	sampleOptionList = Transpose[{myPooledSamples,excitationWavelengths}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,incompatibleExcitationWavelengths];
	incompatibleExcitationOption = If[Length@invalidSampleOptionList>0,{ExcitationWavelength,Instrument},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::IncompatibleExcitationWavelength,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	incompatibleExWavelengthsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved excitation wavelengths for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]" are compatible with the resolved instrument:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved excitation wavelengths for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*14. Throw an error for any sample pools where the emission options are not compatible with the resolved instrument*)

	(*Retrieve the sample pool and group in a list with the emission options*)
	sampleOptionList = Transpose[{myPooledSamples,emissionParameters}];

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[sampleOptionList,incompatibleEmissionDetectors];
	incompatibleEmissionOption = If[Length@invalidSampleOptionList>0,{EmissionWavelength,MinEmissionWavelength,MaxEmissionWavelength,Instrument},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::IncompatibleEmissionOptions,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation]],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	incompatibleEmOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our resolved emission parameters for the inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]" are compatible with the resolved instrument:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our resolved emission parameters for the inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible with the resolved instrument:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*15. Throw an error for any sample pools where the reaction volume does not match the sum of the reaction components*)

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[myPooledSamples,invalidSampleReactionVolumes];
	invalidSampleReactionVolOption = If[Length@invalidSampleOptionList>0,{ReactionVolume,SampleVolume,BufferVolume,DetectionReagentVolume,PassiveReferenceVolume},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidTotalReactionVolume,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation],invalidSampleReactionVolOption],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidSampleReactionVolumesTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our reaction volume is equal to the sum of reaction component volumes inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" :", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our reaction volume is equal to the sum of reaction component volumes inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" :", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*16. Throw an error for any sample pools where the pooling partners have unequal number of dilutions*)

	(*Find the invalid samples using the error checking boolean set in the mapthread*)
	invalidSampleOptionList = PickList[myPooledSamples,invalidPooledDilutions];
	invalidPooledDilutionOptions = If[Length@invalidSampleOptionList>0,{SerialDilutionCurve,DilutionCurve},{}];

	(*Throw an error if there are invalid sample pools.*)
	If[Length[invalidSampleOptionList]>0&&messages,Message[Error::InvalidNestedIndexMatchingDilutions,ObjectToString[invalidSampleOptionList,Simulation->updatedSimulation],invalidPooledDilutionOptions],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidPooledDilutionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length[invalidSampleOptionList]>0,
								Test["Our dilution options for nested index matching inputs "<>ObjectToString[invalidSampleOptionList[[All,1]],Simulation->updatedSimulation]<>" are compatible:", True, False],
								Nothing];
					passingTest =
							If[Length[invalidSampleOptionList]==0,
								Test["Our dilution options for nested index matching inputs "<>ObjectToString[myPooledSamples,Simulation->updatedSimulation]<>" are compatible:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*Experiment Options*)
	(*1. If the resolved instrument is ViiA 7, resolvedTempResolution option must be Null. This is not available on this instrument.*)
	invalidInstrumentBoolean = If[MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]],
		MatchQ[resolvedTempResolution,Except[Null]],
		False
	];

	invalidInstrumentOption = If[invalidInstrumentBoolean==True,{Instrument,TemperatureResolution},{}];

	If[invalidInstrumentBoolean==True&&messages, Message[Error::InvalidTemperatureResolution,resolvedTempResolution,ObjectToString[resolvedInstrument,Simulation->updatedSimulation]]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidTempResTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidInstrumentBoolean,True],
								Test["Our resolved temperature resolution is Null when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidInstrumentBoolean,False],
								Test["Our resolved temperature resolution is Null when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*2. If the resolved temperature resolution is not Null, check that it is less than the calculated max resolution*)
	invalidResolution=If[!MatchQ[resolvedTempResolution,Null],
		resolvedTempResolution<maxRes,
		False
	];

	incompatibleResolutionOption = If[invalidResolution==True,{TemperatureResolution},{}];

	If[invalidResolution==True&&messages, Message[Error::IncompatibleTemperatureResolution,resolvedTempResolution,Total[Flatten@requiredWells],resolvedRampRate,maxRes]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	incompatibleTempResTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidResolution,True],
								Test["Our resolved temperature resolution is greater than the max resolution allowable by the instrument:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidResolution,False],
								Test["Our resolved temperature resolution is greater than the max resolution allowable by the instrument:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*3. Get instrument ramp limits check that resolved value falls within that range*)
	instrumentMaxRate = Sequence@@Convert[Lookup[resolvedInstrumentPacket, MaxTemperatureRamp],Units[resolvedRampRate]];

	If[resolvedRampRate>instrumentMaxRate&&messages,
		Message[Error::InvalidRampRate,resolvedRampRate,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],instrumentMaxRate]
	];

	invalidRampRateOption = If[resolvedRampRate<=instrumentMaxRate,{},{TemperatureRampRate}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidRampRateTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[resolvedRampRate>instrumentMaxRate,
								Test["Our resolved temperature ramp rate is within the resolved instrument operational limits:", True, False],
								Nothing];
					passingTest =
							If[resolvedRampRate<=instrumentMaxRate,
								Test["Our resolved temperature ramp rate is within the resolved instrument operational limits:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*4. Get instrument temperature limits and check that the min and max temperature values fall within that range*)
	instrumentTempRange = Lookup[resolvedInstrumentPacket,{MinTemperature, MaxTemperature}];

	If[!Between[minTemp,instrumentTempRange]&&messages,
		Message[Error::InvalidMinTemperature,minTemp,resolvedInstrument,instrumentTempRange[[1]]]
	];

	invalidMinTempOption = If[Between[minTemp,instrumentTempRange],{},{MinTemperature}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidMinTempTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[Between[minTemp,instrumentTempRange],False],
								Test["Our resolved minimum temperature is within the resolved instrument operational limits:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[Between[minTemp,instrumentTempRange],True],
								Test["Our resolved minimum temperature is within the resolved instrument operational limits:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	If[!Between[maxTemp,instrumentTempRange]&&messages,
		Message[Error::InvalidMaxTemperature,maxTemp,resolvedInstrument,instrumentTempRange[[1]]]
	];

	invalidMaxTempOption = If[Between[maxTemp,instrumentTempRange],{},{MaxTemperature}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidMaxTempTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[Between[maxTemp,instrumentTempRange],False],
								Test["Our resolved maximum temperature is within the resolved instrument operational limits:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[Between[maxTemp,instrumentTempRange],True],
								Test["Our resolved maximum temperature is within the resolved instrument operational limits:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*5. Check that the number of samples including serial dilutions and replicates is compatible with the instrument capacity*)
	{invalidSampleNumber,maxSampleNum}= Switch[{resolvedInstrument},
		{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]}, {Total[Join@@requiredWells]>384,384},
		{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, {Total[Join@@requiredWells]>48,48}
	];

	invalidSampleNumberOption = If[invalidSampleNumber==True,{SerialDilutionCurve,DilutionCurve,NumberOfReplicates},{}];

	If[invalidSampleNumber==True&&messages, Message[Error::TooManySamples,requiredWells,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],maxSampleNum],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidSampleNumberTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidSampleNumber,True],
								Test["Our total sample number is within the resolved instrument operational limits:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidSampleNumber,False],
								Test["Our total sample number is within the resolved instrument operational limits:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*6. Check that the reaction volume is compatible with the instrument capacity*)
	{invalidReactionVolume,compatibleVolume}= Switch[{resolvedInstrument},
		{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]}, {!Between[reactionVolume,{5*Microliter,40*Microliter}],{5*Microliter,40*Microliter}},
		(* For UNcle, the lower limit for ReactionVolume is set to 20 so that the final transfer of 10uL to the capillary strips
		is less likely to have insufficient volume	*)
		{ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]}, {!Between[reactionVolume,{20*Microliter,40*Microliter}],{20*Microliter,40*Microliter}}
	];

	invalidReactionVolOption = If[invalidReactionVolume==True,{ReactionVolume},{}];

	If[invalidReactionVolume==True&&messages, Message[Error::InvalidReactionVolume,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],compatibleVolume],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidReactionVolumeTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidReactionVolume,True],
								Test["Our resolved reaction volume is within the resolved instrument assay container operational limits:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidReactionVolume,False],
								Test["Our resolved reaction volume is within the resolved instrument assay container operational limits:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*7. Check that if the instrument is the Uncle, ContainersOut is Null. Samples cannot be recouped from the Uncle capillary strips.*)
	invalidContainerOutBoolean = If[MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}]],
		MatchQ[containerOption,Except[Null]],
		False
	];

	invalidContainerOutOption = If[invalidContainerOutBoolean==True,{Instrument,ContainerOut},{}];

	If[invalidContainerOutBoolean==True&&messages, Message[Error::InvalidContainerOut,containerOption,ObjectToString[resolvedInstrument,Simulation->updatedSimulation]]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidRecoupSampleTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidContainerOutBoolean,True],
								Test["Our ContainerOut option is Null when the resolved instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"]:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidContainerOutBoolean,False],
								Test["Our ContainerOut option is Null when the resolved instrument is Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"]:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*8. Check that if the instrument is the ViiA 7, NumberOfCycles must be 0.5. This instrument can only record data for a single monotonically changing thermal ramp.*)
	invalidCycleNumBoolean = If[MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]],
		GreaterQ[resolvedCycleNum,0.5],
		False
	];

	invalidCycleNumOption = If[invalidCycleNumBoolean==True,{Instrument,NumberOfCycles},{}];

	If[invalidCycleNumBoolean==True&&messages, Message[Error::InvalidNumberOfCycles,resolvedCycleNum,ObjectToString[resolvedInstrument,Simulation->updatedSimulation]]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidCycleNumTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidCycleNumBoolean,True],
								Test["Our NumberOfCycles option is 0.5 when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidCycleNumBoolean,False],
								Test["Our NumberOfCycles option is 0.5 when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*9. Check that if the instrument is the ViiA 7, the OptimizeFluorescenceLaserPower is False.*)
	invalidLaserOptiBoolean = If[
		MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]]&&MemberQ[Flatten@Lookup[mapThreadFriendlyOptions,OptimizeFluorescenceLaserPower],True],
		True,
		False
	];

	If[invalidLaserOptiBoolean==True&&messages, Message[Warning::InvalidLaserOptimization,OptimizeFluorescenceLaserPower,resolvedInstrument]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidLaserOptiBooleanTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidLaserOptiBoolean,True],
								Test["Our OptimizeFluorescenceLaserPower option is False when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidLaserOptiBoolean,False],
								Test["Our OptimizeFluorescenceLaserPower option is False when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*10. Check that if the instrument is the ViiA 7, the invalidLaserOptiOption is False for all samples.*)

	If[MemberQ[invalidLaserOptiOptions,True]&&messages, Message[Warning::InvalidLaserOptimization,{LaserOptimizationEmissionWavelengthRange,LaserOptimizationTargetEmissionIntensityRange},resolvedInstrument]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidLaserOptiOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MemberQ[invalidLaserOptiOptions,True],
								Test["Our LaserOptimizationEmissionWavelengthRange & LaserOptimizationTargetEmissionIntensityRange options are Null when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, False],
								Nothing];
					passingTest =
							If[!MemberQ[invalidLaserOptiOptions,True],
								Test["Our LaserOptimizationEmissionWavelengthRange & LaserOptimizationTargetEmissionIntensityRange options are Null when the resolved instrument is Model[Instrument,Thermocycler,\"ViiA 7\"] or Model[Instrument, Thermocycler, \"QuantStudio 7 Flex\"]:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*11. Check that if the OptimizeFluorescenceLaserPower is False, LaserOptimizationEmissionWavelengthRange & LaserOptimizationTargetEmissionIntensityRange is Null for all samples.*)
	unsuedOptimizationOptionSamples = PickList[myPooledSamples,unusedOptimizationOptions];
	If[MemberQ[unusedOptimizationOptions,True]&&messages, Message[Warning::UnusedOptimizationParameters,{LaserOptimizationEmissionWavelengthRange,LaserOptimizationTargetEmissionIntensityRange},unsuedOptimizationOptionSamples]];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	unusedLaserOptiOptionsTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MemberQ[unusedOptimizationOptions,True],
								Test["Our LaserOptimizationEmissionWavelengthRange & LaserOptimizationTargetEmissionIntensityRange options are Null when OptimizeFluorescenceLaserPower is False:", True, False],
								Nothing];
					passingTest =
							If[!MemberQ[unusedOptimizationOptions,True],
								Test["Our LaserOptimizationEmissionWavelengthRange & LaserOptimizationTargetEmissionIntensityRange options are Null when OptimizeFluorescenceLaserPower is False:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*12. Check that the number of samples can fit into the ContainerOut capacity*)
	(*find the capacity of the container*)
	containerOutCapacity = If[
		MatchQ[containerOption,ObjectP[]],
		Length[Flatten[List@@@Lookup[Flatten[Join[containerOutObjectPackets, containerOutModelPackets]],AllowedPositions]]],
		Null
	];
	invalidContainerOutCapacity= If[!MatchQ[containerOutCapacity,Null],Total[Join@@requiredWells]>containerOutCapacity, False];
	invalidContainerOutCapacityOption = If[invalidContainerOutCapacity==True,{ContainerOut},{}];

	If[invalidContainerOutCapacity==True&&messages, Message[Error::TooManySamplesOut,containerOutCapacity],Nothing];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidContainerOutCapacityTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidContainerOutCapacity,True],
								Test["Our total sample number is within the container out capacity:", True, False],
								Nothing];
					passingTest =
							If[MatchQ[invalidContainerOutCapacity,False],
								Test["Our total sample number is within the container out capacity:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(*13. Check that the dilution storage condition is compatible for samples diluted in the same container*)
	(*Create a list of rules associating which dilution containers have which storage conditions*)
	dilutionStorageRules = MapThread[#1->#2&,{Cases[Flatten[dilutionContainers,1],{_,ObjectP[]}],Cases[Flatten@resolvedDilutionStorageConditions,Except[Null]]}];
	mergedStorageRules = Merge[dilutionStorageRules,DeleteDuplicates];
	invalidDilutionStorageCondition = Select[mergedStorageRules,Length[#]>1 &];

	If[Length@invalidDilutionStorageCondition>0&&messages, Message[Error::TooManyDilutionStorageConditions,Keys[invalidDilutionStorageCondition],Values[invalidDilutionStorageCondition]],Nothing];
	invalidDilutionStorageConditionOption = If[Length@invalidDilutionStorageCondition>0,{DilutionStorageCondition},{}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidinvalidDilutionStorageConditionTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[Length@invalidDilutionStorageCondition>0,
								Test["Our dilutions in the same container have the same storage condition:", True, False],
								Nothing];
					passingTest =
							If[Length@invalidDilutionStorageCondition<0,
								Test["Our dilutions in the same container have the same storage condition:", True, True],
								Nothing];
					{failingTest, passingTest}
				],
				{}
			];

	(* - Throw an Error if DynamicLightScattering option is True but Instrument is not an Uncle - *)
	invalidConflictingDLSInstrumentOptions=If[

		(* IF DynamicLightScattering is True but the Instrument is not an Uncle*)
		dynamicLightScatteringOption&&MatchQ[resolvedInstrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]],

		(* THEN the options are invalid *)
		{Instrument,DynamicLightScattering},

		(* ELSE nothing is invalid *)
		{}
	];

	(* If there are any invalidConflictingDLSInstrumentOptions has any Contents and we are throwing Messages, throw an Error *)
	If[Length[invalidConflictingDLSInstrumentOptions]>0&&messages,
		Message[Error::ConflictingThermalShiftDynamicLightScatteringInstrument,ObjectToString[resolvedInstrument,Simulation->updatedSimulation],dynamicLightScatteringOption]
	];

	(* Define the tests the user will see for the above message *)
	conflictingDLSInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingDLSInstrumentOptions]==0,
				Nothing,
				Test["The Instrument option, "<>ObjectToString[resolvedInstrument,Simulation->updatedSimulation]<>", and DynamicLightScattering option, "<>ToString[dynamicLightScatteringOption]<>", are in conflict. DynamicLightScattering can only be True if the Instrument is a MultimodeSpectrophotometer:",True,False]
			];
			passingTest=If[Length[invalidConflictingDLSInstrumentOptions]>0,
				Nothing,
				Test["The DynamicLightScattering and Instrument options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw an Error if AutomaticDLS laser settings is in conflict with the related options - *)
	{invalidAutomaticDLSLaserOptionNames,invalidAutomaticDLSLaserOptionValues}=Switch[
		{
			resolvedAutomaticDynamicLightScatteringLaserSettings,
			resolvedDynamicLightScatteringLaserPower,
			resolvedDynamicLightScatteringDiodeAttenuation
		},

		(* Cases where AutomaticDLSLaserSettings is Null - no Error to throw *)
		{Null,_,_},
			{{},{}},

		(* Cases where AutomaticDLSLaserSettings is True, throw an error if either of the other options is Not Null *)
		{True,Null,Null},
			{{},{}},
		{True,_,_},
			{
				Join[
					{AutomaticDynamicLightScatteringLaserSettings},
					PickList[
						{DynamicLightScatteringLaserPower,DynamicLightScatteringDiodeAttenuation},
						{resolvedDynamicLightScatteringLaserPower,resolvedDynamicLightScatteringDiodeAttenuation},
						Except[Null]
					]
				],
				Join[
					{resolvedAutomaticDynamicLightScatteringLaserSettings},
					Cases[{resolvedDynamicLightScatteringLaserPower,resolvedDynamicLightScatteringDiodeAttenuation},Except[Null]]
				]
			},

		(* Cases where AutomaticDLSLaserSettings is False, throw an error if either of the other options is Null *)
		{False,Except[Null],Except[Null]},
			{{},{}},

		{False,_,_},
			{
				Join[
					{AutomaticDynamicLightScatteringLaserSettings},
					PickList[
						{DynamicLightScatteringLaserPower,DynamicLightScatteringDiodeAttenuation},
						{resolvedDynamicLightScatteringLaserPower,resolvedDynamicLightScatteringDiodeAttenuation},
						Null
					]
				],
				Join[
					{resolvedAutomaticDynamicLightScatteringLaserSettings},
					Cases[{resolvedDynamicLightScatteringLaserPower,resolvedDynamicLightScatteringDiodeAttenuation},Null]
				]
			}
	];

	(* If there are any invalidConflictingDLSInstrumentOptions has any Contents and we are throwing Messages, throw an Error *)
	If[Length[invalidAutomaticDLSLaserOptionNames]>0&&messages,
		Message[Error::ConflictingThermalShiftAutomaticDLSLaserOptions,invalidAutomaticDLSLaserOptionNames,invalidAutomaticDLSLaserOptionValues]
	];

	(* Define the tests the user will see for the above message *)
	conflictingAutomaticDLSLaserTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidAutomaticDLSLaserOptionNames]==0,
				Nothing,
				Test["The following options, "<>ToString[invalidAutomaticDLSLaserOptionNames]<>", with values of  "<>ToString[invalidAutomaticDLSLaserOptionValues]<>" are in conflict. If AutomaticDynamicLightScatteringLaserSettings is True, both the DynamicLightScatteringLaserPower and DynamicLightScatteringDiodeAttenuation options must be Null. If AutomaticDynamicLightScatteringLaserSettings is True, neither of the other two options can be Null:",True,False]
			];
			passingTest=If[Length[invalidAutomaticDLSLaserOptionNames]>0,
				Nothing,
				Test["The AutomaticDynamicLightScatteringLaserSettings option and related laser and diode options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*-- Check that DLS measurements and temperatures are index-matched--*)

	(*Check if the option values are the same length*)
	invalidDLSTemperature = !MatchQ[Length[resolvedDynamicLightScatteringMeasurementTemperatures],Length[resolvedDynamicLightScatteringMeasurements]];

	(*Throw an error if invalidDLSTemperature is True*)
	invalidDLSTemperatureOptions = If[MatchQ[invalidDLSTemperature,True]&&messages,
		(Message[Error::ConflictingDLSMeasurementRequestedTemperatures, resolvedDynamicLightScatteringMeasurements, resolvedDynamicLightScatteringMeasurementTemperatures];
		{DynamicLightScatteringMeasurements,DynamicLightScatteringMeasurementTemperatures}),
		{}];

	(*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
	invalidDLSTempTest =
			If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest =
							If[MatchQ[invalidDLSTemperature,True],
								Test["For each DLS measurement we have a corresponding DLS measurement temperature:", True, False],
								Nothing
							];
					passingTest =
							If[MatchQ[invalidDLSTemperature,False],
								Test["For each DLS measurement we have a corresponding DLS measurement temperature:", True, True],
								Nothing
							];
					{failingTest, passingTest}
				],
				{}
			];


	(* -- Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. -- *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,nonLiquidSampleInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		invalidRampOptionsKeys,
		invalidNullRampOptionsKeys,
		Keys[invalidPooledMixOptions],
		Keys[invalidPooledIncubateOptions],
		incompatibleMixOptionKeys,
		incompatibleStorageOptionKeys,
		invalidEmissionOptions,
		incompatibleEmissionRangeKeys,
		invalidPassiveReferenceOptionsKeys,
		incompatibleReagentOptionKeys,
		tooManyDilutionOptionKeys,
		incompatibleDilutionOptions,
		invalidTempRangeOptions,
		invalidDetectionReagentOption,
		invalidEmissionDetectionOptions,
		invalidPoolMixVolOptions,
		invalidSampleVolOption,
		invalidBufferVolOption,
		invalidDilutionVolOption,
		invalidDilutionMixVolOption,
		invalidDilutionContainerOption,
		invalidThermocyclerOption,
		invalidThermocyclerEmissionsOption,
		invalidMultiModeSpecOption,
		invalidExcitationOption,
		incompatibleExcitationOption,
		incompatibleEmissionOption,
		invalidInstrumentOption,
		incompatibleResolutionOption,
		invalidRampRateOption,
		invalidMinTempOption,
		invalidMaxTempOption,
		invalidSampleNumberOption,
		invalidReactionVolOption,
		invalidContainerOutOption,
		invalidCycleNumOption,
		invalidThermocyclerModeOption,
		invalidPassRefOption,
		invalidSampleReactionVolOption,
		invalidPooledDilutionOptions,
		invalidContainerOutCapacityOption,
		invalidDilutionStorageConditionOption,
		invalidConflictingDLSOptionNames,
		invalidConflictingDLSInstrumentOptions,
		invalidConflictingNullDLSOptionNames,
		invalidAutomaticDLSLaserOptionNames,
		invalidDLSTemperatureOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs and we're throwing messages. *)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation->updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options and we're throwing messages. *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Importantly: Remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver so that the resolved options do not conflict *)
	(*In the resolvedOptions replace rule we only want one instance of aliquot options. these should be from the resolved aliquot options not from the sample prep options.*)
	resolveSamplePrepOptionsWithoutAliquot = First[splitPrepOptions[resolvedSamplePrepOptions, PrepOptionSets -> {IncubatePrepOptionsNew, CentrifugePrepOptionsNew, FilterPrepOptionsNew}]];

	(*Resolve aliquot options*)
	(*Ideally what would happen here is that the dilutions and pooling could be simulated. This would simplify alot how the primitives are made in the compiler and how replicates are handled*)
	(* Call the aliquot resolver. Get the tests if we're gathering them *)
	{resolvedAliquotOptions,resolvedAliquotOptionsTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentThermalShift,
			myPooledSamples,
			simulatedSamples,
			ReplaceRule[myOptions,Append[resolveSamplePrepOptionsWithoutAliquot, NumberOfReplicates -> resolvedNumberOfReplicates]],
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->Null,
			AliquotWarningMessage->Null,
			AllowSolids->False,
			Cache->cache,
			Simulation->updatedSimulation,
			Output -> {Result, Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentThermalShift,
				myPooledSamples,
				simulatedSamples,
				ReplaceRule[myOptions,Append[resolveSamplePrepOptionsWithoutAliquot, NumberOfReplicates -> resolvedNumberOfReplicates]],
				RequiredAliquotContainers->targetContainers,
				RequiredAliquotAmounts->Null,
				AliquotWarningMessage->Null,
				AllowSolids->False,
				Cache->cache,
				Simulation->updatedSimulation,
				Output->Result
			],
			{}
		}
	];

	(*-- CONSTRUCT THE RESOLVED OPTIONS AND TESTS OUTPUTS --*)

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* construct the final resolved options. We don't collapse here - that is happening in the main function *)
	(*Replace any 0 volumes with Null so they will be hidden/display properly in CC*)
	bufferVolumesWithNulls = bufferVolumes/. {0 Microliter -> Null, 0.  Microliter -> Null};
	detectionReagentVolumesWithNulls = detectionReagentVolumes/. {0 Microliter -> Null, 0.  Microliter -> Null};
	passiveReferenceVolumeWithNulls = passiveReferenceVolume/. {0 Microliter -> Null, 0.  Microliter -> Null};

	resolvedOptions=ReplaceRule[
		Normal[roundedThermalShiftOptions],
		Join[
			{
				Instrument->resolvedInstrument,
				NumberOfReplicates -> resolvedNumberOfReplicates,
				ReactionVolume->reactionVolume,
				PassiveReferenceVolume->passiveReferenceVolumeWithNulls,
				NestedIndexMatchingMix->pooledMixes,
				NestedIndexMatchingMixType->pooledMixTypes,
				NestedIndexMatchingNumberOfMixes->pooledMixNumberOfMixes,
				NestedIndexMatchingMixVolume->pooledMixVolumes,
				NestedIndexMatchingIncubate->pooledIncubations,
				PooledIncubationTime->pooledIncubationTimes,
				NestedIndexMatchingIncubationTemperature->pooledIncubationTemperatures,
				NestedIndexMatchingAnnealingTime->pooledAnnealingTimes,
				SampleVolume->sampleVolumes,
				Buffer->buffers,
				BufferVolume->bufferVolumesWithNulls,
				DetectionReagent->detectionReagents,
				DetectionReagentVolume->detectionReagentVolumesWithNulls,
				Diluent->diluents,
				DilutionContainer->dilutionContainers,
				DilutionStorageCondition->resolvedDilutionStorageConditions,
				DilutionMixVolume->dilutionMixVolumes,
				DilutionNumberOfMixes->dilutionMixNumbers,
				DilutionMixRate->dilutionMixRates,
				NumberOfCycles->resolvedCycleNum,
				TemperatureRamping->resolvedRampType,
				TemperatureRampRate->resolvedRampRate,
				TemperatureResolution->resolvedTempResolution,
				NumberOfTemperatureRampSteps->resolvedStepNum,
				StepHoldTime->resolvedStepHold,
				FluorescenceLaserPower->fluorescenceFilters,
				StaticLightScatteringLaserPower->slsFilters,
				ExcitationWavelength->excitationWavelengths,
				EmissionWavelength->emWavelengths,
				MinEmissionWavelength->minEmWavelengths,
				MaxEmissionWavelength->maxEmWavelengths,
				StaticLightScatteringExcitationWavelength->slsExcitationWavelengths,
				LaserOptimizationEmissionWavelengthRange->resolvedLaserOptiWavelengths,
				LaserOptimizationTargetEmissionIntensityRange->resolvedLaserOptiIntensities,
				DynamicLightScatteringMeasurements->resolvedDynamicLightScatteringMeasurements,
				(*if we have only one measurement - don't have a list here*)
				DynamicLightScatteringMeasurementTemperatures->If[Length[resolvedDynamicLightScatteringMeasurementTemperatures]==1,First@resolvedDynamicLightScatteringMeasurementTemperatures,resolvedDynamicLightScatteringMeasurementTemperatures],
				NumberOfDynamicLightScatteringAcquisitions->resolvedNumberOfDynamicLightScatteringAcquisitions,
				DynamicLightScatteringAcquisitionTime->resolvedDynamicLightScatteringAcquisitionTime,
				AutomaticDynamicLightScatteringLaserSettings->resolvedAutomaticDynamicLightScatteringLaserSettings,
				DynamicLightScatteringLaserPower->resolvedDynamicLightScatteringLaserPower,
				DynamicLightScatteringDiodeAttenuation->resolvedDynamicLightScatteringDiodeAttenuation,
				DynamicLightScatteringCapillaryLoading->resolvedDynamicLightScatteringCapillaryLoading
			},
			resolveSamplePrepOptionsWithoutAliquot,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		]
	];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests = Cases[Flatten[{
		nonLiquidSampleTest,
		resolvedAliquotOptionsTests,
		preferredInstrumentTest,
		invalidTemperatureRampTest,
		invalidPooledMixTest,
		invalidPooledIncubateTest,
		incompatiblePooledMixOptionsTest,
		incompatibleStorageOptionsTest,
		thermocyclerModeTest,
		invalidEmissionTest,
		invalidEmissionRangeTest,
		invalidPassiveRefTest,
		invalidReagentTest,
		tooManyDilutionsTest,
		invalidDilutionTest,
		invalidRampTest,
		invalidPassiveRefVolTest,
		invalidPoolMixVolumeTest,
		invalidDetectionReagentVolumesTest,
		invalidSampleVolumesTest,
		invalidBufferVolumesTest,
		invalidRequiredSamplesVolumesTest,
		invalidDilutionMixVolumesTest,
		invalidDilutionContainersTest,
		invalidThermocyclerOptionsTest,
		invalidResolvedEmissionRangeTest,
		invalidMMSpecOptionsTest,
		invalidExWavelengthsTest,
		invalidEmWavelengthsTest,
		incompatibleExWavelengthsTest,
		incompatibleEmOptionsTest,
		invalidTempResTest,
		incompatibleTempResTest,
		invalidRampRateTest,
		invalidMinTempTest,
		invalidMaxTempTest,
		invalidSampleNumberTest,
		invalidReactionVolumeTest,
		invalidRecoupSampleTest,
		invalidCycleNumTest,
		optimizeSLSTest,
		invalidLaserOptiBooleanTest,
		invalidLaserOptiOptionsTest,
		unusedLaserOptiOptionsTest,
		validNameTest,
		invalidSampleReactionVolumesTest,
		invalidPooledDilutionsTest,
		invalidContainerOutCapacityTest,
		invalidinvalidDilutionStorageConditionTest,
		conflictingDLSInstrumentTests,
		conflictingDLSOptionTests,
		conflictingNullDLSOptionTests,
		conflictingAutomaticDLSLaserTests,
		invalidDLSTempTest
	}], _EmeraldTest ];

	(* generate the Result output rule *)
	(* if we're not returning results, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* generate the tests rule. If we're not gathering tests, the rule is just Null *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* Return our resolved options and/or tests, as desired *)
	outputSpecification /. {resultRule, testsRule}

];

(* ==========Resource packets Helper function ========== *)
DefineOptions[experimentThermalShiftResourcePackets,
	Options:>{SimulationOption,CacheOption,HelperOutputOption}
];

experimentThermalShiftResourcePackets[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}], myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{liquidHandlerContainers,nonInputSamples,inputSampleContainerModels,nonInputSampleContainerModels,collapsedAliquotContainers,sampleAliquotContainerRules,liquidHandlerContainerMaxVols,allSampleContainerModels,poolLengths,serialDilCurves,dilCurves, eqTime,rampType,cache,dilutionPartnerNumbers,totalSampleNums,aliquotBool,serialDilutionBool,dilutionBool,reqSampleVols,
		sampleVolRules,uniqueSampleVolRules,samplesInResourceRules,containersIn,containersInResource,expandedDilutionOptions,poolExpandedDilutionOptions,
		requiredWells,containersOutNeeded,requiredContainers,containersOutResource,passiveRefObj,singularOptionPatterns,
		passiveRefVol,requiredPassRefVol,passiveRefResource,buffers,bufferVolumes,requiredBufferVolumeRules,dilutionQ,
		reqBufferVolsNoNulls,mergedBufferRequiredVols,bufferResourceRules,buffersWithReplicates,bufferResources,
		detectionReagent,detectionReagentVol,requiredDetectionVolumeRules,reqDetectionVolsNoNulls,mergedDetectionRequiredVols,
		detectionResourceRules,detectionWithReplicates,detectionResources,pooledDiluents,diluents,reqDiluentVolsNoNulls,requiredDiluentVolumes,
		mergedDiluentRequiredVols,diluentResourceRules,diluentWithReplicates,diluentResources,expandedSampleVolumes,
		dilutionContainers,indexedRequiredDilutionWellsRules,reqDilutionWellsNoNulls,mergedDilutionWells,
		dilutionContainersNeeded,uniqueContainerResourcesRules,dilutionContainerResources,assayContainerObject,dilutionContainersNeededNoNulls,
		reqAssayContainerNum,assayContainerResource,plateSealResource,capillaryClipResource,transposeDilutionCurve,transposeSerialDilutionCurve,
		capillaryClipGasketResource,capillaryStripPlateLoader,uncleStageLid,cycleNum,rampRate,minTemp,maxTemp,stepNum,stepTime,aliquotVol,sampleVolumes,
		expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,numReplicates,numReplicatesWithNull,samplesInResources,
		instrument,instrumentTime,instrumentResource,protocolPacket, containerOut,samplesInWithReplicates,requiredReactionWells,
		sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable, frqTests,previewRule,optionsRule,testsRule,resultRule,
		pooledMix, pooledMixType, pooledNumberOfMixes, pooledMixVolume, pooledIncubate, pooledIncubationTemperature,pooledIncubationTime, pooledAnnealingTime,
		pooledMixField,pooledIncubateField,expPooledSamplesIn,expPooledMixField,expPooledIncubateField,sampleVolumesWithReplicates,bufferVolumesWithReplicates,
		detectionVolumesWithReplicates,dilutionsWithReplicates,serialDilWithReplicates,dilutionMixWithReplicates,dilutionMixNumWithReplicates,
		dilutionMixRatesWithReplicates,fluorExWithReplicates,slsExWithReplicates,emWithReplicates,minEmWithReplicates,maxEmWithReplicates,fluorPowerWithReplicates,slsPowerWithReplicates,
		uniqueSamplesIn,uniqueDilutionContainers,sampleContainerPackets,uniqueDilutionContainerObjects,containerOutPacket,dilutionContainerPackets,tempResolution,
		dynamicLightScattering,numberOfDynamicLightScatteringAcquisitions,dynamicLightScatteringAcquisitionTime,
		automaticDynamicLightScatteringLaserSettings,dynamicLightScatteringLaserPower,dynamicLightScatteringDiodeAttenuation,
		dynamicLightScatteringMeasurements,dynamicLightScatteringMeasurementTemperatures,dynamicLightScatteringCapillaryLoading,
		manualLoadingPlateResource,manualLoadingPipetteResource,manualLoadingTipsResource,reactionContainerResource,dilutionCurvesNoNulls,serialDilutionCurvesNoNulls,
		optiWavelengthRangeWithReplicates,optiIntensityRangeWithReplicates,optiWavelengthSpan, optiIntensityPercentSpan, optiWavelengthRanges,
		optiIntensityRanges,optimizeFluorLaserWithReps,optimizeSLSLaserWithReps,optiIntensityPercentRanges,instrumentFields,instrumentData,
		expandedFluorescenceOptiBool,expandedSlsOptiBool,expandedOptiEmWavelength,expandedOptiIntensity,pooledSampleVolume, simulation,
		expandedLaserOptiOptions,dilutionLengths,pooledDilutionLengths,maxDilutionLengths,dilStorageCondWithReps,dilutionStorageConditionRules,uniqueDilutionStorageConditions,
		liquidHandlerCompatibleContainers, samplesInLHContainerQ, preparedPlateQ,thermocyclerPreparedPlateQ,currentSampleVolume,sampleVolumePackets,aliquotRequiredQ
	},

	(*Our primitives require the use of the liquid handling robot. As such, we need all the samples to be in liquid handler compatible containers.*)
	(*Here we will get all the microliquid handling compatible container objects except for the specialized plates for specific assays.*)
	liquidHandlerContainers = Join[
		PreferredContainer[All, Type -> Plate],
		Quiet@PreferredContainer[All, Type -> Vessel, LiquidHandlerCompatible -> True]
	];

	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* lookup the cache *)
	inheritedCache=Lookup[ToList[ops],Cache];
	simulation=Lookup[ToList[ops],Simulation];

	(* determine the pool lengths*)
	poolLengths=Map[Length[#]&,myPooledSamples];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentThermalShift, {myPooledSamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentThermalShift,
		RemoveHiddenOptions[ExperimentThermalShift,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* --- Make all the resources needed in the experiment --- *)

	(*First we need to manually expand the dilution options as done in the option resolver. Because of the nested nature of the dilutions within pooling we must do this manually.*)
	(*If only a single option is given (not a list) we will need to expand it to match the number of samples and then group it by the corresponding pooled sample*)
	(*We have to use the option patterns here because matching just based on option and pool length is not sufficient given the complexity of the dilution option nested lists.*)
	singularOptionPatterns = {
		DilutionCurve->Alternatives[Null, {{VolumeP, VolumeP} ..}, {{VolumeP, RangeP[0, 1]} ..}],
		SerialDilutionCurve->Alternatives[Null,{VolumeP,VolumeP,GreaterP[1,1]},{VolumeP,{RangeP[0,1],GreaterP[1,1]}},{VolumeP,{RangeP[0,1]..}}]
	};

	expandedDilutionOptions = Map[
		Function[dilutionOption,
			Module[{optionVal, optionPattern},
				optionVal = Lookup[myResolvedOptions, dilutionOption];
				optionPattern = Lookup[singularOptionPatterns, dilutionOption];
				Switch[optionVal,
					(*If the option value matches an acceptable single value pattern (singleOptionPatterns), expand the optionVal to match the number of samples. Then group the expanded list by pool. Then generate and option rule for each pool.*)
					(*the format we are going for is a single list for each pool*)
					(*essentially this means that if only one option is specified for all the pooled samples then every pool will have the same dilution options*)
					optionPattern,
					(dilutionOption ->#)&/@TakeList[ConstantArray[optionVal, Total[poolLengths]], poolLengths],
					(*If the option is a list, MapThread again to expand the option for each pool*)
					_, (dilutionOption->#)&/@ MapThread[
					Switch[#1,
						(*If the option value matches an acceptable single value pattern (singleOptionPatterns), expand the optionVal to match the number of samples in the corresponding pool.*)
						optionPattern, ConstantArray[#1,#2],
						(*In all other cases if the option value matches the length of the corresponding pool, return the specified option. If not return an error*)
						_, #1
					]&
					,{optionVal,poolLengths}
				]
				]
			]
		],
		{
			DilutionCurve,
			SerialDilutionCurve
		}
	];

	(*Transpose the expanded options so all the dilution options for each pooled sample is grouped together*)
	poolExpandedDilutionOptions = Transpose@Lookup[expandedResolvedOptions,{DilutionCurve,SerialDilutionCurve}];

	(*Calculate the dilution curves*)
	{serialDilCurves,dilCurves}=Transpose[MapThread[
		Function[{myDilutionOptions,resolvedSampleVolume,aliquotBoolean,aliquotVolume},
			Module[{serialDilution,dilution,dilutionCurveList,serialDilutionList,dilutionList,requiredPureSampleVol},
				(*First get the serial dilution and dilution options*)
				{dilution,serialDilution}=myDilutionOptions;
				dilutionQ=MapThread[MatchQ[#1,Except[Null]]||MatchQ[#2,Except[Null]]&,{serialDilution,dilution}];

				(*Find how much of the pure sample we need. Either the sample volume or the aliquot volume*)
				requiredPureSampleVol=MapThread[If[aliquotBoolean&&#1,Max[resolvedSampleVolume,#2],resolvedSampleVolume]&,{dilutionQ,aliquotVolume}];

				(*Because the dilution options are index match to each sample instead of each pool we will need to mapthread over a flat list of the options and the pooled samples*)
				dilutionCurveList=Flatten[MapThread[
					Function[{serialDilutionOption,dilutionOption,requiredPureSample},
						(*Use the helper function to calculate the dilution curve volumes*)
						Switch[{serialDilutionOption,dilutionOption},
							{Null,Except[Null]},{calculatedDilutionCurveVolumes[dilutionOption]},
							(*the original serial dilution helper function adds the undiluted sample and a blank to the dilution curve after the resolver.
					In this experiment, most use cases will not need a blank. If a blank is necessary it can be added as a separate sample or custom dilution.
					Further, rather than adding an additional well for the undiluted sample such that total dilutions = NumberOfDilutions + 1,
					we want total dilutions = NumberOfDilutions so we will take all except the last dilution output by the original helper function.*)
							{Except[Null],Null},{
							{
								Most[Prepend[calculatedDilutionCurveVolumes[serialDilutionOption][[1]],SafeRound[Total[{First@calculatedDilutionCurveVolumes[serialDilutionOption][[1]],requiredPureSample}],0.1*Microliter]]],
								Most[Prepend[calculatedDilutionCurveVolumes[serialDilutionOption][[2]],0*Microliter]]
							}
						},
							{Null,Null},{Null}
						]
					],
					{serialDilution,dilution,requiredPureSampleVol}
				],1];

				(*split it into dilution curve or serial dilution curve*)
				serialDilutionList=Flatten[MapThread[
					Function[{serialDilutionOption,dilutionOption,dilutionCurve},
						Switch[{serialDilutionOption,dilutionOption},
							{Except[Null],Null},{dilutionCurve},
							{Null,_},{Null}
						]
					],
					{serialDilution,dilution,dilutionCurveList}
				],1];

				dilutionList=Flatten[MapThread[
					Function[{serialDilutionOption,dilutionOption,dilutionCurve},
						Switch[{serialDilutionOption,dilutionOption},
							{Null,Except[Null]},{dilutionCurve},
							{_,Null},{Null}
						]
					],
					{serialDilution,dilution,dilutionCurveList}
				],1];
				{serialDilutionList,dilutionList}
			]
		],
		{poolExpandedDilutionOptions,Lookup[expandedResolvedOptions,SampleVolume],Lookup[expandedResolvedOptions,Aliquot],Lookup[expandedResolvedOptions,AliquotAmount]}
	]];

	(*Look up some resolved options we will need later*)
	{
		instrument,numReplicatesWithNull, eqTime,rampType,
		cycleNum,rampRate,minTemp,maxTemp,stepNum,stepTime,aliquotVol,sampleVolumes,
		pooledMix, pooledMixType, pooledNumberOfMixes, pooledMixVolume,
		pooledIncubate, pooledIncubationTemperature,pooledIncubationTime, pooledAnnealingTime,containerOut, tempResolution,
		dynamicLightScattering,numberOfDynamicLightScatteringAcquisitions,dynamicLightScatteringAcquisitionTime,
		automaticDynamicLightScatteringLaserSettings,dynamicLightScatteringLaserPower,dynamicLightScatteringDiodeAttenuation,
		dynamicLightScatteringMeasurements, dynamicLightScatteringMeasurementTemperatures,dynamicLightScatteringCapillaryLoading
	} = Lookup[expandedResolvedOptions,
		{
			Instrument,NumberOfReplicates,EquilibrationTime,TemperatureRamping,
			NumberOfCycles,TemperatureRampRate, MinTemperature, MaxTemperature, NumberOfTemperatureRampSteps,StepHoldTime,
			AliquotAmount,SampleVolume,NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixVolume,NestedIndexMatchingIncubate,
			NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime,ContainerOut,TemperatureResolution,
			DynamicLightScattering,NumberOfDynamicLightScatteringAcquisitions,DynamicLightScatteringAcquisitionTime,
			AutomaticDynamicLightScatteringLaserSettings,DynamicLightScatteringLaserPower,DynamicLightScatteringDiodeAttenuation,
			DynamicLightScatteringMeasurements, DynamicLightScatteringMeasurementTemperatures, DynamicLightScatteringCapillaryLoading
		}
	];

	(*Get all the sample objects used by this experiment.*)
	nonInputSamples=Cases[DeleteDuplicates[Flatten[Lookup[expandedResolvedOptions,{Diluent,Buffer,DetectionReagent,PassiveReference}]]],ObjectP[Object[]]];

	(*If numReplicatesWithNull is Null (default), treat it as 1. *)
	numReplicates = ReplaceAll[numReplicatesWithNull, Null -> 1];
	
	(*Calculate the total number of samples including dilutions and replicates for each pooledSample*)
	totalSampleNums = MapThread[Switch[{#1,#2,#3},
		(*If there are serial dilution options and the pool length is greater than one*)
		{Except[{Null..}],{Null..},GreaterP[1]}, numReplicates*Max[Length@First[#]&/@Cases[#1,Except[Null]]],
		(*If there are dilution options and the pool length is greater than one*)
		{{Null..},Except[{Null..}],GreaterP[1]}, numReplicates*Max[Length@First[#]&/@Cases[#2,Except[Null]]],
		(*If there are serial dilution options and no pooling*)
		{Except[{Null..}],{Null..},EqualP[1]}, numReplicates*Length[First@Flatten[#1,1]],
		(*If there are dilution options and no pooling*)
		{{Null..},Except[{Null..}],EqualP[1]}, numReplicates*Length[First@Flatten[#2,1]],
		(*If there are no dilution options*)
		{{Null..},{Null..},_}, numReplicates
	]&,
		{serialDilCurves,dilCurves,poolLengths}];

	(*Find all the unique samples in*)
	uniqueSamplesIn = DeleteDuplicates[Flatten[myPooledSamples]];

	(*Find all unique dilution containers*)
	uniqueDilutionContainers = DeleteDuplicates[Cases[Flatten[Lookup[expandedResolvedOptions,DilutionContainer],1],{_Integer,ObjectP[]}]];
	uniqueDilutionContainerObjects = DeleteDuplicates@uniqueDilutionContainers[[All,2]];
	dilutionStorageConditionRules = MapThread[#1->#2&,{Cases[Flatten[Lookup[expandedResolvedOptions,DilutionContainer],1],{_Integer,ObjectP[]}],Cases[Flatten[Lookup[expandedResolvedOptions,DilutionStorageCondition]],Except[Null]]}];
	uniqueDilutionStorageConditions = Values[DeleteDuplicates[dilutionStorageConditionRules]];

	(*Make the download fields for the instrument*)
	instrumentFields = Switch[instrument,
		ObjectP[Model[Instrument,MultimodeSpectrophotometer]], Packet[CCDArraySaturationIntensityData],
		ObjectP[Object[Instrument,MultimodeSpectrophotometer]], Packet[Model[CCDArraySaturationIntensityData]],
		_, Packet[Object]
	];

	(* Get the cache *)
	cache=Lookup[ToList[ops],Cache];
	
	(*Make download call for containers.*)
	{
		sampleContainerPackets,
		sampleVolumePackets,
		containerOutPacket,
		dilutionContainerPackets,
		liquidHandlerContainerMaxVols,
		inputSampleContainerModels,
		nonInputSampleContainerModels,
		instrumentData
	}=Quiet[
		Download[
			{
				uniqueSamplesIn,
				uniqueSamplesIn,
				{Lookup[expandedResolvedOptions,ContainerOut]},
				uniqueDilutionContainerObjects,
				liquidHandlerContainers,
				Flatten[myPooledSamples],
				nonInputSamples,
				{instrument}
			},
			{
				{Container[Object]},
				{Packet[Volume]},
				{Packet[Object,NumberOfWells]},
				{Packet[Object, NumberOfWells]},
				{MaxVolume},
				{Container[Model][Object]},
				{Container[Model][Object]},
				{instrumentFields}
			},
			Cache->cache,
			Simulation->simulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];
	
	(* Collapse aliquot containers *)
	collapsedAliquotContainers=Flatten[DeleteDuplicates/@PartitionRemainder[Lookup[myResolvedOptions,AliquotContainer],numReplicates],1];
	
	(* Create rules for input samples to container models -- if the user requests an aliquot into hamilton compatible container, when we generate the sample resources with container models below, we won't account for this and FRQ will throw a warning that we will move them. This is because we don't simulate aliquoting, so as far as FRQ knows, the container is in its original container. By creating these rules, we are effectively making the sample resource for the aliquot container *)
	sampleAliquotContainerRules=MapThread[
		Function[
			{sampleList,currentContainer,aliquotContainer},
			If[
				NullQ[aliquotContainer],
				MapThread[#1->#2&,{sampleList,currentContainer}],
				#->aliquotContainer[[2]]&/@sampleList
			]
		],
		{myPooledSamples,Unflatten[Flatten[inputSampleContainerModels],myPooledSamples],collapsedAliquotContainers}
	];
	
	(* Create allSample container model association*)
	allSampleContainerModels=DeleteDuplicates[Flatten[{sampleAliquotContainerRules,Thread[Download[nonInputSamples,Object]->nonInputSampleContainerModels]}]];
	
	(* -- Generate samples in resources -- *)

	(*Find which pooled samples are being aliquoted and expand to match the number of samples in*)
	aliquotBool = MapThread[ConstantArray[#1,#2]&,{Lookup[expandedResolvedOptions,Aliquot],poolLengths}];

	(*Find which samples in are serially diluted prior to pooling*)
	serialDilutionBool = If[MatchQ[#,Null],
		False,
		True
	]&/@Flatten[serialDilCurves,1];

	(*Find which samples in are diluted*)
	dilutionBool = If[MatchQ[#,Null],
		False,
		True
	]&/@Flatten[dilCurves,1];

	(*For diluted samples that are pooled with non diluted samples we need to account for the additional aliquots/volume needed of its pooling partner*)
	(*To do this we need to find the number of dilutions for the pool and then later multiply the aliquot volume or sample volume of the undiluted samples by that amount.*)
	dilutionPartnerNumbers = MapThread[
		Function[{serialBool, pooledSerialDilutions, dilBool, pooledDilutions, poolLength},
			Switch[{serialBool, dilBool,poolLength},
				(*If the pool has atleast one sample that is serially diluted, find the max length of the dilution curve and expand to match the pool length*)
				{Except[{False..}], _, GreaterEqualP[2]}, ConstantArray[Max@Map[Length@First[#] &, Cases[pooledSerialDilutions, Except[Null]]], poolLength],
				(*If the pool has atleast one sample that is diluted, find the max length of the dilution curve and expand to match the pool length*)
				{_, Except[{False..}], GreaterEqualP[2]},  ConstantArray[Max@Map[Length@First[#] &, Cases[pooledDilutions, Except[Null]]], poolLength],
				(*catch all*)
				{_, _, _}, ConstantArray[1, poolLength]]],
		{TakeList[serialDilutionBool, poolLengths], serialDilCurves, TakeList[dilutionBool, poolLengths], dilCurves, poolLengths}
	];

	(*expand the pooled sample volumes to match samples in. For pooled samples, divide by the pool length to get the volume of each sample if they were mixed in a 1:1 ration (see below)*)
	expandedSampleVolumes = MapThread[ConstantArray[SafeRound[#1/#2,10^-1*Microliter],#2]&,{sampleVolumes,poolLengths}];

	(*Big switch to calculate required sample volumes per sample in*)
	(*This switch will return required sample volumes in the sample pool groups as samples in. So if the pooled samples are {{s1,s2},{s3}}, will will get back {{volS1,volS2},{volS3}}*)
	(*Request 15% extra of the samples in except when aliquoting. When aliquoting is specified take only the resolved aliquot volume.*)
	reqSampleVols = Flatten@MapThread[
		Function[{aliquot,serialDil,dilution,aliquotVolume,volume,serialDilCurve,dilCurve,dilutionPartnerNum},

			Switch[{aliquot,serialDil,dilution},

				(*If the sample is being serially diluted each replicate will require the initial dilution volume (which is the first dilution volume + first transfer volume). We have already checked in out resolver that this volume is enough to fulfill any downstream aliquotting.*)
				{_,True,False}, 1.15*SafeRound[First[serialDilCurve[[1]]],10^-1*Microliter],

				(*If the sample is being diluted each replicate will require the sum of all the sample volumes.*)
				{_,False,True}, 1.15*SafeRound[Total@First@dilCurve,10^-1*Microliter],

				(*If the sample is being aliquoted but not diluted only require the aliquot volume*)
				{True,False,False}, aliquotVolume*dilutionPartnerNum,

				(*If the sample is not being aliquoted or diluted only require the sample volume. This assumes if no aliquotting or dilution is specified that the samples in a pool are mixed at a 1:1 ratio in the reaction plate.*)
				{False,False,False}, 1.15*volume*dilutionPartnerNum
			]
		],
		{Flatten@aliquotBool,serialDilutionBool,dilutionBool,Flatten@aliquotVol,Flatten@expandedSampleVolumes,Flatten[serialDilCurves,1],Flatten[dilCurves,1],Flatten[dilutionPartnerNumbers]}
	];

	(*Create the sample volume rules*)
	(*Request 15% extra of the samples in*)
	sampleVolRules = MapThread[
		Rule[#1,#2]&,
		{Flatten[Download[myPooledSamples,Object]],reqSampleVols}
	];

	(*Merge the rules and total the required volumes for any repeated samples*)
	uniqueSampleVolRules = Merge[sampleVolRules,numReplicates*Total[#]&];

	(*Make the sample resource rules. The volume is as calculated above multiplied by a scalar to account for volume loss in the liquid handler during transfers*)
	(*If the sample is not in a liquid handler compatible container, put it in one.*)
	samplesInResourceRules = KeyValueMap[
		Switch[Lookup[allSampleContainerModels,#1],
			ObjectP[liquidHandlerContainers], #1 -> Resource[Sample -> #1, Amount-> SafeRound[#2, 10^-1*Microliter], Name -> ToString[Unique[]]],
			_, #1 -> Resource[Sample -> #1, Container->First@PickList[liquidHandlerContainers,Flatten@liquidHandlerContainerMaxVols,GreaterEqualP[#2]], Amount-> SafeRound[#2, 10^-1*Microliter], Name -> ToString[Unique[]]]
			]&,
		uniqueSampleVolRules
	];

	(*Make the samplesIn resources by replacing the sample object reference with the matching resources. Repeated samples should point to the same resource*)
	(*Expand the samples in by the replicate number and then flatten*)
	samplesInWithReplicates = Flatten[
		ConstantArray[#1, numReplicates]&/@Download[myPooledSamples,Object]
	];

	samplesInResources = Replace[samplesInWithReplicates, samplesInResourceRules, {1}];

	(* -- Generate pooled containers in resource -- *)
	(*Get the containers for all input samples and find the unique containers.*)
	containersIn=DeleteDuplicates[Flatten@sampleContainerPackets];

	(*Create ContainersIn resource*)
	containersInResource = (Resource[Sample->#, Name -> ToString[Unique[]]]&) /@containersIn;

	(* -- Generate container out resource -- *)
	(*Find the required number of wells*)
	requiredWells = Total[totalSampleNums];

	(*Expand the number of containers to accommodate the number of wells*)
	containersOutNeeded =If[
		MatchQ[Lookup[expandedResolvedOptions,ContainerOut],Except[Null]],
		Switch[Lookup[Flatten@containerOutPacket, NumberOfWells],
			(*If the container is a multi-well format*)
			{_Integer}, Ceiling[requiredWells/Lookup[Flatten@containerOutPacket, NumberOfWells]],
			(*If the container is a tube or other single well container*)
			_, requiredWells
		],
		{}
	];

	requiredContainers = If[
		MatchQ[Lookup[expandedResolvedOptions,ContainerOut],Except[Null]],
		ConstantArray[containerOut,containersOutNeeded],
		{}
	];

	(*Make containers out resource*)
	containersOutResource = Resource[Sample -> #, Name -> ToString[Unique[]]]&/@requiredContainers;

	(* -- Generate passive reference resources -- *)
	(*Look up the option values*)
	{passiveRefObj, passiveRefVol} = Lookup[expandedResolvedOptions,{PassiveReference,PassiveReferenceVolume}];

	(*Find the required volume*)
	requiredPassRefVol = Switch[passiveRefObj,
		Null,Null,
		ObjectP[], passiveRefVol*Total[totalSampleNums]
	];

	(*Create resource*)
	passiveRefResource = If[MatchQ[passiveRefObj,ObjectP[]],
		Switch[Lookup[allSampleContainerModels,passiveRefObj],
		Except[ObjectP[liquidHandlerContainers]],Link@Resource[Sample -> passiveRefObj, Name -> ToString[Unique[]], Amount -> SafeRound[requiredPassRefVol,10^-1*Microliter], Container->First@PickList[liquidHandlerContainers,Flatten@liquidHandlerContainerMaxVols,GreaterEqualP[requiredPassRefVol]]],
			_, Link@Resource[Sample -> passiveRefObj, Name -> ToString[Unique[]], Amount -> SafeRound[requiredPassRefVol,10^-1*Microliter]]
			],
		Null
	];

	(* -- Generate buffer resources -- *)
	(*Look up option values*)
	{buffers,bufferVolumes}=Lookup[expandedResolvedOptions,{Buffer,BufferVolume}];

	(*Mapthread to calculate required buffer volume for each pooled sample. If resolved buffer is Null, return Null.*)
	(*The buffer volume will need to take into account any additional dilutions of that sample. totalSampleNums/numReplicates*)
	(*In the compiler the buffer volume will be split evenly across each dilution well.*)
	requiredBufferVolumeRules = MapThread[
		Switch[#2,
			Null, Null,
			ObjectP[], #2->#1*#3]&,
		{totalSampleNums/numReplicates,Download[buffers,Object],bufferVolumes}];

	(*Remove Nulls from required volume rules. Then, merge the required volume rules to get one total volume per buffer*)
	reqBufferVolsNoNulls = Cases[requiredBufferVolumeRules,Except[Null]];
	mergedBufferRequiredVols = Merge[reqBufferVolsNoNulls,numReplicates*Total[#]&];

	(*create buffer resource rules*)
	bufferResourceRules = KeyValueMap[
		Switch[Lookup[allSampleContainerModels,#1],
		Except[ObjectP[liquidHandlerContainers]], #1->Resource[Sample ->#1 , Name -> ToString[Unique[]], Amount -> SafeRound[#2, 10^-1*Microliter], Container->First@PickList[liquidHandlerContainers,Flatten@liquidHandlerContainerMaxVols,GreaterEqualP[#2]]],
		_, #1->Resource[Sample ->#1 , Name -> ToString[Unique[]], Amount -> SafeRound[#2, 10^-1*Microliter]]
	]&,
		mergedBufferRequiredVols];

	(*Make the buffer resources by replacing the buffer object reference with the matching resources. Repeated buffers should point to the same resource*)
	(*Expand the buffer by the replicate number and then flatten*)
	buffersWithReplicates = Flatten[
		ConstantArray[#1, numReplicates]&/@Download[buffers,Object]
	];

	bufferResources = Replace[buffersWithReplicates, bufferResourceRules, {1}];

	(* -- Generate detection reagent resources -- *)
	(*Look up option values*)
	{detectionReagent,detectionReagentVol}=Lookup[expandedResolvedOptions,{DetectionReagent,DetectionReagentVolume}];

	(*Mapthread to calculate required reagent volume for each pooled sample. If resolved buffer is Null, return Null.*)
	(*The detection reagent volume will need to take into account any additional dilutions of that sample. totalSampleNums/numReplicates*)
	(*In the compiler the reagent volume will be split evenly across each dilution well.*)
	requiredDetectionVolumeRules = MapThread[
		Switch[#2,
			Null, Null,
			ObjectP[], #2->#1*#3]&,
		{totalSampleNums/numReplicates,Download[detectionReagent,Object],detectionReagentVol}];

	(*Remove Nulls from required volume rules. Then, merge the required volume rules to get one total volume per detection reagent*)
	reqDetectionVolsNoNulls = Cases[requiredDetectionVolumeRules,Except[Null]];
	(*20% excess detection reagent volume is added to the resource required volume*)
	mergedDetectionRequiredVols = Merge[reqDetectionVolsNoNulls,1.2*numReplicates*Total[#]&];

	(*create detection reagent resource rules*)
	detectionResourceRules = KeyValueMap[
		Switch[Lookup[allSampleContainerModels,#1],
			Except[ObjectP[liquidHandlerContainers]], #1->Resource[Sample ->#1 , Name -> ToString[Unique[]], Amount -> SafeRound[#2, 10^-1*Microliter], Container->First@PickList[liquidHandlerContainers,Flatten@liquidHandlerContainerMaxVols,GreaterEqualP[#2]]],
			_, #1->Resource[Sample ->#1 , Name -> ToString[Unique[]], Amount -> SafeRound[#2, 10^-1*Microliter]]
		]&,
		mergedDetectionRequiredVols];

	(*Make the detection resources by replacing the object reference with the matching resources. Repeated reagents should point to the same resource*)
	(*Expand the detection reagent by the replicate number and then flatten*)
	detectionWithReplicates = Flatten[
		ConstantArray[#1, numReplicates]&/@Download[detectionReagent,Object]
	];

	detectionResources = Replace[detectionWithReplicates, detectionResourceRules, {1}];

	(* -- Generate diluent resources -- *)
	(*Look up diluent options for each sample in*)
	diluents = Flatten@Lookup[expandedResolvedOptions,Diluent];

	(*Mapthread to calculate the required diluent volume for each sample in*)
	requiredDiluentVolumes = MapThread[
		Switch[{#1,#2,#3},
			{ObjectP[],_,Null}, #1->Total[#2[[2]]],
			{ObjectP[],Null,_}, #1->Total[#3[[2]]],
			{Null,Null,Null}, Null
		]&,
		{diluents,Flatten[serialDilCurves,1],Flatten[dilCurves,1]}
	];

	(*Remove Nulls from required volume rules. Then, merge the required volume rules to get one total volume per Diluent*)
	reqDiluentVolsNoNulls = Cases[requiredDiluentVolumes,Except[Null]];
	mergedDiluentRequiredVols = Merge[reqDiluentVolsNoNulls,numReplicates*Total[#]&];

	(*create diluent resource rules*)
	diluentResourceRules = KeyValueMap[
		Switch[Lookup[allSampleContainerModels,#1],
			Except[ObjectP[liquidHandlerContainers]], #1->Resource[Sample ->#1 , Name -> ToString[Unique[]], Amount -> SafeRound[#2, 10^-1*Microliter], Container->First@PickList[liquidHandlerContainers,Flatten@liquidHandlerContainerMaxVols,GreaterEqualP[#2]]],
			_, #1->Resource[Sample ->#1 , Name -> ToString[Unique[]], Amount -> SafeRound[#2, 10^-1*Microliter]]
		]&,
		mergedDiluentRequiredVols];

	(*Make the diluent resources by replacing the object reference with the matching resources. Repeated diluents should point to the same resource*)
	(*Expand the diluent by the replicate number and then flatten*)
	pooledDiluents=TakeList[diluents,poolLengths];
	diluentWithReplicates = Flatten[
		Flatten@ConstantArray[#1, numReplicates]&/@pooledDiluents
	];

	diluentResources = Replace[diluentWithReplicates, diluentResourceRules, {1}];

	(* -- Generate Dilution container resources -- *)
	(*Lookup resolved dilution containers*)
	(*The format will be {{grouping index, container object}...}*)
	(*Group replicates together on the same plate*)
	dilutionContainers = Flatten[Lookup[expandedResolvedOptions,DilutionContainer],1];

	(*for each sample find the group index and how many wells are required*)
	indexedRequiredDilutionWellsRules = MapThread[
		Switch[{#1,#2,#3},
			{_,Null,Except[Null]}, #3[[1]]->numReplicates*Length[First@#1],
			{Null,_,Except[Null]}, #3[[1]]->numReplicates*Length[First@#2],
			{_,_,Null}, Null
		]&,
		{Flatten[serialDilCurves,1],Flatten[dilCurves,1],dilutionContainers}
	];

	(*Remove nulls and then merge the required well numbers for each group index*)
	reqDilutionWellsNoNulls = Cases[indexedRequiredDilutionWellsRules,Except[Null]];
	mergedDilutionWells = Merge[reqDilutionWellsNoNulls,Total];

	(*Find the number of required containers *)
	dilutionContainersNeeded = Flatten[
		Map[
			If[MatchQ[#1,Null],
				Null,
				Module[{container,containerPacket,containerCapacity,reqWells},
					(*get the container object for this group*)
					container = #1[[2]];
					(*get the corresponding packet for the container*)
					containerPacket = Cases[Flatten@dilutionContainerPackets,KeyValuePattern[Object->Download[container,Object]]];
					(*get the container capacity*)
					containerCapacity = Lookup[containerPacket,NumberOfWells];
					(*get the calculated required wells*)
					reqWells = Lookup[mergedDilutionWells,#1[[1]]];
					(*Generate array of required containers*)
					Switch[containerCapacity,
						{_Integer}, ConstantArray[container,Ceiling[reqWells/containerCapacity]],
						_,ConstantArray[container,reqWells]
					]
				]
			]&,
			dilutionContainers
		]
	];

	(*Find the unique containers and make resource replace rules for them*)
	dilutionContainersNeededNoNulls = Cases[dilutionContainersNeeded,Except[Null]];
	uniqueContainerResourcesRules = #->Resource[Sample -># , Name -> ToString[Unique[]]]&/@Cases[DeleteDuplicates[dilutionContainersNeeded],Except[Null]];

	(*Replace the list of needed containers with the created resources*)
	dilutionContainerResources = Replace[dilutionContainersNeededNoNulls,uniqueContainerResourcesRules,{1}];

	(* if we are running on the Uncle and use manual loading, we need another plate from which we will load with a multichannel
	 this is a bit ugly, but saves the trouble of re-engineering the whole plate thing*)
	manualLoadingPlateResource=If[MatchQ[dynamicLightScatteringCapillaryLoading, Manual],
		Resource[
			Sample->Model[Container, Plate, "id:01G6nvkKrrYm"](* 96-well PCR Plate *)
		],
		Null
	];

	(* - ManualLoadingPipette - only if we are loading manual. I am not a huge fan of this solution, but its a simpler fix than to rearrange how the sample prep plate is set *)
	manualLoadingPipetteResource=If[MatchQ[dynamicLightScatteringCapillaryLoading, Manual],
		Resource[
			Instrument->Model[Instrument, Pipette, "id:qdkmxzqZMw31"](* Eppendorf Research Plus, 8-channel 10uL *)
		],
		Null
	];

	(* - ManualLoadingTips - only if we are loading manual. I am not a huge fan of this solution, but its a simpler fix than to rearrange how the sample prep plate is set *)
	manualLoadingTipsResource=If[MatchQ[dynamicLightScatteringCapillaryLoading, Manual],
		Resource[
			Sample->Model[Item, Tips, "id:8qZ1VW0Vx7jP"](* 0.1 - 10 uL Tips, Low Retention, Non-Sterile *),
			Amount->requiredWells
		],
		Null
	];

	(* -- Generate instrument resources -- *)

	(* === Calculate an estimate of how long the run will take === *)
	instrumentTime = Module[{totalEqTime,totalRampTime,totalStepTime,totalDLSTime},
		(*Total equilibration time is the resolved equilibration time multiplied by the number of equilibration cycles (one before each heating and cooling ramp)*)
		totalEqTime = 2*cycleNum*eqTime;

		(*Total ramp time is the time for the instrument to ramp from minimum temperature to maximum temperature at the resolved ramp rate multiplied by the number of heating/cooling ramps.*)
		totalRampTime =  2*cycleNum*(maxTemp-minTemp)/rampRate;

		(*If the ramp time is step, calculate the hold time at each step. On the Uncle each sample takes ~3seconds to read so we need to also account for read time.*)
		totalStepTime = If[MatchQ[rampType,Step], 2*cycleNum*stepNum*(stepTime+3.4*Second*Total[totalSampleNums]), 0*Second];

		(* If we are taking DLS measurements, calculate how long they will take *)
		totalDLSTime=If[

			(* IF we are not taking DLS measurements *)
			Not[dynamicLightScattering],

			(* THEN this will take no time *)
			0*Minute,

			(* ELSE, the measurement takes 52 seconds per capillary, and take into account whether this measurement is being done Before, After, or both Before and After thermal ramping *)
			(requiredWells*52*Second*Length[dynamicLightScatteringMeasurements])
		];

		(*Add calculated times together plus additional set-up and tear-down time*)
		SafeRound[totalEqTime+totalRampTime+totalStepTime+totalDLSTime+10*Minute,10^-1 Minute]
	];

	(* Create instrument resource *)
	(* if the instrument specified is the QuantStudio 7 Flex OR the ViiA 7, make the resource for both of them.  this is for CMU vs Austin site things to work smoothly for now *)
	(* Model[Instrument, Thermocycler, "ViiA 7"] and Model[Instrument, Thermocycler, "QuantStudio 7 Flex"] *)
	instrumentResource = If[MatchQ[Download[instrument, Object], ObjectP[{Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"]}]],
		Resource[Instrument -> {Model[Instrument, Thermocycler, "id:D8KAEvdqzXYk"], Model[Instrument, Thermocycler, "id:R8e1PjeaXle4"]}, Time -> instrumentTime],
		Resource[Instrument -> instrument, Time -> instrumentTime]
	];

	(* -- Generate reaction preparation plate container resources -- *)
	(*If a prepared plate is given, this should be the container in*)
	liquidHandlerCompatibleContainers = Join[
		Search[Model[Container, Plate], LiquidHandlerPrefix != Null && Deprecated != True],
		PreferredContainer[All, Type -> Vessel, LiquidHandlerCompatible -> True]
	];

	samplesInLHContainerQ = AllTrue[DeleteDuplicates[Flatten[myPooledSamples]/.allSampleContainerModels],MatchQ[#,ObjectP[liquidHandlerCompatibleContainers]]&];

	thermocyclerPreparedPlateQ = If[MatchQ[instrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]],
		AllTrue[DeleteDuplicates[Flatten[myPooledSamples]/.allSampleContainerModels],MatchQ[#,ObjectP[{Model[Container, Plate, "id:pZx9jo83G0VP"](* 384-well qPCR Optical Reaction Plate *)}]]&],
		True
	];

	currentSampleVolume = Lookup[Cases[Flatten@sampleVolumePackets, KeyValuePattern[Object->ObjectP[#]]], Volume]&/@Download[Flatten@myPooledSamples,Object];
	pooledSampleVolume = Total/@TakeList[Flatten@currentSampleVolume,poolLengths];

	aliquotRequiredQ =MapThread[
		Switch[{#1,#2,#3,passiveRefVol},
			{_ ,Null|0Microliter,Null|0Microliter,Null|0Microliter}, False,
			{EqualP[#4], _, _, _}, False,
			{_,_,_,_}, True
	]&,
		{Flatten@sampleVolumes, Flatten@bufferVolumes, Flatten@detectionReagentVol, Flatten@pooledSampleVolume}
	];

	preparedPlateQ = And[
		MatchQ[DeleteDuplicates[Flatten@dilutionQ],{False}],
		MatchQ[DeleteDuplicates[poolLengths], {1}],
		MatchQ[Length[containersIn],1],
		samplesInLHContainerQ,
		thermocyclerPreparedPlateQ,
		MatchQ[numReplicates,1],
		MatchQ[DeleteDuplicates[Flatten@aliquotRequiredQ],{False}]
	];

	(* Only need this for samples run on the Uncle where we need to mix with detection reagent, buffer, and/or passive reference prior to loading in the capillary strip*)
	{reactionContainerResource} = Switch[
		{Download[instrument,Object], preparedPlateQ},
		{ObjectP[{Object[Instrument,MultimodeSpectrophotometer],Model[Instrument,MultimodeSpectrophotometer]}], False},
		{Link[Resource[Sample ->Model[Container, Plate, "id:01G6nvkKrrYm"](* 96-well PCR Plate *), Name -> ToString[Unique[]]]]},
		{ObjectP[{Object[Instrument,MultimodeSpectrophotometer],Model[Instrument,MultimodeSpectrophotometer]}], True},
		Link/@containersIn,
		{_,_}, {Null}
	];

	(* -- Generate assay container resources -- *)
	(*Get the assay container object based on the resolved instrument*)
	assayContainerObject = Switch[instrument,
		ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}],Model[Container, Plate, "id:pZx9jo83G0VP"](* 384-well qPCR Optical Reaction Plate *),
		ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}], Model[Container, Plate, CapillaryStrip, "id:R8e1Pjp9Kjjj"](* Uncle 16-capillary strip *)
	];

	(*Get the number of required containers based on the total number of sample wells*)
	reqAssayContainerNum = Switch[instrument,
		(*if the instrument is a thermocycler only need one assay plate. we've already error checked to make sure that all the samples will fit on this plate.*)
		ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}], 1,
		(*if the instrument is a Uncle need to calculate the number of 16-well strips needed. Cannot exceed 3 and we've already error checked for this.*)
		ObjectP[{Model[Instrument,MultimodeSpectrophotometer],Object[Instrument,MultimodeSpectrophotometer]}], Ceiling[Total[totalSampleNums]/16]
	];

	(*Create the resource list*)
	(*If we have a prepared plate that is compatible with the ViiA7 that is our assay container.*)
	assayContainerResource = Switch[{instrument,preparedPlateQ},
		{ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}], True},Link/@containersIn,
		{_,_}, Table[Resource[Sample ->assayContainerObject, Name -> ToString[Unique[]]],reqAssayContainerNum]
	];

	(* -- Generate resources for additional parts/accessories needed -- *)

	If[MatchQ[instrument,ObjectP[{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]],
		{
			plateSealResource = Link[Resource[Sample -> Model[Item, PlateSeal, "id:L8kPEjnvlDrN"](* qPCR Plate Seal, Clear *), Name -> ToString[Unique[]]]],
			capillaryClipResource = Null,
			capillaryClipGasketResource = Null,
			uncleStageLid = Null,
			capillaryStripPlateLoader = Null
		},
		{
			plateSealResource = Null,
			capillaryStripPlateLoader = If[MatchQ[dynamicLightScatteringCapillaryLoading, Manual],
				Link[Resource[Sample->Model[Container, Plate, "id:3em6ZvLwoEK7"](* Uncle 16-capillary strip plate loader V3.0 *),Rent->True, Name -> ToString[Unique[]]]],
				Link[Resource[Sample->Model[Container, Plate, "id:GmzlKjP9KdJ9"](* Uncle 16-capillary strip plate loader *),Rent->True, Name -> ToString[Unique[]]]]
			],
			capillaryClipResource = Link/@Table[Resource[Sample->Model[Container, Rack, "id:3em6ZvLn3XJW"](* Uncle capillary strip clip *), Rent->True, Name -> ToString[Unique[]]],reqAssayContainerNum],
			capillaryClipGasketResource = Link[Resource[Sample->Model[Item, Consumable, "id:dORYzZJxz8mG"](* Uncle capillary strip clip gaskets *),Amount->2*reqAssayContainerNum,Name -> ToString[Unique[]]]],
			uncleStageLid = Link[Resource[Sample->Model[Part, "id:wqW9BP7nKP1R"](* Uncle sample stage lid *), Rent->True, Name -> ToString[Unique[]]]]
		}
	];

	(* generate the non-expanded NestedIndexMatchingMixSamplePreparation and NestedIndexMatchingIncubateSamplePreparation fields *)
	pooledMixField = MapThread[
		<|
			Mix -> #1,
			MixType -> #2,
			NumberOfMixes -> #3,
			MixVolume -> #4,
			Incubate -> False
		|>&,
		{pooledMix, pooledMixType, pooledNumberOfMixes, pooledMixVolume}
	];

	pooledIncubateField = MapThread[
		<|
			Incubate -> #1,
			IncubationTemperature -> #2,
			IncubationTime -> #3,
			Mix -> False,
			MixType -> Null,
			MixUntilDissolved -> Null,
			MaxIncubationTime -> Null,
			IncubationInstrument -> Null,
			AnnealingTime -> #4,
			IncubateAliquotContainer -> Null,
			IncubateAliquot -> Null,
			IncubateAliquotDestinationWell -> Null
		|>&,
		{pooledIncubate, pooledIncubationTemperature,pooledIncubationTime, pooledAnnealingTime}
	];

	(* Reformat the laser optimization options for the protocol packet*)
	{optiWavelengthSpan,optiIntensityPercentSpan} = Lookup[expandedResolvedOptions,{LaserOptimizationEmissionWavelengthRange,LaserOptimizationTargetEmissionIntensityRange}];
	optiWavelengthRanges =If[MatchQ[#,Null], Null, {First[#],Last[#]}]&/@optiWavelengthSpan;
	optiIntensityPercentRanges = If[MatchQ[#,Null], Null, {First[#],Last[#]}]&/@optiIntensityPercentSpan;
	optiIntensityRanges = If[MatchQ[instrument,ObjectP[{Object[Instrument,Thermocycler],Model[Instrument,Thermocycler]}]],
		optiIntensityPercentRanges,
		calculateUncleOptimizationIntensity[optiIntensityPercentRanges,optiWavelengthRanges,Flatten@instrumentData]
	];

	(*expand the laser optimization options for any pooled sample dilutions*)
	(*Gather the dilution information for each sample by pool*)
	transposeDilutionCurve = If[Length[#]>0,Transpose[#],#]&/@Flatten[dilCurves,1];
	transposeSerialDilutionCurve = If[Length[#]>0,Transpose[#],#]&/@Flatten[serialDilCurves,1];
	dilutionLengths = Length/@transposeDilutionCurve + Length/@transposeSerialDilutionCurve;
	pooledDilutionLengths = TakeList[dilutionLengths,poolLengths];
	maxDilutionLengths = Max/@pooledDilutionLengths;

	expandedLaserOptiOptions = Flatten[MapThread[
		Function[{dilLength,fluorOpti,slsOpti,optiWavelength,optiSignal},
			Switch[dilLength,
				GreaterEqualP[1], Transpose@{
				ConstantArray[fluorOpti,dilLength],
				ConstantArray[slsOpti,dilLength],
				ConstantArray[optiWavelength,dilLength],
				ConstantArray[optiSignal,dilLength]
			},
				_, {{fluorOpti,slsOpti,optiWavelength,optiSignal}}
			]
		],
		{maxDilutionLengths,Lookup[expandedResolvedOptions,OptimizeFluorescenceLaserPower],Lookup[expandedResolvedOptions,OptimizeStaticLightScatteringLaserPower],optiWavelengthRanges,optiIntensityRanges}
	],1];

	expandedFluorescenceOptiBool=expandedLaserOptiOptions[[All,1]];
	expandedSlsOptiBool=expandedLaserOptiOptions[[All,2]];
	expandedOptiEmWavelength=expandedLaserOptiOptions[[All,3]];
	expandedOptiIntensity=expandedLaserOptiOptions[[All,4]];

	(* expand the pooled-indexed fields according to the NumberOfReplicates *)
	{expPooledSamplesIn,expPooledMixField,expPooledIncubateField,sampleVolumesWithReplicates,bufferVolumesWithReplicates,
		detectionVolumesWithReplicates,dilutionsWithReplicates,serialDilWithReplicates,dilutionMixWithReplicates,dilutionMixNumWithReplicates,
		dilutionMixRatesWithReplicates,fluorExWithReplicates,slsExWithReplicates,emWithReplicates,minEmWithReplicates,maxEmWithReplicates,
		fluorPowerWithReplicates,slsPowerWithReplicates,optiWavelengthRangeWithReplicates,optiIntensityRangeWithReplicates,optimizeFluorLaserWithReps,optimizeSLSLaserWithReps
	}=Flatten[
		Map[
			Function[{listEntry}, ConstantArray[listEntry,numReplicates]], #]
		,1]&/@{Download[myPooledSamples,Object],pooledMixField,pooledIncubateField,sampleVolumes,bufferVolumes,
		detectionReagentVol,dilCurves,serialDilCurves,Lookup[expandedResolvedOptions,DilutionMixVolume]/.Null->None,Lookup[expandedResolvedOptions,DilutionNumberOfMixes]/.Null->None,
		Lookup[expandedResolvedOptions,DilutionMixRate]/.Null->None,Lookup[expandedResolvedOptions,ExcitationWavelength],Lookup[expandedResolvedOptions,StaticLightScatteringExcitationWavelength],
		Lookup[expandedResolvedOptions,EmissionWavelength],Lookup[expandedResolvedOptions,MinEmissionWavelength],Lookup[expandedResolvedOptions,MaxEmissionWavelength],
		Lookup[expandedResolvedOptions,FluorescenceLaserPower],Lookup[expandedResolvedOptions,StaticLightScatteringLaserPower],expandedOptiEmWavelength,expandedOptiIntensity,
		expandedFluorescenceOptiBool,expandedSlsOptiBool
		};

	(*Reformat the dilution curves to get them in the right format (sample and diluent pairs)*)
	transposeDilutionCurve = If[Length[#]>0,Transpose[#],#]&/@Flatten[dilutionsWithReplicates,1];
	transposeSerialDilutionCurve = If[Length[#]>0,Transpose[#],#]&/@Flatten[serialDilWithReplicates,1];
	dilutionCurvesNoNulls = transposeDilutionCurve/.Null->None;
	serialDilutionCurvesNoNulls = transposeSerialDilutionCurve/.Null->None;

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Object->CreateID[Object[Protocol,ThermalShift]],
		Type -> Object[Protocol,ThermalShift],
		Replace[SamplesIn] -> Map[Link[#,Protocols]&,samplesInResources],
		Replace[PooledSamplesIn] ->expPooledSamplesIn,
		UnresolvedOptions -> RemoveHiddenOptions[ExperimentThermalShift, myUnresolvedOptions],
		ResolvedOptions -> RemoveHiddenOptions[ExperimentThermalShift, myResolvedOptions],
		Instrument -> Link[instrumentResource],
		TotalSampleNumber -> requiredWells,

		(*Pooling fields*)
		Replace[NestedIndexMatchingMixSamplePreparation] -> expPooledMixField,
		Replace[NestedIndexMatchingIncubateSamplePreparation] -> expPooledIncubateField,

		(*Container resources*)
		Replace[ContainersIn] -> Map[Link[#,Protocols]&,containersInResource],
		Replace[ContainersOut] -> Map[Link[#]&,containersOutResource],
		Replace[DilutionContainers] -> Map[Link[#]&,dilutionContainerResources],
		Replace[DilutionStorageConditions] -> uniqueDilutionStorageConditions,
		Replace[AssayContainers] -> Map[Link[#]&,assayContainerResource],
		PreparedPlate -> preparedPlateQ,
		Replace[CapillaryStripPreparationPlate] -> reactionContainerResource,

		(*Reaction object sample resources*)
		Replace[Buffers] -> Link/@bufferResources,
		Replace[Diluents] -> Link/@diluentResources,
		Replace[DetectionReagents] -> Link/@detectionResources,
		PassiveReferenceDye -> passiveRefResource,

		(*Reaction sample object volumes*)
		ReactionVolume -> Lookup[expandedResolvedOptions,ReactionVolume],
		Replace[SampleVolumes] -> sampleVolumesWithReplicates,
		Replace[BufferVolumes] -> bufferVolumesWithReplicates,
		Replace[DetectionReagentVolumes] -> detectionVolumesWithReplicates,
		PassiveReferenceDyeVolume -> Lookup[expandedResolvedOptions,PassiveReferenceVolume],

		(*Dilution Curve volumes and mixing*)
		Replace[Dilutions] -> dilutionCurvesNoNulls,
		Replace[SerialDilutions] -> serialDilutionCurvesNoNulls,
		Replace[DilutionMixVolumes] -> Flatten[dilutionMixWithReplicates,1],
		Replace[DilutionNumberOfMixes] -> Flatten[dilutionMixNumWithReplicates,1],
		Replace[DilutionMixRates] -> Flatten[dilutionMixRatesWithReplicates,1],

		(*Instrument-specific accessories resources*)
		PlateSeal->plateSealResource,
		Replace[CapillaryClips]->capillaryClipResource,
		CapillaryGaskets->capillaryClipGasketResource,
		SampleStageLid -> uncleStageLid,
		CapillaryStripLoadingRack->capillaryStripPlateLoader,
		DynamicLightScatteringManualLoadingPlate -> Link[manualLoadingPlateResource],
		DynamicLightScatteringManualLoadingPipette -> Link[manualLoadingPipetteResource],
		DynamicLightScatteringManualLoadingTips -> Link[manualLoadingTipsResource],

		(*Thermal profile parameters*)
		MinTemperature->minTemp,
		MaxTemperature->maxTemp,
		TemperatureRampOrder->Lookup[expandedResolvedOptions,TemperatureRampOrder],
		NumberOfCycles -> cycleNum,
		EquilibrationTime -> eqTime,
		TemperatureRamping->rampType,
		TemperatureRampRate->rampRate,
		NumberOfTemperatureRampSteps -> stepNum,
		StepHoldTime->stepTime,
		TemperatureResolution->tempResolution,
		RunTime->Convert[instrumentTime,Minute],

		(*Detection parameters*)
		Replace[ExcitationWavelengths]->fluorExWithReplicates,
		Replace[StaticLightScatteringExcitationWavelengths] -> slsExWithReplicates,
		Replace[EmissionWavelengths] -> emWithReplicates,
		Replace[MinEmissionWavelengths] -> minEmWithReplicates,
		Replace[MaxEmissionWavelengths] -> maxEmWithReplicates,
		Replace[FluorescenceLaserPower] -> fluorPowerWithReplicates,
		Replace[StaticLightScatteringLaserPower] -> slsPowerWithReplicates,
		Replace[OptimizeFluorescenceLaserPower]->optimizeFluorLaserWithReps,
		Replace[OptimizeStaticLightScatteringLaserPower]->optimizeSLSLaserWithReps,
		Replace[LaserOptimizationEmissionWavelengthRange]->optiWavelengthRangeWithReplicates,
		Replace[LaserOptimizationTargetEmissionIntensityRange]->optiIntensityRangeWithReplicates,
		DynamicLightScattering->dynamicLightScattering,
		Replace[DynamicLightScatteringMeasurements]->dynamicLightScatteringMeasurements,
		Replace[DynamicLightScatteringMeasurementTemperatures]->dynamicLightScatteringMeasurementTemperatures,
		DynamicLightScatteringAcquisitionTime->dynamicLightScatteringAcquisitionTime,
		NumberOfDynamicLightScatteringAcquisitions->numberOfDynamicLightScatteringAcquisitions,
		AutomaticDynamicLightScatteringLaserSettings->automaticDynamicLightScatteringLaserSettings,
		DynamicLightScatteringLaserPower->dynamicLightScatteringLaserPower,
		DynamicLightScatteringDiodeAttenuation->dynamicLightScatteringDiodeAttenuation,
		DynamicLightScatteringCapillaryLoading->dynamicLightScatteringCapillaryLoading,

		(*SamplesOutStorage*)
		Replace[SamplesOutStorage]->Lookup[expandedResolvedOptions,SamplesOutStorageCondition],

		Replace[Checkpoints] -> {
			{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
			{"Preparing Samples",30 Minute,"Preprocessing, such as thermal incubation/mixing, centrifugation, and filtration is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Diluting Samples",30 Minute,"Dilution curves or serial dilution curves are generated.",Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Pooling Samples",30 Minute,"Sample pooling is performed followed by pool mixing and incubation.",Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Preparing Assay Containers",15 Minute,"Final assay reaction assembly and transfer to assay containers if necessary is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Acquiring Data",instrumentTime,"Thermal cycling is performed and sample measurements are taken.",Link[Resource[Operator -> $BaselineOperator, Time -> instrumentTime]]},
			{"Sample Post-Processing",5 Minute,"Sample transfer to storage container, if necessary, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 5 Minute]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = Quiet@populateSamplePrepFields[myPooledSamples, myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->inheritedCache, Simulation->simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->inheritedCache, Simulation->simulation], Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
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
	outputSpecification /. {previewRule,optionsRule,resultRule,testsRule}
];


Authors[calculateUncleOptimizationIntensity] := {"millie.shah"};

calculateUncleOptimizationIntensity[myIntensitySpans_,myWavelengths_,instrumentData_] := Module[{dataWavelengths,dataIntensities,maxSaturationPointInRequestedRange,intensityRanges},
	dataWavelengths =Flatten[Unitless[Lookup[instrumentData,CCDArraySaturationIntensityData]],1][[All,1]];
	dataIntensities = Flatten[Unitless[Lookup[instrumentData,CCDArraySaturationIntensityData]],1][[All,2]];
	maxSaturationPointInRequestedRange = If[MatchQ[#,Null], Null, Max[PickList[dataIntensities,dataWavelengths,x_/;Between[x,#]]]]&/@Unitless[myWavelengths];
	intensityRanges = MapThread[If[MatchQ[#2,Null]||MatchQ[#1,Null], Null, #1*Normal@#2]&,{maxSaturationPointInRequestedRange,myIntensitySpans}]
];

