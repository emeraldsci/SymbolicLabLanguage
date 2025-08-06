(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(* ExperimentExtractRNA Options *)
DefineOptions[ExperimentExtractRNA,
	Options :> {
		(* Index matching Options to SamplesIn *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",

			(* --- GENERAL OPTIONS --- *)
			ModifyOptions[CellExtractionSharedOptions,
				Method,
				{
					Default -> Automatic,
					Widget -> Alternatives[
						Widget[Type -> Enumeration, Pattern :> Alternatives[Custom]],
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, Extraction, RNA]],
							OpenPaths -> {
								{Object[Catalog, "Root"],
									"Materials",
									"Reagents"(*,
					               "Cell Culture",
					               "Exraction Methods"*)
								} (* TODO Add "Extraction Methods" to the catalog *)
							}
						]
					],
					Description -> "The set of reagents and recommended operating conditions which are used to extract RNA from the input sample. These often come from manufacturer recommendations. Custom indicates that all reagents and conditions are individually selected by the user."
				}
			],

			{
				OptionName -> TargetRNA,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"RNA" -> Widget[
						Type -> Enumeration,
						Pattern :> CellularRNAP
					],
					"Unspecified" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Unspecified]
					]
				],
				Description -> "The type of RNA that is purified during the extraction. TotalRNA is extracted from cell lysate. Subsets of cellular RNA (mRNA, miRNA, tRNA, rRNA) are preferentially purified from a cell lysate by varying extraction conditions such as lysis or wash solutions. ViralRNA, ExosomalRNA, or CellFreeRNA are extracted and purified from harvested media or viral particles without lysing cells.",
				ResolutionDescription -> "Automatically set to the TargetRNA specified by the selected Method. Otherwise, TargetRNA is automatically set to Unspecified.",
				Category -> "General"
			},

			ModifyOptions[CellExtractionSharedOptions,
				ContainerOut,
				Description -> "The container into which the output sample resulting from the protocol is collected. The ContainerOut must be compatible with the instrument and technique used during the final unit operation of this experiment. For example, if the final unit operation performed on a sample is elution from a 96-well SolidPhaseExtraction filter plate, the ContainerOut must be a 96-well plate."
			],

			ModifyOptions[CellExtractionSharedOptions,
				ContainerOutWell
			],

			ModifyOptions[CellExtractionSharedOptions,
				IndexedContainerOut
			],

			{
				OptionName -> ExtractedRNALabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Description -> "A user defined word or phrase used to identify the sample that contains the extracted RNA, for use in downstream unit operations.",
				ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise set to \"extracted RNA sample #\".",
				Category -> "General",
				UnitOperation -> True
			},

			{
				OptionName -> ExtractedRNAContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Description -> "A user defined word or phrase used to identify the container that contains the extracted RNA sample, for use in downstream unit operations.",
				ResolutionDescription -> "Automatically set to the previously specified label if the same sample has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise set to \"extracted RNA sample container #\".",
				Category -> "General",
				UnitOperation -> True
			},

			(* --- LYSIS OPTIONS --- *)
			{
				OptionName -> Lyse,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if lysis reagents or conditions are applied to the input sample, chemically breaking the cells' plasma membranes (and cell wall, depending on the cell type) and releasing the cell components into the chosen solution, creating a lysate to extract the RNA from. If the input is live cells, Lyse is automatically set to True and lysis is performed before extraction. If the input is already lysate, Lyse is automatically set to False and the function proceeds directly to extraction.",
				ResolutionDescription -> "Automatically set to match the Lyse setting specified by the selected Method. If the Method does not specify Lyse, or if no Method is selected, Lyse is automatically set to True if any cell lysis options are specified. Otherwise, Lyse is automatically set to True if the input composition includes Model[Cell]. Lyse is automatically set to False if the input composition includes Model[Lysate] without Model[Cell]. Otherwise, Lyse is automatically set to False.",
				Category -> "Lysis"
			},

			(* Including all Options from CellLysisOptions EXCEPT for TargetCellularComponent (will always be RNA) NumberOfLysisReplicates *)
			Sequence@@ModifyOptions[CellLysisOptions,
				ToExpression[Keys[
					KeyDrop[Options[CellLysisOptions], {Key["TargetCellularComponent"]}]
				]]
			],

			(* --- LYSATE HOMOGENIZATION OPTIONS --- *)

			{
				OptionName -> HomogenizeLysate,
				Default -> Automatic,
				Description -> "Indicates if lysate samples are disrupted using mechanical forces to shear large subcellular components, after lysis and prior to purification steps. Lysate homogenization can prevent clogging of solid phase extraction cartridges, if SolidPhaseExtraction is employed during Purification.",
				ResolutionDescription -> "Automatically set to match the HomogenizeLysate setting specified by the selected Method. If the Method does not specify HomogenizeLysate, or if no Method is selected, HomogenizeLysate is automatically set to True if Purification includes SolidPhaseExtraction or MagneticBeadSeparation steps. Otherwise, HomogenizeLysate is automatically set to False.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Lysate Homogenization"
			},
			{
				OptionName -> HomogenizationDevice,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Labware", "Filters", "Filter Plates"}
					}
				],
				Description -> "The consumable container with an embedded filter which is used to shear lysate components by flushing the lysate sample through the pores in the filter.",
				ResolutionDescription -> "Automatically set to Model[Container, Plate, Filter, \"96-well Homogenizer Plate\"] if HomogenizeLysate is set to True.",(*Model[Container, Plate, Filter, "id:BYDOjvDrblOE"]*)
				Category -> "Lysate Homogenization"
			},
			{
				OptionName -> HomogenizationCollectionContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Model[Container]}]
					],
					"Container with Index" -> {
						"Index"->Widget[
							Type->Number,
							Pattern:>GreaterEqualP[1,1]
						],
						"Container"->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Container]}],
							PreparedSample->False,
							PreparedContainer->False
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
							Pattern :> ObjectP[{Object[Container],Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					},
					"Container with Well and Index" -> {
						"Well" -> Widget[
							Type->Enumeration,
							Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
							PatternTooltip->"Enumeration must be any well from A1 to P24."
						],
						"Index and Container"->{
							"Index"->Widget[
								Type->Number,
								Pattern:>GreaterEqualP[1,1]
							],
							"Container"->Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Container]}],
								PreparedSample->False,
								PreparedContainer->False
							]
						}
					}
				],
				Description->"The plate that the HomogenizationDevice is placed on top of before flushing the lysate through the HomogenizationDevice and into the HomogenizationCollectionContainer below.",
				ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"] if HomogenizeLysate is set to True.",
				Category -> "Hidden"
			},
			{
				OptionName -> HomogenizationTechnique,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Centrifuge | AirPressure
				],
				Description -> "The type of force used to flush the cell lysate sample through the HomogenizationDevice in order to shear lysate components.",
				ResolutionDescription -> "Automatically set to AirPressure if HomogenizeLysate is set to True.",
				Category -> "Lysate Homogenization"
			},
			{
				OptionName -> HomogenizationInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument, Centrifuge], Object[Instrument, Centrifuge],
						Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]
					}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Robotic Compatible Microcentrifuges"},
						{Object[Catalog, "Root"], "Instruments", "Robotic Compatible Filtering Devices"}
					}
				],
				Description -> "The Instrument that generates force to flush the cell lysate sample through the HomogenizationDevice during the HomogenizationTime.",
				ResolutionDescription -> "Automatically set to an instrument model that that matches the HomogenizationTechnique and can be used to with the specified option settings (see CentrifugeDevices and FilterDevices help files). If HomogenizationTechnique is not specified, HomogenizationInstrument is automatically set to Model[Instrument, Centrifuge, \"HiG4\"] if HomogenizationCentrifugeIntensity is specified. Otherwise, HomogenizationInstrument is automatically set to Model[Instrument, PressureManifold, \"MPE2\"].",
				Category -> "Lysate Homogenization"
			},
			{
				OptionName -> HomogenizationCentrifugeIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Speed" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 RPM, $MaxRoboticCentrifugeSpeed],
						Units -> RPM
					],
					"Force" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 GravitationalAcceleration, $MaxRoboticRelativeCentrifugalForce],
						Units -> GravitationalAcceleration
					]
				],
				Description -> "The rotational speed or gravitational force at which the sample is centrifuged to flush the lysate through the HomogenizationDevice in order to shear lysate components.",
				ResolutionDescription -> "Automatically set to the lesser of the MaxIntensity of the centrifuge model and the MaxCentrifugationForce of the HomogenizationDevice.",
				Category -> "Lysate Homogenization"
			},
			{
				OptionName -> HomogenizationPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 PSI, $MaxRoboticAirPressure],
					Units -> {PSI, {Pascal, Kilopascal, PSI, Millibar, Bar}}
				],
				Description -> "The amount of pressure applied to flush the lysate through the HomogenizationDevice in order to shear lysate components.",
				ResolutionDescription -> "Automatically set to the lesser of the MaxPressure of the positive pressure model and the MaxPressure of the HomogenizationDevice.",
				Category -> "Lysate Homogenization"
			},
			{
				OptionName -> HomogenizationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, $MaxExperimentTime],
					Units -> {Second, {Second, Minute, Hour}}
				],
				Description -> "The duration of time for which force is applied to flush the lysate through the HomogenizationDevice by the specified HomogenizationTechnique and HomogenizationInstrument in order to shear lysate components.",
				ResolutionDescription -> "Automatically set to 1 Minute if HomogenizeLysate is set to True.",
				Category -> "Lysate Homogenization"
			},

			(* --- DEHYDRATION OPTIONS --- *)
			(* in most RNA extraction protocols, where MBS or SPE are used there is an initial 'loading buffer' step in which a solution containing ~70% EtOH is added to the lysate (or homogenized lysate) prior to loading on to the solid phase material (bead or column) *)
			(* the purpose is to dehydrate the RNA molecules so they will interact better with the silica sorbent *)
			{
				OptionName->DehydrationSolution,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Dehydration Solution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
						OpenPaths -> {
							{Object[Catalog, "Root"], "Materials", "Reagents"}
						}
					],
					"None"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None]]
				],
				Description->"The solution that is added to the sample prior to a purification step in order to promote binding of the analyte to the Sorbent. When Strategy is set to Positive, DehydrationSolution promotes binding of the TargetRNA to the Sorbent.",
				ResolutionDescription->"Automatically set to the DehydrationSolution specified by the selected Method. If Method is set to Custom, DehydrationSolution is automatically set to Model[Sample,Stock Solution,\"70% Ethanol\"].",
				Category->"Dehydration"
			},
			{
				OptionName->DehydrationSolutionVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,$MaxTransferVolume],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The volume of DehydrationSolution that is added to the sample prior to a purification step in order to promote binding of the analyte to the Sorbent. When Strategy is set to Positive, DehydrationSolution promotes binding of the TargetRNA to the Sorbent.",
				ResolutionDescription->"Automatically set to the lesser of 50% of the SampleVolume or 50% of the remaining space in the container (the remaining space is calculated as the MaxVolume of the Cartridge minus the SampleVolume).",
				Category->"Dehydration"
			},
			{
				OptionName->DehydrationSolutionMixType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Shake|Pipette|None
				],
				Description->"The manner in which the sample is agitated following addition of DehydrationSolution to the sample. None specifies that no mixing occurs after adding DehydrationSolution to the sample.",
				ResolutionDescription->"Automatically set to the dehydration solution mix type specified by the selected Method. If Method is set to Custom, DehydrationSolutionMixType is automatically set to Shake if any corresponding Shaking options are set (DehydrationSolutionMixRate, DehydrationSolutionMixTime), or set to Pipette if any corresponding Pipette mixing options are set (DehydrationSolutionMixVolume, NumberOfDehydrationSolutionMixes). Otherwise, DehydrationSolutionMixType is automatically set to Shake.",
				Category->"Dehydration"
			},
			{
				OptionName->NumberOfDehydrationSolutionMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1, $MaxNumberOfMixes, 1]
				],
				Description->"The number of times that the sample is mixed by pipetting the DehydrationSolutionMixVolume up and down following the addition of DehydrationSolution to the sample.",
				ResolutionDescription->"Automatically set to the NumberOfDehydrationSolutionMixes specified by the selected Method. If Method is set to Custom and DehydrationSolutionMixType is set to Pipette, NumberOfDehydrationSolutionMixes is automatically set to 10.",
				Category->"Dehydration"
			},
			{
				OptionName->DehydrationSolutionMixVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,$MaxRoboticTransferVolume],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The volume of sample containing DehydrationSolution that is displaced during each mix-by-pipet mix cycle.",
				ResolutionDescription->"Automatically set to the lesser of 50% of the total volume of the sample containing LoadingSolution or the MaxMicropipetteVolume.",
				Category->"Dehydration"
			},
			{
				OptionName->DehydrationSolutionMixRate,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$MinBioSTARMixRate,$MaxBioSTARMixRate],
					Units->RPM
				],
				Description->"The number of rotations per minute at which the sample containing DehydrationSolution is shaken in order to fully mix the DehydrationSolution with the sample, during the DehydrationSolutionMixTime.",
				ResolutionDescription->"Automatically set to the DehydrationSolutionMixRate specified by the selected Method. If Method is set to Custom, DehydrationSolutionMixRate is automatically set to 100 RPM if DehydrationSolutionMixType is set to Shake, or 0.5 milliliter per second if DehydrationSolutionMixType is set to Pipette.",
				Category->"Dehydration"
			},
			{
				OptionName->DehydrationSolutionMixTime,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, $MaxExperimentTime],
					Units -> {Second, {Second, Minute, Hour}}
				],
				Description -> "The duration for which the sample and DehydrationSolution are mixed by the selected DehydrationSolutionMixType following the combination of the sample and the DehydrationSolution.",
				ResolutionDescription->"Automatically set to the DehydrationSolutionMixTime specified by the selected Method. If Method is set to Custom, DehydrationSolutionMixTime is automatically set to 30 Second if DehydrationSolutionMixType is set to Shake.",
				Category->"Dehydration"
			},

			(* --- ISOLATION OPTIONS --- *)
			(* PurificationStepsSharedOptions set contains shared option sets for LLE, SPE, MBS, and precipitation. *)
			(* All are index-matched except for two MBS options, which are in the NonIndexMatchedExtractionMagneticBeadSharedOptions set outside of this index matched section *)

			(*--- PURIFICATION ---*)
			ModifyOptions[PurificationStepsSharedOptions,
				Purification
			],

			ExtractionMagneticBeadSharedOptions,
			ExtractionLiquidLiquidSharedOptions,
			ExtractionPrecipitationSharedOptions,

			(*--SPE Options with customization--*)
			Sequence@@ModifyOptions[ExtractionSolidPhaseSharedOptions,
				ToExpression[Keys[
					KeyDrop[
						Options[ExtractionSolidPhaseSharedOptions],
						{Key["SolidPhaseExtractionLoadingTemperature"], Key["SolidPhaseExtractionLoadingTemperatureEquilibrationTime"], Key["SolidPhaseExtractionWashTemperature"], Key["SolidPhaseExtractionWashTemperatureEquilibrationTime"], Key["SecondarySolidPhaseExtractionWashTemperature"], Key["SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime"], Key["TertiarySolidPhaseExtractionWashTemperature"], Key["TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime"], Key["SolidPhaseExtractionElutionSolutionTemperature"], Key["SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime"]}
					]
				]]
			],

			Sequence@@ModifyOptions[ExtractionSolidPhaseSharedOptions,
				{
					SolidPhaseExtractionLoadingTemperature, SolidPhaseExtractionLoadingTemperatureEquilibrationTime,
					SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTemperatureEquilibrationTime,
					SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
					TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
					SolidPhaseExtractionElutionSolutionTemperature, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime
				},
				{
					Category -> "Hidden"
				}
			]

		],

		ModifyOptions[CellExtractionSharedOptions,
			RoboticInstrument
		],

		(* shared protocol options *)
		NonIndexMatchedExtractionMagneticBeadSharedOptions,
		RoboticPreparationOption,
		ProtocolOptions,
		SimulationOption,
		BiologyPostProcessingOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		WorkCellOption

	}];

(* ::Subsubsection::Closed:: *)
(*$HomogenizationOptionMap*)

$HomogenizationOptionMap = {
	HomogenizationDevice -> Filter,
	HomogenizationCollectionContainer -> FiltrateContainerOut,
	HomogenizationTechnique -> FiltrationType,
	HomogenizationInstrument -> Instrument,
	HomogenizationCentrifugeIntensity -> Intensity,
	HomogenizationPressure -> Pressure,
	HomogenizationTime -> Time
};

(* ::Subsubsection::Closed:: *)
(*Messages*)

(* shared messages *)
(*DuplicateName,MethodOptionConflict,RoboticInstrumentInvalidCellType,RoboticInstrumentCellTypeMismatch,LysispOptionMismatch,RepeatedLysis,UnlysedCellsInput,LiquidLiquidExtractionOptionMismatch,PrecipitationOptionMismatch,SolidPhaseExtractionOptionMismatch,MagneticBeadSeparationOptionMismatch*)

Warning::MethodTargetRNAMismatch = "The sample(s), `1`, at indices `4`, have a target RNA, `3`, which is not listed as a target by the specified method, `2`.";
Error::NoExtractRNAStepsSet = "The sample(s), `1`, at indices, `2`, do not have any extraction steps set (Lysis, Homogenization, Dehydration, or Purification) to extract RNA from the samples. Please specify options for one or more extraction steps for these samples.";
Warning::CellFreeLysis = "The sample(s), `1`, at indices `2`, have CellFreeRNA set as the TargetRNA and also have Lyse set to True. Lysis is not required if the sample(s) do not contain cells.";
Error::LysateHomogenizationOptionMismatch = "The sample(s), `1`, at indices `4`, have lysate homogenization options set and also have HomogenizeLysate set to False. For the sample(s), `1`, please set the following lysate homogenization options, (`3`), to Null, or set HomogenizeLysate to True.";
Warning::HomogenizationPurificationOptionMismatch = "The sample(s), `1`, at indices `2`, have SolidPhaseExtraction set as the first Purification technique, and also have HomogenizeLysate set to False. Lysate homogenization can prevent clogging of solid phase extraction cartridges if SolidPhaseExtraction is the first Purification technique performed.";
Error::HomogenizationTechniqueInstrumentMismatch = "The homogenization instrument, `3`, set for the sample(s), `1`, at indices, `4`, cannot perform the homogenization technique, `2`. For the sample(s), `1`, please select a homogenization instrument that can perform the homogenization technique, `2`, or select a homogenization technique that can be performed on the homogenization instrument, `3`.";
Error::HomogenizationCentrifugeIntensityPressureMismatch = "The sample(s), `1`, at indices, `4`, have a centrifuge intensity, `2`, and/or a pressure ,`3`, set for homogenization. If HomogenizeLysate is set to True, exactly one (not both or neither) of HomogenizationCentrifugeIntensity and HomogenizationPressure can be specified. For the sample(s), `1`, please set HomogenizationCentrifugeIntensity to Null if HomogenizationTechnique is set to AirPressure, or set HomogenizationPressure to Null if HomogenizationTechnique is set to Centrifuge.";
Warning::EstimatedDehydrationSolutionVolume = "The sample(s), `1`, at indices, `3`, will have a DehydrationSolution added to the sample before the sample is transferred to the purification substrate (eg. SolidPhaseExtraction column or MagneticBeads), but DehydrationSolutionVolume is not specified. For these samples, DehydrationSolutionVolume(s) have been set to the following values: `2`, which are estimated based on the sample volume and container maximum volumes. If a different volume is desired, please set DehydrationSolutionVolume directly for these samples. If a Dehydration step should not be performed, please set DehydrationSolution to Null for these samples.";

(* ::Subsubsection::Closed:: *)
(*$ExtractRNAMethodFields*)

