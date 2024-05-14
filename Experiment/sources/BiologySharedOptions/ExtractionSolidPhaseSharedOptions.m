(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExtractionSolidPhaseSharedOptions*)

$SPESampleFields = {};

$SPEPurificationOptionMap={
	SolidPhaseExtractionStrategy -> ExtractionStrategy,
	SolidPhaseExtractionSeparationMode -> ExtractionMode,
	SolidPhaseExtractionSorbent -> ExtractionSorbent,
	SolidPhaseExtractionCartridge -> ExtractionCartridge,
	SolidPhaseExtractionTechnique -> ExtractionMethod,
	SolidPhaseExtractionInstrument -> Instrument,
	SolidPhaseExtractionCartridgeStorageCondition -> ExtractionCartridgeStorageCondition,
	SolidPhaseExtractionLoadingSampleVolume -> LoadingSampleVolume,
	SolidPhaseExtractionLoadingTemperature -> LoadingSampleTemperature,
	SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> LoadingSampleTemperatureEquilibrationTime,
	SolidPhaseExtractionLoadingCentrifugeIntensity -> LoadingSampleCentrifugeIntensity,
	SolidPhaseExtractionLoadingPressure -> LoadingSamplePressure,
	SolidPhaseExtractionLoadingTime -> LoadingSampleDrainTime,
	CollectSolidPhaseExtractionLoadingFlowthrough -> CollectLoadingSampleFlowthrough,
	SolidPhaseExtractionLoadingFlowthroughContainerOut -> LoadingSampleFlowthroughContainer,
	SolidPhaseExtractionWashSolution -> WashingSolution,
	SolidPhaseExtractionWashSolutionVolume -> WashingSolutionVolume,
	SolidPhaseExtractionWashTemperature -> WashingSolutionTemperature,
	SolidPhaseExtractionWashTemperatureEquilibrationTime -> WashingSolutionTemperatureEquilibrationTime,
	SolidPhaseExtractionWashCentrifugeIntensity -> WashingSolutionCentrifugeIntensity,
	SolidPhaseExtractionWashPressure -> WashingSolutionPressure,
	SolidPhaseExtractionWashTime -> WashingSolutionDrainTime,
	CollectSolidPhaseExtractionWashFlowthrough -> CollectWashingSolution,
	SolidPhaseExtractionWashFlowthroughContainerOut -> WashingSolutionCollectionContainer,
	SecondarySolidPhaseExtractionWashSolution -> SecondaryWashingSolution,
	SecondarySolidPhaseExtractionWashSolutionVolume -> SecondaryWashingSolutionVolume,
	SecondarySolidPhaseExtractionWashTemperature -> SecondaryWashingSolutionTemperature,
	SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> SecondaryWashingSolutionTemperatureEquilibrationTime,
	SecondarySolidPhaseExtractionWashCentrifugeIntensity -> SecondaryWashingSolutionCentrifugeIntensity,
	SecondarySolidPhaseExtractionWashPressure -> SecondaryWashingSolutionPressure,
	SecondarySolidPhaseExtractionWashTime -> SecondaryWashingSolutionDrainTime,
	CollectSecondarySolidPhaseExtractionWashFlowthrough -> CollectSecondaryWashingSolution,
	SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> SecondaryWashingSolutionCollectionContainer,
	TertiarySolidPhaseExtractionWashSolution -> TertiaryWashingSolution,
	TertiarySolidPhaseExtractionWashSolutionVolume -> TertiaryWashingSolutionVolume,
	TertiarySolidPhaseExtractionWashTemperature -> TertiaryWashingSolutionTemperature,
	TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> TertiaryWashingSolutionTemperatureEquilibrationTime,
	TertiarySolidPhaseExtractionWashCentrifugeIntensity -> TertiaryWashingSolutionCentrifugeIntensity,
	TertiarySolidPhaseExtractionWashPressure -> TertiaryWashingSolutionPressure,
	TertiarySolidPhaseExtractionWashTime -> TertiaryWashingSolutionDrainTime,
	CollectTertiarySolidPhaseExtractionWashFlowthrough -> CollectTertiaryWashingSolution,
	TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> TertiaryWashingSolutionCollectionContainer,
	SolidPhaseExtractionElutionSolution -> ElutingSolution,
	SolidPhaseExtractionElutionSolutionVolume -> ElutingSolutionVolume,
	SolidPhaseExtractionElutionSolutionTemperature -> ElutingSolutionTemperature,
	SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> ElutingSolutionTemperatureEquilibrationTime,
	SolidPhaseExtractionElutionCentrifugeIntensity -> ElutingSolutionCentrifugeIntensity,
	SolidPhaseExtractionElutionPressure -> ElutingSolutionPressure,
	SolidPhaseExtractionElutionTime -> ElutingSolutionDrainTime
};

