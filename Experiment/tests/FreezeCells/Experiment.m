(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* Unit Testing *)

(* ::Subsection::Closed:: *)
(* ExperimentFreezeCells *)


DefineTests[ExperimentFreezeCells,
	{
		(* ===Basic=== *)
		Example[{Basic, "Freeze a cell suspension sample in situ:"},
			ExperimentFreezeCells[
				Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Basic, "Prepare multiple frozen cell stocks from a cell suspension sample:"},
			ExperimentFreezeCells[
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				NumberOfReplicates -> 4
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Basic, "Freeze multiple cell suspension samples into cryogenic vials:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"]
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Basic, "Create a protocol object to Freeze a cell from a vessel container:"},
			ExperimentFreezeCells[
				Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Basic, "Create a protocol object to Freeze a cell from a plate container:"},
			ExperimentFreezeCells[
				Object[Container, Plate, "Test 24-well Plate 1 for ExperimentFreezeCells "<>$SessionUUID],
				NumberOfReplicates -> 4
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		(* ===Options=== *)
		(* Options: Sample Properties *)
		Example[{Options, CellType, "Specify the taxon of the organism or cell line from which the cell sample originates using the CellType option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CellType -> Bacterial,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellType -> Bacterial
			}]
		],
		Example[{Options, CellType, "If the CellType option is not specified, it is automatically set to the value of the CellType field in the input sample object, if available:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellType -> Yeast
			}]
		],
		Example[{Options, CultureAdhesion, "Specify the manner in which the cell sample physically interacts with its current container using the CultureAdhesion option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CultureAdhesion -> Suspension,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CultureAdhesion -> Suspension
			}]
		],
		Example[{Options, CultureAdhesion, "If the CultureAdhesion option is not specified, it is automatically set to the value of the CultureAdhesion field in the input sample object, if available:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CultureAdhesion -> Suspension
			}]
		],
		(* Options: Master Switches *)
		Example[{Options, CryoprotectionStrategy, "Specify the manner in which the cells are protected from potentially deleterious ice formation using the CryoprotectionStrategy option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolution -> ObjectP[Model[Sample, StockSolution, "50% Glycerol in Milli-Q water, Autoclaved"]],
				CellPelletCentrifuge -> Null
			}]
		],
		Example[{Options, CryoprotectionStrategy, "If CellPelletCentrifuge is specified, CryoprotectionStrategy is automatically set to ChangeMedia:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletCentrifuge -> Model[Instrument, Centrifuge, "Sterile Microfuge 16"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia
			}]
		],
		Example[{Options, CryoprotectionStrategy, "If CellPelletTime is specified, CryoprotectionStrategy is automatically set to ChangeMedia:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletTime -> 10 Minute,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia
			}]
		],
		Example[{Options, CryoprotectionStrategy, "If CellPelletIntensity is specified, CryoprotectionStrategy is automatically set to ChangeMedia:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletIntensity -> 700 GravitationalAcceleration,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia
			}]
		],
		Example[{Options, CryoprotectionStrategy, "If CellPelletSupernatantVolume is specified, CryoprotectionStrategy is automatically set to ChangeMedia:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletSupernatantVolume -> All,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia
			}]
		],
		Example[{Options, FreezingStrategy, "Specify the manner in which the cells are to be frozen using the FreezingStrategy option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				InsulatedCoolerFreezingTime -> 12 Hour
			}]
		],
		Example[{Options, FreezingStrategy, "If the TemperatureProfile option is specified, FreezingStrategy is set to ControlledRateFreezer:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				TemperatureProfile -> {{-10 Celsius, 30 Minute}, {-60 Celsius, 120 Minute}},
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> ControlledRateFreezer
			}]
		],
		Example[{Options, FreezingStrategy, "If the InsulatedCoolerFreezingTime option is specified, FreezingStrategy is set to InsulatedCooler:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				InsulatedCoolerFreezingTime -> 8.5 Hour,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler
			}]
		],
		Example[{Options, FreezingStrategy, "If the Coolant option is specified, FreezingStrategy is set to InsulatedCooler:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Coolant -> Model[Sample, "Isopropanol"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler
			}]
		],
		(* Options: ChangeMedia *)
		Example[{Options, CellPelletCentrifuge, "Specify the instrument used to pellet the cell sample(s) using the CellPelletCentrifuge option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CellPelletCentrifuge -> Model[Instrument, Centrifuge, "Sterile Microfuge 16"],
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia,
				CellPelletCentrifuge -> ObjectP[Model[Instrument, Centrifuge, "Sterile Microfuge 16"]]
			}]
		],
		Example[{Options, CellPelletCentrifuge, "If CryoprotectionStrategy is ChangeMedia, the CellPelletCentrifuge option is automatically set to a centrifuge suitable for the current container of the sample(s):"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletCentrifuge -> ObjectP[Model[Instrument, Centrifuge]]
			}]
		],
		Test["If the CryprotectionStrategy is ChangeMedia and CellPelletCentrifuge is not specified, the CellPelletCentrifuge resolves to a centrifuge Model which is not Deprecated and which has at least one Object[Instrument, Centrifuge] at ECL:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia
			];
			centrifugeModel = First[Download[protocol, CellPelletCentrifuges]];
			{deprecated, centrifugeObjects} = Download[centrifugeModel, {Deprecated, Objects}];
			{deprecated, Length[centrifugeObjects]},
			{Except[True], GreaterP[0]},
			Variables :> {protocol, centrifugeModel, deprecated, centrifugeObjects}
		],
		Example[{Options, CellPelletCentrifuge, "If CryoprotectionStrategy is AddCryoprotectant, the CellPelletCentrifuge option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletCentrifuge -> Null
			}]
		],
		Example[{Options, CellPelletCentrifuge, "If CryoprotectionStrategy is None, the CellPelletCentrifuge option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletCentrifuge -> Null
			}]
		],
		Example[{Options, CellPelletTime, "Specify the duration for which the cell sample(s) are pelleted using the CellPelletTime option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletTime -> 10 Minute,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletTime -> 10 Minute
			}]
		],
		Example[{Options, CellPelletTime, "If CryoprotectionStrategy is ChangeMedia, the CellPelletTime option is automatically set to 5 Minute:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletTime -> 5 Minute
			}]
		],
		Example[{Options, CellPelletTime, "If CryoprotectionStrategy is AddCryoprotectant, the CellPelletTime option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletTime -> Null
			}]
		],
		Example[{Options, CellPelletTime, "If CryoprotectionStrategy is None, the CellPelletTime option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletTime -> Null
			}]
		],
		Example[{Options, CellPelletIntensity, "Specify the rotational speed or force at which the cell sample(s) are pelleted using the CellPelletIntensity option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletIntensity -> 1000 RPM,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletIntensity -> 1000 RPM
			}]
		],
		Example[{Options, CellPelletIntensity, "If CryoprotectionStrategy is ChangeMedia, the CellPelletIntensity option is automatically set to a gravitational acceleration appropriate for the CellType of the sample(s):"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletIntensity -> $LivingBacterialCentrifugeIntensity
			}]
		],
		Example[{Options, CellPelletIntensity, "If CryoprotectionStrategy is AddCryoprotectant, the CellPelletIntensity option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletIntensity -> Null
			}]
		],
		Example[{Options, CellPelletIntensity, "If CryoprotectionStrategy is None, the CellPelletIntensity option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletIntensity -> Null
			}]
		],
		Example[{Options, CellPelletSupernatantVolume, "Specify the volume of supernatant to be removed following pelleting of the cell sample(s) using the CellPelletSupernatantVolume option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellPelletSupernatantVolume -> All,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletSupernatantVolume -> All
			}]
		],
		Example[{Options, CellPelletSupernatantVolume, "If CryoprotectionStrategy is ChangeMedia, the CellPelletSupernatantVolume option is automatically set to All:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletSupernatantVolume -> All
			}]
		],
		Example[{Options, CellPelletSupernatantVolume, "If CryoprotectionStrategy is AddCryoprotectant, the CellPelletSupernatantVolume option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletSupernatantVolume -> Null
			}]
		],
		Example[{Options, CellPelletSupernatantVolume, "If CryoprotectionStrategy is None, the CellPelletSupernatantVolume option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CellPelletSupernatantVolume -> Null
			}]
		],
		(* Options: Other Cryoprotection *)
		Example[{Options, CryoprotectantSolution, "Specify the substance used to reduce ice formation during freezing using the CryoprotectantSolution option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectantSolution -> Model[Sample, "DMSO, anhydrous"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolution -> ObjectP[Model[Sample, "DMSO, anhydrous"]]
			}]
		],
		Example[{Options, CryoprotectantSolution, "If CryoprotectionStrategy is ChangeMedia and the CellType is Mammalian, the CryoprotectantSolution option is automatically set to Model[Sample, \"Gibco Recovery Cell Culture Freezing Medium\"]:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolution -> ObjectP[Model[Sample, "Gibco Recovery Cell Culture Freezing Medium"]]
			}]
		],
		Example[{Options, CryoprotectantSolution, "If CryoprotectionStrategy is ChangeMedia and the CellType is Bacterial, the CryoprotectantSolution option is automatically set to Model[Sample, StockSolution, \"15% glycerol, 0.5% sodium chloride, Autoclaved\"]:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolution -> ObjectP[Model[Sample, StockSolution, "15% glycerol, 0.5% sodium chloride, Autoclaved"]]
			}]
		],
		Example[{Options, CryoprotectantSolution, "If CryoprotectionStrategy is ChangeMedia and the CellType is Bacterial, the CryoprotectantSolution option is automatically set to Model[Sample, StockSolution, \"30% Glycerol in Milli-Q water, Autoclaved\"]:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolution -> ObjectP[Model[Sample, StockSolution, "30% Glycerol in Milli-Q water, Autoclaved"]]
			}]
		],
		Example[{Options, CryoprotectantSolution, "If CryoprotectionStrategy is AddCryoprotectant, the CryoprotectantSolution option is automatically set to Model[Sample, StockSolution, \"50% Glycerol in Milli-Q water, Autoclaved\"]:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolution -> ObjectP[Model[Sample, StockSolution, "50% Glycerol in Milli-Q water, Autoclaved"]]
			}]
		],
		Example[{Options, CryoprotectantSolution, "If CryoprotectionStrategy is None, the CryoprotectantSolution option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolution -> Null
			}]
		],
		Example[{Options, CryoprotectantSolutionVolume, "Specify the amount of cryoprotectant used to reduce ice formation during freezing using the CryoprotectantSolutionVolume option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectantSolutionVolume -> 300 Microliter,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionVolume -> 300 Microliter
			}]
		],
		Example[{Options, CryoprotectantSolutionVolume, "If CryoprotectionStrategy is ChangeMedia, the CryoprotectantSolutionVolume option is automatically set to 100% of the CellPelletSupernatantVolume that is removed following pelleting:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CellPelletSupernatantVolume -> All,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionVolume -> EqualP[500 Microliter]
			}]
		],
		Example[{Options, CryoprotectantSolutionVolume, "If CryoprotectionStrategy is ChangeMedia, the CryoprotectantSolutionVolume option is automatically set to 100% of the CellPelletSupernatant volume that is removed following pelleting:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CellPelletSupernatantVolume -> 300 Microliter,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionVolume -> EqualP[300 Microliter]
			}]
		],
		Example[{Options, CryoprotectantSolutionVolume, "If CryoprotectionStrategy is AddCryoprotectant, the CryoprotectantSolutionVolume option is automatically set to 50% of the volume of the input sample:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionVolume -> EqualP[0.25 Milliliter]
			}]
		],
		Example[{Options, CryoprotectantSolutionVolume, "If CryoprotectionStrategy is None, the CryoprotectantSolutionVolume option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionVolume -> Null
			}]
		],
		Example[{Options, CryoprotectantSolutionTemperature, "Specify the temperature at which the CryoprotectantSolution is maintained prior to its addition to the cell sample(s) using the CryoprotectantSolutionTemperature option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectantSolutionTemperature -> Ambient,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionTemperature -> Ambient
			}]
		],
		Example[{Options, CryoprotectantSolutionTemperature, "If CryoprotectionStrategy is ChangeMedia, the CryoprotectantSolutionTemperature option is automatically set to Chilled:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionTemperature -> Chilled
			}]
		],
		Example[{Options, CryoprotectantSolutionTemperature, "If CryoprotectionStrategy is AddCryoprotectant, the CryoprotectantSolutionTemperature option is automatically set to Chilled:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionTemperature -> Chilled
			}]
		],
		Example[{Options, CryoprotectantSolutionTemperature, "If CryoprotectionStrategy is None, the CryoprotectantSolutionTemperature option is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryoprotectantSolutionTemperature -> Null
			}]
		],
		(* Options: Aliquoting *)
		Example[{Options, Aliquot, "Use the Aliquot option to specify whether a portion (or all) of the input cell sample is to be transferred to a new container prior to freezing:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True
			}]
		],
		Example[{Options, Aliquot, "If AliquotVolume is specified, the Aliquot option is automatically set to True and don't throw warning:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				AliquotVolume -> All,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True
			}]
		],
		Example[{Options, Aliquot, "If ContainersIn is a cryo vial but different than the the specified CryogenicSampleContainer, automatically set Aliquot to True and don't throw warning:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True
			}],
			Messages :> {Warning::FreezeCellsUnusedSample}
		],
		Example[{Options, Aliquot, "If NumberOfReplicates is specified, the Aliquot option is automatically set to True:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> 3,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True
			}]
		],
		Example[{Options, Aliquot, "If ContainersIn is not a cryo vial, automatically set Aliquot to True:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True
			}],
			Messages :> {
				Warning::FreezeCellsAliquotingRequired
			}
		],
		Example[{Options, Aliquot, "If ContainersIn is a 5 ml cryo vial, and FreezingStrategy is set to ControlledRateFreezer, automatically set Aliquot to True:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True
			}],
			Messages :> {
				Warning::FreezeCellsAliquotingRequired,
				Warning::FreezeCellsUnusedSample
			}
		],
		Example[{Options, Aliquot, "If ContainersIn is a cryo vial but adding CryoprotectantSolutionVolume will overfill the container (75% max vol), automatically set Aliquot to True and select a bigger cryovial if available:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolutionVolume -> 1.1 Milliliter,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> All,
				CryogenicSampleContainer -> ObjectP[Model[Container, Vessel, "5mL Cryogenic Vial"]]
			}],
			Messages :> {
				Warning::FreezeCellsAliquotingRequired
			}
		],
		Example[{Options, AliquotVolume, "Use the AliquotVolume option to specify how much of the input cell sample is to be transferred to a new container prior to freezing:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> All,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> All
			}]
		],
		Example[{Options, AliquotVolume, "If Aliquot is True and CryoprotectionStrategy is AddCryoprotectant, when the total volume of the cell sample is less than the 50% of MaxVolume of the CryogenicSampleContainer and no replica, AliquotVolume is automatically set to All:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> AddCryoprotectant,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> All
			}]
		],
		Example[{Options, AliquotVolume, "If Aliquot is True and CryoprotectionStrategy is None, when the total volume of the cell sample is less than the 75% of MaxVolume of the CryogenicSampleContainer and no replica, AliquotVolume is automatically set to All:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> None,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> All
			}]
		],
		Example[{Options, AliquotVolume, "If Aliquot is True and CryoprotectionStrategy is ChangeMedia, when the total volume of the suspended sample volume (remaining old media plus cryoprotectant) is less than the 75% of MaxVolume of the CryogenicSampleContainer and no replica, AliquotVolume is automatically set to All:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> All
			}]
		],
		Example[{Options, AliquotVolume, "If Aliquot is True and CryoprotectionStrategy is AddCryoprotectant, when the total volume of the cell sample is greater than the 50% of MaxVolume of the CryogenicSampleContainer, AliquotVolume is automatically set to 50% of the volume of the CryogenicSampleContainer:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 250mL Erlenmeyer Flask (Test for ExperimentFreezeCells) " <> $SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> AddCryoprotectant,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> EqualP[1 Milliliter]
			}],
			Messages :> {Warning::FreezeCellsUnusedSample}
		],
		Example[{Options, AliquotVolume, "If Aliquot is True and CryoprotectionStrategy is None, when the total volume of the cell sample is greater than the 50% of MaxVolume of the CryogenicSampleContainer, AliquotVolume is automatically set to 75% of the volume of the CryogenicSampleContainer:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 250mL Erlenmeyer Flask (Test for ExperimentFreezeCells) " <> $SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> None,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> EqualP[1.5 Milliliter]
			}],
			Messages :> {Warning::FreezeCellsUnusedSample}
		],
		Example[{Options, AliquotVolume, "If NumberOfReplicates is specified and CryoprotectionStrategy is AddCryoprotectant, set aliquot volume to the lesser of total volume of the cell sample divided by number of replica or the 50% of MaxVolume of the CryogenicSampleContainer:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> 2,
				CryoprotectionStrategy -> None,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> EqualP[0.25 Milliliter]
			}]
		],
		Example[{Options, AliquotVolume, "If NumberOfReplicates is Null but the sample sample appear in input with different options, set aliquot volume to the lesser of total volume of the cell sample divided by number of duplicates or the 50% of MaxVolume of the CryogenicSampleContainer:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> Null,
				Aliquot -> True,
				CryoprotectionStrategy -> {None, AddCryoprotectant},
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				AliquotVolume -> EqualP[0.25 Milliliter]
			}]
		],
		Example[{Options, AliquotVolume, "If Aliquot is False, AliquotVolume is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> False,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> False,
				AliquotVolume -> Null
			}]
		],
		Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to submit multiple experiments with identical option settings:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"],
				InsulatedCoolerFreezingTime -> 15 Hour,
				Coolant -> Model[Sample, "Isopropanol"],
				NumberOfReplicates -> 4,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				FreezingRack -> ObjectP[Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"]],
				InsulatedCoolerFreezingTime -> 15 Hour,
				Coolant -> ObjectP[Model[Sample, "Isopropanol"]],
				NumberOfReplicates -> 4
			}]
		],
		Example[{Options, NumberOfReplicates, "If NumberOfReplicates is not specified, it is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				NumberOfReplicates -> Null
			}]
		],
		Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to split input samples into replicates and pass the replicates to a subsequent unit operation:"},
			ExperimentCellPreparation[
				{
					FreezeCells[
						Sample -> {
							Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
							Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
						},
						Aliquot -> True,
						NumberOfReplicates -> 2,
						CryogenicSampleContainerLabel -> {"cryogenic vial A", "cryogenic vial B"}
					],
					Incubate[
						Sample -> {"cryogenic vial A replicate 1", "cryogenic vial A replicate 2", "cryogenic vial B replicate 1", "cryogenic vial B replicate 2"},
						Temperature -> {25 Celsius, 30 Celsius, 25 Celsius, 25 Celsius}
					]
				}
			],
			ObjectP[Object[Protocol, ManualCellPreparation]],
			Messages :> {
				Warning::FreezeCellsReplicateLabels
			}
		],
		Example[{Options, CryogenicSampleContainerLabel, "Specify the CryogenicSampleContainerLabel option to give the CryogenicSampleContainer a unique label:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryogenicSampleContainerLabel -> {"cryogenic vial 1"},
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryogenicSampleContainerLabel -> {"cryogenic vial 1"}
			}]
		],
		Example[{Options, CryogenicSampleContainerLabel, "When the NumberOfReplicates option is specified, the CryogenicSampleContainerLabel option expands to give each sample a unique label:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				NumberOfReplicates -> 2,
				CryogenicSampleContainerLabel -> {
					"cryogenic vial A",
					"cryogenic vial B"
				},
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryogenicSampleContainerLabel -> {
					"cryogenic vial A replicate 1",
					"cryogenic vial A replicate 2",
					"cryogenic vial B replicate 1",
					"cryogenic vial B replicate 2"
				}
			}],
			Messages :> {
				Warning::FreezeCellsReplicateLabels
			}
		],
		(* Options: Freezing Hardware *)
		Example[{Options, CryogenicSampleContainer, "Specify the cryogenic vial in which the cell samples are to be frozen using the CryogenicSampleContainer option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> All,
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryogenicSampleContainer -> ObjectP[Model[Container, Vessel, "2mL Cryogenic Vial"]]
			}]
		],
		Example[{Options, CryogenicSampleContainer, "If Aliquot is True, CryogenicSampleContainer is automatically set to an Object[Container, Vessel] which has a CryogenicVial Footprint and a MaxVolume sufficient to contain the AliquotVolume:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> All,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				CryogenicSampleContainer -> ObjectP[Model[Container, Vessel, "2mL Cryogenic Vial"]]
			}]
		],
		Example[{Options, CryogenicSampleContainer, "If Aliquot is False, CryogenicSampleContainer is automatically set to the container of the input cell sample:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> False,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				CryogenicSampleContainer -> ObjectP[Object[Container, Vessel, "Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID]]
			}]
		],
		Example[{Options, CryogenicSampleContainer, "If Aliquot and CryogenicSampleContainer are both Automatic, but the sample's input container is suitable for the experiment, Aliquot is automatically set to False and CryogenicSampleContainer is automatically set to the container of the input sample:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				CryogenicSampleContainer -> ObjectP[Object[Container, Vessel, "Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID]],
				Aliquot -> False
			}]
		],
		Example[{Options, FreezingRack, "Specify the FreezingRack option to determine which rack the CryogenicSampleContainers containing the cell samples are held in:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingRack -> ObjectP[Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"]]
			}]
		],
		Example[{Options, FreezingRack, "If the FreezingStrategy is InsulatedCooler, FreezingRack is automatically set to an insulated cooler rack compatible with the sample volume:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingRack -> ObjectP[Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"]]
			}]
		],
		Example[{Options, FreezingRack, "If the FreezingStrategy is ControlledRateFreezer, FreezingRack is automatically set to Model[Container, Rack, \"2mL Cryo Rack for VIA Freeze\"]:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> ControlledRateFreezer,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingRack -> ObjectP[Model[Container, Rack, "2mL Cryo Rack for VIA Freeze"]]
			}]
		],
		Example[{Options, Freezer, "Specify the Freezer option to designate the instrument used to lower the temperature of the cell sample(s):"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Freezer -> Model[Instrument, Freezer, "Stirling UltraCold SU780UE"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				Freezer -> ObjectP[Model[Instrument, Freezer, "Stirling UltraCold SU780UE"]]
			}]
		],
		Example[{Options, Freezer, "If the FreezingStrategy is ControlledRateFreezer, Freezer is automatically set to the VIA Freeze controlled rate cell freezer:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> ControlledRateFreezer,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				Freezer -> ObjectP[Model[Instrument, ControlledRateFreezer, "VIA Freeze Research"]]
			}]
		],
		Example[{Options, Freezer, "If the FreezingStrategy is InsulatedCooler, Freezer is automatically set to a Freezer maintained at -80 Celsius:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				Freezer -> ObjectP[Model[Instrument, Freezer, "Stirling UltraCold SU780UE"]]
			}]
		],
		(* Options: Freezing Conditions *)
		Example[{Options, Coolant, "For InsulatedCooler strategies, specify the liquid used to fill the FreezingRack using the Coolant option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Coolant -> Model[Sample, "Isopropanol"],
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Coolant -> ObjectP[Model[Sample, "Isopropanol"]]
			}]
		],
		Example[{Options, Coolant, "If the FreezingStrategy is InsulatedCooler, the Coolant is automatically set to Model[Sample, \"Isopropyl alcohol\"]:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				Coolant -> ObjectP[Model[Sample, "Isopropanol"]]
			}]
		],
		Example[{Options, Coolant, "If the FreezingStrategy is ControlledRateFreezer, the Coolant is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> ControlledRateFreezer,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				Coolant -> Null
			}]
		],
		Example[{Options, InsulatedCoolerFreezingTime, "For InsulatedCooler strategies, specify the duration for which the insulated cooler containing cell sample(s) is to remain in the Freezer using the InsulatedCoolerFreezingTime option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				InsulatedCoolerFreezingTime -> 15 Hour,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				InsulatedCoolerFreezingTime -> 15 Hour
			}]
		],
		Example[{Options, InsulatedCoolerFreezingTime, "If the FreezingStrategy is InsulatedCooler, the InsulatedCoolerFreezingTime is automatically set to 12 Hour:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				InsulatedCoolerFreezingTime -> 12 Hour
			}]
		],
		Example[{Options, InsulatedCoolerFreezingTime, "If the FreezingStrategy is ControlledRateFreezer, the InsulatedCoolerFreezingTime is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> ControlledRateFreezer,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				InsulatedCoolerFreezingTime -> Null
			}]
		],
		Example[{Options, TemperatureProfile, "For ControlledRateFreezer strategies, specify the sequence of temperature changes to be carried out using the TemperatureProfile option:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				TemperatureProfile -> {{-10 Celsius, 30 Minute}, {-60 Celsius, 120 Minute}},
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				TemperatureProfile -> {{-10 Celsius, 30 Minute}, {-60 Celsius, 120 Minute}}
			}]
		],
		Example[{Options, TemperatureProfile, "If the FreezingStrategy is ControlledRateFreezer, the TemperatureProfile is automatically set to a profile which results in linear cooling at 1 Celsius per Minute beginning at 25 Celsius and terminating at -80 Celsius:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> ControlledRateFreezer,
				CryoprotectantSolutionTemperature -> Ambient,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				TemperatureProfile -> {{-80 Celsius, 105 Minute}}
			}]
		],
		Example[{Options, TemperatureProfile, "If the FreezingStrategy is InsulatedCooler, the TemperatureProfile is automatically set to Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				TemperatureProfile -> Null
			}]
		],
		(* Options: Storage *)
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to specify the long-term storage condition of the cell sample(s) following freezing:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				SamplesOutStorageCondition -> CryogenicStorage,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				SamplesOutStorageCondition -> CryogenicStorage
			}]
		],
		Example[{Options, SamplesOutStorageCondition, "If the SamplesOutStorageCondition option is not specified, it is automatically set to CryogenicStorage:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> Options, OptionsResolverOnly -> True
			],
			KeyValuePattern[{
				Aliquot -> True,
				SamplesOutStorageCondition -> CryogenicStorage
			}]
		],
		(* ===Additional=== *)
		Example[{Additional, "Allow duplicated input samples if the input samples are aliquoted before pelleting or freezing:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> {None, AddCryoprotectant},
				Aliquot -> True,
				AliquotVolume -> 250 Microliter
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Additional, "Allow duplicated input samples if the input samples are replicated:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> 2,
				CryoprotectionStrategy -> ChangeMedia
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		(* Tests: Resource Packets - Batching and generation of FreezeCells Unit Operations *)
		Test["If the FreezingStrategy is InsulatedCooler and there are multiple unique sets of freezing conditions (Coolant, FreezingRack, and Freezer), split the experiment into batches to allow for the different conditions:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True,
				Freezer -> {
					Model[Instrument, Freezer, "Stirling Ultracold"],
					Model[Instrument, Freezer, "Stirling Ultracold"],
					Model[Instrument, Freezer, "Stirling UltraCold SU780UE, -20C"]
				},
				Coolant -> {
					Model[Sample, "Methanol"],
					Model[Sample, "Isopropanol"],
					Model[Sample, "Isopropanol"]
				}
			];
			batchedUnitOps = Download[protocol, BatchedUnitOperations];
			MatchQ[batchedUnitOps, {ObjectP[Object[UnitOperation, FreezeCells]], ObjectP[Object[UnitOperation, FreezeCells]], ObjectP[Object[UnitOperation, FreezeCells]]}],
			True,
			Variables :> {protocol, batchedUnitOps}
		],
		Test["If the FreezingStrategy is InsulatedCooler and there are multiple samples with identical freezing conditions (Coolant, FreezingRack, and Freezer), consolidate the samples into the same batch:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True
			];
			batchedUnitOps = Download[protocol, BatchedUnitOperations];
			MatchQ[batchedUnitOps, {ObjectP[Object[UnitOperation, FreezeCells]]}],
			True,
			Variables :> {protocol, batchedUnitOps}
		],
		Test["If the FreezingStrategy is InsulatedCooler and the number of samples with identical freezing conditions (Coolant, FreezingRack, and Freezer) exceeds the capacity of the FreezingRack, split the samples into multiple batches:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> 8,
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"], (* Holds a maximum of 18 sample vials. *)
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True
			];
			batchedUnitOps = Download[protocol, BatchedUnitOperations];
			MatchQ[batchedUnitOps, {ObjectP[Object[UnitOperation, FreezeCells]], ObjectP[Object[UnitOperation, FreezeCells]]}],
			True,
			Variables :> {protocol, batchedUnitOps}
		],
		Test["If the FreezingStrategy is ControlledRateFreezer and the number of samples with identical freezing conditions (Coolant, FreezingRack, and Freezer) does not exceed the capacity of the FreezingRack, only one batch is needed:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> 15,
				FreezingRack -> Model[Container, Rack, "id:pZx9jo8ZVNW0"], (* Model[Container, Rack, "2mL Cryo Rack for VIA Freeze"] *)
				FreezingStrategy -> ControlledRateFreezer,
				Aliquot -> True
			];
			batchedUnitOps = Download[protocol, BatchedUnitOperations];
			MatchQ[batchedUnitOps, {ObjectP[Object[UnitOperation, FreezeCells]]}],
			True,
			Variables :> {protocol, batchedUnitOps}
		],
		(* Tests: Resource Packets - Generation of Transfer, Mix, and Pellet Unit Operations *)
		Test["If the FreezingStrategy is InsulatedCooler, the FreezeCellsCoolantTransferUnitOperation field is populated with a Transfer unit operation:",
			protocol = ExperimentFreezeCells[
				Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				FreezingStrategy -> InsulatedCooler
			];
			coolantTransferUnitOps = Download[protocol, FreezeCellsCoolantTransferUnitOperation];
			MatchQ[coolantTransferUnitOps, TransferP],
			True,
			Variables :> {protocol, coolantTransferUnitOps}
		],

		Test["If the FreezingStrategy is ControlledRateFreezer, the FreezeCellsCoolantTransferUnitOperation field is not populated:",
			protocol = ExperimentFreezeCells[
				Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				FreezingStrategy -> ControlledRateFreezer
			];
			coolantTransferUnitOps = Download[protocol, FreezeCellsCoolantTransferUnitOperation];
			MatchQ[coolantTransferUnitOps, Null],
			True,
			Variables :> {protocol, coolantTransferUnitOps}
		],
		Test["If the CryprotectionStrategy is ChangeMedia at any index, the FreezeCellsPelletUnitOperation field is populated with a Pellet unit operation:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> {None, ChangeMedia}
			];
			Download[protocol, FreezeCellsPelletUnitOperation],
			Pellet[
				KeyValuePattern[Sample ->  {
					ObjectP[Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]]
				}]
			],
			Variables :> {protocol}
		],
		Test["If the CryprotectionStrategy is ChangeMedia and NumberOfReplicates is set to 2, collapse on unique sample in FreezeCellsPelletUnitOperation field (1 sample):",
			protocol = ExperimentFreezeCells[
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Aliquot -> True,
				CryoprotectionStrategy -> ChangeMedia,
				NumberOfReplicates -> 2
			];
			Download[protocol, FreezeCellsPelletUnitOperation],
			Pellet[
				KeyValuePattern[Sample ->  {
					ObjectP[Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]]
				}]
			],
			Variables :> {protocol}
		],
		Test["If the CryprotectionStrategy is ChangeMedia for 2 input samples, 2 samples in FreezeCellsPelletUnitOperation field:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CellPelletSupernatantVolume -> {500 Microliter, All},
				Aliquot -> True
			];
			Download[protocol, FreezeCellsPelletUnitOperation],
			Pellet[
				KeyValuePattern[Sample ->  {
					ObjectP[Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]],
					ObjectP[Object[Sample, "Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]]
				}]
			],
			Variables :> {protocol}
		],
		Test["If the CryprotectionStrategy is not ChangeMedia at any index, the FreezeCellsPelletUnitOperation field is not populated:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> {None, AddCryoprotectant}
			];
			pelletUnitOps = Download[protocol, FreezeCellsPelletUnitOperation];
			MatchQ[pelletUnitOps, Null],
			True,
			Variables :> {protocol, pelletUnitOps}
		],
		(* Tests: Resource Packets - Resource Consolidation *)
		Test["If the FreezingStrategy is InsulatedCooler and there are multiple samples with identical freezing conditions (Coolant, FreezingRack, and Freezer), only one unique resource is generated for the FreezingRacks:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			freezingRacks = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, FreezingRacks, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[freezingRacks], 1],
			True,
			Variables :> {protocol, requiredResources, freezingRacks}
		],
		Test["If the FreezingStrategy is InsulatedCooler and there are multiple unique sets of freezing conditions (Coolant, FreezingRack, and Freezer), a unique FreezingRacks resource is generated for each of the unique condition sets:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True,
				Freezer -> {
					Model[Instrument, Freezer, "Stirling Ultracold"],
					Model[Instrument, Freezer, "Stirling Ultracold"],
					Model[Instrument, Freezer, "Stirling UltraCold SU780UE, -20C"]
				},
				Coolant -> {
					Model[Sample, "Methanol"],
					Model[Sample, "Isopropanol"],
					Model[Sample, "Isopropanol"]
				}
			];
			requiredResources = Download[protocol, RequiredResources];
			freezingRacks = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, FreezingRacks, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[freezingRacks], 3],
			True,
			Variables :> {protocol, requiredResources, freezingRacks}
		],
		Test["If the same sample model is specified for the CryoprotectantSolution option at multiple indices, the resources generated for the CryoprotectantSolutions are consolidated:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolution -> Model[Sample, "Glycerol"],
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			cryoprotectantSolutions = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, CryoprotectantSolutions, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[cryoprotectantSolutions], 1],
			True,
			Variables :> {protocol, requiredResources, cryoprotectantSolutions}
		],
		Test["If SamplesOutStorageCondition -> CryogenicStorage for any samples, populate the CryogenicGloves field and generate a corresponding resource:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolution -> Model[Sample, "Glycerol"],
				Aliquot -> True
			];
			{cryoGloves, requiredResources} = Download[protocol, {CryogenicGloves, RequiredResources}];
			cryoGlovesResource = Cases[
				Flatten[
					Cases[requiredResources, {_, CryogenicGloves, _, _}]
				],
				ObjectP[]
			];
			{cryoGloves, cryoGlovesResource},
			{
				ObjectP[Model[Item, Glove]],
				{ObjectP[Object[Resource, Sample]]}
			},
			Variables :> {protocol, cryoGloves, requiredResources, cryoGlovesResource}
		],
		Test["Any CryoprotectantSolutions which are Sterile -> True are excluded from the CryoprotectantSolutionsToAutoclave field:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectantSolution -> {
					Model[Sample, "Glycerol"],
					Model[Sample, StockSolution, "Filtered PBS, Sterile"]
				},
				Aliquot -> True
			];
			Download[protocol, {CryoprotectantSolutions, CryoprotectantSolutionsToAutoclave}],
			{
				{ObjectP[Model[Sample, "Glycerol"]], ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]},
				{ObjectP[Model[Sample, "Glycerol"]]}
			},
			Variables :> {protocol}
		],
		Test["Any CryoprotectantSolutions which contain Model[Molecule, \"Dimethyl sulfoxide\"] are excluded from the CryoprotectantSolutionsToAutoclave field:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectantSolution -> {
					Model[Sample, StockSolution, "80/20 Dimethyl sulfoxide/Milli-Q water"],
					Model[Sample, "Glycerol"]
				},
				Aliquot -> True
			];
			Download[protocol, {CryoprotectantSolutions, CryoprotectantSolutionsToAutoclave}],
			{
				{ObjectP[Model[Sample, StockSolution, "80/20 Dimethyl sulfoxide/Milli-Q water"]], ObjectP[Model[Sample, "Glycerol"]]},
				{ObjectP[Model[Sample, "Glycerol"]]}
			},
			Variables :> {protocol}
		],
		Test["If different sample models are specified for the CryoprotectantSolution option at different indices, unique resources are generated for each of the different CryoprotectantSolutions:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolution -> {Model[Sample, "Glycerol"], Model[Sample, "DMSO, anhydrous"]},
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			cryoprotectantSolutions = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, CryoprotectantSolutions, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[cryoprotectantSolutions], 2],
			True,
			Variables :> {protocol, requiredResources, cryoprotectantSolutions}
		],
		Test["If the FreezingStrategy is InsulatedCooler, no resources are generated for Freezers in the resource packets function:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			freezers = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, Freezers, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[freezers], 0],
			True,
			Variables :> {protocol, requiredResources, freezers}
		],
		Test["If the FreezingStrategy is ControlledRateFreezer, exactly one unique resource is generated for the Freezers:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			freezers = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, Freezers, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[freezers], 1],
			True,
			Variables :> {protocol, requiredResources, freezers}
		],
		Test["Exactly one unique resource is generated for each unique input sample:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			samplesIn = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, SamplesIn, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[samplesIn], 2],
			True,
			Variables :> {protocol, requiredResources, samplesIn}
		],
		Test["Exactly one unique resource is generated for each unique input sample when number of replicates is specified:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				NumberOfReplicates -> 8,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			samplesIn = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, SamplesIn, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[samplesIn], 2],
			True,
			Variables :> {protocol, requiredResources, samplesIn}
		],
		Test["Exactly one unique resource is generated for each unique input container:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			containersIn = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, ContainersIn, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[containersIn], 2],
			True,
			Variables :> {protocol, requiredResources, containersIn}
		],
		Test["Exactly one unique resource is generated for each unique input container when number of replicates is specified:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				NumberOfReplicates -> 8,
				Aliquot -> True
			];
			requiredResources = Download[protocol, RequiredResources];
			containersIn = DeleteDuplicates @ Cases[
				LinkedObject /@ Flatten[
					Cases[requiredResources, {_, ContainersIn, _, _}]
				],
				ObjectP[]
			];
			MatchQ[Length[containersIn], 2],
			True,
			Variables :> {protocol, requiredResources, containersIn}
		],
		Test["If the FreezingStrategy is InsulatedCooler, the EstimatedProcessingTime field is set to 20 minutes more than the InsulatedCoolerFreezingTime:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				InsulatedCoolerFreezingTime -> Hour,
				Aliquot -> True
			];
			Download[protocol, EstimatedProcessingTime],
			RangeP[79 Minute, 81 Minute],
			Variables :> {protocol}
		],
		Test["If the FreezingStrategy is ControlledRateFreezer, the EstimatedProcessingTime field is set to 20 minutes more than the total time required by the TemperatureProfile:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				TemperatureProfile -> {{-80 Celsius, 105 Minute}},
				Aliquot -> True
			];
			Download[protocol, EstimatedProcessingTime],
			RangeP[124 Minute, 126 Minute],
			Variables :> {protocol}
		],
		Test["If the FreezingStrategy is InsulatedCooler, the InsulatedCoolerFreezingConditions field is populated with storage condition models:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Freezer -> {
					Model[Instrument, Freezer, "Stirling UltraCold SU780XLE, -20C"],
					Model[Instrument, Freezer, "Stirling UltraCold SU780UE"]
				},
				Aliquot -> True
			];
			Download[protocol, InsulatedCoolerFreezingConditions],
				{
					ObjectP[Model[StorageCondition, "id:n0k9mG8Bv96n"]], (* Model[StorageCondition, "Freezer, Flammable"]: a -20 Celsius Freezer, Flammable materials rated *)
					ObjectP[Model[StorageCondition, "id:xRO9n3BVOe3z"]] (* Model[StorageCondition, "Deep Freezer"]: a -80 Celsius Freezer *)
				},
			Variables :> {protocol}
		],
		Test["If the FreezingStrategy is ControlledRateFreezer, the InsulatedCoolerFreezingConditions field is not populated with storage condition models:",
			protocol = ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Aliquot -> True
			];
			Download[protocol, InsulatedCoolerFreezingConditions],
			NullP,
			Variables :> {protocol}
		],
		(* Simulation *)
		Example[{Additional, "If Simulation is included in the specified Output, a Simulation is returned:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> {Result, Simulation}
			],
			{ObjectP[Object[Protocol, FreezeCells]], SimulationP}
		],
		(* ===Messages=== *)
		(* Messages: Sample Properties *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentFreezeCells[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentFreezeCells[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentFreezeCells[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentFreezeCells[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentFreezeCells[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Warning::FreezeCellsUnknownCellType,Warning::FreezeCellsUnknownCultureAdhesion,Warning::FreezeCellsAliquotingRequired,Warning::FreezeCellsUnusedSample}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentFreezeCells[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Warning::FreezeCellsUnknownCellType,Warning::FreezeCellsUnknownCultureAdhesion,Warning::FreezeCellsAliquotingRequired,Warning::FreezeCellsUnusedSample}
		],
		Example[{Messages, "DiscardedSamples", "If the given samples are discarded, they cannot be incubated:"},
			ExperimentFreezeCells[Object[Sample, "Test discarded sample (Test for ExperimentFreezeCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "If the given samples have deprecated models, they cannot be incubated:"},
			ExperimentFreezeCells[Object[Sample, "Test deprecated sample (Test for ExperimentFreezeCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicatedSamples", "Throws an error if ChangeMedia CryoprotectionStrategies is applied on the same input sample:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CryoprotectionStrategy -> {ChangeMedia, AddCryoprotectant}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedSamples,
				Error::ConflictingChangeMediaOptionsForSameContainer,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicatedSamples", "Throws an error if all specified options are the same for two inputs which are identical while NumberOfReplicates is Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryogenicSampleContainerLabel -> {
					"freeze cells cryogenic sample container 1",
					"freeze cells cryogenic sample container 2"
				},
				NumberOfReplicates -> Null,
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::DuplicatedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicatedSamples", "Do not throw an error if all specified options are the same for two inputs which are expanded by framework while NumberOfReplicates is Null:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryogenicSampleContainerLabel -> {
					"freeze cells cryogenic sample container 1 replicate 1",
					"freeze cells cryogenic sample container 1 replicate 2"
				},
				NumberOfReplicates -> Null,
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Messages, "DuplicatedSamples", "Throws an error if the number of appearance of the same sample with the same option is larger than NumberOfReplicates:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				NumberOfReplicates -> 2,
				CryoprotectionStrategy -> {AddCryoprotectant, AddCryoprotectant, AddCryoprotectant}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidChangeMediaSamples", "Throws an error if there are more samples in the input sample container while ChangeMedia is required:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidChangeMediaSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidChangeMediaSamples", "Do not throw an error if all samples in the input sample container have ChangeMedia:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True
			],
			ObjectP[Object[Protocol, FreezeCells]]
		],
		Example[{Messages, "FreezeCellsUnsupportedCellType", "If any input sample has a CellType other than those currently supported (Mammalian, Bacterial, and Yeast), an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension insect cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsUnsupportedCellType,
				Error::InvalidInput
			}
		],
		Example[{Messages, "FreezeCellsAliquotingRequired", "Throw a warning if ContainersIn is not a cryo vial, automatically set Aliquot to True:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol, FreezeCells]],
			Messages :> {
				Warning::FreezeCellsAliquotingRequired
			}
		],
		Example[{Messages, "CryogenicVialAliquotingRequired", "Throw an error if ContainersIn is not a cryo vial but Aliquot is set to False:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> False
			],
			$Failed,
			Messages :> {
				Error::CryogenicVialAliquotingRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CryogenicVialAliquotingRequired", "Throw an error if ContainersIn is not the same cryo vial as CryogenicSampleContainer but Aliquot is set to False:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryogenicSampleContainer -> Model[Container, Vessel, "2mL Cryogenic Vial"],
				Aliquot -> False
			],
			$Failed,
			Messages :> {
				Error::CryogenicVialAliquotingRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnknownCellType", "If any input sample has no specified CellType and no information in the CellType field of the Object[Sample], the CellType defaults to Bacterial and a warning is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension cell sample in 2mL Tube with no CellType information (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, FreezeCells]],
				KeyValuePattern[{
					CellType -> Bacterial
				}]
			},
			Messages :> {
				Warning::FreezeCellsUnknownCellType
			}
		],
		Example[{Messages, "FreezeCellsReplicateLabels", "If the NumberOfReplicates option is specified but CryogenicSampleContainerLabel is automatic, no warning is thrown to tell the user how the CryogenicSampleContainerLabel expands to account for the replicates:"},
			ExperimentFreezeCells[
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"],
				InsulatedCoolerFreezingTime -> 15 Hour,
				Coolant -> Model[Sample, "Isopropanol"],
				NumberOfReplicates -> 2,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{_Rule..}
		],
		Example[{Messages, "FreezeCellsReplicateLabels", "If the NumberOfReplicates option is specified and CryogenicSampleContainerLabel is updated, a warning is thrown to tell the user how the CryogenicSampleContainerLabel expands to account for the replicates if we are calling MCP:"},
			ExperimentManualCellPreparation[
				{
					FreezeCells[
						Sample -> Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
						Aliquot -> True,
						FreezingStrategy -> InsulatedCooler,
						FreezingRack -> Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"],
						InsulatedCoolerFreezingTime -> 15 Hour,
						Coolant -> Model[Sample, "Isopropanol"],
						NumberOfReplicates -> 2,
						CryogenicSampleContainerLabel -> "My frozen sample"
					]
				},
				Output -> Options
			],
			{_Rule..},
			Messages :> {
				Warning::FreezeCellsReplicateLabels
			}
		],
		Example[{Messages, "FreezeCellsConflictingCellType", "If a CellType is specified for any sample which does not match the CellType field in Object[Sample], an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CellType -> Mammalian
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingCellType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnsupportedCultureAdhesion", "If any input sample has a CultureAdhesion other than Suspension, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsUnsupportedCultureAdhesion,
				Error::InvalidInput
			}
		],
		Example[{Messages, "FreezeCellsUnknownCultureAdhesion", "If any input sample has no specified CultureAdhesion and no information in the CultureAdhesion field of the Object[Sample], the CultureAdhesion defaults to Suspension and a warning is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Mammalian cell sample in 2mL Tube with no CultureAdhesion information (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, FreezeCells]],
				KeyValuePattern[{
					CultureAdhesion -> Suspension
				}]
			},
			Messages :> {
				Warning::FreezeCellsUnknownCultureAdhesion
			}
		],
		Example[{Messages, "FreezeCellsConflictingCultureAdhesion", "If a CultureAdhesion is specified for any sample which does not match the CultureAdhesion field in Object[Sample], an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				CultureAdhesion -> Adherent
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingCultureAdhesion,
				Error::InvalidOption
			}
		],
		(* Messages: ChangeMedia *)
		Example[{Messages, "FreezeCellsNoCompatibleCentrifuge", "If there is no centrifuge model compatible with the given cell pelleting conditions, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> False
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsNoCompatibleCentrifuge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CellPelletCentrifuge is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CellPelletCentrifuge -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CellPelletIntensity is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CellPelletIntensity -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CellPelletTime is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CellPelletTime -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CellPelletSupernatantVolume is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CellPelletSupernatantVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingChangeMediaOptionsForSameContainer", "If the samples in the same input sample container have ChangeMedia options (CellPelletCentrifuge,CellPelletIntensity,CellPelletTime), throw an error:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CellPelletIntensity -> {700 GravitationalAcceleration, 500 GravitationalAcceleration},
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingChangeMediaOptionsForSameContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CryoprotectantSolution is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CryoprotectantSolution -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CryoprotectantSolutionVolume is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CryoprotectantSolutionVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientChangeMediaOptions", "If CryoprotectantSolutionTemperature is set to Null while CryoprotectionStrategy is ChangeMedia, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				Aliquot -> True,
				CryoprotectantSolutionTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletCentrifuge is specified while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				CellPelletCentrifuge -> Model[Instrument, Centrifuge, "Sterile Microfuge 16"]
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletIntensity is specified while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				CellPelletIntensity -> $LivingMammalianCentrifugeIntensity
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletTime is specified while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				CellPelletTime -> 10 Minute
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletSupernatantVolume is specified while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				Aliquot -> True,
				CellPelletSupernatantVolume -> All
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletCentrifuge is specified while CryoprotectionStrategy is None, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				CellPelletCentrifuge -> Model[Instrument, Centrifuge, "Sterile Microfuge 16"]
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletIntensity is specified while CryoprotectionStrategy is None, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				CellPelletIntensity -> $LivingMammalianCentrifugeIntensity
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletTime is specified while CryoprotectionStrategy is None, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				CellPelletTime -> 10 Minute
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousChangeMediaOptions", "If CellPelletSupernatantVolume is specified while CryoprotectionStrategy is None, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				Aliquot -> True,
				CellPelletSupernatantVolume -> All
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousChangeMediaOptions,
				Error::InvalidOption
			}
		],
		(* Messages: Cryoprotection *)
		Example[{Messages, "FreezeCellsInsufficientCryoprotectantOptions", "If CryoprotectantSolution is set to Null while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolution -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientCryoprotectantOptions", "If CryoprotectantSolutionVolume is set to Null while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolutionVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsInsufficientCryoprotectantOptions", "If CryoprotectantSolutionTemperature is set to Null while CryoprotectionStrategy is AddCryoprotectant, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolutionTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsInsufficientCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousCryoprotectantOptions", "If CryoprotectantSolution is specified while CryoprotectionStrategy is None, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				CryoprotectantSolution -> Model[Sample, "Glycerol"]
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsExtraneousCryoprotectantOptions", "If CryoprotectantSolutionVolume is specified while CryoprotectionStrategy is None, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				CryoprotectantSolutionVolume -> 200 Microliter
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsExtraneousCryoprotectantOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCryoprotectantSolutionTemperature", "If CryoprotectantSolutionTemperature is specified while CryoprotectionStrategy is None at all indices, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> None,
				CryoprotectantSolutionTemperature -> Ambient
			],
			$Failed,
			Messages :> {
				Error::ConflictingCryoprotectantSolutionTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OveraspiratedTransfer", "If CellPelletSupernatantVolume is larger than sample volume, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CryoprotectantSolutionVolume -> 1.5 Milliliter,
				CellPelletSupernatantVolume -> 1 Milliliter,
				NumberOfReplicates -> 2
			],
			$Failed,
			Messages :> {
				Warning::OveraspiratedTransfer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CryoprotectantSolutionOverfill", "If addition of CryoprotectantSolution would result in overfilling the cell sample's current container factoring in supernatant removal, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CryoprotectantSolutionVolume -> 2 Milliliter,
				CellPelletSupernatantVolume -> All,
				AliquotVolume -> 1 Milliliter,
				NumberOfReplicates -> 2
			],
			$Failed,
			Messages :> {
				Error::CryoprotectantSolutionOverfill,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CryoprotectantSolutionOverfill", "If addition of CryoprotectantSolution would result in overfilling the cell sample's current container factoring in supernatant removal, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CryoprotectantSolutionVolume -> 1.6 Milliliter,
				CellPelletSupernatantVolume -> 0.1 Milliliter,
				NumberOfReplicates -> 2
			],
			$Failed,
			Messages :> {
				Error::CryoprotectantSolutionOverfill,
				Error::InvalidOption
			}
		],
		(* Messages: Aliquoting and Replicates *)
		Example[{Messages, "InsufficientVolumeForAliquoting", "If the specified AliquotVolume is greater than the amount of sample to be aliquoted, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> 800 Microliter
			],
			$Failed,
			Messages :> {
				Error::InsufficientVolumeForAliquoting,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InsufficientVolumeForAliquoting", "If the AliquotVolume option is set to All while NumberOfReplicates is not Null, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				AliquotVolume -> All,
				NumberOfReplicates -> 5
			],
			$Failed,
			Messages :> {
				Error::InsufficientVolumeForAliquoting,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InsufficientVolumeForAliquoting", "If the total AliquotVolume option is more than sample volume, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> {300 Microliter, 400 Microliter}
			],
			$Failed,
			Messages :> {
				Error::InsufficientVolumeForAliquoting,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingAliquotOptions", "If AliquotVolume is Null while Aliquot is True, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingAliquotOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingAliquotOptions", "If AliquotVolume is specified while Aliquot is False, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> False,
				AliquotVolume -> All,
				CryogenicSampleContainer -> Object[Container, Vessel, "Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingAliquotOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsReplicatesAliquotRequired", "If NumberOfReplicates is specified while Aliquot is False, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> False,
				CryogenicSampleContainer -> Object[Container, Vessel, "Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID],
				NumberOfReplicates -> 12
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsReplicatesAliquotRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnusedSample", "If a portion of input cell sample will not be frozen in the experiment due to aliquoting, a warning is thrown to indicate how much of the sample will not be frozen:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> 300 Microliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, FreezeCells]],
				KeyValuePattern[{
					Aliquot -> True,
					AliquotVolume -> 300 Microliter
				}]
			},
			Messages :> {
				Warning::FreezeCellsUnusedSample
			}
		],
		Example[{Messages, "FreezeCellsUnusedSample", "If a portion of input cell sample will not be frozen factoring in duplicated samples, a warning is thrown to indicate how much of the sample will not be frozen:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> {200 Microliter, 100 Microliter},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, FreezeCells]],
				KeyValuePattern[{
					Aliquot -> True,
					AliquotVolume -> {200 Microliter, 100 Microliter}
				}]
			},
			Messages :> {
				Warning::FreezeCellsUnusedSample
			}
		],
		Example[{Messages, "FreezeCellsUnusedSample", "If a portion of input cell sample will not be frozen factoring in duplicated samples, a warning is thrown to indicate how much of the sample will not be frozen:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID]
				},
				CryoprotectionStrategy -> ChangeMedia,
				CryoprotectantSolutionVolume -> 1.5 Milliliter,
				Aliquot -> True,
				AliquotVolume -> 1 Milliliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, FreezeCells]],
				KeyValuePattern[{
					Aliquot -> True,
					AliquotVolume -> 1 Milliliter
				}]
			},
			Messages :> {
				Warning::FreezeCellsUnusedSample
			}
		],
		Example[{Messages, "FreezeCellsUnusedSample", "If all of input cell sample is used factoring in duplicated samples, no warning is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) " <> $SessionUUID]
				},
				Aliquot -> True,
				AliquotVolume -> {300 Microliter, 200 Microliter},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, FreezeCells]],
				KeyValuePattern[{
					Aliquot -> True,
					AliquotVolume -> {300 Microliter, 200 Microliter}
				}]
			}
		],
		(* Messages: Freezing *)
		Example[{Messages, "FreezeCellsConflictingHardware", "If Freezer is set to a static freezer model while FreezingStrategy is ControlledRateFreezer, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Freezer -> Model[Instrument, Freezer, "id:01G6nvkKr3dA"] (* Model[Instrument, Freezer, "Stirling UltraCold SU780UE"] *)
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingHardware,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingHardware", "If Freezer is set to a controlled rate freezer model while FreezingStrategy is InsulatedCooler, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Freezer -> Model[Instrument, ControlledRateFreezer, "id:kEJ9mqaVPPWz"] (* Model[Instrument, ControlledRateFreezer, "VIA Freeze Research"] *)
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingHardware,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingHardware", "If FreezingRack is set to an insulated cooler rack model while FreezingStrategy is ControlledRateFreezer, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"] (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingHardware,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingHardware", "If FreezingRack is set to a controlled rate freezer rack model while FreezingStrategy is InsulatedCooler, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				FreezingRack -> Model[Container, Rack, "id:pZx9jo8ZVNW0"] (* Model[Container, Rack, "2mL Cryo Rack for VIA Freeze"] *)
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingHardware,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingHardware", "If FreezingRack is set to a rack model appropriate for a 5 Milliliter CryogenicSampleContainer while CryogenicSampleContainer is set to a container whose MaxVolume is less than 3.6 Milliliter, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"] (* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *),
				Aliquot -> True,
				CryogenicSampleContainer -> Model[Container, Vessel, "id:vXl9j5qEnnOB"] (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingHardware,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingHardware", "If FreezingRack is set to a rack model appropriate for a 2 Milliliter CryogenicSampleContainer while CryogenicSampleContainer is set to a container whose MaxVolume is greater than 2 Milliliter, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingRack -> Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
				CryogenicSampleContainer -> Model[Container, Vessel, "id:o1k9jAG1Nl57"] (* Model[Container, Vessel, "5mL Cryogenic Vial"] *),
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingHardware,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingTemperatureProfile", "If TemperatureProfile is set to Null while FreezingStrategy is ControlledRateFreezer, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				TemperatureProfile -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingTemperatureProfile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingTemperatureProfile", "If TemperatureProfile is specified while FreezingStrategy is InsulatedCooler, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				TemperatureProfile -> {{-60 Celsius, 120 Minute}}
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingTemperatureProfile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingCoolant", "If Coolant is specified while FreezingStrategy is ControlledRateFreezer, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				Coolant -> Model[Sample, "Isopropanol"]
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingCoolant,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingCoolant", "If Coolant is set to Null while FreezingStrategy is InsulatedCooler, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				Coolant -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingCoolant,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingInsulatedCoolerFreezingTime", "If InsulatedCoolerFreezingTime is specified while FreezingStrategy is ControlledRateFreezer, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				InsulatedCoolerFreezingTime -> 6 Hour
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingInsulatedCoolerFreezingTime,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsConflictingInsulatedCoolerFreezingTime", "If InsulatedCoolerFreezingTime is set to Null while FreezingStrategy is InsulatedCooler, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				InsulatedCoolerFreezingTime -> Null
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsConflictingInsulatedCoolerFreezingTime,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnsupportedTemperatureProfile", "If a specified TemperatureProfile involves a time specification that is less than the one that precedes it, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				TemperatureProfile -> {{-10 Celsius, 30 Minute}, {-80 Celsius, 25 Minute}}
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsUnsupportedTemperatureProfile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnsupportedTemperatureProfile", "If a specified TemperatureProfile requires a cooling rate faster than 2 Celsius/Minute, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				TemperatureProfile -> {{-10 Celsius, 10 Minute}, {-80 Celsius, 15 Minute}}
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsUnsupportedTemperatureProfile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnsupportedTemperatureProfile", "If a specified TemperatureProfile requires a nonzero cooling rate slower than 0.01 Celsius/Minute, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				TemperatureProfile -> {{-10 Celsius, 1 Hour}, {-11 Celsius, 3 Hour}, {-60 Celsius, 6 Hour}}
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsUnsupportedTemperatureProfile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnsuitableCryogenicSampleContainerFootprint", "If a specified CryogenicSampleContainer does not have a CryogenicVial Footprint, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				CryogenicSampleContainer -> Model[Container, Vessel, "50mL Tube"],
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::UnsuitableCryogenicSampleContainerFootprint,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnsuitableFreezingRack", "If a specified FreezingRack is not a rack for cryogenic samples, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingRack -> Model[Container, Rack, "15mL Tube Stand"],
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::UnsuitableFreezingRack,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExcessiveCryogenicSampleVolume", "If the total volume to be frozen for any cell sample exceeds the MaxVolume (5 Milliliter) of the largest Model[Container, Vessel] with a CryogenicVial Footprint, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Container, Vessel, "Test 250mL Erlenmeyer Flask 0 for ExperimentFreezeCells "<>$SessionUUID]
				},
				CryoprotectionStrategy -> AddCryoprotectant,
				CryoprotectantSolutionVolume -> 2.0 Milliliter,
				Aliquot -> True,
				AliquotVolume -> All
			],
			$Failed,
			Messages :> {
				Error::ExcessiveCryogenicSampleVolume,
				Error::InvalidOption
			}
		],
		(* Messages: Batching Constraints *)
		Example[{Messages, "TooManyControlledRateFreezerBatches", "If an experiment is submitted with a FreezingStrategy of ControlledRateFreezer which requires multiple freezing batches because more than 48 samples will be frozen, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> ControlledRateFreezer,
				NumberOfReplicates -> 20,
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::TooManyControlledRateFreezerBatches,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyInsulatedCoolerBatches", "If an experiment is submitted with a FreezingStrategy of InsulatedCooler which requires more than three freezing batches because the number of samples to be frozen require more than the capacity of three FreezingRacks, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				FreezingStrategy -> InsulatedCooler,
				FreezingRack -> ConstantArray[Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"], 3],
				NumberOfReplicates -> 13,
				Aliquot -> True
			],
			$Failed,
			Messages :> {
				Error::TooManyInsulatedCoolerBatches,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyInsulatedCoolerBatches", "If an experiment is submitted with a FreezingStrategy of InsulatedCooler which requires more than three freezing batches because more than three different freezing conditions are required, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Coolant -> {
					Model[Sample, "Isopropanol"],
					Model[Sample, "Isopropanol"],
					Model[Sample, "Methanol"],
					Model[Sample, "Methanol"]
				},
				Freezer -> {
					Model[Instrument, Freezer, "Stirling UltraCold SU780UE, -20C"],
					Model[Instrument, Freezer, "Stirling Ultracold"],
					Model[Instrument, Freezer, "Stirling UltraCold SU780UE, -20C"],
					Model[Instrument, Freezer, "Stirling Ultracold"]
				}
			],
			$Failed,
			Messages :> {
				Error::TooManyInsulatedCoolerBatches,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FreezeCellsUnsupportedFreezerModel", "If any Model[Instrument, Freezer] is specified for the Freezer option which does not have a DefaultTemperature within 5 Celsius of either -20 Celsius or -80 Celsius, an error is thrown:"},
			ExperimentFreezeCells[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
					Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID]
				},
				Aliquot -> True,
				FreezingStrategy -> InsulatedCooler,
				Freezer -> {
					Model[Instrument, Freezer, "NexGen Glovebox Freezer"], (* DefaultTemperature -> -30 Celsius *)
					Model[Instrument, Freezer, "So-Low U85-13"],           (* DefaultTemperature -> -78 Celsius *)
					Model[Instrument, Freezer, "NexGen Glovebox Freezer"]  (* DefaultTemperature -> -30 Celsius *)
				}
			],
			$Failed,
			Messages :> {
				Error::FreezeCellsUnsupportedFreezerModel,
				Error::InvalidOption
			}
		]
	},
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, testBench, tube0, tube1, tube2, tube3, tube4, tube5, tube6, cryovial0, cryovial1, cryovial2,
				cryovial3, cryovial4, flask0, plate1, plate2, deprecatedModel, sample0, sample1, sample2, sample3, sample4, sample5,
				sample6, sample7, sample8, sample9, discardedSample, deprecatedSample, sample10, sample11, sharingPlateSample1,
				sharingPlateSample2
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Bench *)
				Object[Container, Bench, "Test bench for ExperimentFreezeCells tests "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 1 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 2 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 3 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 250mL Erlenmeyer Flask 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 5mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Plate, "Test 24-well Plate 1 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Plate, "Test 24-well Plate 2 for ExperimentFreezeCells "<>$SessionUUID],
				(* Samples *)
				Model[Sample, "Bacterial cells Deprecated Model (Test for ExperimentFreezeCells)" <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension insect cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension cell sample in 2mL Tube with no CellType information (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Mammalian cell sample in 2mL Tube with no CultureAdhesion information (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in 250mL Erlenmeyer Flask (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Test discarded sample (Test for ExperimentFreezeCells)" <> $SessionUUID],
				Object[Sample, "Test deprecated sample (Test for ExperimentFreezeCells)" <> $SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in plate 1 (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			testBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentFreezeCells tests "<> $SessionUUID,
					Site -> Link[$Site]
				|>
			];

			{tube0, tube1, tube2, tube3, tube4, tube5, tube6, cryovial0, cryovial1, cryovial2, cryovial3, cryovial4, flask0, plate1, plate2} = UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Cryogenic Vial"],
					Model[Container, Vessel, "2mL Cryogenic Vial"],
					Model[Container, Vessel, "2mL Cryogenic Vial"],
					Model[Container, Vessel, "2mL Cryogenic Vial"],
					Model[Container, Vessel, "5mL Cryogenic Vial"],
					Model[Container, Vessel, "250mL Erlenmeyer Flask"],
					Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"],
					Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"]
				},
				ConstantArray[{"Work Surface", testBench}, 15],
				Name -> {
					"Test 2mL Tube 0 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Tube 1 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Tube 2 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Tube 3 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Tube 4 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Tube 5 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Tube 6 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Cryogenic Vial 1 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Cryogenic Vial 2 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 2mL Cryogenic Vial 3 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 5mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 250mL Erlenmeyer Flask 0 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 24-well Plate 1 for ExperimentFreezeCells "<>$SessionUUID,
					"Test 24-well Plate 2 for ExperimentFreezeCells "<>$SessionUUID
				},
				FastTrack -> True
			];

			(* Create some bacteria and mammalian models *)
			deprecatedModel = UploadSampleModel[
				"Bacterial cells Deprecated Model (Test for ExperimentFreezeCells)" <> $SessionUUID,
				Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				CellType -> Bacterial,
				CultureAdhesion -> Suspension,
				Living -> True
			];

			(* Create some samples for testing purposes *)
			{
				sample0,
				sample1,
				sample2,
				sample3,
				sample4,
				sample5,
				sample6,
				sample7,
				sample8,
				sample9,
				discardedSample,
				deprecatedSample,
				sample10,
				sample11,
				sharingPlateSample1,
				sharingPlateSample2
			} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Yeast, "Pichia Pastoris"]}},
					{{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Mammalian, "Insect Cell Sf9"]}},
					{{100 VolumePercent, Model[Molecule, "Water"]}},
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					deprecatedModel,
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}}
				},
				{
					{"A1", tube0},
					{"A1", tube1},
					{"A1", tube2},
					{"A1", tube3},
					{"A1", tube4},
					{"A1", tube5},
					{"A1", tube6},
					{"A1", cryovial0},
					{"A1", flask0},
					{"A1", cryovial1},
					{"A1", cryovial2},
					{"A1", cryovial3},
					{"A1", cryovial4},
					{"A1", plate1},
					{"A1", plate2},
					{"B1", plate2}
				},
				Name -> {
					"Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Adherent mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension insect cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension cell sample in 2mL Tube with no CellType information (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Mammalian cell sample in 2mL Tube with no CultureAdhesion information (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension mammalian cell sample in 250mL Erlenmeyer Flask (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Test discarded sample (Test for ExperimentFreezeCells)" <> $SessionUUID,
					"Test deprecated sample (Test for ExperimentFreezeCells)" <> $SessionUUID,
					"Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension mammalian cell sample in plate 1 (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID,
					"Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					100 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					2 Milliliter,
					2 Milliliter,
					1 Milliliter,
					1 Milliliter
				},
				CellType -> {
					Mammalian,
					Bacterial,
					Yeast,
					Mammalian,
					Insect,
					Null,
					Mammalian,
					Mammalian,
					Mammalian,
					Bacterial,
					Bacterial,
					Bacterial,
					Bacterial,
					Mammalian,
					Mammalian,
					Mammalian
				},
				CultureAdhesion -> {
					Suspension,
					Suspension,
					Suspension,
					Adherent,
					Suspension,
					Suspension,
					Null,
					Suspension,
					Suspension,
					Suspension,
					Suspension,
					Suspension,
					Suspension,
					Suspension,
					Suspension,
					Suspension
				},
				Living -> {
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];
			Upload[{
				<|Object -> discardedSample, Status -> Discarded|>,
				<|Object -> deprecatedModel, Deprecated -> True|>
			}];
		]
	],
	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Bench *)
				Object[Container, Bench, "Test bench for ExperimentFreezeCells tests "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 1 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 2 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 3 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 250mL Erlenmeyer Flask 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 5mL Cryogenic Vial 0 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Plate, "Test 24-well Plate 1 for ExperimentFreezeCells "<>$SessionUUID],
				Object[Container, Plate, "Test 24-well Plate 2 for ExperimentFreezeCells "<>$SessionUUID],
				(* Samples *)
				Model[Sample, "Bacterial cells Deprecated Model (Test for ExperimentFreezeCells)" <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension yeast cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension insect cell sample in 2mL Tube (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension cell sample in 2mL Tube with no CellType information (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Mammalian cell sample in 2mL Tube with no CultureAdhesion information (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in 250mL Erlenmeyer Flask (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Test discarded sample (Test for ExperimentFreezeCells)" <> $SessionUUID],
				Object[Sample, "Test deprecated sample (Test for ExperimentFreezeCells)" <> $SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 5mL Cryogenic Vial (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample in plate 1 (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample 1 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension mammalian cell sample 2 sharing plate 2 (Test for ExperimentFreezeCells) "<>$SessionUUID]
			},
				ObjectP[]
			];

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

	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}

];



(* ::Section:: *)
(* Sister functions *)


(* ::Subsubsection::Closed:: *)
(* ExperimentFreezeCellsOptions *)

DefineTests[ExperimentFreezeCellsOptions,
	{
		Example[{Basic, "Return the resolved options:"},
			ExperimentFreezeCellsOptions[{
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID]
			},
				Aliquot -> True
			],
			Graphics_
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			ExperimentFreezeCellsOptions[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID]
				},
				Aliquot -> True,
				OutputFormat -> List
			],
			Rule___
		]
	},
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, testBench, tube1, tube2, sample1, sample2
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Bench *)
				Object[Container, Bench, "Test bench for ExperimentFreezeCellsOptions "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentFreezeCellsOptions "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentFreezeCellsOptions "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			testBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentFreezeCellsOptions "<> $SessionUUID,
					Site -> Link[$Site]
				|>
			];

			{tube1, tube2} = UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test 2mL Tube 1 for ExperimentFreezeCellsOptions "<>$SessionUUID,
					"Test 2mL Tube 2 for ExperimentFreezeCellsOptions "<>$SessionUUID
				},
				FastTrack -> True
			];

			(* Create some samples for testing purposes *)
			{sample1, sample2} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}}
				},
				{
					{"A1", tube1},
					{"A1", tube2}
				},
				Name -> {
					"Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter
				},
				CellType -> {
					Mammalian,
					Bacterial
				},
				CultureAdhesion -> {
					Suspension,
					Suspension
				},
				Living -> {
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];

		]
	],
	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Bench *)
				Object[Container, Bench, "Test bench for ExperimentFreezeCellsOptions "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentFreezeCellsOptions "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentFreezeCellsOptions "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsOptions) "<>$SessionUUID]
			},
				ObjectP[]
			];

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
	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];


