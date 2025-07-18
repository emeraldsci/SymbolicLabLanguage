(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
 

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentStockSolution*)


(* ::Subsubsection:: *)
(*ExperimentStockSolution*)



DefineTests[
	ExperimentStockSolution,
	{
		Example[{Basic,"Create a protocol for preparation of a stock solution:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"]],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 80
		],
		Example[{Basic,"Prepare multiple stock solutions in the same protocol:"},
			ExperimentStockSolution[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]}],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 120
		],
		Example[{Basic,"Create a protocol for preparing a solution by initially combining components, then filling with solvent to a specified total volume:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				FillToVolumeMethod->Volumetric
			],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 80
		],
		Example[{Basic,"Manually specify the exact series of manipulations that should be executed to create the stock solution. This option should only be used if preparing a non-standard stock solution:"},
			Module[{protocol},
				protocol=ExperimentStockSolution[
					{
						LabelContainer[
							Label->"output container",
							Container->Model[Container, Vessel, "50mL Tube"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"output container",
							Amount->1 Milliliter
						],
						Mix[
							Sample->"output container",
							MixType->Vortex,
							Time->10 Minute
						]
					}
				];

				Download[protocol, StockSolutionModels[[1]][UnitOperations]]
			],
			{
				LabelContainer[
					Label->"output container",
					Container->ObjectP[Model[Container, Vessel, "50mL Tube"]]
				],
				Transfer[
					Source->ObjectP[Model[Sample,"Milli-Q water"]],
					Destination->"output container",
					Amount->1 Milliliter
				],
				Mix[
					Sample->"output container",
					MixType->Vortex,
					Time->10 Minute
				]
			},
			TimeConstraint -> 600
		],
		Example[{Basic,"Use UnitOperations input to manually specify the exact series of manipulations that should be executed to create the stock solution. This input should only be used if preparing a non-standard stock solution:"},
			Module[{protocol},
				protocol=ExperimentStockSolution[
					{
						LabelContainer[
							Label->"output container",
							Container->Model[Container, Vessel, "50mL Tube"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"output container",
							Amount->1 Milliliter
						],
						Mix[
							Sample->"output container",
							MixType->Vortex,
							Time->10 Minute
						]
					}
				];
				Download[protocol, StockSolutionModels[[1]][UnitOperations]]
			],
			{
				LabelContainer[
					Label->"output container",
					Container->ObjectP[Model[Container, Vessel, "50mL Tube"]]
				],
				Transfer[
					Source->ObjectP[Model[Sample,"Milli-Q water"]],
					Destination->"output container",
					Amount->1 Milliliter
				],
				Mix[
					Sample->"output container",
					MixType->Vortex,
					Time->10 Minute
				]
			},
			TimeConstraint -> 600
		],
		Example[{Additional, "If only LabelContainer primitives are supplied, ExperimentStockSolution can output options in CommandCenter:"},
			ExperimentStockSolution[
				{
					LabelContainer[
						Label->"output container",
						Container->Model[Container, Vessel, "50mL Tube"]
					]
				},
				Output -> Options
			],
			{_Rule..},
			Stubs :> {$ECLApplication = CommandCenter},
			Messages :> {Error::InvalidUnitOperationsInput, Error::InvalidInput}
		],
		Example[{Additional, "If only LabelContainer primitives are supplied, ExperimentStockSolution will end prematurely as long as Result is requested as output, even in CommandCenter:"},
			ExperimentStockSolution[
				{
					LabelContainer[
						Label->"output container",
						Container->Model[Container, Vessel, "50mL Tube"]
					]
				},
				Output -> Result
			],
			$Failed,
			Stubs :> {$ECLApplication = CommandCenter},
			Messages :> {Error::InvalidUnitOperationsInput, Error::InvalidInput}
		],
		Example[{Additional,"Specify a stock solution protocol on a model that has UnitOperations in it:"},
			Module[{primitives,stockSolutionModel, protocol},
				primitives={
					LabelContainer[<|Label -> "Resuspended Container $4681", Container -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]|>],
					LabelContainer[<|Label -> "Resuspended Container $4708", Container -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]|>],
					LabelContainer[<|Label -> "Resuspended Container $4709", Container -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]|>],
					LabelContainer[<|Label -> "Resuspended Container $4792", Container -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]|>],
					LabelContainer[<|Label -> "Resuspended Container $4802", Container -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]|>],
					LabelSample[<|Label -> "Solid Sample", Sample -> Model[Sample, "id:lYq9jRxLYLnA"], Amount -> Quantity[10, "Milligrams"]|>],
					Transfer[<|Source -> Model[Sample, "id:8qZ1VWNmdLBD"], Destination -> "Solid Sample", Amount -> Quantity[100, "Microliters"], DispenseMix -> True, DispenseMixType -> Pipette, NumberOfDispenseMixes -> 10, Tips -> Link[Model[Item, Tips, "200 uL tips, non-sterile"]]|>],
					Transfer[<|Source -> {"Solid Sample", "Solid Sample", "Solid Sample", "Solid Sample", "Solid Sample"}, Destination -> {"Resuspended Container $4681", "Resuspended Container $4708", "Resuspended Container $4709","Resuspended Container $4792", "Resuspended Container $4802"}, Amount -> {Quantity[20, "Microliters"], Quantity[20, "Microliters"], Quantity[20, "Microliters"], Quantity[20, "Microliters"], Quantity[20, "Microliters"]}, DispenseMix -> {False, False, False, False, False}, DispenseMixType -> {Null, Null, Null, Null, Null}, NumberOfDispenseMixes -> {Null, Null, Null, Null, Null}, Tips -> {Link[Model[Item, Tips, "200 uL tips, non-sterile"]], Link[Model[Item, Tips, "200 uL tips, non-sterile"]], Link[Model[Item, Tips, "200 uL tips, non-sterile"]], Link[Model[Item, Tips, "200 uL tips, non-sterile"]], Link[Model[Item, Tips, "200 uL tips, non-sterile"]]}|>]
				};

				stockSolutionModel=Block[{Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True},
					UploadStockSolution[
						primitives,
						DefaultStorageCondition -> Freezer,
						Expires -> True,
						ShelfLife -> 6 Month,
						TransportTemperature->4 Celsius,
						VolumeIncrements -> 20 Microliter
					]
				];
				Upload[<|Object -> stockSolutionModel, Name->"Test Stock Solution Model with Primitives "<>$SessionUUID, DeveloperObject -> True|>];
				protocol=Block[{$DeveloperSearch = True, Experiment`Private`$StockSolutionUnitTestSearchName="Test Stock Solution Model with Primitives ", Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=False},
					ExperimentStockSolution[stockSolutionModel]
				];
				TestResources[protocol];
				InternalExperiment`Private`compileStockSolution[protocol];

				{
					MatchQ[Download[protocol, StockSolutionModels[[1]]], ObjectP[stockSolutionModel]],
					MatchQ[Download[protocol, Primitives], {_LabelContainer, _LabelContainer,  _LabelContainer, _LabelContainer, _LabelContainer, _LabelSample, _Transfer, _Transfer, _LabelSample}]
				}
			],
			{
				True,
				True
			},
			TimeConstraint -> 600
		],
		Example[{Additional,"Request a stock solution that is mixed and incubated for 20 minutes, pH-titrated, and then filtered through a 0.22um filter to remove particular matter:"},
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->20 Minute,
				Incubate -> True,
				pH->6,
				Filter->True,
				FilterSize->0.22 Micron,
				Name->"Full Prep of 1M NaCl (example) "<>$SessionUUID
			],
			Object[Protocol,StockSolution,"Full Prep of 1M NaCl (example) "<>$SessionUUID],
			TimeConstraint -> 500
		],
		Example[{Additional,"When using the formula-style overload, a new stock solution model will be generated containing both any specified preparation parameters as well as other defaulted parameters:"},
			protocol = ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				StockSolutionName->"PBS (example) "<>$SessionUUID,
				MixTime->30 Minute,
				Incubate -> True,
				Filter->True
			];
			Download[protocol, StockSolutionModels],
			{ObjectP[Model[Sample,StockSolution,"PBS (example) "<>$SessionUUID]]},
			Variables :> {protocol},
			TimeConstraint -> 600
		],
		Example[{Additional,"Take StockSolutionModel's pHing specifications to populate pHing fields in the protocols:"},
			protocol = ExperimentStockSolution[
				Model[Sample, StockSolution, "id:jLq9jXvoNk9a"]
			];
			Download[protocol, {NominalpHs,MinpHs,MaxpHs,pHingAcids,pHingBases}],
			{{2.}, {1.9}, {2.1}, {ObjectP[Model[Sample, StockSolution, "id:1ZA60vwjbRdw"]]}, {ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA86X"]]}},
			Variables :> {protocol},
			TimeConstraint -> 600
		],
		Example[{Additional,"Prepare multiple samples of the same stock solution model by repeating the model as input:"},
			ExperimentStockSolution[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"1M NaCl (example)"]}],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 600
		],
		Example[{Additional,"Prepare a stock solution by specifying a direct combination of components (rather than filling to a particular volume with solvent):"},
			ExperimentStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 80
		],
		Example[{Additional,"Create a protocol for preparation of a stock solution with a tablet as a component by specifying a whole number count of tablets to include in the mixture:"},
			ExperimentStockSolution[
				{
					{5,Model[Sample,"Aspirin (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				250 Milliliter
			],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 80
		],
		Test["AutoclaveProgram resolves to False if Autoclaving is not specified:",
			Lookup[
				ExperimentStockSolution[
					Model[Sample, StockSolution, "1M NaCl (example)"],
					Output -> Options
				],
				{Autoclave, AutoclaveProgram}
			],
			{False, Null}],
		Test["AutoclaveProgram resolves to Liquid if Autoclaving is specified:",
			Lookup[
				ExperimentStockSolution[
					Model[Sample, StockSolution, "1M NaCl (example)"],
					Autoclave->True,
					Output -> Options
				],
				{Autoclave, AutoclaveProgram}
			],
			{True, Liquid}],
		Test["Autoclave resolves to True if AutoclaveProgram is specified:",
			Lookup[
				ExperimentStockSolution[
					Model[Sample, StockSolution, "1M NaCl (example)"],
					AutoclaveProgram->Universal,
					Output -> Options
				],
				{Autoclave, AutoclaveProgram}
			],
			{True, Universal}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (model input, ID form):"},
			ExperimentStockSolution[{Model[Sample, StockSolution, "id:123456"]}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (model input, name form):"},
			ExperimentStockSolution[{Model[Sample, StockSolution, "Nonexistent object"]}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (formula input, ID form):"},
			ExperimentStockSolution[{{10 Gram, Model[Sample, "Sodium Chloride"]}, {100 Milliliter, Model[Sample, "id:123456"]}}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (formula input, name form):"},
			ExperimentStockSolution[{{10 Gram, Model[Sample, "Sodium Chloride"]}, {100 Milliliter, Model[Sample, "Nonexistent object"]}}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (formula input, ID form):"},
			ExperimentStockSolution[{{10 Gram, Model[Sample, "Sodium Chloride"]}, {100 Milliliter, Model[Sample, "Milli-Q water"]}}, Model[Sample, "id:123456"], 1000 Milliliter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (formula input, name form):"},
			ExperimentStockSolution[{{10 Gram, Model[Sample, "Sodium Chloride"]}, {100 Milliliter, Model[Sample, "Milli-Q water"]}}, Model[Sample, "Nonexistent object"], 1000 Milliliter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Don't trainwreck if you have objects that do not exist (unit operation input):"},
			ExperimentStockSolution[
				{
					LabelContainer[
						Label->"output container",
						Container->Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"id:123456"],
						Destination->"output container",
						Amount->10 Milliliter
					],
					Mix[
						Sample->"output container",
						MixType->Vortex,
						Time->10 Minute
					]
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"ConflictingUnitOperationsOptions","Other preparatory options cannot be specified along with UnitOperation inputs:"},
			ExperimentStockSolution[
				{
					LabelContainer[
						Label->"output container",
						Container->Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"output container",
						Amount->10 Milliliter
					],
					Mix[
						Sample->"output container",
						MixType->Vortex,
						Time->10 Minute
					]
				},
				OrderOfOperations->{FixedReagentAddition, FillToVolume, pHTitration, Incubation}
			],
			$Failed,
			Messages :> {Error::ConflictingUnitOperationsOptions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabelContainerUnitOperationInput","The first UnitOperation of the UnitOperations option must be a LabelContainer UnitOperation, that will be the final ContainerOut of the stock solution, after the preparation is complete:"},
			ExperimentStockSolution[
				{
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->Model[Container, Vessel, "50mL Tube"],
						Amount->2 Milliliter
					]
				}
			],
			$Failed,
			Messages :> {Error::InvalidLabelContainerUnitOperationInput, Error::InvalidInput}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentStockSolution[Link[Model[Sample, StockSolution, "1M NaCl (example)"], Now - 1 Minute]],
			ObjectP[Object[Protocol, StockSolution]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentStockSolution[
				{
					{5,Link[Model[Sample,"Aspirin (tablet)"], Now - 1 Minute]}
				},
				Link[Model[Sample,"Milli-Q water"], Now - 1 Minute],
				305 Milliliter
			],
			ObjectP[Object[Protocol, StockSolution]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "StockSolutionTooManySamples", "If more than 10 samples are specified and we are not in engine, then throw an error:"},
			ExperimentStockSolution[
				ConstantArray[Model[Sample, StockSolution, "1M NaCl (example)"], 15]
			],
			$Failed,
			TimeConstraint -> 300,
			Messages:>{
				Error::StockSolutionTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ContainerOutMaxTemperature", "The ContainerOut specified must have a MaxTemperature over 120 Celsius if Autoclaving is specified:"},
			ExperimentStockSolution[
				Model[Sample, StockSolution, "1M NaCl (example)"],
				Volume -> 25 Milliliter,
				Autoclave -> True,
				ContainerOut->Model[Container, Vessel, "id:bq9LA0dBGGR6"] (*"50mL Tube"*)
			],
			$Failed,
			TimeConstraint -> 300,
			Messages:>{
				Warning::VolumeTooLowForAutoclave,
				Error::InvalidOption,
				Error::ContainerOutMaxTemperature
			}
		],
		Example[{Messages,"ContainerOutTooSmall", "The ContainerOut specified must be less than 3/4 full if autoclaving is specified:"},
			ExperimentStockSolution[
				Model[Sample, StockSolution, "1M NaCl (example)"],
				Volume -> 100 Milliliter,
				Autoclave -> True,
				ContainerOut->Model[Container, Vessel, "id:jLq9jXvA8ewR"]
			],
			$Failed,
			TimeConstraint -> 300,
			Messages:>{
				Error::InvalidOption,
				Error::ContainerOutTooSmall
			}
		],
		Example[{Messages,"ContainerOutCannotBeFound","An error will be shown if a container cannot be found to contain the solution:"},
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1x PBS from 10x stock, pH 7"],
				Volume->20 Liter
			],
			$Failed,
			TimeConstraint->300,
			Messages:>{Error::ContainerOutCannotBeFound,Error::InvalidOption}
		],
		Example[{Messages,"ContainerOutCannotBeFound","An error will be shown if a container cannot be found to contain the solution:"},
			ExperimentStockSolution[
				{Model[Sample,StockSolution,"1x PBS from 10x stock, pH 7"],Model[Sample,StockSolution,"1M NaCl (example)"]},
				Volume->{20 Liter,1 Liter}
			],
			$Failed,
			TimeConstraint->300,
			Messages:>{Error::ContainerOutCannotBeFound,Error::InvalidOption}
		],
		Test["Properly prepare a tablet-formula-overload stock solution where the formula gives a stock solution that already exists:",
			Download[ExperimentStockSolution[
				{
					{5,Model[Sample,"Aspirin (tablet)" <> $SessionUUID]}
				},
				Model[Sample,"Milli-Q water"],
				305 Milliliter
			], StockSolutionModels],
			{ObjectP[Model[Sample, StockSolution, "Aspirin (tablet) in water" <> $SessionUUID]]},
			TimeConstraint -> 80,
			(* need this one to find the existing Dev object model *)
			Stubs :> {
				$DeveloperSearch = True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=False,
				Experiment`Private`$StockSolutionUnitTestSearchName="Aspirin (tablet) in water"
			}
		],
		Example[{Additional,"Matrix and Media solutions may also be prepared by ExperimentStockSolution:"},
			ExperimentStockSolution[{Model[Sample,Media,"Salt Media (example)"],Model[Sample,Matrix,"Salt Matrix (example)"]}],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 300
		],
		Example[{Additional,"The models of the stock solutions being prepared by the protocol are stored in the StockSolutionModels field:"},
			Download[ExperimentStockSolution[{Model[Sample, StockSolution, "1M NaCl"],Model[Sample,StockSolution,"70% Ethanol"]}],StockSolutionModels],
			{ObjectP[Model[Sample, StockSolution, "1M NaCl"]],ObjectP[Model[Sample,StockSolution,"70% Ethanol"]]},
			TimeConstraint -> 600
		],
		Example[{Additional,"The stock solution model contains preparatory information specifying how it should be prepared; this information is echoed in the protocol:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Name->"Example Salt Buffer Protocol "<>$SessionUUID];
			{
				Download[Model[Sample,StockSolution,"1M NaCl (example)"],{MixTime,IncubationTemperature,IncubationTime}],
				Lookup[Download[Object[Protocol,StockSolution,"Example Salt Buffer Protocol "<>$SessionUUID],MixParameters[[1]]],{Type, Time, Temperature}]
			},
			{
				{20. Minute,Quantity[45., "DegreesCelsius"], Quantity[20., "Minutes"]},
				{Stir,20. Minute, 45.*Celsius}
			},
			TimeConstraint -> 80
		],
		Example[{Additional,"Preparatory information from the stock solution model may be overridden by specifying options to ExperimentStockSolution:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],MixTime->30 Minute,IncubationTime->30 Minute,Name->"Example Salt Buffer Protocol "<>$SessionUUID];
			{
				Download[Model[Sample,StockSolution,"1M NaCl (example)"],{MixTime,IncubationTemperature,IncubationTime}],
				Lookup[Download[Object[Protocol,StockSolution,"Example Salt Buffer Protocol "<>$SessionUUID],MixParameters[[1]]],{Type,Time, Temperature}]
			},
			{
				{RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]],RangeP[Quantity[45, "DegreesCelsius"], Quantity[45, "DegreesCelsius"]], RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]]},
				{Stir,RangeP[Quantity[30, "Minutes"], Quantity[30, "Minutes"]],RangeP[Quantity[45, "DegreesCelsius"], Quantity[45, "DegreesCelsius"]]}
			},
			TimeConstraint -> 80
		],
		Example[{Additional,"Each stock solution model corresponds to a specific set of preparation information. If a preparatory option differs from the provided stock solution's information, a new stock solution model will be generated to track the different preparation:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],pH->7,Name->"Example Salt Buffer Protocol with pHing "<>$SessionUUID];
			{
				Download[Model[Sample,StockSolution,"1M NaCl (example)"],Object],
				Download[Object[Protocol,StockSolution,"Example Salt Buffer Protocol with pHing "<>$SessionUUID],StockSolutionModels]
			},
			{
				ObjectP[Model[Sample,StockSolution,"1M NaCl (example)"]],
				{ObjectP[Model[Sample,StockSolution]]}
			},
			TimeConstraint -> 80
		],
		(* Note: in this test, we're specifying 115 mL of stock solution because that would default to a 150mL container without Autoclave, but needs *)
		(* to go up in size for an autoclaved solution *)
		Example[{Additional},"If Autoclave -> True, the maximum volume of both PreparatoryContainers and ContainersOut exceeds 4/3 the total volume of the stock solution:",
			protocol = ExperimentStockSolution[
				Model[Sample, StockSolution, "1M NaCl (example)"],
				Volume -> 115 * Milliliter,
				Autoclave -> True
			];
			Download[protocol, {ContainersOut[MaxVolume], PreparatoryContainers[MaxVolume]}],
			{{GreaterP[115*4/3*Microliter]}, {GreaterP[115*4/3*Microliter]}},
			Variables :> {protocol}
		],
		Example[{Additional, "Can specify a specific sample in the formula overload and populate SamplesIn:"},
			(
				ExperimentStockSolution[{{ 100*Microliter,Object[Sample, "Example water for ExperimentStockSolution unit tests"]}, { 50*Milliliter,Model[Sample,"Acetonitrile, Biosynthesis Grade"]}}, Name -> "Example StockSolution Protocol with one Sample "<>$SessionUUID];
				Download[Object[Protocol, StockSolution, "Example StockSolution Protocol with one Sample "<>$SessionUUID], SamplesIn]
			),
			{ObjectP[Object[Sample, "Example water for ExperimentStockSolution unit tests"]], ObjectP[Model[Sample,"Acetonitrile, Biosynthesis Grade"]]},
			TimeConstraint -> 80
		],
		Test["Can specify multiple samples in the formula overload and populate SamplesIn:",
			(
				ExperimentStockSolution[{{ 100*Microliter,Object[Sample, "Example water for ExperimentStockSolution unit tests"]}, { 100*Microliter,Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]}, { 50*Milliliter,Model[Sample,"Acetonitrile, Biosynthesis Grade"]}}, Name -> "Example StockSolution Protocol with two Samples "<>$SessionUUID];
				Download[Object[Protocol, StockSolution, "Example StockSolution Protocol with two Samples "<>$SessionUUID], SamplesIn]
			),
			{ObjectP[Object[Sample, "Example water for ExperimentStockSolution unit tests"]], ObjectP[Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]], ObjectP[Model[Sample,"Acetonitrile, Biosynthesis Grade"]]},
			TimeConstraint -> 80
		],
		Test["Properly populate SamplesIn if the solvent is the same model as the sample provided in SamplesIn:",
			Download[
				ExperimentStockSolution[
					{
						{ 100*Microliter,Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]}
					},
					Model[Sample, "Acetone, Reagent Grade"],
					100*Milliliter
				],
				SamplesIn
			],
			{ObjectP[Object[Sample]], ObjectP[Model[Sample]]}
		],
		Test["Can specify multiple formulas with samples and populate SamplesIn:",
			(
				ExperimentStockSolution[
					{
						{
							{ 100 * Microliter,Object[Sample, "Example water for ExperimentStockSolution unit tests"]},
							{ 50 * Milliliter,Model[Sample, "Acetonitrile, Biosynthesis Grade"]}
						},
						{
							{ 100 * Microliter,Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]},
							{ 50 * Milliliter,Model[Sample, "Acetonitrile, Biosynthesis Grade"]}
						}
					},
					Name -> "Example StockSolution Protocol with Two Stock Solutions "<>$SessionUUID
				];
				Download[Object[Protocol, StockSolution, "Example StockSolution Protocol with Two Stock Solutions "<>$SessionUUID], SamplesIn]
			),
			{ObjectP[Object[Sample, "Example water for ExperimentStockSolution unit tests"]], ObjectP[Model[Sample,"Acetonitrile, Biosynthesis Grade"]], ObjectP[Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]], ObjectP[Model[Sample,"Acetonitrile, Biosynthesis Grade"]]}
		],
		Test["Can specify multiple formulas with formula-only options listably:",
			(
				ExperimentStockSolution[
					{
						{
							{ 100 * Microliter,Object[Sample, "Example water for ExperimentStockSolution unit tests"]},
							{ 50 * Milliliter,Model[Sample, "Acetonitrile, Biosynthesis Grade"]}
						},
						{
							{ 100 * Microliter,Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]},
							{ 50 * Milliliter,Model[Sample, "Acetonitrile, Biosynthesis Grade"]}
						}
					},
					Name -> "Example StockSolution Protocol with Two Stock Solutions and Formula-Only Options "<>$SessionUUID,
					Flammable -> {True, False},
					LightSensitive -> {False, True},
					Density -> {1*Gram/Milliliter, 1.3*Gram/Milliliter},
					Ventilated -> True,
					Acid -> False
				];
				Download[
					Object[Protocol, StockSolution, "Example StockSolution Protocol with Two Stock Solutions and Formula-Only Options "<>$SessionUUID],
					StockSolutionModels[{Flammable, LightSensitive, Density, Ventilated, Acid}]
				]
			),
			{
				{True, Null, RangeP[1*Gram/Milliliter, 1*Gram/Milliliter], True, Null},
				{Null, True, RangeP[1.3*Gram/Milliliter, 1.3*Gram/Milliliter], True, Null}
			}
		],
		Test["Can't specify multiple samples in the formula overload if they are duplicates:",
			ExperimentStockSolution[{{ 100*Microliter,Object[Sample, "Example water for ExperimentStockSolution unit tests"]}, { 100*Microliter,Object[Sample, "Example acetone for ExperimentStockSolution unit tests"]}, { 50*Milliliter,Model[Sample,"Milli-Q water"]}}],
			$Failed,
			Messages :> {
				Error::DuplicatedComponents,
				Error::InvalidInput
			},
			TimeConstraint -> 80
		],
		Test["Populate SamplesIn with the components even if given the model overload:",
			Download[ExperimentStockSolution[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]}], SamplesIn],
			{ObjectP[Model[Sample, "Sodium Chloride"]], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Methanol"]]},
			TimeConstraint -> 600
		],
		Test["Can specify a specific sample in the formula overload and populate SamplesIn if we are doing a FillToVolume:",
			(
				ExperimentStockSolution[{{ 100*Microliter,Object[Sample, "Example water for ExperimentStockSolution unit tests"]}}, Model[Sample,"Acetonitrile, Biosynthesis Grade"], 50*Milliliter, Name -> "Example FillToVolume StockSolution Protocol with one Sample "<>$SessionUUID];
				Download[Object[Protocol, StockSolution, "Example FillToVolume StockSolution Protocol with one Sample "<>$SessionUUID], SamplesIn]
			),
			{ObjectP[Object[Sample, "Example water for ExperimentStockSolution unit tests"]], ObjectP[Model[Sample,"Acetonitrile, Biosynthesis Grade"]]},
			TimeConstraint -> 80
		],
		(* Fill-to-Volume method to prepare an acid stock solution will alter the formula to add some of the fill-to-volume solvent before adding the acid, and filling to the requested volume after. A warning message is thrown for safety override. *)
		Test["Populate SamplesIn properly if using an acid. For a fill-to-volume stock solution using an acid, the formula is altered to add some of the fill-to-volume solvent before adding the acid, and filling to the requested volume after for safety purpose:",
			(
				ExperimentStockSolution[{{ 100*Microliter,Model[Sample, "Nitric Acid 70%"]}}, Model[Sample,"Milli-Q water"], 50*Milliliter, Name -> "Example FillToVolume StockSolution Protocol with Acid "<>$SessionUUID];
				Download[Object[Protocol, StockSolution, "Example FillToVolume StockSolution Protocol with Acid "<>$SessionUUID], SamplesIn]
			),
			{ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Nitric Acid 70%"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages:>{Warning::ComponentOrder},
			TimeConstraint -> 80
		],
		Example[{Additional,"Options that can be specified as lists must have the same lengths as the stock solution model inputs:"},
			ExperimentStockSolution[
				{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
				Volume->{500 Milliliter,675 Milliliter,900 Milliliter}
			],
			$Failed,
			Messages:>Error::InputLengthMismatch,
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","Formula components must be unique:"},
			ExperimentStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				}
			],
			$Failed,
			Messages:>{Error::DuplicatedComponents,Error::InvalidInput},
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","Formula components cannot be deprecated:"},
			ExperimentStockSolution[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter
			],
			$Failed,
			Messages:>{Error::DeprecatedComponents,Error::InvalidInput},
			TimeConstraint -> 300
		],
		Example[{Additional,"Formula Issues","If no solvent is explicitly provided, the mixture of all solids will be a new stock solution with State -> Solid:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				}
			],
			ObjectP[Object[Protocol, StockSolution]],
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","If no solvent is explicitly provided, the mixture of all solids will be a new stock solution with State -> Solid:"},
			prot = ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				}
			];
			Download[prot, StockSolutionModels[State]],
			{Solid},
			Variables :> {prot},
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","The solvent must be a liquid if explicitly provided:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter
			],
			$Failed,
			Messages:>{Error::SolventNotLiquid,Error::InvalidInput},
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","Only solids and liquids are supported as formula components:"},
			ExperimentStockSolution[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::ComponentStateInvalid,Error::InvalidInput},
			TimeConstraint -> 80
		],
		Example[{Additional,"Specify liquid components transferred by mass:"},
			ExperimentStockSolution[
				{
					{100 Milliliter,Model[Sample,"Sodium Chloride"]},
					{80 Gram,Model[Sample,"Milli-Q water"]}
				}
			],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","Tablet components must be specified in amounts that are tablet counts, not masses:"},
			ExperimentStockSolution[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::ComponentRequiresTabletCount,Error::InvalidInput},
			TimeConstraint -> 80
		],
		Example[{Additional,"Formula Issues","The sum of the volumes of any formula components should not exceed the requested total volume of the solution:"},
			ExperimentStockSolution[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter
			],
			$Failed,
			Messages:>{Error::FormulaVolumeTooLarge,Error::InvalidOption, Error::InvalidInput},
			TimeConstraint -> 80
		],
		Example[{Options,Autoclave,"Use Autoclave option to indicate if the stock solution should be autoclaved:"},
			Lookup[
				ExperimentStockSolution[
					Model[Sample, StockSolution, "1M NaCl (example)"],
					Autoclave->True,
					Output -> Options
				],
				Autoclave
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,AutoclaveProgram,"Use AutoclaveProgram option to specify the autoclave program:"},
			Lookup[
				ExperimentStockSolution[
					Model[Sample, StockSolution, "1M NaCl (example)"],
					AutoclaveProgram->Universal,
					Output -> Options
				],
				AutoclaveProgram
			],
			Universal
		],
		Example[{Options, OrderOfOperations, "Indicate the order in which the stock solution should be prepared:"},
			Download[
				ExperimentStockSolution[
					{
						{300 Milliliter,Model[Sample,"Methanol"]},
						{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
					},
					Model[Sample,"Milli-Q water"],
					1000 Milliliter,
					Incubate->True,
					pH->7,
					OrderOfOperations->{FixedReagentAddition, pHTitration, FillToVolume, Incubation}
				],
				StockSolutionModels[[1]][OrderOfOperations]
			],
			{FixedReagentAddition, pHTitration, FillToVolume, Incubation}
		],
		Example[{Options, OrderOfOperations, "The order of operations is resolved based on the requirements set for the stock solution:"},
			Download[
				ExperimentStockSolution[
					{
						{300 Milliliter,Model[Sample,"Methanol"]},
						{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
					},
					Model[Sample,"Milli-Q water"],
					1000 Milliliter,
					Incubate->True,
					pH->7,
					Filter->True
				],
				StockSolutionModels[[1]][OrderOfOperations]
			],
			{FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}
		],
		Test["The OrderOfOperations Option resolves correctly (all stages turned on):",
			Lookup[
				ExperimentStockSolution[{{300 Milliliter,
					Model[Sample, "Methanol"]}, {250 Milliliter,
					Model[Sample, StockSolution, "70% Ethanol"]}},
					Model[Sample, "Milli-Q water"], 1000 Milliliter,
					Incubate -> True, pH -> 7, Filter -> True, Output -> Options],
				OrderOfOperations
			],
			{FixedReagentAddition,FillToVolume,pHTitration,Incubation,Filtration}
		],
		Test["The OrderOfOperations Option resolves correctly (all stages turned on except for FTV):",
			Lookup[
				ExperimentStockSolution[{{300 Milliliter,
					Model[Sample, "Methanol"]}, {250 Milliliter,
					Model[Sample, StockSolution, "70% Ethanol"]}}, Incubate -> True,
					pH -> 7, Filter -> True, Output -> Options],
				OrderOfOperations
			],
			{FixedReagentAddition,pHTitration,Incubation,Filtration}
		],
		Test["The OrderOfOperations Option resolves correctly (all stages turned on except for FTV and Filtration):",
			Lookup[
				ExperimentStockSolution[{{300 Milliliter,
					Model[Sample, "Methanol"]}, {250 Milliliter,
					Model[Sample, StockSolution, "70% Ethanol"]}}, Incubate -> True,
					pH -> 7, Output -> Options],
				OrderOfOperations
			],
			{FixedReagentAddition,pHTitration,Incubation}
		],
		Test["The OrderOfOperations Option resolves correctly (all stages turned on except for FTV and Filtration and pH):",
			Lookup[
				ExperimentStockSolution[{{300 Milliliter,
					Model[Sample, "Methanol"]}, {250 Milliliter,
					Model[Sample, StockSolution, "70% Ethanol"]}}, Incubate -> True, Output -> Options],
				OrderOfOperations
			],
			{FixedReagentAddition, Incubation}
		],
		Test["The OrderOfOperations Option resolves correctly (all stages turned off):",
			Lookup[
				ExperimentStockSolution[{{300 Milliliter,
					Model[Sample, "Methanol"]}, {250 Milliliter,
					Model[Sample, StockSolution, "70% Ethanol"]}}, Output -> Options],
				OrderOfOperations
			],
			{FixedReagentAddition, Incubation}
		],
		Test["The OrderOfOperations Option resolves correctly (manually specified):",
			Lookup[
				ExperimentStockSolution[{{300 Milliliter,
					Model[Sample, "Methanol"]}, {250 Milliliter,
					Model[Sample, StockSolution, "70% Ethanol"]}},
					Model[Sample, "Milli-Q water"], 1000 Milliliter,
					Incubate -> True, pH -> 7, Filter -> True,
					OrderOfOperations->{FixedReagentAddition, pHTitration, FillToVolume, Incubation, Filtration}, Output -> Options],
				OrderOfOperations
			],
			ListableP[{FixedReagentAddition, pHTitration, FillToVolume, Incubation, Filtration}]
		],
		Example[{Messages, "InvalidOrderOfOperations", "Fixed reagent addition must always occur first and filtration must always occur last:"},
			ExperimentStockSolution[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				1000 Milliliter,
				Incubate->True,
				pH->7,
				Filter->True,
				OrderOfOperations->{FixedReagentAddition, Filtration, Incubation, FillToVolume, pHTitration}
			],
			$Failed,
			Messages:>{
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidOrderOfOperations", "Fixed reagent addition must always occur first and incubation must be after FillToVolume and/or pHTitration must always occur last:"},
			ExperimentStockSolution[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				1000 Milliliter,
				Incubate->True,
				pH->7,
				Filter->True,
				OrderOfOperations->{FixedReagentAddition, FillToVolume, Incubation, pHTitration, Filtration}
			],
			$Failed,
			Messages:>{
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Options, SafetyOverride, "If the order of the components are such that liquid acids are added before other liquid components and the solution is safe to create, specify a safety override:"},
			Download[
				ExperimentStockSolution[
					{
						{0.001 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
						{10 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					SafetyOverride->True
				],
				StockSolutionModels[Formula]
			][[1]],
			{
				{RangeP[0.0005 Milliliter, 0.005 Milliliter],ObjectP[Model[Sample,"Trifluoroacetic acid"]]},
				{RangeP[9 Milliliter, 11 Milliliter] ,ObjectP[Model[Sample,"Milli-Q water"]]}
			},
			Messages :> {
				Warning::ComponentOrder
			}
		],
		Example[{Options,Volume,"Request that a stock solution be prepared in a different volume than its formula calls for; this request will scale the formula amounts accordingly:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->1.5 Liter],RequestedVolumes],
			{1.5 Liter},
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Example[{Options,Volume,"Prepare multiple stock solutions in specific volumes:"},
			Download[ExperimentStockSolution[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},Volume->{1 Liter,675 Milliliter}],RequestedVolumes],
			{1 Liter,675 Milliliter},
			EquivalenceFunction->Equal,
			TimeConstraint -> 600
		],
		Example[{Options,Volume,"If a stock solution is prepared in volumetric flask and has a volume increment, we only select the volumetric flask that matches the increment and larger than the requested volume:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"ExperimentStockSolution test stock solution with tablet formula and volumetric fill-to-volume "<>$SessionUUID],
					Volume->23 Milliliter
				],
				PreparatoryVolumes
			],
			(* it just needs to be a multiple of 10 here; doing it this way instead of hard coding a number because if our volumetric flask stock changes, this number could change *)
			(* needs to be a multiple of 10 Milliliter and less than or equal to 10x of 10 Milliliter*)
			{_?(Round[# / (10 Milliliter)] == # / (10 Milliliter) && # <= 100 Milliliter&)},
			SetUp:>(
				(* turning this one off because a very weird error can be thrown during resource picking steps *)
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
				(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
				Off[General::stop];
				$CreatedObjects={};
				If[DatabaseMemberQ[Model[Sample,StockSolution,"ExperimentStockSolution test stock solution with tablet formula and volumetric fill-to-volume "<>$SessionUUID]],EraseObject[Model[Sample,StockSolution,"ExperimentStockSolution test stock solution with tablet formula and volumetric fill-to-volume "<>$SessionUUID],Force->True]];
				UploadStockSolution[
					{
						{1 Unit, Model[Sample, "Acetaminophen (tablet)"]}
					},
					Model[Sample, "Milli-Q water"],
					10 Milliliter,
					FillToVolumeMethod -> Volumetric,
					Name -> "ExperimentStockSolution test stock solution with tablet formula and volumetric fill-to-volume "<>$SessionUUID
				]
			),
			TimeConstraint -> 600
		],
		Example[{Options,FillToVolumeMethod,"Specify the method by which the volume of the FillToVolume stock solution should be measured when being prepared:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				FillToVolumeMethod->Volumetric
			],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 8020
		],
		Test["If FillToVolumeMethod is Volumteric, NumberOfMixes is derived from the stock solution model rather than a default:",
			Lookup[Download[
				ExperimentStockSolution[Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV"<>$SessionUUID]],
				MixParameters
			],NumberOfMixes],
			{10},
			TimeConstraint -> 80
		],
		Test["If FillToVolumeMethod is Volumteric, NumberOfMixes is derived from the option rather than a default or from the model:",
			Lookup[Download[
				ExperimentStockSolution[Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV"<>$SessionUUID],
					NumberOfMixes->15
				],
				MixParameters
			],NumberOfMixes],
			{15},
			TimeConstraint -> 80
		],
		Example[{Options,Volume,"If too much precision is provided for the Volume option, round to the nearest 0.1*Milliliter:"},
			Lookup[ExperimentStockSolution[{Model[Sample,StockSolution,"1M NaCl (example)"]},Volume->6.333333323*Milliliter, Output -> Options], Volume],
			6.33333*Milliliter,
			EquivalenceFunction->Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			TimeConstraint -> 8020
		],
		Example[{Messages,"BelowpHMinimum","Certain preparation steps require a minimum volume; requesting a volume below these thresholds produces an error:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->5 Milliliter,pH->6.5],
			$Failed,
			Messages:>{Error::BelowpHMinimum,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Messages,"VolumeOptionUnused","The Volume option is unused if it differs from the provided total volume of solvent for a fill-to-volume style solution:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Volume->2 Liter
				],
				RequestedVolumes
			],
			{1. Liter},
			EquivalenceFunction->Equal,
			Messages:>{Warning::VolumeOptionUnused},
			TimeConstraint -> 80
		],
		Example[{Options,ContainerOut,"Provide a specific container model in which the requested solution should reside:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],ContainerOut->Model[Container,Vessel,"2L Glass Bottle"]],ContainersOut[[1]][Name]],
			"2L Glass Bottle",
			TimeConstraint -> 80
		],
		Example[{Options,ContainerOut,"Request different final containers for different solutions being prepared:"},
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Volume->{2 Liter,1 Liter},
					ContainerOut->{Automatic,Model[Container,Vessel,"Amber Glass Bottle 4 L"]}
				],
				ContainersOut[Name]
			],
			{"2L Glass Bottle","Amber Glass Bottle 4 L"},
			TimeConstraint -> 600
		],
		Example[{Options,ContainerOut,"If a stock solution is marked as light-sensitive, by default an opaque container will be selected:"},
			Download[
				ExperimentStockSolution[
					{
						{200 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					500 Milliliter,
					LightSensitive->True
				],
				ContainersOut[[1]][Name]
			],
			"500mL Amber Glass Bottle",
			TimeConstraint -> 80
		],
		Example[{Options,ContainerOut,"If a specific solution Volume is specified, the ContainerOut will be selected using the PreferredContainer function for that volume:"},
			{
				Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->1 Liter,ContainerOut->Automatic],ContainersOut[[1]]],
				PreferredContainer[1 Liter,Type->Vessel]
			},
			{
				ObjectP[Model[Container,Vessel,"1L Glass Bottle"]],
				ObjectP[Model[Container,Vessel,"1L Glass Bottle"]]
			},
			TimeConstraint -> 80
		],
		Example[{Options,ContainerOut,"If a specific solution Volume is specified, the ContainerOut will be selected using the PreferredContainer function for that volume, with IncompatibleMaterials information considered:"},
			{
				Download[
					ExperimentStockSolution[
						{
							{50 Milligram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						1 Liter,
						IncompatibleMaterials -> {Glass}
					],
					ContainersOut[[1]]
				],
				PreferredContainer[1 Liter,Type->Vessel, IncompatibleMaterials->{Glass}]
			},
			{
				(* "Corning Reusable Plastic Reagent Bottles with GL-45 PP Screw Cap, 2L" *)
				ObjectP[Model[Container, Vessel, "id:mnk9jOkn6oMZ"]],
				ObjectP[Model[Container, Vessel, "id:mnk9jOkn6oMZ"]]
			},
			TimeConstraint -> 80
		],
		Example[{Options,ContainerOut,"If filtering and ContainerOut is not specified, ContainerOut still automatically set to the PreferredContainer (do not get too cute and resolve to the FiltrateContainerOut of ExperimentFilter):"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"], Volume -> 500 Milliliter, FilterModel -> Model[Container, Vessel, Filter, "BottleTop Filter, Cellulose, 0.22um, 500mL"]], ContainersOut[[1]]],
			ObjectP[Model[Container, Vessel, "500mL Glass Bottle"]],
			TimeConstraint -> 600
		],
		Example[{Options,ContainerOut,"All stock solution preparation steps must occur in an ECL-standard vessel that is compatible with all volume measurement, mixing, incubating, pH-titrating, and filtration methods; as a result, if a ContainerOut that is non-standard is requested, the solution will first be prepared in an ECL-standard vessel, and then aliquoted to the final container:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Mix->True,
					Incubate->True,
					pH->7,
					Filter->True,
					ContainerOut->Model[Container,Vessel,"1000mL Erlenmeyer Flask"]
				],
				{PreparatoryContainers[Name],ContainersOut[Name]}
			],
			{{"2L Glass Bottle"},{"1000mL Erlenmeyer Flask"}},
			TimeConstraint -> 500
		],
		Example[{Messages,"IncompatibleStockSolutionContainerOut","The ContainerOut should not incompatible with the stock solution model:"},
			ExperimentStockSolution[
				{
					{50 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				IncompatibleMaterials -> {Glass},
				ContainerOut->Model[Container, Vessel, "2L Glass Bottle"]
			],
			$Failed,
			Messages:>{Error::IncompatibleStockSolutionContainerOut,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Messages,"DeprecatedContainerOut","The ContainerOut should not be deprecated:"},
			ExperimentStockSolution[
				{
					{50 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				46 Milliliter,
				ContainerOut->Model[Container,Vessel,"Deprecated Legacy 46mL Tube"]
			],
			$Failed,
			Messages:>{Error::DeprecatedContainerOut,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Messages,"ContainerOutTooSmall","The ContainerOut should be able to hold the requested volume of stock solution:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->2 Liter,ContainerOut->Model[Container,Vessel,"1L Glass Bottle"]],
			$Failed,
			Messages:>{Error::ContainerOutTooSmall,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Mix,"Indicate if the stock solution should be mixed following component combination and filling to volume with solvent; default mixing parameters are drawn from the model:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						Mix->True
					],
					MixParameters[[1]]
				],
				{Type,Time,Rate}
			],
			{Stir,RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]],RPMP},
			TimeConstraint -> 80
		],
		Example[{Options,Mix,"Indicate if the stock solution should NOT be mixed following component combination (but still incubated); in this case, a new stock solution model is created since the provided model includes mixing AND incubating information.  Note that MixedSolutions include incubated solutions as well:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Mix->False,
					IncubationTemperature -> 40*Celsius
				],
				{MixedSolutions,MixParameters[[All, ThawTemperature]]}
			],
			{
				{Except[ObjectP[Model[Sample,StockSolution,"1M NaCl (example)"]], ObjectP[Model[Sample, StockSolution]]]},
				{Null}
			},
			TimeConstraint -> 80
		],
		Example[{Options,Mix,"Request that one solution be mixed and one not be; only the mixed and/or incubated solution will have an entry in the MixParameters field:"},
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Mix->{True,False}
				],
				{StockSolutionModels,MixedSolutions,MixParameters}
			],
			{
				{ObjectP[],ObjectP[]},
				{ObjectP[]},
				{
					<|
						Type->Stir,
						MixUntilDissolved->False,
						Mixer->ObjectP[Model[Instrument,OverheadStirrer]],
						Time->20. Minute,
						MaxTime->Null,
						Rate->UnitsP[RPM],
						NumberOfMixes->Null,
						MaxNumberOfMixes->Null,
						PipettingVolume->Null,
						Temperature -> 45.*Celsius,
						AnnealingTime -> 0.*Minute,
						ThawInstrument -> Null,
						ThawTemperature -> Null,
						ThawTime -> Null
					|>
				}
			},
			TimeConstraint -> 80
		],
		Example[{Options,Mix,"Setting Mix to False but specifying mixing parameters results in an error:"},
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Mix->False,
				MixTime->5 Minute
			],
			$Failed,
			Messages:>{Error::MixOptionConflict,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,MixType,"Set the style of motion that should be used to mix the stock solution following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{25 Milliliter,Model[Sample,"Milli-Q water"]},
							{25 Milliliter,Model[Sample,"Methanol"]}
						},
						MixType->Vortex
					],
					MixParameters[[1]]
				],
				Type
			],
			Vortex,
			TimeConstraint -> 80
		],
		Test["If MixType is specified in the formula overload, populate it in the new stock solution model:",
			Download[
				ExperimentStockSolution[
					{
						{25 Milliliter,Model[Sample,"Milli-Q water"]},
						{23 Milliliter,Model[Sample,"Methanol"]}
					},
					MixType->Vortex
				],
				StockSolutionModels[[1]][MixType]
			],
			Vortex,
			TimeConstraint -> 80
		],
		Test["If MixType is populated in the model, this is adopted in the Experiment function if it works with the volume:",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample, StockSolution, "NaCl solution with MixType populated"], Volume -> 100*Milliliter],
					MixParameters[[1]]],
				Type
			],
			Stir,
			TimeConstraint -> 80
		],
		(* don't want to delete this test because it's good to have, but recently we changed things so that we _can_ use the stirrer at 5 mL, and so I don't have a good example for this happening anymore.  ExperimentStockSolution _is_ still doing this logic and I want to keep it, but don't have a passing example anymore.  So for now just commenting this out I guess *)
		(*Test["If MixType is populated in the model, don't adopt it in the experiment if it can't be used (i.e., we can't use our Stirrer at 5 mL, so just switch silently to something else):",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample, StockSolution, "NaCl solution with MixType populated"], Volume -> 5*Milliliter],
					MixParameters[[1]]
				],
				Type
			],
			Vortex,
			TimeConstraint -> 80
		],*)
		Test["If Mixer is populated in the model, this is adopted in the Experiment function if it works with the volume:",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample,StockSolution,"NaCl solution with MixType and Mixer populated"], Volume -> 100*Milliliter],
					MixParameters[[1]]],
				Mixer
			],
			ObjectP[Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]],
			TimeConstraint -> 80
		],
		(* don't want to delete this test because it's good to have, but recently we changed things so that we _can_ use the stirrer at 5 mL, and so I don't have a good example for this happening anymore.  ExperimentStockSolution _is_ still doing this logic and I want to keep it, but don't have a passing example anymore.  So for now just commenting this out I guess *)
		(*Test["If Mixer is populated in the model, don't adopt it in the experiment if it can't be used (i.e., we can't use our Stirrer at 5 mL, so just switch silently to something else):",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample,StockSolution,"NaCl solution with MixType and Mixer populated"], Volume -> 5*Milliliter],
					MixParameters[[1]]
				],
				Mixer
			],
			Except[ObjectP[Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]], ObjectP[Model[Instrument]]],
			TimeConstraint -> 80
		],*)
		Test["If MixRate is populated in the model, this is adopted in the Experiment function if it works with the volume:",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample,StockSolution,"NaCl solution with MixType and MixRate populated"], Volume -> 100*Milliliter],
					MixParameters[[1]]],
				Rate
			],
			98*RPM,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 80
		],
		(* don't want to delete this test because it's good to have, but recently we changed things so that we _can_ use the stirrer at 5 mL, and so I don't have a good example for this happening anymore.  ExperimentStockSolution _is_ still doing this logic and I want to keep it, but don't have a passing example anymore.  So for now just commenting this out I guess *)
		(*Test["If MixRate is populated in the model, don't adopt it in the experiment if it can't be used (i.e., we can't use our Stirrer at 5 mL, so just switch silently to something else):",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample,StockSolution,"NaCl solution with MixType and MixRate populated"], Volume -> 5*Milliliter],
					MixParameters[[1]]],
				Rate
			],
			GreaterP[1000*RPM],
			TimeConstraint -> 80
		],*)
		Test["If MixType/Mixer/MixRate are all populated in the model, this is adopted in the Experiment function if it works with the volume:",
			Lookup[
				Download[
					ExperimentStockSolution[Model[Sample,StockSolution,"NaCl solution with MixType and Mixer and MixRate populated"], Volume -> 100*Milliliter],
					MixParameters[[1]]],
				{Type, Mixer, Rate}
			],
			{Stir, ObjectP[Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]], RangeP[98*RPM, 98*RPM]},
			TimeConstraint -> 80
		],
		Test["If MixRate is specified in the formula overload without MixType, do NOT populate it in the stock solution model:",
			Download[
				ExperimentStockSolution[
					{
						{25 Milliliter,Model[Sample,"Milli-Q water"]},
						{23 Milliliter,Model[Sample,"Methanol"]}
					},
					MixRate->100*RPM
				],
				StockSolutionModels[[1]][MixRate]
			],
			Null,
			TimeConstraint -> 80
		],
		Example[{Options,MixUntilDissolved,"Indicate if the stock solution should be mixed in an attempt to completed dissolve any solid components following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						MixUntilDissolved->True
					],
					MixParameters[[1]]
				],
				MixUntilDissolved
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,Mixer,"Specify the instrument that should be used to mix the stock solution following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						MixType->Shake,
						Mixer->Model[Instrument, Shaker, "id:mnk9jORRwA7Z"]
					],
					MixParameters[[1]]
				],
				Mixer
			],
			ObjectP[Model[Instrument, Shaker, "Genie Temp-Shaker 300"]],
			TimeConstraint -> 80
		],
		Example[{Options,MixTime,"Set the duration for which the stock solution should be mixed following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{380 Milliliter,Model[Sample,"Milli-Q water"]},
							{620 Milliliter,Model[Sample,"Methanol"]}
						},
						MixTime->15 Minute
					],
					MixParameters[[1]]
				],
				Time
			],
			15. Minute,
			TimeConstraint -> 80
		],
		Example[{Options,MixTime,"Not all mixing types are compatible with a MixTime; here, the NumberOfMixes should have been used to specify the desired amount of mixing by inversion:"},
			ExperimentStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Invert,
				MixTime->15 Minute
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MixTypeIncorrectOptions},
			TimeConstraint -> 80
		],
		Example[{Options,MaxMixTime,"Set a maximum duration for which the stock solution should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{500 Milliliter,Model[Sample,"Milli-Q water"]},
							{500 Milliliter,Model[Sample,"Methanol"]}
						},
						MixUntilDissolved->True,
						MixTime->15 Minute,
						MaxMixTime->30 Minute
					],
					MixParameters[[1]]
				],
				{MixUntilDissolved,Time,MaxTime}
			],
			{True,15. Minute,30. Minute},
			TimeConstraint -> 80
		],
		Example[{Options,MaxMixTime,"An upper bound on mixing time should only be provided if mixing until dissolution with MixTime specified:"},
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixUntilDissolved->False,
				MixTime->15 Minute,
				MaxMixTime->30 Minute
			],
			$Failed,
			Messages:>{Error::MixUntilDissolvedMaxOptions,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,MaxMixTime,"This maximum will resolve automatically if a mix time to start with is provided:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{500 Milliliter,Model[Sample,"Milli-Q water"]},
							{500 Milliliter,Model[Sample,"Methanol"]}
						},
						MixUntilDissolved->True,
						MixTime->15 Minute
					],
					MixParameters[[1]]
				],
				MaxTime
			],
			300. Minute,
			TimeConstraint -> 80
		],
		Example[{Options,MixRate,"Set the frequency of rotation the mixing instrument should use to mix the stock solution following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{500 Milliliter,Model[Sample,"Milli-Q water"]},
							{500 Milliliter,Model[Sample,"Methanol"]}
						},
						MixType->Stir,
						MixRate->50 RPM
					],
					MixParameters[[1]]
				],
				Rate
			],
			50. RPM,
			TimeConstraint -> 80
		],
		Example[{Options,MixRate,"Not all mixing types are compatible with a MixRate, such as the Pipette mix type:"},
			ExperimentStockSolution[
				{
					{10 Milliliter,Model[Sample,"Milli-Q water"]},
					{10 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Pipette,
				MixRate->100 RPM
			],
			$Failed,
			Messages:>{Error::InvalidOption, Error::MixTypeRateMismatch, Error::MixTypeIncorrectOptions},
			TimeConstraint -> 80
		],
		Example[{Options,NumberOfMixes,"Set the number of times the stock solution should be mixed by inversion or pipetting up and down following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{500 Milliliter,Model[Sample,"Milli-Q water"]},
							{500 Milliliter,Model[Sample,"Methanol"]}
						},
						MixType->Invert,
						NumberOfMixes->20
					],
					MixParameters[[1]]
				],
				NumberOfMixes
			],
			20,
			TimeConstraint -> 80
		],
		Example[{Options,NumberOfMixes,"Not all mixing types are compatible with a NumberOfMixes, such as the Vortex mix type:"},
			ExperimentStockSolution[
				{
					{10 Milliliter,Model[Sample,"Milli-Q water"]},
					{10 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Vortex,
				NumberOfMixes->15
			],
			$Failed,
			Messages:>{Error::InvalidOption, Error::MixTypeNumberOfMixesMismatch, Error::MixTypeIncorrectOptions},
			TimeConstraint -> 80
		],
		Example[{Options,MaxNumberOfMixes,"Set the maximum number of times the stock solution should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{500 Milliliter,Model[Sample,"Milli-Q water"]},
							{500 Milliliter,Model[Sample,"Methanol"]}
						},
						MixType->Invert,
						MixUntilDissolved->True,
						NumberOfMixes->6,
						MaxNumberOfMixes->30
					],
					MixParameters[[1]]
				],
				{MixUntilDissolved,NumberOfMixes,MaxNumberOfMixes}
			],
			{True,6,30},
			TimeConstraint -> 80
		],
		Example[{Options,MaxNumberOfMixes,"An upper bound on number of mixes while attempting to dissolve the solution should only be provided if mixing until dissolution with a NumberOfMixes specified:"},
			ExperimentStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Invert,
				MixUntilDissolved->False,
				NumberOfMixes->10,
				MaxNumberOfMixes->30
			],
			$Failed,
			Messages:>{Error::MixUntilDissolvedMaxOptions,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,MaxNumberOfMixes,"This maximum will resolve automatically if a number of mixes to start with is provided:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{500 Milliliter,Model[Sample,"Milli-Q water"]},
							{500 Milliliter,Model[Sample,"Methanol"]}
						},
						MixType->Invert,
						MixUntilDissolved->True,
						NumberOfMixes->10
					],
					MixParameters[[1]]
				],
				MaxNumberOfMixes
			],
			GreaterEqualP[10],
			TimeConstraint -> 80
		],
		Example[{Options,MixPipettingVolume,"If mixing by pipetting, specify the volume of the stock solution that should be pipetted up and down to mix by pipetting following component combination and filling to volume with solvent:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{10 Milliliter,Model[Sample,"Milli-Q water"]},
							{10 Milliliter,Model[Sample,"Methanol"]}
						},
						MixType->Pipette,
						MixPipettingVolume->5 Milliliter
					],
					MixParameters[[1]]
				],
				PipettingVolume
			],
			5. Milliliter,
			TimeConstraint -> 80
		],
		Example[{Options,MixPipettingVolume,"A mix pipetting volume should only be provided for the Pipette mix type:"},
			ExperimentStockSolution[
				{
					{10 Milliliter,Model[Sample,"Milli-Q water"]},
					{10 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Vortex,
				MixPipettingVolume->5 Milliliter
			],
			$Failed,
			Messages:>{Error::MixTypeIncorrectOptions, Error::MixTypeVolume,Error::InvalidOption},
			TimeConstraint -> 80
		],

		(* Incubating *)
		Example[{Options,Incubate,"Indicate if the stock solution should be incubated following component combination and filling to volume with solvent while mixing; default incubation parameters are drawn from the model:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						Incubate->True
					],
					MixParameters[[1]]
				],
				{Temperature, Time, AnnealingTime, ThawInstrument, ThawTemperature, ThawTime}
			],
			{Quantity[45., "DegreesCelsius"], Quantity[20., "Minutes"], Quantity[0., "Minutes"], Null, Null, Null},
			TimeConstraint -> 80
		],
		Example[{Options,Incubate,"Indicate if the stock solution should be incubated following component combination and filling to volume with solvent without mixing; default incubation parameters are drawn from the model:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						Incubate->True,
						IncubationTemperature -> 45*Celsius,
						IncubationTime -> 45*Minute,
						Mix -> False
					],
					MixParameters[[1]]
				],
				{Temperature, Time, AnnealingTime, ThawInstrument, ThawTemperature, ThawTime}
			],
			{RangeP[45*Celsius, 45*Celsius], RangeP[45*Minute, 45*Minute], Null, Null, Null, Null},
			TimeConstraint -> 80
		],
		Test["If Incubating but not mixing, even though Time and Mixer get populated in MixParameters because ExperimentIncubate needs it, they still get resolved properly to Null:",
			Lookup[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Incubate->True,
					IncubationTemperature -> 45*Celsius,
					IncubationTime -> 45*Minute,
					Mix -> False,
					Output -> Options
				],
				{MixTime, Mixer, IncubationTime, Incubator}
			],
			{Null, Null, RangeP[45*Minute, 45*Minute], ObjectP[Model[Instrument, HeatBlock]]},
			TimeConstraint -> 80
		],
		Example[{Options,Incubate,"Indicate if the stock solution should NOT be incubated following component combination; in this case, a new stock solution model is created since the provided model includes incubation information:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Incubate->False,
					Mix -> False
				],
				{MixedSolutions,MixParameters}
			],
			{{},{}},
			TimeConstraint -> 80
		],
		Example[{Options,Incubate,"Request that one solution be incubated and one not be; only the incubated solution will have an entry in the MixParameters field:"},
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Incubate->{True,False},
					Mix -> {True, False}
				],
				{StockSolutionModels,MixedSolutions,MixParameters}
			],
			{
				{ObjectP[],ObjectP[]},
				{ObjectP[]},
				{
					<|
						Type->MixTypeP,
						MixUntilDissolved->False,
						Mixer->ObjectP[Model[Instrument]],
						Time->UnitsP[Minute],
						MaxTime->Null,
						Rate->UnitsP[RPM],
						NumberOfMixes->Null,
						MaxNumberOfMixes->Null,
						PipettingVolume->Null,
						Temperature -> 45.*Celsius,
						AnnealingTime -> 0.*Minute,
						ThawInstrument -> Null,
						ThawTemperature -> Null,
						ThawTime -> Null
					|>
				}
			},
			TimeConstraint -> 80
		],
		Example[{Options,Incubate,"Setting Incubate to False but specifying incubation parameters results in an error:"},
			ExperimentStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubate->False,
				IncubationTime->5 Minute
			],
			$Failed,
			Messages:>{Error::IncubateOptionConflict,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,IncubationTime,"Set the duration for which the stock solution should be incubated following component combination and filling to volume with solvent, while mixing:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{380 Milliliter,Model[Sample,"Milli-Q water"]},
							{620 Milliliter,Model[Sample,"Methanol"]}
						},
						IncubationTime->15 Minute
					],
					MixParameters[[1]]
				],
				Time
			],
			15. Minute,
			TimeConstraint -> 80
		],
		Example[{Options,AnnealingTime,"Set the minimum duration for which the stock solution should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{380 Milliliter,Model[Sample,"Milli-Q water"]},
							{620 Milliliter,Model[Sample,"Methanol"]}
						},
						AnnealingTime->15 Minute
					],
					MixParameters[[1]]
				],
				AnnealingTime
			],
			15. Minute,
			TimeConstraint -> 80
		],
		Example[{Options,IncubationTemperature,"Set the temperature at which the stock solution should be incubated following component combination, filling to volume with solvent while mixing:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{380 Milliliter,Model[Sample,"Milli-Q water"]},
							{620 Milliliter,Model[Sample,"Methanol"]}
						},
						IncubationTemperature->50Celsius
					],
					MixParameters[[1]]
				],
				Temperature
			],
			50. Celsius,
			TimeConstraint -> 80
		],
		Example[{Options,IncubationTemperature,"Set the temperature at which the stock solution should be incubated following component combination, filling to volume with solvent without mixing:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{380 Milliliter,Model[Sample,"Milli-Q water"]},
							{620 Milliliter,Model[Sample,"Methanol"]}
						},
						IncubationTemperature->50Celsius,
						Mix -> False
					],
					MixParameters[[1]]
				],
				Temperature
			],
			50. Celsius,
			TimeConstraint -> 80
		],
		Example[{Options,Incubator,"Not all incubators are compatible with all incubation temperatures:"},
			ExperimentStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubator -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				IncubationTemperature -> 155 Celsius,
				Mix -> False
			],
			$Failed,
			Messages:>{Error::InvalidOption, Error::MixIncompatibleInstrument, Error::MixMaxTemperature},
			TimeConstraint -> 80
		],

		(* pH Titration *)
		Example[{Options, AdjustpH, "Specify whether to adjust the pH of the specified solution:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->7,
					AdjustpH -> True
				],
				NominalpHs
			],
			{7.},
			TimeConstraint -> 80
		],
		Example[{Options,pH,"Specify the pH to which this solution should be adjusted following component combination and mixing:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->7
				],
				NominalpHs
			],
			{7.},
			TimeConstraint -> 80
		],
		Example[{Options,pH,"If pH is not specified but MinpH and MaxpH are, pH is automatically set to the mean between them:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					MinpH->7,
					MaxpH -> 9
				],
				NominalpHs
			],
			{8.},
			TimeConstraint -> 80
		],
		Example[{Options,pH,"The MinpH, MaxpH, pHingAcid and pHingBase can be automatically resolved if a NominalpH is set:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->10
				],
				{NominalpHs[[1]],MinpHs[[1]],MaxpHs[[1]],pHingAcids[[1]][Name],pHingBases[[1]][Name]}
			],
			{10.,9.9,10.1,"2 M HCl","1.85 M NaOH"},
			TimeConstraint -> 80
		],
		Example[{Options,pH,"Request that one solution be pH-titrated and one not be; only the pH-titrated solution will appear in the pHingSamples field and have an associated entry in the NominalpHs target field:"},
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					pH->{8,Null}
				],
				{StockSolutionModels,pHingSamples,NominalpHs}
			],
			{
				{ObjectP[],ObjectP[]},
				{ObjectP[]},
				{8.}
			},
			TimeConstraint -> 600
		],
		Example[{Options,MinpH,"Specify the minimum pH this solution should be allowed to have following component combination and mixing:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					pH->7,
					MinpH->6.5
				],
				MinpHs[[1]]
			],
			6.5,
			TimeConstraint -> 80
		],
		Example[{Options,MinpH,"MinpH will automatically resolve to 0.1 below the pH if that option is specified:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					pH->7
				],
				MinpHs[[1]]
			],
			6.9,
			TimeConstraint -> 80
		],
		Example[{Messages,"NopH","MinpH cannot be specified if AdjustpH is set to False:"},
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MinpH->6.5,
				AdjustpH -> False
			],
			$Failed,
			Messages:>{Error::NopH,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,MaxpH,"Specify the maximum pH this solution should be allowed to have following component combination and mixing:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					pH->7,
					MaxpH->7.5
				],
				MaxpHs[[1]]
			],
			7.5,
			TimeConstraint -> 80
		],
		Example[{Options,MaxpH,"MaxpH will automatically resolve to 0.1 above the pH if that option is specified:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->7
				],
				MaxpHs[[1]]
			],
			7.1,
			TimeConstraint -> 80
		],
		Example[{Options,MaxpH,"MaxpH cannot be specified if AdjustpH is set to False:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MaxpH->7.5,
				AdjustpH -> False
			],
			$Failed,
			Messages:>{Error::NopH,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,pHingAcid,"Specify the solution that should be used to adjust the pH of this solution downwards following component combination and mixing:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->7,
					pHingAcid->Model[Sample,StockSolution,"10% Nitric Acid Solution"]
				],
				pHingAcids[[1]][Name]
			],
			"10% Nitric Acid Solution",
			TimeConstraint -> 80
		],
		Example[{Options,pHingAcid,"The pHingAcid will automatically resolve to 2 M HCl if a pH is specified:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					pH->7
				],
				pHingAcids[[1]][Name]
			],
			"2 M HCl",
			TimeConstraint -> 80
		],
		Example[{Options,pHingAcid,"A pHingAcid cannot be specified if AdjustpH is set to False:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Mix->False,
				pHingAcid->Model[Sample,StockSolution,"6N hydrochloric acid"],
				AdjustpH -> False
			],
			$Failed,
			Messages:>{Error::NopH,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,pHingBase,"Specify the solution that should be used to adjust the pH of this solution upwards following component combination and mixing:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					pH->7,
					pHingBase->Model[Sample,StockSolution,"0.1 M NaOH"]
				],
				pHingBases[[1]][Name]
			],
			"0.1 M NaOH",
			TimeConstraint -> 80
		],
		Example[{Options,pHingBase,"The pHingBase will automatically resolve to 1.85 M NaOH if a pH is specified:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->7
				],
				pHingBases[[1]][Name]
			],
			"1.85 M NaOH",
			TimeConstraint -> 80
		],
		Example[{Options,pHingBase,"A pHingBase cannot be specified if AdjustpH is set to False:"},
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				pHingBase->Model[Sample,StockSolution,"0.1 M NaOH"],
				AdjustpH -> False
			],
			$Failed,
			Messages:>{Error::NopH,Error::InvalidOption},
			TimeConstraint -> 80
		],



		(* Filtration *)
		Example[{Options,Filter,"Indicate if the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration; in this case, the model is not filtered by default, so a new model with default filtration parameters is created:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						Filter->True
					],
					FiltrationParameters[[1]]
				],
				{Type,MembraneMaterial,PoreSize}
			],
			{FiltrationTypeP,FilterMembraneMaterialP,GreaterP[0 Micron]},
			TimeConstraint -> 600
		],
		Example[{Options,Filter,"Indicate if the stock solution should NOT be filtered following component combination, filling to volume with solvent, mixing, and/or pH adjustment; the resulting stock solution model will not have any filtration parameters populated:"},
			Download[
				ExperimentStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Filter->False
				],
				{FiltrationSamples,FiltrationParameters}
			],
			{{},{}},
			TimeConstraint -> 80
		],
		Example[{Options,Filter,"Indicate that one solution should be filtered and another should not; only the filtered solution will appear in the FiltrationSamples field and have an associated entry in the FiltrationParameters field:"},
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Filter->{True,False}
				],
				{StockSolutionModels,FiltrationSamples,FiltrationParameters}
			],
			{
				{ObjectP[],ObjectP[]},
				{ObjectP[]},
				{
					<|
						Type->PeristalticPump,
						Instrument->ObjectP[Model[Instrument,PeristalticPump]],
						Filter->ObjectP[Model[Item,Filter]],
						MembraneMaterial->FilterMembraneMaterialP,
						PoreSize->GreaterP[0 Micron],
						Syringe->Null,
						FilterHousing->ObjectP[Model[Instrument,FilterHousing]]
					|>
				}
			},
			TimeConstraint -> 600
		],
		Example[{Options,Filter,"The total preparation volume of the stock solution must exceed a minimum threshold for filtration to ensure that a method with low enough dead volume is available:"},
			ExperimentStockSolution[
				{
					{2 Milligram,Model[Sample,"Sodium Chloride"]},
					{1.5 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Filter->True
			],
			$Failed,
			Messages:>{Error::VolumeBelowFiltrationMinimum,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Filter,"This option will default to True if preparing a stock solution model that is filtered by default, allowing changing of specific parameters without explicitly setting this option to True:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl, 0.45um filtered (example)"],
						FilterMaterial->Cellulose,
						FilterModel->Model[Item,Filter,"id:lYq9jRxnrKxY"]
					],
					FiltrationParameters[[1]]
				],
				MembraneMaterial
			],
			Cellulose,
			TimeConstraint -> 600
		],
		Example[{Options,FilterType,"Set the style of filtration that should be used to filter the stock solution following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{15 Gram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						1 Liter,
						Filter->True,
						FilterType->PeristalticPump
					],
					FiltrationParameters[[1]]
				],
				Type
			],
			PeristalticPump,
			TimeConstraint -> 600
		],
		Example[{Options,FilterMaterial,"Specify a filter material through which this solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						Filter->True,
						FilterMaterial->PES
					],
					FiltrationParameters[[1]]
				],
				MembraneMaterial
			],
			PES,
			TimeConstraint -> 600
		],
		Example[{Options,FilterSize,"Specify the size of the pores through which this solution should be filtered after component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{15 Gram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						1 Liter,
						Filter->True,
						FilterSize->0.22 Micron
					],
					FiltrationParameters[[1]]
				],
				PoreSize
			],
			0.22 Micron,
			TimeConstraint -> 600
		],
		Example[{Options,FilterInstrument,"Specify a particular peristaltic pump that should be used to push the stock solution through a filter via the PeristalticPump filter type following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{15 Gram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						1 Liter,
						Filter->True,
						FilterType->PeristalticPump,
						FilterInstrument->Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]
					],
					FiltrationParameters[[1]]
				],
				Instrument
			],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			TimeConstraint -> 600
		],
		Example[{Options,FilterModel,"Specify a particular model of filter that should be used to filter the stock solution following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{50 Gram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						4 Liter,
						Filter -> True,
						FilterModel -> Model[Item,Filter,"Membrane Filter, PES, 0.22um, 142mm"]
					],
					FiltrationParameters[[1]]
				],
				Filter
			],
			ObjectP[Model[Item,Filter,"Membrane Filter, PES, 0.22um, 142mm"]],
			TimeConstraint -> 600
		],
		Example[{Options,FilterSyringe,"Specify a particular syringe that should be used to force the stock solution through a filter following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						{
							{2 Gram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						20 Milliliter,
						Filter->True,
						FilterType->Syringe,
						FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]
					],
					FiltrationParameters[[1]]
				],
				Syringe
			],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			TimeConstraint -> 600
		],
		Example[{Options,FilterSyringe,"Don't specify a syringe with which to push the solution through a filter if the FilterType is not PeristalticPump or Syringe:"},
			ExperimentStockSolution[
				{
					{2 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				25 Milliliter,
				Filter->True,
				FilterType->Centrifuge,
				FilterSyringe->Model[Container,Syringe,"50mL All-Plastic Disposable Luer-Slip Syringe"]
			],
			$Failed,
			Messages:>{Error::InvalidOption, Error::FiltrationTypeAndSyringeMismatch, Error::IncorrectSyringeConnection},
			TimeConstraint -> 80
		],
		Example[{Options,FilterSyringe,"Don't specify a syringe with which to push the solution through a filter if total volume of the stock solution exceeds 60mL (the maximum syringe volume):"},
			ExperimentStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Filter->True,
				FilterType->Syringe,
				FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::VolumeTooLargeForSyringe,Error::NoFilterAvailable,Error::FilterMaxVolume},
			TimeConstraint -> 80
		],
		Example[{Options,FilterHousing,"Specify a filter housing that should be used to hold the filter membrane through which the stock solution is filtered following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						Filter->True,
						FilterType->PeristalticPump,
						FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]
					],
					FiltrationParameters[[1]]
				],
				FilterHousing
			],
			ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
			TimeConstraint -> 600
		],


		Example[{Options,StockSolutionName,"Name a new stock solution model when specifying a solution to prepare via the formula overload:"},
			Download[
				ExperimentStockSolution[
					{
						{17 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					StockSolutionName->"Special Salt in Water Mixture "<>$SessionUUID
				],
				StockSolutionModels[[1]][Name]
			],
			"Special Salt in Water Mixture "<>$SessionUUID,
			TimeConstraint -> 80
		],
		Example[{Messages,"FormulaOptionsUnused","This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl"],
					StockSolutionName->"Special Salt in Water Mixture "<>$SessionUUID
				],
				StockSolutionModels[[1]][Name]
			],
			"1M NaCl",
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,StockSolutionName,"If a stock solution Name is already in use in Constellation, a new stock solution cannot also get that Name:"},
			ExperimentStockSolution[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				StockSolutionName->"Existing Solution of 10% v/v Methanol in Water"
			],
			$Failed,
			Messages:>{Error::StockSolutionNameInUse, Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Synonyms,"Provide synonyms that should be tied to a new stock solution model created and prepared via the formula input; note that a provided Name is automatically added to Synonyms:"},
			Download[
				ExperimentStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					StockSolutionName->"Special Salt in Water Mixture "<>$SessionUUID,
					Synonyms->{"1 M NaCL in water"}
				],
				StockSolutionModels[[1]][Synonyms]
			],
			{"Special Salt in Water Mixture "<>$SessionUUID,"1 M NaCL in water"},
			TimeConstraint -> 80
		],
		Example[{Options,LightSensitive,"Indicate if a solution is sensitive to light exposure and should be stored in light-blocking containers when possible:"},
			Download[
				ExperimentStockSolution[
					{
						{200 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					500 Milliliter,
					LightSensitive->True
				],
				StockSolutionModels[[1]][LightSensitive]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,LightSensitive,"This option automatically resolves to True if any components in the provided formula are themselves marked as LightSensitive:"},
			Download[
				ExperimentStockSolution[
					{
						{1.2 Gram,Model[Sample,"L-Arginine Hydrochloride,U.S.P.,Multi-Compendial"]}
					},
					Model[Sample,"Milli-Q water"],
					50 Milliliter
				],
				StockSolutionModels[[1]][LightSensitive]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,LightSensitive,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					LightSensitive->True
				],
				StockSolutionModels[[1]][LightSensitive]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,LightSensitive,"If creating a stock solution that is light-sensitive and uses volumetric flasks, pick a volumetric flask and container out that is opaque:"},
			Download[
				Lookup[
					ExperimentStockSolution[
						{
							{20 Gram,Model[Sample, "Reserpine, USP Reference Standard"]}
						},
						Model[Sample,"Milli-Q water"],
						100 Milliliter,
						FillToVolumeMethod->Volumetric,
						LightSensitive->True,
						Upload->False
					][[1]],
					Replace[PreparatoryContainers]
				][[1]],
				Opaque
			],
			True
		],
		Example[{Options,LightSensitive,"If creating a stock solution that is NOT light-sensitive and uses volumetric flasks, prefer a volumetric flask and container out that is not opaque:"},
			Download[
				Lookup[
					ExperimentStockSolution[
						{
							{20 Gram,Model[Sample,"Sodium Chloride"]}
						},
						Model[Sample,"Milli-Q water"],
						100 Milliliter,
						FillToVolumeMethod->Volumetric,
						LightSensitive->False,
						Upload->False
					][[1]],
					Replace[PreparatoryContainers]
				][[1]],
				Opaque
			],
			(Null|False)
		],
		Example[{Options,Expires,"Indicate if stock solution samples of a model created via the formula input should expire after a given amount of time (specifiable via the ShelfLife option). Expired samples may be subjected to automated disposal:"},
			Download[
				ExperimentStockSolution[
					{
						{1.2 Gram,Model[Sample,"L-Arginine Hydrochloride,U.S.P.,Multi-Compendial"]}
					},
					Model[Sample,"Milli-Q water"],
					50 Milliliter,
					Expires->True,
					ShelfLife->30 Day
				],
				{StockSolutionModels[[1]][Expires],StockSolutionModels[[1]][ShelfLife]}
			],
			{True,30. Day},
			TimeConstraint -> 80
		],
		Example[{Options,Expires,"If the stock solution formulation is stable and should never be automatically disposed, set Expires to False:"},
			Download[
				ExperimentStockSolution[
					{
						{1.67 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Expires->False
				],
				{StockSolutionModels[[1]][Expires],StockSolutionModels[[1]][ShelfLife]}
			],
			{False,Null},
			TimeConstraint -> 80
		],
		Example[{Options,Expires,"If Expires is set to False, ShelfLife/UnsealedShelfLife cannot also be set:"},
			ExperimentStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->False,
				ShelfLife->1 Year
			],
			$Failed,
			Messages:>{Error::ExpirationShelfLifeConflict,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Expires,"If Expires is set to True, ShelfLife/UnsealedShelfLife cannot be set to Null:"},
			ExperimentStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->True,
				ShelfLife->1 Year,
				UnsealedShelfLife->Null
			],
			$Failed,
			Messages:>{Error::ShelfLifeNotSpecified,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Expires,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Expires->False
				],
				StockSolutionModels[[1]][Expires]
			],
			True,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,DiscardThreshold,"Specify the percentage of the prepared stock solution volume below which the sample will be automatically marked as AwaitingDisposal:"},
			Download[
				ExperimentStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					DiscardThreshold -> 4 Percent
				],
				StockSolutionModels[[1]][DiscardThreshold]
			],
			EqualP[4 Percent]
		],
		Example[{Options,DiscardThreshold,"If a formula is given, the DiscardThreshold option is resolved to 5 Percent:"},
			Download[
				ExperimentStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter
				],
				StockSolutionModels[[1]][DiscardThreshold]
			],
			EqualP[5 Percent]
		],
		Example[{Options,DiscardThreshold,"If a template is given, DiscardThreshold is just Null:"},
			Lookup[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Output -> Options
				],
				DiscardThreshold
			],
			Null
		],
		Example[{Options,ShelfLife,"Specify the length of time after preparation (but without being used) that samples of this stock solution are recommended for use before they should be discarded:"},
			Download[
				ExperimentStockSolution[
					{
						{2.19 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					ShelfLife->90 Day
				],
				StockSolutionModels[[1]][ShelfLife]
			],
			90. Day,
			TimeConstraint -> 80
		],
		Example[{Options,ShelfLife,"Automatically resolves to 5 years if Expires is set to True and no formula components have shelf lives:"},
			Download[
				ExperimentStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					(* RO Water does not have ShelfLife *)
					Model[Sample, "RO Water"],
					1 Liter,
					Expires->True
				],
				StockSolutionModels[[1]][ShelfLife]
			],
			5 Year,
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Example[{Options,ShelfLife,"Automatically resolves to the shortest of the shelf lives of any formula components:"},
			Download[
				ExperimentStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					Expires->True
				],
				StockSolutionModels[[1]][ShelfLife]
			],
			1 Year,
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Example[{Options,ShelfLife,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					ShelfLife->2 Year
				],
				StockSolutionModels[[1]][ShelfLife]
			],
			5. Year,
			EquivalenceFunction->Equal,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,UnsealedShelfLife,"Specify the length of time after first use that samples of this stock solution are recommended for use before they should be discarded:"},
			Download[
				ExperimentStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					UnsealedShelfLife->1 Year,
          ShelfLife->1 Year
				],
				StockSolutionModels[[1]][UnsealedShelfLife]
			],
			1 Year,
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Example[{Options,UnsealedShelfLife,"Automatically resolves to match ShelfLife if Expires is set to True and no formula components have unsealed shelf lives:"},
			Module[
				{protocol,stockSolutionModel},
				protocol=ExperimentStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Dichloromethane, Reagent Grade"],
					1 Liter,
					Expires->True
				];
				stockSolutionModel=Download[protocol,StockSolutionModels[[1]]];
				EqualQ[Download[stockSolutionModel,ShelfLife],Download[stockSolutionModel,UnsealedShelfLife]]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,UnsealedShelfLife,"Automatically resolves to the shortest of the unsealed shelf lives of any formula components:"},
			Download[
				ExperimentStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					Expires->True
				],
				StockSolutionModels[[1]][UnsealedShelfLife]
			],
			1 Day,
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Example[{Options,UnsealedShelfLife,"A warning is provided if the provided UnsealedShelfLife is longer than the provided ShelfLife:"},
			ExperimentStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				ShelfLife->1 Year,
				UnsealedShelfLife->2 Year
			],
			ObjectP[Object[Protocol,StockSolution]],
			Messages:>Warning::UnsealedShelfLifeLonger,
			TimeConstraint -> 80
		],
		Example[{Options,UnsealedShelfLife,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					UnsealedShelfLife->3 Month
				],
				StockSolutionModels[[1]][UnsealedShelfLife]
			],
			1. Year,
			EquivalenceFunction->Equal,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,DefaultStorageCondition,"Indicate the temperature conditions in which samples of this stock solution should be stored. This default condition can be overridden for specific samples using the function StoreSamples:"},
			Download[
				ExperimentStockSolution[
					{
						{4.98 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					DefaultStorageCondition->Refrigerator
				],
				StockSolutionModels[[1]][DefaultStorageCondition][StorageCondition]
			],
			Refrigerator,
			TimeConstraint -> 80
		],
		Example[{Options,DefaultStorageCondition,"Indicate the temperature conditions in which samples of this stock solution should be stored. This default condition can be overridden for specific samples using the function StoreSamples:"},
			Download[
				ExperimentStockSolution[
					{
						{4.98 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					DefaultStorageCondition->Refrigerator
				],
				StockSolutionModels[[1]][DefaultStorageCondition][StorageCondition]
			],
			Refrigerator,
			TimeConstraint -> 80
		],
		Example[{Options,DefaultStorageCondition,"Automatically resolves based on the lowest required temperature of any formula components:"},
			Download[
				ExperimentStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter
				],
				StockSolutionModels[[1]][DefaultStorageCondition][StorageCondition]
			],
			AmbientStorage,
			TimeConstraint -> 80
		],
		Example[{Options,DefaultStorageCondition,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					DefaultStorageCondition->Freezer
				],
				StockSolutionModels[[1]][DefaultStorageCondition][StorageCondition]
			],
			AmbientStorage,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,TransportTemperature,"Indicate if samples of this stock solution should be heated during transport when used in experiments:"},
			Download[
				ExperimentStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					TransportTemperature->50*Celsius
				],
				StockSolutionModels[[1]][TransportTemperature]
			],
			50*Celsius,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 80
		],
		Example[{Options,TransportTemperature,"Indicate if samples of this stock solution should be refrigerated during transport when used in experiments:"},
			Download[
				ExperimentStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					TransportTemperature->4 Celsius
				],
				StockSolutionModels[[1]][TransportTemperature]
			],
			EqualP[4 Celsius],
			TimeConstraint -> 80
		],
		Example[{Options,TransportTemperature,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					TransportTemperature->4 Celsius
				],
				StockSolutionModels[[1]][TransportTemperature]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,Density,"If known explicitly, specify the density that should be associated with this mixture. This will allow samples of this stock solution model to have their volumes measured via the gravimetric method:"},
			Download[
				ExperimentStockSolution[
					{
						{40 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Density->(1.069 Gram/Milliliter)
				],
				StockSolutionModels[[1]][Density]
			],
			(1.069 Gram/Milliliter),
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Example[{Options,Density,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Density->(1.086 Gram/Milliliter)
				],
				StockSolutionModels[[1]][Density]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,ExtinctionCoefficients,"Indicate how strongly this chemical absorbs light at a given wavelength:"},
			Download[
				ExperimentStockSolution[
					{
						{40 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					ExtinctionCoefficients -> {
						{260*Nanometer, 100*Liter/(Centimeter*Mole)},
						{330*Nanometer, 10000*Liter/(Centimeter*Mole)}
					}
				],
				StockSolutionModels[[1]][ExtinctionCoefficients]
			],
			{
				<|Wavelength -> UnitsP[Nanometer], ExtinctionCoefficient -> UnitsP[Liter/(Centimeter*Mole)]|>,
				<|Wavelength -> UnitsP[Nanometer], ExtinctionCoefficient -> UnitsP[Liter/(Centimeter*Mole)]|>
			},
			TimeConstraint -> 80
		],
		Example[{Options,Ventilated,"Indicate if samples of this stock solution should be handled in a ventilated enclosure:"},
			Download[
				ExperimentStockSolution[
					{
						{10 Milliliter,Model[Sample,"Milli-Q water"]},
						{10 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
					},
					Ventilated->True
				],
				StockSolutionModels[[1]][Ventilated]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,Ventilated,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Ventilated->True
				],
				StockSolutionModels[[1]][Ventilated]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,Flammable,"Indicate if samples of this stock solution are easily set aflame under standard conditions:"},
			Download[
				ExperimentStockSolution[
					{
						{950 Milliliter,Model[Sample,"Absolute Ethanol, Anhydrous"]},
						{50 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Flammable->True
				],
				StockSolutionModels[[1]][Flammable]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,Flammable,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Flammable->True
				],
				StockSolutionModels[[1]][Flammable]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,Acid,"Indicate if this stock solution is a strong acid (pH <= 2) and samples of this stock solution model require dedicated secondary containment during storage:"},
			Download[
				ExperimentStockSolution[
					{
						{5 Milliliter,Model[Sample,"Milli-Q water"]},
						{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
					},
					Acid->True
				],
				StockSolutionModels[[1]][Acid]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,Acid,"Acid and Base storage cannot be simultaneously required for a stock solution:"},
			ExperimentStockSolution[
				{
					{5 Milliliter,Model[Sample,"Milli-Q water"]},
					{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
				},
				Acid->True,
				Base->True
			],
			$Failed,
			Messages:>{Error::AcidBaseConflict,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Acid,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Acid->True
				],
				StockSolutionModels[[1]][Acid]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,Base,"Indicates if this stock solution is a strong base (pH >= 12) and samples of this stock solution model require dedicated secondary containment during storage:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Hydroxide"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Base->True
				],
				StockSolutionModels[[1]][Base]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,Base,"Acid and Base storage cannot be simultaneously required for a stock solution:"},
			ExperimentStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Hydroxide"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Base->True,
				Acid->True
			],
			$Failed,
			Messages:>{Error::AcidBaseConflict,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,Base,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Base->True
				],
				StockSolutionModels[[1]][Base]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,Fuming,"Indicates if samples of this stock solution emit fumes spontaneously when exposed to air:"},
			Download[
				ExperimentStockSolution[
					{
						{4 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
						{4 Milliliter,Model[Sample,"Trifluoromethanesulfonic acid"]}
					},
					Fuming->True
				],
				StockSolutionModels[[1]][Fuming]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,Fuming,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Fuming->True
				],
				StockSolutionModels[[1]][Fuming]
			],
			Null,
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,IncompatibleMaterials,"Provide a list of materials which may be damaged when wetted by this stock solution:"},
			Download[
				ExperimentStockSolution[
					{
						{5.6 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					IncompatibleMaterials->{CastIron,CarbonSteel}
				],
				StockSolutionModels[[1]][IncompatibleMaterials]
			],
			{CastIron,CarbonSteel},
			TimeConstraint -> 80
		],
		Example[{Options,IncompatibleMaterials,"This option should only be used with formula input:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					IncompatibleMaterials->{CastIron,CarbonSteel}
				],
				StockSolutionModels[[1]][IncompatibleMaterials]
			],
			{None},
			Messages:>{Warning::FormulaOptionsUnused},
			TimeConstraint -> 80
		],
		Example[{Options,IncompatibleMaterials,"If creating a stock solution that is incompatible with glass and uses volumetric flasks, pick a volumetric flask and container out that is not glass:"},
			Download[
				ExperimentStockSolution[Model[Sample, StockSolution, "id:O81aEB1zxYBo"]],
				{
					PreparatoryContainers[ContainerMaterials],
					ContainersOut[ContainerMaterials]
				}
			],
			{
				(* can't use glass because the sample is incompatible with glass *)
				{{Polypropylene}},
				{{Polypropylene}}
			}
		],
		Example[{Options,IncompatibleMaterials,"If creating a stock solution that is incompatible with polypropylene and uses volumetric flasks, pick a volumetric flask and container out that is not polypropylene:"},
			Download[
				ExperimentStockSolution[Model[Sample, StockSolution, "id:n0k9mGkZKXW3"]],
				{
					PreparatoryContainers[ContainerMaterials],
					ContainersOut[ContainerMaterials]
				}
			],
			{
				(* can't use polypropylene because the sample is incompatible with polypropylene *)
				{{Glass}},
				{{Glass}}
			}
		],
		Example[{Options,NumberOfReplicates,"Specify the number of times to make the given formula:"},
			Download[
				ExperimentStockSolution[
					{
						{4 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
						{4 Milliliter,Model[Sample,"Trifluoromethanesulfonic acid"]}
					},
					NumberOfReplicates -> 3
				],
				StockSolutionModels
			],
			{ObjectP[Model[Sample, StockSolution]], ObjectP[Model[Sample, StockSolution]], ObjectP[Model[Sample, StockSolution]]}
		],
		Test["Make sure we make different resources for each of the stock solution containers:",
			(
				requiredResources = Download[
					ExperimentStockSolution[
						{
							{4 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
							{4 Milliliter,Model[Sample,"Trifluoromethanesulfonic acid"]}
						},
						NumberOfReplicates -> 3
					],
					RequiredResources
				];
				DeleteDuplicates[Download[Select[requiredResources, #[[2]] == ContainersOut&][[All, 1]], Object]]
			),
			{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]},
			Variables :> {requiredResources},
			TimeConstraint -> 80
		],
		Example[{Options,NumberOfReplicates,"Specify the number of times to make the given templates:"},
			Download[
				ExperimentStockSolution[{Model[Sample,StockSolution,"1M NaCl (example)"], Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]}, NumberOfReplicates -> 2],
				StockSolutionModels
			],
			{ObjectP[Model[Sample, StockSolution]], ObjectP[Model[Sample, StockSolution]], ObjectP[Model[Sample, StockSolution]], ObjectP[Model[Sample, StockSolution]]}
		],
		Example[{Options,Template,"Provide a previously-run protocol from which to draw option defaults:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl, 0.45um filtered (example)"],Template->Object[Protocol,StockSolution,"Template Preparation of 1M NaCl (example)"]],Template],
			ObjectP[Object[Protocol,StockSolution,"Template Preparation of 1M NaCl (example)"]],
			TimeConstraint -> 80
		],
		Example[{Options,Name,"Name the protocol that is generated to prepare the stock solution; note that this Name is for the protocol object and NOT for a stock solution model. To name a new stock solution model generated via the formula input, use the StockSolutionName option:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Name->"Example Preparation of 1M NaCl Solution "<>$SessionUUID],Name],
			"Example Preparation of 1M NaCl Solution "<>$SessionUUID,
			TimeConstraint -> 80
		],
		Example[{Options,Name,"The protocol's Name must be unique:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Name->"Template Preparation of 1M NaCl (example)"],
			$Failed,
			Messages:>{Error::DuplicateName,Error::InvalidOption},
			TimeConstraint -> 80
		],
		Example[{Options,ImageSample,"Indicate that an image of the stock solution should be taken after all preparative steps:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],ImageSample->True],ImageSample],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,MeasureWeight,"Indicate that a measurement of the weight of the stock solution should be taken after all preparative steps:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],MeasureWeight->True],MeasureWeight],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,MeasureVolume,"Indicate that a measurement of the volume of the stock solution should be taken after all preparative steps:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],MeasureVolume->True],MeasureVolume],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,SamplesOutStorageCondition,"Provide a non-default storage condition in which the created stock solutions should be stored following preparation:"},
			Download[ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],SamplesOutStorageCondition->Freezer],SamplesOutStorage],
			{Freezer},
			TimeConstraint -> 80
		],
		Example[{Options,Confirm,"Confirm the generated protocol into the operations queue:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Confirm->True][Status],
			Processing|ShippingMaterials|Backlogged,
			TimeConstraint -> 80
		],
		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"][CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			TimeConstraint -> 80,
			Stubs:>{GitBranchExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Messages, "IncubateOptionConflict", "If Incubate -> False but other Incubate options are specified, throw an error:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Incubate -> False, IncubationTemperature -> 50*Celsius],
			$Failed,
			Messages :> {
				Error::IncubateOptionConflict,
				Error::InvalidOption
			},
			TimeConstraint -> 80
		],
		Example[{Messages,"ObjectDoesNotExist","Throw a message and return $Failed quickly if one of the input models does not exist:"},
			ExperimentStockSolution[{Model[Sample,StockSolution,"Stock solution model that doesn't exist"], Model[Sample,StockSolution,"1M NaCl (example)"]}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist},
			TimeConstraint -> 80
		],
		Example[{Messages,"ObjectDoesNotExist","Throw a message and return $Failed quickly if one of the input models in the formula do not exist:"},
			ExperimentStockSolution[
				{
					{5.6 Microgram,Model[Sample,"Fake Sodium Chloride that doesn't exist"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist},
			TimeConstraint -> 80
		],
		Example[{Messages,"ObjectDoesNotExist","Throw a message and return $Failed quickly if one of the input models in the formula do not exist:"},
			ExperimentStockSolution[
				{
					{5.6 Microgram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Fake Milli-Q water that doesn't exist"],
				1 Liter],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist},
			TimeConstraint -> 80
		],
		Example[{Messages, "ComponentAmountOutOfRange", "If the provided liquid amount is above the maximum allowed in the ECL, throw an error:"},
			ExperimentStockSolution[
				{
					{5 Gram, Model[Sample, "Sodium Chloride"]},
					{30 Liter, Model[Sample, "Milli-Q water"]}
				}
			],
			$Failed,
			Messages :> {Error::ComponentAmountOutOfRange, Error::InvalidInput},
			TimeConstraint -> 80
		],
		Example[{Messages,"ComponentAmountOutOfRange","If the provided solid amount is above the maximum allowed in the ECL, throw an error:"},
			ExperimentStockSolution[
				{
					{15 Kilogram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Liter
			],
			$Failed,
			Messages :> {Error::ComponentAmountOutOfRange, Error::InvalidInput},
			TimeConstraint -> 80
		],

		Example[{Messages,"ComponentAmountOutOfRange","If the provided amount is below the minimum allowed in the ECL, throw an error:"},
			ExperimentStockSolution[
				{
					{5.6 Microgram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages :> {Error::ComponentAmountOutOfRange, Error::InvalidInput},
			TimeConstraint -> 80
		],

		Example[{Messages,"DeprecatedStockSolutions","Deprecated stock solution models cannot be prepared:"},
			ExperimentStockSolution[Model[Sample,StockSolution,"Dilute Salt Water, deprecated (example)"]],
			$Failed,
			Messages:>{
				Error::DeprecatedStockSolutions,
				Error::InvalidInput
			},
			TimeConstraint -> 80
		],

		Example[{Messages,"NonPreparableStockSolutions","Stock solution models with Preparable -> False cannot be prepared:"},
			ExperimentStockSolution[Model[Sample, StockSolution, "Non-preparable sodium chloride solution"]],
			$Failed,
			Messages:>{
				Error::NonPreparableStockSolutions,
				Error::InvalidInput
			},
			TimeConstraint -> 80
		],

		Example[{Additional,"Fixed Amounts","A protocol is generated for a stock solution model with a fixed amount component:"},
			ExperimentStockSolution[
				Model[Sample, StockSolution, "Test Stock Solution with Fixed Aliquot Component" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, StockSolution]],
			TimeConstraint -> 80
		],
		Example[{Additional,"Fixed Amounts","A protocol is generated for a formula with a fixed amount component:"},
			ExperimentStockSolution[
				{
					{500 Microliter, Model[Sample, "Milli-Q water"]},
					{5 Milligram, Model[Sample,"Test Fixed Aliquot Solid Model for StockSolution Testing" <> $SessionUUID]}
				}
			],
			ObjectP[Object[Protocol, StockSolution]],
			TimeConstraint -> 120
		],

		Example[{Options,PrepareInResuspensionContainer,"Use PrepareInResuspensionContainer options to indicate that the stock solution should be prepared in the original container of the fixed amount component in the formula:"},
			Module[{protocol},
				protocol=ExperimentStockSolution[
					{
						{500 Microliter, Model[Sample, "Milli-Q water"]},
						{5 Milligram, Model[Sample,"Test Fixed Aliquot Solid Model for StockSolution Testing" <> $SessionUUID]}
					},
					PrepareInResuspensionContainer->True
				];
				Lookup[Download[protocol,ResolvedOptions],PrepareInResuspensionContainer]
			],
			True,
			TimeConstraint -> 80
		],
		Example[{Options,PrepareInResuspensionContainer,"When PrepareInResuspensionContainer->True, the stock solution model has PrepareInResuspensionContainer field populated:"},
			Module[{protocol},
				protocol=ExperimentStockSolution[
					{
						{500 Microliter, Model[Sample, "Milli-Q water"]},
						{5 Milligram, Model[Sample,"Test Fixed Aliquot Solid Model for StockSolution Testing" <> $SessionUUID]}
					},
					PrepareInResuspensionContainer->True
				];
				Download[protocol,StockSolutionModels[PrepareInResuspensionContainer]]
			],
			{True},
			TimeConstraint -> 80
		],

		Example[{Messages,"InvalidPreparationInResuspensionContainer","PrepareInResuspensionContainer cannot be True, if there is no fixed amount component in the formula:"},
			ExperimentStockSolution[
				{
					{500 Microliter, Model[Sample, "Milli-Q water"]},
					{5 Gram, Model[Sample,"Sodium Chloride"]}
				},
				PrepareInResuspensionContainer->True
			],
			$Failed,
			Messages:>{
				Error::InvalidPreparationInResuspensionContainer,
				Error::InvalidOption
			},
			TimeConstraint -> 80
		],

		Example[{Messages,"MultipleFixedAmountComponents","Stock solution models with more than one fixed amounts components cannot be prepared:"},
			ExperimentStockSolution[Model[Sample, StockSolution, "Stock Solution with Two Fixed Amount Components"]],
			$Failed,
			Messages:>{
				Error::MultipleFixedAmountComponents,
				Error::InvalidOption
			},
			TimeConstraint -> 80
		],

		Example[{Messages,"InvalidResuspensionAmounts","A protocol is generated for a formula with a fixed amount component:"},
			ExperimentStockSolution[
				{
					{500 Microliter, Model[Sample, "Milli-Q water"]},
					{7 Milligram, Model[Sample,"Test Fixed Aliquot Solid Model for StockSolution Testing" <> $SessionUUID]}
				},
				PrepareInResuspensionContainer->True
			],
			$Failed,
			Messages:>{
				Error::InvalidResuspensionAmounts,
				Error::InvalidOption
			},
			TimeConstraint -> 80
		],

		Example[{Messages, "VolumeOverMaxIncrement", "If the amount requested exceeds the amount that can feasibly be made by a fixed aliquot stock solution, throw an error:"},
			ExperimentStockSolution[
				{Model[Sample, StockSolution, "Stock Solution with Fixed Aliquot Component"]},
				Volume -> 20*Milliliter,
				PreparedResources -> {Object[Resource, Sample, "Fake resource 1 for fixed aliquot cases in ExperimentStockSolution"]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::VolumeOverMaxIncrement,
				Error::InvalidOption
			},
			TimeConstraint -> 80
		],

		Example[{Messages, "VolumeNotInIncrements", "If the amount requested is not one of the volume increments, throw an error:"},
			ExperimentStockSolution[Model[Sample, StockSolution, "Stock Solution with Fixed Aliquot Component"], Volume -> 2.7*Milliliter],
			$Failed,
			Messages :> {
				Error::VolumeNotInIncrements,
				Error::InvalidOption
			},
			TimeConstraint -> 80
		],

		Example[{Messages, "BelowFillToVolumeMinimum", "The solvent volume in a FillToVolume stock solution may not be outside of RangeP[$MinStockSolutionUltrasonicSolventVolume, $MaxStockSolutionComponentVolume]:"},
			ExperimentStockSolution[
				{
					{5 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				4 Milliliter
			],
			$Failed,
			Messages :> {
				Error::BelowFillToVolumeMinimum,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BelowFillToVolumeMinimum", "The solvent volume in a Volumetric FillToVolume stock solution has a lower limit:"},
			ExperimentStockSolution[
				{
					{5 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				2 Milliliter,
				FillToVolumeMethod->Volumetric
			],
			ObjectP[Object[Protocol,StockSolution]]
		],
		Example[{Messages, "AboveVolumetricFillToVolumeMaximum", "The solvent volume in a Volumetric FillToVolume stock solution cannot exceed the volume of the largest volumetric flask:"},
			ExperimentStockSolution[
				{
					{5 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				8 Liter,
				FillToVolumeMethod->Volumetric
			],
			$Failed,
			Messages :> {
				Error::AboveVolumetricFillToVolumeMaximum,
				Error::VolumeTooLargeForInversion,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AboveVolumetricFillToVolumeMaximum", "The solvent volume in a light-sensitive Volumetric FillToVolume stock solution cannot exceed the volume of the largest opaque volumetric flask:"},
			ExperimentStockSolution[
				{
					{5 Milligram,Model[Sample, "Reserpine, USP Reference Standard"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				LightSensitive->True,
				FillToVolumeMethod->Volumetric
			],
			$Failed,
			Messages :> {
				Error::AboveVolumetricFillToVolumeMaximum,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AboveVolumetricFillToVolumeMaximum", "The solvent volume in a Volumetric FillToVolume stock solution that is incompatible with Glass cannot exceed the volume of the largest polypropylene volumetric flask:"},
			ExperimentStockSolution[
				{
					{5 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				IncompatibleMaterials -> {Glass},
				FillToVolumeMethod->Volumetric
			],
			$Failed,
			Messages :> {
				Error::AboveVolumetricFillToVolumeMaximum,
				Error::InvalidOption
			}
		],

		Example[{Messages, "VolumeOverMaxIncrement", "If the amount requested is one of the volume increments but requires multiple fixed aliquots, populate the FixedAmountsComponents field with the proper duplicity:"},
			Download[
				ExperimentStockSolution[Model[Sample, StockSolution, "Test Stock Solution with Fixed Aliquot Component" <> $SessionUUID], Volume -> 2*Milliliter],
				FixedAmountsComponents
			],
			{ObjectP[Model[Sample]], ObjectP[Model[Sample]], ObjectP[Model[Sample]], ObjectP[Model[Sample]]},
			TimeConstraint -> 80
		],
		Test["If a stock solution has a SingleUse but non-fixed-aliquot component, still populate that component in FixedAmountsComponents:",
			Download[
				ExperimentStockSolution[Model[Sample, StockSolution, "Test Stock Solution with SingleUse Component" <> $SessionUUID], Volume -> 1.5*Liter],
				FixedAmountsComponents
			],
			{ObjectP[Model[Sample]]},
			TimeConstraint -> 80
		],

		Example[{Additional, "If the formula overload is used with a sample without a model, a protocol and a stock solution model are successfully created:"},
			protocol = ExperimentStockSolution[{{3*Milligram, Object[Sample, "Sample without Model for StockSolution tests"]}, {10*Milliliter, Model[Sample, "Milli-Q water"]}}];
			Download[protocol, {Object, StockSolutionModels[Formula]}],
			{ObjectP[Object[Protocol, StockSolution]], {{{_Quantity,ObjectP[]}..}..}},
			Variables :> {protocol},
			TimeConstraint -> 120
		],
		Example[{Additional, "If the formula overload is used with a sample without a model, a protocol and a stock solution model are successfully created:"},
			protocol = ExperimentStockSolution[{{3*Milligram, Object[Sample, "Sample without Model for StockSolution tests"]}}, Model[Sample, "Milli-Q water"], 10 Milliliter];
			Download[protocol, {Object, StockSolutionModels[Formula]}],
			{ObjectP[Object[Protocol, StockSolution]], {{{_Quantity,ObjectP[]}..}..}},
			Variables :> {protocol},
			TimeConstraint -> 80
		],
		Test["If the formula overload is used with a sample without a model, a protocol and a stock solution model are successfully created:",
			protocol = ExperimentStockSolution[{{3*Milligram, Object[Sample, "Sample without Model for StockSolution tests"]}, {10*Milliliter, Model[Sample, "Milli-Q water"]}}];
			Download[protocol, {FillToVolumeSamples, FillToVolumeMethods, VolumeMeasurementSolutions}],
			{{Null}, {Null}, {ObjectP[Model[Sample,StockSolution]]}},
			Variables :> {protocol},
			TimeConstraint -> 80
		],
		Test["If the formula overload is used with a sample without a model, a protocol and a stock solution model are successfully created:",
			protocol = ExperimentStockSolution[{{3*Milligram, Object[Sample, "Sample without Model for StockSolution tests"]}}, Model[Sample, "Milli-Q water"], 10 Milliliter];
			Download[protocol, {FillToVolumeSamples, FillToVolumeMethods, VolumeMeasurementSolutions}],
			{{ObjectP[Model[Sample,StockSolution]]}, {Ultrasonic}, {}},
			Variables :> {protocol},
			TimeConstraint -> 80
		],
		Test["Setting Upload->False returns a list of upload-ready packets:",
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Upload->False],
			_?ValidUploadQ
		],
		Test["Accepts packets, links, and object references:",
			ExperimentStockSolution[{Download[Model[Sample,StockSolution,"1M NaCl (example)"]],Link[Model[Sample,StockSolution,"1M NaCl (example)"]],Model[Sample,StockSolution,"1M NaCl (example)"]}],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 500
		],
		Test["Accepts packets, links, and object references from UnitOps-based stock solution models:",
			ExperimentStockSolution[{Download[Model[Sample,StockSolution,"UnitOps-Based StockSolutionModel "<>$SessionUUID]],Link[Model[Sample,StockSolution,"UnitOps-Based StockSolutionModel "<>$SessionUUID]],Model[Sample,StockSolution,"UnitOps-Based StockSolutionModel "<>$SessionUUID]}],
			ObjectP[Object[Protocol,StockSolution]],
			TimeConstraint -> 500,
			SetUp:>{
				(* turning this one off because a very weird error can be thrown during resource picking steps *)
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
				(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
				Off[General::stop];
				$CreatedObjects={};
				UploadStockSolution[
					{
						LabelContainer[
							Label->"output container",
							Container->Model[Container, Vessel, "50mL Tube"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"output container",
							Amount->1 Milliliter
						],
						Mix[
							Sample->"output container",
							MixType->Vortex,
							Time->10 Minute
						]
					},
					Name->"UnitOps-Based StockSolutionModel "<>$SessionUUID
				]
			},
			TearDown:>{
				EraseObject[Model[Sample,StockSolution,"UnitOps-Based StockSolutionModel "<>$SessionUUID],Force->True,Verbose->False]
			}
		],
		Test["If scaling up a stock solution to 20 mL (the minimum allowed for pHing) and the sum of all the liquid components of the scaled stock solution amounts are a lot less than 20, still properly generate a stock solution protocol:",
			ExperimentStockSolution[
				{Model[Sample, StockSolution, "Concentrated Saline (example)"]},
				Volume -> 1.7*Milliliter, ContainerOut -> Model[Container, Vessel, "2mL Tube"], ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID], PreparedResources -> {Object[Resource, Sample, "Resource 1 Prepped by ExpSS Call" <> $SessionUUID]}
			],
			ObjectP[Object[Protocol, StockSolution]],
			TimeConstraint -> 500
		],
		Test["If preparatory container and final container are the same model and we're not filtering, make a single resource:",
			Module[{protocol,allResources,prepContainerResources,finalContainerResources},

				protocol=ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"]];

				(* get the container resource packets *)
				allResources=Download[protocol,RequiredResources];
				prepContainerResources=Cases[allResources,{_,PreparatoryContainers,_,_}][[All,1]];
				finalContainerResources=Cases[allResources,{_,ContainersOut,_,_}][[All,1]];

				(* the prep and final container resources should be the same *)
				SameObjectQ[First[prepContainerResources],First[finalContainerResources]]
			],
			True,
			TimeConstraint -> 80
		],
		Test["If filtering, make separate resources for preparatory and final containers:",
			Module[{protocol,allResources,prepContainerResources,finalContainerResources},

				protocol=ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],Filter->True];

				(* get the container resource packets *)
				allResources=Download[protocol,RequiredResources];
				prepContainerResources=Cases[allResources,{_,PreparatoryContainers,_,_}][[All,1]];
				finalContainerResources=Cases[allResources,{_,ContainersOut,_,_}][[All,1]];

				(* the prep and final container resources should not be the same *)
				!SameObjectQ[First[prepContainerResources],First[finalContainerResources]]
			],
			True,
			TimeConstraint -> 600
		],
		Test["When ParentProtocol is provided, Author is set to Null:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID],
					PreparedResources->{Object[Resource,Sample,"Resource 2 Prepped by ExpSS Call" <> $SessionUUID]}
				],
				Author
			],
			Null,
			TimeConstraint -> 80
		],
		Test["Populate fill-to-volume fields for any fill-to-volume solutions:",
			Download[
				ExperimentStockSolution[{Model[Sample, StockSolution, "1M NaCl"],Model[Sample,StockSolution,"70% Ethanol"]}],
				{FillToVolumeSamples,FillToVolumeSolvents}
			],
			{
				{ObjectP[Model[Sample, StockSolution, "1M NaCl"]], Null},
				{ObjectP[Model[Sample,"Milli-Q water"]], Null}
			},
			TimeConstraint -> 600
		],
		Test["Populate MixedSolutions and MixParameters appropriately when a subset of solutions are mixed:",
			Download[
				ExperimentStockSolution[
					{Model[Sample, StockSolution, "1M NaCl"],Model[Sample,StockSolution,"70% Ethanol"]},
					Mix->{True,False},
					MixTime->{45 Minute,Null},
					MixType->{Shake,Null}
				],
				{
					MixedSolutions,
					MixParameters
				}
			],
			{
				{ObjectP[]},
				{
					<|
						Type->Shake,
						MixUntilDissolved->False,
						Mixer->ObjectP[Model[Instrument,Shaker]],
						Time->45. Minute,
						MaxTime->Null,
						Rate->UnitsP[RPM],
						NumberOfMixes->Null,
						MaxNumberOfMixes->Null,
						PipettingVolume->Null,
						Temperature -> Null,
						AnnealingTime -> EqualP[0.*Minute],
						ThawInstrument -> Null,
						ThawTemperature -> Null,
						ThawTime -> Null
					|>
				}
			},
			TimeConstraint -> 80
		],
		Test["Populate MixedSolutions and MixParameters appropriately when a subset of solutions are incubated (if not already mixing):",
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Mix -> {False, False},
					Incubate->{True,False},
					IncubationTime->{45 Minute,Null},
					IncubationTemperature->{35Celsius,Null}
				],
				{
					MixedSolutions,
					MixParameters
				}
			],
			{
				{ObjectP[]},
				{
					<|
						Type->Null,
						MixUntilDissolved->Null,
						Mixer->ObjectP[Model[Instrument, HeatBlock]],
						Time -> TimeP,
						MaxTime->Null,
						Rate->Null,
						NumberOfMixes->Null,
						MaxNumberOfMixes->Null,
						PipettingVolume->Null,
						Temperature -> TemperatureP,
						AnnealingTime -> Null,
						ThawInstrument -> Null,
						ThawTemperature -> Null,
						ThawTime -> Null
					|>
				}
			},
			TimeConstraint -> 80
		],
		Test["Populate pH fields when a subset of solutions are pH-titrated:",
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					pH->{Null,6.51},
					MaxpH->{Automatic,7},
					pHingBase->{Automatic,Model[Sample,StockSolution,"0.1 M NaOH"]}
				],
				{
					pHingSamples,
					NominalpHs,
					MinpHs,
					MaxpHs,
					pHTolerances,
					pHingAcids,
					pHingBases,
					pHingPipettes,
					AcidPipetteTips,
					BasePipetteTips,
					pHIncrements,
					pHingMixer,
					pHingMixerImpellers,
					AllpHingTips,
					AllpHingPipettes
				}
			],
			{
				{ObjectP[]},
				{6.51`},
				{6.41`},
				{7.},
				{},
				{ObjectP[Model[Sample,StockSolution,"2 M HCl"]]},
				{ObjectP[Model[Sample,StockSolution,"0.1 M NaOH"]]},
				{},
				{},
				{},
				{},
				Null,
				{},
				{},
				{}
			},
			TimeConstraint -> 600
		],
		Test["Populate FiltrationSamples and FiltrationParameters appropriately when a subset of solutions are filtered:",
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Filter->{False,True},
					FilterMaterial->{Null,PTFE}
				],
				{
					FiltrationSamples,
					FiltrationParameters
				}
			],
			{
				{ObjectP[]},
				{
					<|
						Type->PeristalticPump,
						Instrument->ObjectP[Model[Instrument,PeristalticPump]],
						Filter->ObjectP[Model[Item,Filter]],
						MembraneMaterial->PTFE,
						PoreSize->0.22 Micrometer,
						Syringe->Null,
						FilterHousing->ObjectP[Model[Instrument,FilterHousing]]
					|>
				}
			},
			TimeConstraint -> 600
		],
		Test["Handle links and packets for ContainerOut option:",
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"1M NaCl (example)"]},
					ContainerOut->{Download[Model[Container,Vessel,"2L Glass Bottle"]],Link[Model[Container,Vessel,"2L Glass Bottle"]]}
				],
				ContainersOut
			],
			{ObjectP[Model[Container,Vessel,"2L Glass Bottle"]],ObjectP[Model[Container,Vessel,"2L Glass Bottle"]]},
			TimeConstraint -> 600
		],
		Test["Populate VolumeMeasurementSolutions with any stock solution models being prepared for the first time that don't have TotalVolume populated:",
			Download[
				ExperimentStockSolution[{Model[Sample,StockSolution,"Test Stock Solution with Fixed Aliquot Component" <> $SessionUUID],Model[Sample,StockSolution,"Aspirin (tablet) in water" <> $SessionUUID]}],
				VolumeMeasurementSolutions
			],
			{ObjectP[Model[Sample,StockSolution,"Test Stock Solution with Fixed Aliquot Component" <> $SessionUUID]]},
			TimeConstraint -> 600,
			(* need DevSearch here to find this object bc it is an existing model *)
			Stubs :> {
				$DeveloperSearch = True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=False,
				Experiment`Private`$StockSolutionUnitTestSearchName=$SessionUUID
			}
		],
		Test["If a new stock solution model is created based on an existing model due to, for example, a much different preparation volume, all safety information is preserved:",
			Download[
				ExperimentStockSolution[Model[Sample,StockSolution,"Dangerous Stock Solution (example)"],Volume->10 Milliliter,Mix->False],
				{StockSolutionModels[[1]][Ventilated],StockSolutionModels[[1]][Flammable],StockSolutionModels[[1]][Base],StockSolutionModels[[1]][IncompatibleMaterials]}
			],
			{True,True,True,{CarbonSteel}},
			TimeConstraint -> 80
		],
		Test["Populate PreparedResources field when hidden option is set:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					PreparedResources->{Object[Resource,Sample,"Resource 3 Prepped by ExpSS Call" <> $SessionUUID]},
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID]
				],
				PreparedResources
			],
			{ObjectP[Object[Resource,Sample,"Resource 3 Prepped by ExpSS Call" <> $SessionUUID]]},
			TimeConstraint -> 80
		],
		Test["Resolves ImageSample to the value of the root protocol when it is only one level up:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					ParentProtocol->Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentStockSolution unit test "<>$SessionUUID],
					PreparedResources->{Object[Resource,Sample,"Resource 4 Prepped by ExpSS Call" <> $SessionUUID]}
				],
				ImageSample
			],
			True,
			TimeConstraint -> 80
		],
		Test["Resolves ImageSample to the value of the root protocol when it is multiple levels up:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					ParentProtocol->Object[Protocol,PAGE,"PAGE Root for SM Test"],
					PreparedResources->{Object[Resource,Sample,"Resource 5 Prepped by ExpSS Call" <> $SessionUUID]}
				],
				ImageSample
			],
			True,
			TimeConstraint -> 80
		],
		Test["Resolves ImageSample to True if the parent does not have an ImageSample option:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					ParentProtocol->Object[Maintenance,Clean,"Maintenance Parent for SM Test"],
					PreparedResources->{Object[Resource,Sample,"Resource 6 Prepped by ExpSS Call" <> $SessionUUID]}
				],
				ImageSample
			],
			True,
			TimeConstraint -> 80
		],
		Test["Return options for a full-preparation solution:",
			ExperimentStockSolution[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->20 Minute,
				pH->6,
				IncubationTime->20 Minute,
				Filter->True,
				FilterSize->0.22 Micron,
				Name->"Full Prep of 1M NaCl (example) "<>$SessionUUID,
				Output->Options
			],
			{_Rule..},
			TimeConstraint -> 500
		],
		Test["Return resolved options and tests for formula input:",
			MatchQ[
				ExperimentStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					pH->9,
					Filter->True,
					Incubate->True,
					Output->{Options,Tests}
				],
				{
					{_Rule..},
					{TestP..}
				}
			],
			True,
			Stubs:>{
				$DeveloperSearch = True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
			}
		],
		Test["Return tests for a full-preparation solution:",
			MatchQ[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					MixTime->20 Minute,
					Incubate->True,
					pH->6,
					Filter->True,
					FilterSize->0.22 Micron,
					Name->"Full Prep of 1M NaCl (example)",
					Output->Tests
				],
				{TestP..}
			],
			True
		],
		Test["Return options and tests:",
			MatchQ[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					MixTime->20 Minute,
					pH->6,
					Filter->True,
					Incubate->True,
					FilterSize->0.22 Micron,
					Name->"Full Prep of 1M NaCl (example)",
					Output->{Options,Tests}
				],
				{
					{_Rule..},
					{TestP..}
				}
			],
			True
		],
		Test["Return Tests even if options do not match their patterns, even if Options and Result are $Failed:",
			ExperimentStockSolution[Model[Sample,StockSolution,"1M NaCl (example)"],pH->10 Milliliter,Output->{Result,Options,Tests}],
			{$Failed,$Failed,{TestP..}},
			TimeConstraint -> 80
		],
		Test["If a new model is made to prepare a direct formula solution that already has a TotalVolume, populate TotalVolume in the new model:",
			Download[
				ExperimentStockSolution[Model[Sample,StockSolution,"Already-prepared MeoH/Water solution (test)"],pH->8,Volume->100 Milliliter],
				StockSolutionModels[TotalVolume]
			],
			{UnitsP[Liter]},
			TimeConstraint -> 80
		],
		Test["Silently prepare more volume if being called from Engine with a Volume below a preparatory minimum:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Volume->2 Milliliter,
					pH->6,
					PreparedResources->{Object[Resource,Sample,"Resource 7 Prepped by ExpSS Call" <> $SessionUUID]},
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID]
				],
				{PreparatoryVolumes,RequestedVolumes}
			],
			{
				{20. Milliliter},
				{2. Milliliter}
			},
			EquivalenceFunction->Equal,
			TimeConstraint -> 80
		],
		Test["Silently prepare more volume if being called from Engine with a Volume below a component measurement minimum and leave MaxVolume which containerOut could handle:",
			{
				prepVolumes,
				requestedVolumes,
				containersOut
			} = Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Volume->10 Microliter,
					PreparedResources->{Object[Resource,Sample,"Resource 8 Prepped by ExpSS Call" <> $SessionUUID]},
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID]
				],
				{PreparatoryVolumes,RequestedVolumes,ContainersOut}
			];
			{
				prepVolumes,
				MapThread[#1 == #2&, {requestedVolumes, Download[containersOut, MaxVolume]}]
			},
			(* if the volume is too small then we just scale up to the max volume of the container out; doing it this way so that if we change the ContainerOut this test still works *)
			{
				{EqualP[5. Milliliter]},
				{True}
			},
			Variables :> {prepVolumes, requestedVolumes, containersOut}
		],
		Test["Preserve the Type of an input stock solution model if generating a new one due to prep option conflict:",
			Download[ExperimentStockSolution[Model[Sample,Matrix,"Salt Matrix (example)"],MixType->Vortex],StockSolutionModels[Type]],
			{Model[Sample,Matrix]}
		],

		Test["If the ContainerOut must be mixed by pipette, do NOT mix by pipette because it will be made in a different container before transferring:",
			{
				Download[Model[Sample,StockSolution,"Dilute Salt Water, mixed until dissolved (example)"],{MixTime}],
				Lookup[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"Dilute Salt Water, mixed until dissolved (example)"],
						Volume->5 Milliliter,
						Output->Options,
						ContainerOut -> Model[Container, Vessel, "50mL Reagent Tub"]
					],
					{MixType,MixTime}
				]
			},
			{
				{17*Minute},
				{Vortex,17*Minute}
			},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 80
		],
		Test["If a new model is generated through Engine, the Author of the new model is the root protocol's Author:",
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Volume->2 Milliliter,
					pH->6,
					PreparedResources->{Object[Resource,Sample,"Resource 9 Prepped by ExpSS Call" <> $SessionUUID]},
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID]
				],
				StockSolutionModels[[1]][Authors]
			],
			{ObjectP[Object[User,"Test user for notebook-less test protocols"]]},
			TimeConstraint -> 80
		],

		Test["Calculates the amount of acid and base to request by looking at the maximum amount ever needed:",
			Module[{protocol,resources},
				protocol=ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					pH->{8,8,Null},
					Volume->{100 Milliliter,100 Milliliter,100 Milliliter}
				];
				resources=Download[protocol,RequiredResources];
				acidResources=Download[Cases[resources,{_,pHingAcids,_,_}][[All,1]],Object];
				baseResources=Download[Cases[Download[protocol,RequiredResources],{_,pHingBases,_,_}][[All,1]],Object];
				Download[DeleteDuplicates[Join[acidResources,baseResources]],{Amount,ContainerModels[Object]}]
			],
			{
				{EqualP[15 Milliliter],{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:01G6nvwPempK"], Model[Container, Vessel, "id:J8AY5jwzPPR7"]}},
				{EqualP[15 Milliliter],{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:01G6nvwPempK"], Model[Container, Vessel, "id:J8AY5jwzPPR7"]}}
			},
			TimeConstraint -> 250
		],
		Example[{Options,PreFiltrationImage,"Indicates that the stock solutions being prepared should be imaged before filtration:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Filter->True,
					PreFiltrationImage->True
				],
				PreFiltrationImage
			],
			True,
			TimeConstraint -> 600
		],
		Test["PreFiltrationImage resolves to True if any filtration is being done:",
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"1M NaCl (example)"]},
					Filter->{True,False}
				],
				PreFiltrationImage
			],
			True,
			TimeConstraint -> 600
		],
		Test["PreFiltrationImage resolves to False if no filtration is being done:",
			Download[
				ExperimentStockSolution[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"1M NaCl (example)"]}
				],
				PreFiltrationImage
			],
			False
		],
		Example[{Messages,"NoFiltrationImaging","Print a message and returns $Failed if no filtration is being done, but pre-filtration imaging is requested:"},
			ExperimentStockSolution[
				{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"1M NaCl (example)"]},
				PreFiltrationImage->True
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::NoFiltrationImaging}
		],
		Example[{Messages,"TemplatesPreperationTypeConflict","Throw error if the preparation mode of the specified stock solution models is not the same:"},
			ExperimentStockSolution[
				{Model[Sample,StockSolution, "Formula-based Model "<>$SessionUUID],Model[Sample,StockSolution,"UnitOperations-based Model "<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::TemplatesPreperationTypeConflict},
			SetUp:>(
				(* turning this one off because a very weird error can be thrown during resource picking steps *)
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
				(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
				Off[General::stop];
				$CreatedObjects={};
				UploadStockSolution[
					{{80 Gram, Model[Sample, "Sodium Chloride"]}},
					Model[Sample, "Milli-Q water"],
					1 Liter,
					Name -> "Formula-based Model "<>$SessionUUID
				];
				UploadStockSolution[
					{
						LabelContainer[Label -> "tube",Container -> Model[Container, Vessel, "2mL Tube"]],
						Transfer[Source -> Model[Sample, "Sodium Chloride"],Destination -> "tube", Amount -> 100 Milligram]
					},
					Name -> "UnitOperations-based Model "<>$SessionUUID
				];
			)
		],
		Test["Resolve Acid when preparing a stock solution by formula:",
			Download[
				ExperimentStockSolution[
					{
						{Quantity[125.`, "Milliliters"],Model[Sample, "id:8qZ1VWNmdLBD"]},
						{Quantity[125.`, "Milliliters"],Model[Sample, "id:9RdZXvKBeeoL"]}
					},
					StockSolutionName -> "Test acidic stock solution "<>$SessionUUID
				],
				StockSolutionModels[Acid]
			],
			{True}
		],
		Test["Resolve Base when preparing a stock solution by formula:",
			Download[
				ExperimentStockSolution[
					{
						{Quantity[40.`, "Grams"],Model[Sample, "Sodium Hydroxide"]},
						{Quantity[100.`, "Milliliters"],Model[Sample, "Milli-Q water"]}
					},
					StockSolutionName -> "Test basic stock solution "<>$SessionUUID
				],
				StockSolutionModels[Base]
			],
			{True}
		],
		Example[{Messages, "InvalidModelFormulaForFillToVolume", "Throw an error and return $Failed if the stock solution model has a formula where the combined total volume of its components equal to or exceeds the model's TotalVolume:"},
			ExperimentStockSolution[
				Model[Sample, StockSolution, "Test Model with Invalid Formula and TotalVolume For ExperimentStockSolution"]
			],
			$Failed,
			Messages :> {Error::InvalidModelFormulaForFillToVolume, Error::InvalidInput}
		],
		(*This goes through formula overload and throws a different error message*)
		Example[{Messages, "FormulaVolumeTooLarge", "Throw an error and return $Failed if the input formula has the combined total volume of its components equal to or exceeds the model's TotalVolume:"},
			ExperimentStockSolution[
				{
					{80 Gram, Model[Sample, "Sodium Chloride"]},
					{1000 Milliliter, Model[Sample, "Milli-Q water"]}
				},
				Model[Sample, "Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages :> {Error::FormulaVolumeTooLarge, Error::InvalidOption, Error::InvalidInput}
		],
		(*Warning::VolumeTooLowForAutoclave*)
		Example[{Messages, "VolumeTooLowForAutoclave", "Throw a warning but respect user input if the specified volume is below 100mL for an Autoclave->True protocol:"},
			Lookup[ExperimentStockSolution[
				Model[Sample, StockSolution, "1M NaCl (example)"],
				Volume -> 50 Milliliter,
				Autoclave -> True,
				Output -> Options
			],
				Volume
			],
			EqualP[50 Milliliter],
			Messages :> {Warning::VolumeTooLowForAutoclave}
		],
		Example[{Messages, "ModelStockSolutionMixRateNotSafe", "Throw a warning if the given model stocksolution contains an unsafe mix rate and replace it to the max safe mix rate:"},
			Lookup[ExperimentStockSolution[Model[Sample, StockSolution, "Test Stock Solution with mix rate higher than safe mix rate of container" <> $SessionUUID],
				Output -> Options
			],
				MixRate
			],
			EqualP[600 RPM],
			Messages :> {Warning::ModelStockSolutionMixRateNotSafe}
		],
		Example[{Messages, "SpecifedMixRateNotSafe", "Given formula, throw an error and return $Failed if the specified MixRate is over safe mix rate:"},
			ExperimentStockSolution[
				{
					{700 Milliliter, Model[Sample, "Milli-Q water"]}
				},
				MixRate -> 750 RPM,
				MixType -> Stir
			],
			$Failed,
			Messages :> {Error::SpecifedMixRateNotSafe, Error::InvalidOption}
		],
		Example[{Messages, "SpecifedMixRateNotSafe", "Given model stock solution, throw an error and return $Failed if the specified MixRate is over safe mix rate:"},
			ExperimentStockSolution[
				Model[Sample, StockSolution, "1M NaCl (example)"],
				MixRate -> 750 RPM,
				MixType -> Stir
			],
			$Failed,
			Messages :> {Error::SpecifedMixRateNotSafe, Error::InvalidOption}
		],

		Test[{"VolumeTooLowForAutoclave warning is not thrown for formula overload if the specified volume is below 100mL for an Autoclave->True protocol because this volume is not being used:"},
			Download[
				ExperimentStockSolution[
					{
						{80 Gram, Model[Sample, "Sodium Chloride"]},
						{500 Milliliter, Model[Sample, "Milli-Q water"]}
					},
					Model[Sample, "Milli-Q water"],
					1 Liter,
					Volume -> 10Milliliter,
					Autoclave -> True
				],
				RequestedVolumes
			],
			{EqualP[1 Liter]},
			Messages :> {Warning::VolumeOptionUnused}
		],
		Test[{"No message is thrown if the specified volume is below 100mL for an Autoclave->True protocol while we are in engine:"},
			Download[
				Block[{$ECLApplication=Engine},
					ExperimentStockSolution[
						Model[Sample, StockSolution, "1M NaCl (example)"],
						Volume -> 5 Milliliter,
						Autoclave -> True,
						Output -> Options
					]
				],
				RequestedVolumes
			],
			{EqualP[5 Milliliter]}
		],
		Test[{"No message is thrown but the volume to prepare is bumped to 100 mL if the specified volume is below 100mL for an Autoclave->True protocol that is preparing a resource:"},
			Download[
				ExperimentStockSolution[
					Model[Sample, StockSolution, "1M NaCl (example)"],
					PreparedResources -> {Object[Resource, Sample, "Resource 1 Prepped by ExpSS Call" <> $SessionUUID]},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID],
					Volume -> 10 Milliliter,
					Autoclave -> True
				],
				RequestedVolumes
			],
			{EqualP[100 Milliliter]}
		],
		Test[{"PreparatoryContainers is resolved to an autoclavable container model if Autoclave -> True:"},
			Download[
				Block[{$ECLApplication=Engine},
					ExperimentStockSolution[
						Model[Sample, StockSolution, "1M NaCl (example)"],
						Volume -> 50 Milliliter,(* This volume would otherwise have PreparatoryContainers resolved to a 50mL tube which is not autoclavable*)
						Autoclave -> True
					]
				],
				PreparatoryContainers[MaxTemperature]
			],
			{GreaterEqualP[121 Celsius]}
		],
		Test[{"Resolved mix options respect the model even when PreparatoryContainers is a volumetric flask:"},
			Lookup[
				Download[
					ExperimentStockSolution[
						Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV and Stirring Mix"<>$SessionUUID],
						Volume -> 1 Liter
				],
					ResolvedOptions
				],
				{Mix, MixType, MixUntilDissolved, Mixer, MixTime, MaxMixTime, MixRate, NumberOfMixes, MaxNumberOfMixes}
			],
			{
				True, Stir, True, ObjectP[Model[Instrument, OverheadStirrer]],
				EqualP[30*Minute], EqualP[60*Minute], EqualP[200*RPM], Null, Null
			}
		],
		Example[{Options,MaxNumberOfOverfillingRepreparations,"Indicates how many times the preparation of failed stock solution should be repeated in the event of overfilling:"},
			Download[
				ExperimentStockSolution[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					MaxNumberOfOverfillingRepreparations->2
				],
				MaxNumberOfOverfillingRepreparations
			],
			2
		]
	},
	Parallel -> True,
	SetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {}
	),
	TearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$EmailEnabled = False,
		$AllowSystemsProtocols = True,
		$DeveloperUpload = True,
		(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
		Search[Model[StorageCondition]] = Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True,
		$AllowPublicObjects=True
	},
	SymbolSetUp :>{
		(* turning this one off because a very weird error can be thrown during resource picking steps *)
		Off[Warning::SamplesOutOfStock];
		Block[{$Notebook=Null, $AllowPublicObjects=True},
			Module[
				{
					(* For symbol setup/teardown *)
					allObjects,existingObjects,
					(* Test object variables *)
					testBench,
					fixedAliquotSample,singleUseSample,tabletSample,filterModel1,prod1,prod2,prod3,prod4,ssModel1,ssModel2,ssModel3,
					resource1,resource2,resource3,resource4,resource5,resource6,resource7,resource8,resource9,resource10,hplcProtocol,
					ssModel4, ssModel5, ssModel6
				},
				allObjects=Quiet[
					Cases[
						(* Enlist test objects to make sure they got deleted. *)
						Flatten[{
							$CreatedObjects,
							Object[Container, Bench, "Test bench for ExperimentStockSolution tests" <> $SessionUUID],
							Model[Sample,"Test Fixed Aliquot Solid Model for StockSolution Testing"<>$SessionUUID],
							Model[Sample,"Test SingleUse Aliquot Model for StockSolution Testing"<>$SessionUUID],
							Model[Sample,"Aspirin (tablet)"<>$SessionUUID],
							Model[Item,Filter,"Test non-sterile filter model for ExperimentStockSolution unit test"<>$SessionUUID],
							Object[Product,"Test Fixed Aliquot Solid Product for StockSolution Testing"<>$SessionUUID],
							Object[Product,"Test SingleUse Aliquot Product for StockSolution Testing"<>$SessionUUID],
							Object[Product,"Aspirin (tablet) Product"<>$SessionUUID],
							Object[Product,"Test non-sterile filter product for ExperimentStockSolution unit test"<>$SessionUUID],
							Model[Sample,StockSolution,"Test Stock Solution with Fixed Aliquot Component"<>$SessionUUID],
							Model[Sample,StockSolution,"Test Stock Solution with SingleUse Component"<>$SessionUUID],
							Model[Sample,StockSolution,"Aspirin (tablet) in water"<>$SessionUUID],
							Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV"<>$SessionUUID],
							Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV and Stirring Mix"<>$SessionUUID],
							Object[Resource,Sample,"Resource 1 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 2 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 3 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 4 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 5 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 6 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 7 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 8 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 9 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Resource,Sample,"Resource 10 Prepped by ExpSS Call"<>$SessionUUID],
							Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentStockSolution unit test "<>$SessionUUID],
							Object[Container,Vessel,"Test container for sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],
							Object[Sample,"Test sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],
							Object[Protocol,ManualSamplePreparation,"Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID],
							Model[Sample, StockSolution, "Test Stock Solution with mix rate higher than safe mix rate of container"<>$SessionUUID]
						}],
						ObjectP[]
					]
				];

				existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
				EraseObject[existingObjects,Force->True,Verbose->False];

				(* Initialize $CreatedObjects *)
				$CreatedObjects={};

				Block[{$DeveloperUpload=True},

				(* Create test objects *)
				{
					fixedAliquotSample,
					singleUseSample,
					tabletSample,
					filterModel1,
					prod1,
					prod2,
					prod3,
					prod4,
					ssModel1,
					ssModel2,
					ssModel3,
					ssModel4,
					ssModel5,
					hplcProtocol,
					ssModel6
				}=CreateID[{
					Model[Sample],
					Model[Sample],
					Model[Sample],
					Model[Item,Filter],
					Object[Product],
					Object[Product],
					Object[Product],
					Object[Product],
					Model[Sample,StockSolution],
					Model[Sample,StockSolution],
					Model[Sample,StockSolution],
					Model[Sample,StockSolution],
					Model[Sample,StockSolution],
					Object[Protocol,HPLC],
					Model[Sample,StockSolution]
				}];

				testBench = Upload[<|Type -> Object[Container, Bench], Name -> "Test bench for ExperimentStockSolution tests" <> $SessionUUID, DeveloperObject -> True, Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects]|>];

				UploadSample[
					Model[Container,Vessel, "50mL Tube"],
					{"Work Surface",Object[Container,Bench,"Test bench for ExperimentStockSolution tests"<>$SessionUUID]},
					Name->"Test container for sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID
				];
				UploadSample[
					Model[Sample,"Methanol - LCMS grade"],
					{"A1",Object[Container,Vessel,"Test container for sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID]},
					Name->"Test sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID
				];
				(* Wipe out the model for the Object[Sample] with missing model *)
				Upload[<|Object->Object[Sample,"Test sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],Model->Null|>];

				Upload[{
					<|
						Object->fixedAliquotSample,
						Name->"Test Fixed Aliquot Solid Model for StockSolution Testing"<>$SessionUUID,
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						State->Solid,
						SampleHandling->Fixed,
						Replace[FixedAmounts]->{5 Milligram},
						Replace[TransferOutSolventVolumes]->{Quantity[0.5,"Milliliters"]},
						SingleUse->True,
						Expires->False,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
					|>,
					<|
						Object->singleUseSample,
						Name->"Test SingleUse Aliquot Model for StockSolution Testing"<>$SessionUUID,
						Replace[Synonyms]->{"Test SingleUse Aliquot Model for StockSolution Testing"<>$SessionUUID},
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						Replace[Composition]->{{100 MassPercent,Link[Model[Molecule,"Sodium Chloride"]]}},
						State->Solid,
						SingleUse->True,
						Expires->False,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Flammable->False,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None}
					|>,
					<|
						Object->tabletSample,
						Name->"Aspirin (tablet)"<>$SessionUUID,
						Replace[Synonyms]->{"Aspirin (tablet)"<>$SessionUUID},
						DeveloperObject->True,
						Replace[Authors]->{Link[$PersonID]},
						State->Solid,
						Density->1.4 Kilogram/Liter,
						Tablet->True,
						SolidUnitWeight->300 Milligram,
						Expires->False,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Ventilated->False,
						Flammable->False,
						Replace[IncompatibleMaterials]->{None}
					|>,
					<|
						Object->filterModel1,
						Name->"Test non-sterile filter model for ExperimentStockSolution unit test"<>$SessionUUID,
						MinVolume->20*Milliliter,
						MaxVolume->21*Liter,
						Dimensions->{18*Centimeter,17*Centimeter,6.5*Centimeter},
						Reusable->False,
						FilterType->BottleTop,
						PoreSize->450*Nanometer,
						MembraneMaterial->PES,
						Diameter->90*Millimeter,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Replace[WettedMaterials]->{PES, Acrylic, PVC, Polyester, Polyurethane, Polyethylene},
						Sterile->False
					|>,
					<|
						Object->prod1,
						Name->"Test Fixed Aliquot Solid Product for StockSolution Testing"<>$SessionUUID,
						DeveloperObject->True,
						ProductModel->Link[fixedAliquotSample,Products]
					|>,
					<|
						Object->prod2,
						Name->"Test SingleUse Aliquot Product for StockSolution Testing"<>$SessionUUID,
						DeveloperObject->True,
						ProductModel->Link[singleUseSample,Products]
					|>,
					<|
						Object->prod3,
						Name->"Aspirin (tablet) Product"<>$SessionUUID,
						DeveloperObject->True,
						ProductModel->Link[tabletSample,Products]
					|>,
					<|
						Object->prod4,
						Name->"Test non-sterile filter product for ExperimentStockSolution unit test"<>$SessionUUID,
						DeveloperObject->True,
						ProductModel->Link[filterModel1,Products]
					|>,
					<|
						Object->ssModel1,
						Name->"Test Stock Solution with Fixed Aliquot Component"<>$SessionUUID,
						DeveloperObject->True,
						Replace[Synonyms]->{"Test Stock Solution with Fixed Aliquot Component"<>$SessionUUID},
						Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]]}},
						Expires->False,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None},
						Preparable->True,
						Replace[Formula]->{
							{500 Microliter,Link[Model[Sample,"Milli-Q water"]]},
							{5 Milligram,Link[fixedAliquotSample]}
						},
						Replace[VolumeIncrements]->{0.5 Milliliter}
					|>,
					<|
						Object->ssModel2,
						Name->"Test Stock Solution with SingleUse Component"<>$SessionUUID,
						DeveloperObject->True,
						Replace[Synonyms]->{"Test Stock Solution with Fixed Aliquot Component"<>$SessionUUID},
						Replace[Composition]->{
							{100 VolumePercent,Link[Model[Molecule,"Water"]]},
							{171.116 Millimolar,Link[Model[Molecule,"Sodium Chloride"]]}
						},
						State->Liquid,
						Expires->True,
						ShelfLife->5 Year,
						UnsealedShelfLife->1 Year,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None},
						Preparable->True,
						MixTime->15 Minute,
						Replace[Formula]->{
							{10 Gram,Link[singleUseSample]},
							{1 Liter,Link[Model[Sample,"Milli-Q water"]]}
						},
						Replace[OrderOfOperations]->{FixedReagentAddition,Incubation},
						Autoclave->False
					|>,
					<|
						Object->ssModel3,
						Name->"Aspirin (tablet) in water"<>$SessionUUID,
						Replace[Synonyms]->{"Aspirin (tablet) in water"<>$SessionUUID},
						DeveloperObject->True,
						State->Liquid,
						Expires->True,
						(* Model[Sample,"id:8qZ1VWNmdLBD"] - Milli-Q Water ShelfLife is 1 Year *)
						ShelfLife->1 Year,
						UnsealedShelfLife->1 Year,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						MixTime->15 Minute,
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None},
						Preparable->True,
						Replace[Formula]->{
							{5 Unit,Link[tabletSample]}
						},
						FillToVolumeSolvent->Link[Model[Sample,"id:8qZ1VWNmdLBD"]],
						TotalVolume->305 Milliliter,
						FillToVolumeMethod->Ultrasonic,
						Replace[VolumeIncrements]->{
							Quantity[61.,"Milliliters"],
							Quantity[122.,"Milliliters"],
							Quantity[183.,"Milliliters"],
							Quantity[244.,"Milliliters"],
							Quantity[305.,"Milliliters"]
						}
					|>,
					<|
						Object->ssModel4,
						Name->"Test Stock Solution with Volumetric FtV"<>$SessionUUID,
						DeveloperObject->True,
						Replace[Synonyms]->{"Test Stock Solution with Volumetric FtV"<>$SessionUUID},
						Replace[Composition]->{
							{100 VolumePercent,Link[Model[Molecule,"Water"]]},
							{171.116 Millimolar,Link[Model[Molecule,"Sodium Chloride"]]}
						},
						State->Liquid,
						Expires->True,
						ShelfLife->5 Year,
						UnsealedShelfLife->1 Year,
						DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None},
						Preparable->True,
						NumberOfMixes->10,
						MaxNumberOfMixes->25,
						MixType->Invert,
						MixUntilDissolved->True,
						Replace[Formula]->{
							{10 Gram,Link[singleUseSample]}
						},
						FillToVolumeSolvent->Link[Model[Sample,"id:8qZ1VWNmdLBD"]],
						TotalVolume->1Liter,
						PreparationType->Formula,
						Replace[OrderOfOperations]->{FixedReagentAddition,FillToVolume,Incubation},
						Autoclave->False
					|>,
					<|
						Object->ssModel5,
						Name->"Test Stock Solution with Volumetric FtV and Stirring Mix"<>$SessionUUID,
						DeveloperObject->True,
						Replace[Synonyms]->{"Test Stock Solution with Volumetric FtV and Stirring Mix"<>$SessionUUID},
						Replace[Composition]->{
							{100 VolumePercent,Link[Model[Molecule,"Water"]]},
							{171.116 Millimolar,Link[Model[Molecule,"Sodium Chloride"]]}
						},
						State->Liquid,
						Expires->True,
						ShelfLife->5 Year,
						UnsealedShelfLife->1 Year,
						DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None},
						Preparable->True,
						MixTime -> 30 Minute,
						MaxMixTime -> 60 Minute,
						MixRate -> 200 RPM,
						NumberOfMixes -> Null,
						MaxNumberOfMixes -> Null,
						MixType -> Stir,
						MixUntilDissolved->True,
						Replace[Formula]->{
							{10 Gram,Link[singleUseSample]}
						},
						FillToVolumeSolvent->Link[Model[Sample,"id:8qZ1VWNmdLBD"]],
						TotalVolume->1Liter,
						PreparationType->Formula,
						Replace[OrderOfOperations]->{FixedReagentAddition,FillToVolume,Incubation},
						Autoclave->False
					|>,
					<|
						Object->hplcProtocol,
						Name->"Test HPLC protocol with Sample Prep for ExperimentStockSolution unit test "<>$SessionUUID,
						ImageSample->True,
						DeveloperObject->True
					|>,
					<|
						Type -> Object[Protocol, ManualSamplePreparation],
						Name -> "Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID,
						DeveloperObject -> True,
						CreatedBy -> Link[Object[User,"Test user for notebook-less test protocols"]],
						Author -> Link[Object[User,"Test user for notebook-less test protocols"], ProtocolsAuthored],
						Site -> Link[$Site],
						Status -> Processing
					|>,
					<|
						Object->ssModel6,
						Name->"Test Stock Solution with mix rate higher than safe mix rate of container" <> $SessionUUID,
						DeveloperObject->True,
						Replace[Synonyms]->{"Test Stock Solution with mix rate higher than safe mix rate of container" <> $SessionUUID},
						Replace[Composition]->{
							{Quantity[100., IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
							{Quantity[1.76, ("Millimoles")/("Liters")],Link[Model[Molecule, "Potassium Phosphate (Dibasic)"]]},
							{Quantity[8.1, ("Millimoles")/("Liters")], Link[Model[Molecule, "Dibasic Sodium Phosphate"]]},
							{Quantity[2.7, ("Millimoles")/("Liters")], Link[Model[Molecule, "Potassium Chloride"]]},
							{Quantity[0.137, ("Moles")/("Liters")], Link[Model[Molecule, "Sodium Chloride"]]}
						},
						State->Liquid,
						Expires->True,
						ShelfLife->5 Year,
						UnsealedShelfLife->1 Year,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						MSDSRequired->False,
						BiosafetyLevel->"BSL-1",
						Replace[IncompatibleMaterials]->{None},
						Preparable->True,
						MixTime->15 Minute,
						Replace[Formula]->{
							{Quantity[8.83485, "Milliliters"], Link[Model[Sample, StockSolution, "10x PBS"]]},
							{Quantity[79.5136, "Milliliters"], Link[Model[Sample, "Milli-Q water"]]}
						},
						Autoclave->False,
						MixRate -> 750 RPM,
						MixType -> Stir,
						TotalVolume -> Quantity[0.0883485, "Liters"]
					|>
				}];
				{
					resource1,
					resource2,
					resource3,
					resource4,
					resource5,
					resource6,
					resource7,
					resource8,
					resource9,
					resource10
				}=CreateID[{
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample],
					Object[Resource,Sample]
				}];
				Upload[{
					<|
						Object->resource1,
						DeveloperObject->True,
						Name->"Resource 1 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource2,
						DeveloperObject->True,
						Name->"Resource 2 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource3,
						DeveloperObject->True,
						Name->"Resource 3 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource4,
						DeveloperObject->True,
						Name->"Resource 4 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource5,
						DeveloperObject->True,
						Name->"Resource 5 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource6,
						DeveloperObject->True,
						Name->"Resource 6 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource7,
						DeveloperObject->True,
						Name->"Resource 7 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource8,
						DeveloperObject->True,
						Name->"Resource 8 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource9,
						DeveloperObject->True,
						Name->"Resource 9 Prepped by ExpSS Call"<>$SessionUUID
					|>,
					<|
						Object->resource10,
						DeveloperObject->True,
						Name->"Resource 10 Prepped by ExpSS Call"<>$SessionUUID
					|>
				}]
			]
			]
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container, Bench, "Test bench for ExperimentStockSolution tests" <> $SessionUUID],
						Model[Sample,"Test Fixed Aliquot Solid Model for StockSolution Testing"<>$SessionUUID],
						Model[Sample,"Test SingleUse Aliquot Model for StockSolution Testing"<>$SessionUUID],
						Model[Sample,"Aspirin (tablet)"<>$SessionUUID],
						Model[Item,Filter,"Test non-sterile filter model for ExperimentStockSolution unit test"<>$SessionUUID],
						Object[Product,"Test Fixed Aliquot Solid Product for StockSolution Testing"<>$SessionUUID],
						Object[Product,"Test SingleUse Aliquot Product for StockSolution Testing"<>$SessionUUID],
						Object[Product,"Aspirin (tablet) Product"<>$SessionUUID],
						Object[Product,"Test non-sterile filter product for ExperimentStockSolution unit test"<>$SessionUUID],
						Model[Sample,StockSolution,"Test Stock Solution with Fixed Aliquot Component"<>$SessionUUID],
						Model[Sample,StockSolution,"Test Stock Solution with SingleUse Component"<>$SessionUUID],
						Model[Sample,StockSolution,"Aspirin (tablet) in water"<>$SessionUUID],
						Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV"<>$SessionUUID],
						Model[Sample,StockSolution,"Test Stock Solution with Volumetric FtV and Stirring Mix"<>$SessionUUID],
						Object[Resource,Sample,"Resource 1 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 2 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 3 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 4 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 5 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 6 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 7 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 8 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 9 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Resource,Sample,"Resource 10 Prepped by ExpSS Call"<>$SessionUUID],
						Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentStockSolution unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test container for sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],
						Object[Sample,"Test sample for ExperimentStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],
						Object[Protocol,ManualSamplePreparation,"Test Parent Protocol for ExperimentStockSolution unit test "<>$SessionUUID],
						Model[Sample, StockSolution, "Test Stock Solution with mix rate higher than safe mix rate of container" <> $SessionUUID]
					}],
					ObjectP[]
				]
			];

			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::ExpiredSamples];
		]
	}
];


