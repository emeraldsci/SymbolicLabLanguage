(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*MicrowaveDigestion*)




(* ::Subsubsection::Closed:: *)
(*ExperimentMicrowaveDigestion Options*)

DefineOptions[ExperimentMicrowaveDigestion,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Reactor, Microwave, "Discover SP-D 80"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Instrument, Reactor, Microwave], Model[Instrument, Reactor, Microwave]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Microwaves"
					}
				}
			],
			Description -> "The reactor used to perform the microwave digestion.",
			Category -> "General"
		},

		(* ----------------- *)
		(* -- SAMPLE TYPE -- *)
		(* ----------------- *)

		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleType,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Organic, Inorganic, Tablet, Biological]],
				Description -> "Specifies if the sample is primarily composed of organic material, inorganic material, or is a tablet formulation. If the sample in tablet form, select Tablet regardless of the composition.",
				ResolutionDescription -> "The sample type is set to Organic for any solid and liquid samples by default, and Tablet for samples with Tablet -> True.",
				Category -> "General"
			},
			{
				OptionName -> SampleAmount,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[1 Microliter, 20000 Microliter], Units -> Microliter],
					"Mass" -> Widget[Type -> Quantity, Pattern :> RangeP[1 Milligram, 500 Milligram], Units -> Milligram]
				],
				Description -> "The amount of sample used for digestion.",
				ResolutionDescription -> "The default sample amount is set to 100 Milligram or 100 Microliter for solid and liquids samples, respectively.",
				Category -> "General"
			},
			{
				OptionName -> CrushSample,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the tablet is crushed to a powder prior to digestion.",
				ResolutionDescription -> "If the SampleType -> Tablet, the sample will be crushed by default.",
				Category -> "Sample Preparation"
			},

			(* ------------- *)
			(* -- PRE MIX -- *)
			(* ------------- *)

			(* pre mix master switch *)
			{
				OptionName -> PreDigestionMix,
				AllowNull -> False,
				Default -> Automatic,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating. Pre-mixing can ensure that a sample is fully dissolved or suspended prior to heating.",
				ResolutionDescription -> "Defaults to True unless the PreDigestionMixTime and PreDigestionMixRate are not specified.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> PreDigestionMixTime,
				AllowNull -> True,
				Default -> Automatic,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 2 Minute], Units -> Alternatives[Second, Minute]],
				Description -> "The amount of time for which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
				ResolutionDescription -> "When PreDigestionMix -> True, this option is set to 2 Minutes.",
				Category -> "Sample Preparation"
			},
			{
				OptionName -> PreDigestionMixRate,
				AllowNull -> True,
				Default -> Automatic,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[None, Low, Medium, High]],
				Description -> "The rate at which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
				ResolutionDescription -> "When PreDigestionMix -> True, this option is set to Medium.",
				Category -> "Sample Preparation"
			},

			(* --------------- *)
			(* -- DIGESTION -- *)
			(* --------------- *)


			{
				OptionName -> PreparedSample,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the member of SampleIn is already mixed with an appropriate digestion agent. Setting PreparedSample -> True will change the upper limit on the SampleAmount to 20 mL.",
				ResolutionDescription -> "Resolves to True for liquid samples which contain greater than 50 % of a standard digestion agent.",
				Category -> "Digestion"
			},

			(* -- DIGESTION AGENT -- *)
			(*TODO: make a pattern at the start of the file to use here, such that the allowed reagents are hardcoded.
      H3PO4 (85%),HNO3 (65%), HCl (30-37%), H2SO4 (95-98%), H2O2 (30%), H3BO3 (5%)
      Not used: HF (40 -48%), HClO4 (70-72%)*)
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
						"Volume" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Milliliter, 20 Milliliter],
							Units -> Alternatives[Microliter, Milliliter]
						]
					}
				],
				Description -> "The Model[Sample] and volume of chemical digestion agents used to digest and dissolve the input sample in the form of {Model[Sample], volume}.",
				ResolutionDescription -> "When PreparedSample -> True, this option is set to Null, otherwise the digestion agents will be resolved based on the SampleType.",
				Category -> "Digestion"
			},

			(* -- HEATING AND STIRRING -- *)

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
				ResolutionDescription -> "When DigestionTemperatureProfile is specified, DigestionTemperature -> Null. Otherwise it is set to 200 Celsius.",
				Category -> "Digestion"
			},
			{
				OptionName -> DigestionDuration,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Hour, Min[$MaxExperimentTime, 99 Hour]],
					Units -> Alternatives[Second, Minute, Hour]
				],
				Description -> "The amount of time for which the sample is heated.",
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
				Description -> "The amount of time taken to heat the sample from ambient temperature to reach the DigestionTemperature.",
				ResolutionDescription -> "When DigestionTemperatureProfile is specified, DigestionRampDuration -> Null, otherwise it is set to heat at a rate of 40 C/minute.",
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
							Units -> Celsius
						]
					}
				],
				Description -> "The heating profile for the reaction mixture in the form {Time, Target Temperature}. Consecutive entries with different temperatures result in a linear ramp between the temperatures, while consecutive entries with the same temperature indicate an isothermal region at the specified temperature.",
				ResolutionDescription -> "When DigestionTemperature, DigestionRampTime, or DigestionTime are specified, this option is set to reflect those values.",
				Category -> "Digestion"
			},
			{
				OptionName -> DigestionMixRateProfile,
				Default -> Medium,
				AllowNull -> True,
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
			{
				OptionName -> DigestionMaxPower,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Watt, 300 Watt], Units -> Watt],
				Description -> "The maximum power of the microwave radiation output that will be used during heating.",
				ResolutionDescription -> "If SampleType -> Organic, the maximum power is set at 200 Watt. For SampleType -> Tablet or Inorganic, the maximum power is set to 300 Watt.",
				Category -> "Digestion"
			},
			{
				OptionName -> DigestionMaxPressure,
				Default -> 250 PSI,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 PSI, 500 PSI], Units -> PSI],
				Description -> "The pressure at which the magnetron will cease to heat the reaction vessel. If the vessel internal pressure exceeds 500 PSI, the instrument will cease heating regardless of this option.",
				Category -> "Digestion"
			},

			(* ---------------------- *)
			(* -- PRESSURE VENTING -- *)
			(* ---------------------- *)

			{
				OptionName -> PressureVenting,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the reaction vessel is vented at specified pressure set points during the digestion.",
				ResolutionDescription -> "If PressureVentingTriggers and TargetPressureReduction are both Null, this option is set to False for Inorganic and Tablet samples.",
				Category -> "Digestion"
			},
			(*the upper limit here is 127 number of vents and between 1 - 300 PSI.Seems pretty arbitrary*)
			{
				OptionName -> PressureVentingTriggers,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[{
					"Trigger Pressure" -> Widget[Type -> Quantity, Pattern :> RangeP[1 PSI, 400 PSI], Units -> PSI],
					"Number of Ventings" -> Widget[Type -> Number, Pattern :> RangeP[1, 127]]
				}],
				Description -> "The set point pressures at which venting will begin, and the number of times that the system will vent the vessel in an attempt to reduce the pressure by the value of TargetPressureReduction. If the pressure set points are not reached, no venting will occur. Be aware that excessive venting may result in sample evaporation, leading to superheating of the reaction vessel.",
				ResolutionDescription -> "If PressureVenting -> True, the PressureVentingTriggers are set to include a venting step at 50 PSI (2 attempts) with additional venting set according to SampleType. If SampleType -> Organic, additional venting occurs at 25 PSI increments starting at 225 PSI with 2 venting attempts at each pressure point until 350 PSI, for which venting is set to 100 attempts. Inorganic samples utilize additional venting at 400 PSI, using 100 attempts.",
				Category -> "Digestion"
			},
			{
				OptionName -> TargetPressureReduction,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 PSI, 300 PSI], Units -> PSI],
				Description -> "The target drop in pressure during PressureVenting. Venting is conducted according to the PressureVentingTriggers.",
				ResolutionDescription -> "When PressureVenting -> True, the TargetPressureReduction is set based on the value of SampleType. Organic samples and tablets require more frequent venting with a differential of 25 PSI, while inorganic samples may be vented less frequently with a differential of 40 PSI.",
				Category -> "Digestion"
			},


			(* ------------ *)
			(* -- WORKUP -- *)
			(* ------------ *)

			{
				OptionName -> OutputAliquot,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[0 Milliliter, 20 Milliliter], Units -> Alternatives[Microliter, Milliliter]],
					Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				],
				Description -> "The amount of the reaction mixture that is aliquotted into the ContainerOut as the output of this experiment. The remaining reaction mixture is discarded.",
				ResolutionDescription -> "By default, 25% of the solution by volume will be collected, and 75% discarded.",
				Category -> "Workup"
			},
			{
				OptionName -> DiluteOutputAliquot,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
				ResolutionDescription -> "When Diluent and DiluentVolume are specified, this will automatically resolve to True.",
				Category -> "Workup"
			},
			{
				OptionName -> Diluent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				],
				Description -> "The solution used to dilute the OutputAliquot of the digested sample.",
				ResolutionDescription -> "When DiluteOutputAliquot -> True, the default diluent is Model[Sample, \"Milli-Q water\"].",
				Category -> "Workup"
			},
			{
				OptionName -> DiluentVolume,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Liter, 1 Liter],
					Units -> Alternatives[Microliter, Milliliter, Liter]
				],
				Description -> "The volume of diluent into which the OutputAliquot will be added. User should only specify one of the 3 options: DiluentVolume, DilutionFactor, TargetDilutionVolume.",
				Category -> "Workup"
			},
			{
				OptionName -> DilutionFactor,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 1000]
				],
				Description -> "The desired dilution factor for this mixture. User should only specify one of the 3 options: DiluentVolume, DilutionFactor, TargetDilutionVolume.",
				ResolutionDescription -> "When DiluteOutputAliquot -> True and DiluentVolume, TargetDiluentVolume are both Null, the Dilution factor is set to 5.",
				Category -> "Workup"
			},
			{
				OptionName -> TargetDilutionVolume,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume After Dilution" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Liter, 1 Liter], Units -> Alternatives[Microliter, Milliliter, Liter]]
				],
				Description -> "The volume to which the OutputAliquot is diluted with Diluent. User should only specify one of the 3 options: DiluentVolume, DilutionFactor, TargetDilutionVolume.",
				Category -> "Workup"
			},
			{
				OptionName -> ContainerOut,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "The container into which the OutputAliquotVolume or dilutions thereof is placed as the output of this experiment. The remainder of the reaction mixture is discarded.",
				ResolutionDescription -> "A container that satisfies the output volume requirement and is acid-compatible will be selected.",
				Category -> "Workup"
			},

			(* --- Labels___*)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True,
				Description -> "A user defined word or phrase used to identify the Sample for use in downstream unit operations."
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
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True,
				Description -> "A user defined word or phrase used to identify the Sample as the result of current unit operations."
			}
		],
		(* Shared options *)
		NonBiologyFuntopiaSharedOptions,
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 20 Milliliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		SimulationOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		PreparationOption
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMicrowaveDigestion: Errors and Warnings*)


(* ======================== *)
(* == ERROR AND WARNINGS == *)
(* ======================== *)

(* errors for sample prep *)
Error::MicrowaveDigestionComputedSampleTypeMisMatch="The specified SampleType is not consistent with the physical characteristics of samples `1`. Verify that the physical State of the sample matches the SampleType.";
Error::MicrowaveDigestionSampleCannotBeCrushed="The samples `1` are not tablets and are not compatible with CrushSample ->True.";
Warning::MicrowaveDigestionUncrushedTablet="It is recommended that CrushTablets be set to True for all tablet inputs. The sample(s) `1` will not be crushed and may not digest completely.";
Error::MicrowaveDigestionNoPreDigestionMix="Solid and Tablet samples must undergo pre-digestion mixing. Set PreDigestionMix -> Automatic or True for the samples `1`.";
Error::MicrowaveDigestionMissingPreDigestionMixTime="When PreDigestionMix -> True, PreDigestionMixTime must not be Null for `1`. Specify PreDigestionMixTime or set this option to Automatic.";
Error::MicrowaveDigestionUnusedPreDigestionMixTime="When PreDigestionMix -> False, the specified PreDigestionMixTime will not be used for `1`. Set PreDigestionMixTime to Null or Automatic.";
Error::MicrowaveDigestionUnusedPreDigestionMixRate="When PreDigestionMix -> False, the specified PreDigestionMixRate will not be used for `1`. Set PreDigestionMixRate to Null or Automatic.";
Error::MicrowaveDigestionMissingPreDigestionMixRate="When PreDigestionMix -> True, PreDigestionMixRate must not be Null for `1`. Specify PreDigestionMixRate or set this option to Automatic.";
Error::MicrowaveDigestionTooManySamples="The following samples exceed the limit of 24 samples per experiment call using the Instrument specified: `1`";
Error::MicrowaveDigestionNotEnoughSample="The SampleAmount for `1` exceeds the mass or volume of the sample. Reduce the SampleAmount or use a larger sample.";

(* errors for digestion agents etc *)
Error::MicrowaveDigestionNoDigestionAgent="Any samples with PreparedSample -> False require DigestionAgent. Specify or set DigestionAgents to Automatic, or designate the PreparedSample -> True for `1`.";
Error::MicrowaveDigestionNoSolvent="The samples `1` do not have solvent. Specify DigestionAgents or use Acquitting options to dissolve the samples appropriately.";
Warning::MicrowaveDigestionPossiblePreparedSample="The samples `1` contain standard digestion agents in the Composition field. To dismiss this warning, set PreparedSample to True or False.";
Error::MicrowaveDigestionMissingDigestionAgent="The samples `1` are not PreparedSample and therefore must have DigestionAgents specified.";
Error::MicrowaveDigestionUnusedDigestionAgent="The samples `1` are PreparedSamples and do not require DigestionAgents. Set DigestionAgents to Automatic or the desired reagents, or set PreparedSample -> True.";
Error::MicrowaveDigestionAquaRegiaGeneration="The specified DigestionAgents have a similar composition to Aqua Regia for `1`. This combination of reagents is disallowed due to the potential for unsafe work conditions resulting from heating this mixture in an enclosed vial.";
Error::MicrowaveDigestionBannedAcids="The samples `1` contain either HF or HClO4 in the composition, and cannot be used for this experiment. Combinations of the available acids and oxidants should will generally result in complete sample digestion, with the exception of silicates, which can be removed via filtration post-digestion.";

(* errors for digestion conditions  *)
Error::MicrowaveDigestionMissingDigestionTemperature="When DigestionTemperatureProfile is Null, a DigestionTemperature must be provided for `1`. Set DigestionTemperature or DigestionTemperatureProfile to Automatic or a specified value.";
Error::MicrowaveDigestionConflictingDigestionTemperature="The specified DigestionTemperature is in conflict with the DigestionTemperatureProfile for `1`. Change one of these option values to Null or set them to Automatic.";
Error::MicrowaveDigestionMissingDigestionDuration="When DigestionTemperatureProfile is Null, a DigestionDuration must be provided for `1`. Set DigestionDuration or DigestionTemperatureProfile to Automatic or a specified value.";
Error::MicrowaveDigestionConflictingDigestionDuration="The specified DigestionDuration is in conflict with the DigestionTemperatureProfile for `1`. Change one of these option values to Null or set them to Automatic.";
Error::MicrowaveDigestionMissingDigestionRampDuration="When DigestionTemperatureProfile is Null, a DigestionRampDuration must be provided for `1`. Set DigestionRampDuration or DigestionTemperatureProfile to Automatic or a specified value.";
Error::MicrowaveDigestionConflictingDigestionRampDuration="The specified DigestionRampDuration is in conflict with the DigestionTemperatureProfile for `1`. Change one of these option values to Null or set them to Automatic.";
Error::MicrowaveDigestionRapidRampRate="The given options result in a ramp rate that exceeds 50 C/min. Change either the value of DigestionTemperatureProfile or DigestionRampDuration depending on how the temperature profile is currently indicated.";
Error::MicrowaveDigestionTemperatureProfileWithCooling="The specified DigestionTemperatureProfile for `1` results in cooling steps that cannot be executed on this instrument. Change the DigestionTemperatureProfile to only include positive temperature changes and isothermal segments.";
Error::MicrowaveDigestionTimePointSwapped="The specified DigestionTemperatureProfile contains time points which are not in increasing order for `1`. Verify the DigestionTemperatureProfile, and ensure that the time points are in order.";
Error::MicrowaveDigestionMissingDigestionProfile="Both the combination of {DigestionTemperature, DigestionDuration, DigestionRampDuration} and DigestionTemperatureProfile are Null for `1`. Please use these options to specify the digestion temperature profile.";
Error::MicrowaveDigestionMisMatchReactionLength="The DigestionMixRateProfile includes time points that are outside of the DigestionTemperatureProfile time range for `1`. Match the last timepoint in DigestionMixRateProfile to that of the DigestionDuration or DigestionTemperatureProfile or set DigestionMixRateProfile to a fixed value or Automatic.";
Error::MicrowaveDigestionMissingMixingProfile="The DigestionMixRateProfile is Null for `1`. Please specify a value or set DigestionMixRateProfile to Automatic.";
Error::MicrowaveDigestionAboveAmbientInitialTemperature="The DigestionTemperatureProfile must start at ambient temperature for `1`. Adjust this value to match the capability of the instrument.";

(* errors for venting *)
Error::MicrowaveDigestionMissingTargetPressureReduction="The TargetPressureReduction is required when PressureVenting -> True for `1`. Specify a TargetPressureReduction.";
Error::MicrowaveDigestionMissingPressureVentingTriggers="The PressureVentingTriggers are required when PressureVenting -> True for `1`. Specify PressureVentingTriggers.";
Error::MicrowaveDigestionUnusedTargetPressureReduction="When PressureVenting -> False, the TargetPressureReduction is not required for `1`. Set this option to Null or Automatic.";
Error::MicrowaveDigestionUnusedPressureVentingProfile="When PressureVenting -> False, the PressureVentingTriggers is not required for `1`. Set this option to Null or Automatic ";
Error::MicrowaveDigestionMissingRequiredVenting="When the SampleType is Organic, PressureVenting must be True for `1`. Set PressureVenting to True or specify the SampleType if it has not been correctly classified.";
Warning::MicrowaveDigestionMissingRecommendedVenting="When the SampleType is Inorganic or Tablet, PressureVenting is recommended for `1`. No reaction venting can lead to pressure buildup, reaction vessel failure, and premature reaction shutdown.";
Error::MicrowaveDigestionExcessiveVentingCycles="The total number of venting cycles exceeds 150 for `1`. Sample evaporation in this case is highly likely, leading to sample loss and possible vessel superheating. It is recommended that the number of venting cycles be reduced.";
Error::MicrowaveDigestionUnsafeOrganicVenting="The PressureVentingTriggers is insufficient for the given sample type for `1`. Ensure that PressureVentingTriggers have a trigger point below 100 PSI and one above 300 PSI order to avoid reaction vessel over-pressurization and failure or premature reaction termination.";
Error::MicrowaveDigestionLargePressureReduction="The TargetPressureReduction is excessive for `1`. Lower the TargetPressureReduction - the recommended values are 40 PSI for Inorganic and Tablets, and 25 PSI for Organic SampleTypes.";

(*errors for workup*)
Error::MicrowaveDigestionUnusedDiluent="The Diluent is not used when DiluteOutputAliquot -> False for `1`. If dilution is desired, set DiluteOutputAliquot -> True.";
Error::MicrowaveDigestionMissingDiluent="The Diluent is missing for `1`. Specify a Diluent or set Diluent ot Automatic when DiluteOutputAliquot -> True.";
Error::MicrowaveDigestionMissingDiluentVolume="The DiluentVolume is missing for `1`. Specify a DiluentVolume or set DiluentVolume ot Automatic when DiluteOutputAliquot -> True.";
Error::MicrowaveDigestionUnusedDiluentVolume="The DiluentVolume is not used when DiluteOutputAliquot -> False for `1`. If dilution is desired, set DiluteOutputAliquot -> True.";
Error::MicrowaveDigestionLargeVolumeDilution="The requested volumes for the output of digested samples `1` exceed the limitations of this experiment. Reduce the OutputAliquot volume or the dilution factor specified in DiluentVolume.";
Error::MicrowaveDigestionLargeVolumeConcAcid="The volume of undiluted reaction mixture for `1` exceed the limitations for safe storage. Reduce the OutputAliquot to 1 Milliliter or specify DiluteOutputAliquot.";
Error::MicrowaveDigestionIncompatibleContainerOut="The selected ContainerOut is not compatible with the composition of the OutputAliquot or dilutions thereof for `1`.  Select a different container with an appropriate chemical compatibility and volume.";
Error::MicrowaveDigestionAliquotExceedsReactionVolume="The requested OutputAliquot exceeds the volume of the reaction mixture for sample `1`. Set the OutputAliquot to All or Automatic if unsure about the reaction volume.";
Error::MicrowaveDigestionDilutionLessThanAliquot="The TargetDilutionVolume is less than the OutputAliquot for sample `1`. Reduce the OutputAliquot, increase TargetDilutionVolume, or consider using DiluentVolume to specify a dilution factor.";
Error::MicrowaveDigestionConflictDilution="More than 1 of the following 3 options: DilutionFactor, DiluentVolume, TargetDilutionVolume are specified for sample `1`. Please specify only one of the 3 options and leave the other 2 as Null or Automatic.";

(* rounding warnings *)
Warning::MicrowaveDigestionSampleAmountPrecision="The SamplesAmount values were provided at higher precision than can be executed in this experiment. The values `1` have been rounded to `2`.";
Warning::DigestionTemperatureProfilePrecision="The DigestionTemperatureProfile values were provided at higher precision than can be executed in this experiment. The values `1` have been rounded to `2`.";
Warning::DigestionMixRateProfilePrecision="The DigestionMixRateProfile values were provided at higher precision than can be executed in this experiment. The values `1` have been rounded to `2`.";
Warning::DigestionAgentsPrecision="The DigestionAgents values were provided at higher precision than can be executed in this experiment. The values `1` have been rounded to `2`.";
Warning::PressureVentingTriggersPrecision="The PressureVentingTriggers values were provided at higher precision than can be executed in this experiment. The values `1` have been rounded to `2`.";

(* instrument error *)
Error::MicrowaveDigestionInvalidInstrument="The provided Instrument is not able to perform Digestion. Please check for Model[Instrument, Reactor, Microwave] with Digestion in the ReactorConditions field or restore the option to the default value.";
Warning::InsufficientPreparedMicrowaveDigestionSample="Total of SampleAmount and DigestionAgents is not above the minimum of `1` for all samples. The microwave reactor will attempt to achieve the desired temperature program, but may not heat and/or stir uniformly, leading to hot or cold spots within the sample mixture. The temperature data produced may no longer be representative of the reaction conditions.";

(* ::Subsubsection::Closed:: *)
(*ExperimentMicrowaveDigestion: Experiment Function*)

