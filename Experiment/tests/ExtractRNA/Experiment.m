(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentExtractRNA: Tests*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentExtractRNA*)

DefineTests[ExperimentExtractRNA,
	{

		(* Basic examples *)
		Example[{Basic, "Extract RNA from a sample containing living cells:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Lyse -> True,
					Purification -> {LiquidLiquidExtraction, Precipitation}
				}]
			},
			TimeConstraint -> 4000
		],

		Example[{Basic, "Extract RNA from multiple living cell samples containing different cell types:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Lyse -> True,
					Purification -> {LiquidLiquidExtraction, Precipitation}
				}]
			},
			TimeConstraint -> 4000
		],

		Example[{Basic, "Extract RNA from a sample containing lysed cells (cell lysate):"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Lyse -> False,
					Purification -> {LiquidLiquidExtraction, Precipitation}
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Basic, "A sample containing a crude RNA extract can be further purified using the isolation steps available in ExperimentExtractRNA:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Lyse -> False
				}]
			},
			TimeConstraint -> 1200
		],

		(*Additional examples*)


		(*Options*)
		Example[{Options, Method, "A Method can be specified, which contains a pre-set protocol for RNA Extraction:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Method -> Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
				LysisSolutionVolume -> 300 Microliter,
				DehydrationSolutionVolume -> 200 Microliter,
				DehydrationSolution -> Model[Sample, "Milli-Q water"],
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Method -> ObjectP[Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID]],
					CellType -> Mammalian,
					TargetRNA -> TotalRNA,
					Lyse -> True,
					HomogenizeLysate -> True,
					Purification -> {SolidPhaseExtraction}
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, Method, "If Method is not specified by the user, a default Method for the TargetRNA is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				TargetRNA -> mRNA,
				LysisSolutionVolume -> 200 Microliter,
				DehydrationSolutionVolume -> 100 Microliter,
				SolidPhaseExtractionLoadingSampleVolume -> 250 Microliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Method -> ObjectP[Object[Method, Extraction, RNA, "id:BYDOjvDalnkE"]](*Object[Method, Extraction, RNA, "mRNA Extraction from Live Mammalian Cell using Solid Phase Extraction"]*)
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, TargetRNA, "A TargetRNA can be identified, and a corresponding Method will be suggested if no Method has been selected:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				TargetRNA -> mRNA,
				LysisSolutionVolume -> 200 Microliter,
				DehydrationSolutionVolume -> 100 Microliter,
				SolidPhaseExtractionLoadingSampleVolume -> 250 Microliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					TargetRNA -> mRNA,
					Method -> ObjectP[Object[Method, Extraction, RNA]]
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, TargetRNA, "TargetRNA is set to Unspecified if not specified by the user:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				TargetRNA -> Automatic,
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					TargetRNA -> Unspecified
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, RoboticInstrument, "The bioSTAR liquid handler is used for samples that contain only living Mammalian cells:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"]](*bioSTAR*)
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, RoboticInstrument, "The microBioSTAR liquid handler is used for samples that contain Bacterial or Yeast cells:"},
			ExperimentExtractRNA[
				Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					RoboticInstrument -> ObjectP[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"]](*microbioSTAR*)
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, WorkCell, "WorkCell is set to bioSTAR if the input sample contains only Mammalian cells:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					WorkCell -> bioSTAR
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, WorkCell, "WorkCell is set to microbioSTAR if the input sample contains anything other than Mammalian cells:"},
			ExperimentExtractRNA[
				Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					WorkCell -> microbioSTAR
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, ContainerOut, "ContainerOut is automatically set to the container that the sample was in for the last step of the extraction unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					ContainerOut -> {_String, {_Integer, ObjectP[{Object[Container], Model[Container]}]}},
					IndexedContainerOut -> {_Integer, ObjectP[{Object[Container], Model[Container]}]}
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, ExtractedRNALabel, "ExtractedRNALabel is automatically generated if it is not otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					ExtractedRNALabel -> _String
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, ExtractedRNAContainerLabel, "ExtractedRNAContainerLabel is automatically generated if it is not otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				ExtractedRNAContainerLabel -> _String
			}]},
			TimeConstraint -> 1800
		],

		Example[{Options, Lyse, "Samples containing living cells are lysed prior to extraction and purification steps:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Lyse -> True
				}]
			},
			TimeConstraint -> 1600
		],

		Example[{Options, Lyse, "Samples that do not contain living cells (eg. lysate samples or crude RNA extract samples) are not lysed prior to extraction and purification steps:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					Lyse -> False
				}]
			},
			TimeConstraint -> 1600
		],



		(* --- LYSIS SHARED OPTIONS TESTS --- *)

		(* -- CellType Tests -- *)
		Example[{Options, CellType, "If the CellType field of the sample is specified, CellType is set to that value:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				CellType -> Mammalian
			}]}
		],
		Example[{Options, CellType, "If the CellType field of the input sample is Unspecified, automatically set to the majority cell type of the input sample based on its composition:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Living cell sample with unspecified cell type for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				CellType -> Bacterial
			}]},
			Messages :> {Warning::UnknownCellType}
		],

		(* -- CultureAdhesion Tests -- *)
		Example[{Options, CultureAdhesion, "CultureAdhesion is automatically set to the value in the CultureAdhesion field of the sample:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				CultureAdhesion -> Adherent
			}]}
		],

		(* -- Dissociate Tests -- *)
		Example[{Options, Dissociate, "If CultureAdhesion is Adherent and LysisAliquot is True, then Dissociate is set to True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				CultureAdhesion -> Adherent,
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				Dissociate -> True
			}]}
		],
		Example[{Options, Dissociate, "If CultureAdhesion is Suspension, then Dissociate is set to False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				CultureAdhesion -> Suspension,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				Dissociate -> False
			}]}
		],
		Example[{Options, Dissociate, "If CultureAdhesion is Adherent but LysisAliquot is False, then Dissociate is set to False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				CultureAdhesion -> Adherent,
				LysisAliquot -> False,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				Dissociate -> False
			}]}
		],


		(* -- NumberOfLysisSteps Tests -- *)
		Example[{Options, NumberOfLysisSteps, "If any tertiary lysis steps are set, then NumberOfLysisSteps will be set to 3:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryLysisTemperature -> Ambient,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				NumberOfLysisSteps -> 3
			}]}
		],
		Example[{Options, NumberOfLysisSteps, "If any secondary lysis steps are specified but no tertiary lysis steps are set, then NumberOfLysisSteps will be set to 2:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryLysisTemperature -> Ambient,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				NumberOfLysisSteps -> 2
			}]}
		],
		Example[{Options, NumberOfLysisSteps, "If no secondary nor tertiary lysis steps are set, then NumberOfLysisSteps will be set to 1:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				NumberOfLysisSteps -> 1
			}]}
		],

		(* -- LysisAliquot Tests -- *)
		Example[{Options, LysisAliquot, "If LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration are specified, LysisAliquot is set to True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotAmount -> 0.1 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquot -> True
			}]}
		],
		Example[{Options, LysisAliquot, "If no aliquotting options are set (LysisAliquotAmount, LysisAliquotContainer, TargetCellCount, or TargetCellConcentration), LysisAliquot is set to False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquot -> False
			}]}
		],
		Example[{Options, LysisAliquot, "LysisAliquotAmount and LysisAliquotContainer must not be Null if LysisAliquot is True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotAmount -> GreaterP[0 Microliter],
				LysisAliquotContainer -> (ObjectP[Model[Container]] | {_Integer, ObjectP[Model[Container]]})
			}]}
		],
		Example[{Options, LysisAliquot, "LysisAliquotAmount and LysisAliquotContainer must be Null if LysisAliquot is False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> False,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotAmount -> Null,
				LysisAliquotContainer -> Null
			}]}
		],

		(* -- LysisAliquotAmount Tests -- *)
		Example[{Options, LysisAliquotAmount, "If LysisAliquot is set to True and TargetCellCount is set, LysisAliquotAmount will be set to attain the target cell count:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TargetCellCount -> 10^9 EmeraldCell,
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotAmount -> EqualP[0.1 Milliliter]
			}]}
		],
		Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer is specified but TargetCellCount is not specified, LysisAliquotAmount will be set to All if the input sample is less than half of the LysisAliquotContiner's max volume:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotAmount -> EqualP[0.2 Milliliter]
			}]}
		],
		Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer is specified but TargetCellCount is not specified, LysisAliquotAmount will be set to half of the LysisAliquotContiner's max volume if the input sample volume is greater than that value:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				(* NOTE:Solution volume required to avoid low volume warning *)
				LysisSolutionVolume -> 150 Microliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotAmount -> EqualP[150 Microliter]
			}]}
		],
		Example[{Options, LysisAliquotAmount, "If LysisAliquotContainer and TargetCellCount are not specified, LysisAliquotAmount will be set to 25% of the input sample volume:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotAmount -> EqualP[0.05 Milliliter]
			}]}
		],

		(* -- LysisAliquotContainer Tests -- *)
		(* -- LysisAliquotContainerLabel Tests -- *)
		Example[{Options, {LysisAliquotContainer, LysisAliquotContainerLabel}, "If LysisAliquot is True, LysisAliquotContainer will be assigned by PackContainers and LysisAliquotContainerLabel will be automatically generated:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisAliquotContainer -> ObjectP[Model[Container, Vessel, "id:o1k9jAG00e3N"]],(*Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]*)
				LysisAliquotContainerLabel -> (_String)
			}]}
		],

		(* -- PreLysisPellet Tests -- *)
		Example[{Options, PreLysisPellet, "If any pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisPelletingTime -> 1 Minute,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPellet -> True
			}]}
		],
		Example[{Options, PreLysisPellet, "If no pre-lysis pelleting options are specified (PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, or PreLysisSupernatantContainer), PreLysisPellet is set to False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPellet -> False
			}]}
		],
		Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must not be Null if PreLysisPellet is True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisPellet -> True,
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPelletingCentrifuge -> ObjectP[{Object[Instrument], Model[Instrument]}],
				PreLysisPelletingIntensity -> GreaterP[0 RPM],
				PreLysisPelletingTime -> GreaterP[0 Second],
				PreLysisSupernatantVolume -> GreaterP[0 Microliter],
				PreLysisSupernatantStorageCondition -> (SampleStorageTypeP|Disposal),
				PreLysisSupernatantContainer -> {_Integer, ObjectP[Model[Container]]}
			}]}
		],
		Example[{Options, PreLysisPellet, "PreLysisPelletingCentrifuge, PreLysisPelletingIntensity, PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, and PreLysisSupernatantContainer must be Null if PreLysisPellet is False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisPellet -> False,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPelletingCentrifuge -> Null,
				PreLysisPelletingIntensity -> Null,
				PreLysisPelletingTime -> Null,
				PreLysisSupernatantVolume -> Null,
				PreLysisSupernatantStorageCondition -> Null,
				PreLysisSupernatantContainer -> Null
			}]}
		],

		(* -- PreLysisPelletingCentrifuge Tests -- *)
		(* -- PreLysisPelletingIntensity Tests -- *)
		Example[{Options, {PreLysisPelletingIntensity, PreLysisPelletingCentrifuge}, "If PreLysisPellet is set to True and CellType is Mammalian, PreLysisPelletCentrifugeIntensity is automatically set to 1560 RPM and PreLysisPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				CellType -> Mammalian,
				PreLysisPellet -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPelletingIntensity -> EqualP[1560 RPM],
				PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]] (* Model[Instrument, Centrifuge, "HiG4"] *)
			}]}
		],
		Example[{Options, {PreLysisPelletingIntensity, PreLysisPelletingCentrifuge}, "If PreLysisPellet is set to True and CellType is Bacterial, PreLysisPelletCentrifugeIntensity is automatically set to 4030 RPM and PreLysisPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID]
				},
				CellType -> Bacterial,
				PreLysisPellet -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPelletingIntensity -> EqualP[4030 RPM],
				PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]] (* Model[Instrument, Centrifuge, "HiG4"] *)
			}]}
		],
		(* NOTE:Yeast cells currently not supported, but test will be needed when it is supported. *)
		Example[{Options, {PreLysisPelletingIntensity, PreLysisPelletingCentrifuge}, "If PreLysisPellet is set to True and CellType is Yeast, PreLysisPelletCentrifugeIntensity is automatically set to 2850 RPM and PreLysisPelletCentrifuge is automatically set to Model[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				CellType -> Yeast,
				PreLysisPellet -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPelletingIntensity -> EqualP[2850 RPM],
				PreLysisPelletingCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]] (* Model[Instrument, Centrifuge, "HiG4"] *)
			}]}
		],

		(* -- PreLysisPelletingTime Tests -- *)
		(* -- PreLysisSupernatantVolume Tests -- *)
		(* -- PreLysisSupernatantStorageCondition Tests -- *)
		(* -- PreLysisSupernatantContainer Tests -- *)
		Example[{Options, {PreLysisPelletingTime, PreLysisSupernatantVolume, PreLysisSupernatantStorageCondition, PreLysisSupernatantContainer}, "If PreLysisPellet is set to True, PreLysisPelletCentrifugeTime is automatically set to 10 minutes, PreLysisSupernatantVolume is automatically set to 80% of the of total volume, PreLysisSupernatantStorageCondition is automatically set to Disposal, and PreLysisSupernatantContainer is automatically set by PackContainers unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisPellet -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisPelletingTime -> 10 Minute,
				PreLysisSupernatantVolume -> EqualP[0.16 Milliliter],
				PreLysisSupernatantStorageCondition -> Disposal,
				PreLysisSupernatantContainer -> {(_Integer), ObjectP[Model[Container]]}
			}]}
		],

		(* -- PreLysisSupernatantLabel Tests -- *)
		(* -- PreLysisSupernatantContainerLabel Tests -- *)
		Example[{Options, {PreLysisSupernatantLabel, PreLysisSupernatantContainerLabel}, "If PreLysisPellet is set to True, PreLysisSupernatantLabel and PreLysisSupernatantContainerLabel will be automatically generated:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisPellet -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisSupernatantLabel -> (_String),
				PreLysisSupernatantContainerLabel -> (_String)
			}]}
		],

		(* -- PreLysisDilute Tests -- *)
		Example[{Options, PreLysisDilute, "If either PreLysisDiluent or PreLysisDilutionVolume are set, then PreLysisDilute is automatically set to True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisDilutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisDilute -> True
			}]}
		],
		Example[{Options, PreLysisDilute, "PreLysisDiluent and PreLysisDilutionVolume must be Null if PreLysisDilute is False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisDilute -> False,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisDiluent -> Null,
				PreLysisDilutionVolume -> Null
			}]}
		],

		(* -- PreLysisDilutionVolume Tests -- *)
		Example[{Options, {PreLysisDiluent, PreLysisDilutionVolume}, "If PreLysisDilute is set to True, PreLysisDiluent is automatically set to Model[Sample, StockSolution, \"1x PBS from 10X stock\"] and PreLysisDilutionVolume is set to the volume required to attain the TargetCellConcentration (if TargetCellConcentration is specified):"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				PreLysisDilute -> True,
				TargetCellConcentration -> 5 * 10^9 EmeraldCell/Milliliter,
				LysisAliquot -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				PreLysisDiluent -> ObjectP[Model[Sample, StockSolution, "id:9RdZXv1KejGK"]], (* Model[Sample, StockSolution, "1x PBS from 10X stock, Alternative Preparation 1"] *)
				PreLysisDilutionVolume -> EqualP[0.05 Milliliter]
			}]}
		],

		(* -- LysisSolution Tests -- *)
		(* NOTE:Should be customized for the experiment this is used for. *)
		Example[{Options, LysisSolution, "Unless otherwise specified, LysisSolution is automatically set according to the combination of CellType and TargetCellularComponents:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisSolution -> ObjectP[Model[Sample]]
			}]}
		],

		(* -- LysisSolutionVolume Tests -- *)
		Example[{Options, LysisSolutionVolume, "If LysisAliquot is False, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> False,
				NumberOfLysisSteps -> 1,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisSolutionVolume -> EqualP[0.9 Milliliter]
			}]}
		],
		Example[{Options, LysisSolutionVolume, "If LysisAliquotContainer is set, LysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				NumberOfLysisSteps -> 1,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisSolutionVolume -> EqualP[0.9 Milliliter]
			}]}
		],
		Example[{Options, LysisSolutionVolume, "If LysisAliquot is True and LysisAliquotContainer is not set, LysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> True,
				LysisAliquotAmount -> 0.1 Milliliter,
				NumberOfLysisSteps -> 1,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisSolutionVolume -> EqualP[0.9 Milliliter]
			}]}
		],


		(* -- LysisMixType Tests -- *)
		Example[{Options, LysisMixType, "If LysisMixVolume or NumberOfLysisMixes are specified, LysisMixType is automatically set to Pipette:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				NumberOfLysisMixes -> 3,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixType -> Pipette
			}]}
		],
		Example[{Options, LysisMixType, "If LysisMixRate, LysisMixTime, or LysisMixInstrument are specified, LysisMixType is automatically set to Shake:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisMixTime -> 1 Minute,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixType -> Shake
			}]}
		],
		Example[{Options, LysisMixType, "If no mixing options are set and the sample will be mixed in a plate, LysisMixType is automatically set to Shake:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixType -> Shake
			}]}
		],

		Example[{Options, LysisMixType, "If no mixing options are set and the sample will be mixed in a tube, LysisMixType is automatically set to Pipette:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixType -> Pipette
			}]}
		],

		(* -- LysisMixRate Tests -- *)
		Example[{Options, {LysisMixRate, LysisMixTime, LysisMixTemperature, LysisMixInstrument}, "If LysisMixType is set to Shake, LysisMixRate is automatically set to 200 RPM, LysisMixTime is automatically set to 1 minute, and LysisMixInstrument is automatically set to an available shaking device compatible with the specified LysisMixRate and LysisMixTemperature:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisMixType -> Shake,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixRate -> EqualP[200 RPM],
				LysisMixTime -> EqualP[1 Minute],
				LysisMixTemperature -> Ambient,
				LysisMixInstrument -> ObjectP[Model[Instrument]]
			}]}
		],

		(* -- LysisMixVolume Tests -- *)
		Example[{Options, {LysisMixVolume, NumberOfLysisMixes, LysisMixTemperature}, "If LysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, LysisMixVolume is automatically set to 50% of the total solution volume and NumberOfLysisMixes is automatically set to 10, and LysisMixTemperature is automatically set to Null unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisMixType -> Pipette,
				LysisSolutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixVolume -> EqualP[0.2 Milliliter],
				NumberOfLysisMixes -> 10,
				LysisMixTemperature -> Null
			}]}
		],

		Example[{Options, {LysisMixVolume, NumberOfLysisMixes, LysisMixTemperature}, "If LysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, LysisMixVolume is automatically set to 970 microliters and NumberOfLysisMixes is automatically set to 10, LysisMixTemperature is automatically set to Null unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisMixType -> Pipette,
				LysisSolutionVolume -> 1.8 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisMixVolume -> EqualP[0.970 Milliliter],
				NumberOfLysisMixes -> 10,
				LysisMixTemperature -> Null
			}]}
		],

		(* -- LysisTime Tests -- *)
		(* -- LysisTemperature Tests -- *)
		(* -- LysisIncubationInstrument Tests -- *)
		Example[{Options, {LysisTime, LysisTemperature, LysisIncubationInstrument}, "LysisTime is automatically set to 15 minutes, LysisTemperature is automatically set to Ambient, and LysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified LysisTemperature unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				LysisTime -> EqualP[15 Minute],
				LysisTemperature -> Ambient,
				LysisIncubationInstrument -> ObjectP[Model[Instrument]]
			}]}
		],

		(* -- SecondaryLysisSolution Tests -- *)
		(* NOTE:Should be customized for the experiment this is used for. *)
		Example[{Options, SecondaryLysisSolution, "Unless otherwise specified, SecondaryLysisSolution is the same as LysisSolution:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				NumberOfLysisSteps -> 2,
				LysisSolution -> Model[Sample, StockSolution, "Protein Lysis Buffer"],
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisSolution -> ObjectP[Model[Sample, StockSolution, "Protein Lysis Buffer"]]
			}]}
		],

		(* -- SecondaryLysisSolutionVolume Tests -- *)
		Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1 and LysisAliquot is False, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				NumberOfLysisSteps -> 2,
				LysisAliquot -> False,
				LysisSolutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter]
			}]}
		],
		Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1 and LysisAliquotContainer is set, SecondaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of any lysis solutions) divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				NumberOfLysisSteps -> 2,
				LysisSolutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisSolutionVolume -> EqualP[0.4 Milliliter]
			}]}
		],
		Example[{Options, SecondaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 1, LysisAliquot is True, and LysisAliquotContainer is not set, SecondaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> True,
				NumberOfLysisSteps -> 2,
				LysisAliquotAmount -> 0.1 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisSolutionVolume -> EqualP[0.45 Milliliter]
			}]}
		],

		(* -- SecondaryLysisMixType Tests -- *)
		Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixVolume or SecondaryNumberOfLysisMixes are specified, SecondaryLysisMixType is automatically set to Pipette:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryNumberOfLysisMixes -> 3,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixType -> Pipette
			}]}
		],
		Example[{Options, SecondaryLysisMixType, "If SecondaryLysisMixRate, SecondaryLysisMixTime, or SecondaryLysisMixInstrument are specified, SecondaryLysisMixType is automatically set to Shake:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryLysisMixTime -> 1 Minute,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixType -> Shake
			}]}
		],
		Example[{Options, SecondaryLysisMixType, "If NumberOfLysisSteps is greater than 1, no mixing options are set, and the sample will be mixed in a plate, SecondaryLysisMixType is automatically set to Shake:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				NumberOfLysisSteps -> 2,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixType -> Shake
			}]}
		],
		Example[{Options, SecondaryLysisMixType, "If NumberOfLysisSteps is greater than 1, no mixing options are set, and the sample will be mixed in a tube, SecondaryLysisMixType is automatically set to Pipette:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
				NumberOfLysisSteps -> 2,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixType -> Pipette
			}]}
		],

		(* -- SecondaryLysisMixRate Tests -- *)
		(* -- SecondaryLysisMixTime Tests -- *)
		(* -- SecondaryLysisMixTemperature Tests -- *)
		(* -- SecondaryLysisMixInstrument Tests -- *)
		Example[{Options, {SecondaryLysisMixRate, SecondaryLysisMixTime, SecondaryLysisMixTemperature, SecondaryLysisMixInstrument}, "If SecondaryLysisMixType is set to Shake, SecondaryLysisMixRate is automatically set to 200 RPM, SecondaryLysisMixTime is automatically set to 1 minute, SecondaryLysisMixTemperature is automatically set to Ambient, and SecondaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified SecondaryLysisMixRate and SecondaryLysisMixTemperature unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryLysisMixType -> Shake,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixRate -> EqualP[200 RPM],
				SecondaryLysisMixTime -> EqualP[1 Minute],
				SecondaryLysisMixTemperature -> Ambient,
				SecondaryLysisMixInstrument -> ObjectP[Model[Instrument]]
			}]}
		],

		(* -- SecondaryNumberOfLysisMixes Tests -- *)
		Example[{Options, SecondaryNumberOfLysisMixes, "If SecondaryLysisMixType is set to Pipette, SecondaryNumberOfLysisMixes is automatically set to 10:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryLysisMixType -> Pipette,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryNumberOfLysisMixes -> 10
			}]}
		],

		(* -- SecondaryLysisMixVolume Tests -- *)
		Example[{Options, SecondaryLysisMixVolume, "If SecondaryLysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, SecondaryLysisMixVolume is automatically set to 50% of the total solution volume:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryLysisMixType -> Pipette,
				LysisSolutionVolume -> 0.2 Milliliter,
				SecondaryLysisSolutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixVolume -> EqualP[0.3 Milliliter]
			}]}
		],
		Example[{Options, SecondaryLysisMixVolume, "If SecondaryLysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, SecondaryLysisMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				SecondaryLysisMixType -> Pipette,
				LysisSolutionVolume -> 0.9 Milliliter,
				SecondaryLysisSolutionVolume -> 0.9 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisMixVolume -> EqualP[0.970 Milliliter]
			}]}
		],

		(* -- SecondaryLysisTime Tests -- *)
		(* -- SecondaryLysisTemperature Tests -- *)
		(* -- SecondaryLysisIncubationInstrument Tests -- *)
		Example[{Options, {SecondaryLysisTime, SecondaryLysisTemperature, SecondaryLysisIncubationInstrument}, "If NumberOfLysisSteps is greater than 1, SecondaryLysisTime is automatically set to 15 minutes, SecondaryLysisTemperature is automatically set to Ambient, and SecondaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified SecondaryLysisTemperature unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				NumberOfLysisSteps -> 2,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				SecondaryLysisTime -> EqualP[15 Minute],
				SecondaryLysisTemperature -> Ambient,
				SecondaryLysisIncubationInstrument -> ObjectP[Model[Instrument]]
			}]}
		],

		(* -- TertiaryLysisSolution Tests -- *)
		(* NOTE:Should be customized for the experiment this is used for. *)
		Example[{Options, TertiaryLysisSolution, "If NumberOfLysisSteps is greater than 2, TertiaryLysisSolution is the same as LysisSolution unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				NumberOfLysisSteps -> 3,
				LysisSolution -> Model[Sample, StockSolution, "Protein Lysis Buffer"],
				TertiaryLysisSolutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisSolution -> ObjectP[Model[Sample, StockSolution, "Protein Lysis Buffer"]]
			}]},
			TimeConstraint -> 1600
		],

		(* -- TertiaryLysisSolutionVolume Tests -- *)
		Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2 and LysisAliquot is False, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the sample's container divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				NumberOfLysisSteps -> 3,
				LysisAliquot -> False,
				LysisSolutionVolume -> 0.3 Milliliter,
				SecondaryLysisSolutionVolume -> 0.3 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter]
			}]},
			TimeConstraint -> 1600
		],
		Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2 and LysisAliquotContainer is set, TertiaryLysisSolutionVolume is automatically set to 50% of the unoccupied volume of the LysisAliquotContainer (prior to addition of the TertiaryLysisSolutionVolume) divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				NumberOfLysisSteps -> 3,
				LysisSolutionVolume -> 0.3 Milliliter,
				SecondaryLysisSolutionVolume -> 0.3 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisSolutionVolume -> EqualP[0.2 Milliliter]
			}]},
			TimeConstraint -> 1600
		],
		Example[{Options, TertiaryLysisSolutionVolume, "If NumberOfLysisSteps is greater than 2, LysisAliquot is True, and LysisAliquotContainer is not set, TertiaryLysisSolutionVolume is automatically set to nine times the LysisAliquotAmount divided by the NumberOfLysisSteps:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquot -> True,
				NumberOfLysisSteps -> 3,
				LysisAliquotAmount -> 0.1 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisSolutionVolume -> EqualP[0.3 Milliliter]
			}]},
			TimeConstraint -> 1600
		],

		(* -- TertiaryLysisMixType Tests -- *)
		Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixVolume or TertiaryNumberOfLysisMixes are specified, TertiaryLysisMixType is automatically set to Pipette:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryNumberOfLysisMixes -> 3,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixType -> Pipette
			}]},
			TimeConstraint -> 1600
		],
		Example[{Options, TertiaryLysisMixType, "If TertiaryLysisMixRate, TertiaryLysisMixTime, or TertiaryLysisMixInstrument are specified, TertiaryLysisMixType is automatically set to Shake:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryLysisMixTime -> 1 Minute,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixType -> Shake
			}]},
			TimeConstraint -> 1600
		],
		Example[{Options, TertiaryLysisMixType, "If NumberOfLysisSteps is greater than 2, no mixing options are set, and the sample will be mixed in a plate, TertiaryLysisMixType is automatically set to Shake:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				NumberOfLysisSteps -> 3,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixType -> Shake
			}]},
			TimeConstraint -> 1600
		],
		Example[{Options, TertiaryLysisMixType, "If NumberOfLysisSteps is greater than 2, no mixing options are set, and the sample will be mixed in a tube, TertiaryLysisMixType is automatically set to Pipette:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				LysisAliquotContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],(*Model[Container, Vessel, "2mL Tube"]*)
				NumberOfLysisSteps -> 3,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixType -> Pipette
			}]},
			TimeConstraint -> 1600
		],

		(* -- TertiaryLysisMixRate Tests -- *)
		(* -- TertiaryLysisMixTime Tests -- *)
		(* -- TertiaryLysisMixTemperature Tests -- *)
		(* -- TertiaryLysisMixInstrument Tests -- *)
		Example[{Options, {TertiaryLysisMixRate, TertiaryLysisMixTime, TertiaryLysisMixTemperature, TertiaryLysisMixInstrument}, "If TertiaryLysisMixType is set to Shake, TertiaryLysisMixRate is automatically set to 200 RPM, TertiaryLysisMixTime is automatically set to 1 minute, TertiaryLysisMixTemperature is automatically set to Ambient, and TertiaryLysisMixInstrument is automatically set to an available shaking device compatible with the specified TertiaryLysisMixRate and TertiaryLysisMixTemperature unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryLysisMixType -> Shake,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixRate -> EqualP[200 RPM],
				TertiaryLysisMixTime -> EqualP[1 Minute],
				TertiaryLysisMixTemperature -> Ambient,
				TertiaryLysisMixInstrument -> ObjectP[Model[Instrument]]
			}]},
			TimeConstraint -> 1600
		],

		(* -- TertiaryNumberOfLysisMixes Tests -- *)
		Example[{Options, TertiaryNumberOfLysisMixes, "If TertiaryLysisMixType is set to Pipette, TertiaryNumberOfLysisMixes is automatically set to 10:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryLysisMixType -> Pipette,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryNumberOfLysisMixes -> 10
			}]},
			TimeConstraint -> 1600
		],

		(* -- TertiaryLysisMixVolume Tests -- *)
		Example[{Options, TertiaryLysisMixVolume, "If TertiaryLysisMixType is set to Pipette and 50% of the total solution volume is less than 970 microliters, TertiaryLysisMixVolume is automatically set to 50% of the total solution volume:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryLysisMixType -> Pipette,
				LysisSolutionVolume -> 0.2 Milliliter,
				SecondaryLysisSolutionVolume -> 0.2 Milliliter,
				TertiaryLysisSolutionVolume -> 0.2 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixVolume -> EqualP[0.4 Milliliter]
			}]},
			TimeConstraint -> 1600
		],
		Example[{Options, TertiaryLysisMixVolume, "If TertiaryLysisMixType is set to Pipette and 50% of the total solution volume is greater than 970 microliters, TertiaryLysisMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				TertiaryLysisMixType -> Pipette,
				LysisSolutionVolume -> 0.6 Milliliter,
				SecondaryLysisSolutionVolume -> 0.6 Milliliter,
				TertiaryLysisSolutionVolume -> 0.6 Milliliter,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisMixVolume -> EqualP[0.970 Milliliter]
			}]},
			TimeConstraint -> 1600
		],

		(* -- TertiaryLysisTime Tests -- *)
		(* -- TertiaryLysisTemperature Tests -- *)
		(* -- TertiaryLysisIncubationInstrument Tests -- *)
		Example[{Options, {TertiaryLysisTime, TertiaryLysisTemperature, TertiaryLysisIncubationInstrument}, "If NumberOfLysisSteps is greater than 2, TertiaryLysisTime is automatically set to 15 minutes, TertiaryLysisTemperature is automatically set to Ambient, and TertiaryLysisIncubationInstrument is automatically set to an integrated instrument compatible with the specified TertiaryLysisTemperature unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				NumberOfLysisSteps -> 3,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				TertiaryLysisTime -> EqualP[15 Minute],
				TertiaryLysisTemperature -> Ambient,
				TertiaryLysisIncubationInstrument -> ObjectP[Model[Instrument]]
			}]},
			TimeConstraint -> 1600
		],

		(* -- ClarifyLysate Tests -- *)
		Example[{Options, ClarifyLysate, "If any clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to True:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				ClarifyLysateTime -> 1 Minute,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				ClarifyLysate -> True
			}]}
		],
		Example[{Options, ClarifyLysate, "If no clarification options are set (ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume, ClarifiedLysateContainer, and PostClarificationPelletStorageCondition), then ClarifyLysate is set to False:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				Lyse -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				ClarifyLysate -> False
			}]}
		],

		(* -- ClarifyLysateCentrifuge Tests -- *)
		(* -- ClarifyLysateIntensity Tests -- *)
		(* -- ClarifyLysateTime Tests -- *)
		(* -- ClarifiedLysateVolume Tests -- *)
		Example[{Options, {ClarifyLysateCentrifuge, ClarifyLysateIntensity, ClarifyLysateTime, ClarifiedLysateVolume}, "If ClarifyLysate is set to True, ClarifyLysateCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"], ClarifyLysateIntensity is set to 5700 RPM, ClarifyLysateTime is set to 10 minutes, andClarifiedLysateVolume is set automatically set to 90% of the volume of the lysate:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID]
				},
				ClarifyLysate -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				ClarifyLysateCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "HiG4"]],
				ClarifyLysateIntensity -> EqualP[5700 RPM],
				ClarifyLysateTime -> EqualP[10 Minute],
				ClarifiedLysateVolume -> EqualP[0.99 Milliliter]
			}]}
		],

		(* -- PostClarificationPelletLabel Tests -- *)
		(* -- PostClarificationPelletStorageCondition Tests -- *)
		(* -- ClarifiedLysateContainer Tests -- *)
		(* -- ClarifiedLysateContainerLabel Tests -- *)
		Example[{Options, {ClarifiedLysateContainer, PostClarificationPelletStorageCondition, PostClarificationPelletLabel, ClarifiedLysateContainerLabel}, "If ClarifyLysate is True, ClarifiedLysateContainer will be automatically selected to accomadate the volume of the clarified lysate, PostClarificationPelletStorageCondition will be automatically set to Disposal, PostClarificationPelletLabel and ClarifiedLysateContainerLabel will be automatically generated unless otherwise specified:"},
			ExperimentExtractRNA[
				{
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID]
				},
				ClarifyLysate -> True,
				(* No purification steps to speed up testing. *)
				Purification -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{
				ClarifiedLysateContainer -> ObjectP[Model[Container]],
				PostClarificationPelletStorageCondition -> Disposal,
				PostClarificationPelletLabel -> (_String),
				ClarifiedLysateContainerLabel -> (_String)
			}]}
		],

		(* -- Homogenization Options --*)

		Example[{Options, HomogenizeLysate, "If the first Purification step is SolidPhaseExtraction, cell lysates are mechanically homogenized using a filter plate:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				LysisSolutionVolume -> 300 Microliter,
				DehydrationSolutionVolume -> 200 Microliter,
				Purification -> SolidPhaseExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizeLysate -> True
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, HomogenizeLysate, "If the first Purification step is not SolidPhaseExtraction and HomogenizeLysate is not specified, cell lysates are not homogenized:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				LysisSolutionVolume -> 300 Microliter,
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizeLysate -> False
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, {HomogenizationDevice, HomogenizationTechnique, HomogenizationTime}, "If HomogenizeLysate is set to True, a default HomogenizationDevice is set, HomogenizationTechnique is set to AirPressure, and HomogenizationTime is set to 1 Minute unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizeLysate -> True,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizationDevice -> ObjectP[Model[Container, Plate, Filter, "id:bq9LA09W8zBr"]],(*Model[Container, Plate, Filter, "96-well Homogenizer Plate"]*)
					HomogenizationTechnique -> AirPressure,
					HomogenizationTime -> 1 Minute
				}]
			},
			TimeConstraint -> 400
		],
    
		Example[{Options, HomogenizationInstrument, "If HomogenizationTechnique is AirPressure, the HomogenizationInstrument is the IntegratedPressureManifold of the RoboticInstrument:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizationTechnique -> AirPressure,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizationInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]](*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, HomogenizationInstrument, "If HomogenizationTechnique is Centrifuge, the HomogenizationInstrument is the IntegratedCentrifuge of the RoboticInstrument:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizationTechnique -> Centrifuge,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizationInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, HomogenizationCentrifugeIntensity, "Specifying HomogenizationCentrifugeIntensity sets HomogenizationTechnique to Centrifuge and HomogenizationInstrument to the IntegratedCentrifuge of the RoboticInstrument, if they are not already specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizationCentrifugeIntensity -> 2000 RPM,
				HomogenizationTechnique -> Automatic,
				HomogenizationInstrument -> Automatic,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizationTechnique -> Centrifuge,
					HomogenizationInstrument -> ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, HomogenizationPressure, "Specifying HomogenizationPressure sets HomogenizationTechnique to AirPressure and HomogenizationInstrument to the IntegratedPressureManifold of the RoboticInstrument, if they are not already specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizationPressure -> 40 PSI,
				HomogenizationTechnique -> Automatic,
				HomogenizationInstrument -> Automatic,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizationTechnique -> AirPressure,
					HomogenizationInstrument -> ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]](*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, HomogenizationTime, "If HomogenizationTime is specified, HomogenizeLysate is set to True:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizationTime -> 3 Minute,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					HomogenizeLysate -> True,
					HomogenizationTime -> 3 Minute
				}]
			},
			TimeConstraint -> 400
		],

		(* -- Dehydration Options --*)

		Example[{Options, DehydrationSolution, "If the first Purification step is SolidPhaseExtraction and no DehydrationSolution is selected, DehydrationSolution is set to Model[Sample,Stock Solution,\"70% Ethanol\"]:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolutionVolume -> 200 Microliter,
				Purification -> SolidPhaseExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					DehydrationSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]](*Model[Sample, StockSolution, "70% Ethanol"]*)
				}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, DehydrationSolution, "If any Dehydration options are set and DehydrationSolution is not specified, DehydrationSolution is set to Model[Sample,Stock Solution,\"70% Ethanol\"]:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolutionMixType -> Pipette,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					DehydrationSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]](*Model[Sample, StockSolution, "70% Ethanol"]*)
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, DehydrationSolutionVolume, "If DehydrationSolution is set, DehydrationSolutionVolume is set to match the SampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					DehydrationSolutionVolume -> EqualP[0.2 Milliliter]
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, DehydrationSolutionMixType, "DehydrationSolutionMixType is automatically set to Pipette if not specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					DehydrationSolutionMixType -> Pipette
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, {NumberOfDehydrationSolutionMixes, DehydrationSolutionMixRate}, "If DehydrationSolutionMixType is set to Pipette, NumberOfDehydrationSolutionMixes is set to 10 and DehydrationSolutionMixRate is set to Null:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolutionMixType -> Pipette,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					NumberOfDehydrationSolutionMixes -> 10,
					DehydrationSolutionMixRate -> Null
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, DehydrationSolutionMixVolume, "If DehydrationSolutionMixType is set to Pipette, DehydrationSolutionMixVolume is set to the lesser of 50% of the total volume of the sample containing DehydrationSolution or the MaxMicropipetteVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],
				DehydrationSolutionMixType -> Pipette,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					DehydrationSolutionMixVolume -> EqualP[0.2 Milliliter]
				}]
			},
			TimeConstraint -> 400
		],

		Example[{Options, {DehydrationSolutionMixRate, DehydrationSolutionMixTime}, "If DehydrationSolutionMixType is set to Shake, DehydrationSolutionMixRate is set to 100 RPM and DehydrationSolutionMixTime is set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolutionMixType -> Shake,
				Purification -> None,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					DehydrationSolutionMixRate -> 100 RPM,
					DehydrationSolutionMixTime -> 1 Minute
				}]
			},
			TimeConstraint -> 400
		],

		(* - Purification Option tests - *)

		Example[{Options,Purification, "If any liquid-liquid extraction options are set, then a liquid-liquid extraction will be added to the list of purification steps:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				Output->Options
			],
			KeyValuePattern[
				{
					Purification -> {LiquidLiquidExtraction}
				}
			],
			TimeConstraint -> 1200
		],
		Example[{Options,Purification, "If any precipitation options are set, then precipitation will be added to the list of purification steps:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				PrecipitationSeparationTechnique -> Filter,
				Output->Options
			],
			KeyValuePattern[
				{
					Purification -> {Precipitation}
				}
			],
			TimeConstraint -> 1200
		],
		Example[{Options,Purification, "If any solid phase extraction options are set, then a solid phase extraction will be added to the list of purification steps:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				SolidPhaseExtractionTechnique -> Pressure,
				Output->Options
			],
			KeyValuePattern[
				{
					Purification -> {SolidPhaseExtraction}
				}
			],
			TimeConstraint -> 1200
		],
		Example[{Options,Purification, "If any magnetic bead separation options are set, then a magnetic bead separation will be added to the list of purification steps:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixTime -> 5*Minute,
				Output->Options
			],
			KeyValuePattern[
				{
					Purification -> {MagneticBeadSeparation}
				}
			],
			TimeConstraint -> 1200
		],

		Example[{Options,Purification, "If options from multiple purification steps are specified, then they will be added to the purification step list in the order liquid-liquid extraction, precipitation, solid phase extraction, then magnetic bead separation:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixTime -> 5*Minute,
				SolidPhaseExtractionTechnique -> Pressure,
				PrecipitationNumberOfWashes -> 1,
				LiquidLiquidExtractionTechnique -> Pipette,
				Output->Options
			],
			KeyValuePattern[
				{
					Purification -> {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation}
				}
			],
			TimeConstraint -> 1200
		],
		Example[{Options,Purification, "If no options relating to purification steps are specified, then a liquid-liquid extraction followed by a precipitation will be used by default:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Output->Options
			],
			KeyValuePattern[
				{
					Purification -> {LiquidLiquidExtraction, Precipitation}
				}
			],
			TimeConstraint -> 1200
		],

		(* - Purification Errors - *)

		Example[{Messages, "LiquidLiquidExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 liquid-liquid extractions called for in the purification step list:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction},
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::LiquidLiquidExtractionStepCountLimitExceeded,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],
		Example[{Messages, "PurificationStepCountLimitExceeded", "An error is returned if there are more than 3 precipitations called for in the purification step list:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation, Precipitation, Precipitation, Precipitation},
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::PrecipitationStepCountLimitExceeded,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],
		Example[{Messages, "SolidPhaseExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 solid phase extractions called for in the purification step list:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction},
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::SolidPhaseExtractionStepCountLimitExceeded,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],
		Example[{Messages, "MagneticBeadSeparationStepCountLimitExceeded", "An error is returned if there are more than 3 magnetic bead separations called for in the purification step list:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation},
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::MagneticBeadSeparationStepCountLimitExceeded,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],

		(* Messages tests *)

		(* Invalid input messages*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentExtractRNA[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentExtractRNA[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentExtractRNA[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentExtractRNA[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"2mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{"A1", containerID},
					Upload -> False,
					Living->True,
					CultureAdhesion->Suspension,
					CellType->Bacterial,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 0.1 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentExtractRNA[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			TimeConstraint -> 600
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"2mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Living->True,
					CultureAdhesion->Suspension,
					CellType->Bacterial,
					Simulation -> simulationToPassIn,
					InitialAmount -> 0.1 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentExtractRNA[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			TimeConstraint -> 600
		],

		Example[{Messages, "DiscardedSample", "Return an error if given an object that is discarded:"},
			ExperimentExtractRNA[
				Object[Sample, "Discarded mammalian cell sample 5 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				Output -> Result
			],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			},
			TimeConstraint -> 1200
		],

		Example[{Messages, "InvalidSolidMediaSample", "Return an error if given a sample that is in solid media:"},
			ExperimentExtractRNA[
				Object[Sample, "Solid media bacteria cell sample 6 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				Output -> Result
			],
			$Failed,
			Messages :> {
				Error::InvalidSolidMediaSample,
				Error::InvalidInput
			},
			TimeConstraint -> 1200
		],

		(* Conflicting options messages *)
		Example[{Messages,"MethodTargetRNAMismatch","Return a warning if the specified method conflicts with the specified target RNA:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				TargetRNA -> tRNA,
				Method -> Object[Method, Extraction, RNA, "Test mRNA extraction method, Liquid Liquid Extraction (Test for ExperimentExtractRNA) "<>$SessionUUID],
				Output -> Result
			],
			$Failed,
			Messages:>{
				(*a warning is returned in addition to the method option conflict error, because the target RNA is an option in the method*)
				Error::MethodOptionConflict,
				Warning::MethodTargetRNAMismatch,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],

		Example[{Messages, "Error::MethodOptionConflict", "Return an error if an extraction method is specified but an option is set differently from the method-specified value:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Method -> Object[Method, Extraction, RNA, "Test mRNA extraction method, Liquid Liquid Extraction (Test for ExperimentExtractRNA) "<>$SessionUUID],
				HomogenizeLysate -> True,
				DehydrationSolutionVolume -> 200 Microliter,
				Purification -> {SolidPhaseExtraction},
				Output -> Result
			],
			$Failed,
			Messages :> {
				Error::MethodOptionConflict,
				Error::InvalidOption
			},
			TimeConstraint -> 600
		],

		Example[{Messages, "Error::InvalidExtractionMethod", "An error is returned if an extraction method is specified and it does not pass ValidObjectQ:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Method -> Object[Method, Extraction, RNA, "Test Invalid Method 1 for method validity check test (Test for ExperimentExtractRNA) " <> $SessionUUID],
				Output -> Result
			],
			$Failed,
			Messages :> {
				Error::InvalidExtractionMethod,
				Error::InvalidOption
			},
			TimeConstraint -> 600
		],

		Example[{Messages,"NoExtractRNAStepsSet","Return an error if no RNA extraction steps (Lyse, HomogenizeLysate, or Purification) are set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Lyse -> False,
				HomogenizeLysate -> False,
				Purification -> None,
				Output -> Result
			],
			$Failed,
			Messages:>{
				Error::NoExtractRNAStepsSet,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],

		Example[{Messages,"RepeatedLysis","Return a warning if Lyse is set to True and the sample is a cell lysate:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				Lyse -> True,
				HomogenizeLysate -> False,
				Purification -> None,
				Output -> Result
			],
			ObjectP[Object[Protocol,RoboticCellPreparation]],
			Messages:>{
				Warning::RepeatedLysis
			},
			TimeConstraint -> 1200
		],

		Example[{Messages,"UnlysedCellsInput","Return a warning if Lyse is set to False and the sample is Living:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Lyse -> False,
				HomogenizeLysate -> False,
				Purification -> MagneticBeadSeparation,
				Output -> Result
			],
			ObjectP[Object[Protocol,RoboticCellPreparation]],
			Messages:>{
				Warning::UnlysedCellsInput
			},
			TimeConstraint -> 1200
		],

		Example[{Messages, "ConflictingLysisOutputOptions", "Return an error if the last step of the extraction is lysis, but the ContainerOut does not match the final container in the lysis step:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Lyse -> True,
				ClarifyLysate -> True,
				ClarifiedLysateContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				HomogenizeLysate -> False,
				Purification -> None,
				ContainerOut -> Model[Container, Vessel, "50mL Tube"],
				Output -> Result
			],
			$Failed,
			Messages :> {
				Error::ConflictingLysisOutputOptions,
				Error::InvalidOption
			},
			TimeConstraint -> 600
		],

		Example[{Messages, "CellFreeLysis", "Return a warning if CellFreeRNA is specified as the target RNA and Lyse is set to True:"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				LysisSolutionVolume -> 300 Microliter,
				TargetRNA -> CellFreeRNA,
				Lyse -> True,
				Output -> Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			Messages :> {
				Warning::CellFreeLysis
			},
			TimeConstraint -> 1200
		],

		Example[{Messages, "LysateHomogenizationOptionMismatch", "Return an error if HomogenizeLysate is set to False and homogenization options are specified (not Null or Automatic):"},
			ExperimentExtractRNA[
				Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> None,
				LysisSolutionVolume -> 300 Microliter,
				HomogenizeLysate -> False,
				HomogenizationCentrifugeIntensity -> 100 RPM,
				Output -> Result
			],
			$Failed,
			Messages :> {
				Error::LysateHomogenizationOptionMismatch,
				Error::InvalidOption
			},
			TimeConstraint -> 1200
		],

		Example[{Messages, "HomogenizationPurificationOptionMismatch", "Return a warning if HomogenizeLysate is set to False and the first or only Purification technique is set to SolidPhaseExtraction:"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				HomogenizeLysate->False,
				Purification -> SolidPhaseExtraction,
				Output -> Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			Messages :> {
				Warning::HomogenizationPurificationOptionMismatch
			},
			TimeConstraint -> 1200
		],

		Example[{Messages, "SolidPhaseExtractionTechniqueInstrumentMismatch", "Return an error if the specified SolidPhaseExtractionInstrument cannot perform the specified SolidPhaseExtractionTechnique (If MPE2 is selected, the Technique must be Pressure. If HiG4 is selected, the Technique must be Centrifuge):"},
			ExperimentExtractRNA[
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
				SolidPhaseExtractionTechnique -> Centrifuge,
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::SolidPhaseExtractionTechniqueInstrumentMismatch,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],

		Example[{Messages, "ConflictingMagneticBeadSeparationMethods", "An error is returned if there are different values specified by methods for MagneticBeadSeparationSelectionStrategy:"},
			ExperimentExtractRNA[
				{Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID]},
				Method->{
					Object[Method, Extraction, RNA, "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
					Object[Method, Extraction, RNA, "Test Method 3 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID]
				},
				Output->Result
			],
			$Failed,
			Messages:>{
				(*MagneticBeadSeparationSelectionStrategy is not index matching in MBS, so if there are multiple Methods listed that have different values for*)
				(*MagneticBeadSeparationSelectionStrategy, MBS sets MagneticBeadSeparationSelectionStrategy for all of the samples to the value in the first Method in the list*)
				Error::MethodOptionConflict,
				Error::ConflictingMagneticBeadSeparationMethods,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],
		Example[{Messages, "ConflictingMagneticBeadSeparationMethods", "An error is returned if there are different values specified by methods for MagneticBeadSeparationMode:"},
			ExperimentExtractRNA[
				{Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID]},
				Method->{
					Object[Method, Extraction, RNA, "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
					Object[Method, Extraction, RNA, "Test Method 2 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID]
				},
				Output->Result
			],
			$Failed,
			Messages:>{
				(*MagneticBeadSeparationSelectionStrategy is not index matching in MBS, so if there are multiple Methods listed that have different values for*)
				(*MagneticBeadSeparationSelectionStrategy, MBS sets MagneticBeadSeparationSelectionStrategy for all of the samples to the value in the first Method in the list*)
				Error::MethodOptionConflict,
				Error::ConflictingMagneticBeadSeparationMethods,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],
		Example[{Messages, "ConflictingMagneticBeadSeparationMethods", "An error is returned if there are different values specified by user and methods for MagneticBeadSeparationMode or MagneticBeadSeparationSelectionStrategy:"},
			ExperimentExtractRNA[
				{Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID]},
				Method->Object[Method, Extraction, RNA, "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
				MagneticBeadSeparationSelectionStrategy -> Negative,
				MagneticBeadSeparationMode -> ReversePhase,
				Output->Result
			],
			$Failed,
			Messages:>{
				(*MagneticBeadSeparationSelectionStrategy is not index matching in MBS, so if there are multiple Methods listed that have different values for*)
				(*MagneticBeadSeparationSelectionStrategy, MBS sets MagneticBeadSeparationSelectionStrategy for all of the samples to the value in the first Method in the list*)
				Error::MethodOptionConflict,
				Error::ConflictingMagneticBeadSeparationMethods,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],

		(* --- SPE options tests --- *)

		Example[{Basic, "A sample containing a crude RNA extract can be further purified using solid phase extraction:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> SolidPhaseExtraction,
				Output->Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 1800
		],
		Example[{Basic, "All solid phase extraction options are set to Null if they are not specified by the user or method and SolidPhaseExtraction is not specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
				SolidPhaseExtractionStrategy -> Null,
				SolidPhaseExtractionSeparationMode -> Null,
				SolidPhaseExtractionSorbent -> Null,
				SolidPhaseExtractionCartridge -> Null,
				SolidPhaseExtractionTechnique -> Null,
				SolidPhaseExtractionInstrument -> Null,
				SolidPhaseExtractionCartridgeStorageCondition -> Null,
				SolidPhaseExtractionLoadingSampleVolume -> Null,
				SolidPhaseExtractionLoadingCentrifugeIntensity -> Null,
				SolidPhaseExtractionLoadingPressure -> Null,
				SolidPhaseExtractionLoadingTime -> Null,
				CollectSolidPhaseExtractionLoadingFlowthrough -> Null,
				SolidPhaseExtractionLoadingFlowthroughContainerOut -> Null,
				SolidPhaseExtractionWashSolution -> Null,
				SolidPhaseExtractionWashSolutionVolume -> Null,
				SolidPhaseExtractionWashCentrifugeIntensity -> Null,
				SolidPhaseExtractionWashPressure -> Null,
				SolidPhaseExtractionWashTime -> Null,
				CollectSolidPhaseExtractionWashFlowthrough -> Null,
				SolidPhaseExtractionWashFlowthroughContainerOut -> Null,
				SecondarySolidPhaseExtractionWashSolution -> Null,
				SecondarySolidPhaseExtractionWashSolutionVolume -> Null,
				SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
				SecondarySolidPhaseExtractionWashPressure -> Null,
				SecondarySolidPhaseExtractionWashTime -> Null,
				CollectSecondarySolidPhaseExtractionWashFlowthrough -> Null,
				SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> Null,
				TertiarySolidPhaseExtractionWashSolution -> Null,
				TertiarySolidPhaseExtractionWashSolutionVolume -> Null,
				TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
				TertiarySolidPhaseExtractionWashPressure -> Null,
				TertiarySolidPhaseExtractionWashTime -> Null,
				CollectTertiarySolidPhaseExtractionWashFlowthrough -> Null,
				TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> Null,
				SolidPhaseExtractionElutionSolution -> Null,
				SolidPhaseExtractionElutionSolutionVolume -> Null,
				SolidPhaseExtractionElutionCentrifugeIntensity -> Null,
				SolidPhaseExtractionElutionPressure -> Null,
				SolidPhaseExtractionElutionTime -> Null}]
			},
			TimeConstraint -> 1200
		],

		Example[{Options, {SolidPhaseExtractionStrategy, SolidPhaseExtractionSorbent, SolidPhaseExtractionSeparationMode}, "If SolidPhaseExtraction is specified as a Purification step, SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionSorbent is set to Silica, and SolidPhaseExtractionSeparationMode is set to IonExchange if not specified by the user or method:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionStrategy -> Positive,
					SolidPhaseExtractionSorbent -> Silica,
					SolidPhaseExtractionSeparationMode -> IonExchange
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, SolidPhaseExtractionSorbent, "SolidPhaseExtractionSorbent is set to match the sorbent in the SolidPhaseExtractionCartridge if SolidPhaseExtractionCartridge is specified and SolidPhaseExtractionSorbent is not specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionCartridge -> Model[Container, Plate, Filter, "id:wqW9BPW9jpbV"],(*Model[Container, Plate, Filter, "NucleoSpin 96 RNA Solid Phase Extraction Plate"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
			KeyValuePattern[{SolidPhaseExtractionSorbent -> Silica}]},
			TimeConstraint -> 1800
		],

		Example[{Options, {SolidPhaseExtractionSeparationMode, SolidPhaseExtractionCartridge}, "If not otherwise specified, SolidPhaseExtractionSeparationMode and SolidPhaseExtractionCartridge are set to match the mode of the SolidPhaseExtractionSorbent if SolidPhaseExtractionSorbent is specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionSorbent->Silica,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionSeparationMode -> IonExchange,
					SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:wqW9BPW9jpbV"]](*Model[Container, Plate, Filter, "NucleoSpin 96 RNA Solid Phase Extraction Plate"]*)
				}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionCartridge, "SolidPhaseExtractionCartridge is set to match the mode of the SolidPhaseExtractionSeparationMode if SolidPhaseExtractionSeparationMode is specified and SolidPhaseExtractionCartridge is not specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionSeparationMode->IonExchange,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:wqW9BPW9jpbV"]]}]},(*Model[Container, Plate, Filter, "NucleoSpin 96 RNA Solid Phase Extraction Plate"]*)
			TimeConstraint -> 1800
		],

		Example[{Options, {SolidPhaseExtractionCartridge, SolidPhaseExtractionTechnique}, "If SolidPhaseExtraction is specified as a Purification step, SolidPhaseExtractionCartridge is set to Model[Container, Plate, Filter, \"NucleoSpin 96 RNA Solid Phase Extraction Plate\"] and SolidPhaseExtractionTechnique is set to Pressure if not specified by the user or method:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionCartridge -> ObjectP[Model[Container, Plate, Filter, "id:wqW9BPW9jpbV"]],(*Model[Container, Plate, Filter, "NucleoSpin 96 RNA Solid Phase Extraction Plate"]*)
					SolidPhaseExtractionTechnique -> Pressure
				}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionInstrument, "SolidPhaseExtractionInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if SolidPhaseExtractionTechnique is set to Centrifuge and SolidPhaseExtractionInstrument is not specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionTechnique->Centrifuge,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}]}]},
			TimeConstraint -> 1800
		],

		Example[{Options, {SolidPhaseExtractionInstrument, SolidPhaseExtractionCartridgeStorageCondition}, "If SolidPhaseExtraction is specified as a Purification step, SolidPhaseExtractionInstrument is set to Model[Instrument, PressureManifold, \"MPE2\"] and SolidPhaseExtractionCartridgeStorageCondition is set to Disposal if not specified by the user or method:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionInstrument -> ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]}],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
					SolidPhaseExtractionCartridgeStorageCondition -> Disposal
				}]},
			TimeConstraint -> 1800
		],

		Example[{Options, {SolidPhaseExtractionLoadingSampleVolume}, "SolidPhaseExtractionLoadingSampleVolume is set to All if not specified by the user:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionLoadingSampleVolume -> RangeP[Quantity[399., Microliter], Quantity[401., Microliter]](*in SPE Automatic resolves to use All of the sample. make sure this number matches the volume of the test sample plus any volume added/subtracted prior to SPE purification*)
				}]},
			TimeConstraint -> 1800
		],

		Example[{Options, {SolidPhaseExtractionLoadingCentrifugeIntensity, SolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashCentrifugeIntensity, SolidPhaseExtractionElutionCentrifugeIntensity}, "CentrifugeIntensity options (SolidPhaseExtractionLoadingCentrifugeIntensity, SolidPhaseExtractionWashCentrifugeIntensity, SecondarySolidPhaseExtractionWashCentrifugeIntensity, TertiarySolidPhaseExtractionWashCentrifugeIntensity, SolidPhaseExtractionElutionCentrifugeIntensity) are set to Null if not specified by the user or method and SolidPhaseExtractionInstrument is not set to a Model[Instrument, Centrfuge]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionLoadingCentrifugeIntensity -> Null,
					SolidPhaseExtractionWashCentrifugeIntensity -> Null,
					SecondarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
					TertiarySolidPhaseExtractionWashCentrifugeIntensity -> Null,
					SolidPhaseExtractionElutionCentrifugeIntensity -> Null
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionLoadingCentrifugeIntensity, "SolidPhaseExtractionLoadingCentrifugeIntensity is set to the MaxRoboticCentrifugeSpeed if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionLoadingCentrifugeIntensity -> 5000 RPM}]},
			TimeConstraint -> 1800
		],
		Example[{Options, {SolidPhaseExtractionLoadingPressure, SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashPressure, SolidPhaseExtractionElutionPressure}, "All Pressure options (SolidPhaseExtractionLoadingPressure, SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashPressure, SolidPhaseExtractionElutionPressure) are set to Null if not specified by the user or method and SolidPhaseExtractionInstrument is not set to a Model[Instrument, PressureManifold]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionLoadingPressure -> Null,
					SolidPhaseExtractionWashPressure -> Null,
					SecondarySolidPhaseExtractionWashPressure -> Null,
					TertiarySolidPhaseExtractionWashPressure -> Null,
					SolidPhaseExtractionElutionPressure -> Null
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, {SolidPhaseExtractionLoadingPressure, SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashPressure, SolidPhaseExtractionElutionPressure}, "All Pressure options (SolidPhaseExtractionLoadingPressure, SolidPhaseExtractionWashPressure, SecondarySolidPhaseExtractionWashPressure, TertiarySolidPhaseExtractionWashPressure, SolidPhaseExtractionElutionPressure) are set to the MaxRoboticAirPressure if not specified by the user or method and the SolidPhaseExtractionInstrument is a Model[Instrument, PressureManifold]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
				SolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
				SecondarySolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
				TertiarySolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],(*Model[Sample, StockSolution, "70% Ethanol"]*)
				SolidPhaseExtractionElutionSolution -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample, "Milli-Q water"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionLoadingPressure -> $MaxRoboticAirPressure,
					SolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure,
					SecondarySolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure,
					TertiarySolidPhaseExtractionWashPressure -> $MaxRoboticAirPressure,
					SolidPhaseExtractionElutionPressure -> $MaxRoboticAirPressure
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionLoadingTime, "SolidPhaseExtractionLoadingTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionLoadingTime -> 1 Minute}]},
			TimeConstraint -> 1800
		],
		
		Example[{Options, {CollectSolidPhaseExtractionLoadingFlowthrough, CollectSolidPhaseExtractionWashFlowthrough, CollectSecondarySolidPhaseExtractionWashFlowthrough, CollectTertiarySolidPhaseExtractionWashFlowthrough}, "Flowthrough collection options (CollectSolidPhaseExtractionLoadingFlowthrough, CollectSolidPhaseExtractionWashFlowthrough, CollectSecondarySolidPhaseExtractionWashFlowthrough, CollectTertiarySolidPhaseExtractionWashFlowthrough) are set to False if not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					CollectSolidPhaseExtractionLoadingFlowthrough -> False,(*if the option is not set by the user, SPE sets it to False unless there is a collection container specified*)
					CollectSolidPhaseExtractionWashFlowthrough -> False,
					CollectSecondarySolidPhaseExtractionWashFlowthrough -> False,
					CollectTertiarySolidPhaseExtractionWashFlowthrough -> False
				}]
			},
			TimeConstraint -> 1800
		],
		
		Example[{Options, {SolidPhaseExtractionLoadingFlowthroughContainerOut, SolidPhaseExtractionWashFlowthroughContainerOut, SecondarySolidPhaseExtractionWashFlowthroughContainerOut, TertiarySolidPhaseExtractionWashFlowthroughContainerOut}, "SolidPhaseExtractionLoadingFlowthroughContainerOut is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionLoadingFlowthroughContainerOut -> Null,(*default in SPE is to not collect the flowthrough, so don't need a container*)
					SolidPhaseExtractionWashFlowthroughContainerOut -> Null,
					SecondarySolidPhaseExtractionWashFlowthroughContainerOut -> Null,
					TertiarySolidPhaseExtractionWashFlowthroughContainerOut -> Null
				}]
			},
			TimeConstraint -> 1800
		],
		
		Example[{Options, SolidPhaseExtractionWashSolution, "SolidPhaseExtractionWashSolution is set to (*Model[Sample, StockSolution, \"70% Ethanol\"]*) if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]}]},(*Model[Sample, StockSolution, "70% Ethanol"]*)
			TimeConstraint -> 1800
		],
		Example[{Options, {SolidPhaseExtractionWashSolutionVolume, SecondarySolidPhaseExtractionWashSolutionVolume, TertiarySolidPhaseExtractionWashSolutionVolume}, "Wash solution volumes are resolved by ExperimentSolidPhaseExtraction if they are not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					SolidPhaseExtractionWashSolutionVolume -> EqualP[0.5 Milliliter],
					SecondarySolidPhaseExtractionWashSolutionVolume -> EqualP[0.5 Milliliter],
					TertiarySolidPhaseExtractionWashSolutionVolume -> EqualP[0.5 Milliliter]
				}]
			},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionWashCentrifugeIntensity, "SolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionWashTime, "SolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionWashTime -> 1 Minute}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SecondarySolidPhaseExtractionWashSolution, "SecondarySolidPhaseExtractionWashSolution is set to (*Model[Sample, StockSolution, \"70% Ethanol\"]*) if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SecondarySolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]}]},(*Model[Sample, StockSolution, "70% Ethanol"]*)
			TimeConstraint -> 1800
		],

		Example[{Options, SecondarySolidPhaseExtractionWashCentrifugeIntensity, "SecondarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SecondarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SecondarySolidPhaseExtractionWashTime, "SecondarySolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SecondarySolidPhaseExtractionWashTime -> 1 Minute}]},
			TimeConstraint -> 1800
		],

		Example[{Options, TertiarySolidPhaseExtractionWashSolution, "TertiarySolidPhaseExtractionWashSolution is set to (*Model[Sample, StockSolution, \"70% Ethanol\"]*) if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{TertiarySolidPhaseExtractionWashSolution -> Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]}]},(*Model[Sample, StockSolution, "70% Ethanol"]*)
			TimeConstraint -> 1800
		],

		Example[{Options, TertiarySolidPhaseExtractionWashCentrifugeIntensity, "TertiarySolidPhaseExtractionWashCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}]},
			TimeConstraint -> 1800
		],

		Example[{Options, TertiarySolidPhaseExtractionWashTime, "TertiarySolidPhaseExtractionWashTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{TertiarySolidPhaseExtractionWashTime -> 1 Minute}]},
			TimeConstraint -> 1800
		],
		
		Example[{Options, SolidPhaseExtractionElutionSolution, "SolidPhaseExtractionElutionSolution is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionElutionSolution -> Model[Sample, "id:8qZ1VWNmdLBD"]}]},(*Model[Sample,"Milli-Q water"]*)
			TimeConstraint -> 1800
		],
		Example[{Options, SolidPhaseExtractionElutionSolutionVolume, "SolidPhaseExtractionElutionSolutionVolume is resolved by ExperimentSolidPhaseExtraction if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionElutionSolutionVolume -> EqualP[0.5 Milliliter]}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionElutionCentrifugeIntensity, "SolidPhaseExtractionElutionCentrifugeIntensity is set to the MaxRotationRate of the Centrifuge model if it is not specified by the user or method and SolidPhaseExtractionInstrument is Model[Instrument, Centrifuge, \"HiG4\"] or Object[Instrument, Centrifuge, \"HiG4\"]:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DehydrationSolution -> Null,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{TertiarySolidPhaseExtractionWashCentrifugeIntensity -> 5000 RPM}]},
			TimeConstraint -> 1800
		],

		Example[{Options, SolidPhaseExtractionElutionTime, "SolidPhaseExtractionElutionTime is set to 1 Minute if it is not specified by the user or method and SolidPhaseExtraction is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {SolidPhaseExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{SolidPhaseExtractionElutionTime -> 1 Minute}]},
			TimeConstraint -> 1800
		],


		(* --- PRECIPITATION SHARED OPTIONS TESTS --- *)
		
		Example[{Basic, "A sample containing a crude RNA extract can be further purified using precipitation:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> Precipitation,
				Output -> Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 1800
		],
		Example[{Options, {PrecipitationTargetPhase, PrecipitationSeparationTechnique, PrecipitationReagentVolume, PrecipitationReagentTemperature, PrecipitationReagentEquilibrationTime, PrecipitationMixType, PrecipitationTime, PrecipitationWashSolutionVolume, PrecipitationWashSolutionTemperature, PrecipitationWashSolutionEquilibrationTime}, "PrecipitationTargetPhase is set to Solid, PrecipitationSeparationTechnique is set to Pellet, PrecipitationReagentVolume is set to the lesser of 50% of the sample volume and the MaxVolume of the sample container, PrecipitationReagentTemperature is set to Ambient, PrecipitationReagentEquilibrationTime is set to 5 Minutes, PrecipitationMixType is set to Shake, PrecipitationTime is set to 15 Minutes, PrecipitationWashSolutionVolume is set to the volume of the sample if PrecipitationNumberOfWashes is set to a number greater than 0, PrecipitationWashSolutionTemperature is set to Ambient if PrecipitationNumberOfWashes is greater than 0, PrecipitationWashSolutionEquilibrationTime is set to 10 Minutes if PrecipitationNumberOfWashes is greater than 0 if it is not specified by the user or method and Precipitation is specified as a Purification step:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationTargetPhase -> Solid,
					PrecipitationSeparationTechnique -> Pellet,
					PrecipitationReagentVolume -> EqualP[0.1 Milliliter],
					PrecipitationReagentTemperature -> Ambient,
					PrecipitationReagentEquilibrationTime -> 5 Minute,
					PrecipitationMixType -> Shake,
					PrecipitationTime -> 15 Minute,
					PrecipitationWashSolutionVolume -> EqualP[0.2 Milliliter],
					PrecipitationWashSolutionTemperature -> Ambient,
					PrecipitationWashSolutionEquilibrationTime -> 10 Minute
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationReagent, PrecipitationFilterStorageCondition}, "PrecipitationReagent is set to Model[Sample, StockSolution, \"5M Sodium Chloride\"] and PrecipitationFilterStorageCondition is set to Null if PrecipitationTargetPhase is set to Liquid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationTargetPhase -> Liquid,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationReagent -> Model[Sample,StockSolution,"id:AEqRl954GJb6"],(*Model[Sample, StockSolution, "5M Sodium Chloride"]*)
					PrecipitationFilterStorageCondition -> Null
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationReagent, "PrecipitationReagent is set to Model[Sample,\"Isopropanol\"] if PrecipitationTargetPhase is set to Solid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationTargetPhase -> Solid,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationReagent -> Model[Sample, "id:jLq9jXY4k6da"]}]},(*Model[Sample, "Isopropanol"]*)
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationMixType, "PrecipitationMixType is set to Pipette if PrecipitationMixVolume is set by the user:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationMixVolume -> 100 Microliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationMixType, "PrecipitationMixType is set to Pipette if NumberOfPrecipitationMixes is set by the user:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				NumberOfPrecipitationMixes -> 10,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationMixType -> Pipette}]},
			TimeConstraint -> 1200
		],

		Example[{Options, {PrecipitationMixInstrument, PrecipitationMixRate, PrecipitationMixTemperature, PrecipitationMixTime, NumberOfPrecipitationMixes}, "PrecipitationMixInstrument, PrecipitationMixRate, PrecipitationMixTemperature, and PrecipitationMixTime are set to Null if PrecipitationMixType is not set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationMixInstrument -> Null,
					PrecipitationMixRate -> Null,
					PrecipitationMixTemperature -> Null,
					PrecipitationMixTime -> Null,
					NumberOfPrecipitationMixes -> 10
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, {NumberOfPrecipitationMixes, PrecipitationMixVolume}, "NumberOfPrecipitationMixes is set to 10 if PrecipitationMixType is set to Pipette and PrecipitationMixVolume is set to 50% of the sample volume if and $MaxRoboticSingleTransferVolume is more than 50% of the sample volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationMixType -> Pipette,
				PrecipitationReagentVolume -> 0.1 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					NumberOfPrecipitationMixes -> 10,
					PrecipitationMixVolume -> EqualP[150 Microliter]
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, {PrecipitationMixInstrument, PrecipitationMixRate, PrecipitationMixTemperature, PrecipitationMixTime, NumberOfPrecipitationMixes}, "PrecipitationMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"], PrecipitationMixRate is set to 300 RPM, PrecipitationMixTemperature is set to Ambient, PrecipitationMixTime is set to 15 Minutes, andNumberOfPrecipitationMixes is set to Null if PrecipitationMixType is set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationMixInstrument -> Model[Instrument,Shaker,"id:pZx9jox97qNp"],(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
					PrecipitationMixRate -> 300 RPM,
					PrecipitationMixTemperature -> Ambient,
					PrecipitationMixTime -> 15 Minute,
					NumberOfPrecipitationMixes -> Null
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, {PrecipitationInstrument, PrecipitationTemperature}, "PrecipitationInstrument and PrecipitationTemperature are set to Null if PrecipitationTime is set to 0 Minutes:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationTime -> 0 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationInstrument -> Null,
					PrecipitationTemperature -> Null
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationInstrument, "PrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationTemperature is set to greater than 70 Celsius:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationTemperature -> 80 Celsius,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationInstrument -> Model[Instrument,Shaker,"id:eGakldJkWVnz"]}]},(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationInstrument, "PrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] if PrecipitationTemperature is less than 70 Celsius:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationTemperature -> 50 Celsius,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationInstrument -> Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]}]},(*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationTemperature, "PrecipitationTemperature is set to Ambient if PrecipitationTime is set to greater than 0 Minutes:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationTime -> 1 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationTemperature -> Ambient}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationFiltrationInstrument, "PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] if PrecipitationSeparationTechnique is set to Filter and PrecipitationFiltrationTechnique is set to Centrifuge:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Filter,
				PrecipitationFiltrationTechnique -> Centrifuge,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationFiltrationInstrument -> ObjectP[Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"]]}]},(*Model[Instrument, Centrifuge, "HiG4"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationFiltrationInstrument, "PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"MPE2 Sterile\"] if PrecipitationSeparationTechnique is set to Filter and PrecipitationFiltrationTechnique is set to AirPressure:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Filter,
				PrecipitationFiltrationTechnique -> AirPressure,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationFiltrationInstrument -> ObjectP[Model[Instrument,PressureManifold,"id:4pO6dMOqXNpX"]]}]},(*Model[Instrument, PressureManifold, "MPE2"*)
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationFiltrationInstrument, PrecipitationFiltrationTechnique, PrecipitationFilter, PrecipitationPrefilterPoreSize, PrecipitationPrefilterMembraneMaterial, PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterPosition, PrecipitationFiltrationTime, PrecipitationPelletVolume, PrecipitationPelletCentrifuge, PrecipitationPelletCentrifugeIntensity, PrecipitationPelletCentrifugeTime}, "PrecipitationFiltrationInstrument, PrecipitationFiltrationTechnique, PrecipitationFilter, PrecipitationPrefilterPoreSize, PrecipitationPrefilterMembraneMaterial, PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterPosition, and PrecipitationFiltrationTime are set to Null if PrecipitationSeparationTechnique is set to Pellet. PrecipitationPelletVolume is set to 1 Microliter, PrecipitationPelletCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"], PrecipitationPelletCentrifugeIntensity is set to 3600 Gravitational Acceleration, and PrecipitationPelletCentrifugeTime is set to 10 Minutes if PrecipitationSeparationTechnique is set to Pellet:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Pellet,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationFiltrationInstrument -> Null,
					PrecipitationFiltrationTechnique -> Null,
					PrecipitationFilter -> Null,
					PrecipitationPrefilterPoreSize -> Null,
					PrecipitationPrefilterMembraneMaterial -> Null,
					PrecipitationPoreSize -> Null,
					PrecipitationMembraneMaterial -> Null,
					PrecipitationFilterPosition -> Null,
					PrecipitationFiltrationTime -> Null,
					PrecipitationPelletVolume -> EqualP[1 Microliter],
					PrecipitationPelletCentrifuge -> Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"],(*Model[Instrument, Centrifuge, "HiG4"]*)
					PrecipitationPelletCentrifugeIntensity -> 3600 GravitationalAcceleration
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationFiltrationTechnique, PrecipitationFilter, PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterPosition,PrecipitationFiltrationTime, PrecipitationPelletVolume}, "PrecipitationFiltrationTechnique is set to AirPressure, PrecipitationFiltrationTime is set to 10 Minutes, PrecipitationPelletVolume is set to Null, and PrecipitationFilter, PrecipitationPoreSize, PrecipitationMembraneMaterial, PrecipitationFilterPosition are set by the ExperimentFilter resolver if PrecipitationSeparationTechnique is set to Filter:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Filter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationFiltrationTechnique -> AirPressure,
					PrecipitationFilter -> ObjectP[Model[Container, Plate, Filter, "id:xRO9n3BGnqDz"]],(*Model[Container, Plate, Filter, "QiaQuick 96well"]*)
					PrecipitationPoreSize -> Null,
					PrecipitationMembraneMaterial -> Silica,
					PrecipitationFilterPosition -> "A1",
					PrecipitationFiltrationTime -> 10 Minute,
					PrecipitationPelletVolume -> Null
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, {PrecipitationFilterCentrifugeIntensity, PrecipitationFiltrationPressure}, "PrecipitationFilterCentrifugeIntensity is set to 3600 g and PrecipitationFiltrationPressure is set to Null if PrecipitationFiltrationTechnique is set to Centrifuge:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationFiltrationTechnique -> Centrifuge,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationFilterCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration],
					PrecipitationFiltrationPressure -> Null
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationFilterCentrifugeIntensity, PrecipitationFiltrationPressure}, "PrecipitationFiltrationPressure is set to 40 PSI and PrecipitationFilterCentrifugeIntensity is set to Null if PrecipitationFiltrationTechnique is set to AirPressure:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationFiltrationTechnique -> AirPressure,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationFiltrationPressure -> 40 PSI,
				PrecipitationFilterCentrifugeIntensity -> Null
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, {PrecipitationFiltrateVolume, PrecipitationSupernatantVolume}, "PrecipitationFiltrateVolume is set to the sample volume plus PrecipitationReagentVolume and PrecipitationSupernatantVolume is set to Null if PrecipitationSeparationTechnique is set to Filter:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Filter,
				PrecipitationReagentVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationFiltrateVolume -> EqualP[0.4 Milliliter],
					PrecipitationSupernatantVolume -> Null
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationFiltrateVolume, PrecipitationSupernatantVolume}, "PrecipitationSupernatantVolume is set to 90% of the sample volume plus PrecipitationReagentVolume and PrecipitationFiltrateVolume is set to Null if PrecipitationSeparationTechnique is set to Pellet:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Pellet,
				PrecipitationReagentVolume -> 0.1 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationFiltrateVolume -> Null,
					PrecipitationSupernatantVolume -> EqualP[0.27 Milliliter]
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationFilterStorageCondition, "PrecipitationFilterStorageCondition is set to the StorageCondition of the Sample if PrecipitationTargetPhase is set to Solid and PrecipitationSeparationTechnique is set to Filter:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Filter,
				PrecipitationTargetPhase -> Solid,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationFilterStorageCondition ->ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]]}]},(*Model[StorageCondition, "Refrigerator"]*)
			TimeConstraint -> 1200
		],

		Example[{Options, {PrecipitationNumberOfWashes, PrecipitatedSampleStorageCondition, PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel, UnprecipitatedSampleStorageCondition, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel}, "PrecipitationNumberOfWashes is set to 0, UnprecipitatedSampleStorageCondition is set to the StorageCondition of the Sample, UnprecipitatedSampleLabel and UnprecipitatedSampleContainerLabel are set automatically, and PrecipitatedSampleStorageCondition, PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel are set to Null if PrecipitationTargetPhase is set to Liquid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Liquid,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationNumberOfWashes -> 0,
					PrecipitatedSampleStorageCondition -> Null,
					PrecipitatedSampleLabel -> Null,
					PrecipitatedSampleContainerLabel -> Null,
					UnprecipitatedSampleStorageCondition -> ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]],(*Model[StorageCondition, "Refrigerator"]*)
					UnprecipitatedSampleLabel -> _String,
					UnprecipitatedSampleContainerLabel -> _String
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationNumberOfWashes, PrecipitationDryingTemperature, PrecipitationDryingTime, PrecipitationResuspensionBuffer, PrecipitatedSampleStorageCondition, PrecipitatedSampleLabel, PrecipitatedSampleContainerLabel, UnprecipitatedSampleStorageCondition, UnprecipitatedSampleLabel, UnprecipitatedSampleContainerLabel}, "PrecipitationNumberOfWashes is set to 3, PrecipitationDryingTemperature is set to Ambient, PrecipitationDryingTime is set to 20 Minutes, PrecipitationResuspensionBuffer is set to Model[Sample, StockSolution, \"1x TE Buffer\"], PrecipitatedSampleStorageCondition is set to the StorageCondition of the Sample, PrecipitatedSampleLabel and PrecipitatedSampleContainerLabel are set automatically, and UnprecipitatedSampleStorageCondition, UnprecipitatedSampleLabel, and UnprecipitatedSampleContainerLabel are set to Null if PrecipitationTargetPhase is set to Solid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationNumberOfWashes -> 3,
					PrecipitationDryingTemperature -> Ambient,
					PrecipitationDryingTime -> 20 Minute,
					PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],(*Model[Sample, StockSolution, "1x TE Buffer"]*)
					PrecipitatedSampleStorageCondition -> ObjectP[Model[StorageCondition,"id:N80DNj1r04jW"]],(*Model[StorageCondition, "Refrigerator"]*)
					PrecipitatedSampleLabel -> _String,
					PrecipitatedSampleContainerLabel -> _String,
					UnprecipitatedSampleStorageCondition -> Null,
					UnprecipitatedSampleLabel -> Null,
					UnprecipitatedSampleContainerLabel -> Null
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashSolution, "PrecipitationWashSolution is set to Model[Sample, StockSolution, \"70% Ethanol\"] if PrecipitationNumberOfWashes is greater than 0:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 3,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashSolution -> Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"]}]},(*Model[Sample, StockSolution, "70% Ethanol"]*)
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationWashSolutionVolume, "PrecipitationWashSolutionVolume is set to Null if PrecipitationNumberOfWashes is set to 0:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfWashes -> 0,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashSolutionVolume -> Null}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationWashMixVolume is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				PrecipitationNumberOfWashes -> 1,
				PrecipitationWashMixVolume -> 100 Microliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationNumberOfWashMixes is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				PrecipitationNumberOfWashes -> 1,
				PrecipitationNumberOfWashMixes -> 10,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Pipette if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and PrecipitationSeparationTechnique is set to Filter:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				PrecipitationNumberOfWashes -> 1,
				PrecipitationSeparationTechnique -> Filter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashMixType, "PrecipitationWashMixType is set to Shake if PrecipitationTargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				PrecipitationNumberOfWashes -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashMixType -> Shake}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashMixInstrument, "PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is below 70 Celsius:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashMixType -> Shake,
				PrecipitationWashMixTemperature -> 65 Celsius,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashMixInstrument -> ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]]}]},(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashMixInstrument, "PrecipitationWashMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is above 70 Celsius:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashMixType -> Shake,
				PrecipitationWashMixTemperature -> 72 Celsius,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashMixInstrument -> ObjectP[Model[Instrument, Shaker, "id:eGakldJkWVnz"]]}]},(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationWashMixInstrument, PrecipitationNumberOfWashMixes, PrecipitationWashMixVolume}, "PrecipitationWashMixInstrument is set to Null, PrecipitationNumberOfWashMixes is set to 10, and PrecipitationWashMixVolume is set to the lesser of 50% of the sample volume and $MaxRoboticSingleTransferVolume if PrecipitationWashMixType is set to Pipette:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationWashMixInstrument -> Null,
					PrecipitationNumberOfWashMixes -> 10,
					PrecipitationWashMixVolume -> EqualP[0.1 Milliliter]
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationWashMixRate, PrecipitationWashMixTemperature, PrecipitationWashMixTime, PrecipitationWashMixVolume}, "PrecipitationWashMixRate is set to 300 RPM, PrecipitationWashMixTemperature is set to Ambient, PrecipitationWashMixTime is set to 15 Minutes, and PrecipitationWashMixVolume is set to Null if PrecipitationWashMixType is set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationWashMixRate -> 300 RPM,
					PrecipitationWashMixTemperature -> Ambient,
					PrecipitationWashMixTime -> 15 Minute,
					PrecipitationWashMixVolume -> Null
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationWashPrecipitationTime, "PrecipitationWashPrecipitationTime is set to 1 Minute if the PrecipitationWashSolutionTemperature is greater than the PrecipitationReagentTemperature:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashSolutionTemperature -> 40 Celsius,
				PrecipitationReagentTemperature -> Ambient,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashPrecipitationTime -> 1 Minute}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Null if PrecipitationWashPrecipitationTime is set to 0 Minutes:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashPrecipitationTime -> 0 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Null}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashPrecipitationTemperature is set to greater than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashPrecipitationTemperature -> 80 Celsius,
				PrecipitationWashPrecipitationTime -> 15 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Model[Instrument,Shaker,"id:eGakldJkWVnz"]}]},(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashPrecipitationInstrument, "PrecipitationWashPrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Hamilton Heater Cooler\"] if PrecipitationWashPrecipitationTemperature is less than 70 Celsius and PrecipitationWashPrecipitationTime is greater than 0 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashPrecipitationTemperature -> 50 Celsius,
				PrecipitationWashPrecipitationTime -> 15 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashPrecipitationInstrument -> Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]}]},(*Model[Instrument, HeatBlock, "Hamilton Heater Cooler"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashPrecipitationTemperature, "PrecipitationWashPrecipitationTemperature is set to Ambient if PrecipitationWashPrecipitationTime is greater than 0:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationWashPrecipitationTime -> 10 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashPrecipitationTemperature -> Ambient}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationWashCentrifugeIntensity, "PrecipitationWashCentrifugeIntensity is set to 3600 GravitationalAcceleration if PrecipitationSeparationTechnique is set to Pellet:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationSeparationTechnique -> Pellet,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashCentrifugeIntensity -> 3600 GravitationalAcceleration}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationWashPressure, PrecipitationWashSeparationTime}, "PrecipitationWashPressure is set to 40 PSI and PrecipitationWashSeparationTime is set to 3 Minutes if PrecipitationFiltrationTechnique is set to AirPressure and PrecipitationNumberOfWashes is greater than 0:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationFiltrationTechnique -> AirPressure,
				PrecipitationNumberOfWashes -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationWashPressure -> 40 PSI,
					PrecipitationWashSeparationTime -> 3 Minute
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationWashSeparationTime, "PrecipitationWashSeparationTime is set to 20 Minutes if PrecipitationFiltrationTechnique is set to Centrifuge and PrecipitationNumberOfWashes is greater than 0:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationFiltrationTechnique -> Centrifuge,
				PrecipitationNumberOfWashes -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationWashSeparationTime -> 20 Minute}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationResuspensionBufferVolume, "PrecipitationResuspensionBufferVolume is set to the greater of 10 MicroLiter or 1/4th SampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionBufferVolume -> EqualP[0.05 Milliliter]}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionBufferVolume, "PrecipitationResuspensionBufferVolume is set to the greater of 10 MicroLiter or 1/4th SampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 14 with small volume for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol,RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionBufferVolume -> EqualP[0.01 Milliliter]}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationResuspensionBufferTemperature, PrecipitationResuspensionBufferEquilibrationTime}, "PrecipitationResuspensionBufferTemperature is set to Ambient and PrecipitationResuspensionBufferEquilibrationTime is set to 10 Minutes if a PrecipitationResuspensionBuffer is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],(*Model[Sample, StockSolution, "1x TE Buffer"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationResuspensionBufferTemperature -> Ambient,
					PrecipitationResuspensionBufferEquilibrationTime -> 10 Minute
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationResuspensionMixVolume is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixVolume -> 10 Microliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationNumberOfResuspensionMixes is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationNumberOfResuspensionMixes -> 10,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Pipette if a PrecipitationResuspensionBuffer is set and PrecipitationSeparationTechnique is set to Filter:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationSeparationTechnique -> Filter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixType -> Pipette}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixType, "PrecipitationResuspensionMixType is set to Shake if a PrecipitationResuspensionBuffer is set and neither PrecipitationResuspensionMixVolume or PrecipitationNumberOfResuspensionMixes are set and PrecipitationSeparationTechnique is not set to Filter:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionBuffer -> Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],(*Model[Sample, StockSolution, "1x TE Buffer"]*)
				PrecipitationSeparationTechnique -> Pellet,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixType -> Shake}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixInstrument, "PrecipitationResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is below 70 Celsius:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixType -> Shake,
				PrecipitationResuspensionMixTemperature -> 65 Celsius,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixInstrument -> ObjectP[Model[Instrument,Shaker,"id:pZx9jox97qNp"]]}]},(*Model[Instrument, Shaker, "Inheco ThermoshakeAC"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixInstrument, "PrecipitationResuspensionMixInstrument is set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is above 70 Celsius:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixType -> Shake,
				PrecipitationResuspensionMixTemperature -> 72 Celsius,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixInstrument -> ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]}]},(*Model[Instrument, Shaker, "Inheco Incubator Shaker DWP"]*)
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationResuspensionMixInstrument, PrecipitationNumberOfResuspensionMixes}, "PrecipitationResuspensionMixInstrument is set to Null and PrecipitationNumberOfResuspensionMixes is set to 10 if PrecipitationResuspensionMixType is set to Pipette:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationResuspensionMixInstrument -> Null,
					PrecipitationNumberOfResuspensionMixes -> 10
				}]},
			TimeConstraint -> 1200
		],
		Example[{Options, {PrecipitationResuspensionMixRate, PrecipitationResuspensionMixTemperature, PrecipitationResuspensionMixTime}, "PrecipitationResuspensionMixRate is set to 300 RPM, PrecipitationResuspensionMixTemperature is set to Ambient, PrecipitationResuspensionMixTime is set to 15 Minutes if PrecipitationResuspensionMixType is set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[{
					PrecipitationResuspensionMixRate -> 300 RPM,
					PrecipitationResuspensionMixTemperature -> Ambient,
					PrecipitationResuspensionMixTime -> 15 Minute
				}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitationResuspensionMixVolume, "PrecipitationResuspensionMixVolume is set to the lesser of 50% of the sample volume and $MaxRoboticSingleTransferVolume if PrecipitationResuspensionMixType is set to Pipette:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixType -> Pipette,
				PrecipitationResuspensionBufferVolume -> 0.05 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixVolume -> EqualP[0.025 Milliliter]}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitationResuspensionMixVolume, "PrecipitationResuspensionMixVolume is set to Null if PrecipitationResuspensionMixType is set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationResuspensionMixType -> Shake,
				PrecipitationResuspensionBufferVolume -> 0.05 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitationResuspensionMixVolume -> Null}]},
			TimeConstraint -> 1200
		],
		Example[{Options, PrecipitatedSampleContainerOut, "PrecipitatedSampleContainerOut is set properly based on input:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitatedSampleLabel, "PrecipitatedSampleLabel is set to user-specified label if PrecipitationTargetPhase is set to Solid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				PrecipitatedSampleLabel -> "Test Label for Precipitated Sample",
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitatedSampleLabel -> "Test Label for Precipitated Sample"}]},
			TimeConstraint -> 1200
		],

		Example[{Options, PrecipitatedSampleContainerLabel, "PrecipitatedSampleContainerLabel is set to the user-specified label if PrecipitationTargetPhase is set to Solid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Solid,
				PrecipitatedSampleContainerLabel -> "Test Label for Precipitated Sample Container",
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{PrecipitatedSampleContainerLabel -> "Test Label for Precipitated Sample Container"}]},
			TimeConstraint -> 1200
		],

		Example[{Options, UnprecipitatedSampleContainerOut, "UnprecipitatedSampleContainerOut is set properly based on input:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				UnprecipitatedSampleContainerOut -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{UnprecipitatedSampleContainerOut -> {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}]},
			TimeConstraint -> 1200
		],

		Example[{Options, UnprecipitatedSampleLabel, "UnprecipitatedSampleLabel is set to user-specified label if PrecipitationTargetPhase is set to Liquid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Liquid,
				UnprecipitatedSampleLabel -> "Test Label for Unprecipitated Sample",
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{UnprecipitatedSampleLabel -> "Test Label for Unprecipitated Sample"}]},
			TimeConstraint -> 1200
		],

		Example[{Options, UnprecipitatedSampleContainerLabel, "UnprecipitatedSampleContainerLabel is set to the user-specified label if PrecipitationTargetPhase is set to Liquid:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				PrecipitationTargetPhase -> Liquid,
				UnprecipitatedSampleContainerLabel -> "Test Label for Unprecipitated Sample Container",
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[{UnprecipitatedSampleContainerLabel -> "Test Label for Unprecipitated Sample Container"}]},
			TimeConstraint -> 1200
		],

		(* --- LIQUID LIQUID EXTRACTION SHARED OPTION TESTS --- *)


		(* Basic Example *)
		Example[{Basic, "A sample containing a crude RNA extract can be further purified using liquid-liquid extraction:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {LiquidLiquidExtraction},
				Output -> Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 1800
		],

		(* - Liquid-liquid Extraction Options - *)

		(* -- LiquidLiquidExtractionTechnique Tests -- *)
		Example[{Options,LiquidLiquidExtractionTechnique, "If pipetting-specific options (IncludeLiquidBoundary or LiquidBoundaryVolume) are set for removing one layer from another, then pipetting is used for the liquid-liquid extraction technique:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				IncludeLiquidBoundary -> {False,False,False},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTechnique -> Pipette
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, {LiquidLiquidExtractionTechnique, LiquidLiquidExtractionSelectionStrategy, LiquidLiquidExtractionTargetPhase}, "LiquidLiquidExtractionTechnique is set to PhaseSeparator, LiquidLiquidExtractionSelectionStrategy is set to Positive, and LiquidLiquidExtractionTargetPhase is set based on the PredictDestinationPhase[...] function if not otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {LiquidLiquidExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTechnique -> PhaseSeparator,
					LiquidLiquidExtractionSelectionStrategy -> Positive,
					LiquidLiquidExtractionTargetPhase -> Aqueous
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionDevice Tests --*)
		Example[{Options, {LiquidLiquidExtractionDevice, IncludeLiquidBoundary, OrganicSolvent, LiquidLiquidExtractionCentrifuge, LiquidLiquidExtractionTransferLayer}, "LiquidLiquidExtractionDevice is setto Null, IncludeLiquidBoundary is set to False (for all extractions if there are multiple), OrganicSolvent is set to ObjectP[Model[Sample, \"Ethyl acetate, HPLC Grade\"]], LiquidLiquidExtractionCentrifuge is set to True, and LiquidLiquidExtractionTransferLayer is set to Top (for all extractions if there are multiple) if LiquidLiquidExtractionTechnique is set to Pipette, unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionDevice -> Null,
					IncludeLiquidBoundary -> {False, False, False},
					OrganicSolvent -> ObjectP[Model[Sample, "Ethyl acetate, HPLC Grade"]],
					LiquidLiquidExtractionCentrifuge -> True,
					LiquidLiquidExtractionTransferLayer -> {Top, Top, Top}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, {LiquidLiquidExtractionDevice, OrganicSolvent}, "LiquidLiquidExtractionDevice is set to Model[Container,Plate,PhaseSeparator,\"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits\"] and OrganicSolvent is set to Model[Sample, \"Chloroform\"] if LiquidLiquidExtractionTechnique is set to PhaseSeparator:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> PhaseSeparator,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionDevice -> ObjectP[Model[Container,Plate,PhaseSeparator,"Semi-Transparent Plastic 96 Fixed Well Plate with Phase Separator Frits"]],
					OrganicSolvent -> ObjectP[Model[Sample, "Chloroform"]]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionSelectionStrategy -- *)
		Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If there is only one round of liquid-liquid extraction, then a selection strategy is not specified (since a selection strategy is only required for multiple extraction rounds):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSelectionStrategy -> Null
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round matches the target phase, then the selection strategy is positive:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample,"Milli-Q water"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSelectionStrategy -> Positive
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionSelectionStrategy, "If the phase of the solvent being added for each liquid-liquid extraction round does not match the target phase, then the selection strategy is negative:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				AqueousSolvent -> None,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSelectionStrategy -> Negative
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionTargetLayer -- *)
		Example[{Options,LiquidLiquidExtractionTargetLayer, "The target layer for each extraction round is calculated from the density of the sample's aqueous and organic layers (if present in the sample), the density of the AqueousSolvent and OrganicSolvent options (if specified), and the target phase:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTargetLayer -> {Top, Top, Top}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is less dense than the organic phase, then the target layer will be the top layer:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				NumberOfLiquidLiquidExtractions -> 1,
				AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample,"Milli-Q water"]*)
				OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTargetLayer -> {Top}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is aqueous and the aqueous phase is denser than the organic phase, then the target layer will be the bottom layer:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				NumberOfLiquidLiquidExtractions -> 1,
				AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample,"Milli-Q water"]*)
				OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTargetLayer -> {Bottom}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is less dense than the organic phase, then the target layer will be the bottom layer:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTargetPhase -> Organic,
				NumberOfLiquidLiquidExtractions -> 1,
				AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample,"Milli-Q water"]*)
				OrganicSolvent -> Model[Sample,"Dichloromethane, Reagent Grade"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTargetLayer -> {Bottom}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionTargetLayer, "If the target phase is organic and the aqueous phase is denser than the organic phase, then the target layer will be the top layer:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				LiquidLiquidExtractionTargetPhase -> Organic,
				NumberOfLiquidLiquidExtractions -> 1,
				AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample,"Milli-Q water"]*)
				OrganicSolvent -> Model[Sample,"Ethyl acetate, HPLC Grade"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionTargetLayer -> {Top}
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionContainer -- *)
		Example[{Options,LiquidLiquidExtractionContainer, "If the sample is in a non-centrifuge-compatible container and centrifuging is specified, then the extraction container will be set to a centrifuge-compatible, 96-well 2mL deep well plate:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionCentrifuge -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}(*Model[Container, Plate, "96-well 2mL Deep Well Plate"]*)
				}
			]},
			TimeConstraint -> 1800
		],

		Example[{Options,LiquidLiquidExtractionContainer, "If heating or cooling is specified, then the extraction container will be set to a 96-well 2mL deep well plate (since the robotic heater/cooler units are only compatible with Plate format containers):"},
		  ExperimentExtractRNA[
			Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
			LiquidLiquidExtractionTemperature -> 90.0*Celsius,
			Output -> {Result, Options}
		  ],
		  {ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
			{
			  LiquidLiquidExtractionContainer -> {1,ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}(*Model[Container, Plate, "96-well 2mL Deep Well Plate"]*)
			}
		  ]},
		  TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionContainer, "If the sample will be centrifuged and the extraction will take place at ambient temperature, then the extraction container will be selected using the PreferredContainer function (to find a robotic-compatible container that will hold the sample):"},
		  ExperimentExtractRNA[
			Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
			LiquidLiquidExtractionCentrifuge -> True,
			LiquidLiquidExtractionTemperature -> Ambient,
			Output -> {Result, Options}
		  ],
		  {ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
			{
			  LiquidLiquidExtractionContainer -> Alternatives[{(_Integer), ObjectP[Model[Container]]}, ObjectP[Model[Container]]]
			}
		  ]},
		  TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionContainerWell -- *)
		Example[{Options,LiquidLiquidExtractionContainerWell, "If a liquid-liquid extraction container is specified, then the first available well in the container will be used by default:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionContainerWell -> "A1"
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- AqueousSolvent -- *)
		Example[{Options,AqueousSolvent, "If aqueous solvent is required for a separation, then water (Milli-Q water) will be used as the aqueous solvent:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 3,
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				LiquidLiquidExtractionSelectionStrategy -> Positive,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					AqueousSolvent -> ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]](*Model[Sample,"Milli-Q water"]*)
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- AqueousSolventVolume -- *)
		Example[{Options,AqueousSolventVolume, "If an aqueous solvent ratio is set, then the aqueous solvent volume is calculated from the ratio and the sample volume (SampleVolume/AqueousSolventRatio):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				AqueousSolventRatio -> 5,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					AqueousSolventVolume -> EqualP[0.04*Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, {AqueousSolventVolume, AqueousSolventRatio}, "AqueousSolventVolume is set to 20% of the sample volume and AqueousSolventRatio is set to 5 if an aqueous solvent is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				AqueousSolvent -> Model[Sample, "id:8qZ1VWNmdLBD"],(*Model[Sample,"Milli-Q water"]*)
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					AqueousSolventVolume -> EqualP[0.04*Milliliter],
					AqueousSolventRatio -> EqualP[5.0]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- AqueousSolventRatio -- *)
		Example[{Options,AqueousSolventRatio, "If an aqueous solvent volume is set, then the aqueous solvent ratio is calculated from the set aqueous solvent volume and the sample volume (SampleVolume/AqueousSolventVolume):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				AqueousSolventVolume -> 0.04*Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					AqueousSolventRatio -> EqualP[5.0]
				}
			]},
			TimeConstraint -> 1800
		],
		(* -- OrganicSolvent -- *)
		Example[{Options, {OrganicSolvent, OrganicSolventVolume}, "OrganicSolvent is set to Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"] and OrganicSolventVolume is calculated from the ratio and the sample volume (SampleVolume/OrganicSolventRatio) if OrganicSolventRatio is specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				OrganicSolventRatio -> 5,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],
					OrganicSolventVolume -> EqualP[0.04*Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Test[{"If an organic solvent volume or organic solvent ratio are specified, then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				OrganicSolventVolume -> 0.2*Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,OrganicSolvent, "If the target phase is set to Organic and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTargetPhase -> Organic,
				LiquidLiquidExtractionSelectionStrategy -> Positive,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,OrganicSolvent, "If the target phase is set to Aqueous and the selection strategy is set to Positive (implying addition of organic solvent during later extraction rounds), then a phenol:chloroform:iso-amyl alcohol mixture (often used in phenol-chloroform extractions, Model[Sample, \"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture\"]) will be used as the organic solvent:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				LiquidLiquidExtractionSelectionStrategy -> Negative,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					OrganicSolvent -> ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]
				}
			]},
			TimeConstraint -> 1800
		],
		(*FIXME::Refuses to use ethyl acetate as organic solvent for some reason even though absolute ethanol is less dense. Tracked it down to possible issue with PredictSolventPhase because it's saying sample in Ethanol is Unknown phase with no solvent nor density. Add back in when fix is determined.*)
		(*Example[{Options,OrganicSolvent, "If organic solvent is otherwise required for an extraction and a phase separator will be used to physically separate the phases/layers (LiquidLiquidExtractionTechnique -> PhaseSeparator), then ethyl acetate (Model[Sample, \"Ethyl acetate, HPLC Grade\"]) will be used as the organic solvent if it is denser than the aqueous phase, since the organic layer needs to be below the aqueous layer to pass through the hydrophobic frit:"},
		  ExperimentExtractRNA[
			Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
			LiquidLiquidExtractionTechnique -> PhaseSeparator,
			Output -> {Result, Options}
		  ],
		  {ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
			{
			  OrganicSolvent -> ObjectP[Model[Sample, "Ethyl acetate, HPLC Grade"]]
			}
		  ],
		  TimeConstraint -> 1800
		],*)

		Example[{Options, {OrganicSolventVolume, OrganicSolventRatio}, "OrganicSolventVolume is set to 20% of the sample volume and OrganicSolventRatio is set to 5 if OrganicSolvent is set:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				OrganicSolvent -> Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					OrganicSolventVolume -> EqualP[0.04*Milliliter],
					OrganicSolventRatio -> EqualP[5.0]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- OrganicSolventRatio -- *)
		Example[{Options,OrganicSolventRatio, "If an organic solvent volume is set, then the organic solvent ratio is calculated from the set organic solvent volume and the sample volume (SampleVolume/OrganicSolventVolume):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				OrganicSolventVolume -> 0.04*Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					OrganicSolventRatio -> EqualP[5.0]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionSolventAdditions -- *)
		Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an organic or unknown phase, then an aqueous solvent is added to that sample:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 3,
				LiquidLiquidExtractionTargetPhase -> Organic,
				LiquidLiquidExtractionSelectionStrategy -> Negative,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSolventAdditions -> {{ObjectP[], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of any extraction round is in an aqueous phase, then organic solvent is added to that sample:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 3,
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				LiquidLiquidExtractionSelectionStrategy -> Negative,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSolventAdditions -> {{ObjectP[Model[Sample, "Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]..}}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionSolventAdditions, "If the starting sample of an extraction is biphasic, then no solvent is added for the first extraction:"},
			ExperimentExtractRNA[
				Object[Sample, "Biphasic extracted RNA sample 8 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSolventAdditions -> {None, ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]}
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- Demulsifier -- *)
		Example[{Options,Demulsifier, "If the demulsifier additions are specified, then the specified demulsifier will be used:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DemulsifierAdditions -> {Model[Sample, StockSolution, "5M Sodium Chloride"], None, None},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					Demulsifier -> ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,Demulsifier, "If a demulsifier amount is specified, then a 5M sodium chloride solution will be used as the demulsifier:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				DemulsifierAmount -> 0.1*Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					Demulsifier -> ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,Demulsifier, "If no demulsifier options are specified, then a demulsifier is not used:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					Demulsifier -> None
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- DemulsifierAmount -- *)
		Example[{Options,DemulsifierAmount, "If demulsifier and/or demulsifier additions are specified, then the demulsifier amount is set to 10% of the sample volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					DemulsifierAmount -> EqualP[0.02*Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- DemulsifierAdditions -- *)
		Example[{Options, {DemulsifierAdditions, LiquidLiquidExtractionTemperature, NumberOfLiquidLiquidExtractions, LiquidLiquidExtractionMixType, ImpurityLayerStorageCondition, ImpurityLayerContainerOut, ImpurityLayerLabel, ImpurityLayerContainerLabel}, "DemulsifierAdditions is set to None (for all rounds of extraction), LiquidLiquidExtractionTemperature is set to Ambient, NumberOfLiquidLiquidExtractions is set to 3, LiquidLiquidExtractionMixType is set to Pipette, ImpurityLayerStorageCondition is set to Disposal, ImpurityLayerContainerOut is determined by the PreferredContainer function, ImpurityLayerLabel and ImpurityLayerContainerLabel are automatically generated:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> LiquidLiquidExtraction,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					DemulsifierAdditions -> {None, None, None},
					LiquidLiquidExtractionTemperature -> Ambient,
					NumberOfLiquidLiquidExtractions -> 3,
					LiquidLiquidExtractionMixType -> Pipette,
					ImpurityLayerStorageCondition -> Disposal,
					ImpurityLayerContainerOut -> ObjectP[Model[Container]],
					ImpurityLayerLabel -> (_String),
					ImpurityLayerContainerLabel -> (_String)
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,DemulsifierAdditions, "If there will only be one round of liquid-liquid extraction and a demulsifier is specified, then the demulsifier will be added for that one extraction round:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 1,
				Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the organic phase will be used in subsequent extraction rounds, then the demulsifier will be added for each extraction round (since the demulsifier will likely be removed with the aqueous phase each round):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 3,
				Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
				LiquidLiquidExtractionTargetPhase -> Organic,
				LiquidLiquidExtractionSelectionStrategy -> Negative,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]]..}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,DemulsifierAdditions, "If there will be multiple rounds of liquid-liquid extraction, a demulsifier is specified, and the aqueous phase will be used in subsequent extraction rounds, then the demulsifier will only be added for the first extraction round (since the demulsifier is usually a salt solution which stays in the aqueous phase):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfLiquidLiquidExtractions -> 3,
				Demulsifier -> Model[Sample, StockSolution, "5M Sodium Chloride"],
				LiquidLiquidExtractionTargetPhase -> Aqueous,
				LiquidLiquidExtractionSelectionStrategy -> Negative,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					DemulsifierAdditions -> {ObjectP[Model[Sample, StockSolution, "5M Sodium Chloride"]], None, None}
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionMixType -- *)
		Example[{Options,LiquidLiquidExtractionMixType, "If a mixing time or mixing rate for the liquid-liquid extraction is specified, then the sample will be shaken (since a mixing time or rate does not pertain to pipette mixing):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionMixTime -> 1*Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionMixType -> Shake
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionMixTime -- *)
		Example[{Options, {LiquidLiquidExtractionMixTime, LiquidLiquidExtractionMixRate}, "LiquidLiquidExtractionMixTime is set to 30 Seconds and LiquidLiquidExtractionMixRate is set to 300 RPM if LiquidLiquidExtractionMixType is set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionMixTime -> EqualP[30*Second],
					LiquidLiquidExtractionMixRate -> EqualP[300 Revolution/Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfLiquidLiquidExtractionMixes -- *)
		Example[{Options,NumberOfLiquidLiquidExtractionMixes, "If the liquid-liquid extraction mixture will be mixed by pipette, then the number of mixes (number of times the liquid-liquid extraction mixture is pipetted up and down) is set to 10 by default:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfLiquidLiquidExtractionMixes -> 10
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionMixVolume -- *)
		Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is less than 970 microliters, then that volume will be used as the mixing volume for the pipette mixing:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionMixType -> Pipette,
				OrganicSolventVolume -> 0.2*Milliliter,
				NumberOfLiquidLiquidExtractions -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionMixVolume -> EqualP[0.2*Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionMixVolume, "If half of the liquid-liquid extraction mixture (the sample volume plus the entire volume of the added aqueous solvent, organic solvent, and demulsifier if specified) for each extraction is greater than 970 microliters, then 970 microliters (the maximum amount that can be mixed via pipette on the liquid handling robot) will be used as the mixing volume for the pipette mixing:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionMixType -> Pipette,
				OrganicSolventVolume -> 1.75*Milliliter,
				NumberOfLiquidLiquidExtractions -> 1,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionMixVolume -> EqualP[0.970*Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionSettlingTime -- *)
		Example[{Options, {LiquidLiquidExtractionSettlingTime, LiquidLiquidExtractionCentrifuge}, "LiquidLiquidExtractionSettlingTime is set to 1 Minute and LiquidLiquidExtractionCentrifuge is set to False if not otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification->{LiquidLiquidExtraction},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionSettlingTime -> EqualP[1*Minute],
					LiquidLiquidExtractionCentrifuge -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionCentrifuge -- *)
		Example[{Options,LiquidLiquidExtractionCentrifuge, "If any other centrifuging options are specified, then the liquid-liquid extraction solution will be centrifuged in order to separate the solvent phases:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionCentrifugeTime -> 1*Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionCentrifuge -> True
				}
			]},
			TimeConstraint -> 1800
		],
		(* -- LiquidLiquidExtractionCentrifugeInstrument -- *)
		Example[{Options,LiquidLiquidExtractionCentrifugeInstrument, "If the liquid-liquid extraction solution will be centrifuged, then the integrated centrifuge model on the chosen robotic instrument will be automatically used:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				RoboticInstrument -> Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"],
				LiquidLiquidExtractionCentrifuge -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionCentrifugeInstrument -> ObjectP[Model[Instrument,Centrifuge,"HiG4"]]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionCentrifugeIntensity -- *)
		Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is less than the MaxCentrifugationForce of the plate model (or the MaxCentrifugationForce of the plate model does not exist), the liquid-liquid extraction solution will be centrifuged at the MaxIntensity of the centrifuge model:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument,Centrifuge,"HiG4"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidLiquidExtractionCentrifugeIntensity, "If the liquid-liquid extraction solution will be centrifuged and the MaxIntensity of the centrifuge model is greater than the MaxCentrifugationForce of the plate model, the liquid-liquid extraction solution will be centrifuged at the MaxCentrifugationForce of the plate model:"},
		  ExperimentExtractRNA[
			Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
			LiquidLiquidExtractionCentrifugeInstrument -> Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], (*Model[Instrument, Centrifuge, "HiG4"]*)
			Output -> {Result, Options}
		  ],
		  {ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
			{
			  LiquidLiquidExtractionCentrifugeIntensity -> EqualP[3600 GravitationalAcceleration]
			}
		  ]},
		  TimeConstraint -> 1800
		],

		(* -- LiquidLiquidExtractionCentrifugeTime -- *)
		Example[{Options,LiquidLiquidExtractionCentrifugeTime, "If the liquid-liquid extraction solution will be centrifuged, the liquid-liquid extraction solution will be centrifuged for 2 minutes by default:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionCentrifuge -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidLiquidExtractionCentrifugeTime -> EqualP[2*Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- LiquidBoundaryVolume -- *)
		Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the top layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the sample container at the location of the layer boundary for each extraction round:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				NumberOfLiquidLiquidExtractions -> 1,
				LiquidLiquidExtractionTransferLayer -> {Top},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidBoundaryVolume -> {EqualP[0.02*Milliliter]}
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options,LiquidBoundaryVolume, "If the two layers of the liquid-liquid extraction solution will be physically separated using a pipette and the bottom layer will be transferred, the volume of the boundary between the layers will be set to a 5 millimeter tall cross-section of the bottom of the sample container for each extraction round:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionTechnique -> Pipette,
				NumberOfLiquidLiquidExtractions -> 1,
				LiquidLiquidExtractionTransferLayer -> {Bottom},
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					LiquidBoundaryVolume -> {EqualP[0.02*Milliliter]}
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- ImpurityLayerContainerOut -- *)
		Example[{Options,ImpurityLayerContainerOut, "If LiquidLiquidExtractionTargetPhase is set to Aqueous and LiquidLiquidExtractionTechnique is set to PhaseSeparator, ImpurityLayerContainerOut is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
		  ExperimentExtractRNA[
			Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
			LiquidLiquidExtractionTargetPhase -> Aqueous,
			LiquidLiquidExtractionTechnique -> PhaseSeparator,
			Output -> {Result, Options}
		  ],
		  {ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
			{
			  ImpurityLayerContainerOut -> ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]](*Model[Container, Plate, "96-well 2mL Deep Well Plate"]*)
			}
		  ]},
		  TimeConstraint -> 1800
		],

		(* -- ImpurityLayerContainerOutWell -- *)
		Example[{Options,ImpurityLayerContainerOutWell, "ImpurityLayerContainerOutWell is automatically set tot he first empty well of the ImpurityLayerContainerOut:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> LiquidLiquidExtraction,
				ImpurityLayerContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					ImpurityLayerContainerOutWell -> "A1"
				}
			]},
			TimeConstraint -> 1800
		],

		(*
		(* - Liquid-Liquid Extraction Errors - *)

		Example[{Messages, "LiquidLiquidExtractionOptionMismatch", "An error is returned if any liquid-liquid extraction options are set, but LiquidLiquidExtraction is not specified in Purification:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> {Precipitation},
				LiquidLiquidExtractionSettlingTime -> 1*Minute,
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::LiquidLiquidExtractionConflictingOptions,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],
		Example[{Messages, "LiquidLiquidExtractionSelectionStrategyOptionsMismatched", "A warning is returned if a selection strategy (LiquidLiquidExtractionSelectionStrategy) is specified, but there is only one liquid-liquid extraction round specified (NumberOfLiquidLiquidExtractions) since a selection strategy is only required for multiple rounds of liquid-liquid extraction:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				LiquidLiquidExtractionSelectionStrategy -> Positive,
				NumberOfLiquidLiquidExtractions -> 1,
				Output->Result
			],
			$Failed,
			Messages:>{
				Warning::LiquidLiquidExtractionSelectionStrategyNotNeeded
			},
			TimeConstraint -> 1800
		],
		Example[{Messages, "AqueousSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified aqueous solvent options (AqueousSolvent, AqueousSolventVolume, AqueousSolventRatio) for a sample:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				AqueousSolventVolume -> 0.2*Milliliter,
				AqueousSolventRatio -> Null,
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::AqueousSolventOptionsMismatched,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],
		Example[{Messages, "OrganicSolventOptionsMismatched", "An error is returned if there is a mix of specified and unspecified organic solvent options (OrganicSolvent, OrganicSolventVolume, OrganicSolventRatio) for a sample:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				OrganicSolventVolume -> 0.2*Milliliter,
				OrganicSolventRatio -> Null,
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::OrganicSolventOptionsMismatched,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		],
		Example[{Messages, "DemulsifierOptionsMismatched", "An error is returned if there is a mix of specified and unspecified demulsifier options (Demulsifier, DemulsifierAmount, DemulsifierAdditions):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Demulsifier -> None,
				DemulsifierAmount -> 0.1*Milliliter,
				Output->Result
			],
			$Failed,
			Messages:>{
				Error::DemulsifierOptionsMismatched,
				Error::InvalidOption
			},
			TimeConstraint -> 1800
		]
		*)


		(* -- MagneticBeadSeparationSelectionStrategy Tests -- *)
		(* -- MagneticBeadSeparationMode Tests -- *)
		(* -- MagneticBeadSeparationSampleVolume Tests -- *)
		(* -- MagneticBeadVolume Tests -- *)
		(* -- MagneticBeadCollectionStorageCondition Tests -- *)
		(* -- MagnetizationRack Tests -- *)
		(* -- MagneticBeadSeparationLoadingCollectionContainerLabel Tests -- *)
		(* -- MagneticBeadSeparationLoadingCollectionContainer Tests -- *)
		(* -- MagneticBeadSeparationLoadingMix Tests -- *)
		(* -- LoadingMagnetizationTime Tests -- *)
		(* -- MagneticBeadSeparationLoadingCollectionStorageCondition Tests -- *)
		(* -- MagneticBeadSeparationLoadingAirDry Tests -- *)
		Example[{Options, {MagneticBeadSeparationSelectionStrategy, MagneticBeadSeparationMode, MagneticBeadSeparationSampleVolume, MagneticBeadVolume, MagneticBeadCollectionStorageCondition, MagnetizationRack, MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationLoadingCollectionContainer, MagneticBeadSeparationLoadingMix, LoadingMagnetizationTime, MagneticBeadSeparationLoadingCollectionStorageCondition, MagneticBeadSeparationLoadingAirDry}, "MagneticBeadSeparationSelectionStrategy is set to Positive, MagneticBeadSeparationMode is set to NormalPhase, MagneticBeadSeparationSampleVolume is set to All (if the sample volume is less than 50% of the max container volume), MagneticBeadVolume is set to 1/10 of the MagneticBeadSeparationSampleVolume, MagneticBeadCollectionStorageCondition is set to Disposal, MagnetizationRack is set to Model[Item,MagnetizationRack,\"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"], MagneticBeadSeparationLoadingCollectionContainerLabel is automatically generated, MagneticBeadSeparationLoadingCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationLoadingMix is set to True, MagneticBeadSeparationLoadingMixType is set to Pipette, LoadingMagnetizationTime is set to 5 minutes, MagneticBeadSeparationLoadingCollectionStorageCondition is set to Refrigerator, and MagneticBeadSeparationLoadingAirDry is set to False by default:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> MagneticBeadSeparation,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				KeyValuePattern[
					{
						MagneticBeadSeparationSelectionStrategy -> Positive,
						MagneticBeadSeparationMode -> NormalPhase,
						MagneticBeadSeparationSampleVolume -> EqualP[0.2 Milliliter],
						MagneticBeadVolume -> EqualP[0.02 Milliliter],
						MagneticBeadCollectionStorageCondition -> Disposal,
						MagnetizationRack -> ObjectP[Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"]],(*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"]*)
						MagneticBeadSeparationLoadingCollectionContainerLabel -> {(_String)},
						MagneticBeadSeparationLoadingCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
						MagneticBeadSeparationLoadingMix -> True,
						MagneticBeadSeparationLoadingMixType -> Pipette,
						LoadingMagnetizationTime -> EqualP[5 Minute],
						MagneticBeadSeparationLoadingCollectionStorageCondition -> Refrigerator,
						MagneticBeadSeparationLoadingAirDry -> False
					}
				]
			},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationAnalyteAffinityLabel Tests -- *)
		(* -- MagneticBeadAffinityLabel Tests -- *)
		(* -- MagneticBeads Tests -- *)
		(* NOTE:This test should be customized to your specific experiment if copied in. *)
		(* You may get Warning::GeneralResolvedMagneticBeads for your experiment, indicating we don't have a bead reccomendation for the combination of target and separation mode.*)
		Example[{Options, {MagneticBeadSeparationAnalyteAffinityLabel, MagneticBeadAffinityLabel, MagneticBeads}, "MagneticBeadSeparationAnalyteAffinityLabel is set to the first item in the Analytes field of the sample, MagneticBeadAffinityLabel is set to the first item in the Targets field of the target molecule object, and MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel if MagneticBeadSeparationMode is set to Affinity:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationMode -> Affinity,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationAnalyteAffinityLabel -> ObjectP[Model[Molecule, Oligomer]],
					MagneticBeadAffinityLabel -> Null,
					MagneticBeads -> Model[Sample, "id:lYq9jRxLBKjp"](* Model[Sample, \""Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)"\"] *)
				}
			]},
			Messages :> {Warning::GeneralResolvedMagneticBeads},(*We do not have any products that are Affinity beads for TotalRNA. MBS will choose beads and the user will see the warning to indicate that beads were selected for them*)
			TimeConstraint -> 1800
		],

		Example[{Options, MagneticBeads, "If MagneticBeadSeparationMode is not set to Affinity, MagneticBeads is automatically set based on the MagneticBeadSeparationMode:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationMode -> NormalPhase,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeads -> Model[Sample, "id:eGakldaOxXje"] (* Model[Sample, \"MagBinding Beads\"] *)
				}
			]},
			TimeConstraint -> 1800
		],

		Example[{Options, {MagneticBeadSeparationPreWash, MagneticBeadSeparationEquilibration, MagneticBeadSeparationWash, MagneticBeadSeparationSecondaryWash, MagneticBeadSeparationTertiaryWash, MagneticBeadSeparationQuaternaryWash, MagneticBeadSeparationQuinaryWash, MagneticBeadSeparationSenaryWash, MagneticBeadSeparationSeptenaryWash}, "If no corresponding options (Solution, SolutionVolume, Mix, etc.) are set for a step (MagneticBeadSeparationPreWash, MagneticBeadSeparationEquilibration, MagneticBeadSeparationWash, MagneticBeadSeparationSecondaryWash, MagneticBeadSeparationTertiaryWash, MagneticBeadSeparationQuaternaryWash, MagneticBeadSeparationQuinaryWash, MagneticBeadSeparationSenaryWash, MagneticBeadSeparationSeptenaryWash), then the step is automatically set to False:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> MagneticBeadSeparation,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationWash -> False,
					MagneticBeadSeparationSecondaryWash -> False,
					MagneticBeadSeparationTertiaryWash -> False,
					MagneticBeadSeparationQuaternaryWash -> False,
					MagneticBeadSeparationQuinaryWash -> False,
					MagneticBeadSeparationSenaryWash -> False,
					MagneticBeadSeparationSeptenaryWash -> False,
					MagneticBeadSeparationEquilibration -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationPreWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationPreWashSolution, MagneticBeadSeparationPreWashSolutionVolume, MagneticBeadSeparationPreWashMix, MagneticBeadSeparationPreWashCollectionContainer, MagneticBeadSeparationPreWashCollectionStorageCondition, NumberOfMagneticBeadSeparationPreWashes, MagneticBeadSeparationPreWashAirDry}, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashCollectionContainerLabel is generated, MagneticBeadSeparationPreWashSolution is set to match the MagneticBeadSeparationElutionSolution, MagneticBeadSeparationPreWashSolutionVolume is set to the sample volume, MagneticBeadSeparationPreWashMix is set to True, MagneticBeadSeparationPreWashMixType is set to Pipette, MagneticBeadSeparationPreWashMixTemperature is set to Ambient, PreWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationPreWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationPreWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationPreWashes is set to 1, and MagneticBeadSeparationPreWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationPreWashSolution -> ObjectP[Model[Sample, "id:O81aEBZnWMRO"]],(*Model[Sample,"Nuclease-free Water"]*)
					MagneticBeadSeparationPreWashSolutionVolume -> EqualP[0.2 Milliliter],
					MagneticBeadSeparationPreWashMix -> True,
					MagneticBeadSeparationPreWashMixType -> Pipette,
					MagneticBeadSeparationPreWashMixTemperature -> Ambient,
					PreWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationPreWashCollectionContainer -> {{"A1",ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationPreWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationPreWashes -> 1,
					MagneticBeadSeparationPreWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationEquilibration Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationEquilibrationCollectionContainerLabel, MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationMix, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationEquilibrationMixTemperature, EquilibrationMagnetizationTime, MagneticBeadSeparationEquilibrationCollectionContainer, MagneticBeadSeparationEquilibrationCollectionStorageCondition, MagneticBeadSeparationEquilibrationAirDry}, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionContainerLabel is generated, MagneticBeadSeparationEquilibrationSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationEquilibrationMix is set to True, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette, MagneticBeadSeparationEquilibrationMixTemperature is set to Ambient, EquilibrationMagnetizationTime is set to 5 minutes, MagneticBeadSeparationEquilibrationCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationEquilibrationCollectionStorageCondition is set to Refrigerator, and MagneticBeadSeparationEquilibrationAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibration -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationEquilibrationSolution -> ObjectP[Model[Sample,"Milli-Q water"]],
					MagneticBeadSeparationEquilibrationMix -> True,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					MagneticBeadSeparationEquilibrationMixTemperature -> Ambient,
					EquilibrationMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationEquilibrationCollectionContainer -> {(_String), ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
					MagneticBeadSeparationEquilibrationCollectionStorageCondition -> Refrigerator,
					MagneticBeadSeparationEquilibrationAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashMix, MagneticBeadSeparationWashMixType, MagneticBeadSeparationWashMixTemperature, WashMagnetizationTime, MagneticBeadSeparationWashCollectionContainer, MagneticBeadSeparationWashCollectionStorageCondition, NumberOfMagneticBeadSeparationWashes, MagneticBeadSeparationWashAirDry}, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionContainerLabel is generated, MagneticBeadSeparationWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationWashMix is set to True, MagneticBeadSeparationWashMixType is automatically set to Pipette, MagneticBeadSeparationWashMixTemperature is set to Ambient, WashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationWashes is set to 1, and MagneticBeadSeparationWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationWashMix -> True,
					MagneticBeadSeparationWashMixType -> Pipette,
					MagneticBeadSeparationWashMixTemperature -> Ambient,
					WashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationWashes -> 1,
					MagneticBeadSeparationWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSecondaryWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationSecondaryWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashMix, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationSecondaryWashMixTemperature, SecondaryWashMagnetizationTime, MagneticBeadSeparationSecondaryWashCollectionContainer, MagneticBeadSeparationSecondaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSecondaryWashes, MagneticBeadSeparationSecondaryWashAirDry}, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionContainerLabel is generated, MagneticBeadSeparationSecondaryWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationSecondaryWashMix is set to True, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette, MagneticBeadSeparationSecondaryWashMixTemperature is set to Ambient, SecondaryWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationSecondaryWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationSecondaryWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationSecondaryWashes is set to 1, and MagneticBeadSeparationSecondaryWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWash -> True,
				(* Prior washes need to be True to avoid error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationSecondaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationSecondaryWashMix -> True,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					MagneticBeadSeparationSecondaryWashMixTemperature -> Ambient,
					SecondaryWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationSecondaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationSecondaryWashes -> 1,
					MagneticBeadSeparationSecondaryWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationTertiaryWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashMix, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationTertiaryWashMixTemperature, TertiaryWashMagnetizationTime, MagneticBeadSeparationTertiaryWashCollectionContainer, MagneticBeadSeparationTertiaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationTertiaryWashes, MagneticBeadSeparationTertiaryWashAirDry}, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionContainerLabel is generated, MagneticBeadSeparationTertiaryWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationTertiaryWashMix is set to True, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette, MagneticBeadSeparationTertiaryWashMixTemperature is automatically set to Ambient, TertiaryWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationTertiaryWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationTertiaryWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationTertiaryWashes is set to 1, and MagneticBeadSeparationTertiaryWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWash -> True,
				(* Prior washes need to be True to avoid error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationTertiaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationTertiaryWashMix -> True,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					MagneticBeadSeparationTertiaryWashMixTemperature -> Ambient,
					TertiaryWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationTertiaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationTertiaryWashes -> 1,
					MagneticBeadSeparationTertiaryWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuaternaryWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashMix, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuaternaryWashMixTemperature, QuaternaryWashMagnetizationTime, MagneticBeadSeparationQuaternaryWashCollectionContainer, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuaternaryWashes, MagneticBeadSeparationQuaternaryWashAirDry}, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel is generated, MagneticBeadSeparationQuaternaryWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationQuaternaryWashMix is set to True, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette, MagneticBeadSeparationQuaternaryWashMixTemperature is automatically set to Ambient, QuaternaryWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationQuaternaryWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationQuaternaryWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationQuaternaryWashes is set to 1, and MagneticBeadSeparationQuaternaryWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWash -> True,
				(* Prior washes need to be True to avoid error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationQuaternaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationQuaternaryWashMix -> True,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					MagneticBeadSeparationQuaternaryWashMixTemperature -> Ambient,
					QuaternaryWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationQuaternaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationQuaternaryWashes -> 1,
					MagneticBeadSeparationQuaternaryWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuinaryWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationQuinaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashMix, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationQuinaryWashMixTemperature, QuinaryWashMagnetizationTime, MagneticBeadSeparationQuinaryWashCollectionContainer, MagneticBeadSeparationQuinaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuinaryWashes, MagneticBeadSeparationQuinaryWashAirDry}, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionContainerLabel is generated, MagneticBeadSeparationQuinaryWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationQuinaryWashMix is set to True, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette, MagneticBeadSeparationQuinaryWashMixTemperature is automatically set to Ambient, QuinaryWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationQuinaryWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationQuinaryWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationQuinaryWashes is set to 1, and MagneticBeadSeparationQuinaryWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWash -> True,
				(* Prior washes need to be True to avoid error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationQuinaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationQuinaryWashMix -> True,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					MagneticBeadSeparationQuinaryWashMixTemperature -> Ambient,
					QuinaryWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationQuinaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationQuinaryWashes -> 1,
					MagneticBeadSeparationQuinaryWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSenaryWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashMix, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSenaryWashMixTemperature, SenaryWashMagnetizationTime, MagneticBeadSeparationSenaryWashCollectionContainer, MagneticBeadSeparationSenaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSenaryWashes, MagneticBeadSeparationSenaryWashAirDry}, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionContainerLabel is generated, MagneticBeadSeparationSenaryWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationSenaryWashMix is set to True, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette, MagneticBeadSeparationSenaryWashMixTemperature is automatically set to Ambient, SenaryWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationSenaryWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationSenaryWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationSenaryWashes is set to 1, and MagneticBeadSeparationSenaryWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWash -> True,
				(* Prior washes need to be True to avoid error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationSenaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationSenaryWashMix -> True,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					MagneticBeadSeparationSenaryWashMixTemperature -> Ambient,
					SenaryWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationSenaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationSenaryWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationSenaryWashes -> 1,
					MagneticBeadSeparationSenaryWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSeptenaryWash Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashMix, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixTemperature, SeptenaryWashMagnetizationTime, MagneticBeadSeparationSeptenaryWashCollectionContainer, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSeptenaryWashes, MagneticBeadSeparationSeptenaryWashAirDry}, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel is generated, MagneticBeadSeparationSeptenaryWashSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationSeptenaryWashMix is set to True, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette, MagneticBeadSeparationSeptenaryWashMixTemperature is automatically set to Ambient, SeptenaryWashMagnetizationTime is set to 5 minutes, MagneticBeadSeparationSeptenaryWashCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationSeptenaryWashCollectionStorageCondition is set to Refrigerator, NumberOfMagneticBeadSeparationSeptenaryWashes is set to 1, and MagneticBeadSeparationSeptenaryWashAirDry is set to False unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWash -> True,
				(* Prior washes need to be True to avoid error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationSeptenaryWashSolution -> ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"]],(*Model[Sample, StockSolution, "70% Ethanol"]*)
					MagneticBeadSeparationSeptenaryWashMix -> True,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					MagneticBeadSeparationSeptenaryWashMixTemperature -> Ambient,
					SeptenaryWashMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationSeptenaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
					MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationSeptenaryWashes -> 1,
					MagneticBeadSeparationSeptenaryWashAirDry -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationElution Options Tests -- *)
		Example[{Options, {MagneticBeadSeparationElutionCollectionContainerLabel, MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionMix, MagneticBeadSeparationElutionMixType, MagneticBeadSeparationElutionMixTemperature, ElutionMagnetizationTime, MagneticBeadSeparationElutionCollectionContainer, MagneticBeadSeparationElutionCollectionStorageCondition, NumberOfMagneticBeadSeparationElutions}, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionContainerLabel is generated, MagneticBeadSeparationElutionSolution is set to Model[Sample,\"Milli-Q water\"], MagneticBeadSeparationElutionMix is set to True, MagneticBeadSeparationElutionMixType is automatically set to Pipette, MagneticBeadSeparationElutionMixTemperature is automatically set to Ambient, ElutionMagnetizationTime is set to 5 minutes, MagneticBeadSeparationElutionCollectionContainer is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"], MagneticBeadSeparationElutionCollectionStorageCondition is set to Refrigerator, and NumberOfMagneticBeadSeparationElutions is set to 1 unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElution -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElutionCollectionContainerLabel -> {(_String)},
					MagneticBeadSeparationElutionSolution -> ObjectP[Model[Sample, "id:O81aEBZnWMRO"]],(*Model[Sample, "Nuclease-free Water"]*)
					MagneticBeadSeparationElutionMix -> True,
					MagneticBeadSeparationElutionMixType -> Pipette,
					MagneticBeadSeparationElutionMixTemperature -> Ambient,
					ElutionMagnetizationTime -> EqualP[5 Minute],
					MagneticBeadSeparationElutionCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]},
					MagneticBeadSeparationElutionCollectionStorageCondition -> Refrigerator,
					NumberOfMagneticBeadSeparationElutions -> 1
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparation Step Tests -- *)
		Example[{Options, {MagneticBeadSeparationPreWash, MagneticBeadSeparationEquilibration, MagneticBeadSeparationWash, MagneticBeadSeparationSecondaryWash, MagneticBeadSeparationTertiaryWash, MagneticBeadSeparationQuaternaryWash, MagneticBeadSeparationQuinaryWash, MagneticBeadSeparationSenaryWash, MagneticBeadSeparationSeptenaryWash}, "If any corresponding options (Solution, SolutionVolume, Mix, etc.) are set for a wash, loading, equilibration, or elution step (MagneticBeadSeparationPreWashMixType, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationWashMixType, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationElutionMixType), then the step is automatically set to True:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMix -> True,
				MagneticBeadSeparationEquilibrationMixType -> Shake,
				MagneticBeadSeparationWashMixType -> Shake,
				MagneticBeadSeparationSecondaryWashMixType -> Shake,
				MagneticBeadSeparationTertiaryWashMixType -> Shake,
				MagneticBeadSeparationQuaternaryWashMixType -> Shake,
				MagneticBeadSeparationQuinaryWashMixType -> Shake,
				MagneticBeadSeparationSenaryWashMixType -> Shake,
				MagneticBeadSeparationSeptenaryWashMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationEquilibration -> True,
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					MagneticBeadSeparationSeptenaryWash -> True
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparation MixType Tests -- *)
		Example[{Options, {MagneticBeadSeparationPreWashMixType, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationWashMixType, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationElutionMixType}, "If any shaking options (eg. MixTime) for a wash, loading, equilibration, or elution step (MagneticBeadSeparationPreWashMixType, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationWashMixType, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationElutionMixType) are set, the MixType for that step is automatically set to Shake:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMixRate -> 200 RPM,
				MagneticBeadSeparationEquilibrationMixTime -> 1 Minute,
				MagneticBeadSeparationLoadingMixTime -> 1 Minute,
				MagneticBeadSeparationWashMixTime -> 1 Minute,
				MagneticBeadSeparationSecondaryWashMixTime -> 1 Minute,
				MagneticBeadSeparationTertiaryWashMixTime -> 1 Minute,
				MagneticBeadSeparationQuaternaryWashMixTime -> 1 Minute,
				MagneticBeadSeparationQuinaryWashMixTime -> 1 Minute,
				MagneticBeadSeparationSenaryWashMixTime -> 1 Minute,
				MagneticBeadSeparationSeptenaryWashMixTime -> 1 Minute,
				MagneticBeadSeparationElutionMixTime -> 1 Minute,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashMixType -> Shake,
					MagneticBeadSeparationEquilibrationMixType -> Shake,
					MagneticBeadSeparationLoadingMixType -> Shake,
					MagneticBeadSeparationWashMixType -> Shake,
					MagneticBeadSeparationSecondaryWashMixType -> Shake,
					MagneticBeadSeparationTertiaryWashMixType -> Shake,
					MagneticBeadSeparationQuaternaryWashMixType -> Shake,
					MagneticBeadSeparationQuinaryWashMixType -> Shake,
					MagneticBeadSeparationSenaryWashMixType -> Shake,
					MagneticBeadSeparationSeptenaryWashMixType -> Shake,
					MagneticBeadSeparationElutionMixType -> Shake
				}
			]},
			TimeConstraint -> 1800
		],

		Example[{Options, {MagneticBeadSeparationPreWashMixType, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationWashMixType, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationElutionMixType}, "If any pipetting options (eg. MixVolume) for a wash, loading, equilibration, or elution step (MagneticBeadSeparationPreWashMixType, MagneticBeadSeparationEquilibrationMixType, MagneticBeadSeparationLoadingMixType, MagneticBeadSeparationWashMixType, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationElutionMixType) are set, the MixType for that step is automatically set to Pipette:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMixVolume -> 0.1 Milliliter,
				NumberOfMagneticBeadSeparationEquilibrationMixes -> 10,
				NumberOfMagneticBeadSeparationLoadingMixes -> 10,
				NumberOfMagneticBeadSeparationWashMixes -> 10,
				NumberOfMagneticBeadSeparationSecondaryWashMixes -> 10,
				NumberOfMagneticBeadSeparationTertiaryWashMixes -> 10,
				NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 10,
				NumberOfMagneticBeadSeparationQuinaryWashMixes -> 10,
				NumberOfMagneticBeadSeparationSenaryWashMixes -> 10,
				NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 10,
				NumberOfMagneticBeadSeparationElutionMixes -> 10,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashMixType -> Pipette,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					MagneticBeadSeparationLoadingMixType -> Pipette,
					MagneticBeadSeparationWashMixType -> Pipette,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					MagneticBeadSeparationElutionMixType -> Pipette
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationPreWashMixTime Tests -- *)
		Example[{Options, MagneticBeadSeparationPreWashMixTime, "If MagneticBeadSeparationPreWashMixType is set to Shake, MagneticBeadSeparationPreWashMixTime is automatically set to 5 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashMixTime -> EqualP[5 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationPreWashMixes Tests -- *)
		(* -- MagneticBeadSeparationPreWashMixTipType Tests -- *)
		(* -- MagneticBeadSeparationPreWashMixTipMaterial Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationPreWashMixes, MagneticBeadSeparationPreWashMixTipType, MagneticBeadSeparationPreWashMixTipMaterial}, "If MagneticBeadSeparationPreWashMixType is set to Pipette, NumberOfMagneticBeadSeparationPreWashMixes is automatically set to 20, MagneticBeadSeparationPreWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationPreWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationPreWashMixes -> 20,
					MagneticBeadSeparationPreWashMixTipType -> WideBore,
					MagneticBeadSeparationPreWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationPreWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashMixType -> Pipette,
				MagneticBeadSeparationPreWashSolutionVolume -> 1.95 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationPreWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationPreWashAspirationVolume, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashAspirationVolume is automatically set to the MagneticBeadSeparationPreWashSolutionVolume unless otherwise specified:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationPreWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationPreWashAirDryTime, "If MagneticBeadSeparationPreWashAirDry is True, MagneticBeadSeparationPreWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWashAirDry -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationPreWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationEquilibrationSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationEquilibrationSolutionVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibration -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationSolutionVolume -> EqualP[0.1 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationEquilibrationMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationEquilibrationMixTime, MagneticBeadSeparationEquilibrationMixRate}, "If MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixTime is automatically set to 5 minutesand MagneticBeadSeparationEquilibrationMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibrationMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationEquilibrationMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationEquilibrationMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationEquilibrationMixes, MagneticBeadSeparationEquilibrationMixTipType, MagneticBeadSeparationEquilibrationMixTipMaterial}, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, NumberOfMagneticBeadSeparationEquilibrationMixes is automatically set to 20, MagneticBeadSeparationEquilibrationMixTipType is automatically set to WideBore, and MagneticBeadSeparationEquilibrationMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibrationMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationEquilibrationMixes -> 20,
					MagneticBeadSeparationEquilibrationMixTipType -> WideBore,
					MagneticBeadSeparationEquilibrationMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationEquilibrationMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 80% of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 80% of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibrationMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 80% of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibrationMixType -> Pipette,
				MagneticBeadSeparationEquilibrationSolutionVolume -> 1.95 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationEquilibrationAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationEquilibrationAspirationVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationAspirationVolume is automatically set the same as the MagneticBeadSeparationEquilibrationSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibration -> True,
				MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationEquilibrationAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationEquilibrationAirDryTime, "If MagneticBeadSeparationEquilibrationAirDry is set to True, MagneticBeadSeparationEquilibrationAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationEquilibrationAirDry -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationEquilibrationAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationLoadingMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationLoadingMixTime, MagneticBeadSeparationLoadingMixRate}, "If MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixTime is automatically set to 5 minutes and MagneticBeadSeparationLoadingMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationLoadingMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationLoadingMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationLoadingMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationLoadingMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationLoadingMixes, MagneticBeadSeparationLoadingMixTipType, MagneticBeadSeparationLoadingMixTipMaterial}, "If MagneticBeadSeparationLoadingMixType is set to Pipette, NumberOfMagneticBeadSeparationLoadingMixes is automatically set to 20, MagneticBeadSeparationLoadingMixTipType is automatically set to WideBore, and MagneticBeadSeparationLoadingMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationLoadingMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationLoadingMixes -> 20,
					MagneticBeadSeparationLoadingMixTipType -> WideBore,
					MagneticBeadSeparationLoadingMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationLoadingMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and 80% of the MagneticBeadSeparationSampleVolume is less than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 80% of the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationLoadingMixType -> Pipette,
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadVolume -> 0.02 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationLoadingMixVolume -> EqualP[0.176 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and set to 80% of the MagneticBeadSeparationSampleVolume is greater than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationLoadingMixType -> Pipette,
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadVolume -> 1.8 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationLoadingMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationLoadingMixTemperature Tests -- *)
		Example[{Options, MagneticBeadSeparationLoadingMixTemperature, "If MagneticBeadSeparationLoadingMix is set to True, MagneticBeadSeparationLoadingMixTemperature is automatically set to Ambient:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationLoadingMix -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationLoadingMixTemperature -> Ambient
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationLoadingAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationLoadingAspirationVolume, "MagneticBeadSeparationLoadingAspirationVolume is automatically set the same as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationLoadingAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationLoadingAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationLoadingAirDryTime, "If MagneticBeadSeparationLoadingAirDry is set to True, MagneticBeadSeparationLoadingAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationLoadingAirDry -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationLoadingAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationWashSolutionVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashSolutionVolume -> EqualP[0.1 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationWashMixTime, MagneticBeadSeparationWashMixRate}, "If MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWashMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationWashMixes, MagneticBeadSeparationWashMixTipType, MagneticBeadSeparationWashMixTipMaterial}, "If MagneticBeadSeparationWashMixType is set to Pipette, NumberOfMagneticBeadSeparationWashMixes is automatically set to 20, MagneticBeadSeparationWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWashMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationWashMixes -> 20,
					MagneticBeadSeparationWashMixTipType -> WideBore,
					MagneticBeadSeparationWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWashMixType -> Pipette,
				MagneticBeadSeparationWashSolutionVolume -> 1.95 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationWashAspirationVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashAspirationVolume is automatically set the same as the MagneticBeadSeparationWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationWashAirDryTime, "If MagneticBeadSeparationWashAirDry is set to True, MagneticBeadSeparationWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationWashAirDry -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSecondaryWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				MagneticBeadSeparationSecondaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWash -> False,
				MagneticBeadSeparationSecondaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSecondaryWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationSecondaryWashMixTime, MagneticBeadSeparationSecondaryWashMixRate}, "If MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationSecondaryWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWashMixType -> Shake,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationSecondaryWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationSecondaryWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationSecondaryWashMixes, MagneticBeadSeparationSecondaryWashMixTipType, MagneticBeadSeparationSecondaryWashMixTipMaterial}, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSecondaryWashMixes is automatically set to 20, MagneticBeadSeparationSecondaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationSecondaryWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWashMixType -> Pipette,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationSecondaryWashMixes -> 20,
					MagneticBeadSeparationSecondaryWashMixTipType -> WideBore,
					MagneticBeadSeparationSecondaryWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSecondaryWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWashMixType -> Pipette,
				MagneticBeadSeparationSecondaryWashSolutionVolume -> 1.95 Milliliter,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSecondaryWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSecondaryWashAspirationVolume, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSecondaryWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSecondaryWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationSecondaryWashAirDryTime, "If MagneticBeadSeparationSecondaryWashAirDry is set to True, MagneticBeadSeparationSecondaryWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSecondaryWashAirDry -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSecondaryWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationTertiaryWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				MagneticBeadSeparationTertiaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWash -> False,
				MagneticBeadSeparationTertiaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationTertiaryWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationTertiaryWashMixTime, MagneticBeadSeparationTertiaryWashMixRate}, "If MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationTertiaryWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWashMixType -> Shake,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationTertiaryWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationTertiaryWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationTertiaryWashMixes, MagneticBeadSeparationTertiaryWashMixTipType, MagneticBeadSeparationTertiaryWashMixTipMaterial}, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationTertiaryWashMixes is automatically set to 20, MagneticBeadSeparationTertiaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationTertiaryWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWashMixType -> Pipette,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationTertiaryWashMixes -> 20,
					MagneticBeadSeparationTertiaryWashMixTipType -> WideBore,
					MagneticBeadSeparationTertiaryWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationTertiaryWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWashMixType -> Pipette,
				MagneticBeadSeparationTertiaryWashSolutionVolume -> 1.95 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationTertiaryWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationTertiaryWashAspirationVolume, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationTertiaryWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationTertiaryWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationTertiaryWashAirDryTime, "If MagneticBeadSeparationTertiaryWashAirDry is set to True, MagneticBeadSeparationTertiaryWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationTertiaryWashAirDry -> True,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationTertiaryWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuaternaryWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				MagneticBeadSeparationQuaternaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWash -> False,
				MagneticBeadSeparationQuaternaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuaternaryWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationQuaternaryWashMixTime, MagneticBeadSeparationQuaternaryWashMixRate}, "If MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationQuaternaryWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWashMixType -> Shake,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationQuaternaryWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationQuaternaryWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationQuaternaryWashMixes, MagneticBeadSeparationQuaternaryWashMixTipType, MagneticBeadSeparationQuaternaryWashMixTipMaterial}, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuaternaryWashMixes is automatically set to 20, MagneticBeadSeparationQuaternaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationQuaternaryWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 20,
					MagneticBeadSeparationQuaternaryWashMixTipType -> WideBore,
					MagneticBeadSeparationQuaternaryWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuaternaryWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
				MagneticBeadSeparationQuaternaryWashSolutionVolume -> 1.95 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuaternaryWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationQuaternaryWashAspirationVolume, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuaternaryWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuaternaryWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationQuaternaryWashAirDryTime, "If MagneticBeadSeparationQuaternaryWashAirDry is set to True, MagneticBeadSeparationQuaternaryWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuaternaryWashAirDry -> True,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuaternaryWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuinaryWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				MagneticBeadSeparationQuinaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWash -> False,
				MagneticBeadSeparationQuinaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuinaryWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationQuinaryWashMixTime, MagneticBeadSeparationQuinaryWashMixRate}, "If MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationQuinaryWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWashMixType -> Shake,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationQuinaryWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationQuinaryWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationQuinaryWashMixes, MagneticBeadSeparationQuinaryWashMixTipType, MagneticBeadSeparationQuinaryWashMixTipMaterial}, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuinaryWashMixes is automatically set to 20, MagneticBeadSeparationQuinaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationQuinaryWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWashMixType -> Pipette,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationQuinaryWashMixes -> 20,
					MagneticBeadSeparationQuinaryWashMixTipType -> WideBore,
					MagneticBeadSeparationQuinaryWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuinaryWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWashMixType -> Pipette,
				MagneticBeadSeparationQuinaryWashSolutionVolume -> 1.95 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuinaryWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationQuinaryWashAspirationVolume, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuinaryWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationQuinaryWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationQuinaryWashAirDryTime, "If MagneticBeadSeparationQuinaryWashAirDry is set to True, MagneticBeadSeparationQuinaryWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationQuinaryWashAirDry -> True,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationQuinaryWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSenaryWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				MagneticBeadSeparationSenaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWash -> False,
				MagneticBeadSeparationSenaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSenaryWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationSenaryWashMixTime, MagneticBeadSeparationSenaryWashMixRate}, "If MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationSenaryWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWashMixType -> Shake,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationSenaryWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationSenaryWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationSenaryWashMixes, MagneticBeadSeparationSenaryWashMixTipType, MagneticBeadSeparationSenaryWashMixTipMaterial}, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSenaryWashMixes is automatically set to 20, MagneticBeadSeparationSenaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationSenaryWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWashMixType -> Pipette,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationSenaryWashMixes -> 20,
					MagneticBeadSeparationSenaryWashMixTipType -> WideBore,
					MagneticBeadSeparationSenaryWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSenaryWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWashMixType -> Pipette,
				MagneticBeadSeparationSenaryWashSolutionVolume -> 1.95 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSenaryWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSenaryWashAspirationVolume, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSenaryWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWash -> True,
				MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSenaryWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationSenaryWashAirDryTime, "If MagneticBeadSeparationSenaryWashAirDry is set to True, MagneticBeadSeparationSenaryWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSenaryWashAirDry -> True,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSenaryWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSeptenaryWashSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationPreWash -> True,
				MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
				MagneticBeadSeparationSeptenaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				MagneticBeadSeparationPreWash -> False,
				MagneticBeadSeparationSeptenaryWash -> True,
				(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSeptenaryWashMixTime Tests -- *)
		Example[{Options, {MagneticBeadSeparationSeptenaryWashMixTime, MagneticBeadSeparationSeptenaryWashMixRate}, "If MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixTime is automatically set to 5 minutes and MagneticBeadSeparationSeptenaryWashMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWashMixType -> Shake,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationSeptenaryWashMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationSeptenaryWashMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationSeptenaryWashMixes, MagneticBeadSeparationSeptenaryWashMixTipType, MagneticBeadSeparationSeptenaryWashMixTipMaterial}, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSeptenaryWashMixes is automatically set to 20, MagneticBeadSeparationSeptenaryWashMixTipType is automatically set to WideBore, and MagneticBeadSeparationSeptenaryWashMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 20,
					MagneticBeadSeparationSeptenaryWashMixTipType -> WideBore,
					MagneticBeadSeparationSeptenaryWashMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSeptenaryWashMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 80% of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 80% of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
				MagneticBeadSeparationSeptenaryWashSolutionVolume -> 1.95 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSeptenaryWashAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationSeptenaryWashAspirationVolume, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSeptenaryWashSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWash -> True,
				MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationSeptenaryWashAirDryTime Tests -- *)
		Example[{Options, MagneticBeadSeparationSeptenaryWashAirDryTime, "If MagneticBeadSeparationSeptenaryWashAirDry is set to True, MagneticBeadSeparationSeptenaryWashAirDryTime is automatically set to 1 Minute:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationSeptenaryWashAirDry -> True,
				(* Prior washes need to be set to True to avoid an error. *)
				MagneticBeadSeparationWash -> True,
				MagneticBeadSeparationSecondaryWash -> True,
				MagneticBeadSeparationTertiaryWash -> True,
				MagneticBeadSeparationQuaternaryWash -> True,
				MagneticBeadSeparationQuinaryWash -> True,
				MagneticBeadSeparationSenaryWash -> True,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationSeptenaryWashAirDryTime -> EqualP[1 Minute]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationElution Tests -- *)
		Example[{Options, MagneticBeadSeparationElution, "If any magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.), MagneticBeadSeparationElution is automatically set to True:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElution -> True
				}
			]},
			TimeConstraint -> 1800
		],

		Example[{Options, {MagneticBeadSeparationElutionMixTime, MagneticBeadSeparationElutionMixRate}, "If MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixTime is automatically set to 5 minutes, and MagneticBeadSeparationElutionMixRate is automatically set to 300 RPM:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixType -> Shake,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElutionMixTime -> EqualP[5 Minute],
					MagneticBeadSeparationElutionMixRate -> EqualP[300 RPM]
				}
			]},
			TimeConstraint -> 1800
		],

		Example[{Options, MagneticBeadSeparationElution, "If MagneticBeadSeparationSelectionStrategy is Positive, MagneticBeadSeparationElution is automatically set to True:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> MagneticBeadSeparation,
				MagneticBeadSeparationSelectionStrategy -> Positive,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElution -> True
				}
			]},
			TimeConstraint -> 1800
		],

		Example[{Options, MagneticBeadSeparationElution, "If no magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.) and MagneticBeadSeparationSelectionStrategy is Negative, MagneticBeadSeparationElution is automatically set to False:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> MagneticBeadSeparation,
				MagneticBeadSeparationSelectionStrategy -> Negative,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElution -> False
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationElutionSolutionVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationElutionSolutionVolume, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionSolutionVolume is automatically set 1/10 of the MagneticBeadSeparationSampleVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElution -> True,
				MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElutionSolutionVolume -> EqualP[0.02 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationElutionMixes Tests -- *)
		Example[{Options, {NumberOfMagneticBeadSeparationElutionMixes, MagneticBeadSeparationElutionMixTipType, MagneticBeadSeparationElutionMixTipMaterial}, "If MagneticBeadSeparationElutionMixType is set to Pipette, NumberOfMagneticBeadSeparationElutionMixes is automatically set to 20, MagneticBeadSeparationElutionMixTipType is automatically set to WideBore, andMagneticBeadSeparationElutionMixTipMaterial is automatically set to Polypropylene:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixType -> Pipette,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationElutionMixes -> 20,
					MagneticBeadSeparationElutionMixTipType -> WideBore,
					MagneticBeadSeparationElutionMixTipMaterial -> Polypropylene
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationElutionMixVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 80% of the combined MagneticBeadSeparationElutionSolutionVolume and MagneticBeadVolume is less than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 80% of theMagneticBeadSeparationElutionSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixType -> Pipette,
				MagneticBeadVolume -> 0.2 Milliliter,
				MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElutionMixVolume -> EqualP[0.32 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],
		Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 80% of the MagneticBeadSeparationElutionSolutionVolume is greater than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 970 microliters:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElutionMixType -> Pipette,
				MagneticBeadSeparationElutionSolutionVolume -> 1.95 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElutionMixVolume -> EqualP[0.970 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparationElutionAspirationVolume Tests -- *)
		Example[{Options, MagneticBeadSeparationElutionAspirationVolume, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionAspirationVolume is automatically set the same as the MagneticBeadSeparationElutionSolutionVolume:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				MagneticBeadSeparationElution -> True,
				MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					MagneticBeadSeparationElutionAspirationVolume -> EqualP[0.2 Milliliter]
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- NumberOfMagneticBeadSeparationElutions Tests -- *)
		Example[{Options, NumberOfMagneticBeadSeparationElutions, "If NumberOfMagneticBeadSeparationElutions is set to larger than 1, samples collected from multiple rounds are pooled to one container (and to one well if applicable):"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				NumberOfMagneticBeadSeparationElutions -> 3,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, RoboticCellPreparation]], KeyValuePattern[
				{
					NumberOfMagneticBeadSeparationElutions -> 3,
					MagneticBeadSeparationElutionCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}
				}
			]},
			TimeConstraint -> 1800
		],

		(* -- MagneticBeadSeparation collection container formats -- *)
		Example[{Options, {MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer}, "The collection containers can be specied in a variety of formats for all stages of magnetic bead separation:"},
			ExperimentExtractRNA[
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Purification -> MagneticBeadSeparation,
				MagneticBeadSeparationPreWashCollectionContainer -> {"A1", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
				NumberOfMagneticBeadSeparationPreWashes -> 2,
				MagneticBeadSeparationEquilibrationCollectionContainer -> {"A2", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
				MagneticBeadSeparationLoadingCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				MagneticBeadSeparationWashCollectionContainer -> {"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
				NumberOfMagneticBeadSeparationWashes -> 1,
				MagneticBeadSeparationSecondaryWashCollectionContainer -> {"A1", {2, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
				NumberOfMagneticBeadSeparationSecondaryWashes -> 3,
				NumberOfMagneticBeadSeparationElutions -> 2,
				MagneticBeadSeparationElutionCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				Output -> Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 1800
		],
		(* -- MagneticBeadSeparation collection container formats -- *)
		Example[{Options, {MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer}, "For multiple input samples, the collection containers can be specied in a variety of formats for all stages of magnetic bead separation:"},
			ExperimentExtractRNA[{
				Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
				Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID]
			},
				Purification -> MagneticBeadSeparation,
				MagneticBeadSeparationPreWashCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
				NumberOfMagneticBeadSeparationPreWashes -> 2,
				MagneticBeadSeparationEquilibrationCollectionContainer -> {{"A2", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}, {"A1",Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
				MagneticBeadSeparationLoadingCollectionContainer -> {"A1", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
				MagneticBeadSeparationWashCollectionContainer -> {"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
				NumberOfMagneticBeadSeparationWashes -> 1,
				MagneticBeadSeparationSecondaryWashCollectionContainer -> {{"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}}, {"A2", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}}},
				NumberOfMagneticBeadSeparationSecondaryWashes -> 3,
				NumberOfMagneticBeadSeparationElutions -> 2,
				MagneticBeadSeparationElutionCollectionContainer -> {Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
				Output -> Result
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 1800
		]



	},
Parallel -> True,
TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct, Warning::ConflictingSourceAndDestinationAsepticHandling},
SymbolSetUp :> (
	Block[{$AllowPublicObjects = True},
	Module[
		{
			existsFilter,
			method0, method1, method2, method3, method4, method5, method6, method7, method8,
			tube0, plate0, plate1, plate2, plate3, plate4, plate5, plate6, plate7, plate8, plate9, plate10, plate11, plate12, plate13,
			targetAnalyte0,
			sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12a, sample12b, sample13, sample14
		},

		$CreatedObjects = {};

		existsFilter = DatabaseMemberQ[{
			Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test miRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test RNA extraction method LLE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test RNA extraction method SPE+Precipitation purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test mRNA extraction method, Liquid Liquid Extraction (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Container, Vessel, "Test 50mL sample tube 0 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 0 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 1 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 2 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 3 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 4 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 5 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 6 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 7 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 8 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 9 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 10 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 11 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 12 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 13 for ExperimentExtractRNA "<>$SessionUUID],
			Model[Molecule, Oligomer, "Test target analyte for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Water test sample 0 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Discarded mammalian cell sample 5 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Solid media bacteria cell sample 6 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Biphasic extracted RNA sample 8 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 12a for plate with multiple samples "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 12b for plate with multiple samples "<>$SessionUUID],
			Object[Sample, "Living cell sample with unspecified cell type for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 14 with small volume for ExperimentExtractRNA "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
			Object[Method, Extraction, RNA, "Test Method 2 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
			Object[Method, Extraction, RNA, "Test Method 3 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
			Object[Method, Extraction, RNA, "Test Invalid Method 1 for method validity check test (Test for ExperimentExtractRNA) " <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
					Object[Method, Extraction, RNA, "Test miRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
					Object[Method, Extraction, RNA, "Test RNA extraction method LLE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
					Object[Method, Extraction, RNA, "Test RNA extraction method SPE+Precipitation purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
					Object[Method, Extraction, RNA, "Test mRNA extraction method, Liquid Liquid Extraction (Test for ExperimentExtractRNA) "<>$SessionUUID],
					Object[Container, Vessel, "Test 50mL sample tube 0 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 0 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 1 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 2 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 3 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 4 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 5 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 6 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 7 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 8 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 9 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 10 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 11 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 12 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Container, Plate, "Test 96-well sample plate 13 for ExperimentExtractRNA "<>$SessionUUID],
					Model[Molecule, Oligomer, "Test target analyte for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Water test sample 0 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Discarded mammalian cell sample 5 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Solid media bacteria cell sample 6 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Biphasic extracted RNA sample 8 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Extracted RNA sample 12a for plate with multiple samples "<>$SessionUUID],
					Object[Sample, "Extracted RNA sample 12b for plate with multiple samples "<>$SessionUUID],
					Object[Sample, "Living cell sample with unspecified cell type for ExperimentExtractRNA "<>$SessionUUID],
					Object[Sample, "Extracted RNA sample 14 with small volume for ExperimentExtractRNA "<>$SessionUUID],
					Object[Method, Extraction, RNA, "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
					Object[Method, Extraction, RNA, "Test Method 2 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
					Object[Method, Extraction, RNA, "Test Method 3 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
					Object[Method, Extraction, RNA, "Test Invalid Method 1 for method validity check test (Test for ExperimentExtractRNA) " <> $SessionUUID]
				},
				existsFilter
			],
			Force -> True,
			Verbose -> False
		];

		(* Upload Test Method Objects *)

		{method0, method1, method2, method3, method4, method5, method6, method7, method8} = Upload[{
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test TotalRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				CellType -> Mammalian,
				TargetCellularComponent -> RNA,
				TargetRNA -> TotalRNA,
				Lyse -> True,
				HomogenizeLysate -> True,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionWashSolution -> Link[Model[Sample, "Milli-Q water"]],
				SecondarySolidPhaseExtractionWashSolution -> Link[Model[Sample, "Milli-Q water"]],
				TertiarySolidPhaseExtractionWashSolution -> Link[Model[Sample, "Milli-Q water"]]
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test miRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				CellType -> Mammalian,
				TargetCellularComponent -> RNA,
				TargetRNA -> miRNA,
				Lyse -> True,
				HomogenizeLysate -> True,
				Purification -> {SolidPhaseExtraction},
				SolidPhaseExtractionSorbent -> Silica
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test RNA extraction method LLE purification (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				CellType -> Mammalian,
				TargetCellularComponent -> RNA,
				TargetRNA -> Unspecified,
				Lyse -> True,
				HomogenizeLysate -> False,
				Purification -> {LiquidLiquidExtraction},
				LiquidLiquidExtractionTechnique -> Pipette,
				LiquidLiquidExtractionTargetPhase -> Aqueous
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test RNA extraction method SPE+Precipitation purification (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				CellType -> Mammalian,
				TargetCellularComponent -> RNA,
				TargetRNA -> Unspecified,
				Lyse -> True,
				HomogenizeLysate -> False,
				Purification -> {SolidPhaseExtraction, Precipitation},
				SolidPhaseExtractionStrategy -> Positive,
				SolidPhaseExtractionTechnique -> AirPressure
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test mRNA extraction method, Liquid Liquid Extraction (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				CellType -> Null,
				TargetCellularComponent -> RNA,
				TargetRNA -> mRNA,
				Lyse -> True,
				HomogenizeLysate -> False,
				Purification -> LiquidLiquidExtraction
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				Lyse -> False,
				HomogenizeLysate -> False,
				Purification -> {MagneticBeadSeparation},
				MagneticBeadSeparationSelectionStrategy -> Positive,
				MagneticBeadSeparationMode -> IonExchange
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test Method 2 for Conflicting MBS options (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				Lyse -> False,
				HomogenizeLysate -> False,
				Purification -> {MagneticBeadSeparation},
				MagneticBeadSeparationSelectionStrategy -> Positive,
				MagneticBeadSeparationMode -> ReversePhase(*Differs with 1*)
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test Method 3 for Conflicting MBS options (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				Lyse -> False,
				HomogenizeLysate -> False,
				Purification -> {MagneticBeadSeparation},
				MagneticBeadSeparationSelectionStrategy -> Negative, (*Differs with 1*)
				MagneticBeadSeparationMode -> IonExchange
			|>,
			<|
				Type -> Object[Method, Extraction, RNA],
				Name -> "Test Invalid Method 1 for method validity check test (Test for ExperimentExtractRNA) "<>$SessionUUID,
				DeveloperObject -> True,
				CellType -> Mammalian,
				TargetCellularComponent -> RNA,
				TargetRNA -> TotalRNA,
				Lyse -> False,
				Purification -> {SolidPhaseExtraction}
			|>
		}];

		(* Upload Test Containers *)

		{tube0} = {Upload[
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL sample tube 0 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>
		]};

		{plate0, plate1, plate2, plate3, plate4, plate5, plate6, plate7, plate8, plate9, plate10, plate11, plate12, plate13} = Upload[{
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 0 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 1 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 2 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 3 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 4 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 5 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 6 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 7 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 8 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 9 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 10 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 11 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 12 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Objects],
				Name -> "Test 96-well sample plate 13 for ExperimentExtractRNA "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>
		}];

		{targetAnalyte0} = {UploadOligomer[
			ToStrand["AUGCGUCUAUCGUGUACUCGACUGUCACGAGCAGCUCUAGC"],
			RNA,
			"Test target analyte for ExperimentExtractRNA "<>$SessionUUID,
			PolymerType -> RNA
		]};

		{sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12a, sample12b, sample13, sample14} = UploadSample[
			{
				{{100 VolumePercent, Model[Molecule, "Water"]}},
				{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
				{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
				{{100 VolumePercent, Model[Lysate, "Simple Western Control HeLa Lysate"]}},
				{{100 VolumePercent, Model[Molecule, "Water"]}}, (* TODO :: change to RNA sample *)
				{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
				{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
				{{100 VolumePercent, Model[Molecule, "Water"]}}, (* TODO :: change to RNA sample *)
				{{50 VolumePercent, Model[Molecule, "Ethyl acetate"]},{50 VolumePercent, Model[Molecule, "Water"]}}, (* TODO :: change to RNA sample *)
				{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
				{{10^10 EmeraldCell/Milliliter, Model[Cell, Mammalian, "HEK293"]}},
				{{100 VolumePercent, Model[Molecule, "Water"]}}, (* TODO :: change to RNA sample *)
				{{100 VolumePercent, Model[Molecule, "Water"]}},
				{{100 VolumePercent, Model[Molecule, "Water"]}},
				{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
				{{100 VolumePercent, Model[Molecule, "Water"]}} (* TODO :: change to RNA sample *)
			},
			(*{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, targetAnalyte0}},
			{{95 VolumePercent, Model[Cell, Mammalian, "HEK293"]}, {5 VolumePercent, targetAnalyte0}},
			{{95 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}, {5 VolumePercent, targetAnalyte0}},
			{{95 VolumePercent, Model[Lysate, "Simple Western Control HeLa Lysate"]}, {5 VolumePercent, targetAnalyte0}},
			{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, targetAnalyte0}}, (* TODO :: change to RNA sample *)
			{{95 VolumePercent, Model[Cell, Mammalian, "HEK293"]}, {5 VolumePercent, targetAnalyte0}},
			{{95 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}, {5 VolumePercent, targetAnalyte0}}*)
			{
				{"A1", plate0},
				{"A1", plate1},
				{"A1", plate2},
				{"A1", plate3},
				{"A1", plate4},
				{"A1", plate5},
				{"A1", plate6},
				{"A1", tube0},
				{"A1", plate7},
				{"A1", plate8},
				{"A1", plate9},
				{"A1", plate10},
				{"A1", plate11},
				{"B1", plate11},
				{"A1", plate12},
				{"A1", plate13}
			},
			Name -> {
				"Water test sample 0 for ExperimentExtractRNA "<>$SessionUUID,
				"Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID,
				"Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID,
				"Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID,
				"Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID,
				"Discarded mammalian cell sample 5 for ExperimentExtractRNA "<>$SessionUUID,
				"Solid media bacteria cell sample 6 for ExperimentExtractRNA "<>$SessionUUID,
				"Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID,
				"Biphasic extracted RNA sample 8 for ExperimentExtractRNA "<>$SessionUUID,
				"Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID,
				"Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID,
				"Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID,
				"Extracted RNA sample 12a for plate with multiple samples "<>$SessionUUID,
				"Extracted RNA sample 12b for plate with multiple samples "<>$SessionUUID,
				"Living cell sample with unspecified cell type for ExperimentExtractRNA "<>$SessionUUID,
				"Extracted RNA sample 14 with small volume for ExperimentExtractRNA "<>$SessionUUID
			},
			InitialAmount -> {
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.2 Milliliter,
				0.03 Milliliter
			},
			CellType -> {
				Null,
				Mammalian,
				Bacterial,
				Mammalian,
				Null,
				Mammalian,
				Bacterial,
				Null,
				Null,
				Mammalian,
				Mammalian,
				Null,
				Null,
				Null,
				Null,
				Null
			},
			CultureAdhesion -> {
				Null,
				Adherent,
				Suspension,
				Null,
				Null,
				Adherent,
				SolidMedia,
				Null,
				Null,
				Suspension,
				Suspension,
				Null,
				Null,
				Null,
				Adherent,
				Null
			},
			Living -> {
				False,
				True,
				True,
				False,
				False,
				True,
				True,
				False,
				False,
				True,
				True,
				False,
				False,
				False,
				True,
				False
			},
			State -> Liquid,
			FastTrack -> True,
			StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"]
		];

		Map[
			Upload[{
				<|
					Object -> #,
					Status -> Available,
					DeveloperObject -> True,
					Append[Analytes] -> Link[targetAnalyte0]
				|>
			}]&,
			{sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12a, sample12b, sample13, sample14}
		];

		Upload[<|Object -> sample5, Status -> Discarded|>];

	]
	]),

SymbolTearDown :> (
	Module[{allObjects, existsFilter},

		(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects = Cases[Flatten[{
			Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test miRNA extraction method SPE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test RNA extraction method LLE purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test RNA extraction method SPE+Precipitation purification (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test mRNA extraction method, Liquid Liquid Extraction (Test for ExperimentExtractRNA) "<>$SessionUUID],
			Object[Container, Vessel, "Test 50mL sample tube 0 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 0 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 1 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 2 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 3 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 4 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 5 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 6 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 7 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 8 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 9 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 10 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 11 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 12 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Container, Plate, "Test 96-well sample plate 13 for ExperimentExtractRNA "<>$SessionUUID],
			Model[Molecule, Oligomer, "Test target analyte for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Water test sample 0 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Adherent mammalian cell sample 1 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Suspension bacteria cell sample 2 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Mammalian cell lysate sample 3 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 4 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Discarded mammalian cell sample 5 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Solid media bacteria cell sample 6 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA in tube sample 7 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Biphasic extracted RNA sample 8 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Suspension mammalian cell sample 9 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Suspension mammalian cell sample with cell concentration 10 for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 11 for ExtractionPrecipitationSharedOptions in ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 12a for plate with multiple samples "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 12b for plate with multiple samples "<>$SessionUUID],
			Object[Sample, "Living cell sample with unspecified cell type for ExperimentExtractRNA "<>$SessionUUID],
			Object[Sample, "Extracted RNA sample 14 with small volume for ExperimentExtractRNA "<>$SessionUUID],
			Object[Method, Extraction, RNA, "Test Method 1 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
			Object[Method, Extraction, RNA, "Test Method 2 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
			Object[Method, Extraction, RNA, "Test Method 3 for Conflicting MBS options (Test for ExperimentExtractRNA) " <> $SessionUUID],
			Object[Method, Extraction, RNA, "Test Invalid Method 1 for method validity check test (Test for ExperimentExtractRNA) " <> $SessionUUID]
		}], ObjectP[]];

		(* Erase any objects that we failed to erase in the last unit test *)
		existsFilter = DatabaseMemberQ[allObjects];

		Quiet[EraseObject[
			PickList[
				allObjects,
				existsFilter
			],
			Force -> True,
			Verbose -> False
		]];
	]
),
Skip -> "Tests frequently time out even with high ram and parallel threads. Skipping for now, but will remove the skip before starting any in-lab tests/runs."
];


(* ::Subsubsection::Closed:: *)
(*ExtractRNA*)

DefineTests[ExtractRNA,
	{

		Example[{Basic, "Form an ExtractRNA unit operation:"},
			ExtractRNA[
				Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID]
			],
			_ExtractRNA
		],

		Example[{Basic, "A RoboticCellPreparation protocol is generated when calling ExtractRNA:"},
			ExperimentRoboticCellPreparation[
				{
					ExtractRNA[
						Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID]
					]
				}
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 3200
		](*,

		(* TODO::Determine why labeling is not working for ExtractRNA when trying to pass on labeled samples. *)
		Example[{Basic, "A RoboticCellPreparation protocol is generated when calling ExtractRNA preceded and followed by other unit operations:"},
			ExperimentRoboticCellPreparation[
				{
					Mix[
						Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID]
					],
					ExtractRNA[
						Sample -> Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID],
						ExtractedRNALabel -> "Extracted RNA Sample (Test for ExtractRNA) " <> $SessionUUID
					],
					Transfer[
						Source -> "Extracted RNA Sample (Test for ExtractRNA) " <> $SessionUUID,
						Amount -> All,
						Destination -> Model[Container, Vessel, "50mL Tube"]
					]
				}
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]],
			TimeConstraint -> 3200
		]*)

	},
	SymbolSetUp :> Module[{existsFilter, plate1, sample1},
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter = DatabaseMemberQ[{
			Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID],
			Object[Container, Plate, "Test Plate 1 for ExtractRNA " <> $SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID],
					Object[Container, Plate, "Test Plate 1 for ExtractRNA " <> $SessionUUID]
				},
				existsFilter
			],
			Force -> True,
			Verbose -> False
		];

		plate1 = Upload[
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test Plate 1 for ExtractRNA " <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>
		];

		(* Create some samples for testing purposes *)
		sample1 = UploadSample[
			(* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
			{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
			{"A1", plate1},
			Name -> "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID,
			InitialAmount -> 0.2 Milliliter,
			CellType -> Bacterial,
			CultureAdhesion -> Suspension,
			Living -> True,
			State -> Liquid,
			StorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
			FastTrack -> True
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample1}];

	],
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[Flatten[{
				Object[Sample, "Suspended Bacterial Cell Sample (Test for ExtractRNA) " <> $SessionUUID],
				Object[Container, Plate, "Test Plate 1 for ExtractRNA " <> $SessionUUID]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	),
	Skip -> "Tests frequently time out even with high ram and parallel threads. Skipping for now, but will remove the skip before starting any in-lab tests/runs."
];