(* ::Subsubsection:: *)
(*ExperimentStockSolutionOptions*)


DefineTests[
	ExperimentStockSolutionOptions,
	{
		Example[{Basic,"Return options for preparation of a stock solution:"},
			ExperimentStockSolutionOptions[Model[Sample,StockSolution,"1M NaCl (example)"]],
			_Grid
		],
		Example[{Basic,"Return options when preparing multiple stock solutions in the same protocol:"},
			ExperimentStockSolutionOptions[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]}],
			_Grid,
			TimeConstraint -> 600
		],
		Example[{Basic,"Return options for preparing a solution by initially combining components, then filling with solvent to a specified total volume:"},
			ExperimentStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			_Grid
		],
		Example[{Additional,"Return options for preparing a stock solution that is mixed and incubated for 20 minutes, pH-titrated, and then filtered through a 0.22um filter to remove particular matter:"},
			ExperimentStockSolutionOptions[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->30 Minute,
				IncubationTime->30Minute,
				pH->6,
				Filter->True,
				FilterSize->0.22 Micron,
				Name->"Full Prep of 1M NaCl (example for Options function) "<>$SessionUUID
			],
			_Grid,
			TimeConstraint -> 600
		],
		Example[{Additional,"Return options when preparing a stock solution by specifying a direct combination of components (rather than filling to a particular volume with solvent):"},
			ExperimentStockSolutionOptions[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			_Grid
		],
		Example[{Additional,"Return options for preparation of a stock solution with a tablet as a component by specifying a whole number count of tablets to include in the mixture:"},
			ExperimentStockSolutionOptions[
				{
					{5,Model[Sample,"Aspirin (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				250 Milliliter
			],
			_Grid
		],
		Example[{Additional,"Options for preparation of Matrix and Media solutions may also be returned from this function:"},
			ExperimentStockSolutionOptions[{Model[Sample,Media,"Salt Media (example)"],Model[Sample,Matrix,"Salt Matrix (example)"]}],
			_Grid,
			TimeConstraint -> 600
		],
		Example[{Additional,"Preparatory information from the stock solution model may be overridden by specifying options to ExperimentStockSolution:"},
			{
				Download[Model[Sample,StockSolution,"1M NaCl (example)"],{MixTime}],
				Lookup[
					ExperimentStockSolutionOptions[
						Model[Sample,StockSolution,"1M NaCl (example)"],
						MixTime->15 Minute,
						OutputFormat->List
					],
					{MixType,MixTime}
				]
			},
			{
				{RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]]},
				{Stir,RangeP[Quantity[15, "Minutes"], Quantity[15, "Minutes"]]}
			}
		],
		Example[{Additional,"If options specified as lists do not have the same lengths as the stock solution model inputs, no resolved options are returned:"},
			ExperimentStockSolutionOptions[
				{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
				Volume->{500 Milliliter,675 Milliliter,900 Milliliter}
			],
			$Failed,
			Messages:>Error::InputLengthMismatch
		],
		Example[{Additional,"If options do not match their patterns, no resolved options are returned:"},
			ExperimentStockSolutionOptions[Model[Sample,StockSolution,"1M NaCl (example)"],pH->10 Milliliter],
			$Failed,
			Messages:>Error::Pattern
		],
		Test["Return resolved options despite: Formula components must be unique:",
			ExperimentStockSolutionOptions[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::DuplicatedComponents,Error::InvalidInput}
		],
		Test["Return resolved options despite: Formula components cannot be deprecated:",
			ExperimentStockSolutionOptions[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::DeprecatedComponents,Error::InvalidInput}
		],
		Test["Return resolved options despite: The solvent must be a liquid if explicitly provided:",
			ExperimentStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::SolventNotLiquid,Error::InvalidInput}
		],
		Test["Return resolved options despite: Only solids and liquids are supported as formula components:",
			ExperimentStockSolutionOptions[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::ComponentStateInvalid,Error::InvalidInput}
		],
		Test["Return resolved options despite: Specify liquid components transferred by mass:",
			ExperimentStockSolutionOptions[
				{
					{100 Milliliter,Model[Sample,"Sodium Chloride"]},
					{80 Gram,Model[Sample,"Milli-Q water"]}
				},
				OutputFormat->List
			],
			{Rule[_Symbol,Except[ListableP[Automatic]]]..}
		],
		Test["Return resolved options despite: Tablet components must be specified in amounts that are tablet counts, not masses:",
			ExperimentStockSolutionOptions[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::ComponentRequiresTabletCount,Error::InvalidInput}
		],
		Test["Return resolved options despite: The sum of the volumes of any formula components should not exceed the requested total volume of the solution:",
			ExperimentStockSolutionOptions[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::FormulaVolumeTooLarge,Error::InvalidOption,Error::InvalidInput}
		],
		Example[{Options,OutputFormat,"Return a list of options instead of a table:"},
			ExperimentStockSolutionOptions[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->20 Minute,
				IncubationTemperature->40Celsius,
				pH->6,
				Filter->True,
				FilterSize->0.22 Micron,
				OutputFormat->List
			],
			{Rule[_Symbol,Except[ListableP[Automatic]]]..},
			TimeConstraint -> 600
		],
		Example[{Options,Volume,"Return resolved Volumes when both specifying a volume and allowing the default formula components to be combined:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Volume->{600 Milliliter,Automatic},
					OutputFormat->List
				],
				Volume
			],
			{600 Milliliter,1 Liter},
			EquivalenceFunction->Equal,
			TimeConstraint -> 600
		],
		Test["Return resolved options despite: certain preparation steps require a minimum volume; requesting a volume below these thresholds produces an error:",
			ExperimentStockSolutionOptions[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->5 Milliliter,pH->6.5,OutputFormat->List],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache | Type]]],
			Messages:>{Error::BelowpHMinimum,Error::InvalidOption}
		],
		Example[{Options,Volume,"The Volume option is unused if it differs from the provided total volume of solvent for a fill-to-volume style solution:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2.78 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Volume->2 Liter,
					OutputFormat->List
				],
				Volume
			],
			1 Liter,
			Messages:>{Warning::VolumeOptionUnused}
		],
		Example[{Options,ContainerOut,"Return resolved ContainerOut options when requesting both a specific container and an Automatic value:"},
			Download[
				Lookup[
					ExperimentStockSolutionOptions[
						{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
						Volume->{2 Liter,1 Liter},
						ContainerOut->{Automatic,Model[Container,Vessel,"Amber Glass Bottle 4 L"]},
						OutputFormat->List
					],
					ContainerOut
				],
				Name
			],
			{"2L Glass Bottle", "Amber Glass Bottle 4 L"},
			TimeConstraint -> 600
		],
		Test["Return options despite: The ContainerOut should not be deprecated:",
			ExperimentStockSolutionOptions[
				{
					{50 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				40 Milliliter,
				ContainerOut->Model[Container,Vessel,"Deprecated Legacy 46mL Tube"],
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::DeprecatedContainerOut,Error::InvalidOption}
		],
		Test["Return options despite: The ContainerOut should be able to hold the requested volume of stock solution:",
			ExperimentStockSolutionOptions[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->2 Liter,ContainerOut->Model[Container,Vessel,"1L Glass Bottle"],OutputFormat->List],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache | Type]]],
			Messages:>{Error::ContainerOutTooSmall,Error::InvalidOption}
		],
		Example[{Options,Mix,"Indicate if the stock solution should be mixed following component combination and filling to volume with solvent; default mixing parameters are drawn from the model:"},
			Lookup[
				ExperimentStockSolutionOptions[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Mix->True,
					OutputFormat->List
				],
				{MixType,MixTime,MixRate}
			],
			{Stir,RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]],RPMP}
		],
		Example[{Options,Mix,"Mixing parameters will default to Null if Mix is explicitly set to False; this set of options would create a protocol for preparing a stock solution without any mixing:"},
			Lookup[
				ExperimentStockSolutionOptions[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Mix->False,
					OutputFormat->List
				],
				{MixType,MixTime,MaxMixTime,MixRate,Mixer,NumberOfMixes,MaxNumberOfMixes,MixPipettingVolume}
			],
			{Repeated[Null,{8}]}
		],
		Example[{Options,Mix,"Return options when requesting that one solution be mixed and one not be:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Mix->{True,False},
					OutputFormat->List
				],
				{MixType,MixTime,MixRate}
			],
			{
				{Stir,Null},
				{RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]],Null},
				{UnitsP[RPM],Null}
			}
		],
		Example[{Options,Mix,"Setting Mix to False but specifying mixing parameters results in an error message; the returned options cannot be used to generate a protocol in this state:"},
			ExperimentStockSolutionOptions[
				{
					{ 500 Milliliter,Model[Sample, "Milli-Q water"]},
					{ 500 Milliliter,Model[Sample, "Methanol"]}
				},
				Mix->False,
				MixTime->5 Minute
			],
			_Grid,
			Messages:>{Error::MixOptionConflict,Error::InvalidOption}
		],
		Example[{Options,Incubate,"Indicate if the stock solution should be incubated following component combination and filling to volume with solvent and mixing; default incubation parameters are drawn from the model:"},
			Lookup[
				ExperimentStockSolutionOptions[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Incubate->True,
					OutputFormat->List
				],
				{IncubationTemperature,IncubationTime}
			],
			{
				RangeP[Quantity[45, "DegreesCelsius"],Quantity[45, "DegreesCelsius"]],
				RangeP[Quantity[20, "Minutes"], Quantity[20, "Minutes"]]
			}
		],
		Example[{Options,Incubate,"Incubation parameters will default to Null if Incubate is explicitly set to False; this set of options would create a protocol for preparing a stock solution without any incubation:"},
			Lookup[
				ExperimentStockSolutionOptions[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Incubate->False,
					OutputFormat->List
				],
				{Incubator,IncubationTemperature,IncubationTime,AnnealingTime}
			],
			{Repeated[Null,{4}]}
		],
		Example[{Options,Incubate,"Return options when requesting that one solution be incubated and one not be:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Incubate->{True,False},
					OutputFormat->List
				],
				{Incubator,IncubationTemperature,IncubationTime,AnnealingTime}
			],
			{
				{Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"],Null},
				(* using RangeP here because we don't have an EqualP *)
				{RangeP[Quantity[45., "DegreesCelsius"], Quantity[45., "DegreesCelsius"]], Null},
				{RangeP[Quantity[20., "Minutes"], Quantity[20., "Minutes"]], Null},
				{RangeP[Quantity[0., "Minutes"], Quantity[0., "Minutes"]], Null}
			},
			TimeConstraint -> 600
		],
		Example[{Options,Incubate,"Setting Incubate to False but specifying incubation parameters results in an error message; the returned options cannot be used to generate a protocol in this state:"},
			ExperimentStockSolutionOptions[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Incubate->False,
				IncubationTemperature -> 45*Celsius
			],
			_Grid,
			Messages:>{Error::IncubateOptionConflict,Error::InvalidOption}
		],

		Test["Return resolved options despite a conflict between the incubator and incubation temperature:",
			ExperimentStockSolutionOptions[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubator -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				IncubationTemperature -> 155 Celsius,
				Mix -> False,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::InvalidOption, Error::MixIncompatibleInstrument, Error::MixMaxTemperature}
		],

		(* pH Titration *)
		Example[{Options,pH,"Return resolved pH titration options when specifying the pH to which this solution should be adjusted following component combination and mixing:"},
			Lookup[
				ExperimentStockSolutionOptions[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					pH->7,
					OutputFormat->List
				],
				{pH,MinpH,MaxpH,pHingAcid,pHingBase}
			],
			{7,6.9,7.1,Model[Sample,StockSolution,"2 M HCl"],Model[Sample,StockSolution,"1.85 M NaOH"]}
		],
		Example[{Options,pH,"Return resolved options when requesting that one solution be pH-titrated and one not be:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					pH->{8,Null},
					OutputFormat->List
				],
				{pH,MinpH,MaxpH,pHingAcid,pHingBase}
			],
			{
				{8,Null},
				{7.9,Null},
				{8.1,Null},
				{Model[Sample,StockSolution,"2 M HCl"],Null},
				{Model[Sample,StockSolution,"1.85 M NaOH"],Null}
			},
			TimeConstraint -> 600
		],

		(* Filtration *)
		Example[{Options,Filter,"Return resolved filtration options when indicating if the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Lookup[
				ExperimentStockSolutionOptions[
					Model[Sample,StockSolution,"1M NaCl (example)"],
					Filter->True,
					OutputFormat->List
				],
				{FilterType,FilterMaterial,FilterSize}
			],
			{FiltrationTypeP,FilterMembraneMaterialP,GreaterP[0 Micron]},
			TimeConstraint -> 600
		],
		Example[{Options,Filter,"Filtration parameters default to Null if no filtration is requested:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Filter->False,
					OutputFormat->List
				],
				{FilterType,FilterMaterial,FilterSize}
			],
			{Null,Null,Null}
		],
		Example[{Options,Filter,"Return resolved options when indicating that one solution should be filtered and another should not:"},
			Lookup[
				ExperimentStockSolutionOptions[
					{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
					Filter->{True,False},
					OutputFormat->List
				],
				{FilterType,FilterMaterial,FilterSize}
			],
			{
				{PeristalticPump,Null},
				{FilterMembraneMaterialP,Null},
				{FilterSizeP,Null}
			},
			TimeConstraint -> 500
		],

		Test["Return resolved options despite: If Expires is set to False, ShelfLife/UnsealedShelfLife cannot also be set:",
			ExperimentStockSolutionOptions[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->False,
				ShelfLife->1 Year,
				OutputFormat->List
			],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache]]],
			Messages:>{Error::ExpirationShelfLifeConflict,Error::InvalidOption}
		],
		Example[{Options,Template,"Return resolved options when providing a previously-run protocol from which to draw option defaults:"},
			ExperimentStockSolutionOptions[Model[Sample,StockSolution,"1M NaCl, 0.45um filtered (example)"],Template->Object[Protocol,StockSolution,"Template Preparation of 1M NaCl (example)"]],
			_Grid
		],

		Test["Return resolved options despite: Deprecated stock solution models cannot be prepared:",
			ExperimentStockSolutionOptions[Model[Sample,StockSolution,"Dilute Salt Water, deprecated (example)"],OutputFormat->List],
			KeyValuePattern[Map[Rule[#1, Except[Automatic]] &, DeleteCases[ ToExpression[Options[ExperimentStockSolutionOptions][[All, 1]]], Simulation | OutputFormat | Site | Cache | Type]]],
			Messages:>{
				Error::DeprecatedStockSolutions,
				Error::InvalidInput
			}
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	},
	SetUp:>(
		$CreatedObjects={}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
	Stubs :> {
		Search[Model[StorageCondition]]=Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentStockSolutionQ*)


DefineTests[
	ValidExperimentStockSolutionQ,
	{
		Example[{Basic,"Validate an experiment for preparation of a stock solution:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl (example)"]],
			True
		],
		Example[{Basic,"Validate preparation of multiple stock solutions in the same protocol:"},
			ValidExperimentStockSolutionQ[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]}],
			True,
			TimeConstraint -> 600
		],
		Example[{Basic,"Validate preparation of a solution by initially combining components, then filling with solvent to a specified total volume:"},
			ValidExperimentStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			True
		],
		Example[{Basic,"Validate preparation of a solution by unit operations:"},
			ValidExperimentStockSolutionQ[
				{
					LabelContainer[Label -> "test tube", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "test tube",Amount -> 100 Microliter],
					Transfer[Source -> Model[Sample, "Methanol"], Destination -> "test tube",Amount -> 100 Microliter]
				}
			],
			True,
			TimeConstraint -> 600
		],
		Example[{Additional,"Validate preparation of a stock solution that is mixed and heated for 20 minutes, pH-titrated, and then filtered through a 0.22um filter to remove particular matter:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->20 Minute,
				IncubationTime->20Minute,
				pH->6,
				Filter->True,
				FilterSize->0.22 Micron,
				Name->"Full Prep of 1M NaCl (ValidExperimentStockSolutionQ example) "<>$SessionUUID
			],
			True,
			TimeConstraint -> 600
		],
		Example[{Additional,"Validate preparation of a stock solution prepared by specifying a direct combination of components (rather than filling to a particular volume with solvent):"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			True
		],
		Example[{Additional,"Validate preparation of a stock solution with a tablet as a component by specifying a whole number count of tablets to include in the mixture:"},
			ValidExperimentStockSolutionQ[
				{
					{5,Model[Sample,"Aspirin (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				250 Milliliter
			],
			True
		],
		Example[{Additional,"Validate preparation of Matrix and Media solutions:"},
			ValidExperimentStockSolutionQ[{Model[Sample,Media,"Salt Media (example)"],Model[Sample,Matrix,"Salt Matrix (example)"]}],
			True,
			TimeConstraint -> 600
		],
		Example[{Additional,"Options that can be specified as lists must have the same lengths as the stock solution model inputs:"},
			ValidExperimentStockSolutionQ[
				{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
				Volume->{500 Milliliter,675 Milliliter,900 Milliliter}
			],
			False
		],
		Example[{Additional,"Options must match their patterns:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl (example)"],pH->10 Milliliter],
			False
		],
		Example[{Additional,"Deprecated stock solution models cannot be prepared:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"Dilute Salt Water, deprecated (example)"]],
			False
		],
		Example[{Additional,"Formula Issues","Formula components must be unique:"},
			ValidExperimentStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				}
			],
			False
		],
		Example[{Additional,"Formula Issues","Formula components cannot be deprecated:"},
			ValidExperimentStockSolutionQ[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter
			],
			False
		],
		Example[{Additional,"Formula Issues","If no solvent is explicitly provided, that is acceptable and the mixture will just be a solid:"},
			ValidExperimentStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				}
			],
			True
		],
		Example[{Additional,"Formula Issues","The solvent must be a liquid if explicitly provided:"},
			ValidExperimentStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter
			],
			False
		],
		Example[{Additional,"Formula Issues","Only solids and liquids are supported as formula components:"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			False
		],
		Example[{Additional,"Formula Issues","Components must be specified with amounts that are consistent with the components' states:"},
			ValidExperimentStockSolutionQ[
				{
					{100 Milliliter,Model[Sample,"Sodium Chloride"]},
					{80 Gram,Model[Sample,"Milli-Q water"]}
				}
			],
			True
		],
		Example[{Additional,"Formula Issues","Tablet components must be specified in amounts that are tablet counts, not masses:"},
			ValidExperimentStockSolutionQ[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			False
		],
		Example[{Additional,"Formula Issues","The sum of the volumes of any formula components should not exceed the requested total volume of the solution:"},
			ValidExperimentStockSolutionQ[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter
			],
			False
		],
		Example[{Options,Verbose,"Control the printing of tests performed during validation of a stock solution preparation:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->20 Minute,
				Incubate->True,
				pH->6,
				Filter->True,
				FilterSize->0.22 Micron,
				Verbose->True
			],
			True,
			TimeConstraint -> 500
		],
		Example[{Options,OutputFormat,"Control the output format of the validation function:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixTime->20 Minute,
				Incubate->True,
				pH->6,
				Filter->True,
				FilterSize->0.22 Micron,
				OutputFormat->Boolean
			],
			True,
			TimeConstraint -> 500
		],
		Example[{Options,Volume,"Validate a preparation of a stock solution requesting a different volume than the default preparation volume of the model:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->1.5 Liter],
			True
		],
		Example[{Options,Volume,"Certain preparation steps require a minimum volume; requesting a volume below these thresholds is invalid:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->5 Milliliter,pH->6.5],
			False
		],
		Test["Don't throw messages when: The Volume option is unused if it differs from the provided total volume of solvent for a fill-to-volume style solution:",
			ValidExperimentStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Volume->2 Liter
			],
			True,
			TimeConstraint -> 600
		],
		Example[{Options,ContainerOut,"Validate a stock solution preparation when requesting different final containers for different solutions being prepared:"},
			ValidExperimentStockSolutionQ[
				{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]},
				Volume->{2 Liter,1 Liter},
				ContainerOut->{Automatic,Model[Container,Vessel,"Amber Glass Bottle 4 L"]}
			],
			True,
			TimeConstraint -> 500
		],
		Example[{Options,ContainerOut,"The ContainerOut should not be deprecated:"},
			ValidExperimentStockSolutionQ[
				{
					{50 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				46 Milliliter,
				ContainerOut->Model[Container,Vessel,"Deprecated Legacy 46mL Tube"]
			],
			False
		],
		Example[{Options,ContainerOut,"The ContainerOut should be able to hold the requested volume of stock solution:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl (example)"],Volume->2 Liter,ContainerOut->Model[Container,Vessel,"1L Glass Bottle"]],
			False
		],
		Example[{Options,Mix,"Validate preparation of a stock solution that is mixed following component combination and filling to volume with solvent:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Mix->True
			],
			True
		],
		Example[{Options,Mix,"The mixing options should be specified as single values if the formula input is used:"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Mix->{True,False},
				MixType->Roll,
				MixTime->{1 Hour,10 Minute}
			],
			False
		],
		Example[{Options,Mix,"Setting Mix to False but specifying mixing parameters is invalid:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Mix->False,
				MixTime->5 Minute
			],
			False
		],
		Example[{Options,MixTime,"Not all mixing types are compatible with a MixTime; here, the NumberOfMixes should have been used to specify the desired amount of mixing by inversion:"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Invert,
				MixTime->15 Minute
			],
			False
		],
		Example[{Options,Incubate,"Validate preparation of a stock solution that is mixed following component combination and filling to volume with solvent:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Incubate->True
			],
			True
		],
		Example[{Options,Incubate,"The mixing options should be specified as single values if the formula input is used:"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubate->True,
				IncubationTime->{1 Hour,10 Minute}
			],
			False
		],
		Example[{Options,Incubate,"Setting Incubate to False but specifying incubation parameters is invalid:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Incubate->False,
				IncubationTemperature->40*Celsius
			],
			False
		],
		Example[{Options,Incubator,"Not all incubators are compatible with all temperatures:"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubator -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				IncubationTemperature -> 155 Celsius
			],
			False
		],
		Test["Don't return messages if: An upper bound on mixing time should only be provided if mixing until dissolution with MixTime specified:",
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MixUntilDissolved->False,
				MixTime->15 Minute,
				MaxMixTime->30 Minute
			],
			False
		],
		Test["Don't return messages if: Not all mixing types are compatible with a NumberOfMixes, such as the Vortex mix type:",
			ValidExperimentStockSolutionQ[
				{
					{10 Milliliter,Model[Sample,"Milli-Q water"]},
					{10 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Vortex,
				NumberOfMixes->15
			],
			False
		],
		Test["Don't return messages if: An upper bound on number of mixes while attempting to dissolve the solution should only be provided if mixing until dissolution with a NumberOfMixes specified:",
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Invert,
				MixUntilDissolved->False,
				NumberOfMixes->10,
				MaxNumberOfMixes->30
			],
			False
		],
		Test["Don't return messages if: A mix pipetting volume should only be provided for the Pipette mix type:",
			ValidExperimentStockSolutionQ[
				{
					{10 Milliliter,Model[Sample,"Milli-Q water"]},
					{10 Milliliter,Model[Sample,"Methanol"]}
				},
				MixType->Vortex,
				MixPipettingVolume->5 Milliliter
			],
			False
		],

		(* pH Titration *)
		Example[{Options,pH,"Validate a stock solution preparation when specifying the pH to which this solution should be adjusted following component combination and mixing:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				pH->7
			],
			True,
			TimeConstraint -> 600
		],
		Example[{Options,pH,"If pH titration is requested, the preparation volume of the provided stock solution formula must exceed the minimum threshold to ensure the smallest pH probe can fit in any container in which this formula can be combined:"},
			ValidExperimentStockSolutionQ[
				{
					{4 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter,
				pH->7
			],
			False
		],
		Example[{Options,MinpH,"MinpH cannot be specified if AdjustpH -> False:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				MinpH->6.5,
				AdjustpH -> False
			],
			False
		],
		Example[{Options,MaxpH,"MaxpH cannot be specified if AdjustpH -> False:"},
			ValidExperimentStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MaxpH->7.5,
				AdjustpH -> False
			],
			False
		],

		(* Filtration *)
		Example[{Options,Filter,"Validate a stock solution preparation if the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				Filter->True
			],
			True,
			TimeConstraint -> 500
		],
		Example[{Options,Filter,"The filter options should be specified as single values if the formula input is used:"},
			ValidExperimentStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Filter->{True},
				FilterMaterial->{Cellulose,Cotton}
			],
			False
		],
		Example[{Options,Filter,"The total preparation volume of the stock solution must exceed a minimum threshold for filtration to ensure that a method with low enough dead volume is available:"},
			ValidExperimentStockSolutionQ[
				{
					{2 Milligram,Model[Sample,"Sodium Chloride"]},
					{1.5 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Filter->True
			],
			False
		],
		Test["Don't throw messages if: A provided filtration instrument may be incompatible with the requested type of filtration:",
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl, 0.45um filtered (example)"],
				Filter->True,
				FilterType->Vacuum,
				FilterInstrument->Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]
			],
			False
		],
		Test["Don't throw messages if: Don't specify a syringe with which to push the solution through a filter if the FilterType is not PeristalticPump or Syringe:",
			ValidExperimentStockSolutionQ[
				{
					{2 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				25 Milliliter,
				Filter->True,
				FilterType->Centrifuge,
				FilterSyringe->Model[Container,Syringe,"50mL All-Plastic Disposable Luer-Slip Syringe"]
			],
			False
		],

		Example[{Options,StockSolutionName,"Validate naming of a new stock solution model when specifying a solution to prepare via the formula overload:"},
			ValidExperimentStockSolutionQ[
				{
					{17 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				StockSolutionName->"Special Salt in Water Mixture "<>$SessionUUID
			],
			True
		],
		Test["Don't throw messages if: This option should only be used with formula input:",
			ValidExperimentStockSolutionQ[
				Model[Sample,StockSolution,"1M NaCl (example)"],
				StockSolutionName->"Special Salt in Water Mixture "<>$SessionUUID
			],
			True
		],
		Example[{Options,StockSolutionName,"If a stock solution Name is already in use in Constellation, a new stock solution cannot also get that Name:"},
			ValidExperimentStockSolutionQ[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				StockSolutionName->"Existing Solution of 10% v/v Methanol in Water for ValidExperimentStockSolutionQ "<>$SessionUUID
			],
			False,
			SetUp:>(
				UploadStockSolution[{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				}, Name -> "Existing Solution of 10% v/v Methanol in Water for ValidExperimentStockSolutionQ "<>$SessionUUID];
				Upload[<|Object -> Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol in Water for ValidExperimentStockSolutionQ "<>$SessionUUID], DeveloperObject -> True|>]
			),
			TearDown :> (
				EraseObject[Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol in Water for ValidExperimentStockSolutionQ "<>$SessionUUID], Force -> True]
			)
		],
		Example[{Options,Expires,"If Expires is set to False, ShelfLife/UnsealedShelfLife cannot also be set:"},
			ValidExperimentStockSolutionQ[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->False,
				ShelfLife->1 Year
			],
			False
		],
		Test["Don't throw messages if: A warning is provided if the provided UnsealedShelfLife is longer than the provided ShelfLife:",
			ValidExperimentStockSolutionQ[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				ShelfLife->1 Year,
				UnsealedShelfLife->2 Year
			],
			True,
			TimeConstraint -> 600
		],
		Example[{Options,Acid,"Acid and Base storage cannot be simultaneously required for a stock solution:"},
			ValidExperimentStockSolutionQ[
				{
					{5 Milliliter,Model[Sample,"Milli-Q water"]},
					{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
				},
				Acid->True,
				Base->True
			],
			False
		],
		Example[{Options,Template,"Validate a stock solution preparation when providing a previously-run protocol from which to draw option defaults:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl, 0.45um filtered (example)"],Template->Object[Protocol,StockSolution,"Template Preparation of 1M NaCl (example)"]],
			True
		],
		Example[{Options,Name,"The protocol's Name must be unique:"},
			ValidExperimentStockSolutionQ[Model[Sample,StockSolution,"1M NaCl (example)"],Name->"Template Preparation of 1M NaCl (example)"],
			False
		],
		Example[{Messages, "StockSolutionTooManySamples", "If more than 10 samples are specified and we are not in engine, then throw an error:"},
			ValidExperimentStockSolutionQ[ConstantArray[Model[Sample, StockSolution, "1M NaCl (example)"], 15]],
			False,
			TimeConstraint -> 300
		]
	},
	(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
	Stubs :> {
		Search[Model[StorageCondition]]=Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
	},
	SymbolSetUp :> {
		(* turning this one off because a very weird error can be thrown during resource picking steps *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
		Off[General::stop]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
		On[General::stop]
	}
];


(* ::Subsubsection:: *)
(*ExperimentStockSolutionPreview*)


DefineTests[
	ExperimentStockSolutionPreview,
	{
		Example[{Basic,"Returns Null for a preparation of a stock solution model:"},
			ExperimentStockSolutionPreview[Model[Sample,StockSolution,"1M NaCl (example)"]],
			Null,
			TimeConstraint -> 600
		],
		Example[{Basic,"Returns Null if preparing multiple stock solutions in the same protocol:"},
			ExperimentStockSolutionPreview[{Model[Sample,StockSolution,"1M NaCl (example)"],Model[Sample,StockSolution,"50% v/v Methanol/water (example)"]}],
			Null,
			TimeConstraint -> 600
		],
		Example[{Basic,"Returns Null when preparing a solution by initially combining components, then filling with solvent to a specified total volume:"},
			ExperimentStockSolutionPreview[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			Null,
			TimeConstraint -> 600
		]
	},
	(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
	Stubs :> {
		Search[Model[StorageCondition]]=Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
	},
	SymbolSetUp :> {
		(* turning this one off because a very weird error can be thrown during resource picking steps *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
		Off[General::stop]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* turning this one off because this will help with troubleshooting a super nasty bug in Incubate that makes Message[Part::partd,Null[[1]]] messages but cuts them off instead of letting me see every one *)
		On[General::stop]
	}
];