$ExtractRNAMethodFields =
	{
		AqueousSolvent,AqueousSolventRatio,CellType,ClarifyLysate,ClarifyLysateIntensity,ClarifyLysateTime,DehydrationSolution,DehydrationSolutionMixRate,DehydrationSolutionMixTime,DehydrationSolutionMixType,Demulsifier,DemulsifierAdditions,ElutionMagnetizationTime,EquilibrationMagnetizationTime,HomogenizationCentrifugeIntensity,HomogenizationDevice,HomogenizationPressure,HomogenizationTechnique,HomogenizationTime,HomogenizeLysate,LiquidLiquidExtractionCentrifuge,LiquidLiquidExtractionCentrifugeIntensity,LiquidLiquidExtractionCentrifugeTime,LiquidLiquidExtractionDevice,LiquidLiquidExtractionMixRate,LiquidLiquidExtractionMixTime,LiquidLiquidExtractionMixType,LiquidLiquidExtractionSelectionStrategy,LiquidLiquidExtractionSettlingTime,LiquidLiquidExtractionSolventAdditions,LiquidLiquidExtractionTargetLayer,LiquidLiquidExtractionTargetPhase,LiquidLiquidExtractionTechnique,LiquidLiquidExtractionTemperature,LoadingMagnetizationTime,Lyse,LysisMixRate,LysisMixTemperature,LysisMixTime,LysisMixType,LysisSolution,LysisTemperature,LysisTime,MagneticBeadAffinityLabel,MagneticBeads,MagneticBeadSeparationAnalyteAffinityLabel,MagneticBeadSeparationElution,MagneticBeadSeparationElutionMix,MagneticBeadSeparationElutionMixRate,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionSolution,MagneticBeadSeparationEquilibration,MagneticBeadSeparationEquilibrationAirDry,MagneticBeadSeparationEquilibrationAirDryTime,MagneticBeadSeparationEquilibrationMix,MagneticBeadSeparationEquilibrationMixRate,MagneticBeadSeparationEquilibrationMixTemperature,MagneticBeadSeparationEquilibrationMixTime,MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationSolution,MagneticBeadSeparationLoadingAirDry,MagneticBeadSeparationLoadingAirDryTime,MagneticBeadSeparationLoadingMix,MagneticBeadSeparationLoadingMixRate,MagneticBeadSeparationLoadingMixTemperature,MagneticBeadSeparationLoadingMixTime,MagneticBeadSeparationLoadingMixType,MagneticBeadSeparationMode,MagneticBeadSeparationPreWash,MagneticBeadSeparationPreWashAirDry,MagneticBeadSeparationPreWashAirDryTime,MagneticBeadSeparationPreWashMix,MagneticBeadSeparationPreWashMixRate,MagneticBeadSeparationPreWashMixTemperature,MagneticBeadSeparationPreWashMixTime,MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashSolution,MagneticBeadSeparationQuaternaryWash,MagneticBeadSeparationQuaternaryWashAirDry,MagneticBeadSeparationQuaternaryWashAirDryTime,MagneticBeadSeparationQuaternaryWashMix,MagneticBeadSeparationQuaternaryWashMixRate,MagneticBeadSeparationQuaternaryWashMixTemperature,MagneticBeadSeparationQuaternaryWashMixTime,MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashSolution,MagneticBeadSeparationQuinaryWash,MagneticBeadSeparationQuinaryWashAirDry,MagneticBeadSeparationQuinaryWashAirDryTime,MagneticBeadSeparationQuinaryWashMix,MagneticBeadSeparationQuinaryWashMixRate,MagneticBeadSeparationQuinaryWashMixTemperature,MagneticBeadSeparationQuinaryWashMixTime,MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashSolution,MagneticBeadSeparationSecondaryWash,MagneticBeadSeparationSecondaryWashAirDry,MagneticBeadSeparationSecondaryWashAirDryTime,MagneticBeadSeparationSecondaryWashMix,MagneticBeadSeparationSecondaryWashMixRate,MagneticBeadSeparationSecondaryWashMixTemperature,MagneticBeadSeparationSecondaryWashMixTime,MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashSolution,MagneticBeadSeparationSelectionStrategy,MagneticBeadSeparationSenaryWash,MagneticBeadSeparationSenaryWashAirDry,MagneticBeadSeparationSenaryWashAirDryTime,MagneticBeadSeparationSenaryWashMix,MagneticBeadSeparationSenaryWashMixRate,MagneticBeadSeparationSenaryWashMixTemperature,MagneticBeadSeparationSenaryWashMixTime,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashSolution,MagneticBeadSeparationSeptenaryWash,MagneticBeadSeparationSeptenaryWashAirDry,MagneticBeadSeparationSeptenaryWashAirDryTime,MagneticBeadSeparationSeptenaryWashMix,MagneticBeadSeparationSeptenaryWashMixRate,MagneticBeadSeparationSeptenaryWashMixTemperature,MagneticBeadSeparationSeptenaryWashMixTime,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashSolution,MagneticBeadSeparationTertiaryWash,MagneticBeadSeparationTertiaryWashAirDry,MagneticBeadSeparationTertiaryWashAirDryTime,MagneticBeadSeparationTertiaryWashMix,MagneticBeadSeparationTertiaryWashMixRate,MagneticBeadSeparationTertiaryWashMixTemperature,MagneticBeadSeparationTertiaryWashMixTime,MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashSolution,MagneticBeadSeparationWash,MagneticBeadSeparationWashAirDry,MagneticBeadSeparationWashAirDryTime,MagneticBeadSeparationWashMix,MagneticBeadSeparationWashMixRate,MagneticBeadSeparationWashMixTemperature,MagneticBeadSeparationWashMixTime,MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashSolution,NumberOfDehydrationSolutionMixes,NumberOfLiquidLiquidExtractionMixes,NumberOfLiquidLiquidExtractions,NumberOfLysisMixes,NumberOfLysisSteps,NumberOfMagneticBeadSeparationElutionMixes,NumberOfMagneticBeadSeparationElutions,NumberOfMagneticBeadSeparationEquilibrationMixes,NumberOfMagneticBeadSeparationLoadingMixes,NumberOfMagneticBeadSeparationPreWashes,NumberOfMagneticBeadSeparationPreWashMixes,NumberOfMagneticBeadSeparationQuaternaryWashes,NumberOfMagneticBeadSeparationQuaternaryWashMixes,NumberOfMagneticBeadSeparationQuinaryWashes,NumberOfMagneticBeadSeparationQuinaryWashMixes,NumberOfMagneticBeadSeparationSecondaryWashes,NumberOfMagneticBeadSeparationSecondaryWashMixes,NumberOfMagneticBeadSeparationSenaryWashes,NumberOfMagneticBeadSeparationSenaryWashMixes,NumberOfMagneticBeadSeparationSeptenaryWashes,NumberOfMagneticBeadSeparationSeptenaryWashMixes,NumberOfMagneticBeadSeparationTertiaryWashes,NumberOfMagneticBeadSeparationTertiaryWashMixes,NumberOfMagneticBeadSeparationWashes,NumberOfMagneticBeadSeparationWashMixes,NumberOfPrecipitationMixes,OrganicSolvent,OrganicSolventRatio,PrecipitationDryingTemperature,PrecipitationDryingTime,PrecipitationFilter,PrecipitationFilterCentrifugeIntensity,PrecipitationFiltrationPressure,PrecipitationFiltrationTechnique,PrecipitationFiltrationTime,PrecipitationMembraneMaterial,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,PrecipitationMixType,PrecipitationNumberOfResuspensionMixes,PrecipitationNumberOfWashes,PrecipitationNumberOfWashMixes,PrecipitationPelletCentrifugeIntensity,PrecipitationPelletCentrifugeTime,PrecipitationPoreSize,PrecipitationPrefilterMembraneMaterial,PrecipitationPrefilterPoreSize,PrecipitationReagent,PrecipitationReagentEquilibrationTime,PrecipitationReagentTemperature,PrecipitationResuspensionBuffer,PrecipitationResuspensionBufferEquilibrationTime,PrecipitationResuspensionBufferTemperature,PrecipitationResuspensionMixRate,PrecipitationResuspensionMixTemperature,PrecipitationResuspensionMixTime,PrecipitationResuspensionMixType,PrecipitationSeparationTechnique,PrecipitationTargetPhase,PrecipitationTemperature,PrecipitationTime,PrecipitationWashCentrifugeIntensity,PrecipitationWashMixRate,PrecipitationWashMixTemperature,PrecipitationWashMixTime,PrecipitationWashMixType,PrecipitationWashPrecipitationTemperature,PrecipitationWashPrecipitationTime,PrecipitationWashPressure,PrecipitationWashSeparationTime,PrecipitationWashSolution,PrecipitationWashSolutionEquilibrationTime,PrecipitationWashSolutionTemperature,PreLysisPellet,PreLysisPelletingIntensity,PreLysisPelletingTime,PreWashMagnetizationTime,Purification,QuaternaryWashMagnetizationTime,QuinaryWashMagnetizationTime,SecondaryLysisMixRate,SecondaryLysisMixTemperature,SecondaryLysisMixTime,SecondaryLysisMixType,SecondaryLysisSolution,SecondaryLysisTemperature,SecondaryLysisTime,SecondaryNumberOfLysisMixes,SecondarySolidPhaseExtractionWashCentrifugeIntensity,SecondarySolidPhaseExtractionWashPressure,SecondarySolidPhaseExtractionWashSolution,SecondarySolidPhaseExtractionWashTemperature,SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,SecondarySolidPhaseExtractionWashTime,SecondaryWashMagnetizationTime,SenaryWashMagnetizationTime,SeptenaryWashMagnetizationTime,SolidPhaseExtractionCartridge,SolidPhaseExtractionDigestionTemperature,SolidPhaseExtractionDigestionTime,SolidPhaseExtractionElutionCentrifugeIntensity,SolidPhaseExtractionElutionPressure,SolidPhaseExtractionElutionSolution,SolidPhaseExtractionElutionSolutionTemperature,SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,SolidPhaseExtractionElutionTime,SolidPhaseExtractionLoadingCentrifugeIntensity,SolidPhaseExtractionLoadingPressure,SolidPhaseExtractionLoadingTemperature,SolidPhaseExtractionLoadingTemperatureEquilibrationTime,SolidPhaseExtractionLoadingTime,SolidPhaseExtractionSeparationMode,SolidPhaseExtractionSorbent,SolidPhaseExtractionStrategy,SolidPhaseExtractionTechnique,SolidPhaseExtractionWashCentrifugeIntensity,SolidPhaseExtractionWashPressure,SolidPhaseExtractionWashSolution,SolidPhaseExtractionWashTemperature,SolidPhaseExtractionWashTemperatureEquilibrationTime,SolidPhaseExtractionWashTime,TargetRNA,TertiaryLysisMixRate,TertiaryLysisMixTemperature,TertiaryLysisMixTime,TertiaryLysisMixType,TertiaryLysisSolution,TertiaryLysisTemperature,TertiaryLysisTime,TertiaryNumberOfLysisMixes,TertiarySolidPhaseExtractionWashCentrifugeIntensity,TertiarySolidPhaseExtractionWashPressure,TertiarySolidPhaseExtractionWashSolution,TertiarySolidPhaseExtractionWashTemperature,TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,TertiarySolidPhaseExtractionWashTime,TertiaryWashMagnetizationTime,WashMagnetizationTime
	};

(* ::Subsection::Closed:: *)
(* ExperimentExtractRNA *)

(* - Container to Sample Overload - *)
ExperimentExtractRNA[myContainers:ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions:OptionsPattern[]] := Module[
	{cache, listedOptions, listedContainers, outputSpecification, output, gatherTests, containerToSampleResult,
		containerToSampleOutput, samples, sampleOptions, containerToSampleTests, simulation,
		containerToSampleSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* Fetch the cache from listedOptions. *)
	cache = ToList[Lookup[listedOptions, Cache, {}]];
	simulation = Lookup[listedOptions, Simulation, Null];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentExtractRNA,
			listedContainers,
			listedOptions,
			Output -> {Result, Tests, Simulation},
			Simulation -> simulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentExtractRNA,
				listedContainers,
				listedOptions,
				Output -> {Result, Simulation},
				Simulation -> simulation
			],
			$Failed,
			{Download::ObjectDoesNotExist, Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];


	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentExtractRNA[samples, ReplaceRule[sampleOptions, Simulation -> simulation]]
	]
];