ExperimentMicrowaveDigestion[mySamples:ListableP[ObjectP[{Object[Sample], Model[Sample]}]], myOptions:OptionsPattern[ExperimentMicrowaveDigestion]]:=Module[
	{
		listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests, simulation, simulatedProtocol,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, resourcePackets, resourcePacketTests, allDownloadValues,
		mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, listedSamples, updatedSimulation,
		performSimulationQ, result,
		(* variables from safeOps and download *)
		upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache, samplePreparationPackets, sampleModelPreparationPackets, messages,
		allModelSamplesFromOptions, allObjectSamplesFromOptions, allInstrumentObjectsFromOptions, allObjectsFromOptions, allInstrumentModelsFromOptions,
		containerPreparationPackets, modelPreparationPackets, modelContainerPacketFields, graduatedCylinders
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];
	messages=!gatherTests;

	(* Remove temporal links and named objects. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMicrowaveDigestion,
			listedSamples,
			listedOptions,
			DefaultPreparedModelAmount -> 20 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentMicrowaveDigestion, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentMicrowaveDigestion, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(*sanitize the inputs to remove names and links*)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

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
	{validLengths, validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMicrowaveDigestion, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentMicrowaveDigestion, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache}=Lookup[safeOps, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMicrowaveDigestion, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentMicrowaveDigestion, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
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
	inheritedOptions=ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMicrowaveDigestion, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(* ----------------------------------------------------------------------------------- *)
	(* -- DOWNLOAD THE INFORMATION FOR THE OPTION RESOLVER AND RESOURCE PACKET FUNCTION -- *)
	(* ----------------------------------------------------------------------------------- *)
	(*TODO: add the downloads for other thing that may show up like the reaction vessel*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	samplePreparationPackets=Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], Volume, IncompatibleMaterials, Acid, LiquidHandlerIncompatible, Well, Composition, Tablet];
	sampleModelPreparationPackets=Packet[Model[Flatten[{Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, Acid, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerPreparationPackets=Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];
	modelPreparationPackets=Packet[SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, Acid];

	(* look up the values of the options and select ones that are objects/models *)
	allObjectsFromOptions=DeleteDuplicates[Cases[Values[KeyDrop[expandedSafeOps, Cache]], ObjectP[], Infinity]];

	(* break into their types *)
	allInstrumentObjectsFromOptions=Cases[allObjectsFromOptions, ObjectP[Object[Instrument, Reactor, Microwave]]];
	allInstrumentModelsFromOptions=Cases[allObjectsFromOptions, ObjectP[Model[Instrument, Reactor, Microwave]]];

	(* download the object here since there will be a packet also from simulation *)
	(* note that we want to avoid duplicates that arise from the SamplesIn potentially being the AdjustmentSample *)
	allObjectSamplesFromOptions=DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Object[Sample]], Infinity], Object], Alternatives @@ ToList[mySamplesWithPreparedSamples[Object]]];
	allModelSamplesFromOptions=DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Model[Sample]], Infinity], Object], Alternatives @@ ToList[Download[mySamplesWithPreparedSamples, Model[Object], Simulation -> updatedSimulation]]];

	(* download fields for liquid handler compatible containers *)
	modelContainerPacketFields=Packet @@ Flatten[{Object, SamplePreparationCacheFields[Model[Container]]}];
	graduatedCylinders=Search[Model[Container, GraduatedCylinder], Deprecated != True];

	(* make the big download call *)
	allDownloadValues=Quiet[
		Flatten[
			Download[
				{
					ToList[mySamplesWithPreparedSamples],
					allInstrumentObjectsFromOptions,
					allInstrumentModelsFromOptions,
					allObjectSamplesFromOptions,
					allModelSamplesFromOptions,
					graduatedCylinders
				},
				{
					{
						samplePreparationPackets,
						sampleModelPreparationPackets,
						containerPreparationPackets
					},
					{
						Packet[Name, Status, Model],
						Packet[Model[{Name, WettedMaterials, Positions, ReactorConditions}]]
					},
					{
						Packet[Name, WettedMaterials, Positions, ReactorConditions]
					},
					{
						samplePreparationPackets,
						sampleModelPreparationPackets
					},
					{
						modelPreparationPackets
					},
					{
						Packet[MaxVolume]
					}
				},
				Simulation -> updatedSimulation
			]
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];

	cacheBall=Cases[FlattenCachePackets[{inheritedCache, allDownloadValues}], PacketP[]];


	(* -------------------------- *)
	(* --- RESOLVE THE OPTIONS ---*)
	(* -------------------------- *)

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests}=resolveExperimentMicrowaveDigestionOptions[ToList[mySamplesWithPreparedSamples], expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],
		
		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests}={resolveExperimentMicrowaveDigestionOptions[ToList[mySamplesWithPreparedSamples], expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], Null},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* ---------------------------- *)
	(* -- PREPARE OPTIONS OUTPUT -- *)
	(* ---------------------------- *)

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentMicrowaveDigestion,
		resolvedOptions,
		Ignore -> ToList[myOptions],
		Messages -> False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	performSimulationQ = MemberQ[output, Simulation];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed] && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentMicrowaveDigestion, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];


	(* ---------------------------- *)
	(* Build packets with resources *)
	(* ---------------------------- *)


	{resourcePackets, resourcePacketTests}=If[gatherTests,
		microwaveDigestionResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, collapsedResolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{microwaveDigestionResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, collapsedResolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation], {}}
	];

	(* If we were asked for a simulation, also return a simulation *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentMicrowaveDigestion[
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				{}(* unitOperationPackets, which should always be {} since we are only doing it manually *)
			],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		{Null, updatedSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMicrowaveDigestion, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	(*protocolObject=If[!MatchQ[resourcePackets, $Failed] && !MatchQ[resolvedOptionsResult, $Failed],
		UploadProtocol[
			resourcePackets[[1]],
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps,CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> Object[Protocol, MicrowaveDigestion],
			Cache -> cacheBall,
			Simulation -> simulation
		],
		$Failed
	];*)

	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourcePackets, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
			$Failed,
		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			UploadProtocol[
				resourcePackets[[1]],
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, MicrowaveDigestion],
				Cache -> cacheBall,
				(* If we have performed simulation using simulateExperimentMicrowaveDigestion, use that, otherwise use the latest simulation before simulateExperimentMicrowaveDigestion *)
				Simulation -> simulation
			]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentMicrowaveDigestion, collapsedResolvedOptions],
		Options -> RemoveHiddenOptions[ExperimentMicrowaveDigestion, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];

(* -------------------------- *)
(* --- CONTAINER OVERLOAD --- *)
(* -------------------------- *)