(* ::Subsubsection::Closed:: *)
(* ExperimentFreezeCellsPreview *)

DefineTests[ExperimentFreezeCellsPreview,
	{
		Example[{Basic, "Return Null:"},
			ExperimentFreezeCellsPreview[{
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID]
			},
				Aliquot -> True
			],
			Null
		]
	},
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, testBench, tube1, tube2, sample1, sample2
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Bench *)
				Object[Container, Bench, "Test bench for ExperimentFreezeCellsPreview "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentFreezeCellsPreview "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentFreezeCellsPreview "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			testBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentFreezeCellsPreview "<> $SessionUUID,
					Site -> Link[$Site]
				|>
			];

			{tube1, tube2} = UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test 2mL Tube 1 for ExperimentFreezeCellsPreview "<>$SessionUUID,
					"Test 2mL Tube 2 for ExperimentFreezeCellsPreview "<>$SessionUUID
				},
				FastTrack -> True
			];

			(* Create some samples for testing purposes *)
			{sample1, sample2} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}}
				},
				{
					{"A1", tube1},
					{"A1", tube2}
				},
				Name -> {
					"Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter
				},
				CellType -> {
					Mammalian,
					Bacterial
				},
				CultureAdhesion -> {
					Suspension,
					Suspension
				},
				Living -> {
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];

		]
	],
	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Bench *)
				Object[Container, Bench, "Test bench for ExperimentFreezeCellsPreview "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentFreezeCellsPreview "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentFreezeCellsPreview "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ExperimentFreezeCellsPreview) "<>$SessionUUID]
			},
				ObjectP[]
			];

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
	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];