(* -- Main Overload --*)
ExperimentExtractRNA[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[]] := Module[
	{
		cache, cacheBall, collapsedResolvedOptions, expandedSafeOpsWithoutPurification, expandedSafeOpsWithoutSolventAdditions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,inputSimulation,
		listedSamples, messages, output, outputSpecification, performSimulationQ, resultQ, resourcePacketResult, resourceReturnEarlyQ,
		protocolObject, preResolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
		returnEarlyQ, safeOps, safeOptions, safeOptionTests, templatedOptions, templateTests, resolvedPreparation, roboticSimulation, runTime, fullyResolvedOptions,
		inheritedSimulation, userSpecifiedObjects, objectsExistQs, objectsExistTests, validLengths, validLengthTests, simulation, simulatedProtocol, listedSanitizedSamples,
		listedSanitizedOptions, sampleFields, samplePacketFields, sampleModelFields, sampleModelPacketFields, methodPacketFields, containerObjectFields,
		containerObjectPacketFields, containerObjects, allDownloadValues, containerModelFields, containerModelPacketFields, containerModelObjects
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Remove temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentExtractRNA, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentExtractRNA, listedOptions, AutoCorrect -> False], {}}
	];

	inputSimulation = Lookup[safeOptions, Simulation];

	(* Call sanitize-inputs to clean any named objects - replace all objects referenced by Name to ID *)
	{listedSanitizedSamples, safeOps, listedSanitizedOptions} = sanitizeInputs[listedSamples, safeOptions, listedOptions,Simulation->inputSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentExtractRNA, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentExtractRNA, {listedSanitizedSamples}, listedSanitizedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentExtractRNA, {listedSanitizedSamples}, listedSanitizedOptions, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentExtractRNA, {listedSanitizedSamples}, listedSanitizedOptions], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOpsWithoutPurification = Last[ExpandIndexMatchedInputs[ExperimentExtractRNA, {listedSanitizedSamples}, inheritedOptions]];

	(* Correct expansion of Purification option. *)
	expandedSafeOpsWithoutSolventAdditions = Experiment`Private`expandPurificationOption[inheritedOptions, expandedSafeOpsWithoutPurification, listedSanitizedSamples];

	(* Correct expansion of SolventAdditions if not Automatic. *)
	(* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
	expandedSafeOps = expandSolventAdditionsOption[mySamples, inheritedOptions, expandedSafeOpsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions, NumberOfLiquidLiquidExtractions];

	(* Fetch the cache from expandedSafeOps *)
	cache = Lookup[expandedSafeOps, Cache, {}];
	inheritedSimulation = Lookup[expandedSafeOps, Simulation, Null];

	(* Disallow Upload->False and Confirm->True. *)
	(* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
	If[MatchQ[Lookup[safeOps,Upload],False]&&TrueQ[Lookup[safeOps,Confirm]],
		Message[Error::ConfirmUploadConflict];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

	(* - DOWNLOAD - *)

	(* Download fields from samples that are required.*)
	(* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
	sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position, SamplePreparationCacheFields[Object[Sample]]}]];
	samplePacketFields = Packet@@sampleFields;
	sampleModelFields = DeleteDuplicates[Flatten[{Name, Composition, Density, Deprecated}]];
	sampleModelPacketFields = Packet@@sampleModelFields;
	methodPacketFields = Packet[All];
	containerObjectFields = {Contents, Model, Name, MaxVolume};
	containerObjectPacketFields = Packet@@containerObjectFields;
	containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
	containerModelPacketFields = Packet@@containerModelFields;

	containerModelObjects = DeleteDuplicates@Flatten[{
		Cases[
			Flatten[Lookup[safeOps, {LiquidLiquidExtractionContainer, ContainerOut}]],
			ObjectP[Model[Container]]
		],
		PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All],
		(* Model[Container, Plate, PhaseSeparator, "Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"] *)
		Model[Container, Plate, PhaseSeparator, "id:jLq9jXqrWW11"]
	}];

	containerObjects = DeleteDuplicates@Cases[
		Flatten[Lookup[safeOps, {LiquidLiquidExtractionContainer, ContainerOut}]],
		ObjectP[Object[Container]]
	];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	allDownloadValues = Quiet[
		Download[
			{
				(*1*)listedSanitizedSamples,
				(*2*)listedSanitizedSamples,
				(*3*)Cases[ToList[Lookup[expandedSafeOps, Method]], ObjectP[]],
				(*4*)listedSanitizedSamples,
				(*5*)listedSanitizedSamples,
				(*6*)containerModelObjects,
				(*7*)containerObjects,
				(*8*)Cases[ToList[Lookup[expandedSafeOps, RoboticInstrument]], ObjectP[]]
			},
			Evaluate[{
				(*1*){samplePacketFields},
				(*2*){Packet[Model[sampleModelFields]]},
				(*3*){methodPacketFields},
				(*4*){Packet[Container[containerObjectFields]]},
				(*5*){Packet[Container[Model][containerModelFields]]},
				(*6*){containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
				(*7*){containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]},
				(*8*){Packet[Model], Packet[Model[Object]]}
			}],
			Cache -> cache,
			Simulation -> inheritedSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall = FlattenCachePackets[{cache, allDownloadValues}];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* If we are gathering tests. This silences any messages being thrown. *)
		{preResolvedOptions, resolvedOptionsTests} = resolveExperimentExtractRNAOptions[
			ToList[Download[mySamples, Object]],
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> inheritedSimulation,
			Output -> {Result, Tests}
		];
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{preResolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* If we are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{preResolvedOptions, resolvedOptionsTests} = {
				resolveExperimentExtractRNAOptions[
					ToList[Download[mySamples, Object]],
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> inheritedSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			True,
		gatherTests,
			Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True,
			False
	];

	performSimulationQ = MemberQ[output, Result|Simulation];
	resultQ = MemberQ[output, Result];

	(* If option resolution failed, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentExtractRNA, preResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	resourcePacketResult = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			{{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests} = {{$Failed, $Failed, $Failed, $Failed}, {}},
		gatherTests,
			(* If we are gathering tests. This silences any messages being thrown. *)
			{{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests} = extractRNAResourcePackets[
				ToList[Download[mySamples, Object]],
				templatedOptions,
				preResolvedOptions,
				Cache -> cacheBall,
				Simulation -> inheritedSimulation,
				Output -> {Result, Tests}
			];
			(* Therefore, we have to run the tests to see if we encountered a failure. *)
			If[RunUnitTest[<|"Tests" -> resourcePacketTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests},
			$Failed
		],
		True,
			Check[
				{{resourceResult, roboticSimulation, runTime, fullyResolvedOptions}, resourcePacketTests} = {
					extractRNAResourcePackets[
						ToList[Download[mySamples, Object]],
						templatedOptions,
						preResolvedOptions,
						Cache -> cacheBall,
						Simulation -> inheritedSimulation
					],
					{}
				},
				$Failed,
				{Error::InvalidOption}
			]
		];

	(* run all the tests from the resolution in the resource packet function; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	resourceReturnEarlyQ = Which[
		MatchQ[resourcePacketResult, $Failed],
			True,
		gatherTests,
			Not[RunUnitTest[<|"Tests" -> resourcePacketTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True,
			False
	];

	(* Collapse the resolved options *)
	{collapsedResolvedOptions, resolvedPreparation} = If[MatchQ[resolvedOptionsResult, $Failed],
		{
			$Failed,
			Lookup[preResolvedOptions, Preparation]
		},
		{
			CollapseIndexMatchedOptions[
				ExperimentExtractRNA,
				fullyResolvedOptions,
				Ignore -> ToList[myOptions],
				Messages -> False
			],
			Lookup[fullyResolvedOptions, Preparation]
		}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentExtractRNA[
			If[MatchQ[resourceResult, $Failed],
				$Failed,
				Flatten[ToList[Rest[resourceResult]]] (* allUnitOperationPackets *)
			],
			ToList[Download[mySamples, Object]],
			fullyResolvedOptions,
			Cache -> cacheBall,
			If[MatchQ[roboticSimulation, SimulationP],
				Simulation -> roboticSimulation,
				Simulation -> Null
			],
			ParentProtocol -> Lookup[safeOps, ParentProtocol]
		],
		{Null, Null}
	];

	(* If option resolution failed in the resource packet function, return early. *)
	If[resourceReturnEarlyQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests],
			Options -> RemoveHiddenOptions[ExperimentExtractRNA, preResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentExtractRNA, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult, $Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps, Upload], False],
		Rest[resourceResult], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		True,
		Module[{primitive, nonHiddenOptions},
			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive = ExtractRNA @@ Join[
				{
					Sample -> Download[ToList[mySamples], Object]
				},
				RemoveHiddenPrimitiveOptions[ExtractRNA, ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions = RemoveHiddenOptions[ExperimentExtractRNA, collapsedResolvedOptions];

			(* Memoize the value of ExperimentExtractRNA so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentExtractRNA, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache = <||>;

				DownValues[ExperimentExtractRNA] = {};

				ExperimentExtractRNA[___, options:OptionsPattern[]] := Module[{frameworkOutputSpecification},
					(* Lookup the output specification the framework is asking for. *)
					frameworkOutputSpecification = Lookup[ToList[options], Output];

					frameworkOutputSpecification /. {
						Result -> Rest[resourceResult],
						Options -> nonHiddenOptions,
						Preview -> Null,
						Simulation -> simulation,
						RunTime -> runTime
					}
				];

				(* Extraction and Harvest experiments can only run via RCP and not RSP. *)
				ExperimentRoboticCellPreparation[
					{primitive},
					Name -> Lookup[safeOps, Name],
					Upload -> Lookup[safeOps, Upload],
					Confirm -> Lookup[safeOps, Confirm],
					CanaryBranch -> Lookup[safeOps, CanaryBranch],
					ParentProtocol -> Lookup[safeOps, ParentProtocol],
					Priority -> Lookup[safeOps, Priority],
					StartDate -> Lookup[safeOps, StartDate],
					HoldOrder -> Lookup[safeOps, HoldOrder],
					QueuePosition -> Lookup[safeOps, QueuePosition],
					Instrument -> Lookup[fullyResolvedOptions, RoboticInstrument],
					Cache -> cacheBall,
					Debug -> False
				]
			]
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentExtractRNA, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> runTime
	}
];

(* ::Subsection::Closed:: *)
(*resolveExtractRNAWorkCell*)

DefineOptions[resolveExtractRNAWorkCell,
	SharedOptions:>{
		ExperimentExtractRNA,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];


resolveExtractRNAWorkCell[
	myContainersAndSamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions:OptionsPattern[]
]:=Module[{safeOps, mySamples, myContainers, sampleCellTypes, roboticInstrumentModel, simulation},

	(* get safeOps *)
	safeOps = SafeOptions[resolveExtractRNAWorkCell, ToList[myOptions]];
	simulation = Lookup[safeOps, Simulation, Null];

	mySamples = Cases[myContainersAndSamples, ObjectP[Object[Sample]], Infinity];
	myContainers = Cases[myContainersAndSamples, ObjectP[Object[Container]], Infinity];

	sampleCellTypes = Download[mySamples, CellType, Simulation -> simulation];

	(* get RoboticInstrument model *)
	roboticInstrumentModel = Switch[Lookup[safeOps, RoboticInstrument],
		(* if we can find a instrument model, set to that *)
		ObjectP[Model[Instrument]],
			Download[Lookup[safeOps, RoboticInstrument], Object],
		(* if we can find a instrument object, download the model of the instrument *)
		ObjectP[Object[Instrument]],
			Download[
				Lookup[safeOps, RoboticInstrument],
				Model[Object],
				Simulation -> Lookup[safeOps, Simulation, Null],
				Cache -> Lookup[safeOps, Cache, {}]
			],
		(* otherwise set to Null *)
		_,
			Null
	];

	(* NOTE: due to the mechanism by which the primitive framework resolves WorkCell, we can't just resolve it on our own and then tell *)
	(* the framework what to use. So, we resolve using the CellType option if specified, or the CellType field in the input sample(s). *)

	Which[
		(*choose user selected workcell if the user selected one *)
		MatchQ[Lookup[safeOps, WorkCell], Except[Automatic]],
			ToList[Lookup[safeOps, WorkCell]],
		(* If the user specifies the microbioSTAR for RoboticInstrument, resolve the WorkCell to match *)
		MatchQ[roboticInstrumentModel, ObjectReferenceP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]]],
			{microbioSTAR},
		(* If the user specifies the bioSTAR for RoboticInstrument, resolve the WorkCell to match *)
		MatchQ[roboticInstrumentModel, ObjectReferenceP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]]],
			{bioSTAR},
		(* If the user specifies any microbial (Bacterial, Yeast, or Fungal) cell types using the CellType option, resolve to microbioSTAR *)
		KeyExistsQ[safeOps, CellType] && MemberQ[Lookup[safeOps, CellType], MicrobialCellTypeP],
			{microbioSTAR},
		(* If the user specifies only nonmicrobial (Mammalian, Insect, or Plant) cell types using the CellType option, resolve to bioSTAR *)
		KeyExistsQ[safeOps, CellType] && MatchQ[Lookup[safeOps, CellType], {(NonMicrobialCellTypeP | Null)..}],
			{bioSTAR},
		(*If CellType field for any input Sample objects is microbial (Bacterial, Yeast, or Fungal), then the microbioSTAR is used. *)
		MemberQ[sampleCellTypes, MicrobialCellTypeP],
			{microbioSTAR},
		(*If CellType field for all input Sample objects is not microbial (Mammalian, Plant, or Insect), then the bioSTAR is used. *)
		MatchQ[sampleCellTypes, {(NonMicrobialCellTypeP | Null)..}],
			{bioSTAR},
		(*Otherwise, use the microbioSTAR.*)
		True,
			{microbioSTAR}
	]
];

(* ::Subsection::Closed:: *)
(*resolveExperimentExtractRNAOptions*)

DefineOptions[
	resolveExperimentExtractRNAOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentExtractRNAOptions[mySamples:{ObjectP[Object[Sample]]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentExtractRNAOptions]] := Module[
	{
		(*Option Setup and Cache Setup*)
		outputSpecification, output, gatherTests, messages, listedOptions, currentSimulation, optionPrecisions, roundedExperimentOptions, containerInstrumentModelFastAssoc,

		(*Precision Tests*)
		optionPrecisionTests, preCorrectionMapThreadFriendlyOptions, mapThreadFriendlyOptionsWithoutSolventAdditions, mapThreadFriendlyOptions, labelPreResolvedMapThreadFriendlyOptions,

		(*Downloads*)
		samplePackets, sampleModelPackets, methodPackets, methodDefaultPackets, methodObjects, cacheBall, fastCacheBall,
		centrifugeModelFields, centrifugeModelPacketFields, pressureManifoldModelFields, pressureManifoldModelPacketFields,
		centrifugeModelPackets, pressureManifoldModelPackets,
		containerInstrumentModelCacheBall,
		containerObjectPacketFields, containerModelFields, containerModelPacketFields, containerObjectFields,
		sampleContainerPackets, sampleContainerModelPackets, containerModelPackets, containerModelFromObjectPackets,

		(*Input Validation*)
		discardedInvalidInputs, discardedTest, deprecatedSamplePackets, deprecatedInvalidInputs, deprecatedTest, solidMediaInvalidInputs, solidMediaTest, invalidInputs,

		(*Option Validation*)
		invalidOptions,

		(*Resolving Options - PreMapThread*)
		allowedWorkCells, resolvedWorkCell, resolvedRoboticInstrument,

		(*Resolving Options - MapThread*)
		(*Method*)
		resolvedMethod,
		resolvedTargetRNA,
		(*Lysing*)
		resolvedLyse, resolvedLysisTime, resolvedLysisTemperature, resolvedLysisAliquot, resolvedClarifyLysateBool, preResolvedLysisAliquotContainer,
		preResolvedLysisAliquotContainerLabel, preResolvedClarifiedLysateContainer, preResolvedClarifiedLysateContainerLabel,
		preResolvedCellType, preResolvedNumberOfLysisSteps, preResolvedPreLysisPellet, preResolvedPreLysisPelletingIntensity,
		preResolvedPreLysisPelletingTime, preResolvedLysisSolution, preResolvedLysisMixType, preResolvedLysisMixRate, preResolvedLysisMixTime,
		preResolvedNumberOfLysisMixes, preResolvedLysisMixTemperature, preResolvedSecondaryLysisSolution, preResolvedSecondaryLysisMixType,
		preResolvedSecondaryLysisMixRate, preResolvedSecondaryLysisMixTime, preResolvedSecondaryNumberOfLysisMixes, preResolvedSecondaryLysisMixTemperature,
		preResolvedSecondaryLysisTime, preResolvedSecondaryLysisTemperature, preResolvedTertiaryLysisSolution, preResolvedTertiaryLysisMixType,
		preResolvedTertiaryLysisMixRate, preResolvedTertiaryLysisMixTime, preResolvedTertiaryNumberOfLysisMixes, preResolvedTertiaryLysisMixTemperature,
		preResolvedTertiaryLysisTime, preResolvedTertiaryLysisTemperature, preResolvedClarifyLysateIntensity, preResolvedClarifyLysateTime,
		(*Homogenization*)
		resolvedHomogenizeLysate, resolvedHomogenizationDevice, resolvedHomogenizationCollectionContainer, resolvedHomogenizationTechnique,
		resolvedHomogenizationInstrument, resolvedHomogenizationCentrifugeIntensity, resolvedHomogenizationPressure, resolvedHomogenizationTime,
		(*Dehydration*)
		resolvedDehydrationSolution, preResolvedDehydrationSolutionVolume, mtdehydrationSolutionVolumeWarning, resolvedDehydrationSolutionMixType, resolvedNumberOfDehydrationSolutionMixes,
		preResolvedDehydrationSolutionMixVolume, resolvedDehydrationSolutionMixRate, resolvedDehydrationSolutionMixTime,
		(*LLE*)
		(*Precipitation*)
		(*SPE*)
		(*MBS*)
		(*Purification*)
		preResolvedPurification,

		(*Post MapThread*)
		workingSamples, containerOutBeforePurification,

		(*Method and TargetRNA*)
		resolvedMethodOptions,

		(*Lysis shared options*)
		preResolvedLysisOptions,

		(*Homogenization resolving via ExperimentFilter*)
		resolvedHomogenizationOptions,

		(*Dehydration options*)
		preResolvedDehydrationOptions,

		(*Resolved purification*)
		resolvedPurification, optionsWithResolvedMethodAndPurification, preCorrectionMapThreadFriendlyOptionsWithResolvedMethodAndPurification,
		mapThreadFriendlyOptionsWithResolvedMethodAndPurification, preResolvedPurificationOptions,

		(*Container Out*)
		userSpecifiedLabels, resolvedExtractedRNALabel, preResolvedContainersOutWithWellsRemoved, preResolvedExtractedRNAContainerLabel, labelPreResolvedRoundedExperimentOptions,
		labelPreResolvedPreCorrectionMapThreadFriendlyOptions, labelPreResolvedMapThreadFriendlyOptionsWithoutSolventAdditions,

		(*Post-resolution*)
		preResolvedOptions, resolvedPostProcessingOptions, email,

		(*Conflicing option checking*)
		mapThreadFriendlyPreResolvedOptionsWithoutSolventAdditions, mapThreadFriendlyPreResolvedOptions,
		methodConflictingOptions, methodConflictingOptionsTest,
		dehydrationSolutionVolumeWarningOptions, dehydrationSolutionVolumeWarningTest,
		methodTargetMismatchedOptions, methodTargetConflictingOptionsTest,
		repeatedLysisOptions, repeatedLysisOptionsTest,
		unlysedCellsOptions, unlysedCellsOptionsTest,
		lysateHomogenizationConflictingOptions, lysateHomogenizationConflictingOptionsTest,
		homogenizationPurificationConflictingOptionSamples, homogenizationPurificationConflictingOptionTest,
		homogenizationTechniqueInstrumentConflictingOptions, homogenizationTechniqueInstrumentConflictingOptionsTest,
		homogenizationCentrifugeIntensityPressureConflictingOptions, homogenizationCentrifugeIntensityPressureConflictingOptionsTest,
		methodValidityTest, invalidExtractionMethodOptions,
		solidPhaseExtractionConflictingOptionsTests, solidPhaseExtractionConflictingOptions,
		mbsMethodsConflictingOptionsTest, mbsMethodsConflictingOptions,
		purificationTests, purificationInvalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	(* Make fast association to look up things from cache quickly.*)
	cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
	fastCacheBall = makeFastAssocFromCache[cacheBall];

	(* ToList our options. *)
	listedOptions = ToList[myOptions];

	(* Lookup our simulation. *)
	currentSimulation = Lookup[ToList[myResolutionOptions], Simulation];

	(*-- RESOLVE PREPARATION OPTION --*)
	(* Usually, we resolve our Preparation option here, but since we can only do Preparation -> Robotic, there is no need to. *)

	(* -- DOWNLOAD -- *)

	(* gather the methods we Downloaded, and the containers, and the contianer models *)
	methodObjects = Replace[Lookup[myOptions,Method], {Custom -> Null}, 2];

	centrifugeModelFields = DeleteDuplicates[Flatten[{Name, MinRotationRate, MaxRotationRate}]];
	centrifugeModelPacketFields = Packet @@ centrifugeModelFields;
	pressureManifoldModelFields = DeleteDuplicates[Flatten[{Name, MinPressure, MaxPressure}]];
	pressureManifoldModelPacketFields = Packet @@ pressureManifoldModelFields;

	samplePackets = fetchPacketFromFastAssoc[#, fastCacheBall]& /@ mySamples;
	sampleModelPackets = fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, #, Model], fastCacheBall]& /@ mySamples;
(*	methodPackets = If[NullQ[#], Null, fetchPacketFromFastAssoc[#, fastCacheBall]]& /@ methodObjects;*)
	sampleContainerPackets = fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, #, Container], fastCacheBall]& /@ mySamples;
	sampleContainerModelPackets = fetchPacketFromFastAssoc[fastAssocLookup[fastCacheBall, #, {Container, Model}], fastCacheBall]& /@ mySamples;
	containerModelFields = {VolumeCalibrations, MaxCentrifugationForce, Footprint, MaxVolume, Positions, Name};
	containerModelPacketFields = Packet@@containerModelFields;
	containerObjectFields = {Contents, Model, Name, MaxVolume};
	containerObjectPacketFields = Packet@@containerObjectFields;

	{
		(*3*)methodPackets,
		(*3B*)methodDefaultPackets,
		(*6*)containerModelPackets,
		(*7*)containerModelFromObjectPackets,
		(*8*)centrifugeModelPackets,
		(*9*)pressureManifoldModelPackets
	} = Quiet[Download[
		{
			(*3*)Replace[Lookup[myOptions, Method], {Except[ObjectP[]] -> Null}, 1],(* in this case, to preserve index matching. otherwise use Cases if index matching is not needed *)
			(*3B*)DeleteDuplicates@Flatten[{
			Cases[
				{
					Flatten[Lookup[myOptions, Method]],
					Object[Method, Extraction, RNA, "id:mnk9jOk70L8N"],(*Object[Method, Extraction, RNA, "Total RNA Extraction from Mammalian Cell Lysate using Solid Phase Extraction and Precipitation"]*)
					Object[Method, Extraction, RNA, "id:BYDOjvDalnkE"],(*Object[Method, Extraction, RNA, "mRNA Extraction from Live Mammalian Cell using Solid Phase Extraction"]*)
					Object[Method, Extraction, RNA, "id:9RdZXvd3DzOJ"](*Object[Method, Extraction, RNA, "miRNA Extraction from Live Mammalian Cell using Solid Phase Extraction"]*)
				},
				ObjectP[Object[Method, Extraction, RNA]]
			]
		}],
			(*6*)DeleteDuplicates@Flatten[{
				Cases[
					Flatten[Lookup[myOptions, {ContainerOut, IndexedContainerOut, HomogenizationDevice}]],
					ObjectP[{Object[Container], Model[Container]}]
				],
				PreferredContainer[All, LiquidHandlerCompatible -> True, Sterile->True, Type -> All],
				PreferredContainer[All, LiquidHandlerCompatible -> True, Type -> All]
			}],
			(*7*)DeleteDuplicates@Cases[
				Flatten[Lookup[myOptions, {ContainerOut, IndexedContainerOut, HomogenizationDevice}]],
				ObjectP[Object[Container]]
			],
			(*8*)DeleteDuplicates@Flatten[{
				Cases[
					{
						Flatten[Lookup[myOptions, HomogenizationInstrument]],
						Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],
						Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],
						Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],
						Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]
					},
					ObjectP[Model[Instrument, Centrifuge]]
				]
			}],
			(*9*)DeleteDuplicates@Flatten[{
				Cases[
					{
						Flatten[Lookup[myOptions, HomogenizationInstrument]],
						Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],
						Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],
						Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],
						Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]
					},
					ObjectP[Model[Instrument, PressureManifold]]
				]
			}]
		},
		{
			(*3*){Packet[All]},
			(*3B*){Packet[All]},
			(*6*){containerModelPacketFields, Packet[VolumeCalibrations[{CalibrationFunction}]]},
			(*7*){containerObjectPacketFields, Packet[Model[containerModelFields]], Packet[Model[VolumeCalibrations][{CalibrationFunction}]]},
			(*8*){centrifugeModelPacketFields},
			(*9*){pressureManifoldModelPacketFields}
		},
		Cache -> cacheBall,
		Simulation -> currentSimulation
	],
	{Download::FieldDoesntExist,Download::NotLinkField}
];

	{
		(*3*)methodPackets,
		(*3B*)methodDefaultPackets,
		(*6*)containerModelPackets,
		(*7*)containerModelFromObjectPackets,
		(*8*)centrifugeModelPackets,
		(*9*)pressureManifoldModelPackets
	} = Flatten /@ {
		(*3*)methodPackets,
		(*3B*)methodDefaultPackets,
		(*6*)containerModelPackets,
		(*7*)containerModelFromObjectPackets,
		(*8*)centrifugeModelPackets,
		(*9*)pressureManifoldModelPackets
	};

	containerInstrumentModelCacheBall = FlattenCachePackets[{
		(*3*)methodPackets,
		(*3B*)methodDefaultPackets,
		(*6*)containerModelPackets,
		(*7*)containerModelFromObjectPackets,
		(*8*)centrifugeModelPackets,
		(*9*)pressureManifoldModelPackets
	}];

	containerInstrumentModelFastAssoc = makeFastAssocFromCache[containerInstrumentModelCacheBall];

	(*-- INPUT VALIDATION CHECKS --*)

	(*-- DISCARDED SAMPLE CHECK --*)

	{discardedInvalidInputs, discardedTest} = checkDiscardedSamples[samplePackets, messages, Cache -> cacheBall];

	(* -- DEPRECATED MODEL CHECK -- *)

	(* Get the samples from samplePackets that are deprecated. *)
	deprecatedSamplePackets = Select[Flatten[sampleModelPackets], If[MatchQ[#, Except[Null]], MatchQ[Lookup[#, Deprecated], True]]&];

	(* Set deprecatedInvalidInputs to the input objects whose statuses are Discarded *)
	deprecatedInvalidInputs = Lookup[deprecatedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedInvalidInputs] > 0 && messages,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["The input samples "<>ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall]<>" do not have deprecated models:", True, False]
			];
			passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cacheBall]<>" do not have deprecated models:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- SOLID MEDIA CHECK -- *)

	{solidMediaInvalidInputs, solidMediaTest} = checkSolidMedia[samplePackets, messages, Cache -> cacheBall];

	(*-- OPTION PRECISION CHECKS --*)

	(* Define the option precisions that need to be checked. *)
	optionPrecisions = Sequence@@@{
		(*shared option precisions*)
		$CellLysisOptionsPrecisions,
		$ExtractionLiquidLiquidSharedOptionsPrecisions,
		$PrecipitationSharedOptionsPrecisions,
		$ExtractionSolidPhaseSharedOptionsPrecisions,
		$ExtractionMagneticBeadSharedOptionsPrecisions,
		(*ExtractRNA option precisions*)
		{
			{HomogenizationCentrifugeIntensity, 1 GravitationalAcceleration},
			{HomogenizationPressure, 1 PSI},
			{HomogenizationTime, 1 Second},
			{DehydrationSolutionVolume, 10^-1 Microliter},
			{DehydrationSolutionMixVolume, 10^-1 Microliter},
			{DehydrationSolutionMixRate, 1 RPM},
			{DehydrationSolutionMixTime, 1 Second}
		}
	};

	{roundedExperimentOptions, optionPrecisionTests} = If[gatherTests,
		(*If we are gathering tests *)
		RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
		(* Otherwise *)
		{RoundOptionPrecision[Association @@ listedOptions, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
	];

	(* Convert our options into a MapThread friendly version. *)
	preCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, roundedExperimentOptions];

	mapThreadFriendlyOptionsWithoutSolventAdditions = Experiment`Private`makePurificationMapThreadFriendly[mySamples, roundedExperimentOptions, preCorrectionMapThreadFriendlyOptions];

	(* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
	(* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
	mapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[roundedExperimentOptions, mapThreadFriendlyOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];

	(* -- RESOLVE NON-MAPTHREAD, NON-CONTAINER OPTIONS -- *)

	(* Resolve WorkCell *)
	allowedWorkCells = resolveExtractRNAWorkCell[mySamples, listedOptions];

	resolvedWorkCell = First[allowedWorkCells, microbioSTAR];

	(* Resolve RoboticInstrument *)
	resolvedRoboticInstrument = Which[
		(*If user-set, then use set value.*)
		MatchQ[Lookup[myOptions, RoboticInstrument], Except[Automatic]],
			Lookup[myOptions, RoboticInstrument],
		(*If resolvedWorkCell is set to bioSTAR, use bioSTAR*)
		MatchQ[resolvedWorkCell, bioSTAR],
			Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],(* Model[Instrument, LiquidHandler, "bioSTAR"] *)
		(*If resolvedWorkCell is set to microbioSTAR, use microbioSTAR*)
		MatchQ[resolvedWorkCell, microbioSTAR],
			Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],(* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
		(*If CellType option for all Samples is not microbial (Mammalian, Plant, or Insect) (set or from the field in their sample object), then the bioSTAR is used.*)
		Or[MatchQ[Lookup[myOptions, CellType], {NonMicrobialCellTypeP..}], MatchQ[Lookup[samplePackets, CellType], {NonMicrobialCellTypeP..}]],
			Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"],(* Model[Instrument, LiquidHandler, "bioSTAR"] *)
		(*Otherwise, use the microbioSTAR.*)
		True,
			Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"](* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
	];

	(* -- RESOLVE SAMPLE OUT AND CONTAINER OUT LABELS -- *)

	(* Get our user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			listedOptions,
			{
				ExtractedRNALabel, ExtractedRNAContainerLabel,
				PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel, LysisAliquotContainerLabel, ClarifiedLysateContainerLabel, SampleOutLabel,
				ImpurityLayerLabel, ImpurityLayerContainerLabel,
				PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel,
				MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel,
				MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel,
				MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel,
				MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel
			}
		],
		_String
	];

	(* Resolve the output label and container output label. *)
	resolvedExtractedRNALabel=MapThread[
		Function[{sample, options},
			Which[
				(* If specified by user, then use that value. *)
				MatchQ[Lookup[options, ExtractedRNALabel], Except[Automatic]],
					Lookup[options, ExtractedRNALabel],
				(* If the sample has a label from an upstream unit operation, then use that. *)
				MatchQ[LookupObjectLabel[currentSimulation, Download[sample, Object]], _String],
					LookupObjectLabel[currentSimulation, Download[sample, Object]],
				(* If the sample does not already have a label and one is not specified by the user, then set to the default. *)
				True,
					CreateUniqueLabel["extracted RNA sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels]
			]
		],
		{mySamples, mapThreadFriendlyOptions}
	];


	(* Remove any wells from user-specified container out inputs according to their widget patterns. *)
	preResolvedContainersOutWithWellsRemoved = Map[
		Which[
			(* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
			MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container], Model[Container]}]}],
				Last[#],
			(* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
			MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container], Model[Container]}]}}],
				Last[#],
			(* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
			True,
				#
		]&,
		Lookup[roundedExperimentOptions, ContainerOut]
	];

	(* Resolve the container labels based on the information that we have prior to simulation. *)
	preResolvedExtractedRNAContainerLabel = Module[{sampleContainersToGroupedLabels, sampleContainersToUserSpecifiedLabels},

		(* Make association of containers to their label(s). *)
		(* This is in the format <|object1 -> {label1, label1}, object2 -> {label2, label2, Null}|> *)
		sampleContainersToGroupedLabels = GroupBy[
			Rule@@@Transpose[{preResolvedContainersOutWithWellsRemoved, Lookup[roundedExperimentOptions, ExtractedRNAContainerLabel]}],
			First -> Last
		];

		sampleContainersToUserSpecifiedLabels=(#[[1]]->FirstCase[#[[2]], _String, Null]&)/@Normal[sampleContainersToGroupedLabels];

		MapThread[
			Function[{container, userSpecifiedLabel},
				Which[
					(* User specified the option. *)
					MatchQ[userSpecifiedLabel, _String],
						userSpecifiedLabel,
					(* All Model[Container]s are unique and recieve unique labels. *)
					MatchQ[container, ObjectP[Model[Container]]],
						CreateUniqueLabel["extracted RNA sample container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels],
					(* User specified the option for another index that this container shows up. *)
					MatchQ[Lookup[sampleContainersToUserSpecifiedLabels, Key[container]], _String],
						Lookup[sampleContainersToUserSpecifiedLabels, Key[container]],
					(* The user has labeled this container upstream in another unit operation. *)
					MatchQ[container, ObjectP[Object[Container]]] && MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[container, Object]], _String],
						LookupObjectLabel[currentSimulation, Download[container, Object]],
					(* If a container is specified, make a new label for this container and add it to the container-to-label association. *)
					MatchQ[container, Except[Automatic]],
						Module[{},
							sampleContainersToUserSpecifiedLabels=ReplaceRule[
								sampleContainersToUserSpecifiedLabels,
								container->CreateUniqueLabel["extracted RNA sample container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
							];

							Lookup[sampleContainersToUserSpecifiedLabels, Key[container]]
						],
					(* Otherwise, make a new label to be assigned to the container that is resolved in RCP. *)
					True,
						CreateUniqueLabel["extracted RNA sample container", Simulation->currentSimulation, UserSpecifiedLabels->userSpecifiedLabels]
				]
			],
			{preResolvedContainersOutWithWellsRemoved, Lookup[listedOptions, ExtractedRNAContainerLabel]}
		]
	];

	(* Add in pre-resolved labels into options and make mapThreadFriendly for further resolutions. *)
	labelPreResolvedRoundedExperimentOptions = Merge[
		{
			roundedExperimentOptions,
			<|
				ExtractedRNALabel -> resolvedExtractedRNALabel,
				ExtractedRNAContainerLabel -> preResolvedExtractedRNAContainerLabel,
				WorkCell -> resolvedWorkCell,
				RoboticInstrument -> resolvedRoboticInstrument
			|>
		},
		Last
	];

	(* Convert our options into a MapThread friendly version. *)
	labelPreResolvedPreCorrectionMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA,labelPreResolvedRoundedExperimentOptions];

	labelPreResolvedMapThreadFriendlyOptionsWithoutSolventAdditions = Experiment`Private`makePurificationMapThreadFriendly[mySamples, labelPreResolvedRoundedExperimentOptions, labelPreResolvedPreCorrectionMapThreadFriendlyOptions];

	(* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
	(* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
	labelPreResolvedMapThreadFriendlyOptions = Experiment`Private`mapThreadFriendlySolventAdditions[labelPreResolvedRoundedExperimentOptions, labelPreResolvedMapThreadFriendlyOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];


	(* -- RESOLVE MAPTHREAD OPTIONS -- *)

	{
		(*Method*)
		resolvedMethod,
		resolvedTargetRNA,
		(*Lyse*)
		(*the following Lyse options are resolved/pre-resolved here, then remaining lyse options are resolved using the resolveSharedOptions function after the MapThread*)
		resolvedLyse,
		resolvedLysisTime,
		resolvedLysisTemperature,
		resolvedLysisAliquot,
		resolvedClarifyLysateBool,
		preResolvedCellType,
		preResolvedNumberOfLysisSteps,
		preResolvedPreLysisPellet,
		preResolvedPreLysisPelletingIntensity,
		preResolvedPreLysisPelletingTime,
		preResolvedLysisSolution,
		preResolvedLysisMixType,
		preResolvedLysisMixRate,
		preResolvedLysisMixTime,
		preResolvedNumberOfLysisMixes,
		preResolvedLysisMixTemperature,
		preResolvedSecondaryLysisSolution,
		preResolvedSecondaryLysisMixType,
		preResolvedSecondaryLysisMixRate,
		preResolvedSecondaryLysisMixTime,
		preResolvedSecondaryNumberOfLysisMixes,
		preResolvedSecondaryLysisMixTemperature,
		preResolvedSecondaryLysisTime,
		preResolvedSecondaryLysisTemperature,
		preResolvedTertiaryLysisSolution,
		preResolvedTertiaryLysisMixType,
		preResolvedTertiaryLysisMixRate,
		preResolvedTertiaryLysisMixTime,
		preResolvedTertiaryNumberOfLysisMixes,
		preResolvedTertiaryLysisMixTemperature,
		preResolvedTertiaryLysisTime,
		preResolvedTertiaryLysisTemperature,
		preResolvedClarifyLysateIntensity,
		preResolvedClarifyLysateTime,
		preResolvedLysisAliquotContainer,
		preResolvedLysisAliquotContainerLabel,
		preResolvedClarifiedLysateContainer,
		preResolvedClarifiedLysateContainerLabel,
		(*Homogenization*)
		resolvedHomogenizeLysate,
		resolvedHomogenizationDevice,
		resolvedHomogenizationCollectionContainer,
		resolvedHomogenizationTechnique,
		resolvedHomogenizationInstrument,
		resolvedHomogenizationCentrifugeIntensity,
		resolvedHomogenizationPressure,
		resolvedHomogenizationTime,
		(*Dehydration*)
		resolvedDehydrationSolution,
		preResolvedDehydrationSolutionVolume,
		mtdehydrationSolutionVolumeWarning,
		resolvedDehydrationSolutionMixType,
		resolvedNumberOfDehydrationSolutionMixes,
		preResolvedDehydrationSolutionMixVolume,
		resolvedDehydrationSolutionMixRate,
		resolvedDehydrationSolutionMixTime,
		(*LLE*)
		(*Precipitation*)
		(*SPE*)
		(*MBS*)
		(*Purification*)
		preResolvedPurification
	} = Transpose@MapThread[
		Function[{samplePacket, sampleContainerPacket, methodPacket, options},
			Module[
				{
					sampleVolume, startingSampleContainer, startingSampleContainerVolume,
					(*Method*)
					method, methodSpecifiedQ, assignedMethodPacket, useMapThreadMethodQ, useAssignedMethodQ,
					targetRNA,
					(*Lyse*)
					lyse, lysisTime, lysisTemperature, lysisAliquot, clarifyLysateBool, lysisAliquotContainer, lysisAliquotContainerLabel, clarifiedLysateContainer, clarifiedLysateContainerLabel,
					cellType, numberOfLysisSteps, preLysisPellet, preLysisPelletingIntensity,
					preLysisPelletingTime, lysisSolution, lysisMixType, lysisMixRate, lysisMixTime,
					numberOfLysisMixes, lysisMixTemperature, secondaryLysisSolution, secondaryLysisMixType,
					secondaryLysisMixRate, secondaryLysisMixTime, secondaryNumberOfLysisMixes, secondaryLysisMixTemperature,
					secondaryLysisTime, secondaryLysisTemperature, tertiaryLysisSolution, tertiaryLysisMixType,
					tertiaryLysisMixRate, tertiaryLysisMixTime, tertiaryNumberOfLysisMixes, tertiaryLysisMixTemperature,
					tertiaryLysisTime, tertiaryLysisTemperature, clarifyLysateIntensity, clarifyLysateTime,
					(*Homogenization*)
					homogenizeLysate, homogenizationDevice, homogenizationCollectionContainer, homogenizationCollectionContainerVolume, homogenizationTechnique, homogenizationInstrument, homogenizationCentrifugeIntensity, homogenizationPressure, homogenizationTime,
					(*Dehydration*)
					dehydrationSolution, dehydrationBool, dehydrationSolutionVolume, dehydrationSolutionVolumeWarning, dehydrationSolutionMixType, numberOfDehydrationSolutionMixes, dehydrationSolutionMixVolume, dehydrationSolutionMixRate, dehydrationSolutionMixTime,
					(*LLE*)
					(*Precipitation*)
					(*SPE*)
					(*MBS*)
					(*Purification*)
					purification
				},

				(* Get the sample volume coming in *)
				sampleVolume = Which[
					MatchQ[Lookup[samplePacket, Volume], VolumeP],
						RoundOptionPrecision[Lookup[samplePacket, Volume], 1 Microliter],
					MatchQ[Lookup[samplePacket, InitialAmount], VolumeP],
						RoundOptionPrecision[Lookup[samplePacket, InitialAmount], 1 Microliter],
					True,
						Null
				];

				(* Get the sample container coming in *)
				startingSampleContainer = Which[
					MatchQ[Lookup[samplePacket, Container], ObjectP[{Object[Container], Model[Container]}]],
						Lookup[samplePacket, Container],
					MatchQ[Lookup[sampleContainerPacket, Object], ObjectP[{Object[Container], Model[Container]}]],
						Lookup[sampleContainerPacket, Object],
					True,
						Null
				];

				(* Get the max volume of the sample container coming in *)
				startingSampleContainerVolume = If[
					MatchQ[Lookup[sampleContainerPacket, MaxVolume], VolumeP],
					Lookup[sampleContainerPacket, MaxVolume],
					Null
				];

				(* --- METHOD OPTION RESOLUTION --- *)
				(* Resolve Method *)
				method = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, Method], Except[Automatic]],
						Lookup[options, Method],
					(*If TargetRNA is specified by the user, set method to match the user-specified TargetRNA*)
					MatchQ[Lookup[options, TargetRNA], Except[Automatic]],
						Switch[
							Lookup[options, TargetRNA],
							TotalRNA, Object[Method, Extraction, RNA, "id:mnk9jOk70L8N"],(*Object[Method, Extraction, RNA, "Total RNA Extraction from Mammalian Cell Lysate using Solid Phase Extraction and Precipitation"]*)
							mRNA, Object[Method, Extraction, RNA, "id:BYDOjvDalnkE"],(*Object[Method, Extraction, RNA, "mRNA Extraction from Live Mammalian Cell using Solid Phase Extraction"]*)
							miRNA, Object[Method, Extraction, RNA, "id:9RdZXvd3DzOJ"],(*Object[Method, Extraction, RNA, "miRNA Extraction from Live Mammalian Cell using Solid Phase Extraction 3"]*)
							(*TODO :: update method object types when they are done*)
							tRNA, Custom(*Object[Method, Extraction, RNA(*, "tRNA method"*)]*),
							rRNA, Custom(*Object[Method, Extraction, RNA(*, "rRNA method"*)]*),
							ViralRNA, Custom(*Object[Method, Extraction, RNA(*, "ViralRNA method"*)]*),
							ExosomalRNA, Custom(*Object[Method, Extraction, RNA(*, "ExosomalRNA method"*)]*),
							CellFreeRNA, Custom(*Object[Method, Extraction, RNA(*, "CellFreeRNA method"*)]*),
							_, Custom
						],
					True,
						Custom
				];

				(* Setup a boolean to determine if there is a method set or not. *)
				methodSpecifiedQ = MatchQ[method, ObjectP[Object[Method, Extraction, RNA]]];

				(* Setup a boolean to indicate if the method is user-specified - ie we will use the methodPacket variable that we are Mapping through *)
				useMapThreadMethodQ = MatchQ[Lookup[options, Method], Except[Automatic]];

				(*if the method was assigned inside the MapThread based on user-specified TargetRNA, then fetch the packet from the downloaded default methods in the containerInstrumentModelFastAssoc*)
				{assignedMethodPacket, useAssignedMethodQ} = If[
					And[
						!MatchQ[Lookup[options, Method], Except[Automatic]],
						MatchQ[method, ObjectP[Object[Method, Extraction, RNA]]]
					],
					{
						fetchPacketFromFastAssoc[method, containerInstrumentModelFastAssoc],
						True
					},
					{
						<||>,
						False
					}
				];

				(* resolve TargetRNA *)
				targetRNA = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, TargetRNA], Except[Automatic]],
						Lookup[options, TargetRNA],
					(*If a method is specified and TargetRNA is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TargetRNA], Except[Null]],
						Lookup[methodPacket, TargetRNA],
					(*If a method is set by the TargetRNA and TargetRNA is specified by the method (this is weird and circular..), set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TargetRNA], Except[Null]],
						Lookup[assignedMethodPacket, TargetRNA],
					(*If not specified by the user or the method, set to Unspecified*)
					True,
						Unspecified
				];

				(* --- MASTER SWITCH OPTIONS --- *)

				lyse = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, Lyse], Except[Automatic]],
						Lookup[options, Lyse],
					(*If a method is specified and Lyse is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, Lyse], Except[Null]],
						Lookup[methodPacket, Lyse],
					(*If a method is set by the TargetRNA and Lyse is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, Lyse], Except[Null]],
						Lookup[assignedMethodPacket, Lyse],
					(*If any Lysis options are specified by the user, set Lyse to True. Dropping TargetCellularComponent and NumberOfLysisReplicates from the list since they arent options in ExtractRNA*)
					MemberQ[Lookup[options, ToExpression[Keys[KeyDrop[Options[CellLysisOptions], {Key["TargetCellularComponent"], Key["NumberOfLysisReplicates"]}]]]], Except[Automatic | Null]],
						True,
					(*If the Living field in the sample is True, set Lyse to True*)
					MatchQ[Lookup[samplePacket, Living], True],
						True,
					(*Otherwise set Lyse to False*)
					True,
						False
				];

				(* even though homgenization and dehydration solution come before Purification in the experiment, need to resolve purification first *)
				purification = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, Purification], Except[Automatic]],
						Lookup[options, Purification],
					(*If a method is specified and Purification is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, Purification], Except[Null]],
						Lookup[methodPacket, Purification],
					(*If a method is set by the TargetRNA and Purification is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, Purification], Except[Null]],
						Lookup[assignedMethodPacket, Purification],
					(* If no LLE, Precipitation, SPE, or MBS options are set, the default Purification is LLE followed by Precipitation. *)
					!Or @@ (MemberQ[
						ToList[Lookup[options, #, Null]],
						Except[Automatic | Null | False | {Automatic, Automatic}]
					]&) /@ Keys[Join[$LLEPurificationOptionMap, $PrecipitationSharedOptionMap, $SPEPurificationOptionMap, $MBSPurificationOptionMap]],
						{LiquidLiquidExtraction, Precipitation},
					(* Otherwise, check to see which purification options are set *)
					True,
						{
							(* Are any of the LLE options set? *)
							Module[{lleSpecifiedQ},
								lleSpecifiedQ = Or @@ (MemberQ[
									ToList[Lookup[options, #, Null]],
									Except[Automatic | Null | False | {Automatic, Automatic}]
								]&) /@ Keys[$LLEPurificationOptionMap];

								If[lleSpecifiedQ,
									LiquidLiquidExtraction,
									Nothing
								]
							],
							(* Are any of the Precipitation options set? *)
							Module[{precipitationSpecifiedQ},
								precipitationSpecifiedQ = Or @@ (MemberQ[
									ToList[Lookup[options, #, Null]],
									Except[Automatic | Null | False | {Automatic, Automatic}]
								]&) /@ Keys[$PrecipitationSharedOptionMap];

								If[precipitationSpecifiedQ,
									Precipitation,
									Nothing
								]
							],
							(* Are any of the SPE options set? *)
							Module[{speSpecifiedQ},
								speSpecifiedQ = Or @@ (MemberQ[
									ToList[Lookup[options, #, Null]],
									Except[Automatic | Null | False | {Automatic, Automatic}]
								]&) /@ Keys[$SPEPurificationOptionMap];

								If[speSpecifiedQ,
									SolidPhaseExtraction,
									Nothing
								]
							],
							(* Are any of the MBS options set? *)
							Module[{mbsSpecifiedQ},
								mbsSpecifiedQ = Or @@ (MemberQ[
									ToList[Lookup[options, #, Null]],
									Except[Automatic | Null | False | {Automatic, Automatic}]
								]&) /@ Keys[$MBSPurificationOptionMap];

								If[mbsSpecifiedQ,
									MagneticBeadSeparation,
									Nothing
								]
							]
						}
				];

				homogenizeLysate = Which[
					(*If specified by the user, set to user-specified value*)
					BooleanQ[Lookup[options, HomogenizeLysate]],
						Lookup[options, HomogenizeLysate],
					(*If a method is specified and HomogenizeLysate is specified by the method, set to method-specified values*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, HomogenizeLysate], Except[Null]],
						Lookup[methodPacket, HomogenizeLysate],
					(*If a method is set by the TargetRNA and HomogenizeLysate is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, HomogenizeLysate], Except[Null]],
						Lookup[assignedMethodPacket, HomogenizeLysate],
					(*If any homogenization options are specified by the user, set homogenizeLysate to True*)
					MemberQ[
						Map[
							MatchQ[Lookup[options,#],Except[Null|Automatic]]&,
							{HomogenizationDevice,HomogenizationTechnique,HomogenizationInstrument,HomogenizationCentrifugeIntensity,HomogenizationPressure,HomogenizationTime}
						],
						True
					],
						True,
					(*If the sample contains living cell or a cell lysate, and the first Purification step is set to SPE, set homogenizeLysate to True*)
					And[
						Or[
							MatchQ[Lookup[samplePacket, Living], True],
							MatchQ[Lookup[samplePacket, Composition][[All, 2]][Object], {ObjectP[Model[Lysate]]}]
						],
						MatchQ[purification, (SolidPhaseExtraction | {SolidPhaseExtraction, ___})]
					],
						True,
					(*Otherwise set homogenizeLysate to False*)
					True,
						False
				];

				dehydrationSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, DehydrationSolution], Except[Automatic]],
						Lookup[options, DehydrationSolution],
					(*If a method is specified and DehydrationSolution is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, DehydrationSolution], Except[Null]],
						Lookup[methodPacket, DehydrationSolution],
					(*If a method is set by the TargetRNA and DehydrationSolution is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, DehydrationSolution], Except[Null]],
						Lookup[assignedMethodPacket, DehydrationSolution],
					(*If the first Purification step is set to either SPE or MBS, set to a default solution*)
					MatchQ[purification, (SolidPhaseExtraction | {SolidPhaseExtraction, ___})],
						Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					(*If any dehydration options are specified by the user, set dehydrationSolution to a default solution*)
					MemberQ[
						Map[
							MatchQ[Lookup[options, #], Except[Null|Automatic]]&,
							{DehydrationSolutionVolume, DehydrationSolutionMixType, NumberOfDehydrationSolutionMixes, DehydrationSolutionMixVolume, DehydrationSolutionMixRate, DehydrationSolutionMixTime}
						],
						True
					],
						Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					(*Otherwise set to Null*)
					True,
						Null
				];

				dehydrationBool = MatchQ[dehydrationSolution, ObjectP[{Object[Sample], Model[Sample]}]];

				(* --- LYSE OPTIONS RESOLUTIONS --- *)

				(*resolving LysisTime before calling the LyseCells resolver, bc LyseCells resolver has a default instead of Automatic, so we resolve here first and send it into resolveSharedOptions with the pre-resolved value*)
				lysisTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, LysisTime],Except[Automatic]],
						Lookup[options, LysisTime],
					(*If a method is specified and LysisTime is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisTime], Except[Null]],
						Lookup[methodPacket, LysisTime],
					(*If a method is set by the TargetRNA and LysisTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisTime], Except[Null]],
						Lookup[assignedMethodPacket, LysisTime],
					(*If the sample will not be lysed, then LysisTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(*If the sample will be lysed and LysisTime is Automatic, then is set to the default.*)
					True,
						15 Minute
				];

				(*resolving LysisTemperature before calling the LyseCells resolver, bc LyseCells resolver has a default instead of Automatic, so we resolve here first and send it into resolveSharedOptions with the pre-resolved value*)
				lysisTemperature = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, LysisTemperature],Except[Automatic]],
						Lookup[options, LysisTemperature],
					(*If a method is specified and LysisTemperature is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisTemperature], Except[Null]],
						Lookup[methodPacket, LysisTemperature],
					(*If a method is set by the TargetRNA and LysisTemperature is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisTemperature], Except[Null]],
						Lookup[assignedMethodPacket, LysisTemperature],
					(*If the sample will not be lysed, then LysisTemperature is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(*If the sample will be lysed and LysisTemperature is Automatic, then is set to the default.*)
					True,
						Ambient
				];

				(* Resolve LysisAliquot switch. *)
				lysisAliquot = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options, LysisAliquot], BooleanP],
						Lookup[options, LysisAliquot],
					(*If the sample will not be lysed, then LysisAliquot is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Set LysisAliquot to True if any of LysisAliquotAmount, LysisAliquotContainer, TargetCellCount or TargetCellConcentration are specified *)
					MemberQ[Lookup[options,{LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, TargetCellConcentration}], Except[Null|Automatic]],
						True,
					(* Otherwise, set to False *)
					True,
						False
				];

				clarifyLysateBool = Which[
					(* Use the user-specified values, if any *)
					MatchQ[Lookup[options, ClarifyLysate], BooleanP],
						Lookup[options, ClarifyLysate],
					(*If a method is specified and ClarifyLysate is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, ClarifyLysate], Except[Null]],
						Lookup[methodPacket, ClarifyLysate],
					(*If a method is set by the TargetRNA and ClarifyLysate is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, ClarifyLysate], Except[Null]],
						Lookup[assignedMethodPacket, ClarifyLysate],
					(*If the sample will not be lysed, then ClarifyLysate is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Set to True if any of the dependent options are set *)
					MemberQ[Lookup[options, {ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, PostClarificationPelletStorageCondition}], Except[Null|Automatic]],
						True,
					(* Otherwise, this is False *)
					True,
						False
				];

				lysisAliquotContainer = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, LysisAliquotContainer], Except[Automatic]],
						Lookup[options, LysisAliquotContainer],
					(*not a field in Method so no need to check Method*)
					(*If the sample will not be lysed, then LysisAliquotContainer is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(*If the sample will be lysed and nothing else (no homogenization, dehydration, or purification steps) and the sample will be aliquotted but not clarified during LyseCells, then set to the ContainerOut specified in the options*)
					MatchQ[lyse, True] && MatchQ[{homogenizeLysate, dehydrationSolution, purification}, {False|Null, Null, None|Null}] && MatchQ[{lysisAliquot, clarifyLysateBool}, {True, False}],
						Lookup[options, ContainerOut],
					(*Otherwise, should be resolved by ExperimentLyseCells.*)
					True,
						Automatic
				];

				lysisAliquotContainerLabel = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, LysisAliquotContainerLabel], Except[Automatic]],
						Lookup[options, LysisAliquotContainerLabel],
					(*not a field in Method so no need to check Method*)
					(*If the sample will not be lysed, then LysisAliquotContainerLabel is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(*If the sample will be lysed and nothing else (no homogenization, dehydration, or purification steps) and the sample will be aliquotted but not clarified during LyseCells, then set to the ContainerOut specified in the options*)
					MatchQ[lyse, True] && MatchQ[{homogenizeLysate, dehydrationSolution, purification}, {False|Null, Null, None|Null}] && MatchQ[{lysisAliquot, clarifyLysateBool}, {True, False}],
						Lookup[options, ExtractedRNAContainerLabel],
					(*Otherwise, should be resolved by ExperimentLyseCells.*)
					True,
						Automatic
				];

				cellType = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, CellType], Except[Automatic]],
						Lookup[options, CellType],
					(*Sets CellType to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, CellType, Null], Except[Null]],
						Lookup[methodPacket, CellType],
					(*If a method is set by the TargetRNA and CellType is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, CellType], Except[Null]],
						Lookup[assignedMethodPacket, CellType],
					(*If the sample will not be lysed, then CellType is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				numberOfLysisSteps = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, NumberOfLysisSteps], Except[Automatic]],
						Lookup[options, NumberOfLysisSteps],
					(*Sets NumberOfLysisSteps to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, NumberOfLysisSteps, Null], Except[Null]],
						Lookup[methodPacket, NumberOfLysisSteps],
					(*If a method is set by the TargetRNA and NumberOfLysisSteps is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, NumberOfLysisSteps], Except[Null]],
						Lookup[assignedMethodPacket, NumberOfLysisSteps],
					(*If the sample will not be lysed, then NumberOfLysisSteps is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				preLysisPellet = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, PreLysisPellet], Except[Automatic]],
						Lookup[options, PreLysisPellet],
					(*Sets PreLysisPellet to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, PreLysisPellet, Null], Except[Null]],
						Lookup[methodPacket, PreLysisPellet],
					(*If a method is set by the TargetRNA and PreLysisPellet is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, PreLysisPellet], Except[Null]],
						Lookup[assignedMethodPacket, PreLysisPellet],
					(*If the sample will not be lysed, then PreLysisPellet is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				preLysisPelletingIntensity = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, PreLysisPelletingIntensity], Except[Automatic]],
						Lookup[options, PreLysisPelletingIntensity],
					(*Sets PreLysisPelletingIntensity to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, PreLysisPelletingIntensity, Null], Except[Null]],
						Lookup[methodPacket, PreLysisPelletingIntensity],
					(*If a method is set by the TargetRNA and PreLysisPelletingIntensity is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, PreLysisPelletingIntensity], Except[Null]],
						Lookup[assignedMethodPacket, PreLysisPelletingIntensity],
					(*If the sample will not be lysed, then PreLysisPelletingIntensity is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				preLysisPelletingTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, PreLysisPelletingTime], Except[Automatic]],
						Lookup[options, PreLysisPelletingTime],
					(*Sets PreLysisPelletingTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, PreLysisPelletingTime, Null], Except[Null]],
						Lookup[methodPacket, PreLysisPelletingTime],
					(*If a method is set by the TargetRNA and PreLysisPelletingTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, PreLysisPelletingTime], Except[Null]],
						Lookup[assignedMethodPacket, PreLysisPelletingTime],
					(*If the sample will not be lysed, then PreLysisPelletingTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				lysisSolution = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, LysisSolution], Except[Automatic]],
						Lookup[options, LysisSolution],
					(*Sets SecondaryLysisSolution to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisSolution, Null], Except[Null]],
						Lookup[methodPacket, LysisSolution],
					(*If a method is set by the TargetRNA and LysisSolution is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisSolution], Except[Null]],
						Lookup[assignedMethodPacket, LysisSolution],
					(*If the sample will not be lysed, then SecondaryLysisSolution is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				lysisMixType = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, LysisMixType], Except[Automatic]],
						Lookup[options, LysisMixType],
					(*Sets LysisMixType to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisMixType, Null], Except[Null]],
						Lookup[methodPacket, LysisMixType],
					(*If a method is set by the TargetRNA and LysisMixType is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisMixType], Except[Null]],
						Lookup[assignedMethodPacket, LysisMixType],
					(*If the sample will not be lysed, then LysisMixType is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				lysisMixRate = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, LysisMixRate], Except[Automatic]],
						Lookup[options, LysisMixRate],
					(*Sets LysisMixRate to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisMixRate, Null], Except[Null]],
						Lookup[methodPacket, LysisMixRate],
					(*If a method is set by the TargetRNA and LysisMixRate is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisMixRate], Except[Null]],
						Lookup[assignedMethodPacket, LysisMixRate],
					(*If the sample will not be lysed, then LysisMixRate is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				lysisMixTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, LysisMixTime], Except[Automatic]],
						Lookup[options, LysisMixTime],
					(*Sets LysisMixTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisMixTime, Null], Except[Null]],
						Lookup[methodPacket, LysisMixTime],
					(*If a method is set by the TargetRNA and LysisMixTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisMixTime], Except[Null]],
						Lookup[assignedMethodPacket, LysisMixTime],
					(*If the sample will not be lysed, then LysisMixTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				numberOfLysisMixes = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, NumberOfLysisMixes], Except[Automatic]],
						Lookup[options, NumberOfLysisMixes],
					(*Sets NumberOfLysisMixes to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, NumberOfLysisMixes, Null], Except[Null]],
						Lookup[methodPacket, NumberOfLysisMixes],
					(*If a method is set by the TargetRNA and NumberOfLysisMixes is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, NumberOfLysisMixes], Except[Null]],
						Lookup[assignedMethodPacket, NumberOfLysisMixes],
					(*If the sample will not be lysed, then NumberOfLysisMixes is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				lysisMixTemperature = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, LysisMixTemperature], Except[Automatic]],
						Lookup[options, LysisMixTemperature],
					(*Sets LysisMixTemperature to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, LysisMixTemperature, Null], Except[Null]],
						Lookup[methodPacket, LysisMixTemperature],
					(*If a method is set by the TargetRNA and LysisMixTemperature is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, LysisMixTemperature], Except[Null]],
						Lookup[assignedMethodPacket, LysisMixTemperature],
					(*If the sample will not be lysed, then LysisMixTemperature is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisSolution = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisSolution], Except[Automatic]],
						Lookup[options, SecondaryLysisSolution],
					(*Sets SecondaryLysisSolution to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisSolution, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisSolution],
					(*If a method is set by the TargetRNA and SecondaryLysisSolution is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisSolution], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisSolution],
					(*If the sample will not be lysed, then SecondaryLysisSolution is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisMixType = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisMixType], Except[Automatic]],
						Lookup[options, SecondaryLysisMixType],
					(*Sets SecondaryLysisMixType to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixType, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisMixType],
					(*If a method is set by the TargetRNA and SecondaryLysisMixType is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisMixType], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisMixType],
					(*If the sample will not be lysed, then SecondaryLysisMixType is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisMixRate = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisMixRate], Except[Automatic]],
						Lookup[options, SecondaryLysisMixRate],
					(*Sets SecondaryLysisMixRate to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixRate, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisMixRate],
					(*If a method is set by the TargetRNA and SecondaryLysisMixRate is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisMixRate], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisMixRate],
					(*If the sample will not be lysed, then SecondaryLysisMixRate is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisMixTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisMixTime], Except[Automatic]],
						Lookup[options, SecondaryLysisMixTime],
					(*Sets SecondaryLysisMixTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixTime, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisMixTime],
					(*If a method is set by the TargetRNA and SecondaryLysisMixTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisMixTime], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisMixTime],
					(*If the sample will not be lysed, then SecondaryLysisMixTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryNumberOfLysisMixes = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryNumberOfLysisMixes], Except[Automatic]],
						Lookup[options, SecondaryNumberOfLysisMixes],
					(*Sets SecondaryNumberOfLysisMixes to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryNumberOfLysisMixes, Null], Except[Null]],
						Lookup[methodPacket, SecondaryNumberOfLysisMixes],
					(*If a method is set by the TargetRNA and SecondaryNumberOfLysisMixes is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryNumberOfLysisMixes], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryNumberOfLysisMixes],
					(*If the sample will not be lysed, then SecondaryNumberOfLysisMixes is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisMixTemperature = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisMixTemperature], Except[Automatic]],
						Lookup[options, SecondaryLysisMixTemperature],
					(*Sets SecondaryLysisMixTemperature to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisMixTemperature, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisMixTemperature],
					(*If a method is set by the TargetRNA and SecondaryLysisMixTemperature is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisMixTemperature], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisMixTemperature],
					(*If the sample will not be lysed, then SecondaryLysisMixTemperature is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisTime], Except[Automatic]],
						Lookup[options, SecondaryLysisTime],
					(*Sets SecondaryLysisTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisTime, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisTime],
					(*If a method is set by the TargetRNA and SecondaryLysisTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisTime], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisTime],
					(*If the sample will not be lysed, then SecondaryLysisTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				secondaryLysisTemperature = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, SecondaryLysisTemperature], Except[Automatic]],
						Lookup[options, SecondaryLysisTemperature],
					(*Sets SecondaryLysisTemperature to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, SecondaryLysisTemperature, Null], Except[Null]],
						Lookup[methodPacket, SecondaryLysisTemperature],
					(*If a method is set by the TargetRNA and SecondaryLysisTemperature is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, SecondaryLysisTemperature], Except[Null]],
						Lookup[assignedMethodPacket, SecondaryLysisTemperature],
					(*If the sample will not be lysed, then SecondaryLysisTemperature is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisSolution = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisSolution], Except[Automatic]],
						Lookup[options, TertiaryLysisSolution],
					(*Sets TertiaryLysisSolution to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisSolution, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisSolution],
					(*If a method is set by the TargetRNA and TertiaryLysisSolution is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisSolution], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisSolution],
					(*If the sample will not be lysed, then TertiaryLysisSolution is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisMixType = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisMixType], Except[Automatic]],
						Lookup[options, TertiaryLysisMixType],
					(*Sets TertiaryLysisMixType to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixType, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisMixType],
					(*If a method is set by the TargetRNA and TertiaryLysisMixType is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisMixType], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisMixType],
					(*If the sample will not be lysed, then TertiaryLysisMixType is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisMixRate = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisMixRate], Except[Automatic]],
						Lookup[options, TertiaryLysisMixRate],
					(*Sets TertiaryLysisMixRate to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixRate, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisMixRate],
					(*If a method is set by the TargetRNA and TertiaryLysisMixRate is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisMixRate], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisMixRate],
					(*If the sample will not be lysed, then TertiaryLysisMixRate is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisMixTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisMixTime], Except[Automatic]],
						Lookup[options, TertiaryLysisMixTime],
					(*Sets TertiaryLysisMixTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixTime, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisMixTime],
					(*If a method is set by the TargetRNA and TertiaryLysisMixTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisMixTime], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisMixTime],
					(*If the sample will not be lysed, then TertiaryLysisMixTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryNumberOfLysisMixes = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryNumberOfLysisMixes], Except[Automatic]],
						Lookup[options, TertiaryNumberOfLysisMixes],
					(*Sets TertiaryNumberOfLysisMixes to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryNumberOfLysisMixes, Null], Except[Null]],
						Lookup[methodPacket, TertiaryNumberOfLysisMixes],
					(*If a method is set by the TargetRNA and TertiaryNumberOfLysisMixes is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryNumberOfLysisMixes], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryNumberOfLysisMixes],
					(*If the sample will not be lysed, then TertiaryNumberOfLysisMixes is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisMixTemperature = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisMixTemperature], Except[Automatic]],
						Lookup[options, TertiaryLysisMixTemperature],
					(*Sets TertiaryLysisMixTemperature to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisMixTemperature, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisMixTemperature],
					(*If a method is set by the TargetRNA and TertiaryLysisMixTemperature is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisMixTemperature], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisMixTemperature],
					(*If the sample will not be lysed, then TertiaryLysisMixTemperature is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisTime], Except[Automatic]],
						Lookup[options, TertiaryLysisTime],
					(*Sets TertiaryLysisTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisTime, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisTime],
					(*If a method is set by the TargetRNA and TertiaryLysisTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisTime], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisTime],
					(*If the sample will not be lysed, then TertiaryLysisTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				tertiaryLysisTemperature = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, TertiaryLysisTemperature], Except[Automatic]],
						Lookup[options, TertiaryLysisTemperature],
					(*Sets TertiaryLysisTemperature to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, TertiaryLysisTemperature, Null], Except[Null]],
						Lookup[methodPacket, TertiaryLysisTemperature],
					(*If a method is set by the TargetRNA and TertiaryLysisTemperature is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, TertiaryLysisTemperature], Except[Null]],
						Lookup[assignedMethodPacket, TertiaryLysisTemperature],
					(*If the sample will not be lysed, then TertiaryLysisTemperature is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				clarifyLysateIntensity = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, ClarifyLysateIntensity], Except[Automatic]],
						Lookup[options, ClarifyLysateIntensity],
					(*Sets ClarifyLysateIntensity to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, ClarifyLysateIntensity, Null], Except[Null]],
						Lookup[methodPacket, ClarifyLysateIntensity],
					(*If a method is set by the TargetRNA and ClarifyLysateIntensity is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, ClarifyLysateIntensity], Except[Null]],
						Lookup[assignedMethodPacket, ClarifyLysateIntensity],
					(*If the sample will not be lysed, then ClarifyLysateIntensity is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				clarifyLysateTime = Which[
					(*If user-set, then use set value.*)
					MatchQ[Lookup[options, ClarifyLysateTime], Except[Automatic]],
						Lookup[options, ClarifyLysateTime],
					(*Sets ClarifyLysateTime to value specified in the Method object if selected.*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, ClarifyLysateTime, Null], Except[Null]],
						Lookup[methodPacket, ClarifyLysateTime],
					(*If a method is set by the TargetRNA and ClarifyLysateTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, ClarifyLysateTime], Except[Null]],
						Lookup[assignedMethodPacket, ClarifyLysateTime],
					(*If the sample will not be lysed, then ClarifyLysateTime is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(* Otherwise, set to Automatic to be resolved in ExperimentLyseCells. *)
					True,
						Automatic
				];

				clarifiedLysateContainer = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, ClarifiedLysateContainer], Except[Automatic]],
						Lookup[options, ClarifiedLysateContainer],
					(*not a field in Method so no need to check Method*)
					(*If the sample will not be lysed, then ClarifiedLysateContainer is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(*If the sample will be lysed and nothing else (no homogenization, dehydration, or purification steps) and the sample will clarified during LyseCells, then set to the ContainerOut specified in the options*)
					And[
						MatchQ[lyse, True],
						MatchQ[{homogenizeLysate, dehydrationSolution, purification}, {False|Null, Null, None|Null}],
						MatchQ[clarifyLysateBool, True]
					],
						Lookup[options, ContainerOut],
					(*Otherwise, should be resolved by ExperimentLyseCells.*)
					True,
						Automatic
				];

				clarifiedLysateContainerLabel = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, ClarifiedLysateContainerLabel],Except[Automatic]],
						Lookup[options, ClarifiedLysateContainerLabel],
					(*not a field in Method so no need to check Method*)
					(*If the sample will not be lysed, then ClarifiedLysateContainerLabel is set to Null.*)
					MatchQ[lyse, False],
						Null,
					(*If the sample will be lysed and nothing else (no homogenization, dehydration, or purification steps) and the sample will clarified during LyseCells, then set to the ContainerOutLabel specified in the options*)
					And[
						MatchQ[lyse, True],
						MatchQ[{homogenizeLysate, dehydrationSolution, purification}, {False|Null, Null, None|Null}],
						MatchQ[clarifyLysateBool, True]
					],
						Lookup[options, ExtractedRNAContainerLabel],
					(*Otherwise, should be resolved by ExperimentLyseCells.*)
					True,
						Automatic
				];

				(* --- HOMOGENIZATION OPTIONS RESOLUTIONS ---*)

				homogenizationDevice = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, HomogenizationDevice], Except[Automatic]],
						Lookup[options, HomogenizationDevice],
					(*If a method is specified and HomogenizationDevice is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, HomogenizationDevice], Except[Null]],
						Lookup[methodPacket, HomogenizationDevice],
					(*If a method is set by the TargetRNA and HomogenizationDevice is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, HomogenizationDevice], Except[Null]],
						Lookup[assignedMethodPacket, HomogenizationDevice],
					(*If homogenizeLysate is set to True, HomogenizationDevice is set to the default plate*)
					MatchQ[homogenizeLysate, True],
						Model[Container, Plate, Filter, "id:bq9LA09W8zBr"],(*Model[Container, Plate, Filter, "96-well Homogenizer Plate"]*)
					True,
						Null
				];

				homogenizationTechnique = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, HomogenizationTechnique], Except[Automatic]],
						Lookup[options, HomogenizationTechnique],
					(*If a method is specified and HomogenizationTechnique is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, HomogenizationTechnique], Except[Null]],
						Lookup[methodPacket, HomogenizationTechnique],
					(*If a method is set by the TargetRNA and HomogenizationTechnique is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, HomogenizationTechnique], Except[Null]],
						Lookup[assignedMethodPacket, HomogenizationTechnique],
					(*If homogenizeLysate is set to True, check if HomogenizationInstrument is specified by the user, or if HomogenizationInstrument is specified by the user*)
					MatchQ[homogenizeLysate, True],
						Which[
							MatchQ[Lookup[options, HomogenizationInstrument], ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]],
								AirPressure,
							MatchQ[Lookup[options, HomogenizationInstrument], ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
								Centrifuge,
							MatchQ[Lookup[options, HomogenizationPressure], Except[Automatic | Null]],
								AirPressure,
							MatchQ[Lookup[options, HomogenizationCentrifugeIntensity], Except[Automatic | Null]],
								Centrifuge,
							True,
								AirPressure
						],
					True,
						Null
				];

				homogenizationInstrument = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, HomogenizationInstrument], Except[Automatic]],
						Lookup[options, HomogenizationInstrument],
					(*HomogenizationInstrument is not a field in Object[Method,Extraction,RNA], so dont need to check if the method set this option*)
					(*If homogenizeLysate is set to True, check what homogenizationTechnique is set to, or if either centrifuge intensity or pressure are specified by the user*)
					MatchQ[homogenizeLysate, True],
						Which[
							MatchQ[homogenizationTechnique, AirPressure],
								Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
							MatchQ[homogenizationTechnique, Centrifuge],
								Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
							MatchQ[Lookup[options, HomogenizationPressure], Except[Automatic | Null]],
								Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
							MatchQ[Lookup[options, HomogenizationCentrifugeIntensity], Except[Automatic | Null]],
								Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
							True,
								Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"](*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
						],
					True,
						Null
				];

				homogenizationCentrifugeIntensity = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, HomogenizationCentrifugeIntensity], Except[Automatic]],
						Lookup[options, HomogenizationCentrifugeIntensity],
					(*If a method is specified and HomogenizationCentrifugeIntensity is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, HomogenizationCentrifugeIntensity], Except[Null]],
						Lookup[methodPacket, HomogenizationCentrifugeIntensity],
					(*If a method is set by the TargetRNA and HomogenizationCentrifugeIntensity is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, HomogenizationCentrifugeIntensity], Except[Null]],
						Lookup[assignedMethodPacket, HomogenizationCentrifugeIntensity],
					(*If homogenizeLysate is set to True, check what homogenizationTechnique is set to, or what homogenizationInstrument is set to*)
					MatchQ[homogenizeLysate, True],
						Which[
							MatchQ[homogenizationTechnique, AirPressure],
								Null,
							MatchQ[homogenizationTechnique, Centrifuge],
								Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], containerInstrumentModelFastAssoc], MaxRotationRate],
							True,
								Null
						],
					True,
						Null
				];

				homogenizationPressure = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, HomogenizationPressure], Except[Automatic]],
						Lookup[options, HomogenizationPressure],
					(*If a method is specified and HomogenizationPressure is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, HomogenizationPressure], Except[Null]],
						Lookup[methodPacket, HomogenizationPressure],
					(*If a method is set by the TargetRNA and HomogenizationPressure is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, HomogenizationPressure], Except[Null]],
						Lookup[assignedMethodPacket, HomogenizationPressure],
					(*If homogenizeLysate is set to True, check what homogenizationTechnique is set to, or what homogenizationInstrument is set to*)
					MatchQ[homogenizeLysate, True],
						Which[
							MatchQ[homogenizationTechnique, AirPressure],
								Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"], containerInstrumentModelFastAssoc], MaxPressure],
							MatchQ[homogenizationTechnique, Centrifuge],
								Null,
							True,
								Lookup[fetchModelPacketFromFastAssoc[Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"], containerInstrumentModelFastAssoc], MaxPressure]
						],
					True,
						Null
				];

				homogenizationTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, HomogenizationTime], Except[Automatic]],
						Lookup[options, HomogenizationTime],
					(*If a method is specified and HomogenizationPressure is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, HomogenizationTime], Except[Null]],
						Lookup[methodPacket, HomogenizationTime],
					(*If a method is set by the TargetRNA and HomogenizationTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, HomogenizationTime], Except[Null]],
						Lookup[assignedMethodPacket, HomogenizationTime],
					(*If homogenizeLysate is set to True, check what homogenizationTechnique is set to, or what homogenizationInstrument is set to*)
					MatchQ[homogenizeLysate, True],
						1 Minute,
					True,
						Null
				];

				(* resolve the hidden option HomogenizationCollectionContainer *)
				homogenizationCollectionContainer = Which[
					(* this is not user-facing, so will not check for user-specified values or method-specified values*)
					(* if sample will not be homogenized, set to Null*)
					MatchQ[homogenizeLysate, False],
						Null,
					(* If homogenization or dehydration solution is the final operation being performed on the samples (ie no Purification steps specified), and if the user has specified a container out, the collection container is set to the ContainerOut. *)
					MatchQ[homogenizeLysate, True] && MatchQ[purification, Alternatives[Null, None]] && MatchQ[Lookup[options, ContainerOut], Except[Automatic]],
						Lookup[options, ContainerOut],
					(* Otherwise, Filter will resolve the appropriate collection container *)
					True,
						Automatic
				];

				(* Get the max volume of the collection container *)
				homogenizationCollectionContainerVolume = If[
					And[
						MatchQ[homogenizationCollectionContainer, ObjectP[{Object[Container], Model[Container]}]],
						MatchQ[Lookup[fetchPacketFromFastAssoc[homogenizationCollectionContainer, containerInstrumentModelFastAssoc], MaxVolume], VolumeP]
					],
					Lookup[fetchPacketFromFastAssoc[homogenizationCollectionContainer, containerInstrumentModelFastAssoc], MaxVolume],
					Null
				];

				(* --- DEHYDRATION OPTIONS RESOLUTIONS --- *)

				(* Set up warning check variable *)
				dehydrationSolutionVolumeWarning = False;

				dehydrationSolutionVolume = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, DehydrationSolutionVolume], Except[Automatic]],
						Lookup[options, DehydrationSolutionVolume],
					(*Not a field in the method, so dont check method*)
					(*If dehydrationSolution is Null or None, set to Null*)
					MatchQ[dehydrationSolution, (Null | None)],
						Null,
					dehydrationBool && MatchQ[sampleVolume, VolumeP],
						Switch[{
							lyse,
							homogenizeLysate,
							MatchQ[startingSampleContainerVolume, VolumeP],
							(* NOTE we will only know the homogenizationCollectionContainerVolume if Dehydration is the final unit operation and the user specified a ContainerOut *)
							MatchQ[homogenizationCollectionContainerVolume, VolumeP],
							MatchQ[Lookup[options, LysisSolutionVolume], VolumeP],
							lysisAliquot,
							clarifyLysateBool
						},
							(* The samples are in the original container and we know the MaxVolume so add either 1x sample volume or 80% of the remaining container volume *)
							{False, False, True, _, _, _, _}, RoundOptionPrecision[Min[{sampleVolume, (0.8 * (startingSampleContainerVolume - sampleVolume))}], 10^(-1) Microliter],
							(* The samples are in the homogenization collection container and no additional volume was added to the sample so same as above but use the homogenization container remaining volume *)
							{False, True, _, True, _, _, _}, RoundOptionPrecision[Min[{sampleVolume, (0.8 * (homogenizationCollectionContainerVolume - sampleVolume))}], 10^(-1) Microliter],
							(* The samples are in the homogenization collection container and we know how much volume was added during lysis so same as above but use the total sample + lysis solution volume *)
							{True, True, _, True, True, False, _}, RoundOptionPrecision[Min[{(sampleVolume + Lookup[options, LysisSolutionVolume]), (0.8 * (homogenizationCollectionContainerVolume - (sampleVolume + Lookup[options, LysisSolutionVolume])))}], 10^(-1) Microliter],
							(* We don't resolve the lysis solution volume here so if its not specified, we're estimating that the lysis volume was equal to the sample volume and they'll add 1:1 volume of dehydration solution to that.... *)
							(* NOTE: since we're estimating here, throw a warning to tell the user that we're assigning an estimated volume but it is possible that it won't be compatible with the container. And an OverfilledTransfer error will be thrown when the rest of the volume options get resolved in the transfer unit operation *)
							{True, True, _, True, False, False, _},
								dehydrationSolutionVolumeWarning = True;
								RoundOptionPrecision[Min[{(2 * sampleVolume), (0.8 * (homogenizationCollectionContainerVolume - 2 * sampleVolume))}], 10^(-1) Microliter],
							(* The samples are in the original container and we know how much volume was added during lysis *)
							{True, False, True, _, True, False, False}, RoundOptionPrecision[Min[{(sampleVolume + Lookup[options, LysisSolutionVolume]), (0.8 * (startingSampleContainerVolume - sampleVolume))}], 10^(-1) Microliter],
							(* Otherwise, set to 2x the sample volume and we'll throw an error if this doesnt work once the other volume options are resolved in the resource packets function *)
							(* NOTE: since we're estimating here, throw a warning to tell the user that we're assigning an estimated volume but it is possible that it won't be compatible with the container. And an OverfilledTransfer error will be thrown when the rest of the volume options get resolved in the transfer unit operation *)
							_,
								dehydrationSolutionVolumeWarning = True;
								(2. * sampleVolume)
						],
					(* Otherwise, set to 2x the sample volume and we'll throw an error if this doesnt work once the other volume options are resolved in the resource packets function *)
					(* NOTE: since we're estimating here, throw a warning to tell the user that we're assigning an estimated volume but it is possible that it won't be compatible with the container. And an OverfilledTransfer error will be thrown when the rest of the volume options get resolved in the transfer unit operation *)
					True,
						dehydrationSolutionVolumeWarning = True;
						2. * sampleVolume
				];

				dehydrationSolutionMixType = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, DehydrationSolutionMixType], Except[Automatic]],
						Lookup[options, DehydrationSolutionMixType],
					(*If a method is specified and DehydrationSolutionMixType is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, DehydrationSolutionMixType], Except[Null]],
						Lookup[methodPacket, DehydrationSolutionMixType],
					(*If a method is set by the TargetRNA and DehydrationSolutionMixType is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, DehydrationSolutionMixType], Except[Null]],
						Lookup[assignedMethodPacket, DehydrationSolutionMixType],
					(*If dehydrationSolution is Null or None, set to Null*)
					MatchQ[dehydrationSolution, Null | None],
						Null,
					(*If any Shake mixing options are set, set to Pipette*)
					MatchQ[Lookup[options, DehydrationSolutionMixRate], Except[Automatic | Null]] || MatchQ[Lookup[options, DehydrationSolutionMixTime], Except[Automatic | Null]],
						Shake,
					(*Otherwise, set to Pipette*)
					True,
						Pipette
				];

				numberOfDehydrationSolutionMixes = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, NumberOfDehydrationSolutionMixes], Except[Automatic]],
						Lookup[options, NumberOfDehydrationSolutionMixes],
					(*If a method is specified and NumberOfDehydrationSolutionMixes is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, NumberOfDehydrationSolutionMixes], Except[Null]],
						Lookup[methodPacket, NumberOfDehydrationSolutionMixes],
					(*If a method is set by the TargetRNA and NumberOfDehydrationSolutionMixes is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, NumberOfDehydrationSolutionMixes], Except[Null]],
						Lookup[assignedMethodPacket, NumberOfDehydrationSolutionMixes],
					(*If dehydrationSolution is Null or None, set to Null*)
					MatchQ[dehydrationSolution, Null | None],
						Null,
					(*If dehydrationSolutionMixType is set to Shake set to Null*)
					MatchQ[dehydrationSolutionMixType, Shake],
						Null,
					(*If dehydrationSolutionMixType is set to Pipette or other pipette mixing options are set, set to 10 uL*)
					MatchQ[dehydrationSolutionMixType, Pipette] || MatchQ[Lookup[options, DehydrationSolutionMixVolume], Except[Automatic | Null]],
						10,
					(*Otherwise, set to Null*)
					True,
						Null
				];

				dehydrationSolutionMixVolume = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, DehydrationSolutionMixVolume], Except[Automatic]],
						Lookup[options, DehydrationSolutionMixVolume],
					(*Not a field in the method, so dont check method*)
					(*If dehydrationSolution is Null or None, set to Null*)
					MatchQ[dehydrationSolution, Null | None],
						Null,
					(*If dehydrationSolutionMixType is set to Shake set to Null*)
					MatchQ[dehydrationSolutionMixType, Shake],
						Null,
					(*If dehydrationSolutionMixType is set to Pipette or other pipette mixing options are set, set to the lesser of 1/2 of the sampleVolume + dehydrationSolutionVolume and the maximum pipet volume*)
					MatchQ[dehydrationSolutionMixType, Pipette] || MatchQ[Lookup[options, NumberOfDehydrationSolutionMixes], Except[Automatic | Null]],
						RoundOptionPrecision[Min[{(0.5 * (sampleVolume + dehydrationSolutionVolume)), $MaxRoboticSingleTransferVolume}], 10^(-1) Microliter],
					(*Otherwise, set to Null*)
					True,
						Null
					];

				dehydrationSolutionMixRate = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, DehydrationSolutionMixRate], Except[Automatic]],
						Lookup[options, DehydrationSolutionMixRate],
					(*If a method is specified and DehydrationSolutionMixRate is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, DehydrationSolutionMixRate], Except[Null]],
						Lookup[methodPacket, DehydrationSolutionMixRate],
					(*If a method is set by the TargetRNA and DehydrationSolutionMixRate is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, DehydrationSolutionMixRate], Except[Null]],
						Lookup[assignedMethodPacket, DehydrationSolutionMixRate],
					(*If dehydrationSolution is Null or None, set to Null*)
					MatchQ[dehydrationSolution, Null | None],
						Null,
					(*If dehydrationSolutionMixType is set to Shake or other shake mixing options are set, set to 100 RPM*)
					MatchQ[dehydrationSolutionMixType, Shake],
						100 RPM,
					(*Otherwise (dehydrationSolutionMixType is Pipette), set DehydrationSolutionMixRate to Null*)
					True,
						Null
				];

				dehydrationSolutionMixTime = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, DehydrationSolutionMixTime], Except[Automatic]],
						Lookup[options, DehydrationSolutionMixTime],
					(*If a method is specified and DehydrationSolutionMixTime is specified by the method, set to method-specified value*)
					useMapThreadMethodQ && MatchQ[Lookup[methodPacket, DehydrationSolutionMixTime], Except[Null]],
						Lookup[methodPacket, DehydrationSolutionMixTime],
					(*If a method is set by the TargetRNA and DehydrationSolutionMixTime is specified by the method, set to method-specified value*)
					useAssignedMethodQ && MatchQ[Lookup[assignedMethodPacket, DehydrationSolutionMixTime], Except[Null]],
						Lookup[assignedMethodPacket, DehydrationSolutionMixTime],
					(*If dehydrationSolution is Null or None, set to Null*)
					MatchQ[dehydrationSolution, Null | None],
						Null,
					(*If dehydrationSolutionMixType is set to Shake or other shake mixing options are set, set to 1 Minute*)
					MatchQ[dehydrationSolutionMixType, Shake],
						1 Minute,
					(*Otherwise (dehydrationSolutionMixType is Pipette), set to Null*)
					True,
						Null
				];

				{
					method,
					targetRNA,
					lyse,
					lysisTime,
					lysisTemperature,
					lysisAliquot,
					clarifyLysateBool,
					cellType,
					numberOfLysisSteps,
					preLysisPellet,
					preLysisPelletingIntensity,
					preLysisPelletingTime,
					lysisSolution,
					lysisMixType,
					lysisMixRate,
					lysisMixTime,
					numberOfLysisMixes,
					lysisMixTemperature,
					secondaryLysisSolution,
					secondaryLysisMixType,
					secondaryLysisMixRate,
					secondaryLysisMixTime,
					secondaryNumberOfLysisMixes,
					secondaryLysisMixTemperature,
					secondaryLysisTime,
					secondaryLysisTemperature,
					tertiaryLysisSolution,
					tertiaryLysisMixType,
					tertiaryLysisMixRate,
					tertiaryLysisMixTime,
					tertiaryNumberOfLysisMixes,
					tertiaryLysisMixTemperature,
					tertiaryLysisTime,
					tertiaryLysisTemperature,
					clarifyLysateIntensity,
					clarifyLysateTime,
					lysisAliquotContainer,
					lysisAliquotContainerLabel,
					clarifiedLysateContainer,
					clarifiedLysateContainerLabel,
					homogenizeLysate,
					homogenizationDevice,
					homogenizationCollectionContainer,
					homogenizationTechnique,
					homogenizationInstrument,
					homogenizationCentrifugeIntensity,
					homogenizationPressure,
					homogenizationTime,
					dehydrationSolution, dehydrationSolutionVolume, dehydrationSolutionVolumeWarning, dehydrationSolutionMixType, numberOfDehydrationSolutionMixes, dehydrationSolutionMixVolume, dehydrationSolutionMixRate, dehydrationSolutionMixTime,
					purification
				}
			]
		],
		{samplePackets, sampleContainerPackets, methodPackets, labelPreResolvedMapThreadFriendlyOptions}
	];

	(*Set up working samples prior to any action upon them.*)
	workingSamples = mySamples;

	(*Pull current sample container as ContainerOut option in case it is not worked upon (Lyse -> False, HomogenizeLysate -> False, DehyrationSolution -> Null, Purification -> None).*)
	(*container is in the form of {{Well, Object[Container]}}*)
	containerOutBeforePurification = {Lookup[#, Position],Download[Lookup[#, Container], Object]}& /@ samplePackets;

	(* -- METHOD AND TARGET OPTIONS -- *)
	resolvedMethodOptions = {
		Method -> resolvedMethod,
		TargetRNA -> resolvedTargetRNA
	};

	(* -- LYSIS OPTIONS -- *)
	preResolvedLysisOptions = {
		LysisTime -> resolvedLysisTime,
		LysisTemperature -> resolvedLysisTemperature,
		LysisAliquot -> resolvedLysisAliquot,
		ClarifyLysate -> resolvedClarifyLysateBool,
		CellType -> preResolvedCellType,
		NumberOfLysisSteps -> preResolvedNumberOfLysisSteps,
		PreLysisPellet -> preResolvedPreLysisPellet,
		PreLysisPelletingIntensity -> preResolvedPreLysisPelletingIntensity,
		PreLysisPelletingTime -> preResolvedPreLysisPelletingTime,
		LysisSolution -> preResolvedLysisSolution,
		LysisMixType -> preResolvedLysisMixType,
		LysisMixRate -> preResolvedLysisMixRate,
		LysisMixTime -> preResolvedLysisMixTime,
		NumberOfLysisMixes -> preResolvedNumberOfLysisMixes,
		LysisMixTemperature -> preResolvedLysisMixTemperature,
		SecondaryLysisSolution -> preResolvedSecondaryLysisSolution,
		SecondaryLysisMixType ->  preResolvedSecondaryLysisMixType,
		SecondaryLysisMixRate ->  preResolvedSecondaryLysisMixRate,
		SecondaryLysisMixTime -> preResolvedSecondaryLysisMixTime,
		SecondaryNumberOfLysisMixes -> preResolvedSecondaryNumberOfLysisMixes,
		SecondaryLysisMixTemperature -> preResolvedSecondaryLysisMixTemperature,
		SecondaryLysisTime -> preResolvedSecondaryLysisTime,
		SecondaryLysisTemperature -> preResolvedSecondaryLysisTemperature,
		TertiaryLysisSolution -> preResolvedTertiaryLysisSolution,
		TertiaryLysisMixType -> preResolvedTertiaryLysisMixType,
		TertiaryLysisMixRate -> preResolvedTertiaryLysisMixRate,
		TertiaryLysisMixTime -> preResolvedTertiaryLysisMixTime,
		TertiaryNumberOfLysisMixes -> preResolvedTertiaryNumberOfLysisMixes,
		TertiaryLysisMixTemperature -> preResolvedTertiaryLysisMixTemperature,
		TertiaryLysisTime -> preResolvedTertiaryLysisTime,
		TertiaryLysisTemperature -> preResolvedTertiaryLysisTemperature,
		ClarifyLysateIntensity -> preResolvedClarifyLysateIntensity,
		ClarifyLysateTime -> preResolvedClarifyLysateTime,
		LysisAliquotContainer -> preResolvedLysisAliquotContainer,
		ClarifiedLysateContainer -> preResolvedClarifiedLysateContainer,
		ClarifiedLysateContainerLabel -> preResolvedClarifiedLysateContainerLabel
	};

	(* -- HOMOGENIZATION OPTIONS -- *)
	resolvedHomogenizationOptions = {
		HomogenizeLysate -> resolvedHomogenizeLysate,
		HomogenizationDevice -> resolvedHomogenizationDevice,
		HomogenizationCollectionContainer -> resolvedHomogenizationCollectionContainer,
		HomogenizationTechnique -> resolvedHomogenizationTechnique,
		HomogenizationInstrument -> resolvedHomogenizationInstrument,
		HomogenizationCentrifugeIntensity -> resolvedHomogenizationCentrifugeIntensity,
		HomogenizationPressure -> resolvedHomogenizationPressure,
		HomogenizationTime -> resolvedHomogenizationTime
	};

	(* -- DEHYDRATION OPTIONS -- *)

	preResolvedDehydrationOptions = {
		DehydrationSolution -> resolvedDehydrationSolution,
		DehydrationSolutionVolume -> preResolvedDehydrationSolutionVolume,
		DehydrationSolutionMixType -> resolvedDehydrationSolutionMixType,
		NumberOfDehydrationSolutionMixes -> resolvedNumberOfDehydrationSolutionMixes,
		DehydrationSolutionMixVolume -> preResolvedDehydrationSolutionMixVolume,
		DehydrationSolutionMixRate -> resolvedDehydrationSolutionMixRate,
		DehydrationSolutionMixTime -> resolvedDehydrationSolutionMixTime
	};

	(* -- PURIFICATION OPTION -- *)

	(* resolve the purification master switch option *)
	resolvedPurification = resolvePurification[labelPreResolvedMapThreadFriendlyOptions, Lookup[resolvedMethodOptions, Method]];

	(* Add resolved purification option to existing option sets. *)
	optionsWithResolvedMethodAndPurification = ReplaceRule[
		Normal[labelPreResolvedRoundedExperimentOptions, Association],
		Flatten[{
			Method -> Lookup[resolvedMethodOptions, Method],
			Purification -> resolvedPurification
		}]
	];

	preCorrectionMapThreadFriendlyOptionsWithResolvedMethodAndPurification = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, Association[optionsWithResolvedMethodAndPurification]];

	(* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
	(* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
	mapThreadFriendlyOptionsWithResolvedMethodAndPurification = Experiment`Private`mapThreadFriendlySolventAdditions[optionsWithResolvedMethodAndPurification, preCorrectionMapThreadFriendlyOptionsWithResolvedMethodAndPurification, LiquidLiquidExtractionSolventAdditions];

	(* Pre-resolve purification options. *)
	preResolvedPurificationOptions = preResolvePurificationSharedOptions[mySamples, optionsWithResolvedMethodAndPurification, mapThreadFriendlyOptionsWithResolvedMethodAndPurification, TargetCellularComponent -> ConstantArray[RNA, Length[mySamples]],Simulation->currentSimulation];

	(* -- POST PROCESSING -- *)

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions,Sterile->True];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[Lookup[myOptions,ParentProtocol]],
			True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[Lookup[myOptions,ParentProtocol], ObjectP[ProtocolTypes[Output -> Short]]],
			False,
		True,
			Lookup[myOptions, Email]
	];

	(* -- RESOLVED AND PRE-RESOLVED OPTIONS -- *)

	(* Overwrite our rounded options with our resolved options.*)
	preResolvedOptions=ReplaceRule[
		Normal[labelPreResolvedRoundedExperimentOptions, Association],
		Flatten[{
			(*General Options*)
			RoboticInstrument -> resolvedRoboticInstrument,
			WorkCell -> resolvedWorkCell,
			(*Lysis, Homogenization, and Purification Options*)
			Lyse -> resolvedLyse,
			HomogenizeLysate -> resolvedHomogenizeLysate,
			Purification -> resolvedPurification,
			ExtractedRNALabel -> resolvedExtractedRNALabel,
			ExtractedRNAContainerLabel -> preResolvedExtractedRNAContainerLabel,
			resolvedMethodOptions,
			preResolvedLysisOptions,
			resolvedHomogenizationOptions,
			preResolvedDehydrationOptions,
			resolvedPostProcessingOptions,
			preResolvedPurificationOptions
		}]
	];

	(* Conflicting options checks for options that fully resolve in this function *)


	(*Get map thread friendly preresolved options for use in options checks*)
	mapThreadFriendlyPreResolvedOptionsWithoutSolventAdditions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, preResolvedOptions];

	(* Correctly make SolventAdditions mapThreadFriendly. *)
	(* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
	mapThreadFriendlyPreResolvedOptions = Experiment`Private`mapThreadFriendlySolventAdditions[preResolvedOptions, mapThreadFriendlyPreResolvedOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];


	(* If a method is specified, all corresponding options should match with that method. *)
	(*Error::MethodOptionConflict is in general messages*)
	methodConflictingOptions = MapThread[
		Function[{sample, options, index},
			Module[{conflictingOptions},
				If[
					(* If a method is not set, then no need to check if the options line up with the method object.*)
					If[
						MatchQ[Lookup[options, Method], (Custom | Null)],
						False,
						(* Check if each option that the method can specify matches what is in the method object. *)
						Module[{informedFields, methodPacket},

							methodPacket = fetchPacketFromFastAssoc[Lookup[options, Method], containerInstrumentModelFastAssoc];

							(* Pull out non-Null fields from method packets. *)
							informedFields = Select[$ExtractRNAMethodFields, MatchQ[Lookup[methodPacket, #], Except[Null | {}]]&];

							(* Determine if value of method matches the resolved option. *)
							conflictingOptions = Map[
								If[
									!MatchQ[Lookup[methodPacket, #], Lookup[options, #]],
									#,
									Nothing
								]&,
								informedFields
							];

							If[Length[conflictingOptions] > 0,
								True,
								False
							]
						]

					],
					{
						sample,
						conflictingOptions,
						Lookup[mapThreadFriendlyPreResolvedOptions, Method],
						index
					},
					Nothing
				]
			]
		],
		{mySamples, mapThreadFriendlyPreResolvedOptions, Range[Length[mySamples]]}
	];

	If[Length[methodConflictingOptions]>0 && messages,
		Message[
			Error::MethodOptionConflict,
			ObjectToString[methodConflictingOptions[[All,1]], Cache -> cacheBall],
			methodConflictingOptions[[All,2]],
			methodConflictingOptions[[All,3]],
			methodConflictingOptions[[All,4]]
		];
	];

	methodConflictingOptionsTest=If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = methodConflictingOptions[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall] <> " have all of their liquid-liquid extraction options set to Null since LiquidLiquidExtraction is not called in Purification:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall] <> " have all of their liquid-liquid extraction options set to Null since LiquidLiquidExtraction is not called in Purification:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check if any of the samples had DehydrationSolutionVolume estimated in the pre-resolver (estimated so need to warn user)*)
	dehydrationSolutionVolumeWarningOptions = MapThread[
		Function[{sample, warningBool, dehydrationSolutionVolume, index},
			If[MatchQ[warningBool, True],
				{sample, dehydrationSolutionVolume, index},
				Nothing
			]
		],
		{mySamples, mtdehydrationSolutionVolumeWarning, preResolvedDehydrationSolutionVolume, Range[Length[mySamples]]}
	];

	If[Length[dehydrationSolutionVolumeWarningOptions] > 0 && messages,
		Message[
			Warning::EstimatedDehydrationSolutionVolume,
			ObjectToString[dehydrationSolutionVolumeWarningOptions[[All, 1]], Cache -> cacheBall],
			dehydrationSolutionVolumeWarningOptions[[All, 2]],
			dehydrationSolutionVolumeWarningOptions[[All, 3]]
		];
	];

	dehydrationSolutionVolumeWarningTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = dehydrationSolutionVolumeWarningOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"either have DehydrationSolutionVolume specified or the volume can be calculated from the sample volume, container volumes, and other added solution volumes:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"either have DehydrationSolutionVolume specified or the volume can be calculated from the sample volume, container volumes, and other added solution volumes:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check if the specified method can extract the specified target RNA*)
	methodTargetMismatchedOptions = MapThread[
		Function[{sample, method, targetRNA, index},

			Switch[{targetRNA, method},
				(* if the Method is Custom, or if the TargetRNA is Unspecified, no warning needed *)
				Alternatives[{_, Custom}, {Unspecified, _}],
					Nothing,
				(* If the TargetRNA is not Unspecified and the Method is a method object, check if the target option matches the target field in the method object *)
				{_, ObjectP[Object[Method, Extraction, RNA]]},
					Module[{methodTargetRNA},
						methodTargetRNA = Lookup[fetchPacketFromFastAssoc[method, containerInstrumentModelFastAssoc], TargetRNA];
						If[!MatchQ[targetRNA, methodTargetRNA],
							{sample, method, targetRNA, index},
							Nothing
						]
					],
				True,
					Nothing
			]
		],
		{mySamples, resolvedMethod, resolvedTargetRNA, Range[Length[mySamples]]}
	];

	If[Length[methodTargetMismatchedOptions] > 0 && messages,
		Message[
			Warning::MethodTargetRNAMismatch,
			ObjectToString[methodTargetMismatchedOptions[[All, 1]], Cache -> cacheBall],
			methodTargetMismatchedOptions[[All, 2]],
			methodTargetMismatchedOptions[[All, 3]],
			methodTargetMismatchedOptions[[All, 4]]
		];
	];

	methodTargetConflictingOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = methodTargetMismatchedOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"have a method that is suitable for extraction of the specified target RNA:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"have a method that is suitable for extraction of the specified target RNA:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check if Lyse is not set to False when the Living field in Object[Sample] is set to False (Warning)*)
	repeatedLysisOptions = MapThread[
		Function[{sample, lyse, index},
			If[
				MatchQ[lyse, True] && MatchQ[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Living], False],
				{sample, index},
				Nothing
			]
		],
		{mySamples, resolvedLyse, Range[Length[mySamples]]}
	];

	If[Length[repeatedLysisOptions] > 0 && messages,
		Message[
			Warning::RepeatedLysis,
			ObjectToString[repeatedLysisOptions[[All, 1]], Cache -> cacheBall],
			repeatedLysisOptions[[All, 2]]
		];
	];

	repeatedLysisOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = repeatedLysisOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"have Lyse set to False if the Living field is set to False:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"have Lyse set to False if the Living field is set to False:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(*check if Lyse is not set to true when the Living field in Object[Sample] is set to True (Warning)*)
	unlysedCellsOptions = MapThread[
		Function[{sample, lyse, index},
			If[
				MatchQ[lyse, False] && MatchQ[Lookup[fetchPacketFromFastAssoc[sample, fastCacheBall], Living], True],
				{sample,index},
				Nothing
			]
		],
		{mySamples, resolvedLyse, Range[Length[mySamples]]}
	];

	If[Length[unlysedCellsOptions] > 0 && messages,
		Message[
			Warning::UnlysedCellsInput,
			ObjectToString[unlysedCellsOptions[[All, 1]], Cache -> cacheBall],
			unlysedCellsOptions[[All, 2]]
		];
	];

	unlysedCellsOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unlysedCellsOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"have Lyse set to True if the Living field is set to True:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"have Lyse set to True if the Living field is set to True:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];



	(*check if homogenization options are set when HomogenizeLysate is false (Error)*)
	lysateHomogenizationConflictingOptions = MapThread[
		Function[{sample, homogenizeLysate, homogenizationDevice,homogenizationTechnique,homogenizationInstrument,homogenizationCentrifugeIntensity,homogenizationPressure,homogenizationTime, index},
			If[
				And[
					MatchQ[homogenizeLysate, False],
					!MatchQ[
						{homogenizationDevice,homogenizationTechnique,homogenizationInstrument,homogenizationCentrifugeIntensity,homogenizationPressure,homogenizationTime},
						{Null..}
					]
				],
				{
					sample,
					homogenizeLysate,
					PickList[
						{HomogenizationDevice,HomogenizationTechnique,HomogenizationInstrument,HomogenizationCentrifugeIntensity,HomogenizationPressure,HomogenizationTime},
						homogenizationDevice,homogenizationTechnique,homogenizationInstrument,homogenizationCentrifugeIntensity,homogenizationPressure,homogenizationTime,
						Except[Null|Automatic]
					],
					index
				},
				Nothing
			]
		],
		{mySamples, resolvedHomogenizeLysate, resolvedHomogenizationDevice,resolvedHomogenizationTechnique,resolvedHomogenizationInstrument,resolvedHomogenizationCentrifugeIntensity,resolvedHomogenizationPressure,resolvedHomogenizationTime, Range[Length[mySamples]]}
	];

	If[Length[lysateHomogenizationConflictingOptions] > 0 && messages,
		Message[
			Error::LysateHomogenizationOptionMismatch,
			ObjectToString[lysateHomogenizationConflictingOptions[[All, 1]], Cache -> cacheBall],
			lysateHomogenizationConflictingOptions[[All, 2]],
			lysateHomogenizationConflictingOptions[[All, 3]],
			lysateHomogenizationConflictingOptions[[All, 4]]
		];
	];

	lysateHomogenizationConflictingOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = lysateHomogenizationConflictingOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"do not have lysate homogenization options set if HomogenizeLysate is set to False:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"do not have lysate homogenization options set if HomogenizeLysate is set to False:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* Check if Homogenization is set to True if the first purificaiton step is SPE (warning)*)

	homogenizationPurificationConflictingOptionSamples = MapThread[
		Function[{sample, samplePacket, purification, homogenizeLysate, index},
			If[
				And[
					Or[
						MatchQ[Lookup[samplePacket, Living], True],
						MatchQ[Lookup[samplePacket, Composition][[All, 2]][Object], {ObjectP[Model[Lysate]]}]
					],
					MatchQ[purification, {SolidPhaseExtraction, ___}],
					MatchQ[homogenizeLysate, False]
				],
				{sample, index},
				Nothing
			]
		],
		{mySamples, samplePackets, resolvedPurification, resolvedHomogenizeLysate, Range[Length[mySamples]]}
	];

	If[Length[homogenizationPurificationConflictingOptionSamples] > 0 && messages,
		Message[
			Warning::HomogenizationPurificationOptionMismatch,
			ObjectToString[homogenizationPurificationConflictingOptionSamples[[All, 1]], Cache -> cacheBall],
			homogenizationPurificationConflictingOptionSamples[[All, 2]]
		];
	];

	homogenizationPurificationConflictingOptionTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = homogenizationPurificationConflictingOptionSamples[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"do not have HomogenizeLysate set to False if the first Purification technique is set to SolidPhaseExtraction:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"do not have HomogenizeLysate set to False if the first Purification technique is set to SolidPhaseExtraction:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check if HomogenizationInstrument can perform the HomogenizationTechnique (Error)*)
	homogenizationTechniqueInstrumentConflictingOptions = MapThread[
		Function[{sample, homogenizationTechnique, homogenizationInstrument, index},
			If[
				Or[
					MatchQ[homogenizationTechnique, Centrifuge] && MatchQ[homogenizationInstrument, ObjectP[Model[Instrument, PressureManifold]]],
					MatchQ[homogenizationTechnique, AirPressure] && MatchQ[homogenizationInstrument, ObjectP[Model[Instrument, Centrifuge]]]
				],
				{sample, homogenizationTechnique, homogenizationInstrument, index},
				Nothing
			]
		],
		{mySamples, resolvedHomogenizationTechnique, resolvedHomogenizationInstrument, Range[Length[mySamples]]}
	];

	If[Length[homogenizationTechniqueInstrumentConflictingOptions] > 0 && messages,
		Message[
			Error::HomogenizationTechniqueInstrumentMismatch,
			ObjectToString[homogenizationTechniqueInstrumentConflictingOptions[[All, 1]], Cache -> cacheBall],
			homogenizationTechniqueInstrumentConflictingOptions[[All, 2]],
			homogenizationTechniqueInstrumentConflictingOptions[[All, 3]],
			homogenizationTechniqueInstrumentConflictingOptions[[All, 4]]
		];
	];

	homogenizationTechniqueInstrumentConflictingOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = homogenizationTechniqueInstrumentConflictingOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"do not have HomogenizationTechnique set to a technique that cannot be performed by the set HomogenizationInstrument:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"do not have HomogenizationTechnique set to a technique that cannot be performed by the set HomogenizationInstrument:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check if exactly one of HomogenizationCentrifugeIntensity and HomogenizationPressure is specified (HomogenizationCentrifugeIntensity is set to Null if Technique is AirPressure, HomogenizationPressure is set to Null if Technique is Centrifuge (Error)*)
	homogenizationCentrifugeIntensityPressureConflictingOptions = MapThread[
		Function[{sample, homogenizationCentrifugeIntensity, homogenizationPressure, index},
			If[
				MatchQ[homogenizationCentrifugeIntensity, Except[Null]] && MatchQ[homogenizationPressure, Except[Null]],
				{sample, homogenizationCentrifugeIntensity, homogenizationPressure, index},
				Nothing
			]
		],
		{mySamples, resolvedHomogenizationCentrifugeIntensity, resolvedHomogenizationPressure, Range[Length[mySamples]]}
	];

	If[Length[homogenizationCentrifugeIntensityPressureConflictingOptions] > 0 && messages,
		Message[
			Error::HomogenizationCentrifugeIntensityPressureMismatch,
			ObjectToString[homogenizationCentrifugeIntensityPressureConflictingOptions[[All, 1]], Cache -> cacheBall],
			homogenizationCentrifugeIntensityPressureConflictingOptions[[All, 2]],
			homogenizationCentrifugeIntensityPressureConflictingOptions[[All, 2]],
			homogenizationCentrifugeIntensityPressureConflictingOptions[[All, 2]]
		];
	];

	homogenizationCentrifugeIntensityPressureConflictingOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = homogenizationTechniqueInstrumentConflictingOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) "<>ObjectToString[affectedSamples, Cache -> cacheBall]<>"do not have HomogenizationTechnique set to a technique that cannot be performed by the set HomogenizationInstrument:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall]<>"do not have HomogenizationTechnique set to a technique that cannot be performed by the set HomogenizationInstrument:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*Check that LLE, Precipitation, SPE, and MBS have all options set to Null if not called in Purification.*)
	{methodValidityTest, invalidExtractionMethodOptions} = extractionMethodValidityTest[
		mySamples,
		preResolvedOptions,
		gatherTests,
		Cache -> cacheBall
	];

	(*Check that all of the SPE options work*)
	{solidPhaseExtractionConflictingOptionsTests, solidPhaseExtractionConflictingOptions} = solidPhaseExtractionConflictingOptionsChecks[
		mySamples,
		preResolvedOptions,
		gatherTests,
		Cache -> cacheBall
	];

	(*Check that the non-index matching shared MBS options SelectionStrategy and SeparationMode are not different by methods or user-method conflict*)
	{mbsMethodsConflictingOptionsTest, mbsMethodsConflictingOptions} = mbsMethodsConflictingOptionsTests[
		mySamples,
		preResolvedOptions,
		gatherTests,
		Cache -> cacheBall
	];

	(* Check that there are no more than 3 of each purification technique specified *)
	{purificationTests, purificationInvalidOptions} = purificationSharedOptionsTests[
		mySamples,
		samplePackets,
		preResolvedOptions,
		gatherTests,
		Cache -> cacheBall
	];

		(* -- INVALID INPUT CHECK -- *)

	(*Gather a list of all invalid inputs from all invalid input tests.*)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, deprecatedInvalidInputs, solidMediaInvalidInputs}]];

	(*Throw Error::InvalidInput if there are any invalid inputs.*)
	If[messages && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* -- INVALID OPTION CHECK -- *)

	(* Check our invalid option variables and throw Error::InvalidOption if necessary. *)
	invalidOptions = DeleteDuplicates[Flatten[{
		Sequence@@{
			methodConflictingOptions,
			lysateHomogenizationConflictingOptions,
			homogenizationTechniqueInstrumentConflictingOptions,
			homogenizationCentrifugeIntensityPressureConflictingOptions,
			invalidExtractionMethodOptions,
			solidPhaseExtractionConflictingOptions,
			mbsMethodsConflictingOptions,
			purificationInvalidOptions
		}
	}]];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> preResolvedOptions,
		Tests -> Flatten[{
			optionPrecisionTests,
			discardedTest,
			deprecatedTest,
			solidMediaTest,
			methodConflictingOptionsTest,
			dehydrationSolutionVolumeWarningTest,
			methodTargetConflictingOptionsTest,
			repeatedLysisOptionsTest,
			unlysedCellsOptionsTest,
			lysateHomogenizationConflictingOptionsTest,
			homogenizationPurificationConflictingOptionTest,
			homogenizationTechniqueInstrumentConflictingOptionsTest,
			homogenizationCentrifugeIntensityPressureConflictingOptionsTest,
			methodValidityTest,
			solidPhaseExtractionConflictingOptionsTests,
			mbsMethodsConflictingOptionsTest,
			purificationTests
		}]
	}
];