ExperimentMicrowaveDigestion[myContainers:ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions:OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, listedContainers, listedOptions, validSamplePreparationResult,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, containerToSampleSimulation, containerToSampleResult,
		containerToSampleOutput, samples, sampleOptions, containerToSampleTests, updatedSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* make the inputs and options a list *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMicrowaveDigestion,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentMicrowaveDigestion,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentMicrowaveDigestion,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMicrowaveDigestion[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* ::Subsubsection::Closed:: *)
(* resolveExperimentMicrowaveDigestionOptions *)


(* ---------------------- *)
(* -- OPTIONS RESOLVER -- *)
(* ---------------------- *)


DefineOptions[
	resolveExperimentMicrowaveDigestionOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentMicrowaveDigestionOptions[mySamples:{ObjectP[Object[Sample]]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentMicrowaveDigestionOptions]]:=Module[
	{
		minSampleVolume, outputSpecification, output, gatherTests, cache, samplePrepOptions, microwaveDigestionOptions, simulatedSamples, resolvedSamplePrepOptions, updatedSimulation,
		samplePrepTests, microwaveDigestionOptionsAssociation, microwaveDigestionTests,
		invalidInputs, invalidOptions, targetContainers, resolvedAliquotOptions, aliquotTests, fullMicrowaveDigestionOptionsAssociation,
		resolvedOptions, mapThreadFriendlyOptions, resolvedPostProcessingOptions,fastAssoc, simulation,

		(* -- download related variables -- *)
		inheritedCache, sampleObjectPrepFields, sampleModelPrepFields, samplePackets, sampleModelPackets, newCache, allDownloadValues,
		allObjectPackets, allModelPackets, allModelFields, allObjectFields, allModelOptions, allObjectOptions, modelContainerPacketFields,
		liquidHandlerContainers, liquidHandlerContainerPackets, allInstrumentOptions, allInstrumentModelOptions, allInstrumentPackets, allInstrumentModelPackets,

		(* -- invalid input tests and variables -- *)
		discardedSamplePackets, discardedInvalidInputs, bannedAcidInvalidInputs, overflowInvalidInputs, overflowSamplePackets,
		discardedTest, messages, validNameQ, nameInvalidOptions,
		validNameTest, modelPacketsToCheckIfDeprecated, deprecatedTest, deprecatedInvalidInputs, deprecatedModelPackets,
		compatibleMaterialsBool, compatibleMaterialsTests, compatibleMaterialsInvalidInputs, lowSampleVolumeTest,
		tooManySamplesTest, lowSampleAmountPackets, lowSampleAmountBool, lowSampleMassBool, lowSampleVolumeBool, globalMinMass, globalMinVolume,
		lowSampleAmountInputs, validSamplesInStorageConditionTests,

		(* -- unresolved options -- *)
		instrument, instrumentModel, instrumentReactorConditions,

		(* -- samples in storage condition -- *)
		samplesInStorageCondition, validSamplesInStorageBool, validSamplesInStorageConditionBools,

		(* -- automatic hidden options -- *)

		(* -- option rounding -- *)
		optionPrecisions, roundedGeneralOptions, roundedOptions, precisionTests,
		roundedDigestionTemperatureProfiles, roundedDigestionMixRateProfile, roundedDigestionAgents, roundedPressureVentingTriggers,
		roundedSampleAmounts, sampleAmountPrecisionTest,
		digestionTemperatureProfilesPrecisionTest, digestionMixRateProfilePrecisionTest, digestionAgentsPrecisionTest, pressureVentingTriggersPrecisionTest,

		(* -- experiment specific helper variables -- *)
		digestionAcidIdentityModelP,

		(* -- map thread error tracking variables -- *)
		resolvedMapThreadOptionsAssociations, mapThreadErrorCheckingAssociations, resolvedOptionsAssociation, mapThreadErrorCheckingAssociation,

		(* -- bad sample packets from map thread error check -- *)
		(* sample prep *)
		samplePacketsWithComputedSampleTypeMisMatch, samplePacketsWithSampleCannotBeCrushed, samplePacketsWithUncrushedTablet, samplePacketsWithNoPreDigestionMix,
		samplePacketsWithMissingPreDigestionMixTime, samplePacketsWithUnusedPreDigestionMixTime, samplePacketsWithUnusedPreDigestionMixRate, samplePacketsWithMissingPreDigestionMixRate,
		(* digestion and sample identity *)
		samplePacketsWithNoDigestionAgent, samplePacketsWithNoSolvent, samplePacketsWithPossiblePreparedSample, samplePacketsWithMissingDigestionAgent,
		samplePacketsWithUnusedDigestionAgent, samplePacketsWithAquaRegiaGeneration, samplePacketsWithBannedAcids,
		(* digestion conditions *)
		samplePacketsWithMissingDigestionTemperature, samplePacketsWithConflictingDigestionTemperature, samplePacketsWithMissingDigestionDuration, samplePacketsWithConflictingDigestionDuration,
		samplePacketsWithMissingDigestionRampDuration, samplePacketsWithConflictingDigestionRampDuration, samplePacketsWithRapidRampRate, samplePacketsWithTemperatureProfileWithCooling,
		samplePacketsWithTimePointSwapped, samplePacketsWithMissingDigestionProfile, samplePacketsWithMisMatchReactionLength, samplePacketsWithMissingMixingProfile, samplePacketsWithAboveAmbientStartTemperature,
		(* venting *)
		samplePacketsWithMissingTargetPressureReduction, samplePacketsWithMissingPressureVentingTriggers, samplePacketsWithUnusedTargetPressureReduction,
		samplePacketsWithUnusedPressureVentingProfile, samplePacketsWithMissingRequiredVenting, samplePacketsWithMissingRecommendedVenting, samplePacketsWithExcessiveVentingCycles,
		samplePacketsWithUnsafeOrganicVenting, samplePacketsWithLargePressureReduction,
		(* workup and output *)
		samplePacketsWithUnusedDiluent, samplePacketsWithMissingDiluent, samplePacketsWithMissingDiluentVolume, samplePacketsWithUnusedDiluentVolume,
		samplePacketsWithLargeVolumeDilution, samplePacketsWithLargeVolumeConcAcid, samplePacketsWithIncompatibleContainerOut,
		samplePacketsWithDilutionLessThanAliquot, samplePacketsWithAliquotExceedsReactionVolume, samplePacketsWithConflictDilution,


		(* -- invalid option tests -- *)
		workupGroupedTests, ventingGroupedTests, digestionConditionsGroupedTests, digestionAgentGroupedTests,
		samplePrepGroupedTests, ventingGroupedWarningTests, invalidInstrumentTest, uncrushedTabletWarningTest,

		(* -- invalid option tracking -- *)
		invalidSamplesInStorageConditionOption,
		invalidWorkupOptions, validTotalReactionVolume, validTotalReactionVolumeBool, invalidTotalReactionVolumeTest, invalidTotalReactionVolumeOptions,
		invalidVentingOptions, invalidDigestionConditionOptions, invalidDigestionAgentOptions, invalidSamplePrepOptions, invalidInstrumentOptions,

		(* -- aliquot resolution variables -- *)
		sampleContainerPackets, sampleContainerFields, bestAliquotAmount,

		(* -- labeling options -- *)
		resolvedSampleLabel, resolvedSampleContainerLabel, resolvedSampleOutLabel, resolvedLabelingOptions
	},

	(* ---------------------------------------------- *)
	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* ---------------------------------------------- *)

	(* Define minimum volume of the sample that will actually go into the instrument *)
	minSampleVolume=5 Milliliter;

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output, Tests];
	messages=!gatherTests;

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Separate out our MicrowaveDigestion options from our Sample Prep options. *)
	{samplePrepOptions, microwaveDigestionOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMicrowaveDigestion, mySamples, samplePrepOptions, Cache -> inheritedCache,Simulation->simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMicrowaveDigestion, mySamples, samplePrepOptions, Cache -> inheritedCache,Simulation->simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	microwaveDigestionOptionsAssociation=Association[microwaveDigestionOptions];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* Remember to download from simulatedSamples, using our updatedSimulation *)
	sampleObjectPrepFields=Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, State, Volume, Tablet, Acid];
	sampleModelPrepFields=Packet[Model[Flatten[{SamplePreparationCacheFields[Object[Sample], Format -> Sequence], State, Products, IncompatibleMaterials, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Deprecated, Tablet, Acid}]]];
	sampleContainerFields=Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];

	(* grab all of the instances of objects in the options and make packets for them - make sure to exclude the cache and also any models/objects found in the input *)
	allObjectOptions=DeleteCases[DeleteDuplicates[Download[Cases[KeyDrop[microwaveDigestionOptionsAssociation, Cache], ObjectP[Object[Sample]], Infinity], Object]], Alternatives @@ ToList[simulatedSamples]];
	allModelOptions=DeleteDuplicates[Download[Cases[KeyDrop[microwaveDigestionOptionsAssociation, Cache], ObjectP[Model[Sample]], Infinity], Object]];
	allInstrumentOptions=DeleteDuplicates[Download[Cases[KeyDrop[microwaveDigestionOptionsAssociation, Cache], ObjectP[Object[Instrument, Reactor, Microwave]], Infinity], Object]];
	allInstrumentModelOptions=DeleteDuplicates[Download[Cases[KeyDrop[microwaveDigestionOptionsAssociation, Cache], ObjectP[Model[Instrument, Reactor, Microwave]], Infinity], Object]];

	(* also grab the fields that we will need to check *)
	allObjectFields=Packet[Name, State, Container, Composition, IncompatibleMaterials, Acid];
	allModelFields=Packet[Name, State, IncompatibleMaterials, Acid];
	modelContainerPacketFields=Packet @@ Flatten[{Object, SamplePreparationCacheFields[Model[Container]]}];


	{
		allDownloadValues,
		allObjectPackets,
		allModelPackets,
		allInstrumentPackets,
		allInstrumentModelPackets
	}=Quiet[Download[
		{
			simulatedSamples,
			allObjectOptions,
			allModelOptions,
			allInstrumentOptions,
			allInstrumentModelOptions
		},
		{
			{
				sampleObjectPrepFields,
				sampleModelPrepFields,
				sampleContainerFields
			},
			{
				allObjectFields
			},
			{
				allModelFields
			},
			{
				Packet[Model],
				Packet[Model[ReactorConditions]]
			},
			{
				Packet[ReactorConditions]
			}
		},
		Cache -> Cases[FlattenCachePackets[{inheritedCache}], PacketP[]],
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* split out the sample and model packets *)
	samplePackets=allDownloadValues[[All, 1]];
	sampleModelPackets=allDownloadValues[[All, 2]];
	sampleContainerPackets=allDownloadValues[[All, 3]];

	(* update cache to include the downloaded sample information and the inherited stuff *)
	newCache=Cases[FlattenCachePackets[{allDownloadValues, allObjectPackets, allModelPackets,(* liquidHandlerContainerPackets, *) allInstrumentPackets, allInstrumentModelPackets}], PacketP[]];
	fastAssoc = makeFastAssocFromCache[newCache];
	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(* -------------- *)
	(* -- ROUNDING -- *)
	(* -------------- *)

	(* gather options and their precisions *)
	optionPrecisions={
		{PreDigestionMixTime, 10^0 * Second},
		{DigestionTemperature, 10^0 * Celsius},
		{DigestionDuration, 10^0 * Second},
		{DigestionRampDuration, 10^0 * Second},
		{DigestionMaxPower, 10^0 * Watt},
		{DigestionMaxPressure, 10^0 * PSI},
		{TargetPressureReduction, 10^0 * PSI},
		{OutputAliquot, 10^0 * Microliter},
		{TargetDilutionVolume, 10^0 Milliliter}
	};


	(* big round call on the joined lists of all roundable options *)
	{
		roundedGeneralOptions,
		precisionTests
	}=If[gatherTests,
		RoundOptionPrecision[microwaveDigestionOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
		{
			RoundOptionPrecision[microwaveDigestionOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]],
			{}
		}
	];

	(* -- SampleAmount rounding -- *)

	{roundedSampleAmounts, sampleAmountPrecisionTest}=Module[
		{originalValues, roundedValues, valueWasRounded, roundingTest},

		(* look up the unrounded value - convert the units so that when we round the units don't change *)
		originalValues=Lookup[microwaveDigestionOptionsAssociation, SampleAmount] /. {x:VolumeP :> UnitConvert[x, Microliter], y:MassP :> UnitConvert[y, Milligram]};

		(* round everything by substitution *)
		roundedValues=originalValues /. {x:VolumeP :> Round[x, 10^0 * Microliter], y:MassP :> Round[y, 10^0 * Milligram]};

		(* compare to the original *)
		valueWasRounded=MapThread[If[EqualQ[#1, #2],
			False,
			True
		]&,
			{roundedValues, originalValues /. {x:VolumeP :> UnitConvert[x, Microliter], y:MassP :> UnitConvert[y, Milligram]}}
		];

		(* warn the user if the DigestionTemperatureProfile was rounded *)
		If[messages && Not[MatchQ[$ECLApplication, Engine]] && (Or @@ valueWasRounded),
			Message[Warning::MicrowaveDigestionSampleAmountPrecision, PickList[originalValues, valueWasRounded], PickList[roundedValues, valueWasRounded]],
			Nothing
		];

		(* Define the tests the user will see for the above message *)
		roundingTest=If[gatherTests && MatchQ[originalValues, Except[Null]],
			Module[{failingTest, passingTest},
				failingTest=If[!(Or @@ valueWasRounded),
					Nothing,
					Warning["SampleAmounts have been specified at a higher precision than can be accurately measured:", True, False]
				];
				passingTest=If[!(Or @@ valueWasRounded),
					Warning["SampleAmounts have been specified to a measurable accuracy :", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];

		(*output the test and rounded option*)
		{roundedValues, {roundingTest}}
	];


	(* -- DigestionTempeartureProfile rounding -- *)

	(* round the digestion tempearture profile, which has the from or {time, temperature} *)
	{roundedDigestionTemperatureProfiles, digestionTemperatureProfilesPrecisionTest}=Module[{originalValues, roundedValues, valueWasRounded, roundingTest},

		(* look up the unrounded value - convert the units so that when we round the units don't change *)
		originalValues=Lookup[microwaveDigestionOptionsAssociation, DigestionTemperatureProfile] /. {x:TimeP :> UnitConvert[x, Second], y:TemperatureP :> UnitConvert[y, Celsius]};

		(* round everything by substitution *)
		roundedValues=originalValues /. {x:TimeP :> Round[x, 10^0 * Second], y:TemperatureP :> Round[y, 10^0 * Celsius]};

		(* compare to the original *)
		valueWasRounded=If[MatchQ[roundedValues, originalValues],
			False,
			True
		];

		(* warn the user if the DigestionTemperatureProfile was rounded *)
		If[messages && Not[MatchQ[$ECLApplication, Engine]] && valueWasRounded,
			Message[Warning::DigestionTemperatureProfilePrecision, originalValues, roundedValues],
			Nothing
		];

		(* Define the tests the user will see for the above message *)
		roundingTest=If[gatherTests && MatchQ[originalValues, Except[Null]],
			Module[{failingTest, passingTest},
				failingTest=If[!valueWasRounded,
					Nothing,
					Warning["DigestionTemperatureProfile have been specified at a higher precision than can be executed by the instrument:", True, False]
				];
				passingTest=If[!valueWasRounded,
					Warning["DigestionTemperatureProfile have been specified at a precision appropriate for the instrument:", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];

		(*output the test and rounded option*)
		{roundedValues, {roundingTest}}
	];



	(* -- DigestionMixRateProfile Rounding -- *)

	(* round the DigestionMixRateProfile, which has the form of {time, MixRate (Low, Medium, High, Off) *)
	{roundedDigestionMixRateProfile, digestionMixRateProfilePrecisionTest}=Module[{originalValues, roundedValues, valueWasRounded, roundingTest},

		(* look up the unrounded value - convert the units so that when we round the units don't change *)
		originalValues=Lookup[microwaveDigestionOptionsAssociation, DigestionMixRateProfile] /. {x:TimeP :> UnitConvert[x, Second]};

		(* round everything by substitution *)
		roundedValues=originalValues /. {x:TimeP :> Round[x, 10^0 * Second]};

		(* compare to the original *)
		valueWasRounded=If[MatchQ[roundedValues, originalValues],
			False,
			True
		];

		(* warn the user if the DigestionMixRateProfile was rounded *)
		If[messages && Not[MatchQ[$ECLApplication, Engine]] && valueWasRounded,
			Message[Warning::DigestionMixRateProfilePrecision, originalValues, roundedValues],
			Nothing
		];

		(* Define the tests the user will see for the above message *)
		roundingTest=If[gatherTests && MatchQ[originalValues, Except[Null]],
			Module[{failingTest, passingTest},
				failingTest=If[!valueWasRounded,
					Nothing,
					Warning["DigestionMixRateProfile have been specified at a higher precision than can be executed by the instrument:", True, False]
				];
				passingTest=If[!valueWasRounded,
					Warning["DigestionMixRateProfile have been specified at a precision appropriate for the instrument:", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];

		(*output the test and rounded option*)
		{roundedValues, {roundingTest}}
	];

	(* -- DigestionAgents -- *)

	(* round the DigestionAgents amounts, which has the form {digestion agent, volume} *)
	{roundedDigestionAgents, digestionAgentsPrecisionTest}=Module[{originalValues, roundedValues, valueWasRounded, roundingTest},

		(* look up the unrounded value - convert the units so that when we round the units don't change *)
		originalValues=Lookup[microwaveDigestionOptionsAssociation, DigestionAgents] /. {x:VolumeP :> UnitConvert[x, Microliter]};

		(* round everything by substitution *)
		roundedValues=originalValues /. {x:VolumeP :> Round[x, 10^0 * Microliter]};

		(* compare to the original *)
		valueWasRounded=If[MatchQ[roundedValues, originalValues],
			False,
			True
		];

		(* warn the user if the DigestionMixRateProfile was rounded *)
		If[messages && Not[MatchQ[$ECLApplication, Engine]] && valueWasRounded,
			Message[Warning::DigestionAgentsPrecision, originalValues, roundedValues],
			Nothing
		];

		(* Define the tests the user will see for the above message *)
		roundingTest=If[gatherTests && MatchQ[originalValues, Except[Null]],
			Module[{failingTest, passingTest},
				failingTest=If[!valueWasRounded,
					Nothing,
					Warning["DigestionAgent volumes have been specified at a higher precision than can be executed by the instrument:", True, False]
				];
				passingTest=If[!valueWasRounded,
					Warning["DigestionAgent volumes have been specified at a precision appropriate for the instrument:", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];

		(*output the test and rounded option*)
		{roundedValues, {roundingTest}}
	];

	(* round the PressureVentingTriggers, which have the form of {pressure, number of ventings} *)
	{roundedPressureVentingTriggers, pressureVentingTriggersPrecisionTest}=Module[{originalValues, roundedValues, valueWasRounded, roundingTest},

		(* look up the unrounded value - convert the units so that when we round the units don't change *)
		originalValues=Lookup[microwaveDigestionOptionsAssociation, PressureVentingTriggers];

		(* round everything by substitution *)
		roundedValues=originalValues /. {x:PressureP :> Round[x, 10^0 * PSI]};

		(* compare to the original *)
		valueWasRounded=If[MatchQ[roundedValues, originalValues],
			False,
			True
		];

		(* warn the user if the PressureVentingTriggers was rounded *)
		If[messages && Not[MatchQ[$ECLApplication, Engine]] && valueWasRounded,
			Message[Warning::PressureVentingTriggersPrecision, originalValues, roundedValues],
			Nothing
		];

		(* Define the tests the user will see for the above message *)
		roundingTest=If[gatherTests && MatchQ[originalValues, Except[Null]],
			Module[{failingTest, passingTest},
				failingTest=If[!valueWasRounded,
					Nothing,
					Warning["PressureVentingTriggers  have been specified at a higher precision than can be executed by the instrument:", True, False]
				];
				passingTest=If[!valueWasRounded,
					Warning["PressureVentingTriggers have been specified at a precision appropriate for the instrument:", True, True],
					Nothing
				];
				{failingTest, passingTest}
			],
			Nothing
		];

		(*output the test and rounded option*)
		{roundedValues, {roundingTest}}
	];


	(* combine the RoundOptionPrecision rounded options with the custom rounded option values *)
	roundedOptions=Association @@ ReplaceRule[
		Normal[roundedGeneralOptions],
		Flatten[
			{
				SampleAmount -> roundedSampleAmounts,
				DigestionTemperatureProfile -> roundedDigestionTemperatureProfiles,
				DigestionMixRateProfile -> roundedDigestionMixRateProfile,
				DigestionAgents -> roundedDigestionAgents,
				PressureVentingTriggers -> roundedPressureVentingTriggers
			}
		]
	];

	(* ------------------------------- *)
	(* -- LOOK UP THE OPTION VALUES -- *)
	(* ------------------------------- *)

	(* look up the non index matched options *)
	{
		instrument
	}=Lookup[roundedOptions,
		{
			Instrument
		}
	];

	(* -- bad instrument check -- *)

	(* make sure we are checking the instrument model *)
	instrumentModel=If[MatchQ[instrument, ObjectP[Model[Instrument, Reactor, Microwave]]],
		instrument,
		Download[fastAssocLookup[fastAssoc, instrument, {Model}], Object]
	];

	(*pull out the types of reactions this model is intended for, this experiment supports Digestion *)
	instrumentReactorConditions=fastAssocLookup[fastAssoc, instrumentModel, {ReactorConditions}];

	(* check if the reactor conditions include digestion *)
	invalidInstrumentOptions=If[MemberQ[instrumentReactorConditions, Digestion],
		{},
		{Instrument}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[invalidInstrumentOptions] > 0 && !gatherTests,
		Message[Error::MicrowaveDigestionInvalidInstrument, ObjectToString[instrument, Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidInstrumentTest=If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest=If[MatchQ[Length[invalidInstrumentOptions], GreaterP[0]],
				Test["The instrument "<>ObjectToString[instrument, Simulation -> updatedSimulation]<>" can be used for this experiment:", True, False],
				Nothing
			];

			passingTest=If[MatchQ[Length[invalidInstrumentOptions], 0],
				Test["The instrument "<>ObjectToString[instrument, Simulation -> updatedSimulation]<>" can be used for this experiment:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* --------------------------- *)
	(*-- INPUT VALIDATION CHECKS --*)
	(* --------------------------- *)

	(* -- Compatible Materials Check -- *)

	(* get the boolean for any incompatible materials *)
	{compatibleMaterialsBool, compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument, simulatedSamples, Simulation -> updatedSimulation,Output -> {Result, Tests}],
		{CompatibleMaterialsQ[instrument, simulatedSamples, Simulation -> updatedSimulation,Messages -> messages], {}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidInputs=If[Not[compatibleMaterialsBool] && messages,
		Download[mySamples, Object],
		{}
	];


	(* -- Discarded Samples check -- *)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && !gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest=If[MatchQ[Length[discardedInvalidInputs], 0],
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]<>" are not discarded:", True, False]
			];

			passingTest=If[MatchQ[Length[discardedInvalidInputs], Length[mySamples]],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples, discardedInvalidInputs], Simulation -> updatedSimulation]<>" are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Check if the input samples have Deprecated inputs --- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	modelPacketsToCheckIfDeprecated=Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedModelPackets=Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	deprecatedInvalidInputs=If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
		(
			Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
			Lookup[deprecatedModelPackets, Object, {}]
		),
		Lookup[deprecatedModelPackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest=If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest=If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models "<>ObjectToString[deprecatedInvalidInputs, Simulation -> updatedSimulation]<>" that are not deprecated:", True, False]
			];

			passingTest=If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models "<>ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Simulation -> updatedSimulation]<>" that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* -- SAMPLES IN STORAGE CONDITION -- *)


	(* determine if incompatible storage conditions have been specified for samples in the same container *)
	samplesInStorageCondition=Lookup[roundedOptions, SamplesInStorageCondition];

	(* this will throw warnings if needed *)
	{validSamplesInStorageConditionBools, validSamplesInStorageConditionTests}=Quiet[
		If[gatherTests,
			ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> {Result, Tests}, Cache -> newCache,Simulation -> updatedSimulation],
			{ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> Result, Cache -> newCache,Simulation -> updatedSimulation], {}}
		],
		Download::MissingCacheField
	];

	(* convert to a single boolean *)
	validSamplesInStorageBool=And @@ ToList[validSamplesInStorageConditionBools];

	(* collect the bad option to add to invalid options later *)
	invalidSamplesInStorageConditionOption=If[MatchQ[validSamplesInStorageBool, False],
		{SamplesInStorageCondition},
		{}
	];


	(* -- TooMany Samples check -- *)

	(* Get the samples beyond index 24. *)
	overflowSamplePackets=If[MatchQ[Length[Flatten[samplePackets]], GreaterP[24]],
		Flatten[samplePackets][[24;;]],
		{}
	];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	overflowInvalidInputs=If[MatchQ[overflowSamplePackets, {}],
		{},
		Lookup[overflowSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[overflowInvalidInputs] > 0 && !gatherTests,
		Message[Error::MicrowaveDigestionTooManySamples, ObjectToString[overflowInvalidInputs, Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManySamplesTest=If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest=If[MatchQ[Length[overflowInvalidInputs], 0],
				Nothing,
				Test["The input samples "<>ObjectToString[overflowInvalidInputs, Simulation -> updatedSimulation]<>" can be measured along with the other input samples:", True, False]
			];

			passingTest=If[MatchQ[Length[overflowInvalidInputs], Length[mySamples]],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySamples, overflowInvalidInputs], Simulation -> updatedSimulation]<>" can be measured along with the other input samples:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* define the acid patterns *)
	digestionAcidIdentityModelP=Alternatives @@ Map[
		ObjectP[#]&, {
			Model[Molecule, "Sulfuric acid"],
			Model[Molecule, "Hydrochloric Acid"],
			Model[Molecule, "Phosphoric Acid"],
			Model[Molecule, "Hydrogen Peroxide"],
			Model[Molecule, "Nitric Acid"]
		}
	];

	(* =============== *)
	(* == MAPTHREAD == *)
	(* =============== *)

	(*MapThreadFriendlyOptions have the Key value pairs expanded to index match, such that if you call Lookup[options, OptionName], it gives the Option value at the index we are interested in*)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMicrowaveDigestion, roundedOptions];

	(* the output will be an association of the form <| OptionName -> resolvedOptionValue |> so that it is easy to look up at the end *)
	(* the error trackers will come out the same way as <| |> *)

	{resolvedMapThreadOptionsAssociations, mapThreadErrorCheckingAssociations}=Transpose[
		MapThread[
			Function[{optionSet, sample},
				Module[
					{
						(* sample download *)
						sampleComposition, sampleVolume, sampleMass, sampleTabletBool, sampleState, sampleAcid,

						(* unresolved options *)
						diluent, outputAliquot, diluteOutputAliquot, diluentVolume, targetDilutionVolume, containerOut,
						sampleAmount, sampleType, crushSample, preDigestionMix, preDigestionMixTime, preDigestionMixRate, preparedSample, digestionAgents,
						digestionTemperature, digestionDuration, digestionRampDuration, digestionTemperatureProfile, dilutionFactor,
						digestionMaxPower, digestionMaxPressure, pressureVenting, targetPressureReduction, pressureVentingTriggers, digestionMixRateProfile,

						(* resolved options *)
						resolvedSampleType, resolvedCrushSample, resolvedSampleAmount, resolvedPreDigestionMix, resolvedDiluent, resolvedOutputAliquot,
						resolvedDiluteOutputAliquot, resolvedDiluentVolume, resolvedContainerOut, resolvedPreDigestionMixTime, resolvedPreDigestionMixRate,
						resolvedPreparedSample, resolvedDigestionAgents, resolvedDigestionTemperature, resolvedDigestionDuration,
						resolvedDigestionRampDuration, resolvedDigestionTemperatureProfile, resolvedDigestionMaxPower,
						resolvedPressureVenting, resolvedTargetPressureReduction, resolvedPressureVentingTriggers, resolvedDilutionFactor,

						(* other helper variables *)
						computedSampleType, calculatedPreparedSample, computedDigestionAgentVolume, computedSampleAmount,sampleOutFakeModel,
						estimatedReactionVolume, formattedTemperatureProfile, totalDigestionTime, totalDilutionVolume, totalReactionVolume,

						(* -- error tracking booleans -- *)

						(* grouped error trackers *)
						samplePrepErrorTrackers, digestionAgentErrorTrackers, digestionConditionsErrorTrackers, pressureVentingErrorTrackers, workupErrorTrackers,

						(* sample prep *)
						computedSampleTypeMisMatchBool, sampleCannotBeCrushedBool, uncrushedTabletBool,
						noPreDigestionMixBool, missingPreDigestionMixTimeBool, unusedPreDigestionMixTimeBool, unusedPreDigestionMixRateBool, missingPreDigestionMixRateBool,
						(* digestion and sample identity *)
						noDigestionAgentBool, noSolventBool, possiblePreparedSampleBool, missingDigestionAgentBool, unusedDigestionAgentBool, aquaRegiaGenerationBool,
						sampleHasBannedAcidsBool,
						(* digestion conditions *)
						missingDigestionTemperatureBool, conflictingDigestionTemperatureBool, missingDigestionDurationBool, conflictingDigestionDurationBool, missingDigestionRampDurationBool, conflictingDigestionRampDurationBool,
						rapidRampRateBool, temperatureProfileWithCoolingBool, timePointSwappedBool, missingDigestionProfileBool,
						misMatchReactionLengthBool, missingMixingProfileBool,
						(* presure venting *)
						noPressureVentingBool, missingTargetPressureReductionBool, missingPressureVentingTriggersBool, unusedTargetPressureReductionBool, unusedPressureVentingProfileBool,
						missingRequiredVentingBool, missingRecommendedVentingBool, excessiveVentingCyclesBool, unsafeOrganicVentingBool, largePressureReductionBool,
						(* workup and output *)
						unusedDiluentBool, missingDiluentBool, missingDiluentVolumeBool, unusedDiluentVolumeBool, largeVolumeDilutionBool, largeVolumeConcAcidBool,
						incompatibleContainerOutBool, dilutionIsLessThanAliquotBool, outputAliquotExceedsReactionVolumeBool, conflictDilutionBool,

						(* extra error trackers *)
						temperatureProfileStartsAboveAmbientBool,

						(* -- output -- *)
						allResolvedOptions, allMapThreadErrorTrackers, allOptionsWithResolvedOptions
					},

					(* general sample download *)

					{
						sampleComposition,
						sampleVolume,
						sampleMass,
						sampleTabletBool,
						sampleState,
						sampleAcid
					}= Lookup[
						fetchPacketFromFastAssoc[sample,fastAssoc],
						{
							Composition,
							Volume,
							Mass,
							Tablet,
							State,
							Acid
						}
					];
					(* -- Unresolved Option lookup -- *)

					(* look up the sample prep options *)
					{
						sampleAmount,
						sampleType,
						crushSample,
						preDigestionMix,
						preDigestionMixTime,
						preDigestionMixRate,
						preparedSample,
						digestionAgents
					}=Lookup[optionSet,
						{
							SampleAmount,
							SampleType,
							CrushSample,
							PreDigestionMix,
							PreDigestionMixTime,
							PreDigestionMixRate,
							PreparedSample,
							DigestionAgents
						}
					];

					(* look up the digestion parameters *)
					{
						digestionTemperature,
						digestionDuration,
						digestionRampDuration,
						digestionTemperatureProfile,
						digestionMaxPower,
						digestionMaxPressure,
						pressureVenting,
						targetPressureReduction,
						pressureVentingTriggers,
						digestionMixRateProfile
					}=Lookup[optionSet,
						{
							DigestionTemperature,
							DigestionDuration,
							DigestionRampDuration,
							DigestionTemperatureProfile,
							DigestionMaxPower,
							DigestionMaxPressure,
							PressureVenting,
							TargetPressureReduction,
							PressureVentingTriggers,
							DigestionMixRateProfile
						}
					];

					(* look up the out put dilution parameters *)
					{
						diluent,
						outputAliquot,
						diluteOutputAliquot,
						diluentVolume,
						dilutionFactor,
						targetDilutionVolume,
						containerOut
					}=Lookup[optionSet,
						{
							Diluent,
							OutputAliquot,
							DiluteOutputAliquot,
							DiluentVolume,
							DilutionFactor,
							TargetDilutionVolume,
							ContainerOut
						}
					];

					(* ----------------------- *)
					(* -- OPTION RESOLUTION -- *)
					(* ----------------------- *)

					(* ------------------------------------- *)
					(* -- DIGESTION PARAMETERS RESOLUTION -- *)
					(* ------------------------------------- *)

					(* -- SampleType resolution -- *)

					(* resolve the sample type based on the Tablet field and the composition of the sample in *)
					computedSampleType=If[MatchQ[sampleTabletBool, True],
						Tablet,
						Organic
					];

					(* resolve the sample type based on if it is a tablet or not *)
					(* TODO: may want to put a little more effort into this to determine Organic vs inorganic *)
					resolvedSampleType=sampleType /. {Automatic -> computedSampleType};

					(* -- CrushSample resolution -- *)

					(* if the sample is a tablet, resolve it to True so that the tablet will have a better chance of dissolving *)
					resolvedCrushSample=If[MatchQ[resolvedSampleType, Tablet],
						crushSample /. Automatic -> True,
						crushSample /. Automatic -> False
					];


					(* -- resolve PreDigestionMix -- *)

					(* unless the user has specifically set these both to Null, resolve this to True *)
					resolvedPreDigestionMix=If[MemberQ[{preDigestionMixTime, preDigestionMixRate}, Except[Null]],
						preDigestionMix /. Automatic -> True,

						(* if the sample is not liquid, we will resolve this to True and throw errors. If they really don't want mixing prior to digestion, they can specify this False *)
						If[MatchQ[sampleState, Except[Liquid]],
							preDigestionMix /. Automatic -> True,
							preDigestionMix /. Automatic -> False
						]
					];

					(* -- resolve PreDigestionMixRate -- *)

					(* if the master switch is True, set the rate to Medium. Whatever that means. *)
					resolvedPreDigestionMixRate=If[MatchQ[resolvedPreDigestionMix, True],
						preDigestionMixRate /. Automatic -> Medium,
						preDigestionMixRate /. Automatic -> Null
					];

					(* -- resolve PreDigestionMixTime -- *)

					(* if the master switch is True, set the tiem to the max value allowable (2 min) *)
					resolvedPreDigestionMixTime=If[MatchQ[resolvedPreDigestionMix, True],
						preDigestionMixTime /. Automatic -> 2 Minute,
						preDigestionMixTime /. Automatic -> Null
					];

					(* -- resolve PreparedSample -- *)

					(* The sample is prepared if (1) it is a liquid and (2) it contains any of the digestion acids *)
					(*TODO: need to update this pattern so this will actually work ever*)
					calculatedPreparedSample=If[MatchQ[sampleState, Liquid] && MemberQ[ToList[sampleComposition[[All, 2]]], digestionAcidIdentityModelP],
						True,
						False
					];

					(* set PreparedSample to match what we think it should be *)
					resolvedPreparedSample=preparedSample /. {Automatic -> calculatedPreparedSample};

					(* -- resolve SampleAmount -- *)
					computedSampleAmount=
						Which[

							(*prepared samples will use the minimum allowable sample volume*)
							MatchQ[resolvedPreparedSample, True] && MatchQ[sampleState, Liquid],
							minSampleVolume,

							(* this is an error state since prepared samples must be solid so we will set it to something safe *)
							MatchQ[resolvedPreparedSample, True] && MatchQ[sampleState, Solid],
							1 Milligram,

							(* default sample volume *)
							MatchQ[resolvedPreparedSample, False] && MatchQ[sampleState, Liquid],
							100 Microliter,

							(* default sample mass *)
							MatchQ[resolvedPreparedSample, False] && MatchQ[sampleState, Solid],
							100 Milligram,

							(* should not ever happen, but mass will be safe *)
							True,
							100 Milligram
						];

					(* resolve the SampleAmount based on our calculations/defaults above *)
					resolvedSampleAmount=sampleAmount /. Automatic -> computedSampleAmount;


					(* -- resolve DigestionAgents -- *)

					(* determine the best volume to use *)
					computedDigestionAgentVolume=Module[
						{unitlessSampleAmount},

						(* convert everything to mL or grams and strip units. We make a loose approximation that a gram of material in solution will add 1 mL of volume. Its not great but it should prevent overfilling the tube.*)
						unitlessSampleAmount=Unitless[resolvedSampleAmount /. {x:VolumeP :> UnitConvert[x, Milliliter], y:MassP :> UnitConvert[y, Gram]}];

						(* determine the amount of solvent needed to achieve reasonable volumes and concentrations *)
						If[MatchQ[resolvedPreparedSample, False],

							(* if the sampel is not prepared, we need to calcaulte the amoutn of digestion agent that will be used *)
							Switch[unitlessSampleAmount,

								(* very small samples will use the minimum volume of digestion agents *)
								LessP[0.05],
								5 Milliliter,

								(*small volumes will be made up to 10 mg/mL concentration*)
								RangeP[0.05, 0.19],
								unitlessSampleAmount * 100 Milliliter,

								(* if the mass is greater than that, we will try to put as much digestion agent in as possible but no promises *)
								GreaterP[0.19],
								(20 - unitlessSampleAmount) * Milliliter
							],

							(* if the sample is prepared, we will not add digestion agent to it anyway *)
							Null
						]
					];

					(*TODO: update this with the actual default solutions that we are using*)
					(* use the default ratio and volumes of digestion agents for the compound type *)
					resolvedDigestionAgents=If[MatchQ[digestionAgents, Automatic],

						(*determine the best digestion agents to use*)
						If[MatchQ[resolvedPreparedSample, False],
							Switch[
								resolvedSampleType,

								(* organic  - use H2O2 for better oxidation*)
								Organic,
								{
									{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], SafeRound[computedDigestionAgentVolume * 0.9, 10^-1, AvoidZero -> True]},
									{Model[Sample, "Hydrogen Peroxide 30% for ultratrace analysis"], SafeRound[computedDigestionAgentVolume * 0.1, 10^-1, AvoidZero -> True]}
								},

								(*inorganic - use HCl for halide salt solublity*)
								Inorganic,
								{
									{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], SafeRound[computedDigestionAgentVolume * 0.9, 10^-1, AvoidZero -> True]},
									{Model[Sample, "Hydrochloric Acid 37%, (TraceMetal Grade)"], SafeRound[computedDigestionAgentVolume * 0.1, 10^-1, AvoidZero -> True]}
								},

								(*tablet - to be treated as a mixture of both inorganic and organic samples*)
								Tablet,
								{
									{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], SafeRound[computedDigestionAgentVolume * 0.8, 10^-1, AvoidZero -> True]},
									{Model[Sample, "Hydrogen Peroxide 30% for ultratrace analysis"], SafeRound[computedDigestionAgentVolume * 0.1, 10^-1, AvoidZero -> True]},
									{Model[Sample, "Hydrochloric Acid 37%, (TraceMetal Grade)"], SafeRound[computedDigestionAgentVolume * 0.1, 10^-1, AvoidZero -> True]}
								},
								(* Biological - to be treated similiarly compared to organic *)

								Biological,
								{
									{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], SafeRound[computedDigestionAgentVolume * 0.9, 10^-1, AvoidZero -> True]},
									{Model[Sample, "Hydrogen Peroxide 30% for ultratrace analysis"], SafeRound[computedDigestionAgentVolume * 0.1, 10^-1, AvoidZero -> True]}
								}
							],
							Null
						],

						(*user specified*)
						digestionAgents
					];

					(* ------------------------------------- *)
					(* -- DIGESTION PARAMETERS RESOLUTION -- *)
					(* ------------------------------------- *)

					(* -- Temperature Profile -- *)

					(* the first choice is to use Temperature, Duration, RampDuration, so if Profile is Autoamtic, set these *)
					(* set the DigestionTemperature if there is no DigestionTemperatureProfile *)
					resolvedDigestionTemperature=If[MatchQ[digestionTemperatureProfile, (Automatic | Null)],
						If[MatchQ[resolvedSampleType, Inorganic],
							digestionTemperature /. Automatic -> 300 Celsius,
							digestionTemperature /. Automatic -> 200 Celsius
						],
						digestionTemperature /. Automatic -> Null
					];

					(* set the DigestionDuration if there is no DigestionTemperatureProfile *)
					resolvedDigestionDuration=If[MatchQ[digestionTemperatureProfile, (Automatic | Null)],
						digestionDuration /. Automatic -> 10 Minute,
						digestionDuration /. Automatic -> Null
					];

					(*Set the RampDuration if the TemperatureProfile is Null, base the value on a ~40 C/min ramp rate *)
					resolvedDigestionRampDuration=If[MatchQ[digestionTemperatureProfile, (Automatic | Null)],
						Module[{safeRate},
							(* determine what duration would equate to 40 C/min starting from ambient temp of ~20 C *)
							safeRate=((resolvedDigestionTemperature /. {Null -> 200 * Celsius}) - 20 * Celsius) / (40 * Celsius / Minute);

							(* st the safe ramp rate *)
							digestionRampDuration /. Automatic -> safeRate
						],
						digestionRampDuration /. Automatic -> Null
					];

					(* set the DigestionTemperatureProfile if none of the other parameters are specified *)
					resolvedDigestionTemperatureProfile=If[MemberQ[{resolvedDigestionDuration, resolvedDigestionTemperature, resolvedDigestionRampDuration}, Except[Null]],
						digestionTemperatureProfile /. Automatic -> Null,

						(* organics are heated to a slightly lower temperature *)
						Switch[resolvedSampleType,

							(Organic | Tablet | Biological),
							digestionTemperatureProfile /. {Automatic -> {{4.5 Minute, 200 Celsius}, {14.5 Minute, 200 Celsius}}},

							Inorganic,
							digestionTemperatureProfile /. {Automatic -> {{7 Minute, 300 Celsius}, {17 Minute, 300 Celsius}}}
						]
					];

					(* -- MaxPower -- *)

					resolvedDigestionMaxPower=If[MatchQ[resolvedSampleType, Organic|Biological],
						digestionMaxPower /. Automatic -> 200 Watt,
						digestionMaxPower /. Automatic -> 300 Watt
					];

					(* ---------------------- *)
					(* -- Pressure Venting -- *)
					(* ---------------------- *)

					(* if the options under the master switch are not both intentionally Nulled, resolve to True *)
					(* if the sample is organic, we will set this to True and deal with the conflicts downstream. *)
					resolvedPressureVenting=If[
						Or[
							MemberQ[{pressureVentingTriggers, targetPressureReduction}, Except[Null]],
							MatchQ[resolvedSampleType, (Organic | Tablet | Biological)]
						],
						pressureVenting /. Automatic -> True,
						pressureVenting /. Automatic -> False
					];

					(* if the master switch is True, resolve the PressureReductionTarget based on the sampleType *)
					resolvedTargetPressureReduction=If[MatchQ[resolvedPressureVenting, True],
						If[MatchQ[resolvedSampleType, (Organic | Tablet | Biological)],
							targetPressureReduction /. Automatic -> 25 PSI,
							targetPressureReduction /. Automatic -> 40 PSI
						],
						targetPressureReduction /. Automatic -> Null
					];

					(* if the master switch is True, resolve the PressureVentingTriggers based on the sampleType *)
					resolvedPressureVentingTriggers=If[MatchQ[resolvedPressureVenting, True],
						If[MatchQ[resolvedSampleType, (Organic | Tablet | Biological)],
							pressureVentingTriggers /. Automatic -> {{50 PSI, 2}, {225 PSI, 2}, {250 PSI, 2}, {275 PSI, 2}, {300 PSI, 2}, {350 PSI, 100}},
							pressureVentingTriggers /. Automatic -> {{50 PSI, 2}, {400 PSI, 100}}
						],
						pressureVentingTriggers /. Automatic -> Null
					];

					(* -------------------- *)
					(* -- Output Aliquot -- *)
					(* -------------------- *)

					(* resolve the diluteOutputAliquot master switch based on the values of the things it controls *)
					resolvedDiluteOutputAliquot=If[MemberQ[{diluent, diluentVolume, dilutionFactor, targetDilutionVolume}, Except[Null]],
						diluteOutputAliquot /. {Automatic -> True},
						diluteOutputAliquot /. {Automatic -> False}
					];

					(* if we are doing dilutions, select milli-q water to dilute with *)
					resolvedDiluent=If[MatchQ[resolvedDiluteOutputAliquot, True],
						diluent /. Automatic -> Model[Sample, "Milli-Q water"],
						diluent /. Automatic -> Null
					];

					(* Diluent volume - No resolution needed *)
					resolvedDiluentVolume=diluentVolume;

					(* Dilution factor *)
					resolvedDilutionFactor = Which[
						(* If dilution factor is specified or set to Null, keep it as is *)
						!MatchQ[dilutionFactor, Automatic], dilutionFactor,
						(* Otherwise, if DiluentVolume is specified, set to Null *)
						!NullQ[resolvedDiluentVolume], Null,
						(* Otherwise, if TargetDilutionVolume is specified, set to Null *)
						!NullQ[targetDilutionVolume], Null,
						(* Otherwise, if DilutedOutputAliquot is set to False, set to Null *)
						!resolvedDiluteOutputAliquot, Null,
						(* Otherwise, set to 5 *)
						True, 5
					];

					(*determine the reaction volume, assuming that 1 g of solid will increase the volume by 1 mL. Not great, I know.*)
					estimatedReactionVolume=Total[
						Flatten[
							{
								(resolvedDigestionAgents /. Null -> {{Null, 0 Milliliter}})[[All, 2]],
								(Unitless[resolvedSampleAmount /. {x:MassP :> UnitConvert[x, Gram], y:VolumeP :> UnitConvert[y, Milliliter]}]) * Milliliter
							}
						]
					];

					(* resolve the amount of aliquot that will actually ne used as output. The rest is discarded. *)
					(* this serves two purpose:
           (1) avoid storing large quantities of concentrated acid mixtures that are highly corrosive and potentially generate gas
           (2) avoid making large dilutions of ~1 L or so
           *)
					resolvedOutputAliquot=If[MatchQ[resolvedDiluteOutputAliquot, True],
						(* if the output is diluted, determine the appropriate amount to grab *)

						Switch[{resolvedDiluentVolume, resolvedDilutionFactor, targetDilutionVolume},

							(* if they gave a volume, just use the whole sample even if it exceeds 1 L total volume *)
							{VolumeP, _, _},
							outputAliquot /. Automatic -> All,

							{_, _?NumericQ, _},
							Module[{scalingFactor, volumeForFullDilution},

								(* the total volume if we were to dilute the entire sample using the requested dilution factor *)
								volumeForFullDilution=estimatedReactionVolume * resolvedDilutionFactor;

								(* determine how to scale the dilution so that it is not absurdly large *)
								scalingFactor=If[MatchQ[volumeForFullDilution, LessEqualP[1 Liter]],
									1,
									volumeForFullDilution / (1 * Liter)
								];

								(* scale the output so that we can do the dilution and keep the volume under a liter *)
								(* this really should not come up, but if it does we want to be ready *)
								If[MatchQ[scalingFactor, 1],
									outputAliquot /. Automatic -> All,
									outputAliquot /. Automatic -> UnitConvert[(estimatedReactionVolume / scalingFactor), Milliliter]
								]
							],

							(* if they gave a target for fill to volume, check if the target is less than the total sample. If it is, only use the target volume *)
							{_, _, VolumeP},
							If[MatchQ[targetDilutionVolume, GreaterEqualP[estimatedReactionVolume]],
								outputAliquot /. Automatic -> All,
								outputAliquot /. Automatic -> UnitConvert[targetDilutionVolume, Milliliter]
							],

							(* if the DiluentAmount is Null, something else is wrong so set the volume to something safe.  *)
							{Null, Null, Null},
							outputAliquot /. Automatic -> All
						],

						(* if the output is not diluted, only take 1 Milliliter *)
						outputAliquot /. Automatic -> 1 Milliliter
					];

					(* compute the volumes so we can choose an appropriate container *)

					(* determine how much volume is in the tube *)
					totalReactionVolume=
						Plus[
							Unitless[resolvedSampleAmount /. {x:VolumeP :> UnitConvert[x, Milliliter], y:MassP :> UnitConvert[y, Gram]}] * Milliliter,
							computedDigestionAgentVolume /. {Null -> 0 Milliliter}
						];

					(* calculate the total volume *)
					totalDilutionVolume=If[MatchQ[resolvedDiluteOutputAliquot, True],

						Switch[{resolvedDiluentVolume, resolvedDilutionFactor, targetDilutionVolume},

							(* for a volume, just add *)
							{VolumeP, _, _},
							Plus[resolvedDiluentVolume, resolvedOutputAliquot /. {All -> totalReactionVolume}],

							(* for a dilution factor, multiply *)
							{_, _?NumericQ, _},
							Times[resolvedDilutionFactor, resolvedOutputAliquot /. {All -> totalReactionVolume}],

							(* fill to volume *)
							{_, _, VolumeP},
							targetDilutionVolume,

							(* something is very wrong and we are already going to throw errors so just return a safe value *)
							{_, _, _},
							totalReactionVolume
						],

						(* no dilutions -> we just need to hold however much of hte aliquot is taken out *)
						resolvedOutputAliquot /. {All -> totalReactionVolume}
					];

					(* -- Identify an output container -- *)
					(* use preferred containers to identify an appropriate container for the sample out. we want to leave a little head space in case there is an issue during the transfer *)
					resolvedContainerOut=containerOut/.{Automatic->PreferredContainer[Model[Sample, "id:qdkmxzqpeaRY"], 1.2 * totalDilutionVolume]};


					(* -------------------- *)
					(* -- Error Checking -- *)
					(* -------------------- *)


					(* -- Sample Prep -- *)

					(* if the computed and specified SampleType don't match, throw an error only when it is designated as a Tablet or not a Tablet incorrectly *)
					computedSampleTypeMisMatchBool=Which[
						MatchQ[sampleType, Tablet] && MatchQ[computedSampleType, (Organic | Inorganic)],
						True,

						MatchQ[sampleType, (Organic | Inorganic)] && MatchQ[computedSampleType, Tablet],
						True,

						True,
						False
					];

					(* if the sample is not a tablet but it is crushed, return True *)
					sampleCannotBeCrushedBool=If[MatchQ[resolvedSampleType, Except[Tablet]] && MatchQ[resolvedCrushSample, True],
						True,
						False
					];

					(* if the sample is a tablet and it is not crushed, also return True *)
					uncrushedTabletBool=If[MatchQ[resolvedSampleType, Tablet] && MatchQ[resolvedCrushSample, Except[True]],
						True,
						False
					];

					(* if the sample is a solid or tablet and there is no pre mixing, return True *)
					noPreDigestionMixBool=If[
						And[
							Or[
								MatchQ[sampleState, Solid],
								MatchQ[sampleTabletBool, True]
							],
							MatchQ[resolvedPreDigestionMix, False]
						],
						True,
						False
					];

					(* if the PreDigstionMixTime is required but not specified, return True *)
					missingPreDigestionMixTimeBool=If[And[MatchQ[resolvedPreDigestionMix, True], MatchQ[resolvedPreDigestionMixTime, Null]],
						True,
						False
					];

					(* if the PreDigstionMixTime is specified but not used, return True *)
					unusedPreDigestionMixTimeBool=If[And[MatchQ[resolvedPreDigestionMix, False], MatchQ[resolvedPreDigestionMixTime, Except[Null]]],
						True,
						False
					];

					(* if the PreDigstionMixRate is specified but not used, return True *)
					missingPreDigestionMixRateBool=If[And[MatchQ[resolvedPreDigestionMix, True], MatchQ[resolvedPreDigestionMixRate, Null]],
						True,
						False
					];

					(* if the PreDigstionMixRequired is required but not specified, return True *)
					unusedPreDigestionMixRateBool=If[And[MatchQ[resolvedPreDigestionMix, False], MatchQ[resolvedPreDigestionMixRate, Except[Null]]],
						True,
						False
					];

					samplePrepErrorTrackers={
						ComputedSampleTypeMisMatchBool -> computedSampleTypeMisMatchBool,
						SampleCannotBeCrushedBool -> sampleCannotBeCrushedBool,
						UncrushedTabletBool -> uncrushedTabletBool,
						NoPreDigestionMixBool -> noPreDigestionMixBool,
						MissingPreDigestionMixTimeBool -> missingPreDigestionMixTimeBool,
						UnusedPreDigestionMixTimeBool -> unusedPreDigestionMixTimeBool,
						UnusedPreDigestionMixRateBool -> unusedPreDigestionMixRateBool,
						MissingPreDigestionMixRateBool -> missingPreDigestionMixRateBool
					};

					(* -- Digestion Agents and Sample Identity  -- *)

					(* if the sample is not designated as prepared and it does not have digestion agents added, return True *)
					noDigestionAgentBool=If[MatchQ[resolvedDigestionAgents, Null] && MatchQ[resolvedPreparedSample, Except[True]],
						True,
						False
					];

					(* if the sample is desingated as prepared but is solid or tablet or only has no solvent, return True *)
					noSolventBool=Which[

						(* if it is not a prepared sample, it has solvent form the digestion agent or we have already thrown an error above *)
						MatchQ[resolvedPreparedSample, False],
						False,

						(* check if solid or liquid or tablet *)
						Or[MatchQ[sampleState, Solid], MatchQ[sampleTabletBool, True]],
						True,

						(* check the composition *)
						Or[MatchQ[Length[ToList[sampleComposition]], LessP[1]]],
						True
					];

					(* if the sample might be prepared but was marked as not prepared, we should warn them *)
					possiblePreparedSampleBool=Module[{components, containsAcidBool, digestionAgentIdentityModels},

						(* pull out the identity models that are in the composition field *)
						components=Download[sampleComposition[[All, 2]], Object];

						(*TODO: if this is needed anywhere else, it can be moved outside this module*)
						digestionAgentIdentityModels={
							Model[Molecule, "Sulfuric acid"],
							Model[Molecule, "Hydrochloric Acid"],
							Model[Molecule, "Phosphoric Acid"],
							Model[Molecule, "Hydrogen Peroxide"],
							Model[Molecule, "Nitric Acid"]
						};

						(* determine if any of the constituent molecules are members of the acid list *)
						containsAcidBool=Or @@ Map[MemberQ[digestionAgentIdentityModels, ObjectP[#]]&, components];

						(* throw this warning when we resolve to prepared sample. If they set it to True or False, do not warn *)
						(* TODO: is this a really over complicated check? *)
						If[MatchQ[preparedSample, Automatic] && MatchQ[resolvedPreparedSample, True] && containsAcidBool,
							True,
							False
						]
					];

					(* if the sample is not prepared and has no digestion agent, throw this error *)
					missingDigestionAgentBool=If[MatchQ[resolvedDigestionAgents, (Null | {})] && MatchQ[resolvedPreparedSample, False],
						True,
						False
					];

					(* if the sample is prepared, we don't use the digestion agents even if they are specified *)
					unusedDigestionAgentBool=If[MatchQ[resolvedDigestionAgents, Except[Null]] && MatchQ[resolvedPreparedSample, True],
						True,
						False
					];

					(* need to determien if they have generated aqua regia or similar OR they have somehow just provided undiluted aqua regia *)
					aquaRegiaGenerationBool=Module[
						{
							nitricDigestionAgent, hclDigestionAgent, otherDigestionAgents,
							totalVolume, otherDigestionAgentsVolume, nitricDigestionAgentVolume, hclDigestionAgentVolume,
							nitricToHClRatio, sampleIsAquaRegia, digestionAgentIsAquaRegia
						},

						(* if the sample is not prepared, check the digestion agent *)
						If[MatchQ[resolvedPreparedSample, False] && MatchQ[resolvedDigestionAgents, Except[Null]],
							(* identify the HNO3 and HCl amounts if they are there  *)
							nitricDigestionAgent=Cases[ToList[resolvedDigestionAgents], {ObjectP[Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"]], _}];
							hclDigestionAgent=Cases[ToList[resolvedDigestionAgents], {ObjectP[Model[Sample, "Hydrochloric Acid 37%, (TraceMetal Grade)"]], _}];

							(* also pull out other components *)
							otherDigestionAgents=Complement[ToList[resolvedDigestionAgents], Join[nitricDigestionAgent, hclDigestionAgent]];

							(* get the total volume *)
							totalVolume=If[MatchQ[resolvedDigestionAgents, Except[Null]],
								Total[resolvedDigestionAgents[[All, 2]]],
								Null
							];

							(* calculate the volumes *)
							{otherDigestionAgentsVolume, nitricDigestionAgentVolume, hclDigestionAgentVolume}=Map[
								If[MatchQ[#, Except[{}]],
									Total[#[[All, 2]]],
									Null
								]&,
								{otherDigestionAgents, nitricDigestionAgent, hclDigestionAgent}
							];

							(* calculate the ratio of HCl to Nitric *)
							nitricToHClRatio=If[!MemberQ[{nitricDigestionAgentVolume, hclDigestionAgentVolume}, Null],
								nitricDigestionAgentVolume / hclDigestionAgentVolume,
								Null
							];

							(* if they are combined in a 3:1 ratio (say between a 2.5 and 3.5) *)
							digestionAgentIsAquaRegia=Which[

								(* return false if the digestion agents don't include HNO3 and HCl *)
								MemberQ[{nitricDigestionAgent, hclDigestionAgent}, {}],
								False,

								(* check if there are other components that make up over 20 % of the solution volume *)
								MatchQ[otherDigestionAgentsVolume, Except[Null]],
								If[MatchQ[otherDigestionAgentsVolume / totalVolume, GreaterEqualP[0.2]],
									False,

									(* check if there is aqua regia as the other component *)
									If[MatchQ[nitricToHClRatio, RangeP[2.5, 3.5]],
										True,
										False
									]
								],

								(* there are not other components. check just for aqua regia *)
								MatchQ[otherDigestionAgentsVolume, Null],
								(* check if there is aqua regia as the other component *)
								If[MatchQ[nitricToHClRatio, RangeP[2.5, 3.5]],
									True,
									False
								]
							],

							(* if there is no digestion agent added, skip this *)
							digestionAgentIsAquaRegia=False
						];

						(* check if the sample is aqua regia, only if the sample is prepared *)
						sampleIsAquaRegia=If[MatchQ[resolvedPreparedSample, True],
							And[sampleIsAquaRegiaQ[sampleComposition], MatchQ[resolvedDigestionAgents, Null]],
							False
						];

						(*TODO: should really do a simulation of the composition - scale compositions by volume, total components, then check*)

						Or[sampleIsAquaRegia, digestionAgentIsAquaRegia]
					];

					(* Check for HF or Perchloric acid in the composition - these are currently banned for this experiment *)
					sampleHasBannedAcidsBool=If[MemberQ[sampleComposition[[All, 2]], Alternatives[ObjectP[Model[Molecule, "Hydrofluoric acid"]], ObjectP[Model[Molecule, "Perchloric Acid"]]]],
						True,
						False
					];

					(* collect all the error trackign booleans for digestion agent/prepared sample/aqua regia *)
					digestionAgentErrorTrackers={
						NoDigestionAgentBool -> noDigestionAgentBool,
						NoSolventBool -> noSolventBool,
						PossiblePreparedSampleBool -> possiblePreparedSampleBool,
						MissingDigestionAgentBool -> missingDigestionAgentBool,
						UnusedDigestionAgentBool -> unusedDigestionAgentBool,
						AquaRegiaGenerationBool -> aquaRegiaGenerationBool,
						SampleHasBannedAcidsBool -> sampleHasBannedAcidsBool
					};


					(* -- Digestion Conditions -- *)

					(* check if the digestion temperature is not specified when DigestionTemperatureProfile is Null *)
					missingDigestionTemperatureBool=If[MatchQ[resolvedDigestionTemperature, Null] && MatchQ[resolvedDigestionTemperatureProfile, Null],
						True,
						False
					];

					(* check if the digestion temperature is set and the DigestionTemperatureProfile is aslo set *)
					conflictingDigestionTemperatureBool=If[MatchQ[resolvedDigestionTemperature, Except[Null]] && MatchQ[resolvedDigestionTemperatureProfile, Except[Null]],
						True,
						False
					];

					(* do the same checks for the duration *)
					missingDigestionDurationBool=If[MatchQ[resolvedDigestionDuration, Null] && MatchQ[resolvedDigestionTemperatureProfile, Null],
						True,
						False
					];
					conflictingDigestionDurationBool=If[MatchQ[resolvedDigestionDuration, Except[Null]] && MatchQ[resolvedDigestionTemperatureProfile, Except[Null]],
						True,
						False
					];

					(* do the same checks for the ramp duration *)
					missingDigestionRampDurationBool=If[MatchQ[resolvedDigestionRampDuration, Null] && MatchQ[resolvedDigestionTemperatureProfile, Null],
						True,
						False
					];
					conflictingDigestionRampDurationBool=If[MatchQ[resolvedDigestionRampDuration, Except[Null]] && MatchQ[resolvedDigestionTemperatureProfile, Except[Null]],
						True,
						False
					];

					(* clean up the temperature profile *)
					formattedTemperatureProfile=If[MatchQ[resolvedDigestionTemperatureProfile, Except[Null]],

						(* if there a valid temp profile, make sure there is a zero time point to check our ramp and cooling *)
						If[MatchQ[Cases[resolvedDigestionTemperatureProfile, {EqualP[0 Minute], _}], {}],
							Prepend[resolvedDigestionTemperatureProfile, {0 Minute, $AmbientTemperature}],
							resolvedDigestionTemperatureProfile
						],
						Null
					];

					(* check if the time points are in ascending order, if not we're not going to figure out what they mean because more than likely they made a typo *)
					timePointSwappedBool=If[MatchQ[formattedTemperatureProfile, Except[Null]],
						If[MatchQ[Sort[formattedTemperatureProfile[[All, 1]]], formattedTemperatureProfile[[All, 1]]],
							False,
							True
						],
						False
					];

					(* compute the total digestion time - make sure to compute the timePointSwappedBool first*)
					totalDigestionTime=Which[

						(* use the digestion profile *)
						MatchQ[resolvedDigestionTemperatureProfile, Except[Null]] && MatchQ[timePointSwappedBool, False],
						Max[resolvedDigestionTemperatureProfile[[All, 1]]],

						(* sum the times if they are specified *)
						MatchQ[{resolvedDigestionDuration, resolvedDigestionRampDuration}, {Except[Null], Except[Null]}],
						Plus[resolvedDigestionDuration, resolvedDigestionRampDuration],

						(* there are other errors so just set it really high so that no further error are thrown *)
						True,
						10000 Minute
					];

					(* to check if there is cooling - only check for this if the time points are in order *)
					temperatureProfileWithCoolingBool=If[MatchQ[formattedTemperatureProfile, Except[Null]] && MatchQ[timePointSwappedBool, False],
						If[MatchQ[Sort[formattedTemperatureProfile[[All, 2]]], formattedTemperatureProfile[[All, 2]]],
							False,
							True
						],
						False
					];

					(* check that the starting point, if specified, is ambient. There is no ability ot pre-heat or cool the sample here *)
					temperatureProfileStartsAboveAmbientBool=If[
						MemberQ[formattedTemperatureProfile, {EqualP[0 Minute], Except[EqualP[$AmbientTemperature]]}],
						True,
						False
					];


					(* if there is no digestion profile whatsoever we weren't even able to use helpful errors and need the nuclear option *)
					missingDigestionProfileBool=If[MatchQ[
						{
							resolvedDigestionTemperature,
							resolvedDigestionDuration,
							resolvedDigestionRampDuration,
							resolvedDigestionTemperatureProfile
						},
						ConstantArray[Null, 4]
					],
						True,
						False
					];

					(* only do this check if there is a valid profile, so look for the other error tracking booleans first *)
					rapidRampRateBool=Which[

						(* skip this error checking since the profile is not good anyway *)
						Or[
							temperatureProfileWithCoolingBool,
							timePointSwappedBool,
							missingDigestionProfileBool,
							conflictingDigestionRampDurationBool,
							missingDigestionRampDurationBool,
							conflictingDigestionDurationBool,
							missingDigestionDurationBool,
							conflictingDigestionTemperatureBool,
							missingDigestionTemperatureBool
						],
						False,


						(* do the error check - we know that there is a ramp rate *)
						MatchQ[resolvedDigestionRampDuration, Except[Null]] && MatchQ[resolvedDigestionTemperature, Except[Null]],
						If[MatchQ[(resolvedDigestionTemperature - $AmbientTemperature) / resolvedDigestionRampDuration, GreaterP[50 Celsius / Minute]],
							True,
							False
						],

						(* do the error check with the profile *)
						MatchQ[formattedTemperatureProfile, Except[Null]],
						Module[{rampDurations, temperatureDiffs, rampRates, rapidRampRates},

							(* get the ramp durations from the prodile *)
							rampDurations=Rest[formattedTemperatureProfile][[All, 1]] - Most[formattedTemperatureProfile][[All, 1]];

							(* get the temperature diffs from the profile *)
							temperatureDiffs=Rest[formattedTemperatureProfile][[All, 2]] - Most[formattedTemperatureProfile][[All, 2]];

							(* divide to get the ramp rate *)
							rampRates=(temperatureDiffs / rampDurations);
							rapidRampRates=Cases[rampRates, GreaterP[50 Celsius / Minute]];

							(* rapidRampRates *)
							If[MatchQ[rapidRampRates, Except[{}]],
								True,
								False
							]
						],

						(* if we somehow got though here something else is really wrong and we should for sure skip this check *)
						True,
						False
					];




					(* -- Mixing Errors -- *)

					(* check that if the digestion mixing is done by a profile, it is consistant with total digestion time *)
					misMatchReactionLengthBool=If[MatchQ[digestionMixRateProfile, _List],
						If[MatchQ[Max[digestionMixRateProfile[[All, 1]]], GreaterP[totalDigestionTime]],
							True,
							False
						],
						False
					];

					(* TODO: consider setting this to AllowNull -> False? *)
					(* check that the mixing profile is specified *)
					missingMixingProfileBool=If[MatchQ[digestionMixRateProfile, Null],
						True,
						False
					];


					(* collect all the error trakign booleans for Digestion conditions *)
					digestionConditionsErrorTrackers={
						MissingDigestionTemperatureBool -> missingDigestionTemperatureBool,
						ConflictingDigestionTemperatureBool -> conflictingDigestionTemperatureBool,
						MissingDigestionDurationBool -> missingDigestionDurationBool,
						ConflictingDigestionDurationBool -> conflictingDigestionDurationBool,
						MissingDigestionRampDurationBool -> missingDigestionRampDurationBool,
						ConflictingDigestionRampDurationBool -> conflictingDigestionRampDurationBool,
						RapidRampRateBool -> rapidRampRateBool,
						TemperatureProfileWithCoolingBool -> temperatureProfileWithCoolingBool,
						TimePointSwappedBool -> timePointSwappedBool,
						MissingDigestionProfileBool -> missingDigestionProfileBool,
						MisMatchReactionLengthBool -> misMatchReactionLengthBool,
						MissingMixingProfileBool -> missingMixingProfileBool,
						TemperatureProfileStartsAboveAmbientBool -> temperatureProfileStartsAboveAmbientBool
					};

					(* -- Pressure Venting -- *)

					(* check if there is pressure venting specified *)
					noPressureVentingBool=If[MatchQ[resolvedPressureVenting, False],
						True,
						False
					];

					(* check if the TargetpressureReduction is missing *)
					missingTargetPressureReductionBool=If[MatchQ[resolvedPressureVenting, True] && MatchQ[resolvedTargetPressureReduction, Null],
						True,
						False
					];

					(* check if the PressureVentingTriggers are missing *)
					missingPressureVentingTriggersBool=If[MatchQ[resolvedPressureVenting, True] && MatchQ[resolvedPressureVentingTriggers, Null],
						True,
						False
					];

					(* check if TargetPressureReduction is informed bu unused *)
					unusedTargetPressureReductionBool=If[MatchQ[resolvedPressureVenting, False] && MatchQ[resolvedTargetPressureReduction, Except[Null]],
						True,
						False
					];

					(* check if Pressureventingprofile is indormed but not used *)
					unusedPressureVentingProfileBool=If[MatchQ[resolvedPressureVenting, False] && MatchQ[resolvedPressureVentingTriggers, Except[Null]],
						True,
						False
					];


					(* check if the sample is organic and if pressure venting is going to happen *)
					missingRequiredVentingBool=If[MatchQ[resolvedPressureVenting, False] && MatchQ[resolvedSampleType, Organic|Biological],
						True,
						False
					];

					(* check if the sample is inorganic or tablet and if pressure venting is going to happen. *)
					missingRecommendedVentingBool=If[MatchQ[resolvedPressureVenting, False] && MatchQ[resolvedSampleType, (Inorganic | Tablet)],
						True,
						False
					];

					(* check that the amount of venting is not likely to lead to sample evaporation/loss - I set a limit based on default methods to 150 total cycles.
          That will almost certainly significantly reduce the reaction vessel volume and risk evaporation/heating of a dry sample *)
					excessiveVentingCyclesBool=If[MatchQ[resolvedPressureVentingTriggers, Except[Null]],
						If[MatchQ[Total[resolvedPressureVentingTriggers[[All, 2]]], GreaterP[150]],
							True,
							False
						],
						False
					];

					(* organics must be vented more frequently and should have at least one vent below 100 PSI an done above 300 PSI *)
					unsafeOrganicVentingBool=If[MatchQ[resolvedPressureVentingTriggers, Except[Null]],
						If[MemberQ[resolvedPressureVentingTriggers[[All, 1]], LessP[100 PSI]] && MemberQ[resolvedPressureVentingTriggers[[All, 1]], GreaterEqualP[300 PSI]],
							False,
							True
						],
						False
					];

					(* if the sample pressure reduciton is greater than 50 PSI, it is never going to work and might cause excessive venting *)
					largePressureReductionBool=If[MatchQ[resolvedTargetPressureReduction, GreaterP[50 PSI]],
						True,
						False
					];

					(* collect the pressure Venting related error tracking booleans *)
					pressureVentingErrorTrackers={
						NoPressureVentingBool -> noPressureVentingBool,
						MissingTargetPressureReductionBool -> missingTargetPressureReductionBool,
						MissingPressureVentingTriggersBool -> missingPressureVentingTriggersBool,
						UnusedTargetPressureReductionBool -> unusedTargetPressureReductionBool,
						UnusedPressureVentingProfileBool -> unusedPressureVentingProfileBool,
						MissingRequiredVentingBool -> missingRequiredVentingBool,
						MissingRecommendedVentingBool -> missingRecommendedVentingBool,
						ExcessiveVentingCyclesBool -> excessiveVentingCyclesBool,
						UnsafeOrganicVentingBool -> unsafeOrganicVentingBool,
						LargePressureReductionBool -> largePressureReductionBool
					};

					(* -- Workup and Output -- *)

					(* check if there is an unused diluent specified *)
					unusedDiluentBool=If[MatchQ[resolvedDiluteOutputAliquot, False] && MatchQ[resolvedDiluent, Except[Null]],
						True,
						False
					];

					(* check if we are doing dilutions but they Nulled the Diluent option *)
					missingDiluentBool=If[MatchQ[resolvedDiluteOutputAliquot, True] && MatchQ[resolvedDiluent, Null],
						True,
						False
					];

					(* check if we are doign dilutions but they Nulled the DiluentVolume, DilutionFactor and TargetDilutionFactor option *)
					missingDiluentVolumeBool=If[MatchQ[resolvedDiluteOutputAliquot, True] && MatchQ[resolvedDiluentVolume, Null] && MatchQ[resolvedDilutionFactor, Null] && MatchQ[targetDilutionVolume, Null],
						True,
						False
					];

					(* check if they specified a diluent volume but the master switch is off *)
					unusedDiluentVolumeBool=If[MatchQ[resolvedDiluteOutputAliquot, False] && Or[MatchQ[resolvedDiluentVolume, Except[Null]], MatchQ[resolvedDilutionFactor, Except[Null]], MatchQ[targetDilutionVolume, Except[Null]]],
						True,
						False
					];

					(* check if the dilution volume exceeds 1L, which is sort of our arbitrary upper bound on these dilutions *)
					largeVolumeDilutionBool=If[MatchQ[totalDilutionVolume, GreaterP[1 Liter]],
						True,
						False
					];

					(*TODO: there should be a more complicated tests here to verify that the sample is actually a concentrated mixed acid*)
					(* check if there is no dilution, and the output is not diluted *)
					(* for cases when we don't  *)
					largeVolumeConcAcidBool=And[
						MatchQ[resolvedDiluteOutputAliquot, False],
						MatchQ[resolvedOutputAliquot /. {All -> totalReactionVolume}, GreaterP[1 Milliliter]],
						(* if we are given prepared sample and it does not contain acids, do not error out - it is not a safety issue *)
						(* Note: we rely here that we are either given the sample straight or our PrepPrimitive simulation gave us correct safety flags *)
						Not[MatchQ[resolvedPreparedSample, True]&&!MatchQ[sampleAcid, True]]
					];

					(* check if the container is ok - for now the check is based on Nitric Acid, but this could change *)
					(*TODO: this should really look at the simulated composition of the sample out...DigestionAgents plus the sample in composiiton*)
					(* don't check if the container is Automatic since we already checked this above. Also the info is not in the cache so it will double download *)

					(* Depending on the dilution factor, assign a Model[Sample] for the output sample, for error checking purpose *)
					sampleOutFakeModel = Which[
						(* If the dilution factor is equal or greater than than 4, treat the final solution as 10% HNO3 *)
						TrueQ[resolvedDilutionFactor >= 4], Model[Sample, StockSolution, "10% Nitric Acid Solution"],
						(* If the resolvedDiluentVolume is equal or greater than than 80% total volume, treat the final solution as 10% HNO3 *)
						TrueQ[resolvedDiluentVolume >= estimatedReactionVolume*0.8], Model[Sample, StockSolution, "10% Nitric Acid Solution"],
						(* All other cases treat it as 70% HNO3 *)
						True, Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"]
					];

					incompatibleContainerOutBool=If[MatchQ[containerOut, Except[Automatic]],
						Module[{containerVolume, containerMaterials, incompatibleVolumeBool, incompatibleMaterialsBool},
							{containerVolume, containerMaterials}=Download[containerOut, {MaxVolume, ContainerMaterials}, Simulation -> updatedSimulation];

							(* check if the container is compatible with conc nitric acid - this could be more sophisticated in the future *)
							incompatibleMaterialsBool=If[MatchQ[Intersection[ToList[Download[sampleOutFakeModel, IncompatibleMaterials, Simulation -> updatedSimulation]], ToList[containerMaterials]], Except[{}]],
								True,
								False
							];

							(* check if the volume is too large *)
							incompatibleVolumeBool=If[MatchQ[containerVolume, LessP[totalDilutionVolume]],
								True,
								False
							];

							(* if either one is true, return True *)
							Or[incompatibleVolumeBool, incompatibleMaterialsBool]
						],
						False
					];

					(* check that output aliquot options have not requested more sample than there is. if the output aliquot is All, this will return False *)
					outputAliquotExceedsReactionVolumeBool=If[MatchQ[resolvedOutputAliquot, GreaterP[estimatedReactionVolume]],
						True,
						False
					];

					(* check that the dilution volume is smaller than the reaction volume *)
					dilutionIsLessThanAliquotBool=If[MatchQ[targetDilutionVolume, LessP[resolvedOutputAliquot]],
						True,
						False
					];

					(* Define an error checking Boolean here, which becomes True if more than 1 of the 3 is specified: *)
					(* DilutionFactor, DiluentVolume, TargetDilutionVolume *)
					conflictDilutionBool = Switch[{resolvedDiluentVolume, resolvedDilutionFactor, targetDilutionVolume},
						{_, _?NumericQ, VolumeP}, True,
						{VolumeP, _, VolumeP}, True,
						{VolumeP, _?NumericQ, _}, True,
						{_,_,_}, False
					];

					(* collect all the workup/output error tracking booleans *)
					workupErrorTrackers={
						UnusedDiluentBool -> unusedDiluentBool,
						MissingDiluentBool -> missingDiluentBool,
						MissingDiluentVolumeBool -> missingDiluentVolumeBool,
						UnusedDiluentVolumeBool -> unusedDiluentVolumeBool,
						LargeVolumeDilutionBool -> largeVolumeDilutionBool,
						LargeVolumeConcAcidBool -> largeVolumeConcAcidBool,
						IncompatibleContainerOutBool -> incompatibleContainerOutBool,
						DilutionIsLessThanAliquotBool -> dilutionIsLessThanAliquotBool,
						OutputAliquotExceedsReactionVolumeBool -> outputAliquotExceedsReactionVolumeBool,
						ConflictDilutionBool -> conflictDilutionBool
					};


					(* ------------------------------ *)
					(* -- Inside MapThread Cleanup -- *)
					(* ------------------------------ *)

					(* gather the resolved options and error tracking booleans *)
					allResolvedOptions=Flatten[{
						(* sample prep *)
						SampleType -> resolvedSampleType,
						SampleAmount -> resolvedSampleAmount,
						CrushSample -> resolvedCrushSample,
						PreDigestionMix -> resolvedPreDigestionMix,
						PreDigestionMixRate -> resolvedPreDigestionMixRate,
						PreDigestionMixTime -> resolvedPreDigestionMixTime,

						(* digestion agent prep *)
						PreparedSample -> resolvedPreparedSample,
						DigestionAgents -> resolvedDigestionAgents,

						(* digestion parameters *)
						DigestionDuration -> resolvedDigestionDuration,
						DigestionTemperature -> resolvedDigestionTemperature,
						DigestionRampDuration -> resolvedDigestionRampDuration,
						DigestionTemperatureProfile -> resolvedDigestionTemperatureProfile,
						PressureVenting -> resolvedPressureVenting,
						TargetPressureReduction -> resolvedTargetPressureReduction,
						PressureVentingTriggers -> resolvedPressureVentingTriggers,
						DigestionMaxPower -> resolvedDigestionMaxPower,

						(* output aliquotting *)
						ContainerOut -> resolvedContainerOut,
						DiluteOutputAliquot -> resolvedDiluteOutputAliquot,
						OutputAliquot -> resolvedOutputAliquot,
						Diluent -> resolvedDiluent,
						DiluentVolume -> resolvedDiluentVolume,
						DilutionFactor -> resolvedDilutionFactor
					}];


					(*this is causing non index matched options to be duplicated*)
					(* allOptionsWithResolvedOptions = Association@@ReplaceRule[Normal[optionSet], allResolvedOptions];*)
					allOptionsWithResolvedOptions=Association @@ allResolvedOptions;
					allMapThreadErrorTrackers=Association @@ Flatten[
						{
							samplePrepErrorTrackers,
							digestionAgentErrorTrackers,
							digestionConditionsErrorTrackers,
							pressureVentingErrorTrackers,
							workupErrorTrackers
						}
					];

					(* output the resolved option association and the error tracking booleans *)
					{allOptionsWithResolvedOptions, allMapThreadErrorTrackers}
				]
			],
			{mapThreadFriendlyOptions, simulatedSamples}
		]
	];



	(* ----------------------- *)
	(* -- MAPTHREAD CLEANUP -- *)
	(* ----------------------- *)

	(* note that this does not contain any of the non map thread options in it *)
	resolvedOptionsAssociation=Merge[resolvedMapThreadOptionsAssociations, Join];
	mapThreadErrorCheckingAssociation=Merge[mapThreadErrorCheckingAssociations, Join];


	(* ------------------------------ *)
	(* -- MAPTHREAD ERROR CHECKING -- *)
	(* ------------------------------ *)

	(* -- Extract bad packets -- *)
	(* look up the bad packets using the error trackers in the map thread association (like in RamanSpectroscopy) *)
	(* the look ups are split up for clarity and ease of maintenance *)

	(* sample prep *)
	{
		samplePacketsWithComputedSampleTypeMisMatch,
		samplePacketsWithSampleCannotBeCrushed,
		samplePacketsWithUncrushedTablet,
		samplePacketsWithNoPreDigestionMix,
		samplePacketsWithMissingPreDigestionMixTime,
		samplePacketsWithUnusedPreDigestionMixTime,
		samplePacketsWithUnusedPreDigestionMixRate,
		samplePacketsWithMissingPreDigestionMixRate
	}=Map[PickList[samplePackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				ComputedSampleTypeMisMatchBool,
				SampleCannotBeCrushedBool,
				UncrushedTabletBool,
				NoPreDigestionMixBool,
				MissingPreDigestionMixTimeBool,
				UnusedPreDigestionMixTimeBool,
				UnusedPreDigestionMixRateBool,
				MissingPreDigestionMixRateBool
			}
		]
	];

	(* digestion and sample identity *)
	{
		samplePacketsWithNoDigestionAgent,
		samplePacketsWithNoSolvent,
		samplePacketsWithPossiblePreparedSample,
		samplePacketsWithMissingDigestionAgent,
		samplePacketsWithUnusedDigestionAgent,
		samplePacketsWithAquaRegiaGeneration,
		samplePacketsWithBannedAcids
	}=Map[PickList[samplePackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				NoDigestionAgentBool,
				NoSolventBool,
				PossiblePreparedSampleBool,
				MissingDigestionAgentBool,
				UnusedDigestionAgentBool,
				AquaRegiaGenerationBool,
				SampleHasBannedAcidsBool
			}
		]
	];


	(* digestion conditions *)
	{
		samplePacketsWithMissingDigestionTemperature,
		samplePacketsWithConflictingDigestionTemperature,
		samplePacketsWithMissingDigestionDuration,
		samplePacketsWithConflictingDigestionDuration,
		samplePacketsWithMissingDigestionRampDuration,
		samplePacketsWithConflictingDigestionRampDuration,
		samplePacketsWithRapidRampRate,
		samplePacketsWithTemperatureProfileWithCooling,
		samplePacketsWithTimePointSwapped,
		samplePacketsWithMissingDigestionProfile,
		samplePacketsWithMisMatchReactionLength,
		samplePacketsWithMissingMixingProfile,
		samplePacketsWithAboveAmbientStartTemperature
	}=Map[PickList[samplePackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				MissingDigestionTemperatureBool,
				ConflictingDigestionTemperatureBool,
				MissingDigestionDurationBool,
				ConflictingDigestionDurationBool,
				MissingDigestionRampDurationBool,
				ConflictingDigestionRampDurationBool,
				RapidRampRateBool,
				TemperatureProfileWithCoolingBool,
				TimePointSwappedBool,
				MissingDigestionProfileBool,
				MisMatchReactionLengthBool,
				MissingMixingProfileBool,
				TemperatureProfileStartsAboveAmbientBool
			}
		]
	];


	(* venting *)
	{
		samplePacketsWithMissingTargetPressureReduction,
		samplePacketsWithMissingPressureVentingTriggers,
		samplePacketsWithUnusedTargetPressureReduction,
		samplePacketsWithUnusedPressureVentingProfile,
		samplePacketsWithMissingRequiredVenting,
		samplePacketsWithMissingRecommendedVenting,
		samplePacketsWithExcessiveVentingCycles,
		samplePacketsWithUnsafeOrganicVenting,
		samplePacketsWithLargePressureReduction
	}=Map[PickList[samplePackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				MissingTargetPressureReductionBool,
				MissingPressureVentingTriggersBool,
				UnusedTargetPressureReductionBool,
				UnusedPressureVentingProfileBool,
				MissingRequiredVentingBool,
				MissingRecommendedVentingBool,
				ExcessiveVentingCyclesBool,
				UnsafeOrganicVentingBool,
				LargePressureReductionBool
			}
		]
	];

	(* workup and output *)
	{
		samplePacketsWithUnusedDiluent,
		samplePacketsWithMissingDiluent,
		samplePacketsWithMissingDiluentVolume,
		samplePacketsWithUnusedDiluentVolume,
		samplePacketsWithLargeVolumeDilution,
		samplePacketsWithLargeVolumeConcAcid,
		samplePacketsWithIncompatibleContainerOut,
		samplePacketsWithDilutionLessThanAliquot,
		samplePacketsWithAliquotExceedsReactionVolume,
		samplePacketsWithConflictDilution
	}=Map[PickList[samplePackets, #]&,
		Lookup[mapThreadErrorCheckingAssociation,
			{
				UnusedDiluentBool,
				MissingDiluentBool,
				MissingDiluentVolumeBool,
				UnusedDiluentVolumeBool,
				LargeVolumeDilutionBool,
				LargeVolumeConcAcidBool,
				IncompatibleContainerOutBool,
				DilutionIsLessThanAliquotBool,
				OutputAliquotExceedsReactionVolumeBool,
				ConflictDilutionBool
			}
		]
	];


	(* -------------------------------------- *)
	(* -- MESSAGES, TESTS, INVALID OPTIONS -- *)
	(* -------------------------------------- *)

	(* -- Post MapThread InvalidInputs -- *)


	(* -- Sample amount check -- *)


	(*check in the sample packets where the volume or mass is too small*)
	(* note that for Tablets we aren't really going to worry since there will always be at least one tablet *)
	lowSampleVolumeBool=MapThread[
		MatchQ[Lookup[#1, Volume], LessP[#2]]&,
		{samplePackets, Lookup[resolvedOptionsAssociation, SampleAmount]}
	];
	lowSampleMassBool=MapThread[
		MatchQ[Lookup[#1, Mass], LessP[#2]]&,
		{samplePackets, Lookup[resolvedOptionsAssociation, SampleAmount]}
	];

	(*find the positions that are true for either*)
	lowSampleAmountBool=MapThread[Or, {lowSampleVolumeBool, lowSampleMassBool}];

	(*get the sample objects that are low volume*)
	lowSampleAmountPackets=PickList[samplePackets, lowSampleAmountBool, True];

	lowSampleAmountInputs=If[Length[lowSampleAmountPackets] > 0,
		Lookup[Flatten[lowSampleAmountPackets], Object],
		(* if there are no low quantity inputs, the list is empty *)
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[lowSampleAmountInputs] > 0 && !gatherTests,
		Message[Error::MicrowaveDigestionNotEnoughSample, ObjectToString[lowSampleAmountInputs, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	lowSampleVolumeTest=If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest=If[Length[lowSampleAmountInputs] == 0,
				(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all low volume quantity *)
				Test["The input sample(s) "<>ObjectToString[lowSampleAmountInputs, Simulation -> updatedSimulation]<>" have enough quantity for measurement:", True, False]
			];
			passingTest=If[Length[lowSampleAmountInputs] == Length[simulatedSamples],
				(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples, lowSampleAmountInputs], Simulation -> updatedSimulation]<>" have enough quantity for measurement:", True, True]
			];
			{failingTest, passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];



	(* -------- 1 ------ *)
	(* -- SAMPLE PREP -- *)
	(* -------- 1 ------ *)


	(* -- Throw the errors -- *)

	If[!MatchQ[samplePacketsWithComputedSampleTypeMisMatch, {}] && messages,
		Message[Error::MicrowaveDigestionComputedSampleTypeMisMatch, ObjectToString[samplePacketsWithComputedSampleTypeMisMatch, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithSampleCannotBeCrushed, {}] && messages,
		Message[Error::MicrowaveDigestionSampleCannotBeCrushed, ObjectToString[samplePacketsWithSampleCannotBeCrushed, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUncrushedTablet, {}] && messages && !MatchQ[$ECLApplication, Engine],
		Message[Warning::MicrowaveDigestionUncrushedTablet, ObjectToString[samplePacketsWithUncrushedTablet, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithNoPreDigestionMix, {}] && messages,
		Message[Error::MicrowaveDigestionNoPreDigestionMix, ObjectToString[samplePacketsWithNoPreDigestionMix, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingPreDigestionMixTime, {}] && messages,
		Message[Error::MicrowaveDigestionMissingPreDigestionMixTime, ObjectToString[samplePacketsWithMissingPreDigestionMixTime, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnusedPreDigestionMixTime, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedPreDigestionMixTime, ObjectToString[samplePacketsWithUnusedPreDigestionMixTime, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnusedPreDigestionMixRate, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedPreDigestionMixRate, ObjectToString[samplePacketsWithUnusedPreDigestionMixRate, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingPreDigestionMixRate, {}] && messages,
		Message[Error::MicrowaveDigestionMissingPreDigestionMixRate, ObjectToString[samplePacketsWithMissingPreDigestionMixRate, Simulation -> updatedSimulation]]];


	(* -- generate the tests -- *)

	(* make the tests for all of the sample prep error checkers*)
	samplePrepGroupedTests=MapThread[
		microwaveDigestionSampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithComputedSampleTypeMisMatch,
				samplePacketsWithSampleCannotBeCrushed,
				samplePacketsWithNoPreDigestionMix,
				samplePacketsWithMissingPreDigestionMixTime,
				samplePacketsWithUnusedPreDigestionMixTime,
				samplePacketsWithUnusedPreDigestionMixRate,
				samplePacketsWithMissingPreDigestionMixRate
			},
			{
				"When the SampleType is specified, it is consistant with the composition and physical state of the input sample `1`:",
				"When CrushSample is True, the sample to be crushed is a tablet for the input sample `1`:",
				"When a sample is a solid or tablet, PreDigestionMix is True for the input sample `1`:",
				"When PreDigestionMix is True, a PreDigestionMixTime is specified for the input sample `1`:",
				"When PreDigestionMix is False, no PreDigestionMixTime is specified for the input sample `1`:",
				"When PreDigestionMix is True, a PredigestionMixRate is specified for the input sample `1`:",
				"When PreDigestionMix is False, no PreDigestionMixRate is specified for the input sample `1`:"
			}
		}
	];

	(* generate the warning test for uncrushed tablets *)
	uncrushedTabletWarningTest=microwaveDigestionSampleTests[
		gatherTests,
		Warning,
		samplePackets,
		samplePacketsWithUncrushedTablet,
		"When the input is a Tablet, it is crushed prior to the addition of DigestionAgents for the input sample `1`:",
		newCache
	];


	(* -- collect invalid options -- *)

	(* gather the invalid options corresponding to the bad packets *)
	invalidSamplePrepOptions=PickList[
		{
			SampleType,
			CrushSample,
			PreDigestionMix,
			PreDigestionMixTime,
			PreDigestionMixTime,
			PreDigestionMixRate,
			PreDigestionMixRate
		},
		{
			samplePacketsWithComputedSampleTypeMisMatch,
			samplePacketsWithSampleCannotBeCrushed,
			samplePacketsWithNoPreDigestionMix,
			samplePacketsWithMissingPreDigestionMixTime,
			samplePacketsWithUnusedPreDigestionMixTime,
			samplePacketsWithUnusedPreDigestionMixRate,
			samplePacketsWithMissingPreDigestionMixRate
		},
		Except[{}]
	];




	(* ------------------ 2 --------------------- *)
	(* -- DIGESTION AGENT AND SAMPLE IDENTITY  -- *)
	(* ------------------ 2 --------------------- *)

	(* -- throw the errors -- *)

	If[!MatchQ[samplePacketsWithNoDigestionAgent, {}] && messages,
		Message[Error::MicrowaveDigestionNoDigestionAgent, ObjectToString[samplePacketsWithNoDigestionAgent, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithNoSolvent, {}] && messages,
		Message[Error::MicrowaveDigestionNoSolvent, ObjectToString[samplePacketsWithNoSolvent, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithPossiblePreparedSample, {}] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MicrowaveDigestionPossiblePreparedSample, ObjectToString[samplePacketsWithPossiblePreparedSample, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingDigestionAgent, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDigestionAgent, ObjectToString[samplePacketsWithMissingDigestionAgent, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnusedDigestionAgent, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedDigestionAgent, ObjectToString[samplePacketsWithUnusedDigestionAgent, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithAquaRegiaGeneration, {}] && messages,
		Message[Error::MicrowaveDigestionAquaRegiaGeneration, ObjectToString[samplePacketsWithAquaRegiaGeneration, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithBannedAcids, {}] && messages,
		Message[Error::MicrowaveDigestionBannedAcids, ObjectToString[samplePacketsWithBannedAcids, Simulation -> updatedSimulation]]];

	(* -- generate the tests -- *)

	(* make the tests for all of the CATEGORY error checkers*)
	digestionAgentGroupedTests=MapThread[
		microwaveDigestionSampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithNoDigestionAgent,
				samplePacketsWithNoSolvent,
				samplePacketsWithPossiblePreparedSample,
				samplePacketsWithMissingDigestionAgent,
				samplePacketsWithUnusedDigestionAgent,
				samplePacketsWithAquaRegiaGeneration,
				samplePacketsWithBannedAcids
			},
			{
				"When the PreparedSample is False, DigestionAgents are specified for the input sample `1`:",
				"When PreparedSample is True, the sample is not a solid or tablet for the input sample `1`:",
				"When the sample is liquid and contains digestion agents, PreparedSample -> True for the input sample `1`:" (*move to warnings*),
				"When the sample is not Prepared, DigestionAgents must be specified for the input sample `1`:" (*TODO: why is this here? maybe duplicate?*),
				"When PreparedSample -> True, DigestionAgents are not specified for the input sample `1`:",
				"When DigestionAgents are used, they do not result in the generation of aqua regia for the input sample `1`:",
				"When samples include acid in the composition, those acids do not include banned acids (HF and HClO4) for `1`"
			}
		}
	];


	(* -- collect invalid options -- *)
	(* gather the invalid options corresponding to the bad packets *)
	invalidDigestionAgentOptions=PickList[
		{
			DigestionAgents,
			{DigestionAgents, PreparedSample} (*TODO: this may need ot be thrown seperatly - it may be  aproblem with the sample *),
			DigestionAgents,
			DigestionAgents,
			DigestionAgents
		},
		{
			samplePacketsWithNoDigestionAgent,
			samplePacketsWithNoSolvent,
			samplePacketsWithMissingDigestionAgent,
			samplePacketsWithUnusedDigestionAgent,
			samplePacketsWithAquaRegiaGeneration
		},
		Except[{}]
	];

	(* if we find banned acids in the composition, return an invalid input *)
	bannedAcidInvalidInputs=If[MatchQ[samplePacketsWithBannedAcids, {}],
		{},
		Lookup[samplePacketsWithBannedAcids, Object]
	];



	(* ------------ 3 ----------- *)
	(* -- DIGESTION CONDITIONS -- *)
	(* ------------ 3 ----------- *)

	(* -- throw the errors -- *)

	If[!MatchQ[samplePacketsWithMissingDigestionTemperature, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDigestionTemperature, ObjectToString[samplePacketsWithMissingDigestionTemperature, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithConflictingDigestionTemperature, {}] && messages,
		Message[Error::MicrowaveDigestionConflictingDigestionTemperature, ObjectToString[samplePacketsWithConflictingDigestionTemperature, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingDigestionDuration, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDigestionDuration, ObjectToString[samplePacketsWithMissingDigestionDuration, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithConflictingDigestionDuration, {}] && messages,
		Message[Error::MicrowaveDigestionConflictingDigestionDuration, ObjectToString[samplePacketsWithConflictingDigestionDuration, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingDigestionRampDuration, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDigestionRampDuration, ObjectToString[samplePacketsWithMissingDigestionRampDuration, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithConflictingDigestionRampDuration, {}] && messages,
		Message[Error::MicrowaveDigestionConflictingDigestionRampDuration, ObjectToString[samplePacketsWithConflictingDigestionRampDuration, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithRapidRampRate, {}] && messages,
		Message[Error::MicrowaveDigestionRapidRampRate, ObjectToString[samplePacketsWithRapidRampRate, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithTemperatureProfileWithCooling, {}] && messages,
		Message[Error::MicrowaveDigestionTemperatureProfileWithCooling, ObjectToString[samplePacketsWithTemperatureProfileWithCooling, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithTimePointSwapped, {}] && messages,
		Message[Error::MicrowaveDigestionTimePointSwapped, ObjectToString[samplePacketsWithTimePointSwapped, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingDigestionProfile, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDigestionProfile, ObjectToString[samplePacketsWithMissingDigestionProfile, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMisMatchReactionLength, {}] && messages,
		Message[Error::MicrowaveDigestionMisMatchReactionLength, ObjectToString[samplePacketsWithMisMatchReactionLength, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingMixingProfile, {}] && messages,
		Message[Error::MicrowaveDigestionMissingMixingProfile, ObjectToString[samplePacketsWithMissingMixingProfile, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithAboveAmbientStartTemperature, {}] && messages,
		Message[Error::MicrowaveDigestionAboveAmbientInitialTemperature, ObjectToString[samplePacketsWithAboveAmbientStartTemperature, Simulation -> updatedSimulation]]];


	(* -- generate the tests -- *)

	(* make the tests for all of the digestion conditions error checkers*)
	digestionConditionsGroupedTests=MapThread[
		microwaveDigestionSampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithMissingDigestionTemperature,
				samplePacketsWithConflictingDigestionTemperature,
				samplePacketsWithMissingDigestionDuration,
				samplePacketsWithConflictingDigestionDuration,
				samplePacketsWithMissingDigestionRampDuration,
				samplePacketsWithConflictingDigestionRampDuration,
				samplePacketsWithRapidRampRate,
				samplePacketsWithTemperatureProfileWithCooling,
				samplePacketsWithTimePointSwapped,
				samplePacketsWithMissingDigestionProfile,
				samplePacketsWithMisMatchReactionLength,
				samplePacketsWithMissingMixingProfile,
				samplePacketsWithAboveAmbientStartTemperature
			},
			{
				"The DigestionTemperature is specified if required for the input sample `1`:",
				"The DigestionTemperature and DigestionTemperatureProfile are not both specified for the input sample `1`:",
				"The DigestionDuration is specified if required for the input sample `1`:",
				"The DigestionDuration and DigestionTemperatureProfile are not both specified for the input sample `1`:",
				"The DigestionRampDuration is specified if required for the input sample `1`:",
				"The DigestionRampDuration and DigestionTemperatureProfile are not both specified for the input sample `1`:",
				"The parameters for the heating profile do not result in a ramp rate exceeding 50 C/min for the input sample `1`:",
				"The parameters for the heating profile do not result in cooling segments for the input sample `1`:",
				"DigestionTemperatureProfile is provided in an unambiguous format for the input sample `1`:",
				"Some combination of options is given that results in a valid temperature profile for the input sample `1`:",
				"The DigestionMixProfile maximum time does not exceed that of the digestion temperature profile for the input sample `1`:",
				"The DigestionMixProfile is specified or resolvable for the input sample `1`:",
				"The starting temperature of the digestion is ambient for the input sample `1`:"
			}
		}
	];

	(* -- collect invalid options -- *)
	(* gather the invalid options corresponding to the bad packets *)
	invalidDigestionConditionOptions=PickList[
		{
			DigestionTemperature,
			DigestionTemperature,
			DigestionDuration,
			DigestionDuration,
			DigestionRampDuration,
			DigestionRampDuration,
			{DigestionTemperatureProfile, DigestionRampDuration},
			DigestionTemperatureProfile,
			DigestionTemperatureProfile,
			{DigestionTemperatureProfile, DigestionTemperature, DigestionDuration, DigestionRampDuration},
			DigestionMixingProfile,
			DigestionMixingProfile,
			DigestionTemperatureProfile
		},
		{
			samplePacketsWithMissingDigestionTemperature,
			samplePacketsWithConflictingDigestionTemperature,
			samplePacketsWithMissingDigestionDuration,
			samplePacketsWithConflictingDigestionDuration,
			samplePacketsWithMissingDigestionRampDuration,
			samplePacketsWithConflictingDigestionRampDuration,
			samplePacketsWithRapidRampRate,
			samplePacketsWithTemperatureProfileWithCooling,
			samplePacketsWithTimePointSwapped,
			samplePacketsWithMissingDigestionProfile,
			samplePacketsWithMisMatchReactionLength,
			samplePacketsWithMissingMixingProfile,
			samplePacketsWithAboveAmbientStartTemperature
		},
		Except[{}]
	];




	(* ----- 4 ----- *)
	(* -- VENTING -- *)
	(* ----- 4 ----- *)

	(* -- throw the errors -- *)



	If[!MatchQ[samplePacketsWithMissingTargetPressureReduction, {}] && messages,
		Message[Error::MicrowaveDigestionMissingTargetPressureReduction, ObjectToString[samplePacketsWithMissingTargetPressureReduction, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingPressureVentingTriggers, {}] && messages,
		Message[Error::MicrowaveDigestionMissingPressureVentingTriggers, ObjectToString[samplePacketsWithMissingPressureVentingTriggers, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnusedTargetPressureReduction, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedTargetPressureReduction, ObjectToString[samplePacketsWithUnusedTargetPressureReduction, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnusedPressureVentingProfile, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedPressureVentingProfile, ObjectToString[samplePacketsWithUnusedPressureVentingProfile, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingRequiredVenting, {}] && messages,
		Message[Error::MicrowaveDigestionMissingRequiredVenting, ObjectToString[samplePacketsWithMissingRequiredVenting, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingRecommendedVenting, {}] && messages && !MatchQ[$ECLApplication, Engine],
		Message[Warning::MicrowaveDigestionMissingRecommendedVenting, ObjectToString[samplePacketsWithMissingRecommendedVenting, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithExcessiveVentingCycles, {}] && messages,
		Message[Error::MicrowaveDigestionExcessiveVentingCycles, ObjectToString[samplePacketsWithExcessiveVentingCycles, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnsafeOrganicVenting, {}] && messages,
		Message[Error::MicrowaveDigestionUnsafeOrganicVenting, ObjectToString[samplePacketsWithUnsafeOrganicVenting, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithLargePressureReduction, {}] && messages,
		Message[Error::MicrowaveDigestionLargePressureReduction, ObjectToString[samplePacketsWithLargePressureReduction, Simulation -> updatedSimulation]]];


	(* -- generate the tests -- *)

	(* make the tests for all of the Venting error checkers*)
	ventingGroupedTests=MapThread[
		microwaveDigestionSampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithMissingTargetPressureReduction,
				samplePacketsWithMissingPressureVentingTriggers,
				samplePacketsWithUnusedTargetPressureReduction,
				samplePacketsWithUnusedPressureVentingProfile,
				samplePacketsWithMissingRequiredVenting,
				samplePacketsWithMissingRecommendedVenting,
				samplePacketsWithUnsafeOrganicVenting
			},
			{
				"When PressureVenting -> True, the TargetPressureReduction is not Null for `1`:",
				"When Pressureventing -> True, the PressureVentingTriggers option is valid for the input sample `1`:",
				"When PressureVenting -> False, TargetPressureReduction is not specified for the input sample `1`:",
				"When PressureVenting -> False, PressureVentingTriggers is not informed for the input sample `1`:",
				"When the sample is organic, the reaction vessel is vented for the input sample `1`:",
				"When the sample is inorganic, the reaction vessel is vented for the input sample `1`:",
				"When the sample is organic, the PressureVentingTriggers is appropriate for the input sample `1`:"
			}
		}
	];

	ventingGroupedWarningTests=MapThread[
		microwaveDigestionSampleTests[gatherTests,
			Warning,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithExcessiveVentingCycles,
				samplePacketsWithLargePressureReduction
			},
			{
				"When the PressureVenting is specified, it does not utilize an excessive number of venting cycles for the input sample `1`:",
				"When the TargetPressureReduction is specified it is of practical magnitude for the input sample `1`:"
			}
		}
	];

	(* -- collect invalid options -- *)
	(* gather the invalid options corresponding to the bad packets *)
	invalidVentingOptions=PickList[
		{
			TargetPressureReduction,
			PressureVentingTriggers,
			TargetPressureReduction,
			PressureVentingTriggers,
			PressureVenting,
			PressureVentingTriggers,
			PressureVentingTriggers,
			TargetPressureReduction
		},
		{
			samplePacketsWithMissingTargetPressureReduction,
			samplePacketsWithMissingPressureVentingTriggers,
			samplePacketsWithUnusedTargetPressureReduction,
			samplePacketsWithUnusedPressureVentingProfile,
			samplePacketsWithMissingRequiredVenting,
			samplePacketsWithExcessiveVentingCycles,
			samplePacketsWithUnsafeOrganicVenting,
			samplePacketsWithLargePressureReduction
		},
		Except[{}]
	];

	(* ---------- 5 ---------- *)
	(* -- WORKUP AND OUTPUT -- *)
	(* ---------- 5 ---------- *)

	(* -- throw the errors -- *)

	If[!MatchQ[samplePacketsWithUnusedDiluent, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedDiluent, ObjectToString[samplePacketsWithUnusedDiluent, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingDiluent, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDiluent, ObjectToString[samplePacketsWithMissingDiluent, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithMissingDiluentVolume, {}] && messages,
		Message[Error::MicrowaveDigestionMissingDiluentVolume, ObjectToString[samplePacketsWithMissingDiluentVolume, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithUnusedDiluentVolume, {}] && messages,
		Message[Error::MicrowaveDigestionUnusedDiluentVolume, ObjectToString[samplePacketsWithUnusedDiluentVolume, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithLargeVolumeDilution, {}] && messages,
		Message[Error::MicrowaveDigestionLargeVolumeDilution, ObjectToString[samplePacketsWithLargeVolumeDilution, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithLargeVolumeConcAcid, {}] && messages,
		Message[Error::MicrowaveDigestionLargeVolumeConcAcid, ObjectToString[samplePacketsWithLargeVolumeConcAcid, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithIncompatibleContainerOut, {}] && messages,
		Message[Error::MicrowaveDigestionIncompatibleContainerOut, ObjectToString[samplePacketsWithIncompatibleContainerOut, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithAliquotExceedsReactionVolume, {}] && messages,
		Message[Error::MicrowaveDigestionAliquotExceedsReactionVolume, ObjectToString[samplePacketsWithAliquotExceedsReactionVolume, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithDilutionLessThanAliquot, {}] && messages,
		Message[Error::MicrowaveDigestionDilutionLessThanAliquot, ObjectToString[samplePacketsWithDilutionLessThanAliquot, Simulation -> updatedSimulation]]];

	If[!MatchQ[samplePacketsWithConflictDilution, {}] && messages,
		Message[Error::MicrowaveDigestionConflictDilution, ObjectToString[samplePacketsWithConflictDilution, Simulation -> updatedSimulation]]];


	(* -- generate the tests -- *)

	(* make the tests for all of the workup and output error checkers*)
	workupGroupedTests=MapThread[
		microwaveDigestionSampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithUnusedDiluent,
				samplePacketsWithMissingDiluent,
				samplePacketsWithMissingDiluentVolume,
				samplePacketsWithUnusedDiluentVolume,
				samplePacketsWithLargeVolumeDilution,
				samplePacketsWithLargeVolumeConcAcid,
				samplePacketsWithIncompatibleContainerOut,
				samplePacketsWithAliquotExceedsReactionVolume,
				samplePacketsWithDilutionLessThanAliquot,
				samplePacketsWithConflictDilution
			},
			{
				"When DiluteOuputAliquot -> False, no Diluent is specified for the input sample `1`:",
				"When DiluteOutputAliquot -> True, a Diluent is specified for the input sample `1`:",
				"When DiluteOutputAliquot -> True, a DiluentVolume is specified for the input sample `1`:",
				"When DiluteOuputAliquot -> False, no DiluentVolume is specified for the input sample `1`:",
				"When DiluentVolume is specified, it does not result in a volume of greater than 1 Liter for input sample `1`:",
				"When the reaction mixture is a combination of concentrated acids and DiluteOutputAliquot -> False, the OutputAliquot does not exceed 1 mL for input sample `1`:",
				"When a ContainerOut is specified, it is compatible with the OutputAliquot or dilutions thereof for input sample `1`:",
				"When OutputAliquot is not All, it does not exceed the projected reaction volume for input sample `1`",
				"When TargetDilutionVolume is specified, it does not exceed the OutputAliquot for sample `1`",
				"At most 1 of the 3 following options: DilutionFactor, DiluentVolume, TargetDilutionVolume is specified for sample `1`"
			}
		}
	];

	(* -- collect invalid options -- *)
	(* gather the invalid options corresponding to the bad packets *)
	invalidWorkupOptions=PickList[
		{
			Diluent,
			Diluent,
			DiluentVolume,
			DiluentVolume,
			DiluentVolume,
			{OutputAliquot, DiluteOutputAliquot},
			ContainerOut,
			OutputAliquot,
			TargetDilutionVolume,
			{DilutionFactor, DiluentVolume, TargetDilutionVolume}
		},
		{
			samplePacketsWithUnusedDiluent,
			samplePacketsWithMissingDiluent,
			samplePacketsWithMissingDiluentVolume,
			samplePacketsWithUnusedDiluentVolume,
			samplePacketsWithLargeVolumeDilution,
			samplePacketsWithLargeVolumeConcAcid,
			samplePacketsWithIncompatibleContainerOut,
			samplePacketsWithAliquotExceedsReactionVolume,
			samplePacketsWithDilutionLessThanAliquot,
			samplePacketsWithConflictDilution
		},
		Except[{}]
	];


	(* -- PreparedSample x SampleAmount Check -- *)

	(* check that we have resolved to have enough of the solvent in the microwave reaction *)
	validTotalReactionVolume=MapThread[Function[{preparedSampleBool, sampleAmount, digestionAgents},
		If[
			(* If we're doing PreparedSample->True we aren't adding anything to the sample so the volume requested must be above the experiment min *)
			TrueQ[preparedSampleBool], safeVolumeConvert[sampleAmount]>=minSampleVolume,
			Total[safeVolumeConvert[Flatten[
				{
					(digestionAgents /. Null -> {{Null, 0 Milliliter}})[[All, 2]],
					(Unitless[sampleAmount /. {x:MassP :> UnitConvert[x, Gram], y:VolumeP :> UnitConvert[y, Milliliter]}]) * Milliliter
				}
			]]]>=minSampleVolume
		]],
		{
			Lookup[resolvedMapThreadOptionsAssociations,PreparedSample],
			Lookup[resolvedMapThreadOptionsAssociations,SampleAmount],
			Lookup[resolvedMapThreadOptionsAssociations,DigestionAgents]}
	];

	validTotalReactionVolumeBool=MatchQ[validTotalReactionVolume,{True..}];

	(* Prepare the test if requested *)
	invalidTotalReactionVolumeTest=If[!messages,
		Warning["Total of SampleAmount and DigestionAgents is above the minimum of "<>UnitForm[minSampleVolume,Brackets->False]<>" for all samples which are being used:",validTotalReactionVolumeBool,True],
		Null
	];

	(* If we have an error and we're generating messages, throw the message *)
	If[messages && !validTotalReactionVolumeBool,
		Message[Warning::InsufficientPreparedMicrowaveDigestionSample,minSampleVolume]
	];

	(* Track the option error *)
	invalidTotalReactionVolumeOptions=If[!validTotalReactionVolumeBool,
		{PreparedSample, DigestionAgents}
	];

	(* ------------------------ *)
	(* -- ALIQUOT RESOLUTION -- *)
	(* ------------------------ *)

	(* use the sample amount to determine how much sample is needed - add some padding for liquids and solids. Safe round for Aliquot precision *)
	bestAliquotAmount=Lookup[resolvedOptionsAssociation, SampleAmount] /. {x:MassP :> SafeRound[1.1 * x, 10^-1 Milligram], y:VolumeP :> SafeRound[1.1 * y, 10^-1 Microliter]};

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentMicrowaveDigestion,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions, resolvedSamplePrepOptions],
			Cache -> newCache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers -> Null,
			RequiredAliquotAmounts -> bestAliquotAmount,
			AllowSolids -> True,
			AliquotWarningMessage -> Null,
			Output -> {Result, Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMicrowaveDigestion,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				Cache -> newCache,
				Simulation->updatedSimulation,
				RequiredAliquotContainers -> Null,
				RequiredAliquotAmounts -> bestAliquotAmount,
				AliquotWarningMessage -> Null,
				AllowSolids -> True,
				Output -> Result
			],
			{}
		}
	];

	(* --- Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["microwave digestion sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[object, Object]], _String],
					LookupObjectLabel[simulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[roundedOptions, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["microwave digestion sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[object, Object]], _String],
					LookupObjectLabel[simulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[roundedOptions , SampleContainerLabel]}
		]
	];

	resolvedSampleOutLabel=Map[
		If[MatchQ[#,Automatic],
			CreateUniqueLabel["microwave digestion sample out"],
			#
		]&,
		Lookup[roundedOptions , SampleOutLabel]
	];

	resolvedLabelingOptions={
		SampleLabel->resolvedSampleLabel,
		SampleContainerLabel->resolvedSampleContainerLabel,
		SampleOutLabel->resolvedSampleOutLabel
	};


	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	(* gather the invalid inputs *)
	invalidInputs=DeleteDuplicates[Flatten[{
		compatibleMaterialsInvalidInputs,
		deprecatedInvalidInputs,
		discardedInvalidInputs,
		bannedAcidInvalidInputs,
		lowSampleAmountInputs,
		overflowInvalidInputs
	}]];


	(* gather the invalid options *)
	invalidOptions=DeleteCases[
		DeleteDuplicates[
			Flatten[
				{
					(* invalid options from map thread *)
					invalidWorkupOptions,
					invalidVentingOptions,
					invalidDigestionConditionOptions,
					invalidDigestionAgentOptions,
					invalidSamplePrepOptions,
					invalidInstrumentOptions
				}
			]
		],
		Null
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Simulation -> updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];

	microwaveDigestionTests=Cases[Flatten[
		{
			deprecatedTest,
			discardedTest,
			compatibleMaterialsTests,
			lowSampleVolumeTest,
			tooManySamplesTest,

			(* rounding tests *)
			precisionTests,
			digestionTemperatureProfilesPrecisionTest,
			digestionMixRateProfilePrecisionTest,
			digestionAgentsPrecisionTest,
			pressureVentingTriggersPrecisionTest,
			sampleAmountPrecisionTest,

			(*storage condition tests*)
			validSamplesInStorageConditionTests,

			(* invalid option tests from map thread *)
			workupGroupedTests,
			ventingGroupedTests,
			digestionConditionsGroupedTests,
			digestionAgentGroupedTests,
			samplePrepGroupedTests,
			invalidInstrumentTest,

			(* warnings *)
			ventingGroupedWarningTests,
			uncrushedTabletWarningTest,

			(* post-resolution checks *)
			invalidTotalReactionVolumeTest
		}
	], _EmeraldTest];

	(* ------------------------ *)
	(* --- RESOLVED OPTIONS --- *)
	(* ------------------------ *)

	(* gather the resolved options for output *)
	resolvedOptions=
		ReplaceRule[
			Normal[roundedOptions],
			Flatten[
				{
					(* -- map thread resolved options -- *)
					Normal[resolvedOptionsAssociation],

					(* --- pass through and other resolved options ---- *)
					resolvedSamplePrepOptions,
					resolvedAliquotOptions,
					resolvedPostProcessingOptions,
					resolvedLabelingOptions
				}
			]
		] /. x:ObjectP[] :> Download[x, Object];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> microwaveDigestionTests
	}
];


(* ::Subsubsection::Closed:: *)
(* microwaveDigestionResourcePackets *)


(* ====================== *)
(* == RESOURCE PACKETS == *)
(* ====================== *)

DefineOptions[microwaveDigestionResourcePackets,
	Options :> {
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

microwaveDigestionResourcePackets[
	mySamples:{ObjectP[Object[Sample]]..},
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myCollapsedResolvedOptions:{___Rule},
	myOptions:OptionsPattern[]
]:=Module[
	{
		(* general variables *)
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, simulation,
		gatherTests, messages, cache, acidsCache, graduatedCylinderDownload, unitOperationPacket, groupedOptions, unGroupedOptions,

		(* resolved option values *)
		instrument, sampleType, sampleAmount, crushSample, samplesInStorage, aliquotAmount,
		preDigestionMix, preDigestionMixTime, preDigestionMixRate,
		digestionAgents, preparedSample, digestionTemperature, digestionDuration, digestionRampDuration, digestionTemperatureProfile,
		digestionMixRateProfile, digestionMaxPower, digestionMaxPressure,
		pressureVenting, pressureVentingTriggers, targetPressureReduction,
		diluent, diluentVolume, targetDilutionVolume, outputAliquot, diluteOutputAliquot, containerOut,
		sampleLabel, sampleContainerLabel, sampleOutLabel, dilutionFactor,

		(*download*)
		listedSamplePackets, graduatedCylinderPackets, myGraduatedCylinders,nitric, sulfuric, hcl, phosphoric, peroxide, water,fastAssoc,

		(* variables for condensed option fields in protocol *)
		composedPreDigestionMixParameters, composedDigestionProfiles, composedOutputAliquot, composedDigestionRunTimes, composedPressureVentingParameters,
		composedOutputAliquotDilutions, estimatedReactionVolumes, composedDigestionAgents,
		resourcedOutputAliquotDilutions, resourcedPressureVentingParameters, resourcedDigestionProfile, composedGlassware, placements,

		(* samples in resources *)
		expandedAliquotAmount, sampleResourceAmount, pairedSamplesInAndAmounts,
		sampleAmountRules, sampleResourceReplaceRules, samplesInResources, linkedSampleResourceReplaceRules,

		(* other resources *)
		reactionVesselResources, stirBarResource, reactionVesselCapResources,
		tweezerResource, instrumentResource,
		digestionAgentResourceAmount, digestionAgentAmountRules, digestionAgentResourceReplaceRules, digestionAgentResources,
		quenchSolutionResources, quenchContainerResource, containerOutResources,
		diluentResourceRules, diluentVolumeRules, composedDiluents, resourcedDigestionAgents, quenchDiluentResource,
		stirBarRetriever, workSurface, rackResources,

		(* time estimates *)
		totalReactionTime, samplePrepTime, computedQuenchVolume, resourcePickingEstimate, neutralizationTime,
		samplesWithoutLinks, numberOfReplicates, samplesWithReplicates, optionsWithReplicates,
		protocolPacket, allResourceBlobs, fulfillable, frqTests, resultRule, testsRule,
		rawSampleAmount, solidUnitWeights, protocolPacketMinusRequiredObjects
	},

	(* --------------------------- *)
	(*-- SETUP OPTIONS AND CACHE --*)
	(* --------------------------- *)

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentMicrowaveDigestion, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentMicrowaveDigestion,
		RemoveHiddenOptions[ExperimentMicrowaveDigestion, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[microwaveDigestionResourcePackets, ToList[myOptions]];

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output, Tests];
	messages=Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Cases[Lookup[safeOps, Cache], PacketP[]];
	simulation = Lookup[safeOps, Simulation];

	(* Get rid of the links in mySamples. *)
	samplesWithoutLinks = mySamples /. x:ObjectP[] :> Download[x, Object];

	(* Get our number of replicates. *)
	numberOfReplicates=Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(*Get our instrument*)
	instrument=Lookup[myResolvedOptions, Instrument];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates, optionsWithReplicates}=expandNumberOfReplicates[ExperimentMicrowaveDigestion, samplesWithoutLinks, myResolvedOptions];

	{nitric, sulfuric, hcl, phosphoric, peroxide, water} = Download[
		{
			Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"],
			Model[Sample, "Sulfuric Acid 96% (TraceMetal Grade)"],
			Model[Sample, "Hydrochloric Acid 37%, (TraceMetal Grade)"],
			Model[Sample, "Phosphoric Acid 85% (>99.999% trace metals basis)"],
			Model[Sample, "Hydrogen Peroxide 30% for ultratrace analysis"],
			Model[Sample, "Milli-Q water"]
		},
		Object
	];

	(* -- LOOKUP TABLE FOR ACIDS -- *)
	acidsCache=<|
		nitric -> <|MassPercent -> 70 Percent, Density -> 1.4 Gram / Milliliter, Molecule -> Model[Molecule, "Nitric Acid"], MolecularWeight -> 63 Gram / Mole, AcidicProtons -> 2|>,
		sulfuric -> <|MassPercent -> 96 Percent, Density -> 1.84 Gram / Milliliter, Molecule -> Model[Molecule, "Sulfuric acid"], MolecularWeight -> 98 Gram / Mole, AcidicProtons -> 2|>,
		hcl -> <|MassPercent -> 37 Percent, Density -> 1.18 Gram / Milliliter, Molecule -> Model[Molecule, "Hydrochloric Acid"], MolecularWeight -> 36.5 Gram / Mole, AcidicProtons -> 1|>,
		phosphoric -> <|MassPercent -> 85 Percent, Density -> 1.685 Gram / Milliliter, Molecule -> Model[Molecule, "Phosphoric Acid"], MolecularWeight -> 98 Gram / Mole, AcidicProtons -> 3|>,
		peroxide -> <|MassPercent -> 30 Percent, Density -> 1.11 Gram / Milliliter, Molecule -> Model[Molecule, "Hydrogen Peroxide"], MolecularWeight -> 34 Gram / Mole, AcidicProtons -> 0|>,
		water -> <|MassPercent -> 100 Percent, Density -> 1.0 Gram / Milliliter, Molecule -> Model[Molecule, "Water"], MolecularWeight -> 18 Gram / Mole, AcidicProtons -> 0|>
	|>;

	(* ------------------- *)
	(* -- OPTION LOOKUP -- *)
	(* ------------------- *)

	(* split the lookup by category for readability *)

	(* GENERAL OPTIONS *)
	{
		instrument,
		sampleType,
		rawSampleAmount,
		crushSample,
		samplesInStorage,
		aliquotAmount,
		preDigestionMix,
		preDigestionMixTime,
		preDigestionMixRate,
		sampleLabel,
		sampleContainerLabel,
		sampleOutLabel
	}=Lookup[optionsWithReplicates,
		{
			Instrument,
			SampleType,
			SampleAmount,
			CrushSample,
			SamplesInStorageCondition,
			AliquotAmount,
			PreDigestionMix,
			PreDigestionMixTime,
			PreDigestionMixRate,
			SampleLabel,
			SampleContainerLabel,
			SampleOutLabel
		}
	];

	(* DIGESTION AGENTS *)
	{
		digestionAgents,
		preparedSample
	}=Lookup[optionsWithReplicates,
		{
			DigestionAgents,
			PreparedSample
		}
	];

	(* DIGESTION PARAMETERS *)
	{
		digestionTemperature,
		digestionDuration,
		digestionRampDuration,
		digestionTemperatureProfile,
		digestionMixRateProfile,
		digestionMaxPower,
		digestionMaxPressure
	}=Lookup[optionsWithReplicates,
		{
			DigestionTemperature,
			DigestionDuration,
			DigestionRampDuration,
			DigestionTemperatureProfile,
			DigestionMixRateProfile,
			DigestionMaxPower,
			DigestionMaxPressure
		}
	];

	(* VENTING PARAMETERS *)
	{
		pressureVenting,
		pressureVentingTriggers,
		targetPressureReduction
	}=Lookup[optionsWithReplicates,
		{
			PressureVenting,
			PressureVentingTriggers,
			TargetPressureReduction
		}
	];

	(* DILUTION PARAMETERS *)
	{
		diluent,
		diluentVolume,
		dilutionFactor,
		targetDilutionVolume,
		outputAliquot,
		diluteOutputAliquot,
		containerOut
	}=Lookup[optionsWithReplicates,
		{
			Diluent,
			DiluentVolume,
			DilutionFactor,
			TargetDilutionVolume,
			OutputAliquot,
			DiluteOutputAliquot,
			ContainerOut
		}
	];

	(* -------------- *)
	(* -- DOWNLOAD -- *)
	(* -------------- *)

	(* All the sample handling in this experiment is Macro since it involves concentrated acids, custom transfer procedures *)
	(* we are also going to use preferred containers here *)
	(* We need to download a few fields to determine how much acid there is. No need to download anything about the standard acids since we already know the MW. *)
	(* download sample prep fields from for samples *)
	myGraduatedCylinders=Search[Model[Container, GraduatedCylinder], Deprecated != True];


	(* lookup information we need from the cache *)
	fastAssoc = makeFastAssocFromCache[cache];
	listedSamplePackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@mySamples;
	graduatedCylinderPackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@myGraduatedCylinders;

	(* pull out some values we will need to decide on resoruces *)
	solidUnitWeights=Lookup[listedSamplePackets, SolidUnitWeight];


	(* -------------------- *)
	(* -- PREPARE FIELDS -- *)
	(* -------------------- *)

	(* some options are gathered together for better readablity in the protocol object  *)

	(* -- SampleAmounts -- *)
	(* Trasnfer will automatically crush any tablets that are transferred by mass rather than quantity *)
	(* so we just need to make sure these tablets are in mass. The SolidUnitWeights field will be populated *)
	sampleAmount=MapThread[
		If[And[MatchQ[#3, True], MatchQ[#1, _Integer]],
			#1 * (#2 /. Null -> 100 Milligram),
			#1
		]&,
		{rawSampleAmount, solidUnitWeights, crushSample}
	];

	(* -- PreDigestionMixParameters -- *)
	composedPreDigestionMixParameters=MapThread[
		If[MatchQ[#1, True],
			{#2, #3},
			Null
		]&,
		{preDigestionMix, preDigestionMixTime, preDigestionMixRate}
	] /. ({Null..} -> Null);


	(* -- composed the output aliquot amount -- *)
	composedOutputAliquot=outputAliquot /. {All -> {Null, True}, x:VolumeP :> {x, False}};

	(* -- compose the digestion profiles complete with mixing steps -- *)
	composedDigestionProfiles=MapThread[
		Function[{sample, temperatureProfile, temperature, duration, rampDuration, mixProfile},
			Module[
				{safeDigestionTempProfile, safeMixProfile, temperatureFunction, mixFunctionRule, allTimePoints, newCombinedProfile},

				(* convert digestion temperature profile to the standard form *)
				safeDigestionTempProfile=If[MatchQ[temperatureProfile, Except[Null]],
					(*make sure the temp profile has at least two points (start and end)*)
					If[MemberQ[temperatureProfile, {EqualP[0 Minute], _}] && MemberQ[temperatureProfile, {Except[EqualP[0 Minute]], _}],
						temperatureProfile,
						Prepend[temperatureProfile, {0 Minute, $AmbientTemperature}]
					],
					(* convert the parameters into a profile *)
					{{0 Minute, $AmbientTemperature}, {rampDuration, temperature}, {(rampDuration + duration), temperature}}
				];

				(* make an interpolating function to represent the profile *)
				temperatureFunction=Interpolation[
					safeDigestionTempProfile,
					InterpolationOrder -> 1
				];

				(* convert the mix profile to a standard form also *)
				safeMixProfile=If[MatchQ[mixProfile, _List],

					(* generate a safe profile with at least a start and end point *)
					Which[
						(* if we are missing either end point, provide it *)
						!MemberQ[mixProfile, {EqualP[safeDigestionTempProfile[[All, 2]]]}] && !MemberQ[mixProfile, {EqualP[0 Minute], _}],
						Prepend[
							Append[
								mixProfile,
								{Max[safeDigestionTempProfile[[All, 1]]], Last[mixProfile[[All, 2]]]}
							],
							{0 Minute, First[mixProfile[[All, 2]]]}
						],

						(* if we are missing the 0 time point, set that to the same as the first time point *)
						!MemberQ[mixProfile, {EqualP[0 Minute], _}],
						Prepend[mixProfile, {0 Minute, First[mixProfile[[All, 2]]]}],

						(* if we are missing the last time point, set that to the same as the last existing time point *)
						!MemberQ[mixProfile, {EqualP[safeDigestionTempProfile[[All, 1]]]}],
						Append[mixProfile, {Max[safeDigestionTempProfile[[All, 1]]], Last[mixProfile[[All, 2]]]}]
					],
					{{0 Minute, mixProfile}, {Max[safeDigestionTempProfile[[All, 1]]], mixProfile}}
				];

				(* generate a rule to compute the Mix value at a specified time - reverse this so that the time point specifying the change also gets the correct value (RangeP is inclusive) *)
				mixFunctionRule=Reverse[
					MapThread[
						(RangeP[#1, #2] -> #3)&,
						{Most[safeMixProfile[[All, 1]]], Rest[safeMixProfile[[All, 1]]], Most[safeMixProfile[[All, 2]]]}
					]
				];

				(* extract all the time points and remove any duplicate points *)
				allTimePoints=DeleteDuplicatesBy[
					Sort[
						Flatten[{safeDigestionTempProfile[[All, 1]], safeMixProfile[[All, 1]]}]
					],
					EqualQ
				];

				(* compute the temperature and time at each point *)
				newCombinedProfile=Map[{sample, #1, temperatureFunction[#1], #1 /. mixFunctionRule}&, allTimePoints];

				(* output the result in the format close to what the instrument needs *)
				newCombinedProfile
			]
		],
		{
			Download[mySamples, Object],
			digestionTemperatureProfile,
			digestionTemperature,
			digestionDuration,
			digestionRampDuration,
			digestionMixRateProfile
		}
	];

	(* -- compose the Digestion Run time estimates -- *)

	(* just get the time for the last point in each profile *)
	composedDigestionRunTimes=composedDigestionProfiles[[All, -1, 2]];

	(* -- compose the PressureVenting parameters -- *)

	(* this is a little weird because of no multiple multiples, it tracks the samples in the field itself *)
	composedPressureVentingParameters=MapThread[
		(* check if we are pressure venting *)
		If[MatchQ[#2, Except[Null]],
			Flatten /@ Transpose[{ConstantArray[#1, Length[#2]], #2}],
			Nothing
		]&,
		{Download[mySamples, Object], pressureVentingTriggers}
	];


	(* -- compose the aliquot dilutions -- *)

	(* gather the dilution information in one field so it is cohesive, also indicate method *)
	(* the field format is {aliquot amount, diluent, diluent amount, target dilution volume} *)
	{composedOutputAliquotDilutions, estimatedReactionVolumes}=Transpose[
		MapThread[
			Function[ {aliquotAmt, dil, dilVol, dilFac, targetDilVol, agents, amount},
				Module[{totalDilutedVolume, estimatedReactionVolume, composedField},

					(* repeat the rough estimation of reaction volume from the resolver *)
					(*determine the reaction volume, assuming that 1 g of solid will increase the volume by 1 mL. Not great, I know.*)
					estimatedReactionVolume=Total[
						Flatten[
							{
								(agents /. Null -> {{Null, 0 Milliliter}})[[All, 2]],
								(Unitless[amount /. {x:MassP :> UnitConvert[x, Gram], y:VolumeP :> UnitConvert[y, Milliliter]}]) * Milliliter
							}
						]
					];

					(* compute the total dilution volume *)
					totalDilutedVolume=Which[

						(* if we are filling to volume, use that *)
						MatchQ[targetDilVol, VolumeP],
						targetDilVol,

						(* if we are using a dilution factor, calculate the total solution volume *)
						MatchQ[dilFac, _?NumericQ],
						estimatedReactionVolume * dilFac,

						(* if there is a fixed reagent addition, use that with the aliquot volume *)
						MatchQ[dilVol, VolumeP],
						dilVol + (aliquotAmt /. {All -> estimatedReactionVolume}),

						(* no dilutions. return the aliquot amount *)
						True,
						aliquotAmt /. {All -> estimatedReactionVolume}
					];

					(* compose the field based on if there is a fixed diluent volume or fixed dilution volume *)
					composedField=Which[

						(* add fixed amount of diluent *)
						MatchQ[dilVol, VolumeP],
						{aliquotAmt, dil, dilVol, Null},

						(* fill to volume *)
						MemberQ[{dilFac, targetDilVol}, Except[Null]],
						{aliquotAmt, dil, Null, totalDilutedVolume},

						(* no dilutions *)
						True,
						{aliquotAmt, Null, Null, Null}
					];

					(* output the reaction volume also since we need this later *)
					{composedField, estimatedReactionVolume}
				]
			],
			{outputAliquot, diluent, diluentVolume, dilutionFactor, targetDilutionVolume, digestionAgents, sampleAmount}
		]
	];


	(* -------------------------- *)
	(* -- SAMPLES IN RESOURCES -- *)
	(* -------------------------- *)

	(* -- Generate resources for the SamplesIn -- *)
	(* pull out the AliquotAmount option *)
	expandedAliquotAmount=Lookup[optionsWithReplicates, AliquotAmount];

	(* Get the sample amount; if we're aliquoting, use that amount; otherwise use the minimum amount the experiment will require *)
	sampleResourceAmount=MapThread[
		If[
			MatchQ[#1, Except[Null]],
			#1,
			#2
		]&,
		{expandedAliquotAmount, sampleAmount}
	];

	(* Pair the SamplesIn and their Amounts *)
	pairedSamplesInAndAmounts=MapThread[
		(#1 -> #2)&,
		{samplesWithReplicates, sampleResourceAmount}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleAmountRules=Merge[pairedSamplesInAndAmounts, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules=KeyValueMap[
		Function[{sample, amount},
			If[VolumeQ[amount],
				(sample -> Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount]),
				(sample -> Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount])
			]
		],
		sampleAmountRules
	];

	(*also make a linked version of this so that it can be used on other fields to put the resources in*)
	linkedSampleResourceReplaceRules=KeyValueMap[
		Function[{sample, amount},
			If[VolumeQ[amount],
				(sample -> Link[Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount]]),
				(sample -> Link[Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount]])
			]
		],
		sampleAmountRules
	];

	(* Use the replace rules to get the sample resources *)
	(*samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];*)
	samplesInResources=Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];


	(* ---------------------- *)
	(* -- DIGESTION AGENTS -- *)
	(* ---------------------- *)

	(* Pair the DigestionAgents with their amounts and their Amounts *)
	(* end up with rules of the form Model[Sample, "digestion agent 1"] -> volume *)
	digestionAgentResourceAmount=Flatten[
		MapThread[
			Function[{preparedBool, agentsAndVolumes},
				If[
					MatchQ[preparedBool, True],
					Nothing,
					Map[(First[#] -> Last[#])&, agentsAndVolumes]
				]
			],
			{preparedSample, digestionAgents}
		]
	];

	(* Merge the DigestionAgents volumes together to get the total volume of each sample's resource *)
	digestionAgentAmountRules=Merge[digestionAgentResourceAmount, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	digestionAgentResourceReplaceRules=KeyValueMap[
		Function[{sample, amount},
			(sample -> Link[Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount]])
		],
		digestionAgentAmountRules
	];

	(* Use the replace rules to get the sample resources *)
	(*samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];*)
	digestionAgentResources=Replace[digestionAgents, digestionAgentAmountRules, {1}];

	(* The reaction vessel resource got moved up*)
	(* -- Reaction Vessel -- *)
	reactionVesselResources=Map[
		Link[Resource[Sample -> Model[Container, ReactionVessel, Microwave, "SP-D 80 Reaction Vessel"], Rent -> True, Name -> "vessel"<>ToString[#]]]&,
		Range[Length[mySamples]]
	];

	(* get these bad boys back into the correct format again we are doing something weird to avoid multiple multiple fields*)
	composedDigestionAgents=MapThread[
		Function[{sample, vessels, agents},
			Map[Join[{sample, vessels}, #]&, agents]
		],
		{Download[mySamples, Object], reactionVesselResources, digestionAgents}
	];

	(* ------------------- *)
	(* -- NEUTALIZATION -- *)
	(* ------------------- *)


	(* -- quench container -- *)
	{quenchSolutionResources, quenchDiluentResource, quenchContainerResource, computedQuenchVolume}=Module[
		{
			amountOfBaseSolution, minimumQuenchVolume, molesOfAcidicProtons, scalingFactors, quenchableDigestionAgentRules,
			quenchContainer, totalQuenchedVolume
		},

		(* call the helper function to determine how much acid there is *)
		(*we shoudl account for the fact that not all of the sample is going to be neutralized. *)
		(* scale the volume rules by the amount of sample that will be discarded/retained *)
		scalingFactors=MapThread[
			If[MatchQ[#2, All],
				0,
				(1 - #2 / #1)
			]&,
			{estimatedReactionVolumes, outputAliquot}
		];

		(* determine the amounts of each digestion agent that we are going to be quenching at the end of the digestion *)
		quenchableDigestionAgentRules=Flatten[
			MapThread[
				Function[{preparedBool, agent, amount, scalingFactor},
					If[
						MatchQ[preparedBool, True],

						(* assume that prepared samples are nitric acid *)
						{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"] -> amount * scalingFactor},

						(* get the approximate composition from the digestion agents *)
						Map[(First[#] -> Last[#] * scalingFactor)&, agent]
					]
				],
				{preparedSample, digestionAgents, sampleAmount, scalingFactors}
			]
		];

		(* use the helper to determine how many acid equivilants we need to quench *)
		molesOfAcidicProtons=howMuchAcid[quenchableDigestionAgentRules, acidsCache];

		(* prior to quenching, we wil pour the acids into 5x the total volume we are planning to quench or water *)
		minimumQuenchVolume=Total[Values[quenchableDigestionAgentRules]] * 5;

		(* our target base concentration is 1.85 M - request enough stock solution to neutralize with ~5% excess. This solution is goign to be pretty heavily buffered so the waste will be pretty safe*)
		amountOfBaseSolution=molesOfAcidicProtons / (1.85 Mole / Liter) * 1.05;

		(* find a container that has enough volume to do the quenchign in *)
		totalQuenchedVolume=Total[{amountOfBaseSolution, minimumQuenchVolume, minimumQuenchVolume / 5}];

		(* find a sufficiently large container that is compatible with acid and base *)
		quenchContainer=First[
			Intersection[
				PreferredContainer[Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], totalQuenchedVolume * 1.5, All -> True],
				PreferredContainer[Model[Sample, StockSolution, "1.85 M NaOH"], totalQuenchedVolume * 1.5, All -> True]
			]
		];

		(* make the resource for the stock solution we just made *)
		If[MatchQ[amountOfBaseSolution, EqualP[0 Milliliter]],
			{Null, Null, Null, 0 Milliliter},
			{
				Link[Resource[Sample -> Model[Sample, StockSolution, "1.85 M NaOH"], Amount -> amountOfBaseSolution]],
				Link[Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> minimumQuenchVolume, Container -> PreferredContainer[Model[Sample, "Milli-Q water"], minimumQuenchVolume]]],
				Link[Resource[Sample -> quenchContainer]],
				totalQuenchedVolume
			}
		]
	];

	(* ----------------------- *)
	(* -- DILUENT RESOURCES -- *)
	(* ----------------------- *)

	(* total up the amount of each diluent we are going to use and generate rules to insert the resources into the OutputAliquotDilution field*)
	(* the format of this field is {aliquot amount, diluent, diluent amount, target dilution volume} *)
	diluentVolumeRules=Normal[
		Merge[
			MapThread[
				Module[{updatedComposedOutputAliquotDilutions},

					(* get rif of the All, and use the estimated volumes *)
					updatedComposedOutputAliquotDilutions=#1 /. All -> #2;

					(* determine the rules for the diluent *)
					Which[
						MatchQ[updatedComposedOutputAliquotDilutions, {_, Null, _, _}],
						{},

						MatchQ[updatedComposedOutputAliquotDilutions, {_, _, VolumeP, _}],
						updatedComposedOutputAliquotDilutions[[2]] -> updatedComposedOutputAliquotDilutions[[3]],

						MatchQ[updatedComposedOutputAliquotDilutions, {VolumeP, _, _, VolumeP}],
						updatedComposedOutputAliquotDilutions[[2]] -> (updatedComposedOutputAliquotDilutions[[4]] - updatedComposedOutputAliquotDilutions[[1]])
					]
				]&,
				{composedOutputAliquotDilutions, estimatedReactionVolumes}
			],
			Total
		]
	];


	(* make the resource rules *)
	diluentResourceRules=Map[
		(First[#] -> Resource[Sample -> First[#], Amount -> Last[#], Container -> PreferredContainer[First[#], Last[#]], Name -> ToString[Unique[]]])&,
		diluentVolumeRules
	];

	(* ----------------------------- *)
	(* -- ADD RESOURCES TO FIELDS -- *)
	(* ----------------------------- *)

	(* add the diluent resources *)
	composedDiluents=diluent /. diluentResourceRules;

	(* substitute resources into the output, drop the first element of each since we were just using it to determine resource amounts *)
	resourcedOutputAliquotDilutions=(Rest /@ composedOutputAliquotDilutions) /. diluentResourceRules;

	(* add resources to the venting parameters - this is because they are avoiding a multiple multiple *)
	resourcedPressureVentingParameters=Flatten[composedPressureVentingParameters, 1] /. linkedSampleResourceReplaceRules;

	(* add resources to the DigestionAgents - flatten them one level for the protocol upload. *)
	resourcedDigestionAgents=(Flatten[composedDigestionAgents, 1] /. Join[digestionAgentResourceReplaceRules, linkedSampleResourceReplaceRules]);

	(* add resources to the digestion profiles - same deal as the venting *)
	resourcedDigestionProfile=Flatten[Join[composedDigestionProfiles], 1] /. linkedSampleResourceReplaceRules;

	(* -------------------- *)
	(* -- TIME ESTIMATES -- *)
	(* -------------------- *)

	(* map thread over the sample parameters to determine the amount of time each sampling pattern is going to take, multiply by the number of reads and add the number of reads x read rest time.  *)
	(* then multiply everything by number of replicates *)

	(* -- instrument time estimate -- *)

	totalReactionTime=Total[composedDigestionRunTimes];

	(* -- sample prep estimate -- *)

	(* say about 10 min to add digestion agent, 1 Minute to just transfer sample *)
	samplePrepTime=Plus[
		Length[Cases[preparedSample, False]] * 10 Minute,
		Length[Cases[preparedSample, True]] * 5 Minute
	];

	(* -- neutralization estimate -- *)

	(* estimate based on the volume of the neuralization *)
	neutralizationTime=computedQuenchVolume * 0.01 * Minute / Milliliter;

	(* -- resource picking estimate -- *)

	(* estimate based on the number of samples *)
	resourcePickingEstimate=(Length[mySamples] * 5 Minute + 10 Minute);


	(* -------------------------- *)
	(* -- INSTRUMENT RESOURCES -- *)
	(* -------------------------- *)

	(* -- Instrument -- *)
	(*get the instrument resources. we will pad out the time by a couple minutes*)
	instrumentResource=Link[Resource[Instrument -> instrument, Time -> (10 Minute) + totalReactionTime, Name -> ToString[Unique[]]]];


	(* ------------------- *)
	(* -- ITEM RESOURCE -- *)
	(* ------------------- *)

	(* -- Tweezers -- *)
	tweezerResource=If[MemberQ[sampleType, Tablet],
		Link[Resource[Sample -> Model[Item, Tweezer, "Straight flat tip tweezer"]]],
		Null
	];

	(* -- Stir bar -- *)
	stirBarResource=Table[Link[Resource[Sample -> Model[Part, StirBar, "SP-D 80 Reaction Vessel Stir Bar"], Rent -> True, Name -> ToString[Unique[]]]], {x, 1, Length[mySamples]}];

	(* -- Reaction Vessel cap -- *)
	reactionVesselCapResources=Table[Link[Resource[Sample -> Model[Item, Cap, "SP-D 80 Reaction Vessel Cap"], Name -> ToString[Unique[]]]], {x, 1, Length[mySamples]}];

	(* -- reaction vessel rack -- not needed here *)

	(* -- ContainersOut -- *)
	containerOutResources=Map[Link[Resource[Sample -> #, Name -> ToString[Unique[]]]]&, containerOut];

	(* -- Glassware for DigestionAgents -- *)
	(* consolidate each digestion agent by amount, determine the appropraite glassware *)
	(* to use the minimum amount of glassware and maintain loop index matching, keep them together *)
	(* Digestion Agents field is {sample, container, agent, amount}*)
	composedGlassware=If[MatchQ[resourcedDigestionAgents, Null | {Null}],
		Null,
		Module[{
			safeMaxVolumes, safeGraduatedCylinders,
			graduatedCylinderRules,
			gatheredDigestionAgent, allDigestionAgentVolumeRules,
			safeResourcedDigestionAgents
		},

			(* look up the volumes and objects *)
			safeMaxVolumes=Lookup[graduatedCylinderPackets, MaxVolume];
			safeGraduatedCylinders=Lookup[graduatedCylinderPackets, Object];
			safeResourcedDigestionAgents=DeleteCases[resourcedDigestionAgents, Null];

			(* get the list of digestion agents and their amounts - don't get the resource, get the object *)
			(* this is in the form of Model[Sample] -> Amount *)
			allDigestionAgentVolumeRules=Map[
				<|#[[3]] -> #[[4]]|>&,
				safeResourcedDigestionAgents
			];

			(* figure out the max amount of each agent *)
			gatheredDigestionAgent=Merge[allDigestionAgentVolumeRules, Join];

			(* find the max amount used for each digestion agent and make rules of the form: {digestion agent -> grad cylinder} *)
			graduatedCylinderRules=Map[
				Module[{volume, rule, graduatedCylinder},

					(* use the rule to make this a little easier *)
					rule=#;

					(* find the volume appropriate glassware *)
					volume=FirstCase[Sort[safeMaxVolumes], GreaterP[Max[Last[rule]]]];

					(*should probably check for deprecated too*)
					(* generate the resource *)
					graduatedCylinder=First[PickList[safeGraduatedCylinders, safeMaxVolumes, volume]];

					(* generate the rule *)
					(First[rule] -> Link[Resource[Sample -> graduatedCylinder, Rent -> True, Name -> ToString[Unique[]]]])
				]&,
				Normal[gatheredDigestionAgent]
			];

			(*make the output*)
			Map[
				{Link[#[[2]]], #[[3]] /. graduatedCylinderRules}&,
				safeResourcedDigestionAgents
			]
		]
	];

	(* also generate resources for the work surface and stir bar retriever *)
	stirBarRetriever=Link[Resource[Sample -> Model[Part, StirBarRetriever, "id:eGakldJlXP1o"], Rent -> True]];

	(* Fume Hood model changed to Labconco Premier 6 Foot when moved to ECL. *)
	workSurface=Link[Resource[Instrument -> commonFumeHoodHandlingStationModels["Memoization"], Time -> (10 Minute + (5 Minute * Length[composedGlassware]))]];


	(* -------------------------------- *)
	(* -- Reaction Vessel Placements -- *)
	(* -------------------------------- *)
	(* determine where the reaction vessels will be sitting - this matches what is done in the compiler *)
	placements=Module[{positions, usedPositions},
		(* get a list of positions *)
		positions=If[MatchQ[instrument, ObjectP[Object[Instrument, Reactor, Microwave]]],
			Lookup[
				fastAssocLookup[fastAssoc,instrument,{Model, Positions}],
				Name
			],
			Lookup[
				fastAssocLookup[fastAssoc,instrument,{Positions}],
				Name
			]
		];

		(* take the usable positions *)
		usedPositions=Take[positions, Length[mySamples]];

		(* format the placements field correctly *)
		MapThread[{#1, instrumentResource, #2}&, {reactionVesselResources, usedPositions}]
	];

	(* rack resources - they hold 12 each so we might need 2 *)
	rackResources=If[MatchQ[Length[mySamples], GreaterP[12]],
		{
			Link[Resource[Sample -> Model[Container, Rack, "id:J8AY5jDWmkzD"], Rent -> True, Name -> ToString[Unique[]]]],
			Link[Resource[Sample -> Model[Container, Rack, "id:J8AY5jDWmkzD"], Rent -> True, Name -> ToString[Unique[]]]]
		},
		{Link[Resource[Sample -> Model[Container, Rack, "id:J8AY5jDWmkzD"], Rent -> True]]}
	];

	(* construt a grouped relevant options into batches for the unit operation packets *)
	unGroupedOptions = {
		Preparation -> ConstantArray[Manual, Length[samplesInResources]],
		Sample -> samplesInResources,
		SampleLabel -> sampleLabel,
		SampleContainerLabel -> sampleContainerLabel,
		SampleOutLabel -> sampleOutLabel,
		Instrument -> instrumentResource,
		SampleType -> sampleType,
		SampleAmount -> sampleAmount,
		CrushSample -> crushSample,
		PreDigestionMix -> preDigestionMix,
		PreDigestionMixTime -> preDigestionMixTime,
		PreDigestionMixRate -> preDigestionMixRate,
		PreparedSample -> preparedSample,
		DigestionAgents -> digestionAgents,
		DigestionAgentsResources -> digestionAgentResources,
		DigestionTemperature -> digestionTemperature,
		DigestionDuration -> digestionDuration,
		DigestionRampDuration -> digestionRampDuration,
		DigestionTemperatureProfile -> digestionTemperatureProfile,
		DigestionMixRateProfile -> digestionMixRateProfile,
		DigestionMaxPower -> digestionMaxPower,
		DigestionMaxPressure -> digestionMaxPressure,
		PressureVenting -> pressureVenting,
		PressureVentingTriggers -> pressureVentingTriggers,
		TargetPressureReduction -> targetPressureReduction,
		OutputAliquot -> outputAliquot,
		DiluteOutputAliquot -> diluteOutputAliquot,
		Diluent -> composedDiluents,
		TargetDilutionVolume -> targetDilutionVolume,
		ContainerOut -> containerOutResources
	};
	(* TODO groupByKey does not work for this unGroupedOptions. Here's a temporary alternative *)
	groupedOptions = {unGroupedOptions};


	(* -- Unit Operation Packet *)
	unitOperationPacket = Module[
		{microwaveDigestionUnitOperationPackets},
		microwaveDigestionUnitOperationPackets = MapThread[
			Function[{
				options
			},
				Module[{nonHiddenOptions},
					(* Only include non-hidden options from MicrowaveDigestion. *)
					nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, MicrowaveDigestion]];

					MicrowaveDigestion @@ ReplaceRule[
						Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
						{
							Sample -> Lookup[options, Sample],
							Instrument -> Lookup[options, Instrument],
							Preparation -> Lookup[options, Preparation],
							SampleLabel -> Lookup[options, SampleLabel],
							SampleContainerLabel -> Lookup[options, SampleContainerLabel],
							SampleOutLabel -> Lookup[options, SampleOutLabel],
							DigestionAgentsResources -> Lookup[options, DigestionAgentsResources],
							ContainerOut -> Lookup[options, ContainerOut],
							Diluent -> Lookup[options, Diluent]

						}
					]
				]
			],
			{
				groupedOptions
			}
		];
		UploadUnitOperation[
			microwaveDigestionUnitOperationPackets,
			UnitOperationType -> Batched,
			Preparation -> Manual,
			FastTrack -> True,
			Upload -> False
		]
	];

	(* --------------------- *)
	(* -- PROTOCOL PACKET -- *)
	(* --------------------- *)

	(* Create our protocol packet. *)
	protocolPacketMinusRequiredObjects=Join[<|
		Type -> Object[Protocol, MicrowaveDigestion],
		Object -> CreateID[Object[Protocol, MicrowaveDigestion]],
		Replace[SamplesIn] -> samplesInResources,
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ DeleteDuplicates[Lookup[fetchPacketFromCache[#, cache], Container]& /@ samplesWithReplicates],
		Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@Lookup[unitOperationPacket, Object],


		(* other Object/Model[Samples] *)
		Replace[DigestionAgents] -> DeleteCases[resourcedDigestionAgents, Alternatives[{Null, Null, Null, Null}, Null]],
		Replace[DigestionAgentGlassware] -> composedGlassware,

		(* solutions for neutralization *)
		WasteNeutralizationSolution -> quenchSolutionResources,
		WasteNeutralizationDiluent -> quenchDiluentResource,
		WasteNeutralizationContainer -> quenchContainerResource,

		(* item and instrument resources *)
		Replace[Instrument] -> instrumentResource,
		Replace[ReactionVesselPlacements] -> placements,
		Replace[StirBar] -> stirBarResource,
		WorkSurface -> workSurface,
		StirBarRetriever -> stirBarRetriever,
		Replace[Rack] -> rackResources,

		Replace[ReactionVessels] -> reactionVesselResources,
		Replace[ReactionVesselCaps] -> reactionVesselCapResources,
		Replace[ContainersOut] -> containerOutResources,

		(* general options based fields *)
		Replace[SampleTypes] -> sampleType,
		Replace[SampleAmounts] -> sampleAmount,
		Replace[CrushSamples] -> crushSample,
		Replace[PreDigestionMixParameters] -> composedPreDigestionMixParameters,
		Replace[DigestionReady] -> preparedSample,

		(*one of these is still broken*)
		Replace[DigestionProfiles] -> resourcedDigestionProfile,
		Replace[DigestionMaxPower] -> digestionMaxPower,

		(*one of these two is still broken*)
		Replace[DigestionMaxPressures] -> digestionMaxPressure,
		Replace[PressureVentingParameters] -> resourcedPressureVentingParameters,

		Replace[TargetPressureReduction] -> targetPressureReduction,
		Replace[OutputAliquots] -> composedOutputAliquot,
		Replace[OutputAliquotDilutions] -> resourcedOutputAliquotDilutions,
		Replace[DigestionRunTimes] -> composedDigestionRunTimes,


		(* checkpoints *)
		Replace[Checkpoints] -> {
			{"Preparing Samples", 0 Minute, "Preprocessing, such as incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], Time -> 0 Minute]},
			{"Picking Resources", resourcePickingEstimate, "Samples required to execute this protocol are gathered from storage.", Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], Time -> resourcePickingEstimate]},
			{"Preparing Reaction Mixtures", samplePrepTime, "Samples and digestion agents are added to the reaction vessels.", Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], Time -> samplePrepTime]},
			{"Digest Samples", (10 Minute) + totalReactionTime, "The reaction mixtures are subjected to microwave digestion conditions.", Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], Time -> (10 Minute) + totalReactionTime]},
			{"Digestion Workup", (neutralizationTime + 10 Minute), "The reaction mixtures are diluted, and waste is neutralized as appropriate.", Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], (Time -> neutralizationTime + 10 Minute)]},
			{"Sample Postprocessing", 0 Minute, "The samples are imaged and volumes are measured.", Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], Time -> 0 Minute]}
		},

		ResolvedOptions -> myCollapsedResolvedOptions,
		UnresolvedOptions -> myUnresolvedOptions,
		Replace[SamplesInStorage] -> samplesInStorage
	|>,
		populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation]
	];

	(* ---------------------- *)
	(* -- CLEAN UP AND FRQ -- *)
	(* ---------------------- *)


	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[{Values[protocolPacketMinusRequiredObjects], Values[unitOperationPacket]}], _Resource, Infinity]];

	(* Since we are doing Manual preparation, populate the RequiredObjects and RequiredInstruments fields of the protocol packet *)
	protocolPacket = Join[
			protocolPacketMinusRequiredObjects,
			<|
				Replace[RequiredObjects] -> (Link /@ Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Sample]]]]),
				Replace[RequiredInstruments] -> (Link /@ Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]])
			|>
	];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable, frqTests}=Which[
		MatchQ[$ECLApplication, Engine],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache, Simulation -> simulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> Result, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> Not[gatherTests], Cache -> cache, Simulation -> simulation], Null}
	];

	(* generate the tests rule *)
	testsRule=Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{protocolPacket, unitOperationPacket},
		{$Failed,{}}
	];

	(* Return our result. *)
	outputSpecification /. {resultRule, testsRule}
];

(* ::Subsubsection::Closed:: *)
(* resolveExperimentMicrowaveDigestionMethod *)
DefineOptions[resolveExperimentMicrowaveDigestionMethod,
	SharedOptions :> {
		ExperimentMicrowaveDigestion,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveExperimentMicrowaveDigestionMethod[
	mySamples: ListableP[Automatic|(ObjectP[{Object[Sample],Object[Container]}])],
	myOptions: OptionsPattern[resolveExperimentMicrowaveDigestionMethod]
] := Module[
	{outputSpecification, output, gatherTests, result, tests},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	result = Manual;
	tests = {};

	outputSpecification/.{
		Result -> result,
		Tests -> tests
	}
];


(* ::Subsubsection::Closed:: *)
(* simulateExperimentMicrowaveDigestion *)

DefineOptions[
	simulateExperimentMicrowaveDigestion,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentMicrowaveDigestion[
	myProtocolPacket:(PacketP[Object[Protocol, MicrowaveDigestion], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:(ListableP[PacketP[]]|$Failed|{}),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentMicrowaveDigestion]
] := Module[
	{
		mapThreadFriendlyOptions,resolvedPreparation,cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, simulationWithLabels,
		updatedSimulation, simulatedSamplesOutPacket, simulatedSampleOutObjects,
		simulatedSampleOutPackets, sampleOutLink, simulationWithSamplesOut
	},
	(* Lookup our cache and simulation *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download containers from our sample packets. *)
	samplePackets=Download[
		mySamples,
		Packet[Container],
		Cache->cache,
		Simulation->simulation
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=If[
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[Object[Protocol,MicrowaveDigestion]],
		(* Otherwise there was no problem generating the protocol packet, just read the packet *)
		Lookup[myProtocolPacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentMicrowaveDigestion,
		myResolvedOptions
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation=If[
		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
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

		(* Otherwise, our reosurce packets went fine and we have an Object[Protocol, MicrowaveDigestion]. *)
		SimulateResources[
			myProtocolPacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	(* Update simulation with fulfillment simulation *)
	updatedSimulation = UpdateSimulation[simulation, fulfillmentSimulation];

	(* createID for simulatedSamplesOut *)
	simulatedSampleOutObjects = Table[CreateID[Object[Sample]], Length[mySamples]];

	(* Use MapThread to simulate the SampleOut Packets *)
	simulatedSampleOutPackets = MapThread[
		Function[{sampleInPacket, simulatedSampleOutObject, option},
			Module[{
				sampleOutNothingAddedPacket, sampleOutDigestionAgentsAddedPacket, sampleOutDiluentAddedPacket, sampleInObject,
				sampleOutNothingAddedSimulation, sampleOutDigestionAgentsAddedSimulation, sampleOutDiluentAddedSimulation,
				validDigestionAgentQ, simulatedDigestionAgentObject, simulatedDigestionAgentVolume, simulatedDiluentVolume, validDiluentQ,
				simulatedSampleOutUpdatedVolume, simulatedSampleOutUpdatedMass, simulatedDiluentObject, simulatedDigestionAgent, simulatedDiluent,
				simulatedSampleAmount, simulatedTargetDilutionVolume, simulatedDiluentVolumeOption, sampleModelsInOption, sampleNumberNeeded,
				simulatedContainersInOption, simulatedBench, simulationWithFakeBench, simulationWithFakeContainers, simulatedContainersObjectInOption,
				simulatedSampleObjectPacketsInOption, simulatedSampleObjectsInOption, simulationWithFakeObjectsInOption, simulatedSampleModelToObjectsInOption,
				simulatedDigestionAgentCleanedUp, simulatedDiluentCleanedUp, simulatedBenchObject, simulationWithFakeSampleOut, simulatedContainerOut,
				simulatedContainerOutObjectType, simulatedContainerID
			},

				sampleInObject = Lookup[sampleInPacket, Object];

				(* Read the options *)
				{
					simulatedDigestionAgent,
					simulatedDiluent,
					simulatedDiluentVolumeOption,
					simulatedSampleAmount,
					simulatedTargetDilutionVolume,
					simulatedContainerOut
				} = Lookup[option,
					{
						DigestionAgents,
						Diluent,
						DiluentVolume,
						SampleAmount,
						TargetDilutionVolume,
						ContainerOut
					}
				];

				(* Simulating composition and volume changes relies on UploadSampleTransfer function, which only work on Object[Sample] *)
				(* Therefore, it's necessary to create simulated Objects and convert all the Model[Sample] from options into Object[Sample] *)

				(* Find all Model[Sample] objects in the above options *)
				sampleModelsInOption = Cases[Flatten[
					{simulatedDigestionAgent, simulatedDiluent}],
					ObjectP[Model[Sample]]
				];

				sampleNumberNeeded = Length[sampleModelsInOption];

				(* set up a simulated bench space for simulated containers *)
				simulatedBench = <|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for MicrowaveDigestion simulation",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Object -> CreateID[Object[Container, Bench]]
				|>;

				simulatedBenchObject = Lookup[simulatedBench, Object];

				(* Update simulation with simulated bench *)
				simulationWithFakeBench = UpdateSimulation[updatedSimulation, Simulation[simulatedBench]];

				(* Set up simulated containers for simulated objects *)
				simulatedContainersInOption = UploadSample[
					(* container Model. Use a 1 liter flask just to ensure we have enough amount *)
					Table[Model[Container, Vessel, "1000mL Erlenmeyer Flask"], sampleNumberNeeded],
					(* Location *)
					Table[{"Work Surface", simulatedBenchObject}, sampleNumberNeeded],
					Upload -> False,
					Simulation -> simulationWithFakeBench,
					Cache -> cache
				];
				simulatedContainersObjectInOption = Cases[DeleteDuplicates[Lookup[simulatedContainersInOption, Object]], ObjectP[Object[Container, Vessel]]];

				(* Update simulation with the simulated containers *)
				simulationWithFakeContainers = UpdateSimulation[simulationWithFakeBench, Simulation[simulatedContainersInOption]];

				(* Set up simulated Object[Sample]s for Model[Sample] from options *)
				simulatedSampleObjectPacketsInOption = UploadSample[
					(* Models *)
					sampleModelsInOption,
					(* Containers *)
					{"A1", #}& /@ simulatedContainersObjectInOption,
					InitialAmount -> Table[1 Liter, sampleNumberNeeded],
					Upload -> False,
					Simulation -> simulationWithFakeContainers,
					Cache -> cache
				];

				(* Update simulation with simulated objects *)
				simulationWithFakeObjectsInOption = UpdateSimulation[simulationWithFakeContainers, Simulation[simulatedSampleObjectPacketsInOption]];

				simulatedSampleObjectsInOption = Cases[DeleteDuplicates[Lookup[simulatedSampleObjectPacketsInOption, Object]], ObjectP[Object[Sample]]];

				simulatedSampleModelToObjectsInOption = MapThread[#1 -> #2&, {sampleModelsInOption, simulatedSampleObjectsInOption}];

				(* Replace all Model[Sample] with Object[Sample] for these following two options *)
				{
					simulatedDigestionAgentCleanedUp,
					simulatedDiluentCleanedUp
				} = {
					simulatedDigestionAgent,
					simulatedDiluent
				} /. simulatedSampleModelToObjectsInOption;

				(* UploadSampleTransfer will fail if Sample Packet does not exist, and will fail if sample has no container, thus here we define a pseudo sample packet *)
				simulatedContainerOutObjectType = If[MatchQ[simulatedContainerOut, ObjectP[]],
					Object @@ Download[simulatedContainerOut, Type],
					Object[Container, Vessel]
				];

				simulatedContainerID = CreateID[simulatedContainerOutObjectType];

				simulationWithFakeSampleOut = UpdateSimulation[simulationWithFakeObjectsInOption,
					Simulation[{
						<|Object -> simulatedSampleOutObject, Model -> Null, Volume -> Null, Mass -> Null, Container -> Link[simulatedContainerID, Contents, 2]|>,
						<| Object -> simulatedContainerID, Model -> Null |>
					}]
				];

				(* Transfer input sample to empty output sample *)
				sampleOutNothingAddedPacket = UploadSampleTransfer[
					sampleInObject,
					simulatedSampleOutObject,
					simulatedSampleAmount,
					Cache -> cache,
					Simulation -> simulationWithFakeSampleOut,
					Upload -> False
				];

				(* Update simulation for this transfer *)
				sampleOutNothingAddedSimulation = UpdateSimulation[simulationWithFakeObjectsInOption, Simulation[sampleOutNothingAddedPacket]];

				(* Find out whether digestion agent has been successfully resolved as a list of list of sample and volume for each member of SamplesIn*)
				validDigestionAgentQ = MatchQ[simulatedDigestionAgent, ListableP[{ObjectP[Model[Sample]], VolumeP}]];

				(* extract sample model and volume from simulatedDigestionAgent *)
				{simulatedDigestionAgentObject, simulatedDigestionAgentVolume} = If[validDigestionAgentQ,
					(* If DigestionAgent is valid, extract the sample and volume *)
					Transpose[simulatedDigestionAgentCleanedUp],
					(* Otherwise set to Null *)
					{Null, Null}
				];

				(* generates packet for transferring digestion agent *)
				sampleOutDigestionAgentsAddedPacket = If[validDigestionAgentQ,
					Quiet[UploadSampleTransfer[
						simulatedDigestionAgentObject,
						Table[simulatedSampleOutObject, Length[simulatedDigestionAgentObject]],
						simulatedDigestionAgentVolume,
						Cache -> cache,
						Simulation -> sampleOutNothingAddedSimulation,
						Upload -> False
					]] /.{$Failed -> Null}
				];

				(* Update simulation *)
				sampleOutDigestionAgentsAddedSimulation = If[!NullQ[sampleOutDigestionAgentsAddedPacket],
					UpdateSimulation[sampleOutNothingAddedSimulation, Simulation[sampleOutDigestionAgentsAddedPacket]],
					(* make new simulation the same as old one, if there's no DigestionAgent, or it cannot be properly resolved *)
					sampleOutNothingAddedSimulation
				];

				(* find out whether diluent and diluent volume option has been correctly resolved *)
				validDiluentQ = And[
					(* Diluent option must be resolved to Sample Model or Object *)
					MatchQ[simulatedDiluent, ObjectP[{Model[Sample], Object[Sample]}]],
					Or[
						(* Either DiluentVolume option must be resolved to volume or a factor *)
						MatchQ[simulatedDiluentVolumeOption, VolumeP|_?NumberQ],
						(* Or TargetDilutionVolume resolved as volume *)
						MatchQ[simulatedTargetDilutionVolume, VolumeP]
					]
				];

				simulatedDiluentObject = If[validDiluentQ,
					simulatedDiluentCleanedUp
				];

				(* find updated volume for SampleOut *)
				(* Reason to find this volume is to estimate how much diluent will be added, if DiluentVolume option is set as dilution factor *)
				{simulatedSampleOutUpdatedVolume, simulatedSampleOutUpdatedMass} = Quiet[
					Download[
						simulatedSampleOutObject,
						{Volume, Mass},
						Simulation -> sampleOutDigestionAgentsAddedSimulation,
						Cache -> cache
					], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
				];

				(* Considering volume may not be available, do the following *)
				simulatedSampleOutUpdatedVolume = Which[
					(* If Mass is available, pretend the density if 1 g/ml and calculate a volume *)
					MatchQ[simulatedSampleOutUpdatedMass, MassP], simulatedSampleOutUpdatedMass / (1 Gram / Milliliter),
					(* If volume is available, don't change it *)
					MatchQ[simulatedSampleOutUpdatedVolume, VolumeP], simulatedSampleOutUpdatedVolume,
					(* Any other case set to Null *)
					True, Null
				];

				(* convert simulatedDiluentVolumeOption into volume if it was resolved in terms of factor *)
				simulatedDiluentVolume = Which[
					(* If !validDiluentQ, set to Null *)
					!validDiluentQ, Null,
					(* If DiluentVolume is set as dilution factor but we cannot estimate volume, set to Null *)
					MatchQ[simulatedDiluentVolumeOption, _?NumberQ] && NullQ[simulatedSampleOutUpdatedVolume], Null,
					(* convert simulatedDiluentVolumeOption into volume if it was resolved in terms of factor *)
					MatchQ[simulatedDiluentVolumeOption, _?NumberQ], simulatedDiluentVolumeOption * simulatedSampleOutUpdatedVolume,
					(* Otherwise, if TargetDilutionVolume is set but but we cannot estimate volume, set to Null *)
					MatchQ[simulatedTargetDilutionVolume, VolumeP] && NullQ[simulatedSampleOutUpdatedVolume], Null,
					(* Otherwise, if TargetDilutionVolume is set and but we estimate volume, set to the difference of volume, but make sure it's not negative *)
					MatchQ[simulatedTargetDilutionVolume, VolumeP], Max[simulatedTargetDilutionVolume - simulatedSampleOutUpdatedVolume, 0 Milliliter],
					(* Otherwise no change *)
					True, simulatedDiluentVolumeOption
				];

				(* generates packet for transferring diluent *)
				sampleOutDiluentAddedPacket = If[validDiluentQ &&!NullQ[simulatedDiluentVolume],
					Quiet[UploadSampleTransfer[
						simulatedDiluentObject,
						simulatedSampleOutObject,
						simulatedDiluentVolume,
						Cache -> cache,
						Simulation -> sampleOutDigestionAgentsAddedSimulation,
						Upload -> False
					]]/.{$Failed -> Null}
				];

				(* Update simulation *)
				sampleOutDiluentAddedSimulation = UpdateSimulation[sampleOutDigestionAgentsAddedSimulation, Simulation[sampleOutDiluentAddedPacket]];

				(* Finally, to make it loop *)
				updatedSimulation = sampleOutDiluentAddedSimulation;
			];
		],
		{samplePackets, simulatedSampleOutObjects, mapThreadFriendlyOptions}
	];

	sampleOutLink = Link[#, Protocols]&/@simulatedSampleOutObjects;

	simulationWithSamplesOut = UpdateSimulation[updatedSimulation, Simulation[<|Replace[SamplesOut] -> sampleOutLink, Object -> protocolObject |>]];


	(* Download information from our simulated resources *)

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
		UpdateSimulation[simulationWithSamplesOut, simulationWithLabels]
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentMicrowaveDigestion: Sister Functions*)


(* ------------- *)
(* -- OPTIONS -- *)
(* ------------- *)

DefineOptions[ExperimentMicrowaveDigestionOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentMicrowaveDigestion}
];

ExperimentMicrowaveDigestionOptions[myInput:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | _String], myOptions:OptionsPattern[ExperimentMicrowaveDigestionOptions]]:=Module[
	{listedOptions, preparedOptions, resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions, Output -> Options], {OutputFormat}];

	resolvedOptions=ExperimentMicrowaveDigestion[myInput, preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]], Table] && MatchQ[resolvedOptions, {(_Rule | _RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions, ExperimentMicrowaveDigestion],
		resolvedOptions
	]
];



(* ------------- *)
(* -- PREVIEW -- *)
(* ------------- *)


DefineOptions[ExperimentMicrowaveDigestionPreview,
	SharedOptions :> {ExperimentMicrowaveDigestion}
];

ExperimentMicrowaveDigestionPreview[myInput:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | _String], myOptions:OptionsPattern[ExperimentMicrowaveDigestionPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentMicrowaveDigestion[myInput, ReplaceRule[listedOptions, Output -> Preview]]
];

(* ------------- *)
(* -- VALIDQ -- *)
(* ------------- *)


DefineOptions[ValidExperimentMicrowaveDigestionQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentMicrowaveDigestion}
];

ValidExperimentMicrowaveDigestionQ[myInput:ListableP[ObjectP[{Object[Sample], Object[Container], Object[Sample]}] | _String], myOptions:OptionsPattern[ValidExperimentMicrowaveDigestionQ]]:=Module[
	{listedInput, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions, Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentMicrowaveDigestion[myInput, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest, validObjectBooleans, voqWarnings},
			initialTest=Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1, InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest}, functionTests, voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps=SafeOptions[ValidExperimentMicrowaveDigestionQ, Normal@KeyTake[listedOptions, {Verbose, OutputFormat}]];
	{verbose, outputFormat}=Lookup[safeOps, {Verbose, OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentMicrowaveDigestion" -> allTests|>,
			Verbose -> verbose,
			OutputFormat -> outputFormat
		],
		"ExperimentMicrowaveDigestion"
	]
];





(* ::Subsection::Closed:: *)
(*ExperimentMicrowaveDigestion: Helper Functions*)

(* ------------------- *)
(* -- CHECK OPTIONS -- *)
(* ------------------- *)


(* ======================== *)
(* == microwaveDigestionSampleTests HELPER == *)
(* ======================== *)

(* Conditionally returns appropriate tests based on the number of failing samples and the gather tests boolean
	Inputs:
		testFlag - Indicates if we should actually make tests
		allSamples - The input samples
		badSamples - Samples which are invalid in some way
		testDescription - A description of the sample invalidity check
			- must be formatted as a template with an `1` which can be replaced by a list of samples or "all input samples"
	Outputs:
		out: {(_Test|_Warning)...} - Tests for the good and bad samples - if all samples fall in one category, only one test is returned *)

microwaveDigestionSampleTests[testFlag:False, testHead:(Test | Warning), allSamples_, badSamples_, testDescription_, cache_]:={};

microwaveDigestionSampleTests[testFlag:True, testHead:(Test | Warning), allSamples:{PacketP[]..}, badSamples:{PacketP[]...}, testDescription_String, cache_]:=Module[{
	numberOfSamples, numberOfBadSamples, allSampleObjects, badObjects, goodObjects},

	(* Convert packets to objects *)
	allSampleObjects=Lookup[allSamples, Object];
	badObjects=Lookup[badSamples, Object, {}];

	(* Determine how many of each sample we have - delete duplicates in case one of sample sets was sent to us with duplicates removed *)
	numberOfSamples=Length[DeleteDuplicates[allSampleObjects]];
	numberOfBadSamples=Length[DeleteDuplicates[badObjects]];

	(* Get a list of objects which are okay *)
	goodObjects=Complement[allSampleObjects, badObjects];

	Which[
		(* All samples are okay *)
		MatchQ[numberOfBadSamples, 0], {testHead[StringTemplate[testDescription]["all input samples"], True, True]},

		(* All samples are bad *)
		MatchQ[numberOfBadSamples, numberOfSamples], {testHead[StringTemplate[testDescription]["all input samples"], False, True]},

		(* Mixed samples *)
		True,
		{
			(* Passing Test *)
			testHead[StringTemplate[testDescription][ObjectToString[goodObjects, Cache -> cache]], True, True],
			(* Failing Test *)
			testHead[StringTemplate[testDescription][ObjectToString[badObjects, Cache -> cache]], False, True]
		}
	]
];




(* ======================== *)
(* == sampleIsAquaRegiaQ == *)
(* ======================== *)

(* the helper function determines wheter or not a sample is essentially aqua regia based on its composition *)
sampleIsAquaRegiaQ[composition_List]:=Module[{sufficientNitric, sufficientHCl},

	(* check if there is a concentration of nitric acid high enough to constitute aqua regia (75% or 70 Mass Percent or 15.9 M or ~ 1000 g/L) *)
	sufficientNitric=If[
		MatchQ[
			Cases[
				composition,
				{
					ObjectP[Model[Molecule, "Nitric Acid"]],
					Alternatives[GreaterP[50 MassPercent], GreaterP[11.5 Molar], GreaterP[700 Gram / Liter]]
				}
			],
			Except[{}]
		],
		True,
		False
	];

	(* check if there is a concentration of HCl high enough to constitute aqua regia (25% or 37.2 Mass Percent or 12.1 M or ~ 441 g/L) *)
	sufficientHCl=If[
		MatchQ[
			Cases[
				composition,
				{
					ObjectP[Model[Molecule, "Hydrochloric Acid"]],
					Alternatives[GreaterP[9 MassPercent], GreaterP[3 Molar], GreaterP[110 Gram / Liter]]
				}
			],
			Except[{}]
		],
		True,
		False
	];

	And[sufficientHCl, sufficientNitric]
];


(* ================= *)
(* == howMuchAcid == *)
(* ================= *)

(* -- Determine how many moles of acid there are -- *)
(* volume rules overload *)
(* the cache is generated in the resource packets *)

howMuchAcid[volumeRules_List, cache_Association]:=Total[
	Map[
		Function[volumeRule,
			Module[{acidInfo},

				(* extract the packet that we need to get density, conc, etc from *)
				acidInfo=Lookup[cache, Download[Keys[volumeRule], Object]];

				(* convert the volume to moles via density, mass percent, MW *)
				Times[
					Last[volumeRule],
					Lookup[acidInfo, Density],
					Normal[Lookup[acidInfo, MassPercent]],
					1 / Lookup[acidInfo, MolecularWeight],
					Lookup[acidInfo, AcidicProtons]
				]
			]
		],
		volumeRules
	]
];



(* helper to make comparison to a volume safe, assumes solid has a density of 1 *)
safeVolumeConvert[]:=Null;
safeVolumeConvert[item:MassP]:=item/Quantity[1,"Grams"/"Milliliters"];
safeVolumeConvert[item:VolumeP]:=item;
safeVolumeConvert[list:{MassP|VolumeP...}]:=safeVolumeConvert/@list;