DefineOptionSet[ExtractionSolidPhaseSharedOptions:>{

	(* --- GENERAL OPTIONS --- *)
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ExtractionStrategy,
		{
			OptionName -> SolidPhaseExtractionStrategy,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if the target analyte or the impurities are adsorbed on the solid phase extraction column sorbent material while the other material passes through. Positive indicates that analytes of interest are adsorbed onto the extraction column sorbent and impurities pass through. Negative indicates that impurities adsorb onto the extraction column sorbent and target analytes pass through unretained.",
			(*Calling this option directly it will resolve to Positive. Can use ModifyOptions when calling this option set to target/experiment-specific resolution*)
			ResolutionDescription -> "Automatically set to the SolidPhaseExtractionStrategy specified by the selected Method. If Method is set to Custom, automatically set to Positive indicating that the target analyte is retained on the column sorbent.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ExtractionMode,
		{
			OptionName -> SolidPhaseExtractionSeparationMode,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> IonExchange | SizeExclusion | Affinity(*for now only have patterns that have kits for it but may need to expand this list*)
			],
			Description -> "The mechanism by which the mobile phase and solid support separate impurities from target analytes. IonExchange separates compounds based on charge where the sorbent material retains oppositely charged molecules on its surface. Affinity separates compounds based on \"Lock-and-Key\" model between molecules and sorbent materials, where the sorbent material selectively retains molecules of interest. SizeExclusion separates compounds based on hydrodynamic radius, which is proportional to molecular weight, where sorbent material allows smaller molecules to flow into pores while larger molecules bypass the pores and travel around the outside of the resin material. As a result, smaller molecules process though the column more slowly. Compounds elute in order of decreasing molecular weight.",
			(*Calling this option directly it will resolve to IonExchane. Can use ModifyOptions when calling this option set to target/experiment-specific resolution*)
			ResolutionDescription -> "Automatically set to match the SolidPhaseExtractionMode specified by the selected Method. If Method is set to Custom, automatically set to the SolidPhaseExtractionMode defined by the selected SolidPhaseExtractionSorbent (either directly by setting the SolidPhaseExtractionSorbent or indirectly by specifying a SolidPhaseExtractionCartridge). If no Method, SolidPhaseExtractionSorbent, nor SolidPhaseExtractionCartridge is selected, SolidPhaseExtractionMode is automatically set to IonExchange, matching the default SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ExtractionSorbent,
		{
			OptionName -> SolidPhaseExtractionSorbent,
			AllowNull -> True,
			Description -> "The chemistry of the solid phase material which interacts with the molecular components of the sample in order to retain either the target analyte(s) or the impurities on the extraction column. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionSorbent adsorbs the target analyte while impurities pass through. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionSorbent adsorbs impurities while the target analyte passes through unretained.",
			(*Calling this option directly it will resolve to IonExchange. Can use ModifyOptions when calling this option set to target/experiment-specific resolution*)
			ResolutionDescription -> "Automatically set to the SolidPhaseExtractionSorbent specified by the selected Method. If Method is set to Custom and a SolidPhaseExtractionCartridge is specified, automatically set to match the SolidPhaseExtractionSorbent defined by the selected SolidPhaseExtractionCartridge. If Method is set to Custom and no SolidPhaseExtractionCartridge is specified, SolidPhaseExtractionSorbent is automatically set to Silica, matching the default SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ExtractionCartridge,
		{
			OptionName -> SolidPhaseExtractionCartridge,
			AllowNull -> True,
			Description -> "The container that is packed with SolidPhaseExtractionSorbent, which forms the stationary phase for extraction of the target analyte.",
			(*Use ModifyOptions when calling this option set to target/experiment-specific resolution*)
			ResolutionDescription -> "Automatically set to the SolidPhaseExtractionCartridge specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionSorbent or SolidPhaseExtractionMode are specified, automatically set to a SolidPhaseExtractionCartridge that contains the selected SolidPhaseExtractionSorbent or separates molecules by the selected SolidPhaseExtractionMode. Otherwise, SolidPhaseExtractionCartridge is automatically set to Model[Container,Plate,\"NucleoSpin 96 silica SPE plate\"].", (*change this for different experiments that use SPE shared options *)
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ExtractionMethod,
		{
			OptionName -> SolidPhaseExtractionTechnique,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Pressure | Centrifuge
			],
			Description -> "The type of force that is used to flush fluid through the SolidPhaseExtractionSorbent during Loading, Washing, and Eluting steps.",
			ResolutionDescription -> "Automatically set to the SolidPhaseExtractionTechnique specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionTechnique is automatically set to Pressure.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		Instrument,
		{
			OptionName -> SolidPhaseExtractionInstrument,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Instrument, Centrifuge], Object[Instrument, Centrifuge],
					Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]
				}]
			],
			Description -> "The Instrument that generates force to flush fluid through the SolidPhaseExtractionSorbent during Loading, Washing, and Eluting steps.",
			ResolutionDescription -> "Automatically set to the SolidPhaseExtractionInstrument specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionInstrument is automatically set to match the specified SolidPhaseExtractionTechnique. Otherwise, SolidPhaseExtractionInstrument is automatically set to Model[Instrument,PressureManifold,\"MPE2\"].",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ExtractionCartridgeStorageCondition,
		{
			OptionName -> SolidPhaseExtractionCartridgeStorageCondition,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The conditions under which SolidPhaseExtractionCartridge used by this experiment is stored after the protocol is completed.",
			ResolutionDescription -> "Automatically set to Disposal.",
			Category -> "Solid Phase Extraction"
		}
	],

	(*removed loading solution options from SPE shared options, will be resolved outside of SPE*)

	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSampleVolume,
		{
			OptionName -> SolidPhaseExtractionLoadingSampleVolume,
			AllowNull -> True,
			Category -> "Solid Phase Extraction",
			NestedIndexMatching -> False
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSampleTemperature,
		{
			OptionName -> SolidPhaseExtractionLoadingTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
					Units -> {Celsius, {Celsius, Fahrenheit}}
				]
			],
			Description -> "The temperature at which the Instrument heating or cooling the sample is maintained during the SolidPhaseExtractionLoadingTemperatureEquilibrationTime, which occurs before loading the sample into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the loading sample temperature specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionLoadingTemperature is automatically set to Ambient.",
			Category -> "Hidden",
			NestedIndexMatching -> False
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSampleTemperatureEquilibrationTime,
		{
			OptionName -> SolidPhaseExtractionLoadingTemperatureEquilibrationTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration for which the sample is held at the SolidPhaseExtractionLoadingTemperature before loading the sample into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the loading temperature equilibration time specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionLoadingTemperature is not Ambient, SolidPhaseExtractionLoadingTemperatureEquilibrationTime is automatically set to 3 Minutes.",
			Category -> "Hidden",
			NestedIndexMatching -> False
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSampleCentrifugeIntensity,
		{
			OptionName -> SolidPhaseExtractionLoadingCentrifugeIntensity,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Speed" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, $MaxRoboticCentrifugeSpeed],
					Units -> {RPM, {RPM}}
				],
				"Force" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
					Units -> {GravitationalAcceleration, {GravitationalAcceleration}}
				]
			],
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush the loading sample through the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the loading centrifuge intensity specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionLoadingCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed if SolidPhaseExtractionTechnique is set to Centrifuge.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSamplePressure,
		{
			OptionName -> SolidPhaseExtractionLoadingPressure,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * PSI, $MaxRoboticAirPressure],
				Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
			],
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush the loading sample through the SolidPhaseExtractionSorbent in order to bind the target analyte(s) or impurities to the extraction column.",
			ResolutionDescription -> "Automatically set to the loading pressure specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionTechnique is set to Pressure, SolidPhaseExtractionLoadingPressure is automatically set to the MaxRoboticAirPressure if SolidPhaseExtractionTechnique is set to Pressure.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSampleDrainTime,
		{
			OptionName -> SolidPhaseExtractionLoadingTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush the loading sample through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to load the sample onto the column.",
			ResolutionDescription -> "Automatically set to the loading time specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionLoadingTime is automatically set to 1 Minute.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		CollectLoadingSampleFlowthrough,
		{
			OptionName -> CollectSolidPhaseExtractionLoadingFlowthrough,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if the loaded sample solution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
			ResolutionDescription -> "Automatically set to CollectSolidPhaseExtractionLoadingFlowthrough specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionStrategy is set to Positive, then CollectSolidPhaseExtractionLoadingFlowthrough is automatically set to False. If Method is set to Custom and SolidPhaseExtractionStrategy is set to Negative, then CollectSolidPhaseExtractionLoadingFlowthrough is automatically set to True",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		LoadingSampleFlowthroughContainer,
		{
			OptionName -> SolidPhaseExtractionLoadingFlowthroughContainerOut,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				}
			],
			Description -> "The container used to collect the loaded sample solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionLoadingTime.",
			ResolutionDescription -> "Automatically set to the collection container specified by the selected Method. If Method is set to Custom, then SolidPhaseExtractionLoadingFlowthroughContainerOut is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if CollectSolidPhaseExtractionLoadingFlowthrough is set to True.",
			Category -> "Solid Phase Extraction"
		}
	],

	(* --- WASH OPTIONS --- *)

	(*TODO :: SPE currently has a Washing boolean option for each wash step, but will be changing to have an integer option of 0 - 5 washes; will add that option here after its changed in SPE *)

	(*TODO :: after the option for number of washes is updated, use ModifyOptions to change the Description to include information about how any of the 5 wash steps can be used for digestion by selecting the digestion enzyme solution for the WashSolution option. Something like: "Wash steps can be used to apply other reagents (eg. digestion enzyme solution) to the SolidPhaseExtractionSorbent by specifying the reagent or solution in the SolidPhaseExtractionWashSolution option for that step." *)
	(*	{
			OptionName->NumberOfSolidPhaseExtractionWashes,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[
					Type->Number,
					Pattern:>RangeP[0,20,1]
				],
				Adder[Alternatives[
					Widget[
						Type->Number,
						Pattern:>RangeP[0,20,1]
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Null,Automatic]
					]
				]]
			],
			Description->"The number of times that SolidPhaseExtractionWashSolution is flushed through SolidPhaseExtractionSorbent by Centrifuge or by application of Pressure, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the target analyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription->"Automatically set to the number of washes specified by the selected Method. If Method is set to Custom, automatically set to 1 wash.",
			Category->"Solid Phase Extraction"
		},*)
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolution,
		{
			OptionName -> SolidPhaseExtractionWashSolution,
			Default -> Automatic,
			AllowNull -> True,
			(*TODO :: check catalog update in SPE widget *)
			Description -> "The solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, automatically set to ", (* TODO: default wash buffer *)(*default buffer should be changed in each extraction experiment that uses SPE shared options *)
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionVolume,
		{
			OptionName -> SolidPhaseExtractionWashSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The volume of SolidPhaseExtractionWashSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash solution volume specified by the selected Method. If Method is set to Custom and a SolidPhaseExtractionWashSolution is specified, SolidPhaseExtractionWashSolutionVolume is automatically set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionTemperature,
		{
			OptionName -> SolidPhaseExtractionWashTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
					Units -> {Celsius, {Celsius, Fahrenheit}}
				]
			],
			Description -> "The temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the wash temperature specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashTemperature is automatically set to Ambient.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionTemperatureEquilibrationTime,
		{
			OptionName -> SolidPhaseExtractionWashTemperatureEquilibrationTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the wash temperature equilibration time specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionWashTemperature is not Ambient, SolidPhaseExtractionWashTemperatureEquilibrationTime is automatically set to 3 Minutes.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionCentrifugeIntensity,
		{
			OptionName -> SolidPhaseExtractionWashCentrifugeIntensity,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Speed" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, $MaxRoboticCentrifugeSpeed],
					Units -> {RPM, {RPM}}
				],
				"Force" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
					Units -> {GravitationalAcceleration, {GravitationalAcceleration}}
				]
			],
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash centrifuge intensity specified by the selected Method. If Method is set to Custom, automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the plate model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionPressure,
		{
			OptionName -> SolidPhaseExtractionWashPressure,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * PSI, $MaxRoboticAirPressure],
				Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
			],
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash pressure specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionTechnique is set to Pressure, SolidPhaseExtractionWashPressure is automatically set to match SolidPhaseExtractionLoadingPressure. If SolidPhaseExtractionLoadingPressure is not specified, SolidPhaseExtractionWashPressure is automatically set to the lesser of the MaxPressure of the positive pressure instrument model and the MaxPressure of the SolidPhaseExtractionCartridge model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionDrainTime,
		{
			OptionName -> SolidPhaseExtractionWashTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash time specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashTime is automatically set to 30 seconds.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		CollectWashingSolution,
		{
			OptionName -> CollectSolidPhaseExtractionWashFlowthrough,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if SolidPhaseExtractionWashSolution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
			ResolutionDescription -> "If SolidPhaseExtractionWashFlowthroughContainerOut is set, then CollectSolidPhaseExtractionWashFlowthrough is automatically set to True. Otherwise, CollectSolidPhaseExtractionWashFlowthrough is set to False.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		WashingSolutionCollectionContainer,
		{
			OptionName -> SolidPhaseExtractionWashFlowthroughContainerOut,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Index and Container" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					}
				}
			],
			Description -> "The container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionWashTime.",
			ResolutionDescription -> "Automatically set to the collection container specified by the selected Method. Otherwise, if CollectSolidPhaseExtractionWashFlowthrough is set to True, then SolidPhaseExtractionWashFlowthroughContainerOut is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Category -> "Solid Phase Extraction"
		}
	],

	(*Secondary Wash Options*)
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolution,
		{
			OptionName -> SecondarySolidPhaseExtractionWashSolution,
			Default -> Automatic,
			AllowNull -> True,
			(*TODO :: check catalog update in SPE widget *)
			Description -> "The solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, SecondarySolidPhaseExtractionWashSolution is automatically set to the same solution as the SolidPhaseExtractionWashSolution",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionVolume,
		{
			OptionName -> SecondarySolidPhaseExtractionWashSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The volume of SolidPhaseExtractionWashSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash solution volume specified by the selected Method. If Method is set to Custom and a SecondarySolidPhaseExtractionWashSolution is specified, SecondarySolidPhaseExtractionWashSolutionVolume is automatically set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionTemperature,
		{
			OptionName -> SecondarySolidPhaseExtractionWashTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
					Units -> {Celsius, {Celsius, Fahrenheit}}
				]
			],
			Description -> "The temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the wash temperature specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashTemperature is automatically set to Ambient.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionTemperatureEquilibrationTime,
		{
			OptionName -> SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the wash temperature equilibration time specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionWashTemperature is not Ambient, SolidPhaseExtractionWashTemperatureEquilibrationTime is automatically set to 3 Minutes.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionCentrifugeIntensity,
		{
			OptionName -> SecondarySolidPhaseExtractionWashCentrifugeIntensity,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Speed" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, $MaxRoboticCentrifugeSpeed],
					Units -> {RPM, {RPM}}
				],
				"Force" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
					Units -> {GravitationalAcceleration, {GravitationalAcceleration}}
				]
			],
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash centrifuge intensity specified by the selected Method. If Method is set to Custom, automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the plate model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionPressure,
		{
			OptionName -> SecondarySolidPhaseExtractionWashPressure,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * PSI, $MaxRoboticAirPressure],
				Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
			],
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash pressure specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionTechnique is set to Pressure, SolidPhaseExtractionWashPressure is automatically set to match SolidPhaseExtractionLoadingPressure. If SolidPhaseExtractionLoadingPressure is not specified, SolidPhaseExtractionWashPressure is automatically set to the lesser of the MaxPressure of the positive pressure instrument model and the MaxPressure of the SolidPhaseExtractionCartridge model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionDrainTime,
		{
			OptionName -> SecondarySolidPhaseExtractionWashTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash time specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashTime is automatically set to 30 seconds.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		CollectSecondaryWashingSolution,
		{
			OptionName -> CollectSecondarySolidPhaseExtractionWashFlowthrough,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if SolidPhaseExtractionWashSolution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
			ResolutionDescription -> "If SecondarySolidPhaseExtractionWashFlowthroughContainerOut is set, then CollectSecondarySolidPhaseExtractionWashFlowthrough is automatically set to True. Otherwise, CollectSecondarySolidPhaseExtractionWashFlowthrough is set to False.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		SecondaryWashingSolutionCollectionContainer,
		{
			OptionName -> SecondarySolidPhaseExtractionWashFlowthroughContainerOut,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Index and Container" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					}
				}
			],
			Description -> "The container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionWashTime.",
			ResolutionDescription -> "Automatically set to the collection container specified by the selected Method. Otherwise, if CollectSecondarySolidPhaseExtractionWashFlowthrough is set to True, then SecondarySolidPhaseExtractionWashFlowthroughContainerOut is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Category -> "Solid Phase Extraction"
		}
	],

	(*Tertiary Wash Options*)
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolution,
		{
			OptionName -> TertiarySolidPhaseExtractionWashSolution,
			Default -> Automatic,
			AllowNull -> True,
			(*TODO :: check catalog update in SPE widget *)
			Description -> "The solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash solution specified by the selected Method. If Method is set to Custom, TertiarySolidPhaseExtractionWashSolution is automatically set to the same solution as the SolidPhaseExtractionWashSolution",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionVolume,
		{
			OptionName -> TertiarySolidPhaseExtractionWashSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The volume of SolidPhaseExtractionWashSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash solution volume specified by the selected Method. If Method is set to Custom and a TertiarySolidPhaseExtractionWashSolution is specified, TertiarySolidPhaseExtractionWashSolutionVolume is automatically set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionTemperature,
		{
			OptionName -> TertiarySolidPhaseExtractionWashTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
					Units -> {Celsius, {Celsius, Fahrenheit}}
				]
			],
			Description -> "The temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the wash temperature specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashTemperature is automatically set to Ambient.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionTemperatureEquilibrationTime,
		{
			OptionName -> TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the wash temperature equilibration time specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionWashTemperature is not Ambient, SolidPhaseExtractionWashTemperatureEquilibrationTime is automatically set to 3 Minutes.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionCentrifugeIntensity,
		{
			OptionName -> TertiarySolidPhaseExtractionWashCentrifugeIntensity,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Speed" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, $MaxRoboticCentrifugeSpeed],
					Units -> {RPM, {RPM}}
				],
				"Force" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
					Units -> {GravitationalAcceleration, {GravitationalAcceleration}}
				]
			],
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash centrifuge intensity specified by the selected Method. If Method is set to Custom, automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the plate model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionPressure,
		{
			OptionName -> TertiarySolidPhaseExtractionWashPressure,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * PSI, $MaxRoboticAirPressure],
				Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
			],
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash pressure specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionTechnique is set to Pressure, SolidPhaseExtractionWashPressure is automatically set to match SolidPhaseExtractionLoadingPressure. If SolidPhaseExtractionLoadingPressure is not specified, SolidPhaseExtractionWashPressure is automatically set to the lesser of the MaxPressure of the positive pressure instrument model and the MaxPressure of the SolidPhaseExtractionCartridge model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionDrainTime,
		{
			OptionName -> TertiarySolidPhaseExtractionWashTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the wash time specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionWashTime is automatically set to 30 seconds.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		CollectTertiaryWashingSolution,
		{
			OptionName -> CollectTertiarySolidPhaseExtractionWashFlowthrough,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if SolidPhaseExtractionWashSolution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
			ResolutionDescription -> "If TertiarySolidPhaseExtractionWashFlowthroughContainerOut is set, then CollectTertiarySolidPhaseExtractionWashFlowthrough is automatically set to True. Otherwise, CollectTertiarySolidPhaseExtractionWashFlowthrough is set to False.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		TertiaryWashingSolutionCollectionContainer,
		{
			OptionName -> TertiarySolidPhaseExtractionWashFlowthroughContainerOut,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Index and Container" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					}
				}
			],
			Description -> "The container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionWashTime.",
			ResolutionDescription -> "Automatically set to the collection container specified by the selected Method. Otherwise, if CollectTertiarySolidPhaseExtractionWashFlowthrough is set to True, then TertiarySolidPhaseExtractionWashFlowthroughContainerOut is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Category -> "Solid Phase Extraction"
		}
	],

	(*TODO :: ADD QUARTERNARY AND QUINTENARY WASH OPTIONS HERE AFTER SPE IS UPDATED.*)

	(* removed options for preparing the digestion enzyme solution from SPE shared options. Preparation of the enzyme solution (diluting enzyme, mixing, and incubating) will be resolved outside of the SPE experiment call as sample prep. The prepared enzyme solution will be used as a 'wash solution' for one of the 5 wash steps when calling SPE. *)

	(* Digestion wash options below will be covered by primary, secondary, tertiary, quarternary, or quintenary wash steps. If a digestion is performed, the enzyme solution is specified as the WashSolution in one of the 5 wash steps, and the digestion wash buffer (if there is one) can be specified as the WashSolution for the following wash step. *)

	(* --- ELUTION OPTIONS --- *)
	(*	{
			*)(*TODO :: SPE has an Elution boolean option but no NumberOfElutions option, whereas here there is a NumberOfElutions, which can be set to 0, but no boolean. This may change in SPE, or need to add the boolean option here *)(*
		OptionName->NumberOfSolidPhaseExtractionElutions,
		Default->Automatic,
		AllowNull->True,
		Widget->Widget[
			Type->Number,
			Pattern:>RangeP[1,20,1]
		],
		Description->"The number of times that the SolidPhaseExtractionElutionSolution is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
		ResolutionDescription->"Automatically set to the number of elutions specified by the selected Method. If Method is set to Custom, automatically set to 1 elution.",
		Category->"Solid Phase Extraction"
	},*)
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolution,
		{
			OptionName -> SolidPhaseExtractionElutionSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Elution Solution" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
					(* TODO After catalog *)
					(*
					OpenPaths -> {
					  {Object[Catalog,"Root"],"Materials","Solid Phase Extraction (SPE)","Elution Solution"}
					}*)
				],
				"None" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[None]
				]
			],
			Description -> "The solution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent. SolidPhaseExtractionElutionSolution can be set to None if an elution step will not be used.",
			(*Calling this option directly it will resolve to Milli-Q water. Can use ModifyOptions when calling this option set to target/experiment-specific resolution*)
			ResolutionDescription -> "Automatically set to the elution solution specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionSolution is automatically set to Model[Sample,\"RNase-free water\"].",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolutionVolume,
		{
			OptionName -> SolidPhaseExtractionElutionSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The volume of SolidPhaseExtractionElutionSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the elution solution volume specified by the selected Method. If Method is set to Custom and a SolidPhaseExtractionElutionSolution is specified, then SolidPhaseExtractionElutionSolution is set to 50% of the MaxVolume of the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolutionTemperature,
		{
			OptionName -> SolidPhaseExtractionElutionSolutionTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
					Units -> {Celsius, {Celsius, Fahrenheit}}
				]
			],
			Description -> "The temperature at which the SolidPhaseExtractionElutionSolution is incubated for SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime before being flushed through the SolidPhaseExtractionSorbent to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent. The final temperature of the SolidPhaseExtractionElutionSolution is assumed to equilibrate with the SolidPhaseExtractionElutionSolutionTemperature.",
			ResolutionDescription -> "Automatically set to the elution solution temperature specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionSolutionTemperature is automatically set to Ambient.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolutionTemperatureEquilibrationTime,
		{
			OptionName -> SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration for which SolidPhaseExtractionElutionSolution is held at the SolidPhaseExtractionElutionSolutionTemperature before adding the SolidPhaseExtractionElutionSolution into the SolidPhaseExtractionCartridge.",
			ResolutionDescription -> "Automatically set to the elution solution temperature equilibration time specified by the selected Method. If Method is set to Custom and SolidPhaseExtractionElutionSolutionTemperature is not Ambient, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime is automatically set to 10 Minutes.",
			Category -> "Hidden"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolutionCentrifugeIntensity,
		{
			OptionName -> SolidPhaseExtractionElutionCentrifugeIntensity,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Speed" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, $MaxRoboticCentrifugeSpeed],
					Units -> {RPM, {RPM}}
				],
				"Force" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
					Units -> {GravitationalAcceleration, {GravitationalAcceleration}}
				]
			],
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush the SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the elution centrifuge intensity specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionCentrifugeIntensity is automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the plate model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolutionPressure,
		{
			OptionName -> SolidPhaseExtractionElutionPressure,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * PSI, $MaxRoboticAirPressure],
				Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
			],
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the elution pressure specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionPressure is automatically set to match SolidPhaseExtractionLoadingPressure. If SolidPhaseExtractionLoadingPressure is not specified, SolidPhaseExtractionElutionPressure is automatically set to the lesser of the MaxPressure of the positive pressure instrument model and the MaxPressure of the SolidPhaseExtractionCartridge model.",
			Category -> "Solid Phase Extraction"
		}
	],
	ModifyOptions[ExperimentSolidPhaseExtraction,
		ElutingSolutionDrainTime,
		{
			OptionName -> SolidPhaseExtractionElutionTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration for which the SolidPhaseExtractionInstrument applies force to the SolidPhaseExtractionCartridge to flush the SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
			ResolutionDescription -> "Automatically set to the elution time specified by the selected Method. If Method is set to Custom, SolidPhaseExtractionElutionTime is automatically set to 1 Minute.",
			Category -> "Solid Phase Extraction"
		}
	]
}];


