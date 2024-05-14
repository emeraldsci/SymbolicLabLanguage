(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* MicrowaveDigestionSharedOptions *)

(* ::Subsection::Closed:: *)
(* MicrowaveDigestionSampleOptions *)

DefineOptionSet[MicrowaveDigestionOptions :> {
	{
		OptionName->DigestionInstrument,
		Default -> Model[Instrument, Reactor, Microwave, "Discover SP-D 80"],
		AllowNull -> False,
		Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Instrument, Reactor, Microwave], Model[Instrument, Reactor, Microwave]}]],
		Description -> "The reactor used to perform the microwave digestion.",
		Category -> "Digestion"
	},
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName -> SampleType,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Organic, Inorganic, Tablet, Biological]],
			Description -> "Specifies if the sample is primarily composed of organic material (solid or liquid), inorganic material (solid or liquid), is a tablet formulation, or is biological in origin, such as tissue culture or cell culture sample.",
			ResolutionDescription -> "The sample type is set to Organic for any solid and liquid samples by default, and Tablet for samples with Tablet -> True.",
			Category -> "Digestion"
		},
		{
			OptionName -> SampleDigestionAmount,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				"Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[1 Microliter, 20000 Microliter], Units -> Microliter],
				"Mass" -> Widget[Type -> Quantity, Pattern :> RangeP[1 Milligram, 500 Milligram], Units -> Milligram]
			],
			Description -> "The amount of sample that is mixed with DigestionAgents to fully solublize any solid components.",
			ResolutionDescription -> "The default sample amount is set to 10 Milligram or 100 Microliter for solid and liquids samples, respectively.",
			Category -> "Digestion"
		},
		{
			OptionName -> CrushSample,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the tablet is crushed to a powder prior to mixing with DigestionAgents.",
			ResolutionDescription -> "Automatically set to True if the SampleType is set to Tablet.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> PreDigestionMix,
			AllowNull -> False,
			Default -> Automatic,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating. Pre-mixing can ensure that a sample is fully dissolved or suspended prior to heating.",
			ResolutionDescription -> "Automatically set to True unless the PreDigestionMixTime and PreDigestionMixRate are not specified.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> PreDigestionMixTime,
			AllowNull -> True,
			Default -> Automatic,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 2 Minute], Units -> Alternatives[Second, Minute]],
			Description -> "The amount of time for which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
			ResolutionDescription -> "Automatically set to 2 Minutes when PreDigestionMix is True.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> PreDigestionMixRate,
			AllowNull -> True,
			Default -> Automatic,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[None, Low, Medium, High]],
			Description -> "The rate at which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
			ResolutionDescription -> "Automatically set to Medium when PreDigestionMix is True.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> PreparedPreDigestionSample,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the member of SampleIn is already mixed with an appropriate digestion agent. Setting PreparedSample -> True will change the upper limit on the SampleAmount to 20 mL, allowing it to occupy the full volume of the microwave vessel.",
			ResolutionDescription -> "Automatically set to True for liquid samples which contain greater than 50 % of a standard digestion agent.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionAgents,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Adder[
				{
					"Digestion Agent" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[
							Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"],
							Model[Sample, "Hydrochloric Acid 37%, (TraceMetal Grade)"],
							Model[Sample, "Sulfuric Acid 96% (TraceMetal Grade)"],
							Model[Sample, "Phosphoric Acid 85% (>99.999% trace metals basis)"],
							Model[Sample, "Hydrogen Peroxide 30% for ultratrace analysis"],
							Model[Sample, "Milli-Q water"],
							Model[Sample, "id:qdkmxzqpeaRY"],
							Model[Sample, "id:N80DNj1WpbLD"],
							Model[Sample, "id:n0k9mG8Z1b4p"],
							Model[Sample, "id:lYq9jRx5nvmO"],
							Model[Sample, "id:xRO9n3BGjKb5"],
							Model[Sample, "id:8qZ1VWNmdLBD"]
						]
					],
					(*Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Sample]],
						OpenPaths -> {
							Object[Catalog,"Root"],
							"Materials", "Inductively Coupled Plasma Mass Spectrometry", "Digestion Agents"
						}
					],*)
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter, 20 Milliliter],
						Units -> Alternatives[Microliter, Milliliter]
					]
				}
			],
			Description -> "The sample model and volume of chemical digestion agents used to digest and dissolve the input sample in the form of {Model[Sample], volume}.",
			(*TODO: Add a table here *)
			ResolutionDescription -> "Automatically set to Nitric acid : H2O2 = 9 : 1 for organic samples, Nitric acid : HCl = 9 : 1 for inorganic samples, and Nitric acid : H2O2 : HCl = 8 : 1 : 1 for tablet samples.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionTemperature,
			AllowNull -> True,
			Default -> Automatic,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[25 Celsius, 300 Celsius],
				Units -> Celsius
			],
			Description -> "The temperature to which the sample is heated for the duration of the DigestionDuration.",
			ResolutionDescription -> "Automatically set to 200 Celsius when DigestionTemperatureProfile is not specified.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionDuration,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Hour, Min[$MaxExperimentTime, 99 Hour]],
				Units -> Alternatives[Second, Minute, Hour]
			],
			Description -> "The amount of time for which the sample is incubated at the set DigestionTemperature during digestion.",
			ResolutionDescription -> "When DigestionTemperatureProfile is specified, DigestionDuration matches the length of the final isothermal segment. Otherwise it is set to 10 minutes.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionRampDuration,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Hour, Min[$MaxExperimentTime, 99 Hour]],
				Units -> Alternatives[Second, Minute, Hour]
			],
			(*TODO: read in the style guide about how to enter degree sign*)
			Description -> "The amount of time taken for the sample chamber temperature from ambient temperature to reach the DigestionTemperature.",
			ResolutionDescription -> "Is automatically set to heat at a rate of 40 C/minute unless DigestionTemperatureProfile is specified.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionTemperatureProfile,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Adder[
				{
					"Time" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Hour, Min[$MaxExperimentTime, 99 Hour]],
						Units -> Alternatives[Second, Minute, Hour]
					],
					"Target Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 300 Celsius],
						Units -> {Celsius,{Celsius, Kelvin, Fahrenheit}}
					]
				}
			],
			Description -> "The heating profile for the reaction mixture in the form {{Time, Target Temperature}..}. Consecutive entries with different temperatures result in a linear ramp between the temperatures, while consecutive entries with the same temperature indicate an isothermal region at the specified temperature.",
			ResolutionDescription -> "When DigestionTemperature, DigestionRampTime, or DigestionTime are specified, this option set to {{DigestionRampDuration, DigestionTemperature},{DigestionRampDuration + DigestionDuration, DigestionTemperature}}.",
			Category -> "Digestion"
		},
		(*TODO: check the option resolver in the experiment.m file to deal with cases when DigestionTemperature, DigestionDuration, DigestionRampDuration -> Null, DigestionTemperatureProfile -> Automatic*)
		{
			OptionName -> DigestionMixRateProfile,
			Default -> Medium,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Low, Medium, High]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Hour, Min[$MaxExperimentTime, 99 Hour]],
							Units -> Alternatives[Second, Minute, Hour]
						],
						"Mix Rate" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Low, Medium, High]
						]
					}
				]
			],
			Description -> "The relative rate of the magnetic stir bar rotation that will be used to mix the sample, either for the duration of the digestion (fixed), or from the designated time point to the next time point (variable). For safety reasons, the sample must be mixed during microwave heating.",
			Category -> "Digestion"
		},
		(*TODO: Ask Alex. Find out why it's called maximum. Also find out whether this power refers to electric power or actual power into the sample *)
		{
			OptionName -> DigestionMaxPower,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Watt, 300 Watt], Units -> Watt],
			Description -> "The maximum power of the microwave radiation output that will be used during heating.",
			ResolutionDescription -> "Automatically set to 200 Watt if SampleType -> Organic, and automatically set to 300 Watt For SampleType -> Tablet or Inorganic.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionMaxPressure,
			Default -> 250 PSI,
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 PSI, 500 PSI], Units -> {PSI, {Pascal, Kilopascal, Megapascal, Millibar, Bar, PSI}}],
			Description -> "The pressure at which the magnetron will cease to heat the reaction vessel. If the vessel internal pressure exceeds 500 PSI, the instrument will cease heating regardless of this option.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionPressureVenting,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the reaction vessel is vented when pressure rise above DigestionPressureVentingTriggers.",
			ResolutionDescription -> "Automatically set to True for Inorganic and Tablet samples if DigestionPressureVentingTriggers or DigestionTargetPressureReduction is specified.",
			Category -> "Digestion"
		},
		(*the upper limit here is 127 number of vents and between 1 - 300 PSI.Seems pretty arbitrary*)
		{
			OptionName -> DigestionPressureVentingTriggers,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Adder[{
				"Trigger Pressure" -> Widget[Type -> Quantity, Pattern :> RangeP[1 PSI, 400 PSI], Units -> {PSI, {Pascal, Kilopascal, Megapascal, Millibar, Bar, PSI}}],
				"Number of Ventings" -> Widget[Type -> Number, Pattern :> RangeP[1, 127]]
			}],
			(*TODO: Ask Alex about what happens if reaction vessel gets superheated, any safety concerns?*)
			Description -> "The set point pressures at which venting will begin, and the number of times that the system will vent the vessel in an attempt to reduce the pressure by the value of TargetPressureReduction. If the pressure set points are not reached, no venting will occur. Be aware that excessive venting may result in sample evaporation, leading to dry out of sample, loss of sample and damage of reaction vessel.",
			ResolutionDescription -> "If PressureVenting -> True, the PressureVentingTriggers are set to include a venting step at 50 PSI (2 attempts) with additional venting set according to SampleType. If SampleType -> Organic, additional venting occurs at 25 PSI increments starting at 225 PSI with 2 venting attempts at each pressure point until 350 PSI, for which venting is set to 100 attempts. Inorganic samples utilize additional venting at 400 PSI, using 100 attempts.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionTargetPressureReduction,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 PSI, 300 PSI], Units -> {PSI, {Pascal, Kilopascal, Megapascal, Millibar, Bar, PSI}}],
			Description -> "The target drop in pressure during PressureVenting. Venting is conducted according to the PressureVentingTriggers.",
			ResolutionDescription -> "When PressureVenting -> True, the TargetPressureReduction is set based on the value of SampleType. Organic samples and tablets require more frequent venting until 25 PSI below DigestionPressureVentingTriggers, while inorganic samples may be vented less frequently until 40 PSI below DigestionPressureVentingTriggers.",
			Category -> "Digestion"
		},
		{
			OptionName -> DigestionOutputAliquot,
			Default -> 3 Milliliter,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[0 Milliliter, 20 Milliliter], Units -> Alternatives[Microliter, Milliliter]],
				Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
			],
			Description -> "The maximum amount of the reaction mixture that is aliquoted into the ContainerOut. If the volume of sample after experiment falls below DigestionOutputAliquot, the full fraction will be collected. The remaining reaction mixture is discarded.",
			(*TODO: Do the math and find out a way to match the need for ICPMS*)
			ResolutionDescription -> "For ICPMS applications, if StandardType is set to External or None, this option is automatically set to 150 ul. If StandardType is set to Internal, set to 150 ul times the number of internal standard additions specified by the InternalStandardAdditionCurve.",
			Category -> "Digestion"
		},
		{
			OptionName -> DiluteDigestionOutputAliquot,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the OutputAliquot is added to a specified volume (PostDigestionDiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			ResolutionDescription -> "When Diluent and PostDigestionDiluentVolume are specified, this will automatically set to True.",
			Category -> "Digestion"
		},
		{
			OptionName -> PostDigestionDiluent,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Object[Sample]}]],
			Description -> "The solution used to dilute the OutputAliquot of the digested sample.",
			ResolutionDescription -> "When DiluteOutputAliquot -> True, the default diluent is automatically set to Model[Sample, \"Trace metal grade water\"].",
			Category -> "Digestion"
		},
		(*TODO: Ask thermofisher whether trace metal grade water should be used, or regular milliQ water is fine*)
		(*TODO: Make a folder of trace metal grade solvents*)
		{
			OptionName -> PostDigestionDiluentVolume,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Liter, 1 Liter],
				Units -> Alternatives[Microliter, Milliliter, Liter]
			],
			Description -> "The volume of diluent into which the OutputAliquot will be added. User should only specify one of the 3 options: PostDigestionDiluentVolume, PostDigestionDilutionFactor, PostDigestionSampleVolume.",
			Category -> "Digestion"
		},
		{
			OptionName -> PostDigestionDilutionFactor,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 1000]
			],
			Description -> "The desired dilution factor for this mixture. User should only specify one of the 3 options: PostDigestionDiluentVolume, PostDigestionDilutionFactor, PostDigestionSampleVolume.",
			ResolutionDescription -> "When DiluteOutputAliquot -> True, automatically set to a value so that the volume after dilution is 3 ml.",
			Category -> "Digestion"
		},
		{
			OptionName -> PostDigestionSampleVolume,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				"Target Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Liter, 1 Liter], Units -> Alternatives[Microliter, Milliliter, Liter]]
			],
			Description -> "The volume of output sample after DigestionOutputAliquot has been removed, and subsequently been diluted by the PostDigestionDiluentVolume of the provided Diluent sample.  User should only specify one of the 3 options: PostDigestionDiluentVolume, PostDigestionDilutionFactor, PostDigestionSampleVolume.",
			ResolutionDescription -> "Automatically set to equal to the sum of PostDigestionDiluentVolume and DigestionOutputAliquot if PostDigestionDiluentVolume is specified, otherwise automatically set to 3 ml.",
			Category -> "Digestion"
		},
		(*TODO: Set openpath for tubes in catalog*)
		{
			OptionName -> DigestionContainerOut,
			Default ->Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Container]],
				OpenPaths -> {
					{
						Object[Catalog,"Root"],
						"Containers", "Tubes & Vials"
					}
				}
			],
			Description -> "The container into which the OutputAliquotVolume or dilutions thereof is placed as the output of digestion. If StandardType is set to Internal, the sample will be subjected to internal standard addition before injecting into ICPMS instrument, otherwise the sample will be directly injected to ICPMS instrument.",
			Category -> "Digestion"
		}
	]
}];