(* ::Subsubsection::Closed:: *)
(* ValidExperimentFreezeCellsQ *)

DefineTests[ValidExperimentFreezeCellsQ,
	{
		Example[{Basic, "Return a boolean indicating whether the call is valid:"},
			ValidExperimentFreezeCellsQ[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
				}
			],
			True
		],
		Example[{Basic, "If an input is invalid, returns False:"},
			ValidExperimentFreezeCellsQ[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
				}
			],
			False
		],
		Example[{Basic, "If an option is invalid, returns False:"},
			ValidExperimentFreezeCellsQ[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
				},
				CellType -> Yeast,
				Name -> "Existing ValidExperimentFreezeCellsQ protocol"
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			ValidExperimentFreezeCellsQ[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
				},
				Name -> "Existing ValidExperimentFreezeCellsQ protocol",
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentFreezeCellsQ[
				{
					Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
					Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
				},
				Name -> "Existing ValidExperimentFreezeCellsQ protocol",
				Verbose -> True
			],
			BooleanP
		]
	},
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, testBench, tube1, tube2, tube3, sample1, sample2, sample3
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Bench *)
				Object[Container, Bench, "Test bench for ValidExperimentFreezeCellsQ "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for ValidExperimentFreezeCellsQ "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ValidExperimentFreezeCellsQ "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ValidExperimentFreezeCellsQ "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
				Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			testBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ValidExperimentFreezeCellsQ "<> $SessionUUID,
					Site -> Link[$Site]
				|>
			];

			{tube1, tube2, tube3} = UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test 2mL Tube 1 for ValidExperimentFreezeCellsQ "<>$SessionUUID,
					"Test 2mL Tube 2 for ValidExperimentFreezeCellsQ "<>$SessionUUID,
					"Test 2mL Tube 3 for ValidExperimentFreezeCellsQ "<>$SessionUUID
				},
				FastTrack -> True
			];

			(* Create some samples for testing purposes *)
			{sample1, sample2, sample3} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}}
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", tube3}
				},
				Name -> {
					"Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID,
					"Adherent mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter
				},
				CellType -> {
					Mammalian,
					Bacterial,
					Mammalian
				},
				CultureAdhesion -> {
					Suspension,
					Suspension,
					Adherent
				},
				Living -> {
					True,
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];
		]
	],
	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Bench *)
				Object[Container, Bench, "Test bench for ValidExperimentFreezeCellsQ "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for ValidExperimentFreezeCellsQ "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ValidExperimentFreezeCellsQ "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ValidExperimentFreezeCellsQ "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID],
				Object[Sample, "Adherent mammalian cell sample in 2mL Tube (Test for ValidExperimentFreezeCellsQ) "<>$SessionUUID]
			},
				ObjectP[]
			];

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
	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];