(* ::Subsection:: *)
(*preResolveExtractionSolidPhaseSharedOptions*)

DefineOptions[
	preResolveExtractionSolidPhaseSharedOptions,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName->TargetCellularComponent,
				Default->Unspecified,
				AllowNull->False,
				Widget->Alternatives[
					"Unspecified" -> Widget[Type->Enumeration, Pattern:>Alternatives[Unspecified]],
					"Cellular Component(s)" -> Widget[Type->Enumeration, Pattern:>Alternatives[CellularComponentP]],
					"RNA" -> Widget[Type->Enumeration, Pattern:>CellularRNAP],
					"Molecule" -> Widget[Type->Object, Pattern:>ObjectP[Model[Molecule]]]
				],
				Description->"The desired cellular component to be isolated by the purification steps.",
				Category -> "General"
			}
		],
		CacheOption,
		SimulationOption
	}
];

preResolveExtractionSolidPhaseSharedOptions[
	mySamples:{ObjectP[Object[Sample]]...},
	myMethods:{(ObjectP[Object[Method]]|Custom)..},
	myOptionMap_List,
	myOptions_List,
	myMapThreadOptions:{_Association..},
	myResolutionOptions:OptionsPattern[preResolveExtractionSolidPhaseSharedOptions]
]:= Module[
	{
		safeOptions, expandedInputs, expandedSafeOps, outputSpecification, output, gatherTestsQ, messages, cache, simulation, targets,

		sampleFields, samplePacketFields, methodFields, methodPacketFields, samplePackets, methodPackets,

		simplePreResolveOptionNoMethod,

		preResolvedSolidPhaseExtractionStrategy, preResolvedSolidPhaseExtractionSeparationMode, preResolvedSolidPhaseExtractionSorbent,
		preResolvedSolidPhaseExtractionCartridge, preResolvedSolidPhaseExtractionTechnique, preResolvedSolidPhaseExtractionInstrument,
		preResolvedSolidPhaseExtractionCartridgeStorageCondition, preResolvedSolidPhaseExtractionLoadingSampleVolume, preResolvedSolidPhaseExtractionLoadingTemperature,
		preResolvedSolidPhaseExtractionLoadingTemperatureEquilibrationTime, preResolvedSolidPhaseExtractionLoadingCentrifugeIntensity,
		preResolvedSolidPhaseExtractionLoadingPressure, preResolvedSolidPhaseExtractionLoadingTime, preResolvedCollectSolidPhaseExtractionLoadingFlowthrough,
		preResolvedSolidPhaseExtractionLoadingFlowthroughContainerOut, preResolvedSolidPhaseExtractionWashSolution, preResolvedSolidPhaseExtractionWashSolutionVolume,
		preResolvedSolidPhaseExtractionWashTemperature, preResolvedSolidPhaseExtractionWashTemperatureEquilibrationTime,
		preResolvedSolidPhaseExtractionWashCentrifugeIntensity, preResolvedSolidPhaseExtractionWashPressure, preResolvedSolidPhaseExtractionWashTime,
		preResolvedCollectSolidPhaseExtractionWashFlowthrough, preResolvedSolidPhaseExtractionWashFlowthroughContainerOut,
		preResolvedSecondarySolidPhaseExtractionWashSolution, preResolvedSecondarySolidPhaseExtractionWashSolutionVolume,
		preResolvedSecondarySolidPhaseExtractionWashTemperature, preResolvedSecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		preResolvedSecondarySolidPhaseExtractionWashCentrifugeIntensity, preResolvedSecondarySolidPhaseExtractionWashPressure,
		preResolvedSecondarySolidPhaseExtractionWashTime, preResolvedCollectSecondarySolidPhaseExtractionWashFlowthrough,
		preResolvedSecondarySolidPhaseExtractionWashFlowthroughContainerOut, preResolvedTertiarySolidPhaseExtractionWashSolution,
		preResolvedTertiarySolidPhaseExtractionWashSolutionVolume, preResolvedTertiarySolidPhaseExtractionWashTemperature,
		preResolvedTertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, preResolvedTertiarySolidPhaseExtractionWashCentrifugeIntensity,
		preResolvedTertiarySolidPhaseExtractionWashPressure, preResolvedTertiarySolidPhaseExtractionWashTime, preResolvedCollectTertiarySolidPhaseExtractionWashFlowthrough,
		preResolvedTertiarySolidPhaseExtractionWashFlowthroughContainerOut, preResolvedSolidPhaseExtractionElutionSolution,
		preResolvedSolidPhaseExtractionElutionSolutionVolume, preResolvedSolidPhaseExtractionElutionSolutionTemperature,
		preResolvedSolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, preResolvedSolidPhaseExtractionElutionCentrifugeIntensity,
		preResolvedSolidPhaseExtractionElutionPressure, preResolvedSolidPhaseExtractionElutionTime

	},

	(* Get safe options *)
	safeOptions = SafeOptions[preResolveExtractionSolidPhaseSharedOptions, ToList[myResolutionOptions]];

	(* Determine the requested output format of this function. *)
	outputSpecification = Lookup[myOptions, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTestsQ = MemberQ[output, Tests];
	messages = !gatherTestsQ;

	(* Expand the safe options. *)
	{expandedInputs, expandedSafeOps} = ExpandIndexMatchedInputs[preResolveExtractionSolidPhaseSharedOptions, {mySamples, myMethods, myOptionMap, myOptions, myMapThreadOptions}, safeOptions];

	(* Lookup Cache and Simulation from the safe options*)
	cache = Lookup[safeOptions, Cache];
	simulation = Lookup[safeOptions, Simulation];
	targets = Lookup[expandedSafeOps, TargetCellularComponent, Null];

	(* DOWNLOAD sample packets and method packets *)
	sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Container, Position}]];
	samplePacketFields = Packet @@ sampleFields;
	methodFields = DeleteDuplicates[Flatten[{Purification, SecondarySolidPhaseExtractionWashCentrifugeIntensity,SecondarySolidPhaseExtractionWashPressure,SecondarySolidPhaseExtractionWashSolution,SecondarySolidPhaseExtractionWashTemperature,SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,SecondarySolidPhaseExtractionWashTime,SolidPhaseExtractionCartridge,SolidPhaseExtractionDigestionTemperature,SolidPhaseExtractionDigestionTime,SolidPhaseExtractionElutionCentrifugeIntensity,SolidPhaseExtractionElutionPressure,SolidPhaseExtractionElutionSolution,SolidPhaseExtractionElutionSolutionTemperature,SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,SolidPhaseExtractionElutionTime,SolidPhaseExtractionLoadingCentrifugeIntensity,SolidPhaseExtractionLoadingPressure,SolidPhaseExtractionLoadingTemperature,SolidPhaseExtractionLoadingTemperatureEquilibrationTime,SolidPhaseExtractionLoadingTime,SolidPhaseExtractionSeparationMode,SolidPhaseExtractionSorbent,SolidPhaseExtractionStrategy,SolidPhaseExtractionTechnique,SolidPhaseExtractionWashCentrifugeIntensity,SolidPhaseExtractionWashPressure,SolidPhaseExtractionWashSolution,SolidPhaseExtractionWashTemperature,SolidPhaseExtractionWashTemperatureEquilibrationTime,SolidPhaseExtractionWashTime,TertiarySolidPhaseExtractionWashCentrifugeIntensity,TertiarySolidPhaseExtractionWashPressure,TertiarySolidPhaseExtractionWashSolution,TertiarySolidPhaseExtractionWashTemperature,TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,TertiarySolidPhaseExtractionWashTime}]];
	methodPacketFields = Packet @@ methodFields;

	{
		samplePackets,
		methodPackets
	} = Download[
		{
			mySamples,
			Replace[myMethods, {Except[ObjectP[]] -> Null}, 1]
		},
		{
			{samplePacketFields},
			{methodPacketFields}
		},
		Cache -> cache,
		Simulation -> simulation
	];

	{
		samplePackets,
		methodPackets
	} = Flatten /@ {
		samplePackets,
		methodPackets
	};

	(* helper function that does simple pre-resolution logic with no method:*)
	simplePreResolveOptionNoMethod[myOptionName_Symbol, mapThreadedOptions_Association, mySPEUsedQ:BooleanP]:=Which[
		(* If specified by the user, set to user-specified value *)
		MatchQ[Lookup[mapThreadedOptions, myOptionName], Except[Automatic]],
			Lookup[mapThreadedOptions, myOptionName],
		(* If SPE is not used and the option is not specified, it is set to Null. *)
		!mySPEUsedQ,
			Null,
		True,
			Automatic
	];

	(* Pre-resolve SPE options to check for any options that are specified by the user or by the selected Method, or options that need to be resolved differently than in SPE, before sending the options into the SPE resolver *)
	{
		preResolvedSolidPhaseExtractionStrategy,
		preResolvedSolidPhaseExtractionSeparationMode,
		preResolvedSolidPhaseExtractionSorbent,
		preResolvedSolidPhaseExtractionCartridge,
		preResolvedSolidPhaseExtractionTechnique,
		preResolvedSolidPhaseExtractionInstrument,
		preResolvedSolidPhaseExtractionCartridgeStorageCondition,
		preResolvedSolidPhaseExtractionLoadingSampleVolume,
		preResolvedSolidPhaseExtractionLoadingTemperature,
		preResolvedSolidPhaseExtractionLoadingTemperatureEquilibrationTime,
		preResolvedSolidPhaseExtractionLoadingCentrifugeIntensity,
		preResolvedSolidPhaseExtractionLoadingPressure,
		preResolvedSolidPhaseExtractionLoadingTime,
		preResolvedCollectSolidPhaseExtractionLoadingFlowthrough,
		preResolvedSolidPhaseExtractionLoadingFlowthroughContainerOut,
		preResolvedSolidPhaseExtractionWashSolution,
		preResolvedSolidPhaseExtractionWashSolutionVolume,
		preResolvedSolidPhaseExtractionWashTemperature,
		preResolvedSolidPhaseExtractionWashTemperatureEquilibrationTime,
		preResolvedSolidPhaseExtractionWashCentrifugeIntensity,
		preResolvedSolidPhaseExtractionWashPressure,
		preResolvedSolidPhaseExtractionWashTime,
		preResolvedCollectSolidPhaseExtractionWashFlowthrough,
		preResolvedSolidPhaseExtractionWashFlowthroughContainerOut,
		preResolvedSecondarySolidPhaseExtractionWashSolution,
		preResolvedSecondarySolidPhaseExtractionWashSolutionVolume,
		preResolvedSecondarySolidPhaseExtractionWashTemperature,
		preResolvedSecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		preResolvedSecondarySolidPhaseExtractionWashCentrifugeIntensity,
		preResolvedSecondarySolidPhaseExtractionWashPressure,
		preResolvedSecondarySolidPhaseExtractionWashTime,
		preResolvedCollectSecondarySolidPhaseExtractionWashFlowthrough,
		preResolvedSecondarySolidPhaseExtractionWashFlowthroughContainerOut,
		preResolvedTertiarySolidPhaseExtractionWashSolution,
		preResolvedTertiarySolidPhaseExtractionWashSolutionVolume,
		preResolvedTertiarySolidPhaseExtractionWashTemperature,
		preResolvedTertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		preResolvedTertiarySolidPhaseExtractionWashCentrifugeIntensity,
		preResolvedTertiarySolidPhaseExtractionWashPressure,
		preResolvedTertiarySolidPhaseExtractionWashTime,
		preResolvedCollectTertiarySolidPhaseExtractionWashFlowthrough,
		preResolvedTertiarySolidPhaseExtractionWashFlowthroughContainerOut,
		preResolvedSolidPhaseExtractionElutionSolution,
		preResolvedSolidPhaseExtractionElutionSolutionVolume,
		preResolvedSolidPhaseExtractionElutionSolutionTemperature,
		preResolvedSolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
		preResolvedSolidPhaseExtractionElutionCentrifugeIntensity,
		preResolvedSolidPhaseExtractionElutionPressure,
		preResolvedSolidPhaseExtractionElutionTime
	} = Transpose@MapThread[
		Function[{methodPacket, options, target},
			Module[
				{
					speUsedQ, methodSpecifiedQ,

					solidPhaseExtractionStrategy,solidPhaseExtractionSeparationMode,solidPhaseExtractionSorbent,solidPhaseExtractionCartridge,
					solidPhaseExtractionTechnique,solidPhaseExtractionInstrument,solidPhaseExtractionCartridgeStorageCondition,solidPhaseExtractionLoadingSampleVolume,
					solidPhaseExtractionLoadingTemperature,solidPhaseExtractionLoadingTemperatureEquilibrationTime,solidPhaseExtractionLoadingCentrifugeIntensity,
					solidPhaseExtractionLoadingPressure,solidPhaseExtractionLoadingTime,collectSolidPhaseExtractionLoadingFlowthrough,
					solidPhaseExtractionLoadingFlowthroughContainerOut,solidPhaseExtractionWashSolution,solidPhaseExtractionWashSolutionVolume,
					solidPhaseExtractionWashTemperature,solidPhaseExtractionWashTemperatureEquilibrationTime,solidPhaseExtractionWashCentrifugeIntensity,
					solidPhaseExtractionWashPressure,solidPhaseExtractionWashTime,collectSolidPhaseExtractionWashFlowthrough,
					solidPhaseExtractionWashFlowthroughContainerOut,secondarySolidPhaseExtractionWashSolution,secondarySolidPhaseExtractionWashSolutionVolume,
					secondarySolidPhaseExtractionWashTemperature,secondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
					secondarySolidPhaseExtractionWashCentrifugeIntensity,secondarySolidPhaseExtractionWashPressure,secondarySolidPhaseExtractionWashTime,
					collectSecondarySolidPhaseExtractionWashFlowthrough,secondarySolidPhaseExtractionWashFlowthroughContainerOut,
					tertiarySolidPhaseExtractionWashSolution,tertiarySolidPhaseExtractionWashSolutionVolume,tertiarySolidPhaseExtractionWashTemperature,
					tertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,tertiarySolidPhaseExtractionWashCentrifugeIntensity,
					tertiarySolidPhaseExtractionWashPressure,tertiarySolidPhaseExtractionWashTime,collectTertiarySolidPhaseExtractionWashFlowthrough,
					tertiarySolidPhaseExtractionWashFlowthroughContainerOut,solidPhaseExtractionElutionSolution,solidPhaseExtractionElutionSolutionVolume,
					solidPhaseExtractionElutionSolutionTemperature,solidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
					solidPhaseExtractionElutionCentrifugeIntensity,solidPhaseExtractionElutionPressure,solidPhaseExtractionElutionTime
				},

				(* Determine if Precipitation is used for this sample. *)
				speUsedQ = MemberQ[ToList[Lookup[options, Purification]], SolidPhaseExtraction];

				(* Setup a boolean to determine if there is a method specified *)
				methodSpecifiedQ = MatchQ[Lookup[options, Method], ObjectP[Object[Method]]];

				(* Pre-resolve options that do not rely on the Methods *)
				{
					(*1*)solidPhaseExtractionLoadingSampleVolume,
					(*2*)collectSolidPhaseExtractionLoadingFlowthrough,
					(*3*)solidPhaseExtractionLoadingFlowthroughContainerOut,
					(*4*)solidPhaseExtractionWashSolutionVolume,
					(*5*)collectSolidPhaseExtractionWashFlowthrough,
					(*6*)solidPhaseExtractionWashFlowthroughContainerOut,
					(*7*)secondarySolidPhaseExtractionWashSolutionVolume,
					(*8*)collectSecondarySolidPhaseExtractionWashFlowthrough,
					(*9*)secondarySolidPhaseExtractionWashFlowthroughContainerOut,
					(*10*)tertiarySolidPhaseExtractionWashSolutionVolume,
					(*11*)collectTertiarySolidPhaseExtractionWashFlowthrough,
					(*12*)tertiarySolidPhaseExtractionWashFlowthroughContainerOut,
					(*13*)solidPhaseExtractionElutionSolutionVolume
				} = Map[
					simplePreResolveOptionNoMethod[#, options, speUsedQ]&,
					{
						(*1*)SolidPhaseExtractionLoadingSampleVolume,
						(*2*)CollectSolidPhaseExtractionLoadingFlowthrough,
						(*3*)SolidPhaseExtractionLoadingFlowthroughContainerOut,
						(*4*)SolidPhaseExtractionWashSolutionVolume,
						(*5*)CollectSolidPhaseExtractionWashFlowthrough,
						(*6*)SolidPhaseExtractionWashFlowthroughContainerOut,
						(*7*)SecondarySolidPhaseExtractionWashSolutionVolume,
						(*8*)CollectSecondarySolidPhaseExtractionWashFlowthrough,
						(*9*)SecondarySolidPhaseExtractionWashFlowthroughContainerOut,
						(*10*)TertiarySolidPhaseExtractionWashSolutionVolume,
						(*11*)CollectTertiarySolidPhaseExtractionWashFlowthrough,
						(*12*)TertiarySolidPhaseExtractionWashFlowthroughContainerOut,
						(*13*)SolidPhaseExtractionElutionSolutionVolume
					}
				];

				(* --- RESOLVE GENERAL OPTIONS --- *)

				solidPhaseExtractionStrategy = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionStrategy],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionStrategy], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionStrategy],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					MatchQ[Lookup[myOptions,SolidPhaseExtractionElutionSolution], None],
						Negative,
					True,
						Positive
				];

				solidPhaseExtractionSeparationMode = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionSeparationMode], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionSeparationMode],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionSeparationMode], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionSeparationMode],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If solidPhaseExtractionSorbent is set by the user or method, set to the separation mode of the solidPhaseExtractionSorbent*)
					Or[
						MatchQ[Lookup[options, SolidPhaseExtractionSorbent], SolidPhaseExtractionFunctionalGroupP],
						methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionSorbent], SolidPhaseExtractionFunctionalGroupP]
					],
						Module[{sorbent},
							sorbent = If[MatchQ[Lookup[options, SolidPhaseExtractionSorbent], SolidPhaseExtractionFunctionalGroupP],
								Lookup[options, SolidPhaseExtractionSorbent],
								Lookup[methodPacket, SolidPhaseExtractionSorbent, Null]
							];
							Switch[
								{sorbent,target},
								{SizeExclusion, _},SizeExclusion,
								{Silica,Alternatives[RNA, PlasmidDNA, GenomicDNA]}, IonExchange,
								{ProteinG,_}, Affinity,
								(*If solidPhaseExtractionSorbent is set but does not match any of the above sorbencts, solidPhaseExtractionSeparationMode is set to Automatic and resolved by the SPE resolver. *)
								_, Automatic
							]
						],
					(*Otherwise try to pre-resolve based on target*)
					True,
						Which[
							(*If target is RNA or DNA, set to IonExchange*)
							MatchQ[target, Alternatives[RNA, PlasmidDNA, GenomicDNA]],
								IonExchange,
							(*If target is Protein set to IonExchange*)
							MatchQ[target, Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]],
								SizeExclusion,
							(*Otherwise separation mode is set to Automatic for ExperimentSPE to resolve*)
							True,
								Automatic
						]
				];

				solidPhaseExtractionSorbent = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionSorbent], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionSorbent],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionSorbent], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionSorbent],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionCartridge is specified by the user or method, set to the sorbent in the SolidPhaseExtractionCartridge*)
					Or[
						MatchQ[Lookup[options, SolidPhaseExtractionCartridge], ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]],
						methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionCartridge], ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]]
					],
						Module[{cartridge},
							cartridge = If[MatchQ[Lookup[options, SolidPhaseExtractionCartridge], ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]],
								Lookup[options, SolidPhaseExtractionCartridge],
								Lookup[methodPacket, SolidPhaseExtractionCartridge, Null]
							];
							Switch[cartridge,
								Alternatives[
									ObjectP[Model[Container, Plate, Filter, "id:9RdZXvdnd0bX"]],(*Model[Container, Plate, Filter, "NucleoSpin Plasmid Binding Plate"]*)
									ObjectP[Model[Container, Plate, Filter, "id:wqW9BPW9jpbV"]],(*Model[Container, Plate, Filter, "NucleoSpin 96 RNA Solid Phase Extraction Plate"]*)
									ObjectP[Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"]](*"QiaQuick 96well"*)
								],
									Silica,
								ObjectP[Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"]],(*"Zeba 7K 96-well Desalt Spin Plate". It does not have information.*)
									Null,
								ObjectP[Model[Container, Plate, Filter, "id:eGakldaE6bY1"]],(*"Pierce ProteinG Spin Plate for IgG Screening"*)
									ProteinG,
								ObjectP[Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"]],(*"HisPur Ni-NTA Spin Plates"*)
									Affinity,
								(*If SolidPhaseExtractionCartridge is specified but does not match any of the above objects, solidPhaseExtractionSorbent is set to Automatic and resolved by the SPE resolver. *)
								_,
									Automatic
							]
						],
					(*Otherwise, try to pre-resolve based on target cellular component*)
					True,
						Which[
							(*If target is RNA or DNA, set to Silica*)
							MatchQ[target, Alternatives[RNA, PlasmidDNA, GenomicDNA]],
								Silica,
							MatchQ[target, Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]]&& MatchQ[Lookup[options, SolidPhaseExtractionSeparationMode], Automatic],
								SizeExclusion,
							(*Otherwise, sorbent is set to Automatic for ExperimentSPE to resolve*)
							True,
								Automatic
						]
				];

				solidPhaseExtractionCartridge = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionCartridge], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionCartridge],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionCartridge], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionCartridge],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*Otherwise, try to pre-resolve based on target cellular component, mode, and sorbent*)
					(*If target is RNA*)
					MatchQ[target, RNA],
						If[MatchQ[solidPhaseExtractionSeparationMode, (IonExchange | Automatic)] && MatchQ[solidPhaseExtractionSorbent, (Silica | Automatic)],
							Model[Container, Plate, Filter, "id:wqW9BPW9jpbV"], (*Model[Container, Plate, Filter, "NucleoSpin 96 RNA Solid Phase Extraction Plate"]*)
							Automatic
						],
					(*If target is PlasmidDNA*)
					MatchQ[target, PlasmidDNA],
						If[MatchQ[solidPhaseExtractionSeparationMode, (IonExchange | Automatic)] && MatchQ[solidPhaseExtractionSorbent, (Silica | Automatic)],
							Model[Container, Plate, Filter, "id:9RdZXvdnd0bX"], (*Model[Container, Plate, Filter, "NucleoSpin Plasmid Binding Plate"]*)
							Automatic
						],
					(*If target is Protein*)
					MatchQ[target, Alternatives[CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, TotalProtein]],
						Switch[
							{solidPhaseExtractionSeparationMode, solidPhaseExtractionSorbent},
							(*Need to make sure all pre-resolved plates are compatible with both Pressure manifold and centrifuge. If in future we have plate measured or new default plates incompatible with teh manifold, we will need to add in pre-resolved SPE technique or instrument.*)
							{Affinity, ProteinG|Automatic},
								Model[Container, Plate, Filter, "id:eGakldaE6bY1"],(*Model[Container, Plate, Filter, "Pierce ProteinG Spin Plate for IgG Screening"]*)
							{Affinity, Affinity|Automatic},
								Model[Container, Plate, Filter, "id:8qZ1VWZeAw8p"],(*Model[Container, Plate, Filter, "HisPur Ni-NTA Spin Plates"]*)
							{SizeExclusion, Automatic|Null|SizeExclusion},
								Model[Container, Plate, Filter, "id:M8n3rx0ZkwB5"],(*"Zeba 7K 96-well Desalt Spin Plate".*)
							(*If solidPhaseExtractionSorbent is set but does not match any of the above sorbents, solidPhaseExtractionCartridge is set to Automatic and resolved by the SPE resolver. *)
							_,
								Automatic
						],
					True,
						Automatic
				];

				solidPhaseExtractionTechnique = Which[
					(*change incoming AirPressure options to Pressure for SPE. Should only be coming in as AirPressure, but just in case anything coming in as Pressure will also be kept as Pressure for SPE input*)
					MatchQ[Lookup[options, SolidPhaseExtractionTechnique], Alternatives[AirPressure, Pressure]],
						Pressure,
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionTechnique], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionTechnique],
					(*If specified by the method, set to method-specified value, and replace AirPresure with Pressure. Because Extraction experiments accepts only AirPressure while SPE accepts only Pressure*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionTechnique], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionTechnique]/.AirPressure->Pressure,
					(*If any Centrifuge options are specified by the method, set to Centrifuge*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, {SolidPhaseExtractionLoadingCentrifugeIntensity, SolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashCentrifugeIntensity, SolidPhaseExtractionElutionCentrifugeIntensity}], Except[{Null..}]],
						Centrifuge,
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is specified as a centrifuge, set to Centrifuge*)
					MatchQ[Lookup[options, SolidPhaseExtractionInstrument], ObjectP[{Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]}]],
						Centrifuge,
					(*Otherwise set to Pressure*)
					True,
						Pressure
				];

				solidPhaseExtractionInstrument = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionInstrument], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionInstrument],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*SolidPhaseExtractionInstrument is not a field in the method so do not check method*)
					(*If solidPhaseExtractionTechnique is set to Centrifuge, set to match the solidPhaseExtractionTechnique*)
					MatchQ[solidPhaseExtractionTechnique, Centrifuge],
						Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					(*If solidPhaseExtractionTechnique is set to Pressure or not set, set to PressureManifold*)
					True,
						Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"](*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
				];

				solidPhaseExtractionCartridgeStorageCondition = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionCartridgeStorageCondition], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionCartridgeStorageCondition],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(* This is not a field in the method object, so no need to check for method-specified*)
					True,
						Disposal
				];

				solidPhaseExtractionLoadingTemperature = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionLoadingTemperature], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionLoadingTemperature],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionLoadingTemperature], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionLoadingTemperature],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					True,
						Ambient
				];

				solidPhaseExtractionLoadingTemperatureEquilibrationTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionLoadingTemperatureEquilibrationTime], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionLoadingTemperatureEquilibrationTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionLoadingTemperatureEquilibrationTime], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionLoadingTemperatureEquilibrationTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If solidPhaseExtractionLoadingTemperature is set to Ambient or Null, set equilibration time to Null*)
					MatchQ[solidPhaseExtractionLoadingTemperature, (Ambient | Null)],
						Null,
					(*Otherwise if solidPhaseExtractionLoadingTemperature is set to something other than Ambient or Null, set equilibration time to 3 Minute*)
					True,
						3 Minute
				];

				solidPhaseExtractionLoadingCentrifugeIntensity = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionLoadingCentrifugeIntensity], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionLoadingCentrifugeIntensity],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionLoadingCentrifugeIntensity], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionLoadingCentrifugeIntensity],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a centrifuge, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
						Null,
					True,
						5000 RPM
				];

				solidPhaseExtractionLoadingPressure = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionLoadingPressure], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionLoadingPressure],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionLoadingPressure], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionLoadingPressure],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a pressuremanifold, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]],
						Null,
					True,
						$MaxRoboticAirPressure
				];

				solidPhaseExtractionLoadingTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionLoadingTime], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionLoadingTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionLoadingTime], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionLoadingTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					True,
						1 Minute
				];

				solidPhaseExtractionWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionWashSolution], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionWashSolution], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionWashSolution],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionStrategy is Negative, set to Null*)
					MatchQ[solidPhaseExtractionStrategy, Negative],
						Null,
					(*Otherwise try to set based on target*)
					True,
						Which[
							(*If target is plasmid DNA, set to default wash buffer: Model[Sample, \"Macherey-Nagel Wash Buffer A4\"]*)
							MatchQ[target, PlasmidDNA],
								(* TODO::Fix the resolution below once Macherey-Nagel buffers are ordered and objects are created. *)
								Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
							(*If target is RNA, set to default wash buffer*)
							MatchQ[target, RNA],
								Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
							(*If target is Protein set to set to default wash buffer*)
							MatchQ[target, Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]],
								Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],(*Filtered PBS, Sterile*)
							(*Otherwise set to Automatic for ExperimentSPE to resolve*)
							True,
								Automatic
						]
				];

				solidPhaseExtractionWashTemperature = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionWashTemperature], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionWashTemperature],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionWashTemperature], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionWashTemperature],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					True,
						Ambient
				];

				solidPhaseExtractionWashTemperatureEquilibrationTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionWashTemperatureEquilibrationTime], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionWashTemperatureEquilibrationTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionWashTemperatureEquilibrationTime], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionWashTemperatureEquilibrationTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If solidPhaseExtractionLoadingTemperature is set to Ambient or Null, set equilibration time to Null*)
					MatchQ[solidPhaseExtractionWashTemperature, (Ambient | Null)],
						Null,
					(*Otherwise if solidPhaseExtractionWashTemperature is set to something other than Ambient or Null, set equilibration time to 3 Minute*)
					True,
						3 Minute
				];

				solidPhaseExtractionWashCentrifugeIntensity = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionWashCentrifugeIntensity], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionWashCentrifugeIntensity],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionWashCentrifugeIntensity], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionWashCentrifugeIntensity],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a centrifuge, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
						Null,
					(*If the wash stage is turned off, set it to Null. Two possible scenarios: 1) solidPhaseExtractionWashSolution is Null, 2)solidPhaseExtractionWashSolution is preresolved to Automatic, and SPE resolves the washing switch to False if extraction strategy is Negative *)
					Or[MatchQ[solidPhaseExtractionWashSolution,Null],
						MatchQ[solidPhaseExtractionWashSolution,Automatic]&&MatchQ[solidPhaseExtractionStrategy,Negative]],
						Null,
					True,
						5000 RPM
				];

				solidPhaseExtractionWashPressure = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionWashPressure], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionWashPressure],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionWashPressure], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionWashPressure],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a pressuremanifold, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]],
						Null,
					(*If the wash stage is turned off, set it to Null. Two possible scenarios: 1) solidPhaseExtractionWashSolution is Null, 2)solidPhaseExtractionWashSolution is preresolved to Automatic, and SPE resolves the washing switch to False if extraction strategy is Negative *)
					Or[MatchQ[solidPhaseExtractionWashSolution,Null],
						MatchQ[solidPhaseExtractionWashSolution,Automatic]&&MatchQ[solidPhaseExtractionStrategy,Negative]],
						Null,
					True,
						$MaxRoboticAirPressure
				];

				solidPhaseExtractionWashTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionWashTime], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionWashTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionWashTime], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionWashTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If the wash stage is turned off, set it to Null. Two possible scenarios: 1) solidPhaseExtractionWashSolution is Null, 2)solidPhaseExtractionWashSolution is preresolved to Automatic, and SPE resolves the washing switch to False if extraction strategy is Negative *)
					Or[MatchQ[solidPhaseExtractionWashSolution,Null],
						MatchQ[solidPhaseExtractionWashSolution,Automatic]&&MatchQ[solidPhaseExtractionStrategy,Negative]],
						Null,
					True,
						1 Minute
				];

				secondarySolidPhaseExtractionWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SecondarySolidPhaseExtractionWashSolution], Except[Automatic]],
						Lookup[options, SecondarySolidPhaseExtractionWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondarySolidPhaseExtractionWashSolution], Except[Null]],
						Lookup[methodPacket, SecondarySolidPhaseExtractionWashSolution],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionStrategy is Negative, set to Null*)
					MatchQ[solidPhaseExtractionStrategy, Negative],
						Null,
					(*Otherwise try to set based on target*)
					True,
						Which[
							(*If target is plasmid DNA, set to default wash buffer: Model[Sample, \"Macherey-Nagel Wash Buffer A4\"]*)
							MatchQ[target, PlasmidDNA],
								(* TODO::Fix the resolution below once Macherey-Nagel buffers are ordered and objects are created. *)
								Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
							(*If target is RNA, set to default wash buffer*)
							MatchQ[target, RNA],
								Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
							(*If target is Protein set to set to default wash buffer*)
							MatchQ[target, Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]],
								Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],(*Filtered PBS, Sterile*)
							(*Otherwise set to Automatic for ExperimentSPE to resolve*)
							True,
								Automatic
						]
				];

				secondarySolidPhaseExtractionWashTemperature = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SecondarySolidPhaseExtractionWashTemperature], Except[Automatic]],
						Lookup[options, SecondarySolidPhaseExtractionWashTemperature],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondarySolidPhaseExtractionWashTemperature], Except[Null]],
						Lookup[methodPacket, SecondarySolidPhaseExtractionWashTemperature],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					True,
						Ambient
				];

				secondarySolidPhaseExtractionWashTemperatureEquilibrationTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime], Except[Automatic]],
						Lookup[options, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime], Except[Null]],
						Lookup[methodPacket, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If solidPhaseExtractionLoadingTemperature is set to Ambient or Null, set equilibration time to Null*)
					MatchQ[secondarySolidPhaseExtractionWashTemperature, (Ambient | Null)],
						Null,
					(*Otherwise if solidPhaseExtractionWashTemperature is set to something other than Ambient or Null, set equilibration time to 3 Minute*)
					True,
						3 Minute
				];

				secondarySolidPhaseExtractionWashCentrifugeIntensity = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SecondarySolidPhaseExtractionWashCentrifugeIntensity], Except[Automatic]],
						Lookup[options, SecondarySolidPhaseExtractionWashCentrifugeIntensity],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondarySolidPhaseExtractionWashCentrifugeIntensity], Except[Null]],
						Lookup[methodPacket, SecondarySolidPhaseExtractionWashCentrifugeIntensity],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a centrifuge, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
						Null,
					(*If the secondary wash stage is turned off, set it to Null. Two possible scenarios: 1) secondarySolidPhaseExtractionWashSolution is Null, 2)secondarySolidPhaseExtractionWashSolution is preresolved to Automatic, and SPE would set secondary washing switch to False if nothing else is specified*)
					MatchQ[secondarySolidPhaseExtractionWashSolution,Automatic|Null],
						Null,
					True,
						5000 RPM
				];

				secondarySolidPhaseExtractionWashPressure = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SecondarySolidPhaseExtractionWashPressure], Except[Automatic]],
						Lookup[options, SecondarySolidPhaseExtractionWashPressure],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondarySolidPhaseExtractionWashPressure], Except[Null]],
						Lookup[methodPacket, SecondarySolidPhaseExtractionWashPressure],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a pressuremanifold, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]],
						Null,
					(*If the secondary wash stage is turned off, set it to Null. Two possible scenarios: 1) secondarySolidPhaseExtractionWashSolution is Null, 2)secondarySolidPhaseExtractionWashSolution is preresolved to Automatic, and SPE would set secondary washing switch to False if nothing else is specified*)
					MatchQ[secondarySolidPhaseExtractionWashSolution,Automatic|Null],
						Null,
					True,
						$MaxRoboticAirPressure
				];

				secondarySolidPhaseExtractionWashTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SecondarySolidPhaseExtractionWashTime], Except[Automatic]],
						Lookup[options, SecondarySolidPhaseExtractionWashTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SecondarySolidPhaseExtractionWashTime], Except[Null]],
						Lookup[methodPacket, SecondarySolidPhaseExtractionWashTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If the secondary wash stage is turned off, set it to Null. Two possible scenarios: 1) secondarySolidPhaseExtractionWashSolution is Null, 2)secondarySolidPhaseExtractionWashSolution is preresolved to Automatic, and SPE would set secondary washing switch to False if nothing else is specified*)
					MatchQ[secondarySolidPhaseExtractionWashSolution,Automatic|Null],
						Null,
					True,
						1 Minute
				];

				tertiarySolidPhaseExtractionWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TertiarySolidPhaseExtractionWashSolution], Except[Automatic]],
						Lookup[options, TertiarySolidPhaseExtractionWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiarySolidPhaseExtractionWashSolution], Except[Null]],
						Lookup[methodPacket, TertiarySolidPhaseExtractionWashSolution],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionStrategy is Negative, set to Null*)
					MatchQ[solidPhaseExtractionStrategy, Negative],
						Null,
					(*Otherwise try to set based on target*)
					True,
						Which[
							(*If target is plasmid DNA, set to default wash buffer: Model[Sample, \"Macherey-Nagel Wash Buffer A4\"]*)
							MatchQ[target, PlasmidDNA],
								(* TODO::Fix the resolution below once Macherey-Nagel buffers are ordered and objects are created. *)
								Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
							(*If target is RNA, set to default wash buffer*)
							MatchQ[target, RNA],
								Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
							(*If target is Protein set to set to default wash buffer*)
							MatchQ[target, Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]],
								Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],(*Filtered PBS, Sterile*)
							(*Otherwise set to Automatic for ExperimentSPE to resolve*)
							True,
								Automatic
						]
				];

				tertiarySolidPhaseExtractionWashTemperature = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TertiarySolidPhaseExtractionWashTemperature], Except[Automatic]],
						Lookup[options, TertiarySolidPhaseExtractionWashTemperature],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiarySolidPhaseExtractionWashTemperature], Except[Null]],
						Lookup[methodPacket, TertiarySolidPhaseExtractionWashTemperature],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					True,
						Ambient
				];

				tertiarySolidPhaseExtractionWashTemperatureEquilibrationTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime], Except[Automatic]],
						Lookup[options, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime], Except[Null]],
						Lookup[methodPacket, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If solidPhaseExtractionLoadingTemperature is set to Ambient or Null, set equilibration time to Null*)
					MatchQ[tertiarySolidPhaseExtractionWashTemperature, (Ambient | Null)],
						Null,
					(*Otherwise if solidPhaseExtractionWashTemperature is set to something other than Ambient or Null, set equilibration time to 3 Minute*)
					True,
						3 Minute
				];

				tertiarySolidPhaseExtractionWashCentrifugeIntensity = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TertiarySolidPhaseExtractionWashCentrifugeIntensity], Except[Automatic]],
						Lookup[options, TertiarySolidPhaseExtractionWashCentrifugeIntensity],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiarySolidPhaseExtractionWashCentrifugeIntensity], Except[Null]],
						Lookup[methodPacket, TertiarySolidPhaseExtractionWashCentrifugeIntensity],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a centrifuge, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
						Null,
					(*If the tertiary wash stage is turned off, set it to Null. Two possible scenarios: 1) tertiarySolidPhaseExtractionWashSolution is Null, 2)tertiarySolidPhaseExtractionWashSolution is preresolved to Automatic, and SPE would set tertiary washing switch to False if nothing else is specified*)
					MatchQ[tertiarySolidPhaseExtractionWashSolution,Automatic|Null],
						Null,
					True,
						5000 RPM
				];

				tertiarySolidPhaseExtractionWashPressure = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TertiarySolidPhaseExtractionWashPressure], Except[Automatic]],
						Lookup[options, TertiarySolidPhaseExtractionWashPressure],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiarySolidPhaseExtractionWashPressure], Except[Null]],
						Lookup[methodPacket, TertiarySolidPhaseExtractionWashPressure],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a pressuremanifold, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]],
						Null,
					(*If the tertiary wash stage is turned off, set it to Null. Two possible scenarios: 1) tertiarySolidPhaseExtractionWashSolution is Null, 2)tertiarySolidPhaseExtractionWashSolution is preresolved to Automatic, and SPE would set tertiary washing switch to False if nothing else is specified*)
					MatchQ[tertiarySolidPhaseExtractionWashSolution,Automatic|Null],
						Null,
					True,
						$MaxRoboticAirPressure
				];

				tertiarySolidPhaseExtractionWashTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TertiarySolidPhaseExtractionWashTime], Except[Automatic]],
						Lookup[options, TertiarySolidPhaseExtractionWashTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, TertiarySolidPhaseExtractionWashTime], Except[Null]],
						Lookup[methodPacket, TertiarySolidPhaseExtractionWashTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If the tertiary wash stage is turned off, set it to Null. Two possible scenarios: 1) tertiarySolidPhaseExtractionWashSolution is Null, 2)tertiarySolidPhaseExtractionWashSolution is preresolved to Automatic, and SPE would set tertiary washing switch to False if nothing else is specified*)
					MatchQ[tertiarySolidPhaseExtractionWashSolution,Automatic|Null],
						Null,
					True,
						1 Minute
				];

				solidPhaseExtractionElutionSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionElutionSolution], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionElutionSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionElutionSolution], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionElutionSolution],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionStrategy is Negative, set to Null*)
					MatchQ[solidPhaseExtractionStrategy, Negative],
						Null,
					(*Otherwise try to set based on target*)
					True,
						Which[
							(*If target is plasmid DNA, set to default elution buffer: Model[Sample, \"Macherey-Nagel Elution Buffer AE\"]*)
							MatchQ[target, PlasmidDNA],
								(* TODO::Fix the resolution below once Macherey-Nagel buffers are ordered and objects are created. *)
								Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
							(*If target is RNA, set to default elution buffer*)
							MatchQ[target, RNA],
								Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
							(*If target is Protein set to set to default elution buffer*)
							MatchQ[target, Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]],
								Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"],(*"id:eGakldadjlEe" "50 mM Glycine pH 2.8, sterile filtered"*)
							(*Otherwise set to Automatic for ExperimentSPE to resolve*)
							True,
								Automatic
						]
				];

				solidPhaseExtractionElutionSolutionTemperature = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionElutionSolutionTemperature], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionElutionSolutionTemperature],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionElutionSolutionTemperature], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionElutionSolutionTemperature],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					True,
						Ambient
				];

				solidPhaseExtractionElutionSolutionTemperatureEquilibrationTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If solidPhaseExtractionLoadingTemperature is set to Ambient or Null, set equilibration time to Null*)
					MatchQ[solidPhaseExtractionElutionSolutionTemperature, (Ambient | Null)],
						Null,
					(*Otherwise if solidPhaseExtractionElutionTemperature is set to something other than Ambient or Null, set equilibration time to 3 Minute*)
					True,
						3 Minute
				];

				solidPhaseExtractionElutionCentrifugeIntensity = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionElutionCentrifugeIntensity], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionElutionCentrifugeIntensity],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionElutionCentrifugeIntensity], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionElutionCentrifugeIntensity],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a centrifuge, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
						Null,
					(*If the elution is turned off, set it to Null. Two possible scenarios: 1) solidPhaseExtractionElutionSolution is Null, 2)solidPhaseExtractionElutionSolution is preresolved to Automatic, and SPE would set eluting switch to False if ExtractionStrategy is Negative*)
					Or[MatchQ[solidPhaseExtractionElutionSolution,Null],
						MatchQ[solidPhaseExtractionElutionSolution,Automatic]&&MatchQ[solidPhaseExtractionStrategy,Negative]],
						Null,
					True,
						5000 RPM
				];

				solidPhaseExtractionElutionPressure = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionElutionPressure], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionElutionPressure],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionElutionPressure], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionElutionPressure],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If SolidPhaseExtractionInstrument is set and is not a pressuremanifold, set to Null*)
					!MatchQ[solidPhaseExtractionInstrument, ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]],
						Null,
					(*If the elution is turned off, set it to Null. Two possible scenarios: 1) solidPhaseExtractionElutionSolution is Null, 2)solidPhaseExtractionElutionSolution is preresolved to Automatic, and SPE would set eluting switch to False if ExtractionStrategy is Negative*)
					Or[MatchQ[solidPhaseExtractionElutionSolution,Null],
						MatchQ[solidPhaseExtractionElutionSolution,Automatic]&&MatchQ[solidPhaseExtractionStrategy,Negative]],
					Null,
					True,
						$MaxRoboticAirPressure
				];

				solidPhaseExtractionElutionTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, SolidPhaseExtractionElutionTime], Except[Automatic]],
						Lookup[options, SolidPhaseExtractionElutionTime],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, SolidPhaseExtractionElutionTime], Except[Null]],
						Lookup[methodPacket, SolidPhaseExtractionElutionTime],
					(*If SPE is not used and the option is not specified, it is set to Null.*)
					!speUsedQ,
						Null,
					(*If the elution is turned off, set it to Null. Two possible scenarios: 1) solidPhaseExtractionElutionSolution is Null, 2)solidPhaseExtractionElutionSolution is preresolved to Automatic, and SPE would set eluting switch to False if ExtractionStrategy is Negative*)
					Or[MatchQ[solidPhaseExtractionElutionSolution,Null],
						MatchQ[solidPhaseExtractionElutionSolution,Automatic]&&MatchQ[solidPhaseExtractionStrategy,Negative]],
					Null,
					True,
						1 Minute
				];

				{
					solidPhaseExtractionStrategy,solidPhaseExtractionSeparationMode,solidPhaseExtractionSorbent,solidPhaseExtractionCartridge,solidPhaseExtractionTechnique,solidPhaseExtractionInstrument,solidPhaseExtractionCartridgeStorageCondition,solidPhaseExtractionLoadingSampleVolume,solidPhaseExtractionLoadingTemperature,solidPhaseExtractionLoadingTemperatureEquilibrationTime,solidPhaseExtractionLoadingCentrifugeIntensity,solidPhaseExtractionLoadingPressure,solidPhaseExtractionLoadingTime,collectSolidPhaseExtractionLoadingFlowthrough,solidPhaseExtractionLoadingFlowthroughContainerOut,solidPhaseExtractionWashSolution,solidPhaseExtractionWashSolutionVolume,solidPhaseExtractionWashTemperature,solidPhaseExtractionWashTemperatureEquilibrationTime,solidPhaseExtractionWashCentrifugeIntensity,solidPhaseExtractionWashPressure,solidPhaseExtractionWashTime,collectSolidPhaseExtractionWashFlowthrough,solidPhaseExtractionWashFlowthroughContainerOut,secondarySolidPhaseExtractionWashSolution,secondarySolidPhaseExtractionWashSolutionVolume,secondarySolidPhaseExtractionWashTemperature,secondarySolidPhaseExtractionWashTemperatureEquilibrationTime,secondarySolidPhaseExtractionWashCentrifugeIntensity,secondarySolidPhaseExtractionWashPressure,secondarySolidPhaseExtractionWashTime,collectSecondarySolidPhaseExtractionWashFlowthrough,secondarySolidPhaseExtractionWashFlowthroughContainerOut,tertiarySolidPhaseExtractionWashSolution,tertiarySolidPhaseExtractionWashSolutionVolume,tertiarySolidPhaseExtractionWashTemperature,tertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,tertiarySolidPhaseExtractionWashCentrifugeIntensity,tertiarySolidPhaseExtractionWashPressure,tertiarySolidPhaseExtractionWashTime,collectTertiarySolidPhaseExtractionWashFlowthrough,tertiarySolidPhaseExtractionWashFlowthroughContainerOut,solidPhaseExtractionElutionSolution,solidPhaseExtractionElutionSolutionVolume,solidPhaseExtractionElutionSolutionTemperature,solidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,solidPhaseExtractionElutionCentrifugeIntensity,solidPhaseExtractionElutionPressure,solidPhaseExtractionElutionTime
				}
			]
		],
		{methodPackets, myMapThreadOptions, targets}
	];

	{
		SolidPhaseExtractionStrategy->preResolvedSolidPhaseExtractionStrategy,
		SolidPhaseExtractionSeparationMode->preResolvedSolidPhaseExtractionSeparationMode,
		SolidPhaseExtractionSorbent->preResolvedSolidPhaseExtractionSorbent,
		SolidPhaseExtractionCartridge->preResolvedSolidPhaseExtractionCartridge,
		SolidPhaseExtractionTechnique->preResolvedSolidPhaseExtractionTechnique,
		SolidPhaseExtractionInstrument->preResolvedSolidPhaseExtractionInstrument,
		SolidPhaseExtractionCartridgeStorageCondition->preResolvedSolidPhaseExtractionCartridgeStorageCondition,
		SolidPhaseExtractionLoadingSampleVolume->preResolvedSolidPhaseExtractionLoadingSampleVolume,
		SolidPhaseExtractionLoadingTemperature->preResolvedSolidPhaseExtractionLoadingTemperature,
		SolidPhaseExtractionLoadingTemperatureEquilibrationTime->preResolvedSolidPhaseExtractionLoadingTemperatureEquilibrationTime,
		SolidPhaseExtractionLoadingCentrifugeIntensity->preResolvedSolidPhaseExtractionLoadingCentrifugeIntensity,
		SolidPhaseExtractionLoadingPressure->preResolvedSolidPhaseExtractionLoadingPressure,
		SolidPhaseExtractionLoadingTime->preResolvedSolidPhaseExtractionLoadingTime,
		CollectSolidPhaseExtractionLoadingFlowthrough->preResolvedCollectSolidPhaseExtractionLoadingFlowthrough,
		SolidPhaseExtractionLoadingFlowthroughContainerOut->preResolvedSolidPhaseExtractionLoadingFlowthroughContainerOut,
		SolidPhaseExtractionWashSolution->preResolvedSolidPhaseExtractionWashSolution,
		SolidPhaseExtractionWashSolutionVolume->preResolvedSolidPhaseExtractionWashSolutionVolume,
		SolidPhaseExtractionWashTemperature->preResolvedSolidPhaseExtractionWashTemperature,
		SolidPhaseExtractionWashTemperatureEquilibrationTime->preResolvedSolidPhaseExtractionWashTemperatureEquilibrationTime,
		SolidPhaseExtractionWashCentrifugeIntensity->preResolvedSolidPhaseExtractionWashCentrifugeIntensity,
		SolidPhaseExtractionWashPressure->preResolvedSolidPhaseExtractionWashPressure,
		SolidPhaseExtractionWashTime->preResolvedSolidPhaseExtractionWashTime,
		CollectSolidPhaseExtractionWashFlowthrough->preResolvedCollectSolidPhaseExtractionWashFlowthrough,
		SolidPhaseExtractionWashFlowthroughContainerOut->preResolvedSolidPhaseExtractionWashFlowthroughContainerOut,
		SecondarySolidPhaseExtractionWashSolution->preResolvedSecondarySolidPhaseExtractionWashSolution,
		SecondarySolidPhaseExtractionWashSolutionVolume->preResolvedSecondarySolidPhaseExtractionWashSolutionVolume,
		SecondarySolidPhaseExtractionWashTemperature->preResolvedSecondarySolidPhaseExtractionWashTemperature,
		SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime->preResolvedSecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		SecondarySolidPhaseExtractionWashCentrifugeIntensity->preResolvedSecondarySolidPhaseExtractionWashCentrifugeIntensity,
		SecondarySolidPhaseExtractionWashPressure->preResolvedSecondarySolidPhaseExtractionWashPressure,
		SecondarySolidPhaseExtractionWashTime->preResolvedSecondarySolidPhaseExtractionWashTime,
		CollectSecondarySolidPhaseExtractionWashFlowthrough->preResolvedCollectSecondarySolidPhaseExtractionWashFlowthrough,
		SecondarySolidPhaseExtractionWashFlowthroughContainerOut->preResolvedSecondarySolidPhaseExtractionWashFlowthroughContainerOut,
		TertiarySolidPhaseExtractionWashSolution->preResolvedTertiarySolidPhaseExtractionWashSolution,
		TertiarySolidPhaseExtractionWashSolutionVolume->preResolvedTertiarySolidPhaseExtractionWashSolutionVolume,
		TertiarySolidPhaseExtractionWashTemperature->preResolvedTertiarySolidPhaseExtractionWashTemperature,
		TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime->preResolvedTertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		TertiarySolidPhaseExtractionWashCentrifugeIntensity->preResolvedTertiarySolidPhaseExtractionWashCentrifugeIntensity,
		TertiarySolidPhaseExtractionWashPressure->preResolvedTertiarySolidPhaseExtractionWashPressure,
		TertiarySolidPhaseExtractionWashTime->preResolvedTertiarySolidPhaseExtractionWashTime,
		CollectTertiarySolidPhaseExtractionWashFlowthrough->preResolvedCollectTertiarySolidPhaseExtractionWashFlowthrough,
		TertiarySolidPhaseExtractionWashFlowthroughContainerOut->preResolvedTertiarySolidPhaseExtractionWashFlowthroughContainerOut,
		SolidPhaseExtractionElutionSolution->preResolvedSolidPhaseExtractionElutionSolution,
		SolidPhaseExtractionElutionSolutionVolume->preResolvedSolidPhaseExtractionElutionSolutionVolume,
		SolidPhaseExtractionElutionSolutionTemperature->preResolvedSolidPhaseExtractionElutionSolutionTemperature,
		SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime->preResolvedSolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
		SolidPhaseExtractionElutionCentrifugeIntensity->preResolvedSolidPhaseExtractionElutionCentrifugeIntensity,
		SolidPhaseExtractionElutionPressure->preResolvedSolidPhaseExtractionElutionPressure,
		SolidPhaseExtractionElutionTime->preResolvedSolidPhaseExtractionElutionTime
	}

];

