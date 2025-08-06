(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentQuantifyColonies: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentQuantifyColonies*)


DefineTests[ExperimentQuantifyColonies,
	{
		(* ===Basic===*)
		Example[{Basic, "Create a protocol object to count a single bacterial sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Create a protocol object to count a single bacterial plate:"},
			ExperimentQuantifyColonies[
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Create a protocol object to count several samples:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ExperimentQuantifyColonies" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Create a protocol object to construct solid media plate and count CFU for a single sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, QuantifyColonies]]
		],
		Example[{Basic, "Create a protocol object to construct solid media plates and count CFU for several samples:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Liquid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, QuantifyColonies]]
		],
		Test["Subprotocol IncubateCells populates Overclock -> True when the root protocol is QuantifyColonies:",
			Module[{protocol},
				protocol = ExperimentQuantifyColonies[
					Object[Sample, "Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID]
				];
				ExperimentIncubateCells[
					Object[Sample, "Solid Media Bacterial cells subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
					ParentProtocol -> protocol
				];
				Download[protocol, Overclock]
			],
			True
		],
		Test["Make sure RequiredResources gets only ImagingInstrument and SpreaderInstrument populated properly when incubator is default incubator:",
			Module[{protocol, protRequiredResources},
				protocol = ExperimentQuantifyColonies[
					Object[Sample, "Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID],
					Incubator -> Model[Instrument, Incubator, "Bactomat HERAcell 240i TT 10 for Bacteria"]
				];
				protRequiredResources = Download[protocol, RequiredResources];
				{
					Cases[protRequiredResources, {resource_, ImagingInstrument, _, _} :> Download[resource, Object]],
					Cases[protRequiredResources, {resource_, SpreaderInstrument, _, _} :> Download[resource, Object]],
					Cases[protRequiredResources, {resource_, Incubator, _, _} :> Download[resource, Object]]
				}
			],
			{
				{ObjectP[Object[Resource, Instrument]]},
				{ObjectP[Object[Resource, Instrument]]},
				{}
			}
		],
		Test["Make sure RequiredResources gets Incubator, ImagingInstrument and SpreaderInstrument populated properly when incubator is custom incubator:",
			Module[{protocol, protRequiredResources},
				protocol = ExperimentQuantifyColonies[
					Object[Sample, "Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID],
					IncubationCondition -> Custom,
					Incubator -> Model[Instrument, Incubator, "Multitron Pro with 3mm Orbit"]
				];
				protRequiredResources = Download[protocol, RequiredResources];
				{
					Cases[protRequiredResources, {resource_, ImagingInstrument, _, _} :> Download[resource, Object]],
					Cases[protRequiredResources, {resource_, SpreaderInstrument, _, _} :> Download[resource, Object]],
					Cases[protRequiredResources, {resource_, Incubator, _, _} :> Download[resource, Object]]
				}
			],
			{
				{ObjectP[Object[Resource, Instrument]]},
				{ObjectP[Object[Resource, Instrument]]},
				{ObjectP[Object[Resource, Instrument]]}
			}
		],
		(* ===Options=== *)
		Example[{Options, PreparedSample, "PreparedSample indicates the no spread cells or incubation steps are needed:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				PreparedSample -> True,
				Output -> Options
			],
			KeyValuePattern[{
				PreparedSample -> True
			}]
		],
		Example[{Options, ImagingInstrument, "ImagingInstrument indicates the instrument to count samples:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				ImagingInstrument -> Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				ImagingInstrument -> ObjectP[Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID]]
			}]
		],
		Example[{Options, SpreaderInstrument, "SpreaderInstrument indicates the instrument to spread liquid sample to solid media plates:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreaderInstrument -> Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				SpreaderInstrument -> ObjectP[Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID]]
			}]
		],
		Example[{Options, Incubator, "Incubator indicates the instrument to grow solid media plates:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "Bactomat HERAcell 240i TT 10 for Bacteria"],
				Output -> Options
			],
			KeyValuePattern[{
				Incubator -> ObjectP[Model[Instrument, Incubator, "Bactomat HERAcell 240i TT 10 for Bacteria"]]
			}]
		],
		(* Dilution *)
		Example[{Options, DilutionType, "DilutionType can be set to Linear:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Linear,
				Output -> Options
			],
			KeyValuePattern[{
				DilutionType -> Linear
			}]
		],
		Example[{Options, DilutionType, "DilutionType can be set to Serial:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				Output -> Options
			],
			KeyValuePattern[{
				DilutionType -> Serial
			}]
		],
		Example[{Options, DilutionStrategy, "Specify that the plating should be performed on the final output sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				DilutionStrategy -> Endpoint,
				Output -> Options
			],
			KeyValuePattern[{
				DilutionStrategy -> Endpoint
			}]
		],
		Example[{Options, DilutionStrategy, "Specify that the plating should be performed on the entire dilution series:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				DilutionStrategy -> Series,
				Output -> Options
			],
			KeyValuePattern[{
				DilutionStrategy -> Series
			}]
		],
		Example[{Options, NumberOfDilutions, "Perform multiple serial dilutions before spreading the cells:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				NumberOfDilutions -> 5,
				Output -> Options
			],
			KeyValuePattern[{
				NumberOfDilutions -> 5
			}]
		],
		Example[{Options, NumberOfDilutions, "Perform multiple linear dilutions before spreading the cells (this essentially makes replicates):"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Linear,
				NumberOfDilutions -> 5,
				Output -> Options
			],
			KeyValuePattern[{
				NumberOfDilutions -> 5
			}]
		],
		Example[{Options, CumulativeDilutionFactor, "Specify factor to dilute the cells by specifying the dilution factor in relation to the original sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				DilutionStrategy -> Endpoint,
				SpreadVolume -> 10 Microliter,
				CumulativeDilutionFactor -> {{1.5, 2, 3}},
				Output -> Options
			],
			KeyValuePattern[{
				CumulativeDilutionFactor -> {{1.5, 2, 3}}
			}]
		],
		Example[{Options, SerialDilutionFactor, "Specify factor to dilute the cells by specifying the dilution factor in relation to the previously diluted sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				DilutionStrategy -> Endpoint,
				SpreadVolume -> 10 Microliter,
				SerialDilutionFactor -> {{1.1, 1.5, 2}},
				Output -> Options
			],
			KeyValuePattern[{
				SerialDilutionFactor -> {{1.1, 1.5, 2}}
			}]
		],
		(* SpreadCells *)
		Example[{Options, ColonySpreadingTool, "Specify the tool used to spread the cells in suspension on the destination container:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ColonySpreadingTool -> Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"],
				Output -> Options
			],
			KeyValuePattern[{
				ColonySpreadingTool -> ObjectP[Model[Part, ColonyHandlerHeadCassette, "1-pin spreading head"]]
			}]
		],
		Example[{Options, SpreadVolume, "Specify the amount of cells in suspension to spread on the destination container:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreadVolume -> 50 Microliter,
				Output -> Options
			],
			KeyValuePattern[{
				SpreadVolume -> 50 Microliter
			}]
		],
		Example[{Options, DispenseCoordinates, "Specify the DispenseCoordinates to spread the cells in suspension on the destination container:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DispenseCoordinates -> {{{1 Millimeter, 1 Millimeter}}},
				Output -> Options
			],
			KeyValuePattern[{
				DispenseCoordinates -> {{{1 Millimeter, 1 Millimeter}}}
			}]
		],
		Example[{Options, SpreadPatternType, "Specify the pattern to spread the suspended colonies on the plate:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreadPatternType -> VerticalZigZag,
				Output -> Options
			],
			KeyValuePattern[{
				SpreadPatternType -> VerticalZigZag
			}]
		],
		Example[{Options, CustomSpreadPattern, "Specify a custom set of coordinates to describe how to spread the suspended colonies on the plate:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreadPatternType -> Custom,
				CustomSpreadPattern -> Spread[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}],
				Output -> Options
			],
			KeyValuePattern[{
				CustomSpreadPattern -> {Spread[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}]}
			}]
		],
		Example[{Options, CustomSpreadPattern, "Specify a custom set of coordinates with multiple strokes to describe how to spread the suspended colonies on the plate:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreadPatternType -> Custom,
				CustomSpreadPattern -> {
					Spread[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}],
					Spread[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}]
				},
				Output -> Options
			],
			KeyValuePattern[{
				CustomSpreadPattern -> {
					Spread[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}],
					Spread[{{1 Millimeter, 1 Millimeter}, {2 Millimeter, 2 Millimeter}}]
				}
			}]
		],
		Example[{Options, DestinationContainer, "Specify the container to spread the suspended colonies in as an object:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				DestinationContainer -> ObjectP[Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID]]
			}]
		],
		Example[{Options, DestinationContainer, "Specify the container to spread the suspended colonies in as a model:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Model[Container, Plate, "Omni Tray Sterile Media Plate"],
				Output -> Options
			],
			KeyValuePattern[{
				DestinationContainer -> ObjectP[Model[Container, Plate, "Omni Tray Sterile Media Plate"]]
			}]
		],
		Example[{Options, DestinationWell, "Specify the well in DestinationContainer the suspended colonies should be spread in:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Model[Container, Plate, "Omni Tray Sterile Media Plate"],
				DestinationWell -> "A1",
				Output -> Options
			],
			KeyValuePattern[{
				DestinationWell -> {"A1"}
			}]
		],
		Example[{Options, DestinationMedia, "Specify the media to pour into the destination well of destination container which the colonies will be spread on:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"],
				Output -> Options
			],
			KeyValuePattern[{
				DestinationMedia -> ObjectP[Model[Sample, Media, "LB (Solid Agar)"]]
			}]
		],
		(* IncubateCells *)
		Example[{Options, IncubationCondition, "Select under what conditions the spread solid media plates should be incubated:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubationCondition -> BacterialIncubation,
				Output -> Options
			],
			KeyValuePattern[{
				IncubationCondition -> BacterialIncubation
			}]
		],
		Example[{Options, IncubationCondition, "IncubationCondition is automatically resolved to Custom if samples are a mix of Bacterial and Yeast:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				Output -> Options
			],
			KeyValuePattern[{
				IncubationCondition -> Custom
			}]
		],
		Example[{Options, Temperature, "Incubate a single sample in a plate with a given Temperature:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Temperature -> 37 Celsius,
				Output -> Options
			],
			KeyValuePattern[{
				Temperature -> EqualP[37 Celsius]
			}]
		],
		Example[{Options, Temperature, "Temperature is automatically resolved to the temperature field of specified IncubationCondition:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubationCondition -> BacterialIncubation,
				Output -> Options
			],
			KeyValuePattern[{
				Temperature -> EqualP[37 Celsius]
			}]
		],
		Example[{Options, Temperature, "Temperature is automatically resolved to 30 Celsius if IncubationCondition is Custom:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				IncubationCondition -> Custom,
				Output -> Options
			],
			KeyValuePattern[{
				Temperature -> EqualP[30 Celsius]
			}]
		],
		Example[{Options, ColonyIncubationTime, "ColonyIncubationTime indicates the time for incubation before the solid media plate is imaged for the first time:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ColonyIncubationTime -> 12 Hour,
				Output -> Options
			],
			KeyValuePattern[{
				ColonyIncubationTime -> EqualP[12 Hour]
			}]
		],
		Example[{Options, ColonyIncubationTime, "ColonyIncubationTime is default to 10 times doubling time:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				ColonyIncubationTime -> EqualP[3 Hour]
			}]
		],
		Example[{Options, MinReliableColonyCount, "MinReliableColonyCount is automatically set to 1 for prepared samples:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MinReliableColonyCount
			],
			1
		],
		Example[{Options, MaxReliableColonyCount, "MaxReliableColonyCount is automatically set to 300:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MaxReliableColonyCount
			],
			300
		],
		Example[{Options, IncubateUntilCountable, "IncubateUntilCountable indicates if incubation is repeated before stopping the experiment:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubateUntilCountable -> False,
				Output -> Options
			];
			KeyValuePattern[{
				IncubateUntilCountable -> False
			}]
		],
		Example[{Options, {IncubateUntilCountable, NumberOfStableIntervals}, "IncubateUntilCountable is default to True:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				IncubateUntilCountable -> True,
				NumberOfStableIntervals -> 1
			}]
		],
		Example[{Options, NumberOfStableIntervals, "Specify the NumberOfStableIntervals option to set stopping criteria for the experiment:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubateUntilCountable -> True,
				NumberOfStableIntervals -> 3,
				Output -> Options
			],
			KeyValuePattern[{
				IncubateUntilCountable -> True,
				NumberOfStableIntervals -> 3
			}]
		],
		Example[{Options, MaxColonyIncubationTime, "MaxColonyIncubationTime indicates the longest time for incubation before stopping the experiment:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ColonyIncubationTime -> 12 Hour,
				IncubationInterval -> 1 Hour,
				MaxColonyIncubationTime -> 18 Hour,
				Output -> Options
			],
			KeyValuePattern[{
				MaxColonyIncubationTime -> EqualP[18 Hour]
			}]
		],
		Example[{Options, MaxColonyIncubationTime, "MaxColonyIncubationTime is default to 20 times doubling time:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				MaxColonyIncubationTime -> EqualP[7 Hour]
			}]
		],
		Example[{Options, IncubationInterval, "Specify the IncubationInterval option to set the time interval between imaging:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ColonyIncubationTime -> 12 Hour,
				IncubationInterval -> 1 Hour,
				Output -> Options
			],
			KeyValuePattern[{
				IncubationInterval -> EqualP[1 Hour]
			}]
		],
		Example[{Options, IncubationInterval, "IncubationInterval is default to 5 times doubling time:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				IncubationInterval -> EqualP[2 Hour]
			}]
		],
		(* Core options *)
		Example[{Options, Populations, "Use the Populations option to specify a single population primitive that describes the colonies to count:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> Diameter[],
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> DiameterPrimitiveP
			}]
		],
		Example[{Options, Populations, "Use the Populations option to specify multiple population primitives that describes the colonies to count:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {
					Diameter[],
					Fluorescence[
						ExcitationWavelength -> 457 Nanometer,
						EmissionWavelength -> 536 Nanometer
					]
				},
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> {DiameterPrimitiveP, FluorescencePrimitiveP}
			}]
		],
		Example[{Options, Populations, "Use the Populations option to specify a MultiFeatured primitive:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {
					MultiFeatured[
						Features -> {Fluorescence, Fluorescence},
						Select -> {Positive, Positive},
						ExcitationWavelength -> {457 Nanometer, 531 Nanometer},
						EmissionWavelength -> {536 Nanometer, 593 Nanometer}
					]
				},
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> {MultiFeaturedPrimitiveP}
			}]
		],
		Example[{Options, Populations, "Populations is automatically resolved to Fluorescence if input sample contains fluorophore:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Fluorescence Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> FluorescencePrimitiveP,
				PopulationCellTypes -> Bacterial,
				PopulationIdentities -> ObjectP[Model[Cell, Bacteria, "Fluorescence Model Cell for ExperimentQuantifyColonies" <> $SessionUUID]]
			}]
		],
		Example[{Options, PopulationCellTypes, "Use the PopulationCellTypes option to specify cell type associated with populations:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> All,
				PopulationCellTypes -> Bacterial,
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> AllColoniesPrimitiveP,
				PopulationCellTypes -> Bacterial,
				PopulationIdentities -> ObjectP[Model[Cell, Bacteria, "E.coli MG1655"]]
			}]
		],
		Example[{Options, PopulationCellTypes, "If PopulationCellTypes option is specified and no duplicates, PopulationIdentities can be resolved if Model[Cell] corresponding exists:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Mixed Yeast and Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {
					Diameter[],
					Fluorescence[
						ExcitationWavelength -> 457 Nanometer,
						EmissionWavelength -> 536 Nanometer
					]
				},
				PopulationCellTypes -> {Bacterial, Yeast},
				Output -> Options
			],
			KeyValuePattern[{
				PopulationCellTypes -> {Bacterial, Yeast},
				PopulationIdentities -> {ObjectP[Model[Cell, Bacteria, "E.coli MG1655"]], ObjectP[Model[Cell, Yeast, "Yeast Model Cell for ExperimentQuantifyColonies" <> $SessionUUID]]}
			}]
		],
		Example[{Options, PopulationIdentities, "PopulationIdentities is automatically resolved to strings if specified populations are not in existing sample composition:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {
					Diameter[],
					Fluorescence[
						ExcitationWavelength -> 457 Nanometer,
						EmissionWavelength -> 536 Nanometer
					]
				},
				Output -> Options
			],
			KeyValuePattern[{
				PopulationIdentities -> {_String, _String}
			}]
		],
		Example[{Options, PopulationIdentities, "PopulationIdentities can be specified as either Model[Cell] or string:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {
					Diameter[],
					Fluorescence[
						ExcitationWavelength -> 457 Nanometer,
						EmissionWavelength -> 536 Nanometer
					]
				},
				PopulationIdentities -> {Model[Cell, Bacteria, "id:54n6evLm7m0L"], "new selected col" <> $SessionUUID},
				Output -> Options
			],
			KeyValuePattern[{
				PopulationIdentities -> {ObjectP[], _String}
			}]
		],
		Example[{Options, ImagingStrategies, "ImagingStrategies indicates the presets which describe how to expose the colonies to light:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, DarkRedFluorescence},
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> FluorescencePrimitiveP,
				ImagingStrategies -> {BrightField, DarkRedFluorescence},
				ExposureTimes -> {Automatic, Automatic}
			}]
		],
		Example[{Options, ImagingStrategies, "ImagingStrategies can be resolved automatically if Populations is specified:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {
					MultiFeatured[
						Features -> {BlueWhiteScreen, Fluorescence, Fluorescence},
						Select -> {Negative, Positive, Positive},
						ExcitationWavelength -> {Null, 457 Nanometer, 531 Nanometer},
						EmissionWavelength -> {Null, 536 Nanometer, 593 Nanometer}
					]
				},
				Output -> Options
			],
			KeyValuePattern[{
				Populations -> {MultiFeaturedPrimitiveP},
				ImagingStrategies -> {(BrightField|BlueWhiteScreen|GreenFluorescence|OrangeFluorescence)..},
				ExposureTimes -> {Automatic, Automatic, Automatic, Automatic}
			}]
		],
		Example[{Options, ExposureTimes, "ExposureTimes indicates the length of time to allow the camera to capture an image:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				ImagingStrategies -> BrightField,
				ExposureTimes -> 100 Millisecond,
				Output -> Options
			],
			KeyValuePattern[{
				ImagingStrategies -> BrightField,
				ExposureTimes -> 100 Millisecond
			}]
		],
		(* Analysis *)
		Example[{Options, MinDiameter, "MinDiameter is automatically set to 0.5 Millimeter:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MinDiameter
			],
			0.5 Millimeter
		],
		Example[{Options, MaxDiameter, "MaxDiameter is automatically set to 2 Millimeter:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MaxDiameter
			],
			EqualP[2 Millimeter]
		],
		Example[{Options, MinColonySeparation, "MinColonySeparation is automatically set to 0.2 Millimeter:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MinColonySeparation
			],
			0.2 Millimeter
		],
		Example[{Options, MinRegularityRatio, "MinRegularityRatio is automatically set to 0.65:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MinRegularityRatio
			],
			0.65
		],
		Example[{Options, MaxRegularityRatio, "MaxRegularityRatio is automatically set to 1:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MaxRegularityRatio
			],
			EqualP[1]
		],
		Example[{Options, MaxCircularityRatio, "MaxCircularityRatio is automatically set to 1:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MaxCircularityRatio
			],
			EqualP[1]
		],
		Example[{Options, MinCircularityRatio, "MinCircularityRatio is automatically set to 0.65:"},
			Lookup[
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Output -> Options
				],
				MinCircularityRatio
			],
			EqualP[0.65]
		],
		(* Others *)
		Example[{Options, SampleLabel, "SampleLabel can be given:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				SampleLabel -> "my test bacterial sample" <> $SessionUUID,
				Output -> Options
			],
			KeyValuePattern[{
				SampleLabel -> "my test bacterial sample" <> $SessionUUID
			}]
		],
		Example[{Options, SampleContainerLabel, "SampleContainerLabel can be given:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				SampleContainerLabel -> "my test bacterial plate" <> $SessionUUID,
				Output -> Options
			],
			KeyValuePattern[{
				SampleContainerLabel -> "my test bacterial plate" <> $SessionUUID
			}]
		],
		Example[{Options, SampleOutLabel, "Specify labels for samples out:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				NumberOfDilutions -> 3,
				DilutionType -> Serial,
				DilutionStrategy -> Series,
				SampleOutLabel -> {
					"My sample 1", "My sample 2", "My sample 3", "My sample 4"
				},
				Output -> Options
			],
			KeyValuePattern[{
				SampleOutLabel -> {"My sample 1", "My sample 2", "My sample 3", "My sample 4"}
			}]
		],
		Example[{Options, SampleOutLabel, "Specifying SampleOutLabel to Null should not yell ConflictingPreparedSampleWithSpreading:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				SampleOutLabel -> Null,
				Output -> Options
			],
			KeyValuePattern[{
				SampleOutLabel -> Null
			}]
		],
		Example[{Options, SampleOutLabel, "QuantifyColonies UnitOperation called within ExperimentCellPreparation can handle specified SampleOutLabel to Null (for script run):"},
			ExperimentRoboticCellPreparation[
				{
					QuantifyColonies[
						Sample -> {
							Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
							Object[Sample,
								"Solid Media Yeast cells for ExperimentQuantifyColonies" <> $SessionUUID]
						},
						SampleOutLabel -> Null
					]
				}
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Options, ContainerOutLabel, "Specify labels for the containers out:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				NumberOfDilutions -> 3,
				DilutionType -> Serial,
				DilutionStrategy -> Series,
				ContainerOutLabel -> {
					"My container 1","My container 2","My container 3","My container 4"
				},
				Output -> Options
			],
			KeyValuePattern[{
				ContainerOutLabel -> {"My container 1", "My container 2", "My container 3", "My container 4"}
			}]
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___] := (Message[Error::ShouldntGetHere]; False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___] := False}
		],
		Example[{Options, Preparation, "Preparation is default to Robotic for prepared sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Preparation -> Robotic
			}]
		],
		Example[{Options, Preparation, "Preparation is default to Manual for unprepared sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Preparation -> Manual
			}]
		],
		Example[{Options, WorkCell, "WorkCell is default to qPix for robotic preparation:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				WorkCell -> qPix
			}]
		],
		Example[{Options, WorkCell, "WorkCell is default to Null for manual preparation:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				WorkCell -> Null
			}]
		],
		Example[{Options, SampleOutLabel, "Specify labels for samples out:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				NumberOfDilutions -> 3,
				DilutionType -> Serial,
				DilutionStrategy -> Series,
				SampleOutLabel -> {
					"My sample 1", "My sample 2", "My sample 3", "My sample 4"
				},
				Output -> Options
			],
			KeyValuePattern[{
				SampleOutLabel -> {"My sample 1", "My sample 2", "My sample 3", "My sample 4"}
			}]
		],
		Example[{Options, ContainerOutLabel, "Specify labels for the containers out:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				NumberOfDilutions -> 3,
				DilutionType -> Serial,
				DilutionStrategy -> Series,
				ContainerOutLabel -> {
					"My container 1","My container 2","My container 3","My container 4"
				},
				Output -> Options
			],
			KeyValuePattern[{
				ContainerOutLabel -> {"My container 1", "My container 2", "My container 3", "My container 4"}
			}]
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___] := (Message[Error::ShouldntGetHere]; False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___] := False}
		],
		Example[{Options, Preparation, "Preparation is default to Robotic for prepared sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Preparation -> Robotic
			}]
		],
		Example[{Options, Preparation, "Preparation is default to Manual for unprepared sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Preparation -> Manual
			}]
		],
		Example[{Options, WorkCell, "WorkCell is default to qPix for robotic preparation:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				WorkCell -> qPix
			}]
		],
		Example[{Options, WorkCell, "WorkCell is default to Null for manual preparation:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				WorkCell -> Null
			}]
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the Spreading step:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SamplesInStorageCondition -> BacterialShakingIncubation,
				Output -> Options
			],
			KeyValuePattern[{
				SamplesInStorageCondition -> BacterialShakingIncubation
			}]
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SamplesOutStorageCondition -> Refrigerator,
				Output -> Options
			],
			KeyValuePattern[{
				SamplesOutStorageCondition -> Refrigerator
			}]
		],
		(* ===Additional=== *)
		Example[{Additional, "Return the simulation packet when Output->Simulation:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP,
			TimeConstraint -> 1000
		],
		Example[{Additional, "Simulate IncubationSamples with Composition in the unit of Colony:"},
			Module[{protocol, simulation, incubationSamples},
				{protocol, simulation} = ExperimentQuantifyColonies[
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					MinReliableColonyCount -> 30,
					MaxReliableColonyCount -> 300,
					Output -> {Result, Simulation}
				];
				incubationSamples = Download[
					protocol,
					IncubationSamples,
					Simulation -> simulation
				];
				ColonyCountQ[Cases[Flatten[Download[incubationSamples, Composition, Simulation -> simulation], 1], {_, LinkP[Model[Cell, Bacteria, "E.coli MG1655"]], _}][[All, 1]]]
			],
			{True..}
		],
		Example[{Additional, "Simulate composition change with CFU unit for each input sample after experiment:"},
			Module[{protocol, simulation, oldComp, simulatedComp},
				{protocol, simulation} = ExperimentQuantifyColonies[
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					MinReliableColonyCount -> 30,
					MaxReliableColonyCount -> 300,
					Output -> {Result, Simulation}
				];
				oldComp = Download[
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Composition
				];
				simulatedComp = Download[
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Composition,
					Simulation -> simulation
				];
				Cases[Flatten[Join[{oldComp, simulatedComp}], 1], {_, LinkP[Model[Cell, Bacteria, "E.coli MG1655"]], _}][[All, 1]]
			],
			{EqualP[1000000 EmeraldCell/Milliliter], RangeP[0.18 CFU/Microliter, 0.185 CFU/Microliter]}
		],
		Example[{Additional, "If PopulationCellTypes is specified as a list, Populations is resolved according to the specified form:"},
			Module[{protocol},
				protocol = ExperimentRoboticCellPreparation[{
					QuantifyColonies[
						Sample -> {
							Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
							Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
							Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID]
						},
						ImagingStrategies -> {
							{BrightField, GreenFluorescence},
							{BrightField, GreenFluorescence},
							{BrightField, GreenFluorescence}
						},
						PopulationCellTypes -> {{Bacterial}, {Bacterial}, {Bacterial}}
					]
				}];
				Download[protocol, OutputUnitOperations[[1]][Populations]]
			],
			{{FluorescencePrimitiveP},{FluorescencePrimitiveP},{FluorescencePrimitiveP}}
		],
		Example[{Additional, "If PopulationIdentities is specified as a list, Populations is resolved according to the specified form:"},
			Module[{protocol},
				protocol = ExperimentRoboticCellPreparation[{
					QuantifyColonies[
						Sample -> {
							Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
							Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
							Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID]
						},
						ImagingStrategies -> {
							{BrightField, GreenFluorescence},
							{BrightField, GreenFluorescence},
							{BrightField, GreenFluorescence}
						},
						PopulationIdentities -> {{"new cells 1"}, {"new cells 2"}, {"new cells 3"}}
					]
				}];
				Download[protocol, OutputUnitOperations[[1]][Populations]]
			],
			{{FluorescencePrimitiveP},{FluorescencePrimitiveP},{FluorescencePrimitiveP}}
		],
		(* ===Messages=== *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentQuantifyColonies[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentQuantifyColonies[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentQuantifyColonies[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentQuantifyColonies[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "id:O81aEBZjRXvx"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 10 Gram,
					State -> Solid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentQuantifyColonies[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "id:O81aEBZjRXvx"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 10 Gram,
					State -> Solid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentQuantifyColonies[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "UnsupportedColonyTypes", "Throws an error if the input sample is not bacterial or yeast:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Mammalian cells for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedColonyTypes,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnsupportedColonyTypes", "Throws an error cleanly if the input sample has cell type of Null:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media No Cell sample 1 for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedColonyTypes,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonSolidSamples", "Throws an error if the input sample is not solid. But should not complain about conflicting preparation in v1 because liquid is now allowed at all:"},
			Block[{$QuantifyColoniesPreparedOnly = True},
				ExperimentQuantifyColonies[
					{
						Object[Sample, "Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID]
					}
				]
			],
			$Failed,
			Messages :> {
				Error::NonSolidSamples,
				Error::QuantifyColoniesPreparationNotSupported,
				Error::InvalidOption,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonLiquidSamples", "Throws an error if the input sample is freeze dried:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Freeze dried sample 1 for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonLiquidSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NonLiquidSamples", "Throws an error if the input sample is frozen:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Frozen glycerol sample 1 for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonLiquidSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "Throws an error if model of the sample is deprecated:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Bacterial cells Deprecated for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidContainerModels", "Throws an error if the container of prepared sample is not a SBS plate:"},
			Block[{$QuantifyColoniesPreparedOnly = True},
				ExperimentQuantifyColonies[
					Object[Sample, "Bacterial cells in InvalidContainerModels 1 for ExperimentQuantifyColonies" <> $SessionUUID]
				]
			],
			$Failed,
			Messages :> {
				Error::NonOmniTrayContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidContainerModels", "Throws an error if the container of prepared sample has more than 1 well:"},
			Block[{$QuantifyColoniesPreparedOnly = True},
				ExperimentQuantifyColonies[
					Object[Sample, "Bacterial cells in InvalidContainerModels 2 for ExperimentQuantifyColonies" <> $SessionUUID]
				]
			],
			$Failed,
			Messages :> {
				Error::NonOmniTrayContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicatedSamples", "Throws an error if the input samples contain duplicates:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "QuantifyColoniesPreparationNotSupported", "Throws an error if PreparedSample option is False if $QuantifyColoniesPreparedOnly is True:"},
			Block[{$QuantifyColoniesPreparedOnly = True},
				ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					PreparedSample -> False
				]
			],
			$Failed,
			Messages :> {
				Error::QuantifyColoniesPreparationNotSupported,
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InstrumentPrecision", "Throws a warning if option is rounded:"},
			options = ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				ExposureTimes -> 100.1 Millisecond,
				Output -> Options
			];
			Lookup[options, ExposureTimes],
			100 Millisecond,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Messages, "InstrumentPrecision", "Throws a warning if option is rounded:"},
			options = ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				MinDiameter -> 0.651 Millimeter,
				Output -> Options
			];
			Lookup[options, MinDiameter],
			0.65 Millimeter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Messages, "ImagingOptionMismatch", "Throws an error if the length of ImagingStrategies and ExposureTimes are different:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, BlueWhiteScreen, RedFluorescence},
				ExposureTimes -> {3 Millisecond, 5 Millisecond}
			],
			$Failed,
			Messages :> {
				Error::ImagingOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ImagingOptionMismatch", "Throws an error if ImagingStrategies is a list but ExposureTimes is a single value:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, BlueWhiteScreen, RedFluorescence},
				ExposureTimes -> 3 Millisecond
			],
			$Failed,
			Messages :> {
				Error::ImagingOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MissingImagingStrategies", "If there are imaging strategies specified in a Population that are not specified in ImagingStrategies, an error will be thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> Fluorescence[ExcitationWavelength -> 457 Nanometer, EmissionWavelength -> 536 Nanometer],
				ImagingStrategies -> {BrightField, VioletFluorescence}
			],
			$Failed,
			Messages :> {
				Error::MissingImagingStrategies,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OverlappingPopulations", "Throws an error if there is a duplicates in Populations:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {Diameter[], Diameter[]}
			],
			$Failed,
			Messages :> {
				Error::OverlappingPopulations,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OverlappingPopulations", "Throws an error if there is All and Diameter in Populations:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {Diameter[], All}
			],
			$Failed,
			Messages :> {
				Error::OverlappingPopulations,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicatedPopulationIdentities", "Throws an error if there is a duplicate new cell model in PopulationIdentities option:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				Populations -> {Diameter[]},
				PopulationIdentities -> {{"repeat colony name" <> $SessionUUID}, {"repeat colony name" <> $SessionUUID}}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedPopulationIdentities,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicatedPopulationIdentities", "Throws an error if there is a duplicate in existing model PopulationIdentities option:"},(*TODO*)
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {{
					Diameter[ThresholdDiameter -> 1 Millimeter],
					Diameter[Include -> {{300 Nanometer, 800 Nanometer}}]
				}},
				PopulationIdentities -> {{Model[Cell, Bacteria, "E.coli MG1655"], Model[Cell, Bacteria, "E.coli MG1655"]}}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedPopulationIdentities,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPopulationIdentitiesWithPopulations", "Throws an error if the length of PopulationIdentities and Populations are different:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {Diameter[]},
				PopulationCellTypes -> {Bacterial},
				PopulationIdentities -> {"extra cell1" <> $SessionUUID, "extra cell2" <> $SessionUUID}
			],
			$Failed,
			Messages :> {
				Error::ConflictingPopulationCellTypesWithIdentities,
				Error::ConflictingPopulationIdentitiesWithPopulations,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPopulationCellTypesWithIdentities", "Throws an error if the PopulationIdentities is not the PopulationCellTypes:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {All},
				PopulationCellTypes -> {Yeast},
				PopulationIdentities -> {Model[Cell, Bacteria, "E.coli MG1655"]}
			],
			$Failed,
			Messages :> {
				Error::ConflictingPopulationCellTypesWithIdentities,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPopulationCellTypesWithPopulations", "Throws an error if the length of Populations and PopulationCellTypes are different:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {Diameter[]},
				PopulationCellTypes -> {Bacterial, Yeast}
			],
			$Failed,
			Messages :> {
				Error::ConflictingPopulationCellTypesWithPopulations,
				Error::ConflictingPopulationIdentitiesWithPopulations,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPopulationCellTypesWithPopulations", "Throws an error if the format of Populations and PopulationCellTypes are different:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {Diameter[]},
				PopulationCellTypes -> Bacterial
			],
			$Failed,
			Messages :> {
				Error::ConflictingPopulationCellTypesWithPopulations,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NewColonyNameInUse", "Throws an error if there the specified PopulationIdentities exists in database:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				PopulationIdentities -> {"Yeast Model Cell for ExperimentQuantifyColonies" <> $SessionUUID}
			],
			$Failed,
			Messages :> {
				Error::NewColonyNameInUse,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPopulationCellTypesWithIdentities", "Throws an error if there the specified PopulationIdentities is different from specified PopulationCellTypes:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				PopulationIdentities -> {Model[Cell, Bacteria, "E.coli MG1655"]},
				PopulationCellTypes -> {Yeast}
			],
			$Failed,
			Messages :> {
				Error::ConflictingPopulationCellTypesWithIdentities,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWorkCellWithPreparation", "If Preparation is set to Manual, WorkCell must not be set. If Preparation is set to Robotic, it must be set to the correct work cell, otherwise an error will be thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Preparation -> Robotic,
				WorkCell -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingWorkCellWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirement", "If Preparation is set to Manual for a solid sample, throws an error:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Preparation -> Manual
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirement", "If Preparation is set to Robotic for a liquid sample, throws an error:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedSampleWithSpreading", "If PreparedSample is set to True, SpreaderInstrument must not be set:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				PreparedSample -> True,
				SpreaderInstrument -> Model[Instrument, ColonyHandler, "QPix 420 HT"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::ConflictingPreparedSampleWithSpreading,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedSampleWithSpreading", "If PreparedSample is set to False, SpreaderInstrument must be set:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				PreparedSample -> False,
				SpreaderInstrument -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedSampleWithSpreading,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedSampleWithIncubation", "If PreparedSample is set to True, Incubator must not be set:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				PreparedSample -> True,
				Incubator -> Model[Instrument, Incubator, "Bactomat HERAcell 240i TT 10 for Bacteria"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::ConflictingPreparedSampleWithIncubation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedSampleWithIncubation", "If PreparedSample is set to False, Incubator must be set:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				PreparedSample -> False,
				Incubator -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedSampleWithIncubation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SpreadPatternMismatch", "If SpreadPatternType is Custom and a CustomSpreadPattern is not specified, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreadPatternType -> Custom,
				CustomSpreadPattern -> Null
			],
			$Failed,
			Messages :> {
				Error::SpreadPatternMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SpreadPatternMismatch", "If SpreadPatternType is not Custom and a CustomSpreadPattern is specified, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				SpreadPatternType -> Spiral,
				CustomSpreadPattern -> Spread[{{1 Millimeter, 1 Millimeter}}]
			],
			$Failed,
			Messages :> {
				Error::SpreadPatternMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidDestinationContainerType", "If DilutionStrategy is Series and DestinationContainer is an Object[Container], an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionStrategy -> Series,
				DestinationContainer -> Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::InvalidDestinationContainerType,
				Error::InvalidOption,
				Error::ContainerOutLabelMismatch
			}
		],
		Example[{Messages, "DilutionMismatch", "If DilutionType is specified and another dilution option is Null, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Linear,
				NumberOfDilutions -> Null
			],
			$Failed,
			Messages :> {
				Error::DilutionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidDestinationContainer", "If the DestinationContainer has more than 1 well, an error is thrown"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages :> {
				Error::InvalidDestinationContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidDestinationWell", "If the specified DestinationWell is not a position in DestinationContainer, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Model[Container, Plate, "Omni Tray Sterile Media Plate"],
				DestinationWell -> "A2"
			],
			$Failed,
			Messages :> {
				Error::InvalidDestinationWell,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDestinationMedia", "If the specified DestinationMedia is not the same Model as the sample in DestinationWell of DestinationContainer, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationMedia -> Model[Sample, Media, "LB (Solid Agar)"],
				DestinationWell -> "A1"
			],
			$Failed,
			Messages :> {
				Error::ConflictingDestinationMedia,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DestinationMediaNotSolid"," If the specified DestinationMedia does not have Solid State, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationMedia -> Model[Sample, Media, "LB (Liquid)"]
			],
			$Failed,
			Messages :> {
				Error::DestinationMediaNotSolid,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SpreadingMultipleSamplesOnSamePlate", "If DestinationContainer is the same Object[Container] for 2 input samples, an error is thrown:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				DestinationContainer -> {
					Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				Output -> Options
			],
			_,
			Messages :> {Warning::SpreadingMultipleSamplesOnSamePlate}
		],
		Example[{Messages, "SampleOutLabelMismatch", "If DilutionType is Linear and the length of SampleOutLabel is not NumberOfDilutions, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Linear,
				NumberOfDilutions -> 3,
				SampleOutLabel -> {"my label 1", "my label 2"}
			],
			$Failed,
			Messages :> {
				Error::SampleOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleOutLabelMismatch", "If there is no dilution and the length of SampleOutLabel is not 1, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Null,
				SampleOutLabel -> {"my label 1", "my label 2"}
			],
			$Failed,
			Messages :> {
				Error::SampleOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleOutLabelMismatch", "If DilutionStrategy is Series and the length of SampleOutLabel is not NumberOfDilutions + 1, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				DilutionStrategy -> Series,
				NumberOfDilutions -> 3,
				SampleOutLabel -> {"my label 1", "my label 2", "my label 3"}
			],
			$Failed,
			Messages :> {
				Error::SampleOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleOutLabelMismatch", "If DilutionStrategy is Endpoint and the length of SampleOutLabel is not 1, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Serial,
				DilutionStrategy -> Endpoint,
				NumberOfDilutions -> 3,
				SampleOutLabel -> {"my label 1", "my label 2"}
			],
			$Failed,
			Messages :> {
				Error::SampleOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleOutLabelMismatch", "If DilutionStrategy is Null and the length of SampleOutLabel is not NumberOfDilutions, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Linear,
				DilutionStrategy -> Null,
				NumberOfDilutions -> 3,
				SampleOutLabel -> {"my label 1", "my label 2"}
			],
			$Failed,
			Messages :> {
				Error::SampleOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOutLabelMismatch", "If DilutionStrategy is Series and the length of ContainerOutLabel is not NumberOfDilutions + 1, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionStrategy -> Series,
				NumberOfDilutions -> 3,
				ContainerOutLabel -> {"my label 1", "my label 2", "my label 3"}
			],
			$Failed,
			Messages :> {
				Error::ContainerOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOutLabelMismatch", "If DilutionStrategy is Endpoint and the length of ContainerOutLabel is not 1, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionStrategy -> Endpoint,
				NumberOfDilutions -> 3,
				ContainerOutLabel -> {"my label 1", "my label 2"}
			],
			$Failed,
			Messages :> {
				Error::ContainerOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerOutLabelMismatch", "If DilutionStrategy is Null and the length of ContainerOutLabel is not NumberOfDilutions, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DilutionType -> Linear,
				DilutionStrategy -> Null,
				NumberOfDilutions -> 3,
				ContainerOutLabel -> {"my label 1", "my label 2"}
			],
			$Failed,
			Messages :> {
				Error::ContainerOutLabelMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidIncubationConditions", "If storage condition object is specified, an error is thrown if it is not a supported cellular incubation storage condition:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubationCondition -> Model[StorageCondition, "Ambient Storage"]
			],
			$Failed,
			Messages :> {
				Error::InvalidIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidIncubationConditions", "Throws an error is if specified IncubationCondition is not supported for the cell type:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubationCondition -> YeastIncubation
			],
			$Failed,
			Messages :> {
				Error::InvalidIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidIncubationConditions", "Throws an error is if IncubationCondition is not suitable for SolidMedia sample:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubationCondition -> Model[StorageCondition, "Bacterial Incubation with Shaking"]
			],
			$Failed,
			Messages :> {
				Error::InvalidIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubatorIsIncompatible", "Throws an error is if robotic incubator is specified:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"]
			],
			$Failed,
			Messages :> {
				Error::IncubatorIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubatorIsIncompatible", "Throws an error is if specified incubator is not suitable for resolved IncubationCondition:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "Innova 44 for Bacterial Plates"]
			],
			$Failed,
			Messages :> {
				Error::IncubatorIsIncompatible,
				Error::InvalidIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubationMaxTemperature", "If a sample is provided in a container incompatible with the temperature requested, throws an error and returns $Failed:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				DestinationContainer -> Model[Container, Plate, "Test Low MaxTemperature SingleWell Plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Temperature -> 40 Celsius
			],
			$Failed,
			Messages :> {
				Error::IncubationMaxTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyIncubationConditions", "Throws an error if IncubationCondition is a default storage condition while samples are a mix of Bacterial and Yeast:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				IncubationCondition -> YeastIncubation
			],
			$Failed,
			Messages :> {
				Error::TooManyIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyIncubationSamples", "Throws an error if the number of solid media plates exceed the capacity of incubator:"},
			ExperimentQuantifyColonies[
				{
					Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 3 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				DilutionStrategy -> Series,
				NumberOfDilutions -> 6,
				IncubationCondition -> Custom
			],
			$Failed,
			Messages :> {
				Error::TooManyIncubationSamples,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnsuitableIncubationInterval", "If the IncubationInterval is longer than the MaxColonyIncubationTime-ColonyIncubationTime, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ColonyIncubationTime -> 12 Hour,
				MaxColonyIncubationTime -> 14 Hour,
				NumberOfStableIntervals -> Null,
				IncubationInterval -> 3 Hour
			],
			$Failed,
			Messages :> {
				Error::UnsuitableIncubationInterval,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnsuitableIncubationInterval", "If the IncubationInterval is longer than the MaxColonyIncubationTime-ColonyIncubationTime divided by NumberOfStableIntervals, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ColonyIncubationTime -> 12 Hour,
				MaxColonyIncubationTime -> 14 Hour,
				NumberOfStableIntervals -> 2,
				IncubationInterval -> 2 Hour
			],
			$Failed,
			Messages :> {
				Error::UnsuitableIncubationInterval,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubationRepeatOptions", "If IncubateUntilCountable is False but IncubationInterval is specified, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubateUntilCountable -> False,
				ColonyIncubationTime -> 12 Hour,
				MaxColonyIncubationTime -> 12 Hour,
				IncubationInterval -> 1 Hour
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubationRepeatOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubationRepeatOptions", "If IncubateUntilCountable is False but MaxColonyIncubationTime is longer than ColonyIncubationTime, an error is thrown:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				IncubateUntilCountable -> False,
				ColonyIncubationTime -> 12 Hour,
				MaxColonyIncubationTime -> 16 Hour
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubationRepeatOptions,
				Error::InvalidOption
			}
		],
		Test["New colony identity model is uploaded at the time of generation protocol:",
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> Diameter[],
				PopulationCellTypes -> Bacterial,
				PopulationIdentities -> "new selected colony1 for ExperimentQuantifyColonies" <> $SessionUUID
			];
			DatabaseMemberQ[{Model[Cell, Bacteria, "new selected colony1 for ExperimentQuantifyColonies" <> $SessionUUID]}],
			{True}
		],
		Test["When PreparedSample is False and PopulationIdentities is string for new colony identity, new model is created and used to populate PopulationIdentities field of generated protocol:",
			protocol = ExperimentQuantifyColonies[
				Object[Sample, "Liquid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
				Populations -> {Diameter[ThresholdDiameter -> 1 Millimeter], Diameter[Include -> {{300 Nanometer, 800 Nanometer}}]},
				PopulationCellTypes -> {Bacterial, Bacterial},
				PopulationIdentities -> {"new selected colony3 for ExperimentQuantifyColonies" <> $SessionUUID, "new selected colony4 for ExperimentQuantifyColonies" <> $SessionUUID}
			];
			Download[protocol, PopulationIdentities],
			{{ObjectP[Model[Cell, Bacteria, "new selected colony3 for ExperimentQuantifyColonies" <> $SessionUUID]], ObjectP[Model[Cell, Bacteria, "new selected colony4 for ExperimentQuantifyColonies" <> $SessionUUID]]}},
			Variables :> {protocol}
		],
		Test["If the two samples have the same imaging parameters after converting to a list, they can be grouped in the same unit operation:",
			protocol = ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 8 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 9 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				ImagingStrategies -> {BrightField, {BrightField}}
			];
			Download[protocol, OutputUnitOperations[BatchedUnitOperations]],
			{{ObjectP[Object[UnitOperation, QuantifyColonies]]}},
			Variables :> {protocol}
		],
		Test["If the two samples have different imaging parameters, they cannot be grouped in the same batched unit operation:",
			protocol = ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 10 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 11 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				ImagingStrategies -> {BrightField, {BrightField, BlueWhiteScreen}}
			];
			Length@Download[protocol, OutputUnitOperations[[1]][BatchedUnitOperations]],
			2,
			Variables :> {protocol}
		],
		Test["The OutputUnitOperations field is populated, and BatchedUnitOperations field is populated:",
			protocol = ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 12 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 13 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 14 for ExperimentQuantifyColonies" <> $SessionUUID]
				}
			];
			Length@Download[protocol, OutputUnitOperations[[1]][BatchedUnitOperations]],
			2,
			Variables :> {protocol}
		],
		Test["A resource for an optical filter is found the in the RequiredObjects of the rcp protocol, if there is BlueWhiteScreen in ImagingStrategies option:",
			protocol = ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				ImagingStrategies -> {BrightField, BlueWhiteScreen}
			];
			MemberQ[Download[protocol, RequiredObjects], ObjectP[Model[Part, OpticalFilter]]],
			True,
			Variables :> {protocol}
		],
		Test["The AbsorbanceFilter field is populated in the OutputUnitOperation if BlueWhiteScreen is specified in ImagingStrategies option:",
			protocol = ExperimentQuantifyColonies[
				{
					Object[Sample, "Solid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 7 for ExperimentQuantifyColonies" <> $SessionUUID]
				},
				ImagingStrategies -> {{BrightField, BlueWhiteScreen}, {BrightField, GreenFluorescence}}
			];
			Download[protocol, OutputUnitOperations[AbsorbanceFilter]],
			{ObjectP[Model[Part, OpticalFilter]]},
			Variables :> {protocol}
		],
		Test["The generated RCP, requires the Magnetic Hazard Safety certification:",
			Module[{protocol,requiredCerts},
				protocol = ExperimentQuantifyColonies[
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID]
				];
				requiredCerts = Download[protocol,RequiredCertifications];
				MemberQ[requiredCerts,ObjectP[Model[Certification, "id:XnlV5jNAkGmM"]]]
			],
			True
		],
		(* ===Additional=== *)
		Example[{Additional, "If Simulation is included in the specified Output, a Simulation is returned:"},
			ExperimentQuantifyColonies[
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the tests for preparing omnitray to still pass even if we're not yet supporting in lab *)
		$QuantifyColoniesPreparedOnly = False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Container, Plate, "Test Low MaxTemperature SingleWell Plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Item, Lid, "Test bacterial plate lid subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test yeast plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test depreciated bacterial model plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test InvalidContainerModels plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test InvalidContainerModels plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate 4 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid bacterial plate 6 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid yeast plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid yeast plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid yeast plate 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 4 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 6 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 7 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 8 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 9 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 10 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 11 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 12 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 13 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 14 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 15 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test fluorescence bacterial plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test Mixed Yeast and Bacterial cell plate for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test liquid plate parentprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test no cell agar plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Vessel, "Test ampoule 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Container, Vessel, "Test cryoVial 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Cell, Bacteria, "Fluorescence Model Cell for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Cell, Yeast, "Yeast Model Cell for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Cell, Bacteria, "new selected colony1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Cell, Bacteria, "new selected colony2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Cell, Bacteria, "new selected colony3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Cell, Bacteria, "new selected colony4 for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Liquid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Liquid Media Yeast cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Yeast cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Bacterial cells Deprecated Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Fluorescence Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Mixed Yeast and Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Test freeze dried e.coli sample model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, "Test e.coli in 50% frozen glycerol sample model for ExperimentQuantifyColonies" <> $SessionUUID],
				Model[Sample, Media, "Test Solid Media for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Yeast cells for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Bacterial cells Deprecated for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Bacterial cells in InvalidContainerModels 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Bacterial cells in InvalidContainerModels 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Mammalian cells for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media only for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Yeast cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Media Yeast cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 7 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 8 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 9 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 10 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 11 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 12 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 13 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 14 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 15 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Fluorescence Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Mixed Yeast and Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Freeze dried sample 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Frozen glycerol sample 1 for ExperimentQuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media No Cell sample 1 for ExperimentQuantifyColonies" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlateModel, allContainers, yeastCellModel, fluorescenceCellModel, mixedCellModel, freezeDriedModel,
				frozenGlycerolModel, liquidMediaBacteriaModel, solidMediaBacteriaModel, liquidMediaYeastModel, solidMediaYeastModel,
				deprecatedBacteriaModel, mammalianModel, fluorescenceSampleModel, testSolidMedia, allPreparedSamples, testCover
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentQuantifyColonies" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				(*Upload a test instrument object*)
				Upload[
					<|
						Type -> Object[Instrument, ColonyHandler],
						Model -> Link[Model[Instrument, ColonyHandler, "QPix 420 HT"], Objects],
						Name -> "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID,
						Site -> Link[$Site]
					|>
				];

				testPlateModel = Upload[<|
					Type -> Model[Container, Plate],
					Name -> "Test Low MaxTemperature SingleWell Plate for ExperimentQuantifyColonies" <> $SessionUUID,
					Replace[Synonyms] -> {"Test Low MaxTemperature SingleWell Plate for ExperimentQuantifyColonies" <> $SessionUUID},
					Opaque -> False,
					SelfStanding -> True,
					Treatment -> NonTreated,
					MinTemperature -> -20 Celsius,
					MaxTemperature -> 30 Celsius,
					MinVolume -> 1 Milliliter,
					MaxVolume -> 50 Milliliter,
					Dimensions -> {128.0 Millimeter, 86 Millimeter, 14 Millimeter},
					CrossSectionalShape -> Rectangle,
					Footprint -> Plate,
					NumberOfWells -> 1,
					Columns -> 1,
					Rows -> 1,
					AspectRatio -> 1,
					Replace[Positions] -> {
						<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.0835 Meter, MaxDepth -> 0.1236 Meter, MaxHeight -> 0.014 Meter|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1", XOffset -> 0.04575 Meter, YOffset -> 0.0202 Meter, ZOffset -> 0.014 Meter, CrossSectionalShape -> Circle, Rotation -> 0|>
					},
					Replace[ContainerMaterials] -> {Polystyrene},
					ImageFile -> Link[Object[EmeraldCloudFile, "id:XnlV5jldXaRz"]],
					Reusable -> False,
					Expires -> False,
					DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
					Replace[CoverTypes] -> {Seal, Place},
					(*Plate*)
					PlateColor -> Clear,
					WellColor -> Clear,
					HorizontalMargin -> 11.2 Millimeter,
					VerticalMargin -> 8.15 Millimeter,
					DepthMargin -> 11.8 Millimeter,
					HorizontalOffset -> 0 Millimeter,
					VerticalOffset -> 0 Millimeter,
					WellBottomThickness -> 0.8 Millimeter,
					VerifiedContainerModel -> True,
					RecommendedFillVolume -> 35000 Microliter,
					WellBottom -> FlatBottom,
					WellDepth -> 14 Millimeter,
					WellDimensions -> {83.5 Millimeter, 123.6 Millimeter},
					FlangeWidth -> 1.8 Millimeter,
					FlangeHeight -> 4.2 Millimeter
				|>];

				allContainers = UploadSample[
					{
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Delta 8 Wash Tray"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
						Model[Container, Vessel, "2mL amber glass ampoule"],
						Model[Container, Vessel, "2mL Cryogenic Vial"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"]
					},
					ConstantArray[{"Work Surface", testBench}, 37],
					Name -> {
						"Test liquid bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test yeast plate for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test depreciated bacterial model plate for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test InvalidContainerModels plate 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test InvalidContainerModels plate 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test mammalian plate for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 3 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 4 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 5 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 6 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 7 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 8 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 9 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 10 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 11 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 12 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 13 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 14 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 15 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test fluorescence bacterial plate for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test Mixed Yeast and Bacterial cell plate for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test bacterial plate subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid plate parentprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid bacterial plate 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid bacterial plate 3 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid bacterial plate 4 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid bacterial plate 5 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid bacterial plate 6 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid yeast plate 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid yeast plate 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test liquid yeast plate 3 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test ampoule 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test cryoVial 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test no cell agar plate 1 for ExperimentQuantifyColonies" <> $SessionUUID
					}
				];

				(* Create yeast cell model *)
				yeastCellModel = UploadYeastCell[
					"Yeast Model Cell for ExperimentQuantifyColonies" <> $SessionUUID,
					CellType -> Yeast,
					CultureAdhesion -> SolidMedia,
					BiosafetyLevel -> "BSL-2",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None}
				];

				(* Create model[Cell] packet with fluorophore *)
				fluorescenceCellModel = UploadBacterialCell[
					"Fluorescence Model Cell for ExperimentQuantifyColonies" <> $SessionUUID,
					CellType -> Bacterial,
					CellLength -> 2 Millimeter,
					CultureAdhesion -> SolidMedia,
					BiosafetyLevel -> "BSL-2",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					FluorescentExcitationWavelength -> {350 Nanometer, 400 Nanometer},
					FluorescentEmissionWavelength -> {400 Nanometer, 450 Nanometer}
				];

				(* Create some sample models *)
				{
					liquidMediaBacteriaModel,
					solidMediaBacteriaModel,
					liquidMediaYeastModel,
					solidMediaYeastModel,
					deprecatedBacteriaModel,
					mammalianModel,
					fluorescenceSampleModel,
					mixedCellModel,
					freezeDriedModel,
					frozenGlycerolModel
				} = UploadSampleModel[
					{
						"Liquid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Yeast cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Yeast cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Bacterial cells Deprecated Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Mammalian cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Fluorescence Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Mixed Yeast and Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test freeze dried e.coli sample model for ExperimentQuantifyColonies" <> $SessionUUID,
						"Test e.coli in 50% frozen glycerol sample model for ExperimentQuantifyColonies" <> $SessionUUID
					},
					Composition -> {
						{{97.5 VolumePercent, Model[Molecule, "Water"]}, {0.005 Gram/Milliliter, Link[Model[Molecule, "Yeast Extract"]]}, {171.116 Millimolar, Link[Model[Molecule, "Sodium Chloride"]]}, {1000000 EmeraldCell/Milliliter, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{97.5 VolumePercent, Model[Molecule, "Water"]}, {0.005 Gram/Milliliter, Link[Model[Molecule, "Yeast Extract"]]}, {171.116 Millimolar, Link[Model[Molecule, "Sodium Chloride"]]}, {1000000 EmeraldCell/Milliliter, yeastCellModel}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, yeastCellModel}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, fluorescenceCellModel}},
						{{90 MassPercent, Model[Molecule, "Agarose"]}, {6 Cell/Milliliter, yeastCellModel}, {4000 Cell/Liter, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{100 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{50 VolumePercent, Model[Molecule, "Nutrient Broth"]}, {50 VolumePercent, Model[Molecule, "Glycerol"]}, {(1000 EmeraldCell)/Milliliter, Model[Cell, Bacteria, "E.coli MG1655"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Join[ConstantArray[Model[StorageCondition, "Ambient Storage"], 8], {Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Deep Freezer"]}],
					State -> {Liquid, Solid, Liquid, Solid, Solid, Liquid, Solid, Solid, Solid, Liquid},
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> {Bacterial, Bacterial, Yeast, Yeast, Bacterial, Mammalian, Bacterial, Yeast, Bacterial, Bacterial},
					CultureAdhesion -> {Suspension, SolidMedia, Suspension, SolidMedia, SolidMedia, Adherent, SolidMedia, SolidMedia, Null, Null},
					Living -> True
				];
				Upload[<|Object -> deprecatedBacteriaModel, Deprecated -> True|>];

				(* Media *)
				testSolidMedia = UploadStockSolution[
					{
						{20 Gram, Model[Sample, "Agar"]},
						{25 Gram, Model[Sample, "LB Broth Miller (Sigma Aldrich)"]},
						{900 Milliliter, Model[Sample, "Milli-Q water"]}
					},
					Model[Sample, "Milli-Q water"],
					1 Liter,
					Name -> "Test Solid Media for ExperimentQuantifyColonies" <> $SessionUUID,
					Type -> Media,
					DefaultStorageCondition -> AmbientStorage,
					Expires -> True
				];
				(* Fix the state *)
				Upload[<|
					Object -> testSolidMedia,
					State -> Solid
				|>];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					{
						liquidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaYeastModel,
						deprecatedBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						mammalianModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel,
						fluorescenceSampleModel,
						mixedCellModel,
						testSolidMedia,
						solidMediaBacteriaModel,
						liquidMediaBacteriaModel,
						liquidMediaBacteriaModel,
						liquidMediaBacteriaModel,
						liquidMediaBacteriaModel,
						liquidMediaBacteriaModel,
						liquidMediaBacteriaModel,
						liquidMediaYeastModel,
						liquidMediaYeastModel,
						liquidMediaYeastModel,
						freezeDriedModel,
						frozenGlycerolModel,
						Model[Sample, "id:9RdZXvKBee1Z"](* Model[Sample, "Agar"] *)
					},
					{"A1", #}& /@ allContainers,
					InitialAmount -> {
						300 Microliter,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						300 Microliter,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						10 Gram,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter,
						100 Milligram,
						1 Milliliter,
						10 Gram
					},
					State -> Join[{Liquid, Solid, Solid, Solid, Solid, Solid, Liquid}, ConstantArray[Solid, 18], ConstantArray[Liquid, 9], {Solid, Solid, Solid}],
					Name -> {
						"Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Yeast cells for ExperimentQuantifyColonies" <> $SessionUUID,
						"Bacterial cells Deprecated for ExperimentQuantifyColonies" <> $SessionUUID,
						"Bacterial cells in InvalidContainerModels 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Bacterial cells in InvalidContainerModels 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Mammalian cells for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 7 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 8 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 9 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 10 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 11 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 12 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 13 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 14 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells 15 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Fluorescence Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Mixed Yeast and Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media only for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media Bacterial cells subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Yeast cells 2 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Liquid Media Yeast cells 3 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Freeze dried sample 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Frozen glycerol sample 1 for ExperimentQuantifyColonies" <> $SessionUUID,
						"Solid Media No Cell sample 1 for ExperimentQuantifyColonies" <> $SessionUUID
					}
				];
				(* For suspension cell samples, upload Media *)
				Map[
					Upload[<|Object -> #, Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]|>]&,
					{
						Object[Sample, "Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Yeast cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
						Object[Sample, "Liquid Media Yeast cells 3 for ExperimentQuantifyColonies" <> $SessionUUID]
					}
				];

				(* Create cover for the subprotocol sample *)
				testCover = UploadSample[Model[Item, Lid, "Universal Clear Lid"], {"Work Surface", testBench}, Name -> "Test bacterial plate lid subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID];
				UploadCover[Object[Container, Plate, "Test bacterial plate subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID], Cover -> testCover];
			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Instrument, ColonyHandler, "Test imaging instrument object for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Container, Plate, "Test Low MaxTemperature SingleWell Plate for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Item, Lid, "Test bacterial plate lid subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test yeast plate for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test depreciated bacterial model plate for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test InvalidContainerModels plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test InvalidContainerModels plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test DestinationContainer for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate 4 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid bacterial plate 6 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid yeast plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid yeast plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid yeast plate 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 4 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 6 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 7 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 8 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 9 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 10 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 11 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 12 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 13 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 14 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 15 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test fluorescence bacterial plate for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test Mixed Yeast and Bacterial cell plate for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test liquid plate parentprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Vessel, "Test ampoule 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Vessel, "Test cryoVial 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test no cell agar plate 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Cell, Bacteria, "Fluorescence Model Cell for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Cell, Yeast, "Yeast Model Cell for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Cell, Bacteria, "new selected colony1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Cell, Bacteria, "new selected colony2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Cell, Bacteria, "new selected colony3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Cell, Bacteria, "new selected colony4 for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Liquid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Liquid Media Yeast cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Yeast cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Bacterial cells Deprecated Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Fluorescence Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Mixed Yeast and Bacterial cells Model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Test freeze dried e.coli sample model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, "Test e.coli in 50% frozen glycerol sample model for ExperimentQuantifyColonies" <> $SessionUUID],
					Model[Sample, Media, "Test Solid Media for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Bacterial cells Deprecated for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Bacterial cells in InvalidContainerModels 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Bacterial cells in InvalidContainerModels 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Mammalian cells for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media only for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells subprotocolinput for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells parentprotocol input for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Media Yeast cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 2 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 3 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 4 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 5 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 6 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 7 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 8 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 9 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 10 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 11 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 12 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 13 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 14 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 15 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Fluorescence Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Mixed Yeast and Bacterial cells for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Freeze dried sample 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Frozen glycerol sample 1 for ExperimentQuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media No Cell sample 1 for ExperimentQuantifyColonies" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentQuantifyColoniesQ*)


DefineTests[ValidExperimentQuantifyColoniesQ,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns a Boolean indicating the validity of a QuantifyColonies experimental setup on a sample:"},
			ValidExperimentQuantifyColoniesQ[
				Object[Sample, "Solid Media Bacterial cells 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a QuantifyColonies experimental setup on a sample:"},
			ValidExperimentQuantifyColoniesQ[
				Object[Sample, "Mammalian cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID]
			],
			False
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a QuantifyColonies experimental setup on multiple samples:"},
			ValidExperimentQuantifyColoniesQ[
				{
					Object[Sample, "Solid Media Bacterial cells 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID]
				}
			],
			True
		],
		(* ===Options=== *)
		Example[{Options, Verbose, "If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentQuantifyColoniesQ[
				Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Verbose -> True
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentQuantifyColoniesQ[
				Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				ImagingStrategies -> BrightField,
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test yeast plate for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Model[Cell, Yeast, "Yeast Model Cell for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Model[Sample, "Solid Media Yeast cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Yeast cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Sample, "Mammalian cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, testPlate2, testPlate3, testPlate4, testPlate5, yeastCellModel, solidMediaBacteriaModel,
				solidMediaYeastModel, mammalianModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				{testPlate1, testPlate2, testPlate3, testPlate4, testPlate5} = UploadSample[
					{
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"]
					},
					ConstantArray[{"Work Surface", testBench}, 5],
					Name -> {
						"Test bacterial plate 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Test yeast plate for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Test mammalian plate for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Test bacterial plate 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Test bacterial plate 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID
					}
				];

				(* Create yeast cell model *)
				yeastCellModel = UploadYeastCell[
					"Yeast Model Cell for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
					CellType -> Yeast,
					CultureAdhesion -> SolidMedia,
					BiosafetyLevel -> "BSL-2",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None}
				];

				(* Create some sample models *)
				{solidMediaBacteriaModel, solidMediaYeastModel, mammalianModel} = UploadSampleModel[
					{
						"Solid Media Bacterial cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Solid Media Yeast cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Mammalian cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID
					},
					Composition -> {
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, yeastCellModel}},
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> {Bacterial, Yeast, Mammalian},
					CultureAdhesion -> {SolidMedia, SolidMedia, Adherent},
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					{
						solidMediaBacteriaModel,
						solidMediaYeastModel,
						mammalianModel,
						solidMediaBacteriaModel,
						solidMediaBacteriaModel
					},
					{
						{"A1", testPlate1},
						{"A1", testPlate2},
						{"A1", testPlate3},
						{"A1", testPlate4},
						{"A1", testPlate5}
					},
					InitialAmount -> {
						10 Gram,
						10 Gram,
						300 Microliter,
						10 Gram,
						10 Gram
					},
					State -> {Solid, Solid, Liquid, Solid, Solid},
					Name -> {
						"Solid Media Bacterial cells 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Solid Media Yeast cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Mammalian cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Solid Media Bacterial cells 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID,
						"Solid Media Bacterial cells 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID
					}
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test yeast plate for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Model[Cell, Yeast, "Yeast Model Cell for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Model[Sample, "Solid Media Yeast cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Yeast cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Sample, "Mammalian cells for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 2 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 3 for ValidExperimentQuantifyColoniesQ" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentQuantifyColoniesPreview*)

DefineTests[ExperimentQuantifyColoniesPreview,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns nothing for sample used in a QuantifyColonies experiment:"},
			ExperimentQuantifyColoniesPreview[
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID]
			],
			Null
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentQuantifyColoniesPreview" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColoniesPreview" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, solidMediaBacteriaModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentQuantifyColoniesPreview" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "Omni Tray Sterile Media Plate"],
					{"Work Surface", testBench},
					Name -> "Test bacterial plate 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID
				];

				(* Create some sample models *)
				solidMediaBacteriaModel = UploadSampleModel[
					"Solid Media Bacterial cells Model for ExperimentQuantifyColoniesPreview" <> $SessionUUID,
					Composition -> {{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> SolidMedia,
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					solidMediaBacteriaModel,
					{"A1", testPlate1},
					InitialAmount -> 10 Gram,
					State -> Solid,
					Name -> "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentQuantifyColoniesPreview" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColoniesPreview" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesPreview" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentQuantifyColoniesOptions*)

DefineTests[ExperimentQuantifyColoniesOptions,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns options for sample used in a QuantifyColonies experiment:"},
			ExperimentQuantifyColoniesOptions[
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID]
			],
			_Grid
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentQuantifyColoniesOptions" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColoniesOptions" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, solidMediaBacteriaModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentQuantifyColoniesOptions" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "Omni Tray Sterile Media Plate"],
					{"Work Surface", testBench},
					Name -> "Test bacterial plate 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID
				];

				(* Create some sample models *)
				solidMediaBacteriaModel = UploadSampleModel[
					"Solid Media Bacterial cells Model for ExperimentQuantifyColoniesOptions" <> $SessionUUID,
					Composition -> {{95 MassPercent, Model[Molecule, "Agarose"]}, {5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> SolidMedia,
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					solidMediaBacteriaModel,
					{"A1", testPlate1},
					InitialAmount -> 10 Gram,
					State -> Solid,
					Name -> "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentQuantifyColoniesOptions" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for ExperimentQuantifyColoniesOptions" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for ExperimentQuantifyColoniesOptions" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*QuantifyColonies*)
(* This is the unit test for the primitive heads *)

DefineTests[QuantifyColonies,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns a robotic cell preparation protocol to run a QuantifyColonies experiment:"},
			ExperimentCellPreparation[
				QuantifyColonies[
					Sample -> Object[Sample, "Solid Media Bacterial cells 1 for QuantifyColonies" <> $SessionUUID]
				]
			],
			ObjectReferenceP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Returns a manual cell preparation protocol to run a QuantifyColonies experiment:"},
			ExperimentCellPreparation[
				QuantifyColonies[
					Sample -> Object[Sample, "Liquid Bacterial cells 1 for QuantifyColonies" <> $SessionUUID]
				]
			],
			ObjectReferenceP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Additional, "Can use Experiment for building the protocol from a set of primitives:"},
			ExperimentCellPreparation[
				{
					LabelSample[
						Label -> "my sample",
						Sample -> Object[Sample, "Solid Media Bacterial cells 1 for QuantifyColonies" <> $SessionUUID]
					],
					IncubateCells[
						Sample -> "my sample",
						Time -> 10 Hour,
						Preparation -> Manual
					],
					QuantifyColonies[
						Sample -> "my sample"
					]
				}
			],
			ObjectP[Object[Notebook, Script]]
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for QuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 for QuantifyColonies" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 for QuantifyColonies" <> $SessionUUID],
				Object[Item, Lid, "Test bacterial cover 1 for QuantifyColonies" <> $SessionUUID],
				Object[Item, Lid, "Test bacterial cover 2 for QuantifyColonies" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model for QuantifyColonies" <> $SessionUUID],
				Model[Sample, "Liquid Bacterial cells Model for QuantifyColonies" <> $SessionUUID],
				Object[Sample, "Solid Media Bacterial cells 1 for QuantifyColonies" <> $SessionUUID],
				Object[Sample, "Liquid Bacterial cells 1 for QuantifyColonies" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				testBench, testPlate1, testPlate2, testCover1, testCover2, solidMediaBacteriaModel, liquidMediaBacteriaModel, allPreparedSamples
			},
			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for QuantifyColonies" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				{testPlate1, testPlate2} = UploadSample[
					{
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test bacterial plate 1 for QuantifyColonies" <> $SessionUUID,
						"Test bacterial plate 2 for QuantifyColonies" <> $SessionUUID
					}
				];

				{testCover1, testCover2} = UploadSample[
					{
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test bacterial cover 1 for QuantifyColonies" <> $SessionUUID,
						"Test bacterial cover 2 for QuantifyColonies" <> $SessionUUID
					}
				];

				(* Create some sample models *)
				{solidMediaBacteriaModel, liquidMediaBacteriaModel} = UploadSampleModel[
					{
						"Solid Media Bacterial cells Model for QuantifyColonies" <> $SessionUUID,
						"Liquid Bacterial cells Model for QuantifyColonies" <> $SessionUUID
					},
					Composition -> {
						{
							{95 MassPercent, Model[Molecule, "Agarose"]},
							{5 MassPercent, Model[Cell, Bacteria, "E.coli MG1655"]}
						},
						{
							{97.5 VolumePercent, Model[Molecule, "Water"]},
							{0.005 Gram/Milliliter, Link[Model[Molecule, "Yeast Extract"]]},
							{171.116 Millimolar, Link[Model[Molecule, "Sodium Chloride"]]},
							{1000000 EmeraldCell/Milliliter, Model[Cell, Bacteria, "E.coli MG1655"]}
						}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> {Solid, Liquid},
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> {SolidMedia, Suspension},
					Living -> True
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					{
						solidMediaBacteriaModel,
						liquidMediaBacteriaModel
					},
					{
						{"A1", testPlate1},
						{"A1", testPlate2}
					},
					InitialAmount -> {10 Gram, 10 Milliliter},
					State -> {Solid, Liquid},
					Name -> {
						"Solid Media Bacterial cells 1 for QuantifyColonies" <> $SessionUUID,
						"Liquid Bacterial cells 1 for QuantifyColonies" <> $SessionUUID
					}
				];
				Upload[<|Object ->allPreparedSamples[[2]], Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]|>];

				(* Upload Cover *)
				UploadCover[{testPlate1, testPlate2}, Cover -> {testCover1, testCover2}]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for QuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 for QuantifyColonies" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 2 for QuantifyColonies" <> $SessionUUID],
					Object[Item, Lid, "Test bacterial cover 1 for QuantifyColonies" <> $SessionUUID],
					Object[Item, Lid, "Test bacterial cover 2 for QuantifyColonies" <> $SessionUUID],
					Model[Sample, "Solid Media Bacterial cells Model for QuantifyColonies" <> $SessionUUID],
					Model[Sample, "Liquid Bacterial cells Model for QuantifyColonies" <> $SessionUUID],
					Object[Sample, "Solid Media Bacterial cells 1 for QuantifyColonies" <> $SessionUUID],
					Object[Sample, "Liquid Bacterial cells 1 for QuantifyColonies" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];
