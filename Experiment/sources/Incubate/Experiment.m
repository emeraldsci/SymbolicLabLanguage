(* ::Package:: *)

(* ::Title:: *)
(*Experiment Incubate: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentIncubate*)


(* ::Subsection::Closed:: *)
(*Options and constants*)


DefineOptions[
	#,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being incubated, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being incubated, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName->Thaw,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if any SamplesIn are incubated until visibly liquid, before they are mixed and/or incubated.",
				ResolutionDescription->"Automatically set to True if any corresponding Thaw options are set. Otherwise, set to False.",
				Category->"Protocol"
			},
			{
				OptionName->ThawTime,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description->"The minimum interval at which the samples are checked to see if they are thawed.",
				ResolutionDescription->"If Thaw is set to True, this option is automatically set to the ThawTime field in the Object[Sample], if specified. Otherwise, extra small volume samples (under 10mL) will be thawed for 5 Minutes, small volume samples (under 50mL) will be thawed for 15 Minutes, medium volume samples (under 100mL) will be 30 Minutes, and large volume samples (over 100mL) will be thawed for an hour.",
				Category->"Protocol"
			},
			{
				OptionName->MaxThawTime,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description->"The maximum time for which the sample is allowed to thaw.",
				ResolutionDescription->"Automatically set to 5 Hour if Thaw->True for this sample.",
				Category->"Protocol"
			},
			{
				OptionName->ThawTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature, 90 Celsius],Units->Celsius],
				Description->"Temperature at which the SamplesIn are incubated for the duration of the thawing.",
				ResolutionDescription->"Resolves to 40 Celsius if Thaw->True for this sample.",
				Category->"Protocol"
			},
			{
				OptionName->ThawInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Heating",
							"Heat Blocks"
						}
					}
				],
				Description->"The instrument that will be used to thaw this sample.",
				ResolutionDescription->"Automatically set to the first instrument in the list of compatible instruments found by IncubateDevices with the given SamplesIn and ThawTemperature, if Thaw->True.",
				Category->"Protocol"
			},
			{
				OptionName -> Mix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample is mixed.",
				ResolutionDescription -> "Automatically set to True if any Mix related options are set. Otherwise, set to False.",
				Category->"Protocol"
			},
			{
				OptionName -> MixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
				Description -> "Indicates the style of motion used to mix the sample. Options include Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate.",
				ResolutionDescription -> "Automatically sets based on the container of the sample and the Mix option. Specifically, if Mix is set to False, the option is set to Null. If MixInstrument is specified, the option is set based on the type of the Model[Instrument] or Object[Instrument] of the specified MixInstrument. If MixRate and Time are Null, when MixVolume is Null or larger than 50ml, the option is set to Invert, otherwise set to Pipette. If Amplitude, MaxTemperature, or DutyCycle is not Null, the option is set to Homogenizer. If MixRate is set, the option is set based on the type of the Model[Instrument] of the first instrument found by MixDevices that is compatible with the SamplesIn, Temperature, and MixRate.",
				Category->"Protocol"
			},
			{
				OptionName -> MixUntilDissolved,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute.",
				ResolutionDescription -> "Automatically set to True if MaxTime or MaxNumberOfMixes is set.",
				Category->"Protocol"
			},
			{
				OptionName -> Instrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
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
				Description -> "The instrument used to perform the Mix and/or Incubation.",
				ResolutionDescription -> "Automatically resolves based on the options Mix, Temperature, MixType and container of the sample.",
				(* TODO:: I don't think I understand the resolver enough to revise it. *)
				Category->"Protocol"
			},
			{
				OptionName -> StirBar,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type->Object,
					Pattern :> ObjectP[
						{
							Model[Part, StirBar],
							Object[Part, StirBar]
						}
					]
				],
				Description -> "The stir bar that is used to stir the sample.",
				ResolutionDescription -> "If MixRate is above 1000 RPM, or if no compatible impeller can be found for the given stirrer, StirBar is automatically set to the largest compatible stir bar found. Here, a compatible impeller means that it can fit in the aperture of the sample's container, can reach the bottom of the sample's container, and is compatible with the stir instrument given; a compatible stir bar means that its width can fit in the aperture of the sample's container and that its length is not greater than the InternalDiameter of the sample's container. Otherwise set to Null.",
				Category->"Protocol"
			},
			{
				OptionName -> Time,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description -> "Duration of time for which the samples will be mixed.",
				ResolutionDescription -> "Automatically set to 5 Minute for robotic preparation. For manual preparation, if Thaw is True, set to 0 Minute; else if MaxTime is specified, Time is automatically set to 1/3 of MaxTime; otherwise set to 15 Minute. As a special case in manual preparation, when LightExposure is not Null, Thaw is True, set to 0 Minute; else if TotalLightExposure is specified and LightExposureIntensity is not Null, Time is automatically set to TotalLightExposure/LightExposureIntensity; otherwise set to 1 Hour.",
				Category->"Protocol"
			},
			{
				OptionName -> MaxTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description -> "Maximum duration of time for which the samples are mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
				ResolutionDescription -> "Automatically set to 5 Hour if MixUntilDissolved is True, when an applicable MixType is chosen, otherwise set to Null.",
				Category->"Protocol"
			},
			{
				OptionName -> PreSonicationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute,$MaxExperimentTime], Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description -> "Duration of time for which the sonicator water bath degases prior to loading sample.",
				ResolutionDescription -> "Automatically set to 15 Minute for sonication over 1 hour, 0 Minute for sonication less than 1 hour. For MixType other than Sonicate, set to Null.",
				Category->"Protocol"
			},
			{
				OptionName -> AlternateInstruments,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type->Object,
						Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Instruments",
								"Mixing Devices"
							}
						}
					]
				],
				Description -> "The alternative instruments can be used to perform the Mix and/or Incubation. Currently, this is only used when mixing with Sonicator.",
				ResolutionDescription -> "If mix type is Sonicate and Instrument is not specified, resolve to all the other instruments can be used except the resolved Instrument. Otherwise, resolve to Null.",
				Category->"Hidden"
			},
			{
				OptionName -> DutyCycle,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> {
					"Time On"->Widget[Type->Quantity,Pattern:>RangeP[0 Minute, 60 Hour],Units->{1,{Millisecond,{Millisecond,Second,Minute,Hour}}}],
					"Time Off"->Widget[Type->Quantity,Pattern:>RangeP[0 Minute, 60 Hour],Units->{1,{Millisecond,{Millisecond,Second,Minute,Hour}}}]
				},
				Description -> "The style how the homogenizer mixes the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
				ResolutionDescription -> "Automatically set to {10 Millisecond, 10 Millisecond} if mixing by homogenization.",
				Category->"Protocol"
			},
			{
				OptionName -> MixRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"RPM" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
					"Gravitational Acceleration (Acoustic Shaker Only)" -> Widget[Type -> Quantity, Pattern :> RangeP[0 GravitationalAcceleration, 100 GravitationalAcceleration], Units->GravitationalAcceleration]
				],
				Description -> "The frequency of rotation used by the mixing instrument to mix the samples.",
				ResolutionDescription -> "Automatically set to 300 RPM for robotic preparation. For manual preparation, MixRate is set to 20% of the MaxRotationRate if MixType is Stir, or otherwise is set to the average of MinRotationRate and MaxRotationRate of the instrument.",
				Category->"Protocol"
			},
			{
				OptionName -> MixRateProfile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[{
					"Time" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Minute, $MaxExperimentTime],
						Units -> {1,{Minute,{Minute,Second,Hour}}}
					],
					"MixRate" -> Alternatives[
						"RPM" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
						"Gravitational Acceleration (Acoustic Shaker Only)" -> Widget[Type -> Quantity, Pattern :> RangeP[0 GravitationalAcceleration, 100 GravitationalAcceleration], Units->GravitationalAcceleration]
					]
				}],
				Description -> "The frequency of rotation of the mixing instrument used to mix the samples, over the course of time.",
				Category -> "Protocol"
			},
			{
				OptionName -> NumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description -> "The number of times the samples are mixed if MixType of Pipette or Invert is chosen.",
				ResolutionDescription -> "If MaxNumberOfMixes is specified, automatically set to 1/3 of MaxNumberOfMixes (round to integer); else if MixUntilDissolved->True, automatically set to 25; otherwise set to 15.",
				Category -> "Protocol"
			},
			{
				OptionName -> MaxNumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Number, Pattern :> RangeP[1, 250, 1]],
				Description -> "The maximum number of times for which the samples are mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
				ResolutionDescription -> "When MixUntilDissolved->True, automatically set to 2*NumberOfMixes if it is Numeric (specified or automatically set); if not, set to 50.",
				Category -> "Protocol"
			},
			{
				OptionName -> MixVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0.5 Microliter, 50 Milliliter],Units :> {1,{Milliliter,{Microliter,Milliliter}}}],
				Description -> "The volume of the sample that is pipetted up and down to mix if MixType->Pipette.",
				ResolutionDescription->"For robotic preparation, automatically set to 970 Microliter or sample volume informed by the field Volume of the sample, whichever is smaller. For manual preparation, automatically set to 50 Milliliter or half of the sample volume informed by the field Volume of the sample, whichever is smaller.",
				Category -> "Protocol"
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],Units :> Celsius],
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
				],
				Description -> "The temperature of the device that is used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn is automatically adjusted if the measured temperature of the sample exceeds this set temperature.",
				ResolutionDescription->"Automatically set to 40 Celsius if AnnealingTime is specified, if not, set to Ambient.",
				Category -> "Protocol"
			},
			{
				OptionName -> TemperatureProfile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[{
					"Time" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Minute, $MaxExperimentTime],
						Units -> {1,{Minute,{Minute,Second,Hour}}}
					],
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinTemperatureProfileTemperature, $MaxTemperatureProfileTemperature],
						Units -> Celsius
					]
				}],
				Description -> "The temperature of the device, over the course of time, that is used to mix/incubate the sample.",
				Category -> "Protocol"
			},
			{
				OptionName -> MaxTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius],Units :> Celsius],
				Description -> "The maximum temperature that the sample is allowed to reach during mixing via homogenization or sonication. If the measured temperature is above this MaxTemperature, the homogenizer/sonicator turns off until the measured temperature is 2C below the MaxTemperature, then it automatically resumes.",
				Category -> "Protocol"
			},

			{
				OptionName->RelativeHumidity,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
					Units -> Percent
				],
				Description->"The amount of water vapor present in air that the samples are exposed to during incubation, relative to the amount needed for saturation.",
				ResolutionDescription->"Automatically set to 70 Percent if using an environmental chamber with relative humidity control.",
				Category -> "General"
			},

			{
				OptionName->LightExposure,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> EnvironmentalChamberLightTypeP (* UVLight | VisibleLight *)
				],
				Description->"The range of wavelengths of light that the incubated samples are exposed to. Only available when incubating the samples in an environmental chamber with UVLight and VisibleLight control.",
				ResolutionDescription->"Automatically set to UVLight if LightExposureIntensity is in units of Watt/Meter^2, set to VisibleLight if LightExposureIntensity is in units of Lumen/Meter^2, otherwise set to Null.",
				Category -> "General"
			},

			{
				OptionName->LightExposureIntensity,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"UV Light Intensity"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[2 Watt/(Meter^2), 36 Watt/(Meter^2)],
						Units -> CompoundUnit[{1, {Watt, {Watt}}}, {-2, {Meter, {Meter}}}]
					],
					"Visible Light Intensity"-> Widget[
						Type -> Quantity,
						Pattern :> RangeP[2 Lumen/(Meter^2), 29000 Lumen/(Meter^2)],
						Units -> CompoundUnit[{1, {Lumen, {Lumen}}}, {-2, {Meter, {Meter}}}]
					]
				],
				Description->"The intensity of light that the incubated samples will be exposed to during the course of the incubation. UVLight exposure is measured in Watt/Meter^2 and Visible Light Intensity is measured in Lumen/Meter^2.",
				ResolutionDescription->"Automatically set to 19 Watt/Meter^2 if LightExposure is set to UVLight and 14500 Lumen/Meter^2 if LightExposure is set to VisibleLight. Otherwise, set to Null.",
				Category -> "General"
			},

			{
				OptionName->TotalLightExposure,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"UV Light Exposure"->Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Watt*Hour/(Meter^2)],
						Units -> CompoundUnit[{1, {Watt*Hour, {Watt*Hour}}}, {-2, {Meter, {Meter}}}]
					],
					"Visible Light Exposure"-> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Lumen*Hour/(Meter^2)],
						Units -> CompoundUnit[{1, {Lumen*Hour, {Lumen*Hour}}}, {-2, {Meter, {Meter}}}]
					]
				],
				Description->"The total exposure of light that the incubated samples are exposed to during the course of the incubation. UVLight exposure is measured in Watt*Hour/Meter^2 and Visible Light exposure is measured in Lumen*Hour/Meter^2.",
				ResolutionDescription->"Automatically calculated by LightExposureIntensity*Time.",
				Category -> "General"
			},

			{
				OptionName -> OscillationAngle,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 AngularDegree, 15 AngularDegree],Units :> AngularDegree],
				Description -> "The angle of oscillation of the mixing motion when a wrist action shaker is used.",
				Category -> "Protocol"
			},
			{
				OptionName -> Amplitude,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[10 Percent, 100 Percent],Units :> Percent],
				Description -> "The amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
				Category -> "Protocol"
			},
			{
				OptionName->AnnealingTime,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units->{1,{Hour,{Second,Minute,Hour}}}],
				Description->"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the Time has passed.",
				ResolutionDescription->"Automatically set to 0 Minute (or to Null in cases where the sample is not being incubated).",
				Category->"Protocol"
			},

			(* add robotic-specific options for mix *)
			{
				OptionName -> MixFlowRate,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.4 Microliter/Second,500 Microliter/Second],
					Units -> CompoundUnit[
						{1,{Milliliter,{Microliter,Milliliter,Liter}}},
						{-1,{Second,{Second,Minute}}}
					],
					PatternTooltip -> "The speed at which liquid should be drawn up into the pipette tip."
				],
				AllowNull -> True,
				Default -> Automatic,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated. This option can only be set if Preparation->Robotic.",
				ResolutionDescription->"Automatically set to 100 Microliter/Second when mixing by pipetting if Preparation->Robotic.",
				Category-> "Protocol"
			},
			{
				OptionName -> MixPosition,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> PipettingPositionP,
					PatternTooltip -> "The location from which liquid should be aspirated."
				],
				AllowNull -> True,
				Default -> Automatic,
				Description -> "The location from which liquid should be mixed by pipetting. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to LiquidLevel if MixType->Pipette and Preparation->Robotic.",
				Category-> "Protocol"
			},
			{
				OptionName -> MixPositionOffset,
				Widget -> Alternatives[
					"Z Offset" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Millimeter],
						Units -> {Millimeter,{Millimeter}}
					],
					"{X,Y,Z} Coordinate Offset" -> Widget[
						Type -> Expression,
						Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
						Size -> Line
					]
				],
				AllowNull -> True,
				Default -> Automatic,
				Description -> "The distance from the center of the well that liquid will aspirated/dispensed while mixing the sample. When specifying a Z Offset, the Z Offset is calculated either as the height below the top of the well, the height above the bottom of the well, or the height below the detected liquid level, depending on value of the AspirationPosition option (Top|Bottom|LiquidLevel). When an AspirationAngle is specified, the AspirationPositionOffset is measured in the frame of reference of the tilted labware (so that wells that are further away from the pivot point of the tilt are in the same frame of reference as wells that are close to the pivot point of the tilt). This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to 2 Millimeter if MixType->Pipette and Preparation->Robotic.",
				Category-> "Protocol"
			},
			{
				OptionName -> MixTiltAngle,
				Default -> Null,
				Description -> "The angle that the sample's container is tilted during the mixing of the sample. The container is pivoted on its left edge when tilting occurs. This option can only be provided if Preparation->Robotic.",
				AllowNull -> True,
				Category-> "Protocol",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
					Units -> {AngularDegree,{AngularDegree}}
				]
			},
			{
				OptionName -> CorrectionCurve,
				Widget ->  Adder[
					{
						"Target Volume" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Microliter, 1000 Microliter],
							Units -> {Microliter,{Microliter,Milliliter}}
						],
						"Actual Volume" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Microliter, 1250 Microliter],
							Units -> {Microliter,{Microliter,Milliliter}}
						]
					}
				],
				AllowNull -> True,
				Default -> Automatic,
				Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to correction curve set in the PipettingMethod for the Object[Sample] if MixType->Pipette and Preparation->Robotic.",
				Category-> "Protocol"
			},
			{
				OptionName->Tips,
				Default->Automatic,
				ResolutionDescription -> "If MixType->Pipette, automatically set to the preferred tips determined by TransferDevices with given MixVolume, as well as TipType and TipMaterial if specified, and it is also checked that the tips can reach the bottom of the container.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Item, Tips],
						Object[Item, Tips]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Labware",
							"Pipette Tips"
						}
					}
				],
				Description->"The pipette tips used to aspirate and dispense the requested volume..",
				Category-> "Protocol"
			},
			{
				OptionName -> TipType,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>TipTypeP
				],
				AllowNull -> True,
				Default -> Automatic,
				Description -> "The tip type to use to mix liquid in the manipulation.",
				ResolutionDescription -> "If Tips is specified, automatically set to the field TipType of the Model[Item, Tips] or the Model of Object[Item,Tips]. Otherwise, set to Null.",
				Category-> "Protocol"
			},
			{
				OptionName->TipMaterial,
				Default->Automatic,
				ResolutionDescription -> "If Tips is specified, automatically set to the field Material of the Model[Item, Tips] or the Model of Object[Item,Tips]. Otherwise, set to Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>MaterialP
				],
				Description->"The material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category-> "Protocol"
			},
			{
				OptionName -> MultichannelMix,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to True if there are multiple samples that are mixed via pipette, if MixType->Pipette.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if multiple device channels should be used when performing pipette mixing.",
				Category-> "Protocol"
			},
			{
				OptionName -> MultichannelMixName,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to a unique identifier that indicates that the transfers occur during the same time if MultichannelMix->True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size->Line
				],
				Description -> "The unique identitifer for the multichannel mix.",
				Category->"Hidden"
			},
			{
				OptionName -> DeviceChannel,
				Default -> Automatic,
				Description -> "The channel of the work cell that should be used to perform the pipetting mixing. This option can only be set if Preparation->Robotic and MixType->Pipette.",
				ResolutionDescription -> "Automatically set to SingleProbe1 if MultichannelMix->False. Otherwise, set to the appropriate channel to perform the transfer, if Preparation->Robotic and MixType->Pipette.",
				AllowNull -> True,
				Category-> "Protocol",
				Widget->Widget[Type->Enumeration,Pattern:>DeviceChannelP]
			},
			(* add robotic-specific options for incubate *)
			{
				OptionName->ResidualIncubation,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the incubation and/or mixing should continue after Time/MaxTime has finished while waiting to progress to the next step in the protocol.",
				ResolutionDescription->"Automatically set to True if Temperature is non-Ambient and the samples being incubated have non-ambient TransportTemperature.",
				Category->"Protocol"
			},
			{
				OptionName -> ResidualTemperature,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> RangeP[0 Celsius, 105 Celsius],Units -> Celsius],
					Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
				],
				AllowNull -> True,
				Default -> Automatic,
				Description -> 	"The temperature at which the sample(s) should remain incubating after Time has elapsed. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to Temperature if ResidualIncubation is True and Preparation->Robotic.",
				Category->"Protocol"
			},
			{
				OptionName -> ResidualMix,
				Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
				AllowNull -> True,
				Default -> Automatic,
				Description -> "Indicates that the sample(s) should remain shaking at the ResidualMixRate after Time has elapsed. This option can only be set if Preparation->Robotic.",
				Category->"Protocol",
				ResolutionDescription -> "Automatically set to False if Preparation->Robotic."
			},
			{
				OptionName -> ResidualMixRate,
				(* NOTE: MinRotationRate on the Heater Shaker, MaxRotationRate on the Heater Shaker. *)
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
				AllowNull -> True,
				Default -> Automatic,
				Category->"Protocol",
				Description -> "When mixing by shaking, this is the rate at which the sample(s) remains shaking after Time has elapsed. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to MixRate if ResidualMix is True and Preparation->Robotic."
			},
			{
				OptionName -> Preheat,
				Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
				AllowNull -> True,
				Default -> Automatic,
				Category->"Protocol",
				Description -> "Indicates if the incubation position is brought to Temperature before exposing the Sample to it. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to False if Preparation->Robotic."
			},
			(* Transform-specific options *)
			{
				OptionName -> Transform,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				AllowNull -> True,
				Default -> Automatic,
				Category -> "Cell Transformation",
				Description -> "Indicates whether the incubation is intended to heat-shock cells in order to disrupt the cell membrane and allow a plasmid to be taken up and incorporated into the cell.",
				ResolutionDescription -> "Automatically set to True if any Transform-related options are specified. Otherwise, automatically set to Null if there are no cells detected in the input samples."
			},
			{
				OptionName -> TransformHeatShockTemperature,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[37*Celsius, 47*Celsius], Units -> Celsius],
				AllowNull -> True,
				Default -> Automatic,
				Category -> "Cell Transformation",
				Description -> "The temperature at which the cells should be heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				ResolutionDescription -> "Automatically set to 42 Celsius if Transform is True."
			},
			{
				OptionName -> TransformHeatShockTime,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0*Second, 120*Second], Units -> Second],
				AllowNull -> True,
				Default -> Automatic,
				Category -> "Cell Transformation",
				Description -> "The length of time for which the cells should be heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				ResolutionDescription -> "Automatically set to 45 Second if Transform is True."
			},
			{
				OptionName -> TransformPreHeatCoolingTime,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0*Minute, 120*Minute], Units -> Minute],
				AllowNull -> True,
				Default -> Automatic,
				Category -> "Cell Transformation",
				Description -> "The length of time for which the cells should be cooled prior to heat shocking in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				ResolutionDescription -> "Automatically set to 25 Minute if Transform is True."
			},
			{
				OptionName -> TransformPostHeatCoolingTime,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0*Minute, 60*Minute], Units -> Minute],
				AllowNull -> True,
				Default -> Automatic,
				Category -> "Cell Transformation",
				Description -> "The length of time for which the cells should be cooled after heat shocking in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
				ResolutionDescription -> "Automatically set to 2 Minute if Transform is True."
			},
			{
				OptionName -> TransformRecoveryMedia,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Cell Culture"
						}
					}
				],
				AllowNull -> True,
				Default -> Automatic,
				Category -> "Cell Transformation",
				Description -> "The recovery media used to incubate the cells after heat shocking.",
				ResolutionDescription -> "Must be provided as an object if Transform is True."
			},
			{
				OptionName -> TransformRecoveryTransferVolumes,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Cell Transformation",
				Widget -> {
					"Initial transfer volume" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Milliliter],
						Units -> {Milliliter, {Microliter, Milliliter}}
					],
					"Secondary transfer volume" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Milliliter],
						Units -> {Milliliter, {Microliter, Milliliter}}
					]
				},
				Description -> "The amount of the aliquot of recovery media added to the cells after heat shocking, and the volume of resulting mixture that is recombined with the recovery media.",
				ResolutionDescription -> "Automatically set to approximately 25% of the maximum volume of the container of the cells, and the volume of the resulting mixture."
			},
			{
				OptionName -> TransformIncubator,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Cell Transformation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Instrument, Incubator]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Cell Culture",
							"Cell Incubation"
						}
					}
				],
				Description -> "The model of the incubator used to recover the cells after heat shock.",
				ResolutionDescription -> "Set to Model[Instrument, Incubator, Innova 44 for Bacterial Plates]."
			},
			{
				OptionName -> TransformIncubatorTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Cell Transformation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellIncubationTemperatureP (* 30 C, 37 C *)
				],
				Description -> "The temperature at which the input cells are incubated for a short duration after heat shock. Currently, 37 Degrees Celsius is supported.",
				ResolutionDescription -> "Set to 37 Celsius."
			},
			{
				OptionName -> TransformIncubatorShakingRate,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Cell Transformation",
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> RPM],
				Description -> "The frequency at which the input cells are agitated by movement in a circular motion during recovery incubation following transformation. Currently, 200 RPM is supported.",
				ResolutionDescription -> "Set to 200 RPM."
			},
			{
				OptionName -> TransformRecoveryIncubationTime,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Cell Transformation",
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units->Alternatives[Second, Minute, Hour]],
				Description -> "The duration for which the input cells incubated for recovery after transformation.",
				ResolutionDescription -> "Set to 1 Hour."
			}
		],
		{
			OptionName->LightExposureStandard,
			Default->Null,
			AllowNull->True,
			Widget->Adder[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Object[Container]}]
				]
			],
			Description->"During light exposure experiments, a set of samples that are placed in an opaque box to receive identical incubation conditions without exposure to light. This option can only be set if incubating other samples in an environmental stability chamber with light exposure.",
			Category -> "General"
		},
		{
			OptionName->EnableSamplePreparation,
			Default->True,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the sample preperation options for this function should be resolved. This option is set to False when ExperimentIncubate is called within resolveSamplePrepOptions to avoid an infinite loop.",
			Category->"Hidden"
		},

		(* Shared Options *)
		(* Note: Here we would usually just include NonBiologyFuntopiaSharedOptions, but since this is a sample prep *)
		(* experiment, we have to exclude the Incubate/Mix prep options. *)
		CentrifugePrepOptionsNew,
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> CentrifugeAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category->"Sample Preparation",
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container]],
					ObjectTypes->{Model[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				]
			}
		],
		FilterPrepOptionsNew,
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> FilterAliquotContainer,
				Default -> Automatic,
				Description -> "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull -> True,
				Category->"Sample Preparation",
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container]],
					ObjectTypes->{Model[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				]
			}
		],
		AliquotOptions,
		PreparatoryUnitOperationsOption,
		(* For Model[Sample] input, since we use Incubate to thaw cell samples before ExperimentThawCells is online, we have to allow pick up the whole cell vial as default. *)
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to All."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			AliquotOptions,
			AliquotContainer,
			{Description->"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired."}
		],
		ModifyOptions[
			AliquotOptions,
			Aliquot,
			{Description-> "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment."}
		],

		(* Other shared options. *)
		WorkCellOption,
		PreparationOption,
		ProtocolOptions,
		SimulationOption,
		NonBiologyPostProcessingOptions,
		SamplesInStorageOption,

		{
			OptionName->ExperimentFunction,
			Default->ExperimentIncubate,
			AllowNull->True,
			Widget->Widget[
				Type->Expression,
				Pattern:>_,
				Size->Line
			],
			Description->"The experiment function that we're actually calling.",
			Category->"Hidden"
		},
		{
			OptionName -> UploadResources,
			Default -> True,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the resource blobs from the resource packets function should actually be uploaded.",
			Category->"Hidden"
		}
	}
]&/@{ExperimentIncubate,ExperimentMix};

$IncubateLiquidHandlerFootprints = Alternatives[Plate,MALDIPlate];

$TransformInstruments = Alternatives[Model[Instrument, HeatBlock, "id:Z1lqpMrx4XW0"]]; (* "Cole-Parmer StableTemp Digital Utility Water Baths, 10 liters for Transform" *)
$TransformContainerMaxHeight = 18*Centimeter;

(* Model[Container, Rack, "2 mL Glass Vial Orbital Shaker Rack"] adapter which has 35 slots. *)
$GlassVialOrbitalShakerRackPositions = 35;

(* Sonicator Flask Ring parameters *)
$MaxFlaskRingAperture = 70 Millimeter;
$MinFlaskRingAperture = 19 Millimeter;
$FlaskRingClearance = 5 Millimeter;


(* ::Subsection::Closed:: *)
(*ExperimentIncubate *)


(* Container and Prepared Samples Overload *)
ExperimentIncubate[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification, output, gatherTests, listedContainers, listedOptions, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, samplePreparationSimulation, containerToSampleResult, containerToSampleOutput, containerToSampleTests,
		containerToSampleSimulation, samples, sampleOptions
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentIncubate,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> All
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
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
			ExperimentIncubate,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation,
			EmptyContainers->MatchQ[$ECLApplication,Engine]
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentIncubate,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation,
				EmptyContainers->MatchQ[$ECLApplication,Engine]
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
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples, converted options, and simulated cache. *)
		ExperimentIncubate[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];


ExperimentIncubate[myInputs:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples,listedOptionsHumidity,listedOptions,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,result,resourcePackets,resourcePacketTests,
		instruments, groupedInstruments, vortexes,shakerModels,shakerObjects, bottleRollers, rollers,stirrerModels,stirrerObjects, sonicators, heatBlocks,
		supportedSonicationContainers, manualInstrumentModels, manualInstrumentObjects, preferredVessels, sampleFields, modelSampleFields,
		objectContainerFields, modelContainerFields,modelContainerPacket,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,samplePreparationSimulation,homogenizers,simulation,performSimulationQ,
		simulatedProtocol,disruptors,nutators,environmentalChambers,mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed,
		safeOpsNamed, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ,
		resolvedPreparation,resolvedWorkCell, postProcessingOptions,thermocyclers, manualStirBarObjects
	},

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	(* quieting because we could throw an ObjectDoesNotExist error here, but if we do we will already do that in a more robust way later so silence it for now *)
	{listedSamples, listedOptionsHumidity} = removeLinks[ToList[myInputs], ToList[myOptions]];

	(* MM converts % into Rational number instead of Real which breaks our upload pattern *)
	listedOptions = Module[{newHumidity},
		(* return early if user did not specify humidity *)
		If[MatchQ[listedOptionsHumidity, {}|Null],
			Return[listedOptionsHumidity,Module]];

		(* return early if it was Automatic *)
		If[MatchQ[Lookup[listedOptionsHumidity, RelativeHumidity,{}], {}|Null|ListableP[Automatic]],
			Return[listedOptionsHumidity,Module]];

		newHumidity = N@Lookup[listedOptionsHumidity, RelativeHumidity];
		(* return new values *)
		KeyValueMap[#1->#2&,
			Append[Association@listedOptionsHumidity, RelativeHumidity->newHumidity]
		]
	];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentIncubate,
			listedSamples,
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentIncubate,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentIncubate,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* change Named version of objects into ID version *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentIncubate,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentIncubate,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentIncubate,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentIncubate,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentIncubate,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Get the mix instruments in the lab that are not deprecated. *)
	instruments=Flatten[{
		mixInstrumentsSearch["Memoization"],
		Cases[ToList[myOptions],ObjectP[Object[Instrument]],Infinity]
	}];

	(* Separate out these instruments by instrument type. *)
	groupedInstruments=GroupBy[instruments,#[Type]&];
	vortexes=Flatten[Lookup[groupedInstruments,{Model[Instrument,Vortex],Object[Instrument,Vortex]},{}]];
	shakerModels=Flatten[Lookup[groupedInstruments,Model[Instrument,Shaker],{}]];
	shakerObjects=Flatten[Lookup[groupedInstruments,Object[Instrument,Shaker],{}]];
	bottleRollers=Flatten[Lookup[groupedInstruments,{Model[Instrument,BottleRoller],Object[Instrument,BottleRoller]},{}]];
	rollers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Roller],Object[Instrument,Roller]},{}]];
	stirrerModels=Flatten[Lookup[groupedInstruments,Model[Instrument,OverheadStirrer],{}]];
	stirrerObjects=Flatten[Lookup[groupedInstruments,Object[Instrument,OverheadStirrer],{}]];
	sonicators=Flatten[Lookup[groupedInstruments,{Model[Instrument,Sonicator],Object[Instrument,Sonicator]},{}]];
	(*TODO: once it's no longer a developer object, remove the subsequent hardcode*)
	heatBlocks=DeleteDuplicates@Flatten[{Lookup[groupedInstruments,{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock]},{}],List@@$TransformInstruments}];
	homogenizers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Homogenizer],Object[Instrument,Homogenizer]},{}]];
	disruptors=Flatten[Lookup[groupedInstruments,{Model[Instrument,Disruptor],Object[Instrument,Disruptor]},{}]];
	nutators=Flatten[Lookup[groupedInstruments,{Model[Instrument,Nutator],Object[Instrument,Nutator]},{}]];
	environmentalChambers=Flatten[Lookup[groupedInstruments,{Model[Instrument,EnvironmentalChamber],Object[Instrument,EnvironmentalChamber]},{}]];
	thermocyclers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]},{}]];

	(* Supported sonication containers that will fit in the sonication floats or self stand. *)
	supportedSonicationContainers=compatibleSonicationContainers[];

	(* Get any manually supplied instruments in our options. *)
	manualInstrumentModels=Cases[ToList[expandedSafeOps],ObjectP[{Model[Instrument]}]];
	manualInstrumentObjects=Cases[ToList[expandedSafeOps],ObjectP[{Object[Instrument]}]];
	manualStirBarObjects=Cases[ToList[expandedSafeOps],ObjectP[Object[Part,StirBar]]];

	(* Get all of our preferred vessels. *)
	preferredVessels=DeleteDuplicates[Flatten[{
		PreferredContainer[All,Type->Vessel],
		PreferredContainer[All,Sterile->True,LightSensitive->True,Type->Vessel],
		PreferredContainer[All,Sterile->False,LightSensitive->True,Type->Vessel],
		PreferredContainer[All,Sterile->True,LightSensitive->False,Type->Vessel],
		Model[Container, Plate, "id:L8kPEjkmLbvW"],(*"96-well 2mL Deep Well Plate"*)
		Model[Container, Vessel, "id:xRO9n3vk11mz"] (* 50mL beaker *)
	}]];

	(* Sample Fields. *)
	sampleFields=Packet@@Join[SamplePreparationCacheFields[
		Object[Sample]], {RequestedResources}];
	modelSampleFields=Join[SamplePreparationCacheFields[
		Model[Sample]], {RequestedResources}];
	objectContainerFields=Join[SamplePreparationCacheFields[
		Object[Container]], {RequestedResources}];
	modelContainerFields=Join[SamplePreparationCacheFields[
		Model[Container]], {RequestedResources}];
	modelContainerPacket=Packet@@modelContainerFields;

	(* Extract the packets that we need from our downloaded cache. *)
	cacheBall=FlattenCachePackets@Quiet[Flatten[{Download[
		{
			(* Download {WettedMaterials, Positions, MaxRotationRate, MinRotationRate} from our instruments. *)
			ToList[mySamplesWithPreparedSamples],
			ToList[mySamplesWithPreparedSamples],
			ToList[mySamplesWithPreparedSamples],
			ToList[mySamplesWithPreparedSamples],
			manualInstrumentModels,
			manualInstrumentObjects,
			manualStirBarObjects,
			vortexes,
			shakerModels,
			shakerObjects,
			bottleRollers,
			rollers,
			stirrerModels,
			stirrerObjects,
			sonicators,
			heatBlocks,
			homogenizers,
			disruptors,
			nutators,
			environmentalChambers,
			thermocyclers,
			preferredVessels
		},
		{
			{sampleFields},
			{Packet[Model[modelSampleFields]]},
			{Packet[Container[objectContainerFields]]},
			{Packet[Container[Model][modelContainerFields]]},
			(*manualInstrumentModels*)
			{Packet[All]},
			{Packet[Model],Packet[Model[All]]}, (*Object[Instrument] fields are almost totally Computable, which is terrible for speed. We instead download Model and then all the Model fields, none of which is computable*)
			(*explicitly mentioned stir bars*)
			{Packet[Name,Model,Object,StirBarWidth,StirBarLength]},
			(*vortexes*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, Model, MinTemperature, MaxTemperature]},
			(*shakerModels*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model, CompatibleAdapters, Objects, MaxForce, MinForce,IntegratedLiquidHandlers,ProgrammableTemperatureControl,
				ProgrammableMixControl,MaxOscillationAngle,MinOscillationAngle, GripperDiameter, MaxWeight],Packet[CompatibleAdapters[Positions, CompatibleVolumetricFlasks]]},
			(*shakerObjects*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model, CompatibleAdapters, Objects,MaxForce, MinForce,IntegratedLiquidHandlers,ProgrammableTemperatureControl,
				ProgrammableMixControl,MaxOscillationAngle,MinOscillationAngle, GripperDiameter, MaxWeight]},
			(*bottleRollers*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, RollerSpacing, Model, Objects]},
			(*rollers*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model, CompatibleRacks, Objects], Packet[CompatibleRacks[Positions]]},
			(*stirrerModels*)
			{Packet[Name,WettedMaterials,Positions,MaxRotationRate,MinRotationRate,MinTemperature,MaxTemperature,CompatibleImpellers,Model,StirBarControl,MaxStirBarRotationRate,MinStirBarRotationRate],Packet[CompatibleImpellers[{StirrerLength,MaxDiameter,ImpellerDiameter,Name, WettedMaterials}]]},
			(*stirrerObjects*)
			{Packet[Name,WettedMaterials,Positions,MaxRotationRate,MinRotationRate,MinTemperature,MaxTemperature,CompatibleImpellers,Model,MaxStirBarRotationRate,MinStirBarRotationRate]},
			(*sonicators*)
			{Packet[Name, WettedMaterials, Positions, MinTemperature, MaxTemperature, Model, CompatibleSonicationAdapters],
				Packet[CompatibleSonicationAdapters[Positions, Aperture]]},
			(*heatBlocks*)
			{Packet[Name, MinTemperature, MaxTemperature, InternalDimensions, Model]},
			(*homogenizers*)
			{Packet[Name, WettedMaterials, Positions, MinTemperature, MaxTemperature, CompatibleSonicationHorns, Model]},
			(*disruptors*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model]},
			(*nutators*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions, Model]},
			{Packet[Name,MinTemperature,MaxTemperature,Model,WettedMaterials,Positions,EnvironmentalControls,InternalDimensions,MinHumidity,MaxHumidity,MinUVLightIntensity,MaxUVLightIntensity, MinVisibleLightIntensity,MaxVisibleLightIntensity]},
			{Packet[Name, WettedMaterials, Positions, EnvironmentalControls, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions, Model, MaxTemperatureRamp,MinTemperatureRamp]},
			(*preferredVessels*)
			{modelContainerPacket}
		},
		Cache->Lookup[expandedSafeOps,Cache,{}],
		Simulation->samplePreparationSimulation,
		Date->Now
	]}],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveExperimentIncubateNewOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
			{resolveExperimentIncubateNewOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall,Simulation->samplePreparationSimulation],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentIncubate,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	{resolvedPreparation, resolvedWorkCell} = Lookup[resolvedOptions, {Preparation, WorkCell}];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Result|Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentIncubate,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePackets,resourcePacketTests}=Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ, {$Failed, {}},
		gatherTests, incubateNewResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation->samplePreparationSimulation,Output->{Result,Tests}],
		True, {incubateNewResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation->samplePreparationSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentIncubate[
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[2]] (* unitOperationPackets *)
			],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,Cache->cacheBall,
			Simulation->samplePreparationSimulation,
			ParentProtocol->Lookup[safeOps,ParentProtocol]
		],
		{Null, samplePreparationSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentIncubate,collapsedResolvedOptions],
			Preview -> Null,
			Simulation->simulation,
			RunTime->Max@(Cases[Lookup[collapsedResolvedOptions, Time],	TimeP] /. {} -> 5 Minute)
		}]
	];

	(* If told to return the raw resource packets, do that. *)
	If[MatchQ[Lookup[safeOps, UploadResources], False],
		Return[outputSpecification /. {
			Result -> resourcePackets,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentIncubate, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	postProcessingOptions = resolvePostProcessingOptions[
		ReplaceRule[safeOps, Preparation->resolvedPreparation],
		Living -> MemberQ[Download[mySamplesWithPreparedSamples,Living,Cache->cacheBall],True],
		Sterile -> MemberQ[Download[mySamplesWithPreparedSamples,Sterile,Cache->cacheBall],True]
	];

	(* Upload our protocol object, if asked to do so by the user. *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourcePackets,$Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
			resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions, experimentFunction},
				(* Create our primitive to feed into RoboticSamplePreparation. *)
				primitive=If[MatchQ[Lookup[ToList[myOptions],ExperimentFunction],Incubate],
					Incubate@@Join[
						{
							Sample->myInputs
						},
						RemoveHiddenPrimitiveOptions[Incubate,ToList[myOptions]]
					],
					Mix@@Join[
						{
							Sample->myInputs
						},
						RemoveHiddenPrimitiveOptions[Mix,ToList[myOptions]]
					]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions=RemoveHiddenOptions[ExperimentIncubate,collapsedResolvedOptions];

				(* pick the corresponding function from the association above *)
				experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];

				(* Memoize the value of ExperimentIncubate so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentIncubate, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentIncubate]={};

					ExperimentIncubate[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> resourcePackets[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime->Max@(Cases[Lookup[collapsedResolvedOptions, Time],	TimeP] /. {} -> 5 Minute)
						}
					];

					experimentFunction[
						{primitive},
						Join[
							{
								Name->Lookup[safeOps,Name],
								Upload->Lookup[safeOps,Upload],
								Confirm->Lookup[safeOps,Confirm],
								CanaryBranch->Lookup[safeOps,CanaryBranch],
								ParentProtocol->Lookup[safeOps,ParentProtocol],
								Priority->Lookup[safeOps,Priority],
								StartDate->Lookup[safeOps,StartDate],
								HoldOrder->Lookup[safeOps,HoldOrder],
								QueuePosition->Lookup[safeOps,QueuePosition],
								Cache->cacheBall
							},
							postProcessingOptions
						]
					]
				]
			],

		(* If we're doing Preparation->Manual AND our ParentProtocol isn't ManualSamplePreparation, generate an *)
		(* Object[Protocol, ManualSamplePreparation]. *)
		And[
			!MatchQ[Lookup[safeOps,ParentProtocol], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]}]],
			MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], Null|{}],
			(* NOTE: No Incubate prep for Incubate. *)
			MatchQ[Lookup[resolvedOptions, Centrifuge], {False..}],
			MatchQ[Lookup[resolvedOptions, Filtration], {False..}],
			MatchQ[Lookup[resolvedOptions, Aliquot], {False..}]
		],
			Module[{primitive, nonHiddenOptions, experimentFunction},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive=Incubate@@Join[
					{
						Sample->myInputs
					},
					RemoveHiddenPrimitiveOptions[Incubate,ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				(* We need to pass the resolved AlternateInstruments to incubate primitive *)
				nonHiddenOptions=RemoveHiddenOptions[ExperimentIncubate,collapsedResolvedOptions, Exclude -> AlternateInstruments];

				(* Memoize the value of ExperimentIncubate so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentIncubate, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentIncubate]={};

					ExperimentIncubate[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation ->simulation,
							RunTime->Max@(Cases[Lookup[collapsedResolvedOptions, Time],	TimeP] /. {} -> 5 Minute)
						}
					];

					(* Resolve the experiment function (MSP/MCP) to call using the shared helper function *)
					experimentFunction = resolveManualFrameworkFunction[myInputs, nonHiddenOptions, Cache -> cacheBall, Simulation -> simulation, Output -> Function];

					experimentFunction[
						{primitive},
						Join[
							{
								Name->Lookup[safeOps,Name],
								Upload->Lookup[safeOps,Upload],
								Confirm->Lookup[safeOps,Confirm],
								CanaryBranch->Lookup[safeOps,CanaryBranch],
								ParentProtocol->Lookup[safeOps,ParentProtocol],
								Priority->Lookup[safeOps,Priority],
								StartDate->Lookup[safeOps,StartDate],
								HoldOrder->Lookup[safeOps,HoldOrder],
								QueuePosition->Lookup[safeOps,QueuePosition],
								Cache->cacheBall
							},
							postProcessingOptions
						]
					]
				]
			],

		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			ECL`InternalUpload`UploadProtocol[
				resourcePackets[[1]], (* protocolPacket *)
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->{Object[Protocol,Incubate]},
				Cache->cacheBall,
				Simulation->simulation
			]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentIncubate,collapsedResolvedOptions],
		Preview -> Null,
		Simulation->simulation,
		RunTime->Max@(Cases[Lookup[collapsedResolvedOptions, Time],	TimeP] /. {} -> 5 Minute)
	}
];


(* ::Subsection:: *)
(*ResolveOptions*)


DefineOptions[
	resolveExperimentIncubateNewOptions,
	Options:>{ResolverOutputOption,CacheOption,SimulationOption}
];

Error::MixThawOptionMismatch="The sample(s), `1`, have the Thaw option set to `2`. However, they also have the following options set `3`. When Thaw->True, {ThawTime, MaxThawTime, ThawTemperature} must not be Null. When Thaw->False, {ThawTime, MaxThawTime, ThawTemperature} must be Null. Please resolve these option mismatches in order to specify a valid protocol.";

Error::MixInstrumentTypeMismatch="The following mixing Type and mixing Instrument options, `1`, are conflicting for the input(s) `2`. Please change these options in order to specify a valid protocol.";
Error::MixTypeRateMismatch="The following Type and MixRate options, `1`, are conflicting for the input(s) `2`. The MixRate option can only be set to an RPM when the Type option is set to Vortex, Shake, Roll, Stir, Nutate, Disrupt, or Automatic. Please change these options in order to specify a valid protocol.";
Error::MixTypeNumberOfMixesMismatch="The following Type and  NumberOfMixes/MaxNumberOfMixes options, `1`, are conflicting for the input(s) `2`. NumberOfMixes/MaxNumberOfMixes can only be set when the Type option is Invert, Pipette, or Automatic. Please change these options in order to specify a valid protocol.";
Error::MixTypeIncubationMismatch="The sample(s), `1`, have the following conflicting options set: Type->`2`, Temperature->`3`, and AnnealingTime->`4`. Incubation related options can only be set if Type is set to Shake, Roll, Stir, Nutate, or Automatic. This is because the only mix types that support mix while heating are Shake, Roll, Nutate, and Stir. Please change the Type option to resolve this conflict.";
Error::MixTypeVolume="The option value(s) for MixVolume can only be set when mixing by pipette. There are currently mismatch(es), `1`, for input(s), `2`.";
Error::MixUntilDissolvedMaxOptions="The MaxTime and MaxNumberOfMixes must be set if MixUntilDissolved is True and must not be set if MixUntilDissolved is False. The value of these options is currently `1` for input(s) `2`. Please change the value of MixUntilDissolved, MaxTime, and MaxNumberOfMixes for these input(s).";
Error::MixTypeOptionsMismatch="The following mix type(s), `1`, do not have their required options filled out (non-Null), `2`, for the input(s), `3`. Please fix these Null options.";
Error::MixIncubateOptionMismatch="The sample(s), `1`, have conflicting options related to Incubation. These sample(s) have AnnealingTime->`2`, and Temperature->`3`. In order for AnnealingTime to be set, its Temperature must be non-Null. Please fix the conflicting options for these sample(s).";
Error::MixGeneralOptionMismatch="The sample(s), `1`, have the following options set, `2`, which imply that it should be mixed by Pipette/Inversion. However, the options, `3`, are also set which are not supported by Pipette/Inversion. Please change the value of these options to be compatible.";
Error::MixIncompatibleInstrument="The sample(s), `1`, have `2` set to `3`, which are incompatible with the supplied instrument(s) `4`. Make sure that the supplied instruments can support `2` and that the instruments are not deprecated.";
Warning::MixVolumeGreaterThanAvailable="The sample(s), `1`, do not have enough volume to be mixed by pipette with the following MixVolume(s) specified, `2`. When being mixed, these samples will be over-aspirated. If you do not want this to happen, please change the value of the MixVolume options.";
Error::MixTypeIncorrectOptions="The sample(s), `1`, have resolved type(s), `2`. Based on this resolved type(s), the following options must be specified, `3`, and the following options cannot be specified, `4`. Please fix these option mismatches.";
Error::InvalidMultiProbeHeadMix="The following sample(s), `1`, have DeviceChannel -> MultiProbeHead, but are not in a valid 96-channel mixing configuration. In order to use the MultiProbeHead, samples must fill all wells of a 96 well plate or an evenly spaced subdivision of a 384 well plate. Please specify samples in a valid configuration or let the DeviceChannel option be calculated automatically.";
Error::MixMaxTemperature="The sample(s), `1`, are in container(s), `2`, which have MaxTemperature(s) of, `3`. For these sample(s), Temperature->`4` and ThawTemperature->`5`. Temperature and ThawTemperature cannot be set above the MaxTemperature of the given container(s). Please change these options to specify a valid mix protocol.";
Error::MixAmplitudeTooHigh="The sample(s), `1`, are going to be mixed by Homogenization using a microtip sonication horn (for 2mL tubes, 15mL tubes, or other similar containers). According to the manufacturer, the maximum amplitude for these sonication horns is 70%. Please either transfer your sample into a larger container (50mL or later) using the AliquotContainer option or choose a lower amplitude.";
Warning::HomogenizationAmplitude="The homogenization amplitude for the sample(s), `1`, are set to over 50%. Depending on sample viscosity, this can cause the sample to be forcibly displaced outside of its container. This can be safeguarded against by making sure that the sample's volume is not more than 50% of the container's MaxVolume.";
Error::ResidualIncubationInvalid="The residual incubation option(s) `1` are specified for the sample(s) `2` but cannot be fulfilled with the off-deck shaker instruments `3`. Residual incubation settings are only available for robotic on-deck heaters and shakers. Please consider leaving these options Automatic or using the supported instruments.";

Error::MixThawIncompatibleInstrument = "The sample(s), `1`, either do not fit on or the specified temperature is too high for their specified thaw instrument(s), `2`. To get a list of the instruments that are compatible with this sample, in its current container, please use the function IncubateDevices.";
Error::MixThawNoThawInstrumentAvailable = "The sample(s), `1`, have Thaw->True but have no instruments compatible with the current footprint of these sample(s) containers. Please transfer these sample(s) into new containers or do not thaw them. To see the instruments compatible with this sample, please use the function IncubateDevices.";
Error::VolumeTooLargeForInversion="In order to mix a sample by inversion, it must fit in a container that is under 4 Liters. The volume(s), `1`, for sample(s), `2`, are too large to fit inside of a 4L container. Please change the Type option to mix these samples via a different method.";
Error::InvertNoSuitableContainer="The sample(s), `1`, cannot be mixed by inversion since they are not in containers that are <4L and closed. There are also no preferred vessels that are suitable to transfer these samples into. Please choose a different mix type for these samples.";
Warning::LowPipetteMixVolume="The sample(s), `1`, do not have volumes greater than 1 Microliter. The MixVolume options have been resolved to the minimum allowed value - 1 Microliter for Pipette mixing.";
Error::VortexIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::VortexNoInstrumentForRate="The sample(s), `1`, have no vortex instruments that are compatible with the footprint of the sample and the specified rate(s), `2`. Please specify a different rate and/or mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::VortexNoInstrument="The sample(s), `1`, have no vortex instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a vortex instrument. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::DisruptIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::DisruptNoInstrumentForRate="The sample(s), `1`, have no disruptor instruments that are compatible with the footprint of the sample and the specified rate(s), `2`. Please specify a different rate and/or mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::DisruptNoInstrument="The sample(s), `1`, have no disruptor instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a disruption instrument. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::NutateIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::NutateNoInstrument="The sample(s), `1`, have no nutation instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a nutation instrument. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::RollIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::RollNoInstrument="The sample(s), `1`, have no rolling instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a rolling instrument. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::ShakeIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::ShakeNoInstrument="The sample(s), `1`, have no shaker instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a shaker instrument. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::StirNoStirBarOrImpeller = "The sample(s), `1`, are unable to be stirred by the specified instrument, `2`, because no compatible stir bar or impeller can be found. This may be because the selected instrument has StirBarControl set to False, and the sample's volume is too low or the sample to container max volume ratio is too low. Note that aliquoting into another container was considered unless Aliquot is explicitly set to False. Please specify a different instrument or mix type. To see the compatible instruments for this sample, use the MixDevices function.";
Error::StirIncompatibleInstruments="The sample(s), `1`, are either 1) unable to fit on the specified instrument(s), `2`, or 2) are marked as Fuming->True and this instrument isn't in a Fume Hood. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::StirNoInstrument="The sample(s), `1`, have no stirring instruments that are both compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a stirring instrument. For stirring, it is required that the sample volume is no less than 20 Milliliter and the sample volume is also greater than 40% of the container's max volume. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::SonicateIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::SonicateNoInstrument="The sample(s), `1`, have no sonication instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a sonication instrument. Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::HomogenizeIncompatibleInstruments="The sample(s), `1`, are unable to fit on the specified instrument(s), `2`, and are unable to be transferred into a container that is compatible with this instrument. Containers must be able to fit the sonication horn and must have at least 1 CM of clearance if MaxTemperature is specified (to fit the temperature probe). Please specify a different instrument. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::HomogenizeNoInstrument="The sample(s), `1`, have no homogenization instruments that are compatible with the footprint of the sample nor are there any containers that we can aliquot this sample into that would be compatible with a homogenization instrument. Containers must be able to fit the sonication horn and must have at least 1 CM of clearance if MaxTemperature is specified (to fit the temperature probe). Please specify a different mix type. To see the instruments that are compatible with this sample, use the function MixDevices.";
Error::InvalidTemperatureProfile="The sample(s), `1`, have invalid TemperatureProfiles. Please make sure that the TemperatureProfile option is set to a strictly increasing list of times, has no more than 50 elements, and that the profile does not go past `3` (the maximum time of the incubation/mixing).";
Error::InvalidMixRateProfile="The sample(s), `1`, have invalid MixRateProfiles. Please make sure that the MixRateProfiles option is set to a strictly increasing list of times and that the profile does not go past `3` (the maximum time of the incubation/mixing).";
Error::ConflictingProfileResults="The sample(s), `1`, have both the option(s), `2`, set to `3`, and the option(s), `4`, set to `5`. The MixRateProfile option cannot be set if the MixRate option is set and the TemperatureProfile option cannot be set if the Temperature option or Time option is set. Please do not specify the MixRate/Temperature/Time option if you want to specify a MixRateProfile/TemperatureProfile.";
Error::StirBarTooBig="The sample(s), `1`, are in containers that are not compatible with the provided StirBar(s), `2`. StirBar must be able to (1) fit into the container (according to the container Aperture and StirBarWidth) and (2) be able to stir freely at the bottom of the container (InternalDiameter and StirBarLength). Please let the StirBar option resolve automatically or set it to Null to automatically use a stirring impeller (the default stirring behavior).";
Error::ConflictingLightExposureIntensity="The sample(s), `1`, have a specified LightExposure, `3`, that does not match the units of LightExposureIntensity, `2`. UVLight is specified in units of Watt/(Meter^2) and VisibleLight is specified in units of Lumen/(Meter^2). Please correct this mismatch to continue.";
Error::TransformNonTransformOptionsConflict="For sample(s) `1`, the following specified non-Null or non-False Transform-specific option(s), `2`, conflict with the following specified non-Transform-specific options, `3`. Please let either all Transform-specific options or all non-Transform-specific options resolve automatically.";
Error::TransformOptionsConflict="For sample(s) `1`, the following Transform-specific option(s), `2`, are set to Null or False, which conflicts with the specified non-Null and non-False Transform-specific options, `3`. Please ensure that Transform-specific options are all set to resolve automatically, all set to non-Null or non-False options, or all set to Null or False.";
Error::TransformIncompatibleContainer="The sample(s), `1`, are in a container that is too large for a Transform-type incubation. Please transfer the sample(s) to a container whose height is less than 18 cm. A recommended container for Transform-type incubations is Model[Container, Vessel, \"Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap\"]";
Error::TransformIncompatibleInstrument="For sample(s) `1`, a Transform-type incubation is in conflict with the specified instrument, `2`. Transform-type incubations may only use the instrument Model[Instrument, HeatBlock, \"Cole-Parmer StableTemp Digital Utility	Water Baths, 10 liters for Transform\".]";
Error::SafeMixRateMismatch="The sample(s), `1`, have mix rate set to be `2`, which exceeds the maximum mix rate that can be safely achieved for this sample. The maximum safe mix rate is `3`.";
Error::SafeMixRateNotFound="The sample(s), `1`, cannot find MaxOverheadMixRate of its container model. Please check if the field is correctly populated. If the field is not populated, please consider aliquoting the sample or select a different mix type.";
Error::VolumetricFlaskMixMismatch="The sample(s), `1`, is in volumetric flask, which conflicts with mix type (`2`). Volumetric flask can only be mixed using Swirl, Shake or Invert.";
Error::VolumetricFlaskMixRateMismatch="The sample(s), `1`, is in volumetric flask, which conflicts with mix rate (`2`). The max mix rate that volumetric flask can reach is 250 RPM.";

resolveExperimentIncubateNewOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentIncubateNewOptions]]:=Module[
	{
	(* Boilerplate variables. *)
	outputSpecification,output,gatherTests,cache,myIncubateOptions,mySamplePrepOptions,mySimulatedSamples,simulation,
	resolvedSamplePrepOptions,incubateOptionsAssociation,instrumentModels,groupedInstruments,updatedSimulation,cacheBall,
	experimentFunction,preparationResult,allowedPreparation,preparationTest,resolvedPreparation,samplePreparation,samplePrepTests,

	(* Download variables. *)
	fullCacheBall,instrumentSearch,vortexes,shakers,bottleRollers,rollers,stirrerModels,stirrerObjects,sonicators,
	heatBlocks,homogenizers,disruptors,nutators,supportedSonicationContainers,sampleContainerPackets,preferredVesselPackets,
	vortexInstrumentPackets,shakeInstrumentPackets,rollInstrumentPackets,sonicationInstrumentPackets,heatBlockInstrumentPackets,homogenizerInstrumentPackets,
	samplePackets,sampleContainerModelPackets,bottleRollerInstrumentPackets,stirInstrumentPackets,preferredVessels,disruptorInstrumentPackets, nutatorInstrumentPackets,
	stirInstrumentImpellerPackets,sampleContainerModelCalibrationPackets,samplePipettingMethodPackets,allTipModelPackets,suppliedTipObjectPackets,
	environmentalChamberInstrumentPackets,environmentalChambers,thermocyclers,thermocyclerInstrumentPackets,allSyringeModelPackets,
	allPipetteModelPackets, allAspiratorModelPackets, allBalanceModelPackets, allWeighingContainerModelPackets, allGraduatedCylinderModelPackets,
	allSpatulaModelPackets, allNeedleModelPackets, allTransportConditionPackets, allFumeHoodPackets, allGloveBoxPackets, allEnclosurePackets,
	allBiosafetyCabinetPackets, allBenchPackets, allFunnelPackets, allRackModelPackets, allModelConsumablePackets, allGraduatedContainerModelPackets, allHandPumpPackets,allHandPumpAdapaterPackets,suppliedStirBarPackets,
	allHandlingConditionModelPackets, allHandlingStationPackets, allDownloadPackets, fastAssoc,

	(* Invalid input variables. *)
	discardedSamplePackets,discardedInvalidInputs,discardedTest,flattenedMixDutyCycleOptions,typeAndInstrumentMismatches,typerAndInstrumentMismatchOptions,typeAndInstrumentMismatchInputs,
	typeAndRateMismatches,typeAndRateMismatchOptions,typeAndRateMismatchInputs,typeAndNumberOfMixesMismatches,
	typeAndNumberOfMixesMismatchOptions,typeAndNumberOfMixesMismatchInputs,typeAndVolumeMismatches,typeAndVolumeMismatchOptions,
	typeAndVolumeMismatchInputs,typeAndVolumeInvalidOptions,maxMixUntilDissolvedMismatches,maxMixUntilDissolvedMismatchOptions,
	maxMixUntilDissolvedMismatchInputs,typeOptionsNotNullMismatches,typeOptionsNotNullMismatchOptions,typeOptionsNotNullMismatchInputs,
	typeOptionsNotNullInvalidOptions,typeOptionsNotNullTest,typeAndIncubationMismatches,typeAndIncubationMismatchOptions,typeAndIncubationMismatchInputs,
	typeAndIncubationInvalidOptions,typeAndIncubationTest,incubateMismatches,incubateMismatchOptions,incubateMismatchInputs,incubateInvalidOptions,
	incubateTest,generalOptionMismatches,generalMismatchOptions,generalMismatchInputs,generalInvalidOptions,generalTest,instrumentOptionMismatches,
	instrumentMismatchOptions,instrumentMismatchInputs,instrumentInvalidOptions,instrumentTest,volumeOptionMismatches,volumeMismatchOptions,volumeMismatchInputs,
	volumeTest,validNameQ,nameInvalidOptions,validNameTest,maxSafeMixRatesMissingInvalidInputs, maxSafeMixRatesMissingTest,

	(* Precision variables. *)
	roundedMixOptions,precisionTests,

	(* Conflicting option variables. *)
	instrumentTypeInvalidOptions,rateTypeInvalidOptions,typeNumberOfMixesInvalidOptions,invertVolumeInvalidOptions,invertContainerInvalidOptions,
	maxMixUntilDissolvedInvalidOptions,vortexIncompatibleInstrumentInvalidOptions,vortexNoInstrumentForRateInvalidOptions,vortexNoInstrumentInvalidOptions,
	rollIncompatibleInstrumentInvalidOptions,rollNoInstrumentInvalidOptions,shakeIncompatibleInstrumentInvalidOptions,shakeNoInstrumentInvalidOptions,
	stirIncompatibleInstrumentInvalidOptions,stirNoInstrumentInvalidOptions,sonicateIncompatibleInstrumentInvalidOptions,sonicateNoInstrumentInvalidOptions,

	mixTypeTest,rateTypeTest,typeNumberOfMixesTest,typeAndVolumeTest,invertContainerTest,pipetteMixNoVolumeTest,maxMixUntilDissolvedTest,invertVolumeTest,
	vortexIncompatibleInstrumentTest,vortexNoInstrumentForRateTest,vortexNoInstrumentTest,disruptNoInstrumentTest,
	disruptNoInstrumentInvalidOptions, disruptNoInstrumentForRateTest, disruptNoInstrumentForRateInvalidOptions, disruptIncompatibleInstrumentTest,
	disruptIncompatibleInstrumentInvalidOptions,rollIncompatibleInstrumentTest,rollNoInstrumentTest,
	nutateNoInstrumentTest, nutateNoInstrumentInvalidOptions, nutateIncompatibleInstrumentTest, nutateIncompatibleInstrumentInvalidOptions,
	shakeIncompatibleInstrumentTest,shakeNoInstrumentTest,stirIncompatibleInstrumentTest,stirNoInstrumentTest,sonicateIncompatibleInstrumentTest,sonicateNoInstrumentTest,
	homogenizeIncompatibleInstrumentInvalidOptions,homogenizeIncompatibleInstrumentTest,homogenizeNoInstrumentInvalidOptions,homogenizeNoInstrumentTest,homogenizeAmplitudeWarningInputs,
	sonicationHornAmplitudeMismatchInputs,sonicationHorn,sonicationHornAmplitudeInvalidOptions,sonicationHornAmplitudeTest,
	invalidTemperatureProfileResult, temperatureProfileInvalidOptions, temperatureProfileTest,invalidMixRateProfileResult, mixRateProfileInvalidOptions, mixRateProfileTest, conflictingProfileResult,
	conflictingProfileInvalidOptions, conflictingProfileTest, stirBarTooBigTest, stirBarTooBigInvalidOptions, stirBarTooBigResult,
	lightExposureIntensityResult, lightExposureIntensityInvalidOptions, lightExposureIntensityTest,

	thawOptionMismatches,thawMismatchOptions,thawMismatchInputs,thawInvalidOptions,thawTest,

	maxTemperatureMismatches,maxTemperatureOptions,maxTemperatureInputs,maxTemperatureInvalidOptions,maxTemperatureTest,transformSpecificOptions,
		nonTransformSpecificOptions,transformNonTransformConflicts,transformNonTransformInvalidOptions, transformNonTransformTest,
		transformConflicts, transformInvalidOptions, transformTest,

		maxSafeMixRates, safeMixRateMismatches, safeMixRateMismatchOptions,
		safeMixRateMismatchInputs, safeMixRateInvalidOptions, safeMixRateTest,volumetricFlaskMixOptionsMismatches,
		volumetricFlaskMixMismatchOptions, volumetricFlaskMixMismatchInputs,
		volumetricFlaskMixInvalidOptions, volumetricFlaskMixTest, volumetricFlaskMixRateOptionsMismatches, volumetricFlaskMixRateMismatchOptions, volumetricFlaskMixRateMismatchInputs,
		volumetricFlaskMixRateInvalidOptions, volumetricFlaskMixRateTest,

		(* MapThread Variables. *)
	mixPositions,mixPositionOffsets,mixFlowRates,correctionCurves,tipss,tipTypes,tipMaterials,
	preResolvedSampleLabelRules,preResolvedSampleContainerLabelRules,residualTemperatures,residualMixes,residualMixRates,preheatList,workCell,sampleLabels,sampleContainerLabels,relativeHumidities, lightExposures, lightExposureIntensities,totalLightExposures,
	mapThreadFriendlyOptions,mixTypes,mixUntilDissolvedList,instruments,times,maxTimes,rates,numberOfMixesList,maxNumberOfMixesList,volumes,resolvedPostProcessingOptions,measures,temperatures,
	annealingTimes,amplitudes,maxTemperatures,dutyCycles,potentialAliquotContainersList,thaws,thawTimes,maxThawTimes,thawTemperatures,thawInstruments,thawIncompatibleInstrumentErrors,thawNoInstrumentErrors,
	mixTypeRateErrors,invertSampleVolumeErrors,invertSuitableContainerErrors,invertContainerWarnings,pipetteNoInstrumentErrors,pipetteIncompatibleInstrumentErrors,
	pipetteNoInstrumentForVolumeErrors,pipetteMixNoVolumeWarnings,vortexAutomaticInstrumentContainerWarnings,vortexManualInstrumentContainerWarnings,vortexNoInstrumentErrors,vortexNoInstrumentForRateErrors,
	disruptAutomaticInstrumentContainerWarnings,disruptManualInstrumentContainerWarnings, disruptNoInstrumentErrors,disruptNoInstrumentForRateErrors,disruptIncompatibleInstrumentErrors,
	nutateAutomaticInstrumentContainerWarnings,nutateManualInstrumentContainerWarnings,nutateNoInstrumentErrors,nutateIncompatibleInstrumentErrors,
	vortexIncompatibleInstrumentErrors,rollAutomaticInstrumentContainerWarnings,rollManualInstrumentContainerWarnings,rollNoInstrumentErrors,rollIncompatibleInstrumentErrors,
	shakeAutomaticInstrumentContainerWarnings,shakeManualInstrumentContainerWarnings,shakeNoInstrumentErrors,shakeIncompatibleInstrumentErrors,stirAutomaticInstrumentContainerWarnings,
	stirManualInstrumentContainerWarnings,stirNoInstrumentErrors,stirIncompatibleInstrumentErrors,noImpellerOrStirBarErrors, sonicateAutomaticInstrumentContainerWarnings,sonicateManualInstrumentContainerWarnings,
	sonicateNoInstrumentErrors,sonicateIncompatibleInstrumentErrors,homogenizeNoInstrumentErrors,homogenizeIncompatibleInstrumentErrors,
	sterileMismatchWarnings,sterileContaminationWarnings,
	monotonicCorrectionCurveWarnings,incompleteCorrectionCurveWarnings,invalidZeroCorrectionErrors,monotonicCorrectionCurveTest,incompleteCorrectionCurveTest,invalidZeroCorrectionOptions,invalidZeroCorrectionTest,
	mixBooleans,residualIncubationList,invalidInputs,invalidOptions,stirBars,mixRateProfiles,temperatureProfiles,oscillationAngles,specifiedAliquotOptions,shortcircuitAliquotQ,numberSimulatedSamples,
	resolvedRoboticOptionsWithoutMultichannelMixing,resolvedMultichannelMix,resolvedMultichannelMixName,resolvedDeviceChannel,
		transforms, transformHeatShockTemperatures,
		transformHeatShockTimes, transformPreHeatCoolingTimes, transformPostHeatCoolingTimes, preSonicationTimes, samplesAlternateInstruments,transformIncompatibleInstrumentErrors,
		transformIncompatibleContainerErrors, transformRecoveryMedia, transformIncubator, transformIncubatorTemperatures, transformIncubatorShakingRates, transformRecoveryIncubationTimes, transformRecoveryTransferVolumes,

	(* Post-MapThread Checks. *)
	thawNoInstrumentInvalidOptions,thawIncompatibleInstrumentInvalidOptions,thawNoInstrumentTest,thawIncompatibleInstrumentTest,typeOptionMismatches,typeMismatchOptions,typeMismatchInputs,
	residualIncubationOptionTuples,invalidResidualIncubationOptionTuples,residualIncubationIncompatibleInvalidOptions,residualIncubationIncompatibleTests,
	typeTest,typeMismatchInvalidOptions,multiProbeHeadInvalidSamples,multiProbeHeadInvalidOptions,multiProbeHeadTest,resolvedRates,resolvedInstruments,instrumentRates,
	resolvedAliquotOptions,aliquotTests,targetContainers, transformIncompatibleInstrumentOptions,	transformIncompatibleInstrumentTest,
	transformIncompatibleContainerOptions, transformIncompatibleContainerTest,
		stirNoStirBarOrImpellerInvalidOptions, stirNoStirBarOrImpellerTest,

			(* Return Variables. *)
	email,confirm,canaryBranch,template,samplesInStorageCondition,fastTrack,operator,parentProtocol,upload,outputOption
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache];
	simulation=Lookup[ToList[myResolutionOptions],Simulation];
	experimentFunction=Lookup[ToList[myOptions],ExperimentFunction];

	(* Separate out our Mix options from our Sample Prep options. *)
	(* Note: Since we are dealing with a sample prep experiment, we have to manually *)
	(* exclude the MixPrepOptions. This is because we cannot prep a Mix by mixing (conflicting options). *)
	{mySamplePrepOptions,myIncubateOptions}=splitPrepOptions[myOptions,PrepOptionSets->{CentrifugePrepOptionsNew,FilterPrepOptionsNew,AliquotOptions}];

	(* Resolve our sample prep options *)
	{{mySimulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentIncubate, mySamples, mySamplePrepOptions, EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation], Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentIncubate, mySamples, mySamplePrepOptions, EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation], Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	incubateOptionsAssociation=Association[myIncubateOptions];

	(*-- DOWNLOAD --*)
	(* Get the mix instruments in the lab that are not deprecated. *)
	instruments=Flatten[{
		mixInstrumentsSearch["Memoization"],
		Cases[ToList[myOptions],ObjectP[Object[Instrument]],Infinity]
	}];

	(* Separate out these instruments by instrument type. *)
	groupedInstruments=GroupBy[instruments,#[Type]&];
	vortexes=Flatten[Lookup[groupedInstruments,{Model[Instrument,Vortex],Object[Instrument,Vortex]},{}]];
	shakers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Shaker],Object[Instrument,Shaker]},{}]];
	bottleRollers=Flatten[Lookup[groupedInstruments,{Model[Instrument,BottleRoller],Object[Instrument,BottleRoller]},{}]];
	rollers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Roller],Object[Instrument,Roller]},{}]];
	stirrerModels=Flatten[Lookup[groupedInstruments,Model[Instrument,OverheadStirrer],{}]];
	stirrerObjects=Flatten[Lookup[groupedInstruments,Object[Instrument,OverheadStirrer],{}]];
	sonicators=Flatten[Lookup[groupedInstruments,{Model[Instrument,Sonicator],Object[Instrument,Sonicator]},{}]];
	(*TODO: once it's no longer a developer object, remove the subsequent hardcode*)
	heatBlocks=DeleteDuplicates@Flatten[{Lookup[groupedInstruments,{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock]},{}],List@@$TransformInstruments}];
	homogenizers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Homogenizer],Object[Instrument,Homogenizer]},{}]];
	disruptors=Flatten[Lookup[groupedInstruments,{Model[Instrument,Disruptor],Object[Instrument,Disruptor]},{}]];
	nutators=Flatten[Lookup[groupedInstruments,{Model[Instrument,Nutator],Object[Instrument,Nutator]},{}]];
	environmentalChambers=Flatten[Lookup[groupedInstruments,{Model[Instrument,EnvironmentalChamber],Object[Instrument,EnvironmentalChamber]},{}]];
	thermocyclers=Flatten[Lookup[groupedInstruments,{Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]},{}]];

	(* Supported sonication containers that will fit in the sonication floats or self stand. *)
	supportedSonicationContainers=compatibleSonicationContainers[];

	(* Get all of our preferred vessels. *)
	preferredVessels=DeleteDuplicates[Flatten[{
		PreferredContainer[All,Type->Vessel],
		PreferredContainer[All,Sterile->True,LightSensitive->True,Type->Vessel],
		PreferredContainer[All,Sterile->False,LightSensitive->True,Type->Vessel],
		PreferredContainer[All,Sterile->True,LightSensitive->False,Type->Vessel],
		Model[Container, Plate, "id:L8kPEjkmLbvW"],(*"96-well 2mL Deep Well Plate"*)
		Model[Container, Vessel, "id:xRO9n3vk11mz"] (* 50mL beaker *)
	}]];

	(* join cache packets from myOptions and the extracted ones *)
	fullCacheBall=Experiment`Private`FlattenCachePackets[Join[Lookup[myOptions, Cache, {}], cache]];

	(* Get the transfer model packets to get the tip models and pipette models. *)
	{
		(*1*)allSyringeModelPackets,
		(*2*)allPipetteModelPackets,
		(*3*)allAspiratorModelPackets,
		(*4*)allBalanceModelPackets,
		(*5*)allWeighingContainerModelPackets,
		(*6*)allGraduatedCylinderModelPackets,
		(*7*)allSpatulaModelPackets,
		(*8*)allNeedleModelPackets,
		(*9*)allTipModelPackets,
		(*10*)allTransportConditionPackets,
		(*11*)allFumeHoodPackets,
		(*12*)allGloveBoxPackets,
		(*13*)allBiosafetyCabinetPackets,
		(*14*)allEnclosurePackets,
		(*15*)allBenchPackets,
		(*16*)allFunnelPackets,
		(*17*)allRackModelPackets,
		(*18*)allModelConsumablePackets,
		(*19*)allGraduatedContainerModelPackets,
		(*20*)allHandPumpPackets,
		(*21*)allHandPumpAdapaterPackets,
		(*22*)allHandlingConditionModelPackets,
		(*23*)allHandlingStationPackets
	}=transferModelPackets[ToList[myOptions]];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Note: if adding any field here please also add them to the AdjustpH cacheBall download call *)
	{
		samplePackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleContainerModelCalibrationPackets,
		samplePipettingMethodPackets,
		vortexInstrumentPackets,
		shakeInstrumentPackets,
		bottleRollerInstrumentPackets,
		rollInstrumentPackets,
		stirInstrumentPackets,
		stirInstrumentImpellerPackets,
		sonicationInstrumentPackets,
		heatBlockInstrumentPackets,
		homogenizerInstrumentPackets,
		disruptorInstrumentPackets,
		nutatorInstrumentPackets,
		environmentalChamberInstrumentPackets,
		thermocyclerInstrumentPackets,
		preferredVesselPackets,
		suppliedTipObjectPackets,
		suppliedStirBarPackets
	}=Quiet[Download[
		{
			mySimulatedSamples,
			mySimulatedSamples,
			mySimulatedSamples,
			mySimulatedSamples,
			mySimulatedSamples,
			vortexes,
			shakers,
			bottleRollers,
			rollers,
			Join[stirrerModels,stirrerObjects],
			stirrerModels,
			sonicators,
			heatBlocks,
			homogenizers,
			disruptors,
			nutators,
			environmentalChambers,
			thermocyclers,
			preferredVessels,
			DeleteDuplicates@Download[
				Cases[DeleteCases[ToList[myOptions], Cache->_], ObjectP[Object[Item, Tips]], Infinity],
				Object
			],
			DeleteDuplicates@Download[
				Cases[DeleteCases[ToList[myOptions], Cache->_], ObjectP[Object[Part, StirBar]], Infinity],
				Object
			]
		},
		{
			{Packet[Name, LiquidHandlerIncompatible, MassConcentration, Concentration, Count, Volume, Mass, Status, Model, Position, Container, Sterile, StorageCondition, ThawTime, ThawTemperature, MaxThawTime, TransportTemperature, ThawMixType, ThawMixRate, ThawMixTime, ThawNumberOfMixes]},
			{Packet[Container[{Name, Status, Model, Contents, Sterile, TareWeight}]]},
			{Packet[Container[Model][{Name,Deprecated,Sterile,AspectRatio,NumberOfWells,Footprint,Aperture,InternalDepth,SelfStanding,OpenContainer,MinVolume,MaxVolume,Dimensions,InternalDimensions,InternalDiameter,MaxTemperature,Positions,MaxOverheadMixRate}]]},
			{Packet[Container[Model][VolumeCalibrations][{CalibrationFunction, EmptyDistanceDistribution}]]},
			{Packet[PipettingMethod[CorrectionCurve]]},
			(*vortexes*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, Model, MinTemperature, MaxTemperature]},
			(*shakers*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model, CompatibleAdapters, Objects,MaxForce, MinForce,IntegratedLiquidHandlers,ProgrammableTemperatureControl,
				ProgrammableMixControl,MaxOscillationAngle,MinOscillationAngle, GripperDiameter, MaxWeight]},
			(*bottleRollers*)
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, RollerSpacing, Model, Objects]},
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model, CompatibleRacks, Objects]},
			(*Join[stirrerModels,stirrerObjects]*)
			{Packet[Name,WettedMaterials,Positions,MaxRotationRate,MinRotationRate,MinTemperature,MaxTemperature,CompatibleImpellers,Model,StirBarControl,MaxStirBarRotationRate,MinStirBarRotationRate]},
			{Packet[CompatibleImpellers[{StirrerLength,MaxDiameter,ImpellerDiameter,Name, WettedMaterials}]]},
			{Packet[Name, WettedMaterials, Positions, MinTemperature, MaxTemperature, Model, CompatibleSonicationAdapters]},
			{Packet[Name, MinTemperature, MaxTemperature, InternalDimensions, Model]},
			{Packet[Name, WettedMaterials, Positions, MinTemperature, MaxTemperature, CompatibleSonicationHorns, Model]},
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, Model]},
			{Packet[Name, WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions, Model]},
			{Packet[Name, WettedMaterials, Positions, EnvironmentalControls, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions, Model,MinHumidity,MaxHumidity,MinUVLightIntensity,MaxUVLightIntensity, MinVisibleLightIntensity,MaxVisibleLightIntensity]},
			{Packet[Name,MinTemperature,MaxTemperature,Model,WettedMaterials,Positions,EnvironmentalControls,InternalDimensions]},
			{Packet[Name,Deprecated,Sterile,AspectRatio,NumberOfWells,Footprint,Aperture,InternalDepth,SelfStanding,OpenContainer,MinVolume,MaxVolume,Dimensions,InternalDimensions,InternalDiameter,MaxTemperature,Positions, MaxOverheadMixRate]},
			{Packet[Model, Name], Packet[Model[{Object, Name, Sterile, RNaseFree, WideBore,Filtered,GelLoading,Aspirator, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips}]]},
			{Packet[Model,Name,Object,StirBarWidth,StirBarLength]}
		},
		Cache->fullCacheBall,
		Simulation->updatedSimulation
	],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	{
		samplePackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleContainerModelCalibrationPackets,
		samplePipettingMethodPackets,
		vortexInstrumentPackets,
		shakeInstrumentPackets,
		bottleRollerInstrumentPackets,
		rollInstrumentPackets,
		stirInstrumentPackets,
		stirInstrumentImpellerPackets,
		sonicationInstrumentPackets,
		heatBlockInstrumentPackets,
		homogenizerInstrumentPackets,
		disruptorInstrumentPackets,
		nutatorInstrumentPackets,
		preferredVesselPackets,
		suppliedTipObjectPackets,
		suppliedStirBarPackets
	}=Flatten/@{
		samplePackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleContainerModelCalibrationPackets,
		samplePipettingMethodPackets,
		vortexInstrumentPackets,
		shakeInstrumentPackets,
		bottleRollerInstrumentPackets,
		rollInstrumentPackets,
		stirInstrumentPackets,
		stirInstrumentImpellerPackets,
		sonicationInstrumentPackets,
		heatBlockInstrumentPackets,
		homogenizerInstrumentPackets,
		disruptorInstrumentPackets,
		nutatorInstrumentPackets,
		preferredVesselPackets,
		suppliedTipObjectPackets,
		suppliedStirBarPackets
	};

	allDownloadPackets = {
		samplePackets,
		sampleContainerPackets,
		sampleContainerModelPackets,
		sampleContainerModelCalibrationPackets,
		samplePipettingMethodPackets,
		vortexInstrumentPackets,
		shakeInstrumentPackets,
		bottleRollerInstrumentPackets,
		rollInstrumentPackets,
		stirInstrumentPackets,
		stirInstrumentImpellerPackets,
		sonicationInstrumentPackets,
		heatBlockInstrumentPackets,
		homogenizerInstrumentPackets,
		disruptorInstrumentPackets,
		nutatorInstrumentPackets,
		environmentalChamberInstrumentPackets,
		thermocyclerInstrumentPackets,
		preferredVesselPackets,
		suppliedTipObjectPackets,
		suppliedStirBarPackets
	};

	(* Add the rest of our downloaded information to our simulated cache. This is because this function may get called by StockSolution without a full cache ball. *)
	cacheBall = FlattenCachePackets[{fullCacheBall, allDownloadPackets, allTipModelPackets}];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1. Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cacheBall]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->cacheBall]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySimulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySimulatedSamples,discardedInvalidInputs],Cache->cacheBall]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* We want to check the precision of the DutyCycle option which is in the form {{TimeP,TimeP}..}. *)
	(* Flatten out this option if we're given it. *)
	flattenedMixDutyCycleOptions=If[MatchQ[Lookup[incubateOptionsAssociation,DutyCycle],_List],
		Append[incubateOptionsAssociation,DutyCycle->Flatten[Lookup[incubateOptionsAssociation,DutyCycle]]],
		incubateOptionsAssociation
	];

	(*-- OPTION PRECISION CHECKS --*)
	{roundedMixOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[
			flattenedMixDutyCycleOptions,
			{
				Temperature,
				Time,
				MaxTime,
				MixVolume,
				MixRate,
				AnnealingTime,
				DutyCycle,
				OscillationAngle,
				TransformHeatShockTemperature,
				TransformHeatShockTime,
				TransformPreHeatCoolingTime,
				TransformPostHeatCoolingTime,
				PreSonicationTime
			},
			{
				1 Celsius,
				1 Second,
				1 Second,
				(10^(-1)) Microliter,
				1 RPM,
				1 Second,
				10 Millisecond,
				1 AngularDegree,
				1 Celsius,
				1 Second,
				1 Second,
				1 Second,
				1 Second
			},
			AvoidZero->{False,False,False,True,True,False,True,False,False,False,False,False,False},
			Output->{Result,Tests}
		],
		{
			RoundOptionPrecision[
				flattenedMixDutyCycleOptions,
				{
					Temperature,
					Time,
					MaxTime,
					MixVolume,
					MixRate,
					AnnealingTime,
					DutyCycle,
					OscillationAngle,
					TransformHeatShockTemperature,
					TransformHeatShockTime,
					TransformPreHeatCoolingTime,
					TransformPostHeatCoolingTime,
					PreSonicationTime
				},
				{
					1 Celsius,
					1 Second,
					1 Second,
					(10^(-1))Microliter,
					1 RPM,
					1 Second,
					10 Millisecond,
					1 AngularDegree,
					1 Celsius,
					1 Second,
					1 Second,
					1 Second,
					1 Second
				},
				AvoidZero->{False,False,False,True,True,False,True,False,False,False,False,False,False}
			],
			Null
		}
	];

	(* Regroup our DutyCycle option, if we need to. *)
	roundedMixOptions=Append[
		roundedMixOptions,
		DutyCycle->ReplaceAll[
			Lookup[incubateOptionsAssociation,DutyCycle],
			MapThread[#1->#2&,{Flatten[Lookup[incubateOptionsAssociation,DutyCycle]],Lookup[roundedMixOptions,DutyCycle]}]
		]
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* 1. MixType and Instrument are compatible *)
	typeAndInstrumentMismatches=MapThread[
		Function[{mixType,instrument,sampleObject},
			(* Based on our mix type, make sure that the mix instrument matches. *)
			(* If the mix instrument doesn't match, return the options that mismatch and the input for which they mismatch. *)
			Switch[mixType,
				Roll,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,BottleRoller],Object[Instrument,BottleRoller],Model[Instrument,Roller],Object[Instrument,Roller]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Shake,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,Shaker],Object[Instrument,Shaker]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Stir,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Vortex,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,Vortex],Object[Instrument,Vortex]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Disrupt,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,Disruptor],Object[Instrument,Disruptor]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Nutate,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,Nutator],Object[Instrument,Nutator]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Sonicate,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,Sonicator],Object[Instrument,Sonicator]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Homogenize,
					If[MatchQ[instrument,ObjectP[{Model[Instrument,Homogenizer],Object[Instrument,Homogenizer]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Pipette,
					If[MatchQ[instrument,Null|ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Invert,
					If[MatchQ[instrument,Null|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Swirl,
					If[MatchQ[instrument,Null|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Null,
					(* If we're not mixing, we'll want to be Incubating or leaving the instrument up to automatic resolution. *)
					If[MatchQ[instrument,ObjectP[{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock],Model[Instrument,Thermocycler],Object[Instrument,Thermocycler]}]|Automatic],
						Nothing,
						{{mixType,instrument},sampleObject}
					],
				Automatic,
					Nothing,
				_,
					{{mixType,instrument},sampleObject}
			]
		],
		{Lookup[roundedMixOptions,MixType],Lookup[roundedMixOptions,Instrument],mySimulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{typerAndInstrumentMismatchOptions,typeAndInstrumentMismatchInputs}=If[MatchQ[typeAndInstrumentMismatches,{}],
		{{},{}},
		Transpose[typeAndInstrumentMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	instrumentTypeInvalidOptions=If[Length[typerAndInstrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::MixInstrumentTypeMismatch,typerAndInstrumentMismatchOptions,ObjectToString[typeAndInstrumentMismatchInputs]];
		{MixType, Instrument},

		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mixTypeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeAndInstrumentMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options Instrument and MixType match, for the inputs "<>ObjectToString[passingInputs,Cache->cacheBall]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeAndInstrumentMismatchInputs]>0,
				Test["The options Instrument and MixType match, for the inputs "<>ObjectToString[typeAndInstrumentMismatchInputs,Cache->cacheBall]<>" if supplied by the user:",True,False],
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

	(* 2. MixType and MixRate are compatible *)
	typeAndRateMismatches=MapThread[
		Function[{mixType,rate,sampleObject},
			(* MixRate can only be set when MixType is Vortex, Shake, Roll, Stir, Nutate, Disrupt, or Automatic *)
			(* If the type and rate doesn't match, return the options that mismatch and the input for which they mismatch. *)

			If[MatchQ[rate,UnitsP[RPM]]&&!MatchQ[mixType,Vortex|Shake|Roll|Stir|Nutate|Disrupt|Automatic],
				{{mixType,rate},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMixOptions,MixType],Lookup[roundedMixOptions,MixRate],mySimulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{typeAndRateMismatchOptions,typeAndRateMismatchInputs}=If[MatchQ[typeAndRateMismatches,{}],
		{{},{}},
		Transpose[typeAndRateMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	rateTypeInvalidOptions=If[Length[typeAndRateMismatchOptions]>0&&!gatherTests,
		Message[Error::MixTypeRateMismatch,typeAndRateMismatchOptions,ObjectToString[typeAndRateMismatchInputs,Cache->cacheBall]];
		{MixType, Instrument},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	rateTypeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeAndRateMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options Instrument and MixType match, for the inputs "<>ObjectToString[passingInputs,Cache->cacheBall]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeAndRateMismatchInputs]>0,
				Test["The options Instrument and MixType match, for the inputs "<>ObjectToString[typeAndRateMismatchInputs,Cache->cacheBall]<>" if supplied by the user:",True,False],
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

	(* 3. MixType and NumberOfMixes/MaxNumberOfMixes are compatible *)
	typeAndNumberOfMixesMismatches=MapThread[
		Function[{mixType,numberOfMixes,maxNumberOfMixes,sampleObject},
			(* NumberOfMixes/MaxNumberOfMixes can only be set when MixType is Invert, Pipette, Swirl, or Automatic *)
			(* If the type and rate doesn't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[numberOfMixes,_Integer]||MatchQ[maxNumberOfMixes,_Integer])&&!MatchQ[mixType,Invert|Swirl|Pipette|Automatic],
				{{mixType,numberOfMixes,maxNumberOfMixes},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMixOptions,MixType],Lookup[roundedMixOptions,NumberOfMixes],Lookup[roundedMixOptions,MaxNumberOfMixes],mySimulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{typeAndNumberOfMixesMismatchOptions,typeAndNumberOfMixesMismatchInputs}=If[MatchQ[typeAndNumberOfMixesMismatches,{}],
		{{},{}},
		Transpose[typeAndNumberOfMixesMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeNumberOfMixesInvalidOptions=If[Length[typeAndNumberOfMixesMismatchOptions]>0&&!gatherTests,
		Message[Error::MixTypeNumberOfMixesMismatch,typeAndNumberOfMixesMismatchOptions,typeAndNumberOfMixesMismatchInputs];
		{MixType,NumberOfMixes,MaxNumberOfMixes},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	typeNumberOfMixesTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeAndNumberOfMixesMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options NumberOfMixes/MaxNumberOfMixes are only set when MixType is Invert, Swirl, Pipette, or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeAndNumberOfMixesMismatchInputs]>0,
				Test["The options NumberOfMixes/MaxNumberOfMixes are only set when MixType is Invert, Swirl, Pipette, or Automatic for the input(s) "<>ObjectToString[typeAndNumberOfMixesMismatchInputs,Cache->cacheBall]<>" if supplied by the user:",True,False],
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

	(* 4. MixType and MixVolume are compatible *)
	typeAndVolumeMismatches=MapThread[
		Function[{mixType,volume,sampleObject},
			(* MixVolume can only be set when MixType is Pipette or Automatic. *)
			If[MatchQ[volume,_Quantity]&&!MatchQ[mixType,Pipette|Automatic],
				{{mixType,volume},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMixOptions,MixType],Lookup[roundedMixOptions,MixVolume],mySimulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{typeAndVolumeMismatchOptions,typeAndVolumeMismatchInputs}=If[MatchQ[typeAndVolumeMismatches,{}],
		{{},{}},
		Transpose[typeAndVolumeMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeAndVolumeInvalidOptions=If[Length[typeAndVolumeMismatchOptions]>0&&!gatherTests,
		Message[Error::MixTypeVolume,typeAndVolumeMismatchOptions,typeAndVolumeMismatchInputs];
		{MixType,MixVolume},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	typeAndVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeAndVolumeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option MixVolume can only be set when MixType is Pipette for the input(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeAndVolumeMismatchInputs]>0,
				Test["The option MixVolume can only be set when MixType is Pipette for the input(s) "<>ObjectToString[typeAndVolumeMismatchInputs,Cache->cacheBall]<>" if supplied by the user:",True,False],
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

	(* 5. MixType and Temperature/AnnealingTime are compatible. *)
	typeAndIncubationMismatches=MapThread[
		Function[{mixType,instrument,temperature,annealingTime,sample},
			(* Are any of the incubation related options set? *)
			If[MatchQ[temperature,Except[Null|Automatic|$AmbientTemperature|25. Celsius|Ambient]]||MatchQ[annealingTime,Except[Null|Automatic|0 Minute|0. Minute]],
				(* Is MixType\[Rule]Shake|Roll|Stir|Sonicate|Homogenize|Nutate? These are the only types that support incubation while mixing. *)
				(* three critical exceptions here are
				Model[Instrument, Vortex, "Microplate Incu-Mixer MP4"],
				Model[Instrument, Vortex, "Microplate Genie in Heat/Chill Incubator"], and
				Model[Instrument, Vortex, "Multi Tube Vortex Genie 2 in Heat/Chill Incubator"]
				that support vortex and incubation *)
				If[And[
					!MatchQ[mixType,Shake|Roll|Stir|Sonicate|Homogenize|Nutate|Null|Automatic],
					!MatchQ[instrument, ObjectP[Model[Instrument, Vortex, "id:o1k9jAGq7pNA"]]],
					!MatchQ[instrument, ObjectP[Model[Instrument, Vortex, "id:E8zoYvNMxo8m"]]],
					!MatchQ[instrument, ObjectP[Model[Instrument, Vortex, "id:E8zoYvNMxBq5"]]]
				],
					{{mixType,temperature,annealingTime},sample},
					Nothing
				],
				Nothing
			]
		],
		{
			Lookup[roundedMixOptions,MixType],
			Lookup[roundedMixOptions,Instrument],
			Lookup[roundedMixOptions,Temperature],
			Lookup[roundedMixOptions,AnnealingTime],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{typeAndIncubationMismatchOptions,typeAndIncubationMismatchInputs}=If[MatchQ[typeAndIncubationMismatches,{}],
		{{},{}},
		Transpose[typeAndIncubationMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeAndIncubationInvalidOptions=If[Length[typeAndIncubationMismatchOptions]>0&&!gatherTests,
		Message[Error::MixTypeIncubationMismatch,ObjectToString[typeAndIncubationMismatchInputs,Cache->cacheBall],typeAndIncubationMismatchOptions[[All,1]],typeAndIncubationMismatchOptions[[All,2]],typeAndIncubationMismatchOptions[[All,3]]];
		{MixType,Temperature,AnnealingTime},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	typeAndIncubationTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeAndIncubationMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>" can only be incubated if it is being mixed by shaking, rolling, or stirring:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeAndIncubationMismatchInputs]>0,
				Test["The sample(s) "<>ObjectToString[typeAndIncubationMismatchInputs,Cache->cacheBall]<>" can only be incubated if it is being mixed by shaking, rolling, or stirring:",True,False],
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

	(* 6. MixUntilDissolved and MaxTime/MaxNumberOfMixes *)
	maxMixUntilDissolvedMismatches=MapThread[
		Function[{mixUntilDissolved,maxTime,maxNumberOfMixes,sampleObject},
			(* MaxTime and MaxNumberOfMixes can only be set if MixUntilDissolved is True or Automatic. *)
			If[Or[
					MatchQ[{maxTime,maxNumberOfMixes,mixUntilDissolved},{Except[Null|Automatic],_,False}|{_,Except[Null|Automatic],False}],
					MatchQ[{maxTime,maxNumberOfMixes,mixUntilDissolved},{Null,Null,True}]
				],
				{{MaxTime->maxTime,MaxNumberOfMixes->maxNumberOfMixes,MixUntilDissolved->mixUntilDissolved},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMixOptions,MixUntilDissolved],Lookup[roundedMixOptions,MaxTime],Lookup[roundedMixOptions,MaxNumberOfMixes],mySimulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{maxMixUntilDissolvedMismatchOptions,maxMixUntilDissolvedMismatchInputs}=If[MatchQ[maxMixUntilDissolvedMismatches,{}],
		{{},{}},
		Transpose[maxMixUntilDissolvedMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxMixUntilDissolvedInvalidOptions=If[Length[maxMixUntilDissolvedMismatchOptions]>0&&!gatherTests,
		Message[Error::MixUntilDissolvedMaxOptions,maxMixUntilDissolvedMismatchOptions,ObjectToString[maxMixUntilDissolvedMismatchInputs,Cache->cacheBall]];
		{MixUntilDissolved,MaxTime,MaxNumberOfMixes},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	maxMixUntilDissolvedTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,maxMixUntilDissolvedMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options MaxTime and MaxNumberOfMixes are only set if MixUntilDissolved is True for input(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[maxMixUntilDissolvedMismatchInputs]>0,
				Test["The options MaxTime and MaxNumberOfMixes are only set if MixUntilDissolved is True for input(s) "<>ObjectToString[maxMixUntilDissolvedMismatchInputs,Cache->cacheBall]<>" if supplied by the user:",True,False],
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

	(* 7. MixType and other options *)
	typeOptionsNotNullMismatches=MapThread[
		Function[{mixType,numberOfMixes,maxNumberOfMixes,volume,rate,time,maxTime,temperature,amplitude,sampleObject},
			(* What is the mix type? *)
			(* Based on the mix type, certain options cannot be Null. *)
			Switch[mixType,
				Invert,
					If[MatchQ[numberOfMixes,Null],
						{{mixType,{NumberOfMixes->numberOfMixes}},sampleObject},
						Nothing
					],
				Swirl,
					If[MatchQ[numberOfMixes,Null],
						{{mixType,{NumberOfMixes->numberOfMixes}},sampleObject},
						Nothing
					],
				Pipette,
					If[MatchQ[volume,Null]||MatchQ[numberOfMixes,Null],
						{{mixType,{MixVolume->volume,NumberOfMixes->numberOfMixes}},sampleObject},
						Nothing
					],
				Vortex,
					If[MatchQ[rate,Null]||MatchQ[time,Null],
						{{mixType,{MixRate->rate,Time->time}},sampleObject},
						Nothing
					],
				Disrupt,
					If[MatchQ[rate,Null]||MatchQ[time,Null],
						{{mixType,{MixRate->rate,Time->time}},sampleObject},
						Nothing
					],
				Nutate,
					If[MatchQ[rate,Null]||MatchQ[time,Null],
						{{mixType,{MixRate->rate,Time->time}},sampleObject},
						Nothing
					],
				Roll,
					If[MatchQ[rate,Null]||MatchQ[time,Null],
						{{mixType,{MixRate->rate,Time->time}},sampleObject},
						Nothing
					],
				Shake,
					If[MatchQ[rate,Null]||MatchQ[time,Null],
						{{mixType,{MixRate->rate,Time->time}},sampleObject},
						Nothing
					],
				Stir,
					If[MatchQ[rate,Null]||MatchQ[time,Null],
						{{mixType,{MixRate->rate,Time->time}},sampleObject},
						Nothing
					],
				Sonicate,
					If[MatchQ[time,Null],
						{{mixType,{Time->time}},sampleObject},
						Nothing
					],
				Homogenize,
					If[MatchQ[amplitude,Null]||MatchQ[time,Null],
						{{mixType,{Amplitude->amplitude,Time->time}},sampleObject},
						Nothing
					],
				_,
					Nothing
			]
		],
		{
			Lookup[roundedMixOptions,MixType],
			Lookup[roundedMixOptions,NumberOfMixes],
			Lookup[roundedMixOptions,MaxNumberOfMixes],
			Lookup[roundedMixOptions,MixVolume],
			Lookup[roundedMixOptions,MixRate],
			Lookup[roundedMixOptions,Time],
			Lookup[roundedMixOptions,MaxTime],
			Lookup[roundedMixOptions,Temperature],
			Lookup[roundedMixOptions,Amplitude],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{typeOptionsNotNullMismatchOptions,typeOptionsNotNullMismatchInputs}=If[MatchQ[typeOptionsNotNullMismatches,{}],
		{{},{}},
		Transpose[typeOptionsNotNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeOptionsNotNullInvalidOptions=If[Length[typeOptionsNotNullMismatchOptions]>0&&!gatherTests,
		Message[Error::MixTypeOptionsMismatch,typeOptionsNotNullMismatchOptions[[All,1]],typeOptionsNotNullMismatchOptions[[All,2]],ObjectToString[typeOptionsNotNullMismatchInputs,Cache->cacheBall]];
		{MixType},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	typeOptionsNotNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeOptionsNotNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) have all of their required options filled out (non-Null) for their mix type "<>ObjectToString[passingInputs,Cache->cacheBall]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeOptionsNotNullMismatchInputs]>0,
				Test["The following object(s) have all of their required options filled out (non-Null) for their mix type "<>ObjectToString[typeOptionsNotNullMismatchInputs,Cache->cacheBall]<>" if supplied by the user:",True,False],
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

	(* 8. The AnnealingTime option must be compatible with the Temperature option. *)
	incubateMismatches=MapThread[
		Function[{annealingTime,temperature,sample},
			(* Are any of the following incorrect situations hapening? *)
			Switch[{annealingTime,temperature},
				(* AnnealingTime\[Rule]GreaterP[0 Minute] but Temperature\[Rule]Null|Ambient. *)
				{GreaterP[0 Minute],Null|Ambient},
				{{annealingTime,temperature},sample},
				_,
				Nothing
			]
		],
		{
			Lookup[roundedMixOptions,AnnealingTime],
			Lookup[roundedMixOptions,Temperature],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{incubateMismatchOptions,incubateMismatchInputs}=If[MatchQ[incubateMismatches,{}],
		{{},{}},
		Transpose[incubateMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	incubateInvalidOptions=If[Length[incubateMismatchOptions]>0&&!gatherTests,
		Message[Error::MixIncubateOptionMismatch,ObjectToString[incubateMismatchInputs,Cache->cacheBall],ObjectToString[incubateMismatchOptions[[All,1]]],ObjectToString[incubateMismatchOptions[[All,2]]]];
		{AnnealingTime,Temperature},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	incubateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,incubateMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting information in their Incubation related options "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[incubateMismatchInputs]>0,
				Test["The following object(s) do not have conflicting information in their Incubation related options "<>ObjectToString[incubateMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 9. MixVolume, NumberOfMixes, and MaxNumberOfMixes cannot be set if MixRate, Temperature, or AnnealingTime is set. *)
	generalOptionMismatches=MapThread[
		Function[{volume,numberOfMixes,maxNumberOfMixes,rate,temperature,annealingTime,sample},
			Module[{firstOptionsSet,secondOptionsSet},
				(* Get the invert/pipette options that are set. *)
				firstOptionsSet=Select[{MixVolume->volume,NumberOfMixes->numberOfMixes,MaxNumberOfMixes->maxNumberOfMixes},(MatchQ[#[[2]],Except[Null|Automatic]]&)];

				(* Get the other options that are set. *)
				secondOptionsSet=Select[{MixRate->rate,Temperature->temperature,AnnealingTime->annealingTime},(MatchQ[#[[2]],Except[Null|False|Ambient|$AmbientTemperature|25. Celsius|Automatic]]&)];

				(* Do we have a conflict? *)
				If[Length[firstOptionsSet]>0&&Length[secondOptionsSet]>0,
					{{firstOptionsSet,secondOptionsSet},sample},
					Nothing
				]
			]
		],
		{
			Lookup[roundedMixOptions,MixVolume],
			Lookup[roundedMixOptions,NumberOfMixes],
			Lookup[roundedMixOptions,MaxNumberOfMixes],
			Lookup[roundedMixOptions,MixRate],
			Lookup[roundedMixOptions,Temperature],
			Lookup[roundedMixOptions,AnnealingTime],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{generalMismatchOptions,generalMismatchInputs}=If[MatchQ[generalOptionMismatches,{}],
		{{},{}},
		Transpose[generalOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	generalInvalidOptions=If[Length[generalMismatchOptions]>0&&!gatherTests,
		Message[Error::MixGeneralOptionMismatch,ObjectToString[generalMismatchInputs,Cache->cacheBall],generalMismatchOptions[[All,1]],generalMismatchOptions[[All,2]]];
		First/@Flatten[generalMismatchOptions],

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	generalTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,generalMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting information in their options that would cause MixType to be ambiguously resolved "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[generalMismatchInputs]>0,
				Test["The following object(s) do not have conflicting information in their options that would cause MixType to be ambiguously resolved "<>ObjectToString[generalMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 10. MixRate and Temperature are supported if Instrument is given
	 and MixRate and Temperature are specified *)
	instrumentOptionMismatches=MapThread[
		Function[{instrument,rate,temperature,sample},
			Module[{instrumentPacket,minTemperature,maxTemperature,minRotationRate,maxRotationRate, goodTempBool, goodMixBool},
				(* Is Instrument supplied? *)
				If[MatchQ[instrument,Except[Null|Automatic]] && MatchQ[{rate, temperature},Except[{Automatic|Null, Automatic|Null|AmbientTemperatureP}]],

					(* Make sure that our given instrument supports MixRate and Temperature. *)
					(* Lookup our instrument packet. *)
					(* If given an object, go from the object to the model. *)

					instrumentPacket = If[MatchQ[instrument, ObjectP[Object[Instrument]]],
						fastAssocPacketLookup[fastAssoc, instrument, Model],
						fetchPacketFromFastAssoc[instrument, fastAssoc]
					];

					(* If we got an empty packet back, either the instrument isn't an object in the database or it's deprecated. *)
					(* (We don't download the deprecated instruments). Throw an error to let the user know. *)
					If[MatchQ[instrumentPacket, Alternatives[<||>, $Failed]],
						{{instrument, {MixRate, Temperature}, {rate, temperature}},sample},

						(* Check that the instrument supports the rate/temperature. *)
						minTemperature=Lookup[instrumentPacket,MinTemperature,Null];
						maxTemperature=Lookup[instrumentPacket,MaxTemperature,Null];
						minRotationRate=If[MatchQ[Lookup[instrumentPacket,MinForce,Null], UnitsP[GravitationalAcceleration]],
							Lookup[instrumentPacket,MinForce,Null],
							Lookup[instrumentPacket,MinRotationRate,Null]
						];
						maxRotationRate=If[MatchQ[Lookup[instrumentPacket,MaxForce,Null], UnitsP[GravitationalAcceleration]],
							Lookup[instrumentPacket,MaxForce,Null],
							Lookup[instrumentPacket,MaxRotationRate,Null]
						];

						(* if we are not setting MixRate we are good *)
						goodMixBool = If[MatchQ[rate, Null|Automatic], True, MatchQ[rate, RangeP[minRotationRate, maxRotationRate]]];

						(* if we are not setting Temperature, we are good *)
						goodTempBool = If[MatchQ[temperature, Automatic|Null|AmbientTemperatureP], True, MatchQ[temperature, RangeP[minTemperature, maxTemperature]]];

						(* generate the output *)
						Switch[{goodMixBool, goodTempBool},
							{True, True},
							Nothing,
							{False, True},
							{{instrument, {MixRate},{rate}},sample},
							{True, False},
							{{instrument, {Temperature},{temperature}},sample},
							{False, False},
							{{instrument, {MixRate, Temperature},{rate, temperature}},sample}
						]
					],
					(* Instrument isn't supplied. *)
					Nothing
				]
			]
		],
		{
			Lookup[roundedMixOptions,Instrument],
			Lookup[roundedMixOptions,MixRate],
			Lookup[roundedMixOptions,Temperature],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{instrumentMismatchOptions,instrumentMismatchInputs}=If[MatchQ[instrumentOptionMismatches,{}],
		{{},{}},
		Transpose[instrumentOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	instrumentInvalidOptions=If[Length[instrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::MixIncompatibleInstrument,ObjectToString[instrumentMismatchInputs,Cache->cacheBall],instrumentMismatchOptions[[All,2]],instrumentMismatchOptions[[All,3]],instrumentMismatchOptions[[All,1]]];
		{Instrument},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	instrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,instrumentMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have compatible MixRate and Temperature options set, if a Instrument was manually supplied "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[instrumentMismatchInputs]>0,
				Test["The following sample(s) have compatible MixRate and Temperature options set, if a Instrument was manually supplied "<>ObjectToString[instrumentMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 12. MixVolume, if given, is not more than the volume of our sample. *)
	volumeOptionMismatches=MapThread[
		Function[{volume,sample},
			Module[{sampleVolume},
				(* Is Instrument supplied? *)
				If[MatchQ[volume,Except[Null|Automatic]],
					(* Get the volume of our sample. *)
					sampleVolume = fastAssocLookup[fastAssoc, sample, Volume] /. {$Failed | NullP -> 0 Liter};

					(* Is the volume specified more than the volume of our sample? *)
					If[volume>sampleVolume,
						{volume,sample},
						Nothing
					],
					Nothing
				]
			]
		],
		{
			Lookup[roundedMixOptions,MixVolume],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{volumeMismatchOptions,volumeMismatchInputs}=If[MatchQ[volumeOptionMismatches,{}],
		{{},{}},
		Transpose[volumeOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[volumeMismatchOptions]>0&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::MixVolumeGreaterThanAvailable,ObjectToString[volumeMismatchInputs,Cache->cacheBall],volumeMismatchOptions];
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	volumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,volumeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have enough volume available to be mixed by Pipette, if the MixVolume option was specified "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[volumeMismatchInputs]>0,
				Test["The following sample(s) have enough volume available to be mixed by Pipette, if the MixVolume option was specified "<>ObjectToString[volumeMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 13. Make sure that Name isn't taken, if specified. *)
	(* If the specified Name is not in the database, it is valid *)
	validNameQ=If[MatchQ[Lookup[roundedMixOptions, Name],_String],
		Not[DatabaseMemberQ[Object[Protocol,Incubate,Lookup[roundedMixOptions,Name]]]],
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message. *)
	nameInvalidOptions=If[Not[validNameQ]&&!gatherTests,
		Message[Error::DuplicateName,Lookup[roundedMixOptions, Name],"Object[Protocol,Incubate]"];
		{Name},
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[Lookup[roundedMixOptions,Name],_String],
		Test["If specified, the given Name is not already taken for the Object[Protocol,Incubate]:",
			validNameQ,
			True
		],
		Nothing
	];

	(* 14. Make sure that the Thaw options are compatible. *)
	(* If Thaw is set, the following options must be set - ThawTime, MaxThawTime, ThawTemperature. *)
	(* If Thaw is not set, the following options must not be set - ThawTime, MaxThawTime, ThawTemperature. *)
	thawOptionMismatches=MapThread[
		Function[{thaw,thawTime,maxThawTime,thawTemperature,sample},
			(* Is Thaw specified? *)
			If[MatchQ[thaw,Except[Automatic]],
				(* Thaw is given. Is it False? *)
				If[MatchQ[thaw,False|Null],
					(* Thaw is False. *)
					(* Make sure that ThawTime, MaxThawTime, ThawTemperature are not specified. *)
					If[MemberQ[{thawTime,maxThawTime,thawTemperature},Except[Null|Automatic]],
						{
							{
								Thaw->thaw,
								{
									ThawTime->thawTime,
									MaxThawTime->maxThawTime,
									ThawTemperature->thawTemperature
								}
							},
							sample
						},
						Nothing
					],
					(* Thaw is True. *)
					(* Make sure that ThawTime, MaxThawTime, ThawTemperature are specified. *)
					If[MemberQ[{thawTime,maxThawTime,thawTemperature},Null],
						{
							{
								Thaw->thaw,
								{
									ThawTime->thawTime,
									MaxThawTime->maxThawTime,
									ThawTemperature->thawTemperature
								}
							},
							sample
						},
						Nothing
					]
				],
				(* Thaw is not specified. *)
				Nothing
			]
		],
		{
			Lookup[roundedMixOptions,Thaw],
			Lookup[roundedMixOptions,ThawTime],
			Lookup[roundedMixOptions,MaxThawTime],
			Lookup[roundedMixOptions,ThawTemperature],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{thawMismatchOptions,thawMismatchInputs}=If[MatchQ[thawOptionMismatches,{}],
		{{},{}},
		Transpose[thawOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	thawInvalidOptions=If[Length[thawMismatchOptions]>0&&!gatherTests,
		Message[Error::MixThawOptionMismatch,ObjectToString[thawMismatchInputs,Cache->cacheBall],thawMismatchOptions[[All,1]],thawMismatchOptions[[All,2]]];

		{Thaw},
		Nothing
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	thawTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,thawMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have a compatible set of Thaw options "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[thawMismatchInputs]>0,
				Test["The following sample(s) have a compatible set of Thaw options "<>ObjectToString[thawMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 15. Make sure that if the Temperature/ThawTemperature option is specified, it is not more than the MaxTemperature of our sample's conatiner. *)
	maxTemperatureMismatches=MapThread[
		Function[{temperature,thawTemperature,sample},
			Module[{sampleContainerModelObject,maxTemperature},
				(* Get the sample's container's model. *)
				sampleContainerModelObject = fastAssocLookup[fastAssoc, sample, {Container, Model, Object}];

				(* Get the MaxTemperature of this container. *)
				maxTemperature = fastAssocLookup[fastAssoc, sample, {Container, Model, MaxTemperature}];

				(* Is this Temperature or ThawTemperature above maxTemperature? *)
				If[(MatchQ[temperature,UnitsP[Celsius]]&&temperature>maxTemperature)||(MatchQ[thawTemperature,UnitsP[Celsius]]&&thawTemperature>maxTemperature),
					(* Invalid options set. *)
					{{sampleContainerModelObject,maxTemperature,temperature,thawTemperature},sample},
					(* Valid. *)
					Nothing
				]
			]
		],
		{
			Lookup[roundedMixOptions,Temperature],
			Lookup[roundedMixOptions,ThawTemperature],
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{maxTemperatureOptions,maxTemperatureInputs}=If[MatchQ[maxTemperatureMismatches,{}],
		{{},{}},
		Transpose[maxTemperatureMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxTemperatureInvalidOptions=If[Length[maxTemperatureOptions]>0&&!gatherTests,
		Message[Error::MixMaxTemperature,
			ObjectToString[maxTemperatureInputs,Cache->cacheBall],
			ObjectToString[maxTemperatureOptions[[All,1]],Cache->cacheBall],
			ObjectToString[maxTemperatureOptions[[All,2]],Cache->cacheBall],
			ObjectToString[maxTemperatureOptions[[All,3]],Cache->cacheBall],
			ObjectToString[maxTemperatureOptions[[All,4]],Cache->cacheBall]
		];

		{Temperature,ThawTemperature},
		Nothing
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	maxTemperatureTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,maxTemperatureInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) do not have incubation temperatures set over their container's MaxTemperature "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[maxTemperatureInputs]>0,
				Test["The following sample(s) do not have incubation temperatures set over their container's MaxTemperature "<>ObjectToString[maxTemperatureInputs,Cache->cacheBall]<>":",True,False],
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

	(* 16. Transform and non-Transform options are compatible *)
	(* First, establish what the Transform and non-Transform options are *)
	transformSpecificOptions = {
		Transform, TransformHeatShockTemperature, TransformHeatShockTime, TransformPreHeatCoolingTime, TransformPostHeatCoolingTime, TransformRecoveryMedia
	};
	nonTransformSpecificOptions = {
		Thaw, ThawTime, MaxThawTime,	ThawTemperature, ThawInstrument, Mix, MixType, MixUntilDissolved,
		StirBar, Time, MaxTime, DutyCycle, MixRate,	MixRateProfile, NumberOfMixes, MaxNumberOfMixes, MixVolume, Temperature,
		TemperatureProfile, MaxTemperature, RelativeHumidity,	LightExposure, LightExposureIntensity, TotalLightExposure, OscillationAngle,
		Amplitude, AnnealingTime, MixFlowRate, MixPosition,	MixPositionOffset, MixTiltAngle, CorrectionCurve, Tips, TipType,
		TipMaterial, MultichannelMix, MultichannelMixName, DeviceChannel,	ResidualIncubation, ResidualTemperature, ResidualMix,
		ResidualMixRate, Preheat, PreSonicationTime
	};

	(* Find any problematic option sets *)
	transformNonTransformConflicts = MapThread[
		Function[
			{transformOptions, nonTransformOptions, sample},
			If[

				(* If there are non-Null/Automatic/False Transform options and non-Null/Automatic non-Transform options, we've got a problem *)
				MemberQ[transformOptions, Except[Null|Automatic|False]] && MemberQ[nonTransformOptions, Except[Null|Automatic|False]],

				(* We need the name of the problematic options, as well as the sample *)
				{
					sample,
					PickList[transformSpecificOptions, MatchQ[#, Except[Null|Automatic|False]]&/@transformOptions],
					PickList[nonTransformSpecificOptions, MatchQ[#, Except[Null|Automatic|False]]&/@nonTransformOptions]
				},
				Nothing
			]
		],
		{
			Transpose[Lookup[roundedMixOptions, transformSpecificOptions]],
			Transpose[Lookup[roundedMixOptions, nonTransformSpecificOptions]],
			mySimulatedSamples
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	transformNonTransformInvalidOptions=If[Length[transformNonTransformConflicts]>0&&!gatherTests,
		Message[Error::TransformNonTransformOptionsConflict,
			ObjectToString[transformNonTransformConflicts[[All,1]],Cache->cacheBall],
			ObjectToString[transformNonTransformConflicts[[All,2]],Cache->cacheBall],
			ObjectToString[transformNonTransformConflicts[[All,3]],Cache->cacheBall]
		];

		Flatten[{transformNonTransformConflicts[[All,2]],transformNonTransformConflicts[[All,3]]}],
		Nothing
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	transformNonTransformTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,transformNonTransformConflicts[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) do not have conflicting Transform-specific and non-Transform-specific options "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[transformNonTransformConflicts[[All,1]]]>0,
				Test["The following sample(s) do not have conflicting Transform-specific and non-Transform-specific options "<>ObjectToString[transformNonTransformConflicts[[All,1]],Cache->cacheBall]<>":",True,False],
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

	(* 17. Transform options are internally compatible *)
	transformConflicts = MapThread[
		Function[
			{
				transformOptions, sample
			},
			If[

				(* If all of these are Null/Automatic/False OR none is Null/False, we're fine *)
				Or[
					MatchQ[transformOptions,{(Null | Automatic | False)...}],
					!MemberQ[transformOptions, Null|False]
				],
				Nothing,

				(* Otherwise, we need to give back (1) the sample (2) Null/False options, (3) non-Null/False options *)
				{
					sample,
					PickList[transformSpecificOptions, MatchQ[#, Null|False]&/@transformOptions],
					PickList[transformSpecificOptions, MatchQ[#, Except[Null|Automatic|False]]&/@transformOptions]
				}
			]
		],
		{
			Transpose[Lookup[roundedMixOptions, transformSpecificOptions]],
			mySimulatedSamples
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	transformInvalidOptions=If[Length[transformConflicts]>0&&!gatherTests,
		Message[Error::TransformOptionsConflict,
			ObjectToString[transformConflicts[[All,1]],Cache->cacheBall],
			ObjectToString[transformConflicts[[All,2]],Cache->cacheBall],
			ObjectToString[transformConflicts[[All,3]],Cache->cacheBall]
		];

		Flatten[{transformConflicts[[All,2]],transformConflicts[[All,3]]}],
		Nothing
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	transformTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,transformConflicts[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) do not have conflicting Transform-specific and non-Transform-specific options "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[transformConflicts[[All,1]]]>0,
				Test["The following sample(s) do not have conflicting Transform-specific and non-Transform-specific options "<>ObjectToString[transformConflicts[[All,1]],Cache->cacheBall]<>":",True,False],
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
	(* 18. If the specified mix type is Stir, the simulated sample container model must have MaxOverheadMixRate populated. *)
	maxSafeMixRates = Lookup[sampleContainerModelPackets, MaxOverheadMixRate, Null];
	maxSafeMixRatesMissingInvalidInputs = MapThread[
		Function[{maxSafeMixRate,sample,mixType,stirBar},
			(* If mix type is specified to be Stir, but we do not have MaxOverheadMixRate field populated for the simulated sample container, error out as the sample is invalid input *)
			If[MatchQ[maxSafeMixRate, Null]&&MatchQ[mixType, Stir]&&MatchQ[stirBar, Null],
				sample,
				Nothing
			]
		],
		{
			maxSafeMixRates,
			mySimulatedSamples,
			Lookup[roundedMixOptions,MixType],
			Lookup[roundedMixOptions,StirBar]
		}
	];
	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[maxSafeMixRatesMissingInvalidInputs]>0&&!gatherTests,
		Message[Error::SafeMixRateNotFound,ObjectToString[maxSafeMixRatesMissingInvalidInputs,Cache->cacheBall]];
	];
	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	maxSafeMixRatesMissingTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[maxSafeMixRatesMissingInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[maxSafeMixRatesMissingInvalidInputs,Cache->cacheBall]<>" do not have MaxOverheadMixRate field populated for the container:",True,False]
			];

			passingTest=If[Length[maxSafeMixRatesMissingInvalidInputs]==Length[mySimulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySimulatedSamples,maxSafeMixRatesMissingInvalidInputs],Cache->cacheBall]<>" have MaxOverheadMixRate field populated for the container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 19. The given MixRate can be reached with the sample container. *)
	safeMixRateMismatches=MapThread[
		Function[{maxSafeMixRate,mixRate,sample,mixType,stirBar},
			(* If the provided mixRate is larger than the max safeMixRate we can reach *)
			If[MatchQ[mixRate, Except[Automatic|Null]]&&MatchQ[maxSafeMixRate, Except[Null]]&&MatchQ[mixType, Stir]&&MatchQ[stirBar, Null],
				If[!NullQ[maxSafeMixRate]&&maxSafeMixRate < mixRate,
					{{mixRate, maxSafeMixRate},sample},
					Nothing
				],
				Nothing
			]
		],
		{
			maxSafeMixRates,
			Lookup[roundedMixOptions,MixRate],
			mySimulatedSamples,
			Lookup[roundedMixOptions,MixType],
			Lookup[roundedMixOptions,StirBar]
		}
	];
	(* Transpose our result if there were mismatches. *)
	{safeMixRateMismatchOptions,safeMixRateMismatchInputs}=If[MatchQ[safeMixRateMismatches,{}],
		{{},{}},
		Transpose[safeMixRateMismatches]
	];
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	safeMixRateInvalidOptions=If[Length[safeMixRateMismatchOptions]>0&&!gatherTests,
		Message[Error::SafeMixRateMismatch,ObjectToString[safeMixRateMismatchInputs,Cache->cacheBall],safeMixRateMismatchOptions[[All, 1]], safeMixRateMismatchOptions[[All, 2]]];
		{MixRate},
		{}
	];
	(* If we are gathering tests, create a test with the appropriate result. *)
	safeMixRateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,safeMixRateMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting mix rate and the maximumn safe mix rate they can reach "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[safeMixRateMismatchInputs]>0,
				Test["The following object(s) do not have conflicting mix rate and the maximumn safe mix rate they can reach "<>ObjectToString[safeMixRateMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 20. If the input container is a volumetric flask, we do not allow mix time or mix rate to be specified. *)
	volumetricFlaskMixOptionsMismatches=MapThread[
		Function[{sample,mixType,aliquot},
			Module[{sampleContainerObject},
				sampleContainerObject = cacheLookup[samplePackets, sample, Container];
				If[MatchQ[sampleContainerObject, ObjectP[Object[Container,Vessel,VolumetricFlask]]]&&MatchQ[aliquot, False],
					If[MatchQ[mixType, Except[Automatic|Null|Invert|Swirl|Shake|Sonicate]],
						{mixType,sample},
						Nothing
					],
					Nothing
				]
			]
		],
		{
			mySimulatedSamples,
			Lookup[roundedMixOptions,MixType],
			Lookup[mySamplePrepOptions,Aliquot]
		}
	];
	(* Transpose our result if there were mismatches. *)
	{volumetricFlaskMixMismatchOptions,volumetricFlaskMixMismatchInputs}=If[MatchQ[volumetricFlaskMixOptionsMismatches,{}],
		{{},{}},
		Transpose[volumetricFlaskMixOptionsMismatches]
	];
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	volumetricFlaskMixInvalidOptions=If[Length[volumetricFlaskMixMismatchOptions]>0&&!gatherTests,
		Message[Error::VolumetricFlaskMixMismatch,ObjectToString[volumetricFlaskMixMismatchInputs,Cache->cacheBall],volumetricFlaskMixMismatchOptions];
		{MixType},
		{}
	];
	(* If we are gathering tests, create a test with the appropriate result. *)
	volumetricFlaskMixTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,volumetricFlaskMixMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting mix options and the sample container "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[volumetricFlaskMixMismatchInputs]>0,
				Test["The following object(s) do not have conflicting mix options and the sample container "<>ObjectToString[volumetricFlaskMixMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* 21. If we are going to Mix a sample in VolumetricFlask, the max shaking rate is 250 RPM. *)
	volumetricFlaskMixRateOptionsMismatches=MapThread[
		Function[{sample, mixRate, aliquot},
			Module[{sampleContainerObject},
				sampleContainerObject = cacheLookup[samplePackets, sample, Container];
				If[MatchQ[sampleContainerObject, ObjectP[Object[Container,Vessel,VolumetricFlask]]]&&MatchQ[aliquot, False],
					If[MatchQ[mixRate, GreaterP[$MaxVolumetricFlaskShakeRate]],
						{mixRate,sample},
						Nothing
					],
					Nothing
				]
			]
		],
		{
			mySimulatedSamples,
			Lookup[roundedMixOptions,MixRate],
			Lookup[mySamplePrepOptions,Aliquot]
		}
	];
	(* Transpose our result if there were mismatches. *)
	{volumetricFlaskMixRateMismatchOptions,volumetricFlaskMixRateMismatchInputs}=If[MatchQ[volumetricFlaskMixRateOptionsMismatches,{}],
		{{},{}},
		Transpose[volumetricFlaskMixRateOptionsMismatches]
	];
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	volumetricFlaskMixRateInvalidOptions=If[Length[volumetricFlaskMixRateMismatchOptions]>0&&!gatherTests,
		Message[Error::VolumetricFlaskMixRateMismatch,ObjectToString[volumetricFlaskMixRateMismatchInputs,Cache->cacheBall],volumetricFlaskMixRateMismatchOptions];
		{MixRate},
		{}
	];
	(* If we are gathering tests, create a test with the appropriate result. *)
	volumetricFlaskMixRateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,volumetricFlaskMixRateMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting mix rate and the sample container "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[volumetricFlaskMixRateMismatchInputs]>0,
				Test["The following object(s) do not have conflicting mix rate and the sample container "<>ObjectToString[volumetricFlaskMixRateMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentIncubate,roundedMixOptions];


	(* Resolve our preparation option. *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveIncubateMethod[mySimulatedSamples, ReplaceRule[myOptions, {Cache->cacheBall, Output->Result}]],
				{}
			},
			resolveIncubateMethod[mySimulatedSamples, ReplaceRule[myOptions, {Cache->cacheBall, Output->{Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	workCell = Module[
		{allowedWorkCells},

		allowedWorkCells = If[MatchQ[resolvedPreparation, Manual],
			{},
			resolveExperimentIncubateWorkCell[mySimulatedSamples, ReplaceRule[myOptions, {Preparation -> resolvedPreparation, Cache -> cacheBall, Simulation -> updatedSimulation}]]
		];

		Which[
			(* Choose user selected work cell if the user selected one *)
			MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]], Lookup[myOptions, WorkCell],
			(* Set to Null if Manual *)
			MatchQ[resolvedPreparation, Manual], Null,
			(* Otherwise, resolve to the 1st potential work cell. *)
			True, FirstOrDefault[allowedWorkCells]
		]
	];

	(* get the samples without duplicates and make fake labels for them that might be used *)
	preResolvedSampleLabelRules = Module[{samplesNoDupes, preResolvedSampleLabels},
		samplesNoDupes = DeleteDuplicates[Download[mySimulatedSamples, Object]];
		preResolvedSampleLabels = Table[CreateUniqueLabel["incubation sample"], Length[samplesNoDupes]];

		MapThread[
			#1 -> #2&,
			{samplesNoDupes, preResolvedSampleLabels}
		]
	];
	preResolvedSampleContainerLabelRules = Module[{sampleContainersNoDupes, preResolvedSampleContainerLabels},
		sampleContainersNoDupes = DeleteDuplicates[fastAssocLookup[fastAssoc, mySimulatedSamples, {Container, Object}]];
		preResolvedSampleContainerLabels = Table[CreateUniqueLabel["incubation container"], Length[sampleContainersNoDupes]];

		MapThread[
			#1 -> #2&,
			{sampleContainersNoDupes, preResolvedSampleContainerLabels}
		]
	];

	(* MapThread over each of our samples. *)
	{
	thaws,thawTimes,maxThawTimes,thawTemperatures,thawInstruments,

	thawIncompatibleInstrumentErrors,thawNoInstrumentErrors,

	mixBooleans,mixTypes,mixUntilDissolvedList,instruments,times,maxTimes,rates,numberOfMixesList,maxNumberOfMixesList,volumes,
	temperatures,annealingTimes,amplitudes,maxTemperatures,dutyCycles,residualIncubationList,potentialAliquotContainersList,
	stirBars,mixRateProfiles,temperatureProfiles,oscillationAngles,residualTemperatures,residualMixes,residualMixRates,preheatList,
	mixPositions,mixPositionOffsets,mixFlowRates,correctionCurves,tipss,tipTypes,tipMaterials,sampleLabels,sampleContainerLabels,
	relativeHumidities, lightExposures, lightExposureIntensities, totalLightExposures, transforms, transformHeatShockTemperatures,
		transformHeatShockTimes, transformPreHeatCoolingTimes, transformPostHeatCoolingTimes, preSonicationTimes, samplesAlternateInstruments,

	mixTypeRateErrors,

	invertSampleVolumeErrors,invertSuitableContainerErrors,invertContainerWarnings,

	pipetteNoInstrumentErrors,pipetteIncompatibleInstrumentErrors,pipetteNoInstrumentForVolumeErrors,pipetteMixNoVolumeWarnings,

	vortexAutomaticInstrumentContainerWarnings,vortexManualInstrumentContainerWarnings,vortexNoInstrumentErrors,
	vortexNoInstrumentForRateErrors,vortexIncompatibleInstrumentErrors,

	disruptAutomaticInstrumentContainerWarnings,disruptManualInstrumentContainerWarnings,
	disruptNoInstrumentErrors,disruptNoInstrumentForRateErrors,disruptIncompatibleInstrumentErrors,

	nutateAutomaticInstrumentContainerWarnings,nutateManualInstrumentContainerWarnings,
	nutateNoInstrumentErrors,nutateIncompatibleInstrumentErrors,

	rollAutomaticInstrumentContainerWarnings,rollManualInstrumentContainerWarnings,
	rollNoInstrumentErrors,rollIncompatibleInstrumentErrors,

	shakeAutomaticInstrumentContainerWarnings,shakeManualInstrumentContainerWarnings,
	shakeNoInstrumentErrors,shakeIncompatibleInstrumentErrors,

	stirAutomaticInstrumentContainerWarnings,stirManualInstrumentContainerWarnings,
	stirNoInstrumentErrors,stirIncompatibleInstrumentErrors, noImpellerOrStirBarErrors,

	sonicateAutomaticInstrumentContainerWarnings,sonicateManualInstrumentContainerWarnings,
	sonicateNoInstrumentErrors,sonicateIncompatibleInstrumentErrors,

	homogenizeNoInstrumentErrors,homogenizeIncompatibleInstrumentErrors,

	sterileMismatchWarnings,sterileContaminationWarnings,

	monotonicCorrectionCurveWarnings,incompleteCorrectionCurveWarnings,invalidZeroCorrectionErrors,

	transformIncompatibleInstrumentErrors,transformIncompatibleContainerErrors
	}=
	Transpose[MapThread[Function[{mySample,myMapThreadOptions,sourceContainerModelPacket,aliquotQ},
			Module[
				{
					sampleContainerObject,mixTypeRateError,invertSampleVolumeError,invertSuitableContainerError,invertContainerWarning,
					pipetteNoInstrumentError,pipetteIncompatibleInstrumentError,pipetteNoInstrumentForVolumeError,pipetteMixNoVolumeWarning,
					vortexAutomaticInstrumentContainerWarning,vortexManualInstrumentContainerWarning,
					vortexNoInstrumentError,vortexNoInstrumentForRateError,vortexIncompatibleInstrumentError,
					disruptAutomaticInstrumentContainerWarning,disruptManualInstrumentContainerWarning,
					disruptNoInstrumentError,disruptNoInstrumentForRateError,disruptIncompatibleInstrumentError,
					nutateAutomaticInstrumentContainerWarning,nutateManualInstrumentContainerWarning,
					nutateNoInstrumentError,nutateIncompatibleInstrumentError,
					rollAutomaticInstrumentContainerWarning,rollManualInstrumentContainerWarning,
					rollNoInstrumentError,rollIncompatibleInstrumentError,
					shakeAutomaticInstrumentContainerWarning,shakeManualInstrumentContainerWarning,
					shakeNoInstrumentError,shakeIncompatibleInstrumentError,stirAutomaticInstrumentContainerWarning,
					stirManualInstrumentContainerWarning,stirNoInstrumentError,stirIncompatibleInstrumentError,noImpellerOrStirBarError,
					sonicateAutomaticInstrumentContainerWarning,sonicateManualInstrumentContainerWarning,
					sonicateNoInstrumentError,sonicateIncompatibleInstrumentError,
					homogenizeNoInstrumentError,homogenizeIncompatibleInstrumentError,
					monotonicCorrectionCurveWarning,incompleteCorrectionCurveWarning,invalidZeroCorrectionError,
					sterileMismatchWarning,sterileContaminationWarning,mixType,mixUntilDissolved,
					instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,volume,
					temperature,annealingTime,potentialAliquotContainers,
					samplePacket,samplesContainer,containerPacket,otherSamplesInContainer,allOtherMixTypes,
					validOtherMixTypes,suitableContainers,samplesContainerModel,thaw,thawTime,maxThawTime,thawTemperature,
					thawInstrument,mixBoolean,compatibleThawInstruments,givenThawInstrument,thawIncompatibleInstrumentError,
					thawNoInstrumentError,thawInstrumentModel,amplitude,maxTemperature,dutyCycle,
					homogenizeManualInstrumentContainerWarning, homogenizeAutomaticInstrumentContainerWarning,
					compatibleIncubateInstruments, givenInstrument,
					instrumentModel, incubateIncompatibleInstrumentError, incubateNoInstrumentError, residualIncubation,
					stirBar,mixRateProfile,temperatureProfile,oscillationAngle,residualTemperature,residualMix,residualMixRate,preheat,
					mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,sampleLabel,sampleContainerLabel,
					relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,transform,transformHeatShockTemperature,
				transformHeatShockTime,transformPreHeatCoolingTime,transformPostHeatCoolingTime,specifiedTransformOptions,transformQ,
					mainCellIdentityModel,
				resolvedInstrumentModel,transformIncompatibleInstrumentError,sampleContainerHeight,transformIncompatibleContainerError,
				preSonicationTime, alternateInstruments},

				(* Setup our error tracking variables *)
				{
				mixTypeRateError,thawIncompatibleInstrumentError,thawNoInstrumentError,

				invertSampleVolumeError,invertSuitableContainerError,invertContainerWarning,

				pipetteNoInstrumentError,pipetteIncompatibleInstrumentError,pipetteNoInstrumentForVolumeError, pipetteMixNoVolumeWarning,

				vortexAutomaticInstrumentContainerWarning,vortexManualInstrumentContainerWarning,
				vortexNoInstrumentError,vortexNoInstrumentForRateError,vortexIncompatibleInstrumentError,

				disruptAutomaticInstrumentContainerWarning,disruptManualInstrumentContainerWarning,
				disruptNoInstrumentError,disruptNoInstrumentForRateError,disruptIncompatibleInstrumentError,

				nutateAutomaticInstrumentContainerWarning,nutateManualInstrumentContainerWarning,
				nutateNoInstrumentError,nutateIncompatibleInstrumentError,

				rollAutomaticInstrumentContainerWarning,rollManualInstrumentContainerWarning,
				rollNoInstrumentError,rollIncompatibleInstrumentError,

				shakeAutomaticInstrumentContainerWarning,shakeManualInstrumentContainerWarning,
				shakeNoInstrumentError,shakeIncompatibleInstrumentError,

				stirAutomaticInstrumentContainerWarning,stirManualInstrumentContainerWarning,
				stirNoInstrumentError,stirIncompatibleInstrumentError, noImpellerOrStirBarError,

				sonicateAutomaticInstrumentContainerWarning,sonicateManualInstrumentContainerWarning,
				sonicateNoInstrumentError,sonicateIncompatibleInstrumentError,

				homogenizeNoInstrumentError,homogenizeIncompatibleInstrumentError,

				sterileMismatchWarning,sterileContaminationWarning,

				monotonicCorrectionCurveWarning,incompleteCorrectionCurveWarning,invalidZeroCorrectionError,

				transformIncompatibleInstrumentError, transformIncompatibleContainerError
				}=ConstantArray[False,50];

				(* Since the transform options essentially act as a mini-master switch, figure out whether any of them are actively set already *)
				specifiedTransformOptions = Lookup[
					myMapThreadOptions,
					transformSpecificOptions
				];
				transformQ = MemberQ[specifiedTransformOptions, Except[Null|Automatic|False]];

				(* Get the main cell objects in the composition; if this is a mixture it will pick the one with the highest concentration *)
				mainCellIdentityModel = selectMainCellFromSample[mySample, Cache -> cacheBall, Simulation -> updatedSimulation];

				(* We have multiple mix type branches so some of these options are not applicable. *)
				(* Setup our option values to reasonable defaults. *)
				potentialAliquotContainers=Null;
				{
					mixType,mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
					volume,temperature,annealingTime,stirBar,mixRateProfile,temperatureProfile,oscillationAngle,
					relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure
				}=Map[
					(
						Lookup[myMapThreadOptions,#1]
					&),
					{
						MixType,MixUntilDissolved,Instrument,Time,MaxTime,MixRate,NumberOfMixes,MaxNumberOfMixes,MixVolume,
						Temperature,AnnealingTime,StirBar,MixRateProfile,TemperatureProfile,OscillationAngle,RelativeHumidity,
						LightExposure,LightExposureIntensity,TotalLightExposure
					}
				];

				(*-- Resolve Thaw related options. --*)
				(* If Thaw is Automatic, resolve it based on if any thaw related options are set. *)
				thaw=If[MatchQ[Lookup[myMapThreadOptions,Thaw],Automatic],

					(* if the preparation is robotic or we're transforming, then store Null, otherwise resolve Thaw*)
					If[MatchQ[resolvedPreparation,Robotic] || transformQ,
						Null,

						(* If preparation is manual and one of the thaw related options is set to Null or if they're all Automatic, resolve Thaw to False. *)
						If[MemberQ[Lookup[myMapThreadOptions,{ThawTime,MaxThawTime,ThawTemperature,ThawInstrument}],Null]||MatchQ[DeleteDuplicates[Lookup[myMapThreadOptions,{ThawTime,MaxThawTime,ThawTemperature,ThawInstrument}]],{Automatic}],
							False,
							True
						]
					],

					Lookup[myMapThreadOptions,Thaw]
				];

				(* Get sample packet *)
				samplePacket = fetchPacketFromFastAssoc[mySample, fastAssoc];

				(* Get the container object that our sample is in. *)
				samplesContainer = fastAssocLookup[fastAssoc, mySample, {Container, Object}] /. {$Failed | NullP -> Null};

				(* Get the model of this container object. *)
				samplesContainerModel = fastAssocLookup[fastAssoc, samplesContainer, {Model, Object}];

				(* Get the packet that corresponds to the model of the container object. *)
				containerPacket=fetchPacketFromCache[samplesContainerModel,sampleContainerModelPackets];

				(* Lookup information about the other samples in the same container as this sample. *)
				otherSamplesInContainer=Lookup[Cases[samplePackets,KeyValuePattern[Container->ObjectP[samplesContainer]]],Object];

				(* Resolve basic Thaw options. *)
				(* Look to see if the option is set. If it is, use that. *)
				(* If nothing is set, fall back on defaults. *)
				thawTime=If[KeyExistsQ[myMapThreadOptions,ThawTime]&&!MatchQ[Lookup[myMapThreadOptions,ThawTime],Automatic],
					Lookup[myMapThreadOptions,ThawTime],
					(* Do not resolve ThawTime from sample packet if we are not thawing. Just set to Null. Otherwise figure out from sample packet. *)
					If[MatchQ[thaw,True],
						If[MatchQ[Lookup[samplePacket,ThawTime],TimeP],
							Lookup[samplePacket,ThawTime],
							Switch[Lookup[samplePacket, Volume],
								LessEqualP[10 Milliliter],
									5 Minute,
								LessEqualP[50 Milliliter],
									15 Minute,
								LessEqualP[100 Milliliter],
									30 Minute,
								_,
									1 Hour
							]
						],
						Null
					]
				];

				(* MaxThawTime isn't settable in the object/model. Look to see if the option is set and if not, use a default. *)
				maxThawTime=If[KeyExistsQ[myMapThreadOptions,MaxThawTime]&&!MatchQ[Lookup[myMapThreadOptions,MaxThawTime],Automatic],
					Lookup[myMapThreadOptions,MaxThawTime],
					(* Do not resolve MaxThawTime from sample packet if we are not thawing. Just set to Null. Otherwise figure out from sample packet. *)
					If[MatchQ[thaw,True],
						If[MatchQ[Lookup[samplePacket,MaxThawTime],TimeP],
							Lookup[samplePacket,MaxThawTime],
							(* Default to 5 Hour if we are Thawing. *)
							5 Hour
						],
						Null
					]
				];

				(* Look to see if the option is set. If it is, use that. *)
				(* If nothing is set, fall back on defaults. *)
				thawTemperature=If[KeyExistsQ[myMapThreadOptions,ThawTemperature]&&!MatchQ[Lookup[myMapThreadOptions,ThawTemperature],Automatic],
					Lookup[myMapThreadOptions,ThawTemperature],
					(* Do not resolve ThawTemperature from sample packet if we are not thawing. Just set to Null. Otherwise figure out from sample packet. *)
					If[MatchQ[thaw,True],
						If[MatchQ[Lookup[samplePacket,ThawTemperature],TemperatureP],
							Lookup[samplePacket,ThawTemperature],
							(* Default to 25 Celsius if we are Thawing. *)
							$AmbientTemperature
						],
						Null
					]
				];

				(* Were we given an incubation instrument? *)
				thawInstrument=If[MatchQ[thaw,True],
					(* Resolve thaw instrument since we are thawing. *)

					(* Get the instruments that are compatible with this sample. *)
					compatibleThawInstruments=IncubateDevices[
						mySample,
						Temperature->thawTemperature/.{Ambient->Null},
						Cache->cacheBall,
						Simulation->updatedSimulation
					];

					(* Did the user supply an instrument? *)
					If[KeyExistsQ[myMapThreadOptions,ThawInstrument]&&!MatchQ[Lookup[myMapThreadOptions,ThawInstrument],Automatic],
						(* Get the given thaw instrument. *)
						givenThawInstrument=Lookup[myMapThreadOptions,ThawInstrument];

						(* Get the instrument model of the thaw instrument. (We may be given an object.) *)
						thawInstrumentModel = If[MatchQ[givenThawInstrument, ObjectP[Object[Instrument]]],
							fastAssocLookup[fastAssoc, givenThawInstrument, {Model, Object}],
							fastAssocLookup[fastAssoc, givenThawInstrument, Object]
						];

						(* Check to make sure that the sample can fit on the given instrument. *)
						thawIncompatibleInstrumentError=!MemberQ[compatibleThawInstruments,thawInstrumentModel];

						givenThawInstrument,
						(* User didn't give us a thaw instrument. *)
						(* Do we have any compatible thaw instruments? *)
						If[Length[compatibleThawInstruments]>0,
							(* Choose the first instrument. *)
							First[compatibleThawInstruments],
							(* No instruments available, set an error boolean. *)
							thawNoInstrumentError=True;
							Null
						]
					],
					(* Thaw is False. *)
					If[KeyExistsQ[myMapThreadOptions,ThawInstrument]&&!MatchQ[Lookup[myMapThreadOptions,ThawInstrument],Automatic],
						Lookup[myMapThreadOptions,ThawInstrument],
						Null
					]
				];

				(* Resolve master switches *)
				(* Did the user set the mix boolean? *)
				mixBoolean=If[MatchQ[Lookup[myMapThreadOptions,Mix],Except[Automatic]],
					Lookup[myMapThreadOptions,Mix],
					(* Was not set by the user. Automatically resolve it. *)
					Which[
						(* If we're doing ExperimentMix, mix by default. *)
						MatchQ[experimentFunction, ExperimentMix],
							True,

						(* was the preparation robotic and any robotic mix related options set? *)
						MatchQ[resolvedPreparation,Robotic]&&Or[
							(* One of the mix related options is set. *)
							Or@@(MatchQ[Lookup[myMapThreadOptions,#],Except[Automatic|Null|False]]&/@{MixType,MixVolume,NumberOfMixes,MixFlowRate,MixPosition,MixPositionOffset,CorrectionCurve,Tips,TipType,
								TipMaterial,MultichannelMix,MultichannelMixName,DeviceChannel,MixRate,ResidualMix,ResidualMixRate})
						],
							(* Mix. *)
							True,

						(* was Instrument specified that can not Mix? *)
						MatchQ[resolvedPreparation,Manual]&&MatchQ[instrument, ObjectP[{
							Object[Instrument, Thermocycler], Model[Instrument, Thermocycler],
							Object[Instrument, HeatBlock], Model[Instrument, HeatBlock]
						}]],
							False,

						(* Were any mix related options set? *)
						MatchQ[resolvedPreparation,Manual]&&Or[
							(* One of the mix related options is set. *)
							Or@@(MatchQ[Lookup[myMapThreadOptions,#],Except[Automatic|Null|False]]&/@{MixType,MixUntilDissolved,MixRate,NumberOfMixes,MaxNumberOfMixes,MixVolume,MaxTime,StirBar,MixRateProfile,OscillationAngle}),
							(* Or the instrument option is set to something that is not Null, Automatic, or a heat block. *)
							MatchQ[Lookup[myMapThreadOptions,Instrument],Except[Null|Automatic|ObjectP[{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock]}]]],
							(* Or Time was set to Null (you can't incubate only with no time) *)
							MatchQ[Lookup[myMapThreadOptions,Time],Null],
							(* Or TemperatureProfile is set and we're not in a Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"] *)
							(* AKA can't use the thermocycler. *)
							And[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile],Except[Null|Automatic]],
								!MatchQ[samplesContainerModel, ObjectP[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"]]]
							]
						],
							(* Mix. *)
							True,

						(* Were any mix related options set to Null. *)
						MatchQ[resolvedPreparation,Manual]&&Or[
							(* One of the mix related options is set to Null|False. *)
							Or@@(MatchQ[Lookup[myMapThreadOptions,#],Null|False]&/@{MixType,MixUntilDissolved,MixRate,NumberOfMixes,MaxNumberOfMixes,MixVolume,MaxTime,StirBar,MixRateProfile,OscillationAngle}),
							(* Or the instrument option is set to something that is Null or a heat block. *)
							MatchQ[Lookup[myMapThreadOptions,Instrument],Null|ObjectP[{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock]}]],
							(* Or TemperatureProfile is set and we're in a Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"] *)
							(* AKA have to use the thermocycler. *)
							And[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile],Except[Null|Automatic]],
								MatchQ[samplesContainerModel, ObjectP[Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"]]]
							]
						],
							(* Don't mix. *)
							False,

						(* If we're thawing, check if any ThawMix parameters are set in the sample or model *)
						MatchQ[resolvedPreparation,Manual]&&TrueQ[thaw],
							MemberQ[
								Lookup[samplePacket,{ThawMixType,ThawMixRate,ThawMixTime,ThawNumberOfMixes}],
								Except[Null]
							],

						True,
							(* Don't mix. *)
							False
					]
				];

				(* To make MixDevices faster, pull instrument models from the search that ran earlier to pass the results to the function *)
				instrumentSearch = Cases[instruments, ObjectP[Model[Instrument]]];

				(* Is MixType specified by the user? *)
				mixType=Which[
					(* MixType is specified by the user. Simply continue with the user specified value. *)
					!MatchQ[Lookup[myMapThreadOptions,MixType],Automatic],
						Lookup[myMapThreadOptions,MixType],
					(* Is the Mix boolean set to False or Null, or are we doing a transform? *)
					MatchQ[mixBoolean,False|Null] || transformQ,
						Null,
					(* Is the experiment Robotic?*)
					MatchQ[resolvedPreparation,Robotic],
						Which[
							(* Are any pipetting related options set? *)
							MemberQ[Lookup[myMapThreadOptions, #]&/@{ MixVolume,NumberOfMixes,MixFlowRate,MixPosition,MixPositionOffset,CorrectionCurve,Tips,TipType,TipMaterial }, Except[Automatic|False|Null|Ambient]],
								Pipette,
							(* Are any shaking related options set? *)
							MemberQ[Lookup[myMapThreadOptions, #]&/@{ Time,MixRate,Temperature,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate }, Except[Automatic|False|Null|Ambient]],
								Shake,
							(* Otherwise, default to mixing via pipette. *)
							True,
								Pipette
						],
					(* Is Instrument set by the user? *)
					!MatchQ[Lookup[myMapThreadOptions,Instrument],Automatic],
						(* Instrument is set by the user. Resolve MixType based on Instrument. *)
						Switch[Lookup[myMapThreadOptions,Instrument],
							ObjectP[{Model[Instrument,Vortex],Object[Instrument,Vortex]}],
								Vortex,
							ObjectP[{Model[Instrument,Shaker],Object[Instrument,Shaker]}],
								Shake,
							ObjectP[{Model[Instrument,BottleRoller],Object[Instrument,BottleRoller],Object[Instrument,Roller],Model[Instrument,Roller]}],
								Roll,
							ObjectP[{Model[Instrument,Sonicator],Object[Instrument,Sonicator]}],
								Sonicate,
							ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}],
								Stir,
							ObjectP[{Model[Instrument,Homogenizer],Object[Instrument,Homogenizer]}],
								Homogenize,
							ObjectP[{Model[Instrument,Disruptor],Object[Instrument,Disruptor]}],
								Disrupt,
							ObjectP[{Model[Instrument,Nutator],Object[Instrument,Nutator]}],
								Nutate,
							ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}],
								Pipette,
							ObjectP[{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock],Model[Instrument, EnvironmentalChamber],Object[Instrument, EnvironmentalChamber]}],
								Null,
							Null,
								(* Is MixVolume set? *)
								If[MatchQ[Lookup[myMapThreadOptions,MixVolume],Null],
									(* If the mix instrument is Null and MixVolume is Null, we have to invert. *)
									Invert,
									(* What is the volume of our sample? *)
									(* If our sample is > 50mL, do invert since the maximum volume of mix by pipette is 50 mL *)
									(* and if our sample's volume is too large, the sample will not be mixed well. *)
									Which[
										(* large volumes cant be inverted *)
										MatchQ[Lookup[samplePacket,Volume,0 Liter],VolumeP]&&MatchQ[Lookup[samplePacket,Volume,0 Liter], GreaterP[4 Liter]],
											Swirl,

										(* anything between 50 Milliliter and 4 Liter should invert *)
										MatchQ[Lookup[samplePacket,Volume,0 Liter],VolumeP]&&Lookup[samplePacket,Volume,0 Liter]>50 Milliliter,
											Invert,

										(* small volumes are pipetted *)
										True,
											Pipette
									]
								],
							_,
								Invert
						],
					(* Is MixRate or MixRateProfile set to a GravitationalAcceleration? *)
					MatchQ[Lookup[myMapThreadOptions,MixRate],UnitsP[GravitationalAcceleration]] || MatchQ[Lookup[myMapThreadOptions,ResidualMixRate],UnitsP[GravitationalAcceleration]]  || MemberQ[Lookup[myMapThreadOptions,MixRateProfile], Except[Null|Automatic], Infinity],
						Shake,
					(* Is RelativeHumidity, LightExposure, LightExposureIntensity, or LightExposureStandard set? These options are only allowed for our environmental chambers (no mixing). *)
					MatchQ[Lookup[myMapThreadOptions,RelativeHumidity],Except[Null|Automatic]]||MatchQ[Lookup[myMapThreadOptions,LightExposure],Except[Null|Automatic]]||MatchQ[Lookup[myMapThreadOptions,LightExposureIntensity],Except[Null|Automatic]]||MatchQ[Lookup[myMapThreadOptions,LightExposureStandard],Except[Null|Automatic]],
						Null,
					(* Is Amplitude, MaxTemperature, or DutyCycle set? These options are only allowed for the Homogenizer OR for the sonicator, but assume they mean homogenize. *)
					MatchQ[Lookup[myMapThreadOptions,Amplitude],Except[Null|Automatic]]||MatchQ[Lookup[myMapThreadOptions,MaxTemperature],Except[Null|Automatic]]||MatchQ[Lookup[myMapThreadOptions,DutyCycle],Except[Null|Automatic]],
						Homogenize,
					(* Is OscillationAngle set? This is only for the wrist action shaker. *)
					MatchQ[Lookup[myMapThreadOptions,OscillationAngle],Except[Null|Automatic]],
						Shake,
					(* Is PreSonicationTime set? This is only for the sonicator. *)
					MatchQ[Lookup[myMapThreadOptions,PreSonicationTime],Except[Null|Automatic]],
						Sonicate,
					(* Is MixRate or Time set to Null? *)
					MatchQ[Lookup[myMapThreadOptions,MixRate],Null]||MatchQ[Lookup[myMapThreadOptions,Time],Null],
						(* MixRate or Time was Null, resolve to Invert or Pipette. *)
						(* What is the volume of our sample? *)
						(* If our sample is > 50mL, do invert since the maximum volume of mix by pipette is 50 mL *)
						(* and if our sample's volume is too large, the sample will not be mixed well. *)
						If[MatchQ[Lookup[samplePacket,Volume,0 Liter],VolumeP]&&Lookup[samplePacket,Volume,0 Liter]>50 Milliliter,
							Invert,
							Pipette
						],
					(* Is MixRate set? *)
					!MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic|Null],
						Module[{resolvedTemperature,footprintCompatibleInstruments, footprintCompatibleInstrumentsNoStirBar, aliquotInstrumentResult},
							(* Is Temperature set? *)
							resolvedTemperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
								(* User supplied temperature. *)
								Lookup[myMapThreadOptions,Temperature],
								(* Did the user specify any incubation related options? *)
								If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
									40 Celsius,
									Ambient
								]
							];

							(* See if there are any instruments that are capible of mixing our sample, as is. *)
							footprintCompatibleInstrumentsNoStirBar=MixDevices[
								mySample,
								Rate->Lookup[myMapThreadOptions,MixRate],
								(* Is Temperature set? *)
								Temperature->resolvedTemperature/.{Ambient|$AmbientTemperature->Null},
								InstrumentSearch->instrumentSearch,
								StirBar -> False,
								Cache->cacheBall,
								Simulation->updatedSimulation
							];
							(* we try to avoid using StirBar, but if there is no other compatible mix type we allow StirBar *)
							footprintCompatibleInstruments = If[Length[footprintCompatibleInstrumentsNoStirBar]>0 || MatchQ[Lookup[myMapThreadOptions,StirBar], Null],
								footprintCompatibleInstrumentsNoStirBar,
								MixDevices[
									mySample,
									Rate->Lookup[myMapThreadOptions,MixRate],
									(* Is Temperature set? *)
									Temperature->resolvedTemperature/.{Ambient|$AmbientTemperature->Null},
									InstrumentSearch->instrumentSearch,
									Cache->cacheBall,
									Simulation->updatedSimulation
								]
							];

							(* If there are instruments that work, choose the first instrument. *)
							If[Length[footprintCompatibleInstruments]>0,
								(* Convert our first instrument into a mix type. *)
								mixObjectToType[First[footprintCompatibleInstruments]],
								(* ELSE: There are no instruments that currently can be used. *)
								(* Compute the instruments that we can aliquot into. *)
								aliquotInstrumentResult=If[MatchQ[aliquotQ, False],
									{},
									MixDevices[
										mySample,
										Rate->Lookup[myMapThreadOptions,MixRate],
										Temperature->resolvedTemperature/.{Ambient|$AmbientTemperature->Null},
										Output->Containers,
										StirBar -> If[NullQ[Lookup[myMapThreadOptions,StirBar]], False, True],
										InstrumentSearch->instrumentSearch,
										Cache->cacheBall,
										Simulation->updatedSimulation
									]
								];

								(* Are there any instruments that can work after an aliquot? *)
								If[Length[aliquotInstrumentResult]>0,
									(* Pick the first instrument that will work. *)
									mixObjectToType[aliquotInstrumentResult[[1]][[1]]],
									(* ELSE: Otherwise, choose a reasonable default mix type, although we can't aliquot the sample automatically for the user. *)
									Switch[Lookup[myMapThreadOptions,MixRate],
										RangeP[0.2RPM,4RPM],
										Roll,
										RangeP[4RPM,600RPM],
										Shake,
										RangeP[600RPM,3200RPM],
										Vortex
									]
								]
							]
						],
					(* Is Volume set? *)
					!MatchQ[Lookup[myMapThreadOptions,MixVolume],Automatic|Null],
						Pipette,
					(* Is NumberOfMixes or MaxNumberOfMixes set? *)
					!MatchQ[Lookup[myMapThreadOptions,NumberOfMixes],Automatic|Null]||!MatchQ[Lookup[myMapThreadOptions,MaxNumberOfMixes],Automatic|Null],
						(* Is the sample in a vessel that is closed? *)
						If[MatchQ[Lookup[containerPacket,OpenContainer,True],True],
							(* The container is not closed, we cannot invert. *)
							Pipette,
							(* The container is closed, invert. *)
							Invert
						],
					(* Is any temperature related option set to non-Automatic? *)
					MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]]||MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
						Module[{resolvedTemperature,footprintCompatibleInstruments,aliquotInstrumentResult},
							(* Is Temperature set? *)
							resolvedTemperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
								(* User supplied temperature. *)
								Lookup[myMapThreadOptions,Temperature],
								(* Then the user specified an incubation related option. Set Temperature to 40 Celsius. *)
								40Celsius
							];

							(* See if there are any instruments that are capible of mixing our sample, as is. *)
							footprintCompatibleInstruments=MixDevices[mySample,Temperature->(resolvedTemperature/.{Ambient|$AmbientTemperature->Null}),InstrumentSearch->instrumentSearch,Cache->cacheBall,Simulation->updatedSimulation];

							(* If there are instruments that work, choose the first instrument. *)
							If[Length[footprintCompatibleInstruments]>0,
								(* Convert our first instrument into a mix type. *)
								mixObjectToType[First[footprintCompatibleInstruments]],
								(* ELSE: There are no instruments that currently can be used. *)
								(* Compute the instruments that we can aliquot into. *)
								aliquotInstrumentResult=MixDevices[mySample,Temperature->(resolvedTemperature/.{Ambient|$AmbientTemperature->Null}),InstrumentSearch->instrumentSearch,Output->Containers,Cache->cacheBall,Simulation->updatedSimulation];

								(* Are there any instruments that can work after an aliquot? *)
								If[Length[aliquotInstrumentResult]>0,
									(* Pick the first instrument that will work. *)
									mixObjectToType[aliquotInstrumentResult[[1]][[1]]],
									(* ELSE: Otherwise, choose a reasonable default mix type, although we can't aliquot the sample automatically for the user. *)
									Stir
								]
							]
						],
					(* Is Time set? *)
					!MatchQ[Lookup[myMapThreadOptions,Time],Automatic|Null],
						Module[{resolvedTemperature,footprintCompatibleInstruments,aliquotInstrumentResult},
							(* Is Temperature set? *)
							resolvedTemperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
								(* User supplied temperature. *)
								Lookup[myMapThreadOptions,Temperature],
								(* Did the user specify any incubation related options? *)
								If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
									40 Celsius,
									Ambient
								]
							];

							(* See if there are any instruments that are capible of mixing our sample, as is. *)
							footprintCompatibleInstruments=MixDevices[mySample,Temperature->resolvedTemperature/.{Ambient|$AmbientTemperature->Null},InstrumentSearch->instrumentSearch,Cache->cacheBall,Simulation->updatedSimulation];

							(* If there are instruments that work, choose the first instrument. *)
							If[Length[footprintCompatibleInstruments]>0,
								(* Convert our first instrument into a mix type. *)
								mixObjectToType[First[footprintCompatibleInstruments]],
								(* ELSE: There are no instruments that currently can be used. *)
								(* Compute the instruments that we can aliquot into. *)
								aliquotInstrumentResult=MixDevices[mySample,Temperature->resolvedTemperature/.{Ambient|$AmbientTemperature->Null},InstrumentSearch->instrumentSearch,Output->Containers,Cache->cacheBall,Simulation->updatedSimulation];

								(* Are there any instruments that can work after an aliquot? *)
								If[Length[aliquotInstrumentResult]>0,
									(* Pick the first instrument that will work. *)
									mixObjectToType[aliquotInstrumentResult[[1]][[1]]],
									(* ELSE: Otherwise, choose a reasonable default mix type, although we can't aliquot the sample automatically for the user. *)
									Stir
								]
							]
						],
					(* Are we Thawing and ThawMixType is set? *)
					And[
						TrueQ[thaw],
						!NullQ[Lookup[samplePacket,ThawMixType]]
					],
						Lookup[samplePacket,ThawMixType],
					(* Are there other samples in this sample's container? *)
					(* If there are other samples, do these samples have mix types set? *)
					True,
						Module[{},
							allOtherMixTypes=If[Length[otherSamplesInContainer]>0,
								Lookup[
									PickList[mapThreadFriendlyOptions,mySimulatedSamples,ObjectP[otherSamplesInContainer]],
									MixType
								],
								{}
							];

							(* Filter out any Automatics and Nulls from the mix types. *)
							validOtherMixTypes=Cases[allOtherMixTypes,Except[Automatic|Null]];

							(* Do we have any valid other mix types? *)
							If[Length[validOtherMixTypes]>0,
								(* We have other mix types set. *)
								(* Go with the most common other mix type. *)
								First[Commonest[validOtherMixTypes]],
								(* ELSE: There are no other mix types set. *)
								(* Are we in a plate? *)
								If[MatchQ[samplesContainer,ObjectP[Object[Container,Plate]]],
									(* We want to vortex plates. *)
									Vortex,
									(* Are we in a volumetric flask? *)
									If[MatchQ[samplesContainer,ObjectP[Object[Container,Vessel,VolumetricFlask]]],
										Invert,
										(* Are we in an open container? *)
										If[MatchQ[Lookup[containerPacket,OpenContainer,True],True],
											(* In an open container. *)
											(* Does the sample have a volume >50mL? *)
											If[MatchQ[Lookup[samplePacket,Volume,0 Liter],VolumeP]&&Lookup[samplePacket,Volume,0 Liter]>50 Milliliter,
												Stir,
												Pipette
											],
											(* Not in an open container. *)
											(* See if any options are set to Null, if not, optimize footprints. *)
											Module[{footprintCompatibleInstruments,aliquotInstrumentResult},
												(* If Time is Null, we have to choose Invert or Pipette. *)
												If[MatchQ[Lookup[myMapThreadOptions,Time],Null],
													(* What is the volume of our sample? *)
													(* If our sample is > 50mL, do invert since the maximum volume of mix by pipette is 50 mL *)
													(* and if our sample's volume is too large, the sample will not be mixed well. *)
													If[MatchQ[Lookup[samplePacket,Volume,0 Liter],VolumeP]&&Lookup[samplePacket,Volume,0 Liter]>50 Milliliter,
														Invert,
														Pipette
													],
													(* ELSE: *)
													(* See if there are any instruments that are capible of mixing our sample, as is. *)
													footprintCompatibleInstruments=MixDevices[mySample,InstrumentSearch->instrumentSearch,Cache->cacheBall,Simulation->updatedSimulation];
													(* If there are instruments that work, choose the first instrument. *)
													If[Length[footprintCompatibleInstruments]>0,
														(* Convert our first instrument into a mix type. *)
														mixObjectToType[First[footprintCompatibleInstruments]],
														(* ELSE: There are no instruments that currently can be used. *)
														(* Compute the instruments that we can aliquot into. *)
														aliquotInstrumentResult=MixDevices[mySample,InstrumentSearch->instrumentSearch,Output->Containers,Cache->cacheBall,Simulation->updatedSimulation];

														(* Are there any instruments that can work after an aliquot? *)
														If[Length[aliquotInstrumentResult]>0,
															(* Pick the first instrument that will work. *)
															mixObjectToType[aliquotInstrumentResult[[1]][[1]]],
															(* ELSE: Otherwise, choose a reasonable default mix type, although we can't aliquot the sample automatically for the user. *)
															Stir
														]
													]
												]
											]
										]
									]
								]
							]
						]
				];


				(* If our temperature is non-Ambient (or 25 Celsius) and our sample's model is TransportWarmed/Chilled, resolve ResidualIncubation\[Rule]True. *)
				(* Make an exception of Swirl/Invert/Pipette because they are not compatible with ResidualIncubation, and it's not necessary either because this should usually be quick *)
				(* Leave this option alone if it isn't Automatic. *)
				residualIncubation=Which[
					MatchQ[Lookup[myMapThreadOptions, ResidualIncubation], Except[Automatic]],
						Lookup[myMapThreadOptions, ResidualIncubation],
					transformQ,
						False,
					MatchQ[Lookup[myMapThreadOptions, ResidualTemperature], Except[(Automatic|Null)]] || MatchQ[Lookup[myMapThreadOptions, ResidualMixRate], Except[(Automatic|Null)]],
						True,
					TrueQ[Lookup[myMapThreadOptions, ResidualMix]],
						True,
					MatchQ[mixType, (Swirl | Invert | Pipette)],
						False,
					(* On Robotic run, and we resolved to use shaker, cannot allow off-deck residual incubation as we have to move the container back for downstream processing. There is corresponding error-checking below, so we should not allow automatically resolving to an error-throwing situation.*)
					MatchQ[mixType,Shake] && MatchQ[resolvedPreparation,Robotic],
						False,
					!MatchQ[Lookup[myMapThreadOptions, Temperature],(EqualP[$AmbientTemperature] | Null)]&&MatchQ[Lookup[samplePacket,TransportTemperature],TemperatureP],
						True,
					True,
						False
				];

				(* Independent options resolution *)
				(* Switch based off of our resolved mixType to resolve the rest of our mix options. *)
				Switch[mixType,
					(*-- INVERT --*)
					Invert,
						Module[{containerPackets,filteredContainerPackets},
							(* Is the volume of the sample >4 Liters? with a 4% leeway *)
							If[(!MatchQ[Lookup[samplePacket,Volume,0 Liter],VolumeP] && MatchQ[Lookup[containerPacket,MaxVolume,0 Liter],GreaterP[4 Liter]]) || Lookup[samplePacket,Volume,0 Liter]>4Liter*1.04,
								(* We can't invert samples >4L due to the operators getting too tired/not being strong enough. *)
								invertSampleVolumeError=True,

								(* Is the sample not in a closed container or is the container over 4L? *)
								If[MatchQ[Lookup[containerPacket,OpenContainer,True],True]||MatchQ[Lookup[containerPacket,MaxVolume,0 Liter],GreaterP[4 Liter]],
									(* This sample need to be moved into another container. *)
									(* Is there a suitable closed container to transfer the sample into? *)
									suitableContainers=PreferredContainer[Lookup[samplePacket,Volume,0 Liter],Messages->False,All->True,Type->Vessel]/.{$Failed->{}};

									(* Lookup these containers from our cache. *)
									containerPackets = fetchPacketFromFastAssoc[suitableContainers, fastAssoc];

									(* Get the containers that are closed and that are under 4 Liter MaxVolume. *)
									filteredContainerPackets=Cases[
										containerPackets,
										KeyValuePattern[{
											MaxVolume->LessEqualP[4 Liter],
											OpenContainer->False|Null
										}]
									];

									(* Did we find a suitable container? *)
									potentialAliquotContainers=If[Length[filteredContainerPackets]==0,
									(* We were unable to find a suitable container to transfer the sample into. *)
									(* Throw an error at the user. *)
										invertSuitableContainerError=True;
										Null,
									(* We were able to change the container. *)
									(* Warn the user that we're moving their sample b/c of inversion compatibility. *)
										invertContainerWarning=True;
										Lookup[filteredContainerPackets,Object]
									]
								]
							];

							(* Resolve NumberOfMixes and MaxNumberOfMixes *)
							(* Do we have to resolve NumberOfMixes? *)
							numberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,NumberOfMixes],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawNumberOfMixes]]
										],
										Lookup[samplePacket,ThawNumberOfMixes],
								(* Is MaxNumberOfMixes set? *)
									If[MatchQ[Lookup[myMapThreadOptions,MaxNumberOfMixes],Except[Automatic|Null]],
										(* using Round instead of N because this wants to be an integer *)
										Round[(1/3)*Lookup[myMapThreadOptions,MaxNumberOfMixes]],
									(* What is the value of MixUntilDissolved? *)
										If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
											25,
											15
										]
									]
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,NumberOfMixes]
							];

							(* Do we have to resolve MaxNumberOfMixes? *)
							maxNumberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,MaxNumberOfMixes],Automatic],
							(* What is the value of MixUntilDissolved? *)
								If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
									If[MatchQ[numberOfMixes, _?NumericQ],
										numberOfMixes*2,
										50
									],
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxNumberOfMixes]
							];

							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxNumberOfMixes,_?NumericQ],
									True,
								MatchQ[resolvedPreparation, Robotic],
									Null,
								True,
									False
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
								mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								&),
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, Null},
									{Time, Null},
									{MaxTime, Null},
									{MixRate, Null},
									{NumberOfMixes, numberOfMixes},
									{MaxNumberOfMixes, maxNumberOfMixes},
									{MixVolume, Null},
									{Temperature, Ambient},
									{AnnealingTime,Null},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,Null},
									{ResidualMixRate,Null},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					(*-- Swirl --*)
					Swirl,
						Module[{containerPackets,filteredContainerPackets},
						(* Resolve NumberOfMixes and MaxNumberOfMixes *)
						(* Do we have to resolve NumberOfMixes? *)
						numberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,NumberOfMixes],Automatic],
							If[
								And[
									TrueQ[thaw],
									!NullQ[Lookup[samplePacket,ThawNumberOfMixes]]
								],
								Lookup[samplePacket,ThawNumberOfMixes],
								(* Is MaxNumberOfMixes set? *)
								If[MatchQ[Lookup[myMapThreadOptions,NumberOfMixes],Except[Automatic|Null]],
									N[(1/3)*Lookup[myMapThreadOptions,NumberOfMixes]],
									(* What is the value of MixUntilDissolved? *)
									If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
										25,
										15
									]
								]
							],
							(* It's already user specified, use that value. *)
							Lookup[myMapThreadOptions,NumberOfMixes]
						];

						(* Do we have to resolve MaxNumberOfMixes? *)
						maxNumberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,MaxNumberOfMixes],Automatic],
							(* What is the value of MixUntilDissolved? *)
							If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
								50,
								Null
							],
							(* It's already user specified, use that value. *)
							Lookup[myMapThreadOptions,MaxNumberOfMixes]
						];

						(* Resolve mixUntilDissolved. *)
						mixUntilDissolved=Which[
							MatchQ[maxNumberOfMixes,_?NumericQ],
							True,
							MatchQ[resolvedPreparation, Robotic],
							Null,
							True,
							False
						];

						(* Set the rest of the options to proper values, unless already set by the user. *)
						{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
							mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure, preSonicationTime,alternateInstruments}=Map[
							(
								If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
									Lookup[myMapThreadOptions,#[[1]]],
									#[[2]]
								]
							&),
							{
								{MixUntilDissolved, mixUntilDissolved},
								{Instrument, Null},
								{Time, Null},
								{MaxTime, Null},
								{MixRate, Null},
								{NumberOfMixes, numberOfMixes},
								{MaxNumberOfMixes, maxNumberOfMixes},
								{MixVolume, Null},
								{Temperature, Ambient},
								{AnnealingTime,Null},
								{Amplitude, Null},
								{MaxTemperature, Null},
								{DutyCycle, Null},
								{StirBar, Null},
								{MixRateProfile, Null},
								{TemperatureProfile, Null},
								{OscillationAngle, Null},
								{PotentialAliquotContainers, potentialAliquotContainers},
								{Preheat,Null},
								{ResidualTemperature,Null},
								{ResidualMix,Null},
								{ResidualMixRate,Null},
								{MixPosition,Null},
								{MixPositionOffset,Null},
								{MixFlowRate,Null},
								{CorrectionCurve,Null},
								{Tips,Null},
								{TipType, Null},
								{TipMaterial,Null},
								{RelativeHumidity,Null},
								{LightExposure,Null},
								{LightExposureIntensity,Null},
								{TotalLightExposure,Null},
								{PreSonicationTime,Null},
								{AlternateInstruments,Null}
							}
						]
					],
					(*-- PIPETTE --*)
					Pipette,
						Module[{},
							(* Is the volume supplied by the user? *)
							volume=If[MatchQ[Lookup[myMapThreadOptions,MixVolume],Automatic],
								(* MixVolume is not supplied by the user. *)
								(* Is it manual or robotic?*)
								If[MatchQ[resolvedPreparation,Manual],
									(* For manual:*)
									(* Does the sample have a volume? *)
									If[!MatchQ[Lookup[samplePacket,Volume,0 Liter],GreaterEqualP[1Microliter]],
										(* No volume or 0 volume found. Default to the minimum MixVolume *)
										pipetteMixNoVolumeWarning=True;
										1 Microliter,
										(* Sample has a volume larger than 1 Microliter. *)
										(* Resolve it to 1/2 of the volume of the user's sample or 50 mL, whichever is smaller. *)
										If[(Lookup[samplePacket,Volume,0 Liter]/2)>50 Milliliter,
											50 Milliliter,
											Max[
												SafeRound[N[Lookup[samplePacket,Volume,0 Liter]/2], 1 Microliter],
												1 Microliter
											]
										]
									],

									(* ELSE: if robotic *)
									Which[
										!MatchQ[Lookup[samplePacket,Volume,0 Liter],GreaterEqualP[1Microliter]],
										(* No volume or 0 volume found. Default to the minimum MixVolume *)
										pipetteMixNoVolumeWarning=True;
										1 Microliter,
										MatchQ[Lookup[samplePacket, Volume], LessEqualP[970 Microliter]],
										SafeRound[N[Lookup[samplePacket,Volume,0 Liter]], 1 Microliter],
										(* NOTE: The maximum amount that we can aspirate using hamilton tips is 970 Microliter. *)
										True,970 Microliter
									]
								],

								(* The user gave us a volume. *)
								Lookup[myMapThreadOptions,MixVolume]
							];

							(* Resolve NumberOfMixes and MaxNumberOfMixes *)
							(* Do we have to resolve NumberOfMixes? *)
							numberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,NumberOfMixes],Automatic],
								(* yes we have to resolve. First check if manual or robotic*)
								If[MatchQ[resolvedPreparation,Manual],
									(* Resolve for Manual*)
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawNumberOfMixes]]
										],
										Lookup[samplePacket,ThawNumberOfMixes],
										(* Is MaxNumberOfMixes set? *)
										If[MatchQ[Lookup[myMapThreadOptions,NumberOfMixes],Except[Automatic|Null]],
											N[(1/3)*Lookup[myMapThreadOptions,NumberOfMixes]],
											(* What is the value of MixUntilDissolved? *)
											If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
												25,
												15
											]
										]
									],

									(* Else: resolve for robotic*)
									5
								],

								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,NumberOfMixes]
							];

							(* Do we have to resolve MaxNumberOfMixes? *)
							maxNumberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,MaxNumberOfMixes],Automatic],
								(* yes we have to resolve. First check if manual or robotic*)
								If[MatchQ[resolvedPreparation,Manual],
									(* first resolve for manual:*)
									(* What is the value of MixUntilDissolved? *)
									If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
										If[MatchQ[numberOfMixes, _?NumericQ],
											numberOfMixes*2,
											50
										],
										Null
									],

									(* ELSE: resolve for robotic*)
									Null
								],

								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxNumberOfMixes]
							];

							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxNumberOfMixes,_?NumericQ],
								True,
								MatchQ[resolvedPreparation, Robotic],
								Null,
								True,
								False
							];

							(* Resolve some robotic specific options *)
							{mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial}=If[MatchQ[resolvedPreparation,Robotic],
								Module[
									{myMixPosition,myMixPositionOffset,myMixFlowRate,myCorrectionCurve,sortedCorrectionCurve,sortedActualValues,myTips,myTipType,myTipMaterial},
									(* Resolve MixPosition. *)
									myMixPosition=If[
										MatchQ[Lookup[myMapThreadOptions, MixPosition], Except[Automatic]],
										Lookup[myMapThreadOptions, MixPosition],

										(* if not provided, then store default*)
										LiquidLevel
									];

									(* Resolve MixPositionOffset. *)
									myMixPositionOffset=If[
										MatchQ[Lookup[myMapThreadOptions, MixPositionOffset], Except[Automatic]],
										Lookup[myMapThreadOptions, MixPositionOffset],

										(* if not provided, then store default*)
										2 Millimeter
									];

									(* Resolve MixFlowRate. *)
									myMixFlowRate=If[
										MatchQ[Lookup[myMapThreadOptions, MixFlowRate], Except[Automatic]],
										Lookup[myMapThreadOptions, MixFlowRate],

										(* if not provided, then store default*)
										100 Microliter/Second
									];

									(* Resolve CorrectionCurve. *)
									myCorrectionCurve=If[
										MatchQ[Lookup[myMapThreadOptions, CorrectionCurve], Except[Automatic]],
										Lookup[myMapThreadOptions, CorrectionCurve],
										(* if not provided, then store default*)
										Module[{pipettingMethod, correctionCurve},
											(* Is there a correction curve from the pipetting method? *)
											pipettingMethod = Lookup[samplePacket, PipettingMethod];
											correctionCurve = fastAssocLookup[fastAssoc, pipettingMethod, CorrectionCurve];

											If[MatchQ[pipettingMethod, ObjectP[]] && !MatchQ[correctionCurve, $Failed | Null],
												Round[correctionCurve, 0.01 Microliter],
												Null
											]
										]
									];

									(* Sort curve by target volume values *)
									sortedCorrectionCurve=SortBy[myCorrectionCurve/.{Null->{}}, First];

									(* Sort only actual values *)
									sortedActualValues=Sort[(myCorrectionCurve/.{Null->{}})[[All, 2]]];

									(* Check for problems with correction curve *)
									monotonicCorrectionCurveWarning=If[!NullQ[myCorrectionCurve]&&!MatchQ[sortedActualValues, sortedCorrectionCurve[[All, 2]]]&&MatchQ[resolvedPreparation,Robotic],
										True,
										False
									];

									incompleteCorrectionCurveWarning=If[!NullQ[myCorrectionCurve]&&(!MatchQ[LastOrDefault[sortedCorrectionCurve], {GreaterEqualP[1000Microliter],_}]||!MatchQ[FirstOrDefault[sortedCorrectionCurve], {EqualP[0Microliter],_}])&&MatchQ[resolvedPreparation,Robotic],
										True,
										False
									];

									invalidZeroCorrectionError=If[!NullQ[myCorrectionCurve]&&(MatchQ[FirstOrDefault[sortedCorrectionCurve], {EqualP[0Microliter],Except[EqualP[0Microliter]]}])&&MatchQ[resolvedPreparation,Robotic],
										True,
										False
									];


									(* Resolve Tips. *)
									myTips=If[
										MatchQ[Lookup[myMapThreadOptions, Tips], Except[Automatic]],
										Lookup[myMapThreadOptions, Tips],
										(* if not provided, then store default*)
										Module[{specifiedTipType,specifiedTipMaterial,potentialTips},
											(* Lookup our TipType. *)
											specifiedTipType=Which[
												MatchQ[Lookup[myMapThreadOptions, TipType], Except[Automatic]],
												Lookup[myMapThreadOptions, TipType],
												(* Otherwise, all types. *)
												True,
												All
											];

											(* Lookup our TipMaterial. *)
											specifiedTipMaterial=(Lookup[myMapThreadOptions, TipMaterial]/.{Automatic->All});

											(* Get the tips that we should use. *)
											(* TransferDevices gives us results in a preferential order. *)
											potentialTips=Module[{rawPotentialTips, containerCompatibleTips},
												(* Get the list with the correct options passed down to it. *)
												rawPotentialTips=TransferDevices[
													Model[Item, Tips],
													volume,
													TipType->specifiedTipType,
													TipMaterial->specifiedTipMaterial,
													PipetteType->Hamilton,
													(* NOTE: We need sterile tips if we're on the bioSTAR/microbioSTAR since we can only load *)
													(* sterile tips due to the need for using a tip box. *)
													Sterile->If[MatchQ[workCell, bioSTAR|microbioSTAR],
														True,
														All
													]
												][[All,1]];

												(* These tips can hold the volume and meet the required TipType/TipMaterial -- but make sure that they can reach the bottom of the container. *)
												containerCompatibleTips=Select[
													rawPotentialTips,
													(tipsCanAspirateQ[
														#,
														sourceContainerModelPacket,
														volume,
														volume,
														allTipModelPackets,
														sampleContainerModelCalibrationPackets
													]&)
												];

												(* If there are no tips available that suit our needs, then take off our limitations and record an error *)
												(* to throw later. *)
												If[Length[containerCompatibleTips]==0,
													TransferDevices[
														Model[Item, Tips],
														volume,
														PipetteType->Hamilton
													][[All,1]],
													containerCompatibleTips
												]
											];

											Which[
												Length[potentialTips]==0,
												Null,
												True,
												FirstOrDefault[potentialTips]
											]
										]
									];

									(* Resolve TipType. *)
									myTipType=If[MatchQ[Lookup[myMapThreadOptions, TipType],Automatic],
										Which[
											(*When myTips is an Object*)
											MatchQ[myTips, ObjectP[Object[Item, Tips]]],
												(*Look up each value of the {WideBore, Filtered, Aspirator, GelLoading} in the selected myTips object packet*)
												(*If there are more than one True, (i.e. {WideBore,Filtered} or {Aspirator, Filtered}), display the first one as the resolved type*)
												First[
													Map[
														(*If the looked up value is True, append the TipTypeP to the resolved myTipType*)
														If[MatchQ[fastAssocLookup[fastAssoc, myTips, {Model, #}], True],
															#,
															Nothing
														]&,
														(*Map over the following field names in Model[Item,Tips], Replace Filtered(field name) with Barrier(TipTypeP), strip the list of single item, and return Normal for empty list *)
														{WideBore, Aspirator, Filtered, GelLoading}
													] /. {Filtered -> Barrier, {} -> {Normal}}
												],

											(*When myTips is a Model*)
											MatchQ[myTips, ObjectP[Model[Item, Tips]]],
												(*Similarly, Look up each value of the {WideBore, Filter, Aspirator, GelLoading} in the selected myTips model packet*)
												(*If there are more than one True, (i.e. {WideBore,Filtered} or {Aspirator,Filtered}), display the first one as the resolved type*)
												First[
													Map[
														If[MatchQ[fastAssocLookup[fastAssoc, myTips, #], True],
															(*If the looked up value is True, append the TipTypeP to the resolved myTipType*)
															#,
															Nothing
														]&,
														(*Map over the following field names in Model[Item,Tips], Replace Filtered(field name) with Barrier(TipTypeP), strip the list of single item, and return Normal for empty list *)
														{WideBore, Aspirator, Filtered, GelLoading}
													] /. {Filtered -> Barrier, {} -> {Normal}}
												],

											(*When myTips is neither Object nor Model, resolve to Null *)
											True,
												Null
										],
										Lookup[myMapThreadOptions, TipType]
									];

									(* Resolve TipMaterial based on the resolved Tips. *)
									myTipMaterial=If[MatchQ[Lookup[myMapThreadOptions, TipMaterial],Automatic],
										Which[
											MatchQ[myTips, ObjectP[Object[Item, Tips]]],
												fastAssocLookup[fastAssoc, myTips, {Model, Material}] /. {$Failed | NullP -> Null},
											MatchQ[myTips, ObjectP[Model[Item, Tips]]],
												fastAssocLookup[fastAssoc, myTips, Material] /. {$Failed | NullP -> Null},
											True,
												Null
										],
										Lookup[myMapThreadOptions, TipMaterial]
									];

									{ myMixPosition,myMixPositionOffset,myMixFlowRate,myCorrectionCurve,myTips,myTipType,myTipMaterial }
								],
								Module[
									{myTips,myTipType,myTipMaterial},

									(* Resolve Tips. *)
									myTips=If[MatchQ[Lookup[myMapThreadOptions, Tips], Except[Automatic]],
										Lookup[myMapThreadOptions, Tips],
										(* if not provided, then store default*)
										Module[{specifiedTipType,specifiedTipMaterial,potentialTips},
											(* Lookup our TipType. *)
											specifiedTipType=Which[
												MatchQ[Lookup[myMapThreadOptions, TipType], Except[Automatic]],
												Lookup[myMapThreadOptions, TipType],
												(* Otherwise, all types. *)
												True,
												All
											];

											(* Lookup our TipMaterial. *)
											specifiedTipMaterial=(Lookup[myMapThreadOptions, TipMaterial]/.{Automatic->All});

											(* Get the tips that we should use. *)
											(* TransferDevices gives us results in a preferential order. *)
											potentialTips=Module[{rawPotentialTips, containerCompatibleTips},
												(* Get the list with the correct options passed down to it. *)
												rawPotentialTips=TransferDevices[
													Model[Item, Tips],
													volume,
													TipType->specifiedTipType,
													TipMaterial->specifiedTipMaterial
												][[All,1]];

												(* These tips can hold the volume and meet the required TipType/TipMaterial -- but make sure that they can reach the bottom of the container. *)
												containerCompatibleTips=Select[
													rawPotentialTips,
													(tipsCanAspirateQ[
														#,
														sourceContainerModelPacket,
														volume,
														volume,
														allTipModelPackets,
														sampleContainerModelCalibrationPackets
													]&)
												];

												(* If there are no tips available that suit our needs, then take off our limitations and record an error *)
												(* to throw later. *)
												If[Length[containerCompatibleTips]==0,
													TransferDevices[
														Model[Item, Tips],
														volume
													][[All,1]],
													containerCompatibleTips
												]
											];

											Which[
												Length[potentialTips]==0,
												Null,
												True,
												FirstOrDefault[potentialTips]
											]
										]
									];

									(* Resolve TipType. *)
									myTipType=If[MatchQ[Lookup[myMapThreadOptions, TipType],Automatic],
										Which[
											(*When myTips is an Object*)
											MatchQ[myTips, ObjectP[Object[Item, Tips]]],
												(*Look up each value of the {WideBore, Filter, Aspirator, GelLoading} in the selected myTips object packet*)
												(*If there are more than one True, (i.e. {WideBore,Filtered} or {Aspirator,Filtered}), display the first as the resolved type*)
												First[
													Map[
														(*If the looked up value is True, append the TipTypeP to the resolved myTipType*)
														If[MatchQ[fastAssocLookup[fastAssoc, myTips, {Model, #}], True],
															#,
															Nothing
														]&,
														(*Map over the following field names in Model[Item,Tips], Replace Filtered(field name) with Barrier(TipTypeP), strip the list of single item, and return Normal for empty list *)
														{WideBore, Aspirator, Filtered, GelLoading}
													] /. {Filtered -> Barrier, {} -> {Normal}}
												],

											(*When myTips is a Model*)
											MatchQ[myTips, ObjectP[Model[Item, Tips]]],
												(*Similarly, Look up each value of the {WideBore, Filter, Aspirator, GelLoading} in the selected myTips model packet*)
												(*If there are more than one True, (i.e. {WideBore,Filtered} or {Aspirator,Filtered}), display the first one as the resolved type*)
												First[
													Map[
														If[MatchQ[fastAssocLookup[fastAssoc, myTips, #], True],
															(*If the looked up value is True, append the TipTypeP to the resolved myTipType*)
															#,
															Nothing
														]&,
														(*Map over the following field names in Model[Item,Tips], Replace Filtered(field name) with Barrier(TipTypeP), strip the list of single item, and return Normal for empty list *)
														{WideBore, Aspirator, Filtered, GelLoading}
													] /. {Filtered -> Barrier, {} -> {Normal}}
												],

											(*When myTips is neither Object nor Model, resolve to Null *)
											True,
												Null
										],
										Lookup[myMapThreadOptions, TipType]
									];

									(* Resolve TipMaterial based on the resolved Tips. *)
									myTipMaterial=If[MatchQ[Lookup[myMapThreadOptions, TipMaterial],Automatic],
										Which[
											MatchQ[myTips, ObjectP[Object[Item, Tips]]],
												fastAssocLookup[fastAssoc, myTips, {Model, Material}] /. {$Failed | NullP -> Null},
											MatchQ[myTips, ObjectP[Model[Item, Tips]]],
												fastAssocLookup[fastAssoc, myTips, Material] /. {$Failed | NullP -> Null},
											True,
												Null
										],
										Lookup[myMapThreadOptions, TipMaterial]
									];

									{Null,Null,Null,Null,myTips,myTipType,myTipMaterial}
								]
							];

							(* Resolve the instrument option. *)
							instrument=Which[
								MatchQ[Lookup[myMapThreadOptions,Instrument], ObjectP[]],
									Lookup[myMapThreadOptions,Instrument],
								MatchQ[resolvedPreparation,Robotic],
									Null,
								True,
									Module[{tipsModel, potentialPipettes},
										(* Convert our tips to a model. *)
										tipsModel = If[MatchQ[tips, ObjectP[Object[Item, Tips]]],
											fastAssocLookup[fastAssoc, tips, {Model, Object}],
											tips
										];

										(* Get all pipettes that can perform our transfer. *)
										potentialPipettes=compatiblePipettes[
											tipsModel,
											allTipModelPackets,
											allPipetteModelPackets,
											volume
										];

										(* Pick the first one or the largest one if there is not pipette that can hold all of the volume. *)
										If[Length[potentialPipettes]==0,
											FirstOrDefault@compatiblePipettes[
												tipsModel,
												allTipModelPackets,
												allPipetteModelPackets,
												All
											],
											FirstOrDefault[potentialPipettes]
										]
									]
							];

							(* Resolve ResidualMix. *)
							residualMix=Which[
								MatchQ[Lookup[myMapThreadOptions, ResidualMix], Except[Automatic]],
								Lookup[myMapThreadOptions, ResidualMix],
								True,
								Null
							];

							(* Resolve ResidualMixRate. *)
							residualMixRate=Which[
								MatchQ[Lookup[myMapThreadOptions, ResidualMixRate], Except[Automatic]],
								Lookup[myMapThreadOptions, ResidualMixRate],
								True,
								Null
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
							mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								&),
								(* Temperature and Time controls are not applicable for Pipette *)
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, instrument},
									{Time, Null},
									{MaxTime, Null},
									{MixRate, Null},
									{NumberOfMixes, numberOfMixes},
									{MaxNumberOfMixes, maxNumberOfMixes},
									{MixVolume, volume},
									{Temperature, Null},
									{AnnealingTime,Null},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, Null},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,residualMix},
									{ResidualMixRate,residualMixRate},
									{MixPosition,mixPosition},
									{MixPositionOffset,mixPositionOffset},
									{MixFlowRate,mixFlowRate},
									{CorrectionCurve,correctionCurve},
									{Tips,tips},
									{TipType, tipType},
									{TipMaterial,tipMaterial},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					(*-- VORTEX --*)
					Vortex,
						Module[{instrumentModel,vortexPacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,preResolvedRate,preResolvedTemperature},
							(* Did the user supply a instrument object? *)
							If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,Vortex],Model[Instrument,Vortex]}]],
								(* The user supplied a instrument object. *)
								instrument=Lookup[myMapThreadOptions,Instrument];

								(* Get the model of the instrument. *)
								instrumentModel = If[MatchQ[instrument, ObjectP[Model[Instrument, Vortex]]],
									instrument,
									fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
								];

								(* Did the user supply a rate? *)
								rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawMixRate]]
										],
										Lookup[samplePacket,ThawMixRate],
										(* Resolve to the average RPM of the set instrument. *)
										vortexPacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];

										(* Round to the nearest RPM. *)
										Round[Mean[Lookup[vortexPacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
									],
									(* MixRate isn't automatic. Go with the user supplied value. *)
									Lookup[myMapThreadOptions,MixRate]
								];

								(* What are the instruments that this sample can go on? *)
								potentialInstruments=MixDevices[
									mySample,
									Types->Vortex,
									InstrumentSearch->instrumentSearch,
									Cache -> cacheBall,
									Simulation->updatedSimulation
								];

								(* Is the user-specified instrument part of this list? *)
								compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

								(* Figure out if we need to aliquot our sample into another container. *)
								potentialAliquotContainers=If[compatibleFootprintQ,
									(* This vortex is compatible with the sample. *)
									Null,
									(* This vortex is not compatible with the sample in its current container. *)
									aliquotContainers=Lookup[MixDevices[
										mySample,
										{
											Types->Vortex,
											If[MatchQ[rate,UnitsP[RPM]],
												Rate->rate,
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache -> cacheBall,
											Simulation->updatedSimulation
										}
									],instrumentModel[Object],{}];

									(* Are there containers we can move this sample into? *)
									If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
										(* There are containers, just use these. *)
										vortexManualInstrumentContainerWarning=True;
										{instrumentModel->aliquotContainers},
										(* There are no containers. *)
										vortexIncompatibleInstrumentError=True;

										(* Then return Null. *)
										Null
									]
								],

								(* ELSE: The user did not supply a instrument. *)
								(* We need to resolve the instruments. *)
								(* Did the user supply a rate? *)
								preResolvedRate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawMixRate]]
										],
										Lookup[samplePacket,ThawMixRate],
										(* Keep Automatic if we don't have a ThawMixRate *)
										Automatic
									],
									(* MixRate isn't automatic. Go with the user supplied value (Null) *)
									Lookup[myMapThreadOptions,MixRate]
								];
								(* Did the user supply a temperature? Note that heated vortex is not strictly prohibited, and this logic would need to mirror the mixtype resolver which might resolve to Vortex when given a non-ambient temperature. *)
								preResolvedTemperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
									(* User supplied temperature. *)
									Lookup[myMapThreadOptions,Temperature],
									(* Did the user specify any incubation related options? *)
									If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
										40 Celsius,
										Ambient
									]
								];

								potentialInstruments=MixDevices[
									mySample,
									{
										Types->Vortex,
										If[MatchQ[preResolvedRate,UnitsP[RPM]],
											Rate->preResolvedRate,
											Nothing
										],
										Temperature->preResolvedTemperature/.{Ambient|$AmbientTemperature->Null},
										InstrumentSearch->instrumentSearch,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									}
								];

								(* Are there instruments that can currently support the footprint of our sample? *)
								instrument=If[Length[potentialInstruments]>0,
									(* Resolve rate (if we have to) to be the average rate of our first instrument. *)
									rate=If[MatchQ[preResolvedRate,Automatic],
										(* Resolve to the average RPM of the set instrument. *)
										vortexPacket = fetchPacketFromFastAssoc[First[potentialInstruments], fastAssoc];

										(* Round to the nearest RPM. *)
										Round[Mean[Lookup[vortexPacket,{MinRotationRate,MaxRotationRate},{1RPM,1RPM}]],1RPM],
										(* MixRate or ThawMixRate isn't automatic. Go with the user supplied value (Null) *)
										preResolvedRate
									];

									(* Choose the first compatible instrument. *)
									First[potentialInstruments],
									(* There are no compatible instruments that support our sample's footprint. *)
									(* Look to aliquot. *)

									(* Did the user supply a rate? *)
									potentialAliquotInstruments=MixDevices[
										mySample,
										{
											Types->Vortex,
											If[MatchQ[preResolvedRate,UnitsP[RPM]],
												Rate->preResolvedRate,
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache -> cacheBall,
											Simulation->updatedSimulation
										}
									];

									(* Did we get aliquot instruments? *)
									potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
										(* We did get aliquot results. *)
										vortexAutomaticInstrumentContainerWarning=True;
										potentialAliquotInstruments,
										(* We didn't get aliquot results. *)
										(* Did the user set rate? *)
										If[MatchQ[Lookup[myMapThreadOptions,MixRate],UnitsP[RPM]],
											vortexNoInstrumentForRateError=True,
											vortexNoInstrumentError=True
										];
										Null
									];

									(* Our instrument option is going to be Automatic or Null so we will keep our rate as the desired value or Automatic *)
									rate=preResolvedRate;

									(* Set our instrument option appropriately. *)
									If[Length[potentialAliquotInstruments]>0,
										(* We will resolve the instrument option in our aliquot section. *)
										Automatic,
										(* There is no container to move our sample into. No instrument available. *)
										Null
									]
								];
							];

							(* Resolve Time and MaxTime  *)
							time = Which[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
									(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
									Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
								(* TemperatureProfile is not given: Do we have to resolve Time? *)
								MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
								(* It's already user specified, use that value. *)
									Lookup[myMapThreadOptions,Time],
								(* Time is not specified. Resolve according to preparation method *)
								(* Not thawing and MaxTime is given *)
								!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
								(* Not thawing and MaxTime is not given*)
								!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									15 Minute,
								(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
									Lookup[samplePacket,ThawMixTime],
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
									5 Minute,
								True,
									0 Minute
							];

							(* Do we have to resolve MaxTime? *)
							maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
								(* What is the value of MixUntilDissolved? *)
								If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
									5 Hour,
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxTime]
							];

							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxNumberOfMixes,_?NumericQ],
								True,
								MatchQ[resolvedPreparation, Robotic],
								Null,
								True,
								False
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
								mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure, preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								 &),
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, instrument},
									{Time, time},
									{MaxTime, maxTime},
									{MixRate, rate},
									{NumberOfMixes, Null},
									{MaxNumberOfMixes, Null},
									{MixVolume, Null},
									{Temperature, Ambient},
									{AnnealingTime,Null},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,Null},
									{ResidualMixRate,Null},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					(*-- ROLL --*)
					Roll,
						Module[{instrumentModel,rollPacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,resolvedTemperature,resolvedAnnealingTime,preResolvedRate},
							(* Resolve Temperature up front. *)
							(* This is because we need to know the Temperature requirement before we pick an instrument (not all Shakers can heat). *)
							temperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
								(* User supplied temperature. *)
								Lookup[myMapThreadOptions,Temperature],
								(* Did the user specify any incubation related options? *)
								If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
									40 Celsius,
									Ambient
								]
							];

							(* Did the user supply a instrument object? *)
							If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,BottleRoller],Model[Instrument,BottleRoller],Object[Instrument,Roller],Model[Instrument,Roller]}]],
								(* The user supplied a instrument object. *)
								instrument=Lookup[myMapThreadOptions,Instrument];

								(* Get the model of the instrument. *)
								instrumentModel=If[MatchQ[instrument,ObjectP[{Model[Instrument,BottleRoller],Model[Instrument,Roller]}]],
									(* We already have the model. *)
									instrument,
									(* Go from the object to the model. *)
									fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
								];

								(* Did the user supply a rate? *)
								rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawMixRate]]
										],
										Lookup[samplePacket,ThawMixRate],
										(* Resolve to the average RPM of the set instrument. *)
										rollPacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];

										(* Round to the nearest RPM. *)
										Round[Mean[Lookup[rollPacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
									],
									(* MixRate isn't automatic. Go with the user supplied value. *)
									Lookup[myMapThreadOptions,MixRate]
								];

								(* What are the instruments that this sample can go on? *)
								potentialInstruments=MixDevices[
									mySample,
									Types->Roll,
									InstrumentSearch -> instrumentSearch,
									Cache -> cacheBall,
									Simulation->updatedSimulation
								];

								(* Is the user-specified instrument part of this list? *)
								compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

								(* Figure out if we need to aliquot our sample into another container. *)
								potentialAliquotContainers=If[compatibleFootprintQ,
									(* This roller is compatible with the sample. *)
									Null,
									(* This roller is not compatible with the sample in its current container. *)
									aliquotContainers=Lookup[MixDevices[
										mySample,
										{
											Types->Roll,
											(* Did the user specify a rate? *)
											If[MatchQ[rate,UnitsP[RPM]],
												Rate->rate,
												Nothing
											],
											(*Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache -> cacheBall,
											Simulation->updatedSimulation
										}
									],instrumentModel[Object],{}];

									(* Are there containers we can move this sample into? *)
									If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
										(* There are containers, just use these. *)
										rollManualInstrumentContainerWarning=True;
										{instrumentModel->aliquotContainers},
										(* There are no containers. *)
										rollIncompatibleInstrumentError=True;

										(* Then return Null. *)
										Null
									]
								],
								(* ELSE: The user did not supply a instrument. *)
								(* We need to resolve the instruments. *)
								preResolvedRate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawMixRate]]
										],
										Lookup[samplePacket,ThawMixRate],
										(* Keep Automatic if we don't have a ThawMixRate *)
										Automatic
									],
									(* MixRate isn't automatic. Go with the user supplied value (Null) *)
									Lookup[myMapThreadOptions,MixRate]
								];
								potentialInstruments=MixDevices[
									mySample,
									{
										Types->Roll,
										(* Did the user specify a rate? *)
										If[MatchQ[preResolvedRate,UnitsP[RPM]],
											Rate->preResolvedRate,
											Nothing
										],
										(*Did the user specify a temperature? *)
										If[MatchQ[temperature,UnitsP[Celsius]],
											Temperature->temperature,
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									}
								];

								(* Are there instruments that can currently support the footprint of our sample? *)
								instrument=If[Length[potentialInstruments]>0,
									(* Resolve rate (if we have to) to be the average rate of our first instrument. *)
									rate=If[MatchQ[preResolvedRate,Automatic],
										(* Resolve to the average RPM of the set instrument. *)
										rollPacket = fetchPacketFromFastAssoc[First[potentialInstruments], fastAssoc];

										(* Round to the nearest RPM. *)
										Round[Mean[Lookup[rollPacket,{MinRotationRate,MaxRotationRate},{1RPM,1RPM}]],1RPM],
										(* MixRate isn't automatic. Go with the user supplied value (Null) *)
										preResolvedRate
									];

									(* Choose the first compatible instrument. *)
									First[potentialInstruments],
									(* There are no compatible instruments that support our sample's footprint. *)
									(* Look to aliquot. *)
									potentialAliquotInstruments=MixDevices[
										mySample,
										{
											Types->Roll,
											(* Did the user specify a rate? *)
											If[MatchQ[preResolvedRate,UnitsP[RPM]],
												Rate->preResolvedRate,
												Nothing
											],
											(*Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache -> cacheBall,
											Simulation->updatedSimulation
										}
									];

									(* Did we get aliquot instruments? *)
									potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
										(* We did get aliquot results. *)
										rollAutomaticInstrumentContainerWarning=True;
										potentialAliquotInstruments,
										(* We didn't get aliquot results. *)
										rollNoInstrumentError=True;
										Null
									];

									(* Our instrument option is going to be Automatic or Null so we will keep our rate as the desired value or Automatic *)
									rate=preResolvedRate;

									(* Set our instrument option appropriately. *)
									If[Length[potentialAliquotInstruments]>0,
										(* We will resolve the instrument option in our aliquot section. *)
										Automatic,
										(* There is no container to move our sample into. No instrument available. *)
										Null
									]
								];
							];

							(* Resolve Time and MaxTime *)
							time = Which[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
								(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
									Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
								(* TemperatureProfile is not given: Do we have to resolve Time? *)
								MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
								(* It's already user specified, use that value. *)
									Lookup[myMapThreadOptions,Time],
								(* Time is not specified. Resolve according to preparation method *)
								(* Not thawing and MaxTime is given *)
								!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
								(* Not thawing and MaxTime is not given*)
								!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									15 Minute,
								(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
									Lookup[samplePacket,ThawMixTime],
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
									5 Minute,
								True,
									0 Minute
							];

							(* Do we have to resolve MaxTime? *)
							maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
								(* What is the value of MixUntilDissolved? *)
								If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
									5 Hour,
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxTime]
							];

							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxTime,TimeP],
								True,
								MatchQ[resolvedPreparation, Robotic],
								Null,
								True,
								False
							];

							(* Resolve Temperature. *)
							(* Are any of the incubation related options set? *)
							{resolvedTemperature,resolvedAnnealingTime}=If[Or[
									!MatchQ[temperature,Automatic|Ambient|Null],
									!MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Automatic|Null]
								],
								(* We need to set temperature. *)
								{
									temperature,
									0 Minute
								},
								(* We do not need to set temperature. *)
								{
									Ambient,
									Null
								}
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
								mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								 &),
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, instrument},
									{Time, time},
									{MaxTime, maxTime},
									{MixRate, rate},
									{NumberOfMixes, Null},
									{MaxNumberOfMixes, Null},
									{MixVolume, Null},
									{Temperature, resolvedTemperature},
									{AnnealingTime,resolvedAnnealingTime},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,Null},
									{ResidualMixRate,Null},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					(*-- SHAKE --*)
					Shake,
						Module[{instrumentModel,shakePacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,resolvedTemperature,resolvedAnnealingTime,preResolvedRate},
							(* Resolve Temperature up front. *)
							(* This is because we need to know the Temperature requirement before we pick an instrument (not all Shakers can heat). *)
							temperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
								(* User supplied temperature. *)
								Lookup[myMapThreadOptions,Temperature],
								(* Did the user specify any incubation related options? *)
								If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
									40 Celsius,
									Ambient
								]
							];

							(* Resolve ResidualTemperature. *)
							residualTemperature=Which[
								MatchQ[Lookup[myMapThreadOptions, ResidualTemperature], Except[Automatic]],
								Lookup[myMapThreadOptions, ResidualTemperature],
								MatchQ[Lookup[myMapThreadOptions, residualIncubation], True],
								temperature,
								True,
								Null
							];

							(* Resolve ResidualMix. *)
							residualMix=Which[
								MatchQ[Lookup[myMapThreadOptions, ResidualMix], Except[Automatic]],
								Lookup[myMapThreadOptions, ResidualMix],
								MatchQ[Lookup[myMapThreadOptions, ResidualMixRate], Except[Automatic|Null]],
								True,
								MatchQ[resolvedPreparation, Robotic],
								False,
								True,
								Null
							];

							(* Resolve the instrument*)
							If[MatchQ[resolvedPreparation,Manual],

								(* Resolve the Manual instrument*)
								(* Did the user supply a instrument object? *)
								If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,Shaker],Model[Instrument,Shaker]}]],
									(* The user supplied a instrument object. *)
									instrument=Lookup[myMapThreadOptions,Instrument];

									(* Get the model of the instrument. *)
									instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,Shaker]]],
										(* We already have the model. *)
										instrument,
										(* Go from the object to the model. *)
										fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
									];

									(* Did the user supply a rate? *)
									rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
										If[
											And[
												TrueQ[thaw],
												!NullQ[Lookup[samplePacket,ThawMixRate]]
											],
											Lookup[samplePacket,ThawMixRate],
											(* Resolve to the average RPM of the set instrument. *)
											shakePacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];

											(* Round to the nearest RPM, unless we're using a LabRAM. *)
											If[MatchQ[Lookup[shakePacket,MaxForce], UnitsP[GravitationalAcceleration]],
												50 GravitationalAcceleration,
												Round[Mean[Lookup[shakePacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
											]
										],
										(* MixRate isn't automatic. Go with the user supplied value. *)
										Lookup[myMapThreadOptions,MixRate]
									];

									(* Does instrument support the footprint of mySample? *)
									(* Get the instruments that this sample can go on. *)
									potentialInstruments=MixDevices[
										mySample,
										Types->Shake,
										InstrumentSearch->instrumentSearch,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									];

									(* Is the user-specified instrument part of this list? *)
									compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

									(* Figure out if we need to aliquot our sample into another container. *)
									potentialAliquotContainers=If[compatibleFootprintQ,
										(* This shaker is compatible with the sample. *)
										Null,
										(* This shaker is not compatible with the sample in its current container. *)
										aliquotContainers=Lookup[MixDevices[
											mySample,
											{
												Types->Shake,
												(* Did the user specify a rate? *)
												Which[
													MatchQ[rate,UnitsP[RPM]],
														Rate->rate,
													MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List] && Length[Lookup[myMapThreadOptions,MixRateProfile]]>0,
														Rate->Max[Lookup[myMapThreadOptions,MixRateProfile][[All,2]]],
													True,
														Nothing
												],
												(* Did the user specify an MixRateProfile? *)
												If[MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List],
													ProgrammableMixControl->True,
													Nothing
												],
												(* Did the user specify an TemperatureProfile? *)
												If[MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], _List],
													ProgrammableTemperatureControl->True,
													Nothing
												],
												(* Did the user specify an OscillationAngle? *)
												If[MatchQ[Lookup[myMapThreadOptions,OscillationAngle], UnitsP[AngularDegree]],
													OscillationAngle->Lookup[myMapThreadOptions,OscillationAngle],
													Nothing
												],
												(*Did the user specify a temperature? *)
												Which[
													MatchQ[temperature,UnitsP[Celsius]],
														Temperature->temperature,
													MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], _List] && Length[Lookup[myMapThreadOptions,TemperatureProfile]]>0,
														Temperature->Max[Lookup[myMapThreadOptions,TemperatureProfile][[All,2]]],
													True,
														Nothing
												],
												InstrumentSearch->instrumentSearch,
												Output->Containers,
												Cache->cacheBall,
												Simulation->updatedSimulation
											}
										],instrumentModel[Object],{}];

										(* Are there containers we can move this sample into? *)
										If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
											(* There are containers, just use these. *)
											shakeManualInstrumentContainerWarning=True;
											{instrumentModel->aliquotContainers},
											(* There are no containers. *)
											shakeIncompatibleInstrumentError=True;

											(* Then return Null. *)
											Null
										]
									],
									(* ELSE: The user did not supply a instrument. *)
									(* We need to resolve the instruments. *)
									preResolvedRate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
										If[
											And[
												TrueQ[thaw],
												!NullQ[Lookup[samplePacket,ThawMixRate]]
											],
											Lookup[samplePacket,ThawMixRate],
											(* Keep Automatic if we don't have a ThawMixRate *)
											Automatic
										],
										(* MixRate isn't automatic. Go with the user supplied value (Null) *)
										Lookup[myMapThreadOptions,MixRate]
									];
									potentialInstruments=MixDevices[
										mySample,
										{
											Types->Shake,
											(* Did the user specify a rate? *)
											Which[
												MatchQ[preResolvedRate,UnitsP[RPM]|UnitsP[GravitationalAcceleration]],
													Rate->preResolvedRate,
												MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List] && Length[Lookup[myMapThreadOptions,MixRateProfile]]>0,
													Rate->Max[Lookup[myMapThreadOptions,MixRateProfile][[All,2]]],
												True,
													Nothing
											],
											(* Did the user specify an MixRateProfile? *)
											If[MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List],
												ProgrammableMixControl->True,
												Nothing
											],
											(* Did the user specify an TemperatureProfile? *)
											If[MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], _List],
												ProgrammableTemperatureControl->True,
												Nothing
											],
											(* Did the user specify an OscillationAngle? *)
											If[MatchQ[Lookup[myMapThreadOptions,OscillationAngle], UnitsP[AngularDegree]],
												OscillationAngle->Lookup[myMapThreadOptions,OscillationAngle],
												Nothing
											],
											(*Did the user specify a temperature? *)
											Which[
												MatchQ[temperature,UnitsP[Celsius]],
													Temperature->temperature,
												MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], _List] && Length[Lookup[myMapThreadOptions,TemperatureProfile]]>0,
													Temperature->Max[Lookup[myMapThreadOptions,TemperatureProfile][[All,2]]],
												True,
													Nothing
											],
											InstrumentSearch->instrumentSearch,
											Cache -> cacheBall,
											Simulation->updatedSimulation
										}
									];

									(* Are there instruments that can currently support the footprint of our sample? *)
									instrument=If[Length[potentialInstruments]>0,
										(* Resolve rate (if we have to) to be the average rate of our first instrument. *)
										rate=If[MatchQ[preResolvedRate,Automatic],
											If[!MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List],
												(* Resolve to the average RPM of the set instrument. *)
												shakePacket = fetchPacketFromFastAssoc[First[potentialInstruments], fastAssoc];

												(* Round to the nearest RPM, unless we're using a LabRAM. *)
												If[MatchQ[Lookup[shakePacket,MaxForce], UnitsP[GravitationalAcceleration]],
													50 GravitationalAcceleration,
													Round[Mean[Lookup[shakePacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
												],
												Null
											],
											(* MixRate isn't automatic. Go with the user supplied value (Null) *)
											preResolvedRate
										];

										(* Choose the first compatible instrument. *)
										First[potentialInstruments],
										(* There are no compatible instruments that support our sample's footprint. *)
										(* Look to aliquot. *)

										(* Did the user supply a rate? *)
										potentialAliquotInstruments=MixDevices[
											mySample,
											{
												Types->Shake,
												(* Did the user specify a rate? *)
												Which[
													MatchQ[preResolvedRate,UnitsP[RPM]|UnitsP[GravitationalAcceleration]],
														Rate->preResolvedRate,
													MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List] && Length[Lookup[myMapThreadOptions,MixRateProfile]]>0,
														Rate->Max[Lookup[myMapThreadOptions,MixRateProfile][[All,2]]],
													And[
														TrueQ[thaw],
														!NullQ[Lookup[samplePacket,ThawMixRate]]
													],
														Rate -> Lookup[samplePacket,ThawMixRate],
													True,
														Nothing
												],
												(* Did the user specify an MixRateProfile? *)
												If[MatchQ[Lookup[myMapThreadOptions,MixRateProfile], _List],
													ProgrammableMixControl->True,
													Nothing
												],
												(* Did the user specify an TemperatureProfile? *)
												If[MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], _List],
													ProgrammableTemperatureControl->True,
													Nothing
												],
												(* Did the user specify an OscillationAngle? *)
												If[MatchQ[Lookup[myMapThreadOptions,OscillationAngle], UnitsP[AngularDegree]],
													OscillationAngle->Lookup[myMapThreadOptions,OscillationAngle],
													Nothing
												],
												(*Did the user specify a temperature? *)
												Which[
													MatchQ[temperature,UnitsP[Celsius]],
														Temperature->temperature,
													MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], _List] && Length[Lookup[myMapThreadOptions,TemperatureProfile]]>0,
														Temperature->Max[Lookup[myMapThreadOptions,TemperatureProfile][[All,2]]],
													True,
														Nothing
												],
												InstrumentSearch->instrumentSearch,
												Output->Containers,
												Cache -> cacheBall,
												Simulation->updatedSimulation
											}
										];

										(* Did we get aliquot instruments? *)
										potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
											(* We did get aliquot results. *)
											shakeAutomaticInstrumentContainerWarning=True;
											potentialAliquotInstruments,
											(* We didn't get aliquot results. *)
											shakeNoInstrumentError=True;
											Null
										];

										(* Our instrument option is going to be Automatic or Null so we will keep our rate as the desired value or Automatic *)
										rate=preResolvedRate;

										(* Set our instrument option appropriately. *)
										If[Length[potentialAliquotInstruments]>0,
											(* We will resolve the instrument option in our aliquot section. *)
											Automatic,
											(* There is no container to move our sample into. No instrument available. *)
											Null
										]
									];
								],

								(* Resolve if it is robotic:*)
								Module[{potentialInstruments},

									(* no potential aliquot containers*)
									potentialAliquotContainers=Null;

									(* Resolve MixRate. *)
									rate=If[
										MatchQ[Lookup[myMapThreadOptions, MixRate], Except[Automatic]],
										Lookup[myMapThreadOptions, MixRate],
										300 RPM
									];

									(* Get the hamilton integrated instruments that we can use to perform this incubation. *)
									(* Weirdly, if they set MixRate->Null, we will just incubate. *)
									potentialInstruments=If[MatchQ[rate, Null],
										If[MatchQ[residualTemperature, TemperatureP],
											Intersection[
												IncubateDevices[
													Model[Container, Plate, "96-well 2mL Deep Well Plate"],
													1 Milliliter,
													Temperature->temperature/.{Ambient->Null},
													IntegratedLiquidHandler->True
												],
												IncubateDevices[
													Model[Container, Plate, "96-well 2mL Deep Well Plate"],
													1 Milliliter,
													Temperature->residualTemperature/.{Ambient->Null},
													IntegratedLiquidHandler->True
												]
											],
											IncubateDevices[
												Model[Container, Plate, "96-well 2mL Deep Well Plate"],
												1 Milliliter,
												Temperature->temperature/.{Ambient->Null},
												IntegratedLiquidHandler->True
											]
										],
										If[MatchQ[residualTemperature, TemperatureP] || MatchQ[residualMixRate, RPMP|UnitsP[GravitationalAcceleration]],
											Complement[
												Intersection[
													MixDevices[
														Model[Container, Plate, "96-well 2mL Deep Well Plate"],
														1 Milliliter,
														Temperature->temperature,
														Rate->rate,
														IntegratedLiquidHandler->True
													],
													MixDevices[
														Model[Container, Plate, "96-well 2mL Deep Well Plate"],
														1 Milliliter,
														Temperature->If[MatchQ[residualTemperature, TemperatureP],
															residualTemperature,
															Null
														],
														Rate->If[MatchQ[residualMixRate, RPMP|UnitsP[GravitationalAcceleration]],
															residualMixRate,
															Null
														],
														IntegratedLiquidHandler->True
													]
												],
												(* Do not allow residual incubation on off-deck heater shaker since we must move the plate out  *)
												{Model[Instrument, Shaker, "id:eGakldJkWVnz"]}
											],
											MixDevices[
												Model[Container, Plate, "96-well 2mL Deep Well Plate"],
												1 Milliliter,
												Temperature->temperature,
												Rate->rate,
												IntegratedLiquidHandler->True
											]
										]
									];
									(* Filter based on the work cell that we're on. *)
									instrument=If[MatchQ[workCell, STAR],
										(* If we're on the STAR, we do not have the ThermoshakeAC and Off-Deck Incubator Shaker. *)
										FirstOrDefault[
											Cases[
												potentialInstruments,
												Except[Alternatives[Model[Instrument, Shaker, "id:eGakldJkWVnz"],Model[Instrument, Shaker, "id:pZx9jox97qNp"]]]
											]
										],
										(* Otherwise, we are on the microbioSTAR or bioSTAR and do not have the heater shakers (we have the thermoshake instead). *)
										FirstOrDefault[
											Cases[
												potentialInstruments,
												Except[Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"]]
											]
										]
									]
								];
							];

							(* Resolve ResidualMixRate. *)
							residualMixRate=Which[
								MatchQ[Lookup[myMapThreadOptions, ResidualMixRate], Except[Automatic]],
								Lookup[myMapThreadOptions, ResidualMixRate],
								MatchQ[residualMix, True],
								rate,
								True,
								Null
							];

							(* Resolve Time and MaxTime *)
							time = Which[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
								(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
									Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
								(* TemperatureProfile is not given: Do we have to resolve Time? *)
								MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
								(* It's already user specified, use that value. *)
									Lookup[myMapThreadOptions,Time],
								(* Time is not specified. Resolve according to preparation method *)
								(* Resolve for Robotic *)
								MatchQ[resolvedPreparation, Robotic],
									5 Minute,
								(* Resolve for Manual*)
								(* Not thawing and MaxTime is given *)
								!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
								(* Not thawing and MaxTime is not given*)
								!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									15 Minute,
								(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
									Lookup[samplePacket,ThawMixTime],
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
									5 Minute,
								True,
									0 Minute
							];

							(* Do we have to resolve MaxTime? *)
							maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
								(* What is the value of MixUntilDissolved? *)
								If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
									5 Hour,
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxTime]
							];

							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxTime,TimeP],
								True,
								MatchQ[resolvedPreparation, Robotic],
								Null,
								True,
								False
							];

							(* Resolve OscillationAngle. *)
							oscillationAngle=If[MatchQ[Lookup[myMapThreadOptions,OscillationAngle],Automatic],
								If[Or[
										(* Torrey Pines Orbital Shaker *)
										MatchQ[instrument, ObjectP[Model[Instrument, Shaker, "id:N80DNj15vreD"]]],
										MatchQ[instrument, ObjectP[fastAssocLookup[fastAssoc, Model[Instrument, Shaker, "id:N80DNj15vreD"], Objects]]],

										(* Wrist Action Shaker *)
										MatchQ[instrument, ObjectP[Model[Instrument, Shaker, "id:Vrbp1jG80JAw"]]],
										MatchQ[instrument,ObjectP[fastAssocLookup[fastAssoc, Model[Instrument, Shaker, "id:Vrbp1jG80JAw"], Objects]]]
									],
									(* 15 AngularDegree is our maximum angle of shaking. *)
									15 AngularDegree,
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,OscillationAngle]
							];

							(* Resolve Temperature. *)
							(* Are any of the incubation related options set? *)
							resolvedTemperature=If[Or[
								!MatchQ[temperature,Automatic|Ambient|Null],
								!MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Automatic|Null]
							],
								(* We need to set temperature. *)
								temperature,
								(* We do not need to set temperature. *)
								Ambient
							];

							(* AnnealingTime is a manual only option. Since we can also shake on the Hamilton we need special handling here *)
							resolvedAnnealingTime=Switch[{Lookup[myMapThreadOptions,AnnealingTime],resolvedPreparation},
								{Except[Automatic],_}, Lookup[myMapThreadOptions,AnnealingTime],
								{_, Robotic}, Null,
								_, 0 Minute
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
							mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								 &),
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, instrument},
									{Time, time},
									{MaxTime, maxTime},
									{MixRate, rate},
									{NumberOfMixes, Null},
									{MaxNumberOfMixes, Null},
									{MixVolume, Null},
									{Temperature, resolvedTemperature},
									{AnnealingTime,resolvedAnnealingTime},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, oscillationAngle},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,residualTemperature},
									{ResidualMix,residualMix},
									{ResidualMixRate,residualMixRate},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					(*-- STIR --*)
					Stir,
						Module[{instrumentModel,stirPacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,resolvedTemperature,resolvedAnnealingTime,preResolvedRate, exampleAliquotContainer, allPotentialImpelllers, containerSafeMixRate},
							(* Did the user supply a instrument object? *)
							If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,OverheadStirrer],Model[Instrument,OverheadStirrer]}]],
								(* The user supplied a instrument object. *)
								instrument=Lookup[myMapThreadOptions,Instrument];

								(* Get the model of the instrument. *)
								instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,OverheadStirrer]]],
									(* We already have the model. *)
									instrument,
									(* Go from the object to the model. *)
									fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
								];

								(* We need this variable populated for stir bar resolver, since it is specified, it just contains the model of the supplied instrument *)
								potentialAliquotInstruments = {instrumentModel -> Null};

								(* Did the user supply a rate? *)
								rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawMixRate]]
										],
										Lookup[samplePacket,ThawMixRate],
										(* Resolve to 20% of max RPM of the set instrument. *)
										stirPacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];
										(* find out the containerSafeMixRate *)
										containerSafeMixRate = Lookup[sourceContainerModelPacket, MaxOverheadMixRate, Null];

										(* Round to the nearest RPM. *)
										If[NullQ[containerSafeMixRate],
											(* if we do not have MaxOverheadMixRate populated, we will try to use stir bar later *)
											Round[0.2*Lookup[stirPacket,MaxStirBarRotationRate,1000RPM],1RPM],
											Min[Round[0.2*Lookup[stirPacket,MaxRotationRate,1000RPM],1RPM], containerSafeMixRate]
										]
									],
									(* MixRate isn't automatic. Go with the user supplied value. *)
									Lookup[myMapThreadOptions,MixRate]
								];

								(* Does instrument support the footprint of mySample? *)
								(* Get the instruments that this sample can go on. *)
								potentialInstruments=MixDevices[
									mySample,
									Types->Stir,
									InstrumentSearch->instrumentSearch,
									Cache -> cacheBall,
									Simulation->updatedSimulation
								];

								(* Is the user-specified instrument part of this list? *)
								compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

								(* Figure out if we need to aliquot our sample into another container. *)
								potentialAliquotContainers=If[compatibleFootprintQ,
									(* This stirrer is compatible with the sample. *)
									Null,
									(* This stirrer is not compatible with the sample in its current container. *)
									aliquotContainers=Lookup[MixDevices[
										mySample,
										{
											Types->Stir,
											(* Did the user specify a rate? *)
											If[MatchQ[rate,UnitsP[RPM]],
												Rate->rate,
												Nothing
											],
											(*Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache->cacheBall,
											Simulation->updatedSimulation
										}
									],instrumentModel[Object],{}];

									(* Are there containers we can move this sample into? *)
									If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
										(* There are containers, just use these. *)
										stirManualInstrumentContainerWarning=True;
										{instrumentModel->aliquotContainers},
										(* There are no containers. *)
										stirIncompatibleInstrumentError=True;

										(* Then return Null. *)
										Null
									]
								];
								exampleAliquotContainer = If[Length[potentialAliquotContainers]>0,
									FirstCase[Flatten[Values[potentialAliquotContainers]],
										ObjectP[Model[Container]]],
									Null
								],
								(* ELSE: The user did not supply a instrument. *)
								(* We need to resolve the instruments. *)
								preResolvedRate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
									If[
										And[
											TrueQ[thaw],
											!NullQ[Lookup[samplePacket,ThawMixRate]]
										],
										Lookup[samplePacket,ThawMixRate],
										(* Keep Automatic if we don't have a ThawMixRate *)
										Automatic
									],
									(* MixRate isn't automatic. Go with the user supplied value (Null) *)
									Lookup[myMapThreadOptions,MixRate]
								];
								potentialInstruments=MixDevices[
									mySample,
									{
										Types->Stir,
										(* Did the user specify a rate? *)
										If[MatchQ[preResolvedRate,UnitsP[RPM]],
											Rate->preResolvedRate,
											Nothing
										],
										(* Did the user specify a temperature? *)
										If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
											Temperature->Lookup[myMapThreadOptions,Temperature],
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Cache->cacheBall,
										Simulation->updatedSimulation
									}
								];

								(* Are there instruments that can currently support the footprint of our sample? *)
								instrument=If[Length[potentialInstruments]>0,
									(* Resolve rate (if we have to) to be the average rate of our first instrument. *)
									rate=If[MatchQ[preResolvedRate,Automatic],
										(* Resolve to 20% of max RPM of the set instrument. *)
										stirPacket = fetchPacketFromFastAssoc[First[potentialInstruments], fastAssoc];
										(* Round to the nearest RPM. *)
										(* Include magnetic stir rates if instrument allows for it *)
										If[
											And[
												(* StirBarControl can be Null or False, so need to use a MatchQ just in case *)
												MatchQ[
													Lookup[stirPacket, StirBarControl],
													True
												],
												Or[
													MatchQ[
														compatibleImpeller[mySample, Lookup[stirPacket, Object], Cache->cacheBall, Simulation->simulation],
														Null
													],
													NullQ[Lookup[fetchPacketFromFastAssoc[sourceContainerModelPacket, fastAssoc], MaxOverheadMixRate, Null]]
												]
											],
											Round[0.2 * Lookup[stirPacket, MaxStirBarRotationRate, 1000RPM], 1RPM],
											(* Check for safe over head stir mix rate and take the smaller one *)
											Min[Round[0.2*Lookup[stirPacket,MaxRotationRate,1000RPM],1RPM], Lookup[sourceContainerModelPacket, MaxOverheadMixRate]]

										],
										(* MixRate isn't automatic. Go with the user supplied value (Null) *)
										preResolvedRate
									];

									(* Choose the first compatible instrument. *)
									First[potentialInstruments],
									(* ELSE: There are no compatible instruments that support our sample's footprint. *)
									(* Look to aliquot. *)
									potentialAliquotInstruments=MixDevices[
										mySample,
										{
											Types->Stir,
											(* Did the user specify a rate? *)
											If[MatchQ[preResolvedRate,UnitsP[RPM]],
												Rate->preResolvedRate,
												Nothing
											],
											(*Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache->cacheBall,
											Simulation->updatedSimulation
										}
									];
									(* Did we get aliquot instruments? *)
									potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
										(* We did get aliquot results. *)
										stirAutomaticInstrumentContainerWarning=True;
										potentialAliquotInstruments,
										(* We didn't get aliquot results. *)
										stirNoInstrumentError=True;
										Null
									];

									(* If we need to aliquot to new container, get a model from potential aliquot containers to resolve the stir bar downstream. Otherwise we might not be able to find a stir bar based on mySample, leading to a situation where we stir but no impeller or stir bar is resolved. *)
									exampleAliquotContainer = If[Length[potentialAliquotContainers]>0,
										FirstCase[Flatten[Values[potentialAliquotContainers]],
											ObjectP[Model[Container]]],
										Null
									];

									(* Our instrument option is going to be Automatic or Null so we will keep our rate as the desired value or Automatic *)
									rate=preResolvedRate;

									(* Set our instrument option appropriately. *)
									If[Length[potentialAliquotInstruments]>0,
										(* We will resolve the instrument option in our aliquot section. *)
										Automatic,
										(* There is no container to move our sample into. No instrument available. *)
										Null
									]
								];
								(* We need the instrument model for this branch as well *)
								(* Get the model of the instrument. *)
								instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,OverheadStirrer]]],
									(* We already have the model. *)
									instrument,
									(* This branch we should not get any object, but it might remain Automatic *)
									Null
								];
							];
							(* Resolve Time and MaxTime *)
							time = Which[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
								(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
									Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
								(* TemperatureProfile is not given: Do we have to resolve Time? *)
								MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
								(* It's already user specified, use that value. *)
									Lookup[myMapThreadOptions,Time],
								(* Time is not specified. Resolve according to preparation method *)
								(* Not thawing and MaxTime is given *)
								!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
								(* Not thawing and MaxTime is not given*)
								!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									15 Minute,
								(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
									Lookup[samplePacket,ThawMixTime],
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
									5 Minute,
								True,
									0 Minute
							];

							(* Do we have to resolve MaxTime? *)
							maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
								(* What is the value of MixUntilDissolved? *)
								If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
									5 Hour,
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxTime]
							];

							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxTime,TimeP],
								True,
								MatchQ[resolvedPreparation, Robotic],
								Null,
								True,
								False
							];

							(* Resolve Temperature. *)
							(* Are any of the incubation related options set? *)
							{resolvedTemperature,resolvedAnnealingTime}=If[Or[
									!MatchQ[Lookup[myMapThreadOptions,Temperature],Automatic|Ambient|Null],
									!MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Automatic|Null]
								],
								(* We need to set temperature. *)
								{
									If[MatchQ[Lookup[myMapThreadOptions,Temperature],Automatic],
										40 Celsius,
										(* Temperature isn't automatic. Go with the user supplied value (Null) *)
										Lookup[myMapThreadOptions,Temperature]
									],
									0 Minute
								},
								(* We do not need to set temperature. *)
								{
									Ambient,
									Null
								}
							];
							(* If there's potential aliquot, get all potential impellers. This evaluation is used a couple times below *)
							allPotentialImpelllers = If[MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
								compatibleImpeller[exampleAliquotContainer, #, Cache->cacheBall, Simulation->simulation]& /@ Keys[potentialAliquotInstruments],
								{Null}
							];

							(* Resolve StirBar. *)
							stirBar=If[MatchQ[Lookup[myMapThreadOptions,StirBar],Automatic],
								(* Only use stir bar if the instrument is able to use it, the speed is achievable by a stir bar, *)
								(* and there is not an impeller that can be used.  *)
								Which[
									And[
										(* Do the following check only if we have a valid instrument *)
										MatchQ[
											instrument,
											ObjectP[{Object[Instrument], Model[Instrument]}]
										],
										(* StirBarControl can be Null or False, so need to use a MatchQ just in case *)
										MatchQ[
											fastAssocLookup[fastAssoc, instrumentModel, StirBarControl],
											True
										],
										MatchQ[
											rate,
											GreaterP[fastAssocLookup[fastAssoc, instrumentModel, MinStirBarRotationRate]]
										],
										(* Need to use stir bar if there's no compatibleImpeller, or there is impeller found but MaxOverheadMixRate is not populated for the container, or smaller than mix rate *)
										Or[
											MatchQ[
												If[MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
													compatibleImpeller[exampleAliquotContainer, instrument, Cache->cacheBall, Simulation->simulation],
													compatibleImpeller[mySample, instrument, Cache->cacheBall, Simulation->simulation]
												],
												Null
											],
											NullQ[
												If[MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
													Lookup[fetchPacketFromFastAssoc[exampleAliquotContainer, fastAssoc], MaxOverheadMixRate, Null],
													Lookup[fetchPacketFromFastAssoc[sourceContainerModelPacket, fastAssoc], MaxOverheadMixRate, Null]
												]
											],
											If[MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
												rate > fastAssocLookup[fastAssoc, exampleAliquotContainer, MaxOverheadMixRate],
												rate > fastAssocLookup[fastAssoc, sourceContainerModelPacket, MaxOverheadMixRate]
											]
										]
									],
									(* call compatibleStirBar to resolve the stir bar, *)
									(*input the sample if we are not aliquot, and input the aliquot container if we need to *)
										If[MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
											compatibleStirBar[exampleAliquotContainer, Cache->cacheBall, Simulation->simulation],
											compatibleStirBar[mySample, Cache->cacheBall, Simulation->simulation]
										],
									(* Or if we are aliquoting, using stir bar can encompass a wider selection of conditions in rate, temp etc. So if any of the potential aliquot instrument can use stir bar, we resolve a stir bar. *)
									And[
										MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
										MemberQ[
											fastAssocLookup[fastAssoc, Keys[potentialAliquotInstruments], StirBarControl],
											True
										],
										(* but we want to prefer using impeller, so here we check we have no impeller *)
										!MemberQ[allPotentialImpelllers, Except[ListableP[Null]]]
									],
										compatibleStirBar[exampleAliquotContainer, Cache->cacheBall, Simulation->simulation],
									True,
										Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions, StirBar]
							];
							(* If we ended up with a Null in stir bar, we need to double check if we are going to be able to use an impeller or not. If not, we have a problem. *)
							noImpellerOrStirBarError = 	Which[
								(* If we did not get a Null stir bar, we are good. *)
								MatchQ[stirBar, ObjectP[]],
									False,
								(* All other conditions below we have Null stir bar, we need to check if we are okay with it. *)
								(* 1. We are aliquoting, check if there is any impeller able to work with the potential aliquot container *)
								MatchQ[exampleAliquotContainer, ObjectP[Model[Container]]],
									Module[{allowedImpellers},
										allowedImpellers = DeleteCases[
											Flatten[allPotentialImpelllers],
											Null];
										If[Length[allowedImpellers] > 0,
											False,
											True
										]
									],
								(* 2. No aliquot, as long as we can find an impeller, we are good *)
								MatchQ[instrument,ObjectP[{Object[Instrument],Model[Instrument]}]] && !MatchQ[aliquotQ, True],
									Module[{allowedImpellers},
										allowedImpellers = compatibleImpeller[mySample, instrument, Cache->cacheBall, Simulation->simulation];
										If[Length[allowedImpellers] > 0,
											False,
											True
										]
									],
								(* 3. No aliquot, instrument is still Automatic, *)
								True,
									False
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
								mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								 &),
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, instrument},
									{Time, time},
									{MaxTime, maxTime},
									{MixRate, rate},
									{NumberOfMixes, Null},
									{MaxNumberOfMixes, Null},
									{MixVolume, Null},
									{Temperature, resolvedTemperature},
									{AnnealingTime,resolvedAnnealingTime},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, stirBar},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,Null},
									{ResidualMixRate,Null},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					(*-- HOMOGENIZE --*)
					Homogenize,
						Module[{instrumentModel,stirPacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,resolvedTemperature,resolvedAnnealingTime},
								(* Did the user supply a instrument object? *)
								If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,Homogenizer],Model[Instrument,Homogenizer]}]],
									(* The user supplied a instrument object. *)
									instrument=Lookup[myMapThreadOptions,Instrument];

									(* Get the model of the instrument. *)
									instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,Homogenizer]]],
										(* We already have the model. *)
										instrument,
										(* Go from the object to the model. *)
										fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
									];

									(* Does instrument support the footprint of mySample? *)
									(* Get the instruments that this sample can go on. *)
									potentialInstruments=MixDevices[
										mySample,
										Types->Homogenize,
										InstrumentSearch->instrumentSearch,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									];

									(* Is the user-specified instrument part of this list? *)
									compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

									(* Figure out if we need to aliquot our sample into another container. *)
									potentialAliquotContainers=If[compatibleFootprintQ,
										(* This instrument is compatible with the sample based on position. *)

										(* If the user set the amplitude to be over 70 percent, we will have to aliquot out if using the smaller sonication horns. *)
										If[MatchQ[Lookup[myMapThreadOptions,Amplitude],GreaterP[70 Percent]],
											(* Get the sonication horn for this sample. *)
											sonicationHorn=compatibleSonicationHorn[mySample,instrument,Cache->cacheBall,Simulation->updatedSimulation];

											(* If we're using the smaller horns and the amplitude is over 70 Percent, we need to transfer into a 50mL tube (only small sample volumes are used with these horns so we can always transfer into a 50mL). *)
											If[MatchQ[sonicationHorn,Except[ObjectP[Model[Part, SonicationHorn, "id:WNa4ZjKzw8p4"]]]],
												{instrumentModel->{Model[Container, Vessel, "id:bq9LA0dBGGR6"]}},
												Null
											]
										],
										(* This instrument is not compatible with the sample in its current container. *)
										aliquotContainers=Lookup[MixDevices[
											mySample,
											{
												Types->Homogenize,
												(*Did the user specify a temperature? *)
												If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
													Temperature->Lookup[myMapThreadOptions,Temperature],
													Nothing
												],
												InstrumentSearch->instrumentSearch,
												Output->Containers,
												Cache->cacheBall,
												Simulation->updatedSimulation
											}
										],instrumentModel[Object],{}];

										(* Are there containers we can move this sample into? *)
										If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
											(* There are containers, just use these. *)
											homogenizeManualInstrumentContainerWarning=True;
											{instrumentModel->aliquotContainers},
											(* There are no containers. *)
											homogenizeIncompatibleInstrumentError=True;

											(* Then return Null. *)
											Null
										]
									],
									(* ELSE: The user did not supply a instrument. *)
									(* We need to resolve the instruments. *)
									potentialInstruments=MixDevices[
										mySample,
										{
											Types->Homogenize,
											(* Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											(* Did the user specify an amplitude? *)
											If[MatchQ[Lookup[myMapThreadOptions,Amplitude],UnitsP[Percent]],
												Amplitude->Lookup[myMapThreadOptions,Amplitude],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Cache->cacheBall,
											Simulation->updatedSimulation
										}
									];

									(* Are there instruments that can currently support the footprint of our sample? *)
									instrument=If[Length[potentialInstruments]>0,
										(* Choose the first compatible instrument. *)
										First[potentialInstruments],
										(* ELSE: There are no compatible instruments that support our sample's footprint. *)
										(* Look to aliquot. *)
										potentialAliquotInstruments=MixDevices[
											mySample,
											{
												Types->Homogenize,
												(*Did the user specify a temperature? *)
												If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
													Temperature->Lookup[myMapThreadOptions,Temperature],
													Nothing
												],
												(* Did the user specify an amplitude? *)
												If[MatchQ[Lookup[myMapThreadOptions,Amplitude],UnitsP[Percent]],
													Amplitude->Lookup[myMapThreadOptions,Amplitude],
													Nothing
												],
												InstrumentSearch->instrumentSearch,
												Output->Containers,
												Cache->cacheBall,
												Simulation->updatedSimulation
											}
										];

										(* Did we get aliquot instruments? *)
										potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
											(* We did get aliquot results. *)
											homogenizeAutomaticInstrumentContainerWarning=True;
											potentialAliquotInstruments,

											(* We didn't get aliquot results. *)
											homogenizeNoInstrumentError=True;
											Null
										];

										(* Set our instrument option appropriately. *)
										If[Length[potentialAliquotInstruments]>0,
											(* We will resolve the instrument option in our aliquot section. *)
											Automatic,
											(* There is no container to move our sample into. No instrument available. *)
											Null
										]
									];
								];

								(* Resolve Time and MaxTime *)
								time = Which[
									MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
									(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
										Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
									(* TemperatureProfile is not given: Do we have to resolve Time? *)
									MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
									(* It's already user specified, use that value. *)
										Lookup[myMapThreadOptions,Time],
									(* Time is not specified. Resolve according to preparation method *)
									(* Not thawing and MaxTime is given *)
									!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
										N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
									(* Not thawing and MaxTime is not given*)
									!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
										15 Minute,
									(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
									TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
										Lookup[samplePacket,ThawMixTime],
									TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
										5 Minute,
									True,
										0 Minute
								];

								(* Do we have to resolve MaxTime? *)
								maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
									(* What is the value of MixUntilDissolved? *)
									If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
										5 Hour,
										Null
									],
									(* It's already user specified, use that value. *)
									Lookup[myMapThreadOptions,MaxTime]
								];

								(* Resolve mixUntilDissolved. *)
								mixUntilDissolved=Which[
									MatchQ[maxTime,TimeP],
									True,
									MatchQ[resolvedPreparation, Robotic],
									Null,
									True,
									False
								];

								(* Resolve Temperature. *)
								(* Are any of the incubation related options set? *)
								{resolvedTemperature,resolvedAnnealingTime}=If[Or[
										!MatchQ[Lookup[myMapThreadOptions,Temperature],Automatic|Ambient|Null],
										!MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Automatic|Null]
									],
									(* We need to set temperature. *)
									{
										If[MatchQ[Lookup[myMapThreadOptions,Temperature],Automatic],
											40 Celsius,
											(* Temperature isn't automatic. Go with the user supplied value (Null) *)
											Lookup[myMapThreadOptions,Temperature]
										],
										0 Minute
									},
									(* We do not need to set temperature. *)
									{
										Ambient,
										Null
									}
								];

								(* Set the rest of the options to proper values, unless already set by the user. *)
								{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
								volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
								mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
									mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
									(
										If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
											Lookup[myMapThreadOptions,#[[1]]],
											#[[2]]
										]
									 &),
									{
										{MixUntilDissolved, mixUntilDissolved},
										{Instrument, instrument},
										{Time, time},
										{MaxTime, maxTime},
										{MixRate, Null},
										{NumberOfMixes, Null},
										{MaxNumberOfMixes, Null},
										{MixVolume, Null},
										{Temperature, resolvedTemperature},
										{AnnealingTime,resolvedAnnealingTime},
										{Amplitude, 25 Percent},
										{MaxTemperature, Null},
										{DutyCycle, Null},
										{StirBar, Null},
										{MixRateProfile, Null},
										{TemperatureProfile, Null},
										{OscillationAngle, Null},
										{PotentialAliquotContainers, potentialAliquotContainers},
										{Preheat,Null},
										{ResidualTemperature,Null},
										{ResidualMix,Null},
										{ResidualMixRate,Null},
										{MixPosition,Null},
										{MixPositionOffset,Null},
										{MixFlowRate,Null},
										{CorrectionCurve,Null},
										{Tips,Null},
										{TipType, Null},
										{TipMaterial,Null},
										{RelativeHumidity,Null},
										{LightExposure,Null},
										{LightExposureIntensity,Null},
										{TotalLightExposure,Null},
										{PreSonicationTime,Null},
										{AlternateInstruments,Null}
									}
								]
							],
					(*-- SONICATE --*)
					Sonicate,
						Module[{instrumentModel,sonicatePacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments},
							(* Resolve Temperature up front. *)
							(* This is because we need to know the Temperature requirement before we pick an instrument (not all Shakers can heat). *)
							temperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
								(* User supplied temperature. *)
								Lookup[myMapThreadOptions,Temperature],
								(* Did the user specify any incubation related options? *)
								If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
									40 Celsius,
									Ambient
								]
							];

							(* Did the user supply a instrument object? *)
							If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,Sonicator],Model[Instrument,Sonicator]}]],
								(* The user supplied a instrument object. *)
								instrument=Lookup[myMapThreadOptions,Instrument];

								(* if use specified instrument, alternate instrument is {} *)
								alternateInstruments=Null;

								(* Get the model of the instrument. *)
								instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,Sonicator]]],
									(* We already have the model. *)
									instrument,
									(* Go from the object to the model. *)
									fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
								];

								(* Does instrument support the footprint of mySample? *)
								(* Get the instruments that this sample can go on. *)
								potentialInstruments=MixDevices[
									mySample,
									Types->Sonicate,
									InstrumentSearch->instrumentSearch,
									Cache->cacheBall,
									Simulation->updatedSimulation
								];

								(* Is the user-specified instrument part of this list? *)
								compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

								(* Figure out if we need to aliquot our sample into another container. *)
								potentialAliquotContainers=If[compatibleFootprintQ,
									(* This sonicator is compatible with the sample. *)
									Null,
									(* This sonicator is not compatible with the sample in its current container. *)
									aliquotContainers=Lookup[MixDevices[
										mySample,
										{
											Types->Sonicate,
											(*Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache->cacheBall,
											Simulation->updatedSimulation
										}
									],instrumentModel[Object],{}];

									(* Are there containers we can move this sample into? *)
									If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
										(* There are containers, just use these. *)
										sonicateManualInstrumentContainerWarning=True;
										{instrumentModel->aliquotContainers},
										(* There are no containers. *)
										sonicateIncompatibleInstrumentError=True;

										(* Then return Null. *)
										Null
									]
								],
								(* ELSE: The user did not supply a instrument. *)
								(* We need to resolve the instruments. *)
								potentialInstruments=MixDevices[
									mySample,
									{
										Types->Sonicate,
										(*Did the user specify a temperature? *)
										If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
											Temperature->Lookup[myMapThreadOptions,Temperature],
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Cache->cacheBall,
										Simulation->updatedSimulation
									}
								];

								(* Are there instruments that can currently support the footprint of our sample? *)
								instrument=If[Length[potentialInstruments]>0,
									(* Choose the first compatible instrument. *)
									First[potentialInstruments],
									(* ELSE: There are no compatible instruments that support our sample's footprint. *)
									(* Look to aliquot. *)
									potentialAliquotInstruments=MixDevices[
										mySample,
										{
											Types->Sonicate,
											(*Did the user specify a temperature? *)
											If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
												Temperature->Lookup[myMapThreadOptions,Temperature],
												Nothing
											],
											InstrumentSearch->instrumentSearch,
											Output->Containers,
											Cache->cacheBall,
											Simulation->updatedSimulation
										}
									];

									(* Did we get aliquot instruments? *)
									potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
										(* We did get aliquot results. *)
										sonicateAutomaticInstrumentContainerWarning=True;
										potentialAliquotInstruments,
										(* We didn't get aliquot results. *)
										sonicateNoInstrumentError=True;
										Null
									];

									(* Set our instrument option appropriately. *)
									If[Length[potentialAliquotInstruments]>0,
										(* We will resolve the instrument option in our aliquot section. *)
										Automatic,
										(* There is no container to move our sample into. No instrument available. *)
										Null
									]
								];
								(* resolve alternate instruments based on potential instruments *)
								alternateInstruments = If[Length[potentialInstruments]>1,
									Rest[potentialInstruments],
									Null
								];
							];

							(* Resolve Time and MaxTime *)
							time = Which[
								MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
								(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
									Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
								(* TemperatureProfile is not given: Do we have to resolve Time? *)
								MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
								(* It's already user specified, use that value. *)
									Lookup[myMapThreadOptions,Time],
								(* Time is not specified. Resolve according to preparation method *)
								(* Not thawing and MaxTime is given *)
								!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
								(* Not thawing and MaxTime is not given*)
								!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
									15 Minute,
								(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
									Lookup[samplePacket,ThawMixTime],
								TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
									5 Minute,
								True,
									0 Minute
							];

							(* Resolve PreSonicationTime *)
							preSonicationTime = Which[
								(* It's already user specified, use that value. *)
								MatchQ[Lookup[myMapThreadOptions,PreSonicationTime],Except[Automatic]],
								Lookup[myMapThreadOptions,PreSonicationTime],

								(* PreSonicationTime is not specified. Resolve to 15 minute if mix time is over 1 hour*)
								MatchQ[time,GreaterEqualP[1 Hour]],
								15 Minute,

								(* mix time is less than 1 hour, resolves to 0 minute*)
								True,
								0 Minute
							];

							(* Do we have to resolve MaxTime? *)
							maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
								(* What is the value of MixUntilDissolved? *)
								If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
									5 Hour,
									Null
								],
								(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,MaxTime]
							];


							(* Resolve mixUntilDissolved. *)
							mixUntilDissolved=Which[
								MatchQ[maxTime,TimeP],
								True,
								MatchQ[resolvedPreparation, Robotic],
								Null,
								True,
								False
							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
								mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
								mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure, preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
								 &),
								{
									{MixUntilDissolved, mixUntilDissolved},
									{Instrument, instrument},
									{Time, time},
									{MaxTime, maxTime},
									{MixRate, Null},
									{NumberOfMixes, Null},
									{MaxNumberOfMixes, Null},
									{MixVolume, Null},
									{Temperature, temperature},
									{AnnealingTime, Null},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,Null},
									{ResidualMixRate,Null},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,Null},
									{LightExposure,Null},
									{LightExposureIntensity,Null},
									{TotalLightExposure,Null},
									{PreSonicationTime, preSonicationTime},
									{AlternateInstruments, alternateInstruments}
								}
							];
						],
					(*-- DISRUPT --*)
					Disrupt,
						Module[{instrumentModel,disruptorPacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,preResolvedRate},
						(* Did the user supply a instrument object? *)
						If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,Disruptor],Model[Instrument,Disruptor]}]],
							(* The user supplied a instrument object. *)
							instrument=Lookup[myMapThreadOptions,Instrument];

							(* Get the model of the instrument. *)
							instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,Disruptor]]],
								(* We already have the model. *)
								instrument,
								(* Go from the object to the model. *)
								fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
							];

							(* Did the user supply a rate? *)
							rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
								If[
									And[
										TrueQ[thaw],
										!NullQ[Lookup[samplePacket,ThawMixRate]]
									],
									Lookup[samplePacket,ThawMixRate],
									(* Resolve to the average RPM of the set instrument. *)
									disruptorPacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];

									(* Round to the nearest RPM. *)
									Round[Mean[Lookup[disruptorPacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
								],
								(* MixRate isn't automatic. Go with the user supplied value. *)
								Lookup[myMapThreadOptions,MixRate]
							];

							(* What are the instruments that this sample can go on? *)
							potentialInstruments=MixDevices[
								mySample,
								Types->Disrupt,
								InstrumentSearch->instrumentSearch,
								Cache -> cacheBall,
								Simulation->updatedSimulation
							];

							(* Is the user-specified instrument part of this list? *)
							compatibleFootprintQ = MemberQ[potentialInstruments, fastAssocLookup[fastAssoc, instrumentModel, Object]];

							(* Figure out if we need to aliquot our sample into another container. *)
							potentialAliquotContainers=If[compatibleFootprintQ,
								(* This disruptor is compatible with the sample. *)
								Null,
								(* This disruptor is not compatible with the sample in its current container. *)
								aliquotContainers=Lookup[MixDevices[
									mySample,
									{
										Types->Disrupt,
										If[MatchQ[rate,UnitsP[RPM]],
											Rate->rate,
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Output->Containers,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									}
								],instrumentModel[Object],{}];

								(* Are there containers we can move this sample into? *)
								If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
									(* There are containers, just use these. *)
									disruptManualInstrumentContainerWarning=True;
									{instrumentModel->aliquotContainers},
									(* There are no containers. *)
									disruptIncompatibleInstrumentError=True;

									(* Then return Null. *)
									Null
								]
							],
							(* ELSE: The user did not supply a instrument. *)
							(* We need to resolve the instruments. *)
							(* Did the user supply a rate? *)
							preResolvedRate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
								If[
									And[
										TrueQ[thaw],
										!NullQ[Lookup[samplePacket,ThawMixRate]]
									],
									Lookup[samplePacket,ThawMixRate],
									(* Keep Automatic if we don't have a ThawMixRate *)
									Automatic
								],
								(* MixRate isn't automatic. Go with the user supplied value (Null) *)
								Lookup[myMapThreadOptions,MixRate]
							];
							potentialInstruments=MixDevices[
								mySample,
								{
									Types->Disrupt,
									If[MatchQ[preResolvedRate,UnitsP[RPM]],
										Rate->preResolvedRate,
										Nothing
									],
									InstrumentSearch->instrumentSearch,
									Cache -> cacheBall,
									Simulation->updatedSimulation
								}
							];

							(* Are there instruments that can currently support the footprint of our sample? *)
							instrument=If[Length[potentialInstruments]>0,
								(* Resolve rate (if we have to) to be the average rate of our first instrument. *)
								rate=If[MatchQ[preResolvedRate,Automatic],
									(* Resolve to the average RPM of the set instrument. *)
									disruptorPacket = fetchPacketFromFastAssoc[First[potentialInstruments], fastAssoc];

									(* Round to the nearest RPM. *)
									Round[Mean[Lookup[disruptorPacket,{MinRotationRate,MaxRotationRate},{1RPM,1RPM}]],1RPM],
									(* MixRate isn't automatic. Go with the user supplied value (Null) *)
									Lookup[myMapThreadOptions,MixRate]
								];

								(* Choose the first compatible instrument. *)
								First[potentialInstruments],
								(* There are no compatible instruments that support our sample's footprint. *)
								(* Look to aliquot. *)

								(* Did the user supply a rate? *)
								potentialAliquotInstruments=MixDevices[
									mySample,
									{
										Types->Disrupt,
										If[MatchQ[preResolvedRate,UnitsP[RPM]],
											Rate->preResolvedRate,
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Output->Containers,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									}
								];

								(* Did we get aliquot instruments? *)
								potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
									(* We did get aliquot results. *)
									disruptAutomaticInstrumentContainerWarning=True;
									potentialAliquotInstruments,
									(* We didn't get aliquot results. *)
									(* Did the user set rate? *)
									If[MatchQ[Lookup[myMapThreadOptions,MixRate],UnitsP[RPM]],
										disruptNoInstrumentForRateError=True,
										disruptNoInstrumentError=True
									];
									Null
								];

								(* Set our instrument option appropriately. *)
								If[Length[potentialAliquotInstruments]>0,
									(* We will resolve the instrument option in our aliquot section. *)
									Automatic,
									(* There is no container to move our sample into. No instrument available. *)
									Null
								]
							];

							(* Resolve rate based on instrument if 1) we need to (MixRate\[Rule]Automatic) and 2) if we can (Instrument\[NotEqual]Null). *)
							rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic]&&!MatchQ[instrument,Null|Automatic],
								If[
									And[
										TrueQ[thaw],
										!NullQ[Lookup[samplePacket,ThawMixRate]]
									],
									Lookup[samplePacket,ThawMixRate],
									(* Get the model of the instrument. *)
									instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,Disruptor]]],
										(* We already have the model. *)
										instrument,
										(* Go from the object to the model. *)
										fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
									];

									(* Get the packet. *)
									disruptorPacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];

									(* Round to the nearest RPM. *)
									Round[Mean[Lookup[disruptorPacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
								],
								Lookup[myMapThreadOptions,MixRate]
							];
						];

						(* Resolve Time and MaxTime *)
						time = Which[
							MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
							(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
								Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
							(* TemperatureProfile is not given: Do we have to resolve Time? *)
							MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
							(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,Time],
							(* Time is not specified. Resolve according to preparation method *)
							(* Not thawing and MaxTime is given *)
							!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
								N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
							(* Not thawing and MaxTime is not given*)
							!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
								15 Minute,
							(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
							TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
								Lookup[samplePacket,ThawMixTime],
							TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
								5 Minute,
							True,
								0 Minute
						];

						(* Do we have to resolve MaxTime? *)
						maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
							(* What is the value of MixUntilDissolved? *)
							If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
								5 Hour,
								Null
							],
							(* It's already user specified, use that value. *)
							Lookup[myMapThreadOptions,MaxTime]
						];

						(* Resolve mixUntilDissolved. *)
						mixUntilDissolved=Which[
							MatchQ[maxTime,TimeP],
							True,
							MatchQ[resolvedPreparation, Robotic],
							Null,
							True,
							False
						];

						(* Set the rest of the options to proper values, unless already set by the user. *)
						{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
							mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
							(
								If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
									Lookup[myMapThreadOptions,#[[1]]],
									#[[2]]
								]
							&),
							{
								{MixUntilDissolved, mixUntilDissolved},
								{Instrument, instrument},
								{Time, time},
								{MaxTime, maxTime},
								{MixRate, rate},
								{NumberOfMixes, Null},
								{MaxNumberOfMixes, Null},
								{MixVolume, Null},
								{Temperature, Ambient},
								{AnnealingTime,Null},
								{Amplitude, Null},
								{MaxTemperature, Null},
								{DutyCycle, Null},
								{StirBar, Null},
								{MixRateProfile, Null},
								{TemperatureProfile, Null},
								{OscillationAngle, Null},
								{PotentialAliquotContainers, potentialAliquotContainers},
								{Preheat,Null},
								{ResidualTemperature,Null},
								{ResidualMix,Null},
								{ResidualMixRate,Null},
								{MixPosition,Null},
								{MixPositionOffset,Null},
								{MixFlowRate,Null},
								{CorrectionCurve,Null},
								{Tips,Null},
								{TipType, Null},
								{TipMaterial,Null},
								{RelativeHumidity,Null},
								{LightExposure,Null},
								{LightExposureIntensity,Null},
								{TotalLightExposure,Null},
								{PreSonicationTime,Null},
								{AlternateInstruments,Null}
							}
						]
					],
					(*-- NUTATE --*)
					Nutate,
						Module[{instrumentModel,nutatorPacket,compatibleFootprintQ,aliquotContainers,potentialInstruments,potentialAliquotInstruments,resolvedTemperature,resolvedAnnealingTime,preResolvedRate},
						(* Resolve Temperature up front. *)
						(* This is because we need to know the Temperature requirement before we pick an instrument (not all Shakers can heat). *)
						temperature=If[MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]],
							(* User supplied temperature. *)
							Lookup[myMapThreadOptions,Temperature],
							(* Did the user specify any incubation related options? *)
							If[MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Except[Null|Automatic]],
								40 Celsius,
								Ambient
							]
						];

						(* Did the user supply a instrument object? *)
						If[MatchQ[Lookup[myMapThreadOptions,Instrument],ObjectP[{Object[Instrument,Nutator],Model[Instrument,Nutator]}]],
							(* The user supplied a instrument object. *)
							instrument=Lookup[myMapThreadOptions,Instrument];

							(* Get the model of the instrument. *)
							instrumentModel=If[MatchQ[instrument,ObjectP[Model[Instrument,Nutator]]],
								(* We already have the model. *)
								instrument,
								(* Go from the object to the model. *)
								fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null}
							];

							(* Did the user supply a rate? *)
							rate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
								If[
									And[
										TrueQ[thaw],
										!NullQ[Lookup[samplePacket,ThawMixRate]]
									],
									Lookup[samplePacket,ThawMixRate],
									(* Resolve to the average RPM of the set instrument. *)
									nutatorPacket = fetchPacketFromFastAssoc[instrumentModel, fastAssoc];

									(* Round to the nearest RPM. *)
									Round[Mean[Lookup[nutatorPacket,{MinRotationRate,MaxRotationRate},1RPM]],1RPM]
								],
								(* MixRate isn't automatic. Go with the user supplied value. *)
								Lookup[myMapThreadOptions,MixRate]
							];

							(* What are the instruments that this sample can go on? *)
							potentialInstruments=MixDevices[
								mySample,
								Types->Nutate,
								InstrumentSearch->instrumentSearch,
								Cache -> cacheBall,
								Simulation->updatedSimulation
							];

							(* Is the user-specified instrument part of this list? *)
							compatibleFootprintQ = MemberQ[potentialInstruments, Lookup[nutatorPacket, Object, Null]];

							(* Figure out if we need to aliquot our sample into another container. *)
							potentialAliquotContainers=If[compatibleFootprintQ,
								(* This nutator is compatible with the sample. *)
								Null,
								(* This nutator is not compatible with the sample in its current container. *)
								aliquotContainers=Lookup[MixDevices[
									mySample,
									{
										Types->Nutate,
										(* Did the user specify a rate? *)
										If[MatchQ[rate,UnitsP[RPM]],
											Rate->rate,
											Nothing
										],
										(*Did the user specify a temperature? *)
										If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
											Temperature->Lookup[myMapThreadOptions,Temperature],
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Output->Containers,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									}
								],instrumentModel[Object],{}];

								(* Are there containers we can move this sample into? *)
								If[Length[aliquotContainers]>0 && !MatchQ[aliquotQ, False],
									(* There are containers, just use these. *)
									nutateManualInstrumentContainerWarning=True;
									{instrumentModel->aliquotContainers},
									(* There are no containers. *)
									nutateIncompatibleInstrumentError=True;

									(* Then return Null. *)
									Null
								]
							],
							(* ELSE: The user did not supply a instrument. *)
							(* We need to resolve the instruments. *)
							preResolvedRate=If[MatchQ[Lookup[myMapThreadOptions,MixRate],Automatic],
								If[
									And[
										TrueQ[thaw],
										!NullQ[Lookup[samplePacket,ThawMixRate]]
									],
									Lookup[samplePacket,ThawMixRate],
									(* Keep Automatic if we don't have a ThawMixRate *)
									Automatic
								],
								(* MixRate isn't automatic. Go with the user supplied value (Null) *)
								Lookup[myMapThreadOptions,MixRate]
							];
							potentialInstruments=MixDevices[
								mySample,
								{
									Types->Nutate,
									(* Did the user specify a rate? *)
									If[MatchQ[preResolvedRate,UnitsP[RPM]],
										Rate->preResolvedRate,
										Nothing
									],
									(*Did the user specify a temperature? *)
									If[MatchQ[temperature,UnitsP[Celsius]],
										Temperature->temperature,
										Nothing
									],
									InstrumentSearch->instrumentSearch,
									Cache -> cacheBall,
									Simulation->updatedSimulation
								}
							];

							(* Are there instruments that can currently support the footprint of our sample? *)
							instrument=If[Length[potentialInstruments]>0,
								(* Resolve rate (if we have to) to be the average rate of our first instrument. *)
								rate=If[MatchQ[preResolvedRate,Automatic],
									(* Resolve to the average RPM of the set instrument. *)
									nutatorPacket = fetchPacketFromFastAssoc[First[potentialInstruments], fastAssoc];

									(* Round to the nearest RPM. *)
									Round[Mean[Lookup[nutatorPacket,{MinRotationRate,MaxRotationRate},{1RPM,1RPM}]],1RPM],
									(* MixRate isn't automatic. Go with the user supplied value (Null) *)
									preResolvedRate
								];

								(* Choose the first compatible instrument. *)
								First[potentialInstruments],
								(* There are no compatible instruments that support our sample's footprint. *)
								(* Look to aliquot. *)
								potentialAliquotInstruments=MixDevices[
									mySample,
									{
										Types->Nutate,
										(* Did the user specify a rate? *)
										If[MatchQ[preResolvedRate,UnitsP[RPM]],
											Rate->preResolvedRate,
											Nothing
										],
										(*Did the user specify a temperature? *)
										If[MatchQ[Lookup[myMapThreadOptions,Temperature],UnitsP[Celsius]],
											Temperature->Lookup[myMapThreadOptions,Temperature],
											Nothing
										],
										InstrumentSearch->instrumentSearch,
										Output->Containers,
										Cache -> cacheBall,
										Simulation->updatedSimulation
									}
								];

								(* Did we get aliquot instruments? *)
								potentialAliquotContainers=If[Length[potentialAliquotInstruments]>0,
									(* We did get aliquot results. *)
									nutateAutomaticInstrumentContainerWarning=True;
									potentialAliquotInstruments,
									(* We didn't get aliquot results. *)
									nutateNoInstrumentError=True;
									Null
								];

								(* Our instrument option is going to be Automatic or Null so we will keep our rate as the desired value or Automatic *)
								rate=preResolvedRate;

								(* Set our instrument option appropriately. *)
								If[Length[potentialAliquotInstruments]>0,
									(* We will resolve the instrument option in our aliquot section. *)
									Automatic,
									(* There is no container to move our sample into. No instrument available. *)
									Null
								]
							];
						];

						(* Resolve Time and MaxTime  *)
						time = Which[
							MatchQ[Lookup[myMapThreadOptions,TemperatureProfile], Except[Automatic|Null]],
							(* TemperatureProfile is given, use the time based on the TemperatureProfile and add extra 5 minutes *)
								Lookup[myMapThreadOptions, TemperatureProfile][[-1,1]] + 5 Minute,
							(* TemperatureProfile is not given: Do we have to resolve Time? *)
							MatchQ[Lookup[myMapThreadOptions,Time],Except[Automatic]],
							(* It's already user specified, use that value. *)
								Lookup[myMapThreadOptions,Time],
							(* Time is not specified. Resolve according to preparation method *)
							(* Not thawing and MaxTime is given *)
							!TrueQ[thaw] && MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
								N[(1/3)*Lookup[myMapThreadOptions,MaxTime]],
							(* Not thawing and MaxTime is not given*)
							!TrueQ[thaw] && !MatchQ[Lookup[myMapThreadOptions,MaxTime],Except[Automatic|Null]],
								15 Minute,
							(* If we're thawing, either use ThawMixTime or default to 0 or 5 depending on if we need to thaw mix *)
							TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixTime]],
								Lookup[samplePacket,ThawMixTime],
							TrueQ[thaw] && !NullQ[Lookup[samplePacket,ThawMixRate]],
								5 Minute,
							True,
								0 Minute
						];

						(* Do we have to resolve MaxTime? *)
						maxTime=If[MatchQ[Lookup[myMapThreadOptions,MaxTime],Automatic],
							(* What is the value of MixUntilDissolved? *)
							If[TrueQ[Lookup[myMapThreadOptions,MixUntilDissolved]],
								5 Hour,
								Null
							],
							(* It's already user specified, use that value. *)
							Lookup[myMapThreadOptions,MaxTime]
						];

						(* Resolve mixUntilDissolved. *)
						mixUntilDissolved=Which[
							MatchQ[maxTime,TimeP],
							True,
							MatchQ[resolvedPreparation, Robotic],
							Null,
							True,
							False
						];

						(* Resolve Temperature. *)
						(* Are any of the incubation related options set? *)
						{resolvedTemperature,resolvedAnnealingTime}=If[Or[
							!MatchQ[temperature,Automatic|Ambient|Null],
							!MatchQ[Lookup[myMapThreadOptions,AnnealingTime],Automatic|Null]
						],
							(* We need to set temperature. *)
							{
								temperature,
								0 Minute
							},
							(* We do not need to set temperature. *)
							{
								Ambient,
								Null
							}
						];

						(* Set the rest of the options to proper values, unless already set by the user. *)
						{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
							volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
							mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature, residualMix,residualMixRate,
							mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
							(
								If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
									Lookup[myMapThreadOptions,#[[1]]],
									#[[2]]
								]
							&),
							{
								{MixUntilDissolved, mixUntilDissolved},
								{Instrument, instrument},
								{Time, time},
								{MaxTime, maxTime},
								{MixRate, rate},
								{NumberOfMixes, Null},
								{MaxNumberOfMixes, Null},
								{MixVolume, Null},
								{Temperature, resolvedTemperature},
								{AnnealingTime,resolvedAnnealingTime},
								{Amplitude, Null},
								{MaxTemperature, Null},
								{DutyCycle, Null},
								{StirBar, Null},
								{MixRateProfile, Null},
								{TemperatureProfile, Null},
								{OscillationAngle, Null},
								{PotentialAliquotContainers, potentialAliquotContainers},
								{Preheat,Null},
								{ResidualTemperature,Null},
								{ResidualMix,Null},
								{ResidualMixRate,Null},
								{MixPosition,Null},
								{MixPositionOffset,Null},
								{MixFlowRate,Null},
								{CorrectionCurve,Null},
								{Tips,Null},
								{TipType, Null},
								{TipMaterial,Null},
								{RelativeHumidity,Null},
								{LightExposure,Null},
								{LightExposureIntensity,Null},
								{TotalLightExposure,Null},
								{PreSonicationTime,Null},
								{AlternateInstruments,Null}
							}
						]
					],
					(* -- INCUBATE -- *)
					Null,
						Module[{resolvedTemperature, resolvedIncubateInstrument, resolvedRelativeHumidity, resolvedTotalLightExposure, resolvedTime, resolvedLightExposure, resolvedLightExposureIntensity},
							(* Resolve our incubation temperature to 40 C (manual) or 25 C (robotic) or Null (transform) if it's not set*)
							resolvedTemperature=Which[
								MatchQ[temperature,Except[Automatic]],
									temperature,
								transformQ,
									Null,
								MatchQ[temperatureProfile,_List]&&MatchQ[resolvedPreparation,Manual],
									Null,
								TrueQ[thaw]&&MatchQ[resolvedPreparation,Manual],
									Null,
								(* NOTE: If any of the light exposure options are set, default to 25C instead since the photostability chamber can't *)
								(* heat up to 40 Celsius. *)
								MatchQ[lightExposure, Except[Automatic|Null]]||MatchQ[lightExposureIntensity, Except[Automatic|Null]]||MatchQ[Lookup[myMapThreadOptions,LightExposureStandard], _List?(Length[#]>0&)],
									25 Celsius,
								MatchQ[resolvedPreparation,Manual],
									40 Celsius,
								MatchQ[resolvedPreparation,Robotic],
									25 Celsius
							];

							(* resolve the residual incubation if preparation is robotic *)
							{residualMixRate,residualTemperature}=If[MatchQ[resolvedPreparation,Robotic],
								Module[{
									myResidualMixRate,myResidualTemperature
								},
									myResidualMixRate=Which[
										MatchQ[Lookup[myMapThreadOptions, ResidualMixRate], Except[Automatic]],
										Lookup[myMapThreadOptions, ResidualMixRate],
										MatchQ[Lookup[myMapThreadOptions, ResidualMix], True],
										Lookup[myMapThreadOptions, MixRate],
										True,
										Null
									];

									myResidualTemperature=Which[
										MatchQ[Lookup[myMapThreadOptions, ResidualTemperature], Except[Automatic]],
										Lookup[myMapThreadOptions, ResidualTemperature],
										MatchQ[residualIncubation, True],
										Lookup[myMapThreadOptions, Temperature],
										True,
										Null
									];

									{myResidualMixRate,myResidualTemperature}
								],
								{Null,Null}
							];

							(* resolve mix rate*)
							rate=If[!MatchQ[Lookup[myMapThreadOptions,MixRate,Automatic],Automatic],
								Lookup[myMapThreadOptions,MixRate],
								Null
							];

							(* Resolve light exposure. *)
							resolvedLightExposure=Which[
								!MatchQ[Lookup[myMapThreadOptions,LightExposure], Automatic],
									Lookup[myMapThreadOptions,LightExposure],
								MatchQ[Lookup[myMapThreadOptions,LightExposureIntensity], GreaterP[0 (Watt/(Meter^2))]],
									UVLight,
								MatchQ[Lookup[myMapThreadOptions,LightExposureIntensity], GreaterP[0 (Lumen/(Meter^2))]],
									VisibleLight,
								MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], GreaterP[0 (Watt*Hour/(Meter^2))]],
									UVLight,
								MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], GreaterP[0 (Lumen*Hour/(Meter^2))]],
									VisibleLight,
								MatchQ[Lookup[myMapThreadOptions,LightExposureStandard], _List?(Length[#]>0&)],
									UVLight,
								True,
									Null
							];

							(* Resolve light exposure intensity. *)
							resolvedLightExposureIntensity=Which[
								!MatchQ[Lookup[myMapThreadOptions,LightExposureIntensity], Automatic],
									Lookup[myMapThreadOptions,LightExposureIntensity],
								And[
									MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], GreaterP[0 (Watt*Hour/(Meter^2))]],
									MatchQ[Lookup[myMapThreadOptions,Time], TimeP]
								],
									Lookup[myMapThreadOptions,TotalLightExposure]/Lookup[myMapThreadOptions,Time],
								MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], GreaterP[0 (Watt*Hour/(Meter^2))]],
									36 (Watt/(Meter^2)),
								And[
									MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], GreaterP[0 (Lumen*Hour/(Meter^2))]],
									MatchQ[Lookup[myMapThreadOptions,Time], TimeP]
								],
									Lookup[myMapThreadOptions,TotalLightExposure]/Lookup[myMapThreadOptions,Time],
								MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], GreaterP[0 (Lumen*Hour/(Meter^2))]],
									29000 Lumen/(Meter^2),
								MatchQ[resolvedLightExposure, UVLight],
									19 (Watt/(Meter^2)),
								MatchQ[resolvedLightExposure, VisibleLight],
									14500 (Lumen/(Meter^2)),
								True,
									Null
							];

							(* Resolve the time option. (Null if Transform) *)
							resolvedTime=Which[
								MatchQ[Lookup[myMapThreadOptions,Time], Except[Automatic]],
									Lookup[myMapThreadOptions,Time],
								transformQ,
									Null,
								MatchQ[temperatureProfile, _List] && Length[temperatureProfile]>0,
									Max[temperatureProfile[[All,1]]],
								TrueQ[thaw],
									0 Minute,
								And[
									!MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], Automatic],
									MatchQ[resolvedLightExposureIntensity, UnitsP[]]
								],
									Lookup[myMapThreadOptions,TotalLightExposure]/resolvedLightExposureIntensity,
								True,
									1 Hour
							];

							(* Resolve total light exposure. *)
							resolvedTotalLightExposure=Which[
								!MatchQ[Lookup[myMapThreadOptions,TotalLightExposure], Automatic],
									Lookup[myMapThreadOptions,TotalLightExposure],
								MatchQ[resolvedLightExposureIntensity, UnitsP[]],
									resolvedLightExposureIntensity*resolvedTime,
								True,
									Null
							];

							(* Resolve relative humidity. *)
							(* need N here because MM handling of percent is garbage and it wants to make it 7/10 instead of 0.7 *)
							resolvedRelativeHumidity=Which[
								!MatchQ[Lookup[myMapThreadOptions,RelativeHumidity], Automatic],
									N@Lookup[myMapThreadOptions,RelativeHumidity],
								Or[
									MatchQ[instrument, ObjectP[{Model[Instrument, EnvironmentalChamber], Object[Instrument, EnvironmentalChamber]}]],
									MatchQ[resolvedLightExposure, Except[Null]],
									MatchQ[resolvedLightExposureIntensity, Except[Null]]
								],
									N@(70 Percent),
								True,
									Null
							];

							(* Resolve our incubation instrument, if necessary. *)
							resolvedIncubateInstrument=Which[
								MatchQ[instrument,Except[Automatic]],
									instrument,

								(* If we're transforming, we absolutely have to do this in a transform-allowed instrument. *)
								(* For now, just worry about the model; the appropriate container will come in the compiler *)
								transformQ,
									FirstOrDefault[$TransformInstruments],

								(* ELSE: Get the instruments that are compatible with this sample. *)
								MatchQ[resolvedPreparation,Robotic],

									(* Resolve if it is robotic *)
									Module[{potentialInstruments},
										(* Get the hamilton integrated instruments that we can use to perform this incubation. *)
										potentialInstruments=If[MatchQ[rate, Null],
											If[MatchQ[residualTemperature, TemperatureP],
												Complement[
													Intersection[
														IncubateDevices[
															Model[Container, Plate, "96-well 2mL Deep Well Plate"],
															1 Milliliter,
															Temperature->resolvedTemperature,
															IntegratedLiquidHandler->True
														],
														IncubateDevices[
															Model[Container, Plate, "96-well 2mL Deep Well Plate"],
															1 Milliliter,
															Temperature->residualTemperature,
															IntegratedLiquidHandler->True
														]
													],
													(* Do not allow residual incubation on off-deck heater shaker since we must move the plate out  *)
													{Model[Instrument, Shaker, "id:eGakldJkWVnz"]}
												],
												IncubateDevices[
													Model[Container, Plate, "96-well 2mL Deep Well Plate"],
													1 Milliliter,
													Temperature->resolvedTemperature,
													IntegratedLiquidHandler->True
												]
											],
											If[MatchQ[residualTemperature, TemperatureP] || MatchQ[residualMixRate, RPMP],
												Complement[
													Intersection[
														MixDevices[
															Model[Container, Plate, "96-well 2mL Deep Well Plate"],
															1 Milliliter,
															Temperature->resolvedTemperature,
															Rate->rate,
															IntegratedLiquidHandler->True
														],
														MixDevices[
															Model[Container, Plate, "96-well 2mL Deep Well Plate"],
															1 Milliliter,
															Temperature->If[MatchQ[residualTemperature, TemperatureP],
																residualTemperature,
																Null
															],
															Rate->If[MatchQ[residualMixRate, RPMP],
																residualMixRate,
																Null
															],
															IntegratedLiquidHandler->True
														]
													],
													(* Do not allow residual incubation on off-deck heater shaker since we must move the plate out  *)
													{Model[Instrument, Shaker, "id:eGakldJkWVnz"]}
												],
												MixDevices[
													Model[Container, Plate, "96-well 2mL Deep Well Plate"],
													1 Milliliter,
													Temperature->resolvedTemperature,
													Rate->rate,
													IntegratedLiquidHandler->True
												]
											]
										];

										(* Filter based on the work cell that we're on. *)
										If[MatchQ[workCell, STAR],
											(* If we're on the STAR, we do not have the ThermoshakeAC and Off-Deck Incubator Shaker. *)
											FirstOrDefault[
												Cases[
													potentialInstruments,
													Except[Alternatives[Model[Instrument, Shaker, "id:eGakldJkWVnz"], Model[Instrument, Shaker, "id:pZx9jox97qNp"]]]
												]
											],
											(* Otherwise, we are on the microbioSTAR or bioSTAR and do not have the heater shakers (we have the thermoshake instead). *)
											FirstOrDefault[
												Cases[
													potentialInstruments,
													Except[Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"]]
												]
											]
										]
									],
								True,
									(* Resolve if it is manual *)
									compatibleIncubateInstruments=IncubateDevices[
										mySample,
										Temperature->resolvedTemperature/.{Ambient->Null},
										ProgrammableTemperatureControl->If[MatchQ[temperatureProfile, _List],
											True,
											Null
										],
										LightExposure->resolvedLightExposure,
										LightExposureIntensity->resolvedLightExposureIntensity,
										RelativeHumidity->resolvedRelativeHumidity,
										Cache->cacheBall,
										Simulation->updatedSimulation
									];

									(* Did the user supply an instrument? *)
									If[KeyExistsQ[myMapThreadOptions,Instrument]&&!MatchQ[Lookup[myMapThreadOptions,Instrument],Automatic],
										(* Get the given thaw instrument. *)
										givenInstrument=Lookup[myMapThreadOptions,Instrument];

										(* Get the instrument model of the thaw instrument. (We may be given an object.) *)
										instrumentModel=If[MatchQ[givenThawInstrument,ObjectP[Object[Instrument]]],
											fastAssocLookup[fastAssoc, givenThawInstrument, {Model, Object}],
											fastAssocLookup[fastAssoc, givenThawInstrument, Object]
										];

										(* Check to make sure that the sample can fit on the given instrument. *)
										incubateIncompatibleInstrumentError=!MemberQ[compatibleIncubateInstruments,instrumentModel];

										givenInstrument,
										(* User didn't give us an instrument. *)
										(* Do we have any compatible instruments? *)
										If[Length[compatibleIncubateInstruments]>0,
											(* Choose the first instrument. *)
											First[compatibleIncubateInstruments],
											(* No instruments available, set an error boolean. *)
											incubateNoInstrumentError=True;
											Null
										]
									]

							];

							(* Set the rest of the options to proper values, unless already set by the user. *)
							{mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
								volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,stirBar,
								mixRateProfile,temperatureProfile,oscillationAngle,potentialAliquotContainers,preheat,residualTemperature,residualMix,residualMixRate,
								mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,relativeHumidity,lightExposure,lightExposureIntensity,totalLightExposure,preSonicationTime,alternateInstruments}=Map[
								(
									If[!MatchQ[Lookup[myMapThreadOptions,#[[1]],Automatic],Automatic],
										Lookup[myMapThreadOptions,#[[1]]],
										#[[2]]
									]
											&),
								{
									{MixUntilDissolved, Null},
									{Instrument, resolvedIncubateInstrument},
									{
										Time,
										resolvedTime
									},
									{MaxTime, Null},
									{MixRate, Null},
									{NumberOfMixes, Null},
									{MaxNumberOfMixes, Null},
									{MixVolume, Null},
									{
										Temperature,
										Which[
											MatchQ[temperatureProfile, _List] && Length[temperatureProfile]>0,
												Null,
											transformQ,
												Null,
											TrueQ[thaw],
												Null,
											True,
												40 Celsius
										]
									},
									{AnnealingTime, Null},
									{Amplitude, Null},
									{MaxTemperature, Null},
									{DutyCycle, Null},
									{StirBar, Null},
									{MixRateProfile, Null},
									{TemperatureProfile, Null},
									{OscillationAngle, Null},
									{PotentialAliquotContainers, potentialAliquotContainers},
									{Preheat,Null},
									{ResidualTemperature,Null},
									{ResidualMix,Null},
									{ResidualMixRate,Null},
									{MixPosition,Null},
									{MixPositionOffset,Null},
									{MixFlowRate,Null},
									{CorrectionCurve,Null},
									{Tips,Null},
									{TipType, Null},
									{TipMaterial,Null},
									{RelativeHumidity,resolvedRelativeHumidity},
									{LightExposure,resolvedLightExposure},
									{LightExposureIntensity,resolvedLightExposureIntensity},
									{TotalLightExposure, resolvedTotalLightExposure},
									{PreSonicationTime,Null},
									{AlternateInstruments,Null}
								}
							]
						],
					_,
						Null
				];

				(* Resolve SampleLabel and SampleContainerLabel if it's not given. *)
				sampleLabel=Which[
					MatchQ[Lookup[myMapThreadOptions, SampleLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, SampleLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[mySample, Object]], _String],
					LookupObjectLabel[simulation, Download[mySample, Object, Cache->cacheBall]],

					True,
					Lookup[preResolvedSampleLabelRules, Download[mySample, Object, Cache->cacheBall]]
				];

				sampleContainerObject = fastAssocLookup[fastAssoc, mySample, {Container, Object}];

				sampleContainerLabel=Which[
					MatchQ[Lookup[myMapThreadOptions, SampleContainerLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, SampleContainerLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[sampleContainerObject, Object]], _String],
					LookupObjectLabel[simulation, Download[sampleContainerObject, Object]],

					True,
					Lookup[preResolvedSampleContainerLabelRules, Download[sampleContainerObject, Object]]
				];

				(* Resolve transform options *)
				transform = Which[

					(* User specified Transform *)
					MatchQ[Lookup[myMapThreadOptions, Transform], Except[Automatic]],
						Lookup[myMapThreadOptions, Transform],

					(* We're transforming, as figured out above *)
					transformQ,
						True,

					(* If we have cells, but no other transform options set, default to False so we show up in command builder *)
					MatchQ[mainCellIdentityModel,ListableP[ObjectP[Model[Cell]]]],
						False,

					(* Otherwise, we're not and don't want to show up in command builder *)
					True,
						Null
				];

				transformHeatShockTemperature = Which[

					(* User specified TransformHeatShockTemperature *)
					MatchQ[Lookup[myMapThreadOptions, TransformHeatShockTemperature], Except[Automatic]],
					Lookup[myMapThreadOptions, TransformHeatShockTemperature],

					(* We're transforming, as figured out above *)
					transformQ,
						42 Celsius,

					(* Otherwise, we're not *)
					True,
						Null
				];

				transformHeatShockTime = Which[

					(* User specified TransformHeatShockTemperature *)
					MatchQ[Lookup[myMapThreadOptions, TransformHeatShockTime], Except[Automatic]],
						Lookup[myMapThreadOptions, TransformHeatShockTime],

					(* We're transforming, as figured out above *)
					transformQ,
						45 Second,

					(* Otherwise, we're not *)
					True,
						Null
				];

				transformPreHeatCoolingTime = Which[

					(* User specified TransformHeatShockTemperature *)
					MatchQ[Lookup[myMapThreadOptions, TransformPreHeatCoolingTime], Except[Automatic]],
					Lookup[myMapThreadOptions, TransformPreHeatCoolingTime],

					(* We're transforming, as figured out above *)
					transformQ,
						25 Minute,

					(* Otherwise, we're not *)
					True,
						Null
				];

				transformPostHeatCoolingTime = Which[

					(* User specified TransformHeatShockTemperature *)
					MatchQ[Lookup[myMapThreadOptions, TransformPostHeatCoolingTime], Except[Automatic]],
						Lookup[myMapThreadOptions, TransformPostHeatCoolingTime],

					(* We're transforming, as figured out above *)
					transformQ,
						2 Minute,

					(* Otherwise, we're not *)
					True,
						Null
				];

				(* Some transform error checks *)
				(* Do we have an incompatible instrument with transform? *)
				resolvedInstrumentModel = Which[

					(* The instrument is null because we're just mixing: this doesn't matter *)
					NullQ[instrument],
						Null,

					(* The instrument is a specific object - get its model *)
					MatchQ[instrument,ObjectP[Object[Instrument]]],
						fastAssocLookup[fastAssoc, instrument, {Model, Object}] /. {$Failed | NullP -> Null},

					(* The instrument is a model - it's already what we want *)
					True,
						fastAssocLookup[fastAssoc, instrument, Object] /. {$Failed | NullP -> Null}
				];
				transformIncompatibleInstrumentError = transformQ && MatchQ[resolvedInstrumentModel, ObjectP[$TransformInstruments]];

				(* Is our sample container too big? *)
				sampleContainerHeight = Last[
					Lookup[
						fetchPacketFromCache[
							Download[Lookup[fetchPacketFromCache[sampleContainerObject, cacheBall], Model], Object],
							cacheBall
						],
						Dimensions
					]
				];
				transformIncompatibleContainerError = transformQ && GreaterQ[sampleContainerHeight, $TransformContainerMaxHeight];

				(* Gather MapThread results *)
				{
				thaw,thawTime,maxThawTime,thawTemperature,thawInstrument,

				thawIncompatibleInstrumentError,thawNoInstrumentError,

				mixBoolean,mixType,mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,
				volume,temperature,annealingTime,amplitude,maxTemperature,dutyCycle,residualIncubation,potentialAliquotContainers,
				stirBar,mixRateProfile,temperatureProfile,oscillationAngle,residualTemperature,residualMix,residualMixRate,preheat,
				mixPosition,mixPositionOffset,mixFlowRate,correctionCurve,tips,tipType,tipMaterial,sampleLabel,sampleContainerLabel,
				relativeHumidity, lightExposure, lightExposureIntensity, totalLightExposure, transform, transformHeatShockTemperature,
				transformHeatShockTime, transformPreHeatCoolingTime, transformPostHeatCoolingTime, preSonicationTime, alternateInstruments,

				mixTypeRateError,

				invertSampleVolumeError,invertSuitableContainerError,invertContainerWarning,

				pipetteNoInstrumentError,pipetteIncompatibleInstrumentError,pipetteNoInstrumentForVolumeError,pipetteMixNoVolumeWarning,

				vortexAutomaticInstrumentContainerWarning,vortexManualInstrumentContainerWarning,
				vortexNoInstrumentError,vortexNoInstrumentForRateError,vortexIncompatibleInstrumentError,

				disruptAutomaticInstrumentContainerWarning,disruptManualInstrumentContainerWarning,
				disruptNoInstrumentError,disruptNoInstrumentForRateError,disruptIncompatibleInstrumentError,

				nutateAutomaticInstrumentContainerWarning,nutateManualInstrumentContainerWarning,
				nutateNoInstrumentError,nutateIncompatibleInstrumentError,

				rollAutomaticInstrumentContainerWarning,rollManualInstrumentContainerWarning,
				rollNoInstrumentError,rollIncompatibleInstrumentError,

				shakeAutomaticInstrumentContainerWarning,shakeManualInstrumentContainerWarning,
				shakeNoInstrumentError,shakeIncompatibleInstrumentError,

				stirAutomaticInstrumentContainerWarning,stirManualInstrumentContainerWarning,
				stirNoInstrumentError,stirIncompatibleInstrumentError, noImpellerOrStirBarError,

				sonicateAutomaticInstrumentContainerWarning,sonicateManualInstrumentContainerWarning,
				sonicateNoInstrumentError,sonicateIncompatibleInstrumentError,

				homogenizeNoInstrumentError,homogenizeIncompatibleInstrumentError,

				sterileMismatchWarning,sterileContaminationWarning,

				monotonicCorrectionCurveWarning,incompleteCorrectionCurveWarning,invalidZeroCorrectionError,

				transformIncompatibleInstrumentError, transformIncompatibleContainerError
				}
			]
		],
		{mySimulatedSamples,mapThreadFriendlyOptions,sampleContainerModelPackets,Lookup[mySamplePrepOptions, Aliquot]}
	]];

	(*new resolved options*)
	resolvedRoboticOptionsWithoutMultichannelMixing=ReplaceRule[
		myOptions,
		{
			MixType->mixTypes,
			MixVolume->volumes,
			NumberOfMixes->numberOfMixesList,
			MixRate->rates,
			MixFlowRate->mixFlowRates,
			MixPosition->mixPositions,
			MixPositionOffset->mixPositionOffsets,
			CorrectionCurve->correctionCurves,
			Tips->tipss,
			TipType->tipTypes,
			TipMaterial->tipMaterials,
			Time->times,
			ResidualIncubation->residualIncubationList,
			ResidualTemperature->residualTemperatures,
			ResidualMix->residualMixes,
			ResidualMixRate->residualMixRates,
			SampleLabel->Flatten@sampleLabels,
			SampleContainerLabel->Flatten@sampleContainerLabels
		}
	];

	(* additional resolution for robotic preparation *)
	{resolvedMultichannelMix,resolvedMultichannelMixName,resolvedDeviceChannel}=If[MatchQ[resolvedPreparation,Robotic]&&!MatchQ[mixTypes,{Null...}],
		Module[{pipetteIndices,pipetteSamples,pipetteOptions,pipetteSampleContainers,pipetteMultichannelMixes, pipetteMultichannelMixNames, pipetteDeviceChannels,multichannelMixes,multichannelMixNames,deviceChannels},

			(* Split out our samples and options that are being mixed via pipette. *)
			pipetteIndices=Flatten@Position[mixTypes, Pipette];
			pipetteSamples=mySamples[[pipetteIndices]];
			pipetteOptions=OptionsHandling`Private`mapThreadOptions[
				experimentFunction,
				Normal@resolvedRoboticOptionsWithoutMultichannelMixing
			][[pipetteIndices]];

			(* Figure out containers our pipette samples are in. *)
			pipetteSampleContainers = Map[
				If[MatchQ[#, ObjectP[Object[Sample]]],
					fastAssocLookup[fastAssoc, #, {Container, Object}],
					fastAssocLookup[fastAssoc, #, Object]
				]&,
				mySamples
			];

			(* We ALWAYS set MultichannelMix->True if we have more than one transfer that we're performing. *)
			(* NOTE: This is very similar to the logic we do in the Transfer primitive except here we also have to check for mix via Pipette. *)
			{pipetteMultichannelMixes, pipetteMultichannelMixNames, pipetteDeviceChannels}=Which[
				(* There are no pipette options. *)
				Length[pipetteOptions]==0,
				{{},{},{}},

				(* User is telling us to use the 96 head. *)
				MatchQ[Lookup[pipetteOptions, DeviceChannel], {MultiProbeHead..}],
				{
					Lookup[pipetteOptions, MultichannelMix]/.{Automatic->True},
					Lookup[pipetteOptions, MultichannelMixName]/.{Automatic->CreateUUID[]},
					Lookup[pipetteOptions, DeviceChannel]
				},

				(* The user has set some of these options so we have to do a fold. *)
				Or[
					MemberQ[Lookup[pipetteOptions, MultichannelMix], Except[Automatic]],
					MemberQ[Lookup[pipetteOptions, MultichannelMixName], Except[Automatic]],
					MemberQ[Lookup[pipetteOptions, DeviceChannel], Except[Automatic]]
				],

				Transpose@Fold[
					(* NOTE: Our tuples are in the format {MultichannelMix, MultichannelMixName, DeviceChannel, MixType, TransferIndex}. *)
					Function[{tupleList, newTuple},
						Module[{lastTuple,lastTupleGroup,resolvedNewTuple},
							(* Pull out the last tuple of information. *)
							lastTuple=Last[tupleList];
							(* Get the information about the last MultichannelTransferName group. *)
							lastTupleGroup=Cases[tupleList, {_, lastTuple[[2]], _}];

							(* Resolve our current tupple that we're on. *)
							resolvedNewTuple=Which[
								(* We're not mixing via pipette. *)

								(* The user specifically said to turn off multi-transfer. *)
								MatchQ[newTuple[[1]], False],
								{newTuple[[1]], newTuple[[2]]/.{Automatic->Null}, newTuple[[3]]/.{Automatic->Null}},

								(* If our previous tuple chose to turn off MultiChannel transfers and we're at the end of the list, don't turn it on. *)
								MatchQ[lastTuple[[1]], False] && MatchQ[newTuple[[4]], Length[pipetteOptions]],
								{False, newTuple[[2]]/.{Automatic->Null}, newTuple[[3]]/.{Automatic->Null}},

								(* Previous one was on and we haven't used up all of our channels yet (or the user specifically asked for group inclusion). *)
								(* MultiProbeHead case. *)
								And[
									MatchQ[lastTuple[[1]], True],
									MatchQ[lastTuple[[3]], MultiProbeHead],
									MatchQ[newTuple[[3]], MultiProbeHead],
									Or[
										MatchQ[newTuple[[2]], lastTuple[[2]]],
										Length[Cases[tupleList, lastTuple[[2]], Infinity]] < 96
									]
								],
								{True, lastTuple[[2]],MultiProbeHead},
								(* Append to the previous tuple's run. *)
								And[
									MatchQ[lastTuple[[1]], True],
									Or[
										MatchQ[newTuple[[2]], lastTuple[[2]]],
										And[
											(* Make sure that our group is less than 8 long since we only have 8 channels. *)
											Length[lastTupleGroup] < 8,
											(* HSL requires the DeviceChannel to be in ascending order within one group. That means Channel8 cannot be used already in this group and our new DeviceChannel (if specified) must be larger than existing DeviceChannel *)
											!MemberQ[lastTupleGroup[[All,3]], Last[$WorkCellProbes]],
											Or[
												MatchQ[newTuple[[3]],Automatic],
												MatchQ[
													Max[Flatten[{Position[$WorkCellProbes,Alternatives@@(lastTupleGroup[[All,3]])],0}]],
													LessP[FirstOrDefault[FirstPosition[$WorkCellProbes,newTuple[[3]]],Length[$WorkCellProbes]]]
												]
											]
										]
									]
								],
								{True, lastTuple[[2]], newTuple[[3]]/.{Automatic->FirstOrDefault[Part[$WorkCellProbes, FirstPosition[$WorkCellProbes, lastTuple[[3]],0]+1], SingleProbe1]}},

								(* Start a new run. *)
								True,
								{True, newTuple[[2]]/.{Automatic->CreateUUID[]}, newTuple[[3]]/.{Automatic->SingleProbe1}}
							];

							(* Append our new tupple at the ne of our list. *)
							Append[tupleList, resolvedNewTuple]
						]
					],
					(* Initialize our first transfer before our fold. *)
					List@Switch[First[Lookup[pipetteOptions, {MultichannelMix, MultichannelMixName, DeviceChannel}]],
						{False, _,  _}|{Automatic, _, Null}|{Automatic, Null, _},
						{
							False,
							Lookup[pipetteOptions, MultichannelMixName][[1]],
							Lookup[pipetteOptions, DeviceChannel][[1]]
						}/.{Automatic->Null},
						{Automatic, _, _},
						{
							True,
							Lookup[pipetteOptions, MultichannelMixName][[1]]/.{Automatic->CreateUUID[]},
							Lookup[pipetteOptions, DeviceChannel][[1]]/.{Automatic->SingleProbe1}
						},
						_,
						{
							True,
							Lookup[pipetteOptions, MultichannelMixName][[1]]/.{Automatic->CreateUUID[]},
							Lookup[pipetteOptions, DeviceChannel][[1]]/.{Automatic->SingleProbe1}
						}
					],
					Rest[Transpose[
						Append[
							Transpose[Lookup[pipetteOptions, {MultichannelMix, MultichannelMixName, DeviceChannel}]],
							Range[Length[mySamples]]
						]
					]]
				],

				(* If we only have one source, we can't do this multi-channel. *)
				Length[pipetteOptions]==1,
				{{False},{Null},{SingleProbe1}},

				(* Should we use the 96-head? *)
				(* We will use the 96-head if (1) all of our samples are in a plate, (2) compatible wells are used, AND (3) our amounts are the same. *)
				And[
					Length[pipetteOptions]==96,
					MatchQ[pipetteSampleContainers, {ObjectP[Object[Container, Plate]]..}],
					Length[DeleteDuplicates[pipetteSampleContainers]]==1,
					Length[DeleteDuplicates[volumes]]==1,
					MatchQ[
						Sort[Lookup[samplePackets, Position]],
						Alternatives[
							Sort[Flatten[AllWells[]]],
							Sort[Flatten[AllWells[NumberOfWells -> 384][[ ;; ;; 2]]][[ ;; ;; 2]]],
							Sort[Flatten[AllWells[NumberOfWells -> 384][[2 ;; ;; 2]]][[ ;; ;; 2]]],
							Sort[Flatten[AllWells[NumberOfWells -> 384][[ ;; ;; 2]]][[2 ;; ;; 2]]],
							Sort[Flatten[AllWells[NumberOfWells -> 384][[2 ;; ;; 2]]][[2 ;; ;; 2]]]
						]
					]
				],
				{
					ConstantArray[True, Length[pipetteOptions]],
					ConstantArray[CreateUUID[], Length[pipetteOptions]],
					ConstantArray[MultiProbeHead, Length[pipetteOptions]]
				},

				(* Otherwise, just use the 8 channels like normal. *)
				True,
				{
					ConstantArray[True, Length[pipetteOptions]],
					Flatten@{
						Table[
							ConstantArray[CreateUUID[], $NumberOfWorkCellProbes],
							Floor[Length[pipetteOptions]/$NumberOfWorkCellProbes]
						],

						If[!MatchQ[Mod[Length[pipetteOptions], $NumberOfWorkCellProbes], 0],
							ConstantArray[CreateUUID[], Mod[Length[pipetteOptions], $NumberOfWorkCellProbes]],
							Nothing
						]
					},
					Flatten@{
						Table[
							{SingleProbe1, SingleProbe2, SingleProbe3, SingleProbe4, SingleProbe5, SingleProbe6, SingleProbe7, SingleProbe8},
							Floor[Length[pipetteOptions]/$NumberOfWorkCellProbes]
						],

						If[!MatchQ[Mod[Length[pipetteOptions], $NumberOfWorkCellProbes], 0],
							Take[
								{SingleProbe1, SingleProbe2, SingleProbe3, SingleProbe4, SingleProbe5, SingleProbe6, SingleProbe7, SingleProbe8},
								Mod[Length[pipetteOptions], $NumberOfWorkCellProbes]
							],
							Nothing
						]
					}
				}
			];

			multichannelMixes=ConstantArray[False, Length[mySamples]];
			multichannelMixNames=ConstantArray[Null, Length[mySamples]];
			deviceChannels=Lookup[resolvedRoboticOptionsWithoutMultichannelMixing, DeviceChannel];

			multichannelMixes[[pipetteIndices]]=pipetteMultichannelMixes;
			multichannelMixNames[[pipetteIndices]]=pipetteMultichannelMixNames;
			deviceChannels[[pipetteIndices]]=pipetteDeviceChannels;

			(*If length of pipette options is 0, replace device channels with an empty list*)
			If[Length[pipetteOptions]==0,
				deviceChannels=ConstantArray[Null, Length[mySamples]];
			];

			{multichannelMixes,multichannelMixNames,deviceChannels}
		],

		(* Otherwise, make all of the options Null*)
		{
			ConstantArray[Null, Length[mySamples]],
			ConstantArray[Null, Length[mySamples]],
			ConstantArray[Null, Length[mySamples]]
		}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(*-- THAW CHECKS -- *)

	(* Check for user given incompatible instruments. *)
	thawIncompatibleInstrumentInvalidOptions=If[Or@@thawIncompatibleInstrumentErrors&&!gatherTests,
		Module[{thawIncompatibleInstrumentInvalidSamples,invalidThawInstruments},
			(* Get the samples that correspond to this error. *)
			thawIncompatibleInstrumentInvalidSamples=PickList[mySimulatedSamples,thawIncompatibleInstrumentErrors];

			(* Get the corresponding invalid thaw instruments. *)
			invalidThawInstruments=PickList[thawInstruments,thawIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::MixThawIncompatibleInstrument,ObjectToString[thawIncompatibleInstrumentInvalidSamples,Cache->cacheBall],ObjectToString[invalidThawInstruments,Cache->cacheBall]];

			(* Return our invalid options. *)
			{ThawInstrument}
		],
		{}
	];

	(* Create the corresponding test for the invalid thaw instrument error. *)
	thawIncompatibleInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,thawIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,thawIncompatibleInstrumentErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cacheBall]<>" fit on their thaw instrument, if one is specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cacheBall]<>" fit on their thaw instrument, if one is specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no thaw instrument available. *)
	thawNoInstrumentInvalidOptions=If[Or@@thawNoInstrumentErrors&&!gatherTests,
		Module[{thawNoInstrumentInvalidSamples},
			(* Get the samples that correspond to this error. *)
			thawNoInstrumentInvalidSamples=PickList[mySimulatedSamples,thawNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::MixThawNoThawInstrumentAvailable,ObjectToString[thawNoInstrumentInvalidSamples,Cache->cacheBall]];

			(* Return our invalid options. *)
			{ThawInstrument}
		],
		{}
	];

	(* Create the corresponding test for the no thaw instrument available error. *)
	thawNoInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,thawNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,thawNoInstrumentErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have an instrument capable of thawing the sample, if Thaw->True and ThawInstrument->Automatic.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have an instrument capable of thawing the sample, if Thaw->True and ThawInstrument->Automatic.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- INVERT CHECKS --*)
	(* Check for invert sample volume >4L errors *)
	invertVolumeInvalidOptions=If[Or@@invertSampleVolumeErrors&&!gatherTests,
		Module[{invertVolumeInvalidSamples,sampleVolumes},
			(* Get the samples that correspond to this error. *)
			invertVolumeInvalidSamples=PickList[mySimulatedSamples,invertSampleVolumeErrors];

			(* Get the volumes of these samples. *)
			sampleVolumes = fastAssocLookup[fastAssoc, invertVolumeInvalidSamples, Volume] /. {NullP -> 0 Liter};

			(* Throw the corresponding error. *)
			Message[Error::VolumeTooLargeForInversion,ObjectToString[sampleVolumes],ObjectToString[invertVolumeInvalidSamples,Cache->cacheBall]];

			(* Return our invalid options. *)
			{MixType}
		],
		{}
	];

	(* Create the corresponding test for the invert sample volume error. *)
	invertVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,invertSampleVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Invert]]&),{invertSampleVolumeErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are under 4L if they are to be mixed by inversion.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The volumes of the following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are under 4L if they are to be mixed by inversion.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for invert no suitable container errors. *)
	invertContainerInvalidOptions=If[Or@@invertSuitableContainerErrors&&!gatherTests,
		Module[{invertContainerInvalidSamples},
		(* Get the samples that correspond to this error. *)
			invertContainerInvalidSamples=PickList[mySimulatedSamples,invertSuitableContainerErrors];

			(* Throw the corresponding error. *)
			Message[Error::InvertNoSuitableContainer,ObjectToString[invertContainerInvalidSamples,Cache->cacheBall]];

			(* Return our invalid options. *)
			{MixType}
		],
		{}
	];

	(* Create the corresponding test for the invert sample volume error. *)
	invertContainerTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,invertSuitableContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Invert]]&),{invertSuitableContainerErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are in a, or can be moved into, a inversion compatible container if they are to be mixed by inversion.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are in a, or can be moved into, a inversion compatible container if they are to be mixed by inversion.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- PIPETTE CHECKS --*)
	(* Check if the sample is missing volume and we have to use 1uL MixVolume *)
	If[Or@@pipetteMixNoVolumeWarnings&&!gatherTests,
		Module[{invalidInputs,correspondingCorrectionCurves},
			(* Get the samples that correspond to this warning. *)
			invalidInputs=PickList[mySimulatedSamples,pipetteMixNoVolumeWarnings,True];
			Message[Warning::LowPipetteMixVolume,invalidInputs]
		]
	];

	pipetteMixNoVolumeTest=If[gatherTests,
		If[Or@@pipetteMixNoVolumeWarnings,
			Warning["The sample volumes are above 1 Microliter for Pipette mixing:",False,True],
			Warning["The sample volumes are above 1 Microliter for Pipette mixing:",True,True]
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- VORTEX CHECKS --*)
	(* Check for vortex manual instrument, container changing warnings. *)

	(* Check for incompatible instrument errors. *)
	vortexIncompatibleInstrumentInvalidOptions=If[Or@@vortexIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,vortexIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,vortexIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::VortexIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	vortexIncompatibleInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,vortexIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Vortex]]&),{vortexIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given vortex instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given vortex instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	vortexNoInstrumentForRateInvalidOptions=If[Or@@vortexNoInstrumentForRateErrors&&!gatherTests,
		Module[{invalidSamples,correspondingRates},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,vortexNoInstrumentForRateErrors];
			correspondingRates=PickList[rates,vortexNoInstrumentForRateErrors];

			(* Throw the corresponding error. *)
			Message[Error::VortexNoInstrumentForRate,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingRates,Cache->cacheBall]];

			(* Return the invalid options. *)
			{MixRate,Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	vortexNoInstrumentForRateTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,vortexNoInstrumentForRateErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Vortex]]&),{vortexNoInstrumentForRateErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible vortex instruments, if a rate is supplied and the sample is to be mixed by vortex.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible vortex instruments, if a rate is supplied and the sample is to be mixed by vortex.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	vortexNoInstrumentInvalidOptions=If[Or@@vortexNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,vortexNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::VortexNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	vortexNoInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,vortexNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Vortex]]&),{vortexNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible vortex instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible vortex instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- DISRUPT CHECKS --*)
	(* Check for vortex manual instrument, container changing warnings. *)

	(* Check for incompatible instrument errors. *)
	disruptIncompatibleInstrumentInvalidOptions=If[Or@@disruptIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,disruptIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,disruptIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::DisruptIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	disruptIncompatibleInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,disruptIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Disrupt]]&),{disruptIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given disruptor instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given disruptor instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	disruptNoInstrumentForRateInvalidOptions=If[Or@@disruptNoInstrumentForRateErrors&&!gatherTests,
		Module[{invalidSamples,correspondingRates},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,disruptNoInstrumentForRateErrors];
			correspondingRates=PickList[rates,disruptNoInstrumentForRateErrors];

			(* Throw the corresponding error. *)
			Message[Error::DisruptNoInstrumentForRate,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingRates,Cache->cacheBall]];

			(* Return the invalid options. *)
			{MixRate,Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	disruptNoInstrumentForRateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,disruptNoInstrumentForRateErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Disrupt]]&),{disruptNoInstrumentForRateErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible disruptor instruments, if a rate is supplied and the sample is to be mixed by disruption.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible disruptor instruments, if a rate is supplied and the sample is to be mixed by disruption.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	disruptNoInstrumentInvalidOptions=If[Or@@disruptNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,disruptNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::DisruptNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	disruptNoInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,disruptNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Disrupt]]&),{disruptNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible disruption instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible disruption instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- NUTATE CHECKS --*)

	(* Check for incompatible instrument errors. *)
	nutateIncompatibleInstrumentInvalidOptions=If[Or@@nutateIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,nutateIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,nutateIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::NutateIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	nutateIncompatibleInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,nutateIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Nutate]]&),{nutateIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given nutation instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given nutation instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	nutateNoInstrumentInvalidOptions=If[Or@@nutateNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,nutateNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::NutateNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	nutateNoInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,nutateNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Roll]]&),{nutateNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible nutation instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible nutation instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- ROLL CHECKS --*)

	(* Check for incompatible instrument errors. *)
	rollIncompatibleInstrumentInvalidOptions=If[Or@@rollIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,rollIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,rollIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::RollIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	rollIncompatibleInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,rollIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Roll]]&),{rollIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given roller instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given roller instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	rollNoInstrumentInvalidOptions=If[Or@@rollNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,rollNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::RollNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	rollNoInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,rollNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Roll]]&),{rollNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible roller instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible roller instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- SHAKE CHECKS --*)

	(* Check for incompatible instrument errors. *)
	shakeIncompatibleInstrumentInvalidOptions=If[Or@@shakeIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,shakeIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,shakeIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::ShakeIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	shakeIncompatibleInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,shakeIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Shake]]&),{shakeIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given shaker instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given shaker instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	shakeNoInstrumentInvalidOptions=If[Or@@shakeNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,shakeNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::ShakeNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	shakeNoInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,shakeNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Shake]]&),{shakeNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible shaker instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible shaker instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for residual incubation on shaker errors. *)
	instrumentModels = Map[
		Which[
			NullQ[#],
				Null,
			(* We already have the model. *)
			MatchQ[#, ObjectP[Model[Instrument]]],
				fastAssocLookup[fastAssoc, #, Object],
			(* Go from the object to the model. *)
			True,
				fastAssocLookup[fastAssoc, # {Model, Object}] /. {$Failed | NullP -> Null}
		]&,
		instruments
	];
	residualIncubationOptionTuples=Transpose[
		{
			mixTypes,
			instruments,
			instrumentModels,
			residualIncubationList,
			residualTemperatures,
			residualMixes,
			residualMixRates,
			mySimulatedSamples
		}
	];
	(* On Robotic run, cannot allow off-deck residual incubation as we have to move the container back for downstream processing *)
	invalidResidualIncubationOptionTuples=If[MatchQ[resolvedPreparation,Robotic],
		Select[
			residualIncubationOptionTuples,
			And[
				MatchQ[#[[1]],Shake],
				MatchQ[#[[3]],ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]],
				MemberQ[#[[4;;7]],Except[(Null|False)]]
			]&
		],
		{}
	];
	residualIncubationIncompatibleInvalidOptions=If[Length[invalidResidualIncubationOptionTuples]>0&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=invalidResidualIncubationOptionTuples[[All,-1]];
			invalidOptions={
				If[MemberQ[invalidResidualIncubationOptionTuples[[All,3]],ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]],
					Instrument,
					Nothing
				],
				If[MemberQ[invalidResidualIncubationOptionTuples[[All,4]],Except[(Null|False)]],
					ResidualIncubation,
					Nothing
				],
				If[MemberQ[invalidResidualIncubationOptionTuples[[All,5]],Except[Null]],
					ResidualTemperature,
					Nothing
				],
				If[MemberQ[invalidResidualIncubationOptionTuples[[All,6]],Except[(Null|False)]],
					ResidualMix,
					Nothing
				],
				If[MemberQ[invalidResidualIncubationOptionTuples[[All,7]],Except[Null]],
					ResidualMixRate,
					Nothing
				]
			};
			correspondingInstruments=PickList[instruments,shakeIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::ResidualIncubationInvalid,invalidOptions,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[invalidResidualIncubationOptionTuples[[All,2]],Cache->cacheBall]];

			(* Return the invalid options. *)
			invalidOptions
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	residualIncubationIncompatibleTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=invalidResidualIncubationOptionTuples[[All,-1]];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,invalidResidualIncubationOptionTuples[[All,-1]]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["Residual incubation options can be set for the following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" with the instruments "<>ObjectToString[invalidResidualIncubationOptionTuples[[All,2]],Cache->cacheBall]<>" robotically.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["Residual incubation options can be set for the following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" with the desired mix type and instrument.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- STIR CHECKS --*)

	(* Check for no stir bar or impeller errors. *)
	stirNoStirBarOrImpellerInvalidOptions=If[Or@@noImpellerOrStirBarErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,noImpellerOrStirBarErrors];
			correspondingInstruments=PickList[instruments,noImpellerOrStirBarErrors];

			(* Throw the corresponding error. *)
			Message[Error::StirNoStirBarOrImpeller,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument, StirBar}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	stirNoStirBarOrImpellerTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,noImpellerOrStirBarErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Stir]]&),{noImpellerOrStirBarErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible stir bar or impeller to stir, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible stir bar or impeller to stir, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for incompatible instrument errors. *)
	stirIncompatibleInstrumentInvalidOptions=If[Or@@stirIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,stirIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,stirIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::StirIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the stir incompatible instrument error. *)
	stirIncompatibleInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,stirIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Stir]]&),{stirIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given stir instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given stir instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	stirNoInstrumentInvalidOptions=If[Or@@stirNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,stirNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::StirNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	stirNoInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,stirNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Stir]]&),{stirNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible overhead stirring instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible overhead stirring instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- SONICATE CHECKS --*)

	(* Check for incompatible instrument errors. *)
	sonicateIncompatibleInstrumentInvalidOptions=If[Or@@sonicateIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,sonicateIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,sonicateIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::SonicateIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	sonicateIncompatibleInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,sonicateIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Sonicate]]&),{sonicateIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given sonication instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given sonication instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	sonicateNoInstrumentInvalidOptions=If[Or@@sonicateNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,sonicateNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::SonicateNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	sonicateNoInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,sonicateNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Sonicate]]&),{sonicateNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible sonication instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible sonication instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- HOMOGENIZE CHECKS --*)
	(* Check for incompatible instrument errors. *)
	homogenizeIncompatibleInstrumentInvalidOptions=If[Or@@homogenizeIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,correspondingInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,homogenizeIncompatibleInstrumentErrors];
			correspondingInstruments=PickList[instruments,homogenizeIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::HomogenizeIncompatibleInstruments,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[correspondingInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	homogenizeIncompatibleInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,homogenizeIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Sonicate]]&),{homogenizeIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" are compatible with their given homogenization instrument, if specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are compatible with their given homogenization instrument, if specified.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for no instrument for rate errors. *)
	homogenizeNoInstrumentInvalidOptions=If[Or@@homogenizeNoInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,homogenizeNoInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::HomogenizeNoInstrument,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,MixType}
		],
		{}
	];

	(* Create the corresponding test for the vortex incompatible instrument error. *)
	homogenizeNoInstrumentTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,sonicateNoInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Homogenize]]&),{homogenizeNoInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have compatible homogenization instruments.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have compatible homogenization instruments.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Warn the user if the homogenization amplitude is over 75%. *)
	homogenizeAmplitudeWarningInputs=MapThread[
		Function[{sample,instrument,amplitude},
			(* If we have an amplitude over 50%, throw a warning. *)
			(* BUT it's okay it we're using the plate sonicator since our containers will have covers on them. *)
			If[MatchQ[amplitude,GreaterP[50 Percent]] && !MatchQ[instrument, ObjectP[{Model[Instrument, Sonicator], Object[Instrument, Sonicator]}]],
				sample,
				Nothing
			]
		],
		{mySimulatedSamples,instruments,amplitudes}
	];

	(* Throw our warning if there are amplitudes to warn about. *)
	If[Length[homogenizeAmplitudeWarningInputs]>0,
		Message[Warning::HomogenizationAmplitude,ObjectToString[homogenizeAmplitudeWarningInputs,Cache->cacheBall]];
	];

	(*-- Correction Curve Checks --*)
	If[Or@@monotonicCorrectionCurveWarnings&&!gatherTests,
		Module[{invalidIndices,correspondingCorrectionCurves},
			(* Get the samples that correspond to this error. *)
			invalidIndices=Flatten@Position[monotonicCorrectionCurveWarnings,True];
			correspondingCorrectionCurves=PickList[correctionCurves,monotonicCorrectionCurveWarnings];
			Message[Warning::CorrectionCurveNotMonotonic,correspondingCorrectionCurves,invalidIndices]
		]
	];

	monotonicCorrectionCurveTest=If[gatherTests,
		If[Or@@monotonicCorrectionCurveWarnings,
			Warning["The specified CorrectionCurve has actual values that are not monotonically increasing:",False,True],
			Warning["The specified CorrectionCurve has actual values that are not monotonically increasing:",True,True]
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	If[Or@@incompleteCorrectionCurveWarnings&&!gatherTests,
		Module[{invalidIndices,correspondingCorrectionCurves},
			(* Get the samples that correspond to this error. *)
			invalidIndices=Flatten@Position[incompleteCorrectionCurveWarnings,True];
			correspondingCorrectionCurves=PickList[correctionCurves,incompleteCorrectionCurveWarnings];
			Message[Warning::CorrectionCurveIncomplete,correspondingCorrectionCurves,invalidIndices]
		]
	];

	incompleteCorrectionCurveTest=If[gatherTests,
		If[Or@@incompleteCorrectionCurveWarnings,
			Warning["The specified CorrectionCurve covers the full transfer volume range of 0 uL - 1000 uL:",False,True],
			Warning["The specified CorrectionCurve covers the full transfer volume range of 0 uL - 1000 uL:",True,True]
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	invalidZeroCorrectionOptions=If[Or@@invalidZeroCorrectionErrors&&!gatherTests,
		Module[{invalidIndices,correspondingCorrectionCurves},
			(* Get the samples that correspond to this error. *)
			invalidIndices=Flatten@Position[invalidZeroCorrectionErrors,True];
			correspondingCorrectionCurves=PickList[correctionCurves,invalidZeroCorrectionErrors];
			Message[Error::InvalidCorrectionCurveZeroValue,invalidZeroCorrectionErrors,invalidIndices];
			{CorrectionCurve}
		],
		{}
	];

	invalidZeroCorrectionTest=If[gatherTests,
		If[Or@@invalidZeroCorrectionErrors,
			Test["The specified CorrectionCurve's actual volume corresponding to a target volume of 0 Microliter must be 0 Microliter:",False,True],
			Test["The specified CorrectionCurve's actual volume corresponding to a target volume of 0 Microliter must be 0 Microliter:",True,True]
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*---Transform Checks---*)
	(* Check for instrument compatibility with Transform. *)
	transformIncompatibleInstrumentOptions=If[Or@@transformIncompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples,invalidInstruments},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,transformIncompatibleInstrumentErrors];
			invalidInstruments=PickList[instruments,transformIncompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::TransformIncompatibleInstrument,ObjectToString[invalidSamples,Cache->cacheBall],ObjectToString[invalidInstruments,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Instrument,Transform}
		],
		{}
	];

	(* Create the corresponding test for the transform-incompatible instrument error. *)
	transformIncompatibleInstrumentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,transformIncompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Disrupt]]&),{transformIncompatibleInstrumentErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have instruments compatible with Transform-type incubations.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have instruments compatible with Transform-type incubations.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for container compatibility with Transform. *)
	transformIncompatibleContainerOptions=If[Or@@transformIncompatibleContainerErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[mySimulatedSamples,transformIncompatibleContainerErrors];
			(* Throw the corresponding error. *)
			Message[Error::TransformIncompatibleContainer,ObjectToString[invalidSamples,Cache->cacheBall]];

			(* Return the invalid options. *)
			{Transform}
		],
		{}
	];

	(* Create the corresponding test for the transform-incompatible container error. *)
	transformIncompatibleContainerTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySimulatedSamples,transformIncompatibleContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySimulatedSamples,MapThread[(Xor[#1, MatchQ[#2,Disrupt]]&),{transformIncompatibleContainerErrors,mixTypes}]];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>" have containers compatible with Transform-type incubations.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>" have containers compatible with Transform-type incubations.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve TargetContainers and Instrument. *)
	{targetContainers,resolvedInstruments,resolvedRates}=Module[{aliquotIndices,aliquotTypes,typesAndIndices,groupedTypesAndIndices,aliquotContainersAndInstruments,resolvedContainersAndInstruments,aliquotInformation},
		(* Get the positions of the samples that we need to aliquot. *)
		aliquotIndices=Flatten[Position[potentialAliquotContainersList,_List,{1}]];

		(* Do we need to aliquot at all? *)
		If[Length[aliquotIndices]==0,
			(* We don't need to aliquot anything. *)
			{ConstantArray[Null,Length[mySimulatedSamples]],instruments,rates},
			(* ELSE: We indeed need to aliquot. *)
			(* Get the samples that correspond to these indices. *)
			aliquotTypes=Part[mixTypes,aliquotIndices];

			(* Put our types and indices together. *)
			typesAndIndices=Transpose[{aliquotTypes,aliquotIndices}];

			(* Group by mix type. *)
			groupedTypesAndIndices=Values[GroupBy[typesAndIndices,#[[1]]&]];

			(* Resolve per mix type. *)
			(* This variable is in the form {{aliquotContainer,instrument,index}..}. *)
			aliquotContainersAndInstruments=Flatten[Module[{mixType,instrumentContainerInformation,sortedInstruments,chosenInstrument,allowedContainers,plateInList,chosenContainer,resolvedRate,instrumentPacket},
				(* aliquotInformation is in the form {{type, index}..} where index corresponds to the index of potentialAliquotContainersList. *)
				Function[{aliquotInformation},
					(* What type are we dealing with? *)
					mixType=aliquotInformation[[1]][[1]];

					(* Switch based off of this mix type. *)
					Switch[mixType,
						Invert|Pipette,
							(* We can choose any container to invert since it's by an indivial container basis. *)
							(* potentialAliquotContainers is ordered from smallest to largest so take the first. *)
							({First[potentialAliquotContainersList[[#]]],Null,Null,#}&)/@aliquotInformation[[All,2]],
						Vortex|Shake|Roll|Stir|Sonicate|Homogenize,
							(* We want to try to maximize similar instruments and then maximize similar containers. *)

							(* Get the potentialAliquotContainer information for each of our samples. *)
							(* This is in the format {{Instrument\[Rule]Containers,..}..}. *)
							instrumentContainerInformation=potentialAliquotContainersList[[aliquotInformation[[All,2]]]];

							(* Get all of the instruments from this list and sort them by the number of times they occur (from max to min). *)
							sortedInstruments=SortBy[Tally[Cases[instrumentContainerInformation,ObjectP[Model[Instrument]],Infinity]],-#[[2]]&][[All,1]];

							(* Since instruments will only show up once per sample, we can guarantee that greedily choosing instruments by this ordering will guarantee that instrument commonality is maximized. *)
							(* For each instrument container information, choose instruments by their order in sortedInstruments. Then choose the first container that appears in the list, giving preference to Plates. *)
							MapThread[Function[{instrumentInformation,index},
								(* Pick the first instrument from sortedInstruments (already ordered from max to min occurance) that is allowed for this sample. *)
								chosenInstrument=FirstCase[sortedInstruments,Alternatives@@(First/@instrumentInformation)];

								(* Lookup the containers that go with this instrument. *)
								allowedContainers=Lookup[instrumentInformation,chosenInstrument];

								(* Is there a plate in this list? *)
								plateInList=FirstCase[allowedContainers,ObjectP[Model[Container,Plate]],Null];

								(* Favor plates over vessels. *)
								chosenContainer=If[MatchQ[plateInList,Except[Null]],
									plateInList,
									(* Otherwise, choose the first container. *)
									First[allowedContainers]
								];

								(* Do we have a rate defined for this index? *)
								(* If not, we may need to resolve rate, depending on our chosen instrument. *)
								resolvedRate=If[MatchQ[rates[[index]],Automatic],
									(* Resolve to the average RPM of the set instrument. *)
									instrumentPacket = If[MatchQ[chosenInstrument, ObjectP[Object[Instrument]]],
										fastAssocPacketLookup[fastAssoc, chosenInstrument, Model],
										fetchPacketFromFastAssoc[chosenInstrument, fastAssoc]
									];

									(* Get the instrument rates. *)
									instrumentRates=Lookup[instrumentPacket,{MinRotationRate,MaxRotationRate},Null]/.$Failed->Null;

									(* Does this instrument need a rate? *)
									Which[
										MatchQ[mixType,Sonicate],
											Null,
										(* Are we stirring? *)
										MatchQ[mixType,Stir],
										(* Use 20% of its max stir rate*)
											Round[0.2*(instrumentRates[[2]]/.Null->1000RPM),1RPM],
										True,
										(* Round to the nearest RPM. *)
											Round[Mean[instrumentRates],1RPM]
									],
									(* MixRate isn't automatic. Go with the user supplied value. *)
									rates[[index]]
								];

								(* Return this information. *)
								{chosenContainer,chosenInstrument,resolvedRate,index}
							],{instrumentContainerInformation,aliquotInformation[[All,2]]}],
						_,
							Nothing
					]
				]/@groupedTypesAndIndices
			],1];

			(* Now put our result in-place with the samples that didn't need aliquoting. *)
			(* Loop over our indices, either using the pre-resolved values or our new computed values. *)
			resolvedContainersAndInstruments=Function[{index},
				(* Try to find the aliquot information. *)
				aliquotInformation=FirstCase[aliquotContainersAndInstruments,{_,_,_,index},Null];

				(* Were we able to find it? *)
				If[MatchQ[aliquotInformation,Null],
					(* Use pre-resolved values. *)
					{Null,instruments[[index]],rates[[index]]},
					(* Use aliquot values. *)
					{aliquotInformation[[1]],aliquotInformation[[2]],aliquotInformation[[3]]}
				]
			]/@Range[Length[mySimulatedSamples]];

			(* Transpose our result. *)
			Transpose[resolvedContainersAndInstruments]
		]
	];

	specifiedAliquotOptions=Lookup[myOptions,{Aliquot,ConsolidateAliquots,AliquotPreparation,AliquotSampleLabel,AliquotAmount,TargetConcentration,TargetConcentrationAnalyte,AssayVolume,AliquotContainer,DestinationWell,ConcentratedBuffer,BufferDilutionFactor,BufferDiluent,AssayBuffer,AliquotSampleStorageCondition}];
	shortcircuitAliquotQ=MatchQ[First[specifiedAliquotOptions], {False..}]&&MatchQ[Flatten[Rest[specifiedAliquotOptions]], {(Null|Automatic)..}];
	numberSimulatedSamples=Length[mySimulatedSamples];



	(* Resolve our aliquot options with our computed information. *)
	{resolvedAliquotOptions, aliquotTests} = Which[
		(* Null out everything if robotic *)
		MatchQ[resolvedPreparation,Robotic],
			{
				{
					Aliquot->ConstantArray[False,numberSimulatedSamples],
					AliquotSampleLabel->ConstantArray[Null,numberSimulatedSamples],
					AliquotAmount->ConstantArray[Null,numberSimulatedSamples],
					TargetConcentration->ConstantArray[Null,numberSimulatedSamples],
					TargetConcentrationAnalyte->ConstantArray[Null,numberSimulatedSamples],
					AssayVolume->ConstantArray[Null,numberSimulatedSamples],
					AliquotContainer->ConstantArray[Null,numberSimulatedSamples],
					DestinationWell->ConstantArray[Null,numberSimulatedSamples],
					ConcentratedBuffer->ConstantArray[Null,numberSimulatedSamples],
					BufferDilutionFactor->ConstantArray[Null,numberSimulatedSamples],
					BufferDiluent->ConstantArray[Null,numberSimulatedSamples],
					AssayBuffer->ConstantArray[Null,numberSimulatedSamples],
					AliquotSampleStorageCondition->ConstantArray[Null,numberSimulatedSamples],
					ConsolidateAliquots->Null,
					AliquotPreparation->Null
				},
				{}
			},

		(* SPEED: Directly resolve everything to False and Null if Aliquot is False and everything else is either Automatic or Null *)
		shortcircuitAliquotQ,
			{
				{
					Aliquot->ConstantArray[False,numberSimulatedSamples],
					AliquotSampleLabel->ConstantArray[Null,numberSimulatedSamples],
					AliquotAmount->ConstantArray[Null,numberSimulatedSamples],
					TargetConcentration->ConstantArray[Null,numberSimulatedSamples],
					TargetConcentrationAnalyte->ConstantArray[Null,numberSimulatedSamples],
					AssayVolume->ConstantArray[Null,numberSimulatedSamples],
					AliquotContainer->ConstantArray[Null,numberSimulatedSamples],
					DestinationWell->ConstantArray[Null,numberSimulatedSamples],
					ConcentratedBuffer->ConstantArray[Null,numberSimulatedSamples],
					BufferDilutionFactor->ConstantArray[Null,numberSimulatedSamples],
					BufferDiluent->ConstantArray[Null,numberSimulatedSamples],
					AssayBuffer->ConstantArray[Null,numberSimulatedSamples],
					AliquotSampleStorageCondition->ConstantArray[Null,numberSimulatedSamples],
					ConsolidateAliquots->Null,
					AliquotPreparation->Null
				},
				{}
			},

		(*ELSE: go through resolveAliquotOptions *)
		True,
		If[gatherTests,
		resolveAliquotOptions[
			experimentFunction,
			mySamples,
			mySimulatedSamples,
			ReplaceRule[myOptions, resolvedSamplePrepOptions],
			AllowSolids->True,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->Null,
			AliquotWarningMessage->"because the incubation/mixing instruments chosen do not support the current sample's containers. Please choose different mix types or instruments if an aliquot is not desired. Use the function IncubateDevices/MixDevices to see the instruments that are compatbile with each sample.",
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				experimentFunction,
				mySamples,
				mySimulatedSamples,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				AllowSolids->True,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				RequiredAliquotContainers->targetContainers,
				RequiredAliquotAmounts->Null,
				AliquotWarningMessage->"because the incubation/mixing instruments chosen do not support the current sample's containers. Please choose different mix types or instruments if an aliquot is not desired. Use the function IncubateDevices/MixDevices to see the instruments that are compatbile with each sample."
			],
			{}
		}
	]];


	(* Make sure that if we're using the homogenizer, if we're using the smaller probe tips, the amplitude isn't set above 70 Percent (this can damage the probe tips). *)
	sonicationHornAmplitudeMismatchInputs=MapThread[
		Function[{type,instrument,amplitude,sample,targetContainer},
			(* Are we mixing by Homogenization? *)
			If[MatchQ[type,Homogenize],
				(* Get the sonication horn that we're going to use. *)
				(* Give the container the sample will be in if we are going to aliquot. *)
				sonicationHorn=If[MatchQ[targetContainer,Except[Null]],
					compatibleSonicationHorn[targetContainer,instrument,Cache->cacheBall,Simulation->updatedSimulation],
					compatibleSonicationHorn[sample,instrument,Cache->cacheBall,Simulation->updatedSimulation]
				];

				(* If the sonication horn is not the large one, amplitude must be under 70%. *)
				If[MatchQ[sonicationHorn,Except[ObjectP[Model[Part, SonicationHorn, "id:WNa4ZjKzw8p4"]]]]&&MatchQ[amplitude,GreaterP[70 Percent]],
					sample,
					Nothing
				],
				Nothing
			]
		],
		{
			mixTypes,
			resolvedInstruments,
			amplitudes,
			mySimulatedSamples,
			targetContainers
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	sonicationHornAmplitudeInvalidOptions=If[Length[sonicationHornAmplitudeMismatchInputs]>0&&!gatherTests,
		Message[Error::MixAmplitudeTooHigh,ObjectToString[sonicationHornAmplitudeMismatchInputs,Cache->cacheBall]];
		{Amplitude},
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	sonicationHornAmplitudeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,sonicationHornAmplitudeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have a valid Amplitude that is compatible with the Homogenizer instrument, if mixing by homogenization "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) have a valid Amplitude that is compatible with the Homogenizer instrument, if mixing by homogenization "<>ObjectToString[typeMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* If we are given a temperature profile, make sure time in the profile monotonically increases and does not exceed max time *)
	invalidTemperatureProfileResult=MapThread[
		Function[{sample,temperatureProfile,time,maxTime},
			If[!MatchQ[temperatureProfile,_List]||Length[temperatureProfile]==0,
				Nothing,
				Module[{allTimes,sortedTimes,actualMaxTime},
					allTimes=temperatureProfile[[All,1]];
					sortedTimes=Sort[allTimes];
					actualMaxTime=Which[
						MatchQ[maxTime,TimeP], maxTime,
						MatchQ[time,TimeP], time,
						True, 0 Second
					];

					If[Or[
						allTimes!=sortedTimes,
						!MatchQ[Last[sortedTimes],LessEqualP[actualMaxTime]],
						Length[allTimes]>50
					],
						{sample,temperatureProfile,actualMaxTime},
						Nothing
					]
				]
			]
		],
		{
			mySimulatedSamples,
			temperatureProfiles,
			times,
			maxTimes
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	temperatureProfileInvalidOptions=If[Length[invalidTemperatureProfileResult]>0&&!gatherTests,
		Message[
			Error::InvalidTemperatureProfile,
			ObjectToString[invalidTemperatureProfileResult[[All,1]],Cache->cacheBall],
			invalidTemperatureProfileResult[[All,2]],
			invalidTemperatureProfileResult[[All,3]]
		];
		{TemperatureProfile},
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	temperatureProfileTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,invalidTemperatureProfileResult[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have a valid TemperatureProfile option, if specified, "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) have a valid TemperatureProfile option, if specified, "<>ObjectToString[invalidTemperatureProfileResult[[All,1]],Cache->cacheBall]<>":",True,False],
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

	(* Make sure that if we're given a temperature profile, the times have to be monotonically increasing and can't exceed our max time. *)
	invalidMixRateProfileResult=MapThread[
		Function[{sample, mixRateProfile, time, maxTime},
			If[
				Or[!MatchQ[mixRateProfile, _List],Length[mixRateProfile]==0],
				Nothing,
				Module[{allTimes, sortedTimes, actualMaxTime},
					allTimes=mixRateProfile[[All,1]];
					sortedTimes=Sort[allTimes];
					actualMaxTime=Which[
						MatchQ[maxTime,TimeP],
							maxTime,
						MatchQ[time, TimeP],
							time,
						True,
							0 Second
					];

					If[Or[
						allTimes!=sortedTimes,
						!MatchQ[Last[sortedTimes], LessEqualP[actualMaxTime]]
					],
						{sample, mixRateProfile, actualMaxTime},
						Nothing
					]
				]
			]
		],
		{
			mySimulatedSamples,
			mixRateProfiles,
			times,
			maxTimes
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	mixRateProfileInvalidOptions=If[Length[invalidMixRateProfileResult]>0&&!gatherTests,
		Message[
			Error::InvalidMixRateProfile,
			ObjectToString[invalidMixRateProfileResult[[All,1]],Cache->cacheBall],
			invalidMixRateProfileResult[[All,2]],
			invalidMixRateProfileResult[[All,3]]
		];
		{MixRateProfile},
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	mixRateProfileTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,invalidMixRateProfileResult[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have a valid MixRateProfile option, if specified, "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) have a valid MixRateProfile option, if specified, "<>ObjectToString[invalidMixRateProfileResult[[All,1]],Cache->cacheBall]<>":",True,False],
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

	(* Make sure that if we're given the MixRateProfile/TemperatureProfile option, the MixRate and Temperature options cannot be specified, respectively. *)
	conflictingProfileResult=MapThread[
		Function[{sample, mixRateProfile, temperatureProfile, temperature, mixRate},
			Sequence@@{
				If[MatchQ[mixRateProfile, _List] && !NullQ[mixRateProfile] && MatchQ[mixRate, RPMP],
					{sample, MixRateProfile, mixRateProfile, MixRate, mixRate},
					Nothing
				],
				If[MatchQ[temperatureProfile, _List] && MatchQ[temperature, TemperatureP],
					{sample, TemperatureProfile, temperatureProfile, Temperature, temperature},
					Nothing
				]
			}
		],
		{
			mySimulatedSamples,
			mixRateProfiles,
			temperatureProfiles,
			temperatures,
			rates
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	conflictingProfileInvalidOptions=If[Length[conflictingProfileResult]>0&&!gatherTests,
		Message[
			Error::ConflictingProfileResults,
			ObjectToString[conflictingProfileResult[[All,1]],Cache->cacheBall],
			conflictingProfileResult[[All,2]],
			conflictingProfileResult[[All,3]],
			conflictingProfileResult[[All,4]],
			conflictingProfileResult[[All,5]]
		];
		DeleteDuplicates[Flatten[{conflictingProfileResult[[All,2]], conflictingProfileResult[[All,4]]}]],
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	conflictingProfileTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,conflictingProfileResult[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) do not have conflicting TemperatureProfile/Temperature or MixRateProfile/MixRate options, if specified, "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) do not have conflicting TemperatureProfile/Temperature or MixRateProfile/MixRate options, if specified, "<>ObjectToString[conflictingProfileResult[[All,1]],Cache->cacheBall]<>":",True,False],
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

	(* If given a stir bar, make sure that the stir bar can actually fit in the container that we have. *)
	stirBarTooBigResult=MapThread[
		Function[{sample, targetContainer, stirBar},
			If[MatchQ[stirBar, ObjectP[]],
				Module[{compatibleStirBarModels, givenStirBarModel},
					(* Get the compatible stir bar models. *)
					compatibleStirBarModels= If[MatchQ[targetContainer,ObjectP[Model[Container]]],
						(* If we are aliquoting to another container, use that container for compatibleStirBar*)
						compatibleStirBars[targetContainer, Cache->cacheBall],
						compatibleStirBars[sample, Cache->cacheBall]
					];

					(* If given an object, fetch the model. *)
					givenStirBarModel=If[MatchQ[stirBar, ObjectP[Object[Part]]],
						fastAssocLookup[fastAssoc, stirBar, {Model, Object}],
						stirBar
					];

					(* Make sure it's in our compatible list. *)
					If[!MemberQ[compatibleStirBarModels, ObjectP[givenStirBarModel]],
						{sample, stirBar},
						Nothing
					]
				],
				Nothing
			]
		],
		{
			mySimulatedSamples,
			targetContainers,
			stirBars
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	stirBarTooBigInvalidOptions=If[Length[stirBarTooBigResult]>0&&!gatherTests,
		Message[
			Error::StirBarTooBig,
			ObjectToString[stirBarTooBigResult[[All,1]],Cache->cacheBall],
			ObjectToString[stirBarTooBigResult[[All,2]],Cache->cacheBall]
		];
		{StirBar},
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	stirBarTooBigTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,stirBarTooBigResult[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) are in containers that are compatible with the provided StirBars "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) are in containers that are compatible with the provided StirBars "<>ObjectToString[stirBarTooBigResult[[All,1]],Cache->cacheBall]<>":",True,False],
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

	(* LightExposureIntensity must match the units of the LightExposure. *)
	lightExposureIntensityResult=MapThread[
		Function[{sample, lightExposureIntensity, lightExposure},
			Which[
				MatchQ[lightExposure, UVLight] && !MatchQ[lightExposureIntensity, GreaterP[0 (Watt/(Meter^2))]],
					{sample, lightExposureIntensity, lightExposure},
				MatchQ[lightExposure, VisibleLight] && !MatchQ[lightExposureIntensity, GreaterP[0 (Lumen/(Meter^2))]],
					{sample, lightExposureIntensity, lightExposure},
				MatchQ[lightExposure, Null] && !MatchQ[lightExposureIntensity, Null],
					{sample, lightExposureIntensity, lightExposure},
				True,
					Nothing
			]
		],
		{
			mySimulatedSamples,
			lightExposureIntensities,
			lightExposures
		}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	lightExposureIntensityInvalidOptions=If[Length[lightExposureIntensityResult]>0&&!gatherTests,
		Message[
			Error::ConflictingLightExposureIntensity,
			ObjectToString[lightExposureIntensityResult[[All,1]],Cache->cacheBall],
			ObjectToString[lightExposureIntensityResult[[All,2]]],
			lightExposureIntensityResult[[All,3]]
		];
		{LightExposure, LightExposureIntensity},
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	lightExposureIntensityTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,lightExposureIntensityResult[[All,1]]];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have a LightExposure that matches the units of LightExposureIntensity "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) have a LightExposure that matches the units of LightExposureIntensity "<>ObjectToString[lightExposureIntensityResult[[All,1]],Cache->cacheBall]<>":",True,False],
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

	(* Final check to make sure everything is compatible. *)
	(* Make sure that we don't have incorrect options set, based on the MixType. *)
	typeOptionMismatches=MapThread[
		Function[{type,mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,volume,temperature,annealingTime,residualIncubation,residualTemperature,residualMix,residualMixRate,amplitude,maxTemperature,dutyCycle,relativeHumidity,transform,preSonicationTime,sample},
			Module[{mustBeSpecifiedOptions,cannotBeSpecifiedOptions,specifiedOptionsBooleans,specifiedOptions,notSpecifiedOptions,incorrectlySpecifiedOptions},
				(* Switch based on type. *)
				{mustBeSpecifiedOptions,cannotBeSpecifiedOptions}=Switch[type,
					Invert,
						{{NumberOfMixes},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,Instrument,Time,MaxTime,MixRate,MixVolume,Temperature,AnnealingTime,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Pipette,
						{{MixVolume,NumberOfMixes},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,Time,MaxTime,MixRate,Temperature,AnnealingTime,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Swirl,
						{{NumberOfMixes},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,Instrument,Time,MaxTime,MixRate,MixVolume,Temperature,AnnealingTime,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Vortex,
						{{MixRate,Time},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Roll,
						{{MixRate,Time},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Shake,
						{{Time},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,MixVolume,NumberOfMixes,MaxNumberOfMixes,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Disrupt,
						{{MixRate,Time},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Nutate,
						{{MixRate,Time},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Stir,
						{{MixRate,Time},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,TemperatureProfile,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,Amplitude,MaxTemperature,DutyCycle,PreSonicationTime}},
					Sonicate,
						{{Time,PreSonicationTime},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,MixRate,MixVolume,NumberOfMixes,MaxNumberOfMixes}},
					Homogenize,
						{{Time,Amplitude},{RelativeHumidity,LightExposure,LightExposureIntensity,TotalLightExposure,LightExposureStandard,StirBar,TemperatureProfile,MixRateProfile,MixRate,MixVolume,NumberOfMixes,MaxNumberOfMixes,PreSonicationTime}},
					Null,
						Which[
							TrueQ[transform],
								{{},{StirBar,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,MaxTime,MixUntilDissolved,PreSonicationTime}},
							MatchQ[instrument, ObjectP[{Model[Instrument, EnvironmentalChamber], Object[Instrument, EnvironmentalChamber]}]],
								{{Time,Instrument,RelativeHumidity},{StirBar,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,MaxTime,MixUntilDissolved,PreSonicationTime}},
							True,
								{{Time,Instrument},{StirBar,MixRateProfile,MixVolume,NumberOfMixes,MaxNumberOfMixes,MaxTime,MixUntilDissolved,PreSonicationTime}}
						],
					_,
						{{},{}}
				];

				(* Create a filter mask for the options that were specified. *)
				specifiedOptionsBooleans=(MatchQ[#,Except[Null|False|AmbientTemperatureP]]&)/@{type,mixUntilDissolved,instrument,time,maxTime,rate,numberOfMixes,maxNumberOfMixes,volume,temperature,annealingTime,residualIncubation,residualTemperature,residualMix,residualMixRate,amplitude,maxTemperature,dutyCycle,relativeHumidity,preSonicationTime};

				(* Filter our options based on this mask. *)
				specifiedOptions=PickList[{MixType,MixUntilDissolved,Instrument,Time,MaxTime,MixRate,NumberOfMixes,MaxNumberOfMixes,MixVolume,Temperature,AnnealingTime,ResidualIncubation,ResidualTemperature,ResidualMix,ResidualMixRate,Amplitude,MaxTemperature,DutyCycle,RelativeHumidity, PreSonicationTime},specifiedOptionsBooleans];

				(* Make sure that all of our must be specified options are actually specified. *)
				notSpecifiedOptions=Complement[mustBeSpecifiedOptions,specifiedOptions];

				(* Make sure that all of our cannot be specified options are not specified. *)
				incorrectlySpecifiedOptions=Intersection[cannotBeSpecifiedOptions,specifiedOptions];

				(* If either of these two lists has elements, we have to throw an error. *)
				If[Length[notSpecifiedOptions]>0||Length[incorrectlySpecifiedOptions]>0,
					{{type,notSpecifiedOptions,incorrectlySpecifiedOptions},sample},
					Nothing
				]
			]
		],
		{
			mixTypes,
			mixUntilDissolvedList,
			resolvedInstruments,
			times,
			maxTimes,
			resolvedRates,
			numberOfMixesList,
			maxNumberOfMixesList,
			volumes,
			temperatures,
			annealingTimes,
			residualIncubationList,
			residualTemperatures,
			residualMixes,
			residualMixRates,
			amplitudes,
			maxTemperatures,
			dutyCycles,
			relativeHumidities,
			transforms,
			preSonicationTimes,
			mySimulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{typeMismatchOptions,typeMismatchInputs}=If[MatchQ[typeOptionMismatches,{}],
		{{},{}},
		Transpose[typeOptionMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeMismatchInvalidOptions=If[Length[typeMismatchOptions]>0&&!gatherTests,
		Message[Error::MixTypeIncorrectOptions,ObjectToString[typeMismatchInputs,Cache->cacheBall],typeMismatchOptions[[All,1]]/.{Null->"Null (Incubate Only)"},typeMismatchOptions[[All,2]],typeMismatchOptions[[All,3]]];
		Flatten[{MixType,typeMismatchOptions[[All,2]],typeMismatchOptions[[All,3]]}],
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	typeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,typeMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) have the correct options specified, based on the resolved MixType "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) have the correct options specified, based on the resolved MixType "<>ObjectToString[typeMismatchInputs,Cache->cacheBall]<>":",True,False],
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

	(* Make sure that if DeviceChannel -> MultiProbeHead that we have 96 samples to mix, they're in the same plate, *)
	(* and they're in wells A1-H12 (or a subset of 384). *)
	multiProbeHeadInvalidSamples=Module[{sorted96Wells, sorted384Wells1, sorted384Wells2, sorted384Wells3, sorted384Wells4},
		sorted96Wells = Sort[Flatten[AllWells[]]];
		sorted384Wells1 = Sort[Flatten[#[[;;;;2]] &/@AllWells[NumberOfWells->384][[;;;;2]]]];
		sorted384Wells2 = Sort[Flatten[#[[;;;;2]] &/@AllWells[NumberOfWells->384][[2;;;;2]]]];
		sorted384Wells3 = Sort[Flatten[#[[2;;;;2]] &/@AllWells[NumberOfWells->384][[;;;;2]]]];
		sorted384Wells4 = Sort[Flatten[#[[2;;;;2]] &/@AllWells[NumberOfWells->384][[2;;;;2]]]];

		Map[
			Function[{group},
				Module[{samples, packets, deviceChannels, multichannelMixNames},
					{samples, deviceChannels, multichannelMixNames} = Transpose[group];

					packets = fetchPacketFromFastAssoc[samples, fastAssoc];

					If[And[
							MatchQ[deviceChannels, {MultiProbeHead..}],
							Or[
								Length[packets] != 96,
								!MatchQ[Sort[Lookup[packets, Position]], sorted96Wells | sorted384Wells1 | sorted384Wells2 | sorted384Wells3 | sorted384Wells4]
							]
						],
						Lookup[packets, Object],
						Nothing
					]
				]
			],
			SplitBy[
				Transpose[{
					mySimulatedSamples,
					resolvedDeviceChannel,
					resolvedMultichannelMixName
				}],
				(#[[3]]&)
			]
		]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	multiProbeHeadInvalidOptions=If[Length[multiProbeHeadInvalidSamples]>0&&!gatherTests,
		Message[Error::InvalidMultiProbeHeadMix,ObjectToString[multiProbeHeadInvalidSamples,Cache->cacheBall]];
		{DeviceChannel},
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	multiProbeHeadTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySimulatedSamples,multiProbeHeadInvalidSamples];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>" are not trying to use the 96-channel MultiProbeHead in an invalid format (the 96-channel head can only be used to mix entire plates of samples in a 96 well format or a subdivision of a 384 well format):",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[typeMismatchInputs]>0,
				Test["The following sample(s) "<>ObjectToString[typeMismatchInputs,Cache->cacheBall]<>" are not trying to use the 96-channel MultiProbeHead in an invalid format (the 96-channel head can only be used to mix entire plates of samples in a 96 well format or a subdivision of a 384 well format):",True,False],
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

	(* Resolve transform developer fields *)
	{
		transformRecoveryMedia,
		transformIncubator,
		transformIncubatorTemperatures,
		transformIncubatorShakingRates,
		transformRecoveryIncubationTimes,
		transformRecoveryTransferVolumes
	} = If[MatchQ[transforms, {True..}],
		Module[{expandLength, cellVolumes, cellContainerMaxVolumes, recoveryMediaVolumes, transferVolumes},
			expandLength = Length[mySamples];
			cellVolumes = mySamples[Volume];
			cellContainerMaxVolumes = mySamples[Container][Model][MaxVolume];
			recoveryMediaVolumes = ToList[Lookup[myOptions, TransformRecoveryMedia]][Volume];

			transferVolumes = MapThread[Function[{cellVolume, cellContainerMaxVolume, recoveryMediaVolume},
				Module[{initialTransferVolume},
					{
						(* Volume of the initial transfer of recovery media to the heat shocked cells is computed to prevent container overflow or insufficient volume *)
						initialTransferVolume = Min[Round[(cellContainerMaxVolume - cellVolume)/4, 100 Microliter], Round[recoveryMediaVolume/4, 100 Microliter]],
						(* Volume of the secondary transfer; currently only using P1000 micropipette for both transfers, so lose resolution *)
						Ceiling[initialTransferVolume + cellVolume, 100 Microliter]
					}
				]],
				{cellVolumes, cellContainerMaxVolumes, recoveryMediaVolumes}
			];

			(* fixed options; bacterial shaking incubation *)
			{
				Lookup[myOptions, TransformRecoveryMedia], (* Guaranteed to be objects *)
				Link@Model[Instrument, Incubator, "Innova 44 for Bacterial Plates"],
				37 Celsius,
				200 RPM,
				1 Hour,
				transferVolumes
			}
		],
		ConstantArray[Null, 6]
	];

	(* -- MESSAGE AND RETURN --*)

	(* --- Resolve Post Processing Options --- *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[ReplaceRule[myOptions, Simulation -> simulation]];

	(* Get the resolved Email option; for this experiment, the default is True *)
	email=If[MatchQ[Lookup[myOptions, Email], Automatic],
		True,
		Lookup[myOptions, Email]
	];

	(* Get the rest of our options directly from SafeOptions. *)
	{confirm, canaryBranch, template, samplesInStorageCondition, samplePreparation, cache, fastTrack, operator, parentProtocol, upload, outputOption} = Lookup[myOptions, {Confirm, CanaryBranch, Template, SamplesInStorageCondition, PreparatoryUnitOperations, Cache, FastTrack, Operator, ParentProtocol, Upload, Output}];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs, maxSafeMixRatesMissingInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[
		{
			instrumentTypeInvalidOptions,rateTypeInvalidOptions,typeNumberOfMixesInvalidOptions,invertVolumeInvalidOptions,invertContainerInvalidOptions,
			maxMixUntilDissolvedInvalidOptions,vortexIncompatibleInstrumentInvalidOptions,vortexNoInstrumentForRateInvalidOptions,vortexNoInstrumentInvalidOptions,
			rollIncompatibleInstrumentInvalidOptions,rollNoInstrumentInvalidOptions,shakeIncompatibleInstrumentInvalidOptions,shakeNoInstrumentInvalidOptions,residualIncubationIncompatibleInvalidOptions,
			stirNoStirBarOrImpellerInvalidOptions, stirIncompatibleInstrumentInvalidOptions,stirNoInstrumentInvalidOptions,sonicateIncompatibleInstrumentInvalidOptions,sonicateNoInstrumentInvalidOptions,
			typeAndIncubationInvalidOptions,incubateInvalidOptions,generalInvalidOptions,instrumentInvalidOptions,
			nameInvalidOptions,typeMismatchInvalidOptions,multiProbeHeadInvalidOptions,thawInvalidOptions,thawNoInstrumentInvalidOptions,thawIncompatibleInstrumentInvalidOptions,
			maxTemperatureInvalidOptions,homogenizeIncompatibleInstrumentInvalidOptions,homogenizeNoInstrumentInvalidOptions,
			nutateNoInstrumentInvalidOptions, nutateIncompatibleInstrumentInvalidOptions, disruptNoInstrumentInvalidOptions, disruptNoInstrumentForRateInvalidOptions,
			disruptIncompatibleInstrumentInvalidOptions, sonicationHornAmplitudeInvalidOptions, temperatureProfileInvalidOptions, mixRateProfileInvalidOptions,
			conflictingProfileInvalidOptions, stirBarTooBigInvalidOptions, lightExposureIntensityInvalidOptions,
			invalidZeroCorrectionOptions,transformNonTransformInvalidOptions,transformInvalidOptions,transformIncompatibleInstrumentOptions, safeMixRateInvalidOptions,
			transformIncompatibleContainerOptions, volumetricFlaskMixInvalidOptions,volumetricFlaskMixRateInvalidOptions,
			If[MatchQ[preparationResult, $Failed],
				{Preparation},
				Nothing
			]
		}
	]];

	If[Length[invalidInputs]>0 && MatchQ[gatherTests, False],
		Message[Error::InvalidInput,invalidInputs]
	];

	If[Length[invalidOptions]>0 && MatchQ[gatherTests, False],
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Return our resolved options. *)
	outputSpecification/.{
		Result -> ReplaceRule[
			myOptions,
			Flatten[{
				{
					SampleLabel->Flatten@sampleLabels,
					SampleContainerLabel->Flatten@sampleContainerLabels,
					Preparation->resolvedPreparation,
					Thaw->thaws,
					ThawTime->thawTimes,
					MaxThawTime->maxThawTimes,
					ThawTemperature->thawTemperatures,
					ThawInstrument->thawInstruments,
					Mix->mixBooleans,
					MixType->mixTypes,
					MixUntilDissolved->mixUntilDissolvedList,
					Instrument->Flatten@resolvedInstruments,
					Time->times,
					MaxTime->maxTimes,
					DutyCycle->dutyCycles,
					MixRate->resolvedRates,
					Amplitude->amplitudes,
					NumberOfMixes->numberOfMixesList,
					MaxNumberOfMixes->maxNumberOfMixesList,
					MixVolume->volumes,
					Temperature->temperatures,
					MaxTemperature->maxTemperatures,
					RelativeHumidity->relativeHumidities,
					LightExposure->lightExposures,
					LightExposureIntensity->lightExposureIntensities,
					TotalLightExposure->totalLightExposures,
					LightExposureStandard->Lookup[myOptions, LightExposureStandard],
					AnnealingTime->annealingTimes,
					ResidualIncubation->residualIncubationList,
					StirBar->stirBars,
					MixRateProfile->mixRateProfiles,
					TemperatureProfile->temperatureProfiles,
					OscillationAngle->oscillationAngles,
					ResidualTemperature->residualTemperatures,
					ResidualMix->residualMixes,
					ResidualMixRate->residualMixRates,
					Preheat->preheatList,
					MixPosition->mixPositions,
					MixPositionOffset->mixPositionOffsets,
					MixTiltAngle->Lookup[myOptions, MixTiltAngle],
					MixFlowRate->mixFlowRates,
					CorrectionCurve->correctionCurves,
					Tips->tipss,
					TipType->tipTypes,
					TipMaterial->tipMaterials,
					WorkCell->workCell,
					MultichannelMix->resolvedMultichannelMix,
					MultichannelMixName->resolvedMultichannelMixName,
					DeviceChannel->resolvedDeviceChannel,
					Transform->transforms,
					TransformHeatShockTemperature->transformHeatShockTemperatures,
					TransformHeatShockTime->transformHeatShockTimes,
					TransformPreHeatCoolingTime->transformPreHeatCoolingTimes,
					TransformPostHeatCoolingTime->transformPostHeatCoolingTimes,
					TransformRecoveryMedia -> transformRecoveryMedia,
					TransformIncubator -> transformIncubator,
					TransformIncubatorTemperature -> transformIncubatorTemperatures,
					TransformIncubatorShakingRate -> transformIncubatorShakingRates,
					TransformRecoveryIncubationTime -> transformRecoveryIncubationTimes,
					TransformRecoveryTransferVolumes -> transformRecoveryTransferVolumes,
					PreSonicationTime -> preSonicationTimes,
					AlternateInstruments -> samplesAlternateInstruments,
					Email->email,
					Confirm->confirm,
					CanaryBranch->canaryBranch,
					Template->template,
					SamplesInStorageCondition->samplesInStorageCondition,
					PreparatoryUnitOperations->samplePreparation,
					Cache->cache,
					Simulation->updatedSimulation,
					FastTrack->fastTrack,
					Operator->operator,
					ParentProtocol->parentProtocol,
					Upload->upload,
					Output->outputOption,
					Name->Lookup[myOptions, Name],
					ExperimentFunction->experimentFunction
				},
				resolvedSamplePrepOptions,
				resolvedAliquotOptions,
				resolvedPostProcessingOptions
			}]
		],
		Tests -> Flatten[{
			samplePrepTests,discardedTest,mixTypeTest,precisionTests,rateTypeTest,typeNumberOfMixesTest,typeAndVolumeTest,invertVolumeTest,
			invertContainerTest,pipetteMixNoVolumeTest,maxMixUntilDissolvedTest,vortexIncompatibleInstrumentTest,vortexNoInstrumentForRateTest,vortexNoInstrumentTest,
			rollIncompatibleInstrumentTest,rollNoInstrumentTest,shakeIncompatibleInstrumentTest,shakeNoInstrumentTest,residualIncubationIncompatibleTests,stirNoStirBarOrImpellerTest, stirIncompatibleInstrumentTest,stirNoInstrumentTest,
			sonicateIncompatibleInstrumentTest,sonicateNoInstrumentTest,typeAndIncubationTest,incubateTest,generalTest,homogenizeIncompatibleInstrumentTest,homogenizeNoInstrumentTest,
			instrumentTest,volumeTest,typeTest,multiProbeHeadTest,validNameTest,thawTest,thawNoInstrumentTest,thawIncompatibleInstrumentTest,maxTemperatureTest,aliquotTests,
			sonicationHornAmplitudeTest,disruptNoInstrumentTest,disruptNoInstrumentForRateTest,disruptIncompatibleInstrumentTest,
			nutateNoInstrumentTest, nutateIncompatibleInstrumentTest,temperatureProfileTest,mixRateProfileTest,conflictingProfileTest, stirBarTooBigTest,
			lightExposureIntensityTest,monotonicCorrectionCurveTest,incompleteCorrectionCurveTest,invalidZeroCorrectionTest,transformNonTransformTest,transformTest, safeMixRateTest,
			transformIncompatibleInstrumentTest,transformIncompatibleContainerTest, maxSafeMixRatesMissingTest, volumetricFlaskMixTest, volumetricFlaskMixRateTest
		}]
	}
];


(* ::Subsection::Closed:: *)
(*Resource Packets*)


DefineOptions[incubateNewResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


incubateNewResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{experimentFunction,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,cache,simulatedSamples,mixTypes,mapThreadFriendlyOptions,originalSampleObjects,sampleObjects,groupedSamples,
	protocolFields,mixType,samples,options,thawFields,thawParameters,
	simulatedContainers,sampleGroupingIndices,sampleGroupingLengths,estimatedThawTime,estimatedMixTime,multiIncubateFields,
	transformCoolerResource,transformCoolerPowerCableLink, transformBiosafetyCabinetResource, transformBiosafetyWasteBinResource, transformBiosafetyWasteBagResource, transformRecoveryPipetteResource, transformRecoveryTipResources, transformRecoveryMediaResources,
		result,allResourceBlobs,fulfillable,frqTests,messages,simulation,updatedSimulation,samplePackets,containerPackets,containerModelPackets,preparation,
		sampleLabelResources,sampleContainerLabelResources,instrumentResources,tipResources,unitOperationPacket,unitOperationPacketWithLabeledObjects,mySamplePackets,
	previewRule,optionsRule,testsRule,resultRule,rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,protocolPacket, unitOperationPackets,handlingEnvironmentResource,fastAssoc},

	(* get the experiment function *)
	experimentFunction=Lookup[myResolvedOptions,ExperimentFunction];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentIncubate,
		RemoveHiddenOptions[ExperimentIncubate,myResolvedOptions],
		Messages->False
	];

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* whenever we are not collecting tests, print messages instead *)
	messages = !gatherTests;

	(* look up the preparation *)
	preparation=Lookup[ToList[myResolvedOptions],Preparation];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myOptions],Cache];
	simulation=Lookup[ToList[myOptions],Simulation];

	(* Get rid of the links in mySamples. *)
	originalSampleObjects=Download[mySamples,Object];

	(* Get our simulated samples (we have to figure out sample groupings here). *)
	{simulatedSamples,updatedSimulation}=simulateSamplesResourcePacketsNew[experimentFunction,originalSampleObjects,myResolvedOptions,Cache->cache,Simulation->simulation];
	(* Convert our options into a MapThread friendly version. *)
	(* This will now be index-matched to mySamples. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[experimentFunction,myResolvedOptions/.{Ambient->$AmbientTemperature}];

	(* Download information from our simulated samples. *)
	{samplePackets, containerPackets, containerModelPackets}=Transpose@Download[
		simulatedSamples,
		{
			Packet[Container],
			Packet[Container[{Model}]],
			Packet[Container[Model[{Dimensions}]]]
		},
		Cache->cache,
		Simulation->updatedSimulation
	];

	mySamplePackets=samplePackets[[All,1]];

	sampleObjects=Lookup[samplePackets, Object];

	(* Flatten our simulated information so that we can fetch it from cache. *)
	cache = FlattenCachePackets[{cache, samplePackets, containerPackets, containerModelPackets, transferModelPackets[{}]}];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Thread together out samples and index-matched options, then group by resolved mix type. *)
	groupedSamples=Normal[GroupBy[Transpose[{simulatedSamples,mapThreadFriendlyOptions}],(Lookup[#[[2]],MixType]&)]];

	(* Are we making resources for Manual or Robotic? *)
	{protocolPacket, unitOperationPackets}=If[
		MatchQ[preparation,Manual],

		(*-- Get the types of each of our instruments. --*)
		mixTypes=Lookup[myResolvedOptions,MixType];
		
		(* lets create one handling environment resource, we only need one resource that can be shared if we are inverting or swirling, otherwise, no need to create one at all *)
		handlingEnvironmentResource = If[MemberQ[mixTypes, Invert | Swirl],
			Module[{allAmbientHandlingStations, allAmbientHandlingStationsWithMixingZones},
				(* get all ambient handling stations from a memoized search *)
				allAmbientHandlingStations = Cases[transferModelsSearch["Memoization"][[23]], ObjectP[Model[Instrument, HandlingStation, Ambient]]];

				(* only include the handling stations which has a position called 'Mixing Zone Slot' *)
				allAmbientHandlingStationsWithMixingZones = Select[
					allAmbientHandlingStations,
					MemberQ[fastAssocLookup[fastAssoc, #, Positions], KeyValuePattern[{Name -> "Mixing Zone Slot"}]]&
				];

				(* make one resource *)
				Resource[Instrument -> allAmbientHandlingStationsWithMixingZones, Time -> 5 Minute * Count[mixTypes, Invert | Swirl]]
			],
			Null
		];

		(* Loop over all of our samples and types. *)
		protocolFields=Flatten[Function[{groupedMixSamples},
			(* Get the mix type. *)
			mixType=groupedMixSamples[[1]];

			(* Get the threaded samples and mix options. *)
			samples=groupedMixSamples[[2]][[All,1]];
			options=groupedMixSamples[[2]][[All,2]];

			(* Switch based on mix type of these samples (or use transform escape hatch). *)
			Switch[mixType,
				Invert,
					(* We have to invert our samples, by hand, one by one. *)
					(* Therefore, no grouping is required. *)
					Module[{additionalMixes,invertParameters,samplesInPositions},
						(* Compute Additional mixes. *)
						additionalMixes=MapThread[(
							(* Are we mixing until dissolved? *)
							If[#1,
								(#3-#2),
								0
							]
						&),{Lookup[options,MixUntilDissolved],Lookup[options,NumberOfMixes],Lookup[options,MaxNumberOfMixes]}];

						(* Transpose our information together. *)
						invertParameters=MapThread[
							Function[{numberOfMixes,maxNumberOfMixes,additionalNumberOfMixes,mixUntilDissolved},
								<|
									Sample->Null,
									NumberOfMixes->numberOfMixes,
									MaxNumberOfMixes->maxNumberOfMixes,
									AdditionalNumberOfMixes->additionalNumberOfMixes,
									MixUntilDissolved->mixUntilDissolved
								|>
							],
							{Lookup[options,NumberOfMixes],Lookup[options,MaxNumberOfMixes]/.{Null->0},additionalMixes,Lookup[options,MixUntilDissolved]}
						];

						(* Get the positions of each of our samples from the SamplesIn. *)
						samplesInPositions=(First[FirstPosition[simulatedSamples,#]]&)/@samples;

						{
							Replace[InvertParameters]->invertParameters,
							Replace[InvertIndices]->samplesInPositions
						}
					],
				Swirl,
					(* We have to swirl our samples, by hand, one by one. *)
					(* Therefore, no grouping is required. *)
					Module[{additionalMixes,swirlParameters,samplesInPositions},
						(* Compute Additional mixes. *)
						additionalMixes=MapThread[(
							(* Are we mixing until dissolved? *)
							If[#1,
								(#3-#2),
								0
							]
						&),{Lookup[options,MixUntilDissolved],Lookup[options,NumberOfMixes],Lookup[options,MaxNumberOfMixes]}];

						(* Transpose our information together. *)
						swirlParameters=MapThread[
							Function[{numberOfMixes,maxNumberOfMixes,additionalNumberOfMixes,mixUntilDissolved},
								<|
									Sample->Null,
									NumberOfMixes->numberOfMixes,
									MaxNumberOfMixes->maxNumberOfMixes,
									AdditionalNumberOfMixes->additionalNumberOfMixes,
									MixUntilDissolved->mixUntilDissolved
								|>
							],
							{Lookup[options,NumberOfMixes],Lookup[options,MaxNumberOfMixes]/.{Null->0},additionalMixes,Lookup[options,MixUntilDissolved]}
						];

						(* Get the positions of each of our samples from the SamplesIn. *)
						samplesInPositions=(First[FirstPosition[simulatedSamples,#]]&)/@samples;

						{
							Replace[SwirlParameters]->swirlParameters,
							Replace[SwirlIndices]->samplesInPositions
						}
					],
				Pipette,
					(* We have to pipette our samples, by hand, one by one. *)
					(* Therefore, no grouping is required. *)
					Module[{pipetteParameters,samplesInPositions},
						(* Transpose our information together. *)
						(* We have to make our primitives in the compiler since they point to our source sample. *)
						pipetteParameters=MapThread[
							Function[{numberOfMixes,maxNumberOfMixes,mixUntilDissolved,volume,tips},
								<|
									Sample->Null,
									Primitive->Null,
									AdditionalPrimitive->Null,
									NumberOfMixes->numberOfMixes,
									MaxNumberOfMixes->maxNumberOfMixes,
									MixUntilDissolved->mixUntilDissolved,
									Volume->volume,
									Tips->Link[tips]
								|>
							],
							{Lookup[options,NumberOfMixes],Lookup[options,MaxNumberOfMixes]/.{Null->0},Lookup[options,MixUntilDissolved],Lookup[options,MixVolume],Lookup[options,Tips]}
						];

						(* Get the positions of each of our samples from the SamplesIn. *)
						samplesInPositions=(First[FirstPosition[simulatedSamples,#]]&)/@samples;

						{
							Replace[PipetteParameters]->pipetteParameters,
							Replace[PipetteIndices]->samplesInPositions
						}
					],
				Vortex,
					(* We have to compute grouping orders of what samples we can put into a vortex. *)
					Module[{incubateInformation,incubateSamples,instrumentSettings,samplesAndContainer,containers,containerToSample,samplesAndOptions,samplesAndOptionsWithCounts,containersAndOptionsWithCounts,
					uniqueContainersAndOptions,containersAndOptionsWithMaxCounts,cases,largestCount,expandedContainersAndOptions,expandedSamplesAndOptions,vortexParameters,
					sampleGrouping,instruments,instrumentLocations,groupedSettings,instrumentObjects,instrumentModels,translatedRates,instrumentPositions,time,maxTime,times},
						(* Get the instrument settings that matter. *)
						incubateInformation=MapThread[
							(
								(* Only include groups over 0 Minute time. *)
								If[MatchQ[#3,GreaterP[0Minute]],
									{
										#1,
										{
											MixRate->#2,
											Time->#3,
											MaxTime->#4,
											MixUntilDissolved->#5,
											Temperature->#6,
											AnnealingTime->#7,
											ResidualIncubation->#8
										}
									},
									Nothing
								]
							&),
							{
								samples,
								Lookup[options,MixRate],
								Lookup[options,Time],
								Lookup[options,MaxTime],
								Lookup[options,MixUntilDissolved],
								Lookup[options,Temperature],
								Lookup[options,AnnealingTime],
								Lookup[options,ResidualIncubation]
							}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{incubateSamples,instrumentSettings}=If[Length[incubateInformation]>0,
							Transpose[incubateInformation],
							{{},{}}
						];

						(* Don't return anything if we don't have any samples. *)
						If[Length[incubateSamples]==0,
							Nothing,
							(* For each sample in our input, get the container that they live in. In the form {sample,container}. *)
							samplesAndContainer=({#,Lookup[fetchPacketFromCache[#,cache],Container]}/.{link_Link:>Download[link, Object]}&)/@incubateSamples;

							(* Get all of the containers (duplicates deleted) that we are mixing. *)
							containers=DeleteDuplicates[samplesAndContainer[[All,2]]];

							(* For each container, choose a representative sample from that container. *)
							containerToSample=(#->FirstCase[samplesAndContainer,{_,#}][[1]]&)/@containers;

							(* Transpose our samples and settings together. In the form {{sample,instrument,setting}..}. *)
							samplesAndOptions=Transpose[{incubateSamples,Download[Lookup[options,Instrument], Object],instrumentSettings}];

							(* Include the number of times each {sample,instrument,setting} shows up. *)
							(* This is in the form {{{sample,instrument,setting},count}..}. *)
							samplesAndOptionsWithCounts=Function[{countInformation},
								{countInformation[[1]],countInformation[[2]]}
							]/@Normal[Counts[samplesAndOptions]];

							(* Replace each sample with its container. *)
							(* This is in the form {{{container,instrument,setting},count}..}. *)
							containersAndOptionsWithCounts=samplesAndOptionsWithCounts/.{sample:ObjectP[Object[Sample]]:>Download[Lookup[fetchPacketFromCache[sample,cache],Container,Null],Object]};

							(* Get the biggest times for each {container,instrument,setting}. *)
							uniqueContainersAndOptions=DeleteDuplicates[containersAndOptionsWithCounts[[All,1]]];

							(* This variable is in the form {{{container,instrument,setting},largestCount}..} *)
							containersAndOptionsWithMaxCounts=Function[{containerAndOption},
								(* Get all the cases of {{container,instrument,setting},_}. *)
								cases=Cases[containersAndOptionsWithCounts,{containerAndOption,_}];

								(* Choose the largest number. *)
								largestCount=Max[cases[[All,2]]];

								(* Return the conatiner/options with the largest number. *)
								{containerAndOption,largestCount}
							]/@uniqueContainersAndOptions;

							(* Constant array out our {container,instrument,setting} based on the largestCount. *)
							expandedContainersAndOptions=Function[{containerAndOptionWithMaxCount},
								Sequence@@ConstantArray[containerAndOptionWithMaxCount[[1]],containerAndOptionWithMaxCount[[2]]]
							]/@containersAndOptionsWithMaxCounts;

							(* Map our containers to their representative samples. *)
							expandedSamplesAndOptions=expandedContainersAndOptions/.containerToSample;

							(* Put these representative samples into the grouping calculator. *)
							(* Compute our sample grouping. *)
							{sampleGrouping,instruments,instrumentLocations,groupedSettings}=groupSamples[expandedSamplesAndOptions[[All,1]],expandedSamplesAndOptions[[All,2]],expandedSamplesAndOptions[[All,3]],Cache->cache];

							(* Get the objects for these instruments. *)
							instrumentObjects=Download[instruments, Object];

							(* Translate our rates into instrument specific settings. *)
							(* Get the models of our objects. *)
							instrumentModels=(If[MatchQ[#,ObjectP[Object[Instrument]]],
								Lookup[fetchPacketFromCache[#,cache],Model],
								Lookup[fetchPacketFromCache[#,cache],Object]
							]/.link_Link:>Download[link, Object]&)/@instrumentObjects;

							(* Translate from instrument model to setting. *)
							translatedRates=MapThread[(instrumentInstrumentToSettingFunction[#1,cache][#2]&),{instrumentModels,UnitConvert[Lookup[groupedSettings,MixRate],RPM]}];

							(* We have to make our primitives in the compiler since they point to our source sample. *)
							vortexParameters=Flatten[MapThread[
								Function[{sampleGroup,instrument,instrumentLocation,settings,translatedRate},
									(<|
										Sample->Null,
										Instrument->Link[instrument],
										Location->#,
										Rate->Lookup[settings,MixRate],
										InstrumentRate->translatedRate,
										Time->Lookup[settings,Time],
										MaxTime->Lookup[settings,MaxTime],
										MixUntilDissolved->Lookup[settings,MixUntilDissolved],
										Temperature->Lookup[settings,Temperature],
										AnnealingTime->Lookup[settings,AnnealingTime],
										ResidualIncubation->Lookup[settings,ResidualIncubation]
									|>&)/@instrumentLocation
								],
								{sampleGrouping,instrumentObjects,instrumentLocations,groupedSettings,translatedRates}
							]];

							(* Get our indices of our sample groupings. *)
							sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

							(* Get the lengths of our sample groupings. *)
							sampleGroupingLengths=Length/@sampleGrouping;

							{
								Replace[VortexParameters]->vortexParameters,
								Replace[VortexIndices]->sampleGroupingIndices,
								Replace[VortexBatchLength]->sampleGroupingLengths
							}
						]
					],
				Disrupt,
					(* We have to compute grouping orders of what samples we can put into a disruptor. *)
					(* NOTE: This is the same logic as Vortex up above but without a translated InstrumentRate. *)
					Module[{incubateInformation,incubateSamples,instrumentSettings,samplesAndContainer,containers,containerToSample,samplesAndOptions,samplesAndOptionsWithCounts,containersAndOptionsWithCounts,
						uniqueContainersAndOptions,containersAndOptionsWithMaxCounts,cases,largestCount,expandedContainersAndOptions,expandedSamplesAndOptions,disruptParameters,
						sampleGrouping,instruments,instrumentLocations,groupedSettings,instrumentObjects,instrumentModels,instrumentPositions,time,maxTime,times},
						(* Get the instrument settings that matter. *)
						incubateInformation=MapThread[
							(
								(* Only include groups over 0 Minute time. *)
								If[MatchQ[#3,GreaterP[0Minute]],
									{
										#1,
										{
											MixRate->#2,
											Time->#3,
											MaxTime->#4,
											MixUntilDissolved->#5,
											Temperature->#6,
											AnnealingTime->#7,
											ResidualIncubation->#8
										}
									},
									Nothing
								]
							&),
							{
								samples,
								Lookup[options,MixRate],
								Lookup[options,Time],
								Lookup[options,MaxTime],
								Lookup[options,MixUntilDissolved],
								Lookup[options,Temperature],
								Lookup[options,AnnealingTime],
								Lookup[options,ResidualIncubation]
							}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{incubateSamples,instrumentSettings}=If[Length[incubateInformation]>0,
							Transpose[incubateInformation],
							{{},{}}
						];

						(* Don't return anything if we don't have any samples. *)
						If[Length[incubateSamples]==0,
							Nothing,
							(* For each sample in our input, get the container that they live in. In the form {sample,container}. *)
							samplesAndContainer=({#,Lookup[fetchPacketFromCache[#,cache],Container]}/.{link_Link:>Download[link, Object]}&)/@incubateSamples;

							(* Get all of the containers (duplicates deleted) that we are mixing. *)
							containers=DeleteDuplicates[samplesAndContainer[[All,2]]];

							(* For each container, choose a representative sample from that container. *)
							containerToSample=(#->FirstCase[samplesAndContainer,{_,#}][[1]]&)/@containers;

							(* Transpose our samples and settings together. In the form {{sample,instrument,setting}..}. *)
							samplesAndOptions=Transpose[{incubateSamples,Download[Lookup[options,Instrument], Object],instrumentSettings}];

							(* Include the number of times each {sample,instrument,setting} shows up. *)
							(* This is in the form {{{sample,instrument,setting},count}..}. *)
							samplesAndOptionsWithCounts=Function[{countInformation},
								{countInformation[[1]],countInformation[[2]]}
							]/@Normal[Counts[samplesAndOptions]];

							(* Replace each sample with its container. *)
							(* This is in the form {{{container,instrument,setting},count}..}. *)
							containersAndOptionsWithCounts=samplesAndOptionsWithCounts/.{sample:ObjectP[Object[Sample]]:>Download[Lookup[fetchPacketFromCache[sample,cache],Container,Null],Object]};

							(* Get the biggest times for each {container,instrument,setting}. *)
							uniqueContainersAndOptions=DeleteDuplicates[containersAndOptionsWithCounts[[All,1]]];

							(* This variable is in the form {{{container,instrument,setting},largestCount}..} *)
							containersAndOptionsWithMaxCounts=Function[{containerAndOption},
								(* Get all the cases of {{container,instrument,setting},_}. *)
								cases=Cases[containersAndOptionsWithCounts,{containerAndOption,_}];

								(* Choose the largest number. *)
								largestCount=Max[cases[[All,2]]];

								(* Return the conatiner/options with the largest number. *)
								{containerAndOption,largestCount}
							]/@uniqueContainersAndOptions;

							(* Constant array out our {container,instrument,setting} based on the largestCount. *)
							expandedContainersAndOptions=Function[{containerAndOptionWithMaxCount},
								Sequence@@ConstantArray[containerAndOptionWithMaxCount[[1]],containerAndOptionWithMaxCount[[2]]]
							]/@containersAndOptionsWithMaxCounts;

							(* Map our containers to their representative samples. *)
							expandedSamplesAndOptions=expandedContainersAndOptions/.containerToSample;

							(* Put these representative samples into the grouping calculator. *)
							(* Compute our sample grouping. *)
							{sampleGrouping,instruments,instrumentLocations,groupedSettings}=groupSamples[expandedSamplesAndOptions[[All,1]],expandedSamplesAndOptions[[All,2]],expandedSamplesAndOptions[[All,3]],Cache->cache];

							(* Get the objects for these instruments. *)
							instrumentObjects=Download[instruments, Object];

							(* Translate our rates into instrument specific settings. *)
							(* Get the models of our objects. *)
							instrumentModels=(If[MatchQ[#,ObjectP[Object[Instrument]]],
								Lookup[fetchPacketFromCache[#,cache],Model],
								Lookup[fetchPacketFromCache[#,cache],Object]
							]/.link_Link:>Download[link, Object]&)/@instrumentObjects;

							(* We have to make our primitives in the compiler since they point to our source sample. *)
							disruptParameters=Flatten[MapThread[
								Function[{sampleGroup,instrument,instrumentLocation,settings},
									MapThread[
										<|
											Sample->Link[#1],
											Instrument->Link[instrument],
											Location->#2,
											Rate->Lookup[settings,MixRate],
											Time->Lookup[settings,Time],
											MaxTime->Lookup[settings,MaxTime],
											MixUntilDissolved->Lookup[settings,MixUntilDissolved],
											Temperature->Lookup[settings,Temperature],
											AnnealingTime->Lookup[settings,AnnealingTime],
											ResidualIncubation->Lookup[settings,ResidualIncubation]
										|>&,
										{sampleGroup, instrumentLocation}
									]
								],
								{sampleGrouping,instrumentObjects,instrumentLocations,groupedSettings}
							]];

							(* Get our indices of our sample groupings. *)
							sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

							(* Get the lengths of our sample groupings. *)
							sampleGroupingLengths=Length/@sampleGrouping;

							{
								Replace[DisruptParameters]->disruptParameters,
								Replace[DisruptIndices]->sampleGroupingIndices,
								Replace[DisruptBatchLength]->sampleGroupingLengths
							}
						]
					],
				Nutate,
					(* We have to compute grouping orders of what samples we can put into a nutator. *)
					Module[{incubateInformation,incubateSamples,instrumentSettings,sampleGroupingResult,incubateFieldResults,sampleGroupings,
						instruments,times,temperatures,annealingTimes,instrumentObjects,nutateParameters,simulatedContainers,sampleGroupingIndices,
						sampleGroupingLengths,residualIncubations,mixUntilDissolveds,maxTimes,rates},

					(* Get the instrument settings that matter. *)
					incubateInformation=MapThread[
						(
							(* Only include groups over 0 Minute time. *)
							If[MatchQ[#3,GreaterP[0Minute]],
								{
									#1,
									{
										MixRate->#2,
										Time->#3,
										MaxTime->#4,
										MixUntilDissolved->#5,
										Temperature->#6,
										AnnealingTime->#7,
										ResidualIncubation->#8,
										Instrument->Download[#9, Object]
									}
								},
								Nothing
							]
						&),
						{
							samples,
							Lookup[options,MixRate],
							Lookup[options,Time],
							Lookup[options,MaxTime],
							Lookup[options,MixUntilDissolved],
							Lookup[options,Temperature],
							Lookup[options,AnnealingTime],
							Lookup[options,ResidualIncubation],
							Lookup[options,Instrument]
						}
					];

					(* Transpose our thaw information to get just our samples and thaw settings. *)
					{incubateSamples,instrumentSettings}=If[Length[incubateInformation]>0,
						Transpose[incubateInformation],
						{{},{}}
					];

					(* Don't return anything if we don't have any samples. *)
					If[Length[incubateSamples]==0,
						Nothing,
						(* Compute our sample groupings for thawing. *)
						(* This is in the format {{sampleGrouping,instrumentSettings}..}. *)
						(* NOTE: We use the incubator grouping helper because like in incubation, nutation just has an open footprint to place *)
						(* samples on the nutator. *)
						sampleGroupingResult=groupIncubateSamples[incubateSamples,instrumentSettings,cache];

						(* Create our thaw fields for the protocol object. *)
						incubateFieldResults=(Module[{sampleGrouping,settings},
							sampleGrouping=#[[1]];
							settings=#[[2]];

							{
								sampleGrouping,
								Lookup[settings, Instrument],
								Lookup[settings,MixRate],
								Lookup[settings,Time],
								Lookup[settings,MaxTime],
								Lookup[settings,MixUntilDissolved],
								Lookup[settings,Temperature],
								Lookup[settings,AnnealingTime],
								Lookup[settings,ResidualIncubation]
							}
						]&)/@sampleGroupingResult;

						(* Transpose our result. *)
						{
							sampleGroupings,
							instruments,
							rates,
							times,
							maxTimes,
							mixUntilDissolveds,
							temperatures,
							annealingTimes,
							residualIncubations
						}=If[Length[incubateFieldResults]>0,
							Transpose[incubateFieldResults],
							{{},{},{},{},{}}
						];

						(* Get the objects for these instruments. *)
						instrumentObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@instruments;

						(* We have to make our primitives in the compiler since they point to our source sample. *)
						nutateParameters=Flatten[MapThread[
							Function[{sampleGroup,instrument,rate,time,maxTime,mixUntilDissolved,temperature,annealingTime,residualIncubation},
								ConstantArray[<|
									Sample->Null,
									Instrument->Link[instrument],
									Rate->rate,
									Time->time,
									MaxTime->maxTime,
									MixUntilDissolved->mixUntilDissolved,
									Temperature->temperature/.{Ambient->$AmbientTemperature, Null->$AmbientTemperature},
									AnnealingTime->annealingTime/.{Null->0 Minute},
									ResidualIncubation->residualIncubation
								|>,Length[sampleGroup]]
							],
							{sampleGroupings, instrumentObjects, rates, times, maxTimes, mixUntilDissolveds, temperatures, annealingTimes, residualIncubations}
						]];

						(* Get our indices of our sample groupings. *)
						(* Incubate knapsack operates on containers so use those to get our index. *)
						simulatedContainers=(Lookup[fetchPacketFromCache[#,cache],Container]/.{link_Link:>Download[link, Object]}&)/@simulatedSamples;
						sampleGroupingIndices=(First[FirstPosition[simulatedContainers,#]]&)/@Flatten[sampleGroupings];

						(* Get the lengths of our sample groupings. *)
						sampleGroupingLengths=Length/@sampleGroupings;

						{
							Replace[NutateParameters]->nutateParameters,
							Replace[NutateIndices]->sampleGroupingIndices,
							Replace[NutateBatchLength]->sampleGroupingLengths
						}
					]
				],
				Shake,
					(* We have to compute grouping orders of what samples we can put into a shaker. *)
					Module[
						{incubateInformation,incubateSamples,instrumentSettings,ratchingBarIncubateInformation,ratchingBarParameters,ratchingBarGroupingIndices,ratchingBarGroupingLengths,
						torreyPinesIncubateInformation,torreyPinesParameters,torreyPinesGroupingIndices,torreyPinesGroupingLengths,wristActionIncubateInformation,
						wristActionParameters,wristActionGroupingIndices,wristActionGroupingLengths,magneticIncubateInformation,magneticParameters,magneticGroupingIndices,
						magneticGroupingLengths,labRamIncubateInformation,labRamParameters,labRamGroupingIndices,labRamGroupingLengths},

						(* Get the instrument settings that matter. *)
						incubateInformation=MapThread[
							(
								(* Only include groups over 0 Minute time. *)
								If[MatchQ[#3,GreaterP[0Minute]],
									{
										#1,
										{
											MixRate->#2,
											Time->#3,
											MaxTime->#4,
											MixUntilDissolved->#5,
											Temperature->#6,
											AnnealingTime->#7,
											ResidualIncubation->#8,
											Instrument->Download[#9, Object],
											MixRateProfile->#10,
											TemperatureProfile->#11,
											OscillationAngle->#12
										}
									},
									Nothing
								]
							&),
							{
								samples,
								Lookup[options,MixRate],
								Lookup[options,Time],
								Lookup[options,MaxTime],
								Lookup[options,MixUntilDissolved],
								Lookup[options,Temperature],
								Lookup[options,AnnealingTime],
								Lookup[options,ResidualIncubation],
								Lookup[options,Instrument],
								Lookup[options,MixRateProfile],
								Lookup[options,TemperatureProfile],
								Lookup[options,OscillationAngle]
							}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{incubateSamples,instrumentSettings}=If[Length[incubateInformation]>0,
							Transpose[incubateInformation],
							{{},{}}
						];

						(* Don't return anything if we don't have any samples. *)
						If[Length[incubateSamples]==0,
							Nothing,
							Module[
								{samplesAndContainer, containers, containerToSample, samplesAndOptions, samplesAndOptionsWithCounts, containersAndOptionsWithCounts,
									uniqueContainersAndOptions, containersAndOptionsWithMaxCounts, expandedContainersAndOptions, expandedSamplesAndOptions},

								(* Compute our sample grouping. *)

								(* For each sample in our input, get the container that they live in. In the form {sample,container}. *)
								samplesAndContainer=({#,Lookup[fetchPacketFromCache[#,cache],Container]}/.{link_Link:>Download[link, Object]}&)/@incubateSamples;

								(* Get all of the containers (duplicates deleted) that we are mixing. *)
								containers=DeleteDuplicates[samplesAndContainer[[All,2]]];

								(* For each container, choose a representative sample from that container. *)
								containerToSample=(#->FirstCase[samplesAndContainer,{_,#}][[1]]&)/@containers;

								(* Transpose our samples and settings together. In the form {{sample,instrument,setting}..}. *)
								samplesAndOptions=Transpose[{incubateSamples,Download[Lookup[options,Instrument], Object],instrumentSettings}];

								(* Include the number of times each {sample,instrument,setting} shows up. *)
								(* This is in the form {{{sample,instrument,setting},count}..}. *)
								samplesAndOptionsWithCounts=Function[{countInformation},
									{countInformation[[1]],countInformation[[2]]}
								]/@Normal[Counts[samplesAndOptions]];

								(* Replace each sample with its container. *)
								(* This is in the form {{{container,instrument,setting},count}..}. *)
								containersAndOptionsWithCounts=samplesAndOptionsWithCounts/.{sample:ObjectP[Object[Sample]]:>Download[Lookup[fetchPacketFromCache[sample,cache],Container,Null],Object]};

								(* Get the biggest times for each {container,instrument,setting}. *)
								uniqueContainersAndOptions=DeleteDuplicates[containersAndOptionsWithCounts[[All,1]]];

								(* This variable is in the form {{{container,instrument,setting},largestCount}..} *)
								containersAndOptionsWithMaxCounts=Function[{containerAndOption},
									(* Get all the cases of {{container,instrument,setting},_}. *)
									cases=Cases[containersAndOptionsWithCounts,{containerAndOption,_}];

									(* Choose the largest number. *)
									largestCount=Max[cases[[All,2]]];

									(* Return the conatiner/options with the largest number. *)
									{containerAndOption,largestCount}
								]/@uniqueContainersAndOptions;

								(* Constant array out our {container,instrument,setting} based on the largestCount. *)
								expandedContainersAndOptions=Function[{containerAndOptionWithMaxCount},
									Sequence@@ConstantArray[containerAndOptionWithMaxCount[[1]],containerAndOptionWithMaxCount[[2]]]
								]/@containersAndOptionsWithMaxCounts;

								(* Map our containers to their representative samples. *)
								expandedSamplesAndOptions=expandedContainersAndOptions/.containerToSample;

								(* Overwrite our incubation samples and instrument options. *)
								incubateSamples=expandedSamplesAndOptions[[All,1]];
								instrumentSettings=expandedSamplesAndOptions[[All,3]];
								incubateInformation=Transpose[{incubateSamples, instrumentSettings}];

								(* We only have 4 types of shaker models: *)
								(* 1) Enviro-Genie Temperature Shaker -- has a ratcheting bar that can put multiple of the same container together. *)
								ratchingBarIncubateInformation=Cases[
									incubateInformation,
									{_, KeyValuePattern[{Instrument->Model[Instrument,Shaker,"id:mnk9jORRwA7Z"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument,Shaker,"id:mnk9jORRwA7Z"],cache],Objects],Object]}]}
								];

								{ratchingBarParameters,ratchingBarGroupingIndices,ratchingBarGroupingLengths}=If[Length[ratchingBarIncubateInformation]>0,
									Module[
										{shakerPosition, shakerMaxWidth, groupedByShakerSettings, groupedSamples, settingGroups, transposedGroupInformation,
											sampleContainers,sampleContainerModels,groupedByContainerModel,containerModelGroups,containerModelMaximalAxis,
											numberOfContainers,partitionedSamples,sampleGrouping,instrumentInformation,additionalTime,shakeParameters,
											sampleGroupingIndices,sampleGroupingLengths,groupedSamplesByContainerModel,instrumentSettingWithAdapter, compatibleAdapters,compatibleVFs, flattenAdapters, VFToAdapterLookup, sampleContainerAdapterModels},

										(* Get the position slot of the shaker. *)
										shakerPosition=cacheLookup[cache, Model[Instrument,Shaker,"id:mnk9jORRwA7Z"], Positions][[1]];

										(* Get the width of the position. *)
										shakerMaxWidth=Lookup[shakerPosition,MaxWidth];

										(* Get the CompatibleAdapters of the shaker *)
										compatibleAdapters= Download[cacheLookup[cache, Model[Instrument,Shaker,"id:mnk9jORRwA7Z"], CompatibleAdapters],Object];

										(* For each of the adapter, find out the VF that can be used with this adapter *)
										compatibleVFs = Download[cacheLookup[cache, #, CompatibleVolumetricFlasks], Object]&/@compatibleAdapters;

										(* prepare flatten adapters for look up *)
										flattenAdapters = Flatten[MapThread[ConstantArray[#1, Length[#2]]&, {compatibleAdapters, compatibleVFs}]];
										VFToAdapterLookup = AssociationThread[Flatten[compatibleVFs], flattenAdapters];

										(* Group our samples by their settings. *)
										groupedByShakerSettings=Normal[GroupBy[ratchingBarIncubateInformation,(#[[2]]&)]];

										(* Get the samples and the settings. *)
										groupedSamples=(#[[All,1]]&)/@Values[groupedByShakerSettings];
										settingGroups=Keys[groupedByShakerSettings];

										(* For each sample group, maximally place containers together. *)
										(* transposedGroupInformation is in the form {{samples,instrumentSettings}..}. *)
										transposedGroupInformation=MapThread[
											Function[{sampleGroup,instrumentSetting},
												(* Get the container models of the samples in this group. *)
												sampleContainers=cacheLookup[cache, #, Container]&/@sampleGroup;
												sampleContainerModels=(Download[cacheLookup[cache, #, Model],Object]&)/@sampleContainers;

												(* Replace the vf container with its corresponding adapter *)
												sampleContainerAdapterModels = sampleContainerModels/.VFToAdapterLookup;

												(* Group our samples by their container models. *)
												groupedByContainerModel=Normal[GroupBy[Transpose[{sampleGroup,sampleContainerAdapterModels}],(#[[2]]&)]];

												(* Get the samples and their containers. *)
												groupedSamplesByContainerModel=(#[[All,1]]&)/@Values[groupedByContainerModel];
												containerModelGroups=Keys[groupedByContainerModel];

												(* For each container model, figure out the maximal axis (width or length) then figure out how many of that container we can put on the shaker at the same time. *)
												Sequence@@MapThread[
													Function[{sampleGroupByContainerModel,containerModel},
														(* at this moment, volumetric flask has been replaced as adapter racks *)
														containerModelMaximalAxis=If[MatchQ[containerModel, ObjectP[Model[Container, Rack]]],
															(* Do not need maximal axis if we are dealing with vf -- will be using its compatible adapters*)
															Null,
															(* Figure out the maximal axis if we are dealing with normal vessels or plates *)
															Max[cacheLookup[cache, containerModel, Dimensions][[1;;2]]]
														];

														(* How many of these containers can we fit on the shaker? *)
														numberOfContainers=Which[
															(* If we are dealing with vf, get the number of positions of the adapter *)
															MatchQ[containerModel, ObjectP[compatibleAdapters]],
															Length[cacheLookup[cache, containerModel, Positions]],

															(* If our containers is smaller than 0.017 Meter, then we'll be using the *)
															(* Model[Container, Rack, "2 mL Glass Vial Orbital Shaker Rack"] adapter which has 35 slots. *)
															MatchQ[containerModelMaximalAxis, LessP[0.017 Meter]],
															$GlassVialOrbitalShakerRackPositions,

															(* Otherwise, calculate based on the dimension *)
															True,
															IntegerPart[shakerMaxWidth/containerModelMaximalAxis]
														];

														(* Take up to these number of containers. *)
														partitionedSamples=Partition[sampleGroupByContainerModel,UpTo[numberOfContainers]];

														(* Add an adapter if necessary. *)
														instrumentSettingWithAdapter=Which[
															(* If we are dealing with vf, update the adapter *)
															MatchQ[containerModel, ObjectP[compatibleAdapters]],
															Append[instrumentSetting, ShakerAdapter->containerModel],

															(* If our containers is smaller than 0.017 Meter, then we'll be using Model[Container, Rack, "2 mL Glass Vial Orbital Shaker Rack"] *)
															MatchQ[containerModelMaximalAxis, LessP[0.017 Meter]],
															Append[instrumentSetting, ShakerAdapter->Model[Container, Rack, "2 mL Glass Vial Orbital Shaker Rack"]],

															(* otherwise, do not need adapter*)
															True,
															instrumentSetting
														];

														(* Transpose this together with our instrument setting. Then return as a sequence. *)
														Sequence@@Transpose[{partitionedSamples,ConstantArray[instrumentSettingWithAdapter,Length[partitionedSamples]]}]
													],
													{groupedSamplesByContainerModel,containerModelGroups}
												]
											],
											{groupedSamples,settingGroups}
										];

										(* Transpose our result. *)
										(* Note that the Instrument key is in the instrumentInformation variable. *)
										{sampleGrouping,instrumentInformation}=If[Length[transposedGroupInformation]==0,
											{{},{}},
											Transpose[transposedGroupInformation]
										];

										(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the shaker. *)
										additionalTime=MapThread[(
											(* Are we mixing until dissolved? *)
											If[#1,
												(#3-#2),
												0 Minute
											]&),
											{Lookup[instrumentInformation,MixUntilDissolved],Lookup[instrumentInformation,Time],Lookup[instrumentInformation,MaxTime]}
										];

										(* We have to make our primitives in the compiler since they point to our source sample. *)
										shakeParameters=Flatten[MapThread[
											Function[{sampleGroup,settings},
												ConstantArray[<|
													Sample->Null,
													Instrument->Link[Download[Lookup[settings,Instrument], Object]],
													Location->{"Container Slot",Link[Lookup[settings,Instrument]]},
													Rate->Lookup[settings,MixRate],
													Time->Lookup[settings,Time],
													MaxTime->Lookup[settings,MaxTime],
													Temperature->Lookup[settings,Temperature],
													AnnealingTime->Lookup[settings,AnnealingTime],
													MixUntilDissolved->Lookup[settings,MixUntilDissolved],
													ResidualIncubation->Lookup[settings,ResidualIncubation],
													MixRateProfile->Lookup[settings,MixRateProfile],
													TemperatureProfile->Lookup[settings,TemperatureProfile],
													OscillationAngle->Lookup[settings,OscillationAngle],
													ShakerAdapter->If[MatchQ[Lookup[settings,ShakerAdapter], ObjectP[]],
														Link[Lookup[settings,ShakerAdapter]],
														Null
													]
												|>,Length[sampleGroup]]
											],
											{sampleGrouping,instrumentInformation}
										]];

										(* Get our indices of our sample groupings. *)
										sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

										(* Get the lengths of our sample groupings. *)
										sampleGroupingLengths=Length/@sampleGrouping;

										{shakeParameters,sampleGroupingIndices,sampleGroupingLengths}
									],
									{{},{},{}}
								];

								(* 2) Torrey-Pines Shaker -- requires a shaking adapter that you then put the samples in, like a vortex. *)
								torreyPinesIncubateInformation=Cases[
									incubateInformation,
									{_, KeyValuePattern[{Instrument->Model[Instrument, Shaker, "id:N80DNj15vreD"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument, Shaker, "id:N80DNj15vreD"],cache],Objects],Object]}]}
								];

								{torreyPinesParameters,torreyPinesGroupingIndices,torreyPinesGroupingLengths}=If[Length[torreyPinesIncubateInformation]>0,
									Module[
										{compatibleAdapters,compatibleAdapterPackets,groupedByShakerSettings, groupedSamples, settingGroups, transposedGroupInformation,
											sampleContainers,sampleContainerModels,groupedByContainerModel,containerModelGroups,adapterFootprintToAdapterModel,
											numberOfContainers,partitionedSamples,sampleGrouping,instrumentInformation,additionalTime,shakeParameters,
											sampleGroupingIndices,sampleGroupingLengths,groupedSamplesByContainerModel,adapterFootprintToNumberOfPositions,
											currentFootprint,footprintInformation},

										(* Get the compatible adapter packets from the torrey pines shaker. *)
										compatibleAdapters=Lookup[fetchPacketFromCache[Model[Instrument, Shaker, "id:N80DNj15vreD"], cache], CompatibleAdapters];
										compatibleAdapterPackets=(fetchPacketFromCache[#, cache]&)/@compatibleAdapters;

										(* For each adapter type, create a lookup between footprint and positions that adapter will hold. *)
										(* Ex. The 2mL adapter holds 24 2mL tubes. *)
										adapterFootprintToNumberOfPositions=(
											Lookup[First[Lookup[#, Positions]], Footprint]->Length[Lookup[#, Positions]]
													&)/@compatibleAdapterPackets;
										adapterFootprintToAdapterModel=(
											Lookup[First[Lookup[#, Positions]], Footprint]->Lookup[#, Object]
													&)/@compatibleAdapterPackets;

										(* Group our samples by their settings. *)
										groupedByShakerSettings=Normal[GroupBy[torreyPinesIncubateInformation,(#[[2]]&)]];

										(* Get the samples and the settings. *)
										groupedSamples=(#[[All,1]]&)/@Values[groupedByShakerSettings];
										settingGroups=Keys[groupedByShakerSettings];

										(* For each sample group, maximally place containers together. *)
										(* transposedGroupInformation is in the form {{samples,instrumentSettings,footprints}..}. *)
										transposedGroupInformation=MapThread[
											Function[{sampleGroup,instrumentSetting},
												(* Get the container models of the samples in this group. *)
												sampleContainers=(Lookup[fetchPacketFromCache[#,cache],Container]&)/@sampleGroup;
												sampleContainerModels=(Download[Lookup[fetchPacketFromCache[#,cache],Model],Object]&)/@sampleContainers;

												(* Group our samples by their container models. *)
												groupedByContainerModel=Normal[GroupBy[Transpose[{sampleGroup,sampleContainerModels}],(#[[2]]&)]];

												(* Get the samples and their containers. *)
												groupedSamplesByContainerModel=(#[[All,1]]&)/@Values[groupedByContainerModel];
												containerModelGroups=Keys[groupedByContainerModel];

												(* For each container model, figure out the maximal axis (width or length) then figure out how many of that container we can put on the shaker at the same time. *)
												Sequence@@MapThread[
													Function[{sampleGroupByContainerModel,containerModel},
														(* How many of these containers can we fit in the adapter? *)
														currentFootprint=Lookup[fetchPacketFromCache[containerModel, cache], Footprint];
														(* If the model does not have a footprint but was otherwise determined to be compatible with the instrument/mixtype, use 1 to avoid breaking *)
														numberOfContainers=If[NullQ[currentFootprint],
															1,
															Lookup[adapterFootprintToNumberOfPositions, currentFootprint]
														];

														(* Take up to these number of containers. *)
														partitionedSamples=Partition[sampleGroupByContainerModel,UpTo[numberOfContainers]];

														(* Transpose this together with our instrument setting. Then return as a sequence. *)
														Sequence@@Transpose[{
															partitionedSamples,
															ConstantArray[instrumentSetting,Length[partitionedSamples]],
															ConstantArray[currentFootprint, Length[partitionedSamples]]
														}]
													],
													{groupedSamplesByContainerModel,containerModelGroups}
												]
											],
											{groupedSamples,settingGroups}
										];

										(* Transpose our result. *)
										(* Note that the Instrument key is in the instrumentInformation variable. *)
										{sampleGrouping,instrumentInformation,footprintInformation}=If[Length[transposedGroupInformation]==0,
											{{},{}},
											Transpose[transposedGroupInformation]
										];

										(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the vortex. *)
										additionalTime=MapThread[(
											(* Are we mixing until dissolved? *)
											If[#1,
												(#3-#2),
												0 Minute
											]
													&),{Lookup[instrumentInformation,MixUntilDissolved],Lookup[instrumentInformation,Time],Lookup[instrumentInformation,MaxTime]}];

										(* We have to make our primitives in the compiler since they point to our source sample. *)
										shakeParameters=Flatten[MapThread[
											Function[{sampleGroup,settings,footprint},
												ConstantArray[<|
													Sample->Null,
													Instrument->Link[Download[Lookup[settings,Instrument], Object]],
													Location->{"Adapter Slot",Link[Lookup[settings,Instrument]]},
													Rate->Lookup[settings,MixRate],
													Time->Lookup[settings,Time],
													MaxTime->Lookup[settings,MaxTime],
													Temperature->Lookup[settings,Temperature],
													AnnealingTime->Lookup[settings,AnnealingTime],
													MixUntilDissolved->Lookup[settings,MixUntilDissolved],
													ResidualIncubation->Lookup[settings,ResidualIncubation],
													MixRateProfile->Lookup[settings,MixRateProfile],
													TemperatureProfile->Lookup[settings,TemperatureProfile],
													OscillationAngle->Lookup[settings,OscillationAngle],
													ShakerAdapter->Link[Lookup[adapterFootprintToAdapterModel, footprint]]
												|>,Length[sampleGroup]]
											],
											{sampleGrouping,instrumentInformation,footprintInformation}
										]];

										(* Get our indices of our sample groupings. *)
										sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

										(* Get the lengths of our sample groupings. *)
										sampleGroupingLengths=Length/@sampleGrouping;

										{shakeParameters,sampleGroupingIndices,sampleGroupingLengths}
									],
									{{},{},{}}
								];

								(* 3) Wrist Action Shaker -- you clamp the samples into fixed positions and set an OscillationAngle. *)
								wristActionIncubateInformation=Cases[
									incubateInformation,
									{_, KeyValuePattern[{Instrument->Model[Instrument, Shaker, "id:Vrbp1jG80JAw"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument, Shaker, "id:Vrbp1jG80JAw"],cache],Objects],Object]}]}
								];

								{wristActionParameters,wristActionGroupingIndices,wristActionGroupingLengths}=If[Length[wristActionIncubateInformation]>0,
									Module[
										{instrumentPositions,groupedByShakerSettings, groupedSamples, settingGroups, transposedGroupInformation,
											partitionedSamples,sampleGrouping,instrumentInformation,additionalTime,shakeParameters,
											sampleGroupingIndices,sampleGroupingLengths,groupedSamplesByContainerModel},

										(* Get the compatible adapter packets from the torrey pines shaker. *)
										instrumentPositions=Lookup[fetchPacketFromCache[Model[Instrument, Shaker, "id:Vrbp1jG80JAw"], cache], Positions];

										(* Group our samples by their settings. *)
										groupedByShakerSettings=Normal[GroupBy[wristActionIncubateInformation,(#[[2]]&)]];

										(* Get the samples and the settings. *)
										groupedSamples=(#[[All,1]]&)/@Values[groupedByShakerSettings];
										settingGroups=Keys[groupedByShakerSettings];

										(* For each sample group, maximally place containers together. *)
										(* transposedGroupInformation is in the form {{samples,instrumentSettings}..}. *)
										transposedGroupInformation=MapThread[
											Function[{sampleGroup,instrumentSetting},
												(* Take up to these number of containers that will fit on a shaker. *)
												partitionedSamples=Partition[sampleGroup,UpTo[Length[instrumentPositions]]];

												Sequence@@Transpose[{partitionedSamples,ConstantArray[instrumentSetting,Length[partitionedSamples]]}]
											],
											{groupedSamples,settingGroups}
										];

										(* Transpose our result. *)
										(* Note that the Instrument key is in the instrumentInformation variable. *)
										{sampleGrouping,instrumentInformation}=If[Length[transposedGroupInformation]==0,
											{{},{}},
											Transpose[transposedGroupInformation]
										];

										(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the vortex. *)
										additionalTime=MapThread[(
											(* Are we mixing until dissolved? *)
											If[#1,
												(#3-#2),
												0 Minute
											]
													&),{Lookup[instrumentInformation,MixUntilDissolved],Lookup[instrumentInformation,Time],Lookup[instrumentInformation,MaxTime]}];

										(* We have to make our primitives in the compiler since they point to our source sample. *)
										shakeParameters=Flatten[MapThread[
											Function[{sampleGroup,settings},
												ConstantArray[<|
													Sample->Null,
													Instrument->Link[Download[Lookup[settings,Instrument], Object]],
													Location->{"Adapter Slot",Link[Lookup[settings,Instrument]]},
													Rate->Lookup[settings,MixRate],
													Time->Lookup[settings,Time],
													MaxTime->Lookup[settings,MaxTime],
													Temperature->Lookup[settings,Temperature],
													AnnealingTime->Lookup[settings,AnnealingTime],
													MixUntilDissolved->Lookup[settings,MixUntilDissolved],
													ResidualIncubation->Lookup[settings,ResidualIncubation],
													MixRateProfile->Lookup[settings,MixRateProfile],
													TemperatureProfile->Lookup[settings,TemperatureProfile],
													OscillationAngle->Lookup[settings,OscillationAngle],
													ShakerAdapter->Null
												|>,Length[sampleGroup]]
											],
											{sampleGrouping,instrumentInformation}
										]];

										(* Get our indices of our sample groupings. *)
										sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

										(* Get the lengths of our sample groupings. *)
										sampleGroupingLengths=Length/@sampleGrouping;

										{shakeParameters,sampleGroupingIndices,sampleGroupingLengths}
									],
									{{},{},{}}
								];

								(* 4) Magnetic Incubator Shaker -- you put magnetic clamps onto the shaker's surface and it shakes your samples for you. *)
								magneticIncubateInformation=Cases[
									incubateInformation,
									{_, KeyValuePattern[{Instrument->Model[Instrument, Shaker, "id:6V0npvmNnOrw"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument, Shaker, "id:6V0npvmNnOrw"],cache],Objects],Object]}]}
								];

								{magneticParameters,magneticGroupingIndices,magneticGroupingLengths}=If[Length[magneticIncubateInformation]>0,
									Module[
										{instrumentPositions,groupedByShakerSettings, groupedSamples, settingGroups, transposedGroupInformation,
											partitionedSamples,sampleGrouping,instrumentInformation,additionalTime,shakeParameters,
											sampleGroupingIndices,sampleGroupingLengths, compatibleAdapters, compatibleAdapterPackets, FootprintToAdapterLookup, sampleContainers, sampleContainerModels, sampleContainerModelAdapter, partitionedAdapters, adapterGrouping, sampleContainerAdapterResources},

										(* Get the compatible adapter packets from the incu shaker. *)
										instrumentPositions=cacheLookup[cache, Model[Instrument, Shaker, "id:6V0npvmNnOrw"], Positions];
										(* Get the CompatibleAdapters of the shaker *)
										compatibleAdapters= Download[cacheLookup[cache, Model[Instrument, Shaker, "id:6V0npvmNnOrw"], CompatibleAdapters], Object];
										compatibleAdapterPackets=(fetchPacketFromCache[#, cache]&)/@compatibleAdapters;

										(* generate the footprint -> adapter lookup *)
										(* Note: we only support VF on incu-shaker; each adapter only support one VF and each VF only have one adapter model *)
										FootprintToAdapterLookup = AssociationThread[Lookup[Flatten[Lookup[compatibleAdapterPackets, Positions]], Footprint], compatibleAdapters];

										(* Group our samples by their settings. *)
										groupedByShakerSettings=Normal[GroupBy[magneticIncubateInformation,(#[[2]]&)]];

										(* Get the samples and the settings. *)
										groupedSamples=(#[[All,1]]&)/@Values[groupedByShakerSettings];
										settingGroups=Keys[groupedByShakerSettings];

										(* For each sample group, maximally place containers together. *)
										(* transposedGroupInformation is in the form {{samples,instrumentSettings}..}. *)
										transposedGroupInformation=MapThread[
											Function[{sampleGroup,instrumentSetting},
												(* Take up to these number of containers that will fit on a shaker. *)
												partitionedSamples=Partition[sampleGroup,UpTo[Length[instrumentPositions]]];

												(* Fetch the adapter for the VF *)
												sampleContainers=cacheLookup[cache, #, Container]&/@sampleGroup;
												sampleContainerModels=(Download[cacheLookup[cache, #, Model],Object]&)/@sampleContainers;
												sampleContainerModelAdapter = (cacheLookup[cache, #, Footprint]&/@sampleContainerModels)/.FootprintToAdapterLookup;

												(* generate adapter resources *)
												(* Note: Unlike other shakers which have at most one adapter per shaker, incu-shaker can have more than one adapters used on one instrument *)
												sampleContainerAdapterResources = Resource[Sample -> #, Name -> CreateUUID[]]& /@ Cases[sampleContainerModelAdapter, ObjectP[]];

												(* partition adapters in the same way as samples *)
												partitionedAdapters = Unflatten[sampleContainerAdapterResources, partitionedSamples];

												(* return samples, adapters and instrument settings *)
												Sequence@@Transpose[{partitionedSamples,partitionedAdapters,ConstantArray[instrumentSetting,Length[partitionedSamples]]}]
											],
											{groupedSamples,settingGroups}
										];

										(* Transpose our result. *)
										(* Note that the Instrument key is in the instrumentInformation variable. *)
										{sampleGrouping,adapterGrouping,instrumentInformation}=If[Length[transposedGroupInformation]==0,
											{{},{},{}},
											Transpose[transposedGroupInformation]
										];

										(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the shaker. *)
										additionalTime=MapThread[(
											(* Are we mixing until dissolved? *)
											If[#1,
												(#3-#2),
												0 Minute
											]&),
											{Lookup[instrumentInformation,MixUntilDissolved],Lookup[instrumentInformation,Time],Lookup[instrumentInformation,MaxTime]}
										];

										(* We have to make our primitives in the compiler since they point to our source sample. *)
										shakeParameters=Flatten[MapThread[
											Function[{adapterGroup,settings},
												Map[
													<|
														Sample->Null,
														Instrument->Link[Download[Lookup[settings,Instrument], Object]],
														Location->{"Adapter Slot",Link[Lookup[settings,Instrument]]},
														Rate->Lookup[settings,MixRate],
														Time->Lookup[settings,Time],
														MaxTime->Lookup[settings,MaxTime],
														Temperature->Lookup[settings,Temperature],
														AnnealingTime->Lookup[settings,AnnealingTime],
														MixUntilDissolved->Lookup[settings,MixUntilDissolved],
														ResidualIncubation->Lookup[settings,ResidualIncubation],
														MixRateProfile->Lookup[settings,MixRateProfile],
														TemperatureProfile->Lookup[settings,TemperatureProfile],
														OscillationAngle->Lookup[settings,OscillationAngle],
														ShakerAdapter -> Link[#]
													|>&,
													adapterGroup
												]
											],
											{adapterGrouping, instrumentInformation}
										]];

										(* Get our indices of our sample groupings. *)
										sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

										(* Get the lengths of our sample groupings. *)
										sampleGroupingLengths=Length/@sampleGrouping;

										{shakeParameters,sampleGroupingIndices,sampleGroupingLengths}
									],
									{{},{},{}}
								];

								(* 5) Lab Ram Shaker -- has one position slot but matrix vials can be placed 96 at a time. *)
								labRamIncubateInformation=Cases[
									incubateInformation,
									{_, KeyValuePattern[{Instrument->Model[Instrument, Shaker, "id:bq9LA0JYrN66"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument, Shaker, "id:bq9LA0JYrN66"],cache],Objects],Object]}]}
								];

								{labRamParameters,labRamGroupingIndices,labRamGroupingLengths}=If[Length[labRamIncubateInformation]>0,
									Module[
										{groupedByShakerSettings, groupedSamples, settingGroups, transposedGroupInformation,
											sampleContainers,sampleContainerModels,groupedByContainerModel,containerModelGroups,
											numberOfContainers,partitionedSamples,sampleGrouping,instrumentInformation,additionalTime,shakeParameters,
											sampleGroupingIndices,sampleGroupingLengths,groupedSamplesByContainerModel},
										(* Group our samples by their settings. *)
										groupedByShakerSettings=Normal[GroupBy[labRamIncubateInformation,(#[[2]]&)]];

										(* Get the samples and the settings. *)
										groupedSamples=(#[[All,1]]&)/@Values[groupedByShakerSettings];
										settingGroups=Keys[groupedByShakerSettings];

										(* For each sample group, maximally place containers together. *)
										(* transposedGroupInformation is in the form {{samples,instrumentSettings}..}. *)
										transposedGroupInformation=MapThread[
											Function[{sampleGroup,instrumentSetting},
												(* Get the container models of the samples in this group. *)
												sampleContainers=(Lookup[fetchPacketFromCache[#,cache],Container]&)/@sampleGroup;
												sampleContainerModels=(Download[Lookup[fetchPacketFromCache[#,cache],Model],Object]&)/@sampleContainers;

												(* Group our samples by their container models. *)
												groupedByContainerModel=Normal[GroupBy[Transpose[{sampleGroup,sampleContainerModels}],(#[[2]]&)]];

												(* Get the samples and their containers. *)
												groupedSamplesByContainerModel=(#[[All,1]]&)/@Values[groupedByContainerModel];
												containerModelGroups=Keys[groupedByContainerModel];

												(* For each container model, figure out the maximal axis (width or length) then figure out how many of that container we can put on the shaker at the same time. *)
												Sequence@@MapThread[
													Function[{sampleGroupByContainerModel,containerModel},
														(* How many of these containers can we fit on the shaker? *)
														(* If we're using the Thermo Matrix vials, we can fit 96 tubes at the same time. *)
														(* Otherwise, we need to do them 1 by 1. *)
														numberOfContainers=If[MatchQ[containerModel, ObjectP[Model[Container, Vessel, "id:pZx9jo8MaknP"]]],
															96,
															1
														];

														(* Take up to these number of containers. *)
														partitionedSamples=Partition[sampleGroupByContainerModel,UpTo[numberOfContainers]];

														(* Transpose this together with our instrument setting. Then return as a sequence. *)
														Sequence@@Transpose[{partitionedSamples,ConstantArray[instrumentSetting,Length[partitionedSamples]]}]
													],
													{groupedSamplesByContainerModel,containerModelGroups}
												]
											],
											{groupedSamples,settingGroups}
										];

										(* Transpose our result. *)
										(* Note that the Instrument key is in the instrumentInformation variable. *)
										{sampleGrouping,instrumentInformation}=If[Length[transposedGroupInformation]==0,
											{{},{}},
											Transpose[transposedGroupInformation]
										];

										(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the vortex. *)
										additionalTime=MapThread[(
											(* Are we mixing until dissolved? *)
											If[#1,
												(#3-#2),
												0 Minute
											]
										&),{Lookup[instrumentInformation,MixUntilDissolved],Lookup[instrumentInformation,Time],Lookup[instrumentInformation,MaxTime]}];

										(* We have to make our primitives in the compiler since they point to our source sample. *)
										shakeParameters=Flatten[MapThread[
											Function[{sampleGroup,settings},
												ConstantArray[<|
													Sample->Null,
													Instrument->Link[Download[Lookup[settings,Instrument], Object]],
													Location->{"Container Slot",Link[Lookup[settings,Instrument]]},
													Rate->Lookup[settings,MixRate],
													Time->Lookup[settings,Time],
													MaxTime->Lookup[settings,MaxTime],
													Temperature->Lookup[settings,Temperature],
													AnnealingTime->Lookup[settings,AnnealingTime],
													MixUntilDissolved->Lookup[settings,MixUntilDissolved],
													ResidualIncubation->Lookup[settings,ResidualIncubation],
													MixRateProfile->Lookup[settings,MixRateProfile],
													TemperatureProfile->Lookup[settings,TemperatureProfile],
													OscillationAngle->Lookup[settings,OscillationAngle],
													(* We need a rack if we're using the thermo matrix vials. *)
													ShakerAdapter->If[MatchQ[Lookup[fetchPacketFromCache[Lookup[fetchPacketFromCache[sampleGroup[[1]],cache],Container],cache],Model], ObjectP[Model[Container, Vessel, "id:pZx9jo8MaknP"]]],
														Resource[
															Sample->Model[Container, Rack, "96-position Thermo Matrix 1.0mL Tube Rack"],
															Name->CreateUUID[]
														],
														Null
													]
												|>,Length[sampleGroup]]
											],
											{sampleGrouping,instrumentInformation}
										]];

										(* Get our indices of our sample groupings. *)
										sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

										(* Get the lengths of our sample groupings. *)
										sampleGroupingLengths=Length/@sampleGrouping;

										{shakeParameters,sampleGroupingIndices,sampleGroupingLengths}
									],
									{{},{},{}}
								];

								{
									Replace[ShakeParameters]->Join[
										ratchingBarParameters,
										torreyPinesParameters,
										wristActionParameters,
										magneticParameters,
										labRamParameters
									],
									Replace[ShakeIndices]->Join[
										ratchingBarGroupingIndices,
										torreyPinesGroupingIndices,
										wristActionGroupingIndices,
										magneticGroupingIndices,
										labRamGroupingIndices
									],
									Replace[ShakeBatchLength]->Join[
										ratchingBarGroupingLengths,
										torreyPinesGroupingLengths,
										wristActionGroupingLengths,
										magneticGroupingLengths,
										labRamGroupingLengths
									]
								}
							]
						]
					],
				Roll,
					(* We have to compute grouping orders of what samples we can put into a rollers. *)
					Module[
						{incubateInformation,incubateSamples,instrumentSettings, tubeRollerIncubateInformation, rollerParameters, rollerGroupingIndices, rollerGroupingLengths, bottleRollerIncubateInformation, bottleRollerParameters, bottleRollerGroupingIndices, bottleRollerGroupingLengths},

						(* Get the instrument settings that matter. *)
						incubateInformation=MapThread[
							(
								(* Only include groups over 0 Minute time. *)
								If[MatchQ[#3,GreaterP[0Minute]],
									{
										#1,
										{
											MixRate->#2,
											Time->#3,
											MaxTime->#4,
											MixUntilDissolved->#5,
											Temperature->#6,
											AnnealingTime->#7,
											ResidualIncubation->#8,
											Instrument -> #9
										}
									},
									Nothing
								]
							&),
							{
								samples,
								Lookup[options,MixRate],
								Lookup[options,Time],
								Lookup[options,MaxTime],
								Lookup[options,MixUntilDissolved],
								Lookup[options,Temperature],
								Lookup[options,AnnealingTime],
								Lookup[options,ResidualIncubation],
								Lookup[options,Instrument]
							}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{incubateSamples,instrumentSettings}=If[Length[incubateInformation]>0,
							Transpose[incubateInformation],
							{{},{}}
						];

						(* Don't return anything if we don't have any samples. *)
						If[Length[incubateSamples]==0,
							Nothing,
							(* Compute our sample grouping for Roller *)
							tubeRollerIncubateInformation=Cases[
								incubateInformation,
								(* Model[Instrument, Roller, "Enviro-Genie"] *)
								{_, KeyValuePattern[{Instrument->Model[Instrument, Roller, "id:Vrbp1jKKZw6z"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument, Roller, "id:Vrbp1jKKZw6z"],cache],Objects],Object]}]}
							];
							{rollerParameters, rollerGroupingIndices, rollerGroupingLengths} = If[Length[tubeRollerIncubateInformation] > 0,
								Module[{rollerRackGroupedSample, rollerRackSamplePositions, rollerRackInstrumentSettings, rollerRackModels, groupedByRollerSettings, groupedSamples, settingGroups, compatibleRacks, compatibleRackPackets, tubeFootprintToNumberOfPositions, tubeFootprintToRackModel, transposedGroupInformation,footprintInformation, rollerRackResources, rackToSampleLookups, rollerRackGrouping,instruments,instrumentLocations,groupedSettings, instrumentObjects, instrumentModels, translatedRates, additionalTime,rollParameters, batchedSamples, simulatedSampleIndices, batchedSampleIndices},
									(* group samples to racks *)
									(* Get the compatible rack packets from the roller Model[Instrument, Roller, "Enviro-Genie"] *)
									compatibleRacks=Lookup[fetchPacketFromCache[Model[Instrument, Roller, "id:Vrbp1jKKZw6z"], cache], CompatibleRacks];
									compatibleRackPackets=(fetchPacketFromCache[#, cache]&)/@compatibleRacks;

									(* For each rack type, create a lookup between footprint and positions that rack will hold. *)
									(* Note: each rack must only have one kind of rack positions *)
									(* Ex. The 50mL rack holds 3 50mL tubes. *)
									tubeFootprintToNumberOfPositions=(
										Lookup[First[Lookup[#, Positions]], Footprint]->Length[Lookup[#, Positions]]
												&)/@compatibleRackPackets;
									tubeFootprintToRackModel=(
										Lookup[First[Lookup[#, Positions]], Footprint]->Lookup[#, Object]
												&)/@compatibleRackPackets;

									(* Group our samples by their settings. *)
									groupedByRollerSettings=Normal[GroupBy[tubeRollerIncubateInformation,(#[[2]]&)]];
									(* Get the samples and the settings. *)
									groupedSamples=(#[[All,1]]&)/@Values[groupedByRollerSettings];
									settingGroups=Keys[groupedByRollerSettings];

									transposedGroupInformation=MapThread[
										Function[{sampleGroup,instrumentSetting},
											Module[{sampleContainers, sampleContainerModels, groupedByContainerModel, groupedSamplesByContainerModel, containerModelGroups},
												(* Get the container models of the samples in this group. *)
												sampleContainers=(Download[Lookup[fetchPacketFromCache[#,cache],Container],Object]&)/@sampleGroup;
												sampleContainerModels=(Download[Lookup[fetchPacketFromCache[#,cache],Model],Object]&)/@sampleContainers;

												(* Group our samples by their container models. *)
												groupedByContainerModel=Normal[GroupBy[Transpose[{sampleGroup,sampleContainerModels}],(#[[2]]&)]];

												(* Get the samples and their containers. *)
												groupedSamplesByContainerModel=(#[[All,1]]&)/@Values[groupedByContainerModel];
												containerModelGroups=Keys[groupedByContainerModel];

												(* For each container model, figure out how many of that container we can put on the roller at the same time. *)
												Sequence@@MapThread[
													Function[{sampleGroupByContainerModel,containerModel},
														Module[{currentFootprint, numberOfContainers, partitionedSamples},
															(* How many of these containers can we fit in the rack? *)
															currentFootprint=Lookup[fetchPacketFromCache[containerModel, cache], Footprint];
															numberOfContainers=Lookup[tubeFootprintToNumberOfPositions, currentFootprint];

															(* Take up to these number of containers. *)
															partitionedSamples=Partition[sampleGroupByContainerModel,UpTo[numberOfContainers]];

															(* Transpose this together with our instrument setting. Then return as a sequence. *)
															Sequence@@Transpose[{
																partitionedSamples,
																ConstantArray[instrumentSetting,Length[partitionedSamples]],
																ConstantArray[currentFootprint, Length[partitionedSamples]],
																ConstantArray[currentFootprint, Length[partitionedSamples]]/.tubeFootprintToRackModel
															}]
														]
													],
													{groupedSamplesByContainerModel,containerModelGroups}
												]
											]
										],
										{groupedSamples,settingGroups}
									];
									(* Transpose our result. *)
									{rollerRackGroupedSample,rollerRackInstrumentSettings,footprintInformation, rollerRackModels}=If[Length[transposedGroupInformation]==0,
										{{},{},{},{}},
										Transpose[transposedGroupInformation]
									];
									rollerRackSamplePositions = Range[Length[#]]&/@rollerRackGroupedSample;

									(* Create resources of these rack models, so they have unique Name to be used in groupSamples *)
									rollerRackResources = Resource[
										Sample->#,
										Name->CreateUUID[]
									]&/@rollerRackModels;
									(* create lookup for rack and its corresponding samples *)
									rackToSampleLookups = AssociationThread[rollerRackResources, rollerRackGroupedSample];

									(* apply groupSamples on rack resources since instrument only have footprint of racks *)
									{rollerRackGrouping,instruments,instrumentLocations,groupedSettings}=groupSamples[rollerRackResources,Lookup[rollerRackInstrumentSettings, Instrument],rollerRackInstrumentSettings,Cache->cache];

									(* Get the objects for these instruments. *)
									instrumentObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@instruments;

									(* Get the models of our objects. *)
									instrumentModels=(If[MatchQ[#,ObjectP[Object[Instrument]]],
										Download[Lookup[fetchPacketFromCache[#,cache],Model],Object],
										Download[Lookup[fetchPacketFromCache[#,cache],Object],Object]
									]&)/@instrumentObjects;

									(* Translate from instrument model to setting. *)
									translatedRates=MapThread[(instrumentInstrumentToSettingFunction[#1,cache][#2]&),{instrumentModels,UnitConvert[Lookup[groupedSettings,MixRate],RPM]}];

									(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the roller. *)
									additionalTime=MapThread[(
										(* Are we mixing until dissolved? *)
										If[#1,
											(#3-#2),
											0 Minute
										]&),{Lookup[groupedSettings,MixUntilDissolved],Lookup[groupedSettings,Time],Lookup[groupedSettings,MaxTime]}];

									(* get the batched samples *)
									batchedSamples = rollerRackGrouping/.rackToSampleLookups;
									(* get the batchedSample indices *)
									simulatedSampleIndices = (First[FirstPosition[simulatedSamples,#]]&)/@Flatten[batchedSamples];
									(* unflatten the indices so it can record which sample(s) on each rack *)
									batchedSampleIndices = Unflatten[simulatedSampleIndices, batchedSamples];

									(* We have to make our primitives in the compiler since they point to our source sample. *)
									(* Note: because roller positions footprint is rack, each roll parameter corresponding to one rack *)
									rollParameters=Flatten[MapThread[
										Function[{sampleGroup,instrument,instrumentLocation,settings, batchedSampleIndex},
											MapThread[
												<|
													Sample->Null,
													Instrument->Link[instrument],
													Location->#1,
													Rate->Lookup[settings,MixRate],
													Time->Lookup[settings,Time],
													MaxTime->Lookup[settings,MaxTime],
													Temperature->Lookup[settings,Temperature],
													AnnealingTime->Lookup[settings,AnnealingTime],
													MixUntilDissolved->Lookup[settings,MixUntilDissolved],
													ResidualIncubation->Lookup[settings,ResidualIncubation],
													BatchedSampleIndices -> #2,
													RollerRack -> Link[#3],
													(* Placement will be populated in compile *)
													SamplePlacements -> Null
												|>&,
												{instrumentLocation, batchedSampleIndex, sampleGroup}
											]
										],
										{rollerRackGrouping,instrumentObjects,instrumentLocations,groupedSettings, batchedSampleIndices}
									]];

									(* Note: because roller positions footprint is rack, the indices and lengths here are both pointing to racks *)
									(* Get our indices of our rack groupings. We are going to resource pick RollerParameters[[All, RollerRack]] so the order is consistent *)
									sampleGroupingIndices = Range[Length[Flatten[rollerRackGrouping]]];
									(* Get the lengths of our sample groupings. *)
									sampleGroupingLengths=Length/@rollerRackGrouping;
									{rollParameters, sampleGroupingIndices, sampleGroupingLengths}
								],
								{{}, {}, {}}
							];

							(* Compute our sample grouping for other roller instrument *)
							bottleRollerIncubateInformation=Cases[
								incubateInformation,
								(* for cases of BottleRoller *)
								{_, Except[KeyValuePattern[{Instrument->Model[Instrument, Roller, "id:Vrbp1jKKZw6z"]|Alternatives@@Download[Lookup[fetchPacketFromCache[Model[Instrument, Roller, "id:Vrbp1jKKZw6z"],cache],Objects],Object]}]]}
							];
							{bottleRollerParameters, bottleRollerGroupingIndices, bottleRollerGroupingLengths} = If[Length[bottleRollerIncubateInformation] > 0,
								Module[{bottleRollerIncubateSamples,bottleRollerInstrumentSettings, sampleGrouping,instruments,instrumentLocations,groupedSettings, instrumentObjects, instrumentModels, translatedRates, additionalTime, rollParameters, sampleGroupingIndices, sampleGroupingLengths},
									(* extract the sample and instrument information of bottle rollers *)
									{bottleRollerIncubateSamples,bottleRollerInstrumentSettings}= Transpose[bottleRollerIncubateInformation];

                  {sampleGrouping,instruments,instrumentLocations,groupedSettings}=groupSamples[bottleRollerIncubateSamples,Lookup[bottleRollerInstrumentSettings,Instrument],bottleRollerInstrumentSettings,Cache->cache];

									(* Get the objects for these instruments. *)
									instrumentObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@instruments;

									(* Translate our rates into instrument specific settings. *)
									(* Get the models of our objects. *)
									instrumentModels=(If[MatchQ[#,ObjectP[Object[Instrument]]],
										Download[Lookup[fetchPacketFromCache[#,cache],Model],Object],
										Download[Lookup[fetchPacketFromCache[#,cache],Object],Object]
									]&)/@instrumentObjects;

									(* Translate from instrument model to setting. *)
									translatedRates=MapThread[(instrumentInstrumentToSettingFunction[#1,cache][#2]&),{instrumentModels,UnitConvert[Lookup[groupedSettings,MixRate],RPM]}];

									(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group on the roller. *)
									additionalTime=MapThread[(
										(* Are we mixing until dissolved? *)
										If[#1,
											(#3-#2),
											0 Minute
										]&),{Lookup[groupedSettings,MixUntilDissolved],Lookup[groupedSettings,Time],Lookup[groupedSettings,MaxTime]}];

									(* We have to make our primitives in the compiler since they point to our source sample. *)
									rollParameters=Flatten[MapThread[
										Function[{sampleGroup,instrument,instrumentLocation,settings},
											(<|
												Sample->Null,
												Instrument->Link[instrument],
												Location->#,
												Rate->Lookup[settings,MixRate],
												Time->Lookup[settings,Time],
												MaxTime->Lookup[settings,MaxTime],
												Temperature->Lookup[settings,Temperature],
												AnnealingTime->Lookup[settings,AnnealingTime],
												MixUntilDissolved->Lookup[settings,MixUntilDissolved],
												ResidualIncubation->Lookup[settings,ResidualIncubation],
												BatchedSampleIndices -> Null,
												RollerRack -> Null,
												SamplePlacements -> Null
											|>&)/@instrumentLocation
										],
										{sampleGrouping,instrumentObjects,instrumentLocations,groupedSettings}
									]];

									(* Get our indices of our sample groupings. *)
									sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

									(* Get the lengths of our sample groupings. *)
									sampleGroupingLengths=Length/@sampleGrouping;
									{rollParameters, sampleGroupingIndices, sampleGroupingLengths}
								],
								{{}, {}, {}}
							];

							{
								Replace[RollParameters]-> Join[rollerParameters, bottleRollerParameters],
								Replace[RollIndices]-> Join[rollerGroupingIndices, bottleRollerGroupingIndices],
								Replace[RollBatchLength]->Join[rollerGroupingLengths, bottleRollerGroupingLengths]
							}
						]
					],
				Stir,
					(* There are not instruments with multiple slots so simply stir our samples one at a time. *)
					(* Therefore, no grouping is required. *)
					Module[{instrumentObjects,instrumentModels,instrumentPositions,time,maxTime,times,additionalTime,impellerResources,stirBarResources,stirParameters},

						(* Get the objects for these instruments. *)
						instrumentObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@Lookup[options,Instrument];

						(* Translate our rates into instrument specific settings. *)
						(* Get the models of our objects. *)
						instrumentModels=(If[MatchQ[#,ObjectP[Object[Instrument]]],
							Lookup[fetchPacketFromCache[#,cache],Model],
							Lookup[fetchPacketFromCache[#,cache],Object]
						]/.link_Link:>Download[link, Object]&)/@instrumentObjects;

						(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group. *)
						additionalTime=MapThread[(
							(* Are we mixing until dissolved? *)
							If[#1,
								(#3-#2),
								0 Minute
							]
						&),{Lookup[options,MixUntilDissolved],Lookup[options,Time],Lookup[options,MaxTime]}];

						(* Replace our impeller objects with resources. *)
						(* Importantly, create a separate resource for every impeller. *)
						(* This is because impellers will be dishwashed after use so for every stir sample, we need a different impeller. *)
						impellerResources=MapThread[
							Function[{sample, instrument, stirBar, aliquotContainer},
								Module[{impeller},
									impeller = Which[
										MatchQ[stirBar, ObjectP[]],
											Null,
										(* If we are aliquoting to an object container, find an impeller using the model *)
										MatchQ[aliquotContainer, ObjectP[Object[Container]]],
											compatibleImpeller[Lookup[fetchPacketFromCache[aliquotContainer,cache],Model],instrument,Cache->cache,Simulation->updatedSimulation],
										(* If we are aliquoting to a model container, find an impeller using the model *)
										MatchQ[aliquotContainer, ObjectP[Model[Container]]],
											compatibleImpeller[aliquotContainer,instrument,Cache->cache,Simulation->updatedSimulation],
										(* Otherwise we are not aliquoting, just use sample to find impeller *)
										True,
											compatibleImpeller[sample,instrument,Cache->cache,Simulation->updatedSimulation]
									];
									If[MatchQ[impeller, ObjectP[]],
										Resource[Sample->impeller],
										Null
									]
								]
							],
							{
								samples,
								instrumentModels,
								Lookup[options,StirBar],
								Lookup[options,AliquotContainer]
							}
						];

						stirBarResources=(If[MatchQ[#, ObjectP[]], Resource[Sample->#1], Null]&)/@Lookup[options,StirBar];

						(* We have to make our primitives in the compiler since they point to our source sample. *)
						stirParameters=Flatten[MapThread[
							Function[{instrument,impeller,rate,time,maxTime,temperature,annealingTime,mixUntilDissolved,residualIncubation,stirBarResource,stirBar,stirBarContainer,sampleContainer},
								If[MatchQ[time,GreaterP[0Minute]],
									<|
										Sample->Null,
										Impeller->impeller,
										Instrument->Link[instrument],
										Rate->rate,
										Time->time,
										MaxTime->maxTime,
										Temperature->temperature/.{Ambient->$AmbientTemperature, Null->$AmbientTemperature},
										AnnealingTime->annealingTime,
										MixUntilDissolved->mixUntilDissolved,
										ResidualIncubation->residualIncubation,
										StirBar->stirBarResource,
										(* If the specified stir bar is an object that's already in the container, we're going to leave it there afterward *)
										StirBarRetriever->If[MatchQ[stirBarResource,_Resource] &&
              					!(MatchQ[stirBar,ObjectP[Object[Part,StirBar]]] && MatchQ[First[stirBarContainer],First[sampleContainer]]),
											Resource[Sample->Model[Part, StirBarRetriever, "id:eGakldJlXP1o"]],
											Null
										]
									|>,
									Nothing
								]
							],
							{instrumentObjects,impellerResources,Lookup[options,MixRate],Lookup[options,Time],Lookup[options,MaxTime],Lookup[options,Temperature],Lookup[options,AnnealingTime],Lookup[options,MixUntilDissolved],Lookup[options,ResidualIncubation],stirBarResources,Lookup[options,StirBar],
								Quiet[Download[Lookup[options,StirBar],Container],{Download::FieldDoesntExist}],Download[samples,Container,Cache->cache,Simulation->simulation]}
						]];

						(* Get our indices of our sample groupings. *)
						sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@PickList[samples,MatchQ[#,GreaterP[0Minute]]&/@Lookup[options,Time]];

						{
							Replace[StirParameters]->stirParameters,
							Replace[StirIndices]->sampleGroupingIndices
						}
					],
				Homogenize,
					(* There are not instruments with multiple slots so simply stir our samples one at a time. *)
					(* Therefore, no grouping is required. *)
					Module[{instrumentObjects,instrumentModels,instrumentPositions,time,maxTime,times,additionalTime,sonicationHorns,sonicationHornResources,homogenizeParameters},

						(* Get the objects for these instruments. *)
						instrumentObjects=Download[Lookup[options,Instrument],Object];

						(* Get the models of our objects. *)
						instrumentModels=(If[MatchQ[#,ObjectP[Object[Instrument]]],
							Lookup[fetchPacketFromCache[#,cache],Model],
							Download[#,Object]
						]/.link_Link:>Download[link, Object]&)/@instrumentObjects;

						(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group. *)
						additionalTime=MapThread[(
							(* Are we mixing until dissolved? *)
							If[#1,
								(#3-#2),
								0 Minute
							]
						&),{Lookup[options,MixUntilDissolved],Lookup[options,Time],Lookup[options,MaxTime]}];

						(* Get the sonication horns for each instrument. *)
						sonicationHorns=MapThread[
							(compatibleSonicationHorn[#1,#2,Cache->cache,Simulation->updatedSimulation]&),
							{
								samples,
								instrumentModels
							}
						];

						(* Replace our impeller objects with resources. *)
						(* Importantly, create a separate resource for every impeller. *)
						(* This is because impellers will be dishwashed after use so for every stir sample, we need a different impeller. *)
						sonicationHornResources=(Resource[Sample->#1]&)/@sonicationHorns;

						(* We have to make our primitives in the compiler since they point to our source sample. *)
						homogenizeParameters=Flatten[MapThread[
							Function[{instrument,impeller,time,maxTime,dutyCycle,amplitude,temperature,maxTemperature,annealingTime,mixUntilDissolved,residualIncubation},
								If[MatchQ[time,GreaterP[0Minute]],
									<|
										Sample->Null,
										Horn->impeller,
										Instrument->Link[instrument],
										Time->time,
										MaxTime->maxTime,
										If[MatchQ[dutyCycle,Null],
											{
												DutyCycleOnTime->Null,
												DutyCycleOffTime->Null
											},
											{
												DutyCycleOnTime->dutyCycle[[1]],
												DutyCycleOffTime->dutyCycle[[2]]
											}
										],
										Amplitude->amplitude,
										Temperature->temperature/.{Ambient->$AmbientTemperature, Null->$AmbientTemperature},
										MaxTemperature->maxTemperature,
										AnnealingTime->annealingTime,
										MixUntilDissolved->mixUntilDissolved,
										ResidualIncubation->residualIncubation
									|>,
									Nothing
								]
							],
							{instrumentObjects,sonicationHornResources,Lookup[options,Time],Lookup[options,MaxTime],Lookup[options,DutyCycle],Lookup[options,Amplitude],Lookup[options,Temperature],Lookup[options,MaxTemperature],Lookup[options,AnnealingTime],Lookup[options,MixUntilDissolved],Lookup[options,ResidualIncubation]}
						]];

						(* Get our indices of our sample groupings. *)
						sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@PickList[samples,MatchQ[#,GreaterP[0Minute]]&/@Lookup[options,Time]];

						{
							Replace[HomogenizeParameters]->homogenizeParameters,
							Replace[HomogenizeIndices]->sampleGroupingIndices
						}
					],
				Sonicate,
					(* Even though there is only one position for the sonication bath, we should allow mutliple samples to be placed in the sonication bath at the same time. *)
					(* For example, when we have 10 2mL tubes, they should be allowed to be sonicated at the same time. *)
					Module[{incubateInformation, incubateSamples,instrumentSettings,instrumentObjects,sampleGrouping,instruments,groupedSettings,additionalTime,sonicateParameters,sonicationBatchLengths, adapterGrouping},

						(* Get the instrument settings that matter. *)
						incubateInformation=MapThread[
							(
								(* Only include groups over 0 Minute time. *)
								If[MatchQ[#2,GreaterP[0Minute]],
									{
										#1,
										{
											Time->#2,
											MaxTime->#3,
											MixUntilDissolved->#4,
											Temperature->#5,
											ResidualIncubation->#6,
											Amplitude->#7,
											MaxTemperature->#8,
											PreSonicationTime -> #9,
											AlternateInstruments -> #10
										}
									},
									Nothing
								]
							&),
							{
								samples,
								Lookup[options,Time],
								Lookup[options,MaxTime],
								Lookup[options,MixUntilDissolved],
								Lookup[options,Temperature]/.{Null->$AmbientTemperature},
								Lookup[options,ResidualIncubation],
								Lookup[options,Amplitude],
								Lookup[options,MaxTemperature],
								Lookup[options,PreSonicationTime],
								Lookup[options, AlternateInstruments]
							}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{incubateSamples,instrumentSettings}=If[Length[incubateInformation]>0,
							Transpose[incubateInformation],
							{{},{}}
						];

						(* Don't return anything if we don't have any samples. *)
						If[Length[incubateSamples]==0,
							Nothing,
							(* Compute our sample grouping. *)
							{sampleGrouping,instruments,groupedSettings,adapterGrouping}=groupSonicationSamples[incubateSamples,Download[Lookup[options,Instrument],Object],instrumentSettings,Cache->cache,Simulation->updatedSimulation];

							(* Get the objects for the instruments. *)
							instrumentObjects=(Download[#,Object]&)/@instruments;

							(* If MixUntilDissolved is true, compute the additional time that is needed for each sample group. *)
							additionalTime=MapThread[(
								(* Are we mixing until dissolved? *)
								If[#1,
									(#3-#2),
									0 Minute
								]
							&),{Lookup[groupedSettings,MixUntilDissolved],Lookup[groupedSettings,Time],Lookup[groupedSettings,MaxTime]}];

							(* We have to make our primitives in the compiler since they point to our source sample. *)
							sonicateParameters=Flatten[MapThread[
								Function[{sampleGroup,instrument,settings,adapter},
									Sequence@@ConstantArray[<|
										Sample->Null,
										Instrument->Link[instrument],
										Time->Lookup[settings,Time],
										MaxTime->Lookup[settings,MaxTime],
										MixUntilDissolved->Lookup[settings,MixUntilDissolved],
										Temperature->Lookup[settings,Temperature]/.{Null->$AmbientTemperature},
										ResidualIncubation->Lookup[settings,ResidualIncubation],
										DutyCycleOnTime->If[MatchQ[Lookup[settings,DutyCycle], _List],
											Lookup[settings,DutyCycle][[1]],
											Null
										],
										DutyCycleOffTime->If[MatchQ[Lookup[settings,DutyCycle], _List],
											Lookup[settings,DutyCycle][[2]],
											Null
										],
										Amplitude->Lookup[settings,Amplitude],
										MaxTemperature->Lookup[settings,MaxTemperature],
										PreSonicationTime-> Lookup[settings, PreSonicationTime],
										SonicationAdapter -> If[MatchQ[adapter, ObjectP[]],
											Link[Resource[Sample -> adapter, Name -> CreateUUID[]]],
											Null
										],
										AlternateInstruments -> Lookup[settings, AlternateInstruments]
									|>,Length[sampleGroup]]
								],
								{sampleGrouping,instrumentObjects,groupedSettings,adapterGrouping}
							]];

							(* Get our indices of our sample groupings. *)
							sampleGroupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@Flatten[sampleGrouping];

							(* Get the length of our sample groupings. *)
							sonicationBatchLengths=Length/@sampleGrouping;

							(* There are not stirrers with multiple slots so simply stir our samples one at a time. *)
							(* Therefore, no grouping is required. *)
							{
								Replace[SonicateParameters]->sonicateParameters,
								Replace[SonicateIndices]->sampleGroupingIndices,
								Replace[SonicateBatchLength]->sonicationBatchLengths
							}
						]
					],
				(* Plain incubation *)
				Null,
					(* Populate the information that we need to know about incubation. *)
					(* We are grouping incubation samples FYI. *)
					Module[{incubateInformation,incubateInformationWithoutThermocyclers,nonThermocyclerSamples,nonThermocyclerSamplesOptions,
						nonThermocyclerParameters,nonThermocyclerGroupingIndices,nonThermocyclerGroupingLengths,incubateInformationWithThermocyclers,
						thermocyclerSamples,thermocyclerSamplesOptions,thermocyclerParameters,thermocyclerGroupingIndices,thermocyclerGroupingLengths},

						(* Get the necessary thaw information about all the samples that we're going to incubate. *)
						incubateInformation=MapThread[
							(
								(* Only include groups over 0 Minute time, or transforms. *)
								If[MatchQ[#3,GreaterP[0Minute]] || #11,
									{
										#1,
										{
											Instrument->#2,
											Time->#3,
											Temperature->#4,
											AnnealingTime->#5,
											TemperatureProfile->#6,
											RelativeHumidity->#7,
											LightExposure->#8,
											LightExposureIntensity->#9,
											TotalLightExposure->#10,
											Transform->#11,
											TransformHeatShockTemperature->#12,
											TransformHeatShockTime->#13,
											TransformPreHeatCoolingTime->#14,
											TransformPostHeatCoolingTime->#15
										}
									},
									Nothing
								]
							&),
							{
								samples,Lookup[options,Instrument],Lookup[options,Time],Lookup[options,Temperature],Lookup[options,AnnealingTime],
								Lookup[options,TemperatureProfile], Lookup[options,RelativeHumidity],Lookup[options,LightExposure],
								Lookup[options,LightExposureIntensity],Lookup[options,TotalLightExposure],Lookup[options,Transform],Lookup[options,TransformHeatShockTemperature],
								Lookup[options,TransformHeatShockTime],Lookup[options,TransformPreHeatCoolingTime],Lookup[options,TransformPostHeatCoolingTime]
							}
						];

						(* Only include the samples that are not using a thermocycler. Those cannot be grouped together. *)
						incubateInformationWithoutThermocyclers=Cases[
							incubateInformation,
							{_, KeyValuePattern[Instrument->Except[ObjectP[{Model[Instrument, Thermocycler], Object[Instrument, Thermocycler]}]]]}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{nonThermocyclerSamples,nonThermocyclerSamplesOptions}=If[Length[incubateInformationWithoutThermocyclers]>0,
							Transpose[incubateInformationWithoutThermocyclers],
							{{},{}}
						];

						(* Get information for the non-thermocycler parameters. *)
						{nonThermocyclerParameters,nonThermocyclerGroupingIndices,nonThermocyclerGroupingLengths}=If[Length[nonThermocyclerSamples]==0,
							{{},{},{}},
							Module[
								{
									sampleGroupingResult,incubateFieldResults,sampleGroupings, instruments, times, temperatures, annealingTimes,
									instrumentObjects,parameters,groupingIndices,groupingLengths,relativeHumidites, lightExposures, lightExposureIntensities,
									totalLightExposures,transforms,transformHeatShockTemperatures,transformHeatShockTimes,transformPreHeatCoolingTimes,
									transformPostHeatCoolingTimes
								},
								(* Compute our sample groupings for thawing. *)
								(* This is in the format {{sampleGrouping,instrumentSettings}..}. *)
								sampleGroupingResult=groupIncubateSamples[nonThermocyclerSamples,nonThermocyclerSamplesOptions,cache];

								(* Create our thaw fields for the protocol object. *)
								incubateFieldResults=(Module[{sampleGrouping,settings},
									sampleGrouping=#[[1]];
									settings=#[[2]];

									{
										sampleGrouping,
										Lookup[settings,Instrument],
										Lookup[settings,Time],
										Lookup[settings,Temperature],
										Lookup[settings,AnnealingTime],
										Lookup[settings,RelativeHumidity],
										Lookup[settings,LightExposure],
										Lookup[settings,LightExposureIntensity],
										Lookup[settings,TotalLightExposure],
										Lookup[settings,Transform],
										Lookup[settings,TransformHeatShockTemperature],
										Lookup[settings,TransformHeatShockTime],
										Lookup[settings,TransformPreHeatCoolingTime],
										Lookup[settings,TransformPostHeatCoolingTime]
									}
								]&)/@sampleGroupingResult;

								(* Transpose our result. *)
								{
									sampleGroupings,
									instruments,
									times,
									temperatures,
									annealingTimes,
									relativeHumidites,
									lightExposures,
									lightExposureIntensities,
									totalLightExposures,
									transforms,
									transformHeatShockTemperatures,
									transformHeatShockTimes,
									transformPreHeatCoolingTimes,
									transformPostHeatCoolingTimes
								}=If[Length[incubateFieldResults]>0,
									Transpose[incubateFieldResults],
									ConstantArray[{},14]
								];

								(* Get the objects for these instruments. *)
								instrumentObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@instruments;

								(* We have to make our primitives in the compiler since they point to our source sample. *)
								parameters=Flatten[MapThread[
									Function[
										{
											sampleGroup,instrument,time,temperature,annealingTime,relativeHumidity,lightExposure,lightExposureIntensity,
											totalLightExposure,transform,transformHeatShockTemperature,transformHeatShockTime,transformPreHeatCoolingTime,
											transformPostHeatCoolingTime
										},
										ConstantArray[<|
											Sample->Null,
											Instrument->Link[instrument],
											Time->time,
											Temperature->temperature/.{Ambient->$AmbientTemperature, Null->$AmbientTemperature},
											AnnealingTime->annealingTime/.{Null->0 Minute},
											TemperatureProfile->Null,
											PlateSeal->Null,
											RelativeHumidity->relativeHumidity,
											LightExposure->lightExposure,
											LightExposureIntensity->lightExposureIntensity,
											TotalLightExposure->totalLightExposure,
											Transform->transform,
											TransformHeatShockTemperature->transformHeatShockTemperature,
											TransformHeatShockTime->transformHeatShockTime,
											TransformPreHeatCoolingTime->transformPreHeatCoolingTime,
											TransformPostHeatCoolingTime->transformPostHeatCoolingTime
										|>,Length[sampleGroup]]
									],
									{
										sampleGroupings,instrumentObjects,times,temperatures,annealingTimes,relativeHumidites,lightExposures,lightExposureIntensities,
										totalLightExposures,transforms,transformHeatShockTemperatures,transformHeatShockTimes,transformPreHeatCoolingTimes,
										transformPostHeatCoolingTimes
									}
								]];

								(* Get our indices of our sample groupings. *)
								(* Incubate knapsack operates on containers so use those to get our index. *)
								simulatedContainers=(Lookup[fetchPacketFromCache[#,cache],Container]/.{link_Link:>Download[link, Object]}&)/@simulatedSamples;
								groupingIndices=(First[FirstPosition[simulatedContainers,#]]&)/@Flatten[sampleGroupings];

								(* Get the lengths of our sample groupings. *)
								groupingLengths=Length/@sampleGroupings;

								{parameters,groupingIndices,groupingLengths}
							]
						];

						(* Get the samples that are using a thermocycler. *)
						incubateInformationWithThermocyclers=Cases[
							incubateInformation,
							{_, KeyValuePattern[Instrument->ObjectP[{Model[Instrument, Thermocycler], Object[Instrument, Thermocycler]}]]}
						];

						(* Transpose our thaw information to get just our samples and thaw settings. *)
						{thermocyclerSamples,thermocyclerSamplesOptions}=If[Length[incubateInformationWithThermocyclers]>0,
							Transpose[incubateInformationWithThermocyclers],
							{{},{}}
						];

						(* Get information for the non-thermocycler parameters. *)
						{thermocyclerParameters,thermocyclerGroupingIndices,thermocyclerGroupingLengths}=If[Length[thermocyclerSamples]==0,
							{{},{},{}},
							Module[
								{samplesAndContainer,containers,containerToSample,samplesAndOptions,samplesAndOptionsWithCounts,
									containersAndOptionsWithCounts,uniqueContainersAndOptions,containersAndOptionsWithMaxCounts,
									expandedContainersAndOptions,parameters,groupingIndices,groupingLengths,expandedSamplesAndOptions},

								(* For each sample in our input, get the container that they live in. In the form {sample,container}. *)
								samplesAndContainer=({#,Lookup[fetchPacketFromCache[#,cache],Container]}/.{link_Link:>Download[link, Object]}&)/@thermocyclerSamples;

								(* Get all of the containers (duplicates deleted) that we are mixing. *)
								containers=DeleteDuplicates[samplesAndContainer[[All,2]]];

								(* For each container, choose a representative sample from that container. *)
								containerToSample=(#->FirstCase[samplesAndContainer,{_,#}][[1]]&)/@containers;

								(* Transpose our samples and settings together. In the form {{sample,instrument,setting}..}. *)
								samplesAndOptions=Transpose[{thermocyclerSamples,Download[Lookup[thermocyclerSamplesOptions,Instrument], Object],thermocyclerSamplesOptions}];

								(* Include the number of times each {sample,instrument,setting} shows up. *)
								(* This is in the form {{{sample,instrument,setting},count}..}. *)
								samplesAndOptionsWithCounts=Function[{countInformation},
									{countInformation[[1]],countInformation[[2]]}
								]/@Normal[Counts[samplesAndOptions]];

								(* Replace each sample with its container. *)
								(* This is in the form {{{container,instrument,setting},count}..}. *)
								containersAndOptionsWithCounts=samplesAndOptionsWithCounts/.{sample:ObjectP[Object[Sample]]:>Download[Lookup[fetchPacketFromCache[sample,cache],Container,Null],Object]};

								(* Get the biggest times for each {container,instrument,setting}. *)
								uniqueContainersAndOptions=DeleteDuplicates[containersAndOptionsWithCounts[[All,1]]];

								(* This variable is in the form {{{container,instrument,setting},largestCount}..} *)
								containersAndOptionsWithMaxCounts=Function[{containerAndOption},
									(* Get all the cases of {{container,instrument,setting},_}. *)
									cases=Cases[containersAndOptionsWithCounts,{containerAndOption,_}];

									(* Choose the largest number. *)
									largestCount=Max[cases[[All,2]]];

									(* Return the conatiner/options with the largest number. *)
									{containerAndOption,largestCount}
								]/@uniqueContainersAndOptions;

								(* Constant array out our {container,instrument,setting} based on the largestCount. *)
								expandedContainersAndOptions=Function[{containerAndOptionWithMaxCount},
									Sequence@@ConstantArray[containerAndOptionWithMaxCount[[1]],containerAndOptionWithMaxCount[[2]]]
								]/@containersAndOptionsWithMaxCounts;

								(* Map our containers to their representative samples. *)
								expandedSamplesAndOptions=expandedContainersAndOptions/.containerToSample;

								(* Overwrite our incubation samples and instrument options. *)
								thermocyclerSamples=expandedSamplesAndOptions[[All,1]];
								thermocyclerSamplesOptions=expandedSamplesAndOptions[[All,3]];

								(* We have to make our primitives in the compiler since they point to our source sample. *)
								parameters=MapThread[
									Function[{sample, options},
										<|
											Sample->Null,
											Instrument->Link[Lookup[options, Instrument]],
											Time->Lookup[options, Time],
											Temperature->Lookup[options, Temperature],
											AnnealingTime->Lookup[options, AnnealingTime]/.{Null->0 Minute},
											TemperatureProfile->Lookup[options, TemperatureProfile],
											PlateSeal->Link[Model[Item, PlateSeal, "id:9RdZXv17jeqZ"]],
											RelativeHumidity->Null,
											LightExposure->Null,
											LightExposureIntensity->Null,
											TotalLightExposure->Null,
											Transform->Null,
											TransformHeatShockTemperature->Null,
											TransformHeatShockTime->Null,
											TransformPreHeatCoolingTime->Null,
											TransformPostHeatCoolingTime->Null
										|>
									],
									{thermocyclerSamples,thermocyclerSamplesOptions}
								];

								(* Get our indices of our sample groupings. *)
								(* Incubate knapsack operates on containers so use those to get our index. *)
								groupingIndices=(First[FirstPosition[simulatedSamples,#]]&)/@thermocyclerSamples;

								(* Get the lengths of our sample groupings. *)
								groupingLengths=ConstantArray[1, Length[parameters]];

								{parameters,groupingIndices,groupingLengths}
							]
						];

						{
							Replace[IncubateParameters]->Join[
								nonThermocyclerParameters,
								thermocyclerParameters
							],
							Replace[IncubateIndices]->Join[
								nonThermocyclerGroupingIndices,
								thermocyclerGroupingIndices
							],
							Replace[IncubateBatchLength]->Join[
								nonThermocyclerGroupingLengths,
								thermocyclerGroupingLengths
							]
						}
					],
				_,
					Nothing
			]
		]/@groupedSamples];

		(*-- COMPUTE THAW FIELDS --*)
		thawFields=Module[
			{thawInformation,thawSamples,thawSettings,sampleGroupingResult,thawSampleGroupings,thawFieldsResult,
			thawTimes,thawMaxTimes,thawTemperatures,thawInstruments,
			thawInstrumentObjects,uniqueInstrumentObjects,thawInstrumentTimes,instrumentPositions,
			time,maxTime,times,additionalTime,instrumentObjectToResourceMap,
			releaseBooleans,resourceIndices,selectBooleans,instrumentResources},

			(* Get the necessary thaw information about all the samples that we're going to thaw. *)
			thawInformation=MapThread[(
					(* Are we going to thaw this sample? *)
					If[MatchQ[Lookup[#2,Thaw,False],True],
						(* We are thawing this sample. *)
						(* Return the relevant information *)
						{
							#1,
							MapThread[
								(#1->#2&),
								{
									{ThawTime,MaxThawTime,ThawTemperature,ThawInstrument},
									Lookup[#2,{ThawTime,MaxThawTime,ThawTemperature,ThawInstrument},Null]
								}
							]
						},
						(* We are not thawing this sample. *)
						Nothing
					]
				&),
				{sampleObjects,mapThreadFriendlyOptions}
			];

			(* Transpose our thaw information to get just our samples and thaw settings. *)
			{thawSamples,thawSettings}=If[Length[thawInformation]>0,
				Transpose[thawInformation],
				{{},{}}
			];

			(* Compute our sample groupings for thawing. *)
			(* This is in the format {{sampleGrouping,instrumentSettings}..}. *)
			sampleGroupingResult=groupIncubateSamples[thawSamples,thawSettings,cache];

			(* Create our thaw fields for the protocol object. *)
			thawFieldsResult=(Module[{sampleGrouping,settings},
				sampleGrouping=#[[1]];
				settings=#[[2]];

				{
					sampleGrouping,
					Lookup[settings,ThawTime],
					Lookup[settings,MaxThawTime],
					Lookup[settings,ThawTemperature],
					Lookup[settings,ThawInstrument]
				}
			]&)/@sampleGroupingResult;

			(* Transpose our result. *)
			{
				thawSampleGroupings,
				thawTimes,
				thawMaxTimes,
				thawTemperatures,
				thawInstruments
			}=If[Length[thawFieldsResult]>0,
				Transpose[thawFieldsResult],
				{{},{},{},{},{}}
			];

			(* Get the objects for these instruments. *)
			thawInstrumentObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@thawInstruments;

			(* Get a list of unique instrument objects. *)
			uniqueInstrumentObjects=DeleteDuplicates[thawInstrumentObjects];

			(* Figure out the total time that a particular instrument object is going to be used. *)
			thawInstrumentTimes=Function[{instrument},
				(* Get the positions that this instrument shows up. *)
				instrumentPositions=Flatten[Position[thawInstrumentObjects,instrument,1]];

				(* Take Time and MaxTime of these positions. *)
				time=thawTimes[[instrumentPositions]];
				maxTime=thawMaxTimes[[instrumentPositions]];

				(* Take MaxTime if it's not Null. Otherwise, take Time. *)
				times=MapThread[(If[!MatchQ[#2,Null],#2,#1]&),{time,maxTime}];

				(* Total up these times. *)
				Total[times]
			]/@uniqueInstrumentObjects;

			(* Compute the additional time to thaw the sample. *)
			additionalTime=MapThread[(
				If[EqualQ[#1,#2],
					Null,
					Max[
						Min[Ceiling[UnitConvert[(#2-#1),Minute]],#1],
						1 Second(* The timing task can't accept 0 Second, so if our Ceiling call converts to 0s, adjust up to 1s*)
					]
				]
			&),{thawTimes,thawMaxTimes}];

			(* Create resources for each of these instrument objects. *)
			instrumentObjectToResourceMap=MapThread[(#1->Resource[Instrument->#1,Time->#2,Name->ToString[Unique[]]]&),{uniqueInstrumentObjects,thawInstrumentTimes}];

			(* Compute instrument location indices. *)
			(* First, convert our instruments to resource form. *)
			instrumentResources=thawInstrumentObjects/.instrumentObjectToResourceMap;

			(* Compute whether each vortex should be released. *)
			releaseBooleans=MapThread[Function[{instrumentIndex,instrument},
					(* An incubator should be released if it's the last instance that we are going to use that incubator. *)
					(* We can tell if the incubator is the same by comparing the resources (the same incubator will be inidicated by the same resource). *)

					(* Get all of the positions in which this resource appears. *)
					resourceIndices=Flatten[Position[instrumentResources,instrument,1]];

					(* Are we at the last instance of this resource appearing? If so, we should release the incubator. *)
					MatchQ[Last[resourceIndices],instrumentIndex]
				],
				{Range[Length[thawInstrumentObjects]],instrumentResources}
			];

			(* Compute whether each incubator should be selected. *)
			selectBooleans=MapThread[Function[{instrumentIndex,instrument},
					(* A incubator should be selected if it's the first instance that we are going to use that incubator. *)
					(* We can tell if the incubator is the same by comparing the resources (the same incubator will be inidicated by the same resource). *)

					(* Get all of the positions in which this resource appears. *)
					resourceIndices=Flatten[Position[instrumentResources,instrument,1]];

					(* Are we at the first instance of this resource appearing? If so, we should select the vortex. *)
					MatchQ[First[resourceIndices],instrumentIndex]
				],
				{Range[Length[thawInstrumentObjects]],instrumentResources}
			];

			(* We have to make our primitives in the compiler since they point to our source sample. *)
			thawParameters=Flatten[MapThread[
				Function[{sampleGroup,instrument,time,maxTime,temperature},
					ConstantArray[<|
						Sample->Null,
						Instrument->instrument,
						Time->time,
						MaxTime->maxTime,
						Temperature->temperature
					|>,Length[sampleGroup]]
				],
				{thawSampleGroupings,instrumentResources,thawTimes,thawMaxTimes,thawTemperatures}
			]];

			(* Get our indices of our sample groupings. *)
			(* Incubate knapsack operates on containers so use those to get our index. *)
			simulatedContainers=(Lookup[fetchPacketFromCache[#,cache],Container]/.{link_Link:>Download[link, Object]}&)/@simulatedSamples;
			sampleGroupingIndices=(First[FirstPosition[simulatedContainers,#]]&)/@Flatten[thawSampleGroupings];

			(* Get the lengths of our sample groupings. *)
			sampleGroupingLengths=Length/@thawSampleGroupings;

			(* Gather up our thaw fields. *)
			{
				Replace[ThawParameters]->thawParameters,
				Replace[ThawIndices]->sampleGroupingIndices,
				Replace[ThawBatchLength]->sampleGroupingLengths,
				Replace[ThawInstruments]->instrumentResources,
				Replace[ThawSelect]->selectBooleans,
				Replace[ThawRelease]->releaseBooleans,
				Replace[ThawTime]->thawTimes,
				Replace[ThawAdditionalTime]->additionalTime,
				Replace[ThawTemperature]->thawTemperatures
			}
		];

		(* Compute the estimated timing of the thawing checkpoint of the protocol. *)
		estimatedThawTime=Total[
			Flatten[{
				(* Add up all times and max times. Assume that we will only need 1/2 of the additional thaw time until the sample grouping is thawed. *)
				Lookup[thawFields,Replace[ThawTime],{}],
				(1/2)*Lookup[thawFields,Replace[AdditionalThawTime],{}]/.{Null->0 Minute},
				0 Minute
			}]
		];

		(* Compute the estimated timing of the mixing checkpoint of the protocol. *)
		estimatedMixTime=Total[
			Flatten[{
				(* Estimate that each inversion will take 30 Seconds. *)
				Length[Lookup[protocolFields,Replace[InvertSamples],{}]]*.5 Minute,
				(* Pipetting is done via a subprotocol and will get its time added.*)
				(* Add up all minimal times and assume that MixUntilDissolved will take 1/2 of the additional time. *)
				(Lookup[Lookup[protocolFields,Replace[#],{}],Time,0Minute]&)/@{IncubateParameters,VortexParameters,ShakeParameters,RollParameters,StirParameters,SonicateParameters,HomogenizeParameters}/.Null->0*Minute,
				1/2*(Lookup[Lookup[protocolFields,Replace[#],{}],MaxTime,0Minute]/.Null->0&)/@{VortexParameters,ShakeParameters,RollParameters,StirParameters,SonicateParameters,HomogenizeParameters},
				(Lookup[Lookup[protocolFields,Replace[#],{}],AnnealingTime,0Minute]/.Null->0&)/@{IncubateParameters,ShakeParameters,RollParameters,StirParameters,HomogenizeParameters},
				(Lookup[Lookup[protocolFields,Replace[IncubateParameters],{}],TransformHeatShockTime,0Minute])/.Null->0*Minute,
				(Lookup[Lookup[protocolFields,Replace[IncubateParameters],{}],TransformPreHeatCoolingTime,0Minute])/.Null->0*Minute,
				(Lookup[Lookup[protocolFields,Replace[IncubateParameters],{}],TransformPostHeatCoolingTime,0Minute])/.Null->0*Minute,
				0 Minute
			}]
		];

		(* Populate the QueuedIncubationTypes and QueueIncubationBatches fields based on the batches for our mix types. *)
		(* Note: Thawing, Inversion, and Pipetting and not queued for multi-incubate because they cannot be optimized in that way. *)
		multiIncubateFields={
			Replace[QueuedIncubationTypes]->Flatten[
				Map[
					ConstantArray[#[[1]],Length[Lookup[protocolFields,Replace[#[[2]]],{}]]]&,
					{
						{Null,IncubateBatchLength},
						{Vortex,VortexBatchLength},
						{Shake,ShakeBatchLength},
						{Roll,RollBatchLength},
						{Stir,StirParameters},
						{Sonicate,SonicateBatchLength},
						{Homogenize,HomogenizeParameters},
						{Nutate,NutateBatchLength},
						{Disrupt,DisruptBatchLength}
					}
				]
			],
			Replace[QueuedIncubationBatches]->Flatten[
				{
					(* Note: Stirring is always of length batch 1. Therefore, we use the StirParameters field. *)
					Range[Length[Lookup[protocolFields,Replace[#],{}]]]&/@{IncubateBatchLength,VortexBatchLength,ShakeBatchLength,RollBatchLength,StirParameters,SonicateBatchLength,HomogenizeParameters,NutateBatchLength,DisruptBatchLength}
				}
			]
		};

		(* Set transform resources *)
		{
			transformCoolerResource,
			transformCoolerPowerCableLink,
			transformBiosafetyCabinetResource,
			transformBiosafetyWasteBinResource,
			transformBiosafetyWasteBagResource,
			transformRecoveryPipetteResource,
			transformRecoveryTipResources,
			transformRecoveryMediaResources
		} = If[MemberQ[Lookup[myResolvedOptions, Transform], True | {True..}],
			{
				Link@Resource[Instrument -> {
					Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"], (* "ICECO GO20 Portable Refrigerator" *)
					Model[Instrument, PortableCooler, "id:eGakldJdO9le"] (* "ICECO GO12" *)
				}],
				Link@Model[Wiring, Cable, "Portable cooler power cable for Transform"][Objects][[1]],
				Link@Resource[Instrument -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Microbiology"]], (* "Biosafety Cabinet Handling Station for Microbiology" *)
				Link@Resource[Sample -> Model[Container, WasteBin, "id:7X104v1DJmX6"]], (* "Biohazard Waste Container, BSC" *)
				Link@Resource[Sample -> Model[Item, Consumable, "id:7X104v6oeYNJ"]], (* "Biohazard Waste Bags, 8x12" *)
				Link@Resource[Instrument -> Model[Instrument, Pipette, "id:GmzlKjP3boWe"]], (* "Eppendorf Research Plus P1000, Microbial" *)
				ConstantArray[
					Link@Resource[
						Sample -> Model[Item, Tips, "id:n0k9mGzRaaN3"], (* "1000 uL reach tips, sterile" *)
						Amount -> Length[mySamples]
					],
					Length[mySamples]
				],
				MapThread[
					Link@Resource[Sample -> #1, Container -> #2]&,
					{Lookup[myUnresolvedOptions, TransformRecoveryMedia], Lookup[myUnresolvedOptions, TransformRecoveryMedia][Container][Object]}
				]
			},
			(* Return Nulls if not transforming *)
			ConstantArray[Null, 8]
		];

		(* Create our final packet. *)
		result=Join[
			Association[protocolFields],
			Association[thawFields],
			Association[multiIncubateFields],
			<|
				Type->Object[Protocol,Incubate],
				Object->CreateID[Object[Protocol,Incubate]],
				Replace[SamplesIn]->(Resource[Sample->#]&)/@originalSampleObjects,
				Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[Download[Lookup[fetchPacketFromCache[#,cache],Container], Object]&/@originalSampleObjects],
				Replace[Checkpoints]->{
					{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time->10 Minute]},
					{"Preparing Samples",0 Minute,"Preprocessing, such as incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator->$BaselineOperator,Time->0 Minute]},
					{"Thawing",estimatedThawTime,"The containers/samples are thawed.",Resource[Operator->$BaselineOperator,Time->30 Minute]},
					{"Incubation",estimatedMixTime,"The containers/samples are mixed and/or incubated.",Resource[Operator->$BaselineOperator,Time->1 Hour]},
					{"Returning Materials",15 Minute,"Samples are returned to storage.",Resource[Operator->$BaselineOperator,Time->15 Minute]}
				},
				Replace[Thaw]->Lookup[myResolvedOptions, Thaw],
				Replace[ThawTimes]->Lookup[myResolvedOptions, ThawTime],
				Replace[MaxThawTimes]->Lookup[myResolvedOptions, MaxThawTime],
				Replace[ThawTemperatures]->Lookup[myResolvedOptions, ThawTemperature],
				Replace[ThawInstrument]->(Link/@Lookup[myResolvedOptions, ThawInstrument]),
				Replace[Mix]->Lookup[myResolvedOptions, Mix],
				Replace[MixTypes]->Lookup[myResolvedOptions, MixType],
				Replace[MixUntilDissolved]->Lookup[myResolvedOptions, MixUntilDissolved],
				Replace[Instruments]->(Link/@Lookup[myResolvedOptions, Instrument]),
				Replace[StirBars]->(Link/@Lookup[myResolvedOptions, StirBar]),
				Replace[Times]->Lookup[myResolvedOptions, Time],
				Replace[DutyCycles]->(If[!MatchQ[#, _List], <|On->Null,Off->Null|>, <|On->#[[1]],Off->#[[2]]|>]&)/@Lookup[myResolvedOptions, DutyCycle],
				Replace[MixRates]->Lookup[myResolvedOptions, MixRate],
				Replace[MixRateProfiles]->Lookup[myResolvedOptions, MixRateProfile],
				Replace[NumberOfMixes]->Lookup[myResolvedOptions, NumberOfMixes],
				Replace[MaxNumberOfMixes]->Lookup[myResolvedOptions, MaxNumberOfMixes],
				Replace[MixVolumes]->Lookup[myResolvedOptions, MixVolume],
				Replace[Temperatures]->Lookup[myResolvedOptions, Temperature]/.{Ambient->25 Celsius},
				Replace[TemperatureProfiles]->Lookup[myResolvedOptions, TemperatureProfile],
				Replace[MaxTemperatures]->Lookup[myResolvedOptions, MaxTemperature],
				Replace[RelativeHumidities]->Lookup[myResolvedOptions, RelativeHumidity],
				Replace[LightExposures]->Lookup[myResolvedOptions, LightExposure],
				Replace[LightExposureIntensities]->Lookup[myResolvedOptions, LightExposureIntensity],
				Replace[LightExposureStandards]->If[MatchQ[Lookup[myResolvedOptions, LightExposureStandard], _List],
					(Resource[Sample->#]&)/@Lookup[myResolvedOptions, LightExposureStandard],
					{}
				],
				LightExposureStandardBox->If[MatchQ[Lookup[myResolvedOptions, LightExposureStandard], _List] && Length[Lookup[myResolvedOptions, LightExposureStandard]]>0,
					Resource[Sample->Model[Container, LightBox, "id:N80DNj1VKxME"]],
					Null
				],
				Replace[OscillationAngles]->Lookup[myResolvedOptions, OscillationAngle],
				Replace[Amplitudes]->Lookup[myResolvedOptions, Amplitude],
				Replace[AnnealingTime]->Lookup[myResolvedOptions, AnnealingTime],
				Replace[ResidualIncubation]->Lookup[myResolvedOptions, ResidualIncubation],
				Replace[ResidualTemperatures]->Lookup[myResolvedOptions, ResidualTemperature],
				Replace[ResidualMix]->Lookup[myResolvedOptions, ResidualMix],
				Replace[ResidualMixRates]->Lookup[myResolvedOptions, ResidualMixRate],
				Replace[Preheat]->Lookup[myResolvedOptions, Preheat],
				Replace[Transform]->Lookup[myResolvedOptions, Transform],
				Replace[TransformHeatShockTemperature]->Lookup[myResolvedOptions, TransformHeatShockTemperature],
				Replace[TransformHeatShockTime]->Lookup[myResolvedOptions, TransformHeatShockTime],
				Replace[TransformPreHeatCoolingTime]->Lookup[myResolvedOptions, TransformPreHeatCoolingTime],
				Replace[TransformPostHeatCoolingTime]->Lookup[myResolvedOptions, TransformPostHeatCoolingTime],
				TransformCooler -> transformCoolerResource,
				TransformCoolerPowerCable -> transformCoolerPowerCableLink,
				TransformBiosafetyCabinet -> transformBiosafetyCabinetResource,
				TransformBiosafetyWasteBin -> transformBiosafetyWasteBinResource,
				TransformBiosafetyWasteBag -> transformBiosafetyWasteBagResource,
				TransformRecoveryPipette -> transformRecoveryPipetteResource,
				Replace[TransformRecoveryTips] -> transformRecoveryTipResources,
				Replace[TransformRecoveryMedia] -> transformRecoveryMediaResources,
				Replace[TransformRecoveryTransferVolumes] -> Lookup[myResolvedOptions, TransformRecoveryTransferVolumes],
				TransformRecoveryIncubationTime -> Lookup[myResolvedOptions, TransformRecoveryIncubationTime],
				TransformIncubator -> Lookup[myResolvedOptions, TransformIncubator],
				TransformIncubatorTemperature -> Lookup[myResolvedOptions, TransformIncubatorTemperature],
				TransformIncubatorShakingRate -> Lookup[myResolvedOptions, TransformIncubatorShakingRate],
				Replace[AlternateInstruments]->Lookup[myResolvedOptions, AlternateInstruments],

				HandlingEnvironment->Link[handlingEnvironmentResource],

				ResolvedOptions->myCollapsedResolvedOptions,
				UnresolvedOptions->myUnresolvedOptions
			|>,
			populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->updatedSimulation]
		];

		(* Return our protocol packet and no unit operation packets. *)
		{result, Null},


		(*---- Do the resource packets for if preparation is Robotic ----*)
		If[MatchQ[preparation,Robotic],

			(* Create label to resource lookups for our samples and containers. *)
			sampleLabelResources=MapThread[
				Function[{sampleLabel, sample},
					Resource[
						Sample->sample,
						Name->CreateUUID[]
					]
				],
				{Lookup[myResolvedOptions, SampleLabel], mySamples}
			];

			sampleContainerLabelResources=MapThread[
				Function[{sampleLabel, sampleContainer},
					Resource[
						Sample->sampleContainer,
						Name->CreateUUID[]
					]
				],
				{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}
			];

			(* Create resources for our instruments. *)
			instrumentResources=(
				If[MatchQ[#,ObjectP[]],
					Resource[
						Instrument->#,
						Time->5 Minute, (* NOTE: This key doesn't actually matter because it'll be changed to the time of the work cell resource. *)
						Name->CreateUUID[]
					],
					Null
				]
			&)/@Lookup[myResolvedOptions, Instrument];

			(* Create resources for our tips. *)
			tipResources=(
				If[MatchQ[#, Except[Null]],
					Resource[
						Sample->#,
						Amount->1,
						Name->CreateUUID[]
					],
					Null
				]
			&)/@Lookup[myResolvedOptions, Tips];

			(* Upload our UnitOperation with the options replaced with resources. *)
			unitOperationPacket=Module[{nonHiddenOptions},
				(* Only include non-hidden options from Incubate. *)
				nonHiddenOptions=Lookup[
					Cases[OptionDefinition[ExperimentIncubate], KeyValuePattern["Category"->Except["Hidden"]]],
					"OptionSymbol"
				];

				(* upload the corresponding unit operation depending on which experiment function is called*)
				If[MatchQ[experimentFunction,ExperimentIncubate],
					(* Upload a Incubate unit operation if the experiment is incubate*)
					UploadUnitOperation[
						Incubate@@Join[
							{
								SampleLink->(Resource[Sample->#]&)/@originalSampleObjects,
								WorkCell->Lookup[myResolvedOptions, WorkCell]
							},
							ReplaceRule[
								Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
								{
									Instrument->instrumentResources,
									Tips->tipResources,
									PlateTilter->If[MemberQ[Lookup[myResolvedOptions, {MixTiltAngle}], GreaterP[0 AngularDegree], Infinity],
										Resource[
											Instrument->Model[Instrument, PlateTilter, "id:eGakldJkWVk4"] (* "Hamilton Plate Tilter" *)
										],
										Null
									],
									MultichannelMixName->Lookup[myResolvedOptions, MultichannelMixName]
								}
							]
						],
						Preparation->Robotic,
						UnitOperationType->Output,
						FastTrack->True,
						Upload->False
					],

					(* Upload a mix unit operation if the experiment is mix*)
					UploadUnitOperation[
						Mix@@Join[
							{
								SampleLink->(Resource[Sample->#]&)/@originalSampleObjects,
								WorkCell->Lookup[myResolvedOptions, WorkCell]
							},
							ReplaceRule[
								Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
								{
									Instrument->instrumentResources,
									Tips->tipResources,
									PlateTilter->If[MemberQ[Lookup[myResolvedOptions, {MixTiltAngle}], GreaterP[0 AngularDegree], Infinity],
										Resource[
											Instrument->Model[Instrument, PlateTilter, "id:eGakldJkWVk4"] (* "Hamilton Plate Tilter" *)
										],
										Null
									],
									MultichannelMixName->Lookup[myResolvedOptions, MultichannelMixName]
								}
							]
						],
						Preparation->Robotic,
						UnitOperationType->Output,
						FastTrack->True,
						Upload->False
					]
				]
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			unitOperationPacketWithLabeledObjects=Append[
				unitOperationPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{Lookup[myResolvedOptions, SampleLabel], sampleLabelResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], sampleContainerLabelResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					]
				]
			];

			(* Return our protocol packet (we don't have one) and our unit operation packet. *)
			{Null,{unitOperationPacketWithLabeledObjects}}
		]

	];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
			{True, {}},
		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[preparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation->updatedSimulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->cache, Simulation->updatedSimulation], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		{protocolPacket, unitOperationPackets}/.resourceToNameReplaceRules,
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		previewRule,
		optionsRule,
		resultRule,
		testsRule
	}
];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentIncubate,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentIncubate[
	myProtocolPacket:(PacketP[Object[Protocol, Incubate], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:(ListableP[PacketP[]]|$Failed|Null),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentIncubate]
]:=Module[
	{
		mapThreadFriendlyOptions, resolvedPreparation, resolvedWorkCell, protocolType, cache, simulation, samplePackets,
		sampleModelPackets, protocolObject, fulfillmentSimulation, currentSimulation, simulatedSampleStatePackets,
		simulationWithLabels
	},

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download containers and related model info from cache and simulation *)
	{
		samplePackets,
		sampleModelPackets
	} = Quiet[
		Download[
			{
				mySamples,
				mySamples
			},
			{
				{Evaluate[Packet[{Model, Container, Composition, MeltingPoint, State, Volume, Mass, Density}]]},
				{Packet[Model[{MeltingPoint, Composition}]]}
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::MissingCacheField}
	];

	{samplePackets, sampleModelPackets} = Flatten /@ {samplePackets, sampleModelPackets};

	(* Lookup our resolved preparation option. *)
	{resolvedPreparation, resolvedWorkCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];

	(* If preparation is Robotic, determine the protocol type (RCP vs. RSP) that we want to create an ID for. *)
	protocolType = If[MatchQ[resolvedPreparation, Robotic],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		],
		Object[Protocol,Incubate]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[MatchQ[resolvedPreparation, Robotic] || MatchQ[myProtocolPacket, $Failed|Null],
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		SimulateCreateID[protocolType],
		Lookup[myProtocolPacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentIncubate,
		myResolvedOptions
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, ListableP[PacketP[]]],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->{}
				|>;

				SimulateResources[protocolPacket, ToList[myUnitOperationPackets], ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->simulation]
			],

		(* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateResources[
				<|
					Object->protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
					ResolvedOptions->myResolvedOptions
				|>,
				Cache->cache,
				Simulation->simulation
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Transfer]. *)
		True,
			SimulateResources[
				myProtocolPacket,
				Cache->cache,
				Simulation->simulation
			]
	];

	(* Update the simulation with the simulated resources. *)
	currentSimulation = UpdateSimulation[simulation, fulfillmentSimulation];

	(* If Thaw is set to True, update the state to Liquid in the simulation to the best of our knowledge (based on melting point, composition) *)
	(* Note:also add Volume to the thawed sample and pass in simulation *)
	simulatedSampleStatePackets = Flatten@MapThread[
		Function[{sample, sampleOptions, samplePacket, sampleModelPacket},
			If[!TrueQ[Lookup[sampleOptions, Thaw]],
				Nothing,
				Module[{thawTemperature, meltedQ, convertedAmountAsVolume},
					(* Check resolved ThawTemperature, if not populated use Ambient *)
					thawTemperature = Lookup[sampleOptions, ThawTemperature, 25 Celsius];
					meltedQ = Which[
						(* If input sample is already liquid, it is melted at the end of thaw *)
						MatchQ[Lookup[samplePacket, State], Liquid],
							True,
						(* If the input sample has a melting temp lower than thaw temperature, it is melted *)
						MatchQ[Lookup[samplePacket, MeltingPoint], TemperatureP] && LessQ[Lookup[samplePacket, MeltingPoint], thawTemperature],
							True,
						(* If the model of input sample has a melting temp lower than thaw temperature, it is melted *)
						!NullQ[sampleModelPacket] && MatchQ[Lookup[sampleModelPacket, MeltingPoint], TemperatureP] && LessQ[Lookup[sampleModelPacket, MeltingPoint], thawTemperature],
							True,
						(* In case there is no melting point info, check composition for water molecule or cell *)
						MemberQ[Lookup[samplePacket, Composition][[All, 2]], ObjectP[{Model[Molecule, "id:vXl9j57PmP5D"], Model[Cell]}]] && GreaterQ[thawTemperature, 0 Celsius],
							True,
						(* In case there is no melting point info, check composition for water molecule or cell in the model*)
						!NullQ[sampleModelPacket] && MemberQ[Lookup[sampleModelPacket, Composition][[All, 2]], ObjectP[{Model[Molecule, "id:vXl9j57PmP5D"], Model[Cell]}]] && GreaterQ[thawTemperature, 0 Celsius],
							True,
						True,
							False
					];
					(* If our amount is a mass, convert the mass to a volume. If we don't have a density, assume the density of water with a little buffer amount. *)
					convertedAmountAsVolume = Which[
						MatchQ[Lookup[samplePacket, Volume], VolumeP],
							Lookup[samplePacket, Volume],
							(* Otherwise, amount is represented by mass and we need to look up sample density to calculate volume *)
						MatchQ[Lookup[samplePacket, Mass], MassP] && MatchQ[Lookup[samplePacket, Density], DensityP],
							Lookup[samplePacket, Mass]/Lookup[samplePacket, Density],
							(* Finally, if density is not available, use default value 0.7976 g/ml (75% of water) *)
							(* This is the same logic we use in ExperimentTransfer *)
						MatchQ[Lookup[samplePacket, Mass], MassP],
							(Lookup[samplePacket, Mass]/Quantity[0.997`, ("Grams")/("Milliliters")]) * 1.25,
						(* Otherwise, we have no way to determine volume. Do not update it *)
						True,
							Null
					];
					(* Check the composition, and compare melting point with thawing temperature *)
					If[TrueQ[meltedQ],
						<|Object -> sample, State -> Liquid, Volume -> convertedAmountAsVolume|> ,
						Nothing
					]
				]
			]
		],
		{mySamples, mapThreadFriendlyOptions, samplePackets, sampleModelPackets}
	];

	(* Update the simulation to reflect the outcome of the freezing process. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedSampleStatePackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
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


(* ::Subsection::Closed:: *)
(*Helper Functions*)


(* ::Subsubsection::Closed:: *)
(*groupSonicationSamples*)


groupSonicationSamples[mySamples_List,myInstruments_List,myInstrumentSettings_List,myOptions:OptionsPattern[]]:=Module[
	{transposedSampleInformation,groupedSamples,transposedGroupedSamples},
	(* Transpose our samples, instruments, and settings together. *)

	transposedSampleInformation=Transpose[{mySamples,myInstruments,myInstrumentSettings}];

	(* Group our samples by their instrument and instrument settings. *)
	groupedSamples=Values[GroupBy[transposedSampleInformation,({#[[2]],#[[3]]}&)]];

	(* Transpose each of our groups so that the samples, instruments, and the settings are part of the same list. *)
	transposedGroupedSamples=Transpose/@groupedSamples;

	(* Take those grouped samples and get batches. *)
	Flatten[#, 1]&/@Transpose[(groupSonicationSamples[#[[1]],First[#[[2]]],First[#[[3]]],myOptions]&)/@transposedGroupedSamples]
];


(* Returns {(sampleGrouping:{ObjectP[Object[Sample]])..,instruments,instrumentSettings} based on: *)
(* 1) What instrument needs to be used to mix the sample. *)
(* 2) What instrument settings need to be set to mix the sample. *)
(* 3) If there is enough space in the water bath to fit the samples, taking into account the dimensions of the sonication floats. *)
groupSonicationSamples[mySamples_List,myInstrument:ObjectP[{Model[Instrument,Sonicator],Object[Instrument,Sonicator]}],myInstrumentSettings_List,myOptions:OptionsPattern[]]:=Module[
	{cache,simulation,floatPackets,sampleContainerModels,samplesAndContainerModels,
	samplesAndContainersInFloatsQ,samplesAndContainersInFloats,samplesAndContainersNotInFloats,samplesAndFloats,groupedSamplesAndFloats,
	floatBatches,floatModel,numberOfPositions,samples,sampleBatches,validPositionsLength,newBatch,firstCounts,sampleCounts,
	sampleContainerModelFootprint, samplesNotInFloats, samplesFloatsLookup, instrumentSonicationAdapters, compatibleFloats, compatibleRings, compatibleFloatPackets,compatibleRingPackets, floatFootprintToNumberOfPositions, floatFootprintToAdapterModel, floatsFootprint, resolvedFlaskRings, groupedSamples, groupedInstruments, groupedInstrumentSettings, groupedAdapters},

	(* Lookup our passed cache. *)
	cache=Lookup[ToList[myOptions],Cache,{}];
	simulation=Lookup[ToList[myOptions],Simulation,Null];

	(* Download the information about our sonication floats from our cache. *)
	sampleContainerModels=Download[mySamples,Container[Model],Cache->cache,Simulation->simulation];

	(* fetch footprint of sample container *)
	sampleContainerModelFootprint = cacheLookup[cache, #, Footprint]&/@sampleContainerModels;

	(* fetch all the sonication adapters *)
	instrumentSonicationAdapters = Download[cacheLookup[cache, myInstrument, CompatibleSonicationAdapters],Object];

	(* split adapters by their type *)
	compatibleFloats = Cases[instrumentSonicationAdapters, ObjectP[Model[Container, Rack]]];
	compatibleRings = Cases[instrumentSonicationAdapters, ObjectP[Model[Part, FlaskRing]]];

	(* fetch packets of each adapter*)
	compatibleFloatPackets=(fetchPacketFromCache[#, cache]&)/@compatibleFloats;
	compatibleRingPackets=(fetchPacketFromCache[#, cache]&)/@compatibleRings;

	(* For each float type, create a lookup between footprint and positions that float will hold. *)
	floatFootprintToNumberOfPositions=(Lookup[First[Lookup[#, Positions]], Footprint]->Length[Lookup[#, Positions]]&)/@compatibleFloatPackets;
	floatFootprintToAdapterModel=(Lookup[First[Lookup[#, Positions]], Footprint]->Lookup[#, Object]&)/@compatibleFloatPackets;

	(* extract the allowed footprints of floats *)
	floatsFootprint = DeleteDuplicates[Keys[floatFootprintToAdapterModel]];

	(* Thread together our samples and their container models. *)
	samplesAndContainerModels=Transpose[{mySamples,Download[sampleContainerModels,Object], sampleContainerModelFootprint}];

	(* We only have to worry about optimizing the samples that can be placed in floats together. *)
	(* Get the samples that will be in floats. *)
	samplesAndContainersInFloatsQ=MatchQ[#,{_,_,Alternatives@@floatsFootprint}]&/@samplesAndContainerModels;

	(* Now that we have the boolean mask, get the {sample, container} information for the floats and non-floats. *)
	samplesAndContainersInFloats=PickList[samplesAndContainerModels,samplesAndContainersInFloatsQ];
	samplesAndContainersNotInFloats=PickList[samplesAndContainerModels,samplesAndContainersInFloatsQ,False];

	(* === Samples without floats ===*)
	(* For the samples that are not in floats, we check if we can find a flask ring. If no flask rings can be used, the container is large -- should be safe even without flask ring *)
	resolvedFlaskRings = Map[
		Function[{sample},
			Module[{containerModel, containerModelAperture, containerModelInternalDiameter, filteredFlaskRingPackets, clearance, sortedFlaskRingPackets},
				(* each element is in the format of {sampleID, containerModel, containerFootprint} *)
				containerModel = sample[[2]];
				(* set a clearance *)
				clearance = $FlaskRingClearance;

				(* fetch container information *)
				containerModelAperture = cacheLookup[cache, containerModel, Aperture];
				containerModelInternalDiameter = cacheLookup[cache, containerModel, InternalDiameter];

				(* flask ring must have Apeture larger than container aperture and smaller than internal diameter *)
				filteredFlaskRingPackets = Cases[compatibleRingPackets, KeyValuePattern[Aperture -> RangeP[containerModelAperture + clearance, containerModelInternalDiameter - clearance]]];
				(* sort the filtered flask ring packets so we can pick the largest one if we have multiple rings *)
				sortedFlaskRingPackets = Sort[filteredFlaskRingPackets, (Lookup[#1, Aperture] > Lookup[#2, Aperture])&];
				If[sortedFlaskRingPackets == {},
					(* should be safe without flask ring if we cannot find a ring *)
					Null,
					(* resolve to the largest ring if we have multiple rings to choose from *)
					First[Lookup[sortedFlaskRingPackets, Object]]
				]
			]
		],
		samplesAndContainersNotInFloats
	];


	(* === Samples with floats ===*)
	(* For the samples that are in floats, we really care about their sonication float, not their container model. *)
	(* Map from {sample,container} to {sample,float}. *)
	samplesAndFloats={#[[1]],Lookup[floatFootprintToAdapterModel,#[[3]]]}&/@samplesAndContainersInFloats;

	(* Create Lookup for samples to floats *)
	samplesFloatsLookup = If[Length[samplesAndFloats]>0,
		AssociationThread[Transpose[samplesAndFloats][[1]], Transpose[samplesAndFloats][[2]]],
		<||>
	];

	(* Group our samples by the floats that they're in. *)
	groupedSamplesAndFloats=Values[GroupBy[samplesAndFloats,(#[[2]]&)]];

	(* Each of our groups will be in the same type of float. *)
	(* Map over each float group and group the samples based on the slots that each float has, taking into account that repeated samples cannot be in the same float batch. *)
	(* This result is in the form {(floatModel\[Rule]batches)..}. *)
	floatBatches=Map[
		Function[{samplesAndFloatGroup},
			(* Get the float for this group. *)
			floatModel=First[samplesAndFloatGroup][[2]];

			(* Get the number of positions that this float has. *)
			numberOfPositions=Length[cacheLookup[cache, floatModel, Positions]];

			(* For the batch, get all of the samples. *)
			samples=samplesAndFloatGroup[[All,1]];

			(* Get the counts of the samples. *)
			sampleCounts=Tally[samples];

			(* Initialize a list to keep track of our batches. *)
			sampleBatches={};

			(* Keep taking that number of positions off of a stack, putting any duplicates back. *)
			(* This is because identical samples cannot be in the same batch with one another. *)
			(* Warning: The following is imperative but is much faster than a recursive functional version that I wrote. *)
			While[Length[sampleCounts]>0,
				(* Take the minimum of Length[sampleCounts] and numberOfPositions. *)
				(* We either want to take the maximum number of positions or the unique samples that are left in our queue. *)
				validPositionsLength=Min[Length[sampleCounts],numberOfPositions];

				(* Take samples for our new batch. *)
				newBatch=sampleCounts[[1;;validPositionsLength]][[All,1]];

				(* Append to our batches. *)
				AppendTo[sampleBatches,newBatch];

				(* Decrement our counts in sampleCounts. *)
				(* Decrement our first n indices. *)
				firstCounts=(
					If[MatchQ[sampleCounts[[#]],{_,1}],
						Nothing,
						{sampleCounts[[#]][[1]],sampleCounts[[#]][[2]]-1}
					]
				&)/@Range[validPositionsLength];

				(* Our new list of sample counts is our decremented list combined with the samples that we didn't touch yet. *)
				sampleCounts=Join[firstCounts,sampleCounts[[validPositionsLength+1;;]]];
			];

			(* Return our batches. *)
			Sequence@@sampleBatches
		],
		groupedSamplesAndFloats
	];

	(* We've finished batching all of the samples that are in floats. Add the rest of the non-floated samples in their own groups. *)
	samplesNotInFloats=PickList[mySamples,samplesAndContainersInFloatsQ,False];

	(* prepare return values *)
	groupedSamples = Join[floatBatches, {#}&/@samplesNotInFloats];
	groupedInstruments = Join[
		ConstantArray[myInstrument,Length[floatBatches]],
		ConstantArray[myInstrument,Length[samplesNotInFloats]]
	];
	groupedInstrumentSettings = Join[
		ConstantArray[myInstrumentSettings,Length[floatBatches]],
		ConstantArray[myInstrumentSettings,Length[samplesNotInFloats]]
	];
	groupedAdapters = Join[
		(* As for batched float samples, each batch share one float. Use the first sample to find out corresponding rack model through look up *)
		If[Length[floatBatches]>0, floatBatches[[All, 1]]/.samplesFloatsLookup, {}],
		resolvedFlaskRings
	];

	(* Return our result. *)
	{groupedSamples, groupedInstruments, groupedInstrumentSettings, groupedAdapters}
];


(* ::Subsubsection::Closed:: *)
(*groupSamples*)


(* Returns {{(sampleGrouping:{ObjectP[Object[Sample]])..}..},{(instrument:ObjectP[Model[Instrument]])..},{(instrumentPositions:{_String..})..}{(instrumentSettings:_List)..}} based on: *)
(* 1) What instrument needs to be used to mix the sample. *)
(* 2) What instrument settings need to be set to mix the sample. *)
(* 3) If there are enough positions open on the instrument to be used to mix the samples. *)
Authors[groupSamples]:={"taylor.hochuli", "hanming.yang", "thomas"};

groupSamples[mySamples_,myInstruments_,myInstrumentSettings_,myOptions:OptionsPattern[]]:=Module[
	{cache,instrumentModels,instrumentObjects,sampleObjects,transposedInformation,groupedByInstrument,result,instrument,
	instrumentModel,instrumentInformation,instrumentPacket,groupedBySettings,settings,settingsInformation,samples,
	positions,samplePacket,samplesContainer,samplesContainerModel,samplesLeft,
	edgeSetPairings,samplesLeftWithoutDuplicates,positionsWithoutDuplicates,uuids,uuidMap,uuidsLeft,
	positionEdges,uuidEdgeSet,matchedUUIDs,samplesMatched,objectEdgeSet,sampleGroupings,positionGroupings,
	instrumentPositionGroupings,flattenedResult,sampleGrouping,instruments,instrumentLocations,
	groupedSettings,expandedInstruments,expandedSettings,flattenedSampleGrouping,flattenedInstrumentLocations},

	(* Fetch our cache from the parent function. *)
	(* This is a private helper that is only called from the mix resource packets so we can assume that our info is always in the cache. *)
	cache=Lookup[ToList[myOptions],Cache];

	(* Make sure that all of our instruments are in object notation (not name as this will group our instrument incorrectly). *)
	(* Make sure that we get the instrument models, not the objects. *)
	instrumentModels=(If[MatchQ[#,ObjectP[Model[Instrument]]],
		(* We already have the model. *)
		Download[#,Object],
		(* Go from the object to the model. *)
		Download[Lookup[fetchPacketFromCache[#,cache],Model,Null],Object]
	]&)/@myInstruments;

	(* create a list of instrument objects or Null if they weren't specified *)
	instrumentObjects=(If[MatchQ[#,ObjectP[Object[Instrument]]],
		(* we have an instrument object *)
		Download[#,Object],
		(* we don't *)
		Null
	]&)/@myInstruments;

	(* Make sure that all of our samples are in object notation (not name as this will mess up keeping track of duplicate samples). *)
	sampleObjects=If[MatchQ[#, _Resource],
		(* if we are handling Roller samples, the sample objects are rack resources *)
		#,
		Lookup[fetchPacketFromCache[#,cache],Object]
	]&/@mySamples;

	(* Transpose our samples, instruments, and instrument settings together. *)
	transposedInformation=Transpose[{sampleObjects,instrumentModels,myInstrumentSettings,instrumentObjects}];

	(* 1) Group by instrument model and object. *)
	groupedByInstrument=Normal[GroupBy[transposedInformation,({#[[2]],#[[4]]}&)]];

	(* For each instrument group: *)
	result=Function[{instrumentGroup},
		(* instrumentGroup is in the format {instrumentModel,instrumentObject}\[Rule]transposedInformation *)

		(* Get the instrument model *)
		instrumentModel=instrumentGroup[[1]][[1]];

		(* set instrument as object if one exists otherwise as the model *)
		instrument=If[NullQ[instrumentGroup[[1]][[2]]],
			instrumentModel,
			instrumentGroup[[1]][[2]]
		];

		instrumentInformation=instrumentGroup[[2]];

		(* Get the packet for our instrument. *)
		instrumentPacket=fetchPacketFromCache[instrumentModel,cache];

		(* 2) Group by instrument settings. *)
		groupedBySettings=Normal[GroupBy[instrumentInformation,(#[[3]]&)]];

		(* For each instrument settings group: *)
		Function[{settingsGroup},
			(* settingsGroup is in the format settingsGroup\[Rule]transposedInformation *)

			(* Get the settings. *)
			settings=settingsGroup[[1]];
			settingsInformation=settingsGroup[[2]];

			(* Get the samples in this group. *)
			samples=settingsInformation[[All,1]];

			(* 3) Group by open positions. *)
			positions=Function[{sample},
				(* Get the packet for this sample. *)
				samplePacket=fetchPacketFromCache[sample,cache];

				(* Get the container object that our sample is in. *)
				samplesContainer=If[MatchQ[sample, _Resource],
					(* if we are handling Roller samples, the sample objects are rack resources, which does not have container *)
					sample,
					Lookup[samplePacket,Container,Null]/.{link_Link:>Download[link, Object]}
				];

				(* Get the model of this container object. *)
				samplesContainerModel=If[MatchQ[sample, _Resource],
					(* if we are handling Roller samples, the sample objects are rack resources, its Sample is the Container Model we need *)
					sample[Sample],
					Lookup[fetchPacketFromCache[samplesContainer,cache],Model]
				];

				(* Get the compatible positions for each of our samples. *)
				CompatibleFootprintQ[
					Lookup[instrumentPacket,Object],
					samplesContainerModel,

					(* Set MidWidth if we're dealing with a bottle roller. *)
					MinWidth->If[MatchQ[Lookup[instrumentPacket,Object],ObjectP[Model[Instrument,BottleRoller]]],
						Lookup[instrumentPacket,RollerSpacing],
						Null
					],

					ExactMatch->Which[
						(* for torrey pine and incu shaker, we only want to use the container with exact footprint *)
						MatchQ[Lookup[instrumentPacket,Object], ObjectP[{Model[Instrument, Shaker, "id:N80DNj15vreD"], Model[Instrument, Shaker, "id:6V0npvmNnOrw"]}]],
						True,
						(* Set ExactMatch\[Rule]False if we're dealing with a sonicator, bottle roller, shaker, nutator, or overhead stirrer. *)
						(* for genie temp shaker, we allow it to use with or without adapter. *)
						MatchQ[Lookup[instrumentPacket,Object],ObjectP[{Model[Instrument,Sonicator],Model[Instrument,BottleRoller],Model[Instrument,Shaker],Model[Instrument,Nutator],Model[Instrument,OverheadStirrer]}]],
						False,
						(* otherwise set to True *)
						True,
						True
					],

					Output->Positions,
					Cache->cache
				]
			]/@samples;

			(* We have to keep track of how many times samples were specified (users can specify the same sample multiple times). *)
			samplesLeft=samples;

			(* Keep track of our pairings. *)
			edgeSetPairings={};

			(* Loop until no samples left. *)
			While[Length[samplesLeft]>0,
				(* Get our samples left without duplicates. *)
				(* This is because we cannot place sample A two times in the same instrument in the same grouping. *)
				samplesLeftWithoutDuplicates=DeleteDuplicates[samplesLeft];

				(* Get a list of positions index-matched to samplesLeftWithoutDuplicates. *)
				positionsWithoutDuplicates=(positions[[First[FirstPosition[samples,#]]]]&)/@samplesLeftWithoutDuplicates;

				(* The graph symbolic representation cannot deal with complex labeled nodes (aka objects). *)
				(* Turn our objects into UUIDs. *)
				uuids=Table[CreateUUID[],Length[samplesLeftWithoutDuplicates]];

				(* Create a map of UUID to sample. *)
				uuidMap=MapThread[(#1->#2&),{uuids,samplesLeftWithoutDuplicates}];

				(* Keep track of a list of UUIDs we still need to match. *)
				uuidsLeft=uuids;

				(* While we still have UUIDs left to match, do a round of stable marriage: *)
				While[Length[uuidsLeft]>0,
					(* Match samples to positions on the instrument. *)
					(* Create edges for each sample \[Rule] compatible position. *)
					positionEdges=Flatten[MapThread[
						Function[{sampleUUID,samplePositions},
							(* Do we still have to match this UUID? *)

							If[MemberQ[uuidsLeft,sampleUUID],
								(* Create rules of sample \[Rule] compatible position. *)
								((sampleUUID->#)&)/@ToList[samplePositions],
								(* Already matched. Don't include. *)
								Nothing
							]
						],
						(* Map over all UUIDs to keep index-matching to their positions. *)
						{uuids,positionsWithoutDuplicates}
					]];

					(* Find an independent edge set. *)
					uuidEdgeSet=FindIndependentEdgeSet[Graph[positionEdges]];

					(* Get the edges that were matched in this round. *)
					matchedUUIDs=First/@uuidEdgeSet;

					(* Remove these matched UUIDs from our uuidsLeft list. *)
					uuidsLeft=Complement[uuidsLeft,matchedUUIDs];

					(* Translate UUIDs matched into samples. *)
					samplesMatched=matchedUUIDs/.uuidMap;

					(* Remove these samples from our samples we still need to match. *)
					(* https://mathematica.stackexchange.com/questions/66079/how-to-subtract-one-list-from-another-treating-each-elements-as-distinct-assum *)
					samplesLeft=Join@@ConstantArray@@@Normal@Merge[{Counts[samplesLeft],-Counts[samplesMatched]},Total];

					(* Translate this back into object notation. *)
					objectEdgeSet=uuidEdgeSet/.uuidMap;

					(* Add our pairings to our result list. *)
					edgeSetPairings=Append[edgeSetPairings,objectEdgeSet];
				];
			];

			(* We've finished with our pairings. *)
			(* Translate this back into {sampleGrouping..,positions..}. *)

			(* Get the samples per grouping. *)
			sampleGroupings=(First/@#&)/@edgeSetPairings;

			(* Get the positions per grouping. *)
			positionGroupings=(Last/@#&)/@edgeSetPairings;

			(* Add the instrument to the positions. *)
			instrumentPositionGroupings=Map[({#,instrument}&),positionGroupings,{2}];

			(* Return {sampleGroupings, instrument, positionGroupings, instrumentSettings}. *)
			{sampleGroupings,instrument,instrumentPositionGroupings,First[settingsInformation[[All,3]]]}
		]/@groupedBySettings
	]/@groupedByInstrument;

	(* Flatten our result by 1 level. *)
	flattenedResult=Flatten[result,1];

	(* Shape our result into a form that we can map over in the procedure. *)
	{sampleGrouping,instruments,instrumentLocations,groupedSettings}=Transpose[flattenedResult];

	(* Expand instruments to match each sample groupings. *)
	expandedInstruments=Flatten[MapThread[(ConstantArray[#1,Length[#2]]&),{instruments,sampleGrouping}]];

	(* Expand instrument settings to match each sample groupings. *)
	expandedSettings=Flatten[MapThread[(ConstantArray[#1,Length[#2]]&),{groupedSettings,sampleGrouping}],1];

	(* Flatten our sample groupings to a preferred depth. *)
	flattenedSampleGrouping=Flatten[sampleGrouping,1];

	(* Flatten instrument locations to a preferred depth. *)
	flattenedInstrumentLocations=Flatten[instrumentLocations,1];

	(* Return our shaped results. *)
	{flattenedSampleGrouping,expandedInstruments,flattenedInstrumentLocations,expandedSettings}
];


(* ::Subsubsection::Closed:: *)
(*groupIncubateSamples*)


(* Empty option definition. *)
groupIncubateSamples[{},{},_]:={};

(* Definition for mutliple incubator settings. *)
(* myContainers is index matched to myIncubators. *)
groupIncubateSamples[myObjects:{ObjectP[Object[Sample]]..},myIncubatorOptions:_List,cache_]:=Module[
	{rawIncubatorObjects,incubatorObjects,sanitizedIncubatorOptions,objectContainers,samplesAndOptions,samplesAndOptionsWithCounts,
	containersAndOptionsWithCounts,uniqueContainersAndOptions,containersAndOptionsWithMaxCounts,overallLargestCount,maxCountGroupedContainers,
	groupedContainers},

	(* Get all of the incubator objects in our options. *)
	rawIncubatorObjects=(If[MatchQ[Lookup[#,ThawInstrument,Null], Null|Automatic],
		Lookup[#,Instrument,Null],
		Lookup[#,ThawInstrument,Null]
	])&/@myIncubatorOptions/.{Automatic|Null->Nothing};

	(* First, make sure we have the object (ID form, not Name form) for all of our incubator objects. *)
	incubatorObjects=(Lookup[fetchPacketFromCache[#,cache],Object]&)/@rawIncubatorObjects;

	(* Make sure that all of our incubators are in option form. *)
	sanitizedIncubatorOptions=myIncubatorOptions/.MapThread[(#1->#2&),{rawIncubatorObjects,incubatorObjects}];

	(* Get the containers of our objects. *)
	objectContainers=(Lookup[fetchPacketFromCache[#,cache],Container,Null]/.{link_Link:>Download[link, Object]}&)/@myObjects;

	(* Combine our samples and the incubator options. *)
	(* This is in the form {{sample, setting}...}. *)
	samplesAndOptions=Transpose[{myObjects/.{link_Link:>Download[link, Object]},myIncubatorOptions}];

	(* Include the number of times each {sample,setting} shows up. *)
	(* This is in the form {{{sample,setting},count}..}. *)
	samplesAndOptionsWithCounts=Function[{countInformation},
		{countInformation[[1]],countInformation[[2]]}
	]/@Normal[Counts[samplesAndOptions]];

	(* Replace each sample with its container. *)
	(* This is in the form {{{container,setting},count}..}. *)
	containersAndOptionsWithCounts=samplesAndOptionsWithCounts/.{sample:ObjectP[Object[Sample]]:>Lookup[fetchPacketFromCache[sample,cache],Container,Null]/.{link_Link:>Download[link, Object]}};

	(* Get the biggest times for each {sample,setting}. *)
	uniqueContainersAndOptions=DeleteDuplicates[containersAndOptionsWithCounts[[All,1]]];

	(* This variable is in the form {{{container,setting},largestCount}..} *)
	containersAndOptionsWithMaxCounts=Function[{containerAndOption},
		(* Get all the cases of {{container,option},_}. *)
		cases=Cases[containersAndOptionsWithCounts,{containerAndOption,_}];

		(* Choose the largest number. *)
		largestCount=Max[cases[[All,2]]];

		(* Return the conatiner/options with the largest number. *)
		{containerAndOption,largestCount}
	]/@uniqueContainersAndOptions;

	(* Get the overall largest count of the counts. *)
	overallLargestCount=Max[containersAndOptionsWithMaxCounts[[All,2]]];

	(* All containers and settings with largestCount\[Rule]1 should be in a group then we go to largestCount\[Rule]2 and so on until we have got all counts. *)
	(* This variable is in the form {group:{{container,setting}..}..} *)
	maxCountGroupedContainers=Function[{count},
		(* Get all of the {container,setting} instances of this count. *)
		cases=Cases[containersAndOptionsWithMaxCounts,{_,GreaterEqualP[count]}];

		(* If there are no cases, return nothing, otherwise, return all the cases. *)
		If[Length[cases]>0,
			cases[[All,1]],
			Nothing
		]
	]/@Range[overallLargestCount];

	(* Create groupings to put into our knapsack. *)
	(* We do this by grouping each container "max count" by their settings. *)
	groupedContainers=(
		Sequence@@(Values[GroupBy[#,#[[2]]&]])
	&)/@maxCountGroupedContainers;

	(* For each set of options, figure out an incubator grouping. *)
	(Module[{containers,options,incubator,groupings},
		(* Get our list of containers and our options for these containers. *)
		containers=#[[All,1]];
		options=#[[1]][[2]];

		(* Get the incubator that we're using for these containers. *)
		incubator=If[KeyExistsQ[options,ThawInstrument],
			Lookup[options,ThawInstrument],
			Lookup[options,Instrument]
		];

		(* Knapsack these containers. *)
		groupings=knapsackIncubatorContainers[containers,incubator,cache];

		(* Return our groupings along with the instrument settings. *)
		Sequence@@Transpose[{groupings,ConstantArray[options,Length[groupings]]}]
	]&)/@groupedContainers
];

(* Tries to fit myContainers into myIncubator, minimizing batches. *)
(* Assumes that given container objects are unique. *)
(* Returns {{vessels..}..}. *)
knapsackIncubatorContainers[myContainers:{ObjectP[Object[Container]]...}, myIncubator:ObjectP[{Object[Instrument,HeatBlock],Model[Instrument,HeatBlock],Object[Instrument,Nutator],Model[Instrument,Nutator],Object[Instrument,EnvironmentalChamber],Model[Instrument,EnvironmentalChamber]}],cache_]:=Module[
	{instrumentModel,incubateContainers,heatBlockInternalDimensions,containerDimensions,containerGeometry,containerDimension,containersAndGeometry,
	containerAreas,uuidGroups,containerUUIDs,instrumentArea,containersAndAreasLeft,knapsackSolution,containerAndGeometryGroups,containersDidntFit,
	optimizedPacks,chosenContainers},

	(* Get the model's object of our incubator. *)
	instrumentModel=If[MatchQ[myIncubator,ObjectP[Model[Instrument]]],
		Lookup[fetchPacketFromCache[myIncubator,cache],Object],
		Download[Lookup[fetchPacketFromCache[myIncubator,cache],Model],Object]
	];

	(* Get the models of the containers that we need to incubate. *)
	incubateContainers=Download[Lookup[fetchPacketFromCache[#,cache],Model]&/@myContainers,Object];

	(* Get the dimensions of our containers and the dimensions of our heat block. *)
	heatBlockInternalDimensions=QuantityMagnitude[UnitConvert[Lookup[fetchPacketFromCache[instrumentModel,cache],InternalDimensions],Centimeter]];

	(* Initialize the geometry of these containers. *)
	(* If the depth of the container is less than the depth of the heat block, then treat the cross sectional area as top-down. *)
	(* Otherwise, we will lie the container on its side. *)
	containerGeometry=Map[
		Function[{container},
			(* Lookup the dimensions of this container from our cache. *)
			containerDimension=QuantityMagnitude[UnitConvert[Lookup[fetchPacketFromCache[container,cache],Dimensions],Centimeter]];

			(* Switch based on our container's depth. *)
			If[containerDimension[[3]]<heatBlockInternalDimensions[[3]],
				(* This container can fit top-down on the heatblock. *)
				{containerDimension[[1]],containerDimension[[2]]},
				(* This container must be laid on its side. *)
				{Max[containerDimension[[1]],containerDimension[[2]]],containerDimension[[3]]}
			]
		],
		incubateContainers
	];

	(* Combine our containers with their geometry. *)
	(* These are the containers that we have to pack into the incubator. *)
	containersAndGeometry=Transpose[{myContainers,containerGeometry}];

	(* Get the area of our 2D representations. *)
	containerAreas=(Times@@#&)/@containersAndGeometry[[All,2]];

	(* We want to group these containers into partitions that are as close to the incubator's area as possible. *)
	uuidGroups={};

	(* Create UUIDs for each container. *)
	containerUUIDs=CreateUUID[]&/@Range[Length[containersAndGeometry]];

	(* Get the area of our incubator (2D Area). *)
	instrumentArea=heatBlockInternalDimensions[[1]]*heatBlockInternalDimensions[[2]];

	(* Keep grouping containers until we get all of them. *)
	containersAndAreasLeft=Transpose[{containerUUIDs,containerAreas}];
	While[Length[containersAndAreasLeft]>0,
		(* Solve our knapsack problem. Aim for 80% of the instrument's area. *)
		knapsackSolution=KnapsackSolve[Association@((#->{"Cost"->#[[2]],"MaxCount"->1}&)/@containersAndAreasLeft),0.80*instrumentArea];

		(* Only get the containers that are going to be chosen (there will be results with {...}\[Rule]0 in our result). *)
		chosenContainers=Cases[Normal[knapsackSolution],Verbatim[Rule][_,1]];

		(* Remove these UUIDs from our UUIDs left. *)
		containersAndAreasLeft=DeleteCases[containersAndAreasLeft,Alternatives@@(Keys[chosenContainers])];

		(* Store our group. *)
		uuidGroups=Append[uuidGroups,Keys[chosenContainers]];
	];

	(* Go back from UUIDs to containers and geometry. *)
	containerAndGeometryGroups=(#[[All,1]]&)/@(uuidGroups/.MapThread[#1->#2&,{containerUUIDs,containersAndGeometry}]);

	(* Get only the containers. *)
	(#[[All,1]]&)/@containerAndGeometryGroups
];



(* ::Subsubsection::Closed:: *)
(*mixObjectToType*)


mixObjectToType[object_]:=Switch[object,
	ObjectP[Model[Instrument,Shaker]],
		Shake,
	ObjectP[Model[Instrument,Roller]]|ObjectP[Model[Instrument,BottleRoller]],
		Roll,
	ObjectP[Model[Instrument,OverheadStirrer]],
		Stir,
	ObjectP[Model[Instrument,Vortex]],
		Vortex,
	ObjectP[Model[Instrument,Homogenizer]],
		Homogenize
];


(* ::Subsubsection::Closed:: *)
(*compatibleStirBar*)

(* Cache the stir bars that are available in the lab. *)
stirBarPackets[]:=stirBarPackets[]=Download[
	Search[Model[Part, StirBar], Deprecated!=True && DeveloperObject != True],
	Packet[MinTemperature, MaxTemperature, StirBarLength, StirBarWidth]
];

(* Overload that takes in a container. *)
compatibleStirBar[myContainer:ObjectReferenceP[Model[Container]],ops:OptionsPattern[]]:=Module[{},
	(* Fake a sample to pass into the main function. *)
	compatibleStirBar[
		<|Object->Object[Sample, "id:bxExiCVfgb3H"],Container->Link[Object[Container,"id:V8zjStew9qzQ"], Contents, 2]|>,
		Cache->{
			<|Object->Object[Container,"id:V8zjStew9qzQ"],Model->Link[myContainer, Objects]|>,
			Quiet[
				Download[
					myContainer,
					Packet[Aperture,InternalDepth,InternalDimensions,InternalDiameter],
					Simulation->Lookup[ToList[ops], Simulation, Null]
				]
			]
		},
		ops
	]
];

(* Checks that for a given stirrer, and sample, returns the best impeller. *)
(* 1) The stir bar's width can fit in the aperture of the sample's container. *)
(* 2) The stir bar's length is not greater than the InternalDiameter of the smaple's container. *)

compatibleStirBar[mySample:ObjectP[Object[Sample]],ops:OptionsPattern[]]:=FirstOrDefault[compatibleStirBars[mySample,ops]];

compatibleStirBars[myContainer:ObjectP[Model[Container]],ops:OptionsPattern[]]:=Module[{},
	(* Fake a sample to pass into the main function. *)
	compatibleStirBars[
		<|Object->Object[Sample, "id:bxExiCVfgb3H"],Container->Link[Object[Container,"id:V8zjStew9qzQ"], Contents, 2]|>,
		Cache->{
			<|Object->Object[Container,"id:V8zjStew9qzQ"],Model->Link[myContainer, Objects]|>,
			Quiet[
				Download[
					myContainer,
					Packet[Aperture,InternalDepth,InternalDimensions,InternalDiameter],
					Simulation->Lookup[ToList[ops], Simulation, Null]
				]
			]
		},
		ops
	]
];

compatibleStirBars[mySample:ObjectP[Object[Sample]],ops:OptionsPattern[]]:=Module[
	{cache,simulation,sampleContainerPacket,stirInstrumentPackets,impellerPackets,containerAperture,
		containerInternalDiameter, allStirBarPackets,filteredStirBars},

	(* Lookup our cache. *)
	cache=Lookup[ToList[ops],Cache,{}];
	simulation=Lookup[ToList[ops],Simulation,Null];

	(* Download our necessary information. *)
	sampleContainerPacket=Quiet[Download[
		mySample,
		Packet[Container[Model][{Aperture,InternalDepth,InternalDimensions,InternalDiameter}]],
		Cache->cache,
		Simulation->simulation
	],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* If the download failed or the sample isn't in a Model[Container,Vessel], it can't be stirred. *)
	If[!MatchQ[sampleContainerPacket,PacketP[]]||!MatchQ[Lookup[sampleContainerPacket,Object],ObjectP[Model[Container,Vessel]]],
		Return[Null];
	];

	(* Get the information about the container that we need. *)
	containerAperture=Lookup[sampleContainerPacket,Aperture,Null];
	containerInternalDiameter=Lookup[sampleContainerPacket,InternalDiameter,Null];

	(* Lookup StirrerLength and MaxDiameter from each packet. *)
	allStirBarPackets=stirBarPackets[];

	(* Make sure that we have at least one impeller that can hit the bottom of the container, can fit in the aperture, and that there's at least 1 Centimeters of clearance between the impeller diameter and the internal diameter. *)
	filteredStirBars=Cases[allStirBarPackets,KeyValuePattern[{StirBarWidth->LessEqualP[containerAperture], StirBarLength->LessEqualP[containerInternalDiameter]}]];

	(* Did we find a compatible stir bar? *)
	If[Length[filteredStirBars]>0,
		(* Order by largest StirBarWidth. *)
		Lookup[SortBy[filteredStirBars,(-Lookup[#, StirBarWidth]&)], Object],
		(* There are no valid stir bars. *)
		{}
	]
];

(* ::Subsubsection::Closed:: *)
(*compatibleImpeller*)


DefineOptions[compatibleImpeller,
	Options:>{
		{Clearance->1.5 Centimeter, DistanceP[],"The minimum difference between the aperture and the rod diameter."}
	}
];


(* Overload that takes in a container. *)
compatibleImpeller[myContainer:ObjectReferenceP[Model[Container]],myStirInstrument:ObjectP[{Object[Instrument],Model[Instrument]}],ops:OptionsPattern[]]:=Module[{},
	(* Fake a sample to pass into the main function. *)
	compatibleImpeller[
		<|Object->Object[Sample, "id:bxExiCVfgb3H"],Container->Link[Object[Container,"id:V8zjStew9qzQ"]], IncompatibleMaterials-> {None}|>,
		myStirInstrument,
		Cache->{
			<|Object->Object[Container,"id:V8zjStew9qzQ"],Model->Link[myContainer, Objects]|>,
			Quiet[
				Download[
					myContainer,
					Packet[Aperture,InternalDepth,InternalDimensions,InternalDiameter],
					Simulation->Lookup[ToList[ops], Simulation, Null]
				]
			]
		},
		ops
	]
];

(* Checks that for a given stirrer, and sample, returns the best impeller. *)
(* 1) The impeller can fit in the aperture of the sample's container. *)
(* 2) The impeller can reach the bottom of the sample's container. *)
(* 3) The impeller is compatible with the stir instrument given. *)
compatibleImpeller[mySample:ObjectP[Object[Sample]],myStirInstrument:ObjectP[{Object[Instrument],Model[Instrument]}],ops:OptionsPattern[]]:=Module[
	{cache,simulation,clearence,sampleContainerPackets,stirInstrumentPackets,impellerPackets,containerInternalDepth,containerAperture, containerMaxVolume,
	containerInternalDiameter,instrumentPacket,compatibleImpellers,compatibleImpellerPackets,impellerInformation,
	filteredImpellers, materialCompatibleImpellerPackets},

	(* Lookup our cache. *)
	cache=Lookup[ToList[ops],Cache,{}];
	simulation=Lookup[ToList[ops],Simulation,Null];
	clearence=Lookup[ToList[ops],Clearance,1.5 Centimeter];

	(* Download our necessary information. *)
	(* CompatibleImpellers is a field of Model[Instrument] *)
	{
		sampleContainerPackets,
		stirInstrumentPackets,
		impellerPackets
	}=Quiet[Flatten[Download[
		{
			{mySample},
			{myStirInstrument},
			{myStirInstrument}
		},
		{
			{Packet[Container[Model][{Aperture, InternalDepth, InternalDimensions, InternalDiameter}]]},
			{
				Packet[CompatibleImpellers],
				Packet[Model[CompatibleImpellers]]
			},
			{
				Packet[CompatibleImpellers[{StirrerLength,MaxDiameter,ImpellerDiameter,Name, WettedMaterials}]],
				Packet[Model[CompatibleImpellers][{StirrerLength,MaxDiameter,ImpellerDiameter,Name, WettedMaterials}]]
			}
		},
		Cache->cache,
		Simulation->simulation
	],1],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}]/. {$Failed -> Null};

	(* If the sample isn't in a Model[Container,Vessel], it can't be stirred. *)
	If[!MatchQ[Lookup[First[Flatten[sampleContainerPackets]],Object],ObjectP[Model[Container,Vessel]]],
		Return[Null];
	];

	(* Get the information about the container that we need. *)
	{containerInternalDepth, containerAperture} = Lookup[First[sampleContainerPackets], {InternalDepth, Aperture}, Null];

	(* Get the internal diameter of the conatiner. *)
	containerInternalDiameter=If[MatchQ[Lookup[First[sampleContainerPackets],InternalDiameter,Null],Null],
		Null,
		Lookup[First[sampleContainerPackets],InternalDiameter,Null]
	];

	(* Get the packet for this instrument. *)
	instrumentPacket=fetchPacketFromCache[myStirInstrument,stirInstrumentPackets];

	(* Packet[CompatibleImpellers] is Null or Packet[Model[CompatibleImpellers]] is Null, depending on if given instrument is Object or Model *)
	compatibleImpellers=Flatten[Lookup[DeleteCases[stirInstrumentPackets, Null],CompatibleImpellers,{}]];

	(* For each compatible impeller, get the information we need about it. *)
	compatibleImpellerPackets=fetchPacketFromCache[#,DeleteCases[Flatten[impellerPackets], Null]]&/@compatibleImpellers;

	(* Make sure the impellers we resolve are material compatible *)
	materialCompatibleImpellerPackets =Quiet[Cases[compatibleImpellerPackets, _?(CompatibleMaterialsQ[#, mySample, Cache -> cache, Simulation -> simulation]&)], {Error::IncompatibleMaterials}];

	(* Lookup StirrerLength and MaxDiameter from each packet. *)
	impellerInformation=Lookup[Flatten[materialCompatibleImpellerPackets],{Object,StirrerLength,MaxDiameter,ImpellerDiameter},Null];

	(* Make sure that we have at least one impeller that can hit the bottom of the container (but not too long to assemble), can fit in the aperture, and that there's at least 1 Centimeters of clearance between the impeller diameter and the internal diameter. *)
	filteredImpellers=Cases[impellerInformation,{_,RangeP[containerInternalDepth, containerInternalDepth * 2.5],LessP[containerAperture],LessEqualP[containerInternalDiameter-clearence]}];

	(* Did we find a compatible impeller? *)
	If[Length[filteredImpellers]>0,
		(* Choose the impeller with the largest ImpellerDiameter. *)
		Sort[filteredImpellers,(#1[[4]]>#2[[4]]&)][[1]][[1]],
		(* There are no valid impellers. *)
		Null
	]
];



(* ::Subsubsection::Closed:: *)
(*compatibleSonicationHorn*)


(* Overload that takes in a container. *)
compatibleSonicationHorn[myContainer:ObjectReferenceP[Model[Container]],myInstrument:ObjectP[{Object[Instrument],Model[Instrument]}],ops:OptionsPattern[]]:=Module[{},
	(* Fake a sample to pass into the main function. *)
	compatibleSonicationHorn[<|Type->Object[Sample],Container->Link[Object[Container,"id:V8zjStew9qzQ"]]|>,myInstrument,Cache->{<|Object->Object[Container,"id:V8zjStew9qzQ"],Model->Link[myContainer, Objects]|>},ops]
];

(* Checks that for a given homogenizer, and sample, returns the best sonication horn (or Null if there is none). *)
(* 1) The impeller can fit in the aperture of the sample's container. *)
(* 2) The impeller can reach the bottom of the sample's container. *)
(* 3) The impeller is compatible with the stir instrument given. *)

compatibleSonicationHorn[mySample:ObjectP[Object[Sample]],myInstrument:ObjectP[{Object[Instrument],Model[Instrument]}],ops:OptionsPattern[]]:=Module[
	{cache,simulation,instrumentDownloadFields,impellerDownloadFields,sampleContainerPackets,homogenizerInstrumentPackets,stirInstrumentPackets,impellerPackets,containerInternalDepth,containerAperture,
	containerInternalDiameter,instrumentPacket,compatibleImpellers,compatibleImpellerPackets,impellerInformation,
	filteredImpellers,compatibleHorns,compatibleHornPackets,hornInformation},

	(* Lookup our cache. *)
	cache=Lookup[ToList[ops],Cache,{}];
	simulation=Lookup[ToList[ops],Simulation,Null];

	(* path to fields we need to download is different depending on Object/Model instrument *)
	{instrumentDownloadFields,impellerDownloadFields}=If[MatchQ[myInstrument,ObjectP[Object[Instrument]]],
		{Packet[Model[CompatibleSonicationHorns]],Packet[Model[CompatibleSonicationHorns[{HornLength,HornDiameter}]]]},
		{Packet[CompatibleSonicationHorns],Packet[CompatibleSonicationHorns[{HornLength,HornDiameter}]]}
	];

	(* Download our necessary information. *)
	{
		{
			sampleContainerPackets,
			homogenizerInstrumentPackets,
			impellerPackets
		}
	}=Quiet[Flatten[Download[
		{
			{mySample},
			{myInstrument},
			{myInstrument}
		},
		{
			{Packet[Container[Model][{Aperture,InternalDepth,InternalDimensions,InternalDiameter}]]},
			{instrumentDownloadFields},
			{impellerDownloadFields}
		},
		Cache->cache,
		Simulation->simulation
	],{3}],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* If the sample isn't in a Model[Container,Vessel], it can't be homogenized. *)
	If[!MatchQ[Lookup[First[Flatten[sampleContainerPackets]],Object],ObjectP[Model[Container,Vessel]]],
		Return[Null];
	];

	(* Get the information about the container that we need. *)
	{containerInternalDepth,containerAperture}=Lookup[First[sampleContainerPackets],{InternalDepth,Aperture},Null];

	(* Get the internal diameter of the conatiner. *)
	containerInternalDiameter=If[MatchQ[Lookup[First[sampleContainerPackets],InternalDiameter,Null],Null],
		Null,
		Lookup[First[sampleContainerPackets],InternalDiameter,Null]
	];

	(* Get the packet for this instrument. *)
	instrumentPacket=fetchPacketFromCache[myInstrument,homogenizerInstrumentPackets];

	(* Get the compatible impellers for this instrument. *)
	compatibleHorns=Lookup[instrumentPacket,CompatibleSonicationHorns,{}]/.{$Failed->{}};

	(* For each compatible impeller, get the information we need about it. *)
	compatibleHornPackets=fetchPacketFromCache[#,Flatten[impellerPackets]]&/@compatibleHorns;

	(* Lookup HornLength and HornDiameter from each packet. *)
	hornInformation=Lookup[Flatten[compatibleHornPackets],{Object,HornLength,HornDiameter},Null];

	(* Make sure that we have at least one impeller that can hit the bottom of the container, can fit in the aperture, and that there's at least 7 Millimeters of clearance between the impeller diameter and the internal diameter. *)
	filteredImpellers=Cases[hornInformation,{_,GreaterEqualP[containerInternalDepth],PatternUnion[LessEqualP[containerAperture],LessEqualP[containerInternalDiameter-7Millimeter]]}];

	(* Did we find a compatible impeller? *)
	If[Length[filteredImpellers]>0,
		(* Choose the impeller with the largest ImpellerDiameter. *)
		Sort[filteredImpellers,(#1[[3]]>#2[[3]]&)][[1]][[1]],
		(* There are no valid impellers. *)
		Null
	]
];


(* ::Subsubsection::Closed:: *)
(*instrumentInstrumentToSettingFunction*)


(* Function that maps from instrument model to pure function that will convert our rate (in RPM) to a setting on the instrument. *)
(* This function was created by Guillaume via experimental measurement and linear fitting. *)
instrumentInstrumentToSettingFunction[modelInstrumentInstrument:(ObjectP[Model[Instrument]]|Null),cache_]:=Module[
	{instrumentPacket,instrumentObject},

	(* Lookup the instrument packet from the cache. *)
	instrumentPacket=fetchPacketFromCache[modelInstrumentInstrument,cache];

	(* Get the Object from the cache. *)
	instrumentObject=Lookup[instrumentPacket,Object,Null];

	(* Return the appropriate function. *)
	Switch[instrumentObject,
		Model[Instrument, Vortex, "id:dORYzZn0o45q"], (Round[10*(QuantityMagnitude[#]-750)/(3200-750),1]&),	 (*"Microplate Genie"*)
		Model[Instrument, Vortex, "id:E8zoYvNMxBq5"], (Round[10*(QuantityMagnitude[#]-750)/(3200-750),1]&),	 (*"Microplate Genie in Heat/Chill Incubator"*)
		Model[Instrument, Vortex, "id:8qZ1VWNmdKjP"], (Round[10*(QuantityMagnitude[#]-600)/(3200-600), 1]&),(* "Multi Tube Vortex Genie 2"*)
		Model[Instrument, Vortex, "id:E8zoYvNMxo8m"], (Round[10*(QuantityMagnitude[#]-600)/(3200-600), 1]&),(* "Multi Tube Vortex Genie 2 in Heat/Chill Incubator"*)
		Model[Instrument, BottleRoller, "id:lYq9jRzX330Y"], (Round[10*(QuantityMagnitude[#])/4, 1]&),	 (*"Cell-Production Roller Aparatus"*)
		Model[Instrument, BottleRoller, "id:4pO6dMWvnJ9B"], (QuantityMagnitude[#]&), (*Model[Instrument, BottleRoller, "Drum Roller"*)
		Model[Instrument, Vortex, "id:qdkmxz0A8YJm"], (Round[10*(QuantityMagnitude[#]-600)/(3200-600), 1]&), (*"35 mm Bottle Vortex Genie"*)
		Model[Instrument, Vortex, "id:E8zoYveRlq3w"], (Round[10*(QuantityMagnitude[#]-600)/(3200-600), 1]&),  (*"20 mm Bottle Vortex Genie"*)
		(* anything else return the QuantityMagnitude *)
		_, (QuantityMagnitude[#]&)
	]
];

(* ::Subsubsection::Closed:: *)
(*mixInstrumentsSearch*)

(* Memoize the search for mix instruments in the lab that are not deprecated *)
mixInstrumentsSearch[fakeString: _String] := mixInstrumentsSearch[fakeString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`mixInstrumentsSearch],
		AppendTo[$Memoization, Experiment`Private`mixInstrumentsSearch]
	];

	Search[
		{
			Model[Instrument, Vortex],
			Model[Instrument, Shaker],
			Model[Instrument, BottleRoller],
			Model[Instrument, Roller],
			Model[Instrument, OverheadStirrer],
			Model[Instrument, Sonicator],
			Model[Instrument, HeatBlock],
			Model[Instrument, Homogenizer],
			Model[Instrument, Disruptor],
			Model[Instrument, Nutator],
			Model[Instrument, EnvironmentalChamber],
			Model[Instrument, Thermocycler]
		},
		Deprecated == (False | Null) && DeveloperObject != True
	]
];


(* Memoize the search for integrated mix instruments in the lab that are not deprecated *)
mixDevicesIntegratedInstrumentsSearch[fakeString: _String] := mixDevicesIntegratedInstrumentsSearch[fakeString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`mixDevicesIntegratedInstrumentsSearch],
		AppendTo[$Memoization, Experiment`Private`mixDevicesIntegratedInstrumentsSearch]
	];

	Search[
		{
			Model[Instrument, Shaker]
		},
		IntegratedLiquidHandlers != Null && Deprecated == (False | Null) && DeveloperObject != True
	]
];


(* Memoize the search for non-integrated mix instruments in the lab that are not deprecated *)
mixDevicesNonIntegratedInstrumentsSearch[fakeString: _String] := mixDevicesNonIntegratedInstrumentsSearch[fakeString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`mixDevicesNonIntegratedInstrumentsSearch],
		AppendTo[$Memoization, Experiment`Private`mixDevicesNonIntegratedInstrumentsSearch]
	];

	Search[
		{
			Model[Instrument, Vortex],
			Model[Instrument, Shaker],
			Model[Instrument, BottleRoller],
			Model[Instrument, Roller],
			Model[Instrument, OverheadStirrer],
			Model[Instrument, Sonicator],
			Model[Instrument, Homogenizer],
			Model[Instrument, Disruptor],
			Model[Instrument, Nutator]
		},
		IntegratedLiquidHandlers == Null && Deprecated == (False | Null) && DeveloperObject != True
	]
];


(* ::Subsection::Closed:: *)
(*Execute Tasks*)


(* ::Subsubsection::Closed:: *)
(*Upload Helpers*)


uploadInvertFullyDissolved[object_]:=Upload[<|Object->object,Append[InvertFullyDissolved]->True|>];

uploadSwirlFullyDissolved[object_]:=Upload[<|Object->object,Append[SwirlFullyDissolved]->True|>];

uploadThawStartTime[object_]:=Upload[<|Object->object,ThawStartTime->Now|>];

uploadCurrentStartDate[object_]:=Upload[<|Object->object,CurrentStartDate->Now|>];

uploadTemporaryMixUntilDissolvedFalse[object_]:=Upload[<|Object->object,Append[TemporaryMixUntilDissolved]->False|>];

uploadCurrentMixUntilDissolved[object_]:=Module[{currentMixUntilDissolved,temporaryMixUntilDissolved,truePositions},
	(* Download from our protocol object. *)
	{currentMixUntilDissolved,temporaryMixUntilDissolved}=Download[object,{CurrentMixUntilDissolved,TemporaryMixUntilDissolved}];

	(* If CurrentMixUntilDissolved is blank, just copy over TemporaryMixUntilDissolved. *)
	(* Otherwise, we have to reconsile the two. *)
	If[MatchQ[currentMixUntilDissolved,{}|Null],
		Upload[<|
			Object->object,
			Replace[CurrentMixUntilDissolved]->temporaryMixUntilDissolved,
			Replace[TemporaryMixUntilDissolved]->Null
		|>],
		(* We only uploaded results where CurrentMixUntilDissolved is True (we have a batch setup). *)
		(* Get the positions of the True elements in CurrentMixUntilDissolved. *)
		truePositions=Flatten[Position[currentMixUntilDissolved,True]];

		(* Replace these positions with the result from TemporaryMixUntilDissolved. *)
		(* These are the updated statuses of our batches. *)
		Upload[<|
			Object->object,
			Replace[CurrentMixUntilDissolved]->ReplacePart[
				currentMixUntilDissolved,
				MapThread[#1->#2&,{truePositions,temporaryMixUntilDissolved}]
			],
			Replace[TemporaryMixUntilDissolved]->Null
		|>]
	]
];

uploadPipetteFullyDissolvedFalse[object_]:=Upload[<|Object->object,Append[PipetteFullyDissolved]->False|>];

clearPipetteFullyDissolved[object_]:=Upload[<|Object->object,Replace[PipetteFullyDissolved]->Null|>];


(* ::Subsubsection:: *)
(*temperatureShakerQ*)


(* Returns BooleanP based on if this instrument object has the model Model[Instrument,Shaker,"id:mnk9jORRwA7Z"]. *)
temperatureShakerQ[myInstrumentObject_]:=Module[{instrumentModel},
	(* Get the model from the instrument object. *)
	instrumentModel=Download[myInstrumentObject,Model]/.{link_Link:>Download[link, Object]};

	(* Is this model the temperature enviro genie? *)
	MatchQ[instrumentModel,Model[Instrument,Shaker,"id:mnk9jORRwA7Z"]]
];


(* ::Subsubsection:: *)
(*temperatureRollerQ*)


(* Returns BooleanP based on if this instrument object has the model Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]. *)
temperatureRollerQ[myInstrumentObject_]:=Module[{instrumentModel},
	(* Get the model from the instrument object. *)
	instrumentModel=Download[myInstrumentObject,Model]/.{link_Link:>Download[link, Object]};

	(* Is this model the temperature enviro genie? *)
	MatchQ[instrumentModel,Model[Instrument,Roller,"id:Vrbp1jKKZw6z"]]
];


(* ::Subsubsection:: *)
(*drumRollerQ*)


(* Returns BooleanP based on if this instrument object has the model Model[Instrument,BottleRoller,"id:4pO6dMWvnJ9B"]. *)
drumRollerQ[myInstrumentObject_]:=Module[{instrumentModel},
	(* Get the model from the instrument object. *)
	instrumentModel=Download[myInstrumentObject,Model]/.{link_Link:>Download[link, Object]};

	(* Is this model the drum roller? *)
	MatchQ[instrumentModel,Model[Instrument,BottleRoller,"id:4pO6dMWvnJ9B"]]
];


(* ::Subsubsection:: *)
(*cellProductionRollerQ*)


(* Returns BooleanP based on if this instrument object has the model Model[Instrument,BottleRoller,"id:lYq9jRzX330Y"]. *)
cellProductionRollerQ[myInstrumentObject_]:=Module[{instrumentModel},
	(* Get the model from the instrument object. *)
	instrumentModel=Download[myInstrumentObject,Model]/.{link_Link:>Download[link, Object]};

	(* Is this model the drum roller? *)
	MatchQ[instrumentModel,Model[Instrument,BottleRoller,"id:lYq9jRzX330Y"]]
];


(* ::Subsubsection:: *)
(*ikaRollerQ*)


(* Returns BooleanP based on if this instrument object has the model Model[Instrument,BottleRoller,"id:lYq9jRzX330Y"]. *)
ikaRollerQ[myInstrumentObject_]:=Module[{instrumentModel},
	(* Get the model from the instrument object. *)
	instrumentModel=Download[myInstrumentObject,Model]/.{link_Link:>Download[link, Object]};

	(* Is this model the drum roller? *)
	MatchQ[instrumentModel,Model[Instrument,BottleRoller,"id:n0k9mG8KJbjp"]]
];


(* ::Subsubsection:: *)
(*compatibleSonicationContainers*)


compatibleSonicationContainers[]:=compatibleSonicationContainers[]=Flatten@Search[
	Model[Container, Vessel],
	And[
		DeveloperObject != True,
		Or[
			(* The vessel will fit in one of our tube floats *)
			Footprint==(MicrocentrifugeTube|CEVial|GlassReactionVessel|Conical15mLTube|Conical50mLTube),
			(* OR it can be weighed down by our weighted sonication collar. Give it 5 Millimeter tolerance *)
			And[
				Aperture < $MaxFlaskRingAperture - $FlaskRingClearance,
				InternalDiameter > $MinFlaskRingAperture + $FlaskRingClearance
			]
		]
	]
];

(* ::Subsection::Closed:: *)
(*MixDevices*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[MixDevices,
	Options:>{
		{
			OptionName -> Types,
			Default -> {Vortex,Stir,Shake,Roll,Disrupt,Nutate,Sonicate,Homogenize},
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[Vortex,Stir,Shake,Roll,Disrupt,Nutate,Sonicate,Homogenize]],
				Adder[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Vortex,Stir,Shake,Roll,Disrupt,Nutate,Sonicate,Homogenize]]
				]
			],
			Description -> "Indicates the style of motion used to mix the sample."
		},
		{
			OptionName -> Rate,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				"RPM" -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
				"Gravitational Acceleration (Acoustic Shaker Only)" -> Widget[Type -> Quantity, Pattern :> RangeP[0 GravitationalAcceleration, 100 GravitationalAcceleration], Units->GravitationalAcceleration]
			],
			Description -> "Frequency of rotation the mixing instrument should use to mix the samples.",
			ResolutionDescription -> "Automatically, resolves based on the sample container and instrument instrument model."
		},
		{
			OptionName -> Temperature,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, $MaxIncubationTemperature],Units :> Celsius],
				Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
			],
			Description -> "The temperature of the device that should be used to mix the sample."
		},
		{
			OptionName -> MaxTemperature,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius],Units :> Celsius]
			],
			Description -> "The maximum temperature that the sample should reach during mixing via homogenization. If the measured temperature is above this MaxTemperature, the homogenizer will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume."
		},
		{
			OptionName -> OscillationAngle,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 AngularDegree, 15 AngularDegree],Units :> AngularDegree],
			Description -> "The angle of oscillation of the mixing motion when a wrist action shaker is used."
		},
		{
			OptionName -> ProgrammableMixControl,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates that the mixer supports the specification of a mix rate profile."
		},
		{
			OptionName -> ProgrammableTemperatureControl,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates that the mixer supports the specification of a temperature profile."
		},
		{
			OptionName -> Amplitude,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[10 Percent, 100 Percent],Units :> Percent],
			Description -> "The amplitude of the sonciation horn used to homogenize the sample, when mixing by homogenization."
		},
		{
			OptionName -> IntegratedLiquidHandler,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if only devices that are integrated with a liquid handler should be returned."
		},
		{
			OptionName -> Output,
			Default -> Instruments,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Instruments,Containers]],
				Adder[
					Widget[Type->Enumeration,Pattern:>Alternatives[Instruments,Containers]]
				]
			],
			Description -> "Indicates if the result, the suitable mix device(s) for the sample, and/or containers, containers that the sample must be aliquoted into - if the sample's current container cannot fit on the mix device, should be returned."
		},
		{
			OptionName -> InstrumentSearch,
			Default ->Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type->Object,Pattern:>ObjectP[Model[Instrument]]]],
			Description -> "Indicates a list of instruments available in the lab to avoid repeated searches when possible.",
			Category -> "Hidden"
		},
		{
			OptionName -> StirBar,
			Default -> True,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates that if we want to allow StirBar usage when mix type is Stir."
		},
		CacheOption,
		SimulationOption
	}
];


(* ::Subsubsection::Closed:: *)
(*Main Function*)


(* Overload that takes in a container. *)
MixDevices[myContainer:ObjectReferenceP[Model[Container]], mySampleVolume:VolumeP, myOptions:OptionsPattern[]]:=Module[
	{samplePacket, containerPacket},

	(* Simulate our sample and container. *)
	{{samplePacket}, containerPacket}=SimulateSample[
		{Model[Sample, "Milli-Q water"]},
		"after Simulation",
		{"A1"},
		myContainer,
		{Volume -> mySampleVolume}
	];

	(* Fake a sample to pass into the main function. *)
	MixDevices[
		samplePacket,
		Append[ToList[myOptions], Cache->{samplePacket, containerPacket}]
	]
];

MixDevices[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,safeOps,types,rate,temperature,amplitude,maxTemperature,cache,instrumentSearch,instruments,
	groupedInstruments,vortexes,shakers,bottleRollers,rollers,stirrers,sonicators,homogenizers,
	supportedSonicationContainers,preferredVessels,preferredVesselPackets,shakeAdapterPackets,
	samplePackets,sampleCompositionPackets,sampleContainerPackets,sampleSolventPackets,vortexInstrumentPackets,shakeInstrumentPackets,
	bottleRollerInstrumentPackets,homogenizerInstrumentPackets,sonicationHornPackets,
	rollInstrumentPackets,stirInstrumentPackets,impellerPackets,sonicationInstrumentPackets,sonicationContainerPackets,
	cacheBall,sampleContainerModel,sampleContainerWeight,sampleContainerMaxVolume,simulation,oscillationAngle,programmableTemperatureControl,programmableMixControl,
	wiggleRoom,modelDimensions,sterile,lightSensitive,sampleVolume,sampleMass,sampleDensity,solventDensity,
	estimatedSampleDensity,estimatedSampleMass,estimatedTotalWeight,devicesAndContainersResult,
	potentialAliquotContainers,instrumentResult,containerModelMaxVolume,disruptors,nutators,
	disruptorInstrumentPackets, nutatorInstrumentPackets, integratedLiquidHandler, stirBar,
	fastAssoc, sampleContainerModelPacket, samplePacket},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Get the safe options of our function. *)
	safeOps=SafeOptions[MixDevices,listedOptions,AutoCorrect->False];

	(* Determine the mix types that we should return information for. *)
	types=ToList[Lookup[safeOps,Types]];

	(* Determine the value of our rate and temperature specification. *)
	rate=Lookup[safeOps,Rate];
	temperature=Lookup[safeOps,Temperature]/.{Ambient|RangeP[$AmbientTemperature-0.0001 Celsius,$AmbientTemperature+0.0001 Celsius]->Null};
	amplitude=Lookup[safeOps,Amplitude];
	maxTemperature=Lookup[safeOps,MaxTemperature];
	oscillationAngle=Lookup[safeOps,OscillationAngle];
	programmableTemperatureControl=Lookup[safeOps,ProgrammableTemperatureControl];
	programmableMixControl=Lookup[safeOps,ProgrammableMixControl];
	integratedLiquidHandler=Lookup[safeOps,IntegratedLiquidHandler];
	stirBar = Lookup[safeOps, StirBar];

	(* Get instrument search results that were previously run *)
	instrumentSearch=Lookup[safeOps,InstrumentSearch];

	(* Lookup our cache. *)
	cache=Lookup[safeOps,Cache];
	simulation=Lookup[safeOps,Simulation];

	(* Get the mix instruments in the lab that are not deprecated. *)
	instruments = If[NullQ[instrumentSearch],
		If[MatchQ[integratedLiquidHandler, True],
			mixDevicesIntegratedInstrumentsSearch["Memoization"],
			mixDevicesNonIntegratedInstrumentsSearch["Memoization"]
		],
		mixInstrumentsSearch["Memoization"]
	];

	(* Separate out these instruments by instrument type. *)
	groupedInstruments=GroupBy[instruments,#[Type]&];
	vortexes=Lookup[groupedInstruments,Model[Instrument,Vortex],{}];
	shakers=Lookup[groupedInstruments,Model[Instrument,Shaker],{}];
	bottleRollers=Lookup[groupedInstruments,Model[Instrument,BottleRoller],{}];
	rollers=Lookup[groupedInstruments,Model[Instrument,Roller],{}];
	stirrers=Lookup[groupedInstruments,Model[Instrument,OverheadStirrer],{}];
	sonicators=Lookup[groupedInstruments,Model[Instrument,Sonicator],{}];
	homogenizers=Lookup[groupedInstruments,Model[Instrument,Homogenizer],{}];
	disruptors=Lookup[groupedInstruments,Model[Instrument,Disruptor],{}];
	nutators=Lookup[groupedInstruments,Model[Instrument,Nutator],{}];

	(* Supported sonication containers that will fit in the sonication floats or self stand. *)
	supportedSonicationContainers=compatibleSonicationContainers[];

	(* Get all of our preferred vessels. *)
	preferredVessels=DeleteDuplicates[Flatten[{
		PreferredContainer[All,Type->Vessel],
		PreferredContainer[All,Sterile->True,LightSensitive->True,Type->Vessel],
		PreferredContainer[All,Sterile->False,LightSensitive->True,Type->Vessel],
		PreferredContainer[All,Sterile->True,LightSensitive->False,Type->Vessel],
		Model[Container,Plate,"id:L8kPEjkmLbvW"], (* 96 deep-well plate *)
		Model[Container, Vessel, "id:xRO9n3vk11mz"] (* 50mL beaker *)
	}]];

	(* Extract the packets that we need from our downloaded cache. *)
	{
		{
			samplePackets,
			sampleCompositionPackets,
			sampleContainerPackets,
			sampleSolventPackets,
			vortexInstrumentPackets,
			shakeInstrumentPackets,
			shakeAdapterPackets,
			bottleRollerInstrumentPackets,
			rollInstrumentPackets,
			stirInstrumentPackets,
			impellerPackets,
			sonicationInstrumentPackets,
			homogenizerInstrumentPackets,
			sonicationHornPackets,
			disruptorInstrumentPackets,
			nutatorInstrumentPackets,
			preferredVesselPackets
		}
	}=Quiet[Flatten[Download[
		{
			(* Download {WettedMaterials, Positions, MaxRotationRate, MinRotationRate} from our instruments. *)
			{mySample},
			{mySample},
			{mySample},
			{mySample},
			vortexes,
			shakers,
			shakers,
			bottleRollers,
			rollers,
			stirrers,
			stirrers,
			sonicators,
			homogenizers,
			homogenizers,
			disruptors,
			nutators,
			preferredVessels
		},
		{
			{Packet[Object,Volume,Mass,Sterile,Container,Fuming,Ventilated,Flammable,Density,Solvent]},
			{Packet[Composition[[All, 2]][{Fuming, Ventilated, Flammable}]]},
			{Packet[Container[Model][{Aperture,InternalDepth,InternalDimensions,InternalDiameter,SelfStanding,OpenContainer,MinVolume,MaxVolume,Dimensions,Footprint, SelfStanding, TareWeight, MaxOverheadMixRate}]]},
			{Packet[Solvent[{Density}]]},
			{Packet[WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature]},
			{Packet[IntegratedLiquidHandlers, ProgrammableTemperatureControl, ProgrammableMixControl, MaxOscillationAngle, MinOscillationAngle, WettedMaterials, Positions, MaxForce, MinForce, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, GripperDiameter, CompatibleAdapters, MaxWeight]},
			{Packet[CompatibleAdapters[Positions]]},
			{Packet[WettedMaterials, Positions, MaxRotationRate, MinRotationRate, RollerSpacing, Objects]},
			{Packet[WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, CompatibleRacks, Objects]},
			{Packet[WettedMaterials, Positions, MaxStirBarRotationRate, StirBarControl, MinStirBarRotationRate, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, CompatibleImpellers]},
			{Packet[CompatibleImpellers[{StirrerLength,MaxDiameter,ImpellerDiameter,Name, WettedMaterials}]]},
			{Packet[WettedMaterials, Positions, MinTemperature, MaxTemperature, CompatibleSonicationAdapters]},
			{Packet[WettedMaterials, Positions, MinTemperature, MaxTemperature, CompatibleSonicationHorns]},
			{Packet[CompatibleSonicationHorns[{HornLength,HornDiameter}]]},
			{Packet[WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature]},
			{Packet[WettedMaterials, Positions, MaxRotationRate, MinRotationRate, MinTemperature, MaxTemperature, InternalDimensions]},
			{Packet[Aperture,InternalDepth,Footprint,InternalDiameter,InternalDimensions,SelfStanding,OpenContainer,MinVolume,MaxVolume,Dimensions, MaxOverheadMixRate]}
		},
		Cache->cache,
		Simulation->simulation
	],{3}],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* Ball up our cache & make fast assoc. *)
	cacheBall=FlattenCachePackets[{samplePackets,sampleContainerPackets,vortexInstrumentPackets,shakeInstrumentPackets,rollInstrumentPackets,stirInstrumentPackets,sonicationInstrumentPackets,disruptorInstrumentPackets, nutatorInstrumentPackets,preferredVesselPackets,cache}];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the sample's container's model. *)
	sampleContainerModel=Lookup[First[Flatten[sampleContainerPackets]],Object];

	(* Get the packet of the sample's container's model processed by FlattenCachePackets. *)
	sampleContainerModelPacket = fetchPacketFromFastAssoc[sampleContainerModel, fastAssoc];

	(* Get the sample's container's weight *)
	sampleContainerWeight=Lookup[First[Flatten[sampleContainerPackets]],TareWeight];

	(* Get the sample's container's max volume *)
	sampleContainerMaxVolume=Lookup[First[Flatten[sampleContainerPackets]],MaxVolume];

	(* Get the flattened packet of the sample *)
	samplePacket = fetchPacketFromFastAssoc[mySample, fastAssoc];

	(* Get the sample's volume *)
	sampleVolume = Lookup[samplePacket, Volume, Null];

	(* Get the sample's mass *)
	sampleMass = Lookup[samplePacket, Mass, Null];

	(* Get the sample's density *)
	sampleDensity = Lookup[samplePacket, Density, Null];

	(* Get the sample's solvent's density  *)
	solventDensity = If[MatchQ[sampleSolventPackets,PacketP..],
		Lookup[First[Flatten[sampleSolventPackets]], Density, Null],
		Null
	];

	(* Get our best estimate of the sample's density *)
	estimatedSampleDensity = Which[

		(* If we know the sample's density, then use it *)
		DensityQ[sampleDensity], sampleDensity,

		(* If we know the sample's mass and volume, use them to calculate the density *)
		MassQ[sampleMass] && VolumeQ[sampleVolume] && TrueQ[sampleVolume > 0 Liter], sampleMass / sampleVolume,

		(* If we know the sample's solvent's density, then use it *)
		DensityQ[solventDensity], solventDensity,

		(* Otherwise, use a density slightly higher than that of water *)
		True, 1.2 Gram / Milliliter
	];

	(* Get our best estimate of the sample's mass *)
	estimatedSampleMass = Which[

		(* If we know the sample's mass, then use it *)
		MassQ[sampleMass], sampleMass,

		(* If we know the sample's volume, then use it and the estimated density to calculate the mass *)
		VolumeQ[sampleVolume], sampleVolume * estimatedSampleDensity,

		(* Otherwise use the max volume of the container model and the estimated density *)
		True, sampleContainerMaxVolume * estimatedSampleDensity
	];

	(* Get our best estimate for the total weight of container + sample *)
	estimatedTotalWeight = sampleContainerWeight + estimatedSampleMass;

	(* Compute the best mix devices (and transfer container, if applicable) for the specified mix types. *)
	devicesAndContainersResult=Function[type,
		Module[{oscillationAnglePattern,filterPattern,instrumentPackets,filteredInstrumentPackets,compatibleInstruments,filteredCompatibleInstruments,filteredContainers,compatibleFootprintsQ,containers,containerResult,containerRules},
			(* Create a pattern to filter our instruments based on the given options. *)
			filterPattern=Module[{ratePattern,temperaturePattern,weightPattern,programmableMixControlPattern,programmableTemperatureControlPattern},
				(* Create a pattern for Rate. *)
				ratePattern=Which[
					MatchQ[rate,RPMP],
						Alternatives[
							KeyValuePattern[{
								MaxRotationRate->GreaterEqualP[rate],
								MinRotationRate->LessEqualP[rate]
							}],
							KeyValuePattern[{
								MaxStirBarRotationRate->GreaterEqualP[rate],
								MinStirBarRotationRate->LessEqualP[rate]
							}]
						],
					MatchQ[rate,UnitsP[GravitationalAcceleration]],
						KeyValuePattern[{
							MaxForce->GreaterEqualP[rate],
							MinForce->LessEqualP[rate]
						}],
					True,
						_
				];

				(* Create a pattern for OscillationAngle. *)
				oscillationAnglePattern=If[!MatchQ[oscillationAngle,Null],
					KeyValuePattern[{
						MaxOscillationAngle->GreaterEqualP[oscillationAngle],
						MinOscillationAngle->LessEqualP[oscillationAngle]
					}],
					_
				];

				(* Create a pattern for ProgrammableMixControl. *)
				programmableMixControlPattern=If[!MatchQ[programmableMixControl,Null],
					KeyValuePattern[{
						ProgrammableMixControl->programmableMixControl
					}],
					_
				];

				(* Create a pattern for ProgrammableTemperatureControl. *)
				programmableTemperatureControlPattern=If[!MatchQ[programmableTemperatureControl,Null],
					KeyValuePattern[{
						ProgrammableTemperatureControl->programmableTemperatureControl
					}],
					_
				];

				(* Create a pattern for Temperature. *)
				temperaturePattern=If[!MatchQ[temperature,Null],
					KeyValuePattern[{
						MaxTemperature->GreaterEqualP[temperature],
						MinTemperature->LessEqualP[temperature]
					}],
					_
				];

				(* Create a pattern for MaxWeight. This field only exists for shakers. *)
				weightPattern=If[MatchQ[type, Shake],
					KeyValuePattern[{
						MaxWeight->(Null|GreaterEqualP[estimatedTotalWeight])
					}],
					_
				];

				(* Combine to create our pattern. *)
				PatternUnion[
					ratePattern,
					oscillationAnglePattern,
					programmableMixControlPattern,
					programmableTemperatureControlPattern,
					temperaturePattern,
					weightPattern
				]
			];

			(* Get our corresponding instrument packet. *)
			instrumentPackets=Switch[type,
				Vortex,
					vortexInstrumentPackets,
				Roll,
					Flatten[{bottleRollerInstrumentPackets,rollInstrumentPackets}],
				Shake,
					shakeInstrumentPackets,
				Stir,
				If[MemberQ[
					Flatten[{
						Lookup[Flatten@samplePackets, {Fuming, Ventilated, Flammable}],
						(*we have to pick only packets here because it is legal for the samples to have composition elements of Null*)
						Lookup[Cases[Flatten@sampleCompositionPackets,PacketP[]], {Fuming, Ventilated, Flammable}]
					}],
					True],
						Cases[stirInstrumentPackets, KeyValuePattern[{Object->ObjectP[Model[Instrument, OverheadStirrer, "id:Z1lqpMzavMN9"]]}]],
						stirInstrumentPackets
					],
				Sonicate,
					sonicationInstrumentPackets,
				Disrupt,
					disruptorInstrumentPackets,
				Nutate,
					nutatorInstrumentPackets,
				Homogenize,
					homogenizerInstrumentPackets
			];

			(* Filter the instrument packets to make sure we can support the user-supplied Rate/Temperature. *)
			filteredInstrumentPackets=Cases[instrumentPackets,filterPattern];

			(* Do we have any filtered instruments? *)
			If[Length[filteredInstrumentPackets]==0,
				(* There are no filtered instruments. *)
				Nothing,

				(* There are filtered instruments. Do footprint checks. *)
				compatibleFootprintsQ = Module[
					{
						locations, minWidths, exactMatchQs,
						expandedLocations, expandedMinWidths, expandedExactMatchQs,
						flattenedLocations, flattenedMinWidths, flattenedExactMatchQs,
						flattenedCompatibleFootprintQs, expandedCompatibleFootprintQs
					},

					(* Preprocess variable inputs/options for listable CompatibleFootprintQ call *)
					{locations, minWidths, exactMatchQs} = Transpose[
						Map[Module[
							{filteredInstrumentObject},

							filteredInstrumentObject = Lookup[#, Object];

							{
								(* Input: location *)
								(* If we are dealing with Roller, we need to check if the footprint of sample match with any of the compatible racks *)
								If[MatchQ[filteredInstrumentObject, ObjectP[Model[Instrument, Roller]]],
									Lookup[#, CompatibleRacks],
									filteredInstrumentObject
								],

								(* Option: minWidth *)
								(* Set MinWidth if we're dealing with a bottle roller. *)
								If[MatchQ[filteredInstrumentObject, ObjectP[Model[Instrument, BottleRoller]]],
									Lookup[#, RollerSpacing],
									Null
								],

								(* Option: exactMatchQ *)
								Which[
									MatchQ[filteredInstrumentObject, ObjectP[Model[Instrument, Roller]]],
										True,
									(* for torrey pine and incu shaker, we only want to use the container with exact footprint *)
									MatchQ[filteredInstrumentObject, ObjectP[{
										Model[Instrument, Shaker, "id:N80DNj15vreD"],
										Model[Instrument, Shaker, "id:6V0npvmNnOrw"]
									}]],
										True,
									(* Set ExactMatch->False if we're dealing with a sonicator, bottle roller, shaker, nutator, homogenizer or overhead stirrer. *)
									(* for genie temp shaker, we allow it to use with or without adapter. *)
									MatchQ[filteredInstrumentObject, ObjectP[{
										Model[Instrument, Sonicator],
										Model[Instrument, BottleRoller],
										Model[Instrument, Shaker],
										Model[Instrument, Nutator],
										Model[Instrument, OverheadStirrer],
										Model[Instrument, Homogenizer]
									}]],
									False,
									(* otherwise set to True *)
									True,
										True
								]
							}]&,
							filteredInstrumentPackets
						]
					];

					(* Expand inputs for listable CompatibleFootprintQ call *)
					{expandedLocations, expandedMinWidths, expandedExactMatchQs} = Transpose[
						MapThread[Function[{location, minWidth, exactMatchQ},
							If[ListQ[location],
								(* Lists (of compatible racks) correspond to Rollers; expand options to index match to compatible racks *)
								{location, ConstantArray[minWidth, Length[location]], ConstantArray[exactMatchQ, Length[location]]},
								(* ToList atomic elements to singletons for downstream TakeList *)
								{{location}, {minWidth}, {exactMatchQ}}
							]],
							{locations, minWidths, exactMatchQs}
						]
					];

					(* Flatten inputs for listable CompatibleFootprintQ call since CompatibleFootprintQ cannot take mixed (ex. {x, {x}}) inputs *)
					{flattenedLocations, flattenedMinWidths, flattenedExactMatchQs} = Flatten /@ {expandedLocations, expandedMinWidths, expandedExactMatchQs};

					(* Listable CompatibleFootprintQ call for all filtered instruments *)
					flattenedCompatibleFootprintQs = CompatibleFootprintQ[
						flattenedLocations,
						sampleContainerModel,
						MinWidth -> flattenedMinWidths,
						ExactMatch -> flattenedExactMatchQs,
						Cache -> cacheBall
					];

					(* Output is either a flattened list, {p1, p2, p3, ...}, or a single boolean, p1, corresponding to a single non-list input *)
					If[ListQ[flattenedCompatibleFootprintQs],
						(* Group outputs of listable call, each sublist corresponding to the index-matched location; {p1, p2, p3, ...} -> {{p1}, {p2, p3}, ...} *)
						expandedCompatibleFootprintQs = TakeList[flattenedCompatibleFootprintQs, Length /@ expandedLocations];

						(* For rollers, the footprint has to be compatible with any of the compatible racks. Or-ing singletons for non-rollers *)
						(Or @@ #)& /@ expandedCompatibleFootprintQs,

						(* If the output is a single boolean, return that *)
						flattenedCompatibleFootprintQs
					]
				];

				(* Filter our instruments based on compatible footprints. *)
				compatibleInstruments=PickList[
					Lookup[filteredInstrumentPackets,Object],
					ToList[compatibleFootprintsQ]
				];

				(* Do some additional filtering based on our mix type. *)
				filteredCompatibleInstruments=Switch[type,
					Sonicate,
					Which[
						MatchQ[sampleContainerModel,ObjectP[Model[Container,Vessel]]],
						(* If our vessel is self standing and can fit a self-standing weight, we don't need to put it in a float. *)
							Which[
								(* Our special tube is allowed in the QSonica with a special rack. *)
								MatchQ[sampleContainerModel, ObjectP[Model[Container, Vessel, "id:pZx9jo8MaknP"]]],
									Cases[compatibleInstruments, ObjectP[Model[Instrument, Sonicator, "id:6V0npvmZlEk6"]]],
								And[
									(* Self-standing check *)
									MatchQ[
										Lookup[sampleContainerModelPacket, SelfStanding, False],
										True
									],
									(* About as large as a 250mL vessel in order to fit a sonciation weight. *)
									MatchQ[
										Lookup[sampleContainerModelPacket, Dimensions, {0 Meter, 0 Meter, 0 Meter}],
										{GreaterEqualP[0.068 Meter], GreaterEqualP[0.068 Meter], GreaterEqualP[.13 Meter]}
									]
								],
									Cases[compatibleInstruments, Except[ObjectP[Model[Instrument, Sonicator, "id:6V0npvmZlEk6"]]]],
								(* Otherwise, only allow approved sonication containers (for which we have specific floats or rings for). *)
								MemberQ[supportedSonicationContainers,sampleContainerModel],
									Cases[compatibleInstruments, Except[ObjectP[Model[Instrument, Sonicator, "id:6V0npvmZlEk6"]]]],
								True,
									{}
							],
						(* ELSE: Not a Model[Container,Vessel]. *)
						True,
							If[And[
									MatchQ[sampleContainerModel, ObjectP[Model[Container, Plate]]],
									MatchQ[
										Lookup[sampleContainerModelPacket, Dimensions, {0 Meter, 0 Meter, 0 Meter}],
										{LessEqualP[0.1376 Meter], LessEqualP[0.0955 Meter], LessEqualP[0.0544 Meter]}
									]
								],
								{Model[Instrument, Sonicator, "id:6V0npvmZlEk6"]},
								{}
							]
					],
					Shake|Roll,
						(* Are we only asking for hamilton compatible things? *)
						If[MatchQ[integratedLiquidHandler, False],
							Which[
								MatchQ[sampleContainerModel,ObjectP[Model[Container,Plate]]],
									(* NOTE: he torrey pines shaker and the LabRAM shaker is fine. *)
									Cases[compatibleInstruments, ObjectP[{Model[Instrument, Shaker, "id:N80DNj15vreD"], Model[Instrument, Shaker, "id:bq9LA0JYrN66"]}]],

								(* Volumetric Flask can be shaked with genie-temp or incu-shaker *)
								MatchQ[sampleContainerModel, ObjectP[Model[Container, Vessel, VolumetricFlask]]],
									If[MatchQ[rate,RPMP] && rate > $MaxVolumetricFlaskShakeRate,
										(* If we want to shake a VF, its mix rate cannot exceed $MaxVolumetricFlaskShakeRate--250 RPM *)
										{},
										(* Model[Instrument, Shaker, "Genie Temp-Shaker 300"] and Model[Instrument, Shaker, "Incu-Shaker 10L"] can be used for VF *)
										Cases[compatibleInstruments, ObjectP[{Model[Instrument, Shaker, "id:mnk9jORRwA7Z"], Model[Instrument, Shaker, "id:6V0npvmNnOrw"]}]]
									],

								True,
									(* For each instrument, if GripperDiameter is filled out, make sure the Aperture of the container can be gripped. *)
									(* Also, only self standing containers can be put into the LabRAM. *)
									(
										Module[{packet},
											packet=fetchPacketFromCache[#, filteredInstrumentPackets];

											If[And[
													If[MatchQ[#, ObjectP[Model[Instrument, Shaker, "id:bq9LA0JYrN66"]]],
														MatchQ[Lookup[sampleContainerModelPacket, SelfStanding], True],
														True
													],
													MatchQ[Lookup[packet, GripperDiameter], GreaterP[0 Millimeter]],
													!MatchQ[
														Lookup[packet, GripperDiameter],
														GreaterEqualP[Lookup[sampleContainerModelPacket, Aperture]]
													]
												],
												Nothing,
												#
											]
										]
									&)/@compatibleInstruments
							],
							(* We're asking for hamilton compatible things. *)
							compatibleInstruments
						],
					Stir,
						Which[
							(* If we are considering aliquot, we can loosen some container constraints, the only absolutely-no condition is our sample volume is too low *)
							MemberQ[output,Containers] && LessQ[sampleVolume, 20*Milliliter],
								{},
							(* if we want the sample in the current container and does not want it to use StirBar *)
							And[
								!MemberQ[output, Containers],
								MatchQ[stirBar, False],
								Or[
									(* No Stir if the sample container is missing MaxOverheadMixRate *)
									NullQ[Lookup[sampleContainerModelPacket, MaxOverheadMixRate, Null]],

									(* No Stir if the sample container is the mix rate is over MaxOverheadMixRate *)
									rate > Lookup[sampleContainerModelPacket, MaxOverheadMixRate]
								]
							],
								{},
							(* We just want to know if sample in the current container can be stirred or not*)
							And[
								!MemberQ[output,Containers],
								Or[
									(* No Stir for volumetric flask *)
									MatchQ[sampleContainerModel, ObjectP[Model[Container, Vessel, VolumetricFlask]]],

									(* No Stir for sample volume below 20mL *)
									LessQ[sampleVolume, 20*Milliliter],

									(* No Stir for sample to container max volume ratio below 40% *)
									LessQ[FirstCase[
										{
											sampleVolume / Lookup[sampleContainerModelPacket, MaxVolume, Null],
											0.39
										}, NumericP
									], 0.4]
								]
							],
								{},
							True,
							(* Assume that as long as we do not have the combination of no aliquot allowed and sample volume below 20mL, there is an either an impeller or stirbar that is compatible. *)
								compatibleInstruments
						],
					Homogenize,
						If[MatchQ[sampleContainerModel,ObjectP[Model[Container,Vessel,VolumetricFlask]]],
							(* No Homogenize for volumetric flask *)
							{},
							(* Make sure that for each compatible instrument, there is an sonication horn that is compatible with our container. *)
							Module[{bestSonicationHorn},
								Map[
									Function[{instrument},
										(* Get the sample's volume and the container's max volume. *)
										containerModelMaxVolume = Lookup[sampleContainerModelPacket, MaxVolume, 2 Milliliter];

										(* Filter out the sample if it has a volume that's within 95% of the container's max volume. *)
										(* This is so that the sample doesn't get displaced out of the container. *)
										(* No compatible devices if sample has no volume (it is a solid). *)
										If[MatchQ[sampleVolume,Null]||MatchQ[sampleVolume,GreaterEqualP[.95*containerModelMaxVolume]],
											(* We are more than 95% full in our container. Require a transfer to homogenize. *)
											Nothing,
											(* Get the best impeller for this sample and instrument. *)
											bestSonicationHorn=compatibleSonicationHorn[mySample,instrument,Cache->cacheBall,Simulation->simulation];

											(* Were we able to find a sonication horn, if not, filter out this instrument. *)
											If[MatchQ[bestSonicationHorn,Null],
												Nothing,
												(* If we have a compatible sonication horn, make sure the container of the sample is also self-standing, or has an approved holder (2mL, 15mL, or 50mL tube). *)
												If[TrueQ[
													Or[
														Lookup[sampleContainerModelPacket, SelfStanding, False],
														MatchQ[sampleContainerModel, ObjectP[{
															Model[Container, Vessel, "id:3em6Zv9NjjN8"],
															Model[Container, Vessel, "id:xRO9n3vk11pw"],
															Model[Container, Vessel, "id:bq9LA0dBGGR6"]
														}]]
													]],

													(* If we were given an Amplitude over 70 Percent, the sonication horn used can't be one of the small ones. *)
													(* The object we have listed is the large sonication horn. There is only one large sonication horn. *)
													If[MatchQ[amplitude,GreaterP[70 Percent]]&&!MatchQ[bestSonicationHorn,ObjectP[Model[Part, SonicationHorn, "id:WNa4ZjKzw8p4"]]],
														Nothing,

														(* If we were given a MaxTemperature, there has to be at least 1 CM of clearance between the container aperture and the sonication horn's diameter *)
														If[And[
															MatchQ[maxTemperature, TemperatureP],
															MatchQ[
																Lookup[sampleContainerModelPacket, Aperture] - fastAssocLookup[fastAssoc, bestSonicationHorn, HornDiameter],
																LessEqualP[1 Centimeter]
															]],
															Nothing,
															instrument
														]
													],
													Nothing
												]
											]
										]
									],
									compatibleInstruments
								]
							]
						],
					Disrupt|Nutate,
						If[MatchQ[sampleContainerModel,ObjectP[Model[Container,Vessel,VolumetricFlask]]],
							(* No Disrupt|Nutate for volumetric flask *)
							{},
							compatibleInstruments
						],
					_,
						compatibleInstruments
				];

				(* Were we asked to compute potentialAliquotContainers? *)
				containers=If[MemberQ[output,Containers],
					containerResult=AliquotContainers[
						Lookup[filteredInstrumentPackets,Object],
						mySample,

						(* Set MidWidth if we're dealing with a bottle roller. *)
						MinWidth->(
							If[MatchQ[Lookup[#,Object],ObjectP[Model[Instrument,BottleRoller]]],
								Lookup[#,RollerSpacing],
								Null
							]
						&)/@filteredInstrumentPackets,

						ExactMatch->(
							Which[
								(* for torrey pine and incu shaker, we only want to use the container with exact footprint *)
								MatchQ[Lookup[#,Object], ObjectP[{Model[Instrument, Shaker, "id:N80DNj15vreD"], Model[Instrument, Shaker, "id:6V0npvmNnOrw"]}]],
								True,
								(* Set ExactMatch\[Rule]False if we're dealing with a sonicator, bottle roller, shaker, nutator, homogenizer or overhead stirrer. *)
								(* for genie temp shaker, we allow it to use with or without adapter. *)
								MatchQ[Lookup[#,Object],ObjectP[{Model[Instrument,Sonicator],Model[Instrument,BottleRoller],Model[Instrument,Shaker],Model[Instrument,Nutator],Model[Instrument,OverheadStirrer], Model[Instrument,Homogenizer]}]],
								False,
								(* otherwise set to True *)
								True,
								True
							]
						&)/@filteredInstrumentPackets,
						Cache->cacheBall,
						Simulation->simulation
					];

					(* Do some additional filtering. *)
					filteredContainers=Switch[type,
						Sonicate,
							(* The sonicator can only have Vessels that are 1) SelfStanding and at least as large as a 250mL vessel (to fit a self-standing sonication weight) or 2) are supported by floats. *)
							Map[
								(If[!MatchQ[#,ObjectP[Model[Container,Vessel]]],
									(* Don't allow non-vessels. *)
									Nothing,
									(* ELSE: Is our vessel self standing and large enough to fit a sonication weight? *)
									If[And[
											(* Self-standing check *)
											MatchQ[
												fastAssocLookup[fastAssoc, #, SelfStanding],
												True
											],
											(* About as large as a 250mL vessel in order to fit a sonciation weight. *)
											MatchQ[
												fastAssocLookup[fastAssoc, #, Dimensions],
												{GreaterEqualP[0.06985 Meter], GreaterEqualP[0.06985 Meter], GreaterEqualP[0.0762 Meter]}
											]
										],
										(* Allow it. *)
										#,
										(* Otherwise, is it supported by the sonication floats we have? *)
										If[MemberQ[supportedSonicationContainers,#],
											(* Allow it. *)
											#,
											(* Don't allow it. *)
											Nothing
										]
									]
								]&),
								containerResult,
								{2}
							],
						Stir,
						(* Only allow containers that have a compatible impeller or stir bar, when sampleVolume >= 20mL and  sample to container max volume ratio is no less than 40%*)
						(* Among containers fulfilling our requirements, we prefer larger ones for stir to minimum spillage *)
							ReverseSortBy[Lookup[fetchPacketFromFastAssoc[#, fastAssoc], MaxVolume]&] /@
								Map[
									(If[GreaterEqualQ[sampleVolume,20*Milliliter] &&
										GreaterEqualQ[FirstCase[
											{
												sampleVolume / Lookup[fetchPacketFromFastAssoc[#, fastAssoc], MaxVolume, Null],
												0.39
											}, NumericP
										], 0.4] &&
										Or[
											(* we can find a Impeller and the container has MaxOverheadMixRate over resolve rate *)
											And[
												Sequence @@ Map[
													Function[{overheadStirrerModel},
														!MatchQ[compatibleImpeller[#, overheadStirrerModel, Cache->cacheBall, Simulation -> simulation], Null]
													],
													Cases[Lookup[filteredInstrumentPackets, Object], ObjectP[Model[Instrument, OverheadStirrer]]]
												],
												!NullQ[Lookup[fetchPacketFromFastAssoc[#, fastAssoc], MaxOverheadMixRate, Null]],
												rate < fastAssocLookup[fastAssoc, #, MaxOverheadMixRate]
											],
											(* it can find a stir bar and we allow using stir bar*)
											And[
												MatchQ[stirBar, Except[False]],
												!MatchQ[compatibleStirBar[#,Cache->cacheBall,Simulation->simulation],Null]
											]
										],
										#,
										Nothing
									]&),
									containerResult,
									{2}
								],
						Homogenize,
							(* Only allow containers that have a mixable container. If Amplitude is over 70 Percent, the sonication horn must be the large one. *)
							Map[
								(* TODO: We only have one homogenizer now so this is okay. Will need to double map when we have multiple instrument models. *)
								Function[{container},
									(* Get the sample's volume and the container's max volume. *)
									containerModelMaxVolume = Lookup[fetchPacketFromFastAssoc[container, fastAssoc], MaxVolume, 2 Milliliter];

									(* Filter out the container if it has a volume that's within 95% of the container's max volume (with relation to the sample's volume). *)
									(* Let the container pass through if the sample doesn't have a volume (it is a solid). *)
									(* This is so that the sample doesn't get displaced out of the container. *)
									If[!(MatchQ[sampleVolume,Null]||MatchQ[sampleVolume,GreaterEqualP[.95*containerModelMaxVolume]]),
										(* We are more than 95% full in our container. Require a transfer to homogenize. *)
										Nothing,
										(* Get the best impeller for this sample and instrument. *)
										bestSonicationHorn=compatibleSonicationHorn[container,Model[Instrument,Homogenizer,"id:rea9jlRZqM7b"],Cache->cacheBall,Simulation->simulation];

										(* Were we able to find a sonication horn, if not, filter out this instrument. *)
										If[MatchQ[bestSonicationHorn,Null],
											Nothing,
											(* If we have a compatible sonication horn, make sure the container of the sample is also self-standing, or has an approved holder (2mL, 15mL, or 50mL tube). *)
											If[TrueQ[
												Or[
													Lookup[fetchPacketFromFastAssoc[container, fastAssoc], SelfStanding, False],
													MatchQ[container, ObjectP[{
														Model[Container, Vessel, "id:3em6Zv9NjjN8"],
														Model[Container, Vessel, "id:xRO9n3vk11pw"],
														Model[Container, Vessel, "id:bq9LA0dBGGR6"]
													}]]
												]],

												(* If we were given an Amplitude over 70 Percent, the sonication horn used can't be one of the small ones. *)
												If[MatchQ[amplitude,GreaterP[70 Percent]]&&!MatchQ[bestSonicationHorn,ObjectP[Model[Part, SonicationHorn, "id:WNa4ZjKzw8p4"]]],
													Nothing,

													(* If we were given a MaxTemperature, there has to be at least 1 CM of clearance between the container aperture and the sonication horn's diameter *)
													If[And[
														MatchQ[maxTemperature, TemperatureP],
														MatchQ[
															fastAssocLookup[fastAssoc, container, Aperture] - fastAssocLookup[fastAssoc, bestSonicationHorn, HornDiameter],
															LessEqualP[1 Centimeter]
														]],
														Nothing,
														container
													]
												],
												Nothing
											]
										]
									]
								],
								containerResult,
								{2}
							],
						Shake,
							(* Don't allow plates in the shakers, unless we're using hamilton compatible things. *)
							If[MatchQ[integratedLiquidHandler, True],
								containerResult,
								(Cases[#,ObjectP[Model[Container,Vessel]]]&)/@containerResult
							],
						_,
							containerResult
					];

					(* Create rules between our instruments and their respective compatible aliquot containers. *)
					containerRules=(Rule@@#)&/@Transpose[{Flatten[Lookup[filteredInstrumentPackets,Object]],filteredContainers}];

					(* Filter out the instruments that have no valid aliquot containers. *)
					Cases[containerRules,Verbatim[Rule][_,Except[{}]],{1}],
					{}
				];

				(* Return {currentlyCompatibleInstruments,containerRules}. *)
				{filteredCompatibleInstruments,containers}
			]
		]
	]/@types;

	(* Do we have to transpose? *)
	{instrumentResult,potentialAliquotContainers}=If[MatchQ[devicesAndContainersResult,{}],
		{{},{}},
		Transpose[devicesAndContainersResult]
	];

	(* Return our result. *)
	outputSpecification/.{
		Instruments -> Flatten[instrumentResult],
		Containers -> Flatten[potentialAliquotContainers]
	}
];


(* ::Subsection::Closed:: *)
(*IncubateDevices*)


DefineOptions[IncubateDevices,
	Options:>{
		{
			OptionName -> Temperature,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> GreaterP[0 Kelvin],Units :> Celsius]
			],
			Description -> "The temperature of the device that should be used to incubate the sample."
		},
		{
			OptionName->RelativeHumidity,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
				Units -> Percent
			],
			Description->"The amount of water vapor present in air that the samples will be exposed to during incubation, relative to the amount needed for saturation."
		},
		{
			OptionName->LightExposure,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> EnvironmentalChamberLightTypeP (* UVLight | VisibleLight *)
			],
			Description->"The range of wavelengths of light that the incubated samples will be exposed to. Only available when incubating the samples in an environmental chamber with UVLight and VisibleLight control."
		},
		{
			OptionName->LightExposureIntensity,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				"UV Light Intensity"->Widget[
					Type -> Quantity,
					Pattern :> RangeP[2 Watt/(Meter^2), 36 Watt/(Meter^2)],
					Units -> CompoundUnit[{1, {Watt, {Watt}}}, {-2, {Meter, {Meter}}}]
				],
				"Visible Light Intensity"-> Widget[
					Type -> Quantity,
					Pattern :> RangeP[2 Lumen/(Meter^2), 29000 Lumen/(Meter^2)],
					Units -> CompoundUnit[{1, {Lumen, {Lumen}}}, {-2, {Meter, {Meter}}}]
				]
			],
			Description->"The intensity of light that the incubated samples will be exposed to during the course of the incubation. UVLight exposure is measured in Watt/Meter^2 and Visible Light Intensity is measured in Lumen/Meter^2."
		},
		{
			OptionName -> ProgrammableTemperatureControl,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates that the mixer supports the specification of a temperature profile."
		},
		{
			OptionName -> IntegratedLiquidHandler,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if only devices that are integrated with a liquid handler should be returned."
		},
		CacheOption,
		SimulationOption
	}
];

IncubateDevices[myContainer:ObjectReferenceP[Model[Container]], mySampleVolume:VolumeP, myOptions:OptionsPattern[]]:=Module[
	{samplePacket, containerPacket},

	(* Simulate our sample and container. *)
	{{samplePacket}, containerPacket}=SimulateSample[
		{Model[Sample, "Milli-Q water"]},
		"after Simulation",
		{"A1"},
		myContainer,
		{Volume -> mySampleVolume}
	];

	(* Fake a sample to pass into the main function. *)
	IncubateDevices[
		samplePacket,
		Append[ToList[myOptions], Cache->{samplePacket, containerPacket}]
	]
];

integratedIncubateInstrumentsSearch[fakeString_]:=integratedIncubateInstrumentsSearch[fakeString]=Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`integratedIncubateInstrumentsSearch],
		AppendTo[$Memoization, Experiment`Private`integratedIncubateInstrumentsSearch]
	];

	Search[Model[Instrument,HeatBlock],IntegratedLiquidHandlers!=Null && Deprecated==(False|Null) && DeveloperObject != True]
];

nonIntegratedIncubateInstrumentsSearch[fakeString_]:=nonIntegratedIncubateInstrumentsSearch[fakeString]=Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`nonIntegratedIncubateInstrumentsSearch],
		AppendTo[$Memoization, Experiment`Private`nonIntegratedIncubateInstrumentsSearch]
	];

	Search[
		{Model[Instrument,HeatBlock], Model[Instrument, EnvironmentalChamber]},
		IntegratedLiquidHandlers==Null && Deprecated==(False|Null) && DeveloperObject != True
	]
];

IncubateDevices[mySample:NonSelfContainedSampleP,myOptions:OptionsPattern[IncubateDevices]]:=Module[
	{safeOptions,temperature,cache,simulation,instrumentModels,containerModelPackets,containerModelPacket,incubatorPackets,
	filteredTemperatureIncubatorPackets,containerDimensions,incubatorPacketsInRange,programmableTemperatureControl,
	integratedLiquidHandler,relativeHumidity,lightExposure,lightExposureIntensity,filteredHumidityIncubatorPackets,
	filteredLightExposureIncubatorPackets,filteredLightExposureIntensityIncubatorPackets},

	(* Get the safe options of our function. *)
	safeOptions=SafeOptions[IncubateDevices,ToList[myOptions]];

	(* Get the temperature passed by our options. *)
	temperature=Lookup[safeOptions,Temperature];
	relativeHumidity=Lookup[safeOptions,RelativeHumidity];
	lightExposure=Lookup[safeOptions,LightExposure];
	lightExposureIntensity=Lookup[safeOptions,LightExposureIntensity];
	programmableTemperatureControl=Lookup[safeOptions,ProgrammableTemperatureControl];
	integratedLiquidHandler=Lookup[safeOptions,IntegratedLiquidHandler];

	(* If we we need programmable temperature control, we can only return the ATC thermocycler. *)
	(* Otherwise, we will go and do a search for compatible heat blocks. *)
	If[MatchQ[programmableTemperatureControl,True],
		If[MatchQ[temperature, Null|RangeP[4 Celsius, 105 Celsius]],
			Return[{Download[Model[Instrument, Thermocycler, "Automated Thermal Cycler"], Object]}],
			Return[{}]
		]
	];

	(* Get the cache passed by our options. *)
	cache=Lookup[safeOptions,Cache];
	simulation=Lookup[safeOptions,Simulation];

	(* Get all of the non-deprecated heat blocks. *)
	instrumentModels=If[MatchQ[integratedLiquidHandler, True],
		integratedIncubateInstrumentsSearch["Memoization"],
		nonIntegratedIncubateInstrumentsSearch["Memoization"]
	];


	(* Download the information that we need about the sample. *)
	{{containerModelPackets,incubatorPackets}}=Quiet[Flatten[Download[
		{
			{mySample},
			instrumentModels
		},
		{
			{Packet[Container[Model][{Dimensions,Footprint}]]},
			{Packet[InternalDimensions,MinTemperature,MaxTemperature,EnvironmentalControls,MinHumidity,MaxHumidity,MinUVLightIntensity,MaxUVLightIntensity,MinVisibleLightIntensity,MaxVisibleLightIntensity]}
		},
		Cache->cache,
		Simulation->simulation
	],{3}],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* We only have one container model packet. *)
	containerModelPacket=First[containerModelPackets];

	(* If IntegratedLiquidHandler -> True, we can ONLY incubate containers with footprint Plate or MALDIPlate *)
	(* If our container does not have either of these footprints, return early *)
	If[
		And[
			TrueQ[integratedLiquidHandler],
			MatchQ[Lookup[containerModelPacket,Footprint,Null],Except[$IncubateLiquidHandlerFootprints]]
		],
		Return[{}]
	];

	(* First, filter out our incubator packets by temperature, if one is specified. *)
	filteredTemperatureIncubatorPackets=If[!MatchQ[temperature,Null],
		(* Temperature specification given. Filter our incubators. *)
		Select[incubatorPackets,RangeQ[temperature,Lookup[#,{MinTemperature,MaxTemperature}]]&],
		incubatorPackets
	];

	(* Next, filter out our incubator packets by relative humidity, if one is specified. *)
	filteredHumidityIncubatorPackets=If[!MatchQ[relativeHumidity,Null],
		Cases[
			filteredTemperatureIncubatorPackets,
			KeyValuePattern[{
				MinHumidity->LessEqualP[relativeHumidity],
				MaxHumidity->GreaterEqualP[relativeHumidity]
			}]
		],
		filteredTemperatureIncubatorPackets
	];

	(* Next, filter out our incubator packets by light exposure, if one is specified. *)
	filteredLightExposureIncubatorPackets=If[!MatchQ[lightExposure,Null],
		Cases[
			filteredHumidityIncubatorPackets,
			KeyValuePattern[{
				EnvironmentalControls->{___, lightExposure, ___}
			}]
		],
		filteredHumidityIncubatorPackets
	];

	(* Next, filter out our incubator packets by light exposure intensity, if one is specified. *)
	filteredLightExposureIntensityIncubatorPackets=Which[
		MatchQ[lightExposureIntensity,GreaterP[0 Watt/(Meter^2)]],
			Cases[
				filteredLightExposureIncubatorPackets,
				KeyValuePattern[{
					MinUVLightIntensity->LessEqualP[lightExposureIntensity],
					MaxUVLightIntensity->GreaterEqualP[lightExposureIntensity]
				}]
			],
		MatchQ[lightExposureIntensity,GreaterP[0 Lumen/(Meter^2)]],
			Cases[
				filteredLightExposureIncubatorPackets,
				KeyValuePattern[{
					MinVisibleLightIntensity->LessEqualP[lightExposureIntensity],
					MaxVisibleLightIntensity->GreaterEqualP[lightExposureIntensity]
				}]
			],
		True,
			filteredLightExposureIncubatorPackets
	];

	(* Next, filter out our incubator packets by dimensions. *)
	(* Lookup the dimensions of the container *)
	(* If there is no container (discarded sample), use 0 meter as dimensions so we allow any device *)
	containerDimensions = Lookup[containerModelPacket/.{Null-><||>},Dimensions,{0Meter,0Meter,0Meter}];

	(* Get the incubators large enough to hold the container *)
	incubatorPacketsInRange = Map[
		Function[incubatorPacket,
			Module[{allowedPermutations,incubatorDimensions,fitBooleans},

			(* Plates can be oriented in the incubator in x-y-z or y-x-z. Vessels can be placed in any directions *)
				allowedPermutations = If[MatchQ[containerModelPacket,PacketP[Model[Container,Plate]]],
					{containerDimensions,containerDimensions[[{2,1,3}]]},
					Permutations[containerDimensions]
				];

				(* Get the dimensions of the incubator *)
				incubatorDimensions = Lookup[incubatorPacket,InternalDimensions];

				(* For each container orientation, check if all its dimensions are less than the dimensions of the incubator *)
				fitBooleans=And@@MapThread[LessEqual,{#,incubatorDimensions}]&/@allowedPermutations;

				(* If the container can fit in at least one orientation, return the incubator *)
				If[Or@@fitBooleans,
					incubatorPacket,
					Nothing
				]
			]
		],
		filteredLightExposureIntensityIncubatorPackets
	];

	(* Return our filtered incubators. *)
	Lookup[incubatorPacketsInRange,Object,{}]
];


(* ::Subsection::Closed:: *)
(*ExperimentMix Overload*)


ExperimentMix[x___, myOptions:OptionsPattern[]]:=ExperimentIncubate[x, Append[ToList[myOptions], ExperimentFunction->ExperimentMix]];


(* ::Subsection::Closed:: *)
(*resolveIncubateMethod*)
DefineOptions[resolveIncubateMethod,
	SharedOptions:>{
		ExperimentIncubate,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];


(* TODO: NOTE: If changes are made to this method resolver please check if they impact the MagneticBeadSeparation method resolver!!! *)
(* MBS uses most of the incubate/mix options and therefore had to copy some of the logic from this method resolver *)
(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveIncubateMethod[myContainers:ListableP[Automatic|ObjectP[{Object[Container],Object[Sample]}]|{LocationPositionP,ObjectP[Object[Container]]}], myOptions:OptionsPattern[]]:=Module[
	{
		safeOptions,outputSpecification,output,gatherTests,containers,samples,containerPackets, samplePackets,mySamplePackets,
		allPackets,allModelContainerPackets,allModelContainerPlatePackets,liquidHandlerIncompatibleContainers,
		experimentFunction,specifiedTemperatures,specifiedAnnealingTimes,specifiedResidualIncubations,
		specifiedResidualTemperatures,indexMatchingIncubateBools, liquidHandlerIncubationIncompatibleContainerFootprints,
		indexMatchingLiquidHandlerAdapterIncubateCompatibleBool, manualRequirementStrings, roboticRequirementStrings, result,tests,
		indexMatchingModelContainerFootprints, indexMatchingModelContainerPackets,indexMatchingLiquidHandlerAdapterPackets
	},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveIncubateMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Download information that we need from our inputs and/or options. *)
	containers=Map[
		Which[
			(* Remove the sample *)
			MatchQ[#,ObjectP[Object[Sample]]],Null,
			(* Extract the container if we have a position + container. Incubate method resolution only cares about container. *)
			MatchQ[#,{LocationPositionP,ObjectP[Object[Container]]}],#[[2]],
			(* Remove Automatic *)
			MatchQ[#,Automatic],Nothing,
			(* Otherwise just keep the container *)
			True,#
		]&,
		ToList[myContainers]
	];
	samples=Map[
		Which[
			(* Keep the sample only *)
			MatchQ[#,ObjectP[Object[Sample]]],#,
			(* Remove Automatic *)
			MatchQ[#,Automatic],Nothing,
			(* Otherwise Null it *)
			True,Null
		]&,
		ToList[myContainers]
	];
	{containerPackets, samplePackets}=Quiet[
		Download[
			(* Note that we change Automatic to Nothing here because we may be called from Command Builder. In CB, we don't do simulation and we get inputs as Automatic. We can skip all later checks and no need trying to download here. *)
			{
				containers,
				samples
			},
			{
				{Packet[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]], Packet[Name, Model, Contents], Packet[Contents[[All,2]][{Name, LiquidHandlerIncompatible, Container, Position}]], Packet[Model[LiquidHandlerAdapter[{Footprint,ContainerMaterials}]]]},
				{Packet[Name, LiquidHandlerIncompatible, Container, Position], Packet[Container[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]], Packet[Container[Model[LiquidHandlerAdapter[{Footprint,ContainerMaterials}]]]]}
			},
			Cache->Lookup[ToList[myOptions], Cache, {}],
			Simulation->Lookup[ToList[myOptions], Simulation, Null]
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* separate out the sample packet *)
	mySamplePackets=Map[
		If[NullQ[#],
			<||>,
			#[[1]]
		]&,
		samplePackets
	];

	(* Join all packets. *)
	allPackets=Cases[Flatten[{containerPackets, samplePackets}], PacketP[]];

	(* Get all of our Model[Container]s and look at their footprints. *)
	(* NOTE: This is index matching to our inputs. *)
	indexMatchingModelContainerPackets=MapThread[
		Which[
			(* Container input *)
			!NullQ[#1]&&MatchQ[#1[[1]],PacketP[Model[Container]]],
			#1[[1]],
			(* Sample input *)
			!NullQ[#2]&&MatchQ[#2[[2]],PacketP[Model[Container]]],
			#2[[2]],
			True,
			Null
		]&,
		{containerPackets, samplePackets}
	];
	(* For containers with liquid handler adapters, consider the footprint of the liquid handler adapter instead *)
	indexMatchingLiquidHandlerAdapterPackets=MapThread[
		Which[
			(* Container input *)
			!NullQ[#1]&&MatchQ[#1[[-1]],PacketP[Model[Container]]],
			#1[[-1]],
			(* Sample input *)
			!NullQ[#2]&&MatchQ[#2[[-1]],PacketP[Model[Container]]],
			#2[[-1]],
			True,
			Null
		]&,
		{containerPackets, samplePackets}
	];
	indexMatchingModelContainerFootprints=MapThread[
		Which[
			MatchQ[#2, PacketP[]], Lookup[#2, Footprint, Null],
			MatchQ[#1, PacketP[]], Lookup[#1, Footprint, Null],
			True, Null
		]&,
		{indexMatchingModelContainerPackets,indexMatchingLiquidHandlerAdapterPackets}
	];

	allModelContainerPackets=Cases[indexMatchingModelContainerPackets, PacketP[]];
	allModelContainerPlatePackets=Cases[allModelContainerPackets,PacketP[Model[Container,Plate]]];

	(* Get the containers that are liquid handler incompatible *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[
		Join[
			Lookup[Cases[allModelContainerPackets,KeyValuePattern[Footprint->Except[LiquidHandlerCompatibleFootprintP]]],Object,{}],
			Lookup[Cases[allModelContainerPlatePackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
		]
	];

	(* Get the experiment function that was called *)
	experimentFunction = Lookup[safeOptions,ExperimentFunction];

	(* Get the temperature, annealing time, and residual incubation options. Also make sure that these lists of options are the *)
	(* same length, in case any get passed in as singletons rather than lists of the correct length. *)
	{
		specifiedTemperatures,
		specifiedAnnealingTimes,
		specifiedResidualIncubations,
		specifiedResidualTemperatures
	} = Module[
		{temps, annealingTimes, resIncubations, resTemps, inputsLength},
		(* Get the values from safe options. *)
		{temps, annealingTimes, resIncubations, resTemps} = ToList /@ Lookup[
			safeOptions,
			{Temperature, AnnealingTime, ResidualIncubation, ResidualTemperature}
		];
		(* Find the length from inputs. Our option length should match input. *)
		inputsLength = Length[samplePackets];
		(* If any of these options have the wrong length, pad them out so the MapThread below doesn't fail. *)
		(* This also applies when the input is Automatic (from JSON handling in command builder) *)
		If[!MatchQ[Length[#], inputsLength] && MatchQ[Length[#], 1],
			ConstantArray[First[#], inputsLength],
			#
		] & /@ {temps, annealingTimes, resIncubations, resTemps}
	];

	(* Get the containers that are non liquid handler incubation compatible *)
	(* Currently, we can only incubate SBS plates on the liquid handlers *)
	indexMatchingIncubateBools = MapThread[
		Function[{temperature,annealingTime,residualIncubation,residualTemperature},
			(* If Temperature or AnnealingTime is specified, we are incubating *)
			Or[
				MatchQ[temperature,Except[Automatic|Ambient|Null]],
				MatchQ[annealingTime,Except[Automatic|Null]],
				MatchQ[residualIncubation,Except[Automatic|False|Null]],
				MatchQ[residualTemperature,Except[Automatic|Ambient|Null]]
			]
		],
		{
			specifiedTemperatures,
			specifiedAnnealingTimes,
			specifiedResidualIncubations,
			specifiedResidualTemperatures
		}
	];

	liquidHandlerIncubationIncompatibleContainerFootprints = DeleteCases[DeleteDuplicates[PickList[indexMatchingModelContainerFootprints,indexMatchingIncubateBools]],$IncubateLiquidHandlerFootprints];

	(* Check if the container's liquid handler adapters can be incubated. To make sure the rack can be used as heating/cooling adapters, they must be Metal material. *)
	indexMatchingLiquidHandlerAdapterIncubateCompatibleBool = MapThread[
		Which[
			(* Incubate not required, set to True (compatible) *)
			!TrueQ[#2],True,
			(* No adapter, set to True (compatible) *)
			!MatchQ[#1, PacketP[]],True,
			(* Check if adapter is metal *)
			True, MatchQ[Lookup[#1,ContainerMaterials],ListableP[MetalP]]
		]&,
		{indexMatchingLiquidHandlerAdapterPackets,indexMatchingIncubateBools}
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the sample containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible",
			Nothing
		],
		If[MemberQ[ToList[Lookup[ToList[myOptions], MixType, {}]], Except[Automatic|Pipette|Shake]],
			"the MixType(s) "<>ToString[Cases[ToList[Lookup[ToList[myOptions], MixType, {}]], Except[Automatic|Pipette|Shake]]]<>" can only be performed manually",
			Nothing
		],
		If[!MatchQ[indexMatchingModelContainerFootprints,{}]&&!MatchQ[Lookup[ToList[myOptions], MixType, {}],{}]&&MemberQ[Transpose[{indexMatchingModelContainerFootprints, Lookup[ToList[myOptions], MixType, {}]}], {Except[Plate], Shake}],
			"the source/destination container footprints "<>ToString[Cases[Transpose[{indexMatchingModelContainerFootprints, Lookup[ToList[myOptions], MixType]}], {Except[Plate], Shake}][[All,1]]]<>" are not compatible with liquid handler Shake mixing (only plates and vessels with plate adapters are allowed)",
			Nothing
		],
		If[!MatchQ[liquidHandlerIncubationIncompatibleContainerFootprints,{}],
			"the sample container footprint(s) " <> ToString[liquidHandlerIncubationIncompatibleContainerFootprints] <> " are not compatible with liquid handler incubation (only plates and vessels with plate adapters are allowed)",
			Nothing
		],
		Module[{manualInstrumentTypes},
			manualInstrumentTypes=Cases[Join[MixInstrumentModels,MixInstrumentObjects], Except[Model[Instrument, HeatBlock]|Object[Instrument, HeatBlock]|Model[Instrument, Shaker]|Object[Instrument, Shaker]]];

			If[MemberQ[ToList[Lookup[ToList[myOptions], Instrument, {}]], ObjectP[manualInstrumentTypes]],
				"the Instrument(s) "<>ToString[Cases[ToList[Lookup[ToList[myOptions], Instrument, {}]], ObjectP[manualInstrumentTypes]]]<>" can only be used manually",
				Nothing
			]
		],
		If[MemberQ[indexMatchingLiquidHandlerAdapterIncubateCompatibleBool,False],
			"the sample containers' liquid handler adapter racks "<>ObjectToString/@(Lookup[PickList[indexMatchingLiquidHandlerAdapterPackets,indexMatchingLiquidHandlerAdapterIncubateCompatibleBool,False], Object, {}])<>" are not made of metal in order to be incubated robotically so the sample containers can only be incubated manually",
			Nothing
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[
				{
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
					AnnealingTime,
					RelativeHumidity,
					LightExposure,
					LightExposureIntensity,
					LightExposureStandard
				},
				(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic]|{}]&)];

			If[Length[manualOnlyOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		If[MemberQ[Lookup[mySamplePackets, LiquidHandlerIncompatible], True],
			"the following samples are liquid handler incompatible "<>ObjectToString[Lookup[Cases[mySamplePackets, KeyValuePattern[LiquidHandlerIncompatible->True]], Object], Cache->allPackets],
			Nothing
		],
		(* NOTE: There is no incubate prep option for ExperimentIncubate. *)
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, PreparatoryUnitOperations], Except[Null]],
			"the PreparatoryUnitOperations option is set (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		Module[{roboticOnlyOptions},
			roboticOnlyOptions=Select[{
				MixFlowRate,MixPosition,MixPositionOffset,MixTiltAngle,CorrectionCurve,MultichannelMix,MultichannelMixName,DeviceChannel,
				ResidualTemperature,ResidualMix,ResidualMixRate,Preheat},(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic]]&)];

			If[Length[roboticOnlyOptions]>0,
				"the following Robotic-only options were specified "<>ToString[roboticOnlyOptions],
				Nothing
			]
		],
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
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
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
		Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings]>0,
		Manual,
		Length[roboticRequirementStrings]>0,
		Robotic,
		True,
		{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentIncubateWorkCell*)


resolveExperimentIncubateWorkCell[
	myListedSamples:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[resolveExperimentIncubateWorkCell]
] := Module[{cache, simulation, workCell, preparation},

	{cache, simulation, workCell, preparation} = Lookup[myOptions, {Cache, Simulation, WorkCell, Preparation}];

	(* Determine the WorkCell that can be used: *)
	Which[
		MatchQ[workCell, WorkCellP|Null],
			{workCell}/.{Null} -> {},
		(* The ThermoshakeAC and Inheco Incubator Shaker DWP are only available on the bioSTAR/microbioSTAR. *)
		MemberQ[Lookup[myOptions, Instrument, {}], ObjectP[{Model[Instrument, Shaker, "id:pZx9jox97qNp"], Model[Instrument, Shaker, "id:eGakldJkWVnz"]}]],
			{bioSTAR, microbioSTAR},
		(* The Heater Shaker is only available on the STAR. *)
		MemberQ[Lookup[myOptions, Instrument, {}], ObjectP[Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"]]],
			{STAR},
		(* Otherwise, use helper function to resolve potential work cells based on experiment options and sample properties *)
		True,
			resolvePotentialWorkCells[myListedSamples, {Preparation -> preparation}, Cache -> cache, Simulation -> simulation]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentMixWorkCell*)


resolveExperimentMixWorkCell[
	myListedSamples:ListableP[ObjectP[{Object[Sample], Object[Container]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],
	myOptions:OptionsPattern[resolveExperimentMixWorkCell]
]:=resolveExperimentIncubateWorkCell[myListedSamples, myOptions];

(* ::Subsection::Closed:: *)
(*TransportDevices*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[TransportDevices,
	Options:>{
		{
			OptionName -> Volume,
			AllowNull -> False,
			Default->Automatic,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[0Microliter,$MaxTransferVolume],
				Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
			],
			Description -> "Indicates the volume of sample to be transported."
		},
		{
			OptionName -> SetTemperature,
			AllowNull -> True,
			Default->Null,
			Widget -> Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Kelvin], Units-> Celsius | Kelvin ],
			Description -> "Indicates the desired temperature at which to transport the sample."
		},
		{
			OptionName -> Container,
			AllowNull -> False,
			Default->Automatic,
			Widget -> Widget[Type->Object,Pattern:>ObjectP[Model[Container]],ObjectTypes->{Model[Container]}],
			Description -> "Indicates the container in which the input model sample will be."
		},
		CacheOption,
		SimulationOption
	}
];


(* ::Subsubsection::Closed:: *)
(*Main Function*)


(* Overload that takes in a model sample. *)
TransportDevices[myModelSample:ObjectReferenceP[Model[Sample]], myOptions:OptionsPattern[]]:=Module[
	{transportCondition, finalTransportCondition},

	(* Get myModelSample's TransportCondition *)
	transportCondition = Download[myModelSample,TransportCondition];
	finalTransportCondition=If[NullQ[transportCondition],
		(* if transportCondition is Null, default to Model[Container, LightBox, "Opaque Transport Box"] *)
		Ambient,
		transportCondition
	];

	(* Pass myModelSample and transportCondition into one of the main overloads *)
	TransportDevices[
		myModelSample,
		Ambient,
		ToList[myOptions]
	]
];

(* Overload that takes in a object sample. *)
TransportDevices[myObjectSample:ObjectReferenceP[Object[Sample]], myOptions:OptionsPattern[]]:=Module[
	{transportCondition, finalTransportCondition},

	(* Get myModelSample's TransportCondition *)
	transportCondition = Download[myObjectSample,TransportCondition];
	finalTransportCondition=If[NullQ[transportCondition],
		(* if transportCondition is Null, default to Model[Container, LightBox, "Opaque Transport Box"] *)
		Ambient,
		transportCondition
	];

	(* Pass myModelSample and transportCondition into one of the main overloads *)
	TransportDevices[
		myObjectSample,
		Ambient
	]
];

Warning::NoVolumeSpecified = "The Volume option must be specified because the input is a Model[Sample]. Automatically set to 2 Milliliter.";
Error::IncompatibleDimensions = "The dimensions of the found container cannot fit into the found transport instrument `1`, please adjust the specified Volume or transport condition.";
Error::IncompatibleTemperatures = "The temperature of the input model sample is not compatible with the found transport instrument `1`, please adjust the sample's DefaultStorageCondition.";
Error::FlammableOrPyrophoric = "The input sample is being asked to be transported in an OvenDried instrument, but the sample is either flammable or pyrophoric.";
Error::TemperatureOutOfRange = "The given SetTemperature, `1`, is out of the instrument's, `2`, corresponding to the given TransportCondition's temperature range. Please consider changing the SetTemperature or TransportCondition.";
Error::HeatedFlammable = "The input sample, `1`, is being asked to be transported at a temperature above its flashpoint. Please consider changing the SetTemperature option or given TransportCondition.";
Warning::FrozenSampleThawTemperature = "The input sample, `1`, has a storage condition of either frozen or cryogenic, and needs to be transported at its ThawTemperature. The given TransportCondition's instruments cannot reach the input sample's ThawTemperature.";


(* First overload where TransportDevices just takes in a TransportCondition *)
TransportDevices[myTransportCondition:(ObjectReferenceP[Model[TransportCondition]]|TransportConditionP), myOptions:OptionsPattern[]]:=Module[{listedOptions,safeOps,myTC},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Get the safe options of our function. *)
	safeOps=SafeOptions[TransportDevices,listedOptions,AutoCorrect->False];

	myTC = Download[myTransportCondition,Name];

	(* Match the TransportCondition with corresponding instruments *)
	Which[
		MatchQ[myTC,"LightBox"],
		Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

		MatchQ[myTC,"OvenDried"],
		Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],

		MatchQ[myTC,"Chilled"],
		Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],

		MatchQ[myTC,"Minus 40"],
		Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],

		MatchQ[myTC,"Minus 80"],
		Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]
	]
];

(* Main overload with Model[Sample] *)
TransportDevices[myModelSample:ObjectReferenceP[Model[Sample]], myTransportCondition:(ObjectReferenceP[Model[TransportCondition]]|TransportConditionP), myOptions:OptionsPattern[]]:=Module[
	{listedOptions,safeOps,volumeToTransfer,preferredTransferContainer,matchingInstrument,
		dimensionsNotFlat,storageConditionNotFlat,transportPositionsAndDimensionsNotFlat,
		allPositionDimensions,allPositionDimensionsNoWarmed,warmedPositionDimensions,defaultStorageTemperature,transportTempLookup,
		maxContainerTemperature,minContainerTemperature,flammable,pyrophoric,inputContainer,
		instrumentToTransportFrozenSample,currentStorageConditionName,thawTemp,setTemp, cleanedTransportCondition},

	(* if TransportCondition is Ambient, return Null, no need for a transport device *)
	(* Code of this function relies on the named object form of Model[TransportCondition] to function *)
	(* TODO should fix that properly but now put a patch here *)
	cleanedTransportCondition = NamedObject[myTransportCondition];
	If[MatchQ[cleanedTransportCondition,Ambient],
		Return[Null]
	];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Get the safe options of our function. *)
	safeOps=SafeOptions[TransportDevices,listedOptions,AutoCorrect->False];

	(* Get the Volume option from safeOps *)
	volumeToTransfer = Lookup[safeOps,Volume];
	inputContainer = Lookup[safeOps,Container];

	(* Get the SetTemperature option from safeOps *)
	setTemp = Lookup[safeOps,SetTemperature];

	(* If volumeToTransfer is Automatic, return an error saying Volume must be filled because input is a Model[Sample] and return early *)
	If[MatchQ[volumeToTransfer,Automatic],
		Message[Warning::NoVolumeSpecified];
		volumeToTransfer = 2Milliliter
	];

	preferredTransferContainer = If[MatchQ[inputContainer,Automatic],
		PreferredContainer[volumeToTransfer],
		inputContainer
	];

	(* get dimensions of the preferredTransferContainer and the other possible portable containers, and then the storage conditions and positions of the remaining *)
	{
		dimensionsNotFlat,
		storageConditionNotFlat,
		transportPositionsAndDimensionsNotFlat
	} = Download[
		{
			{preferredTransferContainer},
			{myModelSample},
			{
				(*lightbox/Ambient*)
				Model[Container, LightBox, "id:Z1lqpMzDbjlz"],
				(*Minus40*)
				Model[Instrument, PortableCooler, "id:R8e1PjpjnEPK"],
				(*Minus80*)
				Model[Instrument, PortableCooler, "id:o1k9jAGAEpjr"],
				(*Chilled*)
				Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"],
				(*Warmed*)
				Model[Instrument, PortableHeater, "id:3em6ZvLv7bZv"]
			}
		},
		{
			{
				Dimensions,
				MinTemperature,
				MaxTemperature
			},
			{
				DefaultStorageCondition[Name],
				Flammable,
				Pyrophoric,
				ThawTemperature
			},
			{
				Dimensions,
				Positions,
				MinTemperature,
				MaxTemperature
			}
		}];

	(* Extract the dimensions of each transport instrument, except for Warmed, based on positions and height of dimensions if applicable *)
	allPositionDimensionsNoWarmed = Map[
		Function[{trasportContainerInformation},
			Module[{containerDimensions,containerPositions,positionWidth,positionDepth,positionHeight,finalPositionHeight},
				containerDimensions = trasportContainerInformation[[1]];
				containerPositions = trasportContainerInformation[[2]];
				{positionWidth,positionDepth,positionHeight} = Flatten[Lookup[containerPositions,{MaxWidth,MaxDepth,MaxHeight}]];
				finalPositionHeight = If[NullQ[positionHeight],containerDimensions[[3]],positionHeight];
				{positionWidth,positionDepth,finalPositionHeight}
			]
		],Most[transportPositionsAndDimensionsNotFlat]
	];

	warmedPositionDimensions = Lookup[transportPositionsAndDimensionsNotFlat[[-1]][[2]],{MaxWidth,MaxDepth,MaxHeight}];

	allPositionDimensions = Join[allPositionDimensionsNoWarmed,warmedPositionDimensions];

	(* the storage temperature of the input model sample *)
	maxContainerTemperature = dimensionsNotFlat[[1]][[3]];
	minContainerTemperature = dimensionsNotFlat[[1]][[2]];
	flammable = storageConditionNotFlat[[1]][[2]];
	pyrophoric = storageConditionNotFlat[[1]][[3]];
	currentStorageConditionName = storageConditionNotFlat[[1]][[1]];
	thawTemp = storageConditionNotFlat[[1]][[4]];

	(* construct transport instrument to min temp/max temp lookup *)
	transportTempLookup = AssociationThread[
		{"LightBox","Minus 40","Minus 80","Chilled","OvenDried"}
			->{
			{transportPositionsAndDimensionsNotFlat[[1]][[3]],transportPositionsAndDimensionsNotFlat[[1]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[2]][[3]],transportPositionsAndDimensionsNotFlat[[2]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[3]][[3]],transportPositionsAndDimensionsNotFlat[[3]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[4]][[3]],transportPositionsAndDimensionsNotFlat[[4]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[5]][[3]],transportPositionsAndDimensionsNotFlat[[5]][[4]]}
		}];

	(* check if currentStorageConditionName has Freezer or Cryo in it *)
	instrumentToTransportFrozenSample = Which[(StringContainsQ[currentStorageConditionName,"Freezer"] || StringContainsQ[currentStorageConditionName,"Cryo"]) && !NullQ[thawTemp],
		(* if it does, want to transport it at Thawed temp, so check whether thawTemp is in range of given TransportCondition's instrument *)
		Module[{chosenTransportInstrument,transportConditionName,instrumentMinTemp,instrumentMaxTemp},
			chosenTransportInstrument=Which[

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"LightBox"]],
				Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"OvenDried"]],
				Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"Chilled"]],
				Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 40"]],
				Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 80"]],
				Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]
			];

			transportConditionName = cleanedTransportCondition[Name];

			instrumentMinTemp = Lookup[transportTempLookup,transportConditionName][[1]];

			instrumentMaxTemp = Lookup[transportTempLookup,transportConditionName][[2]];

			(* if it is in range, thenn return the instrument *)
			If[thawTemp >= instrumentMinTemp && thawTemp <= instrumentMaxTemp,
				(* if it is in range, do footprint check *)
				If[CompatibleFootprintQ[chosenTransportInstrument,preferredTransferContainer,ExactMatch->False],
					chosenTransportInstrument,
					(*if the footprint check does not pass, return incompatible dims error*)
					Message[Error::IncompatibleTemperatures,ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]]
				],
				(* if not in temperature range, then return the instrument whose range has the thawTemp and throw a warning *)
				Message[Warning::FrozenSampleThawTemperature,ObjectToString[chosenTransportInstrument]];
				chosenTransportInstrument
			]
		],
		(* check if thawTemp is Null and Freezer/cryo is still storage condition, return the LightBox instrument *)
		NullQ[thawTemp] && (StringContainsQ[currentStorageConditionName,"Freezer"] || StringContainsQ[currentStorageConditionName,"Cryo"]),
		Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

		(* otherwise, return Null*)
		True,
		Null

		];

	(* if this particular case occurred, return the instrument *)
	If[!NullQ[instrumentToTransportFrozenSample],
		Return[instrumentToTransportFrozenSample]
	];

	(* Since Volume is specified at this point, find the matching instrument with the transport condition and then see if dimensions of chosen container can fit *)
	matchingInstrument=Which[
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"LightBox"]],
		(* input transportCondition is lightbox *)
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Container,LightBox,"id:Z1lqpMzDbjlz"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures of the container are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"LightBox"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"LightBox"][[2]],
				(*If temperatures of the container are in range, then check if setTemp isn't null and if it isn't, make sure it's in instrument temperature range *)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"LightBox"][[1]] && setTemp <= Lookup[transportTempLookup,"LightBox"][[2]]),
					Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"LightBox"][[1]] && setTemp <= Lookup[transportTempLookup,"LightBox"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Container,LightBox,"id:Z1lqpMzDbjlz"]
				],
				(*If container temps are not in range, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]]
			],
			(* else: If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]]
		],

		(* input transportCondition is Warmed *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"OvenDried"]],
		(* check if sample is flammable or pyrophoric *)
		If[flammable || pyrophoric,
			(* if it is, throw an error, as it's not supposed to be OvenDried *)
			Message[Error::FlammableOrPyrophoric],
			(* if not, check if Dimensions fit *)
			If[CompatibleFootprintQ[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],preferredTransferContainer,ExactMatch->False],
				(*If they do, check if the temperatures are in range*)
				If[minContainerTemperature<=Lookup[transportTempLookup,"OvenDried"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"OvenDried"][[2]],
					(*If temperature is in range, return the portable heater*)
					Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"OvenDried"][[1]] && setTemp <= Lookup[transportTempLookup,"OvenDried"][[2]]),
						Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],

						(* check if setTemp isnt Null and if it's not in range, throw an error *)
						!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"OvenDried"][[1]] && setTemp <= Lookup[transportTempLookup,"OvenDried"][[2]]),
						Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]]}],

						(* if setTemp is Null / any other case, just return the LightBox *)
						True,
						Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]
					],
					(*If not, throw an error*)
					Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]]]
				],
				(*If dimensions don't fit, return error*)
				Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]]]
			]
		],

		(* input transportCondition is Chilled *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"Chilled"]],
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"Chilled"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"Chilled"][[2]],
				(*If temperature is in range, return the portable heater*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"Chilled"][[1]] && setTemp <= Lookup[transportTempLookup,"Chilled"][[2]]),
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"Chilled"][[1]] && setTemp <= Lookup[transportTempLookup,"Chilled"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]]]
			],
			(*If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]]]
		],

		(* input transportCondition is Minus40 *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 40"]],
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"Minus 40"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"Minus 40"][[2]],
				(*If temperature is in range, return the portable heater*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"Minus 40"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 40"][[2]]),
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"Minus 40"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 40"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]]]
			],
			(*If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]]]
		],

		(* input transportCondition is Minus80 *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 80"]],
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"Minus 80"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"Minus 80"][[2]],
				(*If temperature is in range, return the portable heater*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"Minus 80"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 80"][[2]]),
					Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"Minus 80"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 80"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]]]
			],
			(*If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]]]
		],

		True,
		Null
	];

	If[MatchQ[matchingInstrument,ObjectP[{Model[Instrument],Model[Container]}]],
		matchingInstrument,
		matchingInstrument;
		$Failed
	]


];

(* Main overload with Object[Sample] *)
TransportDevices[myObjectSample:ObjectReferenceP[Object[Sample]], myTransportCondition:ObjectReferenceP[Model[TransportCondition]], myOptions:OptionsPattern[]]:=Module[
	{listedOptions,safeOps,volumeToTransfer,preferredTransferContainer,matchingInstrument,
		dimensionsNotFlat,storageConditionNotFlat,transportPositionsAndDimensionsNotFlat,
		allPositionDimensions,allPositionDimensionsNoWarmed,warmedPositionDimensions,defaultStorageTemperature,transportTempLookup,
		containerToTransfer,maxContainerTemperature,minContainerTemperature,flammable,pyrophoric,
		currentStorageConditionName,thawTemp,instrumentToTransportFrozenSample,setTemp, cleanedTransportCondition},

	cleanedTransportCondition = NamedObject[myTransportCondition];
	(* if TransportCondition is Ambient, return Null, no need for a transport device *)
	If[MatchQ[cleanedTransportCondition[Name],"Ambient"],
		Return[Null]
	];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Get the safe options of our function. *)
	safeOps=SafeOptions[TransportDevices,listedOptions,AutoCorrect->False];

	(* Get the Container from myObjectSample *)
	preferredTransferContainer = RemoveLinkID[Download[myObjectSample,Container[Model]]];

	(* Get the SetTemperature option from safeOps *)
	setTemp = Lookup[safeOps,SetTemperature];

	(* get dimensions of the preferredTransferContainer and the other possible portable containers, and then the storage conditions and positions of the remaining *)
	{
		dimensionsNotFlat,
		storageConditionNotFlat,
		transportPositionsAndDimensionsNotFlat
	} = Download[
		{
			{preferredTransferContainer},
			{myObjectSample},
			{
				(*lightbox/Ambient*)
				Model[Container, LightBox, "id:Z1lqpMzDbjlz"],
				(*Minus40*)
				Model[Instrument, PortableCooler, "id:R8e1PjpjnEPK"],
				(*Minus80*)
				Model[Instrument, PortableCooler, "id:o1k9jAGAEpjr"],
				(*Chilled*)
				Model[Instrument, PortableCooler, "id:R8e1PjpjnEPX"],
				(*Warmed*)
				Model[Instrument, PortableHeater, "id:3em6ZvLv7bZv"]
			}
		},
		{
			{
				Dimensions,
				MinTemperature,
				MaxTemperature
			},
			{
				StorageCondition[Name],
				Flammable,
				Pyrophoric,
				ThawTemperature
			},
			{
				Dimensions,
				Positions,
				MinTemperature,
				MaxTemperature
			}
		}];

	(* the storage temperature of the input model sample *)
	maxContainerTemperature = dimensionsNotFlat[[1]][[3]];
	minContainerTemperature = dimensionsNotFlat[[1]][[2]];
	flammable = storageConditionNotFlat[[1]][[2]];
	pyrophoric = storageConditionNotFlat[[1]][[3]];
	currentStorageConditionName = storageConditionNotFlat[[1]][[1]];
	thawTemp = storageConditionNotFlat[[1]][[4]];

	(* construct transport instrument to min temp/max temp lookup *)
	transportTempLookup = AssociationThread[
		{"LightBox","Minus 40","Minus 80","Chilled","OvenDried"}
			->{
			{transportPositionsAndDimensionsNotFlat[[1]][[3]],transportPositionsAndDimensionsNotFlat[[1]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[2]][[3]],transportPositionsAndDimensionsNotFlat[[2]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[3]][[3]],transportPositionsAndDimensionsNotFlat[[3]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[4]][[3]],transportPositionsAndDimensionsNotFlat[[4]][[4]]},
			{transportPositionsAndDimensionsNotFlat[[5]][[3]],transportPositionsAndDimensionsNotFlat[[5]][[4]]}
		}];

	(* check if currentStorageConditionName has Freezer or Cryo in it *)
	instrumentToTransportFrozenSample = Which[StringContainsQ[currentStorageConditionName,"Freezer"] || StringContainsQ[currentStorageConditionName,"Cryo"] && !NullQ[thawTemp],
		(* if it does, want to transport it at Thawed temp, so check whether thawTemp is in range of given TransportCondition's instrument *)
		Module[{chosenTransportInstrument,transportConditionName,instrumentMinTemp,instrumentMaxTemp},
			chosenTransportInstrument=Which[

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"LightBox"]],
				Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"OvenDried"]],
				Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"Chilled"]],
				Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 40"]],
				Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],

				MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 80"]],
				Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]
			];

			transportConditionName = cleanedTransportCondition[Name];
			instrumentMinTemp = Lookup[transportTempLookup,transportConditionName][[1]];
			instrumentMaxTemp = Lookup[transportTempLookup,transportConditionName][[2]];
			(* if it is in range, thenn return the instrument *)
			If[thawTemp >= instrumentMinTemp && thawTemp <= instrumentMaxTemp,
				(* if it is in range, do footprint check *)
				If[CompatibleFootprintQ[chosenTransportInstrument,preferredTransferContainer,ExactMatch->False],
					chosenTransportInstrument,
					(*if the footprint check does not pass, return incompatible dims error*)
					Message[Error::IncompatibleTemperatures,ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]]
				],
				(* if not in temperature range, then return the instrument whose range has the thawTemp and throw a warning *)
				Message[Warning::FrozenSampleThawTemperature,ObjectToString[chosenTransportInstrument]];
				chosenTransportInstrument
			]
		],
		(* check if thawTemp is Null and Freezer/cryo is still storage condition, return the LightBox instrument *)
		NullQ[thawTemp] && StringContainsQ[currentStorageConditionName,"Freezer"] || StringContainsQ[currentStorageConditionName,"Cryo"],
		Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

		(* otherwise, return Null*)
		True,
		Null

	];

	(* if this particular case occurred, return the instrument *)
	If[!NullQ[instrumentToTransportFrozenSample],
		Return[instrumentToTransportFrozenSample]
	];

	(* Since Volume is specified at this point, find the matching instrument with the transport condition and then see if dimensions of chosen container can fit *)
	matchingInstrument=Which[
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"LightBox"]],
		(* input transportCondition is lightbox *)
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Container,LightBox,"id:Z1lqpMzDbjlz"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"LightBox"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"LightBox"][[2]],
				(*If temperature is in range, return the lightbox*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"LightBox"][[1]] && setTemp <= Lookup[transportTempLookup,"LightBox"][[2]]),
					Model[Container,LightBox,"id:Z1lqpMzDbjlz"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"LightBox"][[1]] && setTemp <= Lookup[transportTempLookup,"LightBox"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Container,LightBox,"id:Z1lqpMzDbjlz"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]]
			],
			(* else: If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Container,LightBox,"id:Z1lqpMzDbjlz"]]]
		],

		(* input transportCondition is Warmed *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"OvenDried"]],
		(* check if sample is flammable or pyrophoric *)
		If[flammable || pyrophoric,
			(* if it is, throw an error, as it's not supposed to be OvenDried *)
			Message[Error::FlammableOrPyrophoric],
			(* if not, check if Dimensions fit *)
			If[CompatibleFootprintQ[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],preferredTransferContainer,ExactMatch->False],
				(*If they do, check if the temperatures are in range*)
				If[minContainerTemperature<=Lookup[transportTempLookup,"OvenDried"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"OvenDried"][[2]],
					(*If temperature is in range, return the portable heater*)
					Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"OvenDried"][[1]] && setTemp <= Lookup[transportTempLookup,"OvenDried"][[2]]),
						Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"],

						(* check if setTemp isnt Null and if it's not in range, throw an error *)
						!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"OvenDried"][[1]] && setTemp <= Lookup[transportTempLookup,"OvenDried"][[2]]),
						Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]]}],

						(* if setTemp is Null / any other case, just return the LightBox *)
						True,
						Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]
					],
					(*If not, throw an error*)
					Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]]]
				],
				(*If dimensions don't fit, return error*)
				Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableHeater,"id:3em6ZvLv7bZv"]]]
			]
		],

		(* input transportCondition is Chilled *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"Chilled"]],
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"Chilled"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"Chilled"][[2]],
				(*If temperature is in range, return the portable heater*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"Chilled"][[1]] && setTemp <= Lookup[transportTempLookup,"Chilled"][[2]]),
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"Chilled"][[1]] && setTemp <= Lookup[transportTempLookup,"Chilled"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]]]
			],
			(*If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPX"]]]
		],

		(* input transportCondition is Minus40 *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 40"]],
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"Minus 40"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"Minus 40"][[2]],
				(*If temperature is in range, return the portable heater*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"Minus 40"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 40"][[2]]),
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"Minus 40"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 40"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]]]
			],
			(*If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableCooler,"id:R8e1PjpjnEPK"]]]
		],

		(* input transportCondition is Minus80 *)
		MatchQ[cleanedTransportCondition,Model[TransportCondition,"Minus 80"]],
		(* check if Dimensions fit *)
		If[CompatibleFootprintQ[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"],preferredTransferContainer,ExactMatch->False],
			(*If they do, check if the temperatures are in range*)
			If[minContainerTemperature<=Lookup[transportTempLookup,"Minus 80"][[1]]&&maxContainerTemperature>=Lookup[transportTempLookup,"Minus 80"][[2]],
				(*If temperature is in range, return the portable heater*)
				Which[!NullQ[setTemp] && (setTemp >= Lookup[transportTempLookup,"Minus 80"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 80"][[2]]),
					Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"],

					(* check if setTemp isnt Null and if it's not in range, throw an error *)
					!NullQ[setTemp] && !(setTemp >= Lookup[transportTempLookup,"Minus 80"][[1]] && setTemp <= Lookup[transportTempLookup,"Minus 80"][[2]]),
					Message[Error::TemperatureOutOfRange,{ToString[setTemp],ObjectToString[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]]}],

					(* if setTemp is Null / any other case, just return the LightBox *)
					True,
					Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]
				],
				(*If not, throw an error*)
				Message[Error::IncompatibleTemperatures,ObjectToString[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]]]
			],
			(*If dimensions don't fit, return error*)
			Message[Error::IncompatibleDimensions,ObjectToString[Model[Instrument,PortableCooler,"id:o1k9jAGAEpjr"]]]
		]
	];

	If[MatchQ[matchingInstrument,ObjectP[{Model[Instrument],Model[Container]}]],
		matchingInstrument,
		matchingInstrument;
		$Failed
	]


];