(* ::Subsection::Closed:: *)
(*solidPhaseExtractionConflictingOptionsChecks*)

Error::SolidPhaseExtractionTechniqueInstrumentMismatch = "The solid phase extraction instrument, `3`, set for the sample(s), `1`, at indices, `4`, cannot perform the specified solid phase extraction technique, `2`. For the sample(s), `1`, please set SolidPhaseExtractionInsrument to a model that can perform the solid phase extraction technique, `2`, or set a SolidPhaseExtractionTechnique that can be performed on the homogenization instrument, `3`. Alternatively, set either SolidPhaseExtractionTechnique or SolidPhaseExtractionInstrument to Automatic.";

DefineOptions[
	solidPhaseExtractionConflictingOptionsChecks,
	Options :> {CacheOption}
];

solidPhaseExtractionConflictingOptionsChecks[mySamples:{ObjectP[Object[Sample]]...}, myResolvedOptions:{_Rule...}, gatherTestsQ:BooleanP, myResolutionOptions:OptionsPattern[solidPhaseExtractionConflictingOptionsChecks]] := Module[
	{
		safeOps, cache, messages,

		resolvedSolidPhaseExtractionStrategy,
		resolvedSolidPhaseExtractionSeparationMode,
		resolvedSolidPhaseExtractionSorbent,
		resolvedSolidPhaseExtractionCartridge,
		resolvedSolidPhaseExtractionTechnique,
		resolvedSolidPhaseExtractionInstrument,
		resolvedSolidPhaseExtractionCartridgeStorageCondition,
		resolvedSolidPhaseExtractionLoadingSampleVolume,
		resolvedSolidPhaseExtractionLoadingTemperature,
		resolvedSolidPhaseExtractionLoadingTemperatureEquilibrationTime,
		resolvedSolidPhaseExtractionLoadingCentrifugeIntensity,
		resolvedSolidPhaseExtractionLoadingPressure,
		resolvedSolidPhaseExtractionLoadingTime,
		resolvedCollectSolidPhaseExtractionLoadingFlowthrough,
		resolvedSolidPhaseExtractionLoadingFlowthroughContainerOut,
		resolvedSolidPhaseExtractionWashSolution,
		resolvedSolidPhaseExtractionWashSolutionVolume,
		resolvedSolidPhaseExtractionWashTemperature,
		resolvedSolidPhaseExtractionWashTemperatureEquilibrationTime,
		resolvedSolidPhaseExtractionWashCentrifugeIntensity,
		resolvedSolidPhaseExtractionWashPressure,
		resolvedSolidPhaseExtractionWashTime,
		resolvedCollectSolidPhaseExtractionWashFlowthrough,
		resolvedSolidPhaseExtractionWashFlowthroughContainerOut,
		resolvedSecondarySolidPhaseExtractionWashSolution,
		resolvedSecondarySolidPhaseExtractionWashSolutionVolume,
		resolvedSecondarySolidPhaseExtractionWashTemperature,
		resolvedSecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		resolvedSecondarySolidPhaseExtractionWashCentrifugeIntensity,
		resolvedSecondarySolidPhaseExtractionWashPressure,
		resolvedSecondarySolidPhaseExtractionWashTime,
		resolvedCollectSecondarySolidPhaseExtractionWashFlowthrough,
		resolvedSecondarySolidPhaseExtractionWashFlowthroughContainerOut,
		resolvedTertiarySolidPhaseExtractionWashSolution,
		resolvedTertiarySolidPhaseExtractionWashSolutionVolume,
		resolvedTertiarySolidPhaseExtractionWashTemperature,
		resolvedTertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		resolvedTertiarySolidPhaseExtractionWashCentrifugeIntensity,
		resolvedTertiarySolidPhaseExtractionWashPressure,
		resolvedTertiarySolidPhaseExtractionWashTime,
		resolvedCollectTertiarySolidPhaseExtractionWashFlowthrough,
		resolvedTertiarySolidPhaseExtractionWashFlowthroughContainerOut,
		resolvedSolidPhaseExtractionElutionSolution,
		resolvedSolidPhaseExtractionElutionSolutionVolume,
		resolvedSolidPhaseExtractionElutionSolutionTemperature,
		resolvedSolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
		resolvedSolidPhaseExtractionElutionCentrifugeIntensity,
		resolvedSolidPhaseExtractionElutionPressure,
		resolvedSolidPhaseExtractionElutionTime,

		solidPhaseExtractionTechniqueInstrumentConflictingOptions,
		solidPhaseExtractionTechniqueInstrumentConflictingOptionsTest,

		invalidOptions
	},


	(*Pull out the safe options.*)
	safeOps = SafeOptions[solidPhaseExtractionConflictingOptionsChecks, ToList[myResolutionOptions]];

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[safeOps], Cache, {}];

	(* Determine if we should keep a running list of tests (Output contains Test). *)
	messages = !gatherTestsQ;

	(* Pull out the resolved values. These two options were preresolved to singletons. *)
	{
		resolvedSolidPhaseExtractionStrategy,
		resolvedSolidPhaseExtractionSeparationMode,
		resolvedSolidPhaseExtractionSorbent,
		resolvedSolidPhaseExtractionCartridge,
		resolvedSolidPhaseExtractionTechnique,
		resolvedSolidPhaseExtractionInstrument,
		resolvedSolidPhaseExtractionCartridgeStorageCondition,
		resolvedSolidPhaseExtractionLoadingSampleVolume,
		resolvedSolidPhaseExtractionLoadingTemperature,
		resolvedSolidPhaseExtractionLoadingTemperatureEquilibrationTime,
		resolvedSolidPhaseExtractionLoadingCentrifugeIntensity,
		resolvedSolidPhaseExtractionLoadingPressure,
		resolvedSolidPhaseExtractionLoadingTime,
		resolvedCollectSolidPhaseExtractionLoadingFlowthrough,
		resolvedSolidPhaseExtractionLoadingFlowthroughContainerOut,
		resolvedSolidPhaseExtractionWashSolution,
		resolvedSolidPhaseExtractionWashSolutionVolume,
		resolvedSolidPhaseExtractionWashTemperature,
		resolvedSolidPhaseExtractionWashTemperatureEquilibrationTime,
		resolvedSolidPhaseExtractionWashCentrifugeIntensity,
		resolvedSolidPhaseExtractionWashPressure,
		resolvedSolidPhaseExtractionWashTime,
		resolvedCollectSolidPhaseExtractionWashFlowthrough,
		resolvedSolidPhaseExtractionWashFlowthroughContainerOut,
		resolvedSecondarySolidPhaseExtractionWashSolution,
		resolvedSecondarySolidPhaseExtractionWashSolutionVolume,
		resolvedSecondarySolidPhaseExtractionWashTemperature,
		resolvedSecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		resolvedSecondarySolidPhaseExtractionWashCentrifugeIntensity,
		resolvedSecondarySolidPhaseExtractionWashPressure,
		resolvedSecondarySolidPhaseExtractionWashTime,
		resolvedCollectSecondarySolidPhaseExtractionWashFlowthrough,
		resolvedSecondarySolidPhaseExtractionWashFlowthroughContainerOut,
		resolvedTertiarySolidPhaseExtractionWashSolution,
		resolvedTertiarySolidPhaseExtractionWashSolutionVolume,
		resolvedTertiarySolidPhaseExtractionWashTemperature,
		resolvedTertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
		resolvedTertiarySolidPhaseExtractionWashCentrifugeIntensity,
		resolvedTertiarySolidPhaseExtractionWashPressure,
		resolvedTertiarySolidPhaseExtractionWashTime,
		resolvedCollectTertiarySolidPhaseExtractionWashFlowthrough,
		resolvedTertiarySolidPhaseExtractionWashFlowthroughContainerOut,
		resolvedSolidPhaseExtractionElutionSolution,
		resolvedSolidPhaseExtractionElutionSolutionVolume,
		resolvedSolidPhaseExtractionElutionSolutionTemperature,
		resolvedSolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
		resolvedSolidPhaseExtractionElutionCentrifugeIntensity,
		resolvedSolidPhaseExtractionElutionPressure,
		resolvedSolidPhaseExtractionElutionTime
	} = Map[
		Lookup[myResolvedOptions, #]&,
		{
			SolidPhaseExtractionStrategy,
			SolidPhaseExtractionSeparationMode,
			SolidPhaseExtractionSorbent,
			SolidPhaseExtractionCartridge,
			SolidPhaseExtractionTechnique,
			SolidPhaseExtractionInstrument,
			SolidPhaseExtractionCartridgeStorageCondition,
			SolidPhaseExtractionLoadingSampleVolume,
			SolidPhaseExtractionLoadingTemperature,
			SolidPhaseExtractionLoadingTemperatureEquilibrationTime,
			SolidPhaseExtractionLoadingCentrifugeIntensity,
			SolidPhaseExtractionLoadingPressure,
			SolidPhaseExtractionLoadingTime,
			CollectSolidPhaseExtractionLoadingFlowthrough,
			SolidPhaseExtractionLoadingFlowthroughContainerOut,
			SolidPhaseExtractionWashSolution,
			SolidPhaseExtractionWashSolutionVolume,
			SolidPhaseExtractionWashTemperature,
			SolidPhaseExtractionWashTemperatureEquilibrationTime,
			SolidPhaseExtractionWashCentrifugeIntensity,
			SolidPhaseExtractionWashPressure,
			SolidPhaseExtractionWashTime,
			CollectSolidPhaseExtractionWashFlowthrough,
			SolidPhaseExtractionWashFlowthroughContainerOut,
			SecondarySolidPhaseExtractionWashSolution,
			SecondarySolidPhaseExtractionWashSolutionVolume,
			SecondarySolidPhaseExtractionWashTemperature,
			SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
			SecondarySolidPhaseExtractionWashCentrifugeIntensity,
			SecondarySolidPhaseExtractionWashPressure,
			SecondarySolidPhaseExtractionWashTime,
			CollectSecondarySolidPhaseExtractionWashFlowthrough,
			SecondarySolidPhaseExtractionWashFlowthroughContainerOut,
			TertiarySolidPhaseExtractionWashSolution,
			TertiarySolidPhaseExtractionWashSolutionVolume,
			TertiarySolidPhaseExtractionWashTemperature,
			TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
			TertiarySolidPhaseExtractionWashCentrifugeIntensity,
			TertiarySolidPhaseExtractionWashPressure,
			TertiarySolidPhaseExtractionWashTime,
			CollectTertiarySolidPhaseExtractionWashFlowthrough,
			TertiarySolidPhaseExtractionWashFlowthroughContainerOut,
			SolidPhaseExtractionElutionSolution,
			SolidPhaseExtractionElutionSolutionVolume,
			SolidPhaseExtractionElutionSolutionTemperature,
			SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,
			SolidPhaseExtractionElutionCentrifugeIntensity,
			SolidPhaseExtractionElutionPressure,
			SolidPhaseExtractionElutionTime
		}
	];

	(*check if SolidPhaseExtractionInstrument can perform the SolidPhaseExtractionTechnique (Error)*)
	solidPhaseExtractionTechniqueInstrumentConflictingOptions = MapThread[
		Function[{sample, technique, instrument, index},
			If[
				Or[
					MatchQ[technique, Centrifuge] && MatchQ[instrument, ObjectP[Model[Instrument, PressureManifold]]],
					MatchQ[technique, Pressure] && MatchQ[instrument, ObjectP[Model[Instrument, Centrifuge]]]
				],
				{sample, technique, instrument, index},
				Nothing
			]
		],
		{mySamples, resolvedSolidPhaseExtractionTechnique, resolvedSolidPhaseExtractionInstrument, Range[Length[mySamples]]}
	];

	If[Length[solidPhaseExtractionTechniqueInstrumentConflictingOptions] > 0 && messages,
		Message[
			Error::SolidPhaseExtractionTechniqueInstrumentMismatch,
			ObjectToString[solidPhaseExtractionTechniqueInstrumentConflictingOptions[[All, 1]], Cache -> cache],
			solidPhaseExtractionTechniqueInstrumentConflictingOptions[[All, 2]],
			solidPhaseExtractionTechniqueInstrumentConflictingOptions[[All, 3]],
			solidPhaseExtractionTechniqueInstrumentConflictingOptions[[All, 4]]
		];
	];

	solidPhaseExtractionTechniqueInstrumentConflictingOptionsTest = If[gatherTestsQ,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = solidPhaseExtractionTechniqueInstrumentConflictingOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cache]<>"do not have SolidPhaseExtractionTechnique set to a technique that cannot be performed by the set SolidPhaseExtractionInstrument:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache]<>"do not have HomogenizationTechnique set to a technique that cannot be performed by the set SolidPhaseExtractionInstrument:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	invalidOptions = {
		If[Length[solidPhaseExtractionTechniqueInstrumentConflictingOptions]>0,
			{SolidPhaseExtractionTechnique, SolidPhaseExtractionInstrument},
			{}
		]
	};

	{
		{solidPhaseExtractionTechniqueInstrumentConflictingOptionsTest},
		invalidOptions
	}
];