(* ::Subsubsection::Closed:: *)
(* FreezeCells *)

DefineTests[FreezeCells,
	{
		Example[{Basic, "Freeze a single bacterial cell sample in a cryogenic vial using a ControlledRateFreezer Strategy:"},
			Experiment[{
				FreezeCells[
					Sample -> Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for FreezeCells) "<>$SessionUUID],
					FreezingStrategy -> ControlledRateFreezer
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Freeze two cell samples, one in its input container and another which needs to be aliquoted, using a ControlledRateFreezer Strategy:"},
			Experiment[{
				FreezeCells[
					Sample -> {
						Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for FreezeCells) " <> $SessionUUID],
						Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for FreezeCells) " <> $SessionUUID]
					},
					Aliquot ->{
						False,
						True
					},
					FreezingStrategy -> ControlledRateFreezer
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Freeze a single cell sample (using a container input) using an InsulatedCooler Strategy:"},
			Experiment[{
				FreezeCells[
					Sample -> {
						Object[Container, Vessel, "Test 2mL Cryogenic Vial 1 for FreezeCells "<>$SessionUUID]
					},
					InsulatedCoolerFreezingTime -> 6 Hour
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Freeze two aliquoted cell samples using an InsulatedCooler Strategy following pelleting:"},
			Experiment[{
				FreezeCells[
					Sample -> {
						Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID],
						Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID]
					},
					Aliquot -> True,
					FreezingStrategy -> InsulatedCooler,
					CellPelletTime -> 10 Minute
				]
			}],
			ObjectP[Object[Protocol]]
		]
	},
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter, testBench, tube1, tube2, cryovial1, sample1, sample2, sample3
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Bench *)
				Object[Container, Bench, "Test bench for FreezeCells "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for FreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for FreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 1 for FreezeCells "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for FreezeCells) "<>$SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			testBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for FreezeCells "<> $SessionUUID,
					Site -> Link[$Site]
				|>
			];

			{tube1, tube2, cryovial1} = UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Cryogenic Vial"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test 2mL Tube 1 for FreezeCells "<>$SessionUUID,
					"Test 2mL Tube 2 for FreezeCells "<>$SessionUUID,
					"Test 2mL Cryogenic Vial 1 for FreezeCells "<>$SessionUUID
				},
				FastTrack -> True
			];

			(* Create some samples for testing purposes *)
			{sample1, sample2, sample3} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "Ecoli 25922"]}}
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", cryovial1}
				},
				Name -> {
					"Suspension mammalian cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID,
					"Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for FreezeCells) "<>$SessionUUID
				},
				InitialAmount -> 0.5 Milliliter,
				CellType -> {
					Mammalian,
					Bacterial,
					Bacterial
				},
				CultureAdhesion -> Suspension,
				Living -> True,
				State -> Liquid,
				FastTrack -> True
			];
		]
	],
	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Bench *)
				Object[Container, Bench, "Test bench for FreezeCells "<> $SessionUUID],
				(* Sample Containers *)
				Object[Container, Vessel, "Test 2mL Tube 1 for FreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for FreezeCells "<>$SessionUUID],
				Object[Container, Vessel, "Test 2mL Cryogenic Vial 1 for FreezeCells "<>$SessionUUID],
				(* Samples *)
				Object[Sample, "Suspension mammalian cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Tube (Test for FreezeCells) "<>$SessionUUID],
				Object[Sample, "Suspension bacterial cell sample in 2mL Cryogenic Vial (Test for FreezeCells) "<>$SessionUUID]
			},
				ObjectP[]
			];

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
	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];