(* ::Subsection::Closed:: *)
(* extractRNAResourcePackets *)


(* --- extractRNAResourcePackets --- *)

DefineOptions[
	extractRNAResourcePackets,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

extractRNAResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		safeOps, inheritedCache, fastCacheBall, currentSimulation, resolvedPreparation, expandedInputs, expandedResolvedOptions,
		resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, samplePackets, methodObjects, methodPackets, uniqueSamplesInResources,
		samplesInResources, sampleContainersIn, uniqueSampleContainersInResources, containersInResources, mapThreadFriendlyPreResolvedOptions,
		userSpecifiedLabels, protocolPacket, containerOutMapThreadFriendlyOptions, resolvedContainerOut, allResourceBlobs,resourcesOk,resourceTests,previewRule, optionsRule,testsRule,resultRule,
		allUnitOperationPackets, unitOperationResolvedOptions, resolvedContainersOutWithWellsRemoved, resolvedContainerOutWell, resolvedIndexedContainerOut, fullyResolvedOptions, runTime,

		(*messages*)
		noExtractRNAStepSamples, noExtractRNAStepTest, mapThreadFriendlyResolvedOptionsWithoutSolventAdditions, mapThreadFriendlyResolvedOptions, lysisConflictingOptions, lysisConflictingOptionsTest,
		lyseTargetMismatchedOptions, lyseTargetConflictingOptionsTest, conflictingLysisOutputOptions, conflictingLysisOutputOptionsTest, lysateHomogenizationConflictingOptions, lysateHomogenizationConflictingOptionsTest, homogenizationTechniqueInstrumentConflictingOptions,
		homogenizationTechniqueInstrumentConflictingOptionsTest, homogenizationCentrifugeIntensityPressureConflictingOptions, homogenizationCentrifugeIntensityPressureConflictingOptionsTest, homogenizationPurificationConflictingOptionSamples, homogenizationPurificationConflictingOptionTest,
		purificationConflictingOptions, purificationConflictingOptionsTests,
		liquidLiquidExtractionTests, liquidLiquidExtractionInvalidOptions,
		invalidOptions
	},

	(* get the safe options for this function *)
	safeOps = SafeOptions[extractRNAResourcePackets,ToList[ops]];

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[safeOps],Cache,{}];
	fastCacheBall = makeFastAssocFromCache[inheritedCache];

	(* Get the simulation *)
	currentSimulation=Lookup[ToList[safeOps],Simulation,{}];

	(* Lookup the resolved Preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentExtractRNA, {mySamples}, myResolvedOptions];

	(* Correct expansion of SolventAdditions. *)
	(* NOTE:This is needed because SolventAdditions is not correctly expanded by ExpandIndexMatchedInputs. *)
	expandedResolvedOptions = expandSolventAdditionsOption[mySamples, myResolvedOptions, expandedResolvedOptions, LiquidLiquidExtractionSolventAdditions, NumberOfLiquidLiquidExtractions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentExtractRNA,
		RemoveHiddenOptions[ExperimentExtractRNA,myResolvedOptions],
		Ignore->myTemplatedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Download *)
	samplePackets=fetchPacketFromFastAssoc[#, fastCacheBall]& /@ mySamples;
	methodObjects = Replace[Lookup[myResolvedOptions, Method], {Custom -> Null}, 2];
	methodPackets = If[NullQ[#], Null, fetchPacketFromFastAssoc[#, fastCacheBall]]& /@ methodObjects;

	(* Create resources for our samples in. *)
	uniqueSamplesInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&)/@DeleteDuplicates[Download[mySamples, Object]];
	samplesInResources = (Download[mySamples, Object])/.uniqueSamplesInResources;

	(* Create resources for our containers in. *)
	sampleContainersIn = Lookup[samplePackets, Container];
	uniqueSampleContainersInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&)/@DeleteDuplicates[sampleContainersIn];
	containersInResources = (Download[sampleContainersIn, Object])/.uniqueSampleContainersInResources;

	(* Get our map thread friendly options. *)
	mapThreadFriendlyPreResolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, myResolvedOptions];

	(* Correctly make SolventAdditions mapThreadFriendly if specified by user. *)
	(* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
	mapThreadFriendlyPreResolvedOptions = Experiment`Private`mapThreadFriendlySolventAdditions[myResolvedOptions, mapThreadFriendlyPreResolvedOptions, LiquidLiquidExtractionSolventAdditions];


	(* Get our user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			myResolvedOptions,
			{
				ExtractedRNALabel, ExtractedRNAContainerLabel,
				PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel, PostClarificationPelletLabel, PostClarificationPelletContainerLabel, LysisAliquotContainerLabel, ClarifiedLysateContainerLabel, SampleOutLabel,
				ImpurityLayerLabel, ImpurityLayerContainerLabel,
				PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel,
				MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel,
				MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel,
				MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel,
				MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel
			}
		],
		_String
	];

	(* --- Create the protocol packet --- *)
	(* make unit operation packets for the UOs we just made here *)
	{protocolPacket, allUnitOperationPackets, currentSimulation, runTime} = Module[
		{
			sampleLabels, workingSamples, extractedRNALabels, extactedRNAContainers, extractedRNAContainerWell, extractedRNAIndexedContainers, extractedRNAContainerLabels,
			labelSamplesUnitOperations, lyseUnitOperation, lyseBools, homogenizeLysateUnitOperations, dehydrationUnitOperations,
			purificationUnitOperations, primitives, roboticUnitOperationPackets, roboticRunTime, roboticSimulation, outputUnitOperationPacket
		},

		(* Create a list of SamplesIn labels to be used internally *)
		sampleLabels = Table[
			CreateUniqueLabel["SampleIn for ExtractRNA", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
			{x, 1, Length[mySamples]}
		];

		(*get resolved containersOut, extractedRNALabels and extractedRNAContainerLabels*)
		extractedRNALabels = Lookup[myResolvedOptions, ExtractedRNALabel];
		extactedRNAContainers = Lookup[myResolvedOptions, ContainerOut];(*this could be in any of the acceptable input patterns for the container*)
		extractedRNAContainerWell = Lookup[myResolvedOptions, ContainerOutWell];
		extractedRNAIndexedContainers = Lookup[myResolvedOptions, IndexedContainerOut];(*use this when we need to know that the container is in {_Integer,ObjectP} pattern}*)
		extractedRNAContainerLabels = Lookup[myResolvedOptions, ExtractedRNAContainerLabel];

		(* LabelContainer and LabelSample unit operations *)
		labelSamplesUnitOperations = {
			(* label SamplesIn using the sampleLabels we created above *)
			LabelSample[
				Label -> sampleLabels,
				Sample -> mySamples
			]
		};

		(* Make a list of working samples which can be updated as the samples go through the unit operations *)
		workingSamples = sampleLabels;

		(* lyse cells unit operation *)
		{workingSamples, lyseUnitOperation} = Module[{},

			lyseBools = Lookup[myResolvedOptions, Lyse];

			If[MemberQ[lyseBools, True],
				Module[{lysedSamples, preFilteredLyseOptions, lysisOptions},

					lysedSamples = MapThread[
						Function[{sample, lyseQ},
							If[
								MatchQ[lyseQ, True],
								CreateUniqueLabel["lysed sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
								sample
							]
						],
						{
							workingSamples,
							lyseBools
						}
					];

					(* gather the options we're passing into the Lyse UO; any Automatics that Lyse doesn't like as Automatic are changed to the default *)
					preFilteredLyseOptions = <|
						Sample -> PickList[workingSamples, lyseBools],
						Sequence @@ KeyValueMap[
							Function[{key, value},
								value -> PickList[Lookup[expandedResolvedOptions, key], lyseBools](*Lookup[options, key]*)
							],
							Association @ KeyDrop[$LyseCellsSharedOptionsMap, {RoboticInstrument, TargetCellularComponent}]
						],
						RoboticInstrument -> Lookup[myResolvedOptions, RoboticInstrument],
						NumberOfReplicates -> Null,
						TargetCellularComponent -> RNA,
						SampleOutLabel -> PickList[lysedSamples, lyseBools]
					|>;
					lysisOptions = removeConflictingNonAutomaticOptions[LyseCells, Normal[preFilteredLyseOptions, Association]];


					(*our output of this Module is this list of the new lysed sample label and the LyseCells unit operation call*)
					{
						lysedSamples,
						LyseCells[lysisOptions]
					}
				],
				(*otherwise if no samples are being lysed, return the same sampleLabels and an empty list for the unit operation*)
				{workingSamples, {}}
			]
		];

		(* homogenize lysate unit operations*)
		{workingSamples, homogenizeLysateUnitOperations} = Module[{homogenizeBools},

			homogenizeBools = Lookup[myResolvedOptions, HomogenizeLysate];

			If[MemberQ[homogenizeBools, True],
				Module[{homogenizedSamples, preFilteredHomogenizeLysateOptions, homogenizationOptions},

					homogenizedSamples = MapThread[
						Function[{sample, homogenizeLysateQ},
							If[MatchQ[homogenizeLysateQ, True],
								CreateUniqueLabel["homogenized sample", Simulation -> currentSimulation, UserSpecifiedLabels -> userSpecifiedLabels],
								sample
							]
						],
						{workingSamples, homogenizeBools}
					];

					(* gather the options we're passing into the HomogenizeLysate UO; any Automatics that Filter doesn't like as Automatic are changed to the default *)
					preFilteredHomogenizeLysateOptions = <|
						Sample -> PickList[workingSamples, homogenizeBools],
						Sequence @@ KeyValueMap[
							Function[{key, value},
								value -> PickList[Lookup[expandedResolvedOptions, key], homogenizeBools]
							],
							Association @ $HomogenizationOptionMap
						],
						PrewetFilter -> False,
						WashRetentate -> False,
						RetentateWashVolume -> Null,
						Volume -> All,
						FiltrateLabel -> PickList[homogenizedSamples, homogenizeBools]
					|>;
					homogenizationOptions = removeConflictingNonAutomaticOptions[Precipitate, Normal[preFilteredHomogenizeLysateOptions, Association]];

					{
						homogenizedSamples,
						Filter[homogenizationOptions]
					}
				],
				{workingSamples, {}}
			]
		];

		(* dehydration unit operations *)
		dehydrationUnitOperations = Module[{dehydrationBools},

			dehydrationBools = MatchQ[#, ObjectP[{Object[Sample], Model[Sample]}]]& /@ Lookup[expandedResolvedOptions, DehydrationSolution];

			If[MemberQ[dehydrationBools, True],
				{
					Transfer[
						Source -> PickList[Lookup[expandedResolvedOptions, DehydrationSolution], dehydrationBools],
						Destination -> PickList[workingSamples, dehydrationBools],
						Amount -> PickList[Lookup[expandedResolvedOptions, DehydrationSolutionVolume], dehydrationBools]
					],

					Mix[
						Sample -> PickList[workingSamples, dehydrationBools],
						MixType -> PickList[Lookup[expandedResolvedOptions, DehydrationSolutionMixType], dehydrationBools],
						NumberOfMixes -> PickList[Lookup[expandedResolvedOptions, NumberOfDehydrationSolutionMixes], dehydrationBools],
						MixVolume -> PickList[Lookup[expandedResolvedOptions, DehydrationSolutionMixVolume], dehydrationBools],
						MixRate -> PickList[Lookup[expandedResolvedOptions, DehydrationSolutionMixRate], dehydrationBools],
						Time -> PickList[Lookup[expandedResolvedOptions, DehydrationSolutionMixTime], dehydrationBools]
					]
				},
				{}
			]
		];

		(* Purification unit operations *)
		(* Purification unit operations work in the following way: *)
		(* Figure out what container we are in before purification rounds begin. *)
		(* In the first round, the samples will either be in the initial sample in container, *)
		(* or in the ContainerOut from LyseCells, or the collection container from HomogenizeLysate. *)
		(* Get purificationRound and purificationTechnique lists to Map through each Technique during each Round, *)
		(* for any samples that have that Technique set for that Round. *)
		(* Map through the maximum number of purification rounds that any sample has set. *)
		(* In each purificationRound, Map through the purificationTechniques. *)
		(* Update the sample and container information to the ContainerOut from the purification technique. *)
		(* Each purification technique child function may create additional containers out for impurity layers, etc. *)
		{workingSamples, purificationUnitOperations} = If[MatchQ[Lookup[myResolvedOptions, Purification], ListableP[Null|None]],
			{workingSamples, {}},
			buildPurificationUnitOperations[
				workingSamples,
				myResolvedOptions,
				mapThreadFriendlyPreResolvedOptions,
				ExtractedRNAContainerLabel,
				ExtractedRNALabel,
				Cache -> inheritedCache,
				Simulation -> currentSimulation
			]
		];

		(* Combine all the unit operations *)
		primitives = Flatten[{
			labelSamplesUnitOperations,
			lyseUnitOperation,
			homogenizeLysateUnitOperations,
			dehydrationUnitOperations,
			purificationUnitOperations
		}];

		(* Set this internal variable to unit test the unit operations that are created by this function. *)
		$ExtractRNAUnitOperations = primitives;

		(* Get our robotic unit operation packets. *)
		(* quieting the warning about sterile transferring because LLE will likely not contaminate things when extracting RNA, but will cause the warning to get thrown *)
		(* there is no way around this because the phase separators are not sterile and we can't get a sterile one in hand.  For this case, we're deciding that that is ok *)
		{{roboticUnitOperationPackets, roboticRunTime}, roboticSimulation} = Quiet[
			ExperimentRoboticCellPreparation[
				primitives,
				UnitOperationPackets -> True,
				Output -> {Result, Simulation},
				FastTrack -> Lookup[expandedResolvedOptions, FastTrack],
				ParentProtocol -> Lookup[expandedResolvedOptions, ParentProtocol],
				Name -> Lookup[expandedResolvedOptions, Name],
				Simulation -> currentSimulation,
				Upload -> False,
				ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
				MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
				MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
				Priority -> Lookup[expandedResolvedOptions, Priority],
				StartDate -> Lookup[expandedResolvedOptions, StartDate],
				HoldOrder -> Lookup[expandedResolvedOptions, HoldOrder],
				QueuePosition -> Lookup[expandedResolvedOptions, QueuePosition],
				Instrument -> Lookup[expandedResolvedOptions, RoboticInstrument],
				CoverAtEnd -> False,
				Debug -> False
			],
			Warning::ConflictingSourceAndDestinationAsepticHandling
		];

		(* Create our own output unit operation packet, linking up the "sub" robotic unit operation objects. *)
		outputUnitOperationPacket = UploadUnitOperation[
			Module[{nonHiddenOptions},
				(* Only include non-hidden options from ExperimentExtractRNA. *)
				nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, ExtractRNA]];

				(* Override any options with resource. *)
				ExtractRNA@Join[
					Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
					{
						Sample -> samplesInResources,
						RoboticUnitOperations -> If[Length[roboticUnitOperationPackets] == 0,
							{},
							(Link /@ Lookup[roboticUnitOperationPackets, Object])
						]
					}
				]
			],
			UnitOperationType -> Output,
			Upload -> False
		];

		(* Simulate the resources for our main UO since it's now the only thing that doesn't have resources. *)
		roboticSimulation = UpdateSimulation[
			roboticSimulation,
			Simulation[<|Object -> Lookup[outputUnitOperationPacket, Object], Sample -> (Link /@ mySamples)|>]
		];

		(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
		roboticSimulation=If[Length[roboticUnitOperationPackets]==0,
			roboticSimulation,
			updateLabelFieldReferences[roboticSimulation,RoboticUnitOperations]
		];

		(* Return back our packets and simulation. *)
		{
			Null,
			Flatten[{outputUnitOperationPacket, roboticUnitOperationPackets}],
			roboticSimulation,
			(roboticRunTime + (10 Minute))
		}
	];

	unitOperationResolvedOptions = Module[{lyseSamples, LLESamples, SPESamples, precipitationSamples, MBSSamples, allSharedOptions, unNestedResolvedOptions},

		(* get the samples that are used in each step *)
		(* first get the lysed samples *)
		lyseSamples = PickList[mySamples, Lookup[expandedResolvedOptions, Lyse]];

		(* now get the samples for each purification step *)
		{
			LLESamples,
			SPESamples,
			precipitationSamples,
			MBSSamples
		} = Map[
			Function[{purification},
				Module[{sampleBools},

					sampleBools = Map[
						MemberQ[#, purification]&,
						Lookup[expandedResolvedOptions, Purification]
					];

					PickList[mySamples, sampleBools]
				]
			],
			{
				LiquidLiquidExtraction,
				SolidPhaseExtraction,
				Precipitation,
				MagneticBeadSeparation
			}
		];

		(* call shared function to pull out resolved options from unit operations and change Automatics to Nulls for any steps that are not used *)
		allSharedOptions = optionsFromUnitOperation[
			allUnitOperationPackets,
			{
				Object[UnitOperation, LyseCells],
				Object[UnitOperation, LiquidLiquidExtraction],
				Object[UnitOperation, SolidPhaseExtraction],
				Object[UnitOperation, Precipitate],
				Object[UnitOperation, MagneticBeadSeparation]
			},
			mySamples,
			{
				lyseSamples,
				LLESamples,
				SPESamples,
				precipitationSamples,
				MBSSamples
			},
			myResolvedOptions,
			mapThreadFriendlyPreResolvedOptions,
			{
				Normal[KeyDrop[$LyseCellsSharedOptionsMap, {Method, RoboticInstrument, SampleOutLabel}], Association],
				$LLEPurificationOptionMap,
				$SPEPurificationOptionMap,
				$PrecipitationSharedOptionMap,
				$MBSPurificationOptionMap
			},
			{
				MemberQ[Lookup[myResolvedOptions, Lyse], True],
				MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[LiquidLiquidExtraction]],
				MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[SolidPhaseExtraction]],
				MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[Precipitation]],
				MemberQ[Flatten[ToList[Lookup[myResolvedOptions, Purification]]], ListableP[MagneticBeadSeparation]]
			}
		];

		unNestedResolvedOptions = unNestResolvedPurificationOptions[Flatten[allSharedOptions]]

	];

	(* -- RESOLVE OUTPUT & LABELING OPTIONS -- *)

	(* Combine already resolved options and make them mapThreadFriendly. *)
	containerOutMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentExtractRNA,
		ReplaceRule[
			myResolvedOptions,
			unitOperationResolvedOptions
		]
	];

	(* Pull out ContainerOut option from purification resolved options for label resolution. *)
	resolvedContainerOut = MapThread[
		Function[{sample, options},
			Module[{},

				(* See if ContainerOut is already set or not. If it's Automatic, then resolve it.*)
				If[
					MatchQ[Lookup[options, ContainerOut], Automatic],
					Module[{lyseQ, homogenizeQ, purificationOption},

						(* Pull out master switch resolutions (for each step of the extraction). *)
						{lyseQ, homogenizeQ, purificationOption} = Lookup[options, {Lyse, HomogenizeLysate, Purification}];

						(* Go into that step's options (from the pulled out options or unit operation) and pull out the final container. *)
						Which[
							(* If Lysis is the last step and the lysate is neither aliquotted nor clarified, then it stays in it's original container. *)
							And[
								MatchQ[{lyseQ, homogenizeQ, purificationOption}, {True, False, None}],
								MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}],{False, False}]
							],
								{Download[sample, Well, Cache -> inheritedCache], Download[Download[sample, Container, Cache -> inheritedCache], Object]},
							(* If Lysis is the last step and the lysate is aliquotted but not clarified, then the sample is last in the LysisAliquotContainer. *)
							And[
								MatchQ[{lyseQ, homogenizeQ, purificationOption}, {True, False, None}],
								MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}],{True, False}]
							],
								Lookup[options, LysisAliquotContainer],
							(* If Lysis is the last step and the lysate is clarified, then the sample is last in the ClarifiedLysateContainer. *)
							And[
								MatchQ[{lyseQ, homogenizeQ, purificationOption}, {True, False, None}],
								MatchQ[Lookup[options, ClarifyLysate], True]
							],
								Lookup[options, ClarifiedLysateContainer],
							(* If Homogenization is the last step, then the container is pulled out of the filter unit operation. *)
							And[
								MatchQ[{homogenizeQ, purificationOption}, {True, None}]
							],
								Module[{allUnitOperations, homogenizedSamples, unitOperationPosition, unitOperationOptions},

									(* Pull out unit operation types. *)
									allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

									(* Pull out all homogenized samples. *)
									homogenizedSamples = PickList[mySamples, Lookup[expandedResolvedOptions, HomogenizeLysate]];

									(* Find the position of the UO of interest. *)
									unitOperationPosition = {First[Flatten[Position[allUnitOperations, Object[UnitOperation, Filter]]]]};

									(* Find the resolved options of the UO. *)
									unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

									(* Pull out the final container of the HomogenizeLysate step for this sample. *)
									Extract[
										Lookup[unitOperationOptions, FiltrateContainerOut],
										Position[homogenizedSamples, sample]
									][[1]]
								],
							(* If LLE is the last step, then container can be pulled out of unit operation options. *)
							MatchQ[Last[ToList[purificationOption]], LiquidLiquidExtraction],
								Module[{allUnitOperations, lleSamples, unitOperationPosition, unitOperationOptions},

									(* Pull out unit operation types. *)
									allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

									(* Pull out all samples that use LLE. *)
									lleSamples = PickList[mySamples, Map[MemberQ[#, LiquidLiquidExtraction]&, Lookup[expandedResolvedOptions, Purification]]];

									(* Find the position of the UO of interest. *)
									unitOperationPosition = {Last[Flatten[Position[allUnitOperations, Object[UnitOperation, LiquidLiquidExtraction]]]]};

									(* Find the resolved options of the UO. *)
									unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

									(* Pull out the final container of the LLE step for this sample. *)
									{
										Extract[
											Lookup[unitOperationOptions, TargetContainerOutWell],
											Position[lleSamples, sample]
										][[1]],
										Extract[
											Lookup[unitOperationOptions, TargetContainerOut],
											Position[lleSamples, sample]
										][[1]]
									}

								],
							(* If Precipitation is the last step and the target is liquid, then ContainerOut is the UnprecipitatedSampleContainerOut. *)
							And[
								MatchQ[Last[ToList[purificationOption]], Precipitation],
								MatchQ[Lookup[options, PrecipitationTargetPhase], Liquid]
							],
								Lookup[options, UnprecipitatedSampleContainerOut],
							(* If Precipitation is the last step and the target is solid, then ContainerOut is the PrecipitatedSampleContainerOut. *)
							And[
								MatchQ[Last[ToList[purificationOption]], Precipitation],
								MatchQ[Lookup[options, PrecipitationTargetPhase], Solid]
							],
								Lookup[options, PrecipitatedSampleContainerOut],
							(* If SPE is the last step and ExtractionStrategy is Positive, then ContainerOut is taken from the unit operation options. *)
							And[
								MatchQ[Last[ToList[purificationOption]], SolidPhaseExtraction],
								MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Positive]
							],
								Module[{allUnitOperations, speSamples, unitOperationPosition, unitOperationOptions},

									(* Pull out unit operation types. *)
									allUnitOperations = Lookup[#, Type] & /@ allUnitOperationPackets;

									(* Pull out all samples that use LLE. *)
									speSamples = PickList[mySamples, Map[MemberQ[#, SolidPhaseExtraction]&,Lookup[expandedResolvedOptions, Purification]]];

									(* Find the position of the UO of interest. *)
									unitOperationPosition = {Last[Flatten[Position[allUnitOperations, Object[UnitOperation, SolidPhaseExtraction]]]]};

									(* Find the resolved options of the UO. *)
									unitOperationOptions = Lookup[Extract[allUnitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

									(* Pull out the final container of the SPE step for this sample. *)
									Extract[
										Lookup[unitOperationOptions, ElutingSolutionCollectionContainer],
										Position[speSamples, sample]
									][[1]]

								],
							(* If SPE is the last step and ExtractionStrategy is Negative, then ContainerOut is the SolidPhaseExtractionLoadingFlowthroughContainerOut. *)
							And[
								MatchQ[Last[ToList[purificationOption]], SolidPhaseExtraction],
								MatchQ[Lookup[options, SolidPhaseExtractionStrategy], Negative]
							],
								Lookup[options, SolidPhaseExtractionLoadingFlowthroughContainerOut],
							(* If MBS is the last step and SelectionStrategy is Positive, then ContainerOut is the ElutionCollectionContainer. *)
							And[
								MatchQ[Last[ToList[purificationOption]], MagneticBeadSeparation],
								MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Positive]
							],
								Lookup[options, MagneticBeadSeparationElutionCollectionContainer],
							(* If MBS is the last step and SelectionStrategy is Negative, then ContainerOut is the LoadingCollectionContainer. *)
							And[
								MatchQ[Last[ToList[purificationOption]], MagneticBeadSeparation],
								MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Negative]
							],
								Lookup[options, MagneticBeadSeparationLoadingCollectionContainer],
							(* Otherwise, just set to whatever ContainerOut is as a backup. *)
							True,
								Lookup[options, ContainerOut]
						]
					],
					Lookup[options, ContainerOut]
				]
			]
		],
		{mySamples, containerOutMapThreadFriendlyOptions}
	];

	(* Remove any wells from user-specified container out inputs according to their widget patterns. *)
	resolvedContainersOutWithWellsRemoved = Map[
		Which[
			(* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
			MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
				Last[#],
			(* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
			MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
				Last[#],
			(* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
			True,
				#
		]&,
		resolvedContainerOut
	];

	(*Resolve the ContainerOutWell and the indexed version of the container out (without a well).*)
	{resolvedContainerOutWell, resolvedIndexedContainerOut} = Module[
		{wellsFromContainersOut, uniqueContainers, containerToFilledWells, containerToWellOptions, containerToIndex},

		(* Get any wells from user-specified container out inputs according to their widget patterns. *)
		wellsFromContainersOut = Map[
			Which[
				(* If ContainerOut specified using the "Container with Well" widget format, extract the well. *)
				MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
					First[#],
				(* If ContainerOut specified using the "Container with Well and Index" widget format, extract the well. *)
				MatchQ[#, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
					First[#],
				(* Otherwise, there isn't a well specified and we set this to automatic. *)
				True,
					Automatic
			]&,
			resolvedContainerOut
		];

		(*Make an association of the containers with their already specified wells.*)
		uniqueContainers = DeleteDuplicates[Cases[resolvedContainersOutWithWellsRemoved, Alternatives[ObjectP[Object[Container]],ObjectP[Model[Container]],{_Integer, ObjectP[Model[Container]]}]]];

		containerToFilledWells = Map[
			Module[
				{uniqueContainerWells},

				(*Check if the container is a non-indexed model or non-indexed object. If so, then don't need to "reserve" wells*)
				(*because a new container will be used for each sample for non-indexed model and non-indexed object will be filled below.*)
				If[
					MatchQ[#[[1]], _Integer] || MatchQ[#, ObjectP[Object[Container]]],
					Module[{},

						(*MapThread through the wells and containers. Return the well if the container is the one being sorted.*)
						uniqueContainerWells = MapThread[
							Function[
								{well, container},
								If[
									MatchQ[container, #] && !MatchQ[well, Automatic],
									well,
									Nothing
								]
							],
							{wellsFromContainersOut, resolvedContainersOutWithWellsRemoved}
						];

						(*Return rule in the form of indexed container model to Filled wells.*)
						If[
							MatchQ[#[[1]], _Integer],
							# -> uniqueContainerWells,
							{1,#} -> uniqueContainerWells
						]

					],
					Nothing
				]

			]&,
			uniqueContainers
		];


		(*Determine all of the options that the well can be in this container and put into a rule list.*)
		containerToWellOptions = Map[
			Module[
				{containerModel},

				(*Get the container model to look up the available wells.*)
				containerModel =
					Which[
						(*If the container without a well is just a container model, then that can be used directly.*)
						MatchQ[#, ObjectP[Model[Container]]],
							#,
						(*If the container is an object, then the model is downloaded from the cache.*)
						MatchQ[#, ObjectP[Object[Container]]],
							Download[#, Model],
						(*If the container is an indexed container model, then the model is the second element.*)
						True,
							#[[2]]
					];

				(*The well options are downloaded from the cache from the container model.*)
				# -> Flatten[Transpose[AllWells[containerModel]]]

			]&,
			uniqueContainers
		];

		(*Create a rule list to keep track of the index of the model containers that are being filled.*)
		containerToIndex = Map[
			If[
				MatchQ[#, ObjectP[Model[Container]]],
				# -> 1,
				Nothing
			]&,
			uniqueContainers
		];

		(*MapThread through containers without wells and wells. If resolving needed, finds next available well, resolves it and adds to "taken" wells.*)
		(*Also adds indexing to container if not already indexed.*)
		Transpose[MapThread[
			Function[
				{well,container},
				Module[
					{indexedContainer},

					(*Add index to container if not already indexed.*)
					indexedContainer = Which[
						(*If the container without a well is a non-indexed container model, then a new container is indexed.*)
						MatchQ[container, ObjectP[Model[Container]]],
							Module[
								{},

								(*Moves up the index until the container model index is not already assigned.*)
								While[
									KeyExistsQ[containerToFilledWells,{Lookup[containerToIndex,container],container}],
									containerToIndex = ReplaceRule[containerToIndex, container -> (Lookup[containerToIndex, container]+1)]
								];

								{Lookup[containerToIndex,container],container}

							],
						MatchQ[container, ObjectP[Object[Container]]],
							{1, container},
						True,
							container
					];

					(*Check if the well is already set and doesn't need resolution.*)
					If[
						MatchQ[well, Automatic] && MatchQ[container, Except[Automatic]],
						Module[
							{filledWells,  wellOptions, availableWells, selectedWell},

							(*Pull out the already filled wells from containerToFilledWells so that we don't assign this sample *)
							(*to an already filled well.*)
							filledWells = Lookup[containerToFilledWells, Key[indexedContainer], {}];

							(*Pull out all of the options that the well can be in this container.*)
							wellOptions = Lookup[containerToWellOptions, Key[container]];

							(*Remove filled wells from the well options*)
							(*NOTE:Can't just use compliment because it messes with the order of wellOptions which has already been optimized for the liquid handlers.*)
							availableWells = UnsortedComplement[wellOptions, filledWells];

							(*Select the first well in availableWells to put the sample into.*)
							selectedWell = Which[
								(*If there is an available well, then fill it.*)
								MatchQ[availableWells, Except[{}]],
									First[availableWells],
								(*If there is not an available well and the container is not an object or indexed container, then clear the filled wells and start a new list.*)
								MatchQ[availableWells, {}] && !MatchQ[container, ObjectP[Object[Container]]|{_Integer, ObjectP[Model[Container]]}],
									Module[
										{},

										containerToFilledWells = ReplaceRule[containerToFilledWells, {indexedContainer -> {}}];

										"A1"

									],
								(*If there is not an available well and the container is an object or indexed container, then just set to A1.*)
								(*NOTE:At this point, the object container or indexed container model is full, so just set to A1 and will be caught by error checking.*)
								True,
									"A1"
							];



							(*Now that this well is filled, added to list of filled wells.*)
							containerToFilledWells = If[
								KeyExistsQ[containerToFilledWells, indexedContainer],
								ReplaceRule[containerToFilledWells, {indexedContainer -> Append[filledWells,selectedWell]}],
								Append[containerToFilledWells, indexedContainer -> Append[filledWells,selectedWell]]
							];

							(*Return the selected well and the indexed container.*)
							{selectedWell, indexedContainer}

						],
						Module[
							{},

							(*If the container has a new index (non-indexed container model to start), then*)
							(*added to the containerToFilledWells list.*)
							If[
								MatchQ[container, ObjectP[Model[Container]]],
								containerToFilledWells = Append[containerToFilledWells, indexedContainer -> {well}]
							];

							(*Return the user-specified well and the indexed container.*)
							{well, indexedContainer}

						]
					]
				]

			],
			{wellsFromContainersOut, resolvedContainersOutWithWellsRemoved}
		]]

	];


	(* replaced the pre-resolved options with the resolved options that were pulled out of the unit operations *)
	fullyResolvedOptions = ReplaceRule[
		myResolvedOptions,
		Flatten[{
			unitOperationResolvedOptions,
			ContainerOut -> resolvedContainerOut,
			ContainerOutWell -> resolvedContainerOutWell,
			IndexedContainerOut -> resolvedIndexedContainerOut
		}]
	];


	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*Get map thread friendly resolved options for use in options checks*)
	mapThreadFriendlyResolvedOptionsWithoutSolventAdditions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, fullyResolvedOptions];

	(* Correctly make SolventAdditions mapThreadFriendly. *)
	(* NOTE:This need to be done because OptionsHandling`Private`mapThreadOptions doesn't work correctly on SolventAdditions option. *)
	mapThreadFriendlyResolvedOptions = Experiment`Private`mapThreadFriendlySolventAdditions[fullyResolvedOptions, mapThreadFriendlyResolvedOptionsWithoutSolventAdditions, LiquidLiquidExtractionSolventAdditions];

	(* There should be at least one step in the extraction process (lysis, homogenization, dehydration, or any of the four purification techniques) specified (error) *)
	noExtractRNAStepSamples = MapThread[
		Function[{sample, mapThreadResolvedOptions, index},
			If[
				And[
					MatchQ[Lookup[mapThreadResolvedOptions, Lyse], False],
					MatchQ[Lookup[mapThreadResolvedOptions, DehydrationSolution], Null],
					MatchQ[Lookup[mapThreadResolvedOptions, HomogenizeLysate], False],
					MatchQ[Lookup[mapThreadResolvedOptions, Purification], (None | Null)]
				],
				{sample, index},
				Nothing
			]
		],
		{mySamples, mapThreadFriendlyResolvedOptions, Range[Length[mySamples]]}
	];

	If[Length[noExtractRNAStepSamples]>0 && messages,
		Message[
			Error::NoExtractRNAStepsSet,
			ObjectToString[noExtractRNAStepSamples[[All,1]], Cache -> inheritedCache],
			noExtractRNAStepSamples[[All,2]]
		];
	];

	noExtractRNAStepTest=If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = noExtractRNAStepSamples[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> inheritedCache] <> " have at least one step (Lysis, Homogenization, Purification) set in order to extract RNA from the sample:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> inheritedCache] <> " have at least one step (Lysis, Homogenization, Purification) set in order to extract RNA from the sample:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check if RoboticInstrument is set to BioSTAR if the CellType is set to Mammalian or the CellType field in Object[Sample] contains only mammalian cells (Warning)*)
	(*check if RoboticInstrument is set to MicrobioSTAR if the CellType is set to Microbial, Yeast, or Unspecified or the CellType field in Object[Sample] contains Microbial, Yeast, or Unspecified (Error)*)

	(*check if Lysis options are set when Lyse is false*)
	{lysisConflictingOptions, lysisConflictingOptionsTest} = checkLysisConflictingOptions[
		mySamples,
		mapThreadFriendlyResolvedOptions,
		messages,
		Cache -> inheritedCache
	];

	(*check if Lyse is set to false when TargetRNA is set to CellFreeRNA (Warning)*)
	lyseTargetMismatchedOptions = MapThread[
		Function[{sample, options, index},
			If[
				MatchQ[Lookup[options, Lyse], True] && MatchQ[Lookup[options, TargetRNA], CellFreeRNA],
				{sample,index},
				Nothing
			]
		],
		{mySamples, mapThreadFriendlyResolvedOptions, Range[Length[mySamples]]}
	];

	If[Length[lyseTargetMismatchedOptions] > 0 && messages,
		Message[
			Warning::CellFreeLysis,
			ObjectToString[lyseTargetMismatchedOptions[[All, 1]], Cache -> inheritedCache],
			lyseTargetMismatchedOptions[[All, 2]]
		];
	];

	lyseTargetConflictingOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = lyseTargetMismatchedOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Warning["The sample(s) "<>ObjectToString[affectedSamples, Cache -> inheritedCache]<>"have Lyse set to False if TargetRNA is set to CellFreeLysis:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Warning["The sample(s) "<>ObjectToString[Complement[mySamples, affectedSamples], Cache -> inheritedCache]<>"have Lyse set to False if TargetRNA is set to CellFreeLysis:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*check that if lyse is the final step being done for the sample, that there is no conflict in the ContainerOut, container out labels, and which containers are being set as container out (eg AliquotContainer vs ClarifiedLysateContainer)*)
	conflictingLysisOutputOptions = MapThread[
		Function[{sample, samplePacket, options, index},
			Module[{lyseLastStepQ, startingContainer},

				lyseLastStepQ = MatchQ[Lookup[options, {Lyse, HomogenizeLysate, Purification}], {True, False, None}];

				startingContainer = {Lookup[samplePacket, Position], Download[Lookup[samplePacket, Container], Object]};

				Which[
					(*If Lyse is the last step, and there is no aliquoting or clarifying lysate, the ContainerOut should match the starting container*)
					lyseLastStepQ && MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}], {False, False}] && !MatchQ[startingContainer, Lookup[options, ContainerOut]],
						{
							sample,
							index,
							Lookup[options, LysisAliquot],
							Lookup[options, ClarifyLysate],
							"SampleIn Container",
							startingContainer,
							{ContainerOut},
							Lookup[options, ContainerOut]
						},
					(*If Lyse is the last step, and there is aliquoting but no clarifying lysate, the ContainerOut should match the aliquot container*)
					lyseLastStepQ && MatchQ[Lookup[options, {LysisAliquot, ClarifyLysate}], {True, False}] && !MatchQ[Lookup[options, LysisAliquotContainer], Lookup[options, ContainerOut]],
						{
							sample,
							index,
							Lookup[options, LysisAliquot],
							Lookup[options, ClarifyLysate],
							{LysisAliquotContainer},
							Lookup[options, LysisAliquotContainer],
							{ContainerOut},
							Lookup[options, ContainerOut]
						},
					(*If Lyse is the last step, and ClarifyLysate is true, the ContainerOut should match the clarified lysate container*)
					lyseLastStepQ && MatchQ[Lookup[options, ClarifyLysate], True] && !MatchQ[Lookup[options, {ClarifiedLysateContainer, ClarifiedLysateContainerLabel}], Lookup[options, {ContainerOut, ExtractedRNAContainerLabel}]],
						{
							sample,
							index,
							Lookup[options, LysisAliquot],
							Lookup[options, ClarifyLysate],
							{ClarifiedLysateContainer, ClarifiedLysateContainerLabel},
							Lookup[options, {ClarifiedLysateContainer, ClarifiedLysateContainerLabel}],
							{ContainerOut, ExtractedRNAContainerLabel},
							Lookup[options, {ContainerOut, ExtractedRNAContainerLabel}]
						},
					True,
					Nothing
				]
			]
		],
		{mySamples, samplePackets, mapThreadFriendlyResolvedOptions, Range[Length[mySamples]]}
	];

	(* If there are samples with conflicting lysis options and we are throwing messages, throw an error message *)
	If[Length[conflictingLysisOutputOptions] > 0 && messages,
		Message[Error::ConflictingLysisOutputOptions,
			ObjectToString[conflictingLysisOutputOptions[[All, 1]], Cache -> inheritedCache],
			conflictingLysisOutputOptions[[All, 2]],
			conflictingLysisOutputOptions[[All, 3]],
			conflictingLysisOutputOptions[[All, 4]],
			conflictingLysisOutputOptions[[All, 5]],
			conflictingLysisOutputOptions[[All, 6]],
			conflictingLysisOutputOptions[[All, 7]],
			conflictingLysisOutputOptions[[All, 8]]
		]
	];

	conflictingLysisOutputOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingLysisOutputOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> inheritedCache] <> " do not have any conflicts between SampleOut options and lysis options if lysis is the last step of the extraction:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> inheritedCache] <> " do not have any conflicts between SampleOut options and lysis options if lysis is the last step of the extraction:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* Purification conflicting options check - checks that all options for a purification technique should be Null if that purification technique is not called *)
	{purificationConflictingOptions, purificationConflictingOptionsTests} = checkPurificationConflictingOptions[
		mySamples,
		mapThreadFriendlyResolvedOptions,
		messages,
		Cache -> inheritedCache
	];

	(*Check that all of the LLE options are valid.*)
	{liquidLiquidExtractionTests, liquidLiquidExtractionInvalidOptions} = liquidLiquidExtractionSharedOptionsTests[
		mySamples,
		samplePackets,
		fullyResolvedOptions,
		gatherTests,
		Cache -> inheritedCache
	];

	(* -- INVALID OPTION CHECK -- *)

	invalidOptions = DeleteDuplicates[Flatten[{
		If[Length[noExtractRNAStepSamples]>0,
			{Lyse, HomogenizeLysate, DehydrationSolution, Purification},
			{}
		],
		If[Length[conflictingLysisOutputOptions] > 0,
			{Sequence @@ {conflictingLysisOutputOptions[[All, 5]], conflictingLysisOutputOptions[[All, 7]]}},
			{}
		],
		If[Length[lysateHomogenizationConflictingOptions]>0,
			{lysateHomogenizationConflictingOptions[[All, 3]]},
			{}
		],
		If[Length[homogenizationTechniqueInstrumentConflictingOptions]>0,
			{homogenizationTechniqueInstrumentConflictingOptions[[All, 2]]},
			{}
		],
		If[Length[homogenizationCentrifugeIntensityPressureConflictingOptions]>0,
			{homogenizationCentrifugeIntensityPressureConflictingOptions[[All, 2]]},
			{}
		],
		Sequence@@{lysisConflictingOptions, purificationConflictingOptions, liquidLiquidExtractionInvalidOptions}
	}]];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Make list of all the resources we need to check in FRQ *)
	allResourceBlobs = If[MatchQ[resolvedPreparation, Manual],
		DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]],
		{}
	];

	(* Verify we can satisfy all our resources *)
	{resourcesOk, resourceTests} = Which[
		(* NOTE: If we're robotic, the framework will call FRQ for us. *)
		MatchQ[$ECLApplication,Engine] || MatchQ[resolvedPreparation, Robotic],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Cache->inheritedCache,Simulation->currentSimulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Messages->messages,Cache->inheritedCache,Simulation->currentSimulation],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[
		gatherTests,
		Flatten[{
			resourceTests,
			noExtractRNAStepTest,
			lysisConflictingOptionsTest,
			conflictingLysisOutputOptionsTest,
			lysateHomogenizationConflictingOptionsTest,
			homogenizationTechniqueInstrumentConflictingOptionsTest,
			homogenizationCentrifugeIntensityPressureConflictingOptionsTest,
			purificationConflictingOptionsTests,
			liquidLiquidExtractionTests
		}],
		{}
	];

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output,Result] && TrueQ[resourcesOk],
		{Flatten[{protocolPacket, allUnitOperationPackets}], currentSimulation, runTime, fullyResolvedOptions},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentExtractRNA,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

(*Do not need myProtocolPacket input since its robotic only*)
simulateExperimentExtractRNA[
	myUnitOperationPackets:({PacketP[]..} | $Failed),
	mySamples : {ObjectP[Object[Sample]]..},
	myResolvedOptions : ({_Rule...} | $Failed),
	myResolutionOptions : OptionsPattern[simulateExperimentExtractRNA]
]:=Module[
	{
		cache,simulation,protocolObject,currentSimulation,simulationWithLabels
	},

	(* Lookup our cache and simulation and make our fast association *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Create our protocol ID *)
	protocolObject = SimulateCreateID[Object[Protocol,RoboticCellPreparation]];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = Which[MatchQ[myUnitOperationPackets, {PacketP[]..}],
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		Module[{protocolPacket},
			protocolPacket = <|
				Object -> protocolObject,
				Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
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
				ResolvedOptions -> {}
			|>;

			SimulateResources[
				protocolPacket,
				myUnitOperationPackets,
				ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
				Simulation -> Lookup[ToList[myResolutionOptions],Simulation, Null]
			]
		],

		(*Otherwise, something went wrong *)
		True,
			SimulateResources[
				<|
					Object->protocolObject,
					Replace[SamplesIn]->(Link[#,Protocols]&)/@mySamples,
					If[MatchQ[myResolvedOptions, {Rule..}],
						ResolvedOptions->myResolvedOptions,
						ResolvedOptions->{}
					]
				|>,
				Cache->cache,
				Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
			]
	];

	(* Uploaded Labels *)

	simulationWithLabels = If[MatchQ[myResolvedOptions, {Rule..}],
		Simulation[
			Labels->Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, ExtractedRNALabel], mySamples}],
					{_String, ObjectP[]}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, ExtractedRNAContainerLabel], mySamples}],
					{_String, ObjectP[]}
				]
			],
			LabelFields->Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, ExtractedRNALabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, ExtractedRNAContainerLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				]
			]
		],
		Simulation[]
	];
	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];