(* ::Subsection::Closed:: *)
(*resolveExtractionSolidPhaseSharedOptionsTests*)
(*NOTE:: These tests can serve as a draft but are not being kept up to date - SPE shared options tests are being edited within specific Extract/Harvest experiments*)

resolveExtractionSolidPhaseSharedOptionsTests[myFunction_Symbol, previouslyExtractedSampleInPlate:ObjectP[Object[Sample]]]:=
		{
			Example[{Basic, "Crude samples can be purified with solid phase extraction:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> SolidPhaseExtraction,
					Output->Result
				],
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				TimeConstraint -> 1800
			],
			Example[{Basic, "All solid phase extraction options are set to Null if they are not specified by the user or method and SolidPhaseExtraction is not specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> LiquidLiquidExtraction,
					Output -> Options
				],
				KeyValuePattern[{
					SolidPhaseExtractionStrategy->Null,
					SolidPhaseExtractionSeparationMode->Null,
					SolidPhaseExtractionSorbent->Null,
					SolidPhaseExtractionCartridge->Null,
					SolidPhaseExtractionTechnique->Null,
					SolidPhaseExtractionInstrument->Null,
					SolidPhaseExtractionCartridgeStorageCondition->Null,
					SolidPhaseExtractionLoadingSampleVolume->Null,
					SolidPhaseExtractionLoadingTemperature->Null,
					SolidPhaseExtractionLoadingTemperatureEquilibrationTime->Null,
					SolidPhaseExtractionLoadingCentrifugeIntensity->Null,
					SolidPhaseExtractionLoadingPressure->Null,
					SolidPhaseExtractionLoadingTime->Null,
					CollectSolidPhaseExtractionLoadingFlowthrough->Null,
					SolidPhaseExtractionLoadingFlowthroughContainerOut->Null,
					SolidPhaseExtractionWashSolution->Null,
					SolidPhaseExtractionWashSolutionVolume->Null,
					SolidPhaseExtractionWashTemperature->Null,
					SolidPhaseExtractionWashTemperatureEquilibrationTime->Null,
					SolidPhaseExtractionWashCentrifugeIntensity->Null,
					SolidPhaseExtractionWashPressure->Null,
					SolidPhaseExtractionWashTime->Null,
					CollectSolidPhaseExtractionWashFlowthrough->Null,
					SolidPhaseExtractionWashFlowthroughContainerOut->Null,
					SecondarySolidPhaseExtractionWashSolution->Null,
					SecondarySolidPhaseExtractionWashSolutionVolume->Null,
					SecondarySolidPhaseExtractionWashTemperature->Null,
					SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime->Null,
					SecondarySolidPhaseExtractionWashCentrifugeIntensity->Null,
					SecondarySolidPhaseExtractionWashPressure->Null,
					SecondarySolidPhaseExtractionWashTime->Null,
					CollectSecondarySolidPhaseExtractionWashFlowthrough->Null,
					SecondarySolidPhaseExtractionWashFlowthroughContainerOut->Null,
					TertiarySolidPhaseExtractionWashSolution->Null,
					TertiarySolidPhaseExtractionWashSolutionVolume->Null,
					TertiarySolidPhaseExtractionWashTemperature->Null,
					TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime->Null,
					TertiarySolidPhaseExtractionWashCentrifugeIntensity->Null,
					TertiarySolidPhaseExtractionWashPressure->Null,
					TertiarySolidPhaseExtractionWashTime->Null,
					CollectTertiarySolidPhaseExtractionWashFlowthrough->Null,
					TertiarySolidPhaseExtractionWashFlowthroughContainerOut->Null,
					SolidPhaseExtractionElutionSolution->Null,
					SolidPhaseExtractionElutionSolutionVolume->Null,
					SolidPhaseExtractionElutionSolutionTemperature->Null,
					SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime->Null,
					SolidPhaseExtractionElutionCentrifugeIntensity->Null,
					SolidPhaseExtractionElutionPressure->Null,
					SolidPhaseExtractionElutionTime->Null}],
				TimeConstraint -> 1200
			],
			Example[{Options, SolidPhaseExtractionStrategy, "SolidPhaseExtractionStrategy is set to Positive if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionStrategy -> Positive}],
				TimeConstraint -> 1200
			],
			Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to match the sorbent in the SolidPhaseExtractionCartridge if SolidPhaseExtractionCartridge is specified and SolidPhaseExtractionSorbent is not specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionCartridge->Model[Container, Plate, Filter, "id:9RdZXvdnd0bX"],(*Model[Container, Plate, Filter, "NucleoSpin Plasmid Binding Plate"]*)(*TODO change to experiment-specific model*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionSorbent -> Silica}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to Silica if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionSorbent -> Silica}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionSeparationMode, "SolidPhaseExtractionSeparationMode is set to match the mode of the SolidPhaseExtractionSorbent if SolidPhaseExtractionSorbent is specified and SolidPhaseExtractionSeparationMode is not specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionSorbent->Silica,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionSeparationMode -> IonExchange}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionSeparationMode, "SolidPhaseExtractionSeparationMode is set to IonExchange if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionSeparationMode -> IonExchange}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionCartridge, "SolidPhaseExtractionCartridge is set to match the mode of the SolidPhaseExtractionSorbent if SolidPhaseExtractionSorbent is specified and SolidPhaseExtractionCartridge is not specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionSorbent->Silica,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionCartridge -> ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]}](*TODO can set to experiment-specific model*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionCartridge, "SolidPhaseExtractionCartridge is set to match the mode of the SolidPhaseExtractionSeparationMode if SolidPhaseExtractionSeparationMode is specified and SolidPhaseExtractionCartridge is not specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionSeparationMode->IonExchange,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionCartridge -> ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]}](*TODO can set to experiment-specific model*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionCartridge, "SolidPhaseExtractionCartridge is set to Model[Container, Plate, \"NucleoSpin 96 silica SPE plate\"] if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionCartridge -> ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]}](*TODO can set to experiment-specific model*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionTechnique, "SolidPhaseExtractionTechnique is set to Pressure if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionTechnique -> Pressure}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionInstrument, "SolidPhaseExtractionInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if SolidPhaseExtractionTechnique is set to Centrifuge and SolidPhaseExtractionInstrument is not specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionTechnique->Centrifuge,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}]}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionInstrument, "SolidPhaseExtractionInstrument is set to Model[Instrument, PressureManifold, \"MPE2\"] if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]}]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionCartridgeStorageCondition, "SolidPhaseExtractionCartridgeStorageCondition is set to Disposal if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionCartridgeStorageCondition -> Null}](*in SPE the default for ExtractionCartridgeStorageCondition is Disposal, then disposal (or any input that is not in SampleStorageTypeP) resolves to Null*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingSampleVolume, "SolidPhaseExtractionLoadingSampleVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingSampleVolume -> RangeP[Quantity[199., Microliter], Quantity[201., Microliter]]}](*in SPE Automatic resolves to use All of the sample. make sure this number matches the volume of the test sample plus any volume added/subtracted prior to SPE purification*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingTemperature, "SolidPhaseExtractionLoadingTemperature is set to Ambient if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingTemperature -> $AmbientTemperature}](*SPE returns the resolved loading temperature as {{25 Celsius}}*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingTemperatureEquilibrationTime, "SolidPhaseExtractionLoadingTemperatureEquilibrationTime is set to Null if it is not specified by the user or method and SolidPhaseExtractionLoadingTemperature is set to Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionLoadingTemperature -> Ambient,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingTemperatureEquilibrationTime, "SolidPhaseExtractionLoadingTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SolidPhaseExtractionLoadingTemperature is set to something other than Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionLoadingTemperature -> 37 Celsius,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> 3 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingCentrifugeIntensity, "SolidPhaseExtractionLoadingCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not set to a Model[Instrument, Centrfuge]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingCentrifugeIntensity -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingCentrifugeIntensity, "SolidPhaseExtractionLoadingCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionTechnique -> Centrifuge,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingCentrifugeIntensity -> 5000 RPM}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingPressure, "SolidPhaseExtractionLoadingPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not set to a Model[Instrument, PressureManifold]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingPressure -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingPressure, "SolidPhaseExtractionLoadingPressure is set to the MaxRoboticAirPressure if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					SolidPhaseExtractionTechnique -> Pressure,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingPressure -> $MaxRoboticAirPressure}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingTime, "SolidPhaseExtractionLoadingTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingTime -> 1 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, CollectSolidPhaseExtractionLoadingFlowthrough, "CollectSolidPhaseExtractionLoadingFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{CollectSolidPhaseExtractionLoadingFlowthrough -> False}](*if the option is not set by the user, SPE sets it to False unless there is a collection container specified*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionLoadingFlowthroughContainerOut, "SolidPhaseExtractionLoadingFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionLoadingFlowthroughContainerOut -> Null}](*default in SPE is to not collect the flowthrough, so don't need a container*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashSolution, "SolidPhaseExtractionWashSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"]}](*TODO set to experiment-specific model*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashSolutionVolume, "SolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashSolutionVolume -> 1. Milliliter}](*TODO change to something less than volume of cartridge*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashTemperature, "SolidPhaseExtractionWashTemperature is set to Ambient if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashTemperature -> $AmbientTemperature}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashTemperatureEquilibrationTime, "SolidPhaseExtractionWashTemperatureEquilibrationTime is set to Null if it is not specified by the user or method and SolidPhaseExtractionWashTemperature is Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionWashTemperature -> Ambient,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashTemperatureEquilibrationTime -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashTemperatureEquilibrationTime, "SolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SolidPhaseExtractionWashTemperature is not Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionWashTemperature -> 37 Celsius,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashTemperatureEquilibrationTime -> 3 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashCentrifugeIntensity, "SolidPhaseExtractionWashCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashCentrifugeIntensity -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashCentrifugeIntensity, "SolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashPressure, "SolidPhaseExtractionWashPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashPressure -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashPressure, "SolidPhaseExtractionWashPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashTime, "SolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashTime -> 1 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, CollectSolidPhaseExtractionWashFlowthrough, "CollectSolidPhaseExtractionWashFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{CollectSolidPhaseExtractionWashFlowthrough -> False}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionWashFlowthroughContainerOut, "SolidPhaseExtractionWashFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionWashFlowthroughContainerOut -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashSolution, "SecondarySolidPhaseExtractionWashSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"]}],(*TODO set to experiment-specific model*)
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashSolutionVolume, "SecondarySolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashSolutionVolume -> 1. Milliliter}](*TODO change to something less than volume of cartridge*),
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashTemperature, "SecondarySolidPhaseExtractionWashTemperature is set to Ambient if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashTemperature -> $AmbientTemperature}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, "SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to Null if it is not specified by the user or method and SecondarySolidPhaseExtractionWashTemperature is Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SecondarySolidPhaseExtractionWashTemperature -> Ambient,
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, "SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SecondarySolidPhaseExtractionWashTemperature is not Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SecondarySolidPhaseExtractionWashTemperature -> 37 Celsius,
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> 3 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashCentrifugeIntensity, "SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashCentrifugeIntensity, "SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashPressure, "SecondarySolidPhaseExtractionWashPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashPressure -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashPressure, "SecondarySolidPhaseExtractionWashPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashTime, "SecondarySolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashTime -> 1 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, CollectSecondarySolidPhaseExtractionWashFlowthrough, "CollectSecondarySolidPhaseExtractionWashFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{CollectSecondarySolidPhaseExtractionWashFlowthrough -> False}],
				TimeConstraint -> 3600
			],
			Example[{Options, SecondarySolidPhaseExtractionWashFlowthroughContainerOut, "SecondarySolidPhaseExtractionWashFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashSolution, "TertiarySolidPhaseExtractionWashSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashSolution -> Model[Sample,"Milli-Q water"]}],(*TODO set to experiment-specific model*)
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashSolutionVolume, "TertiarySolidPhaseExtractionWashSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashSolutionVolume -> 1. Milliliter}](*TODO change to something less than volume of cartridge*),
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashTemperature, "TertiarySolidPhaseExtractionWashTemperature is set to Ambient if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashTemperature -> $AmbientTemperature}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, "TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to Null if it is not specified by the user or method and TertiarySolidPhaseExtractionWashTemperature is Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					TertiarySolidPhaseExtractionWashTemperature -> Ambient,
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, "TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and TertiarySolidPhaseExtractionWashTemperature is not Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					TertiarySolidPhaseExtractionWashTemperature -> 37 Celsius,
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> 3 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashCentrifugeIntensity, "TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashCentrifugeIntensity, "TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashPressure, "TertiarySolidPhaseExtractionWashPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashPressure -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashPressure, "TertiarySolidPhaseExtractionWashPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashTime, "TertiarySolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashTime -> 1 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, CollectTertiarySolidPhaseExtractionWashFlowthrough, "CollectTertiarySolidPhaseExtractionWashFlowthrough is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{CollectTertiarySolidPhaseExtractionWashFlowthrough -> False}],
				TimeConstraint -> 3600
			],
			Example[{Options, TertiarySolidPhaseExtractionWashFlowthroughContainerOut, "TertiarySolidPhaseExtractionWashFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionSolution, "SolidPhaseExtractionElutionSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionSolution -> Model[Sample,"Milli-Q water"]}],(*TODO set to experiment-specific model*)
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionSolutionVolume, "SolidPhaseExtractionElutionSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionSolutionVolume -> 1. Milliliter}](*TODO change to something less than volume of cartridge*),
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionSolutionTemperature, "SolidPhaseExtractionElutionSolutionTemperature is set to Ambient if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					{previouslyExtractedSampleInPlate},
					Purification->{SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionSolutionTemperature -> $AmbientTemperature}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, "SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime is set to Null if it is not specified by the user or method and SolidPhaseExtractionWashTemperature is Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionElutionSolutionTemperature -> Ambient,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime, "SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime is set to 3 Minutes if it is not specified by the user or method and SolidPhaseExtractionWashTemperature is not Ambient or Null:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionElutionSolutionTemperature -> 37 Celsius,
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> 3 Minute}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionCentrifugeIntensity, "SolidPhaseExtractionElutionCentrifugeIntensity is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, Centrifuge] or Object[Instrument, Centrifuge]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionCentrifugeIntensity -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionCentrifugeIntensity, "SolidPhaseExtractionElutionCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
				Lookup[myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				], SolidPhaseExtractionElutionCentrifugeIntensity],
				5000 RPM,
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionPressure, "SolidPhaseExtractionElutionPressure is set to Null if it is not specified by the user or method and SolidPhaseExtractionInstrument is not a Model[Instrument, PressureManifold] or Object[Instrument, PressureManifold]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionPressure -> Null}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionPressure, "SolidPhaseExtractionElutionPressure is set to the MaxPressure of the PressureManifold model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"MPE2\"] or Object[Instrument, Centrifuge, \"MPE2\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionPressure -> $MaxRoboticAirPressure}],
				TimeConstraint -> 3600
			],
			Example[{Options, SolidPhaseExtractionElutionTime, "SolidPhaseExtractionElutionTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> {SolidPhaseExtraction},
					Output -> Options
				],
				KeyValuePattern[{SolidPhaseExtractionElutionTime -> 1 Minute}],
				TimeConstraint -> 3600
			]